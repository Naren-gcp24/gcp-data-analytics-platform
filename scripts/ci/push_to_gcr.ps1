param(
  [string]$Image,
  [string]$KeyPath
)
if (-not $Image) { Write-Error 'Image is required'; exit 1 }
if (-not $KeyPath) { Write-Error 'KeyPath is required'; exit 1 }
& gcloud auth activate-service-account --key-file=$KeyPath
& gcloud auth configure-docker --quiet
& docker push $Image
