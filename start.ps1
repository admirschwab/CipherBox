Clear-Host

if ((Test-Path ".\keystore" -PathType Container) -and
    (Test-Path ".\pubkeystore" -PathType Container)) {
} else {
    .\keygen.ps1
}

$mode = Read-Host "encrypt/decrypt"

if ($mode -eq "encrypt") {
    .\encrypt.ps1
} elseif ($mode -eq "decrypt") {
    .\decrypt.ps1
} else {
    Clear-Host
    exit;
}