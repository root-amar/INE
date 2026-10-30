<div align="center">
  <a href="../README.md">⬅️ <b>Back to Main Repository</b></a>
</div>

<br>

<div align="center">

# 🎯 INE Labs — Penetration Testing Student (eJPT) Portfolio

<p>
  <b>Practical hands-on lab solutions, CTF walk-throughs, and vulnerability assessment notes for the eLearnSecurity Junior Penetration Tester certification.</b>
</p>

[![Learning Path](https://img.shields.io/badge/Learning%20Path-Penetration%20Testing%20Student%20(PTS)-0078D4?style=for-the-badge&logo=target&logoColor=white)](https://ine.com/)
[![Certification](https://img.shields.io/badge/Certification-eJPT%20v2-orange?style=for-the-badge&logo=hackthebox&logoColor=white)](https://elearnsecurity.com/)
[![Labs Status](https://img.shields.io/badge/Completed-7%20Labs%20(100%25)-success?style=for-the-badge&logo=checkmarx&logoColor=white)](./README.md)
[![Flag Score](https://img.shields.io/badge/Flags%20Captured-29%20%2F%2029-brightgreen?style=for-the-badge&logo=adblock&logoColor=white)](./README.md)
[![Standards](https://img.shields.io/badge/Standards-MITRE%20ATT%26CK%20%7C%20CVSS%20v3.1-red?style=for-the-badge&logo=shield&logoColor=white)](https://attack.mitre.org/)

</div>

---

## 📊 Training Track & Progress Scorecard

| Metric | Details |
| :--- | :--- |
| **Training Platform** | **INE** (Interactive Network Experts) |
| **Learning Path** | **Penetration Testing Student (PTS)** |
| **Target Certification** | **eJPT** (Junior Penetration Tester Certification) |
| **Active Sections** | **Section 2: Assessment Methodologies**, **Section 4: Host & Network Penetration Testing**, **Section 5: Web Application Penetration Testing** |
| **Active Courses** | **Information Gathering**, **Vulnerability Assessment**, **System/Host Based Attacks**, **Exploitation**, **Introduction to Web & HTTP** |
| **Skill Checks Completed** | **7 Labs** (100% flag capture rate) |
| **Total Flags Captured** | **29 / 29** (5 in AM Lab 1, 4 in AM Lab 2, 4 in AM Lab 3, 4 in AM Lab 4, 4 in HN Lab 1, 4 in HN Lab 2, 4 in WA Lab 1) |
| **Documentation Standards** | **MITRE ATT&CK® Enterprise** mapping, **CVSS v3.1** risk scoring, reproducible commands |

<br>

---

## 🏆 Completed Labs & Skill Checks

| Date | Section / Course | Challenge / Lab | Difficulty | Flags Captured | Key Methodologies & Techniques | Walkthrough |
| :--- | :--- | :--- | :---: | :---: | :--- | :---: |
| 2026-10-14 | Assessment Methodologies: Information Gathering | Skill Check Lab 1 | Easy / Medium | 5 / 5 | Robots.txt inspection, HTML meta generator analysis, DIRB wordlist fuzzing (`big.txt`), `.bak` backup file extraction (`wp-config.bak`), HTTrack site mirroring | [Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%201/README.md) |
| 2026-10-14 | Assessment Methodologies: Information Gathering | Skill Check Lab 2 | Easy / Medium | 4 / 4 | HTTP server banner disclosure, hidden paths via robots.txt, vsftpd anonymous access & credential extraction, MySQL database enumeration | [Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%202/README.md) |
| 2026-10-15 | Assessment Methodologies: Information Gathering | Skill Check Lab 3 | Intermediate | 4 / 4 | Full TCP port scanning (`-p-`), custom Samba share fuzzing (`pubfiles`), Metasploit SID lookup (`smb_lookupsid`), SMB dictionary attack (`josh:purple`), vsftpd banner analysis & Hydra cracking (`alice:pretty`), OpenSSH pre-login warning banner inspection | [Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%203/README.md) |
| 2026-10-16 | Assessment Methodologies: Vulnerability Assessment | Skill Check Lab 1 (CTF 4) | Easy / Medium | 4 / 4 | Nmap service enumeration, exposed `.git/` directory indexing, unauthenticated phpMyAdmin root access (`mysql.secret_info`), diagnostic disclosure via `phpinfo.php`, and `/passwords/` directory browsing | [Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%204/README.md) |
| 2026-10-18 | Host & Network Penetration Testing: System/Host Based Attacks | Skill Check Lab 1 (CTF 1) | Easy / Medium | 4 / 4 | HTTP Basic Auth cracking (`bob`), WebDAV ASP webshell upload & execution, SMB brute-forcing (`administrator:pineapple`), Metasploit PsExec Meterpreter session, FreeRDP desktop access | [Walkthrough](./Host%20&%20Network%20Penetration%20Testing/System-Host%20Based%20Attacks%20CTF%201/README.md) |
| 2026-10-28 | Host & Network Penetration Testing: Exploitation | Skill Check Lab 1 (CTF 1) | Easy / Medium | 4 / 4 | FlatCore CMS 2.0.7 Authenticated RCE (`50262.py`), OpenSSH brute-force (`iamaweakuser:angel`), WordPress Duplicator 1.3.26 Arbitrary File Read (CVE-2020-11738), Passwordless SSH access (`iamacrazyfreeuser`) | [Walkthrough](./Host%20&%20Network%20Penetration%20Testing/Exploitation%20CTF%201/README.md) |
| 2026-10-30 | Web Application Penetration Testing: Introduction to Web & HTTP | Skill Check Lab 1 (CTF 1) | Easy / Medium | 4 / 4 | Local File Inclusion / Path Traversal (`view_file?file=/flag.txt`), Gobuster directory fuzzing (`/secured/`), THC-Hydra HTTP POST login brute-force (`guest:butterfly1`), SQL Injection authentication bypass (`admin' OR 1=1-- -`) | [Walkthrough](./Web%20Application%20Penetration%20Testing/Web%20Application%20Penetration%20Testing%20CTF%201/README.md) |

<br>

---

## 🔬 Course Breakdown: Assessment Methodologies

### 🎯 Course: Information Gathering

#### Skill Check Lab 1: Web & Application Reconnaissance
- **Scope:** `http://target.ine.local` (`192.42.203.3`)
- **Key Techniques:** Passive and active information gathering, inspecting crawler rules in `robots.txt`, analyzing CMS version leakage in `<meta name="generator">`, detecting exposed configuration backups with DIRB and custom extension flags (`.bak`, `.tar.gz`), and performing full offline site mirroring with HTTrack.
- **Flags Captured:** 5 of 5 (`FLAG1` to `FLAG5`).
- **Full Write-up:** [Read Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%201/README.md)

#### Skill Check Lab 2: Network Service Fingerprinting & Database Auditing
- **Scope:** `http://target.ine.local` (`192.198.222.3`)
- **Key Techniques:** Full service version fingerprinting with Nmap, identifying custom HTTP response headers (`Server: FLAG1_...`), navigating disallowed crawler endpoints in `robots.txt`, exploiting anonymous vsftpd access to retrieve database credentials, and connecting remotely to MySQL to dump the secret records table.
- **Flags Captured:** 4 of 4 (`FLAG1` to `FLAG4` MD5 hashes).
- **Full Write-up:** [Read Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%202/README.md)

#### Skill Check Lab 3: Samba Fuzzing, MSRPC SID Lookup & Protocol Chaining
- **Scope:** `target.ine.local` (`192.126.190.3`)
- **Key Techniques:** Executing full TCP range scans (`-p-`) to discover non-standard services (vsftpd on port 5554), writing a custom bash wordlist script (`share.sh`) to locate the anonymous `pubfiles` SMB share, utilizing Metasploit's MSRPC SID lookup (`smb_lookupsid`) to extract valid local usernames, dictionary cracking SMB passwords (`josh:purple`), parsing vsftpd pre-login reminders to target weak accounts with Hydra (`alice:pretty`), and capturing legal warning banners over OpenSSH (`/etc/issue.net`).
- **Flags Captured:** 4 of 4 (`FLAG1` to `FLAG4` MD5 hashes).
- **Full Write-up:** [Read Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%203/README.md)

### 🎯 Course: Vulnerability Assessment

#### Skill Check Lab 1 (CTF 4): Web Misconfigurations, Exposed VCS & Unauthenticated Consoles
- **Scope:** `target.ine.local` (`192.220.66.3`)
- **Key Techniques:** Identifying exposed `.git/` repository with enabled directory browsing to extract secret files, accessing unauthenticated phpMyAdmin consoles running as `root@localhost` to extract sensitive database rows (`secret_info`), leveraging DIRB to uncover `phpinfo.php` diagnostic pages disclosing internal server variables, and discovering exposed credential storage in `/passwords/`.
- **Flags Captured:** 4 of 4 (`FLAG1` to `FLAG4` MD5 hashes).
- **Full Write-up:** [Read Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%204/README.md)

<br>

---

## 🔬 Course Breakdown: Host & Network Penetration Testing

### 🎯 Course: System/Host Based Attacks

#### Skill Check Lab 1: WebDAV Exploitation, SMB Credential Attacks & Remote Desktop Access
- **Scope:** `target1.ine.local` (`10.5.17.248`), `target2.ine.local` (`10.5.16.171`)
- **Key Techniques:** Automated HTTP Basic Auth cracking with THC-Hydra (`bob`), WebDAV method and execution verification using DAVTest, interactive WebDAV file management via Cadaver, uploading an ASP webshell for remote command execution on IIS 10.0, SMB dictionary attack against Windows Server (`administrator:pineapple`), Metasploit PsExec service injection for Meterpreter access, and FreeRDP graphical administrative session.
- **Flags Captured:** 4 of 4 (`FLAG1` to `FLAG4` MD5 hashes).
- **Full Write-up:** [Read Walkthrough](./Host%20&%20Network%20Penetration%20Testing/System-Host%20Based%20Attacks%20CTF%201/README.md)

<br>

### 🎯 Course: Exploitation

#### Skill Check Lab 1 (CTF 1): Web Application RCE, OpenSSH Brute-Force & WordPress Arbitrary File Read
- **Scope:** `target1.ine.local` (`192.225.24.3`), `target2.ine.local` (`192.116.99.4`)
- **Key Techniques:** FlatCore CMS 2.0.7 ACP authentication (`admin:password1`), authenticated arbitrary file upload exploit (`50262.py` / CVE-2021-39608) yielding interactive web shell (`www-data`), `/etc/passwd` enumeration, THC-Hydra dictionary attack cracking SSH credentials (`iamaweakuser:angel`), WordPress plugin enumeration discovering Duplicator 1.3.26, Metasploit arbitrary file read module (`auxiliary/scanner/http/wp_duplicator_file_read` / CVE-2020-11738) extracting `/flag3.txt` and `/etc/passwd`, and passwordless SSH compromise of account `iamacrazyfreeuser`.
- **Flags Captured:** 4 of 4 (`FLAG1` to `FLAG4` MD5 hashes).
- **Full Write-up:** [Read Walkthrough](./Host%20&%20Network%20Penetration%20Testing/Exploitation%20CTF%201/README.md)

<br>

---

## 🔬 Course Breakdown: Web Application Penetration Testing

### 🎯 Course: Introduction to the Web & HTTP Protocol

#### Skill Check Lab 1 (CTF 1): LFI / Path Traversal, Directory Fuzzing, Credential Attacks & SQLi Auth Bypass
- **Scope:** `http://target.ine.local` (`192.162.243.3`)
- **Key Techniques:** Nmap service fingerprinting identifying Gunicorn WSGI HTTP server, Local File Inclusion (LFI) via `/view_file?file=/flag.txt` extracting Flag 1 from the filesystem root, Gobuster directory brute-forcing with `common.txt` revealing hidden `/secured/` endpoint listing sensitive JSON artifacts (`flag.txt`), THC-Hydra dictionary attack on HTTP POST login form cracking credentials (`guest:butterfly1`) to extract Flag 3 from user profile, and SQL injection authentication bypass (`admin' OR 1=1-- -`) hijacking administrative account to capture Flag 4.
- **Flags Captured:** 4 of 4 (`FLAG1` to `FLAG4`).
- **Full Write-up:** [Read Walkthrough](./Web%20Application%20Penetration%20Testing/Web%20Application%20Penetration%20Testing%20CTF%201/README.md)

<br>

---

## 🗺️ Penetration Testing Student (eJPT) Learning Roadmap

Official curriculum tracking directly aligned with the INE training portal:

### 🔰 Section 1: Welcome
- [x] Penetration Testing Student Overview *(Video)*

### 🔍 Section 2: Assessment Methodologies
- [x] **Assessment Methodologies: Information Gathering** *(5h 34m | Alexis Ahmed)*
  - [x] **Skill Check Lab 1** *(5/5 Flags Captured)*
  - [x] **Skill Check Lab 2** *(4/4 Flags Captured)*
  - [x] **Skill Check Lab 3** *(4/4 Flags Captured)*
- [ ] **Assessment Methodologies: Footprinting & Scanning** *(11h 16m | Alexis Ahmed)*
- [ ] **Assessment Methodologies: Enumeration** *(8h 45m | Alexis Ahmed)*
- [ ] **Assessment Methodologies: Vulnerability Assessment** *(7h 1m | Alexis Ahmed)*
  - [x] **Skill Check Lab 1** *(4/4 Flags Captured)*

### 🛡️ Section 3: Host & Networking Auditing
- [ ] **Assessment Methodologies: Auditing Fundamentals** *(3h 58m | Alexis Ahmed)*

### 💻 Section 4: Host & Network Penetration Testing
- [x] **Host & Network Penetration Testing: System/Host Based Attacks** *(20h 28m | Alexis Ahmed)*
  - [x] **Skill Check Lab 1** *(4/4 Flags Captured)*
- [ ] **Host & Network Penetration Testing: Network-Based Attacks** *(4h 47m | Alexis Ahmed)*
- [ ] **Host & Network Penetration Testing: The Metasploit Framework (MSF)** *(35h 29m | Alexis Ahmed)*
- [x] **Host & Network Penetration Testing: Exploitation** *(20h 49m | Alexis Ahmed)*
  - [x] **Skill Check Lab 1** *(4/4 Flags Captured)*
- [ ] **Host & Network Penetration Testing: Post-Exploitation** *(26h 33m | Alexis Ahmed)*
- [ ] **Host & Network Penetration Testing: Social Engineering** *(3h 11m | Alexis Ahmed)*

### 🌐 Section 5: Web Application Penetration Testing
- [x] **Web Application Penetration Testing: Introduction to the Web & HTTP Protocol** *(11h 51m | Alexis Ahmed)*
  - [x] **Skill Check Lab 1** *(4/4 Flags Captured)*

### 🤖 Section 6: AI Enhanced Pentesting
- [ ] **Offensive AI: Generative AI for Pentesters** *(4h 44m | Alexis Ahmed)*

<br>

---

## ⚖️ Disclaimer & Code of Ethics
All activities, tools, scripts, and walkthroughs documented in this repository were performed in authorized virtual lab environments provided by **INE** solely for educational and certification training purposes. Techniques and methodologies presented are intended to improve security posture and support defensive remediation.
