<div align="center">
  <a href="../../README.md">⬅️ <b>Back to eJPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🎯 Vulnerability Assessment CTF 1 Walkthrough 🎯</h1>
  <p><b>Platform:</b> INE Security | <b>Learning Path:</b> Penetration Testing Student (eJPT v2) | <b>Course:</b> Assessment Methodologies: Vulnerability Assessment | <b>Difficulty:</b> Easy / Medium</p>
  <p><i>Date Completed: 16 October 2026</i></p>

[![Platform - INE](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=flat-square&logo=target)](https://ine.com/)
[![Track - eJPT](https://img.shields.io/badge/Track-eJPT%20v2-orange?style=flat-square&logo=hackthebox)](../../README.md)
[![Flags - 4/4](https://img.shields.io/badge/Flags%20Captured-4%20%2F%204-success?style=flat-square&logo=checkmarx)](./README.md)
[![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-T1595%20%7C%20T1078-red?style=flat-square)](https://attack.mitre.org/)
</div>

---

## 📋 Objective & Scope
> **Conduct comprehensive service enumeration and vulnerability assessment against `target.ine.local` (`192.220.66.3`). Identify exposed version control metadata, unauthenticated database management portals, server diagnostic pages, and sensitive directory indexing to extract all 4 MD5 flag hashes.**

- **Target Host:** `target.ine.local` (`192.220.66.3`)
- **Key Services Audited:** Apache 2.4.7 (Port 80), MySQL 5.5.47 (Port 3306), phpMyAdmin 3.5.2.2

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20115307.png" alt="INE Vulnerability Assessment CTF 1 lab dashboard and objective prompt view" width="750px">
  <br><i>Figure 1: INE Portal — Lab Environment, Objectives, and Task Prompts (0 of 4 flags captured).</i>
</div>

<br>

## 🛠️ Tools Used
| Tool | Purpose in Assessment |
| :--- | :--- |
| **Nmap** | Initial port scanning, service version detection, and script enumeration. |
| **DIRB** | Web content brute-forcing and directory discovery. |
| **Gobuster** | High-speed directory brute-forcing with `directory-list-2.3-medium.txt`. |
| **Firefox & DevTools** | Web interface interaction, directory browsing, and page inspection. |
| **phpMyAdmin** | Interacting with unauthenticated MySQL database management portal. |

<br>

---

## 🗺️ MITRE ATT&CK® Enterprise Mapping
| Tactic | Technique ID | Technique Name | Description in Lab |
| :--- | :--- | :--- | :--- |
| **Reconnaissance** | `T1595.002` | Active Scanning: Vulnerability Scanning | Service banner grabbing and directory enumeration |
| **Discovery** | `T1083` | File and Directory Discovery | Discovering exposed `.git/` metadata and `/passwords/` directories |
| **Initial Access** | `T1078.001` | Valid Accounts: Default Accounts | Logging into phpMyAdmin with administrative root privileges without authentication |
| **Collection** | `T1005` | Data from Local System | Dumping rows from `mysql.secret_info` table |

<br>

---

## 🔍 1. Reconnaissance & Service Fingerprinting

### 🌐 Network & Service Scanning
We begin by running a standard Nmap service version and default script scan (`-sV -sC`) against `target.ine.local`:

```bash
nmap -sV -sC target.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20120107.png" alt="Nmap service scan showing Apache 2.4.7 and MySQL 5.5.47 open ports" width="750px">
  <br><i>Figure 2: Nmap scan output revealing Apache 2.4.7, MySQL 5.5.47, robots.txt entries, and exposed Git repository.</i>
</div>

### 📋 Port Scan Findings:
- **Port 80/tcp (HTTP):** `Apache httpd 2.4.7 ((Ubuntu))`
  - **Robots.txt:** 8 disallowed entries: `passwords/`, `config.inc`, `classes/`, `javascript/`, `_owasp-esapi-php/`, `documentation/`, `phpmyadmin/`, `includes/`.
  - **Exposed Git VCS:** Script `http-git` flags an exposed `.git/` repository at `http://192.220.66.3:80/.git/` referencing remote `hello-world-lamp.git`.
  - **Session Tracking:** Issues `PHPSESSID` cookies without the `HttpOnly` flag.
- **Port 3306/tcp (MySQL):** `MySQL 5.5.47-0ubuntu0.14.04.1`.

<br>

### 📂 Directory & Content Discovery
We run automated directory discovery with **DIRB** to map endpoints across the web application:

```bash
dirb http://target.ine.local/
```

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20124320.png" alt="DIRB directory enumeration discovering git repository and phpmyadmin" width="750px">
  <br><i>Figure 3: DIRB scan reveals exposed /.git/HEAD, /passwords/, /phpinfo.php, and /phpmyadmin/ endpoints.</i>
</div>

<br>

---

## ⚡ 2. Flag Acquisition & Methodology

> **Note on Submission Format:**  
> Flags follow the pattern `FLAG<N>_<MD5_HASH>`. The INE platform requires submitting **only the 32-character MD5 hash** string.

---

### 🚩 Flag 1: Exposed Version Control Artifacts (`/.git/`)
**Prompt:** *"Explore hidden directories for version control artifacts that might reveal valuable information."*

The Nmap and DIRB scans confirmed the presence of an exposed `.git/` directory. Navigating directly to `http://target.ine.local/.git/` reveals that Apache directory indexing is fully enabled:

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20120323.png" alt="Apache directory indexing of .git folder showing internal files" width="750px">
  <br><i>Figure 4: Apache directory listing of /.git/ exposing version control internals and flag.txt.</i>
</div>

Among the Git internals (`HEAD`, `config`, `objects/`, `refs/`), a file named `flag.txt` is directly accessible. Opening `http://target.ine.local/.git/flag.txt` reveals Flag 1:

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20120427.png" alt="Browser view of flag.txt in git folder showing Flag 1" width="750px">
  <br><i>Figure 5: Inspecting flag.txt within /.git/ to extract Flag 1.</i>
</div>

```text
FLAG1_5a0badfb52164a4cb9259fc078b914dc
```
- **Submitted Hash:** `5a0badfb52164a4cb9259fc078b914dc`

---

### 🚩 Flag 2: Unauthenticated Database Management (`phpMyAdmin`)
**Prompt:** *"The data storage has some loose security measures. Can you find the flag hidden within it?"*

The `robots.txt` and Gobuster scans identified the `/phpmyadmin/` endpoint. Browsing to `http://target.ine.local/phpmyadmin/` reveals that the administrative console permits passwordless access directly as `root@localhost`:

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20123003.png" alt="phpMyAdmin dashboard accessed without credentials as root user" width="750px">
  <br><i>Figure 6: phpMyAdmin 3.5.2.2 dashboard showing authenticated access as root@localhost with no password required.</i>
</div>

Selecting the system database `mysql` reveals its underlying table structure:

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20122909.png" alt="phpMyAdmin table view of mysql database showing secret_info table" width="750px">
  <br><i>Figure 7: Inspecting tables within the mysql database, highlighting the custom secret_info table.</i>
</div>

Navigating to the `secret_info` table and viewing its records reveals Flag 2:

```sql
SELECT * FROM `secret_info` LIMIT 0, 30;
```

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20122433.png" alt="SQL query results on secret_info table showing Flag 2 hash" width="750px">
  <br><i>Figure 8: Querying the secret_info table exposes Flag 2.</i>
</div>

```text
FLAG2_e9940f29dcf34df7a03420c13ff93df2
```
- **Submitted Hash:** `e9940f29dcf34df7a03420c13ff93df2`

---

### 🚩 Flag 3: Server Information Diagnostic Disclosure (`phpinfo.php`)
**Prompt:** *"A PHP file that displays server information might be worth examining. What could be hidden in plain sight?"*

DIRB directory brute-forcing discovered a diagnostic script located at `http://target.ine.local/phpinfo.php`:

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20124029.png" alt="DIRB command line output discovering phpinfo.php" width="750px">
  <br><i>Figure 9: DIRB scan identifying phpinfo.php returning HTTP 200 OK.</i>
</div>

Browsing to `http://target.ine.local/phpinfo.php` displays the complete PHP 5 runtime configuration. Under the `apache2handler` section, the `Server Administrator` directive is configured with Flag 3:

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20124248.png" alt="phpinfo page displaying Server Administrator value containing Flag 3" width="750px">
  <br><i>Figure 10: Inspecting phpinfo() reveals Flag 3 embedded in the Server Administrator field.</i>
</div>

```text
Server Administrator: FLAG3_828cd5b4e87f4c038711f54a2191a884
```
- **Submitted Hash:** `828cd5b4e87f4c038711f54a2191a884`

---

### 🚩 Flag 4: Sensitive Directory Indexing (`/passwords/`)
**Prompt:** *"Sensitive directories might hold critical information. Search through carefully for hidden gems."*

Using **Gobuster** with `directory-list-2.3-medium.txt` and examining `robots.txt` confirms the existence of the `/passwords/` directory:

```bash
gobuster dir -u http://target.ine.local -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20123106.png" alt="Gobuster terminal scan discovering passwords folder" width="750px">
  <br><i>Figure 11: Gobuster scan discovering /passwords/ returning HTTP 301 redirect.</i>
</div>

Navigating to `http://target.ine.local/passwords/` shows that directory listing is enabled:

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20123237.png" alt="Directory listing of passwords folder showing accounts.txt and flag.txt" width="750px">
  <br><i>Figure 12: Directory index of /passwords/ showing accounts.txt and flag.txt.</i>
</div>

Opening `http://target.ine.local/passwords/flag.txt` yields Flag 4:

<div align="center">
  <img src="./images/Screenshot%202026-10-16%20123302.png" alt="Browser view of passwords flag.txt displaying Flag 4" width="750px">
  <br><i>Figure 13: Extracting Flag 4 from /passwords/flag.txt.</i>
</div>

```text
FLAG4_0f7c0821ee32479e9778ce1c7aae0411
```
- **Submitted Hash:** `0f7c0821ee32479e9778ce1c7aae0411`

<br>

---

## 🏁 3. Flags Summary

| Flag # | Challenge Prompt | Extracted Flag | Submitted Hash | Discovery Vector |
| :---: | :--- | :--- | :--- | :--- |
| **1** | Version control artifacts | `FLAG1_5a0badfb52164a4cb9259fc078b914dc` | `5a0badfb52164a4cb9259fc078b914dc` | Exposed Git repository (`/.git/flag.txt`) |
| **2** | Loose data storage security | `FLAG2_e9940f29dcf34df7a03420c13ff93df2` | `e9940f29dcf34df7a03420c13ff93df2` | Unauthenticated phpMyAdmin (`mysql.secret_info`) |
| **3** | Server information PHP file | `FLAG3_828cd5b4e87f4c038711f54a2191a884` | `828cd5b4e87f4c038711f54a2191a884` | Diagnostic disclosure in `phpinfo.php` |
| **4** | Sensitive directory contents | `FLAG4_0f7c0821ee32479e9778ce1c7aae0411` | `0f7c0821ee32479e9778ce1c7aae0411` | Directory indexing in `/passwords/flag.txt` |

<br>

---

## 🛡️ 4. Vulnerability Risk Ratings & Defensive Hardening

### 📊 CVSS v3.1 Findings Matrix
| Finding | Severity | CVSS v3.1 Score | Vector String |
| :--- | :---: | :---: | :--- |
| **Unauthenticated Database Administration Portal (phpMyAdmin)** | 🔴 **Critical** | **9.8** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` |
| **Exposed Version Control Metadata (`.git`)** | 🔴 **High** | **7.5** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N` |
| **Diagnostic Information Disclosure (`phpinfo()`)** | 🟡 **Medium** | **5.3** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N` |
| **Sensitive Directory Listing (`/passwords/`)** | 🟡 **Medium** | **5.3** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N` |

<br>

<details>
<summary><b>Click to expand remediation strategies & secure configurations</b></summary>
<br>

### 📌 1. Unauthenticated Database Management (`phpMyAdmin`)
- **Root Cause:** phpMyAdmin was deployed without access control or authentication, allowing anonymous external users to manage the MySQL database as `root`.
- **Remediation:** Enforce strong authentication, restrict phpMyAdmin access to internal IPs or loopback interface (`127.0.0.1`), or implement HTTP basic authentication:
  ```apache
  <Directory /usr/share/phpmyadmin>
      Require ip 127.0.0.1 10.0.0.0/8
  </Directory>
  ```

### 📌 2. Exposed Version Control Metadata (`.git`)
- **Root Cause:** Deploying a live web root containing `.git` repositories allows attackers to download source code, commit history, configuration keys, and database credentials.
- **Remediation:** Remove VCS metadata before production deployment and deny access at the web server level:
  ```apache
  <DirectoryMatch "^\.|\/\.">
      Require all denied
  </DirectoryMatch>
  ```

### 📌 3. Diagnostic & Information Disclosure (`phpinfo()`)
- **Root Cause:** Diagnostic files exposing `phpinfo()` disclose exact PHP/module versions, environmental paths, internal IPs, and server directives.
- **Remediation:** Delete all `phpinfo.php` scripts from production environments. Disable dangerous debugging functions in `php.ini`:
  ```ini
  disable_functions = phpinfo, system, exec, shell_exec, passthru
  ```

### 📌 4. Enabled Directory Browsing (Directory Indexing)
- **Root Cause:** Apache directory listing (`mod_autoindex`) allowed attackers to list and browse files within `/passwords/` and `/.git/`.
- **Remediation:** Disable directory indexing globally across the web server configuration:
  ```apache
  <Directory /var/www/html>
      Options -Indexes
  </Directory>
  ```
</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **Robots.txt as an Attack Roadmap:** Entries placed in `robots.txt` intended to restrict search engines often serve as direct signposts for penetration testers to discover sensitive directories (`passwords/`, `phpmyadmin/`).
- **Dangerous Defaults in Production:** Default software installations (such as unauthenticated phpMyAdmin packages) pose immediate critical threats to confidentiality and data integrity.
- **Defense in Depth:** Disabling directory browsing (`Options -Indexes`) combined with strict `.git` access denial eliminates opportunistic metadata harvesting.

---
<div align="center">
  <i>Walkthrough compiled on 16 October 2026. Documented for INE Penetration Testing Student (eJPT) certification path.</i>
</div>
