@echo off
echo EMAIL CONVERSATION EXTRACTOR
echo ============================
echo.
echo This script will extract and transcribe email conversations from your .mbox file
echo Categories: Dr. Jen/Housing, Edith/Property, City Heat Complaints, Nick/Matt/Concepts26
echo.
echo Installing required Python packages...
pip install html2text
echo.
echo Running email extraction...
python "c:\Users\irato\OneDrive - Minnesota State\Civil 2025\email_extractor.py"
echo.
echo Extraction complete! Check the Extracted_Conversations folder for results.
pause
