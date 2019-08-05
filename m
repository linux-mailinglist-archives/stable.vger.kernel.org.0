Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01FD81AD2
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbfHENJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729789AbfHENJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:09:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 265162067D;
        Mon,  5 Aug 2019 13:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010574;
        bh=R3PK63l1+400zO9oK1VK+86Gm7Ip0k7Av3dd8XKgd6A=;
        h=From:To:Cc:Subject:Date:From;
        b=aP2oVG3cQP5z+jsHiPAq+LV9pva+uZ6T2ODdJAp8eNcvUxhp2k7RhoSu/yE9UamsY
         ylW4AhEI8S7GsBbpVtcj73mg0R9GwhY3slGkg/r5CXv8FAc+wrRm3BsT41BGrBsYGA
         lK8C+f4esolbvex3KEjm6ynZ7hvYmZ1pyzYBGN8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/74] 4.19.65-stable review
Date:   Mon,  5 Aug 2019 15:02:13 +0200
Message-Id: <20190805124935.819068648@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.65-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.65-rc1
X-KernelTest-Deadline: 2019-08-07T12:49+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.65 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.65-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.65-rc1

Suganath Prabu <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Use 63-bit DMA addressing on SAS35 HBA

Andy Lutomirski <luto@kernel.org>
    x86/vdso: Prevent segfaults due to hoisted vclock reads

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-9: properly declare the {pv,hv}clock_page storage

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support GCC 9 cold subfunction naming scheme

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: enable uboot support unconditionally

Jean Delvare <jdelvare@suse.de>
    eeprom: at24: make spd world-readable again

Xiaolin Zhang <xiaolin.zhang@intel.com>
    drm/i915/gvt: fix incorrect cache entry for guest page mapping

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

Juergen Gross <jgross@suse.com>
    xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()

Munehisa Kamata <kamatam@amazon.com>
    nbd: replace kill_bdev() with __invalidate_device() again

Will Deacon <will@kernel.org>
    arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}

Will Deacon <will@kernel.org>
    arm64: compat: Allow single-byte watchpoints on all addresses

Will Deacon <will@kernel.org>
    drivers/perf: arm_pmu: Fix failure path in PM notifier

Helge Deller <deller@gmx.de>
    parisc: Fix build of compressed kernel even with debug enabled

Chris Down <chris@chrisdown.name>
    cgroup: kselftest: relax fs_spec checks

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix endless loop after read unit address configuration

Yang Shi <yang.shi@linux.alibaba.com>
    mm: vmscan: check if mem cgroup is disabled or not before calling memcg slab shrinker

Samuel Thibault <samuel.thibault@ens-lyon.org>
    ALSA: hda: Fix 1-minute detection delay when i915 module is not available

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix memory leak in policydb_init()

Marco Felsch <m.felsch@pengutronix.de>
    mtd: rawnand: micron: handle on-die "ECC-off" devices correctly

Gustavo A. R. Silva <gustavo@embeddedor.com>
    IB/hfi1: Fix Spectre v1 vulnerability

Michael Wu <michael.wu@vatics.com>
    gpiolib: fix incorrect IRQ requesting of an active-low lineevent

Joe Perches <joe@perches.com>
    mmc: meson-mx-sdio: Fix misuse of GENMASK macro

Douglas Anderson <dianders@chromium.org>
    mmc: dw_mmc: Fix occasional hang after tuning on eMMC

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race leading to fs corruption after transaction abort

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix incremental send failure after deduplication

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: initialize CLANG_FLAGS correctly in the top Makefile

M. Vefa Bicakci <m.v.b@runbox.com>
    kconfig: Clear "written" flag to avoid data loss

Yongxin Liu <yongxin.liu@windriver.com>
    drm/nouveau: fix memory leak in nouveau_conn_reset()

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    x86, boot: Remove multiple copy of static function sanitize_boot_params()

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/paravirt: Fix callee-saved function ELF sizes

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/kvm: Don't call kvm_spurious_fault() from .fixup

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    xen/pv: Fix a boot up hang revealed by int3 self test

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum_dcb: Configure DSCP map as the last rule is removed

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

Benjamin Poirier <bpoirier@suse.com>
    be2net: Signal that the device cannot transmit during reconfiguration

Arnd Bergmann <arnd@arndb.de>
    ACPI: fix false-positive -Wuninitialized warning

Arnd Bergmann <arnd@arndb.de>
    x86: kvm: avoid constant-conversion warning

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    perf version: Fix segfault due to missing OPT_END()

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: fix GCC compiler warning emitted with -Wmaybe-uninitialized

Arnd Bergmann <arnd@arndb.de>
    ACPI: blacklist: fix clang warning for unused DMI table

Jeff Layton <jlayton@kernel.org>
    ceph: return -ERANGE if virtual xattr value didn't fit in buffer

Andrea Parri <andrea.parri@amarulasolutions.com>
    ceph: fix improper use of smp_mb__before_atomic()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: Fix a race condition with cifs_echo_request

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: Don't hold qgroup_ioctl_lock in btrfs_qgroup_inherit()

David Sterba <dsterba@suse.com>
    btrfs: fix minimum number of chunk errors for DUP

Chunyan Zhang <zhang.chunyan@linaro.org>
    clk: sprd: Add check for return value of sprd_clk_regmap_init()

Russell King <rmk+kernel@armlinux.org.uk>
    fs/adfs: super: fix use-after-free bug

JC Kuo <jckuo@nvidia.com>
    clk: tegra210: fix PLLU and PLLU_OUT1

Geert Uytterhoeven <geert+renesas@glider.be>
    dmaengine: rcar-dmac: Reject zero-length slave DMA requests

Petr Cvek <petrcvekcz@gmail.com>
    MIPS: lantiq: Fix bitfield masking

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    firmware/psci: psci_checker: Park kthreads before stopping them

Prarit Bhargava <prarit@redhat.com>
    kernel/module.c: Only return -EEXIST for modules that have finished loading

Helen Koike <helen.koike@collabora.com>
    arm64: dts: rockchip: fix isp iommu clocks and power domain

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Error out if DMA_PREP_INTERRUPT flag is unset

Cheng Jian <cj.chengjian@huawei.com>
    ftrace: Enable trampoline when rec count returns back to one

Douglas Anderson <dianders@chromium.org>
    ARM: dts: rockchip: Mark that the rk3288 timer might stop in suspend

Douglas Anderson <dianders@chromium.org>
    ARM: dts: rockchip: Make rk3288-veyron-mickey's emmc work again

Douglas Anderson <dianders@chromium.org>
    ARM: dts: rockchip: Make rk3288-veyron-minnie run at hs200

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: riscpc: fix DMA


-------------

Diffstat:

 Makefile                                           |  7 +-
 arch/arc/Kconfig                                   | 13 ----
 arch/arc/configs/nps_defconfig                     |  1 -
 arch/arc/configs/vdk_hs38_defconfig                |  1 -
 arch/arc/configs/vdk_hs38_smp_defconfig            |  2 -
 arch/arc/kernel/head.S                             |  2 -
 arch/arc/kernel/setup.c                            |  2 -
 arch/arm/boot/dts/rk3288-veyron-mickey.dts         |  4 --
 arch/arm/boot/dts/rk3288-veyron-minnie.dts         |  4 --
 arch/arm/boot/dts/rk3288.dtsi                      |  1 +
 arch/arm/mach-rpc/dma.c                            |  5 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  8 +--
 arch/arm64/include/asm/cpufeature.h                |  7 +-
 arch/arm64/kernel/cpufeature.c                     |  8 ++-
 arch/arm64/kernel/hw_breakpoint.c                  |  7 +-
 arch/mips/lantiq/irq.c                             |  5 +-
 arch/parisc/boot/compressed/vmlinux.lds.S          |  4 +-
 arch/x86/boot/compressed/misc.c                    |  1 +
 arch/x86/boot/compressed/misc.h                    |  1 -
 arch/x86/entry/entry_64.S                          |  1 -
 arch/x86/entry/vdso/vclock_gettime.c               | 19 ++++--
 arch/x86/include/asm/apic.h                        |  2 +-
 arch/x86/include/asm/kvm_host.h                    | 34 +++++-----
 arch/x86/include/asm/paravirt.h                    |  1 +
 arch/x86/include/asm/traps.h                       |  2 +-
 arch/x86/kernel/apic/apic.c                        |  2 +-
 arch/x86/kernel/kvm.c                              |  1 +
 arch/x86/kvm/mmu.c                                 |  6 +-
 arch/x86/math-emu/fpu_emu.h                        |  2 +-
 arch/x86/math-emu/reg_constant.c                   |  2 +-
 arch/x86/xen/enlighten_pv.c                        |  2 +-
 arch/x86/xen/xen-asm_64.S                          |  1 -
 drivers/acpi/blacklist.c                           |  4 ++
 drivers/block/nbd.c                                |  2 +-
 drivers/clk/sprd/sc9860-clk.c                      |  5 +-
 drivers/clk/tegra/clk-tegra210.c                   |  8 +--
 drivers/dma/sh/rcar-dmac.c                         |  2 +-
 drivers/dma/tegra20-apb-dma.c                      | 12 +++-
 drivers/firmware/psci_checker.c                    | 10 +--
 drivers/gpio/gpiolib.c                             |  6 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c                   | 12 ++++
 drivers/gpu/drm/nouveau/nouveau_connector.c        |  2 +-
 drivers/infiniband/hw/hfi1/chip.c                  | 11 +++-
 drivers/infiniband/hw/hfi1/verbs.c                 |  2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  1 +
 drivers/infiniband/hw/mlx5/mr.c                    | 23 ++++---
 drivers/infiniband/hw/mlx5/qp.c                    | 13 ++--
 drivers/misc/eeprom/at24.c                         |  2 +-
 drivers/mmc/host/dw_mmc.c                          |  3 +-
 drivers/mmc/host/meson-mx-sdio.c                   |  2 +-
 drivers/mtd/nand/raw/nand_micron.c                 | 14 +++-
 drivers/net/ethernet/emulex/benet/be_main.c        |  6 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c | 16 ++---
 drivers/perf/arm_pmu.c                             |  2 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  2 +
 drivers/s390/block/dasd_alias.c                    | 22 +++++--
 drivers/s390/scsi/zfcp_erp.c                       |  7 ++
 drivers/scsi/mpt3sas/mpt3sas_base.c                | 12 ++--
 drivers/xen/swiotlb-xen.c                          |  4 +-
 fs/adfs/super.c                                    |  5 +-
 fs/btrfs/qgroup.c                                  | 24 ++++++-
 fs/btrfs/send.c                                    | 77 +++++-----------------
 fs/btrfs/transaction.c                             | 10 +++
 fs/btrfs/volumes.c                                 |  3 +-
 fs/ceph/super.h                                    |  7 +-
 fs/ceph/xattr.c                                    | 14 ++--
 fs/cifs/connect.c                                  |  8 +--
 fs/coda/psdev.c                                    |  5 +-
 include/linux/acpi.h                               |  5 +-
 include/linux/coda.h                               |  3 +-
 include/linux/coda_psdev.h                         | 11 ++++
 include/uapi/linux/coda_psdev.h                    | 13 ----
 ipc/mqueue.c                                       | 19 +++---
 kernel/module.c                                    |  6 +-
 kernel/trace/ftrace.c                              | 28 ++++----
 lib/test_overflow.c                                | 11 ++--
 lib/test_string.c                                  |  6 +-
 mm/cma.c                                           | 13 ++++
 mm/vmscan.c                                        |  9 ++-
 scripts/kconfig/confdata.c                         |  4 ++
 security/selinux/ss/policydb.c                     |  6 +-
 sound/hda/hdac_i915.c                              | 10 +--
 tools/objtool/elf.c                                |  2 +-
 tools/perf/builtin-version.c                       |  1 +
 tools/testing/selftests/cgroup/cgroup_util.c       |  3 +-
 85 files changed, 385 insertions(+), 281 deletions(-)


