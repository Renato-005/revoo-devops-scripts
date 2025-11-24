# Setup básico para rodar o Revoo na VM Windows
# Execute no PowerShell como Admin

Write-Host "== Instalando Git (se não existir) =="
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  winget install --id Git.Git -e --source winget
}

Write-Host "== Clone do projeto =="
$repo = Read-Host "Cole o link do GitHub do Revoo"
cd $env:USERPROFILE\Desktop
git clone $repo
$folder = ($repo.Split('/')[-1]).Replace('.git','')
cd $folder

Write-Host "== Agora instale o runtime do seu stack (Node/Java/.NET) e rode o projeto =="
Write-Host "Ex.: Node -> npm install ; npm run build ; npm start -- -H 0.0.0.0 -p 3000"
