#!/bin/bash
# SHOW UPCOMING COURT DATES
# Quick script to display upcoming court dates and action items

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${CYAN}================================================${NC}"
echo -e "${CYAN}  📅 UPCOMING COURT CASES & DATES${NC}"
echo -e "${CYAN}================================================${NC}"
echo ""

# Display last updated date
echo -e "Last Updated: ${YELLOW}January 2025${NC}"
echo ""

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}  ACTIVE CASES SUMMARY${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""

# Case 1: MCRO 62-CO-25-3554
echo -e "${YELLOW}1. MCRO 62-CO-25-3554${NC}"
echo -e "   Status: ${GREEN}FILED (July 17, 2025)${NC}"
echo "   Court: Ramsey County Conciliation Court"
echo -e "   Next Date: ${RED}CHECK COURT WEBSITE${NC}"
echo "   Action: Call (651) 266-8266 or visit https://pa.courts.state.mn.us/CaseSearch"
echo ""

# Case 2: Draft #34703073
echo -e "${YELLOW}2. Draft #34703073 - Edith${NC}"
echo -e "   Status: ${MAGENTA}PRE-FILING${NC}"
echo "   Type: Property/Security Deposit Dispute"
echo "   Next Date: Not yet scheduled (case not filed)"
echo "   Action: Complete demand letter and file case"
echo ""

# Case 3: Draft #34703074
echo -e "${YELLOW}3. Draft #34703074 - Concepts 26${NC}"
echo -e "   Status: ${MAGENTA}PRE-FILING${NC}"
echo "   Type: Property Management Dispute"
echo "   Next Date: Not yet scheduled (case not filed)"
echo "   Action: Complete demand letter and file case"
echo ""

echo -e "${RED}================================================${NC}"
echo -e "${RED}  IMMEDIATE ACTION REQUIRED${NC}"
echo -e "${RED}================================================${NC}"
echo ""

echo -e "${RED}🔴 Priority 1: Check MCRO 62-CO-25-3554 hearing date${NC}"
echo "   • Online: https://pa.courts.state.mn.us/CaseSearch"
echo "   • Phone: (651) 266-8266"
echo "   • Case Number: 62-CO-25-3554"
echo ""

echo -e "${YELLOW}📋 Priority 2: Finalize pre-filing cases${NC}"
echo "   • Draft #34703073 - Edith"
echo "   • Draft #34703074 - Concepts 26"
echo ""

echo -e "${CYAN}================================================${NC}"
echo -e "${CYAN}  HELPFUL RESOURCES${NC}"
echo -e "${CYAN}================================================${NC}"
echo ""

echo -e "${GREEN}📄 Detailed Information:${NC}"
echo "   • UPCOMING_DATES_SUMMARY.md - Quick summary (START HERE)"
echo "   • Court_Calendar.md - Full calendar with all dates"
echo "   • Case_Status_Tracker.md - Detailed case status"
echo "   • How_to_Check_Court_Dates.md - Step-by-step instructions"
echo ""

echo -e "${GREEN}🌐 Online Resources:${NC}"
echo "   • Minnesota Courts: https://www.mncourts.gov/"
echo "   • Court Records: https://pa.courts.state.mn.us/CaseSearch"
echo "   • Legal Aid: 1-888-360-2889"
echo ""

echo -e "${CYAN}================================================${NC}"
echo -e "${CYAN}  QUICK CHECKLIST${NC}"
echo -e "${CYAN}================================================${NC}"
echo ""

# Checklist items
echo "   [ ] Check online for case 62-CO-25-3554 hearing date"
echo "   [ ] If not online, call (651) 266-8266"
echo "   [ ] Update Court_Calendar.md with any dates found"
echo "   [ ] Set phone reminders for any scheduled dates"
echo "   [ ] Review evidence for filed case"
echo "   [ ] Decide on pre-filing cases (file or settle?)"

echo ""
echo -e "${CYAN}================================================${NC}"
echo ""

# Offer to open files
echo -e "${YELLOW}Would you like to:${NC}"
echo "1. View UPCOMING_DATES_SUMMARY.md (detailed quick reference)"
echo "2. View Court_Calendar.md (full calendar)"
echo "3. View Case_Status_Tracker.md (all cases)"
echo "4. Exit"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        if [ -f "UPCOMING_DATES_SUMMARY.md" ]; then
            cat UPCOMING_DATES_SUMMARY.md | less
        else
            echo -e "${RED}File not found!${NC}"
        fi
        ;;
    2)
        if [ -f "Court_Calendar.md" ]; then
            cat Court_Calendar.md | less
        else
            echo -e "${RED}File not found!${NC}"
        fi
        ;;
    3)
        if [ -f "Case_Status_Tracker.md" ]; then
            cat Case_Status_Tracker.md | less
        else
            echo -e "${RED}File not found!${NC}"
        fi
        ;;
    4)
        echo -e "${GREEN}Exiting...${NC}"
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting...${NC}"
        ;;
esac

echo ""
echo -e "${CYAN}TIP: Run this script anytime to see your court date status!${NC}"
echo ""

