$root = gci "cert:\CurrentUser\my\6fa5df9d5b3b69559d954d3731eb439c5008d249"

Write-Host "Creating a Leaf Certificate chained to root:"
Write-Host "  Root Subject:" $root.Subject.Substring(3)
Write-Host "  Root Thumprint:" $root.Thumbprint

$certName = Read-Host "Device ID?"
$keyPwd = Read-Host "Key Password?" -AsSecureString

$cert = New-SelfSignedCertificate `
        -CertStoreLocation cert:\CurrentUser\my `
        -Subject $certName `
        -Signer $root `
        -HashAlgorithm SHA256 `
        -NotAfter (Get-Date).AddMonths(24) `
        -KeyUsage KeyEncipherment, DataEncipherment, DigitalSignature, NonRepudiation

Write-Host ""
Write-Host "Certificate generated and saved in cert store: my/CurrentUser"
Write-Host $cert.Subject $cert.Thumbprint 
Write-Host " . exporting certs to PFX/PEM/KEY files"
Write-Host ""

Export-Certificate -Cert $cert -FilePath "$certname.bin.cer" -TYPE CERT
certutil -encode "$certname.bin.cer" "$certname.pem"

Export-PfxCertificate -Cert $cert -FilePath "$certname.pfx" -Password $keyPwd

$txtPwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($keyPwd))
$bashCmd = "openssl pkcs12 -in '$certname.pfx' -out '$certname.secure.key' -nodes -passin pass:'$txtPwd' -passout pass:'$txtPwd'"
bash -c $bashCmd

$bashcmd = "openssl rsa -in '$certname.secure.key' -out '$certname.key'"
bash -c $bashCmd
