Requirements: PowerShell 7 -> https://github.com/PowerShell/PowerShell<br>
!!Make sure to use always the newest version of CipherBox for all newest features!!

To start just type `.\start.ps1` into your Powershell 7 CLI

At first run the script will ask for a name for the public key and create the following directories and files:
- .\pubkeystore\
- .\keystore\
- .\keystore\private.pem
- .\keystore\name-public.pem

Now you can send the public key to the other person and the person have to drop your key file in the `pubkeystore` folder to encrypt the message for you

To **enrypt** your message just start.ps1 and type as method "encrypt" after this insert your message. The encrypted message will copy autmaticly into your clipboard.<br>
To **decrypt** a message just start.ps1 and type as method "dedrypt" after this insert the encrypted message and confirm. After this the message will appear. 
