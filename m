Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13223D4E2D
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 09:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfJLH7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Oct 2019 03:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728159AbfJLH7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Oct 2019 03:59:10 -0400
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F44F2089C;
        Sat, 12 Oct 2019 07:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570867148;
        bh=bYLlY6jxQu5Eoj6aLBoIDPO0D5b3QnI0k4uaxaaLVwI=;
        h=Date:From:To:Cc:Subject:From;
        b=Uc6ljYJ9QWyy7xPgbyxcrtD+wGRTl1lEx4GmUDXDfnkqLpLpyKDWsHW9JT070mxGG
         mEDWEhiMTNgLfbQrP9rXS0Iyro7vT1dqPjXFHnamEQsF0Zex3/neB9RqRsQmiVEn9c
         fQ3onA4QvlXhHCZqJWhz/LcsIAc/wJjpy6CvtYW0=
Date:   Sat, 12 Oct 2019 09:58:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.79
Message-ID: <20191012075810.GA2038614@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.79 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt  |   16 -
 Documentation/arm64/elf_hwcaps.txt               |    4=20
 Makefile                                         |    2=20
 arch/arm64/Kconfig                               |    1=20
 arch/arm64/include/asm/cpucaps.h                 |    3=20
 arch/arm64/include/asm/cpufeature.h              |    4=20
 arch/arm64/include/asm/kvm_host.h                |   11=20
 arch/arm64/include/asm/processor.h               |   17 +
 arch/arm64/include/asm/ptrace.h                  |    1=20
 arch/arm64/include/asm/sysreg.h                  |   19 +
 arch/arm64/include/uapi/asm/hwcap.h              |    1=20
 arch/arm64/include/uapi/asm/ptrace.h             |    1=20
 arch/arm64/kernel/cpu_errata.c                   |  271 +++++++++++++++++-=
-----
 arch/arm64/kernel/cpufeature.c                   |  130 +++++++++--
 arch/arm64/kernel/cpuinfo.c                      |    1=20
 arch/arm64/kernel/process.c                      |   31 ++
 arch/arm64/kernel/ptrace.c                       |   15 -
 arch/arm64/kernel/ssbd.c                         |   21 +
 arch/arm64/kvm/hyp/sysreg-sr.c                   |   11=20
 arch/mips/include/asm/cpu-features.h             |   16 +
 arch/mips/include/asm/cpu.h                      |    4=20
 arch/mips/kernel/cpu-probe.c                     |    6=20
 arch/mips/kernel/proc.c                          |    4=20
 arch/powerpc/include/asm/cputable.h              |    4=20
 arch/powerpc/kernel/dt_cpu_ftrs.c                |   30 ++
 arch/powerpc/kernel/mce.c                        |   11=20
 arch/powerpc/kernel/mce_power.c                  |   19 +
 arch/powerpc/kvm/book3s_hv.c                     |   24 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c              |    2=20
 arch/powerpc/kvm/book3s_hv_rmhandlers.S          |   36 +--
 arch/powerpc/kvm/book3s_xive.c                   |   18 -
 arch/powerpc/mm/hash_native_64.c                 |    2=20
 arch/powerpc/mm/hash_utils_64.c                  |    9=20
 arch/powerpc/mm/tlb-radix.c                      |    4=20
 arch/powerpc/platforms/powernv/opal.c            |   11=20
 arch/powerpc/platforms/powernv/pci-ioda-tce.c    |   18 +
 arch/powerpc/platforms/pseries/lpar.c            |    8=20
 arch/riscv/kernel/entry.S                        |    6=20
 arch/s390/kernel/process.c                       |   22 +
 arch/s390/kernel/topology.c                      |    3=20
 arch/s390/kvm/kvm-s390.c                         |    2=20
 arch/x86/kvm/vmx.c                               |    4=20
 arch/x86/kvm/x86.c                               |   38 +--
 arch/x86/purgatory/Makefile                      |    1=20
 crypto/skcipher.c                                |   42 +--
 drivers/block/nbd.c                              |   62 +++--
 drivers/crypto/caam/caamalg_desc.c               |    9=20
 drivers/crypto/caam/caamalg_desc.h               |    2=20
 drivers/crypto/cavium/zip/zip_main.c             |    3=20
 drivers/crypto/ccree/cc_aead.c                   |    2=20
 drivers/crypto/ccree/cc_fips.c                   |    8=20
 drivers/crypto/qat/qat_common/adf_common_drv.h   |    2=20
 drivers/devfreq/tegra-devfreq.c                  |   12 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c           |    3=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c          |    3=20
 drivers/gpu/drm/i915/gvt/scheduler.c             |   28 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c               |    8=20
 drivers/gpu/drm/nouveau/dispnv50/disp.c          |    3=20
 drivers/gpu/drm/omapdrm/dss/dss.c                |    2=20
 drivers/gpu/drm/radeon/radeon_drv.c              |   31 ++
 drivers/gpu/drm/radeon/radeon_kms.c              |   25 --
 drivers/hwtracing/coresight/coresight-etm4x.c    |   14 +
 drivers/mmc/host/sdhci-of-esdhc.c                |    7=20
 drivers/mmc/host/sdhci.c                         |   15 -
 drivers/net/can/spi/mcp251x.c                    |   19 +
 drivers/net/ethernet/netronome/nfp/flower/main.c |    1=20
 drivers/net/ieee802154/atusb.c                   |    3=20
 drivers/ntb/test/ntb_perf.c                      |    2=20
 drivers/nvdimm/bus.c                             |    2=20
 drivers/nvdimm/region.c                          |    4=20
 drivers/nvdimm/region_devs.c                     |    4=20
 drivers/pci/controller/vmd.c                     |    9=20
 drivers/pci/pci.c                                |    2=20
 drivers/power/supply/sbs-battery.c               |   27 +-
 drivers/pwm/pwm-stm32-lp.c                       |    6=20
 drivers/s390/cio/ccwgroup.c                      |    2=20
 drivers/s390/cio/css.c                           |    2=20
 drivers/staging/erofs/dir.c                      |   11=20
 drivers/staging/erofs/unzip_vle.c                |   37 ++-
 drivers/thermal/thermal_core.c                   |    2=20
 drivers/thermal/thermal_hwmon.c                  |    8=20
 drivers/watchdog/aspeed_wdt.c                    |    4=20
 drivers/watchdog/imx2_wdt.c                      |    4=20
 drivers/xen/pci.c                                |   21 +
 drivers/xen/xenbus/xenbus_dev_frontend.c         |   20 +
 fs/9p/vfs_file.c                                 |    3=20
 fs/ceph/inode.c                                  |    7=20
 fs/ceph/mds_client.c                             |    4=20
 fs/fuse/cuse.c                                   |    1=20
 fs/nfs/nfs4xdr.c                                 |    2=20
 fs/nfs/pnfs.c                                    |    9=20
 fs/statfs.c                                      |   17 -
 include/linux/ieee80211.h                        |   53 ++++
 include/linux/sched/mm.h                         |    2=20
 include/sound/soc-dapm.h                         |    2=20
 kernel/elfcore.c                                 |    1=20
 kernel/locking/qspinlock_paravirt.h              |    2=20
 kernel/sched/core.c                              |    4=20
 kernel/sched/membarrier.c                        |    2=20
 kernel/time/tick-broadcast-hrtimer.c             |   57 ++--
 kernel/time/timer.c                              |    8=20
 kernel/trace/trace_events_hist.c                 |    2=20
 mm/usercopy.c                                    |    8=20
 net/9p/client.c                                  |    1=20
 net/netfilter/nf_tables_api.c                    |    7=20
 net/netfilter/nft_lookup.c                       |    3=20
 net/wireless/nl80211.c                           |   42 +++
 net/wireless/reg.c                               |    2=20
 net/wireless/scan.c                              |   14 -
 net/wireless/wext-compat.c                       |    2=20
 security/integrity/ima/ima_crypto.c              |   10=20
 sound/soc/codecs/sgtl5000.c                      |  224 ++++++++++++++++---
 tools/lib/traceevent/Makefile                    |    4=20
 tools/lib/traceevent/event-parse.c               |    3=20
 tools/perf/Makefile.config                       |    2=20
 tools/perf/arch/x86/util/unwind-libunwind.c      |    2=20
 tools/perf/builtin-stat.c                        |    5=20
 tools/perf/util/header.c                         |    2=20
 tools/perf/util/stat.c                           |   17 +
 tools/perf/util/stat.h                           |    1=20
 tools/testing/nvdimm/test/nfit_test.h            |    4=20
 121 files changed, 1405 insertions(+), 457 deletions(-)

Alexander Sverdlin (1):
      crypto: qat - Silence smp_processor_id() warning

Alexey Kardashevskiy (1):
      powerpc/powernv/ioda: Fix race in TCE level allocation

Andrew Donnellan (1):
      powerpc/powernv: Restrict OPAL symbol map to only be readable by root

Andrew Murray (1):
      coresight: etm4x: Use explicit barriers on enable/disable

Aneesh Kumar K.V (3):
      powerpc/book3s64/mm: Don't do tlbie fixup for some hardware revisions
      libnvdimm/region: Initialize bad block for volatile namespaces
      powerpc/book3s64/radix: Rename CPU_FTR_P9_TLBIE_BUG feature flag

Arnaldo Carvalho de Melo (1):
      perf unwind: Fix libunwind build failure on i386 systems

Arvind Sankar (1):
      x86/purgatory: Disable the stackleak GCC plugin for the purgatory

Balasubramani Vivekanandan (1):
      tick: broadcast-hrtimer: Fix a race in bc_set_next

Balbir Singh (1):
      powerpc/mce: Fix MCE handling for huge pages

Chengguang Xu (1):
      9p: avoid attaching writeback_fid on mmap with type PRIVATE

C=C3=A9dric Le Goater (1):
      KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before disablin=
g the VP

Dmitry Osipenko (1):
      PM / devfreq: tegra: Fix kHz to Hz conversion

Eric Sandeen (1):
      vfs: Fix EOVERFLOW testing in put_compat_statfs64

Erqi Chen (1):
      ceph: reconnect connection if session hang in opening state

Fabrice Gasnier (1):
      pwm: stm32-lp: Add check in case requested period cannot be achieved

Felix Kuehling (1):
      drm/amdgpu: Fix KFD-related kernel oops on Hawaii

Florian Westphal (1):
      netfilter: nf_tables: allow lookups in dynamic sets

Gao Xiang (4):
      staging: erofs: fix an error handling in erofs_readdir()
      staging: erofs: some compressed cluster should be submitted for corru=
pted images
      staging: erofs: add two missing erofs_workgroup_put for corrupted ima=
ges
      staging: erofs: detect potential multiref due to corrupted images

Gautham R. Shenoy (1):
      powerpc/pseries: Fix cpu_hotplug_lock acquisition in resize_hpt()

Gilad Ben-Yossef (2):
      crypto: ccree - account for TEE not ready to report
      crypto: ccree - use the full crypt length value

Greg Kroah-Hartman (1):
      Linux 4.19.79

Hans de Goede (1):
      drm/radeon: Bail earlier when radeon.cik_/si_support=3D0 is passed

Herbert Xu (1):
      crypto: skcipher - Unmap pages after an external error

Horia Geant=C4=83 (1):
      crypto: caam - fix concurrency issue in givencrypt descriptor

Ido Schimmel (1):
      thermal: Fix use-after-free when unregistering thermal zone device

Igor Druzhinin (1):
      xen/pci: reserve MCFG areas earlier

Jack Wang (1):
      KVM: nVMX: handle page fault in vmread fix

Jeremy Linton (6):
      arm64: add sysfs vulnerability show for meltdown
      arm64: Always enable ssb vulnerability detection
      arm64: Provide a command line to disable spectre_v2 mitigation
      arm64: Always enable spectre-v2 vulnerability detection
      arm64: add sysfs vulnerability show for spectre-v2
      arm64: add sysfs vulnerability show for speculative store bypass

Jia-Ju Bai (1):
      fs: nfs: Fix possible null-pointer dereferences in encode_attrs()

Jiaxun Yang (1):
      MIPS: Treat Loongson Extensions as ASEs

Jiri Olsa (1):
      perf tools: Fix segfault in cpu_cache_level__read()

Johan Hovold (1):
      ieee802154: atusb: fix use-after-free at disconnect

Johannes Berg (3):
      cfg80211: initialize on-stack chandefs
      cfg80211: add and use strongly typed element iteration macros
      nl80211: validate beacon head

Jon Derrick (1):
      PCI: vmd: Fix shadow offsets to reflect spec changes

Josh Poimboeuf (1):
      arm64/speculation: Support 'mitigations=3D' cmdline option

Jouni Malinen (1):
      cfg80211: Use const more consistently in for_each_element macros

Juergen Gross (1):
      xen/xenbus: fix self-deadlock after killing user process

KeMeng Shi (1):
      sched/core: Fix migration to invalid CPU in __set_cpus_allowed_ptr()

Kees Cook (1):
      usercopy: Avoid HIGHMEM pfn warning

Li RongQing (1):
      timer: Read jiffies once when forwarding base clk

Lu Shuaibing (1):
      9p: Transport error uninitialized

Luis Henriques (1):
      ceph: fix directories inode i_blkbits initialization

Lyude Paul (1):
      drm/nouveau/kms/nv50-: Don't create MSTMs for eDP connectors

Marc Kleine-Budde (1):
      can: mcp251x: mcp251x_hw_reset(): allow more time after a reset

Marc Zyngier (3):
      arm64: Advertise mitigation of Spectre-v2, or lack thereof
      arm64: Force SSBS on context switch
      arm64: Use firmware to detect CPUs that are not affected by Spectre-v2

Mark Rutland (1):
      arm64: fix SSBS sanitization

Mathieu Desnoyers (2):
      sched/membarrier: Call sync_core only before usermode for same mm
      sched/membarrier: Fix private expedited registration check

Mian Yousaf Kaukab (2):
      arm64: Add sysfs vulnerability show for spectre-v1
      arm64: enable generic CPU vulnerabilites support

Michael Nosthoff (2):
      power: supply: sbs-battery: use correct flags field
      power: supply: sbs-battery: only return health when battery present

Mike Christie (1):
      nbd: fix max number of supported devs

Nathan Chancellor (1):
      libnvdimm/nfit_test: Fix acpi_handle redefinition

Navid Emamdoost (1):
      nfp: flower: fix memory leak in nfp_flower_spawn_vnic_reprs

Oleksandr Suvorov (2):
      ASoC: Define a set of DAPM pre/post-up events
      ASoC: sgtl5000: Improve VAG power and mute control

Paul Mackerras (3):
      KVM: PPC: Book3S HV: Fix race in re-enabling XIVE escalation interrup=
ts
      KVM: PPC: Book3S HV: Check for MMU ready on piggybacked virtual cores
      KVM: PPC: Book3S HV: Don't lose pending doorbell request on migration=
 on P9

Rasmus Villemoes (1):
      watchdog: imx2_wdt: fix min() calculation in imx2_wdt_set_timeout

Russell King (2):
      mmc: sdhci: improve ADMA error reporting
      mmc: sdhci-of-esdhc: set DMA snooping based on DMA coherence

Ryan Chen (1):
      watchdog: aspeed: Add support for AST2600

Sanjay R Mehta (1):
      ntb: point to right memory window index

Santosh Sivaraj (1):
      powerpc/mce: Schedule work from irq_work

Sascha Hauer (2):
      ima: always return negative code for error
      ima: fix freeing ongoing ahash_request

Sean Christopherson (1):
      KVM: nVMX: Fix consistency check on injected exception error code

Sean Paul (1):
      drm/msm/dsi: Fix return value check for clk_get_parent

Srikar Dronamraju (2):
      perf stat: Fix a segmentation fault when using repeat forever
      perf stat: Reset previous counts on repeat with interval

Stefan Mavrodiev (1):
      thermal_hwmon: Sanitize thermal_zone type

Steven Rostedt (VMware) (2):
      tools lib traceevent: Fix "robust" test of do_generate_dynamic_list_f=
ile
      tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on =
failure

Sumit Saxena (1):
      PCI: Restore Resizable BAR size bits correctly for 1MB BARs

Thomas Huth (1):
      KVM: s390: Test for bad access register and size at the start of S390=
_MEM_OP

Thomas Richter (1):
      perf build: Add detection of java-11-openjdk-devel package

Tom Zanussi (1):
      tracing: Make sure variable reference alias has correct var_ref_idx

Tomi Valkeinen (1):
      drm/omap: fix max fclk divider for omap36xx

Trek (1):
      drm/amdgpu: Check for valid number of registers to read

Trond Myklebust (1):
      pNFS: Ensure we do clear the return-on-close layout stateid on fatal =
errors

Valdis Kletnieks (1):
      kernel/elfcore.c: include proper prototypes

Vasily Gorbik (4):
      s390/process: avoid potential reading of freed stack
      s390/topology: avoid firing events before kobjs are created
      s390/cio: exclude subchannels with no parent from pseudo check
      s390/cio: avoid calling strlen on null pointer

Vincent Chen (1):
      riscv: Avoid interrupts being erroneously enabled in handle_exception=
()

Wanpeng Li (2):
      KVM: X86: Fix userspace set invalid CR4
      Revert "locking/pvqspinlock: Don't wait if vCPU is preempted"

Wei Yongjun (1):
      crypto: cavium/zip - Add missing single_release()

Will Deacon (5):
      arm64: cpufeature: Detect SSBS and advertise to userspace
      arm64: ssbd: Add support for PSTATE.SSBS rather than trapping to EL3
      KVM: arm64: Set SCTLR_EL2.DSSBS if SSBD is forcefully disabled and !v=
he
      arm64: docs: Document SSBS HWCAP
      arm64: ssbs: Don't treat CPUs with SSBS as unaffected by SSB

Xiaolin Zhang (1):
      drm/i915/gvt: update vgpu workload head pointer correctly

Xiubo Li (1):
      nbd: fix crash when the blksize is zero

zhengbin (1):
      fuse: fix memleak in cuse_channel_open


--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2hh5IACgkQONu9yGCS
aT6hDBAA00E2C86zzIYkcXBL4saRf1/fYV4+NkSHcsYIzfO7nlRe0GW0e0Kvniqk
vZFo1LvJkv5U5yys1dDM/U2wf9Q2Jc/cdoPxrAcdr7G8yGzW5ZiKlkll/TunEG0Q
KD78PXYMqtfZjs6NaYjEssWMZPvzGEFbWhL6/wllI8rmhiQlZ5+PhItLgz2DS09E
x+hJqTnGuYth5A1hjyq/XcOO52xnR8Rkyh7IPL7FWhPYb/RHh9PizlbpYGgiDWkh
ZgOP+VOZAnCiNtBVqtLpnJThmej7N+NdjQtnkOD24Ghy+LT09OEG2JcrZSIwC63d
RgQjw7yJAHx2PaGZZ9JQvICj9jnya/6LQ9hwImjFhThDI9o7nDOv82H2paiSrGo7
07OdmhhpK3nSKDgqrRt31pJXJHhC6X5GViNRaSvZNqbAJAFgR9VQAzrNbesMuQGe
dd/6g/cPFPM5QQwl+igsaeDStXfULePn4Nz8DZYzZA03iqPypFVElJGB1jTaQdzh
bxZmGbBLvrVZ815iTDztVXMAB/TFhnzGXlwoagYOEhE6EKdR3PfRu/cVwSrS5eCJ
2KMJvGkV7RznE+i1qvTbvmFkr7X77TSNpVQShUBdJZBS/AghALfo//nA6pm8RtYI
wC0cOVJ5ImB5jQ6R1oeb2UKbeQU4rzvaj1AelfmWJRDVGebIwNM=
=5APs
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
