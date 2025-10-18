param(
  [string]$JenkinsUrl = 'http://localhost:8080',
  [string]$Username = 'gcpdbt',
  [System.Security.SecureString]$Password,
  [string]$JobName = 'newfolder-pipeline',
  [string]$JobConfigPath = 'newfolder/jenkins_job_config.xml'
)

# Reads the job XML and creates/updates a Jenkins job via REST API. Requires that the user has permissions.
$creds = New-Object System.Management.Automation.PSCredential($Username,$Password)
$xml = Get-Content $JobConfigPath -Raw

# get crumb if available
try {
  $crumbJson = Invoke-RestMethod -Uri "$JenkinsUrl/crumbIssuer/api/json" -Credential $creds -Method Get -ErrorAction Stop
  $crumb = $crumbJson.crumb
  $crumbField = $crumbJson.crumbRequestField
} catch {
  $crumb = $null; $crumbField = $null
}

$headers = @{}
if ($crumb) { $headers[$crumbField] = $crumb }

# create or update
$createUrl = "$JenkinsUrl/createItem?name=$JobName"
$updateUrl = "$JenkinsUrl/job/$JobName/config.xml"

# Try update first; if it 404s, create
try {
  Invoke-RestMethod -Uri $updateUrl -Credential $creds -Method Post -Body $xml -ContentType 'application/xml' -Headers $headers -ErrorAction Stop
  Write-Host "Updated Jenkins job '$JobName'"
} catch {
  Write-Host "Job not found or update failed; attempting to create..."
  Invoke-RestMethod -Uri $createUrl -Credential $creds -Method Post -Body $xml -ContentType 'application/xml' -Headers $headers -ErrorAction Stop
  Write-Host "Created Jenkins job '$JobName'"
}
