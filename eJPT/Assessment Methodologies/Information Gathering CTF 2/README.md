<div align="center">
  <a href="../../README.md">⬅️ <b>Back to eJPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🎯 Information Gathering — Skill Check Lab 2 Walkthrough 🎯</h1>
  <p><b>Platform:</b> INE Security | <b>Learning Path:</b> Penetration Testing Student (eJPT v2) | <b>Course:</b> Assessment Methodologies: Information Gathering | <b>Difficulty:</b> Easy / Medium</p>
  <p><i>Date Completed: 14 October 2026</i></p>

[![Platform - INE](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=flat-square&logo=target)](https://ine.com/)
[![Track - eJPT](https://img.shields.io/badge/Track-eJPT%20v2-orange?style=flat-square&logo=hackthebox)](../../README.md)
[![Flags - 4/4](https://img.shields.io/badge/Flags%20Captured-4%20%2F%204-success?style=flat-square&logo=checkmarx)](./README.md)
[![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-T1595%20%7C%20T1078-red?style=flat-square)](https://attack.mitre.org/)
</div>

---

## 📋 Objective & Scope
> **Conduct comprehensive network service reconnaissance and web enumeration against `http://target.ine.local` (`192.198.222.3`). Identify exposed banners, robots directives, anonymous FTP shares, and leaked database configurations to extract all 4 MD5 flag hashes.**

- **Target Host:** `target.ine.local` (`192.198.222.3`)
- **Key Services Audited:** vsftpd 3.0.5 (Port 21), OpenSSH 8.9p1 (Port 22), Werkzeug HTTP (Port 80), MySQL (Port 3306)

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20131940.png" alt="INE Assessment Methodologies Lab 2 environment briefing and objectives" width="750px">
  <br><i>Figure 1: INE Lab Environment and Objectives for Information Gathering CTF 2.</i>
</div>

<br>

## 🛠️ Tools Used
| Tool | Purpose in Assessment |
| :--- | :--- |
| **Nmap** | Host discovery, port scanning, and service version enumeration. |
| **cURL / Firefox** | HTTP banner inspection and endpoint probing. |
| **FTP Client** | Anonymous FTP authentication and remote file retrieval. |
| **MySQL Client** | Connecting to remote database using harvested credentials. |
| **DIRB** | Web content and robots file verification. |

<br>

---

## 🗺️ MITRE ATT&CK® Enterprise Mapping
| Tactic | Technique ID | Technique Name | Description in Lab |
| :--- | :--- | :--- | :--- |
| **Reconnaissance** | `T1595.002` | Active Scanning: Vulnerability Scanning | Service banner grabbing and aggressive port scanning |
| **Initial Access** | `T1078.001` | Valid Accounts: Default Accounts | Anonymous FTP authentication (`ftp:anonymous`) |
| **Discovery** | `T1083` | File and Directory Discovery | Listing FTP directories and crawling `/secret-info/` |
| **Credential Access** | `T1552.001` | Unsecured Credentials: Credentials in Files | Extracting plaintext MySQL credentials from `creds.txt` |
| **Collection** | `T1005` | Data from Local System | Querying MySQL schema to dump database name flag |

<br>

---

## 🔍 1. Network Reconnaissance & Port Scanning

### 🌐 Service Fingerprinting
We execute an Nmap aggressive service scan (`-sV -sC`) against the target host `target.ine.local`:

```bash
nmap -sV -sC target.ine.local
```

**Port Scan Results:**
- **21/tcp:** `vsftpd 3.0.5` — **Anonymous FTP login allowed!** Files found: `creds.txt`, `flag.txt`.
- **22/tcp:** `OpenSSH 8.9p1` (Ubuntu Linux).
- **25/tcp:** `Postfix smtpd`.
- **80/tcp:** `Werkzeug 3.0.6` (Python 3.10.12).
- **Robots.txt:** 3 disallowed entries: `/_photos`, `/secret-info/`, `/data/`.

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132257.png" alt="Nmap port scan results showing open FTP, SSH, SMTP, and HTTP ports" width="750px">
  <br><i>Figure 2: Comprehensive Nmap scan exposing FTP, SSH, SMTP, and Werkzeug HTTP services.</i>
</div>

<br>

---

## ⚡ 2. Flag Acquisition & Exploitation

> **Note on Submission Format:**  
> Flags follow the pattern `FLAG<N>_<MD5_HASH>`. The lab platform requires submitting **only the 32-character MD5 hash** without the `FLAG<N>_` prefix.

---

### 🚩 Flag 1: HTTP Response Server Banner
**Prompt:** *"The server announces its identity in every single response."*

By executing an HTTP header request using `curl -I`:

```bash
curl -I http://target.ine.local/
```

**Response:**
```http
HTTP/1.0 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 1040
Server: FLAG1_77f8f6c7f5bf42ff849b45249e767ce5
Date: Mon, 14 Oct 2026 13:23:05 GMT
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132325.png" alt="cURL HTTP response headers revealing Flag 1 in Server header" width="750px">
  <br><i>Figure 3: Inspecting HTTP response headers reveals Flag 1 in the custom Server banner.</i>
</div>

- **Submitted Hash:** `77f8f6c7f5bf42ff849b45249e767ce5`

---

### 🚩 Flag 2: Search Engine Directives (`robots.txt`)
**Prompt:** *"Search engines look for the gatekeeper's instructions."*

Navigating to `http://target.ine.local/robots.txt`:

```text
User-agent: *
Disallow: /_photos
Disallow: /secret-info/
Disallow: /data/
```

We probe the disallowed `/secret-info/` directory:

```bash
curl http://target.ine.local/secret-info/
```

The server returns an index containing `flag.txt`. Fetching `http://target.ine.local/secret-info/flag.txt`:

```text
FLAG2_73ef9217b4f24c1aa17f66a834c998bc
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132428.png" alt="Browser view of secret-info directory revealing Flag 2" width="750px">
  <br><i>Figure 4: Navigating to the disallowed endpoint reveals Flag 2 in plaintext.</i>
</div>

- **Submitted Hash:** `73ef9217b4f24c1aa17f66a834c998bc`

---

### 🚩 Flag 3: Insecure Anonymous FTP Access
**Prompt:** *"Forgotten treasures may be accessible without credentials."*

The Nmap scan showed `vsftpd` configured with anonymous access. We connect using the standard `anonymous` username:

```bash
ftp target.ine.local
# Name: anonymous
# Password: [blank]
```

```text
ftp> ls -la
-rw-r--r--    1 0        0              41 Oct 14 13:20 creds.txt
-rw-r--r--    1 0        0              38 Oct 14 13:20 flag.txt
ftp> get flag.txt
ftp> get creds.txt
ftp> bye
```

Reading `flag.txt`:

```bash
cat flag.txt
```

```text
FLAG3_99a0590109ce4ac695a4df2cc563302c
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132604.png" alt="Anonymous FTP login and file download session" width="750px">
  <br><i>Figure 5: Authenticating anonymously via FTP and downloading flag.txt and creds.txt.</i>
</div>

- **Submitted Hash:** `99a0590109ce4ac695a4df2cc563302c`

---

### 🚩 Flag 4: Database Credential Pivot & Schema Enumeration
**Prompt:** *"A well-named database can tell you a lot about its purpose."*

Inspecting `creds.txt` retrieved from the FTP share:

```bash
cat creds.txt
```

```text
mysql_user: root
mysql_pass: password@123
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132544.png" alt="Terminal displaying extracted MySQL database credentials" width="750px">
  <br><i>Figure 6: Leaked MySQL credentials discovered inside the FTP share.</i>
</div>

We connect directly to the MySQL database on port 3306:

```bash
mysql -h target.ine.local -u root -p'password@123'
```

Querying available databases:

```sql
SHOW DATABASES;
```

```text
+------------------------------------------+
| Database                                 |
+------------------------------------------+
| FLAG4_2f7d6ae25f4c4de19c2ac1b04f449b3b   |
| information_schema                       |
| mysql                                    |
| performance_schema                       |
| sys                                      |
+------------------------------------------+
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132507.png" alt="MySQL console output showing Flag 4 embedded as a database name" width="750px">
  <br><i>Figure 7: Database enumeration unveils Flag 4 as the custom database name.</i>
</div>

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20130412.png" alt="INE assessment verification screen showing all flags validated" width="750px">
  <br><i>Figure 8: Lab assessment submission verifying all 4 flag hashes captured.</i>
</div>

- **Submitted Hash:** `2f7d6ae25f4c4de19c2ac1b04f449b3b`

<br>

---

## 🏁 3. Flags Summary

| Flag # | Challenge Description | Full Value | Submitted MD5 Hash | Source |
| :---: | :--- | :--- | :--- | :--- |
| **Flag 1** | Server announces identity in every response | `FLAG1_77f8f6c7f5bf42ff849b45249e767ce5` | `77f8f6c7f5bf42ff849b45249e767ce5` | HTTP `Server:` Header |
| **Flag 2** | Gatekeeper's instructions (robots.txt) | `FLAG2_73ef9217b4f24c1aa17f66a834c998bc` | `73ef9217b4f24c1aa17f66a834c998bc` | `/secret-info/flag.txt` |
| **Flag 3** | Anonymous access to forgotten treasures | `FLAG3_99a0590109ce4ac695a4df2cc563302c` | `99a0590109ce4ac695a4df2cc563302c` | Anonymous FTP `flag.txt` |
| **Flag 4** | A well-named database configuration | `FLAG4_2f7d6ae25f4c4de19c2ac1b04f449b3b` | `2f7d6ae25f4c4de19c2ac1b04f449b3b` | MySQL Database Name |

<br>

---

## 🛡️ 4. Vulnerability Risk Ratings & Defensive Hardening

### 📊 CVSS v3.1 Findings Matrix
| Finding | Severity | CVSS v3.1 Score | Vector String |
| :--- | :---: | :---: | :--- |
| **Remote Database Access with Weak Credentials** | 🔴 **Critical** | **9.1** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N` |
| **Anonymous FTP Read Access with Credential Leakage** | 🔴 **High** | **7.5** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N` |
| **HTTP Server Banner Information Disclosure** | 🟡 **Medium** | **5.3** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N` |

<br>

<details>
<summary><b>Click to expand remediation strategies & secure configurations</b></summary>
<br>

### 1. Anonymous FTP Access & Credential Storage
- **Root Cause:** `vsftpd` allowed unauthenticated anonymous logins with read permissions in a folder containing administrative database credentials.
- **Remediation:** Disable anonymous logins in `/etc/vsftpd.conf`:
  ```ini
  anonymous_enable=NO
  ```
  Ensure permissions on credential files are restricted to local administrative users (`chmod 600 creds.txt`).

### 2. External Network MySQL Access
- **Root Cause:** MySQL was bound to `0.0.0.0`, allowing remote network connections without firewall or IP access control restrictions.
- **Remediation:** Bind the database listener exclusively to the local loopback interface in `/etc/mysql/my.cnf`:
  ```ini
  [mysqld]
  bind-address = 127.0.0.1
  ```
  Enforce strong password complexity policies for all database accounts.

### 3. Verbose HTTP Server Headers
- **Root Cause:** The WSGI server returned custom internal headers identifying sensitive build and server details.
- **Remediation:** Configure a reverse proxy (e.g., Nginx) in front of the application to strip or overwrite the `Server` header:
  ```nginx
  proxy_hide_header Server;
  ```
</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **Cross-Service Pivoting:** Reconnaissance findings often chain together — the anonymous FTP share provided credentials that directly unlocked the MySQL service.
- **Header Analysis is Low-Hanging Fruit:** Always analyze full HTTP headers (`curl -I`) as application developers frequently leave debug headers or tokens.
- **Service Hardening Matters:** Restricting default accounts and disabling anonymous access eliminates critical initial foothold vectors.

---
<div align="center">
  <i>Walkthrough documented on 14 October 2026. Part of the INE eJPT Certification Journey.</i>
</div>
