# ```powershell
# ==========================================
# CSV to Terraform.tfvars Generator
# ==========================================

$CsvFile = ".\resource-groups.csv"
$TfvarsFile = ".\terraform.tfvars"

# Check CSV file exists
if (-not (Test-Path $CsvFile)) {
    Write-Host "ERROR: CSV file not found: $CsvFile" -ForegroundColor Red
    exit 1
}

# Read CSV
$rows = Import-Csv $CsvFile

# Start Terraform variable
$output = @()
$output += "rgs = {"

foreach ($row in $rows) {

    # Validate required columns
    if ([string]::IsNullOrWhiteSpace($row.key) -or
        [string]::IsNullOrWhiteSpace($row.name) -or
        [string]::IsNullOrWhiteSpace($row.location)) {

        Write-Host "ERROR: CSV contains missing value." -ForegroundColor Red
        Write-Host "Required columns: key, name, location"
        exit 1
    }

    $output += "  $($row.key) = {"
    $output += "    name     = `"$($row.name)`""
    $output += "    location = `"$($row.location)`""
    $output += "  }"
}

$output += "}"

# Write terraform.tfvars
$output | Set-Content -Path $TfvarsFile -Encoding UTF8

Write-Host ""
Write-Host "terraform.tfvars generated successfully!" -ForegroundColor Green
Write-Host "File: $TfvarsFile" -ForegroundColor Cyan
# ```
