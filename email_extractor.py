#!/usr/bin/env python3
"""
Email Conversation Extractor for Legal Cases
Extracts and transcribes email conversations from .mbox files
Organizes by: Dr. Jen/Housing, Edith/Property, City Heat Complaints, Nick/Matt/Concepts26
"""

import mailbox
import csv
import re
import os
from datetime import datetime
from email.utils import parsedate_to_datetime
import html2text

class EmailTranscriber:
    def __init__(self, mbox_path, output_dir):
        self.mbox_path = mbox_path
        self.output_dir = output_dir
        self.conversations = {
            'dr_jen_housing': [],
            'edith_property': [],
            'city_heat_complaints': [],
            'nick_matt_concepts26': []
        }
        
        # Search keywords for each category
        self.keywords = {
            'dr_jen_housing': [
                'dr jen', 'dr. jen', 'jennifer', 'hennepin county', 'homeless to housing',
                'housing assistance', 'homeless', 'housing program'
            ],
            'edith_property': [
                'edith', 'edith\'s house', 'property address', 'rental property',
                'apartment', 'residence', 'landlord'
            ],
            'city_heat_complaints': [
                'city of minneapolis', 'heat complaint', 'no heat', 'heating',
                'temperature', 'furnace', 'cold', 'heat issue'
            ],
            'nick_matt_concepts26': [
                'nick', 'matt', 'matthew', 'concepts26', 'concepts 26',
                'property management', 'manager'
            ]
        }
    
    def extract_text_from_email(self, email_msg):
        """Extract clean text from email message"""
        text = ""
        
        if email_msg.is_multipart():
            for part in email_msg.walk():
                if part.get_content_type() == "text/plain":
                    text += part.get_payload(decode=True).decode('utf-8', errors='ignore')
                elif part.get_content_type() == "text/html":
                    html_content = part.get_payload(decode=True).decode('utf-8', errors='ignore')
                    h = html2text.HTML2Text()
                    h.ignore_links = True
                    text += h.handle(html_content)
        else:
            if email_msg.get_content_type() == "text/plain":
                text += email_msg.get_payload(decode=True).decode('utf-8', errors='ignore')
            elif email_msg.get_content_type() == "text/html":
                html_content = email_msg.get_payload(decode=True).decode('utf-8', errors='ignore')
                h = html2text.HTML2Text()
                h.ignore_links = True
                text += h.handle(html_content)
        
        # Clean up the text
        text = re.sub(r'\n\s*\n', '\n', text)  # Remove multiple newlines
        text = re.sub(r'[^\w\s\.\,\!\?\:\;\-\(\)\[\]\'\"\/\@]', '', text)  # Remove special chars
        return text.strip()
    
    def categorize_email(self, email_msg):
        """Determine which category an email belongs to"""
        subject = email_msg.get('Subject', '').lower()
        sender = email_msg.get('From', '').lower()
        recipient = email_msg.get('To', '').lower()
        content = self.extract_text_from_email(email_msg).lower()
        
        search_text = f"{subject} {sender} {recipient} {content}"
        
        categories = []
        for category, keywords in self.keywords.items():
            for keyword in keywords:
                if keyword.lower() in search_text:
                    categories.append(category)
                    break
        
        return categories
    
    def parse_mbox(self):
        """Parse the .mbox file and extract relevant conversations"""
        print(f"Opening mbox file: {self.mbox_path}")
        
        try:
            mbox = mailbox.mbox(self.mbox_path)
            total_emails = len(mbox)
            processed = 0
            
            print(f"Found {total_emails} emails to process...")
            
            for message in mbox:
                try:
                    categories = self.categorize_email(message)
                    
                    if categories:
                        email_data = {
                            'date': parsedate_to_datetime(message.get('Date', '')),
                            'from': message.get('From', ''),
                            'to': message.get('To', ''),
                            'subject': message.get('Subject', ''),
                            'content': self.extract_text_from_email(message),
                            'message_id': message.get('Message-ID', '')
                        }
                        
                        for category in categories:
                            self.conversations[category].append(email_data)
                    
                    processed += 1
                    if processed % 100 == 0:
                        print(f"Processed {processed}/{total_emails} emails...")
                        
                except Exception as e:
                    print(f"Error processing email: {e}")
                    continue
            
            print(f"Completed processing {processed} emails")
            self.print_summary()
            
        except Exception as e:
            print(f"Error opening mbox file: {e}")
            return False
        
        return True
    
    def print_summary(self):
        """Print summary of extracted conversations"""
        print("\n=== EXTRACTION SUMMARY ===")
        for category, emails in self.conversations.items():
            print(f"{category.replace('_', ' ').title()}: {len(emails)} emails")
    
    def export_to_csv(self, category, filename):
        """Export conversation to CSV format"""
        if not self.conversations[category]:
            print(f"No emails found for category: {category}")
            return
        
        filepath = os.path.join(self.output_dir, filename)
        
        with open(filepath, 'w', newline='', encoding='utf-8') as csvfile:
            fieldnames = ['Date', 'Time', 'From', 'To', 'Subject', 'Content']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            
            writer.writeheader()
            
            # Sort by date
            sorted_emails = sorted(self.conversations[category], key=lambda x: x['date'] if x['date'] else datetime.min)
            
            for email in sorted_emails:
                date_str = email['date'].strftime('%Y-%m-%d') if email['date'] else 'Unknown'
                time_str = email['date'].strftime('%H:%M:%S') if email['date'] else 'Unknown'
                
                writer.writerow({
                    'Date': date_str,
                    'Time': time_str,
                    'From': email['from'],
                    'To': email['to'],
                    'Subject': email['subject'],
                    'Content': email['content'][:1000] + '...' if len(email['content']) > 1000 else email['content']
                })
        
        print(f"CSV exported: {filepath}")
    
    def export_to_text(self, category, filename):
        """Export conversation to plain text format (court-ready)"""
        if not self.conversations[category]:
            print(f"No emails found for category: {category}")
            return
        
        filepath = os.path.join(self.output_dir, filename)
        
        with open(filepath, 'w', encoding='utf-8') as textfile:
            textfile.write(f"EMAIL CONVERSATION TRANSCRIPT\n")
            textfile.write(f"Category: {category.replace('_', ' ').title()}\n")
            textfile.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            textfile.write(f"Total Emails: {len(self.conversations[category])}\n")
            textfile.write("="*80 + "\n\n")
            
            # Sort by date
            sorted_emails = sorted(self.conversations[category], key=lambda x: x['date'] if x['date'] else datetime.min)
            
            for i, email in enumerate(sorted_emails, 1):
                date_str = email['date'].strftime('%Y-%m-%d %H:%M:%S') if email['date'] else 'Unknown Date'
                
                textfile.write(f"EMAIL #{i}\n")
                textfile.write(f"Date: {date_str}\n")
                textfile.write(f"From: {email['from']}\n")
                textfile.write(f"To: {email['to']}\n")
                textfile.write(f"Subject: {email['subject']}\n")
                textfile.write("-" * 40 + "\n")
                textfile.write(f"{email['content']}\n")
                textfile.write("=" * 80 + "\n\n")
        
        print(f"Text transcript exported: {filepath}")
    
    def export_all_conversations(self):
        """Export all conversations in both CSV and text formats"""
        os.makedirs(self.output_dir, exist_ok=True)
        
        exports = [
            ('dr_jen_housing', 'Dr_Jen_Housing_Conversations'),
            ('edith_property', 'Edith_Property_Conversations'),
            ('city_heat_complaints', 'City_Heat_Complaints'),
            ('nick_matt_concepts26', 'Nick_Matt_Concepts26_Conversations')
        ]
        
        for category, base_filename in exports:
            if self.conversations[category]:
                self.export_to_csv(category, f"{base_filename}.csv")
                self.export_to_text(category, f"{base_filename}.txt")
            else:
                print(f"No conversations found for {category}")


def main():
    # Configuration
    mbox_file = r"c:\Users\irato\Downloads\All mail Including Spam and Trash.mbox"
    output_directory = r"c:\Users\irato\OneDrive - Minnesota State\Civil 2025\Extracted_Conversations"
    
    print("EMAIL CONVERSATION EXTRACTOR")
    print("="*50)
    print(f"Input file: {mbox_file}")
    print(f"Output directory: {output_directory}")
    print()
    
    # Check if mbox file exists
    if not os.path.exists(mbox_file):
        print(f"ERROR: .mbox file not found at {mbox_file}")
        print("Please check the file path and try again.")
        return
    
    # Create extractor and process
    extractor = EmailTranscriber(mbox_file, output_directory)
    
    if extractor.parse_mbox():
        extractor.export_all_conversations()
        print("\n=== EXTRACTION COMPLETE ===")
        print(f"All conversation files saved to: {output_directory}")
        print("\nFiles created:")
        print("- CSV files (spreadsheet compatible)")
        print("- TXT files (court-ready transcripts)")
    else:
        print("ERROR: Failed to process mbox file")


if __name__ == "__main__":
    main()
