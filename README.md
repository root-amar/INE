# 🛡️ INE Cybersecurity Certifications & Training Portfolio

Welcome to my central hands-on cybersecurity repository documenting practical lab solutions, CTF challenges, and penetration testing methodologies across **INE (eLearnSecurity)** certification tracks.

This repository serves as a technical portfolio demonstrating practical competencies in network reconnaissance, vulnerability assessment, web application security, exploit methodologies, and professional security documentation.

---

## 🧭 Certification Tracks & Portfolio Directory

The repository is modularly organized by certification paths to accommodate current coursework and future certifications:

| Certification Track | Platform / Learning Path | Status | Labs Completed | Flags Captured | Primary Focus | Directory Link |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| **eJPT** | **Penetration Testing Student (PTS)** | 🟢 **Active** | **4 Labs** | **17 / 17** | Assessment methodologies, network recon, vulnerability analysis, web app basics, service exploitation | [📂 `eJPT/` Hub](./eJPT/README.md) |
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

<br>

---

## 🛡️ Documentation & Assessment Standards

Every technical write-up in this portfolio adheres to rigorous documentation standards:
- **Scope & Mission Objectives:** Clear identification of targets, network scope, and authorization boundaries.
- **Reproducible Methodology:** Verifiable terminal commands, syntax breakdowns, and defensive remediation insights.
- **Evidence & Verification:** Embedded visual proof including full terminal output, hashes, and tool outputs.
- **Remediation & Hardening:** Practical defensive guidance for system administrators and developers to patch identified weaknesses.

<br>

---

## ⚖️ Disclaimer & Code of Ethics
All security tests, vulnerability assessments, tools, and scripts documented in this repository were conducted strictly in authorized, isolated lab environments provided by **INE** for educational and certification training purposes. These techniques must never be applied against unauthorized targets or systems without explicit prior written consent.
