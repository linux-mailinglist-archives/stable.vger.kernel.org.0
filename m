Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932F3D230E
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbfJJIjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387791AbfJJIjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5F5820B7C;
        Thu, 10 Oct 2019 08:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696748;
        bh=VVYtIcdjNC3r8TbrkWDFhdAS05Y7KYCMIYTp050jqmw=;
        h=From:To:Cc:Subject:Date:From;
        b=T+0lbpjvfSRZ9iJlhsZlanORQQTMH2//Mumfsbhk2Ba6N9MLj6si+YOurb0t2RYs3
         2FipopJBdw7F4X0xTKA/9TClg6gt9JWYymN4g0+BZ122sLu272xLi8IHeauZ0gUtYq
         mAbTWzapPfRd+IZ+sBNFauo+CBZgMK1Pe9DLbVtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 000/148] 5.3.6-stable review
Date:   Thu, 10 Oct 2019 10:34:21 +0200
Message-Id: <20191010083609.660878383@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.6-rc1
X-KernelTest-Deadline: 2019-10-12T08:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.6 release.
There are 148 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.6-rc1

Dave Jiang <dave.jiang@intel.com>
    libnvdimm: prevent nvdimm from requesting key when security is disabled

Gao Xiang <gaoxiang25@huawei.com>
    staging: erofs: detect potential multiref due to corrupted images

Gao Xiang <gaoxiang25@huawei.com>
    staging: erofs: avoid endless loop of invalid lookback distance 0

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

Vincent Chen <vincent.chen@sifive.com>
    riscv: Avoid interrupts being erroneously enabled in handle_exception()

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    perf stat: Reset previous counts on repeat with interval

Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
    tick: broadcast-hrtimer: Fix a race in bc_set_next

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Fix consistency check on injected exception error code

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix selftests failure due to uninitialized i_mode in test inodes

Hans de Goede <hdegoede@redhat.com>
    drm/radeon: Bail earlier when radeon.cik_/si_support=0 is passed

Navid Emamdoost <navid.emamdoost@gmail.com>
    nfp: abm: fix memory leak in nfp_abm_u32_knode_replace

Danielle Ratson <danieller@mellanox.com>
    mlxsw: spectrum_flower: Fail in case user specifies multiple mirror actions

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf unwind: Fix libunwind build failure on i386 systems

Lee Jones <lee.jones@linaro.org>
    i2c: qcom-geni: Disable DMA processing on the Lenovo Yoga C630

Marek Vasut <marex@denx.de>
    net: dsa: microchip: Always set regmap stride to 1

Allan Zhang <allanzhang@google.com>
    bpf: Fix bpf_event_output re-entry issue

Ming Lei <ming.lei@redhat.com>
    blk-mq: move lockdep_assert_held() into elevator_exit

Andrii Nakryiko <andriin@fb.com>
    libbpf: fix false uninitialized variable warning

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    kernel/elfcore.c: include proper prototypes

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: adjust strobemeta loop to satisfy latest clang

Qian Cai <cai@lca.pw>
    include/trace/events/writeback.h: fix -Wstringop-truncation warnings

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
    libnvdimm: Fix endian conversion issues 

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    libnvdimm/region: Initialize bad block for volatile namespaces

Andrei Dulea <adulea@amazon.de>
    iommu/amd: Fix downgrading default page-sizes in alloc_pte()

Stefan Mavrodiev <stefan@olimex.com>
    thermal_hwmon: Sanitize thermal_zone type

Ido Schimmel <idosch@mellanox.com>
    thermal: Fix use-after-free when unregistering thermal zone device

Sanjay R Mehta <sanju.mehta@amd.com>
    ntb: point to right memory window index

Arvind Sankar <nivedita@alum.mit.edu>
    x86/purgatory: Disable the stackleak GCC plugin for the purgatory

Tycho Andersen <tycho@tycho.ws>
    selftests/seccomp: fix build on older kernels

Fabrice Gasnier <fabrice.gasnier@st.com>
    pwm: stm32-lp: Add check in case requested period cannot be achieved

Trond Myklebust <trondmy@gmail.com>
    SUNRPC: Don't try to parse incomplete RPC messages

Trond Myklebust <trondmy@gmail.com>
    pNFS: Ensure we do clear the return-on-close layout stateid on fatal errors

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to clear tev->nargs in clear_probe_trace_event()

Trek <trek00@inbox.ru>
    drm/amdgpu: Check for valid number of registers to read

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdgpu: Fix KFD-related kernel oops on Hawaii

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: allow lookups in dynamic sets

Ryan Chen <ryan_chen@aspeedtech.com>
    watchdog: aspeed: Add support for AST2600

Trond Myklebust <trondmy@gmail.com>
    SUNRPC: RPC level errors should always set task->tk_rpc_status

Erqi Chen <chenerqi@gmail.com>
    ceph: reconnect connection if session hang in opening state

Jeff Layton <jlayton@kernel.org>
    ceph: fetch cap_gen under spinlock in ceph_add_cap

Luis Henriques <lhenriques@suse.com>
    ceph: fix directories inode i_blkbits initialization

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix request limit

Igor Druzhinin <igor.druzhinin@citrix.com>
    xen/pci: reserve MCFG areas earlier

Chengguang Xu <cgxu519@zoho.com.cn>
    9p: avoid attaching writeback_fid on mmap with type PRIVATE

Lu Shuaibing <shuaibinglu@126.com>
    9p: Transport error uninitialized

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Send Queue size grows after a reconnect

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Toggle XPRT_CONGESTED in xprtrdma's slot methods

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: nfs: Fix possible null-pointer dereferences in encode_attrs()

Sascha Hauer <s.hauer@pengutronix.de>
    ima: fix freeing ongoing ahash_request

Sascha Hauer <s.hauer@pengutronix.de>
    ima: always return negative code for error

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    drivers: thermal: qcom: tsens: Fix memory leak from qfprom read

Johannes Berg <johannes.berg@intel.com>
    cfg80211: initialize on-stack chandefs

Johannes Berg <johannes.berg@intel.com>
    cfg80211: validate SSID/MBSSID element ordering assumption

Johannes Berg <johannes.berg@intel.com>
    nl80211: validate beacon head

Johan Hovold <johan@kernel.org>
    ieee802154: atusb: fix use-after-free at disconnect

Juergen Gross <jgross@suse.com>
    xen/xenbus: fix self-deadlock after killing user process

David Hildenbrand <david@redhat.com>
    xen/balloon: Set pages PageOffline() in balloon_add_region()

H. Nikolaus Schaller <hns@goldelico.com>
    DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again

Seth Forshee <seth.forshee@canonical.com>
    sched: Add __ASSEMBLY__ guards around struct clone_args

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    libnvdimm/altmap: Track namespace boundaries in altmap

Wanpeng Li <wanpengli@tencent.com>
    Revert "locking/pvqspinlock: Don't wait if vCPU is preempted"

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Let drivers define their DMA mask

Russell King <rmk+kernel@armlinux.org.uk>
    mmc: sdhci-of-esdhc: set DMA snooping based on DMA coherence

Russell King <rmk+kernel@armlinux.org.uk>
    mmc: sdhci: improve ADMA error reporting

Nicolin Chen <nicoleotsuka@gmail.com>
    mmc: tegra: Implement ->set_dma_mask()

Johannes Berg <johannes.berg@intel.com>
    mac80211: keep BHs disabled while calling drv_tx_wake_queue()

Xiaolin Zhang <xiaolin.zhang@intel.com>
    drm/i915: to make vgpu ppgtt notificaiton as atomic operation

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/userptr: Acquire the page lock around set_page_dirty()

Xiaolin Zhang <xiaolin.zhang@intel.com>
    drm/i915/gvt: update vgpu workload head pointer correctly

Kevin Wang <kevin1.wang@amd.com>
    drm/amd/powerplay: change metrics update period from 1ms to 100ms

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv50-: Don't create MSTMs for eDP connectors

Sean Paul <seanpaul@chromium.org>
    drm/msm/dsi: Fix return value check for clk_get_parent

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/omap: fix max fclk divider for omap36xx

Anders Roxell <anders.roxell@linaro.org>
    drm: mali-dp: Mark expected switch fall-through

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/atomic: Take the atomic toys away from X

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/atomic: Reject FLIP_ASYNC unconditionally

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/i915/dp: Fix dsc bpp calculations, v5.

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    perf stat: Fix a segmentation fault when using repeat forever

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix segfault in cpu_cache_level__read()

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    watchdog: imx2_wdt: fix min() calculation in imx2_wdt_set_timeout

Shuah Khan <skhan@linuxfoundation.org>
    selftests: pidfd: Fix undefined reference to pthread_create()

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    selftests/tpm2: Add the missing TEST_FILES assignment

Sumit Saxena <sumit.saxena@broadcom.com>
    PCI: Restore Resizable BAR size bits correctly for 1MB BARs

Jon Derrick <jonathan.derrick@intel.com>
    PCI: vmd: Fix shadow offsets to reflect spec changes

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it

Jon Derrick <jonathan.derrick@intel.com>
    PCI: vmd: Fix config addressing when using bus offsets

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

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam/qi - fix error handling in ERN handler

Wei Yongjun <weiyongjun1@huawei.com>
    crypto: cavium/zip - Add missing single_release()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: skcipher - Unmap pages after an external error

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    crypto: qat - Silence smp_processor_id() warning

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on failure

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Fix "robust" test of do_generate_dynamic_list_file

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251x: mcp251x_hw_reset(): allow more time after a reset

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm: Fixup tlbie vs mtpidr/mtlpidr ordering issue on POWER9

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/mm: Fix an Oops in kasan_mmu_init()

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/mm: Add a helper to select PAGE_KERNEL_RO or PAGE_READONLY

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/radix: Rename CPU_FTR_P9_TLBIE_BUG feature flag

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/mm: Don't do tlbie fixup for some hardware revisions

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kasan: Fix shadow area set up for modules.

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kasan: Fix parallel loading of modules.

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/powernv/ioda: Fix race in TCE level allocation

Gautham R. Shenoy <ego@linux.vnet.ibm.com>
    powerpc/pseries: Fix cpu_hotplug_lock acquisition in resize_hpt()

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc/powernv: Restrict OPAL symbol map to only be readable by root

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/ptdump: Fix addresses display on PPC32

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/32s: Fix boot failure with DEBUG_PAGEALLOC without KASAN.

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/603: Fix handling of the DIRTY flag

Santosh Sivaraj <santosh@fossix.org>
    powerpc/mce: Schedule work from irq_work

Balbir Singh <bsingharora@gmail.com>
    powerpc/mce: Fix MCE handling for huge pages

Paul Mackerras <paulus@ozlabs.org>
    powerpc/xive: Implement get_irqchip_state method for XIVE to fix shutdown race

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: sgtl5000: Improve VAG power and mute control

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: Define a set of DAPM pre/post-up events

Dmitry Osipenko <digetx@gmail.com>
    PM / devfreq: tegra: Fix kHz to Hz conversion

Mike Christie <mchristi@redhat.com>
    nbd: fix max number of supported devs

Wanpeng Li <wanpengli@tencent.com>
    KVM: X86: Fix userspace set invalid CR4

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Don't lose pending doorbell request on migration on P9

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Check for MMU ready on piggybacked virtual cores

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Fix race in re-enabling XIVE escalation interrupts

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Don't push XIVE context when not using XIVE device

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before disabling the VP

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S: Enable XIVE native capability only if OPAL has required functions

Heiko Carstens <heiko.carstens@de.ibm.com>
    KVM: s390: fix __insn32_query() inline assembly

Stefan Haberland <sth@linux.ibm.com>
    Revert "s390/dasd: Add discard support for ESE volumes"

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix error handling during online processing

Vasily Gorbik <gor@linux.ibm.com>
    s390/cio: exclude subchannels with no parent from pseudo check

Vasily Gorbik <gor@linux.ibm.com>
    s390/cio: avoid calling strlen on null pointer

Vasily Gorbik <gor@linux.ibm.com>
    s390/topology: avoid firing events before kobjs are created

Thomas Huth <thuth@redhat.com>
    KVM: s390: Test for bad access register and size at the start of S390_MEM_OP

Philipp Rudo <prudo@linux.ibm.com>
    s390/sclp: Fix bit checked for has_sipl

Vasily Gorbik <gor@linux.ibm.com>
    s390/process: avoid potential reading of freed stack


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/omap3-gta04.dtsi                 |   1 +
 arch/mips/include/asm/cpu-features.h               |  16 ++
 arch/mips/include/asm/cpu.h                        |   4 +
 arch/mips/kernel/cpu-probe.c                       |   6 +
 arch/mips/kernel/proc.c                            |   4 +
 arch/powerpc/include/asm/cputable.h                |   5 +-
 arch/powerpc/include/asm/kvm_ppc.h                 |   1 +
 arch/powerpc/include/asm/xive.h                    |   9 +
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |  32 ++-
 arch/powerpc/kernel/head_32.S                      |   6 +-
 arch/powerpc/kernel/mce.c                          |  11 +-
 arch/powerpc/kernel/mce_power.c                    |  19 +-
 arch/powerpc/kvm/book3s.c                          |   8 +-
 arch/powerpc/kvm/book3s_hv.c                       |  24 ++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |  42 +++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  38 ++--
 arch/powerpc/kvm/book3s_xive.c                     |  60 +++++-
 arch/powerpc/kvm/book3s_xive.h                     |   2 +
 arch/powerpc/kvm/book3s_xive_native.c              |  23 ++-
 arch/powerpc/kvm/powerpc.c                         |   3 +-
 arch/powerpc/mm/book3s32/mmu.c                     |   9 +
 arch/powerpc/mm/book3s64/hash_native.c             |  31 ++-
 arch/powerpc/mm/book3s64/hash_utils.c              |   9 +-
 arch/powerpc/mm/book3s64/radix_tlb.c               |  84 +++++++-
 arch/powerpc/mm/init_64.c                          |  17 +-
 arch/powerpc/mm/kasan/kasan_init_32.c              |  57 +++++-
 arch/powerpc/mm/ptdump/ptdump.c                    |   2 +-
 arch/powerpc/platforms/powernv/opal.c              |  11 +-
 arch/powerpc/platforms/powernv/pci-ioda-tce.c      |  18 +-
 arch/powerpc/platforms/pseries/lpar.c              |   8 +-
 arch/powerpc/sysdev/xive/common.c                  |  87 +++++---
 arch/powerpc/sysdev/xive/native.c                  |   7 +
 arch/riscv/kernel/entry.S                          |   6 +-
 arch/s390/kernel/process.c                         |  22 +-
 arch/s390/kernel/topology.c                        |   3 +-
 arch/s390/kvm/kvm-s390.c                           |   8 +-
 arch/x86/kvm/vmx/nested.c                          |   2 +-
 arch/x86/kvm/x86.c                                 |  38 ++--
 arch/x86/purgatory/Makefile                        |   1 +
 block/blk-mq-sched.c                               |   2 -
 block/blk.h                                        |   2 +
 crypto/skcipher.c                                  |  42 ++--
 drivers/block/nbd.c                                |  39 ++--
 drivers/crypto/caam/caamalg_desc.c                 |   9 +
 drivers/crypto/caam/caamalg_desc.h                 |   2 +-
 drivers/crypto/caam/error.c                        |   1 +
 drivers/crypto/caam/qi.c                           |   5 +-
 drivers/crypto/caam/regs.h                         |   1 +
 drivers/crypto/cavium/zip/zip_main.c               |   3 +
 drivers/crypto/ccree/cc_aead.c                     |   2 +-
 drivers/crypto/ccree/cc_fips.c                     |   8 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   2 +-
 drivers/devfreq/tegra-devfreq.c                    |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   3 +
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c         |   2 +-
 drivers/gpu/drm/arm/malidp_hw.c                    |   3 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |   3 +-
 drivers/gpu/drm/drm_ioctl.c                        |   7 +-
 drivers/gpu/drm/i915/display/intel_display.c       |  12 +-
 drivers/gpu/drm/i915/display/intel_display.h       |   2 +-
 drivers/gpu/drm/i915/display/intel_dp.c            | 184 +++++++++--------
 drivers/gpu/drm/i915/display/intel_dp.h            |   6 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c        |  10 +-
 drivers/gpu/drm/i915/gvt/scheduler.c               |  28 +--
 drivers/gpu/drm/i915/i915_drv.h                    |   1 +
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  12 +-
 drivers/gpu/drm/i915/i915_vgpu.c                   |   1 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   8 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   3 +-
 drivers/gpu/drm/omapdrm/dss/dss.c                  |   2 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |  31 +++
 drivers/gpu/drm/radeon/radeon_kms.c                |  25 ---
 drivers/hwtracing/coresight/coresight-etm4x.c      |  15 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |  12 +-
 drivers/iommu/amd_iommu.c                          |   3 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |   7 +-
 drivers/mmc/host/sdhci-tegra.c                     |  48 +++--
 drivers/mmc/host/sdhci.c                           |  27 +--
 drivers/mmc/host/sdhci.h                           |   1 +
 drivers/net/can/spi/mcp251x.c                      |  19 +-
 drivers/net/dsa/microchip/ksz_common.h             |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   6 +
 drivers/net/ethernet/netronome/nfp/abm/cls.c       |  14 +-
 drivers/net/ieee802154/atusb.c                     |   3 +-
 drivers/ntb/test/ntb_perf.c                        |   2 +-
 drivers/nvdimm/btt.c                               |   8 +-
 drivers/nvdimm/bus.c                               |   2 +-
 drivers/nvdimm/namespace_devs.c                    |   7 +-
 drivers/nvdimm/pfn_devs.c                          |   2 +
 drivers/nvdimm/region.c                            |   4 +-
 drivers/nvdimm/region_devs.c                       |   4 +-
 drivers/nvdimm/security.c                          |   4 +
 drivers/pci/controller/pci-hyperv.c                |   2 +-
 drivers/pci/controller/vmd.c                       |  25 ++-
 drivers/pci/pci.c                                  |   2 +-
 drivers/power/supply/sbs-battery.c                 |  27 ++-
 drivers/pwm/pwm-stm32-lp.c                         |   6 +
 drivers/s390/block/dasd_eckd.c                     |  81 +-------
 drivers/s390/char/sclp_early.c                     |   2 +-
 drivers/s390/cio/ccwgroup.c                        |   2 +-
 drivers/s390/cio/css.c                             |   2 +
 drivers/staging/erofs/dir.c                        |  11 +-
 drivers/staging/erofs/unzip_vle.c                  |  37 +++-
 drivers/staging/erofs/zmap.c                       |   6 +
 drivers/thermal/qcom/tsens-8960.c                  |   2 +
 drivers/thermal/qcom/tsens-v0_1.c                  |  12 +-
 drivers/thermal/qcom/tsens-v1.c                    |   1 +
 drivers/thermal/qcom/tsens.h                       |   1 +
 drivers/thermal/thermal_core.c                     |   2 +-
 drivers/thermal/thermal_hwmon.c                    |   8 +-
 drivers/watchdog/aspeed_wdt.c                      |   4 +-
 drivers/watchdog/imx2_wdt.c                        |   4 +-
 drivers/xen/balloon.c                              |   1 +
 drivers/xen/pci.c                                  |  21 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |  20 +-
 fs/9p/vfs_file.c                                   |   3 +
 fs/btrfs/tests/btrfs-tests.c                       |   8 +-
 fs/ceph/caps.c                                     |   9 +-
 fs/ceph/inode.c                                    |   7 +-
 fs/ceph/mds_client.c                               |   4 +-
 fs/fuse/cuse.c                                     |   1 +
 fs/fuse/inode.c                                    |   7 +-
 fs/nfs/nfs4xdr.c                                   |   2 +-
 fs/nfs/pnfs.c                                      |   9 +-
 fs/statfs.c                                        |  17 +-
 include/linux/memremap.h                           |   1 +
 include/linux/sched/mm.h                           |   2 +
 include/sound/soc-dapm.h                           |   2 +
 include/trace/events/writeback.h                   |  38 ++--
 include/uapi/linux/sched.h                         |   2 +
 kernel/elfcore.c                                   |   1 +
 kernel/locking/qspinlock_paravirt.h                |   2 +-
 kernel/sched/core.c                                |   4 +-
 kernel/sched/membarrier.c                          |   2 +-
 kernel/time/tick-broadcast-hrtimer.c               |  57 +++---
 kernel/time/timer.c                                |   8 +-
 kernel/trace/bpf_trace.c                           |  26 ++-
 kernel/trace/trace_events_hist.c                   |   2 +
 mm/usercopy.c                                      |   8 +-
 net/9p/client.c                                    |   1 +
 net/mac80211/util.c                                |  13 +-
 net/netfilter/nf_tables_api.c                      |   7 +-
 net/netfilter/nft_lookup.c                         |   3 -
 net/sunrpc/clnt.c                                  |  20 +-
 net/sunrpc/sched.c                                 |   5 +-
 net/sunrpc/xprtrdma/transport.c                    |   4 +-
 net/sunrpc/xprtrdma/verbs.c                        |  26 +--
 net/wireless/nl80211.c                             |  41 +++-
 net/wireless/reg.c                                 |   2 +-
 net/wireless/scan.c                                |   7 +-
 net/wireless/wext-compat.c                         |   2 +-
 security/integrity/ima/ima_crypto.c                |  10 +-
 sound/soc/codecs/sgtl5000.c                        | 224 ++++++++++++++++++---
 tools/lib/bpf/btf_dump.c                           |   1 +
 tools/lib/traceevent/Makefile                      |   4 +-
 tools/lib/traceevent/event-parse.c                 |   3 +-
 tools/perf/Makefile.config                         |   2 +-
 tools/perf/arch/x86/util/unwind-libunwind.c        |   2 +-
 tools/perf/builtin-stat.c                          |   5 +-
 tools/perf/util/header.c                           |   2 +-
 tools/perf/util/probe-event.c                      |   1 +
 tools/perf/util/stat.c                             |  17 ++
 tools/perf/util/stat.h                             |   1 +
 tools/testing/nvdimm/test/nfit_test.h              |   4 +-
 tools/testing/selftests/bpf/progs/strobemeta.h     |   5 +-
 tools/testing/selftests/pidfd/Makefile             |   2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   5 +
 tools/testing/selftests/tpm2/Makefile              |   1 +
 171 files changed, 1624 insertions(+), 703 deletions(-)


