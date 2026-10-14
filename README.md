# 🎯 INE Labs - Penetration Testing & Walkthrough Tracker

Welcome to your central hands-on lab tracker for **INE Security & Certification Labs** (eCPPT, eJPT, eWPTX, and specialized training modules). Use this tracker to record technical steps, flags captured, methodologies, tools, and remediation guides.

---

## 📊 Statistics

| Metric | Count | Details |
| :--- | :---: | :--- |
| **Total Labs Completed** | **2** | 100% flag capture rate |
| **Total Flags Captured** | **9** | 5 in CTF 1, 4 in CTF 2 |
| **Active Focus Path** | **eCPPT / Assessment Methodologies** | Information Gathering, Reconnaissance, Footprinting |

<br>

---

## 🏆 Completed Labs & Walkthroughs

| Date | Category / Module | Lab Name | Difficulty | Flags Captured | Key Learnings & Techniques | Walkthrough Link |
| :--- | :--- | :--- | :---: | :---: | :--- | :---: |
| 2026-10-14 | Assessment Methodologies | Information Gathering CTF 1 | Easy / Medium | 5 / 5 | Robots.txt inspection, HTML meta generator analysis, DIRB wordlist fuzzing (`big.txt`), `.bak` backup file extraction (`wp-config.bak`), HTTrack site mirroring | [Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%201/README.md) |
| 2026-10-14 | Assessment Methodologies | Information Gathering CTF 2 | Easy / Medium | 4 / 4 | HTTP server banner disclosure, hidden paths via robots.txt, vsftpd anonymous access & credential extraction, MySQL database enumeration | [Walkthrough](./Assessment%20Methodologies/Information%20Gathering%20CTF%202/README.md) |

<br>

---

## 🗺️ Certification & Curriculum Roadmap

### 🔍 1. Assessment Methodologies
- [x] **Information Gathering CTF 1** *(5/5 Flags Captured)*
- [x] **Information Gathering CTF 2** *(4/4 Flags Captured)*
- [ ] Footprinting & Reconnaissance
- [ ] Scanning & Enumeration
- [ ] Vulnerability Assessment & Nessus / OpenVAS Auditing

### 🌐 2. Web Application Penetration Testing
- [ ] Information Gathering & Subdomain Takeover
- [ ] Cross-Site Scripting (Reflected, Stored, DOM)
- [ ] SQL Injection (Error-based, Blind, Time-based)
- [ ] Broken Authentication & Session Management
- [ ] Server-Side Request Forgery (SSRF)
- [ ] Server-Side Template Injection (SSTI) & Remote Code Execution

### 🖥️ 3. Host & Network Penetration Testing
- [ ] Linux Privilege Escalation (SUID, Cron, Capabilities, Sudo)
- [ ] Windows Privilege Escalation (Token Impersonation, Unquoted Service Paths, DLL Hijacking)
- [ ] Network Service Attacks (SMB, SNMP, RDP, SSH)
- [ ] Pivoting & Lateral Movement (SSH Tunnels, Chisel, Proxychains, Ligolo-ng)

### 🛡️ 4. Active Directory Exploitation
- [ ] Active Directory Enumeration with PowerView & BloodHound
- [ ] Kerberoasting & AS-REP Roasting
- [ ] DCSync & Pass-the-Hash / Pass-the-Ticket
- [ ] Domain Privilege Escalation & Forest Trusts

### ⚡ 5. Metasploit & Post Exploitation
- [ ] Metasploit Framework Fundamentals
- [ ] Meterpreter Payload Customization & AV Evasion
- [ ] Post-Exploitation Gathering & Credential Dumping (Mimikatz)

### 🧬 6. Exploit Development & Buffer Overflow
- [ ] 32-bit Linux & Windows Stack-Based Buffer Overflows
- [ ] Bad Characters Identification & Finding Return Addresses (JMP ESP)
- [ ] Custom Shellcoding & Exploit Weaponization

<br>

---
*Tip: Use the `template.md` file to maintain a consistent format for your walkthroughs.*
