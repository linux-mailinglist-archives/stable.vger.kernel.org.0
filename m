Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF135FD31E
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 04:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfKODGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 22:06:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43660 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbfKODGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 22:06:47 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iVRwZ-0001iU-MM; Fri, 15 Nov 2019 03:06:43 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iVRwZ-0000Ey-6O; Fri, 15 Nov 2019 03:06:43 +0000
Date:   Fri, 15 Nov 2019 03:06:43 +0000
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Subject: Linux 3.16.77
Message-ID: <lsq.1573787152.846673539@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.16.77 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git

The diff from 3.16.76 is attached to this message.

Ben.

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu |   2 +
 Documentation/hw-vuln/tsx_async_abort.rst          | 268 +++++++++++++++++++++
 Documentation/kernel-parameters.txt                |  62 +++++
 Documentation/x86/tsx_async_abort.rst              | 117 +++++++++
 Makefile                                           |   2 +-
 arch/x86/Kconfig                                   |  45 ++++
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/include/asm/nospec-branch.h               |   4 +-
 arch/x86/include/asm/processor.h                   |   7 +
 arch/x86/include/uapi/asm/msr-index.h              |  16 ++
 arch/x86/kernel/cpu/Makefile                       |   2 +-
 arch/x86/kernel/cpu/bugs.c                         | 143 ++++++++++-
 arch/x86/kernel/cpu/common.c                       |  93 ++++---
 arch/x86/kernel/cpu/cpu.h                          |  18 ++
 arch/x86/kernel/cpu/intel.c                        |   5 +
 arch/x86/kernel/cpu/tsx.c                          | 140 +++++++++++
 arch/x86/kvm/cpuid.c                               |   7 +
 arch/x86/kvm/x86.c                                 |  40 ++-
 drivers/base/cpu.c                                 |  17 ++
 drivers/gpu/drm/i915/i915_drv.c                    |   4 +
 drivers/gpu/drm/i915/i915_drv.h                    |   5 +
 drivers/gpu/drm/i915/i915_reg.h                    |   2 +
 drivers/gpu/drm/i915/intel_display.c               |   9 +
 drivers/gpu/drm/i915/intel_drv.h                   |   3 +
 drivers/gpu/drm/i915/intel_pm.c                    | 146 ++++++++++-
 drivers/isdn/mISDN/socket.c                        |   2 +
 drivers/media/usb/dvb-usb/technisat-usb2.c         |  21 +-
 drivers/media/usb/zr364xx/zr364xx.c                |   3 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |   8 +
 drivers/net/wireless/rtlwifi/ps.c                  |   6 +
 include/linux/cpu.h                                |   5 +
 net/appletalk/ddp.c                                |   5 +
 net/ax25/af_ax25.c                                 |   2 +
 net/ieee802154/af_ieee802154.c                     |   3 +
 net/nfc/llcp_sock.c                                |   7 +-
 net/sched/sch_netem.c                              |   9 +-
 net/wireless/wext-sme.c                            |   8 +-
 38 files changed, 1171 insertions(+), 68 deletions(-)

Ben Hutchings (2):
      KVM: Introduce kvm_get_arch_capabilities()
      Linux 3.16.77

Hui Peng (1):
      ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

Imre Deak (1):
      drm/i915/gen8+: Add RC6 CTX corruption WA

Jakub Kicinski (1):
      net: netem: fix error path for corrupted GSO frames

Josh Poimboeuf (1):
      x86/speculation/taa: Fix printing of TAA_MSG_SMT on IBRS_ALL CPUs

Laura Abbott (1):
      rtlwifi: Fix potential overflow on P2P code

Michal Hocko (1):
      x86/tsx: Add config options to set tsx=on|off|auto

Ori Nimron (5):
      ax25: enforce CAP_NET_RAW for raw sockets
      ieee802154: enforce CAP_NET_RAW for raw sockets
      appletalk: enforce CAP_NET_RAW for raw sockets
      mISDN: enforce CAP_NET_RAW for raw sockets
      nfc: enforce CAP_NET_RAW for raw sockets

Paolo Bonzini (1):
      KVM: x86: use Intel speculation bugs and features as derived in generic x86 code

Pawan Gupta (8):
      x86/msr: Add the IA32_TSX_CTRL MSR
      x86/cpu: Add a helper function x86_read_arch_cap_msr()
      x86/cpu: Add a "tsx=" cmdline option with TSX disabled by default
      x86/speculation/taa: Add mitigation for TSX Async Abort
      x86/speculation/taa: Add sysfs reporting for TSX Async Abort
      kvm/x86: Export MDS_NO=0 to guests when TSX is enabled
      x86/tsx: Add "auto" option to the tsx= cmdline parameter
      x86/speculation/taa: Add documentation for TSX Async Abort

Sean Young (1):
      media: technisat-usb2: break out of loop at end of buffer

Vandana BN (1):
      media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_querycap

Vineela Tummalapalli (1):
      x86/bugs: Add ITLB_MULTIHIT bug infrastructure

Will Deacon (1):
      cfg80211: wext: avoid copying malformed SSIDs


--azLHFNyN32YCQGCU
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.77.patch"
Content-Disposition: attachment; filename="linux-3.16.77.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documenta=
tion/ABI/testing/sysfs-devices-system-cpu
index 9d4dbf0adb21..2fdfbf6337e7 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -232,6 +232,8 @@ What:		/sys/devices/system/cpu/vulnerabilities
 		/sys/devices/system/cpu/vulnerabilities/spec_store_bypass
 		/sys/devices/system/cpu/vulnerabilities/l1tf
 		/sys/devices/system/cpu/vulnerabilities/mds
+		/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
+		/sys/devices/system/cpu/vulnerabilities/itlb_multihit
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities
diff --git a/Documentation/hw-vuln/tsx_async_abort.rst b/Documentation/hw-v=
uln/tsx_async_abort.rst
new file mode 100644
index 000000000000..38beda735f39
--- /dev/null
+++ b/Documentation/hw-vuln/tsx_async_abort.rst
@@ -0,0 +1,268 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+TAA - TSX Asynchronous Abort
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+TAA is a hardware vulnerability that allows unprivileged speculative acces=
s to
+data which is available in various CPU internal buffers by using asynchron=
ous
+aborts within an Intel TSX transactional region.
+
+Affected processors
+-------------------
+
+This vulnerability only affects Intel processors that support Intel
+Transactional Synchronization Extensions (TSX) when the TAA_NO bit (bit 8)
+is 0 in the IA32_ARCH_CAPABILITIES MSR.  On processors where the MDS_NO bit
+(bit 5) is 0 in the IA32_ARCH_CAPABILITIES MSR, the existing MDS mitigatio=
ns
+also mitigate against TAA.
+
+Whether a processor is affected or not can be read out from the TAA
+vulnerability file in sysfs. See :ref:`tsx_async_abort_sys_info`.
+
+Related CVEs
+------------
+
+The following CVE entry is related to this TAA issue:
+
+   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+   CVE-2019-11135  TAA    TSX Asynchronous Abort (TAA) condition on some
+                          microprocessors utilizing speculative execution =
may
+                          allow an authenticated user to potentially enable
+                          information disclosure via a side channel with
+                          local access.
+   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Problem
+-------
+
+When performing store, load or L1 refill operations, processors write
+data into temporary microarchitectural structures (buffers). The data in
+those buffers can be forwarded to load operations as an optimization.
+
+Intel TSX is an extension to the x86 instruction set architecture that adds
+hardware transactional memory support to improve performance of multi-thre=
aded
+software. TSX lets the processor expose and exploit concurrency hidden in =
an
+application due to dynamically avoiding unnecessary synchronization.
+
+TSX supports atomic memory transactions that are either committed (success=
) or
+aborted. During an abort, operations that happened within the transactiona=
l region
+are rolled back. An asynchronous abort takes place, among other options, w=
hen a
+different thread accesses a cache line that is also used within the transa=
ctional
+region when that access might lead to a data race.
+
+Immediately after an uncompleted asynchronous abort, certain speculatively
+executed loads may read data from those internal buffers and pass it to de=
pendent
+operations. This can be then used to infer the value via a cache side chan=
nel
+attack.
+
+Because the buffers are potentially shared between Hyper-Threads cross
+Hyper-Thread attacks are possible.
+
+The victim of a malicious actor does not need to make use of TSX. Only the
+attacker needs to begin a TSX transaction and raise an asynchronous abort
+which in turn potenitally leaks data stored in the buffers.
+
+More detailed technical information is available in the TAA specific x86
+architecture section: :ref:`Documentation/x86/tsx_async_abort.rst <tsx_asy=
nc_abort>`.
+
+
+Attack scenarios
+----------------
+
+Attacks against the TAA vulnerability can be implemented from unprivileged
+applications running on hosts or guests.
+
+As for MDS, the attacker has no control over the memory addresses that can
+be leaked. Only the victim is responsible for bringing data to the CPU. As
+a result, the malicious actor has to sample as much data as possible and
+then postprocess it to try to infer any useful information from it.
+
+A potential attacker only has read access to the data. Also, there is no d=
irect
+privilege escalation by using this technique.
+
+
+.. _tsx_async_abort_sys_info:
+
+TAA system information
+-----------------------
+
+The Linux kernel provides a sysfs interface to enumerate the current TAA s=
tatus
+of mitigated systems. The relevant sysfs file is:
+
+/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
+
+The possible values in this file are:
+
+.. list-table::
+
+   * - 'Vulnerable'
+     - The CPU is affected by this vulnerability and the microcode and ker=
nel mitigation are not applied.
+   * - 'Vulnerable: Clear CPU buffers attempted, no microcode'
+     - The system tries to clear the buffers but the microcode might not s=
upport the operation.
+   * - 'Mitigation: Clear CPU buffers'
+     - The microcode has been updated to clear the buffers. TSX is still e=
nabled.
+   * - 'Mitigation: TSX disabled'
+     - TSX is disabled.
+   * - 'Not affected'
+     - The CPU is not affected by this issue.
+
+.. _ucode_needed:
+
+Best effort mitigation mode
+^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+If the processor is vulnerable, but the availability of the microcode-based
+mitigation mechanism is not advertised via CPUID the kernel selects a best
+effort mitigation mode.  This mode invokes the mitigation instructions
+without a guarantee that they clear the CPU buffers.
+
+This is done to address virtualization scenarios where the host has the
+microcode update applied, but the hypervisor is not yet updated to expose =
the
+CPUID to the guest. If the host has updated microcode the protection takes
+effect; otherwise a few CPU cycles are wasted pointlessly.
+
+The state in the tsx_async_abort sysfs file reflects this situation
+accordingly.
+
+
+Mitigation mechanism
+--------------------
+
+The kernel detects the affected CPUs and the presence of the microcode whi=
ch is
+required. If a CPU is affected and the microcode is available, then the ke=
rnel
+enables the mitigation by default.
+
+
+The mitigation can be controlled at boot time via a kernel command line op=
tion.
+See :ref:`taa_mitigation_control_command_line`.
+
+.. _virt_mechanism:
+
+Virtualization mitigation
+^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Affected systems where the host has TAA microcode and TAA is mitigated by
+having disabled TSX previously, are not vulnerable regardless of the status
+of the VMs.
+
+In all other cases, if the host either does not have the TAA microcode or
+the kernel is not mitigated, the system might be vulnerable.
+
+
+.. _taa_mitigation_control_command_line:
+
+Mitigation control on the kernel command line
+---------------------------------------------
+
+The kernel command line allows to control the TAA mitigations at boot time=
 with
+the option "tsx_async_abort=3D". The valid arguments for this option are:
+
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+  off		This option disables the TAA mitigation on affected platforms.
+                If the system has TSX enabled (see next parameter) and the=
 CPU
+                is affected, the system is vulnerable.
+
+  full	        TAA mitigation is enabled. If TSX is enabled, on an affected
+                system it will clear CPU buffers on ring transitions. On
+                systems which are MDS-affected and deploy MDS mitigation,
+                TAA is also mitigated. Specifying this option on those
+                systems will have no effect.
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Not specifying this option is equivalent to "tsx_async_abort=3Dfull".
+
+The kernel command line also allows to control the TSX feature using the
+parameter "tsx=3D" on CPUs which support TSX control. MSR_IA32_TSX_CTRL is=
 used
+to control the TSX feature and the enumeration of the TSX feature bits (RTM
+and HLE) in CPUID.
+
+The valid options are:
+
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+  off		Disables TSX on the system.
+
+                Note that this option takes effect only on newer CPUs whic=
h are
+                not vulnerable to MDS, i.e., have MSR_IA32_ARCH_CAPABILITI=
ES.MDS_NO=3D1
+                and which get the new IA32_TSX_CTRL MSR through a microcode
+                update. This new MSR allows for the reliable deactivation =
of
+                the TSX functionality.
+
+  on		Enables TSX.
+
+                Although there are mitigations for all known security
+                vulnerabilities, TSX has been known to be an accelerator f=
or
+                several previous speculation-related CVEs, and so there ma=
y be
+                unknown security risks associated with leaving it enabled.
+
+  auto		Disables TSX if X86_BUG_TAA is present, otherwise enables TSX
+                on the system.
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Not specifying this option is equivalent to "tsx=3Doff".
+
+The following combinations of the "tsx_async_abort" and "tsx" are possible=
=2E For
+affected platforms tsx=3Dauto is equivalent to tsx=3Doff and the result wi=
ll be:
+
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+  tsx=3Don     tsx_async_abort=3Dfull         The system will use VERW to =
clear CPU
+                                          buffers. Cross-thread attacks ar=
e still
+					  possible on SMT machines.
+  tsx=3Don     tsx_async_abort=3Doff          The system is vulnerable.
+  tsx=3Doff    tsx_async_abort=3Dfull         TSX might be disabled if mic=
rocode
+                                          provides a TSX control MSR. If s=
o,
+					  system is not vulnerable.
+  tsx=3Doff    tsx_async_abort=3Doff          ditto
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+
+
+For unaffected platforms "tsx=3Don" and "tsx_async_abort=3Dfull" does not =
clear CPU
+buffers.  For platforms without TSX control (MSR_IA32_ARCH_CAPABILITIES.MD=
S_NO=3D0)
+"tsx" command line argument has no effect.
+
+For the affected platforms below table indicates the mitigation status for=
 the
+combinations of CPUID bit MD_CLEAR and IA32_ARCH_CAPABILITIES MSR bits MDS=
_NO
+and TSX_CTRL_MSR.
+
+  =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+  MDS_NO   MD_CLEAR   TSX_CTRL_MSR   Status
+  =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    0          0            0        Vulnerable (needs microcode)
+    0          1            0        MDS and TAA mitigated via VERW
+    1          1            0        MDS fixed, TAA vulnerable if TSX enab=
led
+                                     because MD_CLEAR has no meaning and
+                                     VERW is not guaranteed to clear buffe=
rs
+    1          X            1        MDS fixed, TAA can be mitigated by
+                                     VERW or TSX_CTRL_MSR
+  =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Mitigation selection guide
+--------------------------
+
+1. Trusted userspace and guests
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+If all user space applications are from a trusted source and do not execute
+untrusted code which is supplied externally, then the mitigation can be
+disabled. The same applies to virtualized environments with trusted guests.
+
+
+2. Untrusted userspace and guests
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+If there are untrusted applications or guests on the system, enabling TSX
+might allow a malicious actor to leak data from the host or from other
+processes running on the same physical core.
+
+If the microcode is available and the TSX is disabled on the host, attacks
+are prevented in a virtualized environment as well, even if the VMs do not
+explicitly enable the mitigation.
+
+
+.. _taa_default_mitigations:
+
+Default mitigations
+-------------------
+
+The kernel's default action for vulnerable processors is:
+
+  - Deploy TSX disable mitigation (tsx_async_abort=3Dfull tsx=3Doff).
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-par=
ameters.txt
index 2fe0b85b693d..1c936be7e7f8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1922,6 +1922,7 @@ bytes respectively. Such letter suffixes can also be =
entirely omitted.
 					       spectre_v2_user=3Doff [X86]
 					       spec_store_bypass_disable=3Doff [X86]
 					       mds=3Doff [X86]
+					       tsx_async_abort=3Doff [X86]
=20
 			auto (default)
 				Mitigate all CPU vulnerabilities, but leave SMT
@@ -3581,6 +3582,67 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
 			platforms where RDTSC is slow and this accounting
 			can add overhead.
=20
+	tsx=3D		[X86] Control Transactional Synchronization
+			Extensions (TSX) feature in Intel processors that
+			support TSX control.
+
+			This parameter controls the TSX feature. The options are:
+
+			on	- Enable TSX on the system. Although there are
+				mitigations for all known security vulnerabilities,
+				TSX has been known to be an accelerator for
+				several previous speculation-related CVEs, and
+				so there may be unknown	security risks associated
+				with leaving it enabled.
+
+			off	- Disable TSX on the system. (Note that this
+				option takes effect only on newer CPUs which are
+				not vulnerable to MDS, i.e., have
+				MSR_IA32_ARCH_CAPABILITIES.MDS_NO=3D1 and which get
+				the new IA32_TSX_CTRL MSR through a microcode
+				update. This new MSR allows for the reliable
+				deactivation of the TSX functionality.)
+
+			auto	- Disable TSX if X86_BUG_TAA is present,
+				  otherwise enable TSX on the system.
+
+			Not specifying this option is equivalent to tsx=3Doff.
+
+			See Documentation/hw-vuln/tsx_async_abort.rst
+			for more details.
+
+	tsx_async_abort=3D [X86,INTEL] Control mitigation for the TSX Async
+			Abort (TAA) vulnerability.
+
+			Similar to Micro-architectural Data Sampling (MDS)
+			certain CPUs that support Transactional
+			Synchronization Extensions (TSX) are vulnerable to an
+			exploit against CPU internal buffers which can forward
+			information to a disclosure gadget under certain
+			conditions.
+
+			In vulnerable processors, the speculatively forwarded
+			data can be used in a cache side channel attack, to
+			access data to which the attacker does not have direct
+			access.
+
+			This parameter controls the TAA mitigation.  The
+			options are:
+
+			full       - Enable TAA mitigation on vulnerable CPUs
+				     if TSX is enabled.
+
+			off        - Unconditionally disable TAA mitigation
+
+			Not specifying this option is equivalent to
+			tsx_async_abort=3Dfull.  On CPUs which are MDS affected
+			and deploy MDS mitigation, TAA mitigation is not
+			required and doesn't provide any additional
+			mitigation.
+
+			For details see:
+			Documentation/hw-vuln/tsx_async_abort.rst
+
 	turbografx.map[2|3]=3D	[HW,JOY]
 			TurboGraFX parallel port interface
 			Format:
diff --git a/Documentation/x86/tsx_async_abort.rst b/Documentation/x86/tsx_=
async_abort.rst
new file mode 100644
index 000000000000..4a4336a89372
--- /dev/null
+++ b/Documentation/x86/tsx_async_abort.rst
@@ -0,0 +1,117 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+TSX Async Abort (TAA) mitigation
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
+
+.. _tsx_async_abort:
+
+Overview
+--------
+
+TSX Async Abort (TAA) is a side channel attack on internal buffers in some
+Intel processors similar to Microachitectural Data Sampling (MDS).  In this
+case certain loads may speculatively pass invalid data to dependent operat=
ions
+when an asynchronous abort condition is pending in a Transactional
+Synchronization Extensions (TSX) transaction.  This includes loads with no
+fault or assist condition. Such loads may speculatively expose stale data =
=66rom
+the same uarch data structures as in MDS, with same scope of exposure i.e.
+same-thread and cross-thread. This issue affects all current processors th=
at
+support TSX.
+
+Mitigation strategy
+-------------------
+
+a) TSX disable - one of the mitigations is to disable TSX. A new MSR
+IA32_TSX_CTRL will be available in future and current processors after
+microcode update which can be used to disable TSX. In addition, it
+controls the enumeration of the TSX feature bits (RTM and HLE) in CPUID.
+
+b) Clear CPU buffers - similar to MDS, clearing the CPU buffers mitigates =
this
+vulnerability. More details on this approach can be found in
+:ref:`Documentation/hw-vuln/mds.rst <mds>`.
+
+Kernel internal mitigation modes
+--------------------------------
+
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ off              Mitigation is disabled. Either the CPU is not affected or
+                  tsx_async_abort=3Doff is supplied on the kernel command =
line.
+
+ tsx disabled     Mitigation is enabled. TSX feature is disabled by defaul=
t at
+                  bootup on processors that support TSX control.
+
+ verw             Mitigation is enabled. CPU is affected and MD_CLEAR is
+                  advertised in CPUID.
+
+ ucode needed     Mitigation is enabled. CPU is affected and MD_CLEAR is n=
ot
+                  advertised in CPUID. That is mainly for virtualization
+                  scenarios where the host has the updated microcode but t=
he
+                  hypervisor does not expose MD_CLEAR in CPUID. It's a best
+                  effort approach without guarantee.
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+If the CPU is affected and the "tsx_async_abort" kernel command line param=
eter is
+not provided then the kernel selects an appropriate mitigation depending o=
n the
+status of RTM and MD_CLEAR CPUID bits.
+
+Below tables indicate the impact of tsx=3Don|off|auto cmdline options on s=
tate of
+TAA mitigation, VERW behavior and TSX feature for various combinations of
+MSR_IA32_ARCH_CAPABILITIES bits.
+
+1. "tsx=3Doff"
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+MSR_IA32_ARCH_CAPABILITIES bits     Result with cmdline tsx=3Doff
+----------------------------------  --------------------------------------=
-----------------------------------
+TAA_NO     MDS_NO     TSX_CTRL_MSR  TSX state     VERW can clear  TAA miti=
gation       TAA mitigation
+                                    after bootup  CPU buffers     tsx_asyn=
c_abort=3Doff  tsx_async_abort=3Dfull
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+    0          0           0         HW default         Yes           Same=
 as MDS           Same as MDS
+    0          0           1        Invalid case   Invalid case       Inva=
lid case          Invalid case
+    0          1           0         HW default         No         Need uc=
ode update     Need ucode update
+    0          1           1          Disabled          Yes           TSX =
disabled          TSX disabled
+    1          X           1          Disabled           X             Non=
e needed           None needed
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+2. "tsx=3Don"
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+MSR_IA32_ARCH_CAPABILITIES bits     Result with cmdline tsx=3Don
+----------------------------------  --------------------------------------=
-----------------------------------
+TAA_NO     MDS_NO     TSX_CTRL_MSR  TSX state     VERW can clear  TAA miti=
gation       TAA mitigation
+                                    after bootup  CPU buffers     tsx_asyn=
c_abort=3Doff  tsx_async_abort=3Dfull
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+    0          0           0         HW default        Yes            Same=
 as MDS          Same as MDS
+    0          0           1        Invalid case   Invalid case       Inva=
lid case         Invalid case
+    0          1           0         HW default        No          Need uc=
ode update     Need ucode update
+    0          1           1          Enabled          Yes               N=
one              Same as MDS
+    1          X           1          Enabled          X              None=
 needed          None needed
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+3. "tsx=3Dauto"
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+MSR_IA32_ARCH_CAPABILITIES bits     Result with cmdline tsx=3Dauto
+----------------------------------  --------------------------------------=
-----------------------------------
+TAA_NO     MDS_NO     TSX_CTRL_MSR  TSX state     VERW can clear  TAA miti=
gation       TAA mitigation
+                                    after bootup  CPU buffers     tsx_asyn=
c_abort=3Doff  tsx_async_abort=3Dfull
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+    0          0           0         HW default    Yes                Same=
 as MDS           Same as MDS
+    0          0           1        Invalid case  Invalid case        Inva=
lid case          Invalid case
+    0          1           0         HW default    No              Need uc=
ode update     Need ucode update
+    0          1           1          Disabled      Yes               TSX =
disabled          TSX disabled
+    1          X           1          Enabled       X                 None=
 needed           None needed
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+In the tables, TSX_CTRL_MSR is a new bit in MSR_IA32_ARCH_CAPABILITIES that
+indicates whether MSR_IA32_TSX_CTRL is supported.
+
+There are two control bits in IA32_TSX_CTRL MSR:
+
+      Bit 0: When set it disables the Restricted Transactional Memory (RTM)
+             sub-feature of TSX (will force all transactions to abort on t=
he
+             XBEGIN instruction).
+
+      Bit 1: When set it disables the enumeration of the RTM and HLE featu=
re
+             (i.e. it will make CPUID(EAX=3D7).EBX{bit4} and
+             CPUID(EAX=3D7).EBX{bit11} read as 0).
diff --git a/Makefile b/Makefile
index 44d0302480fd..db0000d44ed7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 76
+SUBLEVEL =3D 77
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9ae6b38b8361..569ade98983b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1531,6 +1531,51 @@ config X86_SMAP
=20
 	  If unsure, say Y.
=20
+choice
+	prompt "TSX enable mode"
+	depends on CPU_SUP_INTEL
+	default X86_INTEL_TSX_MODE_OFF
+	help
+	  Intel's TSX (Transactional Synchronization Extensions) feature
+	  allows to optimize locking protocols through lock elision which
+	  can lead to a noticeable performance boost.
+
+	  On the other hand it has been shown that TSX can be exploited
+	  to form side channel attacks (e.g. TAA) and chances are there
+	  will be more of those attacks discovered in the future.
+
+	  Therefore TSX is not enabled by default (aka tsx=3Doff). An admin
+	  might override this decision by tsx=3Don the command line parameter.
+	  Even with TSX enabled, the kernel will attempt to enable the best
+	  possible TAA mitigation setting depending on the microcode available
+	  for the particular machine.
+
+	  This option allows to set the default tsx mode between tsx=3Don, =3Doff
+	  and =3Dauto. See Documentation/kernel-parameters.txt for more
+	  details.
+
+	  Say off if not sure, auto if TSX is in use but it should be used on safe
+	  platforms or on if TSX is in use and the security aspect of tsx is not
+	  relevant.
+
+config X86_INTEL_TSX_MODE_OFF
+	bool "off"
+	help
+	  TSX is disabled if possible - equals to tsx=3Doff command line paramete=
r.
+
+config X86_INTEL_TSX_MODE_ON
+	bool "on"
+	help
+	  TSX is always enabled on TSX capable HW - equals the tsx=3Don command
+	  line parameter.
+
+config X86_INTEL_TSX_MODE_AUTO
+	bool "auto"
+	help
+	  TSX is enabled on TSX capable HW that is believed to be safe against
+	  side channel attacks- equals the tsx=3Dauto command line parameter.
+endchoice
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpuf=
eatures.h
index ba48ab887acf..4ad4e3bfee4e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -279,5 +279,7 @@
 #define X86_BUG_MDS		X86_BUG(10) /* CPU is affected by Microarchitectural =
data sampling */
 #define X86_BUG_MSBDS_ONLY	X86_BUG(11) /* CPU is only affected by the  MSD=
BS variant of BUG_MDS */
 #define X86_BUG_SWAPGS		X86_BUG(12) /* CPU is affected by speculation thro=
ugh SWAPGS */
+#define X86_BUG_TAA		X86_BUG(13) /* CPU is affected by TSX Async Abort(TAA=
) */
+#define X86_BUG_ITLB_MULTIHIT	X86_BUG(14) /* CPU may incur MCE during cert=
ain page attribute changes */
=20
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 92a9ba2595b3..0249450e2e50 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1062,6 +1062,7 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu);
=20
+u64 kvm_get_arch_capabilities(void);
 void kvm_define_shared_msr(unsigned index, u32 msr);
 int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
=20
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/no=
spec-branch.h
index 1d0c5e2340f6..9c6d043e7e30 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -268,7 +268,7 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
 #include <asm/segment.h>
=20
 /**
- * mds_clear_cpu_buffers - Mitigation for MDS vulnerability
+ * mds_clear_cpu_buffers - Mitigation for MDS and TAA vulnerability
  *
  * This uses the otherwise unused and obsolete VERW instruction in
  * combination with microcode which triggers a CPU buffer flush when the
@@ -291,7 +291,7 @@ static inline void mds_clear_cpu_buffers(void)
 }
=20
 /**
- * mds_user_clear_cpu_buffers - Mitigation for MDS vulnerability
+ * mds_user_clear_cpu_buffers - Mitigation for MDS and TAA vulnerability
  *
  * Clear CPU buffers if the corresponding static key is enabled
  */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proces=
sor.h
index bca59eb2f290..9ea2413fc16d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -960,4 +960,11 @@ enum mds_mitigations {
 	MDS_MITIGATION_VMWERV,
 };
=20
+enum taa_mitigations {
+	TAA_MITIGATION_OFF,
+	TAA_MITIGATION_UCODE_NEEDED,
+	TAA_MITIGATION_VERW,
+	TAA_MITIGATION_TSX_DISABLED,
+};
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/=
asm/msr-index.h
index 7e3a682ba083..e376e780e380 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -70,10 +70,26 @@
 						    * Microarchitectural Data
 						    * Sampling (MDS) vulnerabilities.
 						    */
+#define ARCH_CAP_PSCHANGE_MC_NO		(1UL << 6) /*
+						    * The processor is not susceptible to a
+						    * machine check error due to modifying the
+						    * code page size along with either the
+						    * physical address or cache type
+						    * without TLB invalidation.
+						    */
+#define ARCH_CAP_TSX_CTRL_MSR		(1UL << 7) /* MSR for TSX control is availa=
ble. */
+#define ARCH_CAP_TAA_NO			(1UL << 8) /*
+						   * Not susceptible to
+						   * TSX Async Abort (TAA) vulnerabilities.
+						   */
=20
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
=20
+#define MSR_IA32_TSX_CTRL		0x00000122
+#define TSX_CTRL_RTM_DISABLE		(1UL << 0) /* Disable RTM feature */
+#define TSX_CTRL_CPUID_CLEAR		(1UL << 1) /* Disable TSX enumeration */
+
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
 #define MSR_IA32_SYSENTER_EIP		0x00000176
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index baf9e03d6edf..c3aaa4a06120 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -18,7 +18,7 @@ obj-y			+=3D rdrand.o
 obj-y			+=3D match.o
 obj-y			+=3D bugs.o
=20
-obj-$(CONFIG_CPU_SUP_INTEL)		+=3D intel.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+=3D intel.o tsx.o
 obj-$(CONFIG_CPU_SUP_AMD)		+=3D amd.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+=3D cyrix.o
 obj-$(CONFIG_CPU_SUP_CENTAUR)		+=3D centaur.o
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0340dfdbce7d..884ce92cfc0f 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -30,11 +30,14 @@
 #include <asm/intel-family.h>
 #include <asm/e820.h>
=20
+#include "cpu.h"
+
 static void __init spectre_v1_select_mitigation(void);
 static void __init spectre_v2_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
+static void __init taa_select_mitigation(void);
=20
 /* The base value of the SPEC_CTRL MSR that always has to be preserved. */
 u64 x86_spec_ctrl_base;
@@ -155,6 +158,7 @@ void __init check_bugs(void)
 	ssb_select_mitigation();
 	l1tf_select_mitigation();
 	mds_select_mitigation();
+	taa_select_mitigation();
=20
 	arch_smt_update();
=20
@@ -312,6 +316,93 @@ static int __init mds_cmdline(char *str)
 }
 early_param("mds", mds_cmdline);
=20
+#undef pr_fmt
+#define pr_fmt(fmt)	"TAA: " fmt
+
+/* Default mitigation for TAA-affected CPUs */
+static enum taa_mitigations taa_mitigation =3D TAA_MITIGATION_VERW;
+
+static const char * const taa_strings[] =3D {
+	[TAA_MITIGATION_OFF]		=3D "Vulnerable",
+	[TAA_MITIGATION_UCODE_NEEDED]	=3D "Vulnerable: Clear CPU buffers attempte=
d, no microcode",
+	[TAA_MITIGATION_VERW]		=3D "Mitigation: Clear CPU buffers",
+	[TAA_MITIGATION_TSX_DISABLED]	=3D "Mitigation: TSX disabled",
+};
+
+static void __init taa_select_mitigation(void)
+{
+	u64 ia32_cap;
+
+	if (!boot_cpu_has_bug(X86_BUG_TAA)) {
+		taa_mitigation =3D TAA_MITIGATION_OFF;
+		return;
+	}
+
+	/* TSX previously disabled by tsx=3Doff */
+	if (!boot_cpu_has(X86_FEATURE_RTM)) {
+		taa_mitigation =3D TAA_MITIGATION_TSX_DISABLED;
+		goto out;
+	}
+
+	if (cpu_mitigations_off()) {
+		taa_mitigation =3D TAA_MITIGATION_OFF;
+		return;
+	}
+
+	/* TAA mitigation is turned off on the cmdline (tsx_async_abort=3Doff) */
+	if (taa_mitigation =3D=3D TAA_MITIGATION_OFF)
+		goto out;
+
+	if (boot_cpu_has(X86_FEATURE_MD_CLEAR))
+		taa_mitigation =3D TAA_MITIGATION_VERW;
+	else
+		taa_mitigation =3D TAA_MITIGATION_UCODE_NEEDED;
+
+	/*
+	 * VERW doesn't clear the CPU buffers when MD_CLEAR=3D1 and MDS_NO=3D1.
+	 * A microcode update fixes this behavior to clear CPU buffers. It also
+	 * adds support for MSR_IA32_TSX_CTRL which is enumerated by the
+	 * ARCH_CAP_TSX_CTRL_MSR bit.
+	 *
+	 * On MDS_NO=3D1 CPUs if ARCH_CAP_TSX_CTRL_MSR is not set, microcode
+	 * update is required.
+	 */
+	ia32_cap =3D x86_read_arch_cap_msr();
+	if ( (ia32_cap & ARCH_CAP_MDS_NO) &&
+	    !(ia32_cap & ARCH_CAP_TSX_CTRL_MSR))
+		taa_mitigation =3D TAA_MITIGATION_UCODE_NEEDED;
+
+	/*
+	 * TSX is enabled, select alternate mitigation for TAA which is
+	 * the same as MDS. Enable MDS static branch to clear CPU buffers.
+	 *
+	 * For guests that can't determine whether the correct microcode is
+	 * present on host, enable the mitigation for UCODE_NEEDED as well.
+	 */
+	static_branch_enable(&mds_user_clear);
+
+out:
+	pr_info("%s\n", taa_strings[taa_mitigation]);
+}
+
+static int __init tsx_async_abort_parse_cmdline(char *str)
+{
+	if (!boot_cpu_has_bug(X86_BUG_TAA))
+		return 0;
+
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "off")) {
+		taa_mitigation =3D TAA_MITIGATION_OFF;
+	} else if (!strcmp(str, "full")) {
+		taa_mitigation =3D TAA_MITIGATION_VERW;
+	}
+
+	return 0;
+}
+early_param("tsx_async_abort", tsx_async_abort_parse_cmdline);
+
 #undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V1 : " fmt
=20
@@ -824,13 +915,10 @@ static void update_mds_branch_idle(void)
 }
=20
 #define MDS_MSG_SMT "MDS CPU bug present and SMT on, data leak possible. S=
ee https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for =
more details.\n"
+#define TAA_MSG_SMT "TAA CPU bug present and SMT on, data leak possible. S=
ee https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/tsx_async_abo=
rt.html for more details.\n"
=20
 void arch_smt_update(void)
 {
-	/* Enhanced IBRS implies STIBP. No update required. */
-	if (spectre_v2_enabled =3D=3D SPECTRE_V2_IBRS_ENHANCED)
-		return;
-
 	mutex_lock(&spec_ctrl_mutex);
=20
 	switch (spectre_v2_user) {
@@ -856,6 +944,17 @@ void arch_smt_update(void)
 		break;
 	}
=20
+	switch (taa_mitigation) {
+	case TAA_MITIGATION_VERW:
+	case TAA_MITIGATION_UCODE_NEEDED:
+		if (sched_smt_active())
+			pr_warn_once(TAA_MSG_SMT);
+		break;
+	case TAA_MITIGATION_TSX_DISABLED:
+	case TAA_MITIGATION_OFF:
+		break;
+	}
+
 	mutex_unlock(&spec_ctrl_mutex);
 }
=20
@@ -1243,6 +1342,11 @@ static void __init l1tf_select_mitigation(void)
=20
 #ifdef CONFIG_SYSFS
=20
+static ssize_t itlb_multihit_show_state(char *buf)
+{
+	return sprintf(buf, "Processor vulnerable\n");
+}
+
 static ssize_t mds_show_state(char *buf)
 {
 #ifdef CONFIG_HYPERVISOR_GUEST
@@ -1262,6 +1366,21 @@ static ssize_t mds_show_state(char *buf)
 		       sched_smt_active() ? "vulnerable" : "disabled");
 }
=20
+static ssize_t tsx_async_abort_show_state(char *buf)
+{
+	if ((taa_mitigation =3D=3D TAA_MITIGATION_TSX_DISABLED) ||
+	    (taa_mitigation =3D=3D TAA_MITIGATION_OFF))
+		return sprintf(buf, "%s\n", taa_strings[taa_mitigation]);
+
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
+		return sprintf(buf, "%s; SMT Host state unknown\n",
+			       taa_strings[taa_mitigation]);
+	}
+
+	return sprintf(buf, "%s; SMT %s\n", taa_strings[taa_mitigation],
+		       sched_smt_active() ? "vulnerable" : "disabled");
+}
+
 static char *stibp_state(void)
 {
 	if (spectre_v2_enabled =3D=3D SPECTRE_V2_IBRS_ENHANCED)
@@ -1327,6 +1446,12 @@ static ssize_t cpu_show_common(struct device *dev, s=
truct device_attribute *attr
 	case X86_BUG_MDS:
 		return mds_show_state(buf);
=20
+	case X86_BUG_TAA:
+		return tsx_async_abort_show_state(buf);
+
+	case X86_BUG_ITLB_MULTIHIT:
+		return itlb_multihit_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1363,4 +1488,14 @@ ssize_t cpu_show_mds(struct device *dev, struct devi=
ce_attribute *attr, char *bu
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_MDS);
 }
+
+ssize_t cpu_show_tsx_async_abort(struct device *dev, struct device_attribu=
te *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_TAA);
+}
+
+ssize_t cpu_show_itlb_multihit(struct device *dev, struct device_attribute=
 *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_ITLB_MULTIHIT);
+}
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 337fcac8c8a0..e6d410f83bab 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -807,13 +807,14 @@ static void identify_cpu_without_cpuid(struct cpuinfo=
_x86 *c)
 #endif
 }
=20
-#define NO_SPECULATION	BIT(0)
-#define NO_MELTDOWN	BIT(1)
-#define NO_SSB		BIT(2)
-#define NO_L1TF		BIT(3)
-#define NO_MDS		BIT(4)
-#define MSBDS_ONLY	BIT(5)
-#define NO_SWAPGS	BIT(6)
+#define NO_SPECULATION		BIT(0)
+#define NO_MELTDOWN		BIT(1)
+#define NO_SSB			BIT(2)
+#define NO_L1TF			BIT(3)
+#define NO_MDS			BIT(4)
+#define MSBDS_ONLY		BIT(5)
+#define NO_SWAPGS		BIT(6)
+#define NO_ITLB_MULTIHIT	BIT(7)
=20
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -831,26 +832,26 @@ static const __initconst struct x86_cpu_id cpu_vuln_w=
hitelist[] =3D {
 	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
=20
 	/* Intel Family 6 */
-	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION),
-	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION),
-	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION),
-	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION),
-	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION),
-
-	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPG=
S),
-	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAP=
GS),
-	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+
+	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS =
| NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPG=
S | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAP=
GS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | N=
O_ITLB_MULTIHIT),
+	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | N=
O_ITLB_MULTIHIT),
+	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | N=
O_ITLB_MULTIHIT),
=20
 	VULNWL_INTEL(CORE_YONAH,		NO_SSB),
=20
-	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITL=
B_MULTIHIT),
=20
-	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTI=
HIT),
+	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MUL=
TIHIT),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_M=
ULTIHIT),
=20
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -861,13 +862,13 @@ static const __initconst struct x86_cpu_id cpu_vuln_w=
hitelist[] =3D {
 	 */
=20
 	/* AMD Family 0xf - 0x12 */
-	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
-	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
-	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
-	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
+	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO=
_ITLB_MULTIHIT),
+	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO=
_ITLB_MULTIHIT),
+	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO=
_ITLB_MULTIHIT),
+	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO=
_ITLB_MULTIHIT),
=20
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS),
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | N=
O_ITLB_MULTIHIT),
 	{}
 };
=20
@@ -878,19 +879,30 @@ static bool __init cpu_matches(unsigned long which)
 	return m && !!(m->driver_data & which);
 }
=20
-static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
+u64 x86_read_arch_cap_msr(void)
 {
 	u64 ia32_cap =3D 0;
=20
+	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
+		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, ia32_cap);
+
+	return ia32_cap;
+}
+
+static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
+{
+	u64 ia32_cap =3D x86_read_arch_cap_msr();
+
+	/* Set ITLB_MULTIHIT bug if cpu is not in the whitelist and not mitigated=
 */
+	if (!cpu_matches(NO_ITLB_MULTIHIT) && !(ia32_cap & ARCH_CAP_PSCHANGE_MC_N=
O))
+		setup_force_cpu_bug(X86_BUG_ITLB_MULTIHIT);
+
 	if (cpu_matches(NO_SPECULATION))
 		return;
=20
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
=20
-	if (cpu_has(c, X86_FEATURE_ARCH_CAPABILITIES))
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, ia32_cap);
-
 	if (!cpu_matches(NO_SSB) && !(ia32_cap & ARCH_CAP_SSB_NO) &&
 	   !cpu_has(c, X86_FEATURE_AMD_SSB_NO))
 		setup_force_cpu_bug(X86_BUG_SPEC_STORE_BYPASS);
@@ -907,6 +919,21 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86=
 *c)
 	if (!cpu_matches(NO_SWAPGS))
 		setup_force_cpu_bug(X86_BUG_SWAPGS);
=20
+	/*
+	 * When the CPU is not mitigated for TAA (TAA_NO=3D0) set TAA bug when:
+	 *	- TSX is supported or
+	 *	- TSX_CTRL is present
+	 *
+	 * TSX_CTRL check is needed for cases when TSX could be disabled before
+	 * the kernel boot e.g. kexec.
+	 * TSX_CTRL check alone is not sufficient for cases when the microcode
+	 * update is not present or running as guest that don't get TSX_CTRL.
+	 */
+	if (!(ia32_cap & ARCH_CAP_TAA_NO) &&
+	    (cpu_has(c, X86_FEATURE_RTM) ||
+	     (ia32_cap & ARCH_CAP_TSX_CTRL_MSR)))
+		setup_force_cpu_bug(X86_BUG_TAA);
+
 	if (cpu_matches(NO_MELTDOWN))
 		return;
=20
@@ -1235,6 +1262,8 @@ void __init identify_boot_cpu(void)
 	vgetcpu_set_mode();
 #endif
 	cpu_detect_tlb(&boot_cpu_data);
+
+	tsx_init();
 }
=20
 void identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 4e70442527ff..6c81eb018ce9 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -43,9 +43,27 @@ struct _tlb_table {
 extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
=20
+#ifdef CONFIG_CPU_SUP_INTEL
+enum tsx_ctrl_states {
+	TSX_CTRL_ENABLE,
+	TSX_CTRL_DISABLE,
+	TSX_CTRL_NOT_SUPPORTED,
+};
+
+extern enum tsx_ctrl_states tsx_ctrl_state;
+
+extern void __init tsx_init(void);
+extern void tsx_enable(void);
+extern void tsx_disable(void);
+#else
+static inline void tsx_init(void) { }
+#endif /* CONFIG_CPU_SUP_INTEL */
+
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
 =20
 extern void x86_spec_ctrl_setup_ap(void);
=20
+extern u64 x86_read_arch_cap_msr(void);
+
 #endif /* ARCH_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 759923b7a0bd..224957084d38 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -566,6 +566,11 @@ static void init_intel(struct cpuinfo_x86 *c)
 			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
 		}
 	}
+
+	if (tsx_ctrl_state =3D=3D TSX_CTRL_ENABLE)
+		tsx_enable();
+	if (tsx_ctrl_state =3D=3D TSX_CTRL_DISABLE)
+		tsx_disable();
 }
=20
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
new file mode 100644
index 000000000000..c2a9dd816c5c
--- /dev/null
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Intel Transactional Synchronization Extensions (TSX) control.
+ *
+ * Copyright (C) 2019 Intel Corporation
+ *
+ * Author:
+ *	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
+ */
+
+#include <linux/cpufeature.h>
+
+#include <asm/cmdline.h>
+
+#include "cpu.h"
+
+enum tsx_ctrl_states tsx_ctrl_state =3D TSX_CTRL_NOT_SUPPORTED;
+
+void tsx_disable(void)
+{
+	u64 tsx;
+
+	rdmsrl(MSR_IA32_TSX_CTRL, tsx);
+
+	/* Force all transactions to immediately abort */
+	tsx |=3D TSX_CTRL_RTM_DISABLE;
+
+	/*
+	 * Ensure TSX support is not enumerated in CPUID.
+	 * This is visible to userspace and will ensure they
+	 * do not waste resources trying TSX transactions that
+	 * will always abort.
+	 */
+	tsx |=3D TSX_CTRL_CPUID_CLEAR;
+
+	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
+}
+
+void tsx_enable(void)
+{
+	u64 tsx;
+
+	rdmsrl(MSR_IA32_TSX_CTRL, tsx);
+
+	/* Enable the RTM feature in the cpu */
+	tsx &=3D ~TSX_CTRL_RTM_DISABLE;
+
+	/*
+	 * Ensure TSX support is enumerated in CPUID.
+	 * This is visible to userspace and will ensure they
+	 * can enumerate and use the TSX feature.
+	 */
+	tsx &=3D ~TSX_CTRL_CPUID_CLEAR;
+
+	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
+}
+
+static bool __init tsx_ctrl_is_supported(void)
+{
+	u64 ia32_cap =3D x86_read_arch_cap_msr();
+
+	/*
+	 * TSX is controlled via MSR_IA32_TSX_CTRL.  However, support for this
+	 * MSR is enumerated by ARCH_CAP_TSX_MSR bit in MSR_IA32_ARCH_CAPABILITIE=
S.
+	 *
+	 * TSX control (aka MSR_IA32_TSX_CTRL) is only available after a
+	 * microcode update on CPUs that have their MSR_IA32_ARCH_CAPABILITIES
+	 * bit MDS_NO=3D1. CPUs with MDS_NO=3D0 are not planned to get
+	 * MSR_IA32_TSX_CTRL support even after a microcode update. Thus,
+	 * tsx=3D cmdline requests will do nothing on CPUs without
+	 * MSR_IA32_TSX_CTRL support.
+	 */
+	return !!(ia32_cap & ARCH_CAP_TSX_CTRL_MSR);
+}
+
+static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
+{
+	if (boot_cpu_has_bug(X86_BUG_TAA))
+		return TSX_CTRL_DISABLE;
+
+	return TSX_CTRL_ENABLE;
+}
+
+void __init tsx_init(void)
+{
+	char arg[5] =3D {};
+	int ret;
+
+	if (!tsx_ctrl_is_supported())
+		return;
+
+	ret =3D cmdline_find_option(boot_command_line, "tsx", arg, sizeof(arg));
+	if (ret >=3D 0) {
+		if (!strcmp(arg, "on")) {
+			tsx_ctrl_state =3D TSX_CTRL_ENABLE;
+		} else if (!strcmp(arg, "off")) {
+			tsx_ctrl_state =3D TSX_CTRL_DISABLE;
+		} else if (!strcmp(arg, "auto")) {
+			tsx_ctrl_state =3D x86_get_tsx_auto_mode();
+		} else {
+			tsx_ctrl_state =3D TSX_CTRL_DISABLE;
+			pr_err("tsx: invalid option, defaulting to off\n");
+		}
+	} else {
+		/* tsx=3D not provided */
+		if (IS_ENABLED(CONFIG_X86_INTEL_TSX_MODE_AUTO))
+			tsx_ctrl_state =3D x86_get_tsx_auto_mode();
+		else if (IS_ENABLED(CONFIG_X86_INTEL_TSX_MODE_OFF))
+			tsx_ctrl_state =3D TSX_CTRL_DISABLE;
+		else
+			tsx_ctrl_state =3D TSX_CTRL_ENABLE;
+	}
+
+	if (tsx_ctrl_state =3D=3D TSX_CTRL_DISABLE) {
+		tsx_disable();
+
+		/*
+		 * tsx_disable() will change the state of the
+		 * RTM CPUID bit.  Clear it here since it is now
+		 * expected to be not set.
+		 */
+		setup_clear_cpu_cap(X86_FEATURE_RTM);
+	} else if (tsx_ctrl_state =3D=3D TSX_CTRL_ENABLE) {
+
+		/*
+		 * HW defaults TSX to be enabled at bootup.
+		 * We may still need the TSX enable support
+		 * during init for special cases like
+		 * kexec after TSX is disabled.
+		 */
+		tsx_enable();
+
+		/*
+		 * tsx_enable() will change the state of the
+		 * RTM CPUID bit.  Force it here since it is now
+		 * expected to be set.
+		 */
+		setup_force_cpu_cap(X86_FEATURE_RTM);
+	}
+}
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6531ffcb174b..90ad3c2db24a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -395,6 +395,13 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entr=
y2 *entry, u32 function,
 			entry->ebx |=3D F(TSC_ADJUST);
 			entry->edx &=3D kvm_cpuid_7_0_edx_x86_features;
 			cpuid_mask(&entry->edx, 10);
+			if (boot_cpu_has(X86_FEATURE_IBPB) &&
+			    boot_cpu_has(X86_FEATURE_IBRS))
+				entry->edx |=3D F(SPEC_CTRL);
+			if (boot_cpu_has(X86_FEATURE_STIBP))
+				entry->edx |=3D F(INTEL_STIBP);
+			if (boot_cpu_has(X86_FEATURE_SSBD))
+				entry->edx |=3D F(SPEC_CTRL_SSBD);
 			/*
 			 * We emulate ARCH_CAPABILITIES in software even
 			 * if the host doesn't support it.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c0f1ea119d6..f9e374b696b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -911,6 +911,43 @@ static u32 emulated_msrs[] =3D {
=20
 static unsigned num_emulated_msrs;
=20
+u64 kvm_get_arch_capabilities(void)
+{
+	u64 data;
+
+	rdmsrl_safe(MSR_IA32_ARCH_CAPABILITIES, &data);
+
+	if (!boot_cpu_has_bug(X86_BUG_CPU_MELTDOWN))
+		data |=3D ARCH_CAP_RDCL_NO;
+	if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
+		data |=3D ARCH_CAP_SSB_NO;
+	if (!boot_cpu_has_bug(X86_BUG_MDS))
+		data |=3D ARCH_CAP_MDS_NO;
+
+	/*
+	 * On TAA affected systems, export MDS_NO=3D0 when:
+	 *	- TSX is enabled on the host, i.e. X86_FEATURE_RTM=3D1.
+	 *	- Updated microcode is present. This is detected by
+	 *	  the presence of ARCH_CAP_TSX_CTRL_MSR and ensures
+	 *	  that VERW clears CPU buffers.
+	 *
+	 * When MDS_NO=3D0 is exported, guests deploy clear CPU buffer
+	 * mitigation and don't complain:
+	 *
+	 *	"Vulnerable: Clear CPU buffers attempted, no microcode"
+	 *
+	 * If TSX is disabled on the system, guests are also mitigated against
+	 * TAA and clear CPU buffer mitigation is not required for guests.
+	 */
+	if (boot_cpu_has_bug(X86_BUG_TAA) && boot_cpu_has(X86_FEATURE_RTM) &&
+	    (data & ARCH_CAP_TSX_CTRL_MSR))
+		data &=3D ~ARCH_CAP_MDS_NO;
+
+	return data;
+}
+
+EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
+
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	if (efer & efer_reserved_bits)
@@ -6969,8 +7006,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	int r;
=20
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES,
-		       vcpu->arch.arch_capabilities);
+		vcpu->arch.arch_capabilities =3D kvm_get_arch_capabilities();
 	vcpu->arch.mtrr_state.have_fixed =3D 1;
 	r =3D vcpu_load(vcpu);
 	if (r)
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 2f22e8960d8a..9f7d6b1b1eb2 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -456,12 +456,27 @@ ssize_t __weak cpu_show_mds(struct device *dev,
 	return sprintf(buf, "Not affected\n");
 }
=20
+ssize_t __weak cpu_show_tsx_async_abort(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return sprintf(buf, "Not affected\n");
+}
+
+ssize_t __weak cpu_show_itlb_multihit(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
 static DEVICE_ATTR(spec_store_bypass, 0444, cpu_show_spec_store_bypass, NU=
LL);
 static DEVICE_ATTR(l1tf, 0444, cpu_show_l1tf, NULL);
 static DEVICE_ATTR(mds, 0444, cpu_show_mds, NULL);
+static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
+static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
=20
 static struct attribute *cpu_root_vulnerabilities_attrs[] =3D {
 	&dev_attr_meltdown.attr,
@@ -470,6 +485,8 @@ static struct attribute *cpu_root_vulnerabilities_attrs=
[] =3D {
 	&dev_attr_spec_store_bypass.attr,
 	&dev_attr_l1tf.attr,
 	&dev_attr_mds.attr,
+	&dev_attr_tsx_async_abort.attr,
+	&dev_attr_itlb_multihit.attr,
 	NULL
 };
=20
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_dr=
v.c
index 76964900f06d..38556f8f0442 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -604,6 +604,8 @@ static int i915_drm_thaw_early(struct drm_device *dev)
 	intel_uncore_sanitize(dev);
 	intel_power_domains_init_hw(dev_priv);
=20
+	i915_rc6_ctx_wa_resume(dev_priv);
+
 	return 0;
 }
=20
@@ -926,6 +928,8 @@ static int i915_pm_suspend_late(struct device *dev)
 	if (drm_dev->switch_power_state =3D=3D DRM_SWITCH_POWER_OFF)
 		return 0;
=20
+	i915_rc6_ctx_wa_suspend(to_i915(drm_dev));
+
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
=20
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_dr=
v.h
index 7d9ceaa9ab01..3421a5e85dba 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -910,6 +910,7 @@ struct intel_gen6_power_mgmt {
 	enum { LOW_POWER, BETWEEN, HIGH_POWER } power;
=20
 	bool enabled;
+	bool ctx_corrupted;
 	struct delayed_work delayed_resume_work;
=20
 	/*
@@ -1959,6 +1960,10 @@ struct drm_i915_cmd_table {
=20
 /* Early gen2 have a totally busted CS tlb and require pinned batches. */
 #define HAS_BROKEN_CS_TLB(dev)		(IS_I830(dev) || IS_845G(dev))
+
+#define NEEDS_RC6_CTX_CORRUPTION_WA(dev)	\
+	(IS_BROADWELL(dev) || INTEL_INFO(dev)->gen =3D=3D 9)
+
 /*
  * dp aux and gmbus irq on gen4 seems to be able to generate legacy interr=
upts
  * even when in MSI mode. This results in spurious interrupt warnings if t=
he
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_re=
g.h
index 0d8bae0ec208..b05d99acd363 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -136,6 +136,8 @@
 #define   ECOCHK_PPGTT_WT_HSW		(0x2<<3)
 #define   ECOCHK_PPGTT_WB_HSW		(0x3<<3)
=20
+#define GEN8_RC6_CTX_INFO		0x8504
+
 #define GAC_ECO_BITS			0x14090
 #define   ECOBITS_SNB_BIT		(1<<13)
 #define   ECOBITS_PPGTT_CACHE64B	(3<<8)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 6a5dbe6b1b01..612f35538245 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8787,6 +8787,10 @@ void intel_mark_busy(struct drm_device *dev)
 		return;
=20
 	intel_runtime_pm_get(dev_priv);
+
+	if (NEEDS_RC6_CTX_CORRUPTION_WA(dev))
+		gen6_gt_force_wake_get(dev_priv, FORCEWAKE_ALL);
+
 	i915_update_gfx_val(dev_priv);
 	dev_priv->mm.busy =3D true;
 }
@@ -8814,6 +8818,11 @@ void intel_mark_idle(struct drm_device *dev)
 	if (INTEL_INFO(dev)->gen >=3D 6)
 		gen6_rps_idle(dev->dev_private);
=20
+	if (NEEDS_RC6_CTX_CORRUPTION_WA(dev)) {
+		i915_rc6_ctx_wa_check(dev_priv);
+		gen6_gt_force_wake_put(dev_priv, FORCEWAKE_ALL);
+	}
+
 out:
 	intel_runtime_pm_put(dev_priv);
 }
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_=
drv.h
index 508e4d8ae68d..e676d2425382 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -965,6 +965,9 @@ void intel_enable_gt_powersave(struct drm_device *dev);
 void intel_disable_gt_powersave(struct drm_device *dev);
 void intel_reset_gt_powersave(struct drm_device *dev);
 void ironlake_teardown_rc6(struct drm_device *dev);
+bool i915_rc6_ctx_wa_check(struct drm_i915_private *i915);
+void i915_rc6_ctx_wa_suspend(struct drm_i915_private *i915);
+void i915_rc6_ctx_wa_resume(struct drm_i915_private *i915);
 void gen6_update_ring_freq(struct drm_device *dev);
 void gen6_rps_idle(struct drm_i915_private *dev_priv);
 void gen6_rps_boost(struct drm_i915_private *dev_priv);
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_p=
m.c
index e19c3201db30..7e5a900ef7cc 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3378,11 +3378,17 @@ static void gen6_disable_rps_interrupts(struct drm_=
device *dev)
 	I915_WRITE(GEN6_PMIIR, dev_priv->pm_rps_events);
 }
=20
-static void gen6_disable_rps(struct drm_device *dev)
+static void gen6_disable_rc6(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
=20
 	I915_WRITE(GEN6_RC_CONTROL, 0);
+}
+
+static void gen6_disable_rps(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv =3D dev->dev_private;
+
 	I915_WRITE(GEN6_RPNSWREQ, 1 << 31);
=20
 	if (IS_BROADWELL(dev))
@@ -3391,12 +3397,15 @@ static void gen6_disable_rps(struct drm_device *dev)
 		gen6_disable_rps_interrupts(dev);
 }
=20
-static void valleyview_disable_rps(struct drm_device *dev)
+static void valleyview_disable_rc6(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
=20
 	I915_WRITE(GEN6_RC_CONTROL, 0);
+}
=20
+static void valleyview_disable_rps(struct drm_device *dev)
+{
 	gen6_disable_rps_interrupts(dev);
 }
=20
@@ -3529,7 +3538,8 @@ static void gen8_enable_rps(struct drm_device *dev)
 	I915_WRITE(GEN6_RC6_THRESHOLD, 50000); /* 50/125ms per EI */
=20
 	/* 3: Enable RC6 */
-	if (intel_enable_rc6(dev) & INTEL_RC6_ENABLE)
+	if (!dev_priv->rps.ctx_corrupted &&
+	    intel_enable_rc6(dev) & INTEL_RC6_ENABLE)
 		rc6_mask =3D GEN6_RC_CTL_RC6_ENABLE;
 	intel_print_rc6_info(dev, rc6_mask);
 	I915_WRITE(GEN6_RC_CONTROL, GEN6_RC_CTL_HW_ENABLE |
@@ -4707,10 +4717,103 @@ static void intel_init_emon(struct drm_device *dev)
 	dev_priv->ips.corr =3D (lcfuse & LCFUSE_HIV_MASK);
 }
=20
+static bool i915_rc6_ctx_corrupted(struct drm_i915_private *dev_priv)
+{
+	return !I915_READ(GEN8_RC6_CTX_INFO);
+}
+
+static void i915_rc6_ctx_wa_init(struct drm_i915_private *i915)
+{
+	if (!NEEDS_RC6_CTX_CORRUPTION_WA(i915->dev))
+		return;
+
+	if (i915_rc6_ctx_corrupted(i915)) {
+		DRM_INFO("RC6 context corrupted, disabling runtime power management\n");
+		i915->rps.ctx_corrupted =3D true;
+		intel_runtime_pm_get(i915);
+	}
+}
+
+static void i915_rc6_ctx_wa_cleanup(struct drm_i915_private *i915)
+{
+	if (i915->rps.ctx_corrupted) {
+		intel_runtime_pm_put(i915);
+		i915->rps.ctx_corrupted =3D false;
+	}
+}
+
+/**
+ * i915_rc6_ctx_wa_suspend - system suspend sequence for the RC6 CTX WA
+ * @i915: i915 device
+ *
+ * Perform any steps needed to clean up the RC6 CTX WA before system suspe=
nd.
+ */
+void i915_rc6_ctx_wa_suspend(struct drm_i915_private *i915)
+{
+	if (i915->rps.ctx_corrupted)
+		intel_runtime_pm_put(i915);
+}
+
+/**
+ * i915_rc6_ctx_wa_resume - system resume sequence for the RC6 CTX WA
+ * @i915: i915 device
+ *
+ * Perform any steps needed to re-init the RC6 CTX WA after system resume.
+ */
+void i915_rc6_ctx_wa_resume(struct drm_i915_private *i915)
+{
+	if (!i915->rps.ctx_corrupted)
+		return;
+
+	if (i915_rc6_ctx_corrupted(i915)) {
+		intel_runtime_pm_get(i915);
+		return;
+	}
+
+	DRM_INFO("RC6 context restored, re-enabling runtime power management\n");
+	i915->rps.ctx_corrupted =3D false;
+}
+
+static void intel_disable_rc6(struct drm_device *dev);
+
+/**
+ * i915_rc6_ctx_wa_check - check for a new RC6 CTX corruption
+ * @i915: i915 device
+ *
+ * Check if an RC6 CTX corruption has happened since the last check and if=
 so
+ * disable RC6 and runtime power management.
+ *
+ * Return false if no context corruption has happened since the last call =
of
+ * this function, true otherwise.
+*/
+bool i915_rc6_ctx_wa_check(struct drm_i915_private *i915)
+{
+	if (!NEEDS_RC6_CTX_CORRUPTION_WA(i915->dev))
+		return false;
+
+	if (i915->rps.ctx_corrupted)
+		return false;
+
+	if (!i915_rc6_ctx_corrupted(i915))
+		return false;
+
+	printk(KERN_NOTICE "[" DRM_NAME "] "
+	       "RC6 context corruption, disabling runtime power management\n");
+
+	intel_disable_rc6(i915->dev);
+	i915->rps.ctx_corrupted =3D true;
+	intel_runtime_pm_get_noresume(i915);
+
+	return true;
+}
+
+
 void intel_init_gt_powersave(struct drm_device *dev)
 {
 	i915.enable_rc6 =3D sanitize_rc6_option(dev, i915.enable_rc6);
=20
+	i915_rc6_ctx_wa_init(to_i915(dev));
+
 	if (IS_VALLEYVIEW(dev))
 		valleyview_init_gt_powersave(dev);
 }
@@ -4719,6 +4822,33 @@ void intel_cleanup_gt_powersave(struct drm_device *d=
ev)
 {
 	if (IS_VALLEYVIEW(dev))
 		valleyview_cleanup_gt_powersave(dev);
+
+	i915_rc6_ctx_wa_cleanup(to_i915(dev));
+}
+
+static void __intel_disable_rc6(struct drm_device *dev)
+{
+	if (IS_VALLEYVIEW(dev))
+		valleyview_disable_rc6(dev);
+	else
+		gen6_disable_rc6(dev);
+}
+
+static void intel_disable_rc6(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv =3D to_i915(dev);
+
+	mutex_lock(&dev_priv->rps.hw_lock);
+	__intel_disable_rc6(dev);
+	mutex_unlock(&dev_priv->rps.hw_lock);
+}
+
+static void intel_disable_rps(struct drm_device *dev)
+{
+	if (IS_VALLEYVIEW(dev))
+		valleyview_disable_rps(dev);
+	else
+		gen6_disable_rps(dev);
 }
=20
 void intel_disable_gt_powersave(struct drm_device *dev)
@@ -4736,12 +4866,14 @@ void intel_disable_gt_powersave(struct drm_device *=
dev)
 			intel_runtime_pm_put(dev_priv);
=20
 		cancel_work_sync(&dev_priv->rps.work);
+
 		mutex_lock(&dev_priv->rps.hw_lock);
-		if (IS_VALLEYVIEW(dev))
-			valleyview_disable_rps(dev);
-		else
-			gen6_disable_rps(dev);
+
+		__intel_disable_rc6(dev);
+		intel_disable_rps(dev);
+
 		dev_priv->rps.enabled =3D false;
+
 		mutex_unlock(&dev_priv->rps.hw_lock);
 	}
 }
diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 1be82284cf9d..be13516660c6 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -763,6 +763,8 @@ base_sock_create(struct net *net, struct socket *sock, =
int protocol)
=20
 	if (sock->type !=3D SOCK_RAW)
 		return -ESOCKTNOSUPPORT;
+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
=20
 	sk =3D sk_alloc(net, PF_ISDN, GFP_KERNEL, &mISDN_proto);
 	if (!sk)
diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb=
/dvb-usb/technisat-usb2.c
index d947e0379008..1e1123be9bcc 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -591,9 +591,9 @@ static int technisat_usb2_frontend_attach(struct dvb_us=
b_adapter *a)
=20
 static int technisat_usb2_get_ir(struct dvb_usb_device *d)
 {
-	u8 buf[62], *b;
-	int ret;
 	struct ir_raw_event ev;
+	u8 buf[62];
+	int i, ret;
=20
 	buf[0] =3D GET_IR_DATA_VENDOR_REQUEST;
 	buf[1] =3D 0x08;
@@ -629,26 +629,25 @@ static int technisat_usb2_get_ir(struct dvb_usb_devic=
e *d)
 		return 0; /* no key pressed */
=20
 	/* decoding */
-	b =3D buf+1;
=20
 #if 0
 	deb_rc("RC: %d ", ret);
-	debug_dump(b, ret, deb_rc);
+	debug_dump(buf + 1, ret, deb_rc);
 #endif
=20
 	ev.pulse =3D 0;
-	while (1) {
-		ev.pulse =3D !ev.pulse;
-		ev.duration =3D (*b * FIRMWARE_CLOCK_DIVISOR * FIRMWARE_CLOCK_TICK) / 10=
00;
-		ir_raw_event_store(d->rc_dev, &ev);
-
-		b++;
-		if (*b =3D=3D 0xff) {
+	for (i =3D 1; i < ARRAY_SIZE(buf); i++) {
+		if (buf[i] =3D=3D 0xff) {
 			ev.pulse =3D 0;
 			ev.duration =3D 888888*2;
 			ir_raw_event_store(d->rc_dev, &ev);
 			break;
 		}
+
+		ev.pulse =3D !ev.pulse;
+		ev.duration =3D (buf[i] * FIRMWARE_CLOCK_DIVISOR *
+			       FIRMWARE_CLOCK_TICK) / 1000;
+		ir_raw_event_store(d->rc_dev, &ev);
 	}
=20
 	ir_raw_event_handle(d->rc_dev);
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364x=
x/zr364xx.c
index 886e64361e17..acd787f455dc 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -712,7 +712,8 @@ static int zr364xx_vidioc_querycap(struct file *file, v=
oid *priv,
 	struct zr364xx_camera *cam =3D video_drvdata(file);
=20
 	strlcpy(cap->driver, DRIVER_DESC, sizeof(cap->driver));
-	strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
+	if (cam->udev->product)
+		strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
 	strlcpy(cap->bus_info, dev_name(&cam->udev->dev),
 		sizeof(cap->bus_info));
 	cap->device_caps =3D V4L2_CAP_VIDEO_CAPTURE |
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/a=
th/ath6kl/usb.c
index 3afc5a463d06..30e5c46c66bd 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -132,6 +132,10 @@ ath6kl_usb_alloc_urb_from_pipe(struct ath6kl_usb_pipe =
*pipe)
 	struct ath6kl_urb_context *urb_context =3D NULL;
 	unsigned long flags;
=20
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return NULL;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	if (!list_empty(&pipe->urb_list_head)) {
 		urb_context =3D
@@ -150,6 +154,10 @@ static void ath6kl_usb_free_urb_to_pipe(struct ath6kl_=
usb_pipe *pipe,
 {
 	unsigned long flags;
=20
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	pipe->urb_cnt++;
=20
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwi=
fi/ps.c
index 50504942ded1..bfe097b224ad 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -801,6 +801,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, voi=
d *data,
 				return;
 			} else {
 				noa_num =3D (noa_len - 2) / 13;
+				if (noa_num > P2P_MAX_NOA_NUM)
+					noa_num =3D P2P_MAX_NOA_NUM;
+
 			}
 			noa_index =3D ie[3];
 			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode =3D=3D
@@ -895,6 +898,9 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw, =
void *data,
 				return;
 			} else {
 				noa_num =3D (noa_len - 2) / 13;
+				if (noa_num > P2P_MAX_NOA_NUM)
+					noa_num =3D P2P_MAX_NOA_NUM;
+
 			}
 			noa_index =3D ie[3];
 			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode =3D=3D
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 356c94d46b3a..b12730be21a5 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -51,6 +51,11 @@ extern ssize_t cpu_show_l1tf(struct device *dev,
 			     struct device_attribute *attr, char *buf);
 extern ssize_t cpu_show_mds(struct device *dev,
 			    struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_tsx_async_abort(struct device *dev,
+					struct device_attribute *attr,
+					char *buf);
+extern ssize_t cpu_show_itlb_multihit(struct device *dev,
+				      struct device_attribute *attr, char *buf);
=20
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index e462ce6617a9..d1ac3818a37b 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1029,6 +1029,11 @@ static int atalk_create(struct net *net, struct sock=
et *sock, int protocol,
 	 */
 	if (sock->type !=3D SOCK_RAW && sock->type !=3D SOCK_DGRAM)
 		goto out;
+
+	rc =3D -EPERM;
+	if (sock->type =3D=3D SOCK_RAW && !kern && !capable(CAP_NET_RAW))
+		goto out;
+
 	rc =3D -ENOMEM;
 	sk =3D sk_alloc(net, PF_APPLETALK, GFP_KERNEL, &ddp_proto);
 	if (!sk)
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 1428c3ff3341..78f02c2de17c 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -853,6 +853,8 @@ static int ax25_create(struct net *net, struct socket *=
sock, int protocol,
 		break;
=20
 	case SOCK_RAW:
+		if (!capable(CAP_NET_RAW))
+			return -EPERM;
 		break;
 	default:
 		return -ESOCKTNOSUPPORT;
diff --git a/net/ieee802154/af_ieee802154.c b/net/ieee802154/af_ieee802154.c
index 351d9a94ec2f..bc262a3f46ba 100644
--- a/net/ieee802154/af_ieee802154.c
+++ b/net/ieee802154/af_ieee802154.c
@@ -255,6 +255,9 @@ static int ieee802154_create(struct net *net, struct so=
cket *sock,
=20
 	switch (sock->type) {
 	case SOCK_RAW:
+		rc =3D -EPERM;
+		if (!capable(CAP_NET_RAW))
+			goto out;
 		proto =3D &ieee802154_raw_prot;
 		ops =3D &ieee802154_raw_ops;
 		break;
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 51f077a92fa9..3e2982db97e5 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -1004,10 +1004,13 @@ static int llcp_sock_create(struct net *net, struct=
 socket *sock,
 	    sock->type !=3D SOCK_RAW)
 		return -ESOCKTNOSUPPORT;
=20
-	if (sock->type =3D=3D SOCK_RAW)
+	if (sock->type =3D=3D SOCK_RAW) {
+		if (!capable(CAP_NET_RAW))
+			return -EPERM;
 		sock->ops =3D &llcp_rawsock_ops;
-	else
+	} else {
 		sock->ops =3D &llcp_sock_ops;
+	}
=20
 	sk =3D nfc_llcp_sock_alloc(sock, sock->type, GFP_ATOMIC);
 	if (sk =3D=3D NULL)
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 996b919d82c7..ab8263d97c5b 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -506,6 +506,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch)
 		    (skb->ip_summed =3D=3D CHECKSUM_PARTIAL &&
 		     skb_checksum_help(skb))) {
 			rc =3D qdisc_drop(skb, sch);
+			skb =3D NULL;
 			goto finish_segs;
 		}
=20
@@ -576,9 +577,10 @@ static int netem_enqueue(struct sk_buff *skb, struct Q=
disc *sch)
 finish_segs:
 	if (segs) {
 		unsigned int len, last_len;
-		int nb =3D 0;
+		int nb;
=20
-		len =3D skb->len;
+		len =3D skb ? skb->len : 0;
+		nb =3D skb ? 1 : 0;
=20
 		while (segs) {
 			skb2 =3D segs->next;
@@ -595,7 +597,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch)
 			}
 			segs =3D skb2;
 		}
-		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
+		/* Parent qdiscs accounted for 1 skb of size @prev_len */
+		qdisc_tree_reduce_backlog(sch, -(nb - 1), -(len - prev_len));
 	}
 	return NET_XMIT_SUCCESS;
 }
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index c7e5c8eb4f24..e95b5e949406 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -225,6 +225,7 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 			       struct iw_point *data, char *ssid)
 {
 	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
+	int ret =3D 0;
=20
 	/* call only for station! */
 	if (WARN_ON(wdev->iftype !=3D NL80211_IFTYPE_STATION))
@@ -242,7 +243,10 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 		if (ie) {
 			data->flags =3D 1;
 			data->length =3D ie[1];
-			memcpy(ssid, ie + 2, data->length);
+			if (data->length > IW_ESSID_MAX_SIZE)
+				ret =3D -EINVAL;
+			else
+				memcpy(ssid, ie + 2, data->length);
 		}
 		rcu_read_unlock();
 	} else if (wdev->wext.connect.ssid && wdev->wext.connect.ssid_len) {
@@ -252,7 +256,7 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 	}
 	wdev_unlock(wdev);
=20
-	return 0;
+	return ret;
 }
=20
 int cfg80211_mgd_wext_siwap(struct net_device *dev,

--azLHFNyN32YCQGCU--

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3OFkMACgkQ57/I7JWG
EQn3BRAAlSqcZNrCTW/TQ9GwTUtWWGX7o6APcUkPN7AfFJ3VNXfEa5yL57f5cuFK
yssA4BDWAn1t85Vr6NGqb4YgQoTqkQeRpqIFVAAKarin/BpGEqwTA+r2rh7Gkmw7
DG9SZS462sJ0wDssfU8vi0Dt/tZKdaprgVYaJ+G2Ou5ACIYDCvJRqPPJEHmJ0YH8
82C69SzdtprkL/zC3KJThz+V7I4b6PQhBsT94mYEU7Q9zQCTaRBq0FL8U+fvzRmh
FWlT++fbwkm2aprmTog2IweTONU/VEy71Pluy8z3KVsP0JGfA2kmTNHtxuXa0ojL
qHhxF2dCdqyHYYEReoj4vJGmXHkHEOqcl/CHnREkDiJm+LlWrKt1AbVbRWRFReJv
e/nPucRozMw2NT6wbwc/wswYpfY51UweDQR0CZiURD13J9JqMjfh/EhwnPv63cjg
CijddBwJ2H/9JEyo56p/aDfHpCHy3l76w9j2kNIZacE6lFKFONCVi3CE3TzdVdGD
oMyezc0/6ivj/HwRpp2MdsGCLJzrtaKOrd2/oWp9Tcue5mqRcO83fuC++SIZ8sTG
yVlduLSSWWcSHJ5ZDDh4ATG4sn1VWwDjn1MqglKhJILpsvlBB6uggSCkUFtsjJx1
6VtS/GYJdseZQxT3pmuXedS/s+qOR15L5bVFr6JR7wilZvf7GMI=
=E57E
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
