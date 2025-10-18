param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

# Resolve repository root (parent of the scripts folder)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

# Default profiles dir: use dbt_fundamentals local profiles if present
$PreferredProfiles = Join-Path $RepoRoot 'dbt_fundamentals\.dbt'
if (-Not (Test-Path $PreferredProfiles)) {
    # fallback to jaffle_shop if present
    $PreferredProfiles = Join-Path $RepoRoot 'jaffle_shop\.dbt'
}

# Pick a project dir to use (prefer dbt_fundamentals, otherwise jaffle_shop)
$ProjectDir = Join-Path $RepoRoot 'dbt_fundamentals'
if (-Not (Test-Path (Join-Path $ProjectDir 'dbt_project.yml'))) {
    $ProjectDir = Join-Path $RepoRoot 'jaffle_shop'
}

Write-Host "Using DBT_PROFILES_DIR = $PreferredProfiles"
$env:DBT_PROFILES_DIR = $PreferredProfiles

Write-Host "Running dbt from project dir: $ProjectDir"
Push-Location $ProjectDir
try {
    if ($Args -and $Args.Length -gt 0) {
        & dbt @Args
    } else {
        & dbt debug
    }
} finally {
    Pop-Location
}
