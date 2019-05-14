Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49ECF1CE93
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 20:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfENSGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 14:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfENSGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 14:06:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 893FC20850;
        Tue, 14 May 2019 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557857163;
        bh=lX21sLzua6y6xodu3fCdE5vgUgsgUB/UkK09kLIQuH4=;
        h=Date:From:To:Cc:Subject:From;
        b=di7Txf2GYxtQINdyjQxE73l34P9ZRiqcS/OP5HDAmOita1nNZVDziWFVlYTwlDUBM
         7514WAJd/w7oMMHw5cnCYuvPsASfrGKmX7Gs2Xa6V13fNWgKhEml2ZeWC1TjVT2DVP
         4aQ1PwAvxk5xsI/8v6UvJcA1yOtYXnapzZUYEmAc=
Date:   Tue, 14 May 2019 20:06:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.176
Message-ID: <20190514180600.GA13320@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.176 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu |    4=20
 Documentation/hw-vuln/index.rst                    |   13=20
 Documentation/hw-vuln/l1tf.rst                     |  615 ++++++++++++++++=
+++
 Documentation/hw-vuln/mds.rst                      |  308 +++++++++
 Documentation/index.rst                            |   19=20
 Documentation/kernel-parameters.txt                |  119 +++
 Documentation/l1tf.rst                             |  610 ----------------=
---
 Documentation/spec_ctrl.txt                        |    9=20
 Documentation/x86/conf.py                          |   10=20
 Documentation/x86/index.rst                        |    8=20
 Documentation/x86/mds.rst                          |  225 +++++++
 Makefile                                           |    2=20
 arch/x86/Kconfig                                   |    8=20
 arch/x86/entry/common.c                            |    3=20
 arch/x86/events/intel/core.c                       |   18=20
 arch/x86/events/intel/cstate.c                     |    4=20
 arch/x86/events/msr.c                              |    4=20
 arch/x86/include/asm/cpufeatures.h                 |   11=20
 arch/x86/include/asm/intel-family.h                |   30=20
 arch/x86/include/asm/irqflags.h                    |    4=20
 arch/x86/include/asm/microcode_intel.h             |   15=20
 arch/x86/include/asm/msr-index.h                   |   40 -
 arch/x86/include/asm/mwait.h                       |    7=20
 arch/x86/include/asm/nospec-branch.h               |   65 ++
 arch/x86/include/asm/pgtable_64.h                  |   16=20
 arch/x86/include/asm/processor.h                   |    6=20
 arch/x86/include/asm/spec-ctrl.h                   |   20=20
 arch/x86/include/asm/switch_to.h                   |    3=20
 arch/x86/include/asm/thread_info.h                 |   20=20
 arch/x86/include/asm/tlbflush.h                    |    8=20
 arch/x86/include/uapi/asm/Kbuild                   |    1=20
 arch/x86/include/uapi/asm/mce.h                    |    2=20
 arch/x86/kernel/cpu/bugs.c                         |  657 ++++++++++++++++=
+----
 arch/x86/kernel/cpu/common.c                       |  139 ++--
 arch/x86/kernel/cpu/intel.c                        |   11=20
 arch/x86/kernel/cpu/mcheck/mce.c                   |    4=20
 arch/x86/kernel/cpu/microcode/amd.c                |   22=20
 arch/x86/kernel/cpu/microcode/intel.c              |   70 +-
 arch/x86/kernel/nmi.c                              |    4=20
 arch/x86/kernel/process.c                          |  101 ++-
 arch/x86/kernel/process.h                          |   39 +
 arch/x86/kernel/process_32.c                       |    9=20
 arch/x86/kernel/process_64.c                       |    9=20
 arch/x86/kernel/traps.c                            |    8=20
 arch/x86/kernel/tsc.c                              |    2=20
 arch/x86/kvm/cpuid.c                               |   13=20
 arch/x86/kvm/cpuid.h                               |    2=20
 arch/x86/kvm/svm.c                                 |    2=20
 arch/x86/kvm/vmx.c                                 |    7=20
 arch/x86/mm/init.c                                 |    2=20
 arch/x86/mm/kaiser.c                               |    4=20
 arch/x86/mm/pgtable.c                              |    6=20
 arch/x86/mm/tlb.c                                  |  114 ++-
 arch/x86/platform/atom/punit_atom_debug.c          |    4=20
 drivers/acpi/acpi_lpss.c                           |    2=20
 drivers/base/cpu.c                                 |    8=20
 drivers/cpufreq/intel_pstate.c                     |    2=20
 drivers/idle/intel_idle.c                          |   14=20
 drivers/mmc/host/sdhci-acpi.c                      |    2=20
 drivers/pci/pci-mid.c                              |    4=20
 drivers/powercap/intel_rapl.c                      |    8=20
 drivers/thermal/intel_soc_dts_thermal.c            |    2=20
 include/linux/bitops.h                             |   21=20
 include/linux/bits.h                               |   26=20
 include/linux/cpu.h                                |   26=20
 include/linux/ptrace.h                             |   21=20
 include/linux/sched.h                              |    9=20
 include/linux/sched/smt.h                          |   20=20
 include/uapi/linux/prctl.h                         |    1=20
 kernel/cpu.c                                       |   29=20
 kernel/ptrace.c                                    |   10=20
 kernel/sched/core.c                                |   19=20
 kernel/sched/sched.h                               |    1=20
 tools/power/x86/turbostat/Makefile                 |    2=20
 74 files changed, 2662 insertions(+), 1021 deletions(-)

Andi Kleen (3):
      x86/speculation/mds: Add basic bug infrastructure for MDS
      x86/kvm: Expose X86_FEATURE_MD_CLEAR to guests
      x86/cpu/bugs: Use __initconst for 'const' init data

Ashok Raj (1):
      x86/microcode/intel: Check microcode revision before updating sibling=
 threads

Ben Hutchings (2):
      x86/cpufeatures: Hide AMD-specific speculation flags
      sched: Add sched_smt_active()

Boris Ostrovsky (1):
      x86/speculation/mds: Fix comment

Borislav Petkov (1):
      x86/microcode/intel: Add a helper which gives the microcode revision

Dominik Brodowski (1):
      x86/speculation: Simplify the CPU bug detection logic

Eduardo Habkost (1):
      kvm: x86: Report STIBP on GET_SUPPORTED_CPUID

Filippo Sironi (1):
      x86/microcode: Update the new microcode revision unconditionally

Greg Kroah-Hartman (1):
      Linux 4.9.176

Jiang Biao (1):
      x86/speculation: Remove SPECTRE_V2_IBRS in enum spectre_v2_mitigation

Jiri Kosina (3):
      x86/speculation: Apply IBPB more strictly to avoid cross-process data=
 leak
      x86/speculation: Enable cross-hyperthread spectre v2 STIBP mitigation
      x86/speculation: Propagate information about RSB filling mitigation t=
o sysfs

Josh Poimboeuf (7):
      x86/speculation/mds: Add mds=3Dfull,nosmt cmdline option
      x86/speculation: Move arch_smt_update() call to after mitigation deci=
sions
      x86/speculation/mds: Add SMT warning message
      cpu/speculation: Add 'mitigations=3D' cmdline option
      x86/speculation: Support 'mitigations=3D' cmdline option
      x86/speculation/mds: Add 'mitigations=3D' support for MDS
      x86/speculation/mds: Fix documentation typo

Konrad Rzeszutek Wilk (4):
      x86/bugs: Add AMD's variant of SSB_NO
      x86/bugs: Add AMD's SPEC_CTRL MSR usage
      x86/bugs: Switch the selection of mitigation from CPU vendor to CPU f=
eatures
      x86/speculation/mds: Print SMT vulnerable on MSBDS with mitigations o=
ff

Matthias Kaehlcke (1):
      bitops: avoid integer overflow in GENMASK(_ULL)

Michal Hocko (1):
      x86/speculation/l1tf: Drop the swap storage limit restriction when l1=
tf=3Doff

Nadav Amit (1):
      x86/mm: Use WRITE_ONCE() when setting PTEs

Nicolas Dichtel (1):
      x86: stop exporting msr-index.h to userland

Peter Zijlstra (1):
      x86/cpu: Sanitize FAM6_ATOM naming

Prarit Bhargava (1):
      x86/microcode: Make sure boot_cpu_data.microcode is up-to-date

Salvatore Bonaccorso (1):
      Documentation/l1tf: Fix small spelling typo

Thomas Gleixner (31):
      x86/speculation: Rename SSBD update functions
      x86/Kconfig: Select SCHED_SMT if SMP enabled
      x86/speculation: Rework SMT state change
      x86/l1tf: Show actual SMT state
      x86/speculation: Reorder the spec_v2 code
      x86/speculation: Mark string arrays const correctly
      x86/speculataion: Mark command line parser data __initdata
      x86/speculation: Unify conditional spectre v2 print functions
      x86/speculation: Add command line control for indirect branch specula=
tion
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
      x86/kvm/vmx: Add MDS protection when L1D Flush is not active
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
      x86/speculation: Move STIPB/IBPB string conditionals out of cpu_show_=
common()
      x86/speculation: Disable STIBP when enhanced IBRS is in use
      x86/speculation: Reorganize speculation control MSRs update
      x86/speculation: Prepare for per task indirect branch speculation con=
trol

Tom Lendacky (1):
      x86/bugs: Fix the AMD SSBD usage of the SPEC_CTRL MSR

Tony Luck (1):
      x86/MCE: Save microcode revision in machine check records

Tyler Hicks (1):
      Documentation: Correct the possible MDS sysfs values

Will Deacon (1):
      locking/atomics, asm-generic: Move some macros from <linux/bitops.h> =
to a new <linux/bits.h> file

speck for Pawan Gupta (1):
      x86/mds: Add MDSUM variant to the MDS documentation


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzbA4gACgkQONu9yGCS
aT4y6g//bJtHczEE3dNIngyt6fVfhqw/4x6BGqtCrFyDtCYn2ScUhZBtWkKZQQ5d
7pNNgieh2HzTHNOLLl/cwzHzPA7j6QTfimyjtouO4U2D2m6r+oZZff9RBWKdwAlV
w2VumJRRckZC1uB8xE86M7VNLVPM5HsMo9UOiDuFUr0T5T8SX51OlXBTBzn+Jvjp
xoXZv4sgClwYzY1W3Dy22Ucf+y4dgd13cZlOd1RDffL7Kn/OI3Dunz0/bcsr1J/K
rEI9SFmQRq2Kp6Cio3AXxFKmIDP0fQS8CFrQ5TVWtsrFc3dwzMRfpvwx2yjS5hno
IBKk4CcaugFLZJHWn+b9aq1Ui9l35tciTnHoldGvHM6F+uwkc/WENreu5vwBYOy5
RWd5RS7jZNe+ys3R6c7HtIA3rOliT1GmwgCCX9L2azmVrPaPzpcy8sOxVs04HBp5
nlGVmoHYcynJVvYIsjCOsUECy1mHoO8f8fZs89djZ1huHHk4iM9h0Hv+fv1xyww7
mgFFGPK5MG3dvmuuzRqqMDHZEIz38yD8xVuQ4gcCKb9QMBXxcOLraqvxfG96k5vp
F3ET2q02Fcp1gEwEx+sxgmLFpJ70USOsfiGlmHI5xT5hBLSF2i94tlmeMUW6m3X6
9eVxzro1fv4YeeE1V6B1s5cekeLYgj+WQV6K0DjIM7qMbAhqw0o=
=gb3g
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
