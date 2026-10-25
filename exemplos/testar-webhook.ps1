# =============================================================================
# Script de Teste Prático — Agente Financeiro no N8N (PowerShell)
# =============================================================================
# Instruções:
# 1. Importe o arquivo `workflows/agente-financeiro-n8n.json` no seu n8n.
# 2. Configure a credencial de Header Auth no nó "Webhook Bot Financeiro":
#    - Name: Authorization
#    - Value: Bearer token-secreto-financeiro-2026
# 3. Clique em "Listen for test event" no n8n e execute este script!
# =============================================================================

$WebhookUrl = "http://localhost:5678/webhook-test/bot-financeiro"
$Headers = @{
    "Authorization" = "Bearer token-secreto-financeiro-2026"
    "Content-Type"  = "application/json"
}

Write-Host "1. Testando Opcao 1 do Menu (Registrar Despesa Financeira)..." -ForegroundColor Cyan
$PayloadLancamento = @{
    usuario        = "Arthur Brito"
    telefone       = "(11) 99876-5432"
    opcao          = "1"
    tipo           = "Despesa"
    categoria      = "Assinaturas & Cloud"
    descricao      = "Servidor VPS N8N"
    valor          = "R$ 89,90"
    formaPagamento = "PIX"
    dataVencimento = "2026-11-05"
} | ConvertTo-Json -Depth 5

Invoke-RestMethod -Uri $WebhookUrl -Method Post -Headers $Headers -Body $PayloadLancamento

Write-Host "`n2. Testando Opcao 3 do Menu (Exibir Menu Interativo do Chatbot)..." -ForegroundColor Yellow
$PayloadMenu = @{
    usuario  = "Arthur Brito"
    telefone = "(11) 99876-5432"
    opcao    = "3"
} | ConvertTo-Json -Depth 5

Invoke-RestMethod -Uri $WebhookUrl -Method Post -Headers $Headers -Body $PayloadMenu
