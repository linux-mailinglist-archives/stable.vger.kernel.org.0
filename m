Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB5327BFB
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 13:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfEWLlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 07:41:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40396 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729863AbfEWLlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 07:41:16 -0400
Received: from ben by shadbolt.decadent.org.uk with local (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hTm5l-0002pF-4g; Thu, 23 May 2019 12:41:12 +0100
Date:   Thu, 23 May 2019 12:41:01 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Message-ID: <lsq.1558611626.154833658@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fjdzyk3d2upfqfoi"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        shadbolt.decadent.org.uk
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=5.0 tests=NO_RELAYS autolearn=disabled
        version=3.4.2
Subject: Linux 3.16.68
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fjdzyk3d2upfqfoi
Content-Type: multipart/mixed; boundary="7lnqs4bshjrjhwd2"
Content-Disposition: inline


--7lnqs4bshjrjhwd2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.16.68 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git

The diff from 3.16.67 is attached to this message.

Ben.

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu |   2 +
 Documentation/hw-vuln/mds.rst                      | 305 ++++++++++
 Documentation/kernel-parameters.txt                | 106 +++-
 Documentation/spec_ctrl.rst                        |   9 +
 Documentation/static-keys.txt                      |  99 ++--
 Documentation/x86/mds.rst                          | 225 ++++++++
 Makefile                                           |   3 +-
 arch/arm/include/asm/jump_label.h                  |  30 +-
 arch/arm/kernel/jump_label.c                       |   2 +-
 arch/arm64/include/asm/jump_label.h                |  24 +-
 arch/arm64/kernel/jump_label.c                     |   2 +-
 arch/mips/include/asm/jump_label.h                 |  32 +-
 arch/mips/kernel/jump_label.c                      |  44 +-
 arch/powerpc/include/asm/jump_label.h              |  19 +-
 arch/powerpc/kernel/jump_label.c                   |   2 +-
 arch/s390/include/asm/jump_label.h                 |  29 +-
 arch/s390/kernel/jump_label.c                      |  65 ++-
 arch/sparc/include/asm/jump_label.h                |  38 +-
 arch/sparc/kernel/jump_label.c                     |   2 +-
 arch/x86/Kconfig                                   |   8 +-
 arch/x86/boot/cpuflags.h                           |   2 +-
 arch/x86/boot/mkcpustr.c                           |   2 +-
 arch/x86/crypto/crc32-pclmul_glue.c                |   2 +-
 arch/x86/crypto/crc32c-intel_glue.c                |   2 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c            |   2 +-
 arch/x86/ia32/ia32entry.S                          |   2 +
 arch/x86/include/asm/alternative.h                 |   6 -
 arch/x86/include/asm/apic.h                        |   1 -
 arch/x86/include/asm/arch_hweight.h                |   2 +
 arch/x86/include/asm/atomic.h                      |   1 -
 arch/x86/include/asm/atomic64_32.h                 |   1 -
 arch/x86/include/asm/barrier.h                     |   1 +
 arch/x86/include/asm/cmpxchg.h                     |   1 +
 arch/x86/include/asm/cpufeature.h                  | 278 +--------
 arch/x86/include/asm/cpufeatures.h                 | 278 +++++++++
 arch/x86/include/asm/intel-family.h                |  30 +-
 arch/x86/include/asm/irqflags.h                    |   5 +
 arch/x86/include/asm/jump_label.h                  |  85 ++-
 arch/x86/include/asm/mwait.h                       |   7 +
 arch/x86/include/asm/nospec-branch.h               |  83 ++-
 arch/x86/include/asm/processor.h                   |  10 +-
 arch/x86/include/asm/smap.h                        |   2 +-
 arch/x86/include/asm/smp.h                         |   1 -
 arch/x86/include/asm/spec-ctrl.h                   |  20 +-
 arch/x86/include/asm/switch_to.h                   |   3 -
 arch/x86/include/asm/thread_info.h                 |  28 +-
 arch/x86/include/asm/tlbflush.h                    |   7 +
 arch/x86/include/asm/uaccess_64.h                  |   2 +-
 arch/x86/include/uapi/asm/msr-index.h              |  20 +-
 arch/x86/kernel/cpu/Makefile                       |   2 +-
 arch/x86/kernel/cpu/bugs.c                         | 629 ++++++++++++++++++---
 arch/x86/kernel/cpu/centaur.c                      |   2 +-
 arch/x86/kernel/cpu/common.c                       | 133 +++--
 arch/x86/kernel/cpu/cyrix.c                        |   1 +
 arch/x86/kernel/cpu/intel.c                        |   2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |   2 +-
 arch/x86/kernel/cpu/match.c                        |   2 +-
 arch/x86/kernel/cpu/mkcapflags.sh                  |  51 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |   2 +-
 arch/x86/kernel/cpu/proc.c                         |   8 +
 arch/x86/kernel/cpu/transmeta.c                    |   2 +-
 arch/x86/kernel/e820.c                             |   1 +
 arch/x86/kernel/entry_32.S                         |   4 +-
 arch/x86/kernel/entry_64.S                         |   7 +-
 arch/x86/kernel/head_32.S                          |   2 +-
 arch/x86/kernel/hpet.c                             |   1 +
 arch/x86/kernel/jump_label.c                       |   2 +-
 arch/x86/kernel/msr.c                              |   2 +-
 arch/x86/kernel/nmi.c                              |   4 +
 arch/x86/kernel/process.c                          | 101 +++-
 arch/x86/kernel/process.h                          |  39 ++
 arch/x86/kernel/process_32.c                       |   9 +-
 arch/x86/kernel/process_64.c                       |   9 +-
 arch/x86/kernel/traps.c                            |   9 +
 arch/x86/kernel/verify_cpu.S                       |   2 +-
 arch/x86/kvm/cpuid.c                               |   5 +-
 arch/x86/lib/clear_page_64.S                       |   2 +-
 arch/x86/lib/copy_page_64.S                        |   2 +-
 arch/x86/lib/copy_user_64.S                        |   2 +-
 arch/x86/lib/memcpy_64.S                           |   2 +-
 arch/x86/lib/memmove_64.S                          |   2 +-
 arch/x86/lib/memset_64.S                           |   2 +-
 arch/x86/lib/retpoline.S                           |   2 +-
 arch/x86/mm/kaiser.c                               |   4 +-
 arch/x86/mm/setup_nx.c                             |   1 +
 arch/x86/mm/tlb.c                                  | 102 +++-
 arch/x86/oprofile/op_model_amd.c                   |   1 -
 arch/x86/um/asm/barrier.h                          |   2 +-
 arch/x86/vdso/vdso32-setup.c                       |   1 -
 arch/x86/vdso/vma.c                                |   1 +
 drivers/base/cpu.c                                 |   8 +
 include/linux/cpu.h                                |  19 +
 include/linux/jump_label.h                         | 301 +++++++---
 include/linux/module.h                             |   5 +
 include/linux/ptrace.h                             |  21 +-
 include/linux/sched.h                              |   9 +
 include/linux/sched/smt.h                          |  20 +
 include/uapi/linux/prctl.h                         |   1 +
 kernel/cpu.c                                       |  23 +-
 kernel/jump_label.c                                | 159 ++++--
 kernel/module.c                                    |  12 +-
 kernel/ptrace.c                                    |  10 +
 kernel/sched/core.c                                |  19 +
 kernel/sched/sched.h                               |   1 +
 lib/atomic64_test.c                                |   4 +
 105 files changed, 2872 insertions(+), 829 deletions(-)

Andi Kleen (4):
      x86/headers: Don't include asm/processor.h in asm/atomic.h
      x86/speculation/mds: Add basic bug infrastructure for MDS
      x86/kvm: Expose X86_FEATURE_MD_CLEAR to guests
      x86/cpu/bugs: Use __initconst for 'const' init data

Andy Lutomirski (2):
      x86/asm: Error out if asm/jump_label.h is included inappropriately
      x86/asm: Add asm macros for static keys/jump labels

Anton Blanchard (2):
      jump_label: Allow asm/jump_label.h to be included in assembly
      jump_label: Allow jump labels to be used in assembly

Ben Hutchings (4):
      sched: Add sched_smt_active()
      x86/speculation/l1tf: Document l1tf in sysfs
      x86/bugs: Change L1TF mitigation string to match upstream
      Linux 3.16.68

Boris Ostrovsky (1):
      x86/speculation/mds: Fix comment

Borislav Petkov (2):
      x86/cpufeature: Add bug flags to /proc/cpuinfo
      x86/cpufeature: Carve out X86_FEATURE_*

Dominik Brodowski (1):
      x86/speculation: Simplify the CPU bug detection logic

Eduardo Habkost (1):
      kvm: x86: Report STIBP on GET_SUPPORTED_CPUID

Heiko Carstens (2):
      s390/jump label: add sanity checks
      s390/jump label: use different nop instruction

Ingo Molnar (1):
      jump_label: Fix small typos in the documentation

Jason Baron (1):
      jump label, locking/static_keys: Update docs

Jiang Biao (1):
      x86/speculation: Remove SPECTRE_V2_IBRS in enum spectre_v2_mitigation

Jiri Kosina (3):
      x86/speculation: Apply IBPB more strictly to avoid cross-process data leak
      x86/speculation: Enable cross-hyperthread spectre v2 STIBP mitigation
      x86/speculation: Propagate information about RSB filling mitigation to sysfs

Jonathan Corbet (2):
      locking/static_keys: Fix a silly typo
      locking/static_keys: Fix up the static keys documentation

Josh Poimboeuf (6):
      x86/speculation: Move arch_smt_update() call to after mitigation decisions
      x86/speculation/mds: Add SMT warning message
      cpu/speculation: Add 'mitigations=' cmdline option
      x86/speculation: Support 'mitigations=' cmdline option
      x86/speculation/mds: Add 'mitigations=' support for MDS
      x86/speculation/mds: Fix documentation typo

Konrad Rzeszutek Wilk (1):
      x86/speculation/mds: Print SMT vulnerable on MSBDS with mitigations off

Maciej W. Rozycki (2):
      MIPS: jump_label.c: Correct the span of the J instruction
      MIPS: jump_label.c: Handle the microMIPS J instruction encoding

Paolo Bonzini (1):
      locking/static_key: Fix concurrent static_key_slow_inc()

Peter Zijlstra (8):
      module, jump_label: Fix module locking
      jump_label: Rename JUMP_LABEL_{EN,DIS}ABLE to JUMP_LABEL_{JMP,NOP}
      jump_label, locking/static_keys: Rename JUMP_LABEL_TYPE_* and related helpers to the static_key* pattern
      jump_label: Add jump_entry_key() helper
      locking/static_keys: Rework update logic
      locking/static_keys: Add a new static_key interface
      jump_label/x86: Work around asm build bug on older/backported GCCs
      x86/cpu: Sanitize FAM6_ATOM naming

Petr Mladek (1):
      module: add within_module() function

Sai Praneeth (1):
      x86/speculation: Support Enhanced IBRS on future CPUs

Tejun Heo (1):
      jump_label: make static_key_enabled() work on static_key_true/false types too

Thomas Gleixner (29):
      x86/speculation: Rename SSBD update functions
      x86/Kconfig: Select SCHED_SMT if SMP enabled
      x86/speculation: Rework SMT state change
      x86/speculation: Reorder the spec_v2 code
      x86/speculation: Mark string arrays const correctly
      x86/speculataion: Mark command line parser data __initdata
      x86/speculation: Unify conditional spectre v2 print functions
      x86/speculation: Add command line control for indirect branch speculation
      x86/process: Consolidate and simplify switch_to_xtra() code
      x86/speculation: Avoid __switch_to_xtra() calls
      x86/speculation: Prepare for conditional IBPB in switch_mm()
      x86/speculation: Split out TIF update
      x86/speculation: Prepare arch_smt_update() for PRCTL mode
      x86/speculation: Prevent stale SPEC_CTRL msr content
      x86/speculation: Add prctl() control for indirect branch speculation
      x86/speculation: Enable prctl mode for spectre_v2_user
      x86/speculation: Add seccomp Spectre v2 user space protection mode
      x86/speculation: Provide IBPB always command line options
      x86/msr-index: Cleanup bit defines
      x86/speculation: Consolidate CPU whitelists
      x86/speculation/mds: Add BUG_MSBDS_ONLY
      x86/speculation/mds: Add mds_clear_cpu_buffers()
      x86/speculation/mds: Clear CPU buffers on exit to user
      x86/speculation/mds: Conditionally clear CPU buffers on idle entry
      x86/speculation/mds: Add mitigation control for MDS
      x86/speculation/mds: Add sysfs reporting for MDS
      x86/speculation/mds: Add mitigation mode VMWERV
      Documentation: Move L1TF to separate directory
      Documentation: Add MDS vulnerability documentation

Tim Chen (7):
      x86/speculation: Update the TIF_SSBD comment
      x86/speculation: Clean up spectre_v2_parse_cmdline()
      x86/speculation: Remove unnecessary ret variable in cpu_show_common()
      x86/speculation: Move STIPB/IBPB string conditionals out of cpu_show_common()
      x86/speculation: Disable STIBP when enhanced IBRS is in use
      x86/speculation: Reorganize speculation control MSRs update
      x86/speculation: Prepare for per task indirect branch speculation control

Tony Luck (1):
      locking/static_keys: Provide DECLARE and well as DEFINE macros

Tyler Hicks (1):
      Documentation: Correct the possible MDS sysfs values

speck for Pawan Gupta (1):
      x86/mds: Add MDSUM variant to the MDS documentation


--7lnqs4bshjrjhwd2
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.68.patch"
Content-Disposition: attachment; filename="linux-3.16.68.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documenta=
tion/ABI/testing/sysfs-devices-system-cpu
index 41bed89c8ee5..9d4dbf0adb21 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -230,6 +230,8 @@ What:		/sys/devices/system/cpu/vulnerabilities
 		/sys/devices/system/cpu/vulnerabilities/spectre_v1
 		/sys/devices/system/cpu/vulnerabilities/spectre_v2
 		/sys/devices/system/cpu/vulnerabilities/spec_store_bypass
+		/sys/devices/system/cpu/vulnerabilities/l1tf
+		/sys/devices/system/cpu/vulnerabilities/mds
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities
diff --git a/Documentation/hw-vuln/mds.rst b/Documentation/hw-vuln/mds.rst
new file mode 100644
index 000000000000..3f92728be021
--- /dev/null
+++ b/Documentation/hw-vuln/mds.rst
@@ -0,0 +1,305 @@
+MDS - Microarchitectural Data Sampling
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Microarchitectural Data Sampling is a hardware vulnerability which allows
+unprivileged speculative access to data which is available in various CPU
+internal buffers.
+
+Affected processors
+-------------------
+
+This vulnerability affects a wide range of Intel processors. The
+vulnerability is not present on:
+
+   - Processors from AMD, Centaur and other non Intel vendors
+
+   - Older processor models, where the CPU family is < 6
+
+   - Some Atoms (Bonnell, Saltwell, Goldmont, GoldmontPlus)
+
+   - Intel processors which have the ARCH_CAP_MDS_NO bit set in the
+     IA32_ARCH_CAPABILITIES MSR.
+
+Whether a processor is affected or not can be read out from the MDS
+vulnerability file in sysfs. See :ref:`mds_sys_info`.
+
+Not all processors are affected by all variants of MDS, but the mitigation
+is identical for all of them so the kernel treats them as a single
+vulnerability.
+
+Related CVEs
+------------
+
+The following CVE entries are related to the MDS vulnerability:
+
+   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+   CVE-2018-12126  MSBDS  Microarchitectural Store Buffer Data Sampling
+   CVE-2018-12130  MFBDS  Microarchitectural Fill Buffer Data Sampling
+   CVE-2018-12127  MLPDS  Microarchitectural Load Port Data Sampling
+   CVE-2019-11091  MDSUM  Microarchitectural Data Sampling Uncacheable Mem=
ory
+   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Problem
+-------
+
+When performing store, load, L1 refill operations, processors write data
+into temporary microarchitectural structures (buffers). The data in the
+buffer can be forwarded to load operations as an optimization.
+
+Under certain conditions, usually a fault/assist caused by a load
+operation, data unrelated to the load memory address can be speculatively
+forwarded from the buffers. Because the load operation causes a fault or
+assist and its result will be discarded, the forwarded data will not cause
+incorrect program execution or state changes. But a malicious operation
+may be able to forward this speculative data to a disclosure gadget which
+allows in turn to infer the value via a cache side channel attack.
+
+Because the buffers are potentially shared between Hyper-Threads cross
+Hyper-Thread attacks are possible.
+
+Deeper technical information is available in the MDS specific x86
+architecture section: :ref:`Documentation/x86/mds.rst <mds>`.
+
+
+Attack scenarios
+----------------
+
+Attacks against the MDS vulnerabilities can be mounted from malicious non
+priviledged user space applications running on hosts or guest. Malicious
+guest OSes can obviously mount attacks as well.
+
+Contrary to other speculation based vulnerabilities the MDS vulnerability
+does not allow the attacker to control the memory target address. As a
+consequence the attacks are purely sampling based, but as demonstrated with
+the TLBleed attack samples can be postprocessed successfully.
+
+Web-Browsers
+^^^^^^^^^^^^
+
+  It's unclear whether attacks through Web-Browsers are possible at
+  all. The exploitation through Java-Script is considered very unlikely,
+  but other widely used web technologies like Webassembly could possibly be
+  abused.
+
+
+.. _mds_sys_info:
+
+MDS system information
+-----------------------
+
+The Linux kernel provides a sysfs interface to enumerate the current MDS
+status of the system: whether the system is vulnerable, and which
+mitigations are active. The relevant sysfs file is:
+
+/sys/devices/system/cpu/vulnerabilities/mds
+
+The possible values in this file are:
+
+  .. list-table::
+
+     * - 'Not affected'
+       - The processor is not vulnerable
+     * - 'Vulnerable'
+       - The processor is vulnerable, but no mitigation enabled
+     * - 'Vulnerable: Clear CPU buffers attempted, no microcode'
+       - The processor is vulnerable but microcode is not updated.
+
+         The mitigation is enabled on a best effort basis. See :ref:`vmwer=
v`
+     * - 'Mitigation: Clear CPU buffers'
+       - The processor is vulnerable and the CPU buffer clearing mitigatio=
n is
+         enabled.
+
+If the processor is vulnerable then the following information is appended
+to the above information:
+
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    'SMT vulnerable'          SMT is enabled
+    'SMT mitigated'           SMT is enabled and mitigated
+    'SMT disabled'            SMT is disabled
+    'SMT Host state unknown'  Kernel runs in a VM, Host SMT state unknown
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+.. _vmwerv:
+
+Best effort mitigation mode
+^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+  If the processor is vulnerable, but the availability of the microcode ba=
sed
+  mitigation mechanism is not advertised via CPUID the kernel selects a be=
st
+  effort mitigation mode.  This mode invokes the mitigation instructions
+  without a guarantee that they clear the CPU buffers.
+
+  This is done to address virtualization scenarios where the host has the
+  microcode update applied, but the hypervisor is not yet updated to expose
+  the CPUID to the guest. If the host has updated microcode the protection
+  takes effect otherwise a few cpu cycles are wasted pointlessly.
+
+  The state in the mds sysfs file reflects this situation accordingly.
+
+
+Mitigation mechanism
+-------------------------
+
+The kernel detects the affected CPUs and the presence of the microcode
+which is required.
+
+If a CPU is affected and the microcode is available, then the kernel
+enables the mitigation by default. The mitigation can be controlled at boot
+time via a kernel command line option. See
+:ref:`mds_mitigation_control_command_line`.
+
+.. _cpu_buffer_clear:
+
+CPU buffer clearing
+^^^^^^^^^^^^^^^^^^^
+
+  The mitigation for MDS clears the affected CPU buffers on return to user
+  space and when entering a guest.
+
+  If SMT is enabled it also clears the buffers on idle entry when the CPU
+  is only affected by MSBDS and not any other MDS variant, because the
+  other variants cannot be protected against cross Hyper-Thread attacks.
+
+  For CPUs which are only affected by MSBDS the user space, guest and idle
+  transition mitigations are sufficient and SMT is not affected.
+
+.. _virt_mechanism:
+
+Virtualization mitigation
+^^^^^^^^^^^^^^^^^^^^^^^^^
+
+  The protection for host to guest transition depends on the L1TF
+  vulnerability of the CPU:
+
+  - CPU is affected by L1TF:
+
+    If the L1D flush mitigation is enabled and up to date microcode is
+    available, the L1D flush mitigation is automatically protecting the
+    guest transition.
+
+    If the L1D flush mitigation is disabled then the MDS mitigation is
+    invoked explicit when the host MDS mitigation is enabled.
+
+    For details on L1TF and virtualization see:
+    :ref:`Documentation/hw-vuln//l1tf.rst <mitigation_control_kvm>`.
+
+  - CPU is not affected by L1TF:
+
+    CPU buffers are flushed before entering the guest when the host MDS
+    mitigation is enabled.
+
+  The resulting MDS protection matrix for the host to guest transition:
+
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+   L1TF         MDS   VMX-L1FLUSH   Host MDS     MDS-State
+
+   Don't care   No    Don't care    N/A          Not affected
+
+   Yes          Yes   Disabled      Off          Vulnerable
+
+   Yes          Yes   Disabled      Full         Mitigated
+
+   Yes          Yes   Enabled       Don't care   Mitigated
+
+   No           Yes   N/A           Off          Vulnerable
+
+   No           Yes   N/A           Full         Mitigated
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  This only covers the host to guest transition, i.e. prevents leakage from
+  host to guest, but does not protect the guest internally. Guests need to
+  have their own protections.
+
+.. _xeon_phi:
+
+XEON PHI specific considerations
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+  The XEON PHI processor family is affected by MSBDS which can be exploited
+  cross Hyper-Threads when entering idle states. Some XEON PHI variants al=
low
+  to use MWAIT in user space (Ring 3) which opens an potential attack vect=
or
+  for malicious user space. The exposure can be disabled on the kernel
+  command line with the 'ring3mwait=3Ddisable' command line option.
+
+  XEON PHI is not affected by the other MDS variants and MSBDS is mitigated
+  before the CPU enters a idle state. As XEON PHI is not affected by L1TF
+  either disabling SMT is not required for full protection.
+
+.. _mds_smt_control:
+
+SMT control
+^^^^^^^^^^^
+
+  All MDS variants except MSBDS can be attacked cross Hyper-Threads. That
+  means on CPUs which are affected by MFBDS or MLPDS it is necessary to
+  disable SMT for full protection. These are most of the affected CPUs; the
+  exception is XEON PHI, see :ref:`xeon_phi`.
+
+  Disabling SMT can have a significant performance impact, but the impact
+  depends on the type of workloads.
+
+  See the relevant chapter in the L1TF mitigation documentation for detail=
s:
+  :ref:`Documentation/hw-vuln/l1tf.rst <smt_control>`.
+
+
+.. _mds_mitigation_control_command_line:
+
+Mitigation control on the kernel command line
+---------------------------------------------
+
+The kernel command line allows to control the MDS mitigations at boot
+time with the option "mds=3D". The valid arguments for this option are:
+
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+  full		If the CPU is vulnerable, enable all available mitigations
+		for the MDS vulnerability, CPU buffer clearing on exit to
+		userspace and when entering a VM. Idle transitions are
+		protected as well if SMT is enabled.
+
+		It does not automatically disable SMT.
+
+  off		Disables MDS mitigations completely.
+
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Not specifying this option is equivalent to "mds=3Dfull".
+
+
+Mitigation selection guide
+--------------------------
+
+1. Trusted userspace
+^^^^^^^^^^^^^^^^^^^^
+
+   If all userspace applications are from a trusted source and do not
+   execute untrusted code which is supplied externally, then the mitigation
+   can be disabled.
+
+
+2. Virtualization with trusted guests
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+   The same considerations as above versus trusted user space apply.
+
+3. Virtualization with untrusted guests
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+   The protection depends on the state of the L1TF mitigations.
+   See :ref:`virt_mechanism`.
+
+   If the MDS mitigation is enabled and SMT is disabled, guest to host and
+   guest to guest attacks are prevented.
+
+.. _mds_default_mitigations:
+
+Default mitigations
+-------------------
+
+  The kernel default mitigations for vulnerable processors are:
+
+  - Enable CPU buffer clearing
+
+  The kernel does not by default enforce the disabling of SMT, which leaves
+  SMT systems vulnerable when running untrusted code. The same rationale as
+  for L1TF applies.
+  See :ref:`Documentation/hw-vuln//l1tf.rst <default_mitigations>`.
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-par=
ameters.txt
index 28687bbe2ee0..67a21b2ef3e4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -629,7 +629,7 @@ bytes respectively. Such letter suffixes can also be en=
tirely omitted.
=20
 	clearcpuid=3DBITNUM [X86]
 			Disable CPUID feature X for the kernel. See
-			arch/x86/include/asm/cpufeature.h for the valid bit
+			arch/x86/include/asm/cpufeatures.h for the valid bit
 			numbers. Note the Linux specific bits are not necessarily
 			stable over kernel options, but the vendor specific
 			ones should be.
@@ -1774,6 +1774,30 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
 			Format: <first>,<last>
 			Specifies range of consoles to be captured by the MDA.
=20
+	mds=3D		[X86,INTEL]
+			Control mitigation for the Micro-architectural Data
+			Sampling (MDS) vulnerability.
+
+			Certain CPUs are vulnerable to an exploit against CPU
+			internal buffers which can forward information to a
+			disclosure gadget under certain conditions.
+
+			In vulnerable processors, the speculatively
+			forwarded data can be used in a cache side channel
+			attack, to access data to which the attacker does
+			not have direct access.
+
+			This parameter controls the MDS mitigation. The
+			options are:
+
+			full    - Enable MDS mitigation on vulnerable CPUs
+			off     - Unconditionally disable MDS mitigation
+
+			Not specifying this option is equivalent to
+			mds=3Dfull.
+
+			For details see: Documentation/hw-vuln/mds.rst
+
 	mem=3Dnn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
 			Amount of memory to be used when the kernel is not able
 			to see the whole system memory or for test.
@@ -1882,6 +1906,30 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
 			in the "bleeding edge" mini2440 support kernel at
 			http://repo.or.cz/w/linux-2.6/mini2440.git
=20
+	mitigations=3D
+			[X86] Control optional mitigations for CPU
+			vulnerabilities.  This is a set of curated,
+			arch-independent options, each of which is an
+			aggregation of existing arch-specific options.
+
+			off
+				Disable all optional CPU mitigations.  This
+				improves system performance, but it may also
+				expose users to several CPU vulnerabilities.
+				Equivalent to: nopti [X86]
+					       nospectre_v2 [X86]
+					       spectre_v2_user=3Doff [X86]
+					       spec_store_bypass_disable=3Doff [X86]
+					       mds=3Doff [X86]
+
+			auto (default)
+				Mitigate all CPU vulnerabilities, but leave SMT
+				enabled, even if it's vulnerable.  This is for
+				users who don't want to be surprised by SMT
+				getting disabled across kernel upgrades, or who
+				have other ways of avoiding SMT-based attacks.
+				Equivalent to: (default behavior)
+
 	mminit_loglevel=3D
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
 			parameter allows control of the logging verbosity for
@@ -3176,9 +3224,13 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
=20
 	spectre_v2=3D	[X86] Control mitigation of Spectre variant 2
 			(indirect branch speculation) vulnerability.
+			The default operation protects the kernel from
+			user space attacks.
=20
-			on   - unconditionally enable
-			off  - unconditionally disable
+			on   - unconditionally enable, implies
+			       spectre_v2_user=3Don
+			off  - unconditionally disable, implies
+			       spectre_v2_user=3Doff
 			auto - kernel detects whether your CPU model is
 			       vulnerable
=20
@@ -3188,6 +3240,12 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
 			CONFIG_RETPOLINE configuration option, and the
 			compiler with which the kernel was built.
=20
+			Selecting 'on' will also enable the mitigation
+			against user space to user space task attacks.
+
+			Selecting 'off' will disable both the kernel and
+			the user space protections.
+
 			Specific mitigations can also be selected manually:
=20
 			retpoline	  - replace indirect branches
@@ -3197,6 +3255,48 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
 			Not specifying this option is equivalent to
 			spectre_v2=3Dauto.
=20
+	spectre_v2_user=3D
+			[X86] Control mitigation of Spectre variant 2
+		        (indirect branch speculation) vulnerability between
+		        user space tasks
+
+			on	- Unconditionally enable mitigations. Is
+				  enforced by spectre_v2=3Don
+
+			off     - Unconditionally disable mitigations. Is
+				  enforced by spectre_v2=3Doff
+
+			prctl   - Indirect branch speculation is enabled,
+				  but mitigation can be enabled via prctl
+				  per thread.  The mitigation control state
+				  is inherited on fork.
+
+			prctl,ibpb
+				- Like "prctl" above, but only STIBP is
+				  controlled per thread. IBPB is issued
+				  always when switching between different user
+				  space processes.
+
+			seccomp
+				- Same as "prctl" above, but all seccomp
+				  threads will enable the mitigation unless
+				  they explicitly opt out.
+
+			seccomp,ibpb
+				- Like "seccomp" above, but only STIBP is
+				  controlled per thread. IBPB is issued
+				  always when switching between different
+				  user space processes.
+
+			auto    - Kernel selects the mitigation depending on
+				  the available CPU features and vulnerability.
+
+			Default mitigation:
+			If CONFIG_SECCOMP=3Dy then "seccomp", otherwise "prctl"
+
+			Not specifying this option is equivalent to
+			spectre_v2_user=3Dauto.
+
 	spec_store_bypass_disable=3D
 			[HW] Control Speculative Store Bypass (SSB) Disable mitigation
 			(Speculative Store Bypass vulnerability)
diff --git a/Documentation/spec_ctrl.rst b/Documentation/spec_ctrl.rst
index 32f3d55c54b7..c4dbe6f7cdae 100644
--- a/Documentation/spec_ctrl.rst
+++ b/Documentation/spec_ctrl.rst
@@ -92,3 +92,12 @@ Speculation misfeature controls
    * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_STORE_BYPASS, PR_SPEC_ENABLE, =
0, 0);
    * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_STORE_BYPASS, PR_SPEC_DISABLE,=
 0, 0);
    * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_STORE_BYPASS, PR_SPEC_FORCE_DI=
SABLE, 0, 0);
+
+- PR_SPEC_INDIR_BRANCH: Indirect Branch Speculation in User Processes
+                        (Mitigate Spectre V2 style attacks against user pr=
ocesses)
+
+  Invocations:
+   * prctl(PR_GET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, 0, 0, 0);
+   * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, PR_SPEC_ENABL=
E, 0, 0);
+   * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, PR_SPEC_DISAB=
LE, 0, 0);
+   * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, PR_SPEC_FORCE=
_DISABLE, 0, 0);
diff --git a/Documentation/static-keys.txt b/Documentation/static-keys.txt
index c4407a41b0fc..477927becacb 100644
--- a/Documentation/static-keys.txt
+++ b/Documentation/static-keys.txt
@@ -1,7 +1,22 @@
 			Static Keys
 			-----------
=20
-By: Jason Baron <jbaron@redhat.com>
+DEPRECATED API:
+
+The use of 'struct static_key' directly, is now DEPRECATED. In addition
+static_key_{true,false}() is also DEPRECATED. IE DO NOT use the following:
+
+struct static_key false =3D STATIC_KEY_INIT_FALSE;
+struct static_key true =3D STATIC_KEY_INIT_TRUE;
+static_key_true()
+static_key_false()
+
+The updated API replacements are:
+
+DEFINE_STATIC_KEY_TRUE(key);
+DEFINE_STATIC_KEY_FALSE(key);
+static_branch_likely()
+static_branch_unlikely()
=20
 0) Abstract
=20
@@ -9,22 +24,22 @@ Static keys allows the inclusion of seldom used features=
 in
 performance-sensitive fast-path kernel code, via a GCC feature and a code
 patching technique. A quick example:
=20
-	struct static_key key =3D STATIC_KEY_INIT_FALSE;
+	DEFINE_STATIC_KEY_FALSE(key);
=20
 	...
=20
-        if (static_key_false(&key))
+        if (static_branch_unlikely(&key))
                 do unlikely code
         else
                 do likely code
=20
 	...
-	static_key_slow_inc();
+	static_branch_enable(&key);
 	...
-	static_key_slow_inc();
+	static_branch_disable(&key);
 	...
=20
-The static_key_false() branch will be generated into the code with as litt=
le
+The static_branch_unlikely() branch will be generated into the code with a=
s little
 impact to the likely code path as possible.
=20
=20
@@ -56,7 +71,7 @@ the branch site to change the branch direction.
=20
 For example, if we have a simple branch that is disabled by default:
=20
-	if (static_key_false(&key))
+	if (static_branch_unlikely(&key))
 		printk("I am the true branch\n");
=20
 Thus, by default the 'printk' will not be emitted. And the code generated =
will
@@ -75,68 +90,55 @@ the basis for the static keys facility.
=20
 In order to make use of this optimization you must first define a key:
=20
-	struct static_key key;
-
-Which is initialized as:
-
-	struct static_key key =3D STATIC_KEY_INIT_TRUE;
+	DEFINE_STATIC_KEY_TRUE(key);
=20
 or:
=20
-	struct static_key key =3D STATIC_KEY_INIT_FALSE;
+	DEFINE_STATIC_KEY_FALSE(key);
+
=20
-If the key is not initialized, it is default false. The 'struct static_key=
',
-must be a 'global'. That is, it can't be allocated on the stack or dynamic=
ally
+The key must be global, that is, it can't be allocated on the stack or dyn=
amically
 allocated at run-time.
=20
 The key is then used in code as:
=20
-        if (static_key_false(&key))
+        if (static_branch_unlikely(&key))
                 do unlikely code
         else
                 do likely code
=20
 Or:
=20
-        if (static_key_true(&key))
+        if (static_branch_likely(&key))
                 do likely code
         else
                 do unlikely code
=20
-A key that is initialized via 'STATIC_KEY_INIT_FALSE', must be used in a
-'static_key_false()' construct. Likewise, a key initialized via
-'STATIC_KEY_INIT_TRUE' must be used in a 'static_key_true()' construct. A
-single key can be used in many branches, but all the branches must match t=
he
-way that the key has been initialized.
+Keys defined via DEFINE_STATIC_KEY_TRUE(), or DEFINE_STATIC_KEY_FALSE, may
+be used in either static_branch_likely() or static_branch_unlikely()
+statemnts.
=20
-The branch(es) can then be switched via:
+Branch(es) can be set true via:
=20
-	static_key_slow_inc(&key);
-	...
-	static_key_slow_dec(&key);
+static_branch_enable(&key);
=20
-Thus, 'static_key_slow_inc()' means 'make the branch true', and
-'static_key_slow_dec()' means 'make the branch false' with appropriate
-reference counting. For example, if the key is initialized true, a
-static_key_slow_dec(), will switch the branch to false. And a subsequent
-static_key_slow_inc(), will change the branch back to true. Likewise, if t=
he
-key is initialized false, a 'static_key_slow_inc()', will change the branc=
h to
-true. And then a 'static_key_slow_dec()', will again make the branch false.
+or false via:
+
+static_branch_disable(&key);
=20
-An example usage in the kernel is the implementation of tracepoints:
+The branch(es) can then be switched via reference counts:
=20
-        static inline void trace_##name(proto)                          \
-        {                                                               \
-                if (static_key_false(&__tracepoint_##name.key))		\
-                        __DO_TRACE(&__tracepoint_##name,                \
-                                TP_PROTO(data_proto),                   \
-                                TP_ARGS(data_args),                     \
-                                TP_CONDITION(cond));                    \
-        }
+	static_branch_inc(&key);
+	...
+	static_branch_dec(&key);
=20
-Tracepoints are disabled by default, and can be placed in performance crit=
ical
-pieces of the kernel. Thus, by using a static key, the tracepoints can have
-absolutely minimal impact when not in use.
+Thus, 'static_branch_inc()' means 'make the branch true', and
+'static_branch_dec()' means 'make the branch false' with appropriate
+reference counting. For example, if the key is initialized true, a
+static_branch_dec(), will switch the branch to false. And a subsequent
+static_branch_inc(), will change the branch back to true. Likewise, if the
+key is initialized false, a 'static_branch_inc()', will change the branch =
to
+true. And then a 'static_branch_dec()', will again make the branch false.
=20
=20
 4) Architecture level code patching interface, 'jump labels'
@@ -150,9 +152,12 @@ simply fall back to a traditional, load, test, and jum=
p sequence.
=20
 * #define JUMP_LABEL_NOP_SIZE, see: arch/x86/include/asm/jump_label.h
=20
-* __always_inline bool arch_static_branch(struct static_key *key), see:
+* __always_inline bool arch_static_branch(struct static_key *key, bool bra=
nch), see:
 					arch/x86/include/asm/jump_label.h
=20
+* __always_inline bool arch_static_branch_jump(struct static_key *key, boo=
l branch),
+					see: arch/x86/include/asm/jump_label.h
+
 * void arch_jump_label_transform(struct jump_entry *entry, enum jump_label=
_type type),
 					see: arch/x86/kernel/jump_label.c
=20
@@ -173,7 +178,7 @@ SYSCALL_DEFINE0(getppid)
 {
         int pid;
=20
-+       if (static_key_false(&key))
++       if (static_branch_unlikely(&key))
 +               printk("I am the true branch\n");
=20
         rcu_read_lock();
diff --git a/Documentation/x86/mds.rst b/Documentation/x86/mds.rst
new file mode 100644
index 000000000000..534e9baa4e1d
--- /dev/null
+++ b/Documentation/x86/mds.rst
@@ -0,0 +1,225 @@
+Microarchitectural Data Sampling (MDS) mitigation
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+.. _mds:
+
+Overview
+--------
+
+Microarchitectural Data Sampling (MDS) is a family of side channel attacks
+on internal buffers in Intel CPUs. The variants are:
+
+ - Microarchitectural Store Buffer Data Sampling (MSBDS) (CVE-2018-12126)
+ - Microarchitectural Fill Buffer Data Sampling (MFBDS) (CVE-2018-12130)
+ - Microarchitectural Load Port Data Sampling (MLPDS) (CVE-2018-12127)
+ - Microarchitectural Data Sampling Uncacheable Memory (MDSUM) (CVE-2019-1=
1091)
+
+MSBDS leaks Store Buffer Entries which can be speculatively forwarded to a
+dependent load (store-to-load forwarding) as an optimization. The forward
+can also happen to a faulting or assisting load operation for a different
+memory address, which can be exploited under certain conditions. Store
+buffers are partitioned between Hyper-Threads so cross thread forwarding is
+not possible. But if a thread enters or exits a sleep state the store
+buffer is repartitioned which can expose data from one thread to the other.
+
+MFBDS leaks Fill Buffer Entries. Fill buffers are used internally to manage
+L1 miss situations and to hold data which is returned or sent in response
+to a memory or I/O operation. Fill buffers can forward data to a load
+operation and also write data to the cache. When the fill buffer is
+deallocated it can retain the stale data of the preceding operations which
+can then be forwarded to a faulting or assisting load operation, which can
+be exploited under certain conditions. Fill buffers are shared between
+Hyper-Threads so cross thread leakage is possible.
+
+MLPDS leaks Load Port Data. Load ports are used to perform load operations
+from memory or I/O. The received data is then forwarded to the register
+file or a subsequent operation. In some implementations the Load Port can
+contain stale data from a previous operation which can be forwarded to
+faulting or assisting loads under certain conditions, which again can be
+exploited eventually. Load ports are shared between Hyper-Threads so cross
+thread leakage is possible.
+
+MDSUM is a special case of MSBDS, MFBDS and MLPDS. An uncacheable load from
+memory that takes a fault or assist can leave data in a microarchitectural
+structure that may later be observed using one of the same methods used by
+MSBDS, MFBDS or MLPDS.
+
+Exposure assumptions
+--------------------
+
+It is assumed that attack code resides in user space or in a guest with one
+exception. The rationale behind this assumption is that the code construct
+needed for exploiting MDS requires:
+
+ - to control the load to trigger a fault or assist
+
+ - to have a disclosure gadget which exposes the speculatively accessed
+   data for consumption through a side channel.
+
+ - to control the pointer through which the disclosure gadget exposes the
+   data
+
+The existence of such a construct in the kernel cannot be excluded with
+100% certainty, but the complexity involved makes it extremly unlikely.
+
+There is one exception, which is untrusted BPF. The functionality of
+untrusted BPF is limited, but it needs to be thoroughly investigated
+whether it can be used to create such a construct.
+
+
+Mitigation strategy
+-------------------
+
+All variants have the same mitigation strategy at least for the single CPU
+thread case (SMT off): Force the CPU to clear the affected buffers.
+
+This is achieved by using the otherwise unused and obsolete VERW
+instruction in combination with a microcode update. The microcode clears
+the affected CPU buffers when the VERW instruction is executed.
+
+For virtualization there are two ways to achieve CPU buffer
+clearing. Either the modified VERW instruction or via the L1D Flush
+command. The latter is issued when L1TF mitigation is enabled so the extra
+VERW can be avoided. If the CPU is not affected by L1TF then VERW needs to
+be issued.
+
+If the VERW instruction with the supplied segment selector argument is
+executed on a CPU without the microcode update there is no side effect
+other than a small number of pointlessly wasted CPU cycles.
+
+This does not protect against cross Hyper-Thread attacks except for MSBDS
+which is only exploitable cross Hyper-thread when one of the Hyper-Threads
+enters a C-state.
+
+The kernel provides a function to invoke the buffer clearing:
+
+    mds_clear_cpu_buffers()
+
+The mitigation is invoked on kernel/userspace, hypervisor/guest and C-state
+(idle) transitions.
+
+As a special quirk to address virtualization scenarios where the host has
+the microcode updated, but the hypervisor does not (yet) expose the
+MD_CLEAR CPUID bit to guests, the kernel issues the VERW instruction in the
+hope that it might actually clear the buffers. The state is reflected
+accordingly.
+
+According to current knowledge additional mitigations inside the kernel
+itself are not required because the necessary gadgets to expose the leaked
+data cannot be controlled in a way which allows exploitation from malicious
+user space or VM guests.
+
+Kernel internal mitigation modes
+--------------------------------
+
+ =3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ off      Mitigation is disabled. Either the CPU is not affected or
+          mds=3Doff is supplied on the kernel command line
+
+ full     Mitigation is enabled. CPU is affected and MD_CLEAR is
+          advertised in CPUID.
+
+ vmwerv	  Mitigation is enabled. CPU is affected and MD_CLEAR is not
+	  advertised in CPUID. That is mainly for virtualization
+	  scenarios where the host has the updated microcode but the
+	  hypervisor does not expose MD_CLEAR in CPUID. It's a best
+	  effort approach without guarantee.
+ =3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+If the CPU is affected and mds=3Doff is not supplied on the kernel command
+line then the kernel selects the appropriate mitigation mode depending on
+the availability of the MD_CLEAR CPUID bit.
+
+Mitigation points
+-----------------
+
+1. Return to user space
+^^^^^^^^^^^^^^^^^^^^^^^
+
+   When transitioning from kernel to user space the CPU buffers are flushed
+   on affected CPUs when the mitigation is not disabled on the kernel
+   command line. The migitation is enabled through the static key
+   mds_user_clear.
+
+   The mitigation is invoked in prepare_exit_to_usermode() which covers
+   most of the kernel to user space transitions. There are a few exceptions
+   which are not invoking prepare_exit_to_usermode() on return to user
+   space. These exceptions use the paranoid exit code.
+
+   - Non Maskable Interrupt (NMI):
+
+     Access to sensible data like keys, credentials in the NMI context is
+     mostly theoretical: The CPU can do prefetching or execute a
+     misspeculated code path and thereby fetching data which might end up
+     leaking through a buffer.
+
+     But for mounting other attacks the kernel stack address of the task is
+     already valuable information. So in full mitigation mode, the NMI is
+     mitigated on the return from do_nmi() to provide almost complete
+     coverage.
+
+   - Double fault (#DF):
+
+     A double fault is usually fatal, but the ESPFIX workaround, which can
+     be triggered from user space through modify_ldt(2) is a recoverable
+     double fault. #DF uses the paranoid exit path, so explicit mitigation
+     in the double fault handler is required.
+
+   - Machine Check Exception (#MC):
+
+     Another corner case is a #MC which hits between the CPU buffer clear
+     invocation and the actual return to user. As this still is in kernel
+     space it takes the paranoid exit path which does not clear the CPU
+     buffers. So the #MC handler repopulates the buffers to some
+     extent. Machine checks are not reliably controllable and the window is
+     extremly small so mitigation would just tick a checkbox that this
+     theoretical corner case is covered. To keep the amount of special
+     cases small, ignore #MC.
+
+   - Debug Exception (#DB):
+
+     This takes the paranoid exit path only when the INT1 breakpoint is in
+     kernel space. #DB on a user space address takes the regular exit path,
+     so no extra mitigation required.
+
+
+2. C-State transition
+^^^^^^^^^^^^^^^^^^^^^
+
+   When a CPU goes idle and enters a C-State the CPU buffers need to be
+   cleared on affected CPUs when SMT is active. This addresses the
+   repartitioning of the store buffer when one of the Hyper-Threads enters
+   a C-State.
+
+   When SMT is inactive, i.e. either the CPU does not support it or all
+   sibling threads are offline CPU buffer clearing is not required.
+
+   The idle clearing is enabled on CPUs which are only affected by MSBDS
+   and not by any other MDS variant. The other MDS variants cannot be
+   protected against cross Hyper-Thread attacks because the Fill Buffer and
+   the Load Ports are shared. So on CPUs affected by other variants, the
+   idle clearing would be a window dressing exercise and is therefore not
+   activated.
+
+   The invocation is controlled by the static key mds_idle_clear which is
+   switched depending on the chosen mitigation mode and the SMT state of
+   the system.
+
+   The buffer clear is only invoked before entering the C-State to prevent
+   that stale data from the idling CPU from spilling to the Hyper-Thread
+   sibling after the store buffer got repartitioned and all entries are
+   available to the non idle sibling.
+
+   When coming out of idle the store buffer is partitioned again so each
+   sibling has half of it available. The back from idle CPU could be then
+   speculatively exposed to contents of the sibling. The buffers are
+   flushed either on exit to user space or on VMENTER so malicious code
+   in user space or the guest cannot speculatively access them.
+
+   The mitigation is hooked into all variants of halt()/mwait(), but does
+   not cover the legacy ACPI IO-Port mechanism because the ACPI idle driver
+   has been superseded by the intel_idle driver around 2010 and is
+   preferred on all affected CPUs which are expected to gain the MD_CLEAR
+   functionality in microcode. Aside of that the IO-Port mechanism is a
+   legacy interface which is only used on older systems which are either
+   not affected or do not receive microcode updates anymore.
diff --git a/Makefile b/Makefile
index 33a54d0451a3..7763a879e9d5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 67
+SUBLEVEL =3D 68
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
@@ -761,6 +761,7 @@ KBUILD_ARFLAGS :=3D $(call ar-option,D)
 # check for 'asm goto'
 ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 	KBUILD_CFLAGS +=3D -DCC_HAVE_ASM_GOTO
+	KBUILD_AFLAGS +=3D -DCC_HAVE_ASM_GOTO
 endif
=20
 include $(srctree)/scripts/Makefile.extrawarn
diff --git a/arch/arm/include/asm/jump_label.h b/arch/arm/include/asm/jump_=
label.h
index 70f9b9bfb1f9..34f7b6980d21 100644
--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -1,33 +1,40 @@
 #ifndef _ASM_ARM_JUMP_LABEL_H
 #define _ASM_ARM_JUMP_LABEL_H
=20
-#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
=20
 #include <linux/types.h>
+#include <asm/unified.h>
=20
 #define JUMP_LABEL_NOP_SIZE 4
=20
-#ifdef CONFIG_THUMB2_KERNEL
-#define JUMP_LABEL_NOP	"nop.w"
-#else
-#define JUMP_LABEL_NOP	"nop"
-#endif
-
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key, boo=
l branch)
 {
 	asm_volatile_goto("1:\n\t"
-		 JUMP_LABEL_NOP "\n\t"
+		 WASM(nop) "\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 ".word 1b, %l[l_yes], %c0\n\t"
 		 ".popsection\n\t"
-		 : :  "i" (key) :  : l_yes);
+		 : :  "i" (&((char *)key)[branch]) :  : l_yes);
=20
 	return false;
 l_yes:
 	return true;
 }
=20
-#endif /* __KERNEL__ */
+static __always_inline bool arch_static_branch_jump(struct static_key *key=
, bool branch)
+{
+	asm_volatile_goto("1:\n\t"
+		 WASM(b) " %l[l_yes]\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".word 1b, %l[l_yes], %c0\n\t"
+		 ".popsection\n\t"
+		 : :  "i" (&((char *)key)[branch]) :  : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
=20
 typedef u32 jump_label_t;
=20
@@ -37,4 +44,5 @@ struct jump_entry {
 	jump_label_t key;
 };
=20
+#endif  /* __ASSEMBLY__ */
 #endif
diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
index 4ce4f789446d..d0514adc7e2d 100644
--- a/arch/arm/kernel/jump_label.c
+++ b/arch/arm/kernel/jump_label.c
@@ -13,7 +13,7 @@ static void __arch_jump_label_transform(struct jump_entry=
 *entry,
 	void *addr =3D (void *)entry->code;
 	unsigned int insn;
=20
-	if (type =3D=3D JUMP_LABEL_ENABLE)
+	if (type =3D=3D JUMP_LABEL_JMP)
 		insn =3D arm_gen_branch(entry->code, entry->target);
 	else
 		insn =3D arm_gen_nop();
diff --git a/arch/arm64/include/asm/jump_label.h b/arch/arm64/include/asm/j=
ump_label.h
index 076a1c714049..1b5e0e843c3a 100644
--- a/arch/arm64/include/asm/jump_label.h
+++ b/arch/arm64/include/asm/jump_label.h
@@ -18,28 +18,41 @@
  */
 #ifndef __ASM_JUMP_LABEL_H
 #define __ASM_JUMP_LABEL_H
+
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 #include <asm/insn.h>
=20
-#ifdef __KERNEL__
-
 #define JUMP_LABEL_NOP_SIZE		AARCH64_INSN_SIZE
=20
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key, boo=
l branch)
 {
 	asm goto("1: nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 ".align 3\n\t"
 		 ".quad 1b, %l[l_yes], %c0\n\t"
 		 ".popsection\n\t"
-		 :  :  "i"(key) :  : l_yes);
+		 :  :  "i"(&((char *)key)[branch]) :  : l_yes);
=20
 	return false;
 l_yes:
 	return true;
 }
=20
-#endif /* __KERNEL__ */
+static __always_inline bool arch_static_branch_jump(struct static_key *key=
, bool branch)
+{
+	asm goto("1: b %l[l_yes]\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".align 3\n\t"
+		 ".quad 1b, %l[l_yes], %c0\n\t"
+		 ".popsection\n\t"
+		 :  :  "i"(&((char *)key)[branch]) :  : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
=20
 typedef u64 jump_label_t;
=20
@@ -49,4 +62,5 @@ struct jump_entry {
 	jump_label_t key;
 };
=20
+#endif  /* __ASSEMBLY__ */
 #endif	/* __ASM_JUMP_LABEL_H */
diff --git a/arch/arm64/kernel/jump_label.c b/arch/arm64/kernel/jump_label.c
index 263a166291fb..df23752b4f50 100644
--- a/arch/arm64/kernel/jump_label.c
+++ b/arch/arm64/kernel/jump_label.c
@@ -29,7 +29,7 @@ static void __arch_jump_label_transform(struct jump_entry=
 *entry,
 	void *addr =3D (void *)entry->code;
 	u32 insn;
=20
-	if (type =3D=3D JUMP_LABEL_ENABLE) {
+	if (type =3D=3D JUMP_LABEL_JMP) {
 		insn =3D aarch64_insn_gen_branch_imm(entry->code,
 						   entry->target,
 						   AARCH64_INSN_BRANCH_NOLINK);
diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jum=
p_label.h
index e194f957ca8c..e77672539e8e 100644
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -8,9 +8,9 @@
 #ifndef _ASM_MIPS_JUMP_LABEL_H
 #define _ASM_MIPS_JUMP_LABEL_H
=20
-#include <linux/types.h>
+#ifndef __ASSEMBLY__
=20
-#ifdef __KERNEL__
+#include <linux/types.h>
=20
 #define JUMP_LABEL_NOP_SIZE 4
=20
@@ -20,20 +20,39 @@
 #define WORD_INSN ".word"
 #endif
=20
-static __always_inline bool arch_static_branch(struct static_key *key)
+#ifdef CONFIG_CPU_MICROMIPS
+#define NOP_INSN "nop32"
+#else
+#define NOP_INSN "nop"
+#endif
+
+static __always_inline bool arch_static_branch(struct static_key *key, boo=
l branch)
 {
-	asm_volatile_goto("1:\tnop\n\t"
+	asm_volatile_goto("1:\t" NOP_INSN "\n\t"
 		"nop\n\t"
 		".pushsection __jump_table,  \"aw\"\n\t"
 		WORD_INSN " 1b, %l[l_yes], %0\n\t"
 		".popsection\n\t"
-		: :  "i" (key) : : l_yes);
+		: :  "i" (&((char *)key)[branch]) : : l_yes);
+
 	return false;
 l_yes:
 	return true;
 }
=20
-#endif /* __KERNEL__ */
+static __always_inline bool arch_static_branch_jump(struct static_key *key=
, bool branch)
+{
+	asm_volatile_goto("1:\tj %l[l_yes]\n\t"
+		"nop\n\t"
+		".pushsection __jump_table,  \"aw\"\n\t"
+		WORD_INSN " 1b, %l[l_yes], %0\n\t"
+		".popsection\n\t"
+		: :  "i" (&((char *)key)[branch]) : : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
=20
 #ifdef CONFIG_64BIT
 typedef u64 jump_label_t;
@@ -47,4 +66,5 @@ struct jump_entry {
 	jump_label_t key;
 };
=20
+#endif  /* __ASSEMBLY__ */
 #endif /* _ASM_MIPS_JUMP_LABEL_H */
diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 6001610cfe55..3e586daa3a32 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -18,31 +18,53 @@
=20
 #ifdef HAVE_JUMP_LABEL
=20
-#define J_RANGE_MASK ((1ul << 28) - 1)
+/*
+ * Define parameters for the standard MIPS and the microMIPS jump
+ * instruction encoding respectively:
+ *
+ * - the ISA bit of the target, either 0 or 1 respectively,
+ *
+ * - the amount the jump target address is shifted right to fit in the
+ *   immediate field of the machine instruction, either 2 or 1,
+ *
+ * - the mask determining the size of the jump region relative to the
+ *   delay-slot instruction, either 256MB or 128MB,
+ *
+ * - the jump target alignment, either 4 or 2 bytes.
+ */
+#define J_ISA_BIT	IS_ENABLED(CONFIG_CPU_MICROMIPS)
+#define J_RANGE_SHIFT	(2 - J_ISA_BIT)
+#define J_RANGE_MASK	((1ul << (26 + J_RANGE_SHIFT)) - 1)
+#define J_ALIGN_MASK	((1ul << J_RANGE_SHIFT) - 1)
=20
 void arch_jump_label_transform(struct jump_entry *e,
 			       enum jump_label_type type)
 {
+	union mips_instruction *insn_p;
 	union mips_instruction insn;
-	union mips_instruction *insn_p =3D
-		(union mips_instruction *)(unsigned long)e->code;
=20
-	/* Jump only works within a 256MB aligned region. */
-	BUG_ON((e->target & ~J_RANGE_MASK) !=3D (e->code & ~J_RANGE_MASK));
+	insn_p =3D (union mips_instruction *)msk_isa16_mode(e->code);
+
+	/* Jump only works within an aligned region its delay slot is in. */
+	BUG_ON((e->target & ~J_RANGE_MASK) !=3D ((e->code + 4) & ~J_RANGE_MASK));
=20
-	/* Target must have 4 byte alignment. */
-	BUG_ON((e->target & 3) !=3D 0);
+	/* Target must have the right alignment and ISA must be preserved. */
+	BUG_ON((e->target & J_ALIGN_MASK) !=3D J_ISA_BIT);
=20
-	if (type =3D=3D JUMP_LABEL_ENABLE) {
-		insn.j_format.opcode =3D j_op;
-		insn.j_format.target =3D (e->target & J_RANGE_MASK) >> 2;
+	if (type =3D=3D JUMP_LABEL_JMP) {
+		insn.j_format.opcode =3D J_ISA_BIT ? mm_j32_op : j_op;
+		insn.j_format.target =3D e->target >> J_RANGE_SHIFT;
 	} else {
 		insn.word =3D 0; /* nop */
 	}
=20
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	*insn_p =3D insn;
+	if (IS_ENABLED(CONFIG_CPU_MICROMIPS)) {
+		insn_p->halfword[0] =3D insn.word >> 16;
+		insn_p->halfword[1] =3D insn.word;
+	} else
+		*insn_p =3D insn;
=20
 	flush_icache_range((unsigned long)insn_p,
 			   (unsigned long)insn_p + sizeof(*insn_p));
diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include/a=
sm/jump_label.h
index f016bb699b5f..9bbb8ef11ab5 100644
--- a/arch/powerpc/include/asm/jump_label.h
+++ b/arch/powerpc/include/asm/jump_label.h
@@ -17,14 +17,29 @@
 #define JUMP_ENTRY_TYPE		stringify_in_c(FTR_ENTRY_LONG)
 #define JUMP_LABEL_NOP_SIZE	4
=20
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key, boo=
l branch)
 {
 	asm_volatile_goto("1:\n\t"
 		 "nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
 		 ".popsection \n\t"
-		 : :  "i" (key) : : l_yes);
+		 : :  "i" (&((char *)key)[branch]) : : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
+
+static __always_inline bool arch_static_branch_jump(struct static_key *key=
, bool branch)
+{
+	asm_volatile_goto("1:\n\t"
+		 "b %l[l_yes]\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
+		 ".popsection \n\t"
+		 : :  "i" (&((char *)key)[branch]) : : l_yes);
+
 	return false;
 l_yes:
 	return true;
diff --git a/arch/powerpc/kernel/jump_label.c b/arch/powerpc/kernel/jump_la=
bel.c
index a1ed8a8c7cb4..6472472093d0 100644
--- a/arch/powerpc/kernel/jump_label.c
+++ b/arch/powerpc/kernel/jump_label.c
@@ -17,7 +17,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 {
 	u32 *addr =3D (u32 *)(unsigned long)entry->code;
=20
-	if (type =3D=3D JUMP_LABEL_ENABLE)
+	if (type =3D=3D JUMP_LABEL_JMP)
 		patch_branch(addr, entry->target, 0);
 	else
 		patch_instruction(addr, PPC_INST_NOP);
diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jum=
p_label.h
index 346b1c85ffb4..790ddca29531 100644
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -1,9 +1,12 @@
 #ifndef _ASM_S390_JUMP_LABEL_H
 #define _ASM_S390_JUMP_LABEL_H
=20
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
=20
 #define JUMP_LABEL_NOP_SIZE 6
+#define JUMP_LABEL_NOP_OFFSET 2
=20
 #ifdef CONFIG_64BIT
 #define ASM_PTR ".quad"
@@ -13,14 +16,33 @@
 #define ASM_ALIGN ".balign 4"
 #endif
=20
-static __always_inline bool arch_static_branch(struct static_key *key)
+/*
+ * We use a brcl 0,2 instruction for jump labels at compile time so it
+ * can be easily distinguished from a hotpatch generated instruction.
+ */
+static __always_inline bool arch_static_branch(struct static_key *key, boo=
l branch)
 {
-	asm_volatile_goto("0:	brcl 0,0\n"
+	asm_volatile_goto("0:	brcl 0,"__stringify(JUMP_LABEL_NOP_OFFSET)"\n"
 		".pushsection __jump_table, \"aw\"\n"
 		ASM_ALIGN "\n"
 		ASM_PTR " 0b, %l[label], %0\n"
 		".popsection\n"
-		: : "X" (key) : : label);
+		: : "X" (&((char *)key)[branch]) : : label);
+
+	return false;
+label:
+	return true;
+}
+
+static __always_inline bool arch_static_branch_jump(struct static_key *key=
, bool branch)
+{
+	asm_volatile_goto("0:	brcl 15, %l[label]\n"
+		".pushsection __jump_table, \"aw\"\n"
+		ASM_ALIGN "\n"
+		ASM_PTR " 0b, %l[label], %0\n"
+		".popsection\n"
+		: : "X" (&((char *)key)[branch]) : : label);
+
 	return false;
 label:
 	return true;
@@ -34,4 +56,5 @@ struct jump_entry {
 	jump_label_t key;
 };
=20
+#endif  /* __ASSEMBLY__ */
 #endif
diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index b987ab2c1541..e66c0896a32d 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -22,31 +22,66 @@ struct insn_args {
 	enum jump_label_type type;
 };
=20
+static void jump_label_make_nop(struct jump_entry *entry, struct insn *ins=
n)
+{
+	/* brcl 0,0 */
+	insn->opcode =3D 0xc004;
+	insn->offset =3D 0;
+}
+
+static void jump_label_make_branch(struct jump_entry *entry, struct insn *=
insn)
+{
+	/* brcl 15,offset */
+	insn->opcode =3D 0xc0f4;
+	insn->offset =3D (entry->target - entry->code) >> 1;
+}
+
+static void jump_label_bug(struct jump_entry *entry, struct insn *insn)
+{
+	unsigned char *ipc =3D (unsigned char *)entry->code;
+	unsigned char *ipe =3D (unsigned char *)insn;
+
+	pr_emerg("Jump label code mismatch at %pS [%p]\n", ipc, ipc);
+	pr_emerg("Found:    %02x %02x %02x %02x %02x %02x\n",
+		 ipc[0], ipc[1], ipc[2], ipc[3], ipc[4], ipc[5]);
+	pr_emerg("Expected: %02x %02x %02x %02x %02x %02x\n",
+		 ipe[0], ipe[1], ipe[2], ipe[3], ipe[4], ipe[5]);
+	panic("Corrupted kernel text");
+}
+
+static struct insn orignop =3D {
+	.opcode =3D 0xc004,
+	.offset =3D JUMP_LABEL_NOP_OFFSET >> 1,
+};
+
 static void __jump_label_transform(struct jump_entry *entry,
-				   enum jump_label_type type)
+				   enum jump_label_type type,
+				   int init)
 {
-	struct insn insn;
-	int rc;
+	struct insn old, new;
=20
-	if (type =3D=3D JUMP_LABEL_ENABLE) {
-		/* brcl 15,offset */
-		insn.opcode =3D 0xc0f4;
-		insn.offset =3D (entry->target - entry->code) >> 1;
+	if (type =3D=3D JUMP_LABEL_JMP) {
+		jump_label_make_nop(entry, &old);
+		jump_label_make_branch(entry, &new);
 	} else {
-		/* brcl 0,0 */
-		insn.opcode =3D 0xc004;
-		insn.offset =3D 0;
+		jump_label_make_branch(entry, &old);
+		jump_label_make_nop(entry, &new);
 	}
-
-	rc =3D probe_kernel_write((void *)entry->code, &insn, JUMP_LABEL_NOP_SIZE=
);
-	WARN_ON_ONCE(rc < 0);
+	if (init) {
+		if (memcmp((void *)entry->code, &orignop, sizeof(orignop)))
+			jump_label_bug(entry, &old);
+	} else {
+		if (memcmp((void *)entry->code, &old, sizeof(old)))
+			jump_label_bug(entry, &old);
+	}
+	probe_kernel_write((void *)entry->code, &new, sizeof(new));
 }
=20
 static int __sm_arch_jump_label_transform(void *data)
 {
 	struct insn_args *args =3D data;
=20
-	__jump_label_transform(args->entry, args->type);
+	__jump_label_transform(args->entry, args->type, 0);
 	return 0;
 }
=20
@@ -64,7 +99,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 void arch_jump_label_transform_static(struct jump_entry *entry,
 				      enum jump_label_type type)
 {
-	__jump_label_transform(entry, type);
+	__jump_label_transform(entry, type, 1);
 }
=20
 #endif
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/j=
ump_label.h
index ec2e2e2aba7d..62d0354d1727 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -1,28 +1,43 @@
 #ifndef _ASM_SPARC_JUMP_LABEL_H
 #define _ASM_SPARC_JUMP_LABEL_H
=20
-#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
=20
 #include <linux/types.h>
=20
 #define JUMP_LABEL_NOP_SIZE 4
=20
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key, boo=
l branch)
 {
-		asm_volatile_goto("1:\n\t"
-			 "nop\n\t"
-			 "nop\n\t"
-			 ".pushsection __jump_table,  \"aw\"\n\t"
-			 ".align 4\n\t"
-			 ".word 1b, %l[l_yes], %c0\n\t"
-			 ".popsection \n\t"
-			 : :  "i" (key) : : l_yes);
+	asm_volatile_goto("1:\n\t"
+		 "nop\n\t"
+		 "nop\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".align 4\n\t"
+		 ".word 1b, %l[l_yes], %c0\n\t"
+		 ".popsection \n\t"
+		 : :  "i" (&((char *)key)[branch]) : : l_yes);
+
 	return false;
 l_yes:
 	return true;
 }
=20
-#endif /* __KERNEL__ */
+static __always_inline bool arch_static_branch_jump(struct static_key *key=
, bool branch)
+{
+	asm_volatile_goto("1:\n\t"
+		 "b %l[l_yes]\n\t"
+		 "nop\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".align 4\n\t"
+		 ".word 1b, %l[l_yes], %c0\n\t"
+		 ".popsection \n\t"
+		 : :  "i" (&((char *)key)[branch]) : : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
=20
 typedef u32 jump_label_t;
=20
@@ -32,4 +47,5 @@ struct jump_entry {
 	jump_label_t key;
 };
=20
+#endif  /* __ASSEMBLY__ */
 #endif
diff --git a/arch/sparc/kernel/jump_label.c b/arch/sparc/kernel/jump_label.c
index 48565c11e82a..59bbeff55024 100644
--- a/arch/sparc/kernel/jump_label.c
+++ b/arch/sparc/kernel/jump_label.c
@@ -16,7 +16,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	u32 val;
 	u32 *insn =3D (u32 *) (unsigned long) entry->code;
=20
-	if (type =3D=3D JUMP_LABEL_ENABLE) {
+	if (type =3D=3D JUMP_LABEL_JMP) {
 		s32 off =3D (s32)entry->target - (s32)entry->code;
=20
 #ifdef CONFIG_SPARC64
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 22512bbc5a41..9ae6b38b8361 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -798,13 +798,7 @@ config NR_CPUS
 	  approximately eight kilobytes to the kernel image.
=20
 config SCHED_SMT
-	bool "SMT (Hyperthreading) scheduler support"
-	depends on X86_HT
-	---help---
-	  SMT scheduler support improves the CPU scheduler's decision making
-	  when dealing with Intel Pentium 4 chips with HyperThreading at a
-	  cost of slightly increased overhead in some places. If unsure say
-	  N here.
+	def_bool y if SMP
=20
 config SCHED_MC
 	def_bool y
diff --git a/arch/x86/boot/cpuflags.h b/arch/x86/boot/cpuflags.h
index ea97697e51e4..4cb404fd45ce 100644
--- a/arch/x86/boot/cpuflags.h
+++ b/arch/x86/boot/cpuflags.h
@@ -1,7 +1,7 @@
 #ifndef BOOT_CPUFLAGS_H
 #define BOOT_CPUFLAGS_H
=20
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/processor-flags.h>
=20
 struct cpu_features {
diff --git a/arch/x86/boot/mkcpustr.c b/arch/x86/boot/mkcpustr.c
index 4579eff0ef4d..43574c2c363a 100644
--- a/arch/x86/boot/mkcpustr.c
+++ b/arch/x86/boot/mkcpustr.c
@@ -16,7 +16,7 @@
 #include <stdio.h>
=20
 #include "../include/asm/required-features.h"
-#include "../include/asm/cpufeature.h"
+#include "../include/asm/cpufeatures.h"
 #include "../kernel/cpu/capflags.c"
=20
 int main(void)
diff --git a/arch/x86/crypto/crc32-pclmul_glue.c b/arch/x86/crypto/crc32-pc=
lmul_glue.c
index 0072dd30dd12..6add897d152f 100644
--- a/arch/x86/crypto/crc32-pclmul_glue.c
+++ b/arch/x86/crypto/crc32-pclmul_glue.c
@@ -33,7 +33,7 @@
 #include <linux/crc32.h>
 #include <crypto/internal/hash.h>
=20
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/cpu_device_id.h>
 #include <asm/i387.h>
=20
diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-i=
ntel_glue.c
index c743444b9274..a74eb081f95f 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -30,7 +30,7 @@
 #include <linux/kernel.h>
 #include <crypto/internal/hash.h>
=20
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/cpu_device_id.h>
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct=
10dif-pclmul_glue.c
index b6c67bf30fdf..13dbd3515256 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -30,7 +30,7 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <asm/i387.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/cpu_device_id.h>
=20
 asmlinkage __u16 crc_t10dif_pcl(__u16 crc, const unsigned char *buf,
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 6f98ae2646cf..2f7c40aabf25 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -188,6 +188,7 @@ ENTRY(ia32_sysenter_target)
 	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz	sysexit_audit
 sysexit_from_sys_call:
+	MDS_USER_CLEAR_CPU_BUFFERS
 	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl  $~0x200,EFLAGS-R11(%rsp)=20
@@ -362,6 +363,7 @@ ENTRY(ia32_cstar_target)
 	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz sysretl_audit
 sysretl_from_sys_call:
+	MDS_USER_CLEAR_CPU_BUFFERS
 	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	RESTORE_ARGS 0,-ARG_SKIP,0,0,0
 	movl RIP-ARGOFFSET(%rsp),%ecx
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alte=
rnative.h
index a455de2f9aaf..557b1da2c430 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -147,12 +147,6 @@ static inline int alternatives_text_reserved(void *sta=
rt, void *end)
 	ALTINSTR_REPLACEMENT(newinstr2, feature2, 2)			\
 	".popsection\n"
=20
-/*
- * This must be included *after* the definition of ALTERNATIVE due to
- * <asm/arch_hweight.h>
- */
-#include <asm/cpufeature.h>
-
 /*
  * Alternative instructions for different CPU types or capabilities.
  *
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index d98aa3bb133c..bcb27e90bc49 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -6,7 +6,6 @@
=20
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
-#include <asm/processor.h>
 #include <asm/apicdef.h>
 #include <linux/atomic.h>
 #include <asm/fixmap.h>
diff --git a/arch/x86/include/asm/arch_hweight.h b/arch/x86/include/asm/arc=
h_hweight.h
index 9686c3d9ff73..d0fb5321d079 100644
--- a/arch/x86/include/asm/arch_hweight.h
+++ b/arch/x86/include/asm/arch_hweight.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_HWEIGHT_H
 #define _ASM_X86_HWEIGHT_H
=20
+#include <asm/cpufeatures.h>
+
 #ifdef CONFIG_64BIT
 /* popcnt %edi, %eax -- redundant REX prefix for alignment */
 #define POPCNT32 ".byte 0xf3,0x40,0x0f,0xb8,0xc7"
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 6dd1c7dd0473..2888394200d6 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -3,7 +3,6 @@
=20
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <asm/processor.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 #include <asm/rmwcc.h>
diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atom=
ic64_32.h
index b154de75c90c..1af99f6bc9a1 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -3,7 +3,6 @@
=20
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <asm/processor.h>
 //#include <asm/cmpxchg.h>
=20
 /* An 64bit atomic type */
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 2666f2142b15..4c8f35c2b924 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -3,6 +3,7 @@
=20
 #include <asm/alternative.h>
 #include <asm/nops.h>
+#include <asm/cpufeatures.h>
=20
 /*
  * Force strict CPU ordering.
diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index d47786acb016..0489ae7f0ac6 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -2,6 +2,7 @@
 #define ASM_X86_CMPXCHG_H
=20
 #include <linux/compiler.h>
+#include <asm/cpufeatures.h>
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
=20
 /*
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufe=
ature.h
index 9bb2ef93a7dc..ac76ed727ae4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -4,277 +4,7 @@
 #ifndef _ASM_X86_CPUFEATURE_H
 #define _ASM_X86_CPUFEATURE_H
=20
-#ifndef _ASM_X86_REQUIRED_FEATURES_H
-#include <asm/required-features.h>
-#endif
-
-#define NCAPINTS	12	/* N 32-bit words worth of info */
-#define NBUGINTS	1	/* N 32-bit bug flags */
-
-/*
- * Note: If the comment begins with a quoted string, that string is used
- * in /proc/cpuinfo instead of the macro name.  If the string is "",
- * this feature bit is not displayed in /proc/cpuinfo at all.
- */
-
-/* Intel-defined CPU features, CPUID level 0x00000001 (edx), word 0 */
-#define X86_FEATURE_FPU		(0*32+ 0) /* Onboard FPU */
-#define X86_FEATURE_VME		(0*32+ 1) /* Virtual Mode Extensions */
-#define X86_FEATURE_DE		(0*32+ 2) /* Debugging Extensions */
-#define X86_FEATURE_PSE		(0*32+ 3) /* Page Size Extensions */
-#define X86_FEATURE_TSC		(0*32+ 4) /* Time Stamp Counter */
-#define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers */
-#define X86_FEATURE_PAE		(0*32+ 6) /* Physical Address Extensions */
-#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Exception */
-#define X86_FEATURE_CX8		(0*32+ 8) /* CMPXCHG8 instruction */
-#define X86_FEATURE_APIC	(0*32+ 9) /* Onboard APIC */
-#define X86_FEATURE_SEP		(0*32+11) /* SYSENTER/SYSEXIT */
-#define X86_FEATURE_MTRR	(0*32+12) /* Memory Type Range Registers */
-#define X86_FEATURE_PGE		(0*32+13) /* Page Global Enable */
-#define X86_FEATURE_MCA		(0*32+14) /* Machine Check Architecture */
-#define X86_FEATURE_CMOV	(0*32+15) /* CMOV instructions */
-					  /* (plus FCMOVcc, FCOMI with FPU) */
-#define X86_FEATURE_PAT		(0*32+16) /* Page Attribute Table */
-#define X86_FEATURE_PSE36	(0*32+17) /* 36-bit PSEs */
-#define X86_FEATURE_PN		(0*32+18) /* Processor serial number */
-#define X86_FEATURE_CLFLUSH	(0*32+19) /* CLFLUSH instruction */
-#define X86_FEATURE_DS		(0*32+21) /* "dts" Debug Store */
-#define X86_FEATURE_ACPI	(0*32+22) /* ACPI via MSR */
-#define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
-#define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE/FXRSTOR, CR4.OSFXSR */
-#define X86_FEATURE_XMM		(0*32+25) /* "sse" */
-#define X86_FEATURE_XMM2	(0*32+26) /* "sse2" */
-#define X86_FEATURE_SELFSNOOP	(0*32+27) /* "ss" CPU self snoop */
-#define X86_FEATURE_HT		(0*32+28) /* Hyper-Threading */
-#define X86_FEATURE_ACC		(0*32+29) /* "tm" Automatic clock control */
-#define X86_FEATURE_IA64	(0*32+30) /* IA-64 processor */
-#define X86_FEATURE_PBE		(0*32+31) /* Pending Break Enable */
-
-/* AMD-defined CPU features, CPUID level 0x80000001, word 1 */
-/* Don't duplicate feature flags which are redundant with Intel! */
-#define X86_FEATURE_SYSCALL	(1*32+11) /* SYSCALL/SYSRET */
-#define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
-#define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
-#define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
-#define X86_FEATURE_FXSR_OPT	(1*32+25) /* FXSAVE/FXRSTOR optimizations */
-#define X86_FEATURE_GBPAGES	(1*32+26) /* "pdpe1gb" GB pages */
-#define X86_FEATURE_RDTSCP	(1*32+27) /* RDTSCP */
-#define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
-#define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
-#define X86_FEATURE_3DNOW	(1*32+31) /* 3DNow! */
-
-/* Transmeta-defined CPU features, CPUID level 0x80860001, word 2 */
-#define X86_FEATURE_RECOVERY	(2*32+ 0) /* CPU in recovery mode */
-#define X86_FEATURE_LONGRUN	(2*32+ 1) /* Longrun power control */
-#define X86_FEATURE_LRTI	(2*32+ 3) /* LongRun table interface */
-
-/* Other features, Linux-defined mapping, word 3 */
-/* This range is used for feature bits which conflict or are synthesized */
-#define X86_FEATURE_CXMMX	(3*32+ 0) /* Cyrix MMX extensions */
-#define X86_FEATURE_K6_MTRR	(3*32+ 1) /* AMD K6 nonstandard MTRRs */
-#define X86_FEATURE_CYRIX_ARR	(3*32+ 2) /* Cyrix ARRs (=3D MTRRs) */
-#define X86_FEATURE_CENTAUR_MCR	(3*32+ 3) /* Centaur MCRs (=3D MTRRs) */
-/* cpu types for specific tunings: */
-#define X86_FEATURE_K8		(3*32+ 4) /* "" Opteron, Athlon64 */
-#define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
-#define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
-#define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
-#define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate=
 */
-#define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
-#define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
-#define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon =
*/
-#define X86_FEATURE_PEBS	(3*32+12) /* Precise-Event Based Sampling */
-#define X86_FEATURE_BTS		(3*32+13) /* Branch Trace Store */
-#define X86_FEATURE_SYSCALL32	(3*32+14) /* "" syscall in ia32 userspace */
-#define X86_FEATURE_SYSENTER32	(3*32+15) /* "" sysenter in ia32 userspace =
*/
-#define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well */
-#define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* "" Mfence synchronizes RDTSC=
 */
-#define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC=
 */
-#define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
-#define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-#define X86_FEATURE_ALWAYS	(3*32+21) /* "" Always-present feature */
-#define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
-#define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable =
*/
-#define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states=
 */
-#define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with moni=
tor */
-#define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) =
*/
-#define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
-#define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
-#define X86_FEATURE_EAGER_FPU	(3*32+29) /* "eagerfpu" Non lazy FPU restore=
 */
-#define X86_FEATURE_NONSTOP_TSC_S3 (3*32+30) /* TSC doesn't stop in S3 sta=
te */
-
-/* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
-#define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
-#define X86_FEATURE_PCLMULQDQ	(4*32+ 1) /* PCLMULQDQ instruction */
-#define X86_FEATURE_DTES64	(4*32+ 2) /* 64-bit Debug Store */
-#define X86_FEATURE_MWAIT	(4*32+ 3) /* "monitor" Monitor/Mwait support */
-#define X86_FEATURE_DSCPL	(4*32+ 4) /* "ds_cpl" CPL Qual. Debug Store */
-#define X86_FEATURE_VMX		(4*32+ 5) /* Hardware virtualization */
-#define X86_FEATURE_SMX		(4*32+ 6) /* Safer mode */
-#define X86_FEATURE_EST		(4*32+ 7) /* Enhanced SpeedStep */
-#define X86_FEATURE_TM2		(4*32+ 8) /* Thermal Monitor 2 */
-#define X86_FEATURE_SSSE3	(4*32+ 9) /* Supplemental SSE-3 */
-#define X86_FEATURE_CID		(4*32+10) /* Context ID */
-#define X86_FEATURE_FMA		(4*32+12) /* Fused multiply-add */
-#define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
-#define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
-#define X86_FEATURE_PDCM	(4*32+15) /* Performance Capabilities */
-#define X86_FEATURE_PCID	(4*32+17) /* Process Context Identifiers */
-#define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
-#define X86_FEATURE_XMM4_1	(4*32+19) /* "sse4_1" SSE-4.1 */
-#define X86_FEATURE_XMM4_2	(4*32+20) /* "sse4_2" SSE-4.2 */
-#define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
-#define X86_FEATURE_MOVBE	(4*32+22) /* MOVBE instruction */
-#define X86_FEATURE_POPCNT      (4*32+23) /* POPCNT instruction */
-#define X86_FEATURE_TSC_DEADLINE_TIMER	(4*32+24) /* Tsc deadline timer */
-#define X86_FEATURE_AES		(4*32+25) /* AES instructions */
-#define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
-#define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
-#define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
-#define X86_FEATURE_F16C	(4*32+29) /* 16-bit fp conversions */
-#define X86_FEATURE_RDRAND	(4*32+30) /* The RDRAND instruction */
-#define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */
-
-/* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 =
*/
-#define X86_FEATURE_XSTORE	(5*32+ 2) /* "rng" RNG present (xstore) */
-#define X86_FEATURE_XSTORE_EN	(5*32+ 3) /* "rng_en" RNG enabled */
-#define X86_FEATURE_XCRYPT	(5*32+ 6) /* "ace" on-CPU crypto (xcrypt) */
-#define X86_FEATURE_XCRYPT_EN	(5*32+ 7) /* "ace_en" on-CPU crypto enabled =
*/
-#define X86_FEATURE_ACE2	(5*32+ 8) /* Advanced Cryptography Engine v2 */
-#define X86_FEATURE_ACE2_EN	(5*32+ 9) /* ACE v2 enabled */
-#define X86_FEATURE_PHE		(5*32+10) /* PadLock Hash Engine */
-#define X86_FEATURE_PHE_EN	(5*32+11) /* PHE enabled */
-#define X86_FEATURE_PMM		(5*32+12) /* PadLock Montgomery Multiplier */
-#define X86_FEATURE_PMM_EN	(5*32+13) /* PMM enabled */
-
-/* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
-#define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
-#define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not vali=
d */
-#define X86_FEATURE_SVM		(6*32+ 2) /* Secure virtual machine */
-#define X86_FEATURE_EXTAPIC	(6*32+ 3) /* Extended APIC space */
-#define X86_FEATURE_CR8_LEGACY	(6*32+ 4) /* CR8 in 32-bit mode */
-#define X86_FEATURE_ABM		(6*32+ 5) /* Advanced bit manipulation */
-#define X86_FEATURE_SSE4A	(6*32+ 6) /* SSE-4A */
-#define X86_FEATURE_MISALIGNSSE (6*32+ 7) /* Misaligned SSE mode */
-#define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions=
 */
-#define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
-#define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
-#define X86_FEATURE_XOP		(6*32+11) /* extended AVX instructions */
-#define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
-#define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
-#define X86_FEATURE_LWP		(6*32+15) /* Light Weight Profiling */
-#define X86_FEATURE_FMA4	(6*32+16) /* 4 operands MAC instructions */
-#define X86_FEATURE_TCE		(6*32+17) /* translation cache extension */
-#define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
-#define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
-#define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
-#define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter ext=
ensions */
-#define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extens=
ions */
-#define X86_FEATURE_PERFCTR_L2	(6*32+28) /* L2 performance counter extensi=
ons */
-
-/*
- * Auxiliary flags: Linux defined - For features scattered in various
- * CPUID levels like 0x6, 0xA etc, word 7
- */
-#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
-#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
-#define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
-#define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
-#define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
-#define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
-#define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
-#define X86_FEATURE_DTHERM	(7*32+ 7) /* Digital Thermal Sensor */
-#define X86_FEATURE_HW_PSTATE	(7*32+ 8) /* AMD HW-PState */
-#define X86_FEATURE_PROC_FEEDBACK (7*32+ 9) /* AMD ProcFeedbackInterface */
-#define X86_FEATURE_INVPCID_SINGLE (7*32+10) /* Effectively INVPCID && CR4=
=2EPCIDE=3D1 */
-#define X86_FEATURE_RSB_CTXSW	(7*32+11) /* "" Fill RSB on context switches=
 */
-
-#define X86_FEATURE_USE_IBPB	(7*32+12) /* "" Indirect Branch Prediction Ba=
rrier enabled */
-#define X86_FEATURE_USE_IBRS_FW (7*32+13) /* "" Use IBRS during runtime fi=
rmware calls */
-#define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE (7*32+14) /* "" Disable Spec=
ulative Store Bypass. */
-#define X86_FEATURE_LS_CFG_SSBD	(7*32+15) /* "" AMD SSBD implementation */
-#define X86_FEATURE_IBRS	(7*32+16) /* Indirect Branch Restricted Speculati=
on */
-#define X86_FEATURE_IBPB	(7*32+17) /* Indirect Branch Prediction Barrier */
-#define X86_FEATURE_STIBP	(7*32+18) /* Single Thread Indirect Branch Predi=
ctors */
-#define X86_FEATURE_MSR_SPEC_CTRL (7*32+19) /* "" MSR SPEC_CTRL is impleme=
nted */
-#define X86_FEATURE_SSBD	(7*32+20) /* Speculative Store Bypass Disable */
-#define X86_FEATURE_ZEN		(7*32+21) /* "" CPU is AMD family 0x17 (Zen) */
-#define X86_FEATURE_L1TF_PTEINV	(7*32+22) /* "" L1TF workaround PTE invers=
ion */
-
-#define X86_FEATURE_RETPOLINE	(7*32+29) /* "" Generic Retpoline mitigation=
 for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_AMD (7*32+30) /* "" AMD Retpoline mitigation=
 for Spectre variant 2 */
-/* Because the ALTERNATIVE scheme is for members of the X86_FEATURE club..=
=2E */
-#define X86_FEATURE_KAISER	(7*32+31) /* CONFIG_PAGE_TABLE_ISOLATION w/o no=
kaiser */
-
-/* Virtualization flags: Linux defined, word 8 */
-#define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
-#define X86_FEATURE_VNMI        (8*32+ 1) /* Intel Virtual NMI */
-#define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
-#define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
-#define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
-#define X86_FEATURE_NPT		(8*32+ 5) /* AMD Nested Page Table support */
-#define X86_FEATURE_LBRV	(8*32+ 6) /* AMD LBR Virtualization support */
-#define X86_FEATURE_SVML	(8*32+ 7) /* "svm_lock" AMD SVM locking MSR */
-#define X86_FEATURE_NRIPS	(8*32+ 8) /* "nrip_save" AMD SVM next_rip save */
-#define X86_FEATURE_TSCRATEMSR  (8*32+ 9) /* "tsc_scale" AMD TSC scaling s=
upport */
-#define X86_FEATURE_VMCBCLEAN   (8*32+10) /* "vmcb_clean" AMD VMCB clean b=
its support */
-#define X86_FEATURE_FLUSHBYASID (8*32+11) /* AMD flush-by-ASID support */
-#define X86_FEATURE_DECODEASSISTS (8*32+12) /* AMD Decode Assists support =
*/
-#define X86_FEATURE_PAUSEFILTER (8*32+13) /* AMD filtered pause intercept =
*/
-#define X86_FEATURE_PFTHRESHOLD (8*32+14) /* AMD pause filter threshold */
-#define X86_FEATURE_VMMCALL     ( 8*32+15) /* Prefer vmmcall to vmcall */
-
-
-/* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
-#define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
-#define X86_FEATURE_TSC_ADJUST	(9*32+ 1) /* TSC adjustment MSR 0x3b */
-#define X86_FEATURE_BMI1	(9*32+ 3) /* 1st group bit manipulation extension=
s */
-#define X86_FEATURE_HLE		(9*32+ 4) /* Hardware Lock Elision */
-#define X86_FEATURE_AVX2	(9*32+ 5) /* AVX2 instructions */
-#define X86_FEATURE_SMEP	(9*32+ 7) /* Supervisor Mode Execution Protection=
 */
-#define X86_FEATURE_BMI2	(9*32+ 8) /* 2nd group bit manipulation extension=
s */
-#define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
-#define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
-#define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
-#define X86_FEATURE_MPX		(9*32+14) /* Memory Protection Extension */
-#define X86_FEATURE_AVX512F	(9*32+16) /* AVX-512 Foundation */
-#define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
-#define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
-#define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
-#define X86_FEATURE_CLFLUSHOPT	(9*32+23) /* CLFLUSHOPT instruction */
-#define X86_FEATURE_AVX512PF	(9*32+26) /* AVX-512 Prefetch */
-#define X86_FEATURE_AVX512ER	(9*32+27) /* AVX-512 Exponential and Reciproc=
al */
-#define X86_FEATURE_AVX512CD	(9*32+28) /* AVX-512 Conflict Detection */
-
-/* Intel-defined CPU features, CPUID level 0x00000007:0 (EDX), word 10 */
-#define X86_FEATURE_SPEC_CTRL		(10*32+26) /* "" Speculation Control (IBRS =
+ IBPB) */
-#define X86_FEATURE_INTEL_STIBP		(10*32+27) /* "" Single Thread Indirect B=
ranch Predictors */
-#define X86_FEATURE_ARCH_CAPABILITIES	(10*32+29) /* IA32_ARCH_CAPABILITIES=
 MSR (Intel) */
-#define X86_FEATURE_SPEC_CTRL_SSBD	(10*32+31) /* "" Speculative Store Bypa=
ss Disable */
-
-/* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 11 */
-#define X86_FEATURE_AMD_IBPB		(11*32+12) /* "" Indirect Branch Prediction =
Barrier */
-#define X86_FEATURE_AMD_IBRS		(11*32+14) /* "" Indirect Branch Restricted =
Speculation */
-#define X86_FEATURE_AMD_STIBP		(11*32+15) /* "" Single Thread Indirect Bra=
nch Predictors */
-#define X86_FEATURE_AMD_SSBD		(11*32+24) /* "" Speculative Store Bypass Di=
sable */
-#define X86_FEATURE_VIRT_SSBD		(11*32+25) /* Virtualized Speculative Store=
 Bypass Disable */
-#define X86_FEATURE_AMD_SSB_NO		(11*32+26) /* "" Speculative Store Bypass =
is fixed in hardware. */
-
-/*
- * BUG word(s)
- */
-#define X86_BUG(x)		(NCAPINTS*32 + (x))
-
-#define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
-#define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
-#define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
-#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
-#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* AMD Erratum 400 */
-#define X86_BUG_CPU_MELTDOWN	X86_BUG(5) /* CPU is affected by meltdown att=
ack and needs kernel page table isolation */
-#define X86_BUG_SPECTRE_V1	X86_BUG(6) /* CPU is affected by Spectre varian=
t 1 attack with conditional branches */
-#define X86_BUG_SPECTRE_V2	X86_BUG(7) /* CPU is affected by Spectre varian=
t 2 attack with indirect branches */
-#define X86_BUG_SPEC_STORE_BYPASS X86_BUG(8) /* CPU is affected by specula=
tive store bypass attack */
-#define X86_BUG_L1TF		X86_BUG(9) /* CPU is affected by L1 Terminal Fault */
+#include <asm/processor.h>
=20
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
=20
@@ -284,6 +14,12 @@
 extern const char * const x86_cap_flags[NCAPINTS*32];
 extern const char * const x86_power_flags[32];
=20
+/*
+ * In order to save room, we index into this array by doing
+ * X86_BUG_<name> - NCAPINTS*32.
+ */
+extern const char * const x86_bug_flags[NBUGINTS*32];
+
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
=20
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpuf=
eatures.h
new file mode 100644
index 000000000000..99137cbe34b8
--- /dev/null
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -0,0 +1,278 @@
+#ifndef _ASM_X86_CPUFEATURES_H
+#define _ASM_X86_CPUFEATURES_H
+
+#ifndef _ASM_X86_REQUIRED_FEATURES_H
+#include <asm/required-features.h>
+#endif
+
+#define NCAPINTS	12	/* N 32-bit words worth of info */
+#define NBUGINTS	1	/* N 32-bit bug flags */
+
+/*
+ * Note: If the comment begins with a quoted string, that string is used
+ * in /proc/cpuinfo instead of the macro name.  If the string is "",
+ * this feature bit is not displayed in /proc/cpuinfo at all.
+ */
+
+/* Intel-defined CPU features, CPUID level 0x00000001 (edx), word 0 */
+#define X86_FEATURE_FPU		( 0*32+ 0) /* Onboard FPU */
+#define X86_FEATURE_VME		( 0*32+ 1) /* Virtual Mode Extensions */
+#define X86_FEATURE_DE		( 0*32+ 2) /* Debugging Extensions */
+#define X86_FEATURE_PSE		( 0*32+ 3) /* Page Size Extensions */
+#define X86_FEATURE_TSC		( 0*32+ 4) /* Time Stamp Counter */
+#define X86_FEATURE_MSR		( 0*32+ 5) /* Model-Specific Registers */
+#define X86_FEATURE_PAE		( 0*32+ 6) /* Physical Address Extensions */
+#define X86_FEATURE_MCE		( 0*32+ 7) /* Machine Check Exception */
+#define X86_FEATURE_CX8		( 0*32+ 8) /* CMPXCHG8 instruction */
+#define X86_FEATURE_APIC	( 0*32+ 9) /* Onboard APIC */
+#define X86_FEATURE_SEP		( 0*32+11) /* SYSENTER/SYSEXIT */
+#define X86_FEATURE_MTRR	( 0*32+12) /* Memory Type Range Registers */
+#define X86_FEATURE_PGE		( 0*32+13) /* Page Global Enable */
+#define X86_FEATURE_MCA		( 0*32+14) /* Machine Check Architecture */
+#define X86_FEATURE_CMOV	( 0*32+15) /* CMOV instructions */
+					  /* (plus FCMOVcc, FCOMI with FPU) */
+#define X86_FEATURE_PAT		( 0*32+16) /* Page Attribute Table */
+#define X86_FEATURE_PSE36	( 0*32+17) /* 36-bit PSEs */
+#define X86_FEATURE_PN		( 0*32+18) /* Processor serial number */
+#define X86_FEATURE_CLFLUSH	( 0*32+19) /* CLFLUSH instruction */
+#define X86_FEATURE_DS		( 0*32+21) /* "dts" Debug Store */
+#define X86_FEATURE_ACPI	( 0*32+22) /* ACPI via MSR */
+#define X86_FEATURE_MMX		( 0*32+23) /* Multimedia Extensions */
+#define X86_FEATURE_FXSR	( 0*32+24) /* FXSAVE/FXRSTOR, CR4.OSFXSR */
+#define X86_FEATURE_XMM		( 0*32+25) /* "sse" */
+#define X86_FEATURE_XMM2	( 0*32+26) /* "sse2" */
+#define X86_FEATURE_SELFSNOOP	( 0*32+27) /* "ss" CPU self snoop */
+#define X86_FEATURE_HT		( 0*32+28) /* Hyper-Threading */
+#define X86_FEATURE_ACC		( 0*32+29) /* "tm" Automatic clock control */
+#define X86_FEATURE_IA64	( 0*32+30) /* IA-64 processor */
+#define X86_FEATURE_PBE		( 0*32+31) /* Pending Break Enable */
+
+/* AMD-defined CPU features, CPUID level 0x80000001, word 1 */
+/* Don't duplicate feature flags which are redundant with Intel! */
+#define X86_FEATURE_SYSCALL	( 1*32+11) /* SYSCALL/SYSRET */
+#define X86_FEATURE_MP		( 1*32+19) /* MP Capable. */
+#define X86_FEATURE_NX		( 1*32+20) /* Execute Disable */
+#define X86_FEATURE_MMXEXT	( 1*32+22) /* AMD MMX extensions */
+#define X86_FEATURE_FXSR_OPT	( 1*32+25) /* FXSAVE/FXRSTOR optimizations */
+#define X86_FEATURE_GBPAGES	( 1*32+26) /* "pdpe1gb" GB pages */
+#define X86_FEATURE_RDTSCP	( 1*32+27) /* RDTSCP */
+#define X86_FEATURE_LM		( 1*32+29) /* Long Mode (x86-64) */
+#define X86_FEATURE_3DNOWEXT	( 1*32+30) /* AMD 3DNow! extensions */
+#define X86_FEATURE_3DNOW	( 1*32+31) /* 3DNow! */
+
+/* Transmeta-defined CPU features, CPUID level 0x80860001, word 2 */
+#define X86_FEATURE_RECOVERY	( 2*32+ 0) /* CPU in recovery mode */
+#define X86_FEATURE_LONGRUN	( 2*32+ 1) /* Longrun power control */
+#define X86_FEATURE_LRTI	( 2*32+ 3) /* LongRun table interface */
+
+/* Other features, Linux-defined mapping, word 3 */
+/* This range is used for feature bits which conflict or are synthesized */
+#define X86_FEATURE_CXMMX	( 3*32+ 0) /* Cyrix MMX extensions */
+#define X86_FEATURE_K6_MTRR	( 3*32+ 1) /* AMD K6 nonstandard MTRRs */
+#define X86_FEATURE_CYRIX_ARR	( 3*32+ 2) /* Cyrix ARRs (=3D MTRRs) */
+#define X86_FEATURE_CENTAUR_MCR	( 3*32+ 3) /* Centaur MCRs (=3D MTRRs) */
+/* cpu types for specific tunings: */
+#define X86_FEATURE_K8		( 3*32+ 4) /* "" Opteron, Athlon64 */
+#define X86_FEATURE_K7		( 3*32+ 5) /* "" Athlon */
+#define X86_FEATURE_P3		( 3*32+ 6) /* "" P3 */
+#define X86_FEATURE_P4		( 3*32+ 7) /* "" P4 */
+#define X86_FEATURE_CONSTANT_TSC ( 3*32+ 8) /* TSC ticks at a constant rat=
e */
+#define X86_FEATURE_UP		( 3*32+ 9) /* smp kernel running on up */
+#define X86_FEATURE_FXSAVE_LEAK ( 3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP =
*/
+#define X86_FEATURE_ARCH_PERFMON ( 3*32+11) /* Intel Architectural PerfMon=
 */
+#define X86_FEATURE_PEBS	( 3*32+12) /* Precise-Event Based Sampling */
+#define X86_FEATURE_BTS		( 3*32+13) /* Branch Trace Store */
+#define X86_FEATURE_SYSCALL32	( 3*32+14) /* "" syscall in ia32 userspace */
+#define X86_FEATURE_SYSENTER32	( 3*32+15) /* "" sysenter in ia32 userspace=
 */
+#define X86_FEATURE_REP_GOOD	( 3*32+16) /* rep microcode works well */
+#define X86_FEATURE_MFENCE_RDTSC ( 3*32+17) /* "" Mfence synchronizes RDTS=
C */
+#define X86_FEATURE_LFENCE_RDTSC ( 3*32+18) /* "" Lfence synchronizes RDTS=
C */
+#define X86_FEATURE_11AP	( 3*32+19) /* "" Bad local APIC aka 11AP */
+#define X86_FEATURE_NOPL	( 3*32+20) /* The NOPL (0F 1F) instructions */
+#define X86_FEATURE_ALWAYS	( 3*32+21) /* "" Always-present feature */
+#define X86_FEATURE_XTOPOLOGY	( 3*32+22) /* cpu topology enum extensions */
+#define X86_FEATURE_TSC_RELIABLE ( 3*32+23) /* TSC is known to be reliable=
 */
+#define X86_FEATURE_NONSTOP_TSC	( 3*32+24) /* TSC does not stop in C state=
s */
+#define X86_FEATURE_CLFLUSH_MONITOR ( 3*32+25) /* "" clflush reqd with mon=
itor */
+#define X86_FEATURE_EXTD_APICID	( 3*32+26) /* has extended APICID (8 bits)=
 */
+#define X86_FEATURE_AMD_DCM     ( 3*32+27) /* multi-node processor */
+#define X86_FEATURE_APERFMPERF	( 3*32+28) /* APERFMPERF */
+#define X86_FEATURE_EAGER_FPU	( 3*32+29) /* "eagerfpu" Non lazy FPU restor=
e */
+#define X86_FEATURE_NONSTOP_TSC_S3 ( 3*32+30) /* TSC doesn't stop in S3 st=
ate */
+
+/* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
+#define X86_FEATURE_XMM3	( 4*32+ 0) /* "pni" SSE-3 */
+#define X86_FEATURE_PCLMULQDQ	( 4*32+ 1) /* PCLMULQDQ instruction */
+#define X86_FEATURE_DTES64	( 4*32+ 2) /* 64-bit Debug Store */
+#define X86_FEATURE_MWAIT	( 4*32+ 3) /* "monitor" Monitor/Mwait support */
+#define X86_FEATURE_DSCPL	( 4*32+ 4) /* "ds_cpl" CPL Qual. Debug Store */
+#define X86_FEATURE_VMX		( 4*32+ 5) /* Hardware virtualization */
+#define X86_FEATURE_SMX		( 4*32+ 6) /* Safer mode */
+#define X86_FEATURE_EST		( 4*32+ 7) /* Enhanced SpeedStep */
+#define X86_FEATURE_TM2		( 4*32+ 8) /* Thermal Monitor 2 */
+#define X86_FEATURE_SSSE3	( 4*32+ 9) /* Supplemental SSE-3 */
+#define X86_FEATURE_CID		( 4*32+10) /* Context ID */
+#define X86_FEATURE_FMA		( 4*32+12) /* Fused multiply-add */
+#define X86_FEATURE_CX16	( 4*32+13) /* CMPXCHG16B */
+#define X86_FEATURE_XTPR	( 4*32+14) /* Send Task Priority Messages */
+#define X86_FEATURE_PDCM	( 4*32+15) /* Performance Capabilities */
+#define X86_FEATURE_PCID	( 4*32+17) /* Process Context Identifiers */
+#define X86_FEATURE_DCA		( 4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_XMM4_1	( 4*32+19) /* "sse4_1" SSE-4.1 */
+#define X86_FEATURE_XMM4_2	( 4*32+20) /* "sse4_2" SSE-4.2 */
+#define X86_FEATURE_X2APIC	( 4*32+21) /* x2APIC */
+#define X86_FEATURE_MOVBE	( 4*32+22) /* MOVBE instruction */
+#define X86_FEATURE_POPCNT      ( 4*32+23) /* POPCNT instruction */
+#define X86_FEATURE_TSC_DEADLINE_TIMER	( 4*32+24) /* Tsc deadline timer */
+#define X86_FEATURE_AES		( 4*32+25) /* AES instructions */
+#define X86_FEATURE_XSAVE	( 4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
+#define X86_FEATURE_OSXSAVE	( 4*32+27) /* "" XSAVE enabled in the OS */
+#define X86_FEATURE_AVX		( 4*32+28) /* Advanced Vector Extensions */
+#define X86_FEATURE_F16C	( 4*32+29) /* 16-bit fp conversions */
+#define X86_FEATURE_RDRAND	( 4*32+30) /* The RDRAND instruction */
+#define X86_FEATURE_HYPERVISOR	( 4*32+31) /* Running on a hypervisor */
+
+/* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 =
*/
+#define X86_FEATURE_XSTORE	( 5*32+ 2) /* "rng" RNG present (xstore) */
+#define X86_FEATURE_XSTORE_EN	( 5*32+ 3) /* "rng_en" RNG enabled */
+#define X86_FEATURE_XCRYPT	( 5*32+ 6) /* "ace" on-CPU crypto (xcrypt) */
+#define X86_FEATURE_XCRYPT_EN	( 5*32+ 7) /* "ace_en" on-CPU crypto enabled=
 */
+#define X86_FEATURE_ACE2	( 5*32+ 8) /* Advanced Cryptography Engine v2 */
+#define X86_FEATURE_ACE2_EN	( 5*32+ 9) /* ACE v2 enabled */
+#define X86_FEATURE_PHE		( 5*32+10) /* PadLock Hash Engine */
+#define X86_FEATURE_PHE_EN	( 5*32+11) /* PHE enabled */
+#define X86_FEATURE_PMM		( 5*32+12) /* PadLock Montgomery Multiplier */
+#define X86_FEATURE_PMM_EN	( 5*32+13) /* PMM enabled */
+
+/* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
+#define X86_FEATURE_LAHF_LM	( 6*32+ 0) /* LAHF/SAHF in long mode */
+#define X86_FEATURE_CMP_LEGACY	( 6*32+ 1) /* If yes HyperThreading not val=
id */
+#define X86_FEATURE_SVM		( 6*32+ 2) /* Secure virtual machine */
+#define X86_FEATURE_EXTAPIC	( 6*32+ 3) /* Extended APIC space */
+#define X86_FEATURE_CR8_LEGACY	( 6*32+ 4) /* CR8 in 32-bit mode */
+#define X86_FEATURE_ABM		( 6*32+ 5) /* Advanced bit manipulation */
+#define X86_FEATURE_SSE4A	( 6*32+ 6) /* SSE-4A */
+#define X86_FEATURE_MISALIGNSSE ( 6*32+ 7) /* Misaligned SSE mode */
+#define X86_FEATURE_3DNOWPREFETCH ( 6*32+ 8) /* 3DNow prefetch instruction=
s */
+#define X86_FEATURE_OSVW	( 6*32+ 9) /* OS Visible Workaround */
+#define X86_FEATURE_IBS		( 6*32+10) /* Instruction Based Sampling */
+#define X86_FEATURE_XOP		( 6*32+11) /* extended AVX instructions */
+#define X86_FEATURE_SKINIT	( 6*32+12) /* SKINIT/STGI instructions */
+#define X86_FEATURE_WDT		( 6*32+13) /* Watchdog timer */
+#define X86_FEATURE_LWP		( 6*32+15) /* Light Weight Profiling */
+#define X86_FEATURE_FMA4	( 6*32+16) /* 4 operands MAC instructions */
+#define X86_FEATURE_TCE		( 6*32+17) /* translation cache extension */
+#define X86_FEATURE_NODEID_MSR	( 6*32+19) /* NodeId MSR */
+#define X86_FEATURE_TBM		( 6*32+21) /* trailing bit manipulations */
+#define X86_FEATURE_TOPOEXT	( 6*32+22) /* topology extensions CPUID leafs =
*/
+#define X86_FEATURE_PERFCTR_CORE ( 6*32+23) /* core performance counter ex=
tensions */
+#define X86_FEATURE_PERFCTR_NB  ( 6*32+24) /* NB performance counter exten=
sions */
+#define X86_FEATURE_PERFCTR_L2	( 6*32+28) /* L2 performance counter extens=
ions */
+
+/*
+ * Auxiliary flags: Linux defined - For features scattered in various
+ * CPUID levels like 0x6, 0xA etc, word 7
+ */
+#define X86_FEATURE_IDA		( 7*32+ 0) /* Intel Dynamic Acceleration */
+#define X86_FEATURE_ARAT	( 7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_CPB		( 7*32+ 2) /* AMD Core Performance Boost */
+#define X86_FEATURE_EPB		( 7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
+#define X86_FEATURE_XSAVEOPT	( 7*32+ 4) /* Optimized Xsave */
+#define X86_FEATURE_PLN		( 7*32+ 5) /* Intel Power Limit Notification */
+#define X86_FEATURE_PTS		( 7*32+ 6) /* Intel Package Thermal Status */
+#define X86_FEATURE_DTHERM	( 7*32+ 7) /* Digital Thermal Sensor */
+#define X86_FEATURE_HW_PSTATE	( 7*32+ 8) /* AMD HW-PState */
+#define X86_FEATURE_PROC_FEEDBACK ( 7*32+ 9) /* AMD ProcFeedbackInterface =
*/
+#define X86_FEATURE_INVPCID_SINGLE ( 7*32+10) /* Effectively INVPCID && CR=
4.PCIDE=3D1 */
+#define X86_FEATURE_RSB_CTXSW	( 7*32+11) /* "" Fill RSB on context switche=
s */
+#define X86_FEATURE_USE_IBPB	( 7*32+12) /* "" Indirect Branch Prediction B=
arrier enabled */
+#define X86_FEATURE_USE_IBRS_FW ( 7*32+13) /* "" Use IBRS during runtime f=
irmware calls */
+#define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE ( 7*32+14) /* "" Disable Spe=
culative Store Bypass. */
+#define X86_FEATURE_LS_CFG_SSBD	( 7*32+15) /* "" AMD SSBD implementation */
+#define X86_FEATURE_IBRS	( 7*32+16) /* Indirect Branch Restricted Speculat=
ion */
+#define X86_FEATURE_IBPB	( 7*32+17) /* Indirect Branch Prediction Barrier =
*/
+#define X86_FEATURE_STIBP	( 7*32+18) /* Single Thread Indirect Branch Pred=
ictors */
+#define X86_FEATURE_MSR_SPEC_CTRL ( 7*32+19) /* "" MSR SPEC_CTRL is implem=
ented */
+#define X86_FEATURE_SSBD	( 7*32+20) /* Speculative Store Bypass Disable */
+#define X86_FEATURE_ZEN		( 7*32+21) /* "" CPU is AMD family 0x17 (Zen) */
+#define X86_FEATURE_L1TF_PTEINV	( 7*32+22) /* "" L1TF workaround PTE inver=
sion */
+#define X86_FEATURE_IBRS_ENHANCED ( 7*32+23) /* Enhanced IBRS */
+#define X86_FEATURE_RETPOLINE	( 7*32+29) /* "" Generic Retpoline mitigatio=
n for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_AMD ( 7*32+30) /* "" AMD Retpoline mitigatio=
n for Spectre variant 2 */
+/* Because the ALTERNATIVE scheme is for members of the X86_FEATURE club..=
=2E */
+#define X86_FEATURE_KAISER	( 7*32+31) /* CONFIG_PAGE_TABLE_ISOLATION w/o n=
okaiser */
+
+/* Virtualization flags: Linux defined, word 8 */
+#define X86_FEATURE_TPR_SHADOW  ( 8*32+ 0) /* Intel TPR Shadow */
+#define X86_FEATURE_VNMI        ( 8*32+ 1) /* Intel Virtual NMI */
+#define X86_FEATURE_FLEXPRIORITY ( 8*32+ 2) /* Intel FlexPriority */
+#define X86_FEATURE_EPT         ( 8*32+ 3) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID        ( 8*32+ 4) /* Intel Virtual Processor ID */
+#define X86_FEATURE_NPT		( 8*32+ 5) /* AMD Nested Page Table support */
+#define X86_FEATURE_LBRV	( 8*32+ 6) /* AMD LBR Virtualization support */
+#define X86_FEATURE_SVML	( 8*32+ 7) /* "svm_lock" AMD SVM locking MSR */
+#define X86_FEATURE_NRIPS	( 8*32+ 8) /* "nrip_save" AMD SVM next_rip save =
*/
+#define X86_FEATURE_TSCRATEMSR  ( 8*32+ 9) /* "tsc_scale" AMD TSC scaling =
support */
+#define X86_FEATURE_VMCBCLEAN   ( 8*32+10) /* "vmcb_clean" AMD VMCB clean =
bits support */
+#define X86_FEATURE_FLUSHBYASID ( 8*32+11) /* AMD flush-by-ASID support */
+#define X86_FEATURE_DECODEASSISTS ( 8*32+12) /* AMD Decode Assists support=
 */
+#define X86_FEATURE_PAUSEFILTER ( 8*32+13) /* AMD filtered pause intercept=
 */
+#define X86_FEATURE_PFTHRESHOLD ( 8*32+14) /* AMD pause filter threshold */
+#define X86_FEATURE_VMMCALL     ( 8*32+15) /* Prefer vmmcall to vmcall */
+
+
+/* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
+#define X86_FEATURE_FSGSBASE	( 9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions=
*/
+#define X86_FEATURE_TSC_ADJUST	( 9*32+ 1) /* TSC adjustment MSR 0x3b */
+#define X86_FEATURE_BMI1	( 9*32+ 3) /* 1st group bit manipulation extensio=
ns */
+#define X86_FEATURE_HLE		( 9*32+ 4) /* Hardware Lock Elision */
+#define X86_FEATURE_AVX2	( 9*32+ 5) /* AVX2 instructions */
+#define X86_FEATURE_SMEP	( 9*32+ 7) /* Supervisor Mode Execution Protectio=
n */
+#define X86_FEATURE_BMI2	( 9*32+ 8) /* 2nd group bit manipulation extensio=
ns */
+#define X86_FEATURE_ERMS	( 9*32+ 9) /* Enhanced REP MOVSB/STOSB */
+#define X86_FEATURE_INVPCID	( 9*32+10) /* Invalidate Processor Context ID =
*/
+#define X86_FEATURE_RTM		( 9*32+11) /* Restricted Transactional Memory */
+#define X86_FEATURE_MPX		( 9*32+14) /* Memory Protection Extension */
+#define X86_FEATURE_AVX512F	( 9*32+16) /* AVX-512 Foundation */
+#define X86_FEATURE_RDSEED	( 9*32+18) /* The RDSEED instruction */
+#define X86_FEATURE_ADX		( 9*32+19) /* The ADCX and ADOX instructions */
+#define X86_FEATURE_SMAP	( 9*32+20) /* Supervisor Mode Access Prevention */
+#define X86_FEATURE_CLFLUSHOPT	( 9*32+23) /* CLFLUSHOPT instruction */
+#define X86_FEATURE_AVX512PF	( 9*32+26) /* AVX-512 Prefetch */
+#define X86_FEATURE_AVX512ER	( 9*32+27) /* AVX-512 Exponential and Recipro=
cal */
+#define X86_FEATURE_AVX512CD	( 9*32+28) /* AVX-512 Conflict Detection */
+
+/* Intel-defined CPU features, CPUID level 0x00000007:0 (EDX), word 10 */
+#define X86_FEATURE_MD_CLEAR		(10*32+10) /* VERW clears CPU buffers */
+#define X86_FEATURE_SPEC_CTRL		(10*32+26) /* "" Speculation Control (IBRS =
+ IBPB) */
+#define X86_FEATURE_INTEL_STIBP		(10*32+27) /* "" Single Thread Indirect B=
ranch Predictors */
+#define X86_FEATURE_ARCH_CAPABILITIES	(10*32+29) /* IA32_ARCH_CAPABILITIES=
 MSR (Intel) */
+#define X86_FEATURE_SPEC_CTRL_SSBD	(10*32+31) /* "" Speculative Store Bypa=
ss Disable */
+
+/* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 11 */
+#define X86_FEATURE_AMD_IBPB		(11*32+12) /* "" Indirect Branch Prediction =
Barrier */
+#define X86_FEATURE_AMD_IBRS		(11*32+14) /* "" Indirect Branch Restricted =
Speculation */
+#define X86_FEATURE_AMD_STIBP		(11*32+15) /* "" Single Thread Indirect Bra=
nch Predictors */
+#define X86_FEATURE_AMD_SSBD		(11*32+24) /* "" Speculative Store Bypass Di=
sable */
+#define X86_FEATURE_VIRT_SSBD		(11*32+25) /* Virtualized Speculative Store=
 Bypass Disable */
+#define X86_FEATURE_AMD_SSB_NO		(11*32+26) /* "" Speculative Store Bypass =
is fixed in hardware. */
+
+/*
+ * BUG word(s)
+ */
+#define X86_BUG(x)		(NCAPINTS*32 + (x))
+
+#define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
+#define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
+#define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
+#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* "tlb_mmatch" AMD Erratum 383 =
*/
+#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* "apic_c1e" AMD Erratum 400 */
+#define X86_BUG_CPU_MELTDOWN	X86_BUG(5) /* CPU is affected by meltdown att=
ack and needs kernel page table isolation */
+#define X86_BUG_SPECTRE_V1	X86_BUG(6) /* CPU is affected by Spectre varian=
t 1 attack with conditional branches */
+#define X86_BUG_SPECTRE_V2	X86_BUG(7) /* CPU is affected by Spectre varian=
t 2 attack with indirect branches */
+#define X86_BUG_SPEC_STORE_BYPASS X86_BUG(8) /* CPU is affected by specula=
tive store bypass attack */
+#define X86_BUG_L1TF		X86_BUG(9) /* CPU is affected by L1 Terminal Fault */
+#define X86_BUG_MDS		X86_BUG(10) /* CPU is affected by Microarchitectural =
data sampling */
+#define X86_BUG_MSBDS_ONLY	X86_BUG(11) /* CPU is only affected by the  MSD=
BS variant of BUG_MDS */
+
+#endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/int=
el-family.h
index 40661857e0eb..a501214113ec 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -50,19 +50,23 @@
=20
 /* "Small Core" Processors (Atom) */
=20
-#define INTEL_FAM6_ATOM_PINEVIEW	0x1C
-#define INTEL_FAM6_ATOM_LINCROFT	0x26
-#define INTEL_FAM6_ATOM_PENWELL		0x27
-#define INTEL_FAM6_ATOM_CLOVERVIEW	0x35
-#define INTEL_FAM6_ATOM_CEDARVIEW	0x36
-#define INTEL_FAM6_ATOM_SILVERMONT1	0x37 /* BayTrail/BYT / Valleyview */
-#define INTEL_FAM6_ATOM_SILVERMONT2	0x4D /* Avaton/Rangely */
-#define INTEL_FAM6_ATOM_AIRMONT		0x4C /* CherryTrail / Braswell */
-#define INTEL_FAM6_ATOM_MERRIFIELD	0x4A /* Tangier */
-#define INTEL_FAM6_ATOM_MOOREFIELD	0x5A /* Anniedale */
-#define INTEL_FAM6_ATOM_GOLDMONT	0x5C
-#define INTEL_FAM6_ATOM_DENVERTON	0x5F /* Goldmont Microserver */
-#define INTEL_FAM6_ATOM_GEMINI_LAKE	0x7A
+#define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
+#define INTEL_FAM6_ATOM_BONNELL_MID	0x26 /* Silverthorne, Lincroft */
+
+#define INTEL_FAM6_ATOM_SALTWELL	0x36 /* Cedarview */
+#define INTEL_FAM6_ATOM_SALTWELL_MID	0x27 /* Penwell */
+#define INTEL_FAM6_ATOM_SALTWELL_TABLET	0x35 /* Cloverview */
+
+#define INTEL_FAM6_ATOM_SILVERMONT	0x37 /* Bay Trail, Valleyview */
+#define INTEL_FAM6_ATOM_SILVERMONT_X	0x4D /* Avaton, Rangely */
+#define INTEL_FAM6_ATOM_SILVERMONT_MID	0x4A /* Merriefield */
+
+#define INTEL_FAM6_ATOM_AIRMONT		0x4C /* Cherry Trail, Braswell */
+#define INTEL_FAM6_ATOM_AIRMONT_MID	0x5A /* Moorefield */
+
+#define INTEL_FAM6_ATOM_GOLDMONT	0x5C /* Apollo Lake */
+#define INTEL_FAM6_ATOM_GOLDMONT_X	0x5F /* Denverton */
+#define INTEL_FAM6_ATOM_GOLDMONT_PLUS	0x7A /* Gemini Lake */
=20
 /* Xeon Phi */
=20
diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflag=
s.h
index 0a8b519226b8..6662249366e8 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -4,6 +4,9 @@
 #include <asm/processor-flags.h>
=20
 #ifndef __ASSEMBLY__
+
+#include <asm/nospec-branch.h>
+
 /*
  * Interrupt control:
  */
@@ -46,11 +49,13 @@ static inline void native_irq_enable(void)
=20
 static inline void native_safe_halt(void)
 {
+	mds_idle_clear_cpu_buffers();
 	asm volatile("sti; hlt": : :"memory");
 }
=20
 static inline void native_halt(void)
 {
+	mds_idle_clear_cpu_buffers();
 	asm volatile("hlt": : :"memory");
 }
=20
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_=
label.h
index 6a2cefb4395a..adc54c12cbd1 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -1,12 +1,18 @@
 #ifndef _ASM_X86_JUMP_LABEL_H
 #define _ASM_X86_JUMP_LABEL_H
=20
-#ifdef __KERNEL__
-
-#include <linux/stringify.h>
-#include <linux/types.h>
-#include <asm/nops.h>
-#include <asm/asm.h>
+#ifndef HAVE_JUMP_LABEL
+/*
+ * For better or for worse, if jump labels (the gcc extension) are missing,
+ * then the entire static branch patching infrastructure is compiled out.
+ * If that happens, the code in here will malfunction.  Raise a compiler
+ * error instead.
+ *
+ * In theory, jump labels and the static branch patching infrastructure
+ * could be decoupled to fix this.
+ */
+#error asm/jump_label.h included on a non-jump-label kernel
+#endif
=20
 #define JUMP_LABEL_NOP_SIZE 5
=20
@@ -16,21 +22,44 @@
 # define STATIC_KEY_INIT_NOP GENERIC_NOP5_ATOMIC
 #endif
=20
-static __always_inline bool arch_static_branch(struct static_key *key)
+#include <asm/asm.h>
+#include <asm/nops.h>
+
+#ifndef __ASSEMBLY__
+
+#include <linux/stringify.h>
+#include <linux/types.h>
+
+static __always_inline bool arch_static_branch(struct static_key *key, boo=
l branch)
 {
 	asm_volatile_goto("1:"
 		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
-		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
+		_ASM_PTR "1b, %l[l_yes], %c0 + %c1 \n\t"
 		".popsection \n\t"
-		: :  "i" (key) : : l_yes);
+		: :  "i" (key), "i" (branch) : : l_yes);
+
 	return false;
 l_yes:
 	return true;
 }
=20
-#endif /* __KERNEL__ */
+static __always_inline bool arch_static_branch_jump(struct static_key *key=
, bool branch)
+{
+	asm_volatile_goto("1:"
+		".byte 0xe9\n\t .long %l[l_yes] - 2f\n\t"
+		"2:\n\t"
+		".pushsection __jump_table,  \"aw\" \n\t"
+		_ASM_ALIGN "\n\t"
+		_ASM_PTR "1b, %l[l_yes], %c0 + %c1 \n\t"
+		".popsection \n\t"
+		: :  "i" (key), "i" (branch) : : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
=20
 #ifdef CONFIG_X86_64
 typedef u64 jump_label_t;
@@ -44,4 +73,40 @@ struct jump_entry {
 	jump_label_t key;
 };
=20
+#else	/* __ASSEMBLY__ */
+
+.macro STATIC_JUMP_IF_TRUE target, key, def
+.Lstatic_jump_\@:
+	.if \def
+	/* Equivalent to "jmp.d32 \target" */
+	.byte		0xe9
+	.long		\target - .Lstatic_jump_after_\@
+.Lstatic_jump_after_\@:
+	.else
+	.byte		STATIC_KEY_INIT_NOP
+	.endif
+	.pushsection __jump_table, "aw"
+	_ASM_ALIGN
+	_ASM_PTR	.Lstatic_jump_\@, \target, \key
+	.popsection
+.endm
+
+.macro STATIC_JUMP_IF_FALSE target, key, def
+.Lstatic_jump_\@:
+	.if \def
+	.byte		STATIC_KEY_INIT_NOP
+	.else
+	/* Equivalent to "jmp.d32 \target" */
+	.byte		0xe9
+	.long		\target - .Lstatic_jump_after_\@
+.Lstatic_jump_after_\@:
+	.endif
+	.pushsection __jump_table, "aw"
+	_ASM_ALIGN
+	_ASM_PTR	.Lstatic_jump_\@, \target, \key + 1
+	.popsection
+.endm
+
+#endif	/* __ASSEMBLY__ */
+
 #endif
diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 3ba047cbcf5b..f0d678d40e72 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -3,6 +3,9 @@
=20
 #include <linux/sched.h>
=20
+#include <asm/cpufeature.h>
+#include <asm/nospec-branch.h>
+
 #define MWAIT_SUBSTATE_MASK		0xf
 #define MWAIT_CSTATE_MASK		0xf
 #define MWAIT_SUBSTATE_SIZE		4
@@ -25,6 +28,8 @@ static inline void __monitor(const void *eax, unsigned lo=
ng ecx,
=20
 static inline void __mwait(unsigned long eax, unsigned long ecx)
 {
+	mds_idle_clear_cpu_buffers();
+
 	/* "mwait %eax, %ecx;" */
 	asm volatile(".byte 0x0f, 0x01, 0xc9;"
 		     :: "a" (eax), "c" (ecx));
@@ -32,6 +37,8 @@ static inline void __mwait(unsigned long eax, unsigned lo=
ng ecx)
=20
 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
+	mds_idle_clear_cpu_buffers();
+
 	trace_hardirqs_on();
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/no=
spec-branch.h
index ba2bed5258d3..1d0c5e2340f6 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -3,9 +3,11 @@
 #ifndef _ASM_X86_NOSPEC_BRANCH_H_
 #define _ASM_X86_NOSPEC_BRANCH_H_
=20
+#include <linux/static_key.h>
+
 #include <asm/alternative.h>
 #include <asm/alternative-asm.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
=20
 /*
@@ -169,7 +171,15 @@ enum spectre_v2_mitigation {
 	SPECTRE_V2_RETPOLINE_MINIMAL_AMD,
 	SPECTRE_V2_RETPOLINE_GENERIC,
 	SPECTRE_V2_RETPOLINE_AMD,
-	SPECTRE_V2_IBRS,
+	SPECTRE_V2_IBRS_ENHANCED,
+};
+
+/* The indirect branch speculation control variants */
+enum spectre_v2_user_mitigation {
+	SPECTRE_V2_USER_NONE,
+	SPECTRE_V2_USER_STRICT,
+	SPECTRE_V2_USER_PRCTL,
+	SPECTRE_V2_USER_SECCOMP,
 };
=20
 /* The Speculative Store Bypass disable variants */
@@ -248,5 +258,74 @@ do {									\
 	preempt_enable();						\
 } while (0)
=20
+DECLARE_STATIC_KEY_FALSE(switch_to_cond_stibp);
+DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
+DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
+
+DECLARE_STATIC_KEY_FALSE(mds_user_clear);
+DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
+
+#include <asm/segment.h>
+
+/**
+ * mds_clear_cpu_buffers - Mitigation for MDS vulnerability
+ *
+ * This uses the otherwise unused and obsolete VERW instruction in
+ * combination with microcode which triggers a CPU buffer flush when the
+ * instruction is executed.
+ */
+static inline void mds_clear_cpu_buffers(void)
+{
+	static const u16 ds =3D __KERNEL_DS;
+
+	/*
+	 * Has to be the memory-operand variant because only that
+	 * guarantees the CPU buffer flush functionality according to
+	 * documentation. The register-operand variant does not.
+	 * Works with any segment selector, but a valid writable
+	 * data segment is the fastest variant.
+	 *
+	 * "cc" clobber is required because VERW modifies ZF.
+	 */
+	asm volatile("verw %[ds]" : : [ds] "m" (ds) : "cc");
+}
+
+/**
+ * mds_user_clear_cpu_buffers - Mitigation for MDS vulnerability
+ *
+ * Clear CPU buffers if the corresponding static key is enabled
+ */
+static inline void mds_user_clear_cpu_buffers(void)
+{
+	if (static_branch_likely(&mds_user_clear))
+		mds_clear_cpu_buffers();
+}
+
+/**
+ * mds_idle_clear_cpu_buffers - Mitigation for MDS vulnerability
+ *
+ * Clear CPU buffers if the corresponding static key is enabled
+ */
+static inline void mds_idle_clear_cpu_buffers(void)
+{
+	if (static_branch_likely(&mds_idle_clear))
+		mds_clear_cpu_buffers();
+}
+
 #endif /* __ASSEMBLY__ */
+
+#ifdef __ASSEMBLY__
+.macro MDS_USER_CLEAR_CPU_BUFFERS
+#ifdef CONFIG_JUMP_LABEL
+	STATIC_JUMP_IF_FALSE .Lmds_skip_clear_\@, mds_user_clear, def=3D0
+#endif
+#ifdef CONFIG_X86_64
+	verw	mds_clear_cpu_buffers_ds(%rip)
+#else
+	verw	mds_clear_cpu_buffers_ds
+#endif
+.Lmds_skip_clear_\@:
+.endm
+#endif
+
 #endif /* _ASM_X86_NOSPEC_BRANCH_H_ */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proces=
sor.h
index 935d0c063a50..bca59eb2f290 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -13,7 +13,7 @@ struct mm_struct;
 #include <asm/types.h>
 #include <asm/sigcontext.h>
 #include <asm/current.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/page.h>
 #include <asm/pgtable_types.h>
 #include <asm/percpu.h>
@@ -23,7 +23,6 @@ struct mm_struct;
 #include <asm/special_insns.h>
=20
 #include <linux/personality.h>
-#include <linux/cpumask.h>
 #include <linux/cache.h>
 #include <linux/threads.h>
 #include <linux/math64.h>
@@ -954,4 +953,11 @@ bool xen_set_default_idle(void);
=20
 void stop_this_cpu(void *dummy);
 void df_debug(struct pt_regs *regs, long error_code);
+
+enum mds_mitigations {
+	MDS_MITIGATION_OFF,
+	MDS_MITIGATION_FULL,
+	MDS_MITIGATION_VMWERV,
+};
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
index c56cb4f37be9..94f8a6798c2d 100644
--- a/arch/x86/include/asm/smap.h
+++ b/arch/x86/include/asm/smap.h
@@ -15,7 +15,7 @@
=20
 #include <linux/stringify.h>
 #include <asm/nops.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
=20
 /* "Raw" instruction opcodes */
 #define __ASM_CLAC	.byte 0x0f,0x01,0xca
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 63baf16934d0..eb7fac9ef8a4 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -16,7 +16,6 @@
 #endif
 #include <asm/thread_info.h>
 #include <asm/cpumask.h>
-#include <asm/cpufeature.h>
=20
 extern int smp_num_siblings;
 extern unsigned int num_processors;
diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec-c=
trl.h
index ae7c2c5cd7f0..5393babc0598 100644
--- a/arch/x86/include/asm/spec-ctrl.h
+++ b/arch/x86/include/asm/spec-ctrl.h
@@ -53,12 +53,24 @@ static inline u64 ssbd_tif_to_spec_ctrl(u64 tifn)
 	return (tifn & _TIF_SSBD) >> (TIF_SSBD - SPEC_CTRL_SSBD_SHIFT);
 }
=20
+static inline u64 stibp_tif_to_spec_ctrl(u64 tifn)
+{
+	BUILD_BUG_ON(TIF_SPEC_IB < SPEC_CTRL_STIBP_SHIFT);
+	return (tifn & _TIF_SPEC_IB) >> (TIF_SPEC_IB - SPEC_CTRL_STIBP_SHIFT);
+}
+
 static inline unsigned long ssbd_spec_ctrl_to_tif(u64 spec_ctrl)
 {
 	BUILD_BUG_ON(TIF_SSBD < SPEC_CTRL_SSBD_SHIFT);
 	return (spec_ctrl & SPEC_CTRL_SSBD) << (TIF_SSBD - SPEC_CTRL_SSBD_SHIFT);
 }
=20
+static inline unsigned long stibp_spec_ctrl_to_tif(u64 spec_ctrl)
+{
+	BUILD_BUG_ON(TIF_SPEC_IB < SPEC_CTRL_STIBP_SHIFT);
+	return (spec_ctrl & SPEC_CTRL_STIBP) << (TIF_SPEC_IB - SPEC_CTRL_STIBP_SH=
IFT);
+}
+
 static inline u64 ssbd_tif_to_amd_ls_cfg(u64 tifn)
 {
 	return (tifn & _TIF_SSBD) ? x86_amd_ls_cfg_ssbd_mask : 0ULL;
@@ -70,11 +82,7 @@ extern void speculative_store_bypass_ht_init(void);
 static inline void speculative_store_bypass_ht_init(void) { }
 #endif
=20
-extern void speculative_store_bypass_update(unsigned long tif);
-
-static inline void speculative_store_bypass_update_current(void)
-{
-	speculative_store_bypass_update(current_thread_info()->flags);
-}
+extern void speculation_ctrl_update(unsigned long tif);
+extern void speculation_ctrl_update_current(void);
=20
 #endif
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch=
_to.h
index 53ff351ded61..56c907d2b519 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -6,9 +6,6 @@
 struct task_struct; /* one of the stranger aspects of C forward declaratio=
ns */
 __visible struct task_struct *__switch_to(struct task_struct *prev,
 					   struct task_struct *next);
-struct tss_struct;
-void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next=
_p,
-		      struct tss_struct *tss);
=20
 #ifdef CONFIG_X86_32
=20
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thre=
ad_info.h
index 3a3ce1a45b54..045beb0ce338 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -20,7 +20,7 @@
 #ifndef __ASSEMBLY__
 struct task_struct;
 struct exec_domain;
-#include <asm/processor.h>
+#include <asm/cpufeature.h>
 #include <linux/atomic.h>
=20
 struct thread_info {
@@ -72,13 +72,15 @@ struct thread_info {
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
-#define TIF_SSBD			5	/* Reduced data speculation */
+#define TIF_SSBD		5	/* Speculative store bypass disable */
 #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
+#define TIF_SPEC_IB		9	/* Indirect branch speculation mitigation */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_UPROBE		12	/* breakpointed or singlestepping */
+#define TIF_SPEC_FORCE_UPDATE	13	/* Force speculation MSR update in contex=
t switch */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -102,9 +104,11 @@ struct thread_info {
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_SPEC_IB		(1 << TIF_SPEC_IB)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
+#define _TIF_SPEC_FORCE_UPDATE	(1 << TIF_SPEC_FORCE_UPDATE)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
@@ -133,11 +137,13 @@ struct thread_info {
 #define _TIF_WORK_MASK							\
 	(0x0000FFFF &							\
 	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|			\
-	   _TIF_SINGLESTEP|_TIF_SSBD|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
+	   _TIF_SINGLESTEP|_TIF_SSBD|_TIF_SECCOMP|_TIF_SYSCALL_EMU|	\
+	   _TIF_SPEC_IB|_TIF_SPEC_FORCE_UPDATE))
=20
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK						\
-	((0x0000FFFF & ~(_TIF_SSBD | _TIF_SECCOMP)) |			\
+	((0x0000FFFF & ~(_TIF_SSBD | _TIF_SECCOMP | _TIF_SPEC_IB |	\
+			 _TIF_SPEC_FORCE_UPDATE)) |			\
 	 _TIF_SYSCALL_TRACEPOINT | _TIF_NOHZ)
=20
 /* Only used for 64 bit */
@@ -146,8 +152,18 @@ struct thread_info {
 	 _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE)
=20
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW							\
-	(_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP|_TIF_SSBD)
+#define _TIF_WORK_CTXSW_BASE						\
+	(_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP|			\
+	 _TIF_SSBD | _TIF_SPEC_FORCE_UPDATE)
+
+/*
+ * Avoid calls to __switch_to_xtra() on UP as STIBP is not evaluated.
+ */
+#ifdef CONFIG_SMP
+# define _TIF_WORK_CTXSW	(_TIF_WORK_CTXSW_BASE | _TIF_SPEC_IB)
+#else
+# define _TIF_WORK_CTXSW	(_TIF_WORK_CTXSW_BASE)
+#endif
=20
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflus=
h.h
index bd10f6775dfd..b8617a65c2b0 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
=20
 #include <asm/processor.h>
+#include <asm/cpufeature.h>
 #include <asm/special_insns.h>
 #include <asm/smp.h>
=20
@@ -267,6 +268,12 @@ void native_flush_tlb_others(const struct cpumask *cpu=
mask,
 struct tlb_state {
 	struct mm_struct *active_mm;
 	int state;
+
+	/* Last user mm for optimizing IBPB */
+	union {
+		struct mm_struct	*last_user_mm;
+		unsigned long		last_user_mm_ibpb;
+	};
 };
 DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate);
=20
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uacce=
ss_64.h
index 6415eb20cf97..ac6303bbe1da 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -8,7 +8,7 @@
 #include <linux/errno.h>
 #include <linux/lockdep.h>
 #include <asm/alternative.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/page.h>
=20
 /*
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/=
asm/msr-index.h
index c0e06e5e47a0..7e3a682ba083 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -33,13 +33,14 @@
=20
 /* Intel MSRs. Some also available on other CPUs */
 #define MSR_IA32_SPEC_CTRL		0x00000048 /* Speculation Control */
-#define SPEC_CTRL_IBRS			(1 << 0)   /* Indirect Branch Restricted Speculat=
ion */
-#define SPEC_CTRL_STIBP			(1 << 1)   /* Single Thread Indirect Branch Pred=
ictors */
+#define SPEC_CTRL_IBRS			(1UL << 0) /* Indirect Branch Restricted Speculat=
ion */
+#define SPEC_CTRL_STIBP_SHIFT		1	   /* Single Thread Indirect Branch Predi=
ctor (STIBP) bit */
+#define SPEC_CTRL_STIBP			(1UL << SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
 #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit=
 */
-#define SPEC_CTRL_SSBD			(1 << SPEC_CTRL_SSBD_SHIFT)   /* Speculative Stor=
e Bypass Disable */
+#define SPEC_CTRL_SSBD			(1UL << SPEC_CTRL_SSBD_SHIFT) /* Speculative Stor=
e Bypass Disable */
=20
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
-#define PRED_CMD_IBPB			(1 << 0)   /* Indirect Branch Prediction Barrier */
+#define PRED_CMD_IBPB			(1UL << 0) /* Indirect Branch Prediction Barrier */
=20
 #define MSR_IA32_PERFCTR0		0x000000c1
 #define MSR_IA32_PERFCTR1		0x000000c2
@@ -57,13 +58,18 @@
 #define MSR_MTRRcap			0x000000fe
=20
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
-#define ARCH_CAP_RDCL_NO		(1 << 0)   /* Not susceptible to Meltdown */
-#define ARCH_CAP_IBRS_ALL		(1 << 1)   /* Enhanced IBRS support */
-#define ARCH_CAP_SSB_NO			(1 << 4)   /*
+#define ARCH_CAP_RDCL_NO		(1UL << 0) /* Not susceptible to Meltdown */
+#define ARCH_CAP_IBRS_ALL		(1UL << 1) /* Enhanced IBRS support */
+#define ARCH_CAP_SSB_NO			(1UL << 4) /*
 						    * Not susceptible to Speculative Store Bypass
 						    * attack, so no Speculative Store Bypass
 						    * control required.
 						    */
+#define ARCH_CAP_MDS_NO			(1UL << 5) /*
+						    * Not susceptible to
+						    * Microarchitectural Data
+						    * Sampling (MDS) vulnerabilities.
+						    */
=20
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index e96204e419c4..baf9e03d6edf 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -49,7 +49,7 @@ obj-$(CONFIG_HYPERVISOR_GUEST)		+=3D vmware.o hypervisor.=
o mshyperv.o
 quiet_cmd_mkcapflags =3D MKCAP   $@
       cmd_mkcapflags =3D $(CONFIG_SHELL) $(srctree)/$(src)/mkcapflags.sh $=
< $@
=20
-cpufeature =3D $(src)/../../include/asm/cpufeature.h
+cpufeature =3D $(src)/../../include/asm/cpufeatures.h
=20
 targets +=3D capflags.c
 $(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.sh FORCE
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4364dd458ad6..e325029ff01a 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/nospec.h>
 #include <linux/prctl.h>
+#include <linux/sched/smt.h>
=20
 #include <asm/spec-ctrl.h>
 #include <asm/cmdline.h>
@@ -23,6 +24,7 @@
 #include <asm/msr.h>
 #include <asm/paravirt.h>
 #include <asm/alternative.h>
+#include <asm/hypervisor.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/intel-family.h>
@@ -31,13 +33,12 @@
 static void __init spectre_v2_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
+static void __init mds_select_mitigation(void);
=20
-/*
- * Our boot-time value of the SPEC_CTRL MSR. We read it once so that any
- * writes to SPEC_CTRL contain whatever reserved bits have been set.
- */
+/* The base value of the SPEC_CTRL MSR that always has to be preserved. */
 u64 x86_spec_ctrl_base;
 EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
+static DEFINE_MUTEX(spec_ctrl_mutex);
=20
 /*
  * The vendor and possibly platform specific bits which can be modified in
@@ -52,6 +53,22 @@ static u64 x86_spec_ctrl_mask =3D SPEC_CTRL_IBRS;
 u64 x86_amd_ls_cfg_base;
 u64 x86_amd_ls_cfg_ssbd_mask;
=20
+/* Control conditional STIPB in switch_to() */
+DEFINE_STATIC_KEY_FALSE(switch_to_cond_stibp);
+/* Control conditional IBPB in switch_mm() */
+DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
+/* Control unconditional IBPB in switch_mm() */
+DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
+
+/* Control MDS CPU buffer clear before returning to user space */
+DEFINE_STATIC_KEY_FALSE(mds_user_clear);
+/* Control MDS CPU buffer clear before idling (halt, mwait) */
+DEFINE_STATIC_KEY_FALSE(mds_idle_clear);
+EXPORT_SYMBOL_GPL(mds_idle_clear);
+
+/* For use by asm MDS_CLEAR_CPU_BUFFERS */
+const u16 mds_clear_cpu_buffers_ds =3D __KERNEL_DS;
+
 #ifdef CONFIG_X86_32
=20
 static double __initdata x =3D 4195835.0;
@@ -142,6 +159,10 @@ void __init check_bugs(void)
=20
 	l1tf_select_mitigation();
=20
+	mds_select_mitigation();
+
+	arch_smt_update();
+
 #ifdef CONFIG_X86_32
 	/*
 	 * Check whether we are able to run this kernel safely on SMP.
@@ -179,29 +200,6 @@ void __init check_bugs(void)
 #endif
 }
=20
-/* The kernel command line selection */
-enum spectre_v2_mitigation_cmd {
-	SPECTRE_V2_CMD_NONE,
-	SPECTRE_V2_CMD_AUTO,
-	SPECTRE_V2_CMD_FORCE,
-	SPECTRE_V2_CMD_RETPOLINE,
-	SPECTRE_V2_CMD_RETPOLINE_GENERIC,
-	SPECTRE_V2_CMD_RETPOLINE_AMD,
-};
-
-static const char *spectre_v2_strings[] =3D {
-	[SPECTRE_V2_NONE]			=3D "Vulnerable",
-	[SPECTRE_V2_RETPOLINE_MINIMAL]		=3D "Vulnerable: Minimal generic ASM retp=
oline",
-	[SPECTRE_V2_RETPOLINE_MINIMAL_AMD]	=3D "Vulnerable: Minimal AMD ASM retpo=
line",
-	[SPECTRE_V2_RETPOLINE_GENERIC]		=3D "Mitigation: Full generic retpoline",
-	[SPECTRE_V2_RETPOLINE_AMD]		=3D "Mitigation: Full AMD retpoline",
-};
-
-#undef pr_fmt
-#define pr_fmt(fmt)     "Spectre V2 : " fmt
-
-static enum spectre_v2_mitigation spectre_v2_enabled =3D SPECTRE_V2_NONE;
-
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool set=
guest)
 {
@@ -223,6 +221,10 @@ x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt=
_spec_ctrl, bool setguest)
 		    static_cpu_has(X86_FEATURE_AMD_SSBD))
 			hostval |=3D ssbd_tif_to_spec_ctrl(ti->flags);
=20
+		/* Conditional STIBP enabled? */
+		if (static_branch_unlikely(&switch_to_cond_stibp))
+			hostval |=3D stibp_tif_to_spec_ctrl(ti->flags);
+
 		if (hostval !=3D guestval) {
 			msrval =3D setguest ? guestval : hostval;
 			wrmsrl(MSR_IA32_SPEC_CTRL, msrval);
@@ -256,7 +258,7 @@ x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_=
spec_ctrl, bool setguest)
 		tif =3D setguest ? ssbd_spec_ctrl_to_tif(guestval) :
 				 ssbd_spec_ctrl_to_tif(hostval);
=20
-		speculative_store_bypass_update(tif);
+		speculation_ctrl_update(tif);
 	}
 }
 EXPORT_SYMBOL_GPL(x86_virt_spec_ctrl);
@@ -271,6 +273,57 @@ static void x86_amd_ssb_disable(void)
 		wrmsrl(MSR_AMD64_LS_CFG, msrval);
 }
=20
+#undef pr_fmt
+#define pr_fmt(fmt)	"MDS: " fmt
+
+/* Default mitigation for MDS-affected CPUs */
+static enum mds_mitigations mds_mitigation =3D MDS_MITIGATION_FULL;
+
+static const char * const mds_strings[] =3D {
+	[MDS_MITIGATION_OFF]	=3D "Vulnerable",
+	[MDS_MITIGATION_FULL]	=3D "Mitigation: Clear CPU buffers",
+	[MDS_MITIGATION_VMWERV]	=3D "Vulnerable: Clear CPU buffers attempted, no =
microcode",
+};
+
+static void __init mds_select_mitigation(void)
+{
+	if (!boot_cpu_has_bug(X86_BUG_MDS) || cpu_mitigations_off()) {
+		mds_mitigation =3D MDS_MITIGATION_OFF;
+		return;
+	}
+
+	if (mds_mitigation =3D=3D MDS_MITIGATION_FULL) {
+		if (!boot_cpu_has(X86_FEATURE_MD_CLEAR))
+			mds_mitigation =3D MDS_MITIGATION_VMWERV;
+		static_branch_enable(&mds_user_clear);
+	}
+	pr_info("%s\n", mds_strings[mds_mitigation]);
+}
+
+static int __init mds_cmdline(char *str)
+{
+	if (!boot_cpu_has_bug(X86_BUG_MDS))
+		return 0;
+
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "off"))
+		mds_mitigation =3D MDS_MITIGATION_OFF;
+	else if (!strcmp(str, "full"))
+		mds_mitigation =3D MDS_MITIGATION_FULL;
+
+	return 0;
+}
+early_param("mds", mds_cmdline);
+
+#undef pr_fmt
+#define pr_fmt(fmt)     "Spectre V2 : " fmt
+
+static enum spectre_v2_mitigation spectre_v2_enabled =3D SPECTRE_V2_NONE;
+
+static enum spectre_v2_user_mitigation spectre_v2_user =3D SPECTRE_V2_USER=
_NONE;
+
 #ifdef RETPOLINE
 static bool spectre_v2_bad_module;
=20
@@ -292,67 +345,224 @@ static inline const char *spectre_v2_module_string(v=
oid)
 static inline const char *spectre_v2_module_string(void) { return ""; }
 #endif
=20
-static void __init spec2_print_if_insecure(const char *reason)
+static inline bool match_option(const char *arg, int arglen, const char *o=
pt)
 {
-	if (boot_cpu_has_bug(X86_BUG_SPECTRE_V2))
-		pr_info("%s selected on command line.\n", reason);
+	int len =3D strlen(opt);
+
+	return len =3D=3D arglen && !strncmp(arg, opt, len);
 }
=20
-static void __init spec2_print_if_secure(const char *reason)
+/* The kernel command line selection for spectre v2 */
+enum spectre_v2_mitigation_cmd {
+	SPECTRE_V2_CMD_NONE,
+	SPECTRE_V2_CMD_AUTO,
+	SPECTRE_V2_CMD_FORCE,
+	SPECTRE_V2_CMD_RETPOLINE,
+	SPECTRE_V2_CMD_RETPOLINE_GENERIC,
+	SPECTRE_V2_CMD_RETPOLINE_AMD,
+};
+
+enum spectre_v2_user_cmd {
+	SPECTRE_V2_USER_CMD_NONE,
+	SPECTRE_V2_USER_CMD_AUTO,
+	SPECTRE_V2_USER_CMD_FORCE,
+	SPECTRE_V2_USER_CMD_PRCTL,
+	SPECTRE_V2_USER_CMD_PRCTL_IBPB,
+	SPECTRE_V2_USER_CMD_SECCOMP,
+	SPECTRE_V2_USER_CMD_SECCOMP_IBPB,
+};
+
+static const char * const spectre_v2_user_strings[] =3D {
+	[SPECTRE_V2_USER_NONE]		=3D "User space: Vulnerable",
+	[SPECTRE_V2_USER_STRICT]	=3D "User space: Mitigation: STIBP protection",
+	[SPECTRE_V2_USER_PRCTL]		=3D "User space: Mitigation: STIBP via prctl",
+	[SPECTRE_V2_USER_SECCOMP]	=3D "User space: Mitigation: STIBP via seccomp =
and prctl",
+};
+
+static const struct {
+	const char			*option;
+	enum spectre_v2_user_cmd	cmd;
+	bool				secure;
+} v2_user_options[] __initconst =3D {
+	{ "auto",		SPECTRE_V2_USER_CMD_AUTO,		false },
+	{ "off",		SPECTRE_V2_USER_CMD_NONE,		false },
+	{ "on",			SPECTRE_V2_USER_CMD_FORCE,		true  },
+	{ "prctl",		SPECTRE_V2_USER_CMD_PRCTL,		false },
+	{ "prctl,ibpb",		SPECTRE_V2_USER_CMD_PRCTL_IBPB,		false },
+	{ "seccomp",		SPECTRE_V2_USER_CMD_SECCOMP,		false },
+	{ "seccomp,ibpb",	SPECTRE_V2_USER_CMD_SECCOMP_IBPB,	false },
+};
+
+static void __init spec_v2_user_print_cond(const char *reason, bool secure)
 {
-	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V2))
-		pr_info("%s selected on command line.\n", reason);
+	if (boot_cpu_has_bug(X86_BUG_SPECTRE_V2) !=3D secure)
+		pr_info("spectre_v2_user=3D%s forced on command line.\n", reason);
 }
=20
-static inline bool retp_compiler(void)
+static enum spectre_v2_user_cmd __init
+spectre_v2_parse_user_cmdline(enum spectre_v2_mitigation_cmd v2_cmd)
 {
-	return __is_defined(RETPOLINE);
+	char arg[20];
+	int ret, i;
+
+	switch (v2_cmd) {
+	case SPECTRE_V2_CMD_NONE:
+		return SPECTRE_V2_USER_CMD_NONE;
+	case SPECTRE_V2_CMD_FORCE:
+		return SPECTRE_V2_USER_CMD_FORCE;
+	default:
+		break;
+	}
+
+	ret =3D cmdline_find_option(boot_command_line, "spectre_v2_user",
+				  arg, sizeof(arg));
+	if (ret < 0)
+		return SPECTRE_V2_USER_CMD_AUTO;
+
+	for (i =3D 0; i < ARRAY_SIZE(v2_user_options); i++) {
+		if (match_option(arg, ret, v2_user_options[i].option)) {
+			spec_v2_user_print_cond(v2_user_options[i].option,
+						v2_user_options[i].secure);
+			return v2_user_options[i].cmd;
+		}
+	}
+
+	pr_err("Unknown user space protection option (%s). Switching to AUTO sele=
ct\n", arg);
+	return SPECTRE_V2_USER_CMD_AUTO;
 }
=20
-static inline bool match_option(const char *arg, int arglen, const char *o=
pt)
+static void __init
+spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 {
-	int len =3D strlen(opt);
+	enum spectre_v2_user_mitigation mode =3D SPECTRE_V2_USER_NONE;
+	bool smt_possible =3D IS_ENABLED(CONFIG_SMP);
+	enum spectre_v2_user_cmd cmd;
=20
-	return len =3D=3D arglen && !strncmp(arg, opt, len);
+	if (!boot_cpu_has(X86_FEATURE_IBPB) && !boot_cpu_has(X86_FEATURE_STIBP))
+		return;
+
+	if (!IS_ENABLED(CONFIG_X86_HT))
+		smt_possible =3D false;
+
+	cmd =3D spectre_v2_parse_user_cmdline(v2_cmd);
+	switch (cmd) {
+	case SPECTRE_V2_USER_CMD_NONE:
+		goto set_mode;
+	case SPECTRE_V2_USER_CMD_FORCE:
+		mode =3D SPECTRE_V2_USER_STRICT;
+		break;
+	case SPECTRE_V2_USER_CMD_PRCTL:
+	case SPECTRE_V2_USER_CMD_PRCTL_IBPB:
+		mode =3D SPECTRE_V2_USER_PRCTL;
+		break;
+	case SPECTRE_V2_USER_CMD_AUTO:
+	case SPECTRE_V2_USER_CMD_SECCOMP:
+	case SPECTRE_V2_USER_CMD_SECCOMP_IBPB:
+		if (IS_ENABLED(CONFIG_SECCOMP))
+			mode =3D SPECTRE_V2_USER_SECCOMP;
+		else
+			mode =3D SPECTRE_V2_USER_PRCTL;
+		break;
+	}
+
+	/* Initialize Indirect Branch Prediction Barrier */
+	if (boot_cpu_has(X86_FEATURE_IBPB)) {
+		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
+
+		switch (cmd) {
+		case SPECTRE_V2_USER_CMD_FORCE:
+		case SPECTRE_V2_USER_CMD_PRCTL_IBPB:
+		case SPECTRE_V2_USER_CMD_SECCOMP_IBPB:
+			static_branch_enable(&switch_mm_always_ibpb);
+			break;
+		case SPECTRE_V2_USER_CMD_PRCTL:
+		case SPECTRE_V2_USER_CMD_AUTO:
+		case SPECTRE_V2_USER_CMD_SECCOMP:
+			static_branch_enable(&switch_mm_cond_ibpb);
+			break;
+		default:
+			break;
+		}
+
+		pr_info("mitigation: Enabling %s Indirect Branch Prediction Barrier\n",
+			static_key_enabled(&switch_mm_always_ibpb) ?
+			"always-on" : "conditional");
+	}
+
+	/* If enhanced IBRS is enabled no STIPB required */
+	if (spectre_v2_enabled =3D=3D SPECTRE_V2_IBRS_ENHANCED)
+		return;
+
+	/*
+	 * If SMT is not possible or STIBP is not available clear the STIPB
+	 * mode.
+	 */
+	if (!smt_possible || !boot_cpu_has(X86_FEATURE_STIBP))
+		mode =3D SPECTRE_V2_USER_NONE;
+set_mode:
+	spectre_v2_user =3D mode;
+	/* Only print the STIBP mode when SMT possible */
+	if (smt_possible)
+		pr_info("%s\n", spectre_v2_user_strings[mode]);
 }
=20
+static const char * const spectre_v2_strings[] =3D {
+	[SPECTRE_V2_NONE]			=3D "Vulnerable",
+	[SPECTRE_V2_RETPOLINE_MINIMAL]		=3D "Vulnerable: Minimal generic ASM retp=
oline",
+	[SPECTRE_V2_RETPOLINE_MINIMAL_AMD]	=3D "Vulnerable: Minimal AMD ASM retpo=
line",
+	[SPECTRE_V2_RETPOLINE_GENERIC]		=3D "Mitigation: Full generic retpoline",
+	[SPECTRE_V2_RETPOLINE_AMD]		=3D "Mitigation: Full AMD retpoline",
+	[SPECTRE_V2_IBRS_ENHANCED]		=3D "Mitigation: Enhanced IBRS",
+};
+
 static const struct {
 	const char *option;
 	enum spectre_v2_mitigation_cmd cmd;
 	bool secure;
-} mitigation_options[] =3D {
-	{ "off",               SPECTRE_V2_CMD_NONE,              false },
-	{ "on",                SPECTRE_V2_CMD_FORCE,             true },
-	{ "retpoline",         SPECTRE_V2_CMD_RETPOLINE,         false },
-	{ "retpoline,amd",     SPECTRE_V2_CMD_RETPOLINE_AMD,     false },
-	{ "retpoline,generic", SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
-	{ "auto",              SPECTRE_V2_CMD_AUTO,              false },
+} mitigation_options[] __initconst =3D {
+	{ "off",		SPECTRE_V2_CMD_NONE,		  false },
+	{ "on",			SPECTRE_V2_CMD_FORCE,		  true  },
+	{ "retpoline",		SPECTRE_V2_CMD_RETPOLINE,	  false },
+	{ "retpoline,amd",	SPECTRE_V2_CMD_RETPOLINE_AMD,	  false },
+	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
+	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
 };
=20
+static void __init spec_v2_print_cond(const char *reason, bool secure)
+{
+	if (boot_cpu_has_bug(X86_BUG_SPECTRE_V2) !=3D secure)
+		pr_info("%s selected on command line.\n", reason);
+}
+
+static inline bool retp_compiler(void)
+{
+	return __is_defined(RETPOLINE);
+}
+
 static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 {
+	enum spectre_v2_mitigation_cmd cmd =3D SPECTRE_V2_CMD_AUTO;
 	char arg[20];
 	int ret, i;
-	enum spectre_v2_mitigation_cmd cmd =3D SPECTRE_V2_CMD_AUTO;
=20
-	if (cmdline_find_option_bool(boot_command_line, "nospectre_v2"))
+	if (cmdline_find_option_bool(boot_command_line, "nospectre_v2") ||
+	    cpu_mitigations_off())
 		return SPECTRE_V2_CMD_NONE;
-	else {
-		ret =3D cmdline_find_option(boot_command_line, "spectre_v2", arg, sizeof=
(arg));
-		if (ret < 0)
-			return SPECTRE_V2_CMD_AUTO;
=20
-		for (i =3D 0; i < ARRAY_SIZE(mitigation_options); i++) {
-			if (!match_option(arg, ret, mitigation_options[i].option))
-				continue;
-			cmd =3D mitigation_options[i].cmd;
-			break;
-		}
+	ret =3D cmdline_find_option(boot_command_line, "spectre_v2", arg, sizeof(=
arg));
+	if (ret < 0)
+		return SPECTRE_V2_CMD_AUTO;
=20
-		if (i >=3D ARRAY_SIZE(mitigation_options)) {
-			pr_err("unknown option (%s). Switching to AUTO select\n", arg);
-			return SPECTRE_V2_CMD_AUTO;
-		}
+	for (i =3D 0; i < ARRAY_SIZE(mitigation_options); i++) {
+		if (!match_option(arg, ret, mitigation_options[i].option))
+			continue;
+		cmd =3D mitigation_options[i].cmd;
+		break;
+	}
+
+	if (i >=3D ARRAY_SIZE(mitigation_options)) {
+		pr_err("unknown option (%s). Switching to AUTO select\n", arg);
+		return SPECTRE_V2_CMD_AUTO;
 	}
=20
 	if ((cmd =3D=3D SPECTRE_V2_CMD_RETPOLINE ||
@@ -369,11 +579,8 @@ static enum spectre_v2_mitigation_cmd __init spectre_v=
2_parse_cmdline(void)
 		return SPECTRE_V2_CMD_AUTO;
 	}
=20
-	if (mitigation_options[i].secure)
-		spec2_print_if_secure(mitigation_options[i].option);
-	else
-		spec2_print_if_insecure(mitigation_options[i].option);
-
+	spec_v2_print_cond(mitigation_options[i].option,
+			   mitigation_options[i].secure);
 	return cmd;
 }
=20
@@ -396,6 +603,13 @@ static void __init spectre_v2_select_mitigation(void)
=20
 	case SPECTRE_V2_CMD_FORCE:
 	case SPECTRE_V2_CMD_AUTO:
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
+			mode =3D SPECTRE_V2_IBRS_ENHANCED;
+			/* Force it so VMEXIT will restore correctly */
+			x86_spec_ctrl_base |=3D SPEC_CTRL_IBRS;
+			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+			goto specv2_set_mode;
+		}
 		if (IS_ENABLED(CONFIG_RETPOLINE))
 			goto retpoline_auto;
 		break;
@@ -433,6 +647,7 @@ static void __init spectre_v2_select_mitigation(void)
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
 	}
=20
+specv2_set_mode:
 	spectre_v2_enabled =3D mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
=20
@@ -447,20 +662,114 @@ static void __init spectre_v2_select_mitigation(void)
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switc=
h\n");
=20
-	/* Initialize Indirect Branch Prediction Barrier if supported */
-	if (boot_cpu_has(X86_FEATURE_IBPB)) {
-		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
-		pr_info("Spectre v2 mitigation: Enabling Indirect Branch Prediction Barr=
ier\n");
-	}
-
 	/*
 	 * Retpoline means the kernel is safe because it has no indirect
-	 * branches. But firmware isn't, so use IBRS to protect that.
+	 * branches. Enhanced IBRS protects firmware too, so, enable restricted
+	 * speculation around firmware calls only when Enhanced IBRS isn't
+	 * supported.
+	 *
+	 * Use "mode" to check Enhanced IBRS instead of boot_cpu_has(), because
+	 * the user might select retpoline on the kernel command line and if
+	 * the CPU supports Enhanced IBRS, kernel might un-intentionally not
+	 * enable IBRS around firmware calls.
 	 */
-	if (boot_cpu_has(X86_FEATURE_IBRS)) {
+	if (boot_cpu_has(X86_FEATURE_IBRS) && mode !=3D SPECTRE_V2_IBRS_ENHANCED)=
 {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
+
+	/* Set up IBPB and STIBP depending on the general spectre V2 command */
+	spectre_v2_user_select_mitigation(cmd);
+}
+
+static void update_stibp_msr(void * __unused)
+{
+	wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+}
+
+/* Update x86_spec_ctrl_base in case SMT state changed. */
+static void update_stibp_strict(void)
+{
+	u64 mask =3D x86_spec_ctrl_base & ~SPEC_CTRL_STIBP;
+
+	if (sched_smt_active())
+		mask |=3D SPEC_CTRL_STIBP;
+
+	if (mask =3D=3D x86_spec_ctrl_base)
+		return;
+
+	pr_info("Update user space SMT mitigation: STIBP %s\n",
+		mask & SPEC_CTRL_STIBP ? "always-on" : "off");
+	x86_spec_ctrl_base =3D mask;
+	on_each_cpu(update_stibp_msr, NULL, 1);
+}
+
+/* Update the static key controlling the evaluation of TIF_SPEC_IB */
+static void update_indir_branch_cond(void)
+{
+	if (sched_smt_active())
+		static_branch_enable(&switch_to_cond_stibp);
+	else
+		static_branch_disable(&switch_to_cond_stibp);
+}
+
+#undef pr_fmt
+#define pr_fmt(fmt) fmt
+
+/* Update the static key controlling the MDS CPU buffer clear in idle */
+static void update_mds_branch_idle(void)
+{
+	/*
+	 * Enable the idle clearing if SMT is active on CPUs which are
+	 * affected only by MSBDS and not any other MDS variant.
+	 *
+	 * The other variants cannot be mitigated when SMT is enabled, so
+	 * clearing the buffers on idle just to prevent the Store Buffer
+	 * repartitioning leak would be a window dressing exercise.
+	 */
+	if (!boot_cpu_has_bug(X86_BUG_MSBDS_ONLY))
+		return;
+
+	if (sched_smt_active())
+		static_branch_enable(&mds_idle_clear);
+	else
+		static_branch_disable(&mds_idle_clear);
+}
+
+#define MDS_MSG_SMT "MDS CPU bug present and SMT on, data leak possible. S=
ee https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for =
more details.\n"
+
+void arch_smt_update(void)
+{
+	/* Enhanced IBRS implies STIBP. No update required. */
+	if (spectre_v2_enabled =3D=3D SPECTRE_V2_IBRS_ENHANCED)
+		return;
+
+	mutex_lock(&spec_ctrl_mutex);
+
+	switch (spectre_v2_user) {
+	case SPECTRE_V2_USER_NONE:
+		break;
+	case SPECTRE_V2_USER_STRICT:
+		update_stibp_strict();
+		break;
+	case SPECTRE_V2_USER_PRCTL:
+	case SPECTRE_V2_USER_SECCOMP:
+		update_indir_branch_cond();
+		break;
+	}
+
+	switch (mds_mitigation) {
+	case MDS_MITIGATION_FULL:
+	case MDS_MITIGATION_VMWERV:
+		if (sched_smt_active() && !boot_cpu_has(X86_BUG_MSBDS_ONLY))
+			pr_warn_once(MDS_MSG_SMT);
+		update_mds_branch_idle();
+		break;
+	case MDS_MITIGATION_OFF:
+		break;
+	}
+
+	mutex_unlock(&spec_ctrl_mutex);
 }
=20
 #undef pr_fmt
@@ -477,7 +786,7 @@ enum ssb_mitigation_cmd {
 	SPEC_STORE_BYPASS_CMD_SECCOMP,
 };
=20
-static const char *ssb_strings[] =3D {
+static const char * const ssb_strings[] =3D {
 	[SPEC_STORE_BYPASS_NONE]	=3D "Vulnerable",
 	[SPEC_STORE_BYPASS_DISABLE]	=3D "Mitigation: Speculative Store Bypass dis=
abled",
 	[SPEC_STORE_BYPASS_PRCTL]	=3D "Mitigation: Speculative Store Bypass disab=
led via prctl",
@@ -487,7 +796,7 @@ static const char *ssb_strings[] =3D {
 static const struct {
 	const char *option;
 	enum ssb_mitigation_cmd cmd;
-} ssb_mitigation_options[] =3D {
+} ssb_mitigation_options[]  __initconst =3D {
 	{ "auto",	SPEC_STORE_BYPASS_CMD_AUTO },    /* Platform decides */
 	{ "on",		SPEC_STORE_BYPASS_CMD_ON },      /* Disable Speculative Store By=
pass */
 	{ "off",	SPEC_STORE_BYPASS_CMD_NONE },    /* Don't touch Speculative Stor=
e Bypass */
@@ -501,7 +810,8 @@ static enum ssb_mitigation_cmd __init ssb_parse_cmdline=
(void)
 	char arg[20];
 	int ret, i;
=20
-	if (cmdline_find_option_bool(boot_command_line, "nospec_store_bypass_disa=
ble")) {
+	if (cmdline_find_option_bool(boot_command_line, "nospec_store_bypass_disa=
ble") ||
+	    cpu_mitigations_off()) {
 		return SPEC_STORE_BYPASS_CMD_NONE;
 	} else {
 		ret =3D cmdline_find_option(boot_command_line, "spec_store_bypass_disabl=
e",
@@ -598,10 +908,25 @@ static void ssb_select_mitigation(void)
 #undef pr_fmt
 #define pr_fmt(fmt)     "Speculation prctl: " fmt
=20
-static int ssb_prctl_set(struct task_struct *task, unsigned long ctrl)
+static void task_update_spec_tif(struct task_struct *tsk)
 {
-	bool update;
+	/* Force the update of the real TIF bits */
+	set_tsk_thread_flag(tsk, TIF_SPEC_FORCE_UPDATE);
+
+	/*
+	 * Immediately update the speculation control MSRs for the current
+	 * task, but for a non-current task delay setting the CPU
+	 * mitigation until it is scheduled next.
+	 *
+	 * This can only happen for SECCOMP mitigation. For PRCTL it's
+	 * always the current task.
+	 */
+	if (tsk =3D=3D current)
+		speculation_ctrl_update_current();
+}
=20
+static int ssb_prctl_set(struct task_struct *task, unsigned long ctrl)
+{
 	if (ssb_mode !=3D SPEC_STORE_BYPASS_PRCTL &&
 	    ssb_mode !=3D SPEC_STORE_BYPASS_SECCOMP)
 		return -ENXIO;
@@ -612,28 +937,56 @@ static int ssb_prctl_set(struct task_struct *task, un=
signed long ctrl)
 		if (task_spec_ssb_force_disable(task))
 			return -EPERM;
 		task_clear_spec_ssb_disable(task);
-		update =3D test_and_clear_tsk_thread_flag(task, TIF_SSBD);
+		task_update_spec_tif(task);
 		break;
 	case PR_SPEC_DISABLE:
 		task_set_spec_ssb_disable(task);
-		update =3D !test_and_set_tsk_thread_flag(task, TIF_SSBD);
+		task_update_spec_tif(task);
 		break;
 	case PR_SPEC_FORCE_DISABLE:
 		task_set_spec_ssb_disable(task);
 		task_set_spec_ssb_force_disable(task);
-		update =3D !test_and_set_tsk_thread_flag(task, TIF_SSBD);
+		task_update_spec_tif(task);
 		break;
 	default:
 		return -ERANGE;
 	}
+	return 0;
+}
=20
-	/*
-	 * If being set on non-current task, delay setting the CPU
-	 * mitigation until it is next scheduled.
-	 */
-	if (task =3D=3D current && update)
-		speculative_store_bypass_update_current();
-
+static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
+{
+	switch (ctrl) {
+	case PR_SPEC_ENABLE:
+		if (spectre_v2_user =3D=3D SPECTRE_V2_USER_NONE)
+			return 0;
+		/*
+		 * Indirect branch speculation is always disabled in strict
+		 * mode.
+		 */
+		if (spectre_v2_user =3D=3D SPECTRE_V2_USER_STRICT)
+			return -EPERM;
+		task_clear_spec_ib_disable(task);
+		task_update_spec_tif(task);
+		break;
+	case PR_SPEC_DISABLE:
+	case PR_SPEC_FORCE_DISABLE:
+		/*
+		 * Indirect branch speculation is always allowed when
+		 * mitigation is force disabled.
+		 */
+		if (spectre_v2_user =3D=3D SPECTRE_V2_USER_NONE)
+			return -EPERM;
+		if (spectre_v2_user =3D=3D SPECTRE_V2_USER_STRICT)
+			return 0;
+		task_set_spec_ib_disable(task);
+		if (ctrl =3D=3D PR_SPEC_FORCE_DISABLE)
+			task_set_spec_ib_force_disable(task);
+		task_update_spec_tif(task);
+		break;
+	default:
+		return -ERANGE;
+	}
 	return 0;
 }
=20
@@ -643,6 +996,8 @@ int arch_prctl_spec_ctrl_set(struct task_struct *task, =
unsigned long which,
 	switch (which) {
 	case PR_SPEC_STORE_BYPASS:
 		return ssb_prctl_set(task, ctrl);
+	case PR_SPEC_INDIRECT_BRANCH:
+		return ib_prctl_set(task, ctrl);
 	default:
 		return -ENODEV;
 	}
@@ -653,6 +1008,8 @@ void arch_seccomp_spec_mitigate(struct task_struct *ta=
sk)
 {
 	if (ssb_mode =3D=3D SPEC_STORE_BYPASS_SECCOMP)
 		ssb_prctl_set(task, PR_SPEC_FORCE_DISABLE);
+	if (spectre_v2_user =3D=3D SPECTRE_V2_USER_SECCOMP)
+		ib_prctl_set(task, PR_SPEC_FORCE_DISABLE);
 }
 #endif
=20
@@ -675,11 +1032,35 @@ static int ssb_prctl_get(struct task_struct *task)
 	}
 }
=20
+static int ib_prctl_get(struct task_struct *task)
+{
+	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V2))
+		return PR_SPEC_NOT_AFFECTED;
+
+	switch (spectre_v2_user) {
+	case SPECTRE_V2_USER_NONE:
+		return PR_SPEC_ENABLE;
+	case SPECTRE_V2_USER_PRCTL:
+	case SPECTRE_V2_USER_SECCOMP:
+		if (task_spec_ib_force_disable(task))
+			return PR_SPEC_PRCTL | PR_SPEC_FORCE_DISABLE;
+		if (task_spec_ib_disable(task))
+			return PR_SPEC_PRCTL | PR_SPEC_DISABLE;
+		return PR_SPEC_PRCTL | PR_SPEC_ENABLE;
+	case SPECTRE_V2_USER_STRICT:
+		return PR_SPEC_DISABLE;
+	default:
+		return PR_SPEC_NOT_AFFECTED;
+	}
+}
+
 int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 {
 	switch (which) {
 	case PR_SPEC_STORE_BYPASS:
 		return ssb_prctl_get(task);
+	case PR_SPEC_INDIRECT_BRANCH:
+		return ib_prctl_get(task);
 	default:
 		return -ENODEV;
 	}
@@ -755,16 +1136,66 @@ static void __init l1tf_select_mitigation(void)
 		pr_info("You may make it effective by booting the kernel with mem=3D%llu=
 parameter.\n",
 				half_pa);
 		pr_info("However, doing so will make a part of your RAM unusable.\n");
-		pr_info("Reading https://www.kernel.org/doc/html/latest/admin-guide/l1tf=
=2Ehtml might help you decide.\n");
+		pr_info("Reading https://www.kernel.org/doc/html/latest/admin-guide/hw-v=
uln/l1tf.html might help you decide.\n");
 		return;
 	}
=20
 	setup_force_cpu_cap(X86_FEATURE_L1TF_PTEINV);
 }
 #undef pr_fmt
+#define pr_fmt(fmt) fmt
=20
 #ifdef CONFIG_SYSFS
=20
+static ssize_t mds_show_state(char *buf)
+{
+#ifdef CONFIG_HYPERVISOR_GUEST
+	if (x86_hyper) {
+		return sprintf(buf, "%s; SMT Host state unknown\n",
+			       mds_strings[mds_mitigation]);
+	}
+#endif
+
+	if (boot_cpu_has(X86_BUG_MSBDS_ONLY)) {
+		return sprintf(buf, "%s; SMT %s\n", mds_strings[mds_mitigation],
+			       (mds_mitigation =3D=3D MDS_MITIGATION_OFF ? "vulnerable" :
+			        sched_smt_active() ? "mitigated" : "disabled"));
+	}
+
+	return sprintf(buf, "%s; SMT %s\n", mds_strings[mds_mitigation],
+		       sched_smt_active() ? "vulnerable" : "disabled");
+}
+
+static char *stibp_state(void)
+{
+	if (spectre_v2_enabled =3D=3D SPECTRE_V2_IBRS_ENHANCED)
+		return "";
+
+	switch (spectre_v2_user) {
+	case SPECTRE_V2_USER_NONE:
+		return ", STIBP: disabled";
+	case SPECTRE_V2_USER_STRICT:
+		return ", STIBP: forced";
+	case SPECTRE_V2_USER_PRCTL:
+	case SPECTRE_V2_USER_SECCOMP:
+		if (static_key_enabled(&switch_to_cond_stibp))
+			return ", STIBP: conditional";
+	}
+	return "";
+}
+
+static char *ibpb_state(void)
+{
+	if (boot_cpu_has(X86_FEATURE_IBPB)) {
+		if (static_key_enabled(&switch_mm_always_ibpb))
+			return ", IBPB: always-on";
+		if (static_key_enabled(&switch_mm_cond_ibpb))
+			return ", IBPB: conditional";
+		return ", IBPB: disabled";
+	}
+	return "";
+}
+
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute=
 *attr,
 			       char *buf, unsigned int bug)
 {
@@ -782,9 +1213,11 @@ static ssize_t cpu_show_common(struct device *dev, st=
ruct device_attribute *attr
 		return sprintf(buf, "Mitigation: __user pointer sanitization\n");
=20
 	case X86_BUG_SPECTRE_V2:
-		return sprintf(buf, "%s%s%s%s\n", spectre_v2_strings[spectre_v2_enabled],
-			       boot_cpu_has(X86_FEATURE_USE_IBPB) ? ", IBPB" : "",
+		return sprintf(buf, "%s%s%s%s%s%s\n", spectre_v2_strings[spectre_v2_enab=
led],
+			       ibpb_state(),
 			       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
+			       stibp_state(),
+			       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
 			       spectre_v2_module_string());
=20
 	case X86_BUG_SPEC_STORE_BYPASS:
@@ -792,9 +1225,12 @@ static ssize_t cpu_show_common(struct device *dev, st=
ruct device_attribute *attr
=20
 	case X86_BUG_L1TF:
 		if (boot_cpu_has(X86_FEATURE_L1TF_PTEINV))
-			return sprintf(buf, "Mitigation: Page Table Inversion\n");
+			return sprintf(buf, "Mitigation: PTE Inversion\n");
 		break;
=20
+	case X86_BUG_MDS:
+		return mds_show_state(buf);
+
 	default:
 		break;
 	}
@@ -826,4 +1262,9 @@ ssize_t cpu_show_l1tf(struct device *dev, struct devic=
e_attribute *attr, char *b
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_L1TF);
 }
+
+ssize_t cpu_show_mds(struct device *dev, struct device_attribute *attr, ch=
ar *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_MDS);
+}
 #endif
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index d8fba5c15fbd..5468a6067588 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -1,7 +1,7 @@
 #include <linux/bitops.h>
 #include <linux/kernel.h>
=20
-#include <asm/processor.h>
+#include <asm/cpufeature.h>
 #include <asm/e820.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e8ecf617ca4a..9d4638d437de 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -807,82 +807,95 @@ static void identify_cpu_without_cpuid(struct cpuinfo=
_x86 *c)
 #endif
 }
=20
-static const __initconst struct x86_cpu_id cpu_no_speculation[] =3D {
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_CEDARVIEW,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_CLOVERVIEW,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_LINCROFT,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_PENWELL,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_PINEVIEW,	X86_FEATURE_ANY },
-	{ X86_VENDOR_CENTAUR,	5 },
-	{ X86_VENDOR_INTEL,	5 },
-	{ X86_VENDOR_NSC,	5 },
-	{ X86_VENDOR_ANY,	4 },
+#define NO_SPECULATION	BIT(0)
+#define NO_MELTDOWN	BIT(1)
+#define NO_SSB		BIT(2)
+#define NO_L1TF		BIT(3)
+#define NO_MDS		BIT(4)
+#define MSBDS_ONLY	BIT(5)
+
+#define VULNWL(_vendor, _family, _model, _whitelist)	\
+	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
+
+#define VULNWL_INTEL(model, whitelist)		\
+	VULNWL(INTEL, 6, INTEL_FAM6_##model, whitelist)
+
+#define VULNWL_AMD(family, whitelist)		\
+	VULNWL(AMD, family, X86_MODEL_ANY, whitelist)
+
+static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] =3D {
+	VULNWL(ANY,	4, X86_MODEL_ANY,	NO_SPECULATION),
+	VULNWL(CENTAUR,	5, X86_MODEL_ANY,	NO_SPECULATION),
+	VULNWL(INTEL,	5, X86_MODEL_ANY,	NO_SPECULATION),
+	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
+
+	/* Intel Family 6 */
+	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION),
+	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION),
+	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION),
+	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION),
+	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION),
+
+	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+
+	VULNWL_INTEL(CORE_YONAH,		NO_SSB),
+
+	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY),
+
+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF),
+	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF),
+
+	/* AMD Family 0xf - 0x12 */
+	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
+	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
+	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
+	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
+
+	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS),
 	{}
 };
=20
-static const __initconst struct x86_cpu_id cpu_no_meltdown[] =3D {
-	{ X86_VENDOR_AMD },
-	{}
-};
-
-static const __initconst struct x86_cpu_id cpu_no_spec_store_bypass[] =3D {
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_PINEVIEW	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_LINCROFT	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_PENWELL		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_CLOVERVIEW	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_CEDARVIEW	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT1	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_AIRMONT		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT2	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_MERRIFIELD	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_CORE_YONAH		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNL		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNM		},
-	{ X86_VENDOR_CENTAUR,	5,					},
-	{ X86_VENDOR_INTEL,	5,					},
-	{ X86_VENDOR_NSC,	5,					},
-	{ X86_VENDOR_AMD,	0x12,					},
-	{ X86_VENDOR_AMD,	0x11,					},
-	{ X86_VENDOR_AMD,	0x10,					},
-	{ X86_VENDOR_AMD,	0xf,					},
-	{ X86_VENDOR_ANY,	4,					},
-	{}
-};
+static bool __init cpu_matches(unsigned long which)
+{
+	const struct x86_cpu_id *m =3D x86_match_cpu(cpu_vuln_whitelist);
=20
-static const __initconst struct x86_cpu_id cpu_no_l1tf[] =3D {
-	/* in addition to cpu_no_speculation */
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT1	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT2	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_AIRMONT		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_MERRIFIELD	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_MOOREFIELD	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_GOLDMONT	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_DENVERTON	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_GEMINI_LAKE	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNL		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNM		},
-	{}
-};
+	return m && !!(m->driver_data & which);
+}
=20
 static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 {
 	u64 ia32_cap =3D 0;
=20
+	if (cpu_matches(NO_SPECULATION))
+		return;
+
+	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
+	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
+
 	if (cpu_has(c, X86_FEATURE_ARCH_CAPABILITIES))
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, ia32_cap);
=20
-	if (!x86_match_cpu(cpu_no_spec_store_bypass) &&
-	   !(ia32_cap & ARCH_CAP_SSB_NO) &&
+	if (!cpu_matches(NO_SSB) && !(ia32_cap & ARCH_CAP_SSB_NO) &&
 	   !cpu_has(c, X86_FEATURE_AMD_SSB_NO))
 		setup_force_cpu_bug(X86_BUG_SPEC_STORE_BYPASS);
=20
-	if (x86_match_cpu(cpu_no_speculation))
-		return;
+	if (ia32_cap & ARCH_CAP_IBRS_ALL)
+		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
=20
-	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
-	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
+	if (!cpu_matches(NO_MDS) && !(ia32_cap & ARCH_CAP_MDS_NO)) {
+		setup_force_cpu_bug(X86_BUG_MDS);
+		if (cpu_matches(MSBDS_ONLY))
+			setup_force_cpu_bug(X86_BUG_MSBDS_ONLY);
+	}
=20
-	if (x86_match_cpu(cpu_no_meltdown))
+	if (cpu_matches(NO_MELTDOWN))
 		return;
=20
 	/* Rogue Data Cache Load? No! */
@@ -891,7 +904,7 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 =
*c)
=20
 	setup_force_cpu_bug(X86_BUG_CPU_MELTDOWN);
=20
-	if (x86_match_cpu(cpu_no_l1tf))
+	if (cpu_matches(NO_L1TF))
 		return;
=20
 	setup_force_cpu_bug(X86_BUG_L1TF);
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index aaf152e79637..15e47c1cd412 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -8,6 +8,7 @@
 #include <linux/timer.h>
 #include <asm/pci-direct.h>
 #include <asm/tsc.h>
+#include <asm/cpufeature.h>
=20
 #include "cpu.h"
=20
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1fda971a0726..759923b7a0bd 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -8,7 +8,7 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
=20
-#include <asm/processor.h>
+#include <asm/cpufeature.h>
 #include <asm/pgtable.h>
 #include <asm/msr.h>
 #include <asm/bugs.h>
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/in=
tel_cacheinfo.c
index 9c8f7394c612..8f9c0fd13643 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -15,7 +15,7 @@
 #include <linux/sched.h>
 #include <linux/pci.h>
=20
-#include <asm/processor.h>
+#include <asm/cpufeature.h>
 #include <linux/smp.h>
 #include <asm/amd_nb.h>
 #include <asm/smp.h>
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index afa9f0d487ea..fbb5e90557a5 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -1,5 +1,5 @@
 #include <asm/cpu_device_id.h>
-#include <asm/processor.h>
+#include <asm/cpufeature.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/arch/x86/kernel/cpu/mkcapflags.sh b/arch/x86/kernel/cpu/mkcapf=
lags.sh
index 2bf616505499..6425a3526450 100644
--- a/arch/x86/kernel/cpu/mkcapflags.sh
+++ b/arch/x86/kernel/cpu/mkcapflags.sh
@@ -1,23 +1,25 @@
 #!/bin/sh
 #
-# Generate the x86_cap_flags[] array from include/asm/cpufeature.h
+# Generate the x86_cap/bug_flags[] arrays from include/asm/cpufeatures.h
 #
=20
 IN=3D$1
 OUT=3D$2
=20
-TABS=3D"$(printf '\t\t\t\t\t')"
-trap 'rm "$OUT"' EXIT
+function dump_array()
+{
+	ARRAY=3D$1
+	SIZE=3D$2
+	PFX=3D$3
+	POSTFIX=3D$4
=20
-(
-	echo "#ifndef _ASM_X86_CPUFEATURE_H"
-	echo "#include <asm/cpufeature.h>"
-	echo "#endif"
-	echo ""
-	echo "const char * const x86_cap_flags[NCAPINTS*32] =3D {"
+	PFX_SZ=3D$(echo $PFX | wc -c)
+	TABS=3D"$(printf '\t\t\t\t\t')"
=20
-	# Iterate through any input lines starting with #define X86_FEATURE_
-	sed -n -e 's/\t/ /g' -e 's/^ *# *define *X86_FEATURE_//p' $IN |
+	echo "const char * const $ARRAY[$SIZE] =3D {"
+
+	# Iterate through any input lines starting with #define $PFX
+	sed -n -e 's/\t/ /g' -e "s/^ *# *define *$PFX//p" $IN |
 	while read i
 	do
 		# Name is everything up to the first whitespace
@@ -31,11 +33,32 @@ trap 'rm "$OUT"' EXIT
 		# Name is uppercase, VALUE is all lowercase
 		VALUE=3D"$(echo "$VALUE" | tr A-Z a-z)"
=20
-		TABCOUNT=3D$(( ( 5*8 - 14 - $(echo "$NAME" | wc -c) ) / 8 ))
-		printf "\t[%s]%.*s =3D %s,\n" \
-			"X86_FEATURE_$NAME" "$TABCOUNT" "$TABS" "$VALUE"
+        if [ -n "$POSTFIX" ]; then
+            T=3D$(( $PFX_SZ + $(echo $POSTFIX | wc -c) + 2 ))
+	        TABS=3D"$(printf '\t\t\t\t\t\t')"
+		    TABCOUNT=3D$(( ( 6*8 - ($T + 1) - $(echo "$NAME" | wc -c) ) / 8 ))
+		    printf "\t[%s - %s]%.*s =3D %s,\n" "$PFX$NAME" "$POSTFIX" "$TABCOUNT=
" "$TABS" "$VALUE"
+        else
+		    TABCOUNT=3D$(( ( 5*8 - ($PFX_SZ + 1) - $(echo "$NAME" | wc -c) ) / 8=
 ))
+            printf "\t[%s]%.*s =3D %s,\n" "$PFX$NAME" "$TABCOUNT" "$TABS" =
"$VALUE"
+        fi
 	done
 	echo "};"
+}
+
+trap 'rm "$OUT"' EXIT
+
+(
+	echo "#ifndef _ASM_X86_CPUFEATURES_H"
+	echo "#include <asm/cpufeatures.h>"
+	echo "#endif"
+	echo ""
+
+	dump_array "x86_cap_flags" "NCAPINTS*32" "X86_FEATURE_" ""
+	echo ""
+
+	dump_array "x86_bug_flags" "NBUGINTS*32" "X86_BUG_" "NCAPINTS*32"
+
 ) > $OUT
=20
 trap - EXIT
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/mai=
n.c
index f961de9964c7..44668915fa07 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -47,7 +47,7 @@
 #include <linux/smp.h>
 #include <linux/syscore_ops.h>
=20
-#include <asm/processor.h>
+#include <asm/cpufeature.h>
 #include <asm/e820.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 8d9c2afd16c6..4af9be1c07eb 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -97,6 +97,14 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		if (cpu_has(c, i) && x86_cap_flags[i] !=3D NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
=20
+	seq_printf(m, "\nbugs\t\t:");
+	for (i =3D 0; i < 32*NBUGINTS; i++) {
+		unsigned int bug_bit =3D 32*NCAPINTS + i;
+
+		if (cpu_has_bug(c, bug_bit) && x86_bug_flags[i])
+			seq_printf(m, " %s", x86_bug_flags[i]);
+	}
+
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
 		   c->loops_per_jiffy/(500000/HZ),
 		   (c->loops_per_jiffy/(5000/HZ)) % 100);
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmet=
a.c
index 3fa0e5ad86b4..825c4359656b 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -1,6 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <asm/processor.h>
+#include <asm/cpufeature.h>
 #include <asm/msr.h>
 #include "cpu.h"
=20
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 988c00a1f60d..2b6256bbaef6 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -24,6 +24,7 @@
 #include <asm/e820.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
+#include <asm/cpufeature.h>
=20
 /*
  * The e820 map is the map that gets modified e.g. with command line param=
eters
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 7e5dc491d619..0848c11285eb 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -54,7 +54,7 @@
 #include <asm/processor-flags.h>
 #include <asm/ftrace.h>
 #include <asm/irq_vectors.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/alternative-asm.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
@@ -443,6 +443,7 @@ ENTRY(ia32_sysenter_target)
 	testl $_TIF_ALLWORK_MASK, %ecx
 	jne sysexit_audit
 sysenter_exit:
+	MDS_USER_CLEAR_CPU_BUFFERS
 /* if something modifies registers it must also disable sysexit */
 	movl PT_EIP(%esp), %edx
 	movl PT_OLDESP(%esp), %ecx
@@ -531,6 +532,7 @@ ENTRY(system_call)
 	jne syscall_exit_work
=20
 restore_all:
+	MDS_USER_CLEAR_CPU_BUFFERS
 	TRACE_IRQS_IRET
 restore_all_notrace:
 #ifdef CONFIG_X86_ESPFIX32
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 280230fe7e49..6e5feb342ee4 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -475,6 +475,7 @@ GLOBAL(system_call_after_swapgs)
 	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
+	MDS_USER_CLEAR_CPU_BUFFERS
 	CFI_REMEMBER_STATE
 	/*
 	 * sysretq will re-enable interrupts:
@@ -870,6 +871,7 @@ retint_swapgs:		/* return to user-space */
 	 * The iretq could re-enable interrupts:
 	 */
 	DISABLE_INTERRUPTS(CLBR_ANY)
+	MDS_USER_CLEAR_CPU_BUFFERS
 	TRACE_IRQS_IRETQ
 	/*
 	 * This opens a window where we have a user CR3, but are
@@ -1384,7 +1386,7 @@ ENTRY(paranoid_exit)
 	GET_THREAD_INFO(%rcx)
 	movl TI_flags(%rcx),%ebx
 	andl $_TIF_WORK_MASK,%ebx
-	jz paranoid_kernel
+	jz paranoid_userspace_done
 	movq %rsp,%rdi			/* &pt_regs */
 	call sync_regs
 	movq %rax,%rsp			/* switch stack for scheduling */
@@ -1406,6 +1408,9 @@ ENTRY(paranoid_exit)
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	jmp paranoid_userspace
+paranoid_userspace_done:
+	MDS_USER_CLEAR_CPU_BUFFERS
+	jmp paranoid_kernel
 	CFI_ENDPROC
 END(paranoid_exit)
=20
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 879e67acf463..736330f96d93 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -19,7 +19,7 @@
 #include <asm/setup.h>
 #include <asm/processor-flags.h>
 #include <asm/msr-index.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/percpu.h>
 #include <asm/nops.h>
=20
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 319bcb9372fe..1a7ebfae9160 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -12,6 +12,7 @@
 #include <linux/pm.h>
 #include <linux/io.h>
=20
+#include <asm/cpufeature.h>
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 26d5a55a2736..e565e0e4d216 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -45,7 +45,7 @@ static void __jump_label_transform(struct jump_entry *ent=
ry,
 	const unsigned char default_nop[] =3D { STATIC_KEY_INIT_NOP };
 	const unsigned char *ideal_nop =3D ideal_nops[NOP_ATOMIC5];
=20
-	if (type =3D=3D JUMP_LABEL_ENABLE) {
+	if (type =3D=3D JUMP_LABEL_JMP) {
 		if (init) {
 			/*
 			 * Jump label is enabled for the first time.
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index c9603ac80de5..c6498fa99d2c 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -38,7 +38,7 @@
 #include <linux/uaccess.h>
 #include <linux/gfp.h>
=20
-#include <asm/processor.h>
+#include <asm/cpufeature.h>
 #include <asm/msr.h>
=20
 static struct class *msr_class;
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index d05bd2e2ee91..ee623917ff1d 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -29,6 +29,7 @@
 #include <asm/mach_traps.h>
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
+#include <asm/nospec-branch.h>
=20
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -522,6 +523,9 @@ do_nmi(struct pt_regs *regs, long error_code)
 		write_cr2(this_cpu_read(nmi_cr2));
 	if (this_cpu_dec_return(nmi_state))
 		goto nmi_restart;
+
+	if (user_mode(regs))
+		mds_user_clear_cpu_buffers();
 }
 NOKPROBE_SYMBOL(do_nmi);
=20
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 040e20ffb4be..074510b5ea77 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -32,6 +32,8 @@
 #include <asm/tlbflush.h>
 #include <asm/spec-ctrl.h>
=20
+#include "process.h"
+
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's. The TSS size is kept cacheline-aligned
@@ -197,11 +199,12 @@ int set_tsc_mode(unsigned int val)
 	return 0;
 }
=20
-static inline void switch_to_bitmap(struct tss_struct *tss,
-				    struct thread_struct *prev,
+static inline void switch_to_bitmap(struct thread_struct *prev,
 				    struct thread_struct *next,
 				    unsigned long tifp, unsigned long tifn)
 {
+	struct tss_struct *tss =3D this_cpu_ptr(&init_tss);
+
 	if (tifn & _TIF_IO_BITMAP) {
 		/*
 		 * Copy the relevant range of the IO bitmap.
@@ -335,32 +338,85 @@ static __always_inline void amd_set_ssb_virt_state(un=
signed long tifn)
 	wrmsrl(MSR_AMD64_VIRT_SPEC_CTRL, ssbd_tif_to_spec_ctrl(tifn));
 }
=20
-static __always_inline void intel_set_ssb_state(unsigned long tifn)
+/*
+ * Update the MSRs managing speculation control, during context switch.
+ *
+ * tifp: Previous task's thread flags
+ * tifn: Next task's thread flags
+ */
+static __always_inline void __speculation_ctrl_update(unsigned long tifp,
+						      unsigned long tifn)
 {
-	u64 msr =3D x86_spec_ctrl_base | ssbd_tif_to_spec_ctrl(tifn);
+	unsigned long tif_diff =3D tifp ^ tifn;
+	u64 msr =3D x86_spec_ctrl_base;
+	bool updmsr =3D false;
+
+	/*
+	 * If TIF_SSBD is different, select the proper mitigation
+	 * method. Note that if SSBD mitigation is disabled or permanentely
+	 * enabled this branch can't be taken because nothing can set
+	 * TIF_SSBD.
+	 */
+	if (tif_diff & _TIF_SSBD) {
+		if (static_cpu_has(X86_FEATURE_VIRT_SSBD)) {
+			amd_set_ssb_virt_state(tifn);
+		} else if (static_cpu_has(X86_FEATURE_LS_CFG_SSBD)) {
+			amd_set_core_ssb_state(tifn);
+		} else if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+			   static_cpu_has(X86_FEATURE_AMD_SSBD)) {
+			msr |=3D ssbd_tif_to_spec_ctrl(tifn);
+			updmsr  =3D true;
+		}
+	}
+
+	/*
+	 * Only evaluate TIF_SPEC_IB if conditional STIBP is enabled,
+	 * otherwise avoid the MSR write.
+	 */
+	if (IS_ENABLED(CONFIG_SMP) &&
+	    static_branch_unlikely(&switch_to_cond_stibp)) {
+		updmsr |=3D !!(tif_diff & _TIF_SPEC_IB);
+		msr |=3D stibp_tif_to_spec_ctrl(tifn);
+	}
=20
-	wrmsrl(MSR_IA32_SPEC_CTRL, msr);
+	if (updmsr)
+		wrmsrl(MSR_IA32_SPEC_CTRL, msr);
 }
=20
-static __always_inline void __speculative_store_bypass_update(unsigned lon=
g tifn)
+static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)
 {
-	if (static_cpu_has(X86_FEATURE_VIRT_SSBD))
-		amd_set_ssb_virt_state(tifn);
-	else if (static_cpu_has(X86_FEATURE_LS_CFG_SSBD))
-		amd_set_core_ssb_state(tifn);
-	else
-		intel_set_ssb_state(tifn);
+	if (test_and_clear_tsk_thread_flag(tsk, TIF_SPEC_FORCE_UPDATE)) {
+		if (task_spec_ssb_disable(tsk))
+			set_tsk_thread_flag(tsk, TIF_SSBD);
+		else
+			clear_tsk_thread_flag(tsk, TIF_SSBD);
+
+		if (task_spec_ib_disable(tsk))
+			set_tsk_thread_flag(tsk, TIF_SPEC_IB);
+		else
+			clear_tsk_thread_flag(tsk, TIF_SPEC_IB);
+	}
+	/* Return the updated threadinfo flags*/
+	return task_thread_info(tsk)->flags;
 }
=20
-void speculative_store_bypass_update(unsigned long tif)
+void speculation_ctrl_update(unsigned long tif)
 {
+	/* Forced update. Make sure all relevant TIF flags are different */
 	preempt_disable();
-	__speculative_store_bypass_update(tif);
+	__speculation_ctrl_update(~tif, tif);
 	preempt_enable();
 }
=20
-void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next=
_p,
-		      struct tss_struct *tss)
+/* Called from seccomp/prctl update */
+void speculation_ctrl_update_current(void)
+{
+	preempt_disable();
+	speculation_ctrl_update(speculation_ctrl_update_tif(current));
+	preempt_enable();
+}
+
+void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next=
_p)
 {
 	struct thread_struct *prev, *next;
 	unsigned long tifp, tifn;
@@ -370,7 +426,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struc=
t task_struct *next_p,
=20
 	tifn =3D ACCESS_ONCE(task_thread_info(next_p)->flags);
 	tifp =3D ACCESS_ONCE(task_thread_info(prev_p)->flags);
-	switch_to_bitmap(tss, prev, next, tifp, tifn);
+	switch_to_bitmap(prev, next, tifp, tifn);
=20
 	propagate_user_return_notify(prev_p, next_p);
=20
@@ -392,8 +448,15 @@ void __switch_to_xtra(struct task_struct *prev_p, stru=
ct task_struct *next_p,
 			hard_enable_TSC();
 	}
=20
-	if ((tifp ^ tifn) & _TIF_SSBD)
-		__speculative_store_bypass_update(tifn);
+	if (likely(!((tifp | tifn) & _TIF_SPEC_FORCE_UPDATE))) {
+		__speculation_ctrl_update(tifp, tifn);
+	} else {
+		speculation_ctrl_update_tif(prev_p);
+		tifn =3D speculation_ctrl_update_tif(next_p);
+
+		/* Enforce MSR update to ensure consistent state */
+		__speculation_ctrl_update(~tifn, tifn);
+	}
 }
=20
 /*
diff --git a/arch/x86/kernel/process.h b/arch/x86/kernel/process.h
new file mode 100644
index 000000000000..898e97cf6629
--- /dev/null
+++ b/arch/x86/kernel/process.h
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Code shared between 32 and 64 bit
+
+#include <asm/spec-ctrl.h>
+
+void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next=
_p);
+
+/*
+ * This needs to be inline to optimize for the common case where no extra
+ * work needs to be done.
+ */
+static inline void switch_to_extra(struct task_struct *prev,
+				   struct task_struct *next)
+{
+	unsigned long next_tif =3D task_thread_info(next)->flags;
+	unsigned long prev_tif =3D task_thread_info(prev)->flags;
+
+	if (IS_ENABLED(CONFIG_SMP)) {
+		/*
+		 * Avoid __switch_to_xtra() invocation when conditional
+		 * STIPB is disabled and the only different bit is
+		 * TIF_SPEC_IB. For CONFIG_SMP=3Dn TIF_SPEC_IB is not
+		 * in the TIF_WORK_CTXSW masks.
+		 */
+		if (!static_branch_likely(&switch_to_cond_stibp)) {
+			prev_tif &=3D ~_TIF_SPEC_IB;
+			next_tif &=3D ~_TIF_SPEC_IB;
+		}
+	}
+
+	/*
+	 * __switch_to_xtra() handles debug registers, i/o bitmaps,
+	 * speculation mitigations etc.
+	 */
+	if (unlikely(next_tif & _TIF_WORK_CTXSW_NEXT ||
+		     prev_tif & _TIF_WORK_CTXSW_PREV))
+		__switch_to_xtra(prev, next);
+}
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index c72b7afd3e02..3884a237de7e 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -55,6 +55,8 @@
 #include <asm/debugreg.h>
 #include <asm/switch_to.h>
=20
+#include "process.h"
+
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 asmlinkage void ret_from_kernel_thread(void) __asm__("ret_from_kernel_thre=
ad");
=20
@@ -298,12 +300,7 @@ __switch_to(struct task_struct *prev_p, struct task_st=
ruct *next_p)
 	task_thread_info(prev_p)->saved_preempt_count =3D this_cpu_read(__preempt=
_count);
 	this_cpu_write(__preempt_count, task_thread_info(next_p)->saved_preempt_c=
ount);
=20
-	/*
-	 * Now maybe handle debug registers and/or IO bitmaps
-	 */
-	if (unlikely(task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV ||
-		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
-		__switch_to_xtra(prev_p, next_p, tss);
+	switch_to_extra(prev_p, next_p);
=20
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 512fb8c979ed..7a476ca5bcc6 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -51,6 +51,8 @@
 #include <asm/switch_to.h>
 #include <asm/xen/hypervisor.h>
=20
+#include "process.h"
+
 asmlinkage extern void ret_from_fork(void);
=20
 __visible DEFINE_PER_CPU_USER_MAPPED(unsigned long, old_rsp);
@@ -428,12 +430,7 @@ __switch_to(struct task_struct *prev_p, struct task_st=
ruct *next_p)
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNEL_STACK_OFFSET);
=20
-	/*
-	 * Now maybe reload the debug registers and handle I/O bitmaps
-	 */
-	if (unlikely(task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT ||
-		     task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV))
-		__switch_to_xtra(prev_p, next_p, tss);
+	switch_to_extra(prev_p, next_p);
=20
 #ifdef CONFIG_XEN
 	/*
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 6e0df1be1c19..77a6f3b62786 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -55,6 +55,7 @@
 #include <asm/fixmap.h>
 #include <asm/mach_traps.h>
 #include <asm/alternative.h>
+#include <asm/nospec-branch.h>
=20
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -258,6 +259,14 @@ dotraplinkage void do_double_fault(struct pt_regs *reg=
s, long error_code)
 		normal_regs->orig_ax =3D 0;  /* Missing (lost) #GP error code */
 		regs->ip =3D (unsigned long)general_protection;
 		regs->sp =3D (unsigned long)&normal_regs->orig_ax;
+
+		/*
+		 * This situation can be triggered by userspace via
+		 * modify_ldt(2) and the return does not take the regular
+		 * user space exit, so a CPU buffer clear is required when
+		 * MDS mitigation is enabled.
+		 */
+		mds_user_clear_cpu_buffers();
 		return;
 	}
 #endif
diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index 4cf401f581e7..b7c9db5deebe 100644
--- a/arch/x86/kernel/verify_cpu.S
+++ b/arch/x86/kernel/verify_cpu.S
@@ -30,7 +30,7 @@
  * 	appropriately. Either display a message or halt.
  */
=20
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
=20
 verify_cpu:
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f4be930dffd1..95cd58cdee99 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -303,7 +303,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry=
2 *entry, u32 function,
 	/* cpuid 0x80000008.ebx */
 	const u32 kvm_cpuid_8000_0008_ebx_x86_features =3D
 		F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO);
+		F(AMD_SSB_NO) | F(AMD_STIBP);
=20
 	/* cpuid 0xC0000001.edx */
 	const u32 kvm_supported_word5_x86_features =3D
@@ -319,7 +319,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry=
2 *entry, u32 function,
=20
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =3D
-		F(SPEC_CTRL) | F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES);
+		F(SPEC_CTRL) | F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) |
+		F(INTEL_STIBP) | F(MD_CLEAR);
=20
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index 38e57faefd71..fc1f50f52751 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -56,7 +56,7 @@ ENDPROC(clear_page)
 	 *
 	 */
=20
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
=20
 	.section .altinstr_replacement,"ax"
 1:	.byte 0xeb					/* jmp <disp8> */
diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index f1ffdbb07755..e74d40ea865c 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -97,7 +97,7 @@ ENDPROC(copy_page)
 	/* Some CPUs run faster using the string copy instructions.
 	   It is also a lot simpler. Use this when possible */
=20
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
=20
 	.section .altinstr_replacement,"ax"
 1:	.byte 0xeb					/* jmp <disp8> */
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index fca1f3a32bf5..a515172a0126 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -14,7 +14,7 @@
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/alternative-asm.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index f7766e8a497d..da03a361c79f 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -2,7 +2,7 @@
=20
 #include <linux/linkage.h>
=20
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/dwarf2.h>
 #include <asm/alternative-asm.h>
=20
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index d290a599996c..6e231833f7d6 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -8,7 +8,7 @@
 #define _STRING_C
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/alternative-asm.h>
=20
 #undef memmove
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index aba502738043..de2cf322a786 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -2,7 +2,7 @@
=20
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/alternative-asm.h>
=20
 /*
diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
index e19f5476e218..36ea98019256 100644
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -3,7 +3,7 @@
 #include <linux/stringify.h>
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/alternative-asm.h>
 #include <asm/nospec-branch.h>
=20
diff --git a/arch/x86/mm/kaiser.c b/arch/x86/mm/kaiser.c
index 8a07537dae08..30d1958e0540 100644
--- a/arch/x86/mm/kaiser.c
+++ b/arch/x86/mm/kaiser.c
@@ -10,6 +10,7 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
+#include <linux/cpu.h>
 #include <xen/xen.h>
=20
 #undef pr_fmt
@@ -294,7 +295,8 @@ void __init kaiser_check_boottime_disable(void)
 			goto skip;
 	}
=20
-	if (cmdline_find_option_bool(boot_command_line, "nopti"))
+	if (cmdline_find_option_bool(boot_command_line, "nopti") ||
+	    cpu_mitigations_off())
 		goto disable;
=20
 skip:
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index 90555bf60aa4..6c2c9b0b9b9b 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -4,6 +4,7 @@
=20
 #include <asm/pgtable.h>
 #include <asm/proto.h>
+#include <asm/cpufeature.h>
=20
 static int disable_nx;
=20
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 71b450232c7a..9e633086f1de 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -33,6 +33,12 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbs=
tate)
  *	Implement flush IPI by CALL_FUNCTION_VECTOR, Alex Shi
  */
=20
+/*
+ * Use bit 0 to mangle the TIF_SPEC_IB state into the mm pointer which is
+ * stored in cpu_tlb_state.last_user_mm_ibpb.
+ */
+#define LAST_USER_MM_IBPB	0x1UL
+
 struct flush_tlb_info {
 	struct mm_struct *flush_mm;
 	unsigned long flush_start;
@@ -95,6 +101,89 @@ void switch_mm(struct mm_struct *prev, struct mm_struct=
 *next,
 	local_irq_restore(flags);
 }
=20
+static inline unsigned long mm_mangle_tif_spec_ib(struct task_struct *next)
+{
+	unsigned long next_tif =3D task_thread_info(next)->flags;
+	unsigned long ibpb =3D (next_tif >> TIF_SPEC_IB) & LAST_USER_MM_IBPB;
+
+	return (unsigned long)next->mm | ibpb;
+}
+
+static void cond_ibpb(struct task_struct *next)
+{
+	if (!next || !next->mm)
+		return;
+
+	/*
+	 * Both, the conditional and the always IBPB mode use the mm
+	 * pointer to avoid the IBPB when switching between tasks of the
+	 * same process. Using the mm pointer instead of mm->context.ctx_id
+	 * opens a hypothetical hole vs. mm_struct reuse, which is more or
+	 * less impossible to control by an attacker. Aside of that it
+	 * would only affect the first schedule so the theoretically
+	 * exposed data is not really interesting.
+	 */
+	if (static_branch_likely(&switch_mm_cond_ibpb)) {
+		unsigned long prev_mm, next_mm;
+
+		/*
+		 * This is a bit more complex than the always mode because
+		 * it has to handle two cases:
+		 *
+		 * 1) Switch from a user space task (potential attacker)
+		 *    which has TIF_SPEC_IB set to a user space task
+		 *    (potential victim) which has TIF_SPEC_IB not set.
+		 *
+		 * 2) Switch from a user space task (potential attacker)
+		 *    which has TIF_SPEC_IB not set to a user space task
+		 *    (potential victim) which has TIF_SPEC_IB set.
+		 *
+		 * This could be done by unconditionally issuing IBPB when
+		 * a task which has TIF_SPEC_IB set is either scheduled in
+		 * or out. Though that results in two flushes when:
+		 *
+		 * - the same user space task is scheduled out and later
+		 *   scheduled in again and only a kernel thread ran in
+		 *   between.
+		 *
+		 * - a user space task belonging to the same process is
+		 *   scheduled in after a kernel thread ran in between
+		 *
+		 * - a user space task belonging to the same process is
+		 *   scheduled in immediately.
+		 *
+		 * Optimize this with reasonably small overhead for the
+		 * above cases. Mangle the TIF_SPEC_IB bit into the mm
+		 * pointer of the incoming task which is stored in
+		 * cpu_tlbstate.last_user_mm_ibpb for comparison.
+		 */
+		next_mm =3D mm_mangle_tif_spec_ib(next);
+		prev_mm =3D this_cpu_read(cpu_tlbstate.last_user_mm_ibpb);
+
+		/*
+		 * Issue IBPB only if the mm's are different and one or
+		 * both have the IBPB bit set.
+		 */
+		if (next_mm !=3D prev_mm &&
+		    (next_mm | prev_mm) & LAST_USER_MM_IBPB)
+			indirect_branch_prediction_barrier();
+
+		this_cpu_write(cpu_tlbstate.last_user_mm_ibpb, next_mm);
+	}
+
+	if (static_branch_unlikely(&switch_mm_always_ibpb)) {
+		/*
+		 * Only flush when switching to a user space task with a
+		 * different context than the user space task which ran
+		 * last on this CPU.
+		 */
+		if (this_cpu_read(cpu_tlbstate.last_user_mm) !=3D next->mm) {
+			indirect_branch_prediction_barrier();
+			this_cpu_write(cpu_tlbstate.last_user_mm, next->mm);
+		}
+	}
+}
+
 void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 			struct task_struct *tsk)
 {
@@ -105,19 +194,8 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct=
 mm_struct *next,
 		 * Avoid user/user BTB poisoning by flushing the branch
 		 * predictor when switching between processes. This stops
 		 * one process from doing Spectre-v2 attacks on another.
-		 *
-		 * As an optimization, flush indirect branches only when
-		 * switching into processes that disable dumping. This
-		 * protects high value processes like gpg, without having
-		 * too high performance overhead. IBPB is *expensive*!
-		 *
-		 * This will not flush branches when switching into kernel
-		 * threads. It will flush if we switch to a different non-
-		 * dumpable process.
 		 */
-		if (tsk && tsk->mm &&
-		    get_dumpable(tsk->mm) !=3D SUID_DUMP_USER)
-			indirect_branch_prediction_barrier();
+		cond_ibpb(tsk);
=20
 		this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		this_cpu_write(cpu_tlbstate.active_mm, next);
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_=
amd.c
index 50d86c0e9ba4..660a83c8287b 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -24,7 +24,6 @@
 #include <asm/nmi.h>
 #include <asm/apic.h>
 #include <asm/processor.h>
-#include <asm/cpufeature.h>
=20
 #include "op_x86_model.h"
 #include "op_counter.h"
diff --git a/arch/x86/um/asm/barrier.h b/arch/x86/um/asm/barrier.h
index cc04e67bfd05..1df4eaecd919 100644
--- a/arch/x86/um/asm/barrier.h
+++ b/arch/x86/um/asm/barrier.h
@@ -3,7 +3,7 @@
=20
 #include <asm/asm.h>
 #include <asm/segment.h>
-#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
 #include <asm/cmpxchg.h>
 #include <asm/nops.h>
=20
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index e4c1a14107a4..3fda465f40e0 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/mm_types.h>
=20
-#include <asm/cpufeature.h>
 #include <asm/processor.h>
 #include <asm/vdso.h>
=20
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 91b2677213cf..519e96e4318a 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -17,6 +17,7 @@
 #include <asm/vdso.h>
 #include <asm/page.h>
 #include <asm/hpet.h>
+#include <asm/cpufeature.h>
=20
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled =3D 1;
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index c55acc37fef2..2f22e8960d8a 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -450,11 +450,18 @@ ssize_t __weak cpu_show_l1tf(struct device *dev,
 	return sprintf(buf, "Not affected\n");
 }
=20
+ssize_t __weak cpu_show_mds(struct device *dev,
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
+static DEVICE_ATTR(mds, 0444, cpu_show_mds, NULL);
=20
 static struct attribute *cpu_root_vulnerabilities_attrs[] =3D {
 	&dev_attr_meltdown.attr,
@@ -462,6 +469,7 @@ static struct attribute *cpu_root_vulnerabilities_attrs=
[] =3D {
 	&dev_attr_spectre_v2.attr,
 	&dev_attr_spec_store_bypass.attr,
 	&dev_attr_l1tf.attr,
+	&dev_attr_mds.attr,
 	NULL
 };
=20
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ac169482c507..356c94d46b3a 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -49,6 +49,8 @@ extern ssize_t cpu_show_spec_store_bypass(struct device *=
dev,
 					  struct device_attribute *attr, char *buf);
 extern ssize_t cpu_show_l1tf(struct device *dev,
 			     struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_mds(struct device *dev,
+			    struct device_attribute *attr, char *buf);
=20
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
@@ -275,4 +277,21 @@ void arch_cpu_idle_enter(void);
 void arch_cpu_idle_exit(void);
 void arch_cpu_idle_dead(void);
=20
+/*
+ * These are used for a global "mitigations=3D" cmdline option for toggling
+ * optional CPU mitigations.
+ */
+enum cpu_mitigations {
+	CPU_MITIGATIONS_OFF,
+	CPU_MITIGATIONS_AUTO,
+};
+
+extern enum cpu_mitigations cpu_mitigations;
+
+/* mitigations=3Doff */
+static inline bool cpu_mitigations_off(void)
+{
+	return cpu_mitigations =3D=3D CPU_MITIGATIONS_OFF;
+}
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index f0d0cc763236..a94aee4619dd 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -7,44 +7,72 @@
  * Copyright (C) 2009-2012 Jason Baron <jbaron@redhat.com>
  * Copyright (C) 2011-2012 Peter Zijlstra <pzijlstr@redhat.com>
  *
+ * DEPRECATED API:
+ *
+ * The use of 'struct static_key' directly, is now DEPRECATED. In addition
+ * static_key_{true,false}() is also DEPRECATED. IE DO NOT use the followi=
ng:
+ *
+ * struct static_key false =3D STATIC_KEY_INIT_FALSE;
+ * struct static_key true =3D STATIC_KEY_INIT_TRUE;
+ * static_key_true()
+ * static_key_false()
+ *
+ * The updated API replacements are:
+ *
+ * DEFINE_STATIC_KEY_TRUE(key);
+ * DEFINE_STATIC_KEY_FALSE(key);
+ * static_branch_likely()
+ * static_branch_unlikely()
+ *
  * Jump labels provide an interface to generate dynamic branches using
- * self-modifying code. Assuming toolchain and architecture support the re=
sult
- * of a "if (static_key_false(&key))" statement is a unconditional branch =
(which
- * defaults to false - and the true block is placed out of line).
+ * self-modifying code. Assuming toolchain and architecture support, if we
+ * define a "key" that is initially false via "DEFINE_STATIC_KEY_FALSE(key=
)",
+ * an "if (static_branch_unlikely(&key))" statement is an unconditional br=
anch
+ * (which defaults to false - and the true block is placed out of line).
+ * Similarly, we can define an initially true key via
+ * "DEFINE_STATIC_KEY_TRUE(key)", and use it in the same
+ * "if (static_branch_unlikely(&key))", in which case we will generate an
+ * unconditional branch to the out-of-line true branch. Keys that are
+ * initially true or false can be using in both static_branch_unlikely()
+ * and static_branch_likely() statements.
  *
- * However at runtime we can change the branch target using
- * static_key_slow_{inc,dec}(). These function as a 'reference' count on t=
he key
- * object and for as long as there are references all branches referring to
- * that particular key will point to the (out of line) true block.
+ * At runtime we can change the branch target by setting the key
+ * to true via a call to static_branch_enable(), or false using
+ * static_branch_disable(). If the direction of the branch is switched by
+ * these calls then we run-time modify the branch target via a
+ * no-op -> jump or jump -> no-op conversion. For example, for an
+ * initially false key that is used in an "if (static_branch_unlikely(&key=
))"
+ * statement, setting the key to true requires us to patch in a jump
+ * to the out-of-line of true branch.
  *
- * Since this relies on modifying code the static_key_slow_{inc,dec}() fun=
ctions
+ * In addition to static_branch_{enable,disable}, we can also reference co=
unt
+ * the key or branch direction via static_branch_{inc,dec}. Thus,
+ * static_branch_inc() can be thought of as a 'make more true' and
+ * static_branch_dec() as a 'make more false'.
+ *
+ * Since this relies on modifying code, the branch modifying functions
  * must be considered absolute slow paths (machine wide synchronization et=
c.).
- * OTOH, since the affected branches are unconditional their runtime overh=
ead
+ * OTOH, since the affected branches are unconditional, their runtime over=
head
  * will be absolutely minimal, esp. in the default (off) case where the to=
tal
  * effect is a single NOP of appropriate size. The on case will patch in a=
 jump
  * to the out-of-line block.
  *
- * When the control is directly exposed to userspace it is prudent to dela=
y the
+ * When the control is directly exposed to userspace, it is prudent to del=
ay the
  * decrement to avoid high frequency code modifications which can (and do)
  * cause significant performance degradation. Struct static_key_deferred a=
nd
  * static_key_slow_dec_deferred() provide for this.
  *
- * Lacking toolchain and or architecture support, it falls back to a simple
- * conditional branch.
- *
- * struct static_key my_key =3D STATIC_KEY_INIT_TRUE;
- *
- *   if (static_key_true(&my_key)) {
- *   }
- *
- * will result in the true case being in-line and starts the key with a si=
ngle
- * reference. Mixing static_key_true() and static_key_false() on the same =
key is not
- * allowed.
- *
- * Not initializing the key (static data is initialized to 0s anyway) is t=
he
- * same as using STATIC_KEY_INIT_FALSE.
+ * Lacking toolchain and or architecture support, static keys fall back to=
 a
+ * simple conditional branch.
  *
-*/
+ * Additional babbling in: Documentation/static-keys.txt
+ */
+
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+# define HAVE_JUMP_LABEL
+#endif
+
+#ifndef __ASSEMBLY__
=20
 #include <linux/types.h>
 #include <linux/compiler.h>
@@ -56,7 +84,7 @@ extern bool static_key_initialized;
 				    "%s used before call to jump_label_init", \
 				    __func__)
=20
-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+#ifdef HAVE_JUMP_LABEL
=20
 struct static_key {
 	atomic_t enabled;
@@ -67,57 +95,52 @@ struct static_key {
 #endif
 };
=20
-# include <asm/jump_label.h>
-# define HAVE_JUMP_LABEL
 #else
 struct static_key {
 	atomic_t enabled;
 };
-#endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
+#endif	/* HAVE_JUMP_LABEL */
+#endif /* __ASSEMBLY__ */
+
+#ifdef HAVE_JUMP_LABEL
+#include <asm/jump_label.h>
+#endif
+
+#ifndef __ASSEMBLY__
=20
 enum jump_label_type {
-	JUMP_LABEL_DISABLE =3D 0,
-	JUMP_LABEL_ENABLE,
+	JUMP_LABEL_NOP =3D 0,
+	JUMP_LABEL_JMP,
 };
=20
 struct module;
=20
 #include <linux/atomic.h>
=20
-static inline int static_key_count(struct static_key *key)
-{
-	return atomic_read(&key->enabled);
-}
-
 #ifdef HAVE_JUMP_LABEL
=20
-#define JUMP_LABEL_TYPE_FALSE_BRANCH	0UL
-#define JUMP_LABEL_TYPE_TRUE_BRANCH	1UL
-#define JUMP_LABEL_TYPE_MASK		1UL
-
-static
-inline struct jump_entry *jump_label_get_entries(struct static_key *key)
+static inline int static_key_count(struct static_key *key)
 {
-	return (struct jump_entry *)((unsigned long)key->entries
-						& ~JUMP_LABEL_TYPE_MASK);
+	/*
+	 * -1 means the first static_key_slow_inc() is in progress.
+	 *  static_key_enabled() must return true, so return 1 here.
+	 */
+	int n =3D atomic_read(&key->enabled);
+	return n >=3D 0 ? n : 1;
 }
=20
-static inline bool jump_label_get_branch_default(struct static_key *key)
-{
-	if (((unsigned long)key->entries & JUMP_LABEL_TYPE_MASK) =3D=3D
-	    JUMP_LABEL_TYPE_TRUE_BRANCH)
-		return true;
-	return false;
-}
+#define JUMP_TYPE_FALSE	0UL
+#define JUMP_TYPE_TRUE	1UL
+#define JUMP_TYPE_MASK	1UL
=20
 static __always_inline bool static_key_false(struct static_key *key)
 {
-	return arch_static_branch(key);
+	return arch_static_branch(key, false);
 }
=20
 static __always_inline bool static_key_true(struct static_key *key)
 {
-	return !static_key_false(key);
+	return !arch_static_branch(key, true);
 }
=20
 extern struct jump_entry __start___jump_table[];
@@ -135,15 +158,20 @@ extern void static_key_slow_inc(struct static_key *ke=
y);
 extern void static_key_slow_dec(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
=20
-#define STATIC_KEY_INIT_TRUE ((struct static_key)		\
+#define STATIC_KEY_INIT_TRUE					\
 	{ .enabled =3D ATOMIC_INIT(1),				\
-	  .entries =3D (void *)JUMP_LABEL_TYPE_TRUE_BRANCH })
-#define STATIC_KEY_INIT_FALSE ((struct static_key)		\
+	  .entries =3D (void *)JUMP_TYPE_TRUE }
+#define STATIC_KEY_INIT_FALSE					\
 	{ .enabled =3D ATOMIC_INIT(0),				\
-	  .entries =3D (void *)JUMP_LABEL_TYPE_FALSE_BRANCH })
+	  .entries =3D (void *)JUMP_TYPE_FALSE }
=20
 #else  /* !HAVE_JUMP_LABEL */
=20
+static inline int static_key_count(struct static_key *key)
+{
+	return atomic_read(&key->enabled);
+}
+
 static __always_inline void jump_label_init(void)
 {
 	static_key_initialized =3D true;
@@ -188,21 +216,14 @@ static inline int jump_label_apply_nops(struct module=
 *mod)
 	return 0;
 }
=20
-#define STATIC_KEY_INIT_TRUE ((struct static_key) \
-		{ .enabled =3D ATOMIC_INIT(1) })
-#define STATIC_KEY_INIT_FALSE ((struct static_key) \
-		{ .enabled =3D ATOMIC_INIT(0) })
+#define STATIC_KEY_INIT_TRUE	{ .enabled =3D ATOMIC_INIT(1) }
+#define STATIC_KEY_INIT_FALSE	{ .enabled =3D ATOMIC_INIT(0) }
=20
 #endif	/* HAVE_JUMP_LABEL */
=20
 #define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
 #define jump_label_enabled static_key_enabled
=20
-static inline bool static_key_enabled(struct static_key *key)
-{
-	return static_key_count(key) > 0;
-}
-
 static inline void static_key_enable(struct static_key *key)
 {
 	int count =3D static_key_count(key);
@@ -223,4 +244,152 @@ static inline void static_key_disable(struct static_k=
ey *key)
 		static_key_slow_dec(key);
 }
=20
+/* -----------------------------------------------------------------------=
--- */
+
+/*
+ * Two type wrappers around static_key, such that we can use compile time
+ * type differentiation to emit the right code.
+ *
+ * All the below code is macros in order to play type games.
+ */
+
+struct static_key_true {
+	struct static_key key;
+};
+
+struct static_key_false {
+	struct static_key key;
+};
+
+#define STATIC_KEY_TRUE_INIT  (struct static_key_true) { .key =3D STATIC_K=
EY_INIT_TRUE,  }
+#define STATIC_KEY_FALSE_INIT (struct static_key_false){ .key =3D STATIC_K=
EY_INIT_FALSE, }
+
+#define DEFINE_STATIC_KEY_TRUE(name)	\
+	struct static_key_true name =3D STATIC_KEY_TRUE_INIT
+
+#define DECLARE_STATIC_KEY_TRUE(name)	\
+	extern struct static_key_true name
+
+#define DEFINE_STATIC_KEY_FALSE(name)	\
+	struct static_key_false name =3D STATIC_KEY_FALSE_INIT
+
+#define DECLARE_STATIC_KEY_FALSE(name)	\
+	extern struct static_key_false name
+
+extern bool ____wrong_branch_error(void);
+
+#define static_key_enabled(x)							\
+({										\
+	if (!__builtin_types_compatible_p(typeof(*x), struct static_key) &&	\
+	    !__builtin_types_compatible_p(typeof(*x), struct static_key_true) &&\
+	    !__builtin_types_compatible_p(typeof(*x), struct static_key_false))	\
+		____wrong_branch_error();					\
+	static_key_count((struct static_key *)x) > 0;				\
+})
+
+#ifdef HAVE_JUMP_LABEL
+
+/*
+ * Combine the right initial value (type) with the right branch order
+ * to generate the desired result.
+ *
+ *
+ * type\branch|	likely (1)	      |	unlikely (0)
+ * -----------+-----------------------+------------------
+ *            |                       |
+ *  true (1)  |	   ...		      |	   ...
+ *            |    NOP		      |	   JMP L
+ *            |    <br-stmts>	      |	1: ...
+ *            |	L: ...		      |
+ *            |			      |
+ *            |			      |	L: <br-stmts>
+ *            |			      |	   jmp 1b
+ *            |                       |
+ * -----------+-----------------------+------------------
+ *            |                       |
+ *  false (0) |	   ...		      |	   ...
+ *            |    JMP L	      |	   NOP
+ *            |    <br-stmts>	      |	1: ...
+ *            |	L: ...		      |
+ *            |			      |
+ *            |			      |	L: <br-stmts>
+ *            |			      |	   jmp 1b
+ *            |                       |
+ * -----------+-----------------------+------------------
+ *
+ * The initial value is encoded in the LSB of static_key::entries,
+ * type: 0 =3D false, 1 =3D true.
+ *
+ * The branch type is encoded in the LSB of jump_entry::key,
+ * branch: 0 =3D unlikely, 1 =3D likely.
+ *
+ * This gives the following logic table:
+ *
+ *	enabled	type	branch	  instuction
+ * -----------------------------+-----------
+ *	0	0	0	| NOP
+ *	0	0	1	| JMP
+ *	0	1	0	| NOP
+ *	0	1	1	| JMP
+ *
+ *	1	0	0	| JMP
+ *	1	0	1	| NOP
+ *	1	1	0	| JMP
+ *	1	1	1	| NOP
+ *
+ * Which gives the following functions:
+ *
+ *   dynamic: instruction =3D enabled ^ branch
+ *   static:  instruction =3D type ^ branch
+ *
+ * See jump_label_type() / jump_label_init_type().
+ */
+
+#define static_branch_likely(x)							\
+({										\
+	bool branch;								\
+	if (__builtin_types_compatible_p(typeof(*x), struct static_key_true))	\
+		branch =3D !arch_static_branch(&(x)->key, true);			\
+	else if (__builtin_types_compatible_p(typeof(*x), struct static_key_false=
)) \
+		branch =3D !arch_static_branch_jump(&(x)->key, true);		\
+	else									\
+		branch =3D ____wrong_branch_error();				\
+	branch;									\
+})
+
+#define static_branch_unlikely(x)						\
+({										\
+	bool branch;								\
+	if (__builtin_types_compatible_p(typeof(*x), struct static_key_true))	\
+		branch =3D arch_static_branch_jump(&(x)->key, false);		\
+	else if (__builtin_types_compatible_p(typeof(*x), struct static_key_false=
)) \
+		branch =3D arch_static_branch(&(x)->key, false);			\
+	else									\
+		branch =3D ____wrong_branch_error();				\
+	branch;									\
+})
+
+#else /* !HAVE_JUMP_LABEL */
+
+#define static_branch_likely(x)		likely(static_key_enabled(&(x)->key))
+#define static_branch_unlikely(x)	unlikely(static_key_enabled(&(x)->key))
+
+#endif /* HAVE_JUMP_LABEL */
+
+/*
+ * Advanced usage; refcount, branch is enabled when: count !=3D 0
+ */
+
+#define static_branch_inc(x)		static_key_slow_inc(&(x)->key)
+#define static_branch_dec(x)		static_key_slow_dec(&(x)->key)
+
+/*
+ * Normal usage; boolean enable/disable.
+ */
+
+#define static_branch_enable(x)		static_key_enable(&(x)->key)
+#define static_branch_disable(x)	static_key_disable(&(x)->key)
+
 #endif	/* _LINUX_JUMP_LABEL_H */
+
+#endif /* __ASSEMBLY__ */
diff --git a/include/linux/module.h b/include/linux/module.h
index e18bd2ff1346..e0997e297af6 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -408,6 +408,11 @@ static inline int within_module_init(unsigned long add=
r, const struct module *mo
 	       addr < (unsigned long)mod->module_init + mod->init_size;
 }
=20
+static inline int within_module(unsigned long addr, const struct module *m=
od)
+{
+	return within_module_init(addr, mod) || within_module_core(addr, mod);
+}
+
 /* Search for module by name: must hold module_mutex. */
 struct module *find_module(const char *name);
=20
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 5af4994cac23..00f58dfc4d94 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -59,14 +59,17 @@ extern void exit_ptrace(struct task_struct *tracer);
 #define PTRACE_MODE_READ	0x01
 #define PTRACE_MODE_ATTACH	0x02
 #define PTRACE_MODE_NOAUDIT	0x04
-#define PTRACE_MODE_FSCREDS 0x08
-#define PTRACE_MODE_REALCREDS 0x10
+#define PTRACE_MODE_FSCREDS	0x08
+#define PTRACE_MODE_REALCREDS	0x10
+#define PTRACE_MODE_SCHED	0x20
+#define PTRACE_MODE_IBPB	0x40
=20
 /* shorthands for READ/ATTACH and FSCREDS/REALCREDS combinations */
 #define PTRACE_MODE_READ_FSCREDS (PTRACE_MODE_READ | PTRACE_MODE_FSCREDS)
 #define PTRACE_MODE_READ_REALCREDS (PTRACE_MODE_READ | PTRACE_MODE_REALCRE=
DS)
 #define PTRACE_MODE_ATTACH_FSCREDS (PTRACE_MODE_ATTACH | PTRACE_MODE_FSCRE=
DS)
 #define PTRACE_MODE_ATTACH_REALCREDS (PTRACE_MODE_ATTACH | PTRACE_MODE_REA=
LCREDS)
+#define PTRACE_MODE_SPEC_IBPB (PTRACE_MODE_ATTACH_REALCREDS | PTRACE_MODE_=
IBPB)
=20
 /**
  * ptrace_may_access - check whether the caller is permitted to access
@@ -84,6 +87,20 @@ extern void exit_ptrace(struct task_struct *tracer);
  */
 extern bool ptrace_may_access(struct task_struct *task, unsigned int mode);
=20
+/**
+ * ptrace_may_access - check whether the caller is permitted to access
+ * a target task.
+ * @task: target task
+ * @mode: selects type of access and caller credentials
+ *
+ * Returns true on success, false on denial.
+ *
+ * Similar to ptrace_may_access(). Only to be called from context switch
+ * code. Does not call into audit and the regular LSM hooks due to locking
+ * constraints.
+ */
+extern bool ptrace_may_access_sched(struct task_struct *task, unsigned int=
 mode);
+
 static inline int ptrace_reparented(struct task_struct *child)
 {
 	return !same_thread_group(child->real_parent, child->parent);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9daa104bcb42..f3e261e82a94 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1975,6 +1975,8 @@ static inline void memalloc_noio_restore(unsigned int=
 flags)
 #define PFA_SPREAD_SLAB  2      /* Spread some slab caches over cpuset */
 #define PFA_SPEC_SSB_DISABLE 3	/* Speculative Store Bypass disabled */
 #define PFA_SPEC_SSB_FORCE_DISABLE 4	/* Speculative Store Bypass force dis=
abled*/
+#define PFA_SPEC_IB_DISABLE		5	/* Indirect branch speculation restricted */
+#define PFA_SPEC_IB_FORCE_DISABLE	6	/* Indirect branch speculation permane=
ntly restricted */
=20
 #define TASK_PFA_TEST(name, func)					\
 	static inline bool task_##func(struct task_struct *p)		\
@@ -2004,6 +2006,13 @@ TASK_PFA_CLEAR(SPEC_SSB_DISABLE, spec_ssb_disable)
 TASK_PFA_TEST(SPEC_SSB_FORCE_DISABLE, spec_ssb_force_disable)
 TASK_PFA_SET(SPEC_SSB_FORCE_DISABLE, spec_ssb_force_disable)
=20
+TASK_PFA_TEST(SPEC_IB_DISABLE, spec_ib_disable)
+TASK_PFA_SET(SPEC_IB_DISABLE, spec_ib_disable)
+TASK_PFA_CLEAR(SPEC_IB_DISABLE, spec_ib_disable)
+
+TASK_PFA_TEST(SPEC_IB_FORCE_DISABLE, spec_ib_force_disable)
+TASK_PFA_SET(SPEC_IB_FORCE_DISABLE, spec_ib_force_disable)
+
 /*
  * task->jobctl flags
  */
diff --git a/include/linux/sched/smt.h b/include/linux/sched/smt.h
new file mode 100644
index 000000000000..559ac4590593
--- /dev/null
+++ b/include/linux/sched/smt.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SCHED_SMT_H
+#define _LINUX_SCHED_SMT_H
+
+#include <linux/atomic.h>
+
+#ifdef CONFIG_SCHED_SMT
+extern atomic_t sched_smt_present;
+
+static __always_inline bool sched_smt_active(void)
+{
+	return atomic_read(&sched_smt_present);
+}
+#else
+static inline bool sched_smt_active(void) { return false; }
+#endif
+
+void arch_smt_update(void);
+
+#endif
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 24a1ccbcafa7..b873affd5f6e 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -157,6 +157,7 @@
 #define PR_SET_SPECULATION_CTRL		53
 /* Speculation control variants */
 # define PR_SPEC_STORE_BYPASS		0
+# define PR_SPEC_INDIRECT_BRANCH	1
 /* Return and control values for PR_SET/GET_SPECULATION_CTRL */
 # define PR_SPEC_NOT_AFFECTED		0
 # define PR_SPEC_PRCTL			(1UL << 0)
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e160b9b065e6..ccfcd542efeb 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/notifier.h>
 #include <linux/sched.h>
+#include <linux/sched/smt.h>
 #include <linux/unistd.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
@@ -179,6 +180,12 @@ void cpu_hotplug_enable(void)
=20
 #endif	/* CONFIG_HOTPLUG_CPU */
=20
+/*
+ * Architectures that need SMT-specific errata handling during SMT hotplug
+ * should override this.
+ */
+void __weak arch_smt_update(void) { }
+
 /* Need to know about CPUs going up/down? */
 int __ref register_cpu_notifier(struct notifier_block *nb)
 {
@@ -394,6 +401,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_=
frozen)
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
+	arch_smt_update();
 	return err;
 }
=20
@@ -495,7 +503,7 @@ static int _cpu_up(unsigned int cpu, int tasks_frozen)
 		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
 out:
 	cpu_hotplug_done();
-
+	arch_smt_update();
 	return ret;
 }
=20
@@ -787,3 +795,16 @@ void init_cpu_online(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_online_bits), src);
 }
+
+enum cpu_mitigations cpu_mitigations =3D CPU_MITIGATIONS_AUTO;
+
+static int __init mitigations_parse_cmdline(char *arg)
+{
+	if (!strcmp(arg, "off"))
+		cpu_mitigations =3D CPU_MITIGATIONS_OFF;
+	else if (!strcmp(arg, "auto"))
+		cpu_mitigations =3D CPU_MITIGATIONS_AUTO;
+
+	return 0;
+}
+early_param("mitigations", mitigations_parse_cmdline);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 7d4d0a917d13..94052786d616 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -54,22 +54,40 @@ jump_label_sort_entries(struct jump_entry *start, struc=
t jump_entry *stop)
 	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
 }
=20
-static void jump_label_update(struct static_key *key, int enable);
+static void jump_label_update(struct static_key *key);
=20
 void static_key_slow_inc(struct static_key *key)
 {
+	int v, v1;
+
 	STATIC_KEY_CHECK_USE();
-	if (atomic_inc_not_zero(&key->enabled))
-		return;
+
+	/*
+	 * Careful if we get concurrent static_key_slow_inc() calls;
+	 * later calls must wait for the first one to _finish_ the
+	 * jump_label_update() process.  At the same time, however,
+	 * the jump_label_update() call below wants to see
+	 * static_key_enabled(&key) for jumps to be updated properly.
+	 *
+	 * So give a special meaning to negative key->enabled: it sends
+	 * static_key_slow_inc() down the slow path, and it is non-zero
+	 * so it counts as "enabled" in jump_label_update().  Note that
+	 * atomic_inc_unless_negative() checks >=3D 0, so roll our own.
+	 */
+	for (v =3D atomic_read(&key->enabled); v > 0; v =3D v1) {
+		v1 =3D atomic_cmpxchg(&key->enabled, v, v + 1);
+		if (likely(v1 =3D=3D v))
+			return;
+	}
=20
 	jump_label_lock();
 	if (atomic_read(&key->enabled) =3D=3D 0) {
-		if (!jump_label_get_branch_default(key))
-			jump_label_update(key, JUMP_LABEL_ENABLE);
-		else
-			jump_label_update(key, JUMP_LABEL_DISABLE);
+		atomic_set(&key->enabled, -1);
+		jump_label_update(key);
+		atomic_set(&key->enabled, 1);
+	} else {
+		atomic_inc(&key->enabled);
 	}
-	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
 EXPORT_SYMBOL_GPL(static_key_slow_inc);
@@ -77,6 +95,13 @@ EXPORT_SYMBOL_GPL(static_key_slow_inc);
 static void __static_key_slow_dec(struct static_key *key,
 		unsigned long rate_limit, struct delayed_work *work)
 {
+	/*
+	 * The negative count check is valid even when a negative
+	 * key->enabled is in use by static_key_slow_inc(); a
+	 * __static_key_slow_dec() before the first static_key_slow_inc()
+	 * returns is unbalanced, because all other static_key_slow_inc()
+	 * instances block while the update is in progress.
+	 */
 	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
 		WARN(atomic_read(&key->enabled) < 0,
 		     "jump label: negative count!\n");
@@ -87,10 +112,7 @@ static void __static_key_slow_dec(struct static_key *ke=
y,
 		atomic_inc(&key->enabled);
 		schedule_delayed_work(work, rate_limit);
 	} else {
-		if (!jump_label_get_branch_default(key))
-			jump_label_update(key, JUMP_LABEL_DISABLE);
-		else
-			jump_label_update(key, JUMP_LABEL_ENABLE);
+		jump_label_update(key);
 	}
 	jump_label_unlock();
 }
@@ -156,7 +178,7 @@ static int __jump_label_text_reserved(struct jump_entry=
 *iter_start,
 	return 0;
 }
=20
-/*=20
+/*
  * Update code which is definitely not currently executing.
  * Architectures which need heavyweight synchronization to modify
  * running code can override this to make the non-live update case
@@ -165,37 +187,54 @@ static int __jump_label_text_reserved(struct jump_ent=
ry *iter_start,
 void __weak __init_or_module arch_jump_label_transform_static(struct jump_=
entry *entry,
 					    enum jump_label_type type)
 {
-	arch_jump_label_transform(entry, type);=09
+	arch_jump_label_transform(entry, type);
+}
+
+static inline struct jump_entry *static_key_entries(struct static_key *key)
+{
+	return (struct jump_entry *)((unsigned long)key->entries & ~JUMP_TYPE_MAS=
K);
+}
+
+static inline bool static_key_type(struct static_key *key)
+{
+	return (unsigned long)key->entries & JUMP_TYPE_MASK;
+}
+
+static inline struct static_key *jump_entry_key(struct jump_entry *entry)
+{
+	return (struct static_key *)((unsigned long)entry->key & ~1UL);
+}
+
+static bool jump_entry_branch(struct jump_entry *entry)
+{
+	return (unsigned long)entry->key & 1UL;
+}
+
+static enum jump_label_type jump_label_type(struct jump_entry *entry)
+{
+	struct static_key *key =3D jump_entry_key(entry);
+	bool enabled =3D static_key_enabled(key);
+	bool branch =3D jump_entry_branch(entry);
+
+	/* See the comment in linux/jump_label.h */
+	return enabled ^ branch;
 }
=20
 static void __jump_label_update(struct static_key *key,
 				struct jump_entry *entry,
-				struct jump_entry *stop, int enable)
+				struct jump_entry *stop)
 {
-	for (; (entry < stop) &&
-	      (entry->key =3D=3D (jump_label_t)(unsigned long)key);
-	      entry++) {
+	for (; (entry < stop) && (jump_entry_key(entry) =3D=3D key); entry++) {
 		/*
 		 * entry->code set to 0 invalidates module init text sections
 		 * kernel_text_address() verifies we are not in core kernel
 		 * init code, see jump_label_invalidate_module_init().
 		 */
 		if (entry->code && kernel_text_address(entry->code))
-			arch_jump_label_transform(entry, enable);
+			arch_jump_label_transform(entry, jump_label_type(entry));
 	}
 }
=20
-static enum jump_label_type jump_label_type(struct static_key *key)
-{
-	bool true_branch =3D jump_label_get_branch_default(key);
-	bool state =3D static_key_enabled(key);
-
-	if ((!true_branch && state) || (true_branch && !state))
-		return JUMP_LABEL_ENABLE;
-
-	return JUMP_LABEL_DISABLE;
-}
-
 void __init jump_label_init(void)
 {
 	struct jump_entry *iter_start =3D __start___jump_table;
@@ -209,8 +248,11 @@ void __init jump_label_init(void)
 	for (iter =3D iter_start; iter < iter_stop; iter++) {
 		struct static_key *iterk;
=20
-		iterk =3D (struct static_key *)(unsigned long)iter->key;
-		arch_jump_label_transform_static(iter, jump_label_type(iterk));
+		/* rewrite NOPs */
+		if (jump_label_type(iter) =3D=3D JUMP_LABEL_NOP)
+			arch_jump_label_transform_static(iter, JUMP_LABEL_NOP);
+
+		iterk =3D jump_entry_key(iter);
 		if (iterk =3D=3D key)
 			continue;
=20
@@ -229,6 +271,16 @@ void __init jump_label_init(void)
=20
 #ifdef CONFIG_MODULES
=20
+static enum jump_label_type jump_label_init_type(struct jump_entry *entry)
+{
+	struct static_key *key =3D jump_entry_key(entry);
+	bool type =3D static_key_type(key);
+	bool branch =3D jump_entry_branch(entry);
+
+	/* See the comment in linux/jump_label.h */
+	return type ^ branch;
+}
+
 struct static_key_mod {
 	struct static_key_mod *next;
 	struct jump_entry *entries;
@@ -250,17 +302,15 @@ static int __jump_label_mod_text_reserved(void *start=
, void *end)
 				start, end);
 }
=20
-static void __jump_label_mod_update(struct static_key *key, int enable)
+static void __jump_label_mod_update(struct static_key *key)
 {
-	struct static_key_mod *mod =3D key->next;
+	struct static_key_mod *mod;
=20
-	while (mod) {
+	for (mod =3D key->next; mod; mod =3D mod->next) {
 		struct module *m =3D mod->mod;
=20
 		__jump_label_update(key, mod->entries,
-				    m->jump_entries + m->num_jump_entries,
-				    enable);
-		mod =3D mod->next;
+				    m->jump_entries + m->num_jump_entries);
 	}
 }
=20
@@ -283,7 +333,9 @@ void jump_label_apply_nops(struct module *mod)
 		return;
=20
 	for (iter =3D iter_start; iter < iter_stop; iter++) {
-		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
+		/* Only write NOPs for arch_branch_static(). */
+		if (jump_label_init_type(iter) =3D=3D JUMP_LABEL_NOP)
+			arch_jump_label_transform_static(iter, JUMP_LABEL_NOP);
 	}
 }
=20
@@ -304,12 +356,12 @@ static int jump_label_add_module(struct module *mod)
 	for (iter =3D iter_start; iter < iter_stop; iter++) {
 		struct static_key *iterk;
=20
-		iterk =3D (struct static_key *)(unsigned long)iter->key;
+		iterk =3D jump_entry_key(iter);
 		if (iterk =3D=3D key)
 			continue;
=20
 		key =3D iterk;
-		if (__module_address(iter->key) =3D=3D mod) {
+		if (within_module(iter->key, mod)) {
 			/*
 			 * Set key->entries to iter, but preserve JUMP_LABEL_TRUE_BRANCH.
 			 */
@@ -325,8 +377,9 @@ static int jump_label_add_module(struct module *mod)
 		jlm->next =3D key->next;
 		key->next =3D jlm;
=20
-		if (jump_label_type(key) =3D=3D JUMP_LABEL_ENABLE)
-			__jump_label_update(key, iter, iter_stop, JUMP_LABEL_ENABLE);
+		/* Only update if we've changed from our initial state */
+		if (jump_label_type(iter) !=3D jump_label_init_type(iter))
+			__jump_label_update(key, iter, iter_stop);
 	}
=20
 	return 0;
@@ -341,12 +394,12 @@ static void jump_label_del_module(struct module *mod)
 	struct static_key_mod *jlm, **prev;
=20
 	for (iter =3D iter_start; iter < iter_stop; iter++) {
-		if (iter->key =3D=3D (jump_label_t)(unsigned long)key)
+		if (jump_entry_key(iter) =3D=3D key)
 			continue;
=20
-		key =3D (struct static_key *)(unsigned long)iter->key;
+		key =3D jump_entry_key(iter);
=20
-		if (__module_address(iter->key) =3D=3D mod)
+		if (within_module(iter->key, mod))
 			continue;
=20
 		prev =3D &key->next;
@@ -446,22 +499,24 @@ int jump_label_text_reserved(void *start, void *end)
 	return ret;
 }
=20
-static void jump_label_update(struct static_key *key, int enable)
+static void jump_label_update(struct static_key *key)
 {
 	struct jump_entry *stop =3D __stop___jump_table;
-	struct jump_entry *entry =3D jump_label_get_entries(key);
-
+	struct jump_entry *entry =3D static_key_entries(key);
 #ifdef CONFIG_MODULES
-	struct module *mod =3D __module_address((unsigned long)key);
+	struct module *mod;
=20
-	__jump_label_mod_update(key, enable);
+	__jump_label_mod_update(key);
=20
+	preempt_disable();
+	mod =3D __module_address((unsigned long)key);
 	if (mod)
 		stop =3D mod->jump_entries + mod->num_jump_entries;
+	preempt_enable();
 #endif
 	/* if there are no users, entry can be NULL */
 	if (entry)
-		__jump_label_update(key, entry, stop, enable);
+		__jump_label_update(key, entry, stop);
 }
=20
 #endif
diff --git a/kernel/module.c b/kernel/module.c
index 186c2648c667..38a200d34d73 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3489,8 +3489,7 @@ const char *module_address_lookup(unsigned long addr,
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state =3D=3D MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_init(addr, mod) ||
-		    within_module_core(addr, mod)) {
+		if (within_module(addr, mod)) {
 			if (modname)
 				*modname =3D mod->name;
 			ret =3D get_ksymbol(mod, addr, size, offset);
@@ -3514,8 +3513,7 @@ int lookup_module_symbol_name(unsigned long addr, cha=
r *symname)
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state =3D=3D MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_init(addr, mod) ||
-		    within_module_core(addr, mod)) {
+		if (within_module(addr, mod)) {
 			const char *sym;
=20
 			sym =3D get_ksymbol(mod, addr, NULL, NULL);
@@ -3540,8 +3538,7 @@ int lookup_module_symbol_attrs(unsigned long addr, un=
signed long *size,
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state =3D=3D MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_init(addr, mod) ||
-		    within_module_core(addr, mod)) {
+		if (within_module(addr, mod)) {
 			const char *sym;
=20
 			sym =3D get_ksymbol(mod, addr, size, offset);
@@ -3804,8 +3801,7 @@ struct module *__module_address(unsigned long addr)
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state =3D=3D MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_core(addr, mod)
-		    || within_module_init(addr, mod))
+		if (within_module(addr, mod))
 			return mod;
 	}
 	return NULL;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 96a418e507e6..694e650e962d 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -262,6 +262,9 @@ static int ptrace_check_attach(struct task_struct *chil=
d, bool ignore_state)
=20
 static int ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
 {
+	if (mode & PTRACE_MODE_SCHED)
+		return false;
+
 	if (mode & PTRACE_MODE_NOAUDIT)
 		return has_ns_capability_noaudit(current, ns, CAP_SYS_PTRACE);
 	else
@@ -329,9 +332,16 @@ static int __ptrace_may_access(struct task_struct *tas=
k, unsigned int mode)
 	     !ptrace_has_cap(mm->user_ns, mode)))
 	    return -EPERM;
=20
+	if (mode & PTRACE_MODE_SCHED)
+		return 0;
 	return security_ptrace_access_check(task, mode);
 }
=20
+bool ptrace_may_access_sched(struct task_struct *task, unsigned int mode)
+{
+	return __ptrace_may_access(task, mode | PTRACE_MODE_SCHED);
+}
+
 bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
 	int err;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index abda0a8493c5..45dd606138b0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5210,6 +5210,10 @@ static void __cpuinit set_cpu_rq_start_time(void)
 	rq->age_stamp =3D sched_clock_cpu(cpu);
 }
=20
+#ifdef CONFIG_SCHED_SMT
+atomic_t sched_smt_present =3D ATOMIC_INIT(0);
+#endif
+
 static int sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
@@ -5226,6 +5230,13 @@ static int sched_cpu_active(struct notifier_block *n=
fb,
 		 * Thus, fall-through and help the starting CPU along.
 		 */
 	case CPU_DOWN_FAILED:
+#ifdef CONFIG_SCHED_SMT
+		/*
+		 * When going up, increment the number of cores with SMT present.
+		 */
+		if (cpumask_weight(cpu_smt_mask((long)hcpu)) =3D=3D 2)
+			atomic_inc(&sched_smt_present);
+#endif
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;
 	default:
@@ -5243,6 +5254,14 @@ static int sched_cpu_inactive(struct notifier_block =
*nfb,
 	case CPU_DOWN_PREPARE:
 		set_cpu_active(cpu, false);
=20
+#ifdef CONFIG_SCHED_SMT
+		/*
+		 * When going down, decrement the number of cores with SMT present.
+		 */
+		if (cpumask_weight(cpu_smt_mask(cpu)) =3D=3D 2)
+			atomic_dec(&sched_smt_present);
+#endif
+
 		/* explicitly allow suspend */
 		if (!(action & CPU_TASKS_FROZEN)) {
 			struct dl_bw *dl_b =3D dl_bw_of(cpu);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e7e841393443..41e3547263d4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/smt.h>
 #include <linux/sched/deadline.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index 0211d30d8c39..1f71cb3f1da5 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -16,6 +16,10 @@
 #include <linux/kernel.h>
 #include <linux/atomic.h>
=20
+#ifdef CONFIG_X86
+#include <asm/cpufeature.h>	/* for boot_cpu_has below */
+#endif
+
 #define INIT(c) do { atomic64_set(&v, c); r =3D c; } while (0)
 static __init int test_atomic64(void)
 {

--7lnqs4bshjrjhwd2--

--fjdzyk3d2upfqfoi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlzmhsIACgkQ57/I7JWG
EQnivA//QyeZ5+HELuCUshw70H/nXMcD+J5+NQYnsoWwY9HItWBz7KpRpq4CdvaM
+gG9jMD0u0EU89i8ZrCTcESS9RYRzlizrRISwTQA7iEgIHmlnGGM/zZg+gc5kvR/
30VLJhuYd8O1onYQZlGr8s8QCoIC982xjTmj4YRPx4bIOr40R3rqV+uG59BE1wxU
LoVWpiYi9S/uGbz/QDNsta/2JNAZKh8vhONFWN8mlyb5PWZxx/CY/GN1JRWiBKxn
s3mQR+KxOHgbhinIeMhFbT4KUlcdT0KmArFaw+C3/fRg3+rI8DR2l9kKK1VZ0J0W
k6jR4K7IWQvTNFULEQO2tRkD8BSgnzD81GQSS7rytR3RHExJHqUjlmgblG+kow5J
465yvjfm23Nk1MihQhClTDnnRg44AhnhCABzOQ6PhMf3jZVwioUzCRigXHXbsXrm
/VrhOzmUM1rqQL/h9epodICUIQJFrtXm5QbKtod9YWO6OJxHD1+eFICm+m9w3nw8
IJ87AUFgYZOoj48smdqqjmU/ROEueX8mgJcut/xqLMEn4Sjmv1EGE5CSRsjHzCnm
G1UGAIj4tdk4c5YYcFdx8kNFbZFuePmXq61JO1Hk92A8UM92mcwB0DmKz8omC79F
KRkjqnkBthMK3m1PDCuUtshl0nMaOiCszysGMG0CtLv91Z2jQA4=
=Vf+z
-----END PGP SIGNATURE-----

--fjdzyk3d2upfqfoi--
