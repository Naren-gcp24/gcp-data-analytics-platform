param(
    [string]$CredPath
)

function Fail([string]$msg) {
    Write-Error $msg
    exit 1
}

# If a credential path is passed, use it
if ($CredPath) {
    if (-Not (Test-Path $CredPath)) {
        Fail "Provided credentials file '$CredPath' does not exist."
    }
    $env:GOOGLE_APPLICATION_CREDENTIALS = (Resolve-Path $CredPath).Path
    Write-Host "Set GOOGLE_APPLICATION_CREDENTIALS to $env:GOOGLE_APPLICATION_CREDENTIALS"
} else {
    if (-not $env:GOOGLE_APPLICATION_CREDENTIALS) {
        Fail "GOOGLE_APPLICATION_CREDENTIALS is not set. Provide a path or run 'gcloud auth application-default login' to use your gcloud credentials." 
    }
    if (-Not (Test-Path $env:GOOGLE_APPLICATION_CREDENTIALS)) {
        Fail "GOOGLE_APPLICATION_CREDENTIALS is set to '$env:GOOGLE_APPLICATION_CREDENTIALS' but that file does not exist."
    }
}

Push-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)
try {
    terraform init -input=false
    terraform apply -auto-approve
} finally {
    Pop-Location
}
