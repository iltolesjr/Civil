# CONVERSATION TRANSCRIPTION SCRIPT
# PowerShell script to log and organize conversations with timestamps

# Define case folder paths
$Concepts26Path = "c:\Users\irato\OneDrive - Minnesota State\Civil 2025\Draft_34703074_Concepts26\Emails"
$EdithPath = "c:\Users\irato\OneDrive - Minnesota State\Civil 2025\Draft_34703073_Edith\Emails"

# Function to create conversation log entry
function New-ConversationLog {
    param(
        [string]$CaseFolder,
        [string]$Participant1,
        [string]$Participant2,
        [string]$ConversationType,  # Phone, Text, Email, In-Person
        [string]$Date,
        [string]$StartTime,
        [string]$EndTime = "",
        [string]$Content
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $filename = "Conversation_$($Date)_$timestamp.txt"
    $filepath = Join-Path $CaseFolder $filename
    
    $conversationContent = @"
CONVERSATION LOG
================
Date: $Date
Start Time: $StartTime
End Time: $EndTime
Type: $ConversationType
Participants: $Participant1, $Participant2
Logged: $(Get-Date)

CONVERSATION TRANSCRIPT:
========================
$Content

================
"@
    
    $conversationContent | Out-File -FilePath $filepath -Encoding UTF8
    Write-Host "Conversation saved to: $filepath"
}

# Function to create timestamped conversation template
function New-ConversationTemplate {
    param(
        [string]$CaseFolder,
        [string]$Participant1,
        [string]$Participant2,
        [string]$ConversationType,
        [string]$Date
    )
    
    $templateContent = @"
# CONVERSATION TRANSCRIPT
## Case: [Case Number]
## Date: $Date
## Type: $ConversationType
## Participants: $Participant1, $Participant2

---

**CONVERSATION START:** [Start Time]

**[$Participant1] - [Time]:** 
[Message/Statement]

**[$Participant2] - [Time]:** 
[Message/Statement]

**[$Participant1] - [Time]:** 
[Message/Statement]

**[$Participant2] - [Time]:** 
[Message/Statement]

---

**CONVERSATION END:** [End Time]

## SUMMARY
- **Duration:** [Total Time]
- **Key Points:** 
  - [Point 1]
  - [Point 2]
  - [Point 3]
- **Action Items:** 
  - [Action 1]
  - [Action 2]
- **Follow-up Required:** [Yes/No - Details]

## EVIDENCE VALUE
- **Relevance to Case:** [High/Medium/Low]
- **Legal Significance:** [Brief note]
- **Supporting Documents:** [List any referenced documents]

---
**Template Created:** $(Get-Date)
"@
    
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $filename = "Conversation_Template_$($Date)_$timestamp.md"
    $filepath = Join-Path $CaseFolder $filename
    
    $templateContent | Out-File -FilePath $filepath -Encoding UTF8
    Write-Host "Conversation template created: $filepath"
}

# Function to organize conversations chronologically
function Sort-ConversationsByDate {
    param(
        [string]$CaseFolder
    )
    
    $conversations = Get-ChildItem -Path $CaseFolder -Filter "Conversation_*.txt" | Sort-Object Name
    
    $masterLogPath = Join-Path $CaseFolder "Master_Conversation_Log.md"
    
    $masterContent = @"
# MASTER CONVERSATION LOG
## Case: [Case Number]
## Generated: $(Get-Date)

---

"@
    
    foreach ($conversation in $conversations) {
        $content = Get-Content $conversation.FullName -Raw
        $masterContent += "`n## $($conversation.Name)`n"
        $masterContent += $content
        $masterContent += "`n---`n"
    }
    
    $masterContent | Out-File -FilePath $masterLogPath -Encoding UTF8
    Write-Host "Master conversation log created: $masterLogPath"
}

# Usage Examples and Help
Write-Host "CONVERSATION TRANSCRIPTION TOOL"
Write-Host "==============================="
Write-Host ""
Write-Host "FUNCTIONS AVAILABLE:"
Write-Host ""
Write-Host "1. Create Conversation Template:"
Write-Host 'New-ConversationTemplate -CaseFolder "$Concepts26Path" -Participant1 "Ira Toles" -Participant2 "Nick/Concepts26" -ConversationType "Text Messages" -Date "2025-07-05"'
Write-Host ""
Write-Host "2. Log Completed Conversation:"
Write-Host 'New-ConversationLog -CaseFolder "$Concepts26Path" -Participant1 "Ira Toles" -Participant2 "Nick" -ConversationType "Phone Call" -Date "2025-07-05" -StartTime "2:30 PM" -EndTime "2:45 PM" -Content "Conversation content here"'
Write-Host ""
Write-Host "3. Create Master Chronological Log:"
Write-Host 'Sort-ConversationsByDate -CaseFolder "$Concepts26Path"'
Write-Host ""
Write-Host "CONVERSATION TYPES:"
Write-Host "- Phone Call"
Write-Host "- Text Messages"
Write-Host "- Email Exchange"
Write-Host "- In-Person Meeting"
Write-Host "- Video Call"
Write-Host "- Voicemail"
Write-Host ""
Write-Host "CASE FOLDERS:"
Write-Host "Concepts 26: $Concepts26Path"
Write-Host "Edith: $EdithPath"
