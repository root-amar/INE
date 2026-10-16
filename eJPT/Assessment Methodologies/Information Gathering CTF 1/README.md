<div align="center">
  <h1>🎯 Information Gathering — Skill Check Lab 1 Walkthrough 🎯</h1>
  <p><b>Platform:</b> INE | <b>Learning Path:</b> Penetration Testing Student (eJPT) | <b>Course:</b> Assessment Methodologies: Information Gathering | <b>Challenge:</b> Skill Check 1</p>
  <p><i>Date Completed: 14 October 2026</i></p>
</div>

---

## 📋 Objective
> **Perform passive and active web reconnaissance against the target web application (`http://target.ine.local`). The goal is to uncover hidden information, inspect search engine directives, analyze source code metadata, detect sensitive backup files, and mirror endpoints to extract all 5 hidden flags.**

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132215.png" alt="INE Lab 1 Completed" width="750px">
  <br><i>Figure 1: INE Portal — All 5 flags successfully captured (Activity Status: FINISHED).</i>
</div>

<br>

## 🛠️ Tools Used
| Tool | Purpose |
| :--- | :--- |
| **Nmap** | Initial port scanning, service version detection, and default script execution. |
| **Firefox & DevTools** | Web interface inspection, page source analysis, and robots.txt examination. |
| **DIRB** | Directory brute-forcing with common and custom wordlists (`big.txt`), plus extension fuzzing (`.bak`, `.tar.gz`). |
| **Wget & cURL** | Direct retrieval of exposed backup configuration files. |
| **HTTrack Website Copier** | Offline site mirroring to uncover referenced files and API endpoints. |

<br>

---

## 🔍 1. Reconnaissance & Service Fingerprinting

### 🌐 Network Scanning
We begin by running a standard Nmap service version and script scan (`-sV -sC`) against the designated hostname `target.ine.local` (`192.42.203.3`):

```bash
nmap -sC -sV target.ine.local
```

**Scan Findings:**
- **Port 80/tcp:** Apache httpd `2.4.41` on Ubuntu.
- **Robots.txt:** 1 disallowed entry detected (`/wp-admin/`).
- **Generator Meta Tag Leak:** The scan immediately flags an interesting generator header containing our second flag!

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20123240.png" alt="Nmap Scan Result" width="750px">
  <br><i>Figure 2: Nmap scan output revealing Apache 2.4.41 and the WordPress generator banner.</i>
</div>

<br>

---

## ⚡ 2. Flag Acquisition & Methodology

### 🚩 Flag 1: Search Engine Directives (`robots.txt`)
**Prompt:** *"This tells search engines what to and what not to avoid."*

Search engines adhere to `robots.txt` located in the root of the web server. Browsing directly to `http://target.ine.local/robots.txt` reveals the crawler restrictions and Flag 1 embedded directly in the response:

```text
User-agent: *
Disallow: /wp-admin/
Allow: /wp-admin/admin-ajax.php

FLAG1{1b5d8cb80f9d43c18462e47986890291}
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20123408.png" alt="Robots.txt Inspection" width="750px">
  <br><i>Figure 3: Inspecting robots.txt in Firefox to uncover Flag 1.</i>
</div>

---

### 🚩 Flag 2: CMS Version & Meta Generator Tag
**Prompt:** *"What website is running on the target, and what is its version?"*

During our initial Nmap scan and by inspecting the raw HTML source code (`view-source:http://target.ine.local/`), we examine the `<meta name="generator">` tag:

```html
<meta name="generator" content="WordPress 6.5.3 - FL@G2{1be1317c4461474c973c2b5829b10650}" />
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20123537.png" alt="Page Source Generator Tag" width="750px">
  <br><i>Figure 4: HTML source showing the generator meta tag leaking WordPress 6.5.3 and Flag 2.</i>
</div>

---

### 🚩 Flag 3: Directory Browsing & Content Enumeration
**Prompt:** *"Directory browsing might reveal where files are stored."*

We launch `dirb` with the default common wordlist to identify accessible directories and content structures:

```bash
dirb http://target.ine.local/
```

**Output:**
```text
==> DIRECTORY: http://target.ine.local/wp-admin/
==> DIRECTORY: http://target.ine.local/wp-content/
==> DIRECTORY: http://target.ine.local/wp-includes/
==> DIRECTORY: http://target.ine.local/wp-content/uploads/
```

Directory listing was left enabled on `http://target.ine.local/wp-content/uploads/`, allowing unrestricted browsing of uploaded assets, fulfilling the requirement for Flag 3.

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20123748.png" alt="DIRB Directory Scan" width="750px">
  <br><i>Figure 5: DIRB identifies standard WordPress directories including the exposed uploads folder.</i>
</div>

---

### 🚩 Flag 4: Overlooked Sensitive Backup File (`wp-config.bak`)
**Prompt:** *"An overlooked backup file in the webroot can be problematic if it reveals sensitive configuration details."*

Administrators often make temporary copies of critical files (e.g. `wp-config.php.bak`, `wp-config.bak`) that are not interpreted as PHP by the web server and are delivered as plain text. 

We search for larger wordlists and run DIRB with file extension fuzzing (`-X .bak,.tar.gz`):

```bash
locate big.txt
dirb http://target.ine.local/ -w /usr/share/dirb/wordlists/big.txt -X .bak,.tar.gz
```

**Hit:**
```text
+ http://target.ine.local/wp-config.bak (CODE:200|SIZE:3438)
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20123931.png" alt="DIRB Backup Discovery" width="750px">
  <br><i>Figure 6: Extension brute-forcing locates the exposed wp-config.bak file.</i>
</div>

We download and inspect the backup configuration file:

```bash
wget http://target.ine.local/wp-config.bak
cat wp-config.bak
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20124037.png" alt="Wget Download" width="750px">
  <br><i>Figure 7: Downloading wp-config.bak to the local environment.</i>
</div>

At the bottom of `wp-config.bak`, after the WordPress salt definitions, we find Flag 4:

```php
/** FLAG4{4141aa62557f4591afdb506029e4c2ff} */
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20124131.png" alt="Flag 4 in wp-config.bak" width="750px">
  <br><i>Figure 8: Flag 4 revealed within the sensitive WordPress configuration backup.</i>
</div>

---

### 🚩 Flag 5: Website Mirroring via HTTrack
**Prompt:** *"Certain files may reveal something interesting when mirrored."*

To identify hidden endpoints, RSD XML descriptors, or referenced scripts that are hard to find via standard spidering, we mirror the entire site using `httrack`:

```bash
httrack http://target.ine.local/ -O ine-lab
cd ine-lab/target.ine.local
ls -la
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20124216.png" alt="HTTrack Mirroring" width="750px">
  <br><i>Figure 9: HTTrack mirroring reveals indexed files and xmlrpc0db0.php.</i>
</div>

Among the mirrored files is `xmlrpc0db0.php` (an RSD / Really Simple Discovery endpoint). Reading the file:

```bash
cat xmlrpc0db0.php
```

```xml
<?xml version="1.0" encoding="UTF-8"?><rsd version="1.0" xmlns="http://archipelago.phrasewise.com/rsd">
  <service>
    <engineName>WordPress</engineName>
    <apis>
      <api name="FLAG5{8732e32a71c5443bb97205cb10183815}" blogID="1" preferred="false" apiLink="http://target.ine.local/xmlrpc.php" />
    </apis>
  </service>
</rsd>
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20124250.png" alt="Flag 5 in xmlrpc" width="750px">
  <br><i>Figure 10: Flag 5 captured inside the mirrored RSD/XML-RPC descriptor.</i>
</div>

<br>

---

## 🏁 3. Flags Summary

| Flag # | Challenge Description | Flag Value | Source / Technique |
| :---: | :--- | :--- | :--- |
| **Flag 1** | This tells search engines what to and what not to avoid. | `FLAG1{1b5d8cb80f9d43c18462e47986890291}` | `robots.txt` analysis |
| **Flag 2** | What website is running on the target, and what is its version? | `FL@G2{1be1317c4461474c973c2b5829b10650}` | HTML generator meta tag & Nmap banner |
| **Flag 3** | Directory browsing might reveal where files are stored. | *(Completed via directory browsing)* | `/wp-content/uploads/` directory listing |
| **Flag 4** | An overlooked backup file in the webroot can be problematic... | `FLAG4{4141aa62557f4591afdb506029e4c2ff}` | Fuzzing `.bak` extension -> `wp-config.bak` |
| **Flag 5** | Certain files may reveal something interesting when mirrored. | `FLAG5{8732e32a71c5443bb97205cb10183815}` | HTTrack offline mirror -> `xmlrpc0db0.php` |

<br>

---

## 🛡️ 4. Vulnerability Analysis & Real-World Remediation

<details>
<summary><b>Click to expand vulnerability details & remediation guide</b></summary>
<br>

### 1. Information Disclosure via `robots.txt`
- **Issue:** Sensitive internal paths and comments placed in `robots.txt` are publicly readable by anyone.
- **Remediation:** Never rely on `robots.txt` for access control. Restrict sensitive paths (`/wp-admin`) at the web server / authentication layer (e.g., HTTP Basic Auth, IP allowlisting).

### 2. Software Version Disclosure in HTML Meta Tags
- **Issue:** The `<meta name="generator">` tag advertises the precise CMS version (`WordPress 6.5.3`), facilitating targeted CVE searching by attackers.
- **Remediation:** Remove version generator tags in `functions.php`:
  ```php
  remove_action('wp_head', 'wp_generator');
  ```

### 3. Enabled Directory Listing (`Options +Indexes`)
- **Issue:** The `/wp-content/uploads/` directory permitted index listing, allowing unauthorized actors to browse all stored files.
- **Remediation:** Disable indexing in Apache configuration or `.htaccess`:
  ```apache
  Options -Indexes
  ```

### 4. Plaintext Backup Configuration Exposure
- **Issue:** Backup files ending in `.bak` are not parsed as executable PHP scripts by Apache, causing the web server to return raw database credentials, salts, and secrets.
- **Remediation:** Never store backup files within web server document roots (`/var/www/html`). Block `.bak`, `.old`, and `.orig` extensions in web server configuration.
</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **Extension Fuzzing is Crucial:** Regular directory brute-forcing without extensions often misses critical backup files like `.bak`, `.old`, `.swp`, or `.tar.gz`.
- **Mirroring Unveils Hidden Assets:** Tools like `httrack` systematically harvest connected files, RSD descriptors, and external links that manual exploration easily overlooks.
- **Metadata Inspection First:** Always inspect raw HTML source code and HTTP response headers before attempting complex exploits.

---
<div align="center">
  <i>Walkthrough documented on 14 October 2026. Part of the INE eCPPT Certification Journey.</i>
</div>
