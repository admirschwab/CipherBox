$name = Read-Host "Name"
New-Item -ItemType Directory -Force -Path "keystore" | Out-Null
New-Item -ItemType Directory -Force -Path "pubkeystore" | Out-Null

$rsa = [System.Security.Cryptography.RSA]::Create(4096)

$privateKey = $rsa.ExportPkcs8PrivateKeyPem()
$publicKey  = $rsa.ExportSubjectPublicKeyInfoPem()

$privateKey | Set-Content "keystore\private.pem"
$publicKey  | Set-Content "keystore\$($name.ToLower())-public.pem"