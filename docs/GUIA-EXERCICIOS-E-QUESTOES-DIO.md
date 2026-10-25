# 📚 Caderno de Revisão Comentado — Todas as Aulas e Questionários da DIO

Este guia consolida **100% das aulas práticas e todas as questões** dos três cursos que resolvemos na trilha **Santander Automação com N8N** da DIO, com explicação técnica de cada resposta e como aplicá-la no seu **Bot/Agente Financeiro**.

---

## 📦 Curso 1: Manipulação de Dados e Variáveis no N8N

### 1. Datas, Números e Funções Luxon (`Verificando mais funções`)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **Qual formato exibe apenas o mês de uma data no n8n?** | `2N maiúsculo` *(transcrição de `MM` — dois M maiúsculos)* | No Luxon (biblioteca de datas do n8n), `MM` (dois M maiúsculos) retorna o mês com dois dígitos (`01` a `12`). Já `mm` minúsculo representa minutos! Ex.: `{{ $now.toFormat('MM') }}`. |
| **A função `plus` pode ser usada para adicionar horas ou dias a uma data no n8n.** | `Verdadeiro` | O método `.plus()` soma intervalos de tempo a um objeto `DateTime`. Ex.: `{{ $now.plus({ days: 7, hours: 2 }) }}` calcula o vencimento de um boleto para daqui a 7 dias. |
| **Qual função retorna um número decimal aleatório entre 0 e 1?** | `MatchRandom` *(transcrição de `Math.random()`)* | Função nativa do JavaScript `Math.random()`. Multiplicada e arredondada (`Math.floor(Math.random() * 100000)`), é ótima para gerar protocolos de atendimento ou IDs temporários. |
| **Qual função é utilizada no n8n para somar ou subtrair tempo a uma data atual?** | `As funções plus e minus` | `.plus({ days: X })` avança no tempo (ex.: calcular próx. vencimento) e `.minus({ days: X })` retrocede (ex.: buscar extrato dos últimos 30 dias). |

---

### 2. Conversão de Tipos de Dados (`Convertendo os tipos de dados`)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **Quando a API exige que o dado seja enviado como parâmetro em formato `string` e recebemos em `number`, qual técnica usar?** | `Forçar a conversão usando toString na expressão.` | Ex.: `{{ $json.valor.toString() }}`. Muitas APIs financeiras exigem que IDs ou valores em query/body sejam strings explícitas. |
| **Para que tipo de dado não seria possível aplicar corretamente funções específicas de data, como formatação?** | `string` | Quando uma data vem de um Webhook ou planilha como texto puro (`"2026-10-30"`), ela é apenas uma `string`. Para usar `.plus()`, `.minus()` ou `.toFormat()`, você precisa converter primeiro com `.toDateTime()`. |
| **Sobre conversão de tipos no N8N, é correto afirmar que:** | `Facilita a normalização dos dados sem exigir alteração na origem.` | Você não precisa obrigar o usuário ou o sistema de origem a mudar o formato: o n8n normaliza em trânsito no nó `Edit Fields (Set)` usando `.toNumber()`, `.toString()`, `.toBoolean()` e `.toDateTime()`. |
| **Se uma string aparenta ser uma data, mas não foi convertida no N8N, é possível aplicar funções de data corretamente sobre ela.** | `Falso` | Sem `.toDateTime()`, chamar métodos do Luxon sobre uma string gera erro de função inexistente (`undefined is not a function`). |

---

### 3. Expressões Geradas com IA (`Usando a IA para gerar expressões`)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **Por que é recomendado usar IA para gerar expressões ao invés de criá-las manualmente no n8n?** | `Porque a IA gera expressões mais rápidas e com menor chance de erro.` | Expressões com Regex (ex.: limpar CPF, telefone ou moeda `R$ 1.250,90`) são propensas a erros de sintaxe manual; pedir à IA gera o `.replace()` exato em segundos. |
| **Qual a utilidade de pedir à IA para gerar uma expressão que mantenha apenas números de uma string?** | `Remover espaços, letras e caracteres especiais de telefones.` | Expressão clássica: `{{ $json.telefone.replace(/\D/g, '') }}`. Transforma `"(11) 99876-5432"` em `"11998765432"`, formato exigido por APIs de WhatsApp (Evolution API / Z-API) e bancos. |
| **No contexto apresentado, qual campo seria criado para armazenar o valor da data de vencimento?** | `dataVencimento` | Boas práticas de nomenclatura *camelCase* sem acentos ou espaços no nó `Edit Fields (Set)`. |
| **Ao substituir datas reais em uma expressão gerada pela IA com fins de automação, o campo da data mais recente normalmente representa o quê?** | `A data de vencimento.` | Em fluxos de cobrança, compara-se a data atual (`$now`) com a data futura/mais recente da fatura (`dataVencimento` / `dueDate`) para calcular os dias restantes. |

---

### 4. Agregação e Relatórios por E-mail (`Enviando relatório via e-mail`)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **O que acontece se você não usar o `Aggregate` para juntar os itens antes de usar `join`?** | `O 'join' não conseguirá atuar nos itens distintos, pois não estarão em um único array.` | No n8n, se você tem 10 despesas saindo de um filtro, elas são **10 itens separados** (o nó seguinte rodaria 10 vezes, enviando 10 e-mails!). O nó **`Aggregate`** junta os 10 itens em **1 único item contendo uma lista (array)**, permitindo usar `.join('<br>')` para enviar **1 único e-mail** com o resumo das 10 despesas. |
| **Ao criar o corpo do e-mail com os dados dos usuários, qual benefício existe em montar um template HTML ao invés de texto puro?** | `Possibilita personalização, uso de negrito e quebras de linha para melhor leitura.` | E-mails financeiros precisam destacar valores (`<strong>R$ 150,00</strong>`), vencimentos e organizar listas de forma legível. |
| **No template criado no EditField, por que é importante utilizar a tag `<strong>` ou `<br>` em HTML?** | `Para formatar o texto, destacando campos e criando quebras de linha no corpo do e-mail.` | `<strong>` aplica negrito semântico e `<br>` força a quebra de linha no renderizador HTML do cliente de e-mail. |
| **Ao utilizar a função `join`, o separador `'\n'` sempre é interpretado corretamente em qualquer cliente de e-mail.** | `Falso` | Clientes de e-mail que renderizam HTML **ignoram** `\n` (tratam como espaço em branco). Em corpo HTML, use sempre `.join('<br>')`! |

---

## ⚙️ Curso 2: Automatizando Processos com N8N (Projeto Prático de Cobranças Financeiras)

### 1. Workflows Simples vs. Complexos (`Diferenças entre Workflow simples e complexo`)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **Por que é utilizado um node de `merge` em um workflow complexo?** | `Para unir dados da nota fiscal com os dados do cliente em um único item.` | Em APIs financeiras (como o Asaas), o endpoint `/payments` retorna apenas o ID do cliente (`customer: "cus_0001"`), sem o nome ou e-mail dele. O `Merge` cruza a lista de cobranças com a lista de clientes (`/customers`). |
| **Qual situação geralmente indica a necessidade de um workflow complexo no N8N?** | `Quando há múltiplas fontes de dados e necessidade de tratativas específicas.` | Quando você busca dados de mais de um lugar, precisa unir (`Merge`), filtrar regras de negócio (`Filter`), rotear caminhos (`Switch`) e iterar com controle (`Loop`). |
| **Um workflow simples pode ser caracterizado por:** | `Poucas etapas e ações diretas, sem muita ramificação.` | Ex.: Receber um formulário -> Salvar na planilha -> Notificar no Slack/WhatsApp. |

---

### 2. Integração de APIs Financeiras e `Split Out` (`Iniciando a criação de um Workflow de automação`)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **Quando o Asaas não possui node nativo no N8N, qual recurso deve ser usado para integração?** | `Node HTTP Request` | O nó **`HTTP Request`** é o "coringa universal" do n8n: qualquer sistema financeiro, banco ou ERP que possua API REST pode ser integrado por ele. |
| **Ao criar notificações para clientes, o parâmetro do dia de vencimento serve para:** | `Definir com quantos dias antes do vencimento o cliente será notificado` | Usando régua de cobrança preventiva (ex.: avisar 3 dias antes de vencer para evitar inadimplência). |
| **Qual é o principal objetivo do workflow de automação criado na aula prática?** | `Enviar notificações de cobranças próximas do vencimento aos clientes` | Uma régua de cobrança automática que roda todo dia de manhã, identifica faturas pendentes e avisa cada cliente. |
| **Por que é utilizado o node `split out` após receber o array de clientes ou cobranças da API?** | `Para transformar cada item do array em um item separado do workflow` | A API retorna **1 único objeto JSON** com uma propriedade `data: [ {cobranca1}, {cobranca2}, ... ]`. O **`Split Out`** no campo `data` "desempacota" essa lista para que cada cobrança vire um item individual no fluxo do n8n! |

---

### 3. Unificação Relacional com `Merge` (`Unificando dados em um Workflow`)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **O que é geralmente representado pelo campo `ID` em tabelas de banco de dados relacionais?** | `Identificador único do objeto daquela tabela.` | Chave primária (*Primary Key*) que garante que dois clientes com o mesmo nome nunca sejam confundidos. |
| **No N8N, qual é a principal função do node `Merge` ao unificar dados de diferentes fontes?** | `Associar informações relacionadas de duas ou mais tabelas, combinando dados que possuem campos em comum.` | Funciona exatamente como um `INNER JOIN` / `LEFT JOIN` do SQL ou `PROCV`/`PROCX` do Excel! |
| **Ao unificar dados, por que é importante selecionar corretamente os campos de união no `Merge`?** | `Para garantir que apenas os registros corretos sejam combinados, evitando uniões erradas.` | Na entrada 1 (Cobranças) o campo chama-se `customer`; na entrada 2 (Clientes) o campo chama-se `id`. Se você unir os campos errados, enviará a cobrança de um cliente para o e-mail de outro! |
| **O que acontece se você combinar 100 clientes com 100 cobranças, mas apenas 44 clientes têm cobranças na lista?** | `O resultado terá apenas 44 registros, pois somente estes possuem correspondência entre cliente e cobrança.` | No modo padrão (*Combine -> Merge by Fields -> Keep Matches*), ele faz um `INNER JOIN`, mantendo apenas os 44 registros que têm correspondência nas duas pontas. |

---

### 4. Disparo Personalizado de E-mail (`Enviando e-mail em um Workflow`)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **No N8N, é possível enviar SMS e e-mails individualmente em lote através do mesmo node de envio sem nenhuma diferença de configuração.** | `Falso` | E-mail utiliza protocolo SMTP/OAuth2 (nó `Send Email`/`Gmail`), enquanto SMS/WhatsApp utiliza APIs de telefonia/mensageria (`Twilio`, `Evolution API`, `HTTP Request`). |
| **Quando você configura o campo `Subject` de forma personalizada usando o nome do cliente no N8N, isso é considerado uma:** | `Boa prática de personalização e autenticação de e-mails` | Aumenta a taxa de abertura e reduz a chance de filtros anti-spam classificarem a mensagem como spam genérico em massa. |
| **Ao configurar um workflow para envio de e-mails no N8N, qual node você deve utilizar para enviar o e-mail para cada cliente?** | `Node 'Send Email'` | Conecta-se via SMTP a qualquer provedor de e-mail para realizar o disparo. |
| **Para personalizar o assunto do e-mail com o nome do cliente, qual recurso você pode utilizar no N8N?** | `Expressão JavaScript no campo 'Subject'` | Mudando o campo de *Fixed* para *Expression* e usando `={{ 'Olá ' + $json.name + ', sua fatura vence em breve!' }}`. |

---

### 5. Loops, Filtros de Pagamento e `Wait` (`Criando um loop em um Workflow`)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **Após o envio de uma notificação para um cliente no loop, qual ação pode ser executada antes de passar para o próximo cliente?** | `Adicionar um tempo de espera (Wait) para espaçar os envios.` | O nó **`Wait`** (ex.: 3 a 5 segundos) dentro do loop evita estourar o limite de envios por minuto do servidor SMTP ou da API do WhatsApp. |
| **Qual alternativa melhor define o conceito de `loop` em um workflow do N8N?** | `Processar sequencialmente um conjunto de itens, repetindo ações para cada um deles até finalizar.` | Implementado com o nó **`Loop Over Items (Split in Batches)`**, que possui duas saídas: `loop` (executa para cada lote/item e volta) e `done` (segue adiante quando todos terminam). |
| **Qual campo retornado pela API deve ser utilizado para verificar a data de vencimento de uma cobrança no workflow?** | `due date` (`dueDate`) | Em APIs financeiras padrão (como Asaas/Stripe), `dueDate` é a data de vencimento, enquanto `createdAt` é a data em que a cobrança foi gerada. |
| **Considerando o tipo de pagamento, qual condição deve ser aplicada no filtro para que somente clientes pagantes por boleto ou Pix recebam a notificação?** | `A forma de pagamento (billingType) não deve ser igual a 'Credit Card'.` | Clientes no cartão de crédito têm cobrança automática na fatura; portanto, filtramos `billingType != 'CREDIT_CARD'` para avisar apenas quem precisa pagar ativamente (Boleto ou Pix). |

---

## 🌐 Curso 3: Uso de Webhooks e APIs no N8N

### 1. Webhooks: GET vs POST & Teste vs Produção (Aulas 2 e 3)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **No POST para webhooks, normalmente qual formato de dados é utilizado?** | `JSON` | Padrão universal da web moderna para enviar objetos estruturados no `body` da requisição. |
| **Qual é uma consequência de enviar informações sensíveis por GET em um webhook?** | `Os dados podem ser expostos na URL e registrados em logs.` | Dados financeiros, senhas, tokens ou CPFs **jamais** devem ir na URL (`GET`), pois ficam gravados no histórico, proxies e logs de servidores. |
| **O que acontece quando você executa um webhook GET e passa parâmetros na URL?** | `No n8n, os dados são recebidos como parâmetros de query.` | Ficam disponíveis em `{{ $json.query.nomeDoParametro }}`. |
| **No método GET, se você quiser adicionar um e-mail e um telefone na requisição, como deve fazer?** | `Adicionar ambos na URL separados por '&'.` | Ex.: `https://seu-n8n.com/webhook/teste?email=arthur@email.com&telefone=11999999999`. |
| **Ao pinar dados no editor do n8n, não é possível editar essas informações após o pinamento.** | `Falso` | **Dica de ouro:** Após clicar em *Pin data* no nó Webhook, você pode clicar em **Edit** no painel de saída e alterar qualquer valor do JSON para testar cenários diferentes sem precisar disparar o Webhook de novo! |
| **Quando um evento é recebido pela URL de teste, onde o output aparece?** | `Aba editor.` | Aparece em tempo real direto no canvas do editor enquanto você constrói o fluxo. |
| **Na URL de produção, o workflow monitora o webhook por quanto tempo ao ser ativado?** | `24 horas por dia, enquanto estiver ativado.` | Basta virar a chave **Active** no topo do workflow. |
| **O que acontece se você não ativar o workflow ao usar a URL de produção no n8n?** | `O webhook de produção não ficará no modo escuta e não funcionará.` | A URL `/webhook/...` (produção) retorna `404` se a chave **Active** estiver desligada. |

---

### 2. API REST, HTTP Request, Parâmetros e Autenticação (Aulas 4 a 7)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **O N8N pode realizar manipulação e formatação de dados antes de enviá-los para outra aplicação?** | `Sim, geralmente o N8N processa os dados antes de enviá-los` | Ele atua como camada de ETL/Orquestração: recebe de A, transforma/limpa no meio, e envia no formato exato que B exige. |
| **No contexto da automação, qual a vantagem do N8N integrar-se via API REST?** | `Permitir comunicação e transferência de informações entre diferentes sistemas` | Conecta sistemas de fabricantes totalmente diferentes (ex.: WhatsApp + Banco + Google Sheets). |
| **Para que serve o identificador único (como e-mail ou CPF) em integrações via API?** | `Permitir localizar informações específicas sobre uma pessoa em outra plataforma` | Chave de busca para consultar ou atualizar o cadastro correto antes de criar uma transação. |
| **O método GET é geralmente utilizado para operações de:** | `Leitura de dados.` | Consultar saldo, listar faturas, buscar cliente. |
| **No método POST, os campos enviados no body precisam corresponder exatamente aos nomes definidos pela API.** | `Verdadeiro` | Se a documentação da API pede `"dueDate"` (com D maiúsculo) e você envia `"duedate"`, a API rejeitará ou ignorará o campo. |
| **O que deve ser informado no header quando uma API exige autenticação via chave?** | `A API key no campo apropriado do header.` | Ex.: `access_token: $aact_...` (Asaas) ou `Authorization: Bearer ...`. |
| **Se uma URL possui apenas o valor sem identificar o campo, esse dado é considerado parâmetro de query?** | `Não, pois precisa ter nome e valor para ser query` | Query exige chave=valor (`?id=123`). Quando o valor vai direto na rota (`/clientes/123`), chama-se **Path Parameter** (parâmetro de rota/endpoint). |
| **O parâmetro de cabeçalho (Header) é mais adequado para qual finalidade?** | `Identificação e autenticação da requisição` | Usado para tokens de acesso, `Content-Type` e metadados de controle — **nunca** para passar dados pessoais como nome e idade do cliente. |
| **No processo de autenticação OAuth2 no N8N, qual elemento é fornecido ao usuário após registrar a aplicação?** | `CLIENT ID e CLIENT SECRET` | Credenciais geradas no console do provedor (ex.: Google Cloud Console) para autorizar o n8n a acessar Google Sheets, Drive e Gmail com segurança. |

---

### 3. Formatos de Saída, Códigos HTTP, Resiliência e Segurança de Webhooks (Aulas 8 a 13)

| Questão da DIO | Resposta Correta | Explicação Técnica & Prática no N8N |
| :--- | :--- | :--- |
| **Quando a resposta é retornada em formato binário, qual é uma situação comum de uso no N8N?** | `Ao baixar imagens ou arquivos` | Ex.: receber a foto de um comprovante Pix ou baixar o PDF de um boleto bancário. |
| **Qual código de resposta indica que um campo obrigatório não foi informado na requisição?** | `400` (`400 Bad Request`) | Erro do cliente: faltou um campo obrigatório no JSON ou o formato está inválido. |
| **O que devemos checar primeiro ao receber um erro `404` (`Recurso não encontrado`) em uma chamada de API?** | `Se o endpoint informado está correto` | Uma letra trocada na URL da API ou um ID inexistente gera `404 Not Found`. |
| **Ao enviar letras em vez de números no campo `number`, qual código a API pode retornar?** | `500` (ou `400`/`422`) | Quando o servidor tenta calcular sobre uma string onde esperava número sem tratar a exceção, estoura `500 Internal Server Error`. |
| **No N8N, qual é o número máximo de tentativas e o intervalo máximo no `retry on fail`?** | `5 tentativas` e `5 segundos` (5000 ms) | Na aba **Settings** de qualquer nó de integração (HTTP Request, Google Sheets, Send Email), ative **Retry On Fail** para tolerar oscilações de rede automaticamente! |
| **No N8N, o que deve ser informado no cabeçalho para autenticar o acesso ao webhook?** | `Um token de autenticação no campo authorization` | Geralmente no padrão `Authorization: Bearer <seu-token-secreto>`. |
| **Se alguém descobre o token do seu webhook, mas não está com o IP liberado na whitelist, o que ocorre?** | `A pessoa não consegue acessar o webhook` (retorna **`Erro 403`**) | Dupla camada de segurança: Token no Header + **IP(s) Whitelist** nas opções do nó Webhook! |
| **Qual das opções representa o menu simples do chatbot com Webhook autenticado?** | `1: Financeiro, 2: Suporte, 3: Falar com um atendente` | O Webhook recebe a opção escolhida pelo usuário, passa por um nó `Switch` e executa a automação correspondente! |
