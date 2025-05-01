#!/bin/python3

#TODO: Add functionality to extract phone numbers and email addresses from a choice between a file or clipboard

import re, pyperclip

phoneRegex = re.compile(r'''             # 111-111-1111, 111-1111, (111) 111-1111, 111-1111 ext 11119, ext. 11119, x11119
(
((\d\d\d) | (\(\d\d\d\)))?  # area code (optional with or without parentheses)
(\s|-)                      # first separator
\d\d\d                      # first 3 digits
-                           # separator
\d\d\d\d                    # last 4 digits
((((\s)?ext (\.)?\s) |(\s)?x)         # extension word (optional)
(\d{2,5}))?                 # extension number (optional)
)''', re.VERBOSE)

emailRegex = re.compile(r'''
([a-zA-Z0-9_.+]+      # name part
@                     # @ symbol
[a-zA-Z0-9-_]+          # domain name part
\.[a-zA-Z.]{2,10}+
)   # TLD part
''', re.VERBOSE)

text = pyperclip.paste()  # get text from clipboard

# Test text
""" text = '''
Here is the contact information you requested.

Main office line: 416-555-1234. Please call during business hours.
You can also reach Alice at (212) 987-6543 for urgent matters.
Her email is alice.wonder@example.com.

For technical support, call 800-111-2222 ext 101 or email support@tech-corp.net.
Bob's direct line is 604 555-9988 x12345, or email bob_the_builder+projects@sample.org.
Try the fax at (310) 123-4567 ext. 99 if needed.

More contacts:
- Jane Doe: jane.doe@company.co.uk, Mobile: 778-111-0000
- Mark Smith: mark@smith.io, Office: (408) 444-5555 x77

General inquiries: info@company.net.
Sales department: sales+us@region.domain.info

Remember the old number 905-999-9999 is no longer in service.
Contact us at feedback_dept@my-domain.com or call (888) 555-1212 ext 500.
Another number is 250 867-5309.
''' """


extractedPhoneNumbers = phoneRegex.findall(text)  # find all phone numbers
extreactedEmailAddresses = emailRegex.findall(text)  # find all email addresses

allPhoneNumbers = []  # list to hold all phone numbers
for phoneNumber in extractedPhoneNumbers:
    allPhoneNumbers.append(phoneNumber[0])  # append the phone number to the list

results = '\n'.join(allPhoneNumbers) + '\n'.join(extreactedEmailAddresses) 

print(results)  # print the results
pyperclip.copy(results) # copy the results to the clipboard