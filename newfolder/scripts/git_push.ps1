param(
  [string]$Branch = "feature/newfolder-terraform",
  [string]$Message = "Add newfolder terraform and Jenkins job config"
)

Write-Host "Creating branch $Branch and pushing changes..."
git checkout -b $Branch
git add newfolder
git commit -m $Message
git push -u origin $Branch
Write-Host "Pushed branch $Branch. Create a PR on GitHub or merge as needed."
