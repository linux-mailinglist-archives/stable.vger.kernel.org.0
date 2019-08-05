Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1460C81B6B
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbfHENID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729928AbfHENIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:08:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CFEF2087B;
        Mon,  5 Aug 2019 13:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010481;
        bh=Lr7rPp8Gjkw7OFAvNlfSbxgPDih3ANUh4/AP3k4Put8=;
        h=From:To:Cc:Subject:Date:From;
        b=JOgiunHiAL4Pr/vGrlbM4gYJ0V2PanVMNSUv/3UaUmXLPy2M4KghU+1BvHGzcv6o1
         KI5jqgU/EK1k6kNS3nYrVASe+2zWDJDxBKJnH8Vq2fubg2+j+iK+Oiqys1Ab4uiBN4
         K+GU6KolIcroiUCBpFATi108Vk6mAsrogJBfj+MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/53] 4.14.137-stable review
Date:   Mon,  5 Aug 2019 15:02:25 +0200
Message-Id: <20190805124927.973499541@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.137-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.137-rc1
X-KernelTest-Deadline: 2019-08-07T12:49+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.137 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.137-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.137-rc1

Andy Lutomirski <luto@kernel.org>
    x86/vdso: Prevent segfaults due to hoisted vclock reads

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-9: properly declare the {pv,hv}clock_page storage

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support GCC 9 cold subfunction naming scheme

Jean Delvare <jdelvare@suse.de>
    eeprom: at24: make spd world-readable again

John Fleck <john.fleck@intel.com>
    IB/hfi1: Check for error on call to alloc_rsm_map_table

Yishai Hadas <yishaih@mellanox.com>
    IB/mlx5: Fix RSS Toeplitz setup to be aligned with the HW specification

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
    drivers/perf: arm_pmu: Fix failure path in PM notifier

Helge Deller <deller@gmx.de>
    parisc: Fix build of compressed kernel even with debug enabled

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix endless loop after read unit address configuration

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix memory leak in policydb_init()

Gustavo A. R. Silva <gustavo@embeddedor.com>
    IB/hfi1: Fix Spectre v1 vulnerability

Michael Wu <michael.wu@vatics.com>
    gpiolib: fix incorrect IRQ requesting of an active-low lineevent

Douglas Anderson <dianders@chromium.org>
    mmc: dw_mmc: Fix occasional hang after tuning on eMMC

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race leading to fs corruption after transaction abort

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix incremental send failure after deduplication

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: initialize CLANG_FLAGS correctly in the top Makefile

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

David Sterba <dsterba@suse.com>
    btrfs: fix minimum number of chunk errors for DUP

Russell King <rmk+kernel@armlinux.org.uk>
    fs/adfs: super: fix use-after-free bug

JC Kuo <jckuo@nvidia.com>
    clk: tegra210: fix PLLU and PLLU_OUT1

Geert Uytterhoeven <geert+renesas@glider.be>
    dmaengine: rcar-dmac: Reject zero-length slave DMA requests

Petr Cvek <petrcvekcz@gmail.com>
    MIPS: lantiq: Fix bitfield masking

Prarit Bhargava <prarit@redhat.com>
    kernel/module.c: Only return -EEXIST for modules that have finished loading

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

 Makefile                                    |  7 +--
 arch/arm/boot/dts/rk3288-veyron-mickey.dts  |  4 --
 arch/arm/boot/dts/rk3288-veyron-minnie.dts  |  4 --
 arch/arm/boot/dts/rk3288.dtsi               |  1 +
 arch/arm/mach-rpc/dma.c                     |  5 +-
 arch/mips/lantiq/irq.c                      |  5 +-
 arch/parisc/boot/compressed/vmlinux.lds.S   |  4 +-
 arch/x86/boot/compressed/misc.c             |  1 +
 arch/x86/boot/compressed/misc.h             |  1 -
 arch/x86/entry/entry_64.S                   |  1 -
 arch/x86/entry/vdso/vclock_gettime.c        | 19 +++++--
 arch/x86/include/asm/apic.h                 |  2 +-
 arch/x86/include/asm/kvm_host.h             | 34 +++++++------
 arch/x86/include/asm/paravirt.h             |  1 +
 arch/x86/include/asm/traps.h                |  2 +-
 arch/x86/kernel/apic/apic.c                 |  2 +-
 arch/x86/kernel/kvm.c                       |  1 +
 arch/x86/kvm/mmu.c                          |  6 +--
 arch/x86/math-emu/fpu_emu.h                 |  2 +-
 arch/x86/math-emu/reg_constant.c            |  2 +-
 arch/x86/xen/enlighten_pv.c                 |  2 +-
 arch/x86/xen/xen-asm_64.S                   |  1 -
 drivers/acpi/blacklist.c                    |  4 ++
 drivers/block/nbd.c                         |  2 +-
 drivers/clk/tegra/clk-tegra210.c            |  8 +--
 drivers/dma/sh/rcar-dmac.c                  |  2 +-
 drivers/gpio/gpiolib.c                      |  6 ++-
 drivers/gpu/drm/nouveau/nouveau_connector.c |  2 +-
 drivers/infiniband/hw/hfi1/chip.c           | 11 ++++-
 drivers/infiniband/hw/hfi1/verbs.c          |  2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h        |  1 +
 drivers/infiniband/hw/mlx5/mr.c             | 17 ++++---
 drivers/infiniband/hw/mlx5/qp.c             | 13 +++--
 drivers/misc/eeprom/at24.c                  |  2 +-
 drivers/mmc/host/dw_mmc.c                   |  3 +-
 drivers/net/ethernet/emulex/benet/be_main.c |  6 ++-
 drivers/perf/arm_pmu.c                      |  2 +-
 drivers/rapidio/devices/rio_mport_cdev.c    |  2 +
 drivers/s390/block/dasd_alias.c             | 22 ++++++---
 drivers/s390/scsi/zfcp_erp.c                |  7 +++
 drivers/xen/swiotlb-xen.c                   |  4 +-
 fs/adfs/super.c                             |  5 +-
 fs/btrfs/send.c                             | 77 ++++++-----------------------
 fs/btrfs/transaction.c                      | 10 ++++
 fs/btrfs/volumes.c                          |  3 +-
 fs/ceph/super.h                             |  7 ++-
 fs/ceph/xattr.c                             | 14 +++---
 fs/cifs/connect.c                           |  8 +--
 fs/coda/psdev.c                             |  5 +-
 include/linux/acpi.h                        |  5 +-
 include/linux/coda.h                        |  3 +-
 include/linux/coda_psdev.h                  | 11 +++++
 include/uapi/linux/coda_psdev.h             | 13 -----
 ipc/mqueue.c                                | 19 +++----
 kernel/module.c                             |  6 +--
 kernel/trace/ftrace.c                       | 28 ++++++-----
 mm/cma.c                                    | 13 +++++
 security/selinux/ss/policydb.c              |  6 ++-
 tools/objtool/elf.c                         |  2 +-
 59 files changed, 254 insertions(+), 204 deletions(-)


