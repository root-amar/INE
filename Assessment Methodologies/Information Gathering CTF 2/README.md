<div align="center">
  <h1>🎯 Information Gathering — Skill Check Lab 2 Walkthrough 🎯</h1>
  <p><b>Platform:</b> INE | <b>Learning Path:</b> Penetration Testing Student (eJPT) | <b>Course:</b> Assessment Methodologies: Information Gathering | <b>Challenge:</b> Skill Check 2</p>
  <p><i>Date Completed: 14 October 2026</i></p>
</div>

---

## 📋 Objective
> **Conduct comprehensive network service reconnaissance and web enumeration against `http://target.ine.local` (`192.198.222.3`). Identify exposed banners, robots directives, anonymous FTP shares, and leaked database configurations to extract all 4 MD5 flag hashes.**

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20131940.png" alt="INE Lab 2 Overview" width="750px">
  <br><i>Figure 1: INE Lab Environment and Objectives for Information Gathering CTF 2.</i>
</div>

<br>

## 🛠️ Tools Used
| Tool | Purpose |
| :--- | :--- |
| **Nmap** | Host discovery, port scanning, and service version enumeration. |
| **cURL / Firefox** | HTTP banner inspection and endpoint probing. |
| **FTP Client** | Anonymous FTP authentication and remote file retrieval. |
| **MySQL Client** | Connecting to remote database using harvested credentials. |
| **DIRB** | Web content and robots file verification. |

<br>

---

## 🔍 1. Network Reconnaissance & Port Scanning

### 🌐 Service Fingerprinting
We execute an Nmap aggressive service scan (`-sV -sC`) against the target host `target.ine.local` (`192.198.222.3`):

```bash
nmap -sV -sC target.ine.local
```

**Port Scan Results:**
- **21/tcp:** `vsftpd 3.0.5` — **Anonymous FTP login allowed!** Files found: `creds.txt`, `flag.txt`.
- **22/tcp:** `OpenSSH 8.9p1` (Ubuntu Linux).
- **25/tcp:** `Postfix smtpd`.
- **80/tcp:** `Werkzeug 3.0.6` (Python 3.10.12).
- **Robots.txt:** 3 disallowed entries: `/_photos`, `/secret-info/`, `/data/`.

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132257.png" alt="Nmap Scan Results" width="750px">
  <br><i>Figure 2: Comprehensive Nmap scan exposing FTP, SSH, SMTP, and Werkzeug HTTP services.</i>
</div>

<br>

---

## ⚡ 2. Flag Acquisition & Exploitation

> **Note on Submission Format:**
> Flags follow the pattern `FLAG<N>_<MD5_HASH>`. The lab platform requires submitting **only the 32-character MD5 hash** without the `FLAG<N>_` prefix.

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132021.png" alt="Flag Submission Guidelines" width="750px">
  <br><i>Figure 3: INE portal instructions requiring MD5 hash submissions.</i>
</div>

---

### 🚩 Flag 1: HTTP Response Server Banner Disclosure
**Prompt:** *"The server proudly announces its identity in every response. Look closely; you might find something unusual."*

When inspecting HTTP response headers returned by the Werkzeug web server on port 80, the server leaks a custom `Server` header:

```http
HTTP/1.1 200 OK
Server: Werkzeug/3.0.6 Python/3.10.12
Server: FLAG1_77f8f6c7f5bf42ff849b45249e767ce5
Connection: close
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132325.png" alt="HTTP Header Flag 1" width="750px">
  <br><i>Figure 4: Inspecting raw HTTP headers revealing Flag 1 in the Server response header.</i>
</div>

- **Submitted Hash:** `77f8f6c7f5bf42ff849b45249e767ce5`

---

### 🚩 Flag 2: Hidden Endpoints via `robots.txt`
**Prompt:** *"The gatekeeper's instructions often reveal what should remain unseen. Don't forget to read between the lines."*

The "gatekeeper" refers to `robots.txt`. As observed in the initial Nmap and DIRB scans, the crawler instructions specify:
- `Disallow: /_photos`
- `Disallow: /secret-info/`
- `Disallow: /data/`

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132604.png" alt="DIRB Scan" width="750px">
  <br><i>Figure 5: DIRB verifies the presence of robots.txt on target.ine.local.</i>
</div>

We navigate to `http://target.ine.local/secret-info/flag.txt` in Firefox:

```text
FLAG2_73ef9217b4f24c1aa17f66a834c998bc
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132544.png" alt="Flag 2 in secret-info" width="750px">
  <br><i>Figure 6: Accessing /secret-info/flag.txt reveals Flag 2.</i>
</div>

- **Submitted Hash:** `73ef9217b4f24c1aa17f66a834c998bc`

---

### 🚩 Flag 3: Anonymous FTP Share Access & Credential Harvesting
**Prompt:** *"Anonymous access sometimes leads to forgotten treasures. Connect and explore the directory; you might stumble upon something valuable."*

Port 21 is running `vsftpd 3.0.5` with anonymous authentication enabled. We connect via the FTP client:

```bash
ftp target.ine.local
# Name: anonymous
# Password: [Press Enter]
```

Once connected, listing the files reveals `creds.txt` and `flag.txt`:

```text
ftp> ls
-rw-r--r--   1 0   0   22 Oct 28  2024 creds.txt
-rw-r--r--   1 0   0   39 Oct 14 07:34 flag.txt

ftp> less flag.txt
FLAG3_99a0590109ce4ac695a4df2cc563302c

ftp> less creds.txt
db_admin:password@123
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132428.png" alt="FTP Anonymous Access" width="750px">
  <br><i>Figure 7: Anonymous FTP access revealing Flag 3 and database administrator credentials.</i>
</div>

- **Submitted Hash:** `99a0590109ce4ac695a4df2cc563302c`

---

### 🚩 Flag 4: Database Enumeration via Harvested Credentials
**Prompt:** *"A well-named database can be quite revealing. Peek at the configurations to discover the hidden treasure."*

With the credentials recovered from FTP (`db_admin` / `password@123`), we connect to the MySQL / MariaDB database service:

```bash
mysql -h target.ine.local -u db_admin -p
# Enter password: password@123
```

Upon logging in, we query the existing databases:

```sql
MySQL [(none)]> show databases;
```

**Output:**
```text
+------------------------------------------+
| Database                                 |
+------------------------------------------+
| FLAG4_2f7d6ae25f4c4de19c2ac1b04f449b3b   |
| information_schema                       |
| mysql                                    |
| performance_schema                       |
| sys                                      |
+------------------------------------------+
```

<div align="center">
  <img src="./images/Screenshot%202026-10-14%20132507.png" alt="MySQL Database Enumeration" width="750px">
  <br><i>Figure 8: Database enumeration unveils Flag 4 as the custom database name.</i>
</div>

- **Submitted Hash:** `2f7d6ae25f4c4de19c2ac1b04f449b3b`

<br>

---

## 🏁 3. Flags Summary

| Flag # | Challenge Description | Full Value | Submitted MD5 Hash | Source |
| :---: | :--- | :--- | :--- | :--- |
| **Flag 1** | Server announces identity in every response | `FLAG1_77f8f6c7f5bf42ff849b45249e767ce5` | `77f8f6c7f5bf42ff849b45249e767ce5` | HTTP `Server:` Header |
| **Flag 2** | Gatekeeper's instructions (robots.txt) | `FLAG2_73ef9217b4f24c1aa17f66a834c998bc` | `73ef9217b4f24c1aa17f66a834c998bc` | `/secret-info/flag.txt` |
| **Flag 3** | Anonymous access to forgotten treasures | `FLAG3_99a0590109ce4ac695a4df2cc563302c` | `99a0590109ce4ac695a4df2cc563302c` | Anonymous FTP `flag.txt` |
| **Flag 4** | A well-named database configuration | `FLAG4_2f7d6ae25f4c4de19c2ac1b04f449b3b` | `2f7d6ae25f4c4de19c2ac1b04f449b3b` | MySQL Database Name |

<br>

---

## 🛡️ 4. Vulnerability Analysis & Real-World Remediation

<details>
<summary><b>Click to expand vulnerability details & remediation guide</b></summary>
<br>

### 1. HTTP Banner Information Leaks
- **Issue:** Web applications that return verbose server headers expose underlying technologies and versions, allowing attackers to quickly target known CVEs.
- **Remediation:** Suppress or normalize the `Server` header in production reverse proxies (Nginx/Apache) using `server_tokens off;` or header stripping middleware.

### 2. Disallowed Endpoints in `robots.txt`
- **Issue:** Listing private endpoints (like `/secret-info/`) in `robots.txt` provides attackers with a roadmap of confidential directories.
- **Remediation:** Enforce authentication and access controls on private routes instead of relying on crawler exclusions.

### 3. Insecure Anonymous FTP Configuration
- **Issue:** `vsftpd` allowed anonymous logins with read access, exposing sensitive internal credential files (`creds.txt`).
- **Remediation:** Disable anonymous FTP logins in `/etc/vsftpd.conf`:
  ```ini
  anonymous_enable=NO
  ```

### 4. Direct External Database Access & Weak Credentials
- **Issue:** MySQL was exposed to the network and accessible using simple credentials (`password@123`).
- **Remediation:** Bind MySQL to `localhost` (`bind-address = 127.0.0.1`), enforce strong password policies, and restrict database access through SSH tunnels or dedicated application servers.
</details>

<br>

---

## 💡 5. Key Learnings & Takeaways
- **Cross-Service Pivoting:** Reconnaissance findings often chain together — the anonymous FTP share provided credentials that directly unlocked the MySQL service.
- **Header Analysis is Low-Hanging Fruit:** Always analyze full HTTP headers (`curl -I`) as application developers frequently leave debug headers or tokens.
- **Service Hardening Matters:** Restricting default accounts and disabling anonymous access eliminates critical initial foothold vectors.

---
<div align="center">
  <i>Walkthrough documented on 14 October 2026. Part of the INE eCPPT Certification Journey.</i>
</div>
