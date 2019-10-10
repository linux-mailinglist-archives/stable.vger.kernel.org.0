Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67AE8D23CF
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389265AbfJJIqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:46:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389258AbfJJIqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:46:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E60D1218AC;
        Thu, 10 Oct 2019 08:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697168;
        bh=FFjOByWR+uKNARavRW/EB4RMX+0/94zT9Zb04A8AYQY=;
        h=From:To:Cc:Subject:Date:From;
        b=vMOt0ftNNZJSV1U4HSibIFYAD3Mx9/YbJDG2Vw4rDvi63C7nbKD8rR7DmOGJ/BE6J
         zme0p+7lHcy4osGifyx8G0vn1Uz9dpQQ078s0pnSfjyzUDpr4NqVoZnQkHToU3j8js
         LVPwguMGDMiWAPwCRvr8u+00iLYIxnnz9jtAxBQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/114] 4.19.79-stable review
Date:   Thu, 10 Oct 2019 10:35:07 +0200
Message-Id: <20191010083544.711104709@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.79-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.79-rc1
X-KernelTest-Deadline: 2019-10-12T08:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.79 release.
There are 114 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.79-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.79-rc1

Johannes Berg <johannes.berg@intel.com>
    nl80211: validate beacon head

Jouni Malinen <j@w1.fi>
    cfg80211: Use const more consistently in for_each_element macros

Johannes Berg <johannes.berg@intel.com>
    cfg80211: add and use strongly typed element iteration macros

Gao Xiang <gaoxiang25@huawei.com>
    staging: erofs: detect potential multiref due to corrupted images

Gao Xiang <gaoxiang25@huawei.com>
    staging: erofs: add two missing erofs_workgroup_put for corrupted images

Gao Xiang <gaoxiang25@huawei.com>
    staging: erofs: some compressed cluster should be submitted for corrupted images

Gao Xiang <gaoxiang25@huawei.com>
    staging: erofs: fix an error handling in erofs_readdir()

Andrew Murray <andrew.murray@arm.com>
    coresight: etm4x: Use explicit barriers on enable/disable

Eric Sandeen <sandeen@redhat.com>
    vfs: Fix EOVERFLOW testing in put_compat_statfs64

Josh Poimboeuf <jpoimboe@redhat.com>
    arm64/speculation: Support 'mitigations=' cmdline option

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Use firmware to detect CPUs that are not affected by Spectre-v2

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Force SSBS on context switch

Will Deacon <will.deacon@arm.com>
    arm64: ssbs: Don't treat CPUs with SSBS as unaffected by SSB

Jeremy Linton <jeremy.linton@arm.com>
    arm64: add sysfs vulnerability show for speculative store bypass

Jeremy Linton <jeremy.linton@arm.com>
    arm64: add sysfs vulnerability show for spectre-v2

Jeremy Linton <jeremy.linton@arm.com>
    arm64: Always enable spectre-v2 vulnerability detection

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Advertise mitigation of Spectre-v2, or lack thereof

Jeremy Linton <jeremy.linton@arm.com>
    arm64: Provide a command line to disable spectre_v2 mitigation

Jeremy Linton <jeremy.linton@arm.com>
    arm64: Always enable ssb vulnerability detection

Mian Yousaf Kaukab <ykaukab@suse.de>
    arm64: enable generic CPU vulnerabilites support

Jeremy Linton <jeremy.linton@arm.com>
    arm64: add sysfs vulnerability show for meltdown

Mian Yousaf Kaukab <ykaukab@suse.de>
    arm64: Add sysfs vulnerability show for spectre-v1

Mark Rutland <mark.rutland@arm.com>
    arm64: fix SSBS sanitization

Will Deacon <will.deacon@arm.com>
    arm64: docs: Document SSBS HWCAP

Will Deacon <will.deacon@arm.com>
    KVM: arm64: Set SCTLR_EL2.DSSBS if SSBD is forcefully disabled and !vhe

Will Deacon <will.deacon@arm.com>
    arm64: ssbd: Add support for PSTATE.SSBS rather than trapping to EL3

Vincent Chen <vincent.chen@sifive.com>
    riscv: Avoid interrupts being erroneously enabled in handle_exception()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/userptr: Acquire the page lock around set_page_dirty()

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    perf stat: Reset previous counts on repeat with interval

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix segfault in cpu_cache_level__read()

Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
    tick: broadcast-hrtimer: Fix a race in bc_set_next

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on failure

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/radix: Rename CPU_FTR_P9_TLBIE_BUG feature flag

Gautham R. Shenoy <ego@linux.vnet.ibm.com>
    powerpc/pseries: Fix cpu_hotplug_lock acquisition in resize_hpt()

Xiubo Li <xiubli@redhat.com>
    nbd: fix crash when the blksize is zero

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Fix consistency check on injected exception error code

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before disabling the VP

Hans de Goede <hdegoede@redhat.com>
    drm/radeon: Bail earlier when radeon.cik_/si_support=0 is passed

Navid Emamdoost <navid.emamdoost@gmail.com>
    nfp: flower: fix memory leak in nfp_flower_spawn_vnic_reprs

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf unwind: Fix libunwind build failure on i386 systems

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    kernel/elfcore.c: include proper prototypes

Thomas Richter <tmricht@linux.ibm.com>
    perf build: Add detection of java-11-openjdk-devel package

KeMeng Shi <shikemeng@huawei.com>
    sched/core: Fix migration to invalid CPU in __set_cpus_allowed_ptr()

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    sched/membarrier: Fix private expedited registration check

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    sched/membarrier: Call sync_core only before usermode for same mm

Nathan Chancellor <natechancellor@gmail.com>
    libnvdimm/nfit_test: Fix acpi_handle redefinition

zhengbin <zhengbin13@huawei.com>
    fuse: fix memleak in cuse_channel_open

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    libnvdimm/region: Initialize bad block for volatile namespaces

Stefan Mavrodiev <stefan@olimex.com>
    thermal_hwmon: Sanitize thermal_zone type

Ido Schimmel <idosch@mellanox.com>
    thermal: Fix use-after-free when unregistering thermal zone device

Sanjay R Mehta <sanju.mehta@amd.com>
    ntb: point to right memory window index

Arvind Sankar <nivedita@alum.mit.edu>
    x86/purgatory: Disable the stackleak GCC plugin for the purgatory

Fabrice Gasnier <fabrice.gasnier@st.com>
    pwm: stm32-lp: Add check in case requested period cannot be achieved

Trond Myklebust <trondmy@gmail.com>
    pNFS: Ensure we do clear the return-on-close layout stateid on fatal errors

Trek <trek00@inbox.ru>
    drm/amdgpu: Check for valid number of registers to read

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdgpu: Fix KFD-related kernel oops on Hawaii

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: allow lookups in dynamic sets

Ryan Chen <ryan_chen@aspeedtech.com>
    watchdog: aspeed: Add support for AST2600

Erqi Chen <chenerqi@gmail.com>
    ceph: reconnect connection if session hang in opening state

Luis Henriques <lhenriques@suse.com>
    ceph: fix directories inode i_blkbits initialization

Igor Druzhinin <igor.druzhinin@citrix.com>
    xen/pci: reserve MCFG areas earlier

Chengguang Xu <cgxu519@zoho.com.cn>
    9p: avoid attaching writeback_fid on mmap with type PRIVATE

Lu Shuaibing <shuaibinglu@126.com>
    9p: Transport error uninitialized

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: nfs: Fix possible null-pointer dereferences in encode_attrs()

Sascha Hauer <s.hauer@pengutronix.de>
    ima: fix freeing ongoing ahash_request

Sascha Hauer <s.hauer@pengutronix.de>
    ima: always return negative code for error

Will Deacon <will.deacon@arm.com>
    arm64: cpufeature: Detect SSBS and advertise to userspace

Johannes Berg <johannes.berg@intel.com>
    cfg80211: initialize on-stack chandefs

Vasily Gorbik <gor@linux.ibm.com>
    s390/cio: avoid calling strlen on null pointer

Johan Hovold <johan@kernel.org>
    ieee802154: atusb: fix use-after-free at disconnect

Juergen Gross <jgross@suse.com>
    xen/xenbus: fix self-deadlock after killing user process

Wanpeng Li <wanpengli@tencent.com>
    Revert "locking/pvqspinlock: Don't wait if vCPU is preempted"

Russell King <rmk+kernel@armlinux.org.uk>
    mmc: sdhci-of-esdhc: set DMA snooping based on DMA coherence

Russell King <rmk+kernel@armlinux.org.uk>
    mmc: sdhci: improve ADMA error reporting

Xiaolin Zhang <xiaolin.zhang@intel.com>
    drm/i915/gvt: update vgpu workload head pointer correctly

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv50-: Don't create MSTMs for eDP connectors

Sean Paul <seanpaul@chromium.org>
    drm/msm/dsi: Fix return value check for clk_get_parent

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/omap: fix max fclk divider for omap36xx

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    perf stat: Fix a segmentation fault when using repeat forever

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    watchdog: imx2_wdt: fix min() calculation in imx2_wdt_set_timeout

Sumit Saxena <sumit.saxena@broadcom.com>
    PCI: Restore Resizable BAR size bits correctly for 1MB BARs

Jon Derrick <jonathan.derrick@intel.com>
    PCI: vmd: Fix shadow offsets to reflect spec changes

Li RongQing <lirongqing@baidu.com>
    timer: Read jiffies once when forwarding base clk

Kees Cook <keescook@chromium.org>
    usercopy: Avoid HIGHMEM pfn warning

Tom Zanussi <zanussi@kernel.org>
    tracing: Make sure variable reference alias has correct var_ref_idx

Michael Nosthoff <committed@heine.so>
    power: supply: sbs-battery: only return health when battery present

Michael Nosthoff <committed@heine.so>
    power: supply: sbs-battery: use correct flags field

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Treat Loongson Extensions as ASEs

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - use the full crypt length value

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - account for TEE not ready to report

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - fix concurrency issue in givencrypt descriptor

Wei Yongjun <weiyongjun1@huawei.com>
    crypto: cavium/zip - Add missing single_release()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: skcipher - Unmap pages after an external error

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    crypto: qat - Silence smp_processor_id() warning

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Fix "robust" test of do_generate_dynamic_list_file

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251x: mcp251x_hw_reset(): allow more time after a reset

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/mm: Don't do tlbie fixup for some hardware revisions

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/powernv/ioda: Fix race in TCE level allocation

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc/powernv: Restrict OPAL symbol map to only be readable by root

Santosh Sivaraj <santosh@fossix.org>
    powerpc/mce: Schedule work from irq_work

Balbir Singh <bsingharora@gmail.com>
    powerpc/mce: Fix MCE handling for huge pages

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: sgtl5000: Improve VAG power and mute control

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: Define a set of DAPM pre/post-up events

Dmitry Osipenko <digetx@gmail.com>
    PM / devfreq: tegra: Fix kHz to Hz conversion

Mike Christie <mchristi@redhat.com>
    nbd: fix max number of supported devs

Jack Wang <jinpu.wang@cloud.ionos.com>
    KVM: nVMX: handle page fault in vmread fix

Wanpeng Li <wanpengli@tencent.com>
    KVM: X86: Fix userspace set invalid CR4

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Don't lose pending doorbell request on migration on P9

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Check for MMU ready on piggybacked virtual cores

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Fix race in re-enabling XIVE escalation interrupts

Vasily Gorbik <gor@linux.ibm.com>
    s390/cio: exclude subchannels with no parent from pseudo check

Vasily Gorbik <gor@linux.ibm.com>
    s390/topology: avoid firing events before kobjs are created

Thomas Huth <thuth@redhat.com>
    KVM: s390: Test for bad access register and size at the start of S390_MEM_OP

Vasily Gorbik <gor@linux.ibm.com>
    s390/process: avoid potential reading of freed stack


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt  |  16 +-
 Documentation/arm64/elf_hwcaps.txt               |   4 +
 Makefile                                         |   4 +-
 arch/arm64/Kconfig                               |   1 +
 arch/arm64/include/asm/cpucaps.h                 |   3 +-
 arch/arm64/include/asm/cpufeature.h              |   4 -
 arch/arm64/include/asm/kvm_host.h                |  11 +
 arch/arm64/include/asm/processor.h               |  17 ++
 arch/arm64/include/asm/ptrace.h                  |   1 +
 arch/arm64/include/asm/sysreg.h                  |  19 +-
 arch/arm64/include/uapi/asm/hwcap.h              |   1 +
 arch/arm64/include/uapi/asm/ptrace.h             |   1 +
 arch/arm64/kernel/cpu_errata.c                   | 271 +++++++++++++++++------
 arch/arm64/kernel/cpufeature.c                   | 130 +++++++++--
 arch/arm64/kernel/cpuinfo.c                      |   1 +
 arch/arm64/kernel/process.c                      |  31 +++
 arch/arm64/kernel/ptrace.c                       |  15 +-
 arch/arm64/kernel/ssbd.c                         |  21 ++
 arch/arm64/kvm/hyp/sysreg-sr.c                   |  11 +
 arch/mips/include/asm/cpu-features.h             |  16 ++
 arch/mips/include/asm/cpu.h                      |   4 +
 arch/mips/kernel/cpu-probe.c                     |   6 +
 arch/mips/kernel/proc.c                          |   4 +
 arch/powerpc/include/asm/cputable.h              |   4 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c                |  30 ++-
 arch/powerpc/kernel/mce.c                        |  11 +-
 arch/powerpc/kernel/mce_power.c                  |  19 +-
 arch/powerpc/kvm/book3s_hv.c                     |  24 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c              |   2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S          |  36 +--
 arch/powerpc/kvm/book3s_xive.c                   |  18 +-
 arch/powerpc/mm/hash_native_64.c                 |   2 +-
 arch/powerpc/mm/hash_utils_64.c                  |   9 +-
 arch/powerpc/mm/tlb-radix.c                      |   4 +-
 arch/powerpc/platforms/powernv/opal.c            |  11 +-
 arch/powerpc/platforms/powernv/pci-ioda-tce.c    |  18 +-
 arch/powerpc/platforms/pseries/lpar.c            |   8 +-
 arch/riscv/kernel/entry.S                        |   6 +-
 arch/s390/kernel/process.c                       |  22 +-
 arch/s390/kernel/topology.c                      |   3 +-
 arch/s390/kvm/kvm-s390.c                         |   2 +-
 arch/x86/kvm/vmx.c                               |   4 +-
 arch/x86/kvm/x86.c                               |  38 ++--
 arch/x86/purgatory/Makefile                      |   1 +
 crypto/skcipher.c                                |  42 ++--
 drivers/block/nbd.c                              |  62 ++++--
 drivers/crypto/caam/caamalg_desc.c               |   9 +
 drivers/crypto/caam/caamalg_desc.h               |   2 +-
 drivers/crypto/cavium/zip/zip_main.c             |   3 +
 drivers/crypto/ccree/cc_aead.c                   |   2 +-
 drivers/crypto/ccree/cc_fips.c                   |   8 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h   |   2 +-
 drivers/devfreq/tegra-devfreq.c                  |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c           |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c          |   3 +
 drivers/gpu/drm/i915/gvt/scheduler.c             |  28 +--
 drivers/gpu/drm/i915/i915_gem_userptr.c          |  10 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c               |   8 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c          |   3 +-
 drivers/gpu/drm/omapdrm/dss/dss.c                |   2 +-
 drivers/gpu/drm/radeon/radeon_drv.c              |  31 +++
 drivers/gpu/drm/radeon/radeon_kms.c              |  25 ---
 drivers/hwtracing/coresight/coresight-etm4x.c    |  14 +-
 drivers/mmc/host/sdhci-of-esdhc.c                |   7 +-
 drivers/mmc/host/sdhci.c                         |  15 +-
 drivers/net/can/spi/mcp251x.c                    |  19 +-
 drivers/net/ethernet/netronome/nfp/flower/main.c |   1 +
 drivers/net/ieee802154/atusb.c                   |   3 +-
 drivers/ntb/test/ntb_perf.c                      |   2 +-
 drivers/nvdimm/bus.c                             |   2 +-
 drivers/nvdimm/region.c                          |   4 +-
 drivers/nvdimm/region_devs.c                     |   4 +-
 drivers/pci/controller/vmd.c                     |   9 +-
 drivers/pci/pci.c                                |   2 +-
 drivers/power/supply/sbs-battery.c               |  27 ++-
 drivers/pwm/pwm-stm32-lp.c                       |   6 +
 drivers/s390/cio/ccwgroup.c                      |   2 +-
 drivers/s390/cio/css.c                           |   2 +
 drivers/staging/erofs/dir.c                      |  11 +-
 drivers/staging/erofs/unzip_vle.c                |  37 +++-
 drivers/thermal/thermal_core.c                   |   2 +-
 drivers/thermal/thermal_hwmon.c                  |   8 +-
 drivers/watchdog/aspeed_wdt.c                    |   4 +-
 drivers/watchdog/imx2_wdt.c                      |   4 +-
 drivers/xen/pci.c                                |  21 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c         |  20 +-
 fs/9p/vfs_file.c                                 |   3 +
 fs/ceph/inode.c                                  |   7 +-
 fs/ceph/mds_client.c                             |   4 +-
 fs/fuse/cuse.c                                   |   1 +
 fs/nfs/nfs4xdr.c                                 |   2 +-
 fs/nfs/pnfs.c                                    |   9 +-
 fs/statfs.c                                      |  17 +-
 include/linux/ieee80211.h                        |  53 +++++
 include/linux/sched/mm.h                         |   2 +
 include/sound/soc-dapm.h                         |   2 +
 kernel/elfcore.c                                 |   1 +
 kernel/locking/qspinlock_paravirt.h              |   2 +-
 kernel/sched/core.c                              |   4 +-
 kernel/sched/membarrier.c                        |   2 +-
 kernel/time/tick-broadcast-hrtimer.c             |  57 ++---
 kernel/time/timer.c                              |   8 +-
 kernel/trace/trace_events_hist.c                 |   2 +
 mm/usercopy.c                                    |   8 +-
 net/9p/client.c                                  |   1 +
 net/netfilter/nf_tables_api.c                    |   7 +-
 net/netfilter/nft_lookup.c                       |   3 -
 net/wireless/nl80211.c                           |  42 +++-
 net/wireless/reg.c                               |   2 +-
 net/wireless/scan.c                              |  14 +-
 net/wireless/wext-compat.c                       |   2 +-
 security/integrity/ima/ima_crypto.c              |  10 +-
 sound/soc/codecs/sgtl5000.c                      | 224 ++++++++++++++++---
 tools/lib/traceevent/Makefile                    |   4 +-
 tools/lib/traceevent/event-parse.c               |   3 +-
 tools/perf/Makefile.config                       |   2 +-
 tools/perf/arch/x86/util/unwind-libunwind.c      |   2 +-
 tools/perf/builtin-stat.c                        |   5 +-
 tools/perf/util/header.c                         |   2 +-
 tools/perf/util/stat.c                           |  17 ++
 tools/perf/util/stat.h                           |   1 +
 tools/testing/nvdimm/test/nfit_test.h            |   4 +-
 122 files changed, 1415 insertions(+), 459 deletions(-)


