<div align="center">
  <a href="../README.md">⬅️ <b>Back to eJPT Track Hub</b></a> | <a href="../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🌐 Section 5: Web Application Penetration Testing</h1>
  <p><b>Platform:</b> INE Security | <b>Track:</b> Penetration Testing Student (eJPT v2)</p>

[![Section - Web App Pentesting](https://img.shields.io/badge/Section-Web%20App%20Pentesting-blue?style=flat-square&logo=target)](./README.md)
[![Labs Completed](https://img.shields.io/badge/Completed-1%20Lab-success?style=flat-square&logo=checkmarx)](./README.md)
[![Total Flags](https://img.shields.io/badge/Flags%20Captured-4%20%2F%204-brightgreen?style=flat-square)](./README.md)
</div>

---

## 📌 Section Overview
This section focuses on identifying, exploiting, and mitigating security vulnerabilities within modern web applications, web servers, HTTP protocol interactions, and database backends.

### 🎯 Key Focus Areas
- **Web Reconnaissance & Content Discovery:** High-speed directory brute-forcing, identifying hidden REST endpoints, and analyzing web headers with Nmap, Gobuster, and cURL.
- **Input Validation Vulnerabilities:** Path Traversal and Local File Inclusion (LFI) allowing unauthorized access to arbitrary files on the underlying filesystem.
- **Authentication & Credential Attacks:** Online dictionary attacks and automated password cracking against HTTP POST authentication forms using THC-Hydra.
- **Injection Attacks:** Exploiting SQL Injection (SQLi) vulnerabilities to bypass authentication mechanisms and hijack administrative accounts.
- **Web Defense & Hardening:** Implementation of parameterized queries, path normalization, rate limiting, and access control middleware.

<br>

---

## 🏆 Completed Skill Check Labs

| Date | Course / Module | Challenge / Lab | Difficulty | Flags Captured | Key Methodologies & Highlights | Walkthrough |
| :--- | :--- | :--- | :---: | :---: | :--- | :---: |
| 2026-10-30 | Introduction to Web & HTTP | Skill Check Lab 1 (CTF 1) | Easy / Medium | 4 / 4 | LFI / Path Traversal (`view_file?file=/flag.txt`), Gobuster directory fuzzing (`/secured/`), THC-Hydra HTTP POST form attack (`guest:butterfly1`), SQL Injection authentication bypass (`admin' OR 1=1-- -`) | [Read Walkthrough](./Web%20Application%20Penetration%20Testing%20CTF%201/README.md) |

<br>

---
<div align="center">
  <i>Part of the INE Penetration Testing Student (eJPT) Certification Portfolio.</i>
</div>
