# SHOW UPCOMING COURT DATES
# Quick script to display upcoming court dates and action items

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  📅 UPCOMING COURT CASES & DATES" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Display last updated date
Write-Host "Last Updated: " -NoNewline
Write-Host "January 2025" -ForegroundColor Yellow
Write-Host ""

Write-Host "================================================" -ForegroundColor Green
Write-Host "  ACTIVE CASES SUMMARY" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""

# Case 1: MCRO 62-CO-25-3554
Write-Host "1. MCRO 62-CO-25-3554" -ForegroundColor Yellow
Write-Host "   Status: " -NoNewline
Write-Host "FILED (July 17, 2025)" -ForegroundColor Green
Write-Host "   Court: Ramsey County Conciliation Court"
Write-Host "   Next Date: " -NoNewline
Write-Host "CHECK COURT WEBSITE" -ForegroundColor Red
Write-Host "   Action: Call (651) 266-8266 or visit https://pa.courts.state.mn.us/CaseSearch"
Write-Host ""

# Case 2: Draft #34703073
Write-Host "2. Draft #34703073 - Edith" -ForegroundColor Yellow
Write-Host "   Status: " -NoNewline
Write-Host "PRE-FILING" -ForegroundColor Magenta
Write-Host "   Type: Property/Security Deposit Dispute"
Write-Host "   Next Date: Not yet scheduled (case not filed)"
Write-Host "   Action: Complete demand letter and file case"
Write-Host ""

# Case 3: Draft #34703074
Write-Host "3. Draft #34703074 - Concepts 26" -ForegroundColor Yellow
Write-Host "   Status: " -NoNewline
Write-Host "PRE-FILING" -ForegroundColor Magenta
Write-Host "   Type: Property Management Dispute"
Write-Host "   Next Date: Not yet scheduled (case not filed)"
Write-Host "   Action: Complete demand letter and file case"
Write-Host ""

Write-Host "================================================" -ForegroundColor Red
Write-Host "  IMMEDIATE ACTION REQUIRED" -ForegroundColor Red
Write-Host "================================================" -ForegroundColor Red
Write-Host ""

Write-Host "🔴 Priority 1: Check MCRO 62-CO-25-3554 hearing date" -ForegroundColor Red
Write-Host "   • Online: https://pa.courts.state.mn.us/CaseSearch" -ForegroundColor White
Write-Host "   • Phone: (651) 266-8266" -ForegroundColor White
Write-Host "   • Case Number: 62-CO-25-3554" -ForegroundColor White
Write-Host ""

Write-Host "📋 Priority 2: Finalize pre-filing cases" -ForegroundColor Yellow
Write-Host "   • Draft #34703073 - Edith" -ForegroundColor White
Write-Host "   • Draft #34703074 - Concepts 26" -ForegroundColor White
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  HELPFUL RESOURCES" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📄 Detailed Information:" -ForegroundColor Green
Write-Host "   • UPCOMING_DATES_SUMMARY.md - Quick summary (START HERE)"
Write-Host "   • Court_Calendar.md - Full calendar with all dates"
Write-Host "   • Case_Status_Tracker.md - Detailed case status"
Write-Host "   • How_to_Check_Court_Dates.md - Step-by-step instructions"
Write-Host ""

Write-Host "🌐 Online Resources:" -ForegroundColor Green
Write-Host "   • Minnesota Courts: https://www.mncourts.gov/"
Write-Host "   • Court Records: https://pa.courts.state.mn.us/CaseSearch"
Write-Host "   • Legal Aid: 1-888-360-2889"
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  QUICK CHECKLIST" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Checklist items
$checklistItems = @(
    "Check online for case 62-CO-25-3554 hearing date",
    "If not online, call (651) 266-8266",
    "Update Court_Calendar.md with any dates found",
    "Set phone reminders for any scheduled dates",
    "Review evidence for filed case",
    "Decide on pre-filing cases (file or settle?)"
)

foreach ($item in $checklistItems) {
    Write-Host "   [ ] $item" -ForegroundColor White
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Prompt to open files
Write-Host "Would you like to:" -ForegroundColor Yellow
Write-Host "1. Open UPCOMING_DATES_SUMMARY.md (detailed quick reference)"
Write-Host "2. Open Court_Calendar.md (full calendar)"
Write-Host "3. Open Case_Status_Tracker.md (all cases)"
Write-Host "4. Exit"
Write-Host ""
$choice = Read-Host "Enter choice (1-4)"

switch ($choice) {
    "1" {
        if (Test-Path "UPCOMING_DATES_SUMMARY.md") {
            Start-Process "UPCOMING_DATES_SUMMARY.md"
        } else {
            Write-Host "File not found!" -ForegroundColor Red
        }
    }
    "2" {
        if (Test-Path "Court_Calendar.md") {
            Start-Process "Court_Calendar.md"
        } else {
            Write-Host "File not found!" -ForegroundColor Red
        }
    }
    "3" {
        if (Test-Path "Case_Status_Tracker.md") {
            Start-Process "Case_Status_Tracker.md"
        } else {
            Write-Host "File not found!" -ForegroundColor Red
        }
    }
    "4" {
        Write-Host "Exiting..." -ForegroundColor Green
    }
    default {
        Write-Host "Invalid choice. Exiting..." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "TIP: Run this script anytime to see your court date status!" -ForegroundColor Cyan
Write-Host ""

