const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { VertexAI } = require("@google-cloud/vertexai");
const admin = require("firebase-admin");

// Inicializa o Firebase Admin SDK (necessário para criar usuários)
admin.initializeApp();

// --- INÍCIO DA CONFIGURAÇÃO DA FUNÇÃO DE IA (developIdeaWithAI) ---

const vertexAI = new VertexAI({
  project: "eurofarma-e0432",
  location: "us-central1",
});

const generativeModel = vertexAI.getGenerativeModel({
  model: "gemini-1.0-pro", // Usando um modelo estável
});

const SYSTEM_INSTRUCTION = `
  Você é um assistente de inovação chamado "Catalisador". 
  Sua principal regra é ser objetivo e conciso. 
  Responda em no máximo 4 ou 5 frases curtas, a menos que o usuário peça explicitamente para detalhar mais.
`;

exports.developIdeaWithAI = onCall(async (request) => {
  const newUserMessage = request.data.text;
  const history = request.data.history || [];

  if (!newUserMessage) {
    throw new HttpsError("invalid-argument", "A mensagem de texto é obrigatória.");
  }

  let messageToSend = newUserMessage;
  let finalHistory = history;

  if (history.length <= 2) {
    messageToSend = `
      **PROMPT INICIAL (Siga estas regras para a primeira resposta):**
      Analise a seguinte ideia de um colaborador.
      Forneça uma resposta estruturada nos seguintes tópicos:
      1.  **Pontos Fortes:** Liste 2 pontos fortes.
      2.  **Pontos a Refletir:** Liste 2 possíveis desafios.
      3.  **Próximos Passos:** Sugira 1 ação prática e imediata.
      Use emojis, mas seja breve.

      **Ideia do usuário para analisar:** "${newUserMessage}"
    `;
    finalHistory = [];
  }

  try {
    const chat = generativeModel.startChat({ 
      history: [
        { role: 'user', parts: [{ text: SYSTEM_INSTRUCTION }] },
        { role: 'model', parts: [{ text: "Entendido. Serei breve e objetivo." }] },
        ...finalHistory 
      ] 
    });
    
    const result = await chat.sendMessage(messageToSend);
    const response = result.response;
    const responseText = response.candidates[0].content.parts[0].text;

    return { suggestion: responseText };
  } catch (error) {
    console.error("Erro ao chamar a API do Gemini:", error);
    throw new HttpsError(
      "internal",
      "Ocorreu um erro ao processar a ideia com a IA. Tente novamente."
    );
  }
});

// --- FIM DA FUNÇÃO DE IA ---


// --- INÍCIO DA FUNÇÃO DE CRIAR USUÁRIO (createNewUser) ---

exports.createNewUser = onCall(async (request) => {
  // 1. Verifica se o usuário que chamou a função está autenticado.
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "Você precisa estar autenticado para executar essa ação."
    );
  }

  // 2. Verifica se o usuário que chamou a função é um administrador.
  const callerUid = request.auth.uid;
  const userRecord = await admin.firestore().collection("users").doc(callerUid).get();
  
  if (!userRecord.exists || userRecord.data().role !== "admin") {
    throw new HttpsError(
      "permission-denied",
      "Você não tem permissão para adicionar novos usuários."
    );
  }

  // 3. Se a verificação passar, pega os dados para criar o novo usuário.
  const { email, password, displayName } = request.data;
  if (!email || !password || !displayName) {
     throw new HttpsError(
      "invalid-argument",
      "É necessário fornecer email, senha e nome para criar um usuário."
    );
  }

  try {
    const newUserRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: displayName,
    });

    // 4. Cria o documento para o novo usuário no Firestore com a role 'user'.
    await admin.firestore().collection("users").doc(newUserRecord.uid).set({
      displayName: displayName,
      email: email,
      role: "user",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { result: `Usuário ${displayName} criado com sucesso.` };

  } catch (error) {
    console.error("Erro ao criar novo usuário:", error);
    // Transforma erros específicos do auth em mensagens mais amigáveis
    if (error.code === 'auth/email-already-exists') {
        throw new HttpsError("already-exists", "Este e-mail já está em uso por outro usuário.");
    }
    throw new HttpsError("internal", error.message);
  }
});

// --- FIM DA FUNÇÃO DE CRIAR USUÁRIO ---