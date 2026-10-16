<div align="center">
  <a href="../README.md">⬅️ <b>Back to Main Repository</b></a>
</div>

<br>

# 🎯 INE Labs — Penetration Testing Student (eJPT) Portfolio

Welcome to my central hands-on training repository documenting my progress through the **INE Penetration Testing Student (PTS)** learning path leading to the **eJPT (Junior Penetration Tester)** certification.

This repository serves as a professional portfolio documenting practical penetration-testing training undertaken as a **Junior Penetration Tester in Training**. It emphasizes hands-on methodology, technical reconnaissance, vulnerability identification, network service analysis, and reproducible technical documentation.

---

## 📊 Training Track & Progress

| Metric | Details |
| :--- | :--- |
| **Training Platform** | **INE** (Interactive Network Experts) |
| **Learning Path** | **Penetration Testing Student (PTS)** |
| **Target Certification** | **eJPT** (Junior Penetration Tester Certification) |
| **Current Section** | **Section 2: Assessment Methodologies** |
| **Active Courses** | **Assessment Methodologies: Information Gathering** & **Vulnerability Assessment** |
| **Skill Checks Completed** | **4 Labs** (100% flag capture rate) |
| **Total Flags Captured** | **17 / 17** (5 in Lab 1, 4 in Lab 2, 4 in Lab 3, 4 in Lab 4) |

<br>

---

## 🏆 Completed Labs & Skill Checks

| Date | Section / Course | Challenge / Lab | Difficulty | Flags Captured | Key Methodologies & Techniques | Walkthrough |
| :--- | :--- | :--- | :---: | :---: | :--- | :---: |
| 2026-10-14 | Assessment Methodologies: Information Gathering | Skill Check Lab 1 | Easy / Medium | 5 / 5 | Robots.txt inspection, HTML meta generator analysis, DIRB wordlist fuzzing (`big.txt`), `.bak` backup file extraction (`wp-config.bak`), HTTrack site mirroring | [Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%201/README.md) |
| 2026-10-14 | Assessment Methodologies: Information Gathering | Skill Check Lab 2 | Easy / Medium | 4 / 4 | HTTP server banner disclosure, hidden paths via robots.txt, vsftpd anonymous access & credential extraction, MySQL database enumeration | [Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%202/README.md) |
| 2026-10-15 | Assessment Methodologies: Information Gathering | Skill Check Lab 3 | Intermediate | 4 / 4 | Full TCP port scanning (`-p-`), custom Samba share fuzzing (`pubfiles`), Metasploit SID lookup (`smb_lookupsid`), SMB dictionary attack (`josh:purple`), vsftpd banner analysis & Hydra cracking (`alice:pretty`), OpenSSH pre-login warning banner inspection | [Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%203/README.md) |
| 2026-10-16 | Assessment Methodologies: Vulnerability Assessment | Skill Check Lab 1 (CTF 4) | Easy / Medium | 4 / 4 | Nmap service enumeration, exposed `.git/` directory indexing, unauthenticated phpMyAdmin root access (`mysql.secret_info`), diagnostic disclosure via `phpinfo.php`, and `/passwords/` directory browsing | [Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%204/README.md) |

<br>

---

## 🔬 Course Breakdown: Assessment Methodologies

### 🎯 Course: Information Gathering

#### Skill Check Lab 1: Web & Application Reconnaissance
- **Scope:** `http://target.ine.local` (`192.42.203.3`)
- **Key Techniques:** Passive and active information gathering, inspecting crawler rules in `robots.txt`, analyzing CMS version leakage in `<meta name="generator">`, detecting exposed configuration backups with DIRB and custom extension flags (`.bak`, `.tar.gz`), and performing full offline site mirroring with HTTrack.
- **Flags Captured:** 5 of 5 (`FLAG1` to `FLAG5`).

#### Skill Check Lab 2: Network Service Fingerprinting & Database Auditing
- **Scope:** `http://target.ine.local` (`192.198.222.3`)
- **Key Techniques:** Full service version fingerprinting with Nmap, identifying custom HTTP response headers (`Server: FLAG1_...`), navigating disallowed crawler endpoints in `robots.txt`, exploiting anonymous vsftpd access to retrieve database credentials, and connecting remotely to MySQL to dump the secret records table.
- **Flags Captured:** 4 of 4 (`FLAG1` to `FLAG4` MD5 hashes).

#### Skill Check Lab 3: Samba Fuzzing, MSRPC SID Lookup & Protocol Chaining
- **Scope:** `target.ine.local` (`192.126.190.3`)
- **Key Techniques:** Executing full TCP range scans (`-p-`) to discover non-standard services (vsftpd on port 5554), writing a custom bash wordlist script (`share.sh`) to locate the anonymous `pubfiles` SMB share, utilizing Metasploit's MSRPC SID lookup (`smb_lookupsid`) to extract valid local usernames, dictionary cracking SMB passwords (`josh:purple`), parsing vsftpd pre-login reminders to target weak accounts with Hydra (`alice:pretty`), and capturing legal warning banners over OpenSSH (`/etc/issue.net`).
- **Flags Captured:** 4 of 4 (`FLAG1` to `FLAG4` MD5 hashes).

### 🎯 Course: Vulnerability Assessment

#### Skill Check Lab 1 (CTF 4): Web Misconfigurations, Exposed VCS & Unauthenticated Consoles
- **Scope:** `target.ine.local` (`192.220.66.3`)
- **Key Techniques:** Identifying exposed `.git/` repository with enabled directory browsing to extract secret files, accessing unauthenticated phpMyAdmin consoles running as `root@localhost` to extract sensitive database rows (`secret_info`), leveraging DIRB to uncover `phpinfo.php` diagnostic pages disclosing internal server variables, and discovering exposed credential storage in `/passwords/`.
- **Flags Captured:** 4 of 4 (`FLAG1` to `FLAG4` MD5 hashes).

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
- [ ] **Host & Network Penetration Testing: System/Host Based Attacks** *(20h 28m | Alexis Ahmed)*
- [ ] **Host & Network Penetration Testing: Network-Based Attacks** *(4h 47m | Alexis Ahmed)*
- [ ] **Host & Network Penetration Testing: The Metasploit Framework (MSF)** *(35h 29m | Alexis Ahmed)*
- [ ] **Host & Network Penetration Testing: Exploitation** *(20h 49m | Alexis Ahmed)*
- [ ] **Host & Network Penetration Testing: Post-Exploitation** *(26h 33m | Alexis Ahmed)*
- [ ] **Host & Network Penetration Testing: Social Engineering** *(3h 11m | Alexis Ahmed)*

### 🌐 Section 5: Web Application Penetration Testing
- [ ] **Web Application Penetration Testing: Introduction to the Web & HTTP Protocol** *(11h 51m | Alexis Ahmed)*

### 🤖 Section 6: AI Enhanced Pentesting
- [ ] **Offensive AI: Generative AI for Pentesters** *(4h 44m | Alexis Ahmed)*

<br>

---

## ⚖️ Disclaimer & Code of Ethics
All activities, tools, scripts, and walkthroughs documented in this repository were performed in authorized virtual lab environments provided by **INE** solely for educational and certification training purposes. Techniques and methodologies presented are intended to improve security posture and support defensive remediation.
