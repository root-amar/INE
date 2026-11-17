<div align="center">
  <a href="../README.md">⬅️ <b>Back to eWPT Track Hub</b></a> | <a href="../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🌐 Section: Web Application Penetration Testing</h1>
  <p><b>Platform:</b> INE Security | <b>Track:</b> Web Application Penetration Tester (eWPT)</p>

[![Section - Web Pentesting](https://img.shields.io/badge/Section-Web%20Application%20Penetration%20Testing-blue?style=flat-square&logo=target)](./README.md)
[![Labs Completed](https://img.shields.io/badge/Completed-1%20Lab-success?style=flat-square&logo=checkmarx)](./README.md)
[![Total Flags](https://img.shields.io/badge/Flags%20Captured-8%20%2F%208-brightgreen?style=flat-square)](./README.md)
</div>

---

## 📌 Section Overview
The **Web Application Penetration Testing** module focuses on deep fingerprinting, reconnaissance, content discovery, authentication mechanism auditing, service misconfigurations, and advanced vulnerability chaining across real-world application architectures.

### 🎯 Key Focus Areas
- **Web Fingerprinting & Information Gathering:** Identifying underlying web servers, application frameworks, server response headers, and technologies using active and passive scanning (`Nikto`, `curl`).
- **Crawler & Sitemap Analysis:** Auditing search-engine policy directives (`robots.txt`) and parsing XML sitemaps for unindexed endpoints and sensitive developer build comments.
- **Directory & File Brute-Forcing:** Uncovering hidden administrative portals, backup files (`.bak`), configuration leaks (`.env`), and open directory listings.
- **Client-Side Asset Forensics:** Mirroring websites via `HTTrack` and recursively analyzing JavaScript files for hardcoded secrets, TODO notes, and API tokens.
- **Authentication & Privilege Auditing:** Replaying recovered employee credentials, harvesting developer portal access, and testing default administrator accounts (`admin:admin`).
- **Infrastructure & DNS Reconnaissance:** Performing DNS queries, identifying authoritative nameservers, and exploiting unrestricted DNS Zone Transfers (`AXFR`).

<br>

---

## 🏆 Completed Skill Check Labs

| Date | Course / Module | Challenge / Lab | Difficulty | Flags Captured | Key Methodologies & Highlights | Walkthrough |
| :--- | :--- | :--- | :---: | :---: | :--- | :---: |
| 2026-11-05 | Web Fingerprinting & Enumeration | Skill Check Lab 1 (CTF 1) | Medium | 8 / 8 (100%) | Robots.txt & sitemap.xml inspection, Nikto scanning, phpinfo() debug extraction, open directory indexing on `/staff/`, credential backup harvesting (`credentials.bak`), HTTrack site mirroring, JS asset token grepping, `.env` file disclosure, factory-default administrative login, and unauthenticated DNS AXFR zone transfer | [Read Walkthrough](./web%20Fingerprinting%20and%20Enumeration/README.md) |

<br>

---
<div align="center">
  <i>Part of the INE Web Application Penetration Tester (eWPT) Certification Portfolio. Documented by Amar P.</i>
</div>
