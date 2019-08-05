Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1028B81C20
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbfHENUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730140AbfHENUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:20:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C07120657;
        Mon,  5 Aug 2019 13:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011227;
        bh=Z+cCl2A/sYP5qfPNpACDW3qNGQGqh7MnOeMG18AQJDI=;
        h=From:To:Cc:Subject:Date:From;
        b=F1saqC9OWtCdzs4ZSRhsrTNIV2ORr9Hb+j7PegKcqVd000MAamSuNwp2zgnfhD5ZC
         GiHVBHxuPhafv5z+98nAmXHqIDaxPIrIy0ohlmfV2AtR40MNVY+sxhi4aeIBhIOfjV
         8KlmNKB33BukF12qMHIFtjFWUv+uVN51T6QNxedA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 000/131] 5.2.7-stable review
Date:   Mon,  5 Aug 2019 15:01:27 +0200
Message-Id: <20190805124951.453337465@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.7-rc1
X-KernelTest-Deadline: 2019-08-07T12:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.7 release.
There are 131 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.7-rc1

Xiaolin Zhang <xiaolin.zhang@intel.com>
    drm/i915/gvt: fix incorrect cache entry for guest page mapping

Lionel Landwerlin <lionel.g.landwerlin@intel.com>
    drm/i915/perf: fix ICL perf register offsets

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Field not zero-ed when allocating TID flow memory

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Drop all TID RDMA READ RESP packets after r_next_psn

John Fleck <john.fleck@intel.com>
    IB/hfi1: Check for error on call to alloc_rsm_map_table

Yishai Hadas <yishaih@mellanox.com>
    IB/mlx5: Fix RSS Toeplitz setup to be aligned with the HW specification

Yishai Hadas <yishaih@mellanox.com>
    IB/mlx5: Fix clean_mr() to work in the expected order

Yishai Hadas <yishaih@mellanox.com>
    IB/mlx5: Move MRs to a kernel PD when freeing them to the MR cache

Yishai Hadas <yishaih@mellanox.com>
    IB/mlx5: Use direct mkey destroy command upon UMR unreg failure

Yishai Hadas <yishaih@mellanox.com>
    IB/mlx5: Fix unreg_umr to ignore the mkey state

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/devices: Do not deadlock during client removal

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Honor vlan_id in GID entry comparison

Souptick Joarder <jrdr.linux@gmail.com>
    xen/gntdev.c: Replace vm_map_pages() with vm_map_pages_zero()

Juergen Gross <jgross@suse.com>
    xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()

Munehisa Kamata <kamatam@amazon.com>
    nbd: replace kill_bdev() with __invalidate_device() again

Suganath Prabu <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Use 63-bit DMA addressing on SAS35 HBA

Weiyi Lu <weiyi.lu@mediatek.com>
    clk: mediatek: mt8183: Register 13MHz clock earlier for clocksource

Jackie Liu <liuyun01@kylinos.cn>
    io_uring: fix KASAN use after free in io_sq_wq_submit_work

Will Deacon <will@kernel.org>
    arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}

Will Deacon <will@kernel.org>
    arm64: compat: Allow single-byte watchpoints on all addresses

Will Deacon <will@kernel.org>
    drivers/perf: arm_pmu: Fix failure path in PM notifier

Helge Deller <deller@gmx.de>
    parisc: Fix build of compressed kernel even with debug enabled

Helge Deller <deller@gmx.de>
    parisc: Strip debug info from kernel before creating compressed vmlinuz

James Bottomley <James.Bottomley@HansenPartnership.com>
    parisc: Add archclean Makefile target

Chris Down <chris@chrisdown.name>
    cgroup: kselftest: relax fs_spec checks

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix endless loop after read unit address configuration

Jan Kara <jack@suse.cz>
    loop: Fix mount(2) failure due to race with LOOP_SET_FD

Ralph Campbell <rcampbell@nvidia.com>
    mm/migrate.c: initialize pud_entry in migrate_vma()

Arnd Bergmann <arnd@arndb.de>
    ubsan: build ubsan.c more conservatively

Mel Gorman <mgorman@techsingularity.net>
    mm: compaction: avoid 100% CPU usage during compaction when a task is killed

Jan Kara <jack@suse.cz>
    mm: migrate: fix reference check race between __find_get_block() and migration

Yang Shi <yang.shi@linux.alibaba.com>
    mm: vmscan: check if mem cgroup is disabled or not before calling memcg slab shrinker

Samuel Thibault <samuel.thibault@ens-lyon.org>
    ALSA: hda: Fix 1-minute detection delay when i915 module is not available

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix memory leak in policydb_init()

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kasan: fix early boot failure on PPC32

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    i2c: at91: fix clk_offset for sama5d2

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    i2c: at91: disable TXRDY interrupt after sending data

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    i2c: iproc: Fix i2c master read more than 63 bytes

Jean Delvare <jdelvare@suse.de>
    eeprom: at24: make spd world-readable again

Marco Felsch <m.felsch@pengutronix.de>
    mtd: rawnand: micron: handle on-die "ECC-off" devices correctly

Lyude Paul <lyude@redhat.com>
    drm/nouveau: Only release VCPI slots on mode changes

Gustavo A. R. Silva <gustavo@embeddedor.com>
    IB/hfi1: Fix Spectre v1 vulnerability

Michael Wu <michael.wu@vatics.com>
    gpiolib: fix incorrect IRQ requesting of an active-low lineevent

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    gpio: don't WARN() on NULL descs if gpiolib is disabled

Chris Packham <chris.packham@alliedtelesis.co.nz>
    gpiolib: Preserve desc->flags when setting state

Andreas Koop <andreas.koop@zf.com>
    mmc: mmc_spi: Enable stable writes

Baolin Wang <baolin.wang@linaro.org>
    mmc: host: sdhci-sprd: Fix the missing pm_runtime_put_noidle()

Joe Perches <joe@perches.com>
    mmc: meson-mx-sdio: Fix misuse of GENMASK macro

Douglas Anderson <dianders@chromium.org>
    mmc: dw_mmc: Fix occasional hang after tuning on eMMC

Changbin Du <changbin.du@intel.com>
    fgraph: Remove redundant ftrace_graph_notrace_addr() test

Jan Kara <jack@suse.cz>
    dax: Fix missed wakeup in put_unlocked_entry()

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race leading to fs corruption after transaction abort

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix incremental send failure after deduplication

Milan Broz <gmazyland@gmail.com>
    tpm: Fix null pointer dereference on chip register error path

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: modpost: include .*.cmd files only when targets exist

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: initialize CLANG_FLAGS correctly in the top Makefile

M. Vefa Bicakci <m.v.b@runbox.com>
    kconfig: Clear "written" flag to avoid data loss

Ralph Campbell <rcampbell@nvidia.com>
    drm/nouveau/dmem: missing mutex_lock in error path

Fugang Duan <fugang.duan@nxp.com>
    dma-direct: correct the physical addr in dma_direct_sync_sg_for_cpu/device

Yongxin Liu <yongxin.liu@windriver.com>
    drm/nouveau: fix memory leak in nouveau_conn_reset()

Josh Poimboeuf <jpoimboe@redhat.com>
    bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    x86, boot: Remove multiple copy of static function sanitize_boot_params()

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/paravirt: Fix callee-saved function ELF sizes

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/kvm: Don't call kvm_spurious_fault() from .fixup

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    xen/pv: Fix a boot up hang revealed by int3 self test

David Rientjes <rientjes@google.com>
    crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL

Peter Zijlstra <peterz@infradead.org>
    stacktrace: Force USER_DS for stack_trace_save_user()

Pavel Tatashin <pasha.tatashin@soleen.com>
    mm/hotplug: make remove_memory() interface usable

Pavel Tatashin <pasha.tatashin@soleen.com>
    device-dax: fix memory and resource leak if hotplug fails

Dmitry V. Levin <ldv@altlinux.org>
    nds32: fix asm/syscall.h

Kees Cook <keescook@chromium.org>
    ipc/mqueue.c: only perform resource calculation if user valid

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/rapidio/devices/rio_mport_cdev.c: NUL terminate some strings

Mikko Rapeli <mikko.rapeli@iki.fi>
    uapi linux/coda_psdev.h: move upc_req definition from uapi to kernel side headers

Sam Protsenko <semen.protsenko@linaro.org>
    coda: fix build using bare-metal toolchain

Zhouyang Jia <jiazhouyang09@gmail.com>
    coda: add error handling for fget

Anshuman Khandual <anshuman.khandual@arm.com>
    mm/ioremap: check virtual address alignment while creating huge mappings

Peter Rosin <peda@axentia.se>
    lib/test_string.c: avoid masking memset16/32/64 failures

Kees Cook <keescook@chromium.org>
    lib/test_overflow.c: avoid tainting the kernel and fix wrap size

Doug Berger <opendmb@gmail.com>
    mm/cma.c: fail if fixed declaration can't be honored

Arnd Bergmann <arnd@arndb.de>
    x86: math-emu: Hide clang warnings for 16-bit overflow

Qian Cai <cai@lca.pw>
    x86/apic: Silence -Wtype-limits compiler warnings

Henry Burns <henryburns@google.com>
    mm/z3fold.c: reinitialize zhdr structs after migration

Yafang Shao <laoar.shao@gmail.com>
    mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones

Arnd Bergmann <arnd@arndb.de>
    mm/slab_common.c: work around clang bug #42570

Vitaly Wool <vitalywool@gmail.com>
    mm/z3fold: don't try to use buddy slots after free

Benjamin Poirier <bpoirier@suse.com>
    be2net: Signal that the device cannot transmit during reconfiguration

Andrii Nakryiko <andriin@fb.com>
    bpf: fix BTF verifier size resolution logic

Liran Alon <liran.alon@oracle.com>
    KVM: nVMX: Ignore segment base for VMX memory operand when segment not FS or GS

Arnd Bergmann <arnd@arndb.de>
    ACPI: fix false-positive -Wuninitialized warning

Arnd Bergmann <arnd@arndb.de>
    x86: kvm: avoid constant-conversion warning

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    perf version: Fix segfault due to missing OPT_END()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix crash in cifs_dfs_do_automount

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Expose audio inst from DC to DM

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: do not ignore clang failures

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: fix GCC compiler warning emitted with -Wmaybe-uninitialized

Arnd Bergmann <arnd@arndb.de>
    ACPI: blacklist: fix clang warning for unused DMI table

Ihor Matushchak <ihor.matushchak@foobox.net>
    virtio-mmio: add error check for platform_get_irq

Jeff Layton <jlayton@kernel.org>
    ceph: return -ERANGE if virtual xattr value didn't fit in buffer

Yan, Zheng <zyan@redhat.com>
    ceph: fix dir_lease_is_valid()

Andrea Parri <andrea.parri@amarulasolutions.com>
    ceph: fix improper use of smp_mb__before_atomic()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: Fix a race condition with cifs_echo_request

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: Don't hold qgroup_ioctl_lock in btrfs_qgroup_inherit()

Clement Leger <cleger@kalray.eu>
    remoteproc: copy parent dma_pfn_offset for vdev

Qu Wenruo <wqu@suse.com>
    btrfs: Flush before reflinking any extent to prevent NOCOW write falling back to COW without data reservation

David Sterba <dsterba@suse.com>
    btrfs: fix minimum number of chunk errors for DUP

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Check if the file extent end overflows

Vicente Bergas <vicencb@gmail.com>
    arm64: dts: rockchip: Fix USB3 Type-C on rk3399-sapphire

Chunyan Zhang <zhang.chunyan@linaro.org>
    clk: sprd: Add check for return value of sprd_clk_regmap_init()

Russell King <rmk+kernel@armlinux.org.uk>
    fs/adfs: super: fix use-after-free bug

JC Kuo <jckuo@nvidia.com>
    clk: tegra210: fix PLLU and PLLU_OUT1

Arnd Bergmann <arnd@arndb.de>
    ARM: exynos: Only build MCPM support if used

Geert Uytterhoeven <geert+renesas@glider.be>
    dmaengine: rcar-dmac: Reject zero-length slave DMA requests

Petr Cvek <petrcvekcz@gmail.com>
    MIPS: lantiq: Fix bitfield masking

Arnd Bergmann <arnd@arndb.de>
    swiotlb: fix phys_addr_t overflow warning

Andy Gross <agross@kernel.org>
    arm64: qcom: qcs404: Add reset-cells to GCC node

Anson Huang <Anson.Huang@nxp.com>
    soc: imx8: Fix potential kernel dump in error path

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    firmware/psci: psci_checker: Park kthreads before stopping them

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    PCI: OF: Initialize dev->fwnode appropriately

Prarit Bhargava <prarit@redhat.com>
    kernel/module.c: Only return -EEXIST for modules that have finished loading

Helen Koike <helen.koike@collabora.com>
    arm64: dts: rockchip: fix isp iommu clocks and power domain

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Error out if DMA_PREP_INTERRUPT flag is unset

Anson Huang <Anson.Huang@nxp.com>
    soc: imx: soc-imx8: Correct return value of error handle

Heinrich Schuchardt <xypron.glpk@gmx.de>
    arm64: dts: marvell: mcbin: enlarge PCI memory window

Sibi Sankar <sibis@codeaurora.org>
    soc: qcom: rpmpd: fixup rpmpd set performance state

Niklas Cassel <niklas.cassel@linaro.org>
    arm64: dts: qcom: qcs404-evb: fix l3 min voltage

Cheng Jian <cj.chengjian@huawei.com>
    ftrace: Enable trampoline when rec count returns back to one

Douglas Anderson <dianders@chromium.org>
    ARM: dts: rockchip: Mark that the rk3288 timer might stop in suspend

Jerome Brunet <jbrunet@baylibre.com>
    clk: meson: mpll: properly handle spread spectrum

Douglas Anderson <dianders@chromium.org>
    ARM: dts: rockchip: Make rk3288-veyron-mickey's emmc work again

Douglas Anderson <dianders@chromium.org>
    ARM: dts: rockchip: Make rk3288-veyron-minnie run at hs200

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: riscpc: fix DMA


-------------

Diffstat:

 Makefile                                           |  7 +-
 arch/arm/boot/dts/rk3288-veyron-mickey.dts         |  4 --
 arch/arm/boot/dts/rk3288-veyron-minnie.dts         |  4 --
 arch/arm/boot/dts/rk3288.dtsi                      |  1 +
 arch/arm/mach-exynos/Kconfig                       |  6 +-
 arch/arm/mach-exynos/Makefile                      |  2 +-
 arch/arm/mach-exynos/suspend.c                     |  6 +-
 arch/arm/mach-rpc/dma.c                            |  5 +-
 arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi |  2 +
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi           |  2 +-
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |  1 +
 arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi  |  5 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  8 +--
 arch/arm64/include/asm/cpufeature.h                |  7 +-
 arch/arm64/kernel/cpufeature.c                     |  8 ++-
 arch/arm64/kernel/hw_breakpoint.c                  |  7 +-
 arch/mips/lantiq/irq.c                             |  5 +-
 arch/nds32/include/asm/syscall.h                   | 27 ++++---
 arch/parisc/Makefile                               |  3 +
 arch/parisc/boot/compressed/Makefile               |  4 +-
 arch/parisc/boot/compressed/vmlinux.lds.S          |  4 +-
 arch/powerpc/mm/kasan/kasan_init_32.c              |  7 +-
 arch/x86/boot/compressed/misc.c                    |  1 +
 arch/x86/boot/compressed/misc.h                    |  1 -
 arch/x86/entry/entry_64.S                          |  1 -
 arch/x86/include/asm/apic.h                        |  2 +-
 arch/x86/include/asm/kvm_host.h                    | 34 +++++----
 arch/x86/include/asm/paravirt.h                    |  1 +
 arch/x86/include/asm/traps.h                       |  2 +-
 arch/x86/kernel/apic/apic.c                        |  2 +-
 arch/x86/kernel/kvm.c                              |  1 +
 arch/x86/kvm/mmu.c                                 |  6 +-
 arch/x86/kvm/vmx/nested.c                          |  5 +-
 arch/x86/math-emu/fpu_emu.h                        |  2 +-
 arch/x86/math-emu/reg_constant.c                   |  2 +-
 arch/x86/xen/enlighten_pv.c                        |  2 +-
 arch/x86/xen/xen-asm_64.S                          |  1 -
 drivers/acpi/blacklist.c                           |  4 ++
 drivers/block/loop.c                               | 16 +++--
 drivers/block/nbd.c                                |  2 +-
 drivers/char/tpm/tpm-chip.c                        | 23 ++++--
 drivers/clk/mediatek/clk-mt8183.c                  | 46 ++++++++----
 drivers/clk/meson/clk-mpll.c                       |  9 ++-
 drivers/clk/meson/clk-mpll.h                       |  1 +
 drivers/clk/sprd/sc9860-clk.c                      |  5 +-
 drivers/clk/tegra/clk-tegra210.c                   |  8 +--
 drivers/crypto/ccp/psp-dev.c                       | 19 +++--
 drivers/dax/kmem.c                                 |  5 +-
 drivers/dma/sh/rcar-dmac.c                         |  2 +-
 drivers/dma/tegra20-apb-dma.c                      | 12 +++-
 drivers/firmware/psci/psci_checker.c               | 10 +--
 drivers/gpio/gpiolib.c                             | 23 +++---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  3 +
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |  1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c                   | 12 ++++
 drivers/gpu/drm/i915/i915_perf.c                   | 10 ++-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |  2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |  3 +-
 drivers/i2c/busses/i2c-at91-core.c                 |  2 +-
 drivers/i2c/busses/i2c-at91-master.c               |  9 +--
 drivers/i2c/busses/i2c-bcm-iproc.c                 | 10 +--
 drivers/infiniband/core/device.c                   | 54 ++++++++++----
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  7 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          | 13 ++--
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |  2 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           | 14 ++--
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |  7 +-
 drivers/infiniband/hw/hfi1/chip.c                  | 11 ++-
 drivers/infiniband/hw/hfi1/tid_rdma.c              | 43 +----------
 drivers/infiniband/hw/hfi1/verbs.c                 |  2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  1 +
 drivers/infiniband/hw/mlx5/mr.c                    | 23 +++---
 drivers/infiniband/hw/mlx5/qp.c                    | 13 ++--
 drivers/misc/eeprom/at24.c                         |  2 +-
 drivers/mmc/core/queue.c                           |  5 ++
 drivers/mmc/host/dw_mmc.c                          |  3 +-
 drivers/mmc/host/meson-mx-sdio.c                   |  2 +-
 drivers/mmc/host/sdhci-sprd.c                      |  1 +
 drivers/mtd/nand/raw/nand_micron.c                 | 14 +++-
 drivers/net/ethernet/emulex/benet/be_main.c        |  6 +-
 drivers/pci/of.c                                   |  8 +++
 drivers/perf/arm_pmu.c                             |  2 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  2 +
 drivers/remoteproc/remoteproc_core.c               |  1 +
 drivers/s390/block/dasd_alias.c                    | 22 ++++--
 drivers/s390/scsi/zfcp_erp.c                       |  7 ++
 drivers/scsi/mpt3sas/mpt3sas_base.c                | 12 ++--
 drivers/soc/imx/soc-imx8.c                         | 19 +++--
 drivers/soc/qcom/rpmpd.c                           |  2 +-
 drivers/virtio/virtio_mmio.c                       |  7 +-
 drivers/xen/gntdev.c                               |  2 +-
 drivers/xen/swiotlb-xen.c                          |  6 +-
 fs/adfs/super.c                                    |  5 +-
 fs/block_dev.c                                     | 83 +++++++++++++++-------
 fs/btrfs/ioctl.c                                   | 21 ++++++
 fs/btrfs/qgroup.c                                  | 24 ++++++-
 fs/btrfs/send.c                                    | 77 ++++----------------
 fs/btrfs/transaction.c                             | 10 +++
 fs/btrfs/tree-checker.c                            | 11 +++
 fs/btrfs/volumes.c                                 |  3 +-
 fs/ceph/dir.c                                      | 26 ++++---
 fs/ceph/super.h                                    |  7 +-
 fs/ceph/xattr.c                                    | 14 ++--
 fs/cifs/connect.c                                  | 24 ++++---
 fs/coda/psdev.c                                    |  5 +-
 fs/dax.c                                           |  2 +-
 fs/io_uring.c                                      |  3 +-
 include/linux/acpi.h                               |  5 +-
 include/linux/coda.h                               |  3 +-
 include/linux/coda_psdev.h                         | 11 +++
 include/linux/compiler-gcc.h                       |  2 +
 include/linux/compiler_types.h                     |  4 ++
 include/linux/fs.h                                 |  6 ++
 include/linux/gpio/consumer.h                      | 64 ++++++++---------
 include/linux/memory_hotplug.h                     |  8 ++-
 include/rdma/ib_verbs.h                            |  3 +
 include/uapi/linux/coda_psdev.h                    | 13 ----
 ipc/mqueue.c                                       | 19 ++---
 kernel/bpf/btf.c                                   | 19 +++--
 kernel/bpf/core.c                                  |  2 +-
 kernel/dma/direct.c                                | 18 +++--
 kernel/dma/swiotlb.c                               |  4 +-
 kernel/module.c                                    |  6 +-
 kernel/stacktrace.c                                |  5 ++
 kernel/trace/ftrace.c                              | 28 ++++----
 kernel/trace/trace_functions_graph.c               | 17 ++---
 lib/Makefile                                       |  3 +-
 lib/ioremap.c                                      |  9 +++
 lib/test_overflow.c                                | 11 +--
 lib/test_string.c                                  |  6 +-
 mm/cma.c                                           | 13 ++++
 mm/compaction.c                                    | 11 +--
 mm/memcontrol.c                                    | 22 ++++--
 mm/memory_hotplug.c                                | 64 +++++++++++------
 mm/migrate.c                                       | 21 +++---
 mm/slab_common.c                                   |  3 +-
 mm/vmscan.c                                        |  9 ++-
 mm/z3fold.c                                        | 15 +++-
 scripts/Makefile.modpost                           |  6 +-
 scripts/kconfig/confdata.c                         |  4 ++
 security/selinux/ss/policydb.c                     |  6 +-
 sound/hda/hdac_i915.c                              | 10 +--
 tools/perf/builtin-version.c                       |  1 +
 tools/testing/selftests/bpf/Makefile               | 13 ++--
 tools/testing/selftests/cgroup/cgroup_util.c       |  3 +-
 146 files changed, 961 insertions(+), 561 deletions(-)


