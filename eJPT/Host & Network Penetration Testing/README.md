<div align="center">
  <a href="../README.md">⬅️ <b>Back to eJPT Track Hub</b></a> | <a href="../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>💻 Section 4: Host & Network Penetration Testing</h1>
  <p><b>Platform:</b> INE Security | <b>Track:</b> Penetration Testing Student (eJPT v2)</p>

[![Section - Host & Network Pentesting](https://img.shields.io/badge/Section-Host%20%26%20Network%20Pentesting-blue?style=flat-square&logo=target)](./README.md)
[![Labs Completed](https://img.shields.io/badge/Completed-4%20Labs-success?style=flat-square&logo=checkmarx)](./README.md)
[![Total Flags](https://img.shields.io/badge/Flags%20Captured-16%20%2F%2016-brightgreen?style=flat-square)](./README.md)
</div>

---

## 📌 Section Overview
This section covers offensive techniques and methodologies for compromising host operating systems, network services, administrative protocols, and internal network infrastructure.

### 🎯 Key Focus Areas
- **Host-Based Vulnerabilities:** Windows and Linux system misconfigurations, unquoted service paths, token impersonation, and weak service permissions.
- **Service Exploitation:** Attacking network services including IIS WebDAV, SMB/Samba, WinRM, MSRPC, RDP, and SSH.
- **Credential Attacks & Password Spraying:** Network dictionary attacks and password guessing using THC-Hydra.
- **Post-Exploitation & Pivoting:** Utilizing Metasploit PsExec modules, interactive Meterpreter sessions, and graphical remote desktop management.

<br>

---

## 🏆 Completed Skill Check Labs

| Date | Course / Module | Challenge / Lab | Difficulty | Flags Captured | Key Methodologies & Highlights | Walkthrough |
| :--- | :--- | :--- | :---: | :---: | :--- | :---: |
| 2026-10-18 | System/Host Based Attacks | Skill Check Lab 1 (CTF 1) | Easy / Medium | 4 / 4 | HTTP Basic Auth brute-force (`bob`), WebDAV ASP webshell upload & execution, SMB credential attack (`administrator:pineapple`), Metasploit PsExec Meterpreter session, FreeRDP desktop access | [Read Walkthrough](./System-Host%20Based%20Attacks%20CTF%201/README.md) |
| 2026-10-28 | Exploitation | Skill Check Lab 1 (CTF 1) | Easy / Medium | 4 / 4 | FlatCore CMS 2.0.7 Authenticated RCE (`50262.py`), OpenSSH brute-force (`iamaweakuser:angel`), WordPress Duplicator 1.3.26 Arbitrary File Read (CVE-2020-11738), Passwordless SSH access (`iamacrazyfreeuser`) | [Read Walkthrough](./Exploitation%20CTF%201/README.md) |
| 2026-11-02 | System/Host Based Attacks | Skill Check Lab 2 (CTF 2) | Easy / Medium | 4 / 4 | Apache mod_cgi Shellshock RCE (`CVE-2014-6271`), libssh authentication bypass (`CVE-2018-10933`), Metasploit payload delivery, SUID binary relative path execution hijacking (`welcome` &rarr; `greetings`), root elevation | [Read Walkthrough](./System-Host%20Based%20Attacks%20CTF%202/README.md) |
| 2026-11-02 | The Metasploit Framework (MSF) | Skill Check Lab 1 (CTF 1) | Easy / Medium | 4 / 4 | Metasploit PostgreSQL DB integration, MSSQL CLR payload RCE (`mssql_clr_payload`), token privilege auditing (`SeImpersonatePrivilege`), PrintSpooler `getsystem` elevation, recursive System32 discovery | [Read Walkthrough](./The%20Metasploit%20Framework%20CTF1/README.md) |

<br>

---
<div align="center">
  <i>Part of the INE Penetration Testing Student (eJPT) Certification Portfolio.</i>
</div>
