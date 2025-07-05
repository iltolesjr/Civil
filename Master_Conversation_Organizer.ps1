# MASTER CONVERSATION ORGANIZER
# This script creates chronological conversation logs

# Define case folders
$Concepts26Path = "c:\Users\irato\OneDrive - Minnesota State\Civil 2025\Draft_34703074_Concepts26"
$EdithPath = "c:\Users\irato\OneDrive - Minnesota State\Civil 2025\Draft_34703073_Edith"

function Create-MasterConversationLog {
    param([string]$CaseFolder, [string]$CaseName)
    
    # Get all conversation files
    $conversationFiles = Get-ChildItem -Path $CaseFolder -Filter "*Conversation*" -Recurse | 
        Where-Object { $_.Extension -eq ".md" -or $_.Extension -eq ".txt" } |
        Sort-Object Name
    
    $masterLogPath = Join-Path $CaseFolder "Master_Conversation_Log_$(Get-Date -Format 'yyyy-MM-dd').md"
    
    $header = @"
# MASTER CONVERSATION LOG
## Case: $CaseName
## Generated: $(Get-Date -Format 'MMMM dd, yyyy - HH:mm')
## Total Conversations: $($conversationFiles.Count)

---

## CHRONOLOGICAL INDEX
"@
    
    # Create index
    $index = ""
    $counter = 1
    foreach ($file in $conversationFiles) {
        $index += "$counter. **$($file.BaseName)** - Modified: $($file.LastWriteTime.ToString('MM/dd/yyyy HH:mm'))`n"
        $counter++
    }
    
    # Combine header and index
    $masterContent = $header + "`n" + $index + "`n---`n`n"
    
    # Add each conversation
    foreach ($file in $conversationFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($content) {
            $masterContent += "## $($file.BaseName)`n"
            $masterContent += "**File:** $($file.Name)`n"
            $masterContent += "**Last Modified:** $($file.LastWriteTime.ToString('MM/dd/yyyy HH:mm'))`n`n"
            $masterContent += $content
            $masterContent += "`n`n---`n`n"
        }
    }
    
    $masterContent | Out-File -FilePath $masterLogPath -Encoding UTF8
    Write-Host "✅ Master conversation log created: $masterLogPath"
    return $masterLogPath
}

# Function to create quick conversation entry
function Quick-ConversationEntry {
    param(
        [string]$CaseFolder,
        [string]$CaseName,
        [string]$OtherParty,
        [string]$ConversationType = "Text Messages",
        [string]$Date = (Get-Date -Format "yyyy-MM-dd")
    )
    
    $timestamp = Get-Date -Format "HH-mm"
    $filename = "Conversation_$($Date)_$($timestamp)_$($OtherParty.Replace(' ', '')).md"
    $filepath = Join-Path $CaseFolder $filename
    
    $quickTemplate = @"
# CONVERSATION: $OtherParty
## Case: $CaseName
## Date: $Date
## Type: $ConversationType
## Start Time: [Time]

---

**[Ira] - [Time]:** 


**[$OtherParty] - [Time]:** 


**[Ira] - [Time]:** 


**[$OtherParty] - [Time]:** 


**[Ira] - [Time]:** 


**[$OtherParty] - [Time]:** 


---

## QUICK SUMMARY
- **Key Point:** 
- **Outcome:** 
- **Next Step:** 

**Created:** $(Get-Date -Format 'MM/dd/yyyy HH:mm')
"@
    
    $quickTemplate | Out-File -FilePath $filepath -Encoding UTF8
    Write-Host "✅ Quick conversation template created: $filepath"
    return $filepath
}

# Usage instructions
Write-Host "MASTER CONVERSATION ORGANIZER"
Write-Host "============================="
Write-Host ""
Write-Host "AVAILABLE COMMANDS:"
Write-Host ""
Write-Host "1. Create Master Conversation Log (Concepts 26):"
Write-Host "   Create-MasterConversationLog -CaseFolder '$Concepts26Path' -CaseName 'Draft #34703074 - Concepts 26'"
Write-Host ""
Write-Host "2. Create Master Conversation Log (Edith):"
Write-Host "   Create-MasterConversationLog -CaseFolder '$EdithPath' -CaseName 'Draft #34703073 - Edith'"
Write-Host ""
Write-Host "3. Quick Conversation Entry (Concepts 26):"
Write-Host "   Quick-ConversationEntry -CaseFolder '$Concepts26Path' -CaseName 'Draft #34703074 - Concepts 26' -OtherParty 'Nick' -ConversationType 'Phone Call'"
Write-Host ""
Write-Host "4. Quick Conversation Entry (Edith):"
Write-Host "   Quick-ConversationEntry -CaseFolder '$EdithPath' -CaseName 'Draft #34703073 - Edith' -OtherParty 'Edith' -ConversationType 'Text Messages'"
Write-Host ""
Write-Host "5. Run Both Master Logs:"
Write-Host "   Create-MasterConversationLog -CaseFolder '$Concepts26Path' -CaseName 'Draft #34703074 - Concepts 26'"
Write-Host "   Create-MasterConversationLog -CaseFolder '$EdithPath' -CaseName 'Draft #34703073 - Edith'"
Write-Host ""
Write-Host "CONVERSATION TYPES:"
Write-Host "- Text Messages"
Write-Host "- Phone Call"
Write-Host "- Email Exchange"
Write-Host "- In-Person Meeting"
Write-Host "- Video Call"
Write-Host "- Voicemail"
