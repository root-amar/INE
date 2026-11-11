<div align="center">
  <a href="../README.md">⬅️ <b>Back to Main Repository</b></a>
</div>

<br>

<div align="center">

# 🌐 INE Labs — Web Application Penetration Tester (eWPT) Portfolio

<p>
  <b>Practical hands-on lab solutions, CTF walkthroughs, and vulnerability assessments for the eLearnSecurity Web Application Penetration Tester (eWPT) certification.</b>
</p>

[![Learning Path](https://img.shields.io/badge/Learning%20Path-Web%20Application%20Penetration%20Tester-0078D4?style=for-the-badge&logo=target&logoColor=white)](https://ine.com/)
[![Certification](https://img.shields.io/badge/Certification-eWPT%20v1%20%2F%20v2-blueviolet?style=for-the-badge&logo=hackthebox&logoColor=white)](https://elearnsecurity.com/)
[![Labs Status](https://img.shields.io/badge/Completed-1%20Lab-success?style=for-the-badge&logo=checkmarx&logoColor=white)](./README.md)
[![Flag Score](https://img.shields.io/badge/Flags%20Captured-5%20%2F%205-brightgreen?style=for-the-badge&logo=adblock&logoColor=white)](./README.md)
[![Standards](https://img.shields.io/badge/Standards-OWASP%20Top%2010%20%7C%20WSTG%20%7C%20MITRE-red?style=for-the-badge&logo=shield&logoColor=white)](https://owasp.org/)

</div>

---

## 📊 Training Track & Progress Scorecard

| Metric | Details |
| :--- | :--- |
| **Training Platform** | **INE** (Interactive Network Experts) |
| **Learning Path** | **Web Application Penetration Tester (eWPT)** |
| **Target Certification** | **eWPT** (eLearnSecurity Certified Web Application Penetration Tester) |
| **Active Sections** | **Web Application Pentesting Foundations**, **Web Application Penetration Testing** |
| **Skill Checks Completed** | **1 Lab** (100% flag capture rate) |
| **Total Flags Captured** | **5 / 5** |
| **Documentation Standards** | **OWASP Top 10:2021**, **OWASP WSTG v4.2**, **MITRE ATT&CK® Enterprise**, **CVSS v3.1** risk scoring |

<br>

---

## 🏆 Completed Labs & Skill Checks

| Date | Section / Course | Challenge / Lab | Difficulty | Flags Captured | Key Methodologies & Techniques | Walkthrough |
| :--- | :--- | :--- | :---: | :---: | :--- | :---: |
| 2026-11-05 | Web Application Pentesting Foundations | Introduction to Web Application Security Testing CTF 1 | Easy / Medium | 5 / 5 | Crawler directive discovery (`robots.txt`), Gobuster directory brute-forcing, unreferenced configuration file harvesting (`app-config.bak`), Burp Suite response header analysis (`X-Admin-Flag`), REST API verb testing (`DELETE`), SQLite boolean injection | [Walkthrough](./Web%20Application%20Pentesting%20Foundations/Introduction%20to%20Web%20Application%20Security%20Testing/README.md) |

<br>

---

## 🔬 Course Breakdown: Web Application Pentesting Foundations

### 🎯 Course: Introduction to Web Application Security Testing

#### Skill Check Lab 1 (CTF 1): Information Gathering, Header Analysis, API Verbs & SQLite Injection
- **Scope:** `http://target.ine.local` (`192.95.248.3`)
- **Key Techniques:** Reviewing crawler policies (`robots.txt`) disclosing hidden endpoints (`/secret-docs/`), directory brute-forcing with Gobuster revealing open directory listing on `/backup/`, recovering plaintext administrative credentials from `app-config.bak`, authenticating as administrator, inspecting HTTP response headers with Burp Suite Repeater to extract `X-Admin-Flag`, auditing allowed HTTP verbs with `OPTIONS` and executing `DELETE` on `/api/data`, and exploiting SQLite injection (`' OR '1'='1' -- `) in the admin search feature to dump the hidden flag record.
- **Flags Captured:** 5 of 5 (`FLAG1` to `FLAG5`).
- **Full Walkthrough:** [Read Walkthrough](./Web%20Application%20Pentesting%20Foundations/Introduction%20to%20Web%20Application%20Security%20Testing/README.md)

<br>

---

## 🗺️ Web Application Penetration Tester (eWPT) Roadmap

- [x] **Web Application Pentesting Foundations**
  - [x] **Introduction to Web Application Security Testing CTF 1** *(5/5 Flags Captured)*
- [ ] **Web Application Penetration Testing**
  - [ ] **Web Fingerprinting and Enumeration** *(Queued)*
  - [ ] **Web Proxies and Web Information Gathering CTF 1** *(Queued)*
- [ ] **Database & Injection Attacks**
- [ ] **Cross-Site Scripting & Client-Side Attacks**
- [ ] **Authentication & Session Management**

<br>

---

## ⚖️ Disclaimer & Code of Ethics
All activities, tools, scripts, and walkthroughs documented in this repository were performed in authorized virtual lab environments provided by **INE** solely for educational and certification training purposes. Techniques and methodologies presented are intended to improve security posture and support defensive remediation.
