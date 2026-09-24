# AES-256-Key erzeugen
$key = New-Object byte[] 32
[System.Security.Cryptography.RandomNumberGenerator]::Fill($key)

# Nachricht eingeben
$text = Read-Host "Nachricht"
$plaintext = [System.Text.Encoding]::UTF8.GetBytes($text)

# GCM braucht einen eindeutigen Nonce
$nonce = New-Object byte[] 12
[System.Security.Cryptography.RandomNumberGenerator]::Fill($nonce)

# Speicher für Ciphertext und Authentication Tag
$ciphertext = New-Object byte[] $plaintext.Length
$tag = New-Object byte[] 16

# AES-GCM
$aes = [System.Security.Cryptography.AesGcm]::new($key)

$aes.Encrypt(
    $nonce,
    $plaintext,
    $ciphertext,
    $tag
)

$publicKeyFolder = ".\pubkeystore"

# Alle Public-Key-Dateien finden
$publicKeys = Get-ChildItem -Path $publicKeyFolder -Filter "*.pem" -File

if ($publicKeys.Count -eq 0) {
    Write-Host "Keine Public Keys gefunden."
    exit
}

# Auswahl anzeigen
Write-Host ""
Write-Host "Empfänger auswählen:"
Write-Host ""

for ($i = 0; $i -lt $publicKeys.Count; $i++) {
    Write-Host "$($i + 1)) $($publicKeys[$i].BaseName)"
}

Write-Host ""

# Auswahl abfragen
$selection = Read-Host "Nummer"

# Prüfen, ob gültig
if ($selection -notmatch '^\d+$' -or
    [int]$selection -lt 1 -or
    [int]$selection -gt $publicKeys.Count) {

    Write-Host "Ungültige Auswahl."
    exit
}

# Ausgewählten Key holen
$selectedKey = $publicKeys[[int]$selection - 1]

Write-Host "Empfänger: $($selectedKey.BaseName)"

# Public Key laden
$publicKey = [System.Security.Cryptography.RSA]::Create()
$publicKey.ImportFromPem((Get-Content $selectedKey.FullName -Raw))

$encryptedKey = $publicKey.Encrypt(
    $key,
    [System.Security.Cryptography.RSAEncryptionPadding]::OaepSHA256
)


$data = @{
    key        = [Convert]::ToBase64String($encryptedKey)
    nonce      = [Convert]::ToBase64String($nonce)
    ciphertext = [Convert]::ToBase64String($ciphertext)
    tag        = [Convert]::ToBase64String($tag)
}

$json = $data | ConvertTo-Json -Compress

$message = [Convert]::ToBase64String(
    [System.Text.Encoding]::UTF8.GetBytes($json)
)

$message | Set-Clipboard