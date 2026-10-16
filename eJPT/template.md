<div align="center">
  <a href="../../README.md">⬅️ <b>Back to eJPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🎯 [Lab Name] Walkthrough 🎯</h1>
  <p><b>Platform:</b> INE Security | <b>Learning Path:</b> Penetration Testing Student (eJPT v2) | <b>Course:</b> [Course Name, e.g. Assessment Methodologies: Footprinting & Scanning] | <b>Difficulty:</b> [Easy / Medium / Hard]</p>
  <p><i>Date Completed: YYYY-MM-DD</i></p>

[![Platform - INE](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=flat-square&logo=target)](https://ine.com/)
[![Track - eJPT](https://img.shields.io/badge/Track-eJPT%20v2-orange?style=flat-square&logo=hackthebox)](../../README.md)
[![Flags](https://img.shields.io/badge/Flags%20Captured-X%20%2F%20X-success?style=flat-square&logo=checkmarx)](./README.md)
[![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-Mapped-red?style=flat-square)](https://attack.mitre.org/)
</div>

---

## 📋 Objective & Scope
> **[Brief description of the challenge and what the main goals are. Mention target scope, mission objectives, and expected outcomes.]**

- **Target Host:** `target.ine.local` (`192.x.x.x`)
- **Key Services Audited:** [e.g. Apache 2.4.x, OpenSSH, SMB, MySQL]

<div align="center">
  <img src="./images/01-lab-overview.png" alt="[Descriptive image alt text explaining target briefing and objectives]" width="750px">
  <br><i>Figure 1: Lab environment overview and objectives.</i>
</div>

<br>

## 🛠️ Tools Used
| Tool | Purpose in Assessment |
| :--- | :--- |
| **Nmap** | Port scanning, OS detection, and service version enumeration. |
| **Dirb / Gobuster / Feroxbuster** | Web content and directory brute-forcing. |
| **cURL / Wget** | Manual HTTP interaction and asset retrieval. |
| **[Other Tool]** | [Specific function] |

<br>

---

## 🗺️ MITRE ATT&CK® Enterprise Mapping
| Tactic | Technique ID | Technique Name | Description in Lab |
| :--- | :--- | :--- | :--- |
| **Reconnaissance** | `T1595.002` | Active Scanning: Vulnerability Scanning | Service banner grabbing and directory enumeration |
| **Discovery** | `T1083` | File and Directory Discovery | Enumerating web directories and hidden storage endpoints |
| **Initial Access** | `T1078` | Valid Accounts | [Authenticating via default or weak credentials] |
| **Collection** | `T1005` | Data from Local System | [Extracting confidential files or database rows] |

<br>

---

## 🔍 1. Reconnaissance & Enumeration

### 🌐 Network Scanning
Identify open ports, active services, and potential attack vectors:

```bash
nmap -sV -sC target.ine.local
```

<div align="center">
  <img src="./images/02-nmap-scan.png" alt="[Descriptive alt text of Nmap port scan findings]" width="750px">
  <br><i>Figure 2: Initial port and service scan results.</i>
</div>

### 📂 Web & Content Discovery
Enumerate hidden directories, files, backup archives, and administrative interfaces:

```bash
dirb http://target.ine.local/
```

<div align="center">
  <img src="./images/03-directory-fuzzing.png" alt="[Descriptive alt text of directory brute-force results]" width="750px">
  <br><i>Figure 3: Directory enumeration findings.</i>
</div>

<br>

---

## ⚡ 2. Exploitation & Flag Acquisition

### 🚩 Flag 1: [Flag Description / Name]
**Prompt:** *"[Quote the exact prompt from the lab]"*

[Describe the first vulnerability or discovery found during enumeration.]

```bash
[command to uncover or view flag]
```

<div align="center">
  <img src="./images/04-flag1-discovery.png" alt="[Descriptive alt text showing Flag 1]" width="750px">
  <br><i>Figure 4: Flag 1 retrieval.</i>
</div>

```text
[FLAG_VALUE_HERE]
```
- **Submitted Hash / Value:** `[MD5_OR_STRING]`

---

### 🚩 Flag 2: [Flag Description / Name]
**Prompt:** *"[Quote the exact prompt from the lab]"*

[Describe the next finding and attack step.]

```bash
[command to uncover or view flag]
```

<div align="center">
  <img src="./images/05-flag2-discovery.png" alt="[Descriptive alt text showing Flag 2]" width="750px">
  <br><i>Figure 5: Flag 2 retrieval.</i>
</div>

```text
[FLAG_VALUE_HERE]
```
- **Submitted Hash / Value:** `[MD5_OR_STRING]`

<br>

---

## 🏁 3. Flags Summary

| Flag # | Challenge Prompt | Extracted Flag | Submitted Hash | Discovery Vector |
| :---: | :--- | :--- | :--- | :--- |
| **1** | [Prompt 1] | `FLAG1{...}` | `[hash]` | [Vector / Technique] |
| **2** | [Prompt 2] | `FLAG2{...}` | `[hash]` | [Vector / Technique] |

<br>

---

## 🛡️ 4. Vulnerability Risk Ratings & Defensive Hardening

### 📊 CVSS v3.1 Findings Matrix
| Finding | Severity | CVSS v3.1 Score | Vector String |
| :--- | :---: | :---: | :--- |
| **[Vulnerability Title 1]** | 🔴 **High** / 🔴 **Critical** | **[Score]** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N` |
| **[Vulnerability Title 2]** | 🟡 **Medium** | **[Score]** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N` |

<br>

<details>
<summary><b>Click to expand remediation strategies & secure configurations</b></summary>
<br>

### 📌 1. [Vulnerability Title 1]
- **Root Cause:** [Detailed explanation of why the configuration or code is vulnerable.]
- **Remediation:** [Practical defensive steps and configuration snippets.]
  ```apache
  # Example defensive configuration
  ```

### 📌 2. [Vulnerability Title 2]
- **Root Cause:** [Detailed explanation of why the configuration or code is vulnerable.]
- **Remediation:** [Practical defensive steps and configuration snippets.]
</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **[Key Lesson 1]:** [Insight on methodology or tool usage.]
- **[Key Lesson 2]:** [Insight on defense or vulnerability pattern.]
- **[Key Lesson 3]:** [Takeaway for exam or real-world engagements.]

---
<div align="center">
  <i>Walkthrough compiled on YYYY-MM-DD. Documented for INE Penetration Testing Student (eJPT) certification path.</i>
</div>
