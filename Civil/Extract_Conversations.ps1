# Email Conversation Extractor - PowerShell Version
# This script extracts conversations from .mbox files for legal documentation

Write-Host "EMAIL CONVERSATION EXTRACTOR" -ForegroundColor Green
Write-Host "============================" -ForegroundColor Green
Write-Host ""

# Configuration
$mboxPath = "c:\Users\irato\Downloads\All mail Including Spam and Trash.mbox"
$outputPath = "c:\Users\irato\OneDrive - Minnesota State\Civil 2025\Extracted_Conversations"
$pythonScript = "c:\Users\irato\OneDrive - Minnesota State\Civil 2025\email_extractor.py"

# Check if mbox file exists
if (-not (Test-Path $mboxPath)) {
    Write-Host "ERROR: .mbox file not found at $mboxPath" -ForegroundColor Red
    Write-Host "Please check the file path and try again." -ForegroundColor Red
    exit 1
}

# Create output directory if it doesn't exist
if (-not (Test-Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath -Force
    Write-Host "Created output directory: $outputPath" -ForegroundColor Yellow
}

# Install required Python package
Write-Host "Installing required Python packages..." -ForegroundColor Yellow
try {
    pip install html2text
    Write-Host "Package installation complete." -ForegroundColor Green
} catch {
    Write-Host "Warning: Could not install html2text package. Script may still work." -ForegroundColor Yellow
}

# Run the Python extraction script
Write-Host "Running email extraction..." -ForegroundColor Yellow
try {
    python $pythonScript
    Write-Host "Extraction completed successfully!" -ForegroundColor Green
} catch {
    Write-Host "Error running extraction script: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# List created files
Write-Host ""
Write-Host "FILES CREATED:" -ForegroundColor Green
Write-Host "==============" -ForegroundColor Green

if (Test-Path $outputPath) {
    $files = Get-ChildItem -Path $outputPath -File
    foreach ($file in $files) {
        Write-Host "- $($file.Name)" -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Host "All files are saved in: $outputPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "FILE FORMATS:" -ForegroundColor Yellow
    Write-Host "- .csv files: Spreadsheet compatible, easy to import into Excel"
    Write-Host "- .txt files: Court-ready transcripts, plain text format"
    Write-Host ""
    Write-Host "These files are compatible with eFile systems and legal documentation requirements."
} else {
    Write-Host "No output directory found. Please check for errors above." -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
