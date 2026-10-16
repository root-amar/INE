<div align="center">
  <h1>🎯 [Lab Name] Walkthrough 🎯</h1>
  <p><b>Platform:</b> INE | <b>Learning Path:</b> Penetration Testing Student (eJPT) | <b>Course:</b> [Course Name, e.g., Assessment Methodologies: Information Gathering] | <b>Difficulty:</b> [Easy / Medium / Hard]</p>
  <p><i>Date Completed: YYYY-MM-DD</i></p>
</div>

---

## 📋 Objective
> **[Brief description of the challenge and what the main goals are. Mention target scope, mission objectives, and expected outcomes.]**

<br>

## 🛠️ Tools Used
| Tool | Purpose |
| :--- | :--- |
| **Nmap** | Port scanning, OS detection, and service version enumeration. |
| **Dirb / Gobuster / Feroxbuster** | Web content and directory brute-forcing. |
| **cURL / Wget** | Manual HTTP interaction and asset retrieval. |
| **[Other Tool]** | [Specific function] |

<br>

---

## 🔍 1. Reconnaissance & Enumeration

### 🌐 Network Scanning
Identify open ports, active services, and potential attack vectors.

```bash
nmap -sV -sC target.ine.local
```

<div align="center">
  <img src="./images/screenshot_nmap.png" alt="Nmap Scan" width="750px">
  <br><i>Figure 1: Initial port and service scan results.</i>
</div>

### 📂 Web & Content Discovery
Enumerate hidden directories, files, backup archives, and administrative interfaces.

```bash
dirb http://target.ine.local/
```

<div align="center">
  <img src="./images/screenshot_dirb.png" alt="Directory Enumeration" width="750px">
  <br><i>Figure 2: Directory enumeration findings.</i>
</div>

<br>

---

## ⚡ 2. Exploitation & Flag Acquisition

### 🔑 Step 1: [Initial Finding / Bypass / Footprint]
[Describe the first vulnerability or discovery found during enumeration.]

```bash
# Command used
```

<div align="center">
  <img src="./images/screenshot_step1.png" alt="Step 1" width="750px">
  <br><i>Figure 3: [Description of step].</i>
</div>

### 💥 Step 2: [Exploitation / Access / Extraction]
[Detail how the exploit was executed or how deeper access was achieved.]

```bash
# Command used
```

<br>

---

## 🔐 3. Privilege Escalation & Lateral Movement (if applicable)

### 🕵️ Enumeration
[Commands used to identify privilege escalation paths.]

### 🚀 Escalation Execution
[Commands and steps taken to escalate privileges to root or system.]

<br>

---

## 🏁 4. Flags Captured

| Flag # | Description / Challenge Prompt | Flag Value | Source / Location |
| :---: | :--- | :--- | :--- |
| **1** | [Prompt 1] | `FLAG{...}` | [Location, e.g., robots.txt] |
| **2** | [Prompt 2] | `FLAG{...}` | [Location] |

<br>

---

## 🛡️ 5. Vulnerability Analysis & Real-World Remediation

<details>
<summary><b>Click to expand vulnerability details & remediation guide</b></summary>
<br>

**1. Vulnerability Root Cause:**
- **Description:** [Explain why the vulnerability existed.]
- **Impact:** [Confidentiality / Integrity / Availability risk.]

**2. Hardening & Prevention:**
- **Configuration Fix:** [Specific server / code configuration to eliminate the issue.]
- **Best Practice:** [General security principle to apply.]
</details>

<br>

---

## 💡 6. Key Learnings & Takeaways
- **Key Insight 1:** [What was learned?]
- **Technique 2:** [Methodology reinforcement or tool syntax.]
- **Pitfall Avoided:** [Mistake or efficiency tip for future assessments.]

---
<div align="center">
  <i>Walkthrough updated on [Date]. Documented for INE Penetration Testing certification path.</i>
</div>
