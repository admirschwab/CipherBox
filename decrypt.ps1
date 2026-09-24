$message = Read-Host "Nachricht"

$json = [System.Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String($message)
)

$data = $json | ConvertFrom-Json

$encryptedKey = [Convert]::FromBase64String($data.key)
$nonce        = [Convert]::FromBase64String($data.nonce)
$ciphertext   = [Convert]::FromBase64String($data.ciphertext)
$tag          = [Convert]::FromBase64String($data.tag)


$privateKey = [System.Security.Cryptography.RSA]::Create()
$privateKey.ImportFromPem((Get-Content .\keystore\private.pem -Raw))

$key = $privateKey.Decrypt(
    $encryptedKey,
    [System.Security.Cryptography.RSAEncryptionPadding]::OaepSHA256
)

$plaintext = New-Object byte[] $ciphertext.Length

$aes = [System.Security.Cryptography.AesGcm]::new($key)

$aes.Decrypt(
    $nonce,
    $ciphertext,
    $tag,
    $plaintext
)

$text = [System.Text.Encoding]::UTF8.GetString($plaintext)
Clear-Host
Write-Host $text