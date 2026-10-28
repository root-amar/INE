<div align="center">

# 🛡️ INE Cybersecurity Certifications & eJPT Labs Portfolio

<p>
  <b>Hands-on penetration testing laboratories, CTF walkthroughs, and vulnerability assessments across INE (eLearnSecurity) certification tracks.</b>
</p>

[![Platform - INE Security](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=for-the-badge&logo=target&logoColor=white)](https://ine.com/)
[![Certification - eJPT v2](https://img.shields.io/badge/Certification-eJPT%20v2%20(PTS)-FF6F00?style=for-the-badge&logo=hackthebox&logoColor=white)](./eJPT/README.md)
[![Labs Completed - 6 Labs](https://img.shields.io/badge/Labs%20Completed-6%20Labs%20(100%25)-success?style=for-the-badge&logo=checkmarx&logoColor=white)](./eJPT/README.md)
[![Flags Captured - 25 / 25](https://img.shields.io/badge/Flags%20Captured-25%20%2F%2025-brightgreen?style=for-the-badge&logo=adblock&logoColor=white)](./eJPT/README.md)
[![Methodology - MITRE ATT&CK](https://img.shields.io/badge/Framework-MITRE%20ATT%26CK%20%7C%20CVSS%20v3.1-red?style=for-the-badge&logo=shield&logoColor=white)](https://attack.mitre.org/)

</div>

---

## 📌 Executive Summary

Welcome to my central cybersecurity repository documenting practical lab solutions, CTF challenges, and offensive security assessments across **INE (eLearnSecurity)** certification paths.

This portfolio serves as a technical showcase for practical competencies in:
- **Network Reconnaissance & Host Fingerprinting** (Nmap, DIRB, Feroxbuster)
- **Vulnerability Assessment & Configuration Auditing** (VCS leaks, phpMyAdmin, OpenSSL/SSH banners)
- **Service Exploitation & Protocol Chaining** (vsftpd, Samba SMB, MySQL, FlatCore CMS, WordPress)
- **Enterprise Defense & Remediation** (MITRE ATT&CK® mapping, CVSS v3.1 scoring, defensive hardening)

<details>
<summary><b>🔍 GitHub Repository SEO Metadata & Discovery Tags (Click to expand)</b></summary>
<br>

To ensure maximum discoverability by technical recruiters and penetration testing teams, this repository targets the following taxonomy:

- **Repository Description:**
  > *Complete hands-on lab solutions, technical walkthroughs, and vulnerability assessments for the INE Penetration Testing Student (PTS) and eLearnSecurity Junior Penetration Tester (eJPT v2) certification path.*

- **Recommended GitHub Topics:**
  `ejpt` • `ejptv2` • `ine-security` • `penetration-testing-student` • `ethical-hacking` • `ctf-walkthrough` • `vulnerability-assessment` • `mitre-attack` • `cvss-v3` • `network-reconnaissance` • `cybersecurity-portfolio` • `infosec` • `offensive-security`
</details>

<br>

---

## 🧭 Certification Tracks & Portfolio Directory

The repository is organized into modular directories representing distinct certification tracks:

| Certification Track | Platform / Learning Path | Status | Labs Completed | Flags Captured | Primary Focus | Directory Link |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| **eJPT** | **Penetration Testing Student (PTS)** | 🟢 **Active** | **6 Labs** | **25 / 25** | Assessment methodologies, network recon, vulnerability analysis, host & network attacks, service exploitation | [📂 `eJPT/` Hub](./eJPT/README.md) |
| **eCPPTv2** | **Penetration Testing Professional (PTP)** | 🟡 *Planned* | — | — | Network pivoting, Active Directory, system exploitation, privilege escalation, reporting | `eCPPTv2/` *(Upcoming)* |
| **eWPT** | **Web Application Penetration Testing (WAPT)** | 🟡 *Planned* | — | — | Web architectures, OWASP Top 10, SQLi, XSS, CSRF, session hijacking, API testing | `eWPT/` *(Upcoming)* |
| **eCIR** | **Certified Incident Responder (CIR)** | 🟡 *Planned* | — | — | Threat detection, live host triage, memory analysis, log forensics, incident containment | `eCIR/` *(Upcoming)* |

<br>

---

## 🗂️ Repository Architecture

All coursework and technical write-ups are organized under their respective certification track directories:

```text
INE/
├── README.md                                  # Root Portfolio Hub & Certification Index
├── new-lab.ps1                                # Automated Lab Scaffolding Script
├── .gitignore                                 # Git ignore patterns
│
└── eJPT/                                      # eLearnSecurity Junior Penetration Tester Track
    ├── README.md                              # Dedicated eJPT Tracker & Curriculum Roadmap
    ├── template.md                            # Standardized Lab Walkthrough Template
    │
    ├── Assessment Methodologies/              # Section 2: Assessment Methodologies
    │   ├── Information Gathering CTF 1/       # Lab 1: Web & App Recon (5/5 Flags)
    │   ├── Information Gathering CTF 2/       # Lab 2: Service Fingerprinting (4/4 Flags)
    │   ├── Information Gathering CTF 3/       # Lab 3: Samba & Protocol Chaining (4/4 Flags)
    │   └── Information Gathering CTF 4/       # Lab 4: Vulnerability Assessment (4/4 Flags)
    │
    ├── Host & Network Penetration Testing/    # Section 4: System & Network Attacks
    │   ├── README.md                          # Section Index & Syllabus
    │   ├── System-Host Based Attacks CTF 1/   # Lab 1: WebDAV, SMB & RDP (4/4 Flags)
    │   └── Exploitation CTF 1/                # Lab 2: Web RCE, Hydra SSH & Duplicator LFI (4/4 Flags)
    ├── Web Application Penetration Testing/   # Section 5: Web Attacks & HTTP
    ├── Active Directory Exploitation/         # Advanced Enterprise AD
    ├── Metasploit & Post Exploitation/        # Metasploit Framework & Payloads
    └── Exploit Development/                   # Buffer Overflows & Shellcoding
```

<br>

---

## 🎯 Active Track Spotlight: eLearnSecurity Junior Penetration Tester (eJPT)

**Current Status:** Active & In Progress  
**Dedicated Track Hub:** [👉 Explore Full eJPT Curriculum, Labs & Roadmap](./eJPT/README.md)  
**Standardized Write-up Template:** [📝 Walkthrough Template](./eJPT/template.md)

### 🏆 Completed Labs & Technical Walkthroughs

| Date | Course / Module | Challenge / Lab | Difficulty | Flags | Methodologies & Highlights | Walkthrough Link |
| :--- | :--- | :--- | :---: | :---: | :--- | :---: |
| 2026-10-14 | Assessment Methodologies: Information Gathering | Skill Check Lab 1 | Easy / Medium | 5 / 5 | Crawler rules (`robots.txt`), CMS generator fingerprinting, DIRB wordlist fuzzing (`big.txt`), `.bak` config extraction, HTTrack mirroring | [Read Walkthrough](./eJPT/Assessment%20Methodologies/Information%20Gathering%20CTF%201/README.md) |
| 2026-10-14 | Assessment Methodologies: Information Gathering | Skill Check Lab 2 | Easy / Medium | 4 / 4 | Custom HTTP banner leakage (`FLAG1_...`), robots.txt navigation, anonymous vsftpd access, MySQL database credential dumping | [Read Walkthrough](./eJPT/Assessment%20Methodologies/Information%20Gathering%20CTF%202/README.md) |
| 2026-10-15 | Assessment Methodologies: Information Gathering | Skill Check Lab 3 | Intermediate | 4 / 4 | Full TCP scanning (`-p-`), custom SMB share bash fuzzing (`share.sh`), Metasploit MSRPC SID lookup, Hydra password cracking, OpenSSH banner auditing | [Read Walkthrough](./eJPT/Assessment%20Methodologies/Information%20Gathering%20CTF%203/README.md) |
| 2026-10-16 | Assessment Methodologies: Vulnerability Assessment | Skill Check Lab 1 (CTF 4) | Easy / Medium | 4 / 4 | Exposed `.git/` repository indexing, unauthenticated phpMyAdmin root database dump (`mysql.secret_info`), `phpinfo.php` diagnostic analysis, `/passwords/` extraction | [Read Walkthrough](./eJPT/Assessment%20Methodologies/Information%20Gathering%20CTF%204/README.md) |
| 2026-10-18 | Host & Network Penetration Testing: System/Host Based Attacks | Skill Check Lab 1 (CTF 1) | Easy / Medium | 4 / 4 | HTTP Basic Auth cracking (`bob`), WebDAV ASP webshell upload & execution, SMB brute-forcing (`administrator:pineapple`), Metasploit PsExec Meterpreter session, FreeRDP desktop access | [Read Walkthrough](./eJPT/Host%20&%20Network%20Penetration%20Testing/System-Host%20Based%20Attacks%20CTF%201/README.md) |
| 2026-10-28 | Host & Network Penetration Testing: Exploitation | Skill Check Lab 1 (CTF 1) | Easy / Medium | 4 / 4 | FlatCore CMS 2.0.7 Authenticated RCE (`50262.py`), OpenSSH brute-force (`iamaweakuser:angel`), WordPress Duplicator 1.3.26 Arbitrary File Read (CVE-2020-11738), Passwordless SSH access (`iamacrazyfreeuser`) | [Read Walkthrough](./eJPT/Host%20&%20Network%20Penetration%20Testing/Exploitation%20CTF%201/README.md) |

<br>

---

## 🛡️ Documentation & Assessment Standards

Every technical write-up in this portfolio adheres to rigorous documentation standards:
- **Scope & Mission Objectives:** Clear identification of targets, network scope, and authorization boundaries.
- **MITRE ATT&CK® Mapping:** Threat actor tactics and techniques mapped to every reconnaissance and exploitation step.
- **CVSS v3.1 Severity Scoring:** Quantitative vulnerability assessments to communicate real-world business risk.
- **Reproducible Methodology:** Verifiable terminal commands, syntax breakdowns, and defensive remediation insights.
- **Evidence & Verification:** Embedded visual proof including full terminal output, hashes, and tool outputs.
- **Remediation & Hardening:** Practical defensive guidance for system administrators and developers to patch identified weaknesses.

<br>

---

## ⚖️ Disclaimer & Code of Ethics
All security tests, vulnerability assessments, tools, and scripts documented in this repository were conducted strictly in authorized, isolated lab environments provided by **INE** for educational and certification training purposes. These techniques must never be applied against unauthorized targets or systems without explicit prior written consent.
