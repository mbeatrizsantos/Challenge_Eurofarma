const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { VertexAI } = require("@google-cloud/vertexai");

const vertexAI = new VertexAI({
  project: "eurofarma-e0432",
  location: "us-central1",
});

const generativeModel = vertexAI.getGenerativeModel({
  model: "gemini-2.0-flash",
});

// 1. ADICIONAMOS UMA INSTRUÇÃO DE SISTEMA (A "PERSONALIDADE" DA IA)
const SYSTEM_INSTRUCTION = `
  Você é um assistente de inovação chamado "Catalisador". 
  Sua principal regra é ser  objetivo e conciso. 
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

  // 2. SIMPLIFICAMOS O PROMPT INICIAL
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
    // 3. INJETAMOS A "PERSONALIDADE" NO INÍCIO DO HISTÓRICO DA CONVERSA
    const chat = generativeModel.startChat({ 
      history: [
        // Adiciona a instrução de sistema no começo de toda conversa
        { role: 'user', parts: [{ text: SYSTEM_INSTRUCTION }] },
        { role: 'model', parts: [{ text: "Entendido. Serei breve e objetivo." }] },
        // Continua com o histórico real da conversa
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