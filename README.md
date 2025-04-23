# Salesforce Developer Assignment – PagerDuty

## 👤 Test User

A test user was created with the email: `bae@pagerduty.com`.  
(If the username was already in use, a number was appended.)

---

## 🧩 Part 1 – Apex Trigger: Associate Contact to Account by Email Domain

### 🎯 Objective:
Automatically associate a newly created Contact with an existing Account based on the domain of the Contact’s email address.  
For example, a Contact with email `steve@blast.com` should be linked to an Account whose website is `https://www.blast.com`.

### ⚙️ How It Works:
- A `before insert` and `before update` trigger runs when a Contact is created or modified.
- If the Contact has no `AccountId`, the domain is extracted from the email.
- The system searches for Accounts whose `Website` contains that domain (after cleaning prefixes like `http`, `https`, `www`).
- If a match is found (even with variants like `.com.au`, `.com.ca`, etc.), the Account is assigned to the Contact.

### 📌 Key Considerations:
- The domain match is implemented as a *fuzzy match* (substring comparison).
- TLD flexibility is supported to account for international variations (e.g., `.com.au`, `.com.co`).

### 🧪 Test Class:
A test class is included that:
- Creates an Account with a sample website.
- Creates a Contact with a matching email domain.
- Verifies that the Contact is assigned to the Account.

---

## ⚡ Part 2 – Lightning Web Component (LWC): Contact Search by Domain

### 🎯 Objective:
Allow users to search for Contacts from the Home Page using a company website or domain.

### 📦 Components:

#### **Apex Controller – `ContactSearchController.cls`**
- Exposes a method `searchContactsByWebsite`.
- Cleans the input URL (`http`, `https`, `www`) and searches for Contacts whose email domain matches.

#### **Lightning Web Component – `contactSearch`**
- Input field to enter a website or domain.
- Button to trigger the search.
- Displays the following Contact fields:
  - Name
  - Email
  - Title
  - Created Date

### 🗂️ Files:

| File                        | Description                               |
|----------------------------|-------------------------------------------|
| `contactSearch.html`       | Markup structure                          |
| `contactSearch.js`         | Logic to handle input and call Apex       |
| `contactSearch.js-meta.xml`| Exposes the component on the Home Page    |

---

## ✅ How to Test

### Part 1:
1. Create an Account with a website like `https://www.blast.com`.
2. Create a Contact with email `someone@blast.com` and leave `AccountId` blank.
3. After insert, the Contact should be automatically assigned to the Account.

### Part 2:
1. Go to the Home Page in the Lightning App.
2. Add the `Contact Search by Domain` component.
3. Enter a website such as `www.blast.com` and click **Search**.
4. View matching Contacts displayed below the search box.

---
