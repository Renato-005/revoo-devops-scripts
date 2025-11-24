# Revoo - Setup da VM Windows (App)

Write-Host "Revoo - Setup VM Windows" -ForegroundColor Cyan

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Git..." -ForegroundColor Yellow
    winget install --id Git.Git -e --source winget
} else {
    Write-Host "Git já instalado." -ForegroundColor Green
}

$repo = Read-Host "Cole o link HTTPS do repositório do Revoo"

if (-not $repo) {
    Write-Host "Nenhum repositório informado." -ForegroundColor Red
    exit 1
}

cd $env:USERPROFILE\Desktop
git clone $repo

$folder = ($repo.Split('/')[-1]).Replace('.git','')
cd $folder

Write-Host "Projeto clonado em: $(Get-Location)" -ForegroundColor Green
Write-Host "Agora instale o runtime do projeto (Node/Java/.NET), ajuste a string de conexão para o IP privado da VM Linux (por exemplo 10.0.2.4) e rode a aplicação escutando em 0.0.0.0 na porta configurada." -ForegroundColor Cyan
