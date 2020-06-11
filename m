Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895901F6D87
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 20:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgFKSfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 14:35:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55810 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbgFKSfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 14:35:22 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jjS2m-0007Pt-4t; Thu, 11 Jun 2020 19:35:16 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jjS2l-000556-IA; Thu, 11 Jun 2020 19:35:15 +0100
Date:   Thu, 11 Jun 2020 19:35:15 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Subject: Linux 3.16.85
Message-ID: <lsq.1591898928.276150302@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.16.85 kernel.  This is probably
the last release in the 3.16 stable series, unless some critical fix
comes up later this month.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git

The diff from 3.16.84 is attached to this message.

Ben.

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 .../special-register-buffer-data-sampling.rst      | 149 ++++
 Documentation/kernel-parameters.txt                |  20 +
 Makefile                                           |   2 +-
 arch/x86/include/asm/acpi.h                        |   2 +-
 arch/x86/include/asm/cpu_device_id.h               |  27 +
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/processor.h                   |   2 +-
 arch/x86/include/uapi/asm/msr-index.h              |   4 +
 arch/x86/kernel/amd_nb.c                           |   2 +-
 arch/x86/kernel/asm-offsets_32.c                   |   2 +-
 arch/x86/kernel/cpu/amd.c                          |  28 +-
 arch/x86/kernel/cpu/bugs.c                         | 106 +++
 arch/x86/kernel/cpu/centaur.c                      |   4 +-
 arch/x86/kernel/cpu/common.c                       |  62 +-
 arch/x86/kernel/cpu/cpu.h                          |   1 +
 arch/x86/kernel/cpu/cyrix.c                        |   2 +-
 arch/x86/kernel/cpu/intel.c                        |  18 +-
 arch/x86/kernel/cpu/match.c                        |   7 +-
 arch/x86/kernel/cpu/microcode/intel.c              |   4 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |   2 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |   4 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |   2 +-
 arch/x86/kernel/cpu/perf_event_p6.c                |   2 +-
 arch/x86/kernel/cpu/proc.c                         |   4 +-
 arch/x86/kernel/head_32.S                          |   4 +-
 arch/x86/kernel/mpparse.c                          |   2 +-
 drivers/base/cpu.c                                 |   8 +
 drivers/char/hw_random/via-rng.c                   |   2 +-
 drivers/char/random.c                              |   3 -
 drivers/cpufreq/acpi-cpufreq.c                     |   2 +-
 drivers/cpufreq/longhaul.c                         |   6 +-
 drivers/cpufreq/p4-clockmod.c                      |   2 +-
 drivers/cpufreq/powernow-k7.c                      |   2 +-
 drivers/cpufreq/speedstep-centrino.c               |   4 +-
 drivers/cpufreq/speedstep-lib.c                    |   6 +-
 drivers/crypto/padlock-aes.c                       |   2 +-
 drivers/edac/amd64_edac.c                          |   2 +-
 drivers/edac/mce_amd.c                             |   2 +-
 drivers/hwmon/coretemp.c                           |   6 +-
 drivers/hwmon/hwmon-vid.c                          |   2 +-
 drivers/hwmon/k10temp.c                            |   2 +-
 drivers/hwmon/k8temp.c                             |   2 +-
 drivers/message/fusion/mptctl.c                    | 215 ++----
 drivers/net/can/slcan.c                            |   4 +
 drivers/net/slip/slip.c                            |   4 +
 drivers/net/wireless/mwifiex/scan.c                |   7 +
 drivers/net/wireless/mwifiex/wmm.c                 |   4 +
 drivers/scsi/sg.c                                  | 758 +++++++++++----------
 drivers/usb/core/message.c                         |  53 +-
 drivers/usb/gadget/configfs.c                      |   3 +
 drivers/video/fbdev/geode/video_gx.c               |   2 +-
 fs/binfmt_elf.c                                    |   2 +-
 fs/exec.c                                          |   2 +-
 fs/ext4/block_validity.c                           |  57 ++
 fs/ext4/ext4.h                                     |  19 +-
 fs/ext4/extents.c                                  |  13 +-
 fs/ext4/inode.c                                    |   5 +
 include/linux/mod_devicetable.h                    |   6 +
 include/linux/sched.h                              |   4 +-
 include/scsi/sg.h                                  |   1 -
 kernel/signal.c                                    |   2 +-
 net/core/net-sysfs.c                               |  39 +-
 security/selinux/hooks.c                           |  70 +-
 65 files changed, 1102 insertions(+), 688 deletions(-)

Akinobu Mita (1):
      sg: prevent integer overflow when converting from sectors to bytes

Alan Stern (1):
      USB: core: Fix free-while-in-use bug in the USB S-Glibrary

Alexander Potapenko (1):
      fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

Ben Hutchings (3):
      scsi: sg: Change next_cmd_len handling to mirror upstream
      scsi: sg: Re-fix off by one in sg_fill_request_table()
      Linux 3.16.85

Colin Ian King (1):
      ext4: unsigned int compared against zero

Dan Carpenter (3):
      scsi: mptfusion: Add bounds check in mptctl_hp_targetinfo()
      scsi: mptfusion: Fix double fetch bug in ioctl
      scsi: sg: off by one in sg_ioctl()

David Mosberger (2):
      drivers: usb: core: Don't disable irqs in usb_sg_wait() during URB submit.
      drivers: usb: core: Minimize irq disabling in usb_sg_cancel()

Douglas Gilbert (1):
      sg: O_EXCL and other lock handling

Eric Dumazet (1):
      net-sysfs: fix netdev_queue_add_kobject() breakage

Eric W. Biederman (1):
      signal: Extend exec_id to 64bits

Hannes Reinecke (8):
      scsi: sg: protect accesses to 'reserved' page array
      scsi: sg: reset 'res_in_use' after unlinking reserved array
      scsi: sg: remove 'save_scat_len'
      scsi: sg: use standard lists for sg_requests
      scsi: sg: factor out sg_fill_request_table()
      scsi: sg: fixup infoleak when using SG_GET_REQUEST_TABLE
      scsi: sg: disable SET_FORCE_LOW_DMA
      scsi: sg: close race condition in sg_remove_sfp_usercontext()

Jason A. Donenfeld (1):
      random: always use batched entropy for get_random_u{32,64}

Jia Zhang (1):
      x86/cpu: Rename cpu_data.x86_mask to cpu_data.x86_stepping

Johannes Thumshirn (5):
      scsi: sg: check for valid direction before starting the request
      scsi: sg: fix SG_DXFER_FROM_DEV transfers
      scsi: sg: fix static checker warning in sg_is_valid_dxfer
      scsi: sg: only check for dxfer_len greater than 256M
      scsi: sg: don't return bogus Sg_requests

Josh Poimboeuf (1):
      x86/speculation: Add Ivy Bridge to affected list

Jouni Hogander (7):
      slcan: Fix memory leak in error path
      can: slcan: Fix use-after-free Read in slcan_open
      slip: Fix memory leak in slip_open error path
      slip: Fix use-after-free Read in slip_open
      net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
      net-sysfs: Call dev_hold always in netdev_queue_add_kobject
      net-sysfs: Call dev_hold always in rx_queue_add_kobject

Kyungtae Kim (1):
      USB: gadget: fix illegal array access in binding with UDC

Li Bin (1):
      scsi: sg: add sg_remove_request in sg_common_write

Marek Milkovic (1):
      selinux: Print 'sclass' as string when unrecognized netlink message occurs

Mark Gross (4):
      x86/cpu: Add a steppings field to struct x86_cpu_id
      x86/cpu: Add 'table' argument to cpu_matches()
      x86/speculation: Add Special Register Buffer Data Sampling (SRBDS) mitigation
      x86/speculation: Add SRBDS vulnerability and mitigation documentation

Oliver Hartkopp (1):
      slcan: not call free_netdev before rtnl_unlock in slcan_open

Paul Moore (1):
      selinux: properly handle multiple messages in selinux_netlink_send()

Qing Xu (2):
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv()
      mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()

Richard Guy Briggs (2):
      selinux: cleanup error reporting in selinux_nlmsg_perm()
      selinux: convert WARN_ONCE() to printk() in selinux_nlmsg_perm()

Shijie Luo (1):
      ext4: add cond_resched() to ext4_protect_reserved_inode

Tahsin Erdogan (1):
      ext4: Make checks for metadata_csum feature safer

Theodore Ts'o (3):
      ext4: protect journal inode's blocks using block_validity
      ext4: fix block validity checks for journal inodes using indirect blocks
      ext4: don't perform block validity checks on the journal inode

Todd Poynor (2):
      scsi: sg: protect against races between mmap() and SG_SET_RESERVED_SIZE
      scsi: sg: recheck MMAP_IO request length with lock held

Tony Battersby (1):
      scsi: sg: fix minor memory leak in error path

Vladis Dronov (1):
      selinux: rate-limit netlink message warnings in selinux_nlmsg_perm()

Wu Bo (1):
      scsi: sg: add sg_remove_request in sg_write

yangerkun (1):
      slip: not call free_netdev before rtnl_unlock in slip_open


--qDbXVdCdHGoSgWSk
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.85.patch"
Content-Disposition: attachment; filename="linux-3.16.85.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documenta=
tion/ABI/testing/sysfs-devices-system-cpu
index 2fdfbf6337e7..19251577179b 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -232,6 +232,7 @@ What:		/sys/devices/system/cpu/vulnerabilities
 		/sys/devices/system/cpu/vulnerabilities/spec_store_bypass
 		/sys/devices/system/cpu/vulnerabilities/l1tf
 		/sys/devices/system/cpu/vulnerabilities/mds
+		/sys/devices/system/cpu/vulnerabilities/srbds
 		/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
 		/sys/devices/system/cpu/vulnerabilities/itlb_multihit
 Date:		January 2018
diff --git a/Documentation/hw-vuln/special-register-buffer-data-sampling.rs=
t b/Documentation/hw-vuln/special-register-buffer-data-sampling.rst
new file mode 100644
index 000000000000..47b1b3afac99
--- /dev/null
+++ b/Documentation/hw-vuln/special-register-buffer-data-sampling.rst
@@ -0,0 +1,149 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+SRBDS - Special Register Buffer Data Sampling
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+SRBDS is a hardware vulnerability that allows MDS :doc:`mds` techniques to
+infer values returned from special register accesses.  Special register
+accesses are accesses to off core registers.  According to Intel's evaluat=
ion,
+the special register reads that have a security expectation of privacy are
+RDRAND, RDSEED and SGX EGETKEY.
+
+When RDRAND, RDSEED and EGETKEY instructions are used, the data is moved
+to the core through the special register mechanism that is susceptible
+to MDS attacks.
+
+Affected processors
+--------------------
+Core models (desktop, mobile, Xeon-E3) that implement RDRAND and/or RDSEED=
 may
+be affected.
+
+A processor is affected by SRBDS if its Family_Model and stepping is
+in the following list, with the exception of the listed processors
+exporting MDS_NO while Intel TSX is available yet not enabled. The
+latter class of processors are only affected when Intel TSX is enabled
+by software using TSX_CTRL_MSR otherwise they are not affected.
+
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D
+  common name    Family_Model  Stepping
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D
+  IvyBridge      06_3AH        All
+
+  Haswell        06_3CH        All
+  Haswell_L      06_45H        All
+  Haswell_G      06_46H        All
+
+  Broadwell_G    06_47H        All
+  Broadwell      06_3DH        All
+
+  Skylake_L      06_4EH        All
+  Skylake        06_5EH        All
+
+  Kabylake_L     06_8EH        <=3D 0xC
+  Kabylake       06_9EH        <=3D 0xD
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D
+
+Related CVEs
+------------
+
+The following CVE entry is related to this SRBDS issue:
+
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    CVE-2020-0543   SRBDS  Special Register Buffer Data Sampling
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Attack scenarios
+----------------
+An unprivileged user can extract values returned from RDRAND and RDSEED
+executed on another core or sibling thread using MDS techniques.
+
+
+Mitigation mechanism
+-------------------
+Intel will release microcode updates that modify the RDRAND, RDSEED, and
+EGETKEY instructions to overwrite secret special register data in the shar=
ed
+staging buffer before the secret data can be accessed by another logical
+processor.
+
+During execution of the RDRAND, RDSEED, or EGETKEY instructions, off-core
+accesses from other logical processors will be delayed until the special
+register read is complete and the secret data in the shared staging buffer=
 is
+overwritten.
+
+This has three effects on performance:
+
+#. RDRAND, RDSEED, or EGETKEY instructions have higher latency.
+
+#. Executing RDRAND at the same time on multiple logical processors will be
+   serialized, resulting in an overall reduction in the maximum RDRAND
+   bandwidth.
+
+#. Executing RDRAND, RDSEED or EGETKEY will delay memory accesses from oth=
er
+   logical processors that miss their core caches, with an impact similar =
to
+   legacy locked cache-line-split accesses.
+
+The microcode updates provide an opt-out mechanism (RNGDS_MITG_DIS) to dis=
able
+the mitigation for RDRAND and RDSEED instructions executed outside of Intel
+Software Guard Extensions (Intel SGX) enclaves. On logical processors that
+disable the mitigation using this opt-out mechanism, RDRAND and RDSEED do =
not
+take longer to execute and do not impact performance of sibling logical
+processors memory accesses. The opt-out mechanism does not affect Intel SGX
+enclaves (including execution of RDRAND or RDSEED inside an enclave, as we=
ll
+as EGETKEY execution).
+
+IA32_MCU_OPT_CTRL MSR Definition
+--------------------------------
+Along with the mitigation for this issue, Intel added a new thread-scope
+IA32_MCU_OPT_CTRL MSR, (address 0x123). The presence of this MSR and
+RNGDS_MITG_DIS (bit 0) is enumerated by CPUID.(EAX=3D07H,ECX=3D0).EDX[SRBD=
S_CTRL =3D
+9]=3D=3D1. This MSR is introduced through the microcode update.
+
+Setting IA32_MCU_OPT_CTRL[0] (RNGDS_MITG_DIS) to 1 for a logical processor
+disables the mitigation for RDRAND and RDSEED executed outside of an Intel=
 SGX
+enclave on that logical processor. Opting out of the mitigation for a
+particular logical processor does not affect the RDRAND and RDSEED mitigat=
ions
+for other logical processors.
+
+Note that inside of an Intel SGX enclave, the mitigation is applied regard=
less
+of the value of RNGDS_MITG_DS.
+
+Mitigation control on the kernel command line
+---------------------------------------------
+The kernel command line allows control over the SRBDS mitigation at boot t=
ime
+with the option "srbds=3D".  The option for this is:
+
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
+  off           This option disables SRBDS mitigation for RDRAND and RDSEE=
D on
+                affected platforms.
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
+
+SRBDS System Information
+-----------------------
+The Linux kernel provides vulnerability status information through sysfs. =
 For
+SRBDS this can be accessed by the following sysfs file:
+/sys/devices/system/cpu/vulnerabilities/srbds
+
+The possible values contained in this file are:
+
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+ Not affected                   Processor not vulnerable
+ Vulnerable                     Processor vulnerable and mitigation disabl=
ed
+ Vulnerable: No microcode       Processor vulnerable and microcode is miss=
ing
+                                mitigation
+ Mitigation: Microcode          Processor is vulnerable and mitigation is =
in
+                                effect.
+ Mitigation: TSX disabled       Processor is only vulnerable when TSX is
+                                enabled while this system was booted with =
TSX
+                                disabled.
+ Unknown: Dependent on
+ hypervisor status              Running on virtual guest processor that is
+                                affected but with no way to know if host
+                                processor is mitigated or vulnerable.
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+
+SRBDS Default mitigation
+------------------------
+This new microcode serializes processor access during execution of RDRAND,
+RDSEED ensures that the shared buffer is overwritten before it is released=
 for
+reuse.  Use the "srbds=3Doff" kernel command line to disable the mitigatio=
n for
+RDRAND and RDSEED.
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-par=
ameters.txt
index 01eb7cab0419..b12d696ba116 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3356,6 +3356,26 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
 	spia_pedr=3D
 	spia_peddr=3D
=20
+	srbds=3D		[X86,INTEL]
+			Control the Special Register Buffer Data Sampling
+			(SRBDS) mitigation.
+
+			Certain CPUs are vulnerable to an MDS-like
+			exploit which can leak bits from the random
+			number generator.
+
+			By default, this issue is mitigated by
+			microcode.  However, the microcode fix can cause
+			the RDRAND and RDSEED instructions to become
+			much slower.  Among other effects, this will
+			result in reduced throughput from /dev/urandom.
+
+			The microcode mitigation can be disabled with
+			the following option:
+
+			off:    Disable mitigation and remove
+				performance impact to RDRAND and RDSEED
+
 	stack_guard_gap=3D	[MM]
 			override the default stack gap protection. The value
 			is in page units and it defines how many pages prior
diff --git a/Makefile b/Makefile
index e1c91ead7918..ed944e74529c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 84
+SUBLEVEL =3D 85
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index e06225eda635..28a11324052f 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -87,7 +87,7 @@ static inline unsigned int acpi_processor_cstate_check(un=
signed int max_cstate)
 	if (boot_cpu_data.x86 =3D=3D 0x0F &&
 	    boot_cpu_data.x86_vendor =3D=3D X86_VENDOR_AMD &&
 	    boot_cpu_data.x86_model <=3D 0x05 &&
-	    boot_cpu_data.x86_mask < 0x0A)
+	    boot_cpu_data.x86_stepping < 0x0A)
 		return 1;
 	else if (amd_e400_c1e_detected)
 		return 1;
diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cp=
u_device_id.h
index ff501e511d91..b9473858c6b6 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -8,6 +8,33 @@
=20
 #include <linux/mod_devicetable.h>
=20
+#define X86_STEPPINGS(mins, maxs)    GENMASK(maxs, mins)
+
+/**
+ * X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE - Base macro for CPU match=
ing
+ * @_vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@_vendor
+ * @_family:	The family number or X86_FAMILY_ANY
+ * @_model:	The model number, model constant or X86_MODEL_ANY
+ * @_steppings:	Bitmask for steppings, stepping constant or X86_STEPPING_A=
NY
+ * @_feature:	A X86_FEATURE bit or X86_FEATURE_ANY
+ * @_data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * Backport version to keep the SRBDS pile consistant. No shorter variants
+ * required for this.
+ */
+#define X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(_vendor, _family, _mo=
del, \
+						    _steppings, _feature, _data) { \
+	.vendor		=3D X86_VENDOR_##_vendor,				\
+	.family		=3D _family,					\
+	.model		=3D _model,					\
+	.steppings	=3D _steppings,					\
+	.feature	=3D _feature,					\
+	.driver_data	=3D (unsigned long) _data				\
+}
+
 extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *mat=
ch);
=20
 #endif
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpuf=
eatures.h
index 4ad4e3bfee4e..47aed45d0514 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -247,6 +247,7 @@
 #define X86_FEATURE_AVX512CD	( 9*32+28) /* AVX-512 Conflict Detection */
=20
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EDX), word 10 */
+#define X86_FEATURE_SRBDS_CTRL		(10*32+ 9) /* "" SRBDS mitigation MSR avai=
lable */
 #define X86_FEATURE_MD_CLEAR		(10*32+10) /* VERW clears CPU buffers */
 #define X86_FEATURE_SPEC_CTRL		(10*32+26) /* "" Speculation Control (IBRS =
+ IBPB) */
 #define X86_FEATURE_INTEL_STIBP		(10*32+27) /* "" Single Thread Indirect B=
ranch Predictors */
@@ -281,5 +282,6 @@
 #define X86_BUG_SWAPGS		X86_BUG(12) /* CPU is affected by speculation thro=
ugh SWAPGS */
 #define X86_BUG_TAA		X86_BUG(13) /* CPU is affected by TSX Async Abort(TAA=
) */
 #define X86_BUG_ITLB_MULTIHIT	X86_BUG(14) /* CPU may incur MCE during cert=
ain page attribute changes */
+#define X86_BUG_SRBDS		X86_BUG(15) /* CPU may leak RNG bits if not mitigat=
ed */
=20
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proces=
sor.h
index 9ea2413fc16d..0cd633ecef64 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -82,7 +82,7 @@ struct cpuinfo_x86 {
 	__u8			x86;		/* CPU family */
 	__u8			x86_vendor;	/* CPU vendor */
 	__u8			x86_model;
-	__u8			x86_mask;
+	__u8			x86_stepping;
 #ifdef CONFIG_X86_32
 	char			wp_works_ok;	/* It doesn't on 386's */
=20
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/=
asm/msr-index.h
index e376e780e380..a22e63c5abb6 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -90,6 +90,10 @@
 #define TSX_CTRL_RTM_DISABLE		(1UL << 0) /* Disable RTM feature */
 #define TSX_CTRL_CPUID_CLEAR		(1UL << 1) /* Disable TSX enumeration */
=20
+/* SRBDS support */
+#define MSR_IA32_MCU_OPT_CTRL		0x00000123
+#define RNGDS_MITG_DIS			BIT(0)
+
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
 #define MSR_IA32_SYSENTER_EIP		0x00000176
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 3c9d268939af..3a7e04cad598 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -116,7 +116,7 @@ int amd_cache_northbridges(void)
 	if (boot_cpu_data.x86 =3D=3D 0x10 &&
 	    boot_cpu_data.x86_model >=3D 0x8 &&
 	    (boot_cpu_data.x86_model > 0x9 ||
-	     boot_cpu_data.x86_mask >=3D 0x1))
+	     boot_cpu_data.x86_stepping >=3D 0x1))
 		amd_northbridges.flags |=3D AMD_NB_L3_INDEX_DISABLE;
=20
 	if (boot_cpu_data.x86 =3D=3D 0x15)
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets=
_32.c
index d67c4be3e8b1..45768892add5 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -27,7 +27,7 @@ void foo(void)
 	OFFSET(CPUINFO_x86, cpuinfo_x86, x86);
 	OFFSET(CPUINFO_x86_vendor, cpuinfo_x86, x86_vendor);
 	OFFSET(CPUINFO_x86_model, cpuinfo_x86, x86_model);
-	OFFSET(CPUINFO_x86_mask, cpuinfo_x86, x86_mask);
+	OFFSET(CPUINFO_x86_stepping, cpuinfo_x86, x86_stepping);
 	OFFSET(CPUINFO_cpuid_level, cpuinfo_x86, cpuid_level);
 	OFFSET(CPUINFO_x86_capability, cpuinfo_x86, x86_capability);
 	OFFSET(CPUINFO_x86_vendor_id, cpuinfo_x86, x86_vendor_id);
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ccfb36b455a4..878dc10b7db3 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -101,7 +101,7 @@ static void init_amd_k6(struct cpuinfo_x86 *c)
 		return;
 	}
=20
-	if (c->x86_model =3D=3D 6 && c->x86_mask =3D=3D 1) {
+	if (c->x86_model =3D=3D 6 && c->x86_stepping =3D=3D 1) {
 		const int K6_BUG_LOOP =3D 1000000;
 		int n;
 		void (*f_vide)(void);
@@ -131,7 +131,7 @@ static void init_amd_k6(struct cpuinfo_x86 *c)
=20
 	/* K6 with old style WHCR */
 	if (c->x86_model < 8 ||
-	   (c->x86_model =3D=3D 8 && c->x86_mask < 8)) {
+	   (c->x86_model =3D=3D 8 && c->x86_stepping < 8)) {
 		/* We can only write allocate on the low 508Mb */
 		if (mbytes > 508)
 			mbytes =3D 508;
@@ -150,7 +150,7 @@ static void init_amd_k6(struct cpuinfo_x86 *c)
 		return;
 	}
=20
-	if ((c->x86_model =3D=3D 8 && c->x86_mask > 7) ||
+	if ((c->x86_model =3D=3D 8 && c->x86_stepping > 7) ||
 	     c->x86_model =3D=3D 9 || c->x86_model =3D=3D 13) {
 		/* The more serious chips .. */
=20
@@ -190,12 +190,12 @@ static void amd_k7_smp_check(struct cpuinfo_x86 *c)
 	 * but they are not certified as MP capable.
 	 */
 	/* Athlon 660/661 is valid. */
-	if ((c->x86_model =3D=3D 6) && ((c->x86_mask =3D=3D 0) ||
-	    (c->x86_mask =3D=3D 1)))
+	if ((c->x86_model =3D=3D 6) && ((c->x86_stepping =3D=3D 0) ||
+	    (c->x86_stepping =3D=3D 1)))
 		return;
=20
 	/* Duron 670 is valid */
-	if ((c->x86_model =3D=3D 7) && (c->x86_mask =3D=3D 0))
+	if ((c->x86_model =3D=3D 7) && (c->x86_stepping =3D=3D 0))
 		return;
=20
 	/*
@@ -205,8 +205,8 @@ static void amd_k7_smp_check(struct cpuinfo_x86 *c)
 	 * See http://www.heise.de/newsticker/data/jow-18.10.01-000 for
 	 * more.
 	 */
-	if (((c->x86_model =3D=3D 6) && (c->x86_mask >=3D 2)) ||
-	    ((c->x86_model =3D=3D 7) && (c->x86_mask >=3D 1)) ||
+	if (((c->x86_model =3D=3D 6) && (c->x86_stepping >=3D 2)) ||
+	    ((c->x86_model =3D=3D 7) && (c->x86_stepping >=3D 1)) ||
 	     (c->x86_model > 7))
 		if (cpu_has_mp)
 			return;
@@ -244,7 +244,7 @@ static void init_amd_k7(struct cpuinfo_x86 *c)
 	 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
 	 * As per AMD technical note 27212 0.2
 	 */
-	if ((c->x86_model =3D=3D 8 && c->x86_mask >=3D 1) || (c->x86_model > 8)) {
+	if ((c->x86_model =3D=3D 8 && c->x86_stepping >=3D 1) || (c->x86_model > =
8)) {
 		rdmsr(MSR_K7_CLK_CTL, l, h);
 		if ((l & 0xfff00000) !=3D 0x20000000) {
 			printk(KERN_INFO
@@ -514,7 +514,7 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 	/*  Set MTRR capability flag if appropriate */
 	if (c->x86 =3D=3D 5)
 		if (c->x86_model =3D=3D 13 || c->x86_model =3D=3D 9 ||
-		    (c->x86_model =3D=3D 8 && c->x86_mask >=3D 8))
+		    (c->x86_model =3D=3D 8 && c->x86_stepping >=3D 8))
 			set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_PCI)
@@ -561,7 +561,7 @@ static void init_amd_zn(struct cpuinfo_x86 *c)
 	 * Fix erratum 1076: CPB feature bit not being set in CPUID. It affects
 	 * all up to and including B1.
 	 */
-	if (c->x86_model <=3D 1 && c->x86_mask <=3D 1)
+	if (c->x86_model <=3D 1 && c->x86_stepping <=3D 1)
 		set_cpu_cap(c, X86_FEATURE_CPB);
 }
=20
@@ -810,11 +810,11 @@ static unsigned int amd_size_cache(struct cpuinfo_x86=
 *c, unsigned int size)
 	/* AMD errata T13 (order #21922) */
 	if ((c->x86 =3D=3D 6)) {
 		/* Duron Rev A0 */
-		if (c->x86_model =3D=3D 3 && c->x86_mask =3D=3D 0)
+		if (c->x86_model =3D=3D 3 && c->x86_stepping =3D=3D 0)
 			size =3D 64;
 		/* Tbird rev A1/A2 */
 		if (c->x86_model =3D=3D 4 &&
-			(c->x86_mask =3D=3D 0 || c->x86_mask =3D=3D 1))
+			(c->x86_stepping =3D=3D 0 || c->x86_stepping =3D=3D 1))
 			size =3D 256;
 	}
 	return size;
@@ -951,7 +951,7 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu=
, const int *erratum)
 	}
=20
 	/* OSVW unavailable or ID unknown, match family-model-stepping range */
-	ms =3D (cpu->x86_model << 4) | cpu->x86_mask;
+	ms =3D (cpu->x86_model << 4) | cpu->x86_stepping;
 	while ((range =3D *erratum++))
 		if ((cpu->x86 =3D=3D AMD_MODEL_RANGE_FAMILY(range)) &&
 		    (ms >=3D AMD_MODEL_RANGE_START(range)) &&
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 9739e4436e79..f1367b95b8d3 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -38,6 +38,7 @@ static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
 static void __init taa_select_mitigation(void);
+static void __init srbds_select_mitigation(void);
=20
 /* The base value of the SPEC_CTRL MSR that always has to be preserved. */
 u64 x86_spec_ctrl_base;
@@ -159,6 +160,7 @@ void __init check_bugs(void)
 	l1tf_select_mitigation();
 	mds_select_mitigation();
 	taa_select_mitigation();
+	srbds_select_mitigation();
=20
 	arch_smt_update();
=20
@@ -416,6 +418,97 @@ static int __init tsx_async_abort_parse_cmdline(char *=
str)
 }
 early_param("tsx_async_abort", tsx_async_abort_parse_cmdline);
=20
+#undef pr_fmt
+#define pr_fmt(fmt)	"SRBDS: " fmt
+
+enum srbds_mitigations {
+	SRBDS_MITIGATION_OFF,
+	SRBDS_MITIGATION_UCODE_NEEDED,
+	SRBDS_MITIGATION_FULL,
+	SRBDS_MITIGATION_TSX_OFF,
+	SRBDS_MITIGATION_HYPERVISOR,
+};
+
+static enum srbds_mitigations srbds_mitigation =3D SRBDS_MITIGATION_FULL;
+
+static const char * const srbds_strings[] =3D {
+	[SRBDS_MITIGATION_OFF]		=3D "Vulnerable",
+	[SRBDS_MITIGATION_UCODE_NEEDED]	=3D "Vulnerable: No microcode",
+	[SRBDS_MITIGATION_FULL]		=3D "Mitigation: Microcode",
+	[SRBDS_MITIGATION_TSX_OFF]	=3D "Mitigation: TSX disabled",
+	[SRBDS_MITIGATION_HYPERVISOR]	=3D "Unknown: Dependent on hypervisor statu=
s",
+};
+
+static bool srbds_off;
+
+void update_srbds_msr(void)
+{
+	u64 mcu_ctrl;
+
+	if (!boot_cpu_has_bug(X86_BUG_SRBDS))
+		return;
+
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return;
+
+	if (srbds_mitigation =3D=3D SRBDS_MITIGATION_UCODE_NEEDED)
+		return;
+
+	rdmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_ctrl);
+
+	switch (srbds_mitigation) {
+	case SRBDS_MITIGATION_OFF:
+	case SRBDS_MITIGATION_TSX_OFF:
+		mcu_ctrl |=3D RNGDS_MITG_DIS;
+		break;
+	case SRBDS_MITIGATION_FULL:
+		mcu_ctrl &=3D ~RNGDS_MITG_DIS;
+		break;
+	default:
+		break;
+	}
+
+	wrmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_ctrl);
+}
+
+static void __init srbds_select_mitigation(void)
+{
+	u64 ia32_cap;
+
+	if (!boot_cpu_has_bug(X86_BUG_SRBDS))
+		return;
+
+	/*
+	 * Check to see if this is one of the MDS_NO systems supporting
+	 * TSX that are only exposed to SRBDS when TSX is enabled.
+	 */
+	ia32_cap =3D x86_read_arch_cap_msr();
+	if ((ia32_cap & ARCH_CAP_MDS_NO) && !boot_cpu_has(X86_FEATURE_RTM))
+		srbds_mitigation =3D SRBDS_MITIGATION_TSX_OFF;
+	else if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		srbds_mitigation =3D SRBDS_MITIGATION_HYPERVISOR;
+	else if (!boot_cpu_has(X86_FEATURE_SRBDS_CTRL))
+		srbds_mitigation =3D SRBDS_MITIGATION_UCODE_NEEDED;
+	else if (cpu_mitigations_off() || srbds_off)
+		srbds_mitigation =3D SRBDS_MITIGATION_OFF;
+
+	update_srbds_msr();
+	pr_info("%s\n", srbds_strings[srbds_mitigation]);
+}
+
+static int __init srbds_parse_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!boot_cpu_has_bug(X86_BUG_SRBDS))
+		return 0;
+
+	srbds_off =3D !strcmp(str, "off");
+	return 0;
+}
+early_param("srbds", srbds_parse_cmdline);
+
 #undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V1 : " fmt
=20
@@ -1422,6 +1515,11 @@ static char *ibpb_state(void)
 	return "";
 }
=20
+static ssize_t srbds_show_state(char *buf)
+{
+	return sprintf(buf, "%s\n", srbds_strings[srbds_mitigation]);
+}
+
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute=
 *attr,
 			       char *buf, unsigned int bug)
 {
@@ -1463,6 +1561,9 @@ static ssize_t cpu_show_common(struct device *dev, st=
ruct device_attribute *attr
 	case X86_BUG_ITLB_MULTIHIT:
 		return itlb_multihit_show_state(buf);
=20
+	case X86_BUG_SRBDS:
+		return srbds_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1509,4 +1610,9 @@ ssize_t cpu_show_itlb_multihit(struct device *dev, st=
ruct device_attribute *attr
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_ITLB_MULTIHIT);
 }
+
+ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr, =
char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_SRBDS);
+}
 #endif
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 5468a6067588..4ff55c676a13 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -134,7 +134,7 @@ static void init_centaur(struct cpuinfo_x86 *c)
 			clear_cpu_cap(c, X86_FEATURE_TSC);
 			break;
 		case 8:
-			switch (c->x86_mask) {
+			switch (c->x86_stepping) {
 			default:
 			name =3D "2";
 				break;
@@ -209,7 +209,7 @@ centaur_size_cache(struct cpuinfo_x86 *c, unsigned int =
size)
 	 *  - Note, it seems this may only be in engineering samples.
 	 */
 	if ((c->x86 =3D=3D 6) && (c->x86_model =3D=3D 9) &&
-				(c->x86_mask =3D=3D 1) && (size =3D=3D 65))
+				(c->x86_stepping =3D=3D 1) && (size =3D=3D 65))
 		size -=3D 1;
 	return size;
 }
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e6d410f83bab..95f06271fdec 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -659,7 +659,7 @@ void cpu_detect(struct cpuinfo_x86 *c)
 		cpuid(0x00000001, &tfms, &misc, &junk, &cap0);
 		c->x86 =3D (tfms >> 8) & 0xf;
 		c->x86_model =3D (tfms >> 4) & 0xf;
-		c->x86_mask =3D tfms & 0xf;
+		c->x86_stepping =3D tfms & 0xf;
=20
 		if (c->x86 =3D=3D 0xf)
 			c->x86 +=3D (tfms >> 20) & 0xff;
@@ -872,9 +872,30 @@ static const __initconst struct x86_cpu_id cpu_vuln_wh=
itelist[] =3D {
 	{}
 };
=20
-static bool __init cpu_matches(unsigned long which)
+#define VULNBL_INTEL_STEPPINGS(model, steppings, issues)		   \
+	X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(INTEL, 6,		   \
+					    INTEL_FAM6_##model, steppings, \
+					    X86_FEATURE_ANY, issues)
+
+#define SRBDS		BIT(0)
+
+static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst =3D {
+	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(HASWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(HASWELL_ULT,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(HASWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(BROADWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(BROADWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x0, 0xC),	SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x0, 0xD),	SRBDS),
+	{}
+};
+
+static bool __init cpu_matches(const struct x86_cpu_id *table, unsigned lo=
ng which)
 {
-	const struct x86_cpu_id *m =3D x86_match_cpu(cpu_vuln_whitelist);
+	const struct x86_cpu_id *m =3D x86_match_cpu(table);
=20
 	return m && !!(m->driver_data & which);
 }
@@ -894,29 +915,32 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x8=
6 *c)
 	u64 ia32_cap =3D x86_read_arch_cap_msr();
=20
 	/* Set ITLB_MULTIHIT bug if cpu is not in the whitelist and not mitigated=
 */
-	if (!cpu_matches(NO_ITLB_MULTIHIT) && !(ia32_cap & ARCH_CAP_PSCHANGE_MC_N=
O))
+	if (!cpu_matches(cpu_vuln_whitelist, NO_ITLB_MULTIHIT) &&
+	    !(ia32_cap & ARCH_CAP_PSCHANGE_MC_NO))
 		setup_force_cpu_bug(X86_BUG_ITLB_MULTIHIT);
=20
-	if (cpu_matches(NO_SPECULATION))
+	if (cpu_matches(cpu_vuln_whitelist, NO_SPECULATION))
 		return;
=20
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
=20
-	if (!cpu_matches(NO_SSB) && !(ia32_cap & ARCH_CAP_SSB_NO) &&
+	if (!cpu_matches(cpu_vuln_whitelist, NO_SSB) &&
+	    !(ia32_cap & ARCH_CAP_SSB_NO) &&
 	   !cpu_has(c, X86_FEATURE_AMD_SSB_NO))
 		setup_force_cpu_bug(X86_BUG_SPEC_STORE_BYPASS);
=20
 	if (ia32_cap & ARCH_CAP_IBRS_ALL)
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
=20
-	if (!cpu_matches(NO_MDS) && !(ia32_cap & ARCH_CAP_MDS_NO)) {
+	if (!cpu_matches(cpu_vuln_whitelist, NO_MDS) &&
+	    !(ia32_cap & ARCH_CAP_MDS_NO)) {
 		setup_force_cpu_bug(X86_BUG_MDS);
-		if (cpu_matches(MSBDS_ONLY))
+		if (cpu_matches(cpu_vuln_whitelist, MSBDS_ONLY))
 			setup_force_cpu_bug(X86_BUG_MSBDS_ONLY);
 	}
=20
-	if (!cpu_matches(NO_SWAPGS))
+	if (!cpu_matches(cpu_vuln_whitelist, NO_SWAPGS))
 		setup_force_cpu_bug(X86_BUG_SWAPGS);
=20
 	/*
@@ -934,7 +958,16 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86=
 *c)
 	     (ia32_cap & ARCH_CAP_TSX_CTRL_MSR)))
 		setup_force_cpu_bug(X86_BUG_TAA);
=20
-	if (cpu_matches(NO_MELTDOWN))
+	/*
+	 * SRBDS affects CPUs which support RDRAND or RDSEED and are listed
+	 * in the vulnerability blacklist.
+	 */
+	if ((cpu_has(c, X86_FEATURE_RDRAND) ||
+	     cpu_has(c, X86_FEATURE_RDSEED)) &&
+	    cpu_matches(cpu_vuln_blacklist, SRBDS))
+		    setup_force_cpu_bug(X86_BUG_SRBDS);
+
+	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
=20
 	/* Rogue Data Cache Load? No! */
@@ -943,7 +976,7 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 =
*c)
=20
 	setup_force_cpu_bug(X86_BUG_CPU_MELTDOWN);
=20
-	if (cpu_matches(NO_L1TF))
+	if (cpu_matches(cpu_vuln_whitelist, NO_L1TF))
 		return;
=20
 	setup_force_cpu_bug(X86_BUG_L1TF);
@@ -1095,7 +1128,7 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	c->loops_per_jiffy =3D loops_per_jiffy;
 	c->x86_cache_size =3D 0;
 	c->x86_vendor =3D X86_VENDOR_UNKNOWN;
-	c->x86_model =3D c->x86_mask =3D 0;	/* So far unknown... */
+	c->x86_model =3D c->x86_stepping =3D 0;	/* So far unknown... */
 	c->x86_vendor_id[0] =3D '\0'; /* Unset */
 	c->x86_model_id[0] =3D '\0';  /* Unset */
 	c->x86_max_cores =3D 1;
@@ -1280,6 +1313,7 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
 #endif
 	mtrr_ap_init();
 	x86_spec_ctrl_setup_ap();
+	update_srbds_msr();
 }
=20
 struct msr_range {
@@ -1356,8 +1390,8 @@ void print_cpu_info(struct cpuinfo_x86 *c)
=20
 	printk(KERN_CONT " (fam: %02x, model: %02x", c->x86, c->x86_model);
=20
-	if (c->x86_mask || c->cpuid_level >=3D 0)
-		printk(KERN_CONT ", stepping: %02x)\n", c->x86_mask);
+	if (c->x86_stepping || c->cpuid_level >=3D 0)
+		printk(KERN_CONT ", stepping: %02x)\n", c->x86_stepping);
 	else
 		printk(KERN_CONT ")\n");
=20
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 6c81eb018ce9..71c2b191fb5c 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -63,6 +63,7 @@ extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
 =20
 extern void x86_spec_ctrl_setup_ap(void);
+extern void update_srbds_msr(void);
=20
 extern u64 x86_read_arch_cap_msr(void);
=20
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 15e47c1cd412..e297ef0cfffb 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -212,7 +212,7 @@ static void init_cyrix(struct cpuinfo_x86 *c)
=20
 	/* common case step number/rev -- exceptions handled below */
 	c->x86_model =3D (dir1 >> 4) + 1;
-	c->x86_mask =3D dir1 & 0xf;
+	c->x86_stepping =3D dir1 & 0xf;
=20
 	/* Now cook; the original recipe is by Channing Corn, from Cyrix.
 	 * We do the same thing for each generation: we work out
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 224957084d38..8f119fef01e3 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -81,7 +81,7 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
=20
 	for (i =3D 0; i < ARRAY_SIZE(spectre_bad_microcodes); i++) {
 		if (c->x86_model =3D=3D spectre_bad_microcodes[i].model &&
-		    c->x86_mask =3D=3D spectre_bad_microcodes[i].stepping)
+		    c->x86_stepping =3D=3D spectre_bad_microcodes[i].stepping)
 			return (c->microcode <=3D spectre_bad_microcodes[i].microcode);
 	}
 	return false;
@@ -131,7 +131,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 * need the microcode to have already been loaded... so if it is
 	 * not, recommend a BIOS update and disable large pages.
 	 */
-	if (c->x86 =3D=3D 6 && c->x86_model =3D=3D 0x1c && c->x86_mask <=3D 2 &&
+	if (c->x86 =3D=3D 6 && c->x86_model =3D=3D 0x1c && c->x86_stepping <=3D 2=
 &&
 	    c->microcode < 0x20e) {
 		printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update re=
commended\n");
 		clear_cpu_cap(c, X86_FEATURE_PSE);
@@ -147,7 +147,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
=20
 	/* CPUID workaround for 0F33/0F34 CPU */
 	if (c->x86 =3D=3D 0xF && c->x86_model =3D=3D 0x3
-	    && (c->x86_mask =3D=3D 0x3 || c->x86_mask =3D=3D 0x4))
+	    && (c->x86_stepping =3D=3D 0x3 || c->x86_stepping =3D=3D 0x4))
 		c->x86_phys_bits =3D 36;
=20
 	/*
@@ -246,7 +246,7 @@ int ppro_with_ram_bug(void)
 	if (boot_cpu_data.x86_vendor =3D=3D X86_VENDOR_INTEL &&
 	    boot_cpu_data.x86 =3D=3D 6 &&
 	    boot_cpu_data.x86_model =3D=3D 1 &&
-	    boot_cpu_data.x86_mask < 8) {
+	    boot_cpu_data.x86_stepping < 8) {
 		printk(KERN_INFO "Pentium Pro with Errata#50 detected. Taking evasive ac=
tion.\n");
 		return 1;
 	}
@@ -263,7 +263,7 @@ static void intel_smp_check(struct cpuinfo_x86 *c)
 	 * Mask B, Pentium, but not Pentium MMX
 	 */
 	if (c->x86 =3D=3D 5 &&
-	    c->x86_mask >=3D 1 && c->x86_mask <=3D 4 &&
+	    c->x86_stepping >=3D 1 && c->x86_stepping <=3D 4 &&
 	    c->x86_model <=3D 3) {
 		/*
 		 * Remember we have B step Pentia with bugs
@@ -305,7 +305,7 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 	 * SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until
 	 * model 3 mask 3
 	 */
-	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
+	if ((c->x86<<8 | c->x86_model<<4 | c->x86_stepping) < 0x633)
 		clear_cpu_cap(c, X86_FEATURE_SEP);
=20
 	/*
@@ -323,7 +323,7 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 	 * P4 Xeon errata 037 workaround.
 	 * Hardware prefetcher may cause stale data to be loaded into the cache.
 	 */
-	if ((c->x86 =3D=3D 15) && (c->x86_model =3D=3D 1) && (c->x86_mask =3D=3D =
1)) {
+	if ((c->x86 =3D=3D 15) && (c->x86_model =3D=3D 1) && (c->x86_stepping =3D=
=3D 1)) {
 		if (msr_set_bit(MSR_IA32_MISC_ENABLE,
 				MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE_BIT)
 		    > 0) {
@@ -339,7 +339,7 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 	 * Specification Update").
 	 */
 	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) =3D=3D 0x520 &&
-	    (c->x86_mask < 0x6 || c->x86_mask =3D=3D 0xb))
+	    (c->x86_stepping < 0x6 || c->x86_stepping =3D=3D 0xb))
 		set_cpu_cap(c, X86_FEATURE_11AP);
=20
=20
@@ -523,7 +523,7 @@ static void init_intel(struct cpuinfo_x86 *c)
 		case 6:
 			if (l2 =3D=3D 128)
 				p =3D "Celeron (Mendocino)";
-			else if (c->x86_mask =3D=3D 0 || c->x86_mask =3D=3D 5)
+			else if (c->x86_stepping =3D=3D 0 || c->x86_stepping =3D=3D 5)
 				p =3D "Celeron-A";
 			break;
=20
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index fbb5e90557a5..a207aaaf78db 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -33,13 +33,18 @@ const struct x86_cpu_id *x86_match_cpu(const struct x86=
_cpu_id *match)
 	const struct x86_cpu_id *m;
 	struct cpuinfo_x86 *c =3D &boot_cpu_data;
=20
-	for (m =3D match; m->vendor | m->family | m->model | m->feature; m++) {
+	for (m =3D match;
+	     m->vendor | m->family | m->model | m->steppings | m->feature;
+	     m++) {
 		if (m->vendor !=3D X86_VENDOR_ANY && c->x86_vendor !=3D m->vendor)
 			continue;
 		if (m->family !=3D X86_FAMILY_ANY && c->x86 !=3D m->family)
 			continue;
 		if (m->model !=3D X86_MODEL_ANY && c->x86_model !=3D m->model)
 			continue;
+		if (m->steppings !=3D X86_STEPPING_ANY &&
+		    !(BIT(c->x86_stepping) & m->steppings))
+			continue;
 		if (m->feature !=3D X86_FEATURE_ANY && !cpu_has(c, m->feature))
 			continue;
 		return m;
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/mi=
crocode/intel.c
index 96fc70c033a2..6f0d056b47bf 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -291,7 +291,7 @@ static bool is_blacklisted(unsigned int cpu)
 	 */
 	if (c->x86 =3D=3D 6 &&
 	    c->x86_model =3D=3D 0x4F &&
-	    c->x86_mask =3D=3D 0x01 &&
+	    c->x86_stepping =3D=3D 0x01 &&
 	    llc_size_per_core > 2621440 &&
 	    c->microcode < 0x0b000021) {
 		pr_err_once("Erratum BDF90: late loading with revision < 0x0b000021 (0x%=
x) disabled.\n", c->microcode);
@@ -314,7 +314,7 @@ static enum ucode_state request_microcode_fw(int cpu, s=
truct device *device,
 		return UCODE_NFOUND;
=20
 	sprintf(name, "intel-ucode/%02x-%02x-%02x",
-		c->x86, c->x86_model, c->x86_mask);
+		c->x86, c->x86_model, c->x86_stepping);
=20
 	if (request_firmware_direct(&firmware, name, device)) {
 		pr_debug("data file %s load failed\n", name);
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/=
generic.c
index 0e25a1bc5ab5..cf0ef3412903 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -791,7 +791,7 @@ int generic_validate_add_page(unsigned long base, unsig=
ned long size,
 	 */
 	if (is_cpu(INTEL) && boot_cpu_data.x86 =3D=3D 6 &&
 	    boot_cpu_data.x86_model =3D=3D 1 &&
-	    boot_cpu_data.x86_mask <=3D 7) {
+	    boot_cpu_data.x86_stepping <=3D 7) {
 		if (base & ((1 << (22 - PAGE_SHIFT)) - 1)) {
 			pr_warning("mtrr: base(0x%lx000) is not 4 MiB aligned\n", base);
 			return -EINVAL;
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/mai=
n.c
index 44668915fa07..cb717ed27188 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -688,8 +688,8 @@ void __init mtrr_bp_init(void)
 			if (boot_cpu_data.x86_vendor =3D=3D X86_VENDOR_INTEL &&
 			    boot_cpu_data.x86 =3D=3D 0xF &&
 			    boot_cpu_data.x86_model =3D=3D 0x3 &&
-			    (boot_cpu_data.x86_mask =3D=3D 0x3 ||
-			     boot_cpu_data.x86_mask =3D=3D 0x4))
+			    (boot_cpu_data.x86_stepping =3D=3D 0x3 ||
+			     boot_cpu_data.x86_stepping =3D=3D 0x4))
 				phys_addr =3D 36;
=20
 			size_or_mask =3D SIZE_OR_MASK_BITS(phys_addr);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/p=
erf_event_intel.c
index 6cb22df3a92e..e91d9891a82a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2192,7 +2192,7 @@ static int intel_snb_pebs_broken(int cpu)
 		break;
=20
 	case 45: /* SNB-EP */
-		switch (cpu_data(cpu).x86_mask) {
+		switch (cpu_data(cpu).x86_stepping) {
 		case 6: rev =3D 0x618; break;
 		case 7: rev =3D 0x70c; break;
 		}
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/c=
pu/perf_event_intel_lbr.c
index 32a14fe2a65c..222b47f20847 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -763,7 +763,7 @@ void intel_pmu_lbr_init_atom(void)
 	 * on PMU interrupt
 	 */
 	if (boot_cpu_data.x86_model =3D=3D 28
-	    && boot_cpu_data.x86_mask < 10) {
+	    && boot_cpu_data.x86_stepping < 10) {
 		pr_cont("LBR disabled due to erratum");
 		return;
 	}
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf=
_event_p6.c
index 7c1a0c07b607..507e2e319f52 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -233,7 +233,7 @@ static __initconst const struct x86_pmu p6_pmu =3D {
=20
 static __init void p6_pmu_rdpmc_quirk(void)
 {
-	if (boot_cpu_data.x86_mask < 9) {
+	if (boot_cpu_data.x86_stepping < 9) {
 		/*
 		 * PPro erratum 26; fixed in stepping 9 and above.
 		 */
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 4af9be1c07eb..b8d40e046d0b 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -69,8 +69,8 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		   c->x86_model,
 		   c->x86_model_id[0] ? c->x86_model_id : "unknown");
=20
-	if (c->x86_mask || c->cpuid_level >=3D 0)
-		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
+	if (c->x86_stepping || c->cpuid_level >=3D 0)
+		seq_printf(m, "stepping\t: %d\n", c->x86_stepping);
 	else
 		seq_printf(m, "stepping\t: unknown\n");
 	if (c->microcode)
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 736330f96d93..302969718d54 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -33,7 +33,7 @@
 #define X86		new_cpu_data+CPUINFO_x86
 #define X86_VENDOR	new_cpu_data+CPUINFO_x86_vendor
 #define X86_MODEL	new_cpu_data+CPUINFO_x86_model
-#define X86_MASK	new_cpu_data+CPUINFO_x86_mask
+#define X86_STEPPING	new_cpu_data+CPUINFO_x86_stepping
 #define X86_HARD_MATH	new_cpu_data+CPUINFO_hard_math
 #define X86_CPUID	new_cpu_data+CPUINFO_cpuid_level
 #define X86_CAPABILITY	new_cpu_data+CPUINFO_x86_capability
@@ -433,7 +433,7 @@ ENTRY(startup_32_smp)
 	shrb $4,%al
 	movb %al,X86_MODEL
 	andb $0x0f,%cl		# mask mask revision
-	movb %cl,X86_MASK
+	movb %cl,X86_STEPPING
 	movl %edx,X86_CAPABILITY
=20
 is486:
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d2b56489d70f..ea6715138021 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -409,7 +409,7 @@ static inline void __init construct_default_ISA_mptable=
(int mpc_default_type)
 	processor.apicver =3D mpc_default_type > 4 ? 0x10 : 0x01;
 	processor.cpuflag =3D CPU_ENABLED;
 	processor.cpufeature =3D (boot_cpu_data.x86 << 8) |
-	    (boot_cpu_data.x86_model << 4) | boot_cpu_data.x86_mask;
+	    (boot_cpu_data.x86_model << 4) | boot_cpu_data.x86_stepping;
 	processor.featureflag =3D boot_cpu_data.x86_capability[0];
 	processor.reserved[0] =3D 0;
 	processor.reserved[1] =3D 0;
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 9f7d6b1b1eb2..0c8289d5aae8 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -469,6 +469,12 @@ ssize_t __weak cpu_show_itlb_multihit(struct device *d=
ev,
 	return sprintf(buf, "Not affected\n");
 }
=20
+ssize_t __weak cpu_show_srbds(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
@@ -477,6 +483,7 @@ static DEVICE_ATTR(l1tf, 0444, cpu_show_l1tf, NULL);
 static DEVICE_ATTR(mds, 0444, cpu_show_mds, NULL);
 static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
 static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
+static DEVICE_ATTR(srbds, 0444, cpu_show_srbds, NULL);
=20
 static struct attribute *cpu_root_vulnerabilities_attrs[] =3D {
 	&dev_attr_meltdown.attr,
@@ -487,6 +494,7 @@ static struct attribute *cpu_root_vulnerabilities_attrs=
[] =3D {
 	&dev_attr_mds.attr,
 	&dev_attr_tsx_async_abort.attr,
 	&dev_attr_itlb_multihit.attr,
+	&dev_attr_srbds.attr,
 	NULL
 };
=20
diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-=
rng.c
index de5a6dcfb3e2..64313dbdecba 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -166,7 +166,7 @@ static int via_rng_init(struct hwrng *rng)
 	/* Enable secondary noise source on CPUs where it is present. */
=20
 	/* Nehemiah stepping 8 and higher */
-	if ((c->x86_model =3D=3D 9) && (c->x86_mask > 7))
+	if ((c->x86_model =3D=3D 9) && (c->x86_stepping > 7))
 		lo |=3D VIA_NOISESRC2;
=20
 	/* Esther */
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0787fa2bdf27..4fd33598ce0a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1700,9 +1700,6 @@ unsigned int get_random_int(void)
 	__u32 *hash;
 	unsigned int ret;
=20
-	if (arch_get_random_int(&ret))
-		return ret;
-
 	hash =3D get_cpu_var(get_random_int_hash);
=20
 	hash[0] +=3D current->pid + jiffies + random_get_entropy();
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index b0c18ed8d83f..ec3c0afb1bb2 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -628,7 +628,7 @@ static int acpi_cpufreq_blacklist(struct cpuinfo_x86 *c)
 	if (c->x86_vendor =3D=3D X86_VENDOR_INTEL) {
 		if ((c->x86 =3D=3D 15) &&
 		    (c->x86_model =3D=3D 6) &&
-		    (c->x86_mask =3D=3D 8)) {
+		    (c->x86_stepping =3D=3D 8)) {
 			printk(KERN_INFO "acpi-cpufreq: Intel(R) "
 			    "Xeon(R) 7100 Errata AL30, processors may "
 			    "lock up on frequency changes: disabling "
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index c913906a719e..74ff01e77b95 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -786,7 +786,7 @@ static int longhaul_cpu_init(struct cpufreq_policy *pol=
icy)
 		break;
=20
 	case 7:
-		switch (c->x86_mask) {
+		switch (c->x86_stepping) {
 		case 0:
 			longhaul_version =3D TYPE_LONGHAUL_V1;
 			cpu_model =3D CPU_SAMUEL2;
@@ -798,7 +798,7 @@ static int longhaul_cpu_init(struct cpufreq_policy *pol=
icy)
 			break;
 		case 1 ... 15:
 			longhaul_version =3D TYPE_LONGHAUL_V2;
-			if (c->x86_mask < 8) {
+			if (c->x86_stepping < 8) {
 				cpu_model =3D CPU_SAMUEL2;
 				cpuname =3D "C3 'Samuel 2' [C5B]";
 			} else {
@@ -825,7 +825,7 @@ static int longhaul_cpu_init(struct cpufreq_policy *pol=
icy)
 		numscales =3D 32;
 		memcpy(mults, nehemiah_mults, sizeof(nehemiah_mults));
 		memcpy(eblcr, nehemiah_eblcr, sizeof(nehemiah_eblcr));
-		switch (c->x86_mask) {
+		switch (c->x86_stepping) {
 		case 0 ... 1:
 			cpu_model =3D CPU_NEHEMIAH;
 			cpuname =3D "C3 'Nehemiah A' [C5XLOE]";
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 529cfd92158f..3ab037775c04 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -176,7 +176,7 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *p=
olicy)
 #endif
=20
 	/* Errata workaround */
-	cpuid =3D (c->x86 << 8) | (c->x86_model << 4) | c->x86_mask;
+	cpuid =3D (c->x86 << 8) | (c->x86_model << 4) | c->x86_stepping;
 	switch (cpuid) {
 	case 0x0f07:
 	case 0x0f0a:
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index e61e224475ad..d8f4ef994c73 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -133,7 +133,7 @@ static int check_powernow(void)
 		return 0;
 	}
=20
-	if ((c->x86_model =3D=3D 6) && (c->x86_mask =3D=3D 0)) {
+	if ((c->x86_model =3D=3D 6) && (c->x86_stepping =3D=3D 0)) {
 		printk(KERN_INFO PFX "K7 660[A0] core detected, "
 				"enabling errata workarounds\n");
 		have_a0 =3D 1;
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedst=
ep-centrino.c
index 7d4a31571608..a7e72a51806a 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -36,7 +36,7 @@ struct cpu_id
 {
 	__u8	x86;            /* CPU family */
 	__u8	x86_model;	/* model */
-	__u8	x86_mask;	/* stepping */
+	__u8	x86_stepping;	/* stepping */
 };
=20
 enum {
@@ -276,7 +276,7 @@ static int centrino_verify_cpu_id(const struct cpuinfo_=
x86 *c,
 {
 	if ((c->x86 =3D=3D x->x86) &&
 	    (c->x86_model =3D=3D x->x86_model) &&
-	    (c->x86_mask =3D=3D x->x86_mask))
+	    (c->x86_stepping =3D=3D x->x86_stepping))
 		return 1;
 	return 0;
 }
diff --git a/drivers/cpufreq/speedstep-lib.c b/drivers/cpufreq/speedstep-li=
b.c
index 4ab7a2156672..ee4a8f2def34 100644
--- a/drivers/cpufreq/speedstep-lib.c
+++ b/drivers/cpufreq/speedstep-lib.c
@@ -270,9 +270,9 @@ unsigned int speedstep_detect_processor(void)
 		ebx =3D cpuid_ebx(0x00000001);
 		ebx &=3D 0x000000FF;
=20
-		pr_debug("ebx value is %x, x86_mask is %x\n", ebx, c->x86_mask);
+		pr_debug("ebx value is %x, x86_stepping is %x\n", ebx, c->x86_stepping);
=20
-		switch (c->x86_mask) {
+		switch (c->x86_stepping) {
 		case 4:
 			/*
 			 * B-stepping [M-P4-M]
@@ -359,7 +359,7 @@ unsigned int speedstep_detect_processor(void)
 				msr_lo, msr_hi);
 		if ((msr_hi & (1<<18)) &&
 		    (relaxed_check ? 1 : (msr_hi & (3<<24)))) {
-			if (c->x86_mask =3D=3D 0x01) {
+			if (c->x86_stepping =3D=3D 0x01) {
 				pr_debug("early PIII version\n");
 				return SPEEDSTEP_CPU_PIII_C_EARLY;
 			} else
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 2250db026198..6b706544b279 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -535,7 +535,7 @@ static int __init padlock_init(void)
=20
 	printk(KERN_NOTICE PFX "Using VIA PadLock ACE for AES algorithm.\n");
=20
-	if (c->x86 =3D=3D 6 && c->x86_model =3D=3D 15 && c->x86_mask =3D=3D 2) {
+	if (c->x86 =3D=3D 6 && c->x86_model =3D=3D 15 && c->x86_stepping =3D=3D 2=
) {
 		ecb_fetch_blocks =3D MAX_ECB_FETCH_BLOCKS;
 		cbc_fetch_blocks =3D MAX_CBC_FETCH_BLOCKS;
 		printk(KERN_NOTICE PFX "VIA Nano stepping 2 detected: enabling workaroun=
d.\n");
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5fde910aeb62..0b612d240202 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2576,7 +2576,7 @@ static struct amd64_family_type *per_family_init(stru=
ct amd64_pvt *pvt)
 	struct amd64_family_type *fam_type =3D NULL;
=20
 	pvt->ext_model  =3D boot_cpu_data.x86_model >> 4;
-	pvt->stepping	=3D boot_cpu_data.x86_mask;
+	pvt->stepping	=3D boot_cpu_data.x86_stepping;
 	pvt->model	=3D boot_cpu_data.x86_model;
 	pvt->fam	=3D boot_cpu_data.x86;
=20
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 5f43620d580a..064ef95f9aad 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -744,7 +744,7 @@ int amd_decode_mce(struct notifier_block *nb, unsigned =
long val, void *data)
=20
 	pr_emerg(HW_ERR "CPU:%d (%x:%x:%x) MC%d_STATUS[%s|%s|%s|%s|%s",
 		m->extcpu,
-		c->x86, c->x86_model, c->x86_mask,
+		c->x86, c->x86_model, c->x86_stepping,
 		m->bank,
 		((m->status & MCI_STATUS_OVER)	? "Over"  : "-"),
 		((m->status & MCI_STATUS_UC)	? "UE"	  : "CE"),
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index d76f0b70c6e0..4cf3b791e88e 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -268,13 +268,13 @@ static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id=
, struct device *dev)
 	for (i =3D 0; i < ARRAY_SIZE(tjmax_model_table); i++) {
 		const struct tjmax_model *tm =3D &tjmax_model_table[i];
 		if (c->x86_model =3D=3D tm->model &&
-		    (tm->mask =3D=3D ANY || c->x86_mask =3D=3D tm->mask))
+		    (tm->mask =3D=3D ANY || c->x86_stepping =3D=3D tm->mask))
 			return tm->tjmax;
 	}
=20
 	/* Early chips have no MSR for TjMax */
=20
-	if (c->x86_model =3D=3D 0xf && c->x86_mask < 4)
+	if (c->x86_model =3D=3D 0xf && c->x86_stepping < 4)
 		usemsr_ee =3D 0;
=20
 	if (c->x86_model > 0xe && usemsr_ee) {
@@ -426,7 +426,7 @@ static int chk_ucode_version(unsigned int cpu)
 	 * Readings might stop update when processor visited too deep sleep,
 	 * fixed for stepping D0 (6EC).
 	 */
-	if (c->x86_model =3D=3D 0xe && c->x86_mask < 0xc && c->microcode < 0x39) {
+	if (c->x86_model =3D=3D 0xe && c->x86_stepping < 0xc && c->microcode < 0x=
39) {
 		pr_err("Errata AE18 not fixed, update BIOS or microcode of the CPU!\n");
 		return -ENODEV;
 	}
diff --git a/drivers/hwmon/hwmon-vid.c b/drivers/hwmon/hwmon-vid.c
index ef91b8a67549..84e91286fc4f 100644
--- a/drivers/hwmon/hwmon-vid.c
+++ b/drivers/hwmon/hwmon-vid.c
@@ -293,7 +293,7 @@ u8 vid_which_vrm(void)
 	if (c->x86 < 6)		/* Any CPU with family lower than 6 */
 		return 0;	/* doesn't have VID */
=20
-	vrm_ret =3D find_vrm(c->x86, c->x86_model, c->x86_mask, c->x86_vendor);
+	vrm_ret =3D find_vrm(c->x86, c->x86_model, c->x86_stepping, c->x86_vendor=
);
 	if (vrm_ret =3D=3D 134)
 		vrm_ret =3D get_via_model_d_vrm();
 	if (vrm_ret =3D=3D 0)
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index f7b46f68ef43..91f22a0e72b3 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -126,7 +126,7 @@ static bool has_erratum_319(struct pci_dev *pdev)
 	 * and AM3 formats, but that's the best we can do.
 	 */
 	return boot_cpu_data.x86_model < 4 ||
-	       (boot_cpu_data.x86_model =3D=3D 4 && boot_cpu_data.x86_mask <=3D 2=
);
+	       (boot_cpu_data.x86_model =3D=3D 4 && boot_cpu_data.x86_stepping <=
=3D 2);
 }
=20
 static int k10temp_probe(struct pci_dev *pdev,
diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 734d55d48cc8..486502798fc5 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -187,7 +187,7 @@ static int k8temp_probe(struct pci_dev *pdev,
 		return -ENOMEM;
=20
 	model =3D boot_cpu_data.x86_model;
-	stepping =3D boot_cpu_data.x86_mask;
+	stepping =3D boot_cpu_data.x86_stepping;
=20
 	/* feature available since SH-C0, exclude older revisions */
 	if ((model =3D=3D 4 && stepping =3D=3D 0) ||
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptct=
l.c
index 8a050e885688..03a5db0da480 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -100,19 +100,19 @@ struct buflist {
  * Function prototypes. Called from OS entry point mptctl_ioctl.
  * arg contents specific to function.
  */
-static int mptctl_fw_download(unsigned long arg);
-static int mptctl_getiocinfo(unsigned long arg, unsigned int cmd);
-static int mptctl_gettargetinfo(unsigned long arg);
-static int mptctl_readtest(unsigned long arg);
-static int mptctl_mpt_command(unsigned long arg);
-static int mptctl_eventquery(unsigned long arg);
-static int mptctl_eventenable(unsigned long arg);
-static int mptctl_eventreport(unsigned long arg);
-static int mptctl_replace_fw(unsigned long arg);
-
-static int mptctl_do_reset(unsigned long arg);
-static int mptctl_hp_hostinfo(unsigned long arg, unsigned int cmd);
-static int mptctl_hp_targetinfo(unsigned long arg);
+static int mptctl_fw_download(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_getiocinfo(MPT_ADAPTER *iocp, unsigned long arg, unsigne=
d int cmd);
+static int mptctl_gettargetinfo(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_readtest(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_mpt_command(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_eventquery(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_eventenable(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_eventreport(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_replace_fw(MPT_ADAPTER *iocp, unsigned long arg);
+
+static int mptctl_do_reset(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_hp_hostinfo(MPT_ADAPTER *iocp, unsigned long arg, unsign=
ed int cmd);
+static int mptctl_hp_targetinfo(MPT_ADAPTER *iocp, unsigned long arg);
=20
 static int  mptctl_probe(struct pci_dev *, const struct pci_device_id *);
 static void mptctl_remove(struct pci_dev *);
@@ -123,8 +123,8 @@ static long compat_mpctl_ioctl(struct file *f, unsigned=
 cmd, unsigned long arg);
 /*
  * Private function calls.
  */
-static int mptctl_do_mpt_command(struct mpt_ioctl_command karg, void __use=
r *mfPtr);
-static int mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwle=
n);
+static int mptctl_do_mpt_command(MPT_ADAPTER *iocp, struct mpt_ioctl_comma=
nd karg, void __user *mfPtr);
+static int mptctl_do_fw_download(MPT_ADAPTER *iocp, char __user *ufwbuf, s=
ize_t fwlen);
 static MptSge_t *kbuf_alloc_2_sgl(int bytes, u32 dir, int sge_offset, int =
*frags,
 		struct buflist **blp, dma_addr_t *sglbuf_dma, MPT_ADAPTER *ioc);
 static void kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma,
@@ -656,19 +656,19 @@ __mptctl_ioctl(struct file *file, unsigned int cmd, u=
nsigned long arg)
 	 * by TM and FW reloads.
 	 */
 	if ((cmd & ~IOCSIZE_MASK) =3D=3D (MPTIOCINFO & ~IOCSIZE_MASK)) {
-		return mptctl_getiocinfo(arg, _IOC_SIZE(cmd));
+		return mptctl_getiocinfo(iocp, arg, _IOC_SIZE(cmd));
 	} else if (cmd =3D=3D MPTTARGETINFO) {
-		return mptctl_gettargetinfo(arg);
+		return mptctl_gettargetinfo(iocp, arg);
 	} else if (cmd =3D=3D MPTTEST) {
-		return mptctl_readtest(arg);
+		return mptctl_readtest(iocp, arg);
 	} else if (cmd =3D=3D MPTEVENTQUERY) {
-		return mptctl_eventquery(arg);
+		return mptctl_eventquery(iocp, arg);
 	} else if (cmd =3D=3D MPTEVENTENABLE) {
-		return mptctl_eventenable(arg);
+		return mptctl_eventenable(iocp, arg);
 	} else if (cmd =3D=3D MPTEVENTREPORT) {
-		return mptctl_eventreport(arg);
+		return mptctl_eventreport(iocp, arg);
 	} else if (cmd =3D=3D MPTFWREPLACE) {
-		return mptctl_replace_fw(arg);
+		return mptctl_replace_fw(iocp, arg);
 	}
=20
 	/* All of these commands require an interrupt or
@@ -678,15 +678,15 @@ __mptctl_ioctl(struct file *file, unsigned int cmd, u=
nsigned long arg)
 		return ret;
=20
 	if (cmd =3D=3D MPTFWDOWNLOAD)
-		ret =3D mptctl_fw_download(arg);
+		ret =3D mptctl_fw_download(iocp, arg);
 	else if (cmd =3D=3D MPTCOMMAND)
-		ret =3D mptctl_mpt_command(arg);
+		ret =3D mptctl_mpt_command(iocp, arg);
 	else if (cmd =3D=3D MPTHARDRESET)
-		ret =3D mptctl_do_reset(arg);
+		ret =3D mptctl_do_reset(iocp, arg);
 	else if ((cmd & ~IOCSIZE_MASK) =3D=3D (HP_GETHOSTINFO & ~IOCSIZE_MASK))
-		ret =3D mptctl_hp_hostinfo(arg, _IOC_SIZE(cmd));
+		ret =3D mptctl_hp_hostinfo(iocp, arg, _IOC_SIZE(cmd));
 	else if (cmd =3D=3D HP_GETTARGETINFO)
-		ret =3D mptctl_hp_targetinfo(arg);
+		ret =3D mptctl_hp_targetinfo(iocp, arg);
 	else
 		ret =3D -EINVAL;
=20
@@ -705,11 +705,10 @@ mptctl_ioctl(struct file *file, unsigned int cmd, uns=
igned long arg)
 	return ret;
 }
=20
-static int mptctl_do_reset(unsigned long arg)
+static int mptctl_do_reset(MPT_ADAPTER *iocp, unsigned long arg)
 {
 	struct mpt_ioctl_diag_reset __user *urinfo =3D (void __user *) arg;
 	struct mpt_ioctl_diag_reset krinfo;
-	MPT_ADAPTER		*iocp;
=20
 	if (copy_from_user(&krinfo, urinfo, sizeof(struct mpt_ioctl_diag_reset)))=
 {
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_do_reset - "
@@ -718,12 +717,6 @@ static int mptctl_do_reset(unsigned long arg)
 		return -EFAULT;
 	}
=20
-	if (mpt_verify_adapter(krinfo.hdr.iocnum, &iocp) < 0) {
-		printk(KERN_DEBUG MYNAM "%s@%d::mptctl_do_reset - ioc%d not found!\n",
-				__FILE__, __LINE__, krinfo.hdr.iocnum);
-		return -ENODEV; /* (-6) No such device or address */
-	}
-
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "mptctl_do_reset called.\n",
 	    iocp->name));
=20
@@ -754,7 +747,7 @@ static int mptctl_do_reset(unsigned long arg)
  *		-ENOMSG if FW upload returned bad status
  */
 static int
-mptctl_fw_download(unsigned long arg)
+mptctl_fw_download(MPT_ADAPTER *iocp, unsigned long arg)
 {
 	struct mpt_fw_xfer __user *ufwdl =3D (void __user *) arg;
 	struct mpt_fw_xfer	 kfwdl;
@@ -766,7 +759,7 @@ mptctl_fw_download(unsigned long arg)
 		return -EFAULT;
 	}
=20
-	return mptctl_do_fw_download(kfwdl.iocnum, kfwdl.bufp, kfwdl.fwlen);
+	return mptctl_do_fw_download(iocp, kfwdl.bufp, kfwdl.fwlen);
 }
=20
 /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D*/
@@ -784,11 +777,10 @@ mptctl_fw_download(unsigned long arg)
  *		-ENOMSG if FW upload returned bad status
  */
 static int
-mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
+mptctl_do_fw_download(MPT_ADAPTER *iocp, char __user *ufwbuf, size_t fwlen)
 {
 	FWDownload_t		*dlmsg;
 	MPT_FRAME_HDR		*mf;
-	MPT_ADAPTER		*iocp;
 	FWDownloadTCSGE_t	*ptsge;
 	MptSge_t		*sgl, *sgIn;
 	char			*sgOut;
@@ -808,17 +800,10 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, s=
ize_t fwlen)
 	pFWDownloadReply_t	 ReplyMsg =3D NULL;
 	unsigned long		 timeleft;
=20
-	if (mpt_verify_adapter(ioc, &iocp) < 0) {
-		printk(KERN_DEBUG MYNAM "ioctl_fwdl - ioc%d not found!\n",
-				 ioc);
-		return -ENODEV; /* (-6) No such device or address */
-	} else {
-
-		/*  Valid device. Get a message frame and construct the FW download mess=
age.
-	 	*/
-		if ((mf =3D mpt_get_msg_frame(mptctl_id, iocp)) =3D=3D NULL)
-			return -EAGAIN;
-	}
+	/*  Valid device. Get a message frame and construct the FW download messa=
ge.
+	*/
+	if ((mf =3D mpt_get_msg_frame(mptctl_id, iocp)) =3D=3D NULL)
+		return -EAGAIN;
=20
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT
 	    "mptctl_do_fwdl called. mptctl_id =3D %xh.\n", iocp->name, mptctl_id)=
);
@@ -826,8 +811,6 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, siz=
e_t fwlen)
 	    iocp->name, ufwbuf));
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.fwlen =3D %d\n",
 	    iocp->name, (int)fwlen));
-	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.ioc   =3D %04xh\n",
-	    iocp->name, ioc));
=20
 	dlmsg =3D (FWDownload_t*) mf;
 	ptsge =3D (FWDownloadTCSGE_t *) &dlmsg->SGL;
@@ -1234,13 +1217,11 @@ kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma, struct=
 buflist *buflist, MPT_ADAPTE
  *		-ENODEV  if no such device/adapter
  */
 static int
-mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
+mptctl_getiocinfo (MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_=
size)
 {
 	struct mpt_ioctl_iocinfo __user *uarg =3D (void __user *) arg;
 	struct mpt_ioctl_iocinfo *karg;
-	MPT_ADAPTER		*ioc;
 	struct pci_dev		*pdev;
-	int			iocnum;
 	unsigned int		port;
 	int			cim_rev;
 	struct scsi_device 	*sdev;
@@ -1276,14 +1257,6 @@ mptctl_getiocinfo (unsigned long arg, unsigned int d=
ata_size)
 		return -EFAULT;
 	}
=20
-	if (((iocnum =3D mpt_verify_adapter(karg->hdr.iocnum, &ioc)) < 0) ||
-	    (ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_getiocinfo() @%d - ioc%d not found!\=
n",
-				__FILE__, __LINE__, iocnum);
-		kfree(karg);
-		return -ENODEV;
-	}
-
 	/* Verify the data transfer size is correct. */
 	if (karg->hdr.maxDataSize !=3D data_size) {
 		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_getiocinfo - "
@@ -1389,15 +1362,13 @@ mptctl_getiocinfo (unsigned long arg, unsigned int =
data_size)
  *		-ENODEV  if no such device/adapter
  */
 static int
-mptctl_gettargetinfo (unsigned long arg)
+mptctl_gettargetinfo (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_targetinfo __user *uarg =3D (void __user *) arg;
 	struct mpt_ioctl_targetinfo karg;
-	MPT_ADAPTER		*ioc;
 	VirtDevice		*vdevice;
 	char			*pmem;
 	int			*pdata;
-	int			iocnum;
 	int			numDevices =3D 0;
 	int			lun;
 	int			maxWordsLeft;
@@ -1412,13 +1383,6 @@ mptctl_gettargetinfo (unsigned long arg)
 		return -EFAULT;
 	}
=20
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_gettargetinfo() @%d - ioc%d not foun=
d!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_gettargetinfo called.\n",
 	    ioc->name));
 	/* Get the port number and set the maximum number of bytes
@@ -1514,12 +1478,10 @@ mptctl_gettargetinfo (unsigned long arg)
  *		-ENODEV  if no such device/adapter
  */
 static int
-mptctl_readtest (unsigned long arg)
+mptctl_readtest (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_test __user *uarg =3D (void __user *) arg;
 	struct mpt_ioctl_test	 karg;
-	MPT_ADAPTER *ioc;
-	int iocnum;
=20
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_test))) {
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_readtest - "
@@ -1528,13 +1490,6 @@ mptctl_readtest (unsigned long arg)
 		return -EFAULT;
 	}
=20
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_readtest() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_readtest called.\n",
 	    ioc->name));
 	/* Fill in the data and return the structure to the calling
@@ -1575,12 +1530,10 @@ mptctl_readtest (unsigned long arg)
  *		-ENODEV  if no such device/adapter
  */
 static int
-mptctl_eventquery (unsigned long arg)
+mptctl_eventquery (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_eventquery __user *uarg =3D (void __user *) arg;
 	struct mpt_ioctl_eventquery	 karg;
-	MPT_ADAPTER *ioc;
-	int iocnum;
=20
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventquery))) {
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_eventquery - "
@@ -1589,13 +1542,6 @@ mptctl_eventquery (unsigned long arg)
 		return -EFAULT;
 	}
=20
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_eventquery() @%d - ioc%d not found!\=
n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_eventquery called.\n",
 	    ioc->name));
 	karg.eventEntries =3D MPTCTL_EVENT_LOG_SIZE;
@@ -1614,12 +1560,10 @@ mptctl_eventquery (unsigned long arg)
=20
 /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D*/
 static int
-mptctl_eventenable (unsigned long arg)
+mptctl_eventenable (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_eventenable __user *uarg =3D (void __user *) arg;
 	struct mpt_ioctl_eventenable	 karg;
-	MPT_ADAPTER *ioc;
-	int iocnum;
=20
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventenable))) {
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_eventenable - "
@@ -1628,13 +1572,6 @@ mptctl_eventenable (unsigned long arg)
 		return -EFAULT;
 	}
=20
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_eventenable() @%d - ioc%d not found!=
\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_eventenable called.\n",
 	    ioc->name));
 	if (ioc->events =3D=3D NULL) {
@@ -1662,12 +1599,10 @@ mptctl_eventenable (unsigned long arg)
=20
 /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D*/
 static int
-mptctl_eventreport (unsigned long arg)
+mptctl_eventreport (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_eventreport __user *uarg =3D (void __user *) arg;
 	struct mpt_ioctl_eventreport	 karg;
-	MPT_ADAPTER		 *ioc;
-	int			 iocnum;
 	int			 numBytes, maxEvents, max;
=20
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventreport))) {
@@ -1677,12 +1612,6 @@ mptctl_eventreport (unsigned long arg)
 		return -EFAULT;
 	}
=20
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_eventreport() @%d - ioc%d not found!=
\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_eventreport called.\n",
 	    ioc->name));
=20
@@ -1716,12 +1645,10 @@ mptctl_eventreport (unsigned long arg)
=20
 /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D*/
 static int
-mptctl_replace_fw (unsigned long arg)
+mptctl_replace_fw (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_replace_fw __user *uarg =3D (void __user *) arg;
 	struct mpt_ioctl_replace_fw	 karg;
-	MPT_ADAPTER		 *ioc;
-	int			 iocnum;
 	int			 newFwSize;
=20
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_replace_fw))) {
@@ -1731,13 +1658,6 @@ mptctl_replace_fw (unsigned long arg)
 		return -EFAULT;
 	}
=20
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_replace_fw() @%d - ioc%d not found!\=
n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_replace_fw called.\n",
 	    ioc->name));
 	/* If caching FW, Free the old FW image
@@ -1789,12 +1709,10 @@ mptctl_replace_fw (unsigned long arg)
  *		-ENOMEM if memory allocation error
  */
 static int
-mptctl_mpt_command (unsigned long arg)
+mptctl_mpt_command (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_command __user *uarg =3D (void __user *) arg;
 	struct mpt_ioctl_command  karg;
-	MPT_ADAPTER	*ioc;
-	int		iocnum;
 	int		rc;
=20
=20
@@ -1805,14 +1723,7 @@ mptctl_mpt_command (unsigned long arg)
 		return -EFAULT;
 	}
=20
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_mpt_command() @%d - ioc%d not found!=
\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
-	rc =3D mptctl_do_mpt_command (karg, &uarg->MF);
+	rc =3D mptctl_do_mpt_command (ioc, karg, &uarg->MF);
=20
 	return rc;
 }
@@ -1830,9 +1741,8 @@ mptctl_mpt_command (unsigned long arg)
  *		-EPERM if SCSI I/O and target is untagged
  */
 static int
-mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
+mptctl_do_mpt_command (MPT_ADAPTER *ioc, struct mpt_ioctl_command karg, vo=
id __user *mfPtr)
 {
-	MPT_ADAPTER	*ioc;
 	MPT_FRAME_HDR	*mf =3D NULL;
 	MPIHeader_t	*hdr;
 	char		*psge;
@@ -1841,7 +1751,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg,=
 void __user *mfPtr)
 	dma_addr_t	dma_addr_in;
 	dma_addr_t	dma_addr_out;
 	int		sgSize =3D 0;	/* Num SG elements */
-	int		iocnum, flagsLength;
+	int		flagsLength;
 	int		sz, rc =3D 0;
 	int		msgContext;
 	u16		req_idx;
@@ -1856,13 +1766,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg=
, void __user *mfPtr)
 	bufIn.kptr =3D bufOut.kptr =3D NULL;
 	bufIn.len =3D bufOut.len =3D 0;
=20
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_do_mpt_command() @%d - ioc%d not fou=
nd!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
 	if (ioc->ioc_reset_in_progress) {
 		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
@@ -2418,17 +2321,15 @@ mptctl_do_mpt_command (struct mpt_ioctl_command kar=
g, void __user *mfPtr)
  *		-ENOMEM if memory allocation error
  */
 static int
-mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
+mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_=
size)
 {
 	hp_host_info_t	__user *uarg =3D (void __user *) arg;
-	MPT_ADAPTER		*ioc;
 	struct pci_dev		*pdev;
 	char                    *pbuf=3DNULL;
 	dma_addr_t		buf_dma;
 	hp_host_info_t		karg;
 	CONFIGPARMS		cfg;
 	ConfigPageHeader_t	hdr;
-	int			iocnum;
 	int			rc, cim_rev;
 	ToolboxIstwiReadWriteRequest_t	*IstwiRWRequest;
 	MPT_FRAME_HDR		*mf =3D NULL;
@@ -2452,12 +2353,6 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int d=
ata_size)
 		return -EFAULT;
 	}
=20
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_hp_hostinfo() @%d - ioc%d not found!=
\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": mptctl_hp_hostinfo called.\n",
 	    ioc->name));
=20
@@ -2670,15 +2565,13 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int =
data_size)
  *		-ENOMEM if memory allocation error
  */
 static int
-mptctl_hp_targetinfo(unsigned long arg)
+mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
 {
 	hp_target_info_t __user *uarg =3D (void __user *) arg;
 	SCSIDevicePage0_t	*pg0_alloc;
 	SCSIDevicePage3_t	*pg3_alloc;
-	MPT_ADAPTER		*ioc;
 	MPT_SCSI_HOST 		*hd =3D NULL;
 	hp_target_info_t	karg;
-	int			iocnum;
 	int			data_sz;
 	dma_addr_t		page_dma;
 	CONFIGPARMS	 	cfg;
@@ -2692,12 +2585,8 @@ mptctl_hp_targetinfo(unsigned long arg)
 		return -EFAULT;
 	}
=20
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-		(ioc =3D=3D NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_hp_targetinfo() @%d - ioc%d not foun=
d!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
+	if (karg.hdr.id >=3D MPT_MAX_FC_DEVICES)
+		return -EINVAL;
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_hp_targetinfo called.\n",
 	    ioc->name));
=20
@@ -2863,7 +2752,7 @@ compat_mptfwxfer_ioctl(struct file *filp, unsigned in=
t cmd,
 	kfw.fwlen =3D kfw32.fwlen;
 	kfw.bufp =3D compat_ptr(kfw32.bufp);
=20
-	ret =3D mptctl_do_fw_download(kfw.iocnum, kfw.bufp, kfw.fwlen);
+	ret =3D mptctl_do_fw_download(iocp, kfw.bufp, kfw.fwlen);
=20
 	mutex_unlock(&iocp->ioctl_cmds.mutex);
=20
@@ -2917,7 +2806,7 @@ compat_mpt_command(struct file *filp, unsigned int cm=
d,
=20
 	/* Pass new structure to do_mpt_command
 	 */
-	ret =3D mptctl_do_mpt_command (karg, &uarg->MF);
+	ret =3D mptctl_do_mpt_command (iocp, karg, &uarg->MF);
=20
 	mutex_unlock(&iocp->ioctl_cmds.mutex);
=20
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index f0769ce11c4b..772fe3bfc348 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -620,6 +620,10 @@ static int slcan_open(struct tty_struct *tty)
 	sl->tty =3D NULL;
 	tty->disc_data =3D NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	/* do not call free_netdev before rtnl_unlock */
+	rtnl_unlock();
+	slc_free_netdev(sl->dev);
+	return err;
=20
 err_exit:
 	rtnl_unlock();
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 65df455c056e..812fe19986e2 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -867,6 +867,10 @@ static int slip_open(struct tty_struct *tty)
 	sl->tty =3D NULL;
 	tty->disc_data =3D NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	/* do not call free_netdev before rtnl_unlock */
+	rtnl_unlock();
+	sl_free_netdev(sl->dev);
+	return err;
=20
 err_exit:
 	rtnl_unlock();
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwi=
fiex/scan.c
index b73af01c84d5..362b49c8b878 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2267,6 +2267,13 @@ mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *=
priv,
 			vs_param_set->header.len =3D
 				cpu_to_le16((((u16) priv->vs_ie[id].ie[1])
 				& 0x00FF) + 2);
+			if (le16_to_cpu(vs_param_set->header.len) >
+				MWIFIEX_MAX_VSIE_LEN) {
+				dev_info(priv->adapter->dev,
+					 "Invalid param length!\n");
+				break;
+			}
+
 			memcpy(vs_param_set->ie, priv->vs_ie[id].ie,
 			       le16_to_cpu(vs_param_set->header.len));
 			*buffer +=3D le16_to_cpu(vs_param_set->header.len) +
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwif=
iex/wmm.c
index 67cefd06b7b0..00b2cb7eb60b 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -791,6 +791,10 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private =
*priv,
 				wmm_param_ie->qos_info_bitmap &
 				IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK);
=20
+			if (wmm_param_ie->vend_hdr.len + 2 >
+				sizeof(struct ieee_types_wmm_parameter))
+				break;
+
 			memcpy((u8 *) &priv->curr_bss_params.bss_descriptor.
 			       wmm_ie, wmm_param_ie,
 			       wmm_param_ie->vend_hdr.len + 2);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2cb688ba1d2b..d8d81515789d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -51,8 +51,10 @@ static int sg_version_num =3D 30534;	/* 2 digits for eac=
h component */
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
 #include <linux/mutex.h>
+#include <linux/atomic.h>
 #include <linux/ratelimit.h>
 #include <linux/cred.h> /* for sg_check_file_access() */
+#include <linux/sizes.h>
=20
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -103,18 +105,16 @@ static int scatter_elem_sz_prev =3D SG_SCATTER_SZ;
=20
 #define SG_SECTOR_SZ 512
=20
-static int sg_add(struct device *, struct class_interface *);
-static void sg_remove(struct device *, struct class_interface *);
-
-static DEFINE_SPINLOCK(sg_open_exclusive_lock);
+static int sg_add_device(struct device *, struct class_interface *);
+static void sg_remove_device(struct device *, struct class_interface *);
=20
 static DEFINE_IDR(sg_index_idr);
 static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
 							   file descriptor list for device */
=20
 static struct class_interface sg_interface =3D {
-	.add_dev	=3D sg_add,
-	.remove_dev	=3D sg_remove,
+	.add_dev        =3D sg_add_device,
+	.remove_dev     =3D sg_remove_device,
 };
=20
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather i=
nfo */
@@ -131,7 +131,7 @@ struct sg_device;		/* forward declarations */
 struct sg_fd;
=20
 typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file =
*/
-	struct sg_request *nextrp;	/* NULL -> tail request (slist) */
+	struct list_head entry;	/* list entry */
 	struct sg_fd *parentfp;	/* NULL -> not in use */
 	Sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
 	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
@@ -147,38 +147,38 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests =
outstanding per file */
 } Sg_request;
=20
 typedef struct sg_fd {		/* holds the state of a file descriptor */
-	/* sfd_siblings is protected by sg_index_lock */
-	struct list_head sfd_siblings;
+	struct list_head sfd_siblings;  /* protected by device's sfd_lock */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
+	struct mutex f_mutex;	/* protect against changes in this fd */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
-	unsigned save_scat_len;	/* original length of trunc. scat. element */
-	Sg_request *headrp;	/* head of request slist, NULL->empty */
+	struct list_head rq_list; /* head of request list */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
-	char low_dma;		/* as in parent but possibly overridden to 1 */
 	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
 	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
-	char next_cmd_len;	/* 0 -> automatic (def), >0 -> use on next write() */
+	unsigned char next_cmd_len; /* 0: automatic, >0: use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
+	char res_in_use;	/* 1 -> 'reserve' array in use */
 	struct kref f_ref;
 	struct execute_work ew;
 } Sg_fd;
=20
 typedef struct sg_device { /* holds the state of each scsi generic device =
*/
 	struct scsi_device *device;
-	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
+	wait_queue_head_t open_wait;    /* queue open() when O_EXCL present */
+	struct mutex open_rel_lock;     /* held when in open() or release() */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
-	/* sfds is protected by sg_index_lock */
 	struct list_head sfds;
-	volatile char detached;	/* 0->attached, 1->detached pending removal */
-	/* exclude protected by sg_open_exclusive_lock */
-	char exclude;		/* opened for exclusive access */
+	rwlock_t sfd_lock;      /* protect access to sfd list */
+	atomic_t detaching;     /* 0->device usable, 1->device detaching */
+	bool exclude;		/* 1->open(O_EXCL) succeeded and is active */
+	int open_cnt;		/* count of opens (perhaps < num(sfds) ) */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
@@ -207,9 +207,8 @@ static void sg_remove_sfp(struct kref *);
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
-static int sg_res_in_use(Sg_fd * sfp);
 static Sg_device *sg_get_dev(int dev);
-static void sg_put_dev(Sg_device *sdp);
+static void sg_device_destroy(struct kref *kref);
=20
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
@@ -253,38 +252,43 @@ static int sg_allow_access(struct file *filp, unsigne=
d char *cmd)
 	return blk_verify_command(cmd, filp->f_mode & FMODE_WRITE);
 }
=20
-static int get_exclude(Sg_device *sdp)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
-	ret =3D sdp->exclude;
-	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
-	return ret;
-}
-
-static int set_exclude(Sg_device *sdp, char val)
+static int
+open_wait(Sg_device *sdp, int flags)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
-	sdp->exclude =3D val;
-	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
-	return val;
-}
+	int retval =3D 0;
=20
-static int sfds_list_empty(Sg_device *sdp)
-{
-	unsigned long flags;
-	int ret;
+	if (flags & O_EXCL) {
+		while (sdp->open_cnt > 0) {
+			mutex_unlock(&sdp->open_rel_lock);
+			retval =3D wait_event_interruptible(sdp->open_wait,
+					(atomic_read(&sdp->detaching) ||
+					 !sdp->open_cnt));
+			mutex_lock(&sdp->open_rel_lock);
+
+			if (retval) /* -ERESTARTSYS */
+				return retval;
+			if (atomic_read(&sdp->detaching))
+				return -ENODEV;
+		}
+	} else {
+		while (sdp->exclude) {
+			mutex_unlock(&sdp->open_rel_lock);
+			retval =3D wait_event_interruptible(sdp->open_wait,
+					(atomic_read(&sdp->detaching) ||
+					 !sdp->exclude));
+			mutex_lock(&sdp->open_rel_lock);
+
+			if (retval) /* -ERESTARTSYS */
+				return retval;
+			if (atomic_read(&sdp->detaching))
+				return -ENODEV;
+		}
+	}
=20
-	read_lock_irqsave(&sg_index_lock, flags);
-	ret =3D list_empty(&sdp->sfds);
-	read_unlock_irqrestore(&sg_index_lock, flags);
-	return ret;
+	return retval;
 }
=20
+/* Returns 0 on success, else a negated errno value */
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -293,17 +297,15 @@ sg_open(struct inode *inode, struct file *filp)
 	struct request_queue *q;
 	Sg_device *sdp;
 	Sg_fd *sfp;
-	int res;
 	int retval;
=20
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=3D%d, flags=3D0x%x\n", dev, flag=
s));
+	if ((flags & O_EXCL) && (O_RDONLY =3D=3D (flags & O_ACCMODE)))
+		return -EPERM; /* Can't lock it with read only access */
 	sdp =3D sg_get_dev(dev);
-	if (IS_ERR(sdp)) {
-		retval =3D PTR_ERR(sdp);
-		sdp =3D NULL;
-		goto sg_put;
-	}
+	if (IS_ERR(sdp))
+		return PTR_ERR(sdp);
=20
 	/* This driver's module count bumped by fops_get in <linux/fs.h> */
 	/* Prevent the device driver from vanishing while we sleep */
@@ -315,6 +317,9 @@ sg_open(struct inode *inode, struct file *filp)
 	if (retval)
 		goto sdp_put;
=20
+	/* scsi_block_when_processing_errors() may block so bypass
+	 * check if O_NONBLOCK. Permits SCSI commands to be issued
+	 * during error recovery. Tread carefully. */
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval =3D -ENXIO;
@@ -322,65 +327,65 @@ sg_open(struct inode *inode, struct file *filp)
 		goto error_out;
 	}
=20
-	if (flags & O_EXCL) {
-		if (O_RDONLY =3D=3D (flags & O_ACCMODE)) {
-			retval =3D -EPERM; /* Can't lock it with read only access */
-			goto error_out;
-		}
-		if (!sfds_list_empty(sdp) && (flags & O_NONBLOCK)) {
-			retval =3D -EBUSY;
-			goto error_out;
-		}
-		res =3D wait_event_interruptible(sdp->o_excl_wait,
-					   ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 : set_exclude(sdp=
, 1)));
-		if (res) {
-			retval =3D res;	/* -ERESTARTSYS because signal hit process */
-			goto error_out;
-		}
-	} else if (get_exclude(sdp)) {	/* some other fd has an exclusive lock on =
dev */
-		if (flags & O_NONBLOCK) {
-			retval =3D -EBUSY;
-			goto error_out;
-		}
-		res =3D wait_event_interruptible(sdp->o_excl_wait, !get_exclude(sdp));
-		if (res) {
-			retval =3D res;	/* -ERESTARTSYS because signal hit process */
-			goto error_out;
+	mutex_lock(&sdp->open_rel_lock);
+	if (flags & O_NONBLOCK) {
+		if (flags & O_EXCL) {
+			if (sdp->open_cnt > 0) {
+				retval =3D -EBUSY;
+				goto error_mutex_locked;
+			}
+		} else {
+			if (sdp->exclude) {
+				retval =3D -EBUSY;
+				goto error_mutex_locked;
+			}
 		}
+	} else {
+		retval =3D open_wait(sdp, flags);
+		if (retval) /* -ERESTARTSYS or -ENODEV */
+			goto error_mutex_locked;
 	}
-	if (sdp->detached) {
-		retval =3D -ENODEV;
-		goto error_out;
-	}
-	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
+
+	/* N.B. at this point we are holding the open_rel_lock */
+	if (flags & O_EXCL)
+		sdp->exclude =3D true;
+
+	if (sdp->open_cnt < 1) {  /* no existing opens */
 		sdp->sgdebug =3D 0;
 		q =3D sdp->device->request_queue;
 		sdp->sg_tablesize =3D queue_max_segments(q);
 	}
-	if ((sfp =3D sg_add_sfp(sdp, dev)))
-		filp->private_data =3D sfp;
-	else {
-		if (flags & O_EXCL) {
-			set_exclude(sdp, 0);	/* undo if error */
-			wake_up_interruptible(&sdp->o_excl_wait);
-		}
-		retval =3D -ENOMEM;
-		goto error_out;
+	sfp =3D sg_add_sfp(sdp, dev);
+	if (IS_ERR(sfp)) {
+		retval =3D PTR_ERR(sfp);
+		goto out_undo;
 	}
+
+	filp->private_data =3D sfp;
+	sdp->open_cnt++;
+	mutex_unlock(&sdp->open_rel_lock);
+
 	retval =3D 0;
-error_out:
-	if (retval) {
-		scsi_autopm_put_device(sdp->device);
-sdp_put:
-		scsi_device_put(sdp->device);
-	}
 sg_put:
-	if (sdp)
-		sg_put_dev(sdp);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 	return retval;
+
+out_undo:
+	if (flags & O_EXCL) {
+		sdp->exclude =3D false;   /* undo if error */
+		wake_up_interruptible(&sdp->open_wait);
+	}
+error_mutex_locked:
+	mutex_unlock(&sdp->open_rel_lock);
+error_out:
+	scsi_autopm_put_device(sdp->device);
+sdp_put:
+	scsi_device_put(sdp->device);
+	goto sg_put;
 }
=20
-/* Following function was formerly called 'sg_close' */
+/* Release resources associated with a successful sg_open()
+ * Returns 0 on success, else a negated errno value */
 static int
 sg_release(struct inode *inode, struct file *filp)
 {
@@ -391,11 +396,20 @@ sg_release(struct inode *inode, struct file *filp)
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
=20
-	set_exclude(sdp, 0);
-	wake_up_interruptible(&sdp->o_excl_wait);
-
+	mutex_lock(&sdp->open_rel_lock);
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
+	sdp->open_cnt--;
+
+	/* possibly many open()s waiting on exlude clearing, start many;
+	 * only open(O_EXCL)s wait on 0=3D=3Dopen_cnt so only start one */
+	if (sdp->exclude) {
+		sdp->exclude =3D false;
+		wake_up_interruptible_all(&sdp->open_wait);
+	} else if (0 =3D=3D sdp->open_cnt) {
+		wake_up_interruptible(&sdp->open_wait);
+	}
+	mutex_unlock(&sdp->open_rel_lock);
 	return 0;
 }
=20
@@ -455,7 +469,7 @@ sg_read(struct file *filp, char __user *buf, size_t cou=
nt, loff_t * ppos)
 	}
 	srp =3D sg_get_rq_mark(sfp, req_pack_id);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (sdp->detached) {
+		if (atomic_read(&sdp->detaching)) {
 			retval =3D -ENODEV;
 			goto free_old_hdr;
 		}
@@ -464,9 +478,9 @@ sg_read(struct file *filp, char __user *buf, size_t cou=
nt, loff_t * ppos)
 			goto free_old_hdr;
 		}
 		retval =3D wait_event_interruptible(sfp->read_wait,
-			(sdp->detached ||
+			(atomic_read(&sdp->detaching) ||
 			(srp =3D sg_get_rq_mark(sfp, req_pack_id))));
-		if (sdp->detached) {
+		if (atomic_read(&sdp->detaching)) {
 			retval =3D -ENODEV;
 			goto free_old_hdr;
 		}
@@ -548,6 +562,7 @@ sg_read(struct file *filp, char __user *buf, size_t cou=
nt, loff_t * ppos)
 	} else
 		count =3D (old_hdr->result =3D=3D 0) ? 0 : -EIO;
 	sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
 	retval =3D count;
 free_old_hdr:
 	kfree(old_hdr);
@@ -588,6 +603,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count=
, Sg_request * srp)
 	}
 err_out:
 	err2 =3D sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
 	return err ? : err2 ? : count;
 }
=20
@@ -613,7 +629,7 @@ sg_write(struct file *filp, const char __user *buf, siz=
e_t count, loff_t * ppos)
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_write: %s, count=3D%d\n",
 				   sdp->disk->disk_name, (int) count));
-	if (sdp->detached)
+	if (atomic_read(&sdp->detaching))
 		return -ENODEV;
 	if (!((filp->f_flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device)))
@@ -638,13 +654,8 @@ sg_write(struct file *filp, const char __user *buf, si=
ze_t count, loff_t * ppos)
 	}
 	buf +=3D SZ_SG_HEADER;
 	__get_user(opcode, buf);
+	mutex_lock(&sfp->f_mutex);
 	if (sfp->next_cmd_len > 0) {
-		if (sfp->next_cmd_len > MAX_COMMAND_SIZE) {
-			SCSI_LOG_TIMEOUT(1, printk("sg_write: command length too long\n"));
-			sfp->next_cmd_len =3D 0;
-			sg_remove_request(sfp, srp);
-			return -EIO;
-		}
 		cmd_size =3D sfp->next_cmd_len;
 		sfp->next_cmd_len =3D 0;	/* reset so only this write() effected */
 	} else {
@@ -652,6 +663,7 @@ sg_write(struct file *filp, const char __user *buf, siz=
e_t count, loff_t * ppos)
 		if ((opcode >=3D 0xc0) && old_hdr.twelve_byte)
 			cmd_size =3D 12;
 	}
+	mutex_unlock(&sfp->f_mutex);
 	SCSI_LOG_TIMEOUT(4, printk(
 		"sg_write:   scsi opcode=3D0x%02x, cmd_size=3D%d\n", (int) opcode, cmd_s=
ize));
 /* Determine buffer size.  */
@@ -684,26 +696,24 @@ sg_write(struct file *filp, const char __user *buf, s=
ize_t count, loff_t * ppos)
 	hp->flags =3D input_size;	/* structure abuse ... */
 	hp->pack_id =3D old_hdr.pack_id;
 	hp->usr_ptr =3D NULL;
-	if (__copy_from_user(cmnd, buf, cmd_size))
+	if (__copy_from_user(cmnd, buf, cmd_size)) {
+		sg_remove_request(sfp, srp);
 		return -EFAULT;
+	}
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
 	 * is a non-zero input_size, so emit a warning.
 	 */
 	if (hp->dxfer_direction =3D=3D SG_DXFER_TO_FROM_DEV) {
-		static char cmd[TASK_COMM_LEN];
-		if (strcmp(current->comm, cmd)) {
-			printk_ratelimited(KERN_WARNING
-					   "sg_write: data in/out %d/%d bytes "
-					   "for SCSI command 0x%x-- guessing "
-					   "data in;\n   program %s not setting "
-					   "count and/or reply_len properly\n",
-					   old_hdr.reply_len - (int)SZ_SG_HEADER,
-					   input_size, (unsigned int) cmnd[0],
-					   current->comm);
-			strcpy(cmd, current->comm);
-		}
+		printk_ratelimited(KERN_WARNING
+				   "sg_write: data in/out %d/%d bytes "
+				   "for SCSI command 0x%x-- guessing "
+				   "data in;\n   program %s not setting "
+				   "count and/or reply_len properly\n",
+				   old_hdr.reply_len - (int)SZ_SG_HEADER,
+				   input_size, (unsigned int) cmnd[0],
+				   current->comm);
 	}
 	k =3D sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
@@ -750,7 +760,7 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char =
__user *buf,
 			sg_remove_request(sfp, srp);
 			return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
 		}
-		if (sg_res_in_use(sfp)) {
+		if (sfp->res_in_use) {
 			sg_remove_request(sfp, srp);
 			return -EBUSY;	/* reserve buffer already being used */
 		}
@@ -800,19 +810,26 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	SCSI_LOG_TIMEOUT(4, printk("sg_common_write:  scsi opcode=3D0x%02x, cmd_s=
ize=3D%d\n",
 			  (int) cmnd[0], (int) hp->cmd_len));
=20
+	if (hp->dxfer_len >=3D SZ_256M) {
+		sg_remove_request(sfp, srp);
+		return -EINVAL;
+	}
+
 	k =3D sg_start_req(srp, cmnd);
 	if (k) {
 		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=3D%d\n", k));
 		sg_finish_rem_req(srp);
+		sg_remove_request(sfp, srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
-	if (sdp->detached) {
+	if (atomic_read(&sdp->detaching)) {
 		if (srp->bio) {
 			blk_end_request_all(srp->rq, -EIO);
 			srp->rq =3D NULL;
 		}
=20
 		sg_finish_rem_req(srp);
+		sg_remove_request(sfp, srp);
 		return -ENODEV;
 	}
=20
@@ -851,6 +868,48 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
 	return ret;
 }
=20
+static int max_sectors_bytes(struct request_queue *q)
+{
+	unsigned int max_sectors =3D queue_max_sectors(q);
+
+	max_sectors =3D min_t(unsigned int, max_sectors, INT_MAX >> 9);
+
+	return max_sectors << 9;
+}
+
+static void
+sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
+{
+	Sg_request *srp;
+	int val;
+	unsigned int ms;
+
+	val =3D 0;
+	list_for_each_entry(srp, &sfp->rq_list, entry) {
+		if (val >=3D SG_MAX_QUEUE)
+			break;
+		rinfo[val].req_state =3D srp->done + 1;
+		rinfo[val].problem =3D
+			srp->header.masked_status &
+			srp->header.host_status &
+			srp->header.driver_status;
+		if (srp->done)
+			rinfo[val].duration =3D
+				srp->header.duration;
+		else {
+			ms =3D jiffies_to_msecs(jiffies);
+			rinfo[val].duration =3D
+				(ms > srp->header.duration) ?
+				(ms - srp->header.duration) : 0;
+		}
+		rinfo[val].orphan =3D srp->orphan;
+		rinfo[val].sg_io_owned =3D srp->sg_io_owned;
+		rinfo[val].pack_id =3D srp->header.pack_id;
+		rinfo[val].usr_ptr =3D srp->header.usr_ptr;
+		val++;
+	}
+}
+
 static long
 sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -871,7 +930,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsign=
ed long arg)
=20
 	switch (cmd_in) {
 	case SG_IO:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (!scsi_block_when_processing_errors(sdp->device))
 			return -ENXIO;
@@ -882,8 +941,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsign=
ed long arg)
 		if (result < 0)
 			return result;
 		result =3D wait_event_interruptible(sfp->read_wait,
-			(srp_done(sfp, srp) || sdp->detached));
-		if (sdp->detached)
+			(srp_done(sfp, srp) || atomic_read(&sdp->detaching)));
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		write_lock_irq(&sfp->rq_list_lock);
 		if (srp->done) {
@@ -911,31 +970,21 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsi=
gned long arg)
 				/* strange ..., for backward compatibility */
 		return sfp->timeout_user;
 	case SG_SET_FORCE_LOW_DMA:
-		result =3D get_user(val, ip);
-		if (result)
-			return result;
-		if (val) {
-			sfp->low_dma =3D 1;
-			if ((0 =3D=3D sfp->low_dma) && (0 =3D=3D sg_res_in_use(sfp))) {
-				val =3D (int) sfp->reserve.bufflen;
-				sg_remove_scat(&sfp->reserve);
-				sg_build_reserve(sfp, val);
-			}
-		} else {
-			if (sdp->detached)
-				return -ENODEV;
-			sfp->low_dma =3D sdp->device->host->unchecked_isa_dma;
-		}
+		/*
+		 * N.B. This ioctl never worked properly, but failed to
+		 * return an error value. So returning '0' to keep compability
+		 * with legacy applications.
+		 */
 		return 0;
 	case SG_GET_LOW_DMA:
-		return put_user((int) sfp->low_dma, ip);
+		return put_user((int) sdp->device->host->unchecked_isa_dma, ip);
 	case SG_GET_SCSI_ID:
 		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t)))
 			return -EFAULT;
 		else {
 			sg_scsi_id_t __user *sg_idp =3D p;
=20
-			if (sdp->detached)
+			if (atomic_read(&sdp->detaching))
 				return -ENODEV;
 			__put_user((int) sdp->device->host->host_no,
 				   &sg_idp->host_no);
@@ -962,7 +1011,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsig=
ned long arg)
 		if (!access_ok(VERIFY_WRITE, ip, sizeof (int)))
 			return -EFAULT;
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
-		for (srp =3D sfp->headrp; srp; srp =3D srp->nextrp) {
+		list_for_each_entry(srp, &sfp->rq_list, entry) {
 			if ((1 =3D=3D srp->done) && (!srp->sg_io_owned)) {
 				read_unlock_irqrestore(&sfp->rq_list_lock,
 						       iflags);
@@ -975,7 +1024,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsig=
ned long arg)
 		return 0;
 	case SG_GET_NUM_WAITING:
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
-		for (val =3D 0, srp =3D sfp->headrp; srp; srp =3D srp->nextrp) {
+		val =3D 0;
+		list_for_each_entry(srp, &sfp->rq_list, entry) {
 			if ((1 =3D=3D srp->done) && (!srp->sg_io_owned))
 				++val;
 		}
@@ -990,17 +1040,23 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, uns=
igned long arg)
                 if (val < 0)
                         return -EINVAL;
 		val =3D min_t(int, val,
-			    queue_max_sectors(sdp->device->request_queue) * 512);
+			    max_sectors_bytes(sdp->device->request_queue));
+		mutex_lock(&sfp->f_mutex);
 		if (val !=3D sfp->reserve.bufflen) {
-			if (sg_res_in_use(sfp) || sfp->mmap_called)
+			if (sfp->mmap_called ||
+			    sfp->res_in_use) {
+				mutex_unlock(&sfp->f_mutex);
 				return -EBUSY;
+			}
+
 			sg_remove_scat(&sfp->reserve);
 			sg_build_reserve(sfp, val);
 		}
+		mutex_unlock(&sfp->f_mutex);
 		return 0;
 	case SG_GET_RESERVED_SIZE:
 		val =3D min_t(int, sfp->reserve.bufflen,
-			    queue_max_sectors(sdp->device->request_queue) * 512);
+			    max_sectors_bytes(sdp->device->request_queue));
 		return put_user(val, ip);
 	case SG_SET_COMMAND_Q:
 		result =3D get_user(val, ip);
@@ -1022,6 +1078,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsi=
gned long arg)
 		result =3D get_user(val, ip);
 		if (result)
 			return result;
+		if (val > MAX_COMMAND_SIZE)
+			return -ENOMEM;
 		sfp->next_cmd_len =3D (val > 0) ? val : 0;
 		return 0;
 	case SG_GET_VERSION_NUM:
@@ -1035,53 +1093,26 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, un=
signed long arg)
 			return -EFAULT;
 		else {
 			sg_req_info_t *rinfo;
-			unsigned int ms;
=20
-			rinfo =3D kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
-								GFP_KERNEL);
+			rinfo =3D kzalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
+					GFP_KERNEL);
 			if (!rinfo)
 				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
-			for (srp =3D sfp->headrp, val =3D 0; val < SG_MAX_QUEUE;
-			     ++val, srp =3D srp ? srp->nextrp : srp) {
-				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
-				if (srp) {
-					rinfo[val].req_state =3D srp->done + 1;
-					rinfo[val].problem =3D
-					    srp->header.masked_status &=20
-					    srp->header.host_status &=20
-					    srp->header.driver_status;
-					if (srp->done)
-						rinfo[val].duration =3D
-							srp->header.duration;
-					else {
-						ms =3D jiffies_to_msecs(jiffies);
-						rinfo[val].duration =3D
-						    (ms > srp->header.duration) ?
-						    (ms - srp->header.duration) : 0;
-					}
-					rinfo[val].orphan =3D srp->orphan;
-					rinfo[val].sg_io_owned =3D
-							srp->sg_io_owned;
-					rinfo[val].pack_id =3D
-							srp->header.pack_id;
-					rinfo[val].usr_ptr =3D
-							srp->header.usr_ptr;
-				}
-			}
+			sg_fill_request_table(sfp, rinfo);
 			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-			result =3D __copy_to_user(p, rinfo,=20
+			result =3D __copy_to_user(p, rinfo,
 						SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 			result =3D result ? -EFAULT : 0;
 			kfree(rinfo);
 			return result;
 		}
 	case SG_EMULATED_HOST:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		return put_user(sdp->device->host->hostt->emulated, ip);
 	case SG_SCSI_RESET:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (filp->f_flags & O_NONBLOCK) {
 			if (scsi_host_in_recovery(sdp->device->host))
@@ -1114,7 +1145,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsi=
gned long arg)
 		return (scsi_reset_provider(sdp->device, val) =3D=3D
 			SUCCESS) ? 0 : -EIO;
 	case SCSI_IOCTL_SEND_COMMAND:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (read_only) {
 			unsigned char opcode =3D WRITE_6;
@@ -1136,11 +1167,11 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, un=
signed long arg)
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 	case SCSI_IOCTL_PROBE_HOST:
 	case SG_GET_TRANSFORM:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
 	case BLKSECTGET:
-		return put_user(queue_max_sectors(sdp->device->request_queue) * 512,
+		return put_user(max_sectors_bytes(sdp->device->request_queue),
 				ip);
 	case BLKTRACESETUP:
 		return blk_trace_setup(sdp->device->request_queue,
@@ -1202,7 +1233,7 @@ sg_poll(struct file *filp, poll_table * wait)
 		return POLLERR;
 	poll_wait(filp, &sfp->read_wait, wait);
 	read_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (srp =3D sfp->headrp; srp; srp =3D srp->nextrp) {
+	list_for_each_entry(srp, &sfp->rq_list, entry) {
 		/* if any read waiting, flag it */
 		if ((0 =3D=3D res) && (1 =3D=3D srp->done) && (!srp->sg_io_owned))
 			res =3D POLLIN | POLLRDNORM;
@@ -1210,7 +1241,7 @@ sg_poll(struct file *filp, poll_table * wait)
 	}
 	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
=20
-	if (sdp->detached)
+	if (atomic_read(&sdp->detaching))
 		res |=3D POLLHUP;
 	else if (!sfp->cmd_q) {
 		if (0 =3D=3D count)
@@ -1282,6 +1313,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	unsigned long req_sz, len, sa;
 	Sg_scatter_hold *rsv_schp;
 	int k, length;
+	int ret =3D 0;
=20
 	if ((!filp) || (!vma) || (!(sfp =3D (Sg_fd *) filp->private_data)))
 		return -ENXIO;
@@ -1291,8 +1323,11 @@ sg_mmap(struct file *filp, struct vm_area_struct *vm=
a)
 	if (vma->vm_pgoff)
 		return -EINVAL;	/* want no offset */
 	rsv_schp =3D &sfp->reserve;
-	if (req_sz > rsv_schp->bufflen)
-		return -ENOMEM;	/* cannot map more than reserved buffer */
+	mutex_lock(&sfp->f_mutex);
+	if (req_sz > rsv_schp->bufflen) {
+		ret =3D -ENOMEM;	/* cannot map more than reserved buffer */
+		goto out;
+	}
=20
 	sa =3D vma->vm_start;
 	length =3D 1 << (PAGE_SHIFT + rsv_schp->page_order);
@@ -1306,15 +1341,19 @@ sg_mmap(struct file *filp, struct vm_area_struct *v=
ma)
 	vma->vm_flags |=3D VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data =3D sfp;
 	vma->vm_ops =3D &sg_mmap_vm_ops;
-	return 0;
+out:
+	mutex_unlock(&sfp->f_mutex);
+	return ret;
 }
=20
-static void sg_rq_end_io_usercontext(struct work_struct *work)
+static void
+sg_rq_end_io_usercontext(struct work_struct *work)
 {
 	struct sg_request *srp =3D container_of(work, struct sg_request, ew.work);
 	struct sg_fd *sfp =3D srp->parentfp;
=20
 	sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 }
=20
@@ -1322,7 +1361,8 @@ static void sg_rq_end_io_usercontext(struct work_stru=
ct *work)
  * This function is a "bottom half" handler that is called by the mid
  * level when a command is completed (or has failed).
  */
-static void sg_rq_end_io(struct request *rq, int uptodate)
+static void
+sg_rq_end_io(struct request *rq, int uptodate)
 {
 	struct sg_request *srp =3D rq->end_io_data;
 	Sg_device *sdp;
@@ -1340,8 +1380,8 @@ static void sg_rq_end_io(struct request *rq, int upto=
date)
 		return;
=20
 	sdp =3D sfp->parentdp;
-	if (unlikely(sdp->detached))
-		printk(KERN_INFO "sg_rq_end_io: device detached\n");
+	if (unlikely(atomic_read(&sdp->detaching)))
+		pr_info("%s: device detaching\n", __func__);
=20
 	sense =3D rq->sense;
 	result =3D rq->errors;
@@ -1364,7 +1404,7 @@ static void sg_rq_end_io(struct request *rq, int upto=
date)
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION =3D=3D srp->header.masked_status) ||
 		     (COMMAND_TERMINATED =3D=3D srp->header.masked_status)))
-			__scsi_print_sense("sg_cmd_done", sense,
+			__scsi_print_sense(__func__, sense,
 					   SCSI_SENSE_BUFFERSIZE);
=20
 		/* Following if statement is a patch supplied by Eric Youngdale */
@@ -1423,7 +1463,8 @@ static struct class *sg_sysfs_class;
=20
 static int sg_sysfs_valid =3D 0;
=20
-static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsid=
p)
+static Sg_device *
+sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 {
 	struct request_queue *q =3D scsidp->request_queue;
 	Sg_device *sdp;
@@ -1433,7 +1474,8 @@ static Sg_device *sg_alloc(struct gendisk *disk, stru=
ct scsi_device *scsidp)
=20
 	sdp =3D kzalloc(sizeof(Sg_device), GFP_KERNEL);
 	if (!sdp) {
-		printk(KERN_WARNING "kmalloc Sg_device failure\n");
+		sdev_printk(KERN_WARNING, scsidp, "%s: kmalloc Sg_device "
+			    "failure\n", __func__);
 		return ERR_PTR(-ENOMEM);
 	}
=20
@@ -1448,8 +1490,9 @@ static Sg_device *sg_alloc(struct gendisk *disk, stru=
ct scsi_device *scsidp)
 				    scsidp->type, SG_MAX_DEVS - 1);
 			error =3D -ENODEV;
 		} else {
-			printk(KERN_WARNING
-			       "idr allocation Sg_device failure: %d\n", error);
+			sdev_printk(KERN_WARNING, scsidp, "%s: idr "
+				    "allocation Sg_device failure: %d\n",
+				    __func__, error);
 		}
 		goto out_unlock;
 	}
@@ -1460,8 +1503,11 @@ static Sg_device *sg_alloc(struct gendisk *disk, str=
uct scsi_device *scsidp)
 	disk->first_minor =3D k;
 	sdp->disk =3D disk;
 	sdp->device =3D scsidp;
+	mutex_init(&sdp->open_rel_lock);
 	INIT_LIST_HEAD(&sdp->sfds);
-	init_waitqueue_head(&sdp->o_excl_wait);
+	init_waitqueue_head(&sdp->open_wait);
+	atomic_set(&sdp->detaching, 0);
+	rwlock_init(&sdp->sfd_lock);
 	sdp->sg_tablesize =3D queue_max_segments(q);
 	sdp->index =3D k;
 	kref_init(&sdp->d_ref);
@@ -1479,7 +1525,7 @@ static Sg_device *sg_alloc(struct gendisk *disk, stru=
ct scsi_device *scsidp)
 }
=20
 static int
-sg_add(struct device *cl_dev, struct class_interface *cl_intf)
+sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp =3D to_scsi_device(cl_dev->parent);
 	struct gendisk *disk;
@@ -1490,7 +1536,7 @@ sg_add(struct device *cl_dev, struct class_interface =
*cl_intf)
=20
 	disk =3D alloc_disk(1);
 	if (!disk) {
-		printk(KERN_WARNING "alloc_disk failed\n");
+		pr_warn("%s: alloc_disk failed\n", __func__);
 		return -ENOMEM;
 	}
 	disk->major =3D SCSI_GENERIC_MAJOR;
@@ -1498,7 +1544,7 @@ sg_add(struct device *cl_dev, struct class_interface =
*cl_intf)
 	error =3D -ENOMEM;
 	cdev =3D cdev_alloc();
 	if (!cdev) {
-		printk(KERN_WARNING "cdev_alloc failed\n");
+		pr_warn("%s: cdev_alloc failed\n", __func__);
 		goto out;
 	}
 	cdev->owner =3D THIS_MODULE;
@@ -1506,7 +1552,7 @@ sg_add(struct device *cl_dev, struct class_interface =
*cl_intf)
=20
 	sdp =3D sg_alloc(disk, scsidp);
 	if (IS_ERR(sdp)) {
-		printk(KERN_WARNING "sg_alloc failed\n");
+		pr_warn("%s: sg_alloc failed\n", __func__);
 		error =3D PTR_ERR(sdp);
 		goto out;
 	}
@@ -1524,22 +1570,20 @@ sg_add(struct device *cl_dev, struct class_interfac=
e *cl_intf)
 						      sdp->index),
 						sdp, "%s", disk->disk_name);
 		if (IS_ERR(sg_class_member)) {
-			printk(KERN_ERR "sg_add: "
-			       "device_create failed\n");
+			pr_err("%s: device_create failed\n", __func__);
 			error =3D PTR_ERR(sg_class_member);
 			goto cdev_add_err;
 		}
 		error =3D sysfs_create_link(&scsidp->sdev_gendev.kobj,
 					  &sg_class_member->kobj, "generic");
 		if (error)
-			printk(KERN_ERR "sg_add: unable to make symlink "
-					"'generic' back to sg%d\n", sdp->index);
+			pr_err("%s: unable to make symlink 'generic' back "
+			       "to sg%d\n", __func__, sdp->index);
 	} else
-		printk(KERN_WARNING "sg_add: sg_sys Invalid\n");
+		pr_warn("%s: sg_sys Invalid\n", __func__);
=20
-	sdev_printk(KERN_NOTICE, scsidp,
-		    "Attached scsi generic sg%d type %d\n", sdp->index,
-		    scsidp->type);
+	sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d "
+		    "type %d\n", sdp->index, scsidp->type);
=20
 	dev_set_drvdata(cl_dev, sdp);
=20
@@ -1558,7 +1602,8 @@ sg_add(struct device *cl_dev, struct class_interface =
*cl_intf)
 	return error;
 }
=20
-static void sg_device_destroy(struct kref *kref)
+static void
+sg_device_destroy(struct kref *kref)
 {
 	struct sg_device *sdp =3D container_of(kref, struct sg_device, d_ref);
 	unsigned long flags;
@@ -1580,33 +1625,39 @@ static void sg_device_destroy(struct kref *kref)
 	kfree(sdp);
 }
=20
-static void sg_remove(struct device *cl_dev, struct class_interface *cl_in=
tf)
+static void
+sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp =3D to_scsi_device(cl_dev->parent);
 	Sg_device *sdp =3D dev_get_drvdata(cl_dev);
 	unsigned long iflags;
 	Sg_fd *sfp;
+	int val;
=20
-	if (!sdp || sdp->detached)
+	if (!sdp)
 		return;
+	/* want sdp->detaching non-zero as soon as possible */
+	val =3D atomic_inc_return(&sdp->detaching);
+	if (val > 1)
+		return; /* only want to do following once per device */
=20
-	SCSI_LOG_TIMEOUT(3, printk("sg_remove: %s\n", sdp->disk->disk_name));
+	SCSI_LOG_TIMEOUT(3, printk("%s: %s\n", __func__,
+			 sdp->disk->disk_name));
=20
-	/* Need a write lock to set sdp->detached. */
-	write_lock_irqsave(&sg_index_lock, iflags);
-	sdp->detached =3D 1;
+	read_lock_irqsave(&sdp->sfd_lock, iflags);
 	list_for_each_entry(sfp, &sdp->sfds, sfd_siblings) {
-		wake_up_interruptible(&sfp->read_wait);
+		wake_up_interruptible_all(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	wake_up_interruptible_all(&sdp->open_wait);
+	read_unlock_irqrestore(&sdp->sfd_lock, iflags);
=20
 	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
 	device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
 	cdev_del(sdp->cdev);
 	sdp->cdev =3D NULL;
=20
-	sg_put_dev(sdp);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 }
=20
 module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUS=
R);
@@ -1676,7 +1727,8 @@ exit_sg(void)
 	idr_destroy(&sg_index_idr);
 }
=20
-static int sg_start_req(Sg_request *srp, unsigned char *cmd)
+static int
+sg_start_req(Sg_request *srp, unsigned char *cmd)
 {
 	int res;
 	struct request *rq;
@@ -1719,13 +1771,25 @@ static int sg_start_req(Sg_request *srp, unsigned c=
har *cmd)
 		md =3D &map_data;
=20
 	if (md) {
-		if (!sg_res_in_use(sfp) && dxfer_len <=3D rsv_schp->bufflen)
+		mutex_lock(&sfp->f_mutex);
+		if (dxfer_len <=3D rsv_schp->bufflen &&
+		    !sfp->res_in_use) {
+			sfp->res_in_use =3D 1;
 			sg_link_reserve(sfp, srp, dxfer_len);
-		else {
+		} else if (hp->flags & SG_FLAG_MMAP_IO) {
+			res =3D -EBUSY; /* sfp->res_in_use =3D=3D 1 */
+			if (dxfer_len > rsv_schp->bufflen)
+				res =3D -ENOMEM;
+			mutex_unlock(&sfp->f_mutex);
+			return res;
+		} else {
 			res =3D sg_build_indirect(req_schp, sfp, dxfer_len);
-			if (res)
+			if (res) {
+				mutex_unlock(&sfp->f_mutex);
 				return res;
+			}
 		}
+		mutex_unlock(&sfp->f_mutex);
=20
 		md->pages =3D req_schp->pages;
 		md->page_order =3D req_schp->page_order;
@@ -1778,7 +1842,8 @@ static int sg_start_req(Sg_request *srp, unsigned cha=
r *cmd)
 	return res;
 }
=20
-static int sg_finish_rem_req(Sg_request * srp)
+static int
+sg_finish_rem_req(Sg_request *srp)
 {
 	int ret =3D 0;
=20
@@ -1798,8 +1863,6 @@ static int sg_finish_rem_req(Sg_request * srp)
 	else
 		sg_remove_scat(req_schp);
=20
-	sg_remove_request(sfp, srp);
-
 	return ret;
 }
=20
@@ -1823,6 +1886,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp=
, int buff_size)
 	int sg_tablesize =3D sfp->parentdp->sg_tablesize;
 	int blk_size =3D buff_size, order;
 	gfp_t gfp_mask =3D GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
+	struct sg_device *sdp =3D sfp->parentdp;
=20
 	if (blk_size < 0)
 		return -EFAULT;
@@ -1847,7 +1911,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp=
, int buff_size)
 			scatter_elem_sz_prev =3D num;
 	}
=20
-	if (sfp->low_dma)
+	if (sdp->device->host->unchecked_isa_dma)
 		gfp_mask |=3D GFP_DMA;
=20
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
@@ -2008,8 +2072,9 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
 	req_schp->pages =3D NULL;
 	req_schp->page_order =3D 0;
 	req_schp->sglist_len =3D 0;
-	sfp->save_scat_len =3D 0;
 	srp->res_used =3D 0;
+	/* Called without mutex lock to avoid deadlock */
+	sfp->res_in_use =3D 0;
 }
=20
 static Sg_request *
@@ -2019,16 +2084,17 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
 	unsigned long iflags;
=20
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (resp =3D sfp->headrp; resp; resp =3D resp->nextrp) {
+	list_for_each_entry(resp, &sfp->rq_list, entry) {
 		/* look for requests that are ready + not SG_IO owned */
 		if ((1 =3D=3D resp->done) && (!resp->sg_io_owned) &&
 		    ((-1 =3D=3D pack_id) || (resp->header.pack_id =3D=3D pack_id))) {
 			resp->done =3D 2;	/* guard against other readers */
-			break;
+			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+			return resp;
 		}
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return resp;
+	return NULL;
 }
=20
 /* always adds to end of list */
@@ -2037,70 +2103,45 @@ sg_add_request(Sg_fd * sfp)
 {
 	int k;
 	unsigned long iflags;
-	Sg_request *resp;
 	Sg_request *rp =3D sfp->req_arr;
=20
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	resp =3D sfp->headrp;
-	if (!resp) {
-		memset(rp, 0, sizeof (Sg_request));
-		rp->parentfp =3D sfp;
-		resp =3D rp;
-		sfp->headrp =3D resp;
-	} else {
-		if (0 =3D=3D sfp->cmd_q)
-			resp =3D NULL;	/* command queuing disallowed */
-		else {
-			for (k =3D 0; k < SG_MAX_QUEUE; ++k, ++rp) {
-				if (!rp->parentfp)
-					break;
-			}
-			if (k < SG_MAX_QUEUE) {
-				memset(rp, 0, sizeof (Sg_request));
-				rp->parentfp =3D sfp;
-				while (resp->nextrp)
-					resp =3D resp->nextrp;
-				resp->nextrp =3D rp;
-				resp =3D rp;
-			} else
-				resp =3D NULL;
+	if (!list_empty(&sfp->rq_list)) {
+		if (!sfp->cmd_q)
+			goto out_unlock;
+
+		for (k =3D 0; k < SG_MAX_QUEUE; ++k, ++rp) {
+			if (!rp->parentfp)
+				break;
 		}
+		if (k >=3D SG_MAX_QUEUE)
+			goto out_unlock;
 	}
-	if (resp) {
-		resp->nextrp =3D NULL;
-		resp->header.duration =3D jiffies_to_msecs(jiffies);
-	}
+	memset(rp, 0, sizeof (Sg_request));
+	rp->parentfp =3D sfp;
+	rp->header.duration =3D jiffies_to_msecs(jiffies);
+	list_add_tail(&rp->entry, &sfp->rq_list);
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return resp;
+	return rp;
+out_unlock:
+	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	return NULL;
 }
=20
 /* Return of 1 for found; 0 for not found */
 static int
 sg_remove_request(Sg_fd * sfp, Sg_request * srp)
 {
-	Sg_request *prev_rp;
-	Sg_request *rp;
 	unsigned long iflags;
 	int res =3D 0;
=20
-	if ((!sfp) || (!srp) || (!sfp->headrp))
+	if (!sfp || !srp || list_empty(&sfp->rq_list))
 		return res;
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	prev_rp =3D sfp->headrp;
-	if (srp =3D=3D prev_rp) {
-		sfp->headrp =3D prev_rp->nextrp;
-		prev_rp->parentfp =3D NULL;
+	if (!list_empty(&srp->entry)) {
+		list_del(&srp->entry);
+		srp->parentfp =3D NULL;
 		res =3D 1;
-	} else {
-		while ((rp =3D prev_rp->nextrp)) {
-			if (srp =3D=3D rp) {
-				prev_rp->nextrp =3D rp->nextrp;
-				rp->parentfp =3D NULL;
-				res =3D 1;
-				break;
-			}
-			prev_rp =3D rp;
-		}
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return res;
@@ -2115,29 +2156,33 @@ sg_add_sfp(Sg_device * sdp, int dev)
=20
 	sfp =3D kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
=20
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
-
+	INIT_LIST_HEAD(&sfp->rq_list);
 	kref_init(&sfp->f_ref);
+	mutex_init(&sfp->f_mutex);
 	sfp->timeout =3D SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user =3D SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid =3D SG_DEF_FORCE_PACK_ID;
-	sfp->low_dma =3D (SG_DEF_FORCE_LOW_DMA =3D=3D 0) ?
-	    sdp->device->host->unchecked_isa_dma : 1;
 	sfp->cmd_q =3D SG_DEF_COMMAND_Q;
 	sfp->keep_orphan =3D SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp =3D sdp;
-	write_lock_irqsave(&sg_index_lock, iflags);
+	write_lock_irqsave(&sdp->sfd_lock, iflags);
+	if (atomic_read(&sdp->detaching)) {
+		write_unlock_irqrestore(&sdp->sfd_lock, iflags);
+		kfree(sfp);
+		return ERR_PTR(-ENODEV);
+	}
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=3D0x%p\n", sfp));
 	if (unlikely(sg_big_buff !=3D def_reserved_size))
 		sg_big_buff =3D def_reserved_size;
=20
 	bufflen =3D min_t(int, sg_big_buff,
-			queue_max_sectors(sdp->device->request_queue) * 512);
+			max_sectors_bytes(sdp->device->request_queue));
 	sg_build_reserve(sfp, bufflen);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=3D%d, k_use_sg=3D%d\n",
 			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
@@ -2147,14 +2192,23 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	return sfp;
 }
=20
-static void sg_remove_sfp_usercontext(struct work_struct *work)
+static void
+sg_remove_sfp_usercontext(struct work_struct *work)
 {
 	struct sg_fd *sfp =3D container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp =3D sfp->parentdp;
+	Sg_request *srp;
+	unsigned long iflags;
=20
 	/* Cleanup any responses which were never read(). */
-	while (sfp->headrp)
-		sg_finish_rem_req(sfp->headrp);
+	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	while (!list_empty(&sfp->rq_list)) {
+		srp =3D list_first_entry(&sfp->rq_list, Sg_request, entry);
+		sg_finish_rem_req(srp);
+		list_del(&srp->entry);
+		srp->parentfp =3D NULL;
+	}
+	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
=20
 	if (sfp->reserve.bufflen > 0) {
 		SCSI_LOG_TIMEOUT(6,
@@ -2171,39 +2225,25 @@ static void sg_remove_sfp_usercontext(struct work_s=
truct *work)
 	kfree(sfp);
=20
 	scsi_device_put(sdp->device);
-	sg_put_dev(sdp);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 	module_put(THIS_MODULE);
 }
=20
-static void sg_remove_sfp(struct kref *kref)
+static void
+sg_remove_sfp(struct kref *kref)
 {
 	struct sg_fd *sfp =3D container_of(kref, struct sg_fd, f_ref);
 	struct sg_device *sdp =3D sfp->parentdp;
 	unsigned long iflags;
=20
-	write_lock_irqsave(&sg_index_lock, iflags);
+	write_lock_irqsave(&sdp->sfd_lock, iflags);
 	list_del(&sfp->sfd_siblings);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
-	wake_up_interruptible(&sdp->o_excl_wait);
+	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
=20
 	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
 	schedule_work(&sfp->ew.work);
 }
=20
-static int
-sg_res_in_use(Sg_fd * sfp)
-{
-	const Sg_request *srp;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (srp =3D sfp->headrp; srp; srp =3D srp->nextrp)
-		if (srp->res_used)
-			break;
-	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return srp ? 1 : 0;
-}
-
 #ifdef CONFIG_SCSI_PROC_FS
 static int
 sg_idr_max_id(int id, void *p, void *data)
@@ -2235,7 +2275,8 @@ static Sg_device *sg_lookup_dev(int dev)
 	return idr_find(&sg_index_idr, dev);
 }
=20
-static Sg_device *sg_get_dev(int dev)
+static Sg_device *
+sg_get_dev(int dev)
 {
 	struct sg_device *sdp;
 	unsigned long flags;
@@ -2244,8 +2285,8 @@ static Sg_device *sg_get_dev(int dev)
 	sdp =3D sg_lookup_dev(dev);
 	if (!sdp)
 		sdp =3D ERR_PTR(-ENXIO);
-	else if (sdp->detached) {
-		/* If sdp->detached, then the refcount may already be 0, in
+	else if (atomic_read(&sdp->detaching)) {
+		/* If sdp->detaching, then the refcount may already be 0, in
 		 * which case it would be a bug to do kref_get().
 		 */
 		sdp =3D ERR_PTR(-ENODEV);
@@ -2256,11 +2297,6 @@ static Sg_device *sg_get_dev(int dev)
 	return sdp;
 }
=20
-static void sg_put_dev(struct sg_device *sdp)
-{
-	kref_put(&sdp->d_ref, sg_device_destroy);
-}
-
 #ifdef CONFIG_SCSI_PROC_FS
=20
 static struct proc_dir_entry *sg_proc_sgp =3D NULL;
@@ -2477,8 +2513,7 @@ static int sg_proc_single_open_version(struct inode *=
inode, struct file *file)
=20
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
 {
-	seq_printf(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\t"
-		   "online\n");
+	seq_puts(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\tonline\n");
 	return 0;
 }
=20
@@ -2534,7 +2569,11 @@ static int sg_proc_seq_show_dev(struct seq_file *s, =
void *v)
=20
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp =3D it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && (scsidp =3D sdp->device) && (!sdp->detached))
+	if ((NULL =3D=3D sdp) || (NULL =3D=3D sdp->device) ||
+	    (atomic_read(&sdp->detaching)))
+		seq_puts(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	else {
+		scsidp =3D sdp->device;
 		seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
 			      scsidp->host->host_no, scsidp->channel,
 			      scsidp->id, scsidp->lun, (int) scsidp->type,
@@ -2542,8 +2581,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, v=
oid *v)
 			      (int) scsidp->queue_depth,
 			      (int) scsidp->device_busy,
 			      (int) scsi_device_online(scsidp));
-	else
-		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
@@ -2562,11 +2600,12 @@ static int sg_proc_seq_show_devstrs(struct seq_file=
 *s, void *v)
=20
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp =3D it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && (scsidp =3D sdp->device) && (!sdp->detached))
+	scsidp =3D sdp ? sdp->device : NULL;
+	if (sdp && scsidp && (!atomic_read(&sdp->detaching)))
 		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n",
 			   scsidp->vendor, scsidp->model, scsidp->rev);
 	else
-		seq_printf(s, "<no active device>\n");
+		seq_puts(s, "<no active device>\n");
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
@@ -2574,7 +2613,7 @@ static int sg_proc_seq_show_devstrs(struct seq_file *=
s, void *v)
 /* must be called while holding sg_index_lock */
 static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 {
-	int k, m, new_interface, blen, usg;
+	int k, new_interface, blen, usg;
 	Sg_request *srp;
 	Sg_fd *fp;
 	const sg_io_hdr_t *hp;
@@ -2590,17 +2629,15 @@ static void sg_proc_debug_helper(struct seq_file *s=
, Sg_device * sdp)
 			   jiffies_to_msecs(fp->timeout),
 			   fp->reserve.bufflen,
 			   (int) fp->reserve.k_use_sg,
-			   (int) fp->low_dma);
+			   (int) sdp->device->host->unchecked_isa_dma);
 		seq_printf(s, "   cmd_q=3D%d f_packid=3D%d k_orphan=3D%d closed=3D0\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
 			   (int) fp->keep_orphan);
-		for (m =3D 0, srp =3D fp->headrp;
-				srp !=3D NULL;
-				++m, srp =3D srp->nextrp) {
+		list_for_each_entry(srp, &fp->rq_list, entry) {
 			hp =3D &srp->header;
 			new_interface =3D (hp->interface_id =3D=3D '\0') ? 0 : 1;
 			if (srp->res_used) {
-				if (new_interface &&=20
+				if (new_interface &&
 				    (SG_FLAG_MMAP_IO & hp->flags))
 					cp =3D "     mmap>> ";
 				else
@@ -2611,12 +2648,12 @@ static void sg_proc_debug_helper(struct seq_file *s=
, Sg_device * sdp)
 				else
 					cp =3D "     ";
 			}
-			seq_printf(s, cp);
+			seq_puts(s, cp);
 			blen =3D srp->data.bufflen;
 			usg =3D srp->data.k_use_sg;
-			seq_printf(s, srp->done ?=20
-				   ((1 =3D=3D srp->done) ?  "rcv:" : "fin:")
-				   : "act:");
+			seq_puts(s, srp->done ?
+				 ((1 =3D=3D srp->done) ?  "rcv:" : "fin:")
+				  : "act:");
 			seq_printf(s, " id=3D%d blen=3D%d",
 				   srp->header.pack_id, blen);
 			if (srp->done)
@@ -2631,8 +2668,8 @@ static void sg_proc_debug_helper(struct seq_file *s, =
Sg_device * sdp)
 			seq_printf(s, "ms sgat=3D%d op=3D0x%02x\n", usg,
 				   (int) srp->data.cmd_opcode);
 		}
-		if (0 =3D=3D m)
-			seq_printf(s, "     No requests active\n");
+		if (list_empty(&fp->rq_list))
+			seq_puts(s, "     No requests active\n");
 		read_unlock(&fp->rq_list_lock);
 	}
 }
@@ -2648,31 +2685,34 @@ static int sg_proc_seq_show_debug(struct seq_file *=
s, void *v)
 	Sg_device *sdp;
 	unsigned long iflags;
=20
-	if (it && (0 =3D=3D it->index)) {
-		seq_printf(s, "max_active_device=3D%d(origin 1)\n",
-			   (int)it->max);
-		seq_printf(s, " def_reserved_size=3D%d\n", sg_big_buff);
-	}
+	if (it && (0 =3D=3D it->index))
+		seq_printf(s, "max_active_device=3D%d  def_reserved_size=3D%d\n",
+			   (int)it->max, sg_big_buff);
=20
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp =3D it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && !list_empty(&sdp->sfds)) {
-		struct scsi_device *scsidp =3D sdp->device;
-
+	if (NULL =3D=3D sdp)
+		goto skip;
+	read_lock(&sdp->sfd_lock);
+	if (!list_empty(&sdp->sfds)) {
 		seq_printf(s, " >>> device=3D%s ", sdp->disk->disk_name);
-		if (sdp->detached)
-			seq_printf(s, "detached pending close ");
-		else
-			seq_printf
-			    (s, "scsi%d chan=3D%d id=3D%d lun=3D%d   em=3D%d",
-			     scsidp->host->host_no,
-			     scsidp->channel, scsidp->id,
-			     scsidp->lun,
-			     scsidp->host->hostt->emulated);
-		seq_printf(s, " sg_tablesize=3D%d excl=3D%d\n",
-			   sdp->sg_tablesize, get_exclude(sdp));
+		if (atomic_read(&sdp->detaching))
+			seq_puts(s, "detaching pending close ");
+		else if (sdp->device) {
+			struct scsi_device *scsidp =3D sdp->device;
+
+			seq_printf(s, "%d:%d:%d:%d   em=3D%d",
+				   scsidp->host->host_no,
+				   scsidp->channel, scsidp->id,
+				   scsidp->lun,
+				   scsidp->host->hostt->emulated);
+		}
+		seq_printf(s, " sg_tablesize=3D%d excl=3D%d open_cnt=3D%d\n",
+			   sdp->sg_tablesize, sdp->exclude, sdp->open_cnt);
 		sg_proc_debug_helper(s, sdp);
 	}
+	read_unlock(&sdp->sfd_lock);
+skip:
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index f7019c7e9bc5..da693eceff9a 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -306,9 +306,10 @@ static void sg_complete(struct urb *urb)
 		 */
 		spin_unlock(&io->lock);
 		for (i =3D 0, found =3D 0; i < io->entries; i++) {
-			if (!io->urbs[i] || !io->urbs[i]->dev)
+			if (!io->urbs[i])
 				continue;
 			if (found) {
+				usb_block_urb(io->urbs[i]);
 				retval =3D usb_unlink_urb(io->urbs[i]);
 				if (retval !=3D -EINPROGRESS &&
 				    retval !=3D -ENODEV &&
@@ -519,12 +520,10 @@ void usb_sg_wait(struct usb_sg_request *io)
 		int retval;
=20
 		io->urbs[i]->dev =3D io->dev;
-		retval =3D usb_submit_urb(io->urbs[i], GFP_ATOMIC);
-
-		/* after we submit, let completions or cancellations fire;
-		 * we handshake using io->status.
-		 */
 		spin_unlock_irq(&io->lock);
+
+		retval =3D usb_submit_urb(io->urbs[i], GFP_NOIO);
+
 		switch (retval) {
 			/* maybe we retrying will recover */
 		case -ENXIO:	/* hc didn't queue this one */
@@ -582,30 +581,34 @@ EXPORT_SYMBOL_GPL(usb_sg_wait);
 void usb_sg_cancel(struct usb_sg_request *io)
 {
 	unsigned long flags;
+	int i, retval;
=20
 	spin_lock_irqsave(&io->lock, flags);
+	if (io->status || io->count =3D=3D 0) {
+		spin_unlock_irqrestore(&io->lock, flags);
+		return;
+	}
+	/* shut everything down */
+	io->status =3D -ECONNRESET;
+	io->count++;		/* Keep the request alive until we're done */
+	spin_unlock_irqrestore(&io->lock, flags);
=20
-	/* shut everything down, if it didn't already */
-	if (!io->status) {
-		int i;
-
-		io->status =3D -ECONNRESET;
-		spin_unlock(&io->lock);
-		for (i =3D 0; i < io->entries; i++) {
-			int retval;
+	for (i =3D io->entries - 1; i >=3D 0; --i) {
+		usb_block_urb(io->urbs[i]);
=20
-			if (!io->urbs[i]->dev)
-				continue;
-			retval =3D usb_unlink_urb(io->urbs[i]);
-			if (retval !=3D -EINPROGRESS
-					&& retval !=3D -ENODEV
-					&& retval !=3D -EBUSY
-					&& retval !=3D -EIDRM)
-				dev_warn(&io->dev->dev, "%s, unlink --> %d\n",
-					__func__, retval);
-		}
-		spin_lock(&io->lock);
+		retval =3D usb_unlink_urb(io->urbs[i]);
+		if (retval !=3D -EINPROGRESS
+		    && retval !=3D -ENODEV
+		    && retval !=3D -EBUSY
+		    && retval !=3D -EIDRM)
+			dev_warn(&io->dev->dev, "%s, unlink --> %d\n",
+				 __func__, retval);
 	}
+
+	spin_lock_irqsave(&io->lock, flags);
+	io->count--;
+	if (!io->count)
+		complete(&io->complete);
 	spin_unlock_irqrestore(&io->lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_sg_cancel);
diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 3589be72f598..05b9adde1a17 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -254,6 +254,9 @@ static ssize_t gadget_dev_desc_UDC_store(struct gadget_=
info *gi,
 	char *name;
 	int ret;
=20
+	if (strlen(page) < len)
+		return -EOVERFLOW;
+
 	name =3D kstrdup(page, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
diff --git a/drivers/video/fbdev/geode/video_gx.c b/drivers/video/fbdev/geo=
de/video_gx.c
index 6082f653c68a..67773e8bbb95 100644
--- a/drivers/video/fbdev/geode/video_gx.c
+++ b/drivers/video/fbdev/geode/video_gx.c
@@ -127,7 +127,7 @@ void gx_set_dclk_frequency(struct fb_info *info)
 	int timeout =3D 1000;
=20
 	/* Rev. 1 Geode GXs use a 14 MHz reference clock instead of 48 MHz. */
-	if (cpu_data(0).x86_mask =3D=3D 1) {
+	if (cpu_data(0).x86_stepping =3D=3D 1) {
 		pll_table =3D gx_pll_table_14MHz;
 		pll_table_len =3D ARRAY_SIZE(gx_pll_table_14MHz);
 	} else {
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 2df8642c3ac1..563b42f3f3ba 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1575,7 +1575,7 @@ static int fill_thread_core_info(struct elf_thread_co=
re_info *t,
 		    (!regset->active || regset->active(t->task, regset) > 0)) {
 			int ret;
 			size_t size =3D regset->n * regset->size;
-			void *data =3D kmalloc(size, GFP_KERNEL);
+			void *data =3D kzalloc(size, GFP_KERNEL);
 			if (unlikely(!data))
 				return 0;
 			ret =3D regset->get(t->task, regset,
diff --git a/fs/exec.c b/fs/exec.c
index 077f85439264..680d1dbcf564 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1182,7 +1182,7 @@ void setup_new_exec(struct linux_binprm * bprm)
=20
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
-	current->self_exec_id++;
+	ACCESS_ONCE(current->self_exec_id) =3D current->self_exec_id + 1;
 	flush_signal_handlers(current, 0);
 }
 EXPORT_SYMBOL(setup_new_exec);
diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 41eb9dcfac7e..c6836e6726ae 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -137,6 +137,50 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
 	printk("\n");
 }
=20
+static int ext4_protect_reserved_inode(struct super_block *sb, u32 ino)
+{
+	struct inode *inode;
+	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
+	struct ext4_map_blocks map;
+	u32 i =3D 0, num;
+	int err =3D 0, n;
+
+	if ((ino < EXT4_ROOT_INO) ||
+	    (ino > le32_to_cpu(sbi->s_es->s_inodes_count)))
+		return -EINVAL;
+	inode =3D ext4_iget(sb, ino, EXT4_IGET_SPECIAL);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	num =3D (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
+	while (i < num) {
+		cond_resched();
+		map.m_lblk =3D i;
+		map.m_len =3D num - i;
+		n =3D ext4_map_blocks(NULL, inode, &map, 0);
+		if (n < 0) {
+			err =3D n;
+			break;
+		}
+		if (n =3D=3D 0) {
+			i++;
+		} else {
+			if (!ext4_data_block_valid(sbi, map.m_pblk, n)) {
+				ext4_error(sb, "blocks %llu-%llu from inode %u "
+					   "overlap system zone", map.m_pblk,
+					   map.m_pblk + map.m_len - 1, ino);
+				err =3D -EIO;
+				break;
+			}
+			err =3D add_system_zone(sbi, map.m_pblk, n);
+			if (err < 0)
+				break;
+			i +=3D n;
+		}
+	}
+	iput(inode);
+	return err;
+}
+
 int ext4_setup_system_zone(struct super_block *sb)
 {
 	ext4_group_t ngroups =3D ext4_get_groups_count(sb);
@@ -171,6 +215,13 @@ int ext4_setup_system_zone(struct super_block *sb)
 		if (ret)
 			return ret;
 	}
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL) &&
+	    sbi->s_es->s_journal_inum) {
+		ret =3D ext4_protect_reserved_inode(sb,
+				le32_to_cpu(sbi->s_es->s_journal_inum));
+		if (ret)
+			return ret;
+	}
=20
 	if (test_opt(sb, DEBUG))
 		debug_print_tree(EXT4_SB(sb));
@@ -227,6 +278,12 @@ int ext4_check_blockref(const char *function, unsigned=
 int line,
 	__le32 *bref =3D p;
 	unsigned int blk;
=20
+	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
+				    EXT4_FEATURE_COMPAT_HAS_JOURNAL) &&
+	    (inode->i_ino =3D=3D
+	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum)))
+		return 0;
+
 	while (bref < p+max) {
 		blk =3D le32_to_cpu(*bref++);
 		if (blk &&
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 09e978818474..929834c9a85c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2411,21 +2411,24 @@ extern void ext4_group_desc_csum_set(struct super_b=
lock *sb, __u32 group,
 extern int ext4_register_li_request(struct super_block *sb,
 				    ext4_group_t first_not_zeroed);
=20
-static inline int ext4_has_group_desc_csum(struct super_block *sb)
-{
-	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
-	       (EXT4_SB(sb)->s_chksum_driver !=3D NULL);
-}
-
 static inline int ext4_has_metadata_csum(struct super_block *sb)
 {
 	WARN_ON_ONCE(EXT4_HAS_RO_COMPAT_FEATURE(sb,
 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
 		     !EXT4_SB(sb)->s_chksum_driver);
=20
-	return (EXT4_SB(sb)->s_chksum_driver !=3D NULL);
+	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	       (EXT4_SB(sb)->s_chksum_driver !=3D NULL);
+}
+
+static inline int ext4_has_group_desc_csum(struct super_block *sb)
+{
+	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
+					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
+		ext4_has_metadata_csum(sb);
 }
+
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
 	return ((ext4_fsblk_t)le32_to_cpu(es->s_blocks_count_hi) << 32) |
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 02dca6c43316..43602f4b0ae5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -503,10 +503,15 @@ __read_extent_tree_block(const char *function, unsign=
ed int line,
 	}
 	if (buffer_verified(bh) && !(flags & EXT4_EX_FORCE_CACHE))
 		return bh;
-	err =3D __ext4_ext_check(function, line, inode,
-			       ext_block_hdr(bh), depth, pblk);
-	if (err)
-		goto errout;
+	if (!EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
+				     EXT4_FEATURE_COMPAT_HAS_JOURNAL) ||
+	    (inode->i_ino !=3D
+	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum))) {
+		err =3D __ext4_ext_check(function, line, inode,
+				       ext_block_hdr(bh), depth, pblk);
+		if (err)
+			goto errout;
+	}
 	set_buffer_verified(bh);
 	/*
 	 * If this is a leaf block, cache all of its entries
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 66aed5f01784..67d8c6a7b182 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -411,6 +411,11 @@ static int __check_block_validity(struct inode *inode,=
 const char *func,
 				unsigned int line,
 				struct ext4_map_blocks *map)
 {
+	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
+				    EXT4_FEATURE_COMPAT_HAS_JOURNAL) &&
+	    (inode->i_ino =3D=3D
+	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum)))
+		return 0;
 	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), map->m_pblk,
 				   map->m_len)) {
 		ext4_error_inode(inode, func, line, map->m_pblk,
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetabl=
e.h
index 4c546028b035..db45b2a21d2f 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -559,6 +559,10 @@ struct amba_id {
 /*
  * MODULE_DEVICE_TABLE expects this struct to be called x86cpu_device_id.
  * Although gcc seems to ignore this error, clang fails without this defin=
e.
+ *
+ * Note: The ordering of the struct is different from upstream because the
+ * static initializers in kernels < 5.7 still use C89 style while upstream
+ * has been converted to proper C99 initializers.
  */
 #define x86cpu_device_id x86_cpu_id
 struct x86_cpu_id {
@@ -567,6 +571,7 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 feature;	/* bit index */
 	kernel_ulong_t driver_data;
+	__u16 steppings;
 };
=20
 #define X86_FEATURE_MATCH(x) \
@@ -575,6 +580,7 @@ struct x86_cpu_id {
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
+#define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
=20
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index bcd8b1664301..182f15430cb0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1427,8 +1427,8 @@ struct task_struct {
 	struct seccomp seccomp;
=20
 /* Thread group tracking */
-   	u32 parent_exec_id;
-   	u32 self_exec_id;
+	u64 parent_exec_id;
+	u64 self_exec_id;
 /* Protection of (de-)allocation: mm, files, fs, tty, keyrings, mems_allow=
ed,
  * mempolicy */
 	spinlock_t alloc_lock;
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index a9f3c6fc3f57..034cf63c1342 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -234,7 +234,6 @@ typedef struct sg_req_info { /* used by SG_GET_REQUEST_=
TABLE ioctl() */
 #define SG_DEFAULT_RETRIES 0
=20
 /* Defaults, commented if they differ from original sg driver */
-#define SG_DEF_FORCE_LOW_DMA 0  /* was 1 -> memory below 16MB on i386 */
 #define SG_DEF_FORCE_PACK_ID 0
 #define SG_DEF_KEEP_ORPHAN 0
 #define SG_DEF_RESERVED_SIZE SG_SCATTER_SZ /* load time option */
diff --git a/kernel/signal.c b/kernel/signal.c
index 6816d3ae6f46..d7b33730a2a4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1679,7 +1679,7 @@ bool do_notify_parent(struct task_struct *tsk, int si=
g)
 		 * This is only possible if parent =3D=3D real_parent.
 		 * Check if it has changed security domain.
 		 */
-		if (tsk->parent_exec_id !=3D tsk->parent->self_exec_id)
+		if (tsk->parent_exec_id !=3D ACCESS_ONCE(tsk->parent->self_exec_id))
 			sig =3D SIGCHLD;
 	}
=20
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 7550d098e3b7..ada029c4af3a 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -782,25 +782,30 @@ static int rx_queue_add_kobject(struct net_device *ne=
t, int index)
 	struct kobject *kobj =3D &queue->kobj;
 	int error =3D 0;
=20
+	/* Kobject_put later will trigger rx_queue_release call which
+	 * decreases dev refcount: Take that reference here
+	 */
+	dev_hold(queue->dev);
+
 	kobj->kset =3D net->queues_kset;
 	error =3D kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
 	    "rx-%u", index);
 	if (error)
-		return error;
-
-	dev_hold(queue->dev);
+		goto err;
=20
 	if (net->sysfs_rx_queue_group) {
 		error =3D sysfs_create_group(kobj, net->sysfs_rx_queue_group);
-		if (error) {
-			kobject_put(kobj);
-			return error;
-		}
+		if (error)
+			goto err;
 	}
=20
 	kobject_uevent(kobj, KOBJ_ADD);
=20
 	return error;
+
+err:
+	kobject_put(kobj);
+	return error;
 }
 #endif /* CONFIG_SYSFS */
=20
@@ -1141,25 +1146,29 @@ static int netdev_queue_add_kobject(struct net_devi=
ce *net, int index)
 	struct kobject *kobj =3D &queue->kobj;
 	int error =3D 0;
=20
+	/* Kobject_put later will trigger netdev_queue_release call
+	 * which decreases dev refcount: Take that reference here
+	 */
+	dev_hold(queue->dev);
+
 	kobj->kset =3D net->queues_kset;
 	error =3D kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
 	    "tx-%u", index);
 	if (error)
-		return error;
-
-	dev_hold(queue->dev);
+		goto err;
=20
 #ifdef CONFIG_BQL
 	error =3D sysfs_create_group(kobj, &dql_group);
-	if (error) {
-		kobject_put(kobj);
-		return error;
-	}
+	if (error)
+		goto err;
 #endif
=20
 	kobject_uevent(kobj, KOBJ_ADD);
-
 	return 0;
+
+err:
+	kobject_put(kobj);
+	return error;
 }
 #endif /* CONFIG_SYSFS */
=20
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 60d50812900f..84f4a4e9e2ba 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4669,37 +4669,59 @@ static int selinux_tun_dev_open(void *security)
=20
 static int selinux_nlmsg_perm(struct sock *sk, struct sk_buff *skb)
 {
-	int err =3D 0;
-	u32 perm;
+	int rc =3D 0;
+	unsigned int msg_len;
+	unsigned int data_len =3D skb->len;
+	unsigned char *data =3D skb->data;
 	struct nlmsghdr *nlh;
 	struct sk_security_struct *sksec =3D sk->sk_security;
+	u16 sclass =3D sksec->sclass;
+	u32 perm;
=20
-	if (skb->len < NLMSG_HDRLEN) {
-		err =3D -EINVAL;
-		goto out;
-	}
-	nlh =3D nlmsg_hdr(skb);
-
-	err =3D selinux_nlmsg_lookup(sksec->sclass, nlh->nlmsg_type, &perm);
-	if (err) {
-		if (err =3D=3D -EINVAL) {
-			audit_log(current->audit_context, GFP_KERNEL, AUDIT_SELINUX_ERR,
-				  "SELinux:  unrecognized netlink message"
-				  " type=3D%hu for sclass=3D%hu\n",
-				  nlh->nlmsg_type, sksec->sclass);
-			if (!selinux_enforcing || security_get_allow_unknown())
-				err =3D 0;
+	while (data_len >=3D nlmsg_total_size(0)) {
+		nlh =3D (struct nlmsghdr *)data;
+
+		/* NOTE: the nlmsg_len field isn't reliably set by some netlink
+		 *       users which means we can't reject skb's with bogus
+		 *       length fields; our solution is to follow what
+		 *       netlink_rcv_skb() does and simply skip processing at
+		 *       messages with length fields that are clearly junk
+		 */
+		if (nlh->nlmsg_len < NLMSG_HDRLEN || nlh->nlmsg_len > data_len)
+			return 0;
+
+		rc =3D selinux_nlmsg_lookup(sclass, nlh->nlmsg_type, &perm);
+		if (rc =3D=3D 0) {
+			rc =3D sock_has_perm(current, sk, perm);
+			if (rc)
+				return rc;
+		} else if (rc =3D=3D -EINVAL) {
+			/* -EINVAL is a missing msg/perm mapping */
+			pr_warn_ratelimited("SELinux: unrecognized netlink"
+				" message: protocol=3D%hu nlmsg_type=3D%hu sclass=3D%s"
+				" pid=3D%d comm=3D%s\n",
+				sk->sk_protocol, nlh->nlmsg_type,
+				secclass_map[sclass - 1].name,
+				task_pid_nr(current), current->comm);
+			if (selinux_enforcing && !security_get_allow_unknown())
+				return rc;
+			rc =3D 0;
+		} else if (rc =3D=3D -ENOENT) {
+			/* -ENOENT is a missing socket/class mapping, ignore */
+			rc =3D 0;
+		} else {
+			return rc;
 		}
=20
-		/* Ignore */
-		if (err =3D=3D -ENOENT)
-			err =3D 0;
-		goto out;
+		/* move to the next message after applying netlink padding */
+		msg_len =3D NLMSG_ALIGN(nlh->nlmsg_len);
+		if (msg_len >=3D data_len)
+			return 0;
+		data_len -=3D msg_len;
+		data +=3D msg_len;
 	}
=20
-	err =3D sock_has_perm(current, sk, perm);
-out:
-	return err;
+	return rc;
 }
=20
 #ifdef CONFIG_NETFILTER

--qDbXVdCdHGoSgWSk--

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7ieV8ACgkQ57/I7JWG
EQn4xBAAyTOkcxr1ITJVtEooRS5fdW/0NKCV8S0VLyALWF8al251/hGAqLhs0qTP
SnxgmShy/pPXv7XlNv/n253fVX8p99eHTkhx871ujSIRkN1UAAvL4NgBu/OoCfB1
nrXGXAD71qdb5pzweneo3abFhl8Ioc06vqe9Pc/R7IUOWqrtwd/3a22oX1OO2GxF
6lnjrLjDFPmd1DoD68Eo2hp9yfQBc0SWpDyo+ijMZCdOCOXpcMyZ5O3cqA4PM3Pd
vJ2UuLS//Slc5nRjwAjEPxiGXSx53jE6Zl4o5XpXH9VbuFPHKgtEtztmSQRCMGc4
ZcmGjODiq53WBQPkHsg1Co6LMOCEuYaLjvK5L2ddjaru2Bby/x0oMVC28eeIeABv
7qDegxwyvAZGo6ysQGbeNHeZRtyp+nQAiMi/yVJHary5LMg0oXBqA/cwNLjkx0AT
pxj0IRxjS3XLRSbuzOjqSqVLovxXTOa5iLitCoQEnP1hQp8CBYdMUn5Vf5TjbU5A
+bQbEnpgLZ4rRPpPP12HP7O0amDWM//xV0rjShqTUHu+aIUy4XexdW899hoeGNEb
bS9jOb88THJXpjSxkVKcwpsp7nC9rOcDBTd3b6JtryYzgBNDfIJHOqoIMYT9rN6X
k591avzst0o0V44ftBi42TyV73sgswrJCk7BhW2TrypE4YLOulg=
=tPHN
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
