Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5E481A5E
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfHENFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:05:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729274AbfHENFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:05:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8775206C1;
        Mon,  5 Aug 2019 13:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010320;
        bh=1KhugDbYUY1S51uwi69yCtGXNjuJxQjnkDZDsrv/bog=;
        h=From:To:Cc:Subject:Date:From;
        b=AaSLtXmPuBM6yfIsa5l5YBVwdtQFIfo1GVFN0hTNBdBRY4KlLILp65RtIN18tX6XO
         AUbRTePlNny/RtRl6gvKHErL4HrdnP9d+13LW0X5qBGCvYJing2T8W0ZDNPgr3oB7v
         ubOToXLVW+z3rCU09xUTZl3Xgpp0S8hGghQSEL20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/42] 4.9.188-stable review
Date:   Mon,  5 Aug 2019 15:02:26 +0200
Message-Id: <20190805124924.788666484@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.188-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.188-rc1
X-KernelTest-Deadline: 2019-08-07T12:49+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.188 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.188-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.188-rc1

Vlastimil Babka <vbabka@suse.cz>
    x86, mm, gup: prevent get_page() race with munmap in paravirt guest

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support GCC 9 cold subfunction naming scheme

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
    include/linux/module.h: copy __init/__exit attrs to init/cleanup_module

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
    Backport minimal compiler_attributes.h to support GCC 9

Jean Delvare <jdelvare@suse.de>
    eeprom: at24: make spd world-readable again

Andrea Arcangeli <aarcange@redhat.com>
    coredump: fix race condition between collapse_huge_page() and core dumping

Ajay Kaher <akaher@vmware.com>
    infiniband: fix race condition between infiniband mlx4, mlx5 driver and core dumping

Andrea Arcangeli <aarcange@redhat.com>
    coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping

Yishai Hadas <yishaih@mellanox.com>
    IB/mlx5: Fix RSS Toeplitz setup to be aligned with the HW specification

Juergen Gross <jgross@suse.com>
    xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()

Will Deacon <will@kernel.org>
    drivers/perf: arm_pmu: Fix failure path in PM notifier

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix endless loop after read unit address configuration

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix memory leak in policydb_init()

Michael Wu <michael.wu@vatics.com>
    gpiolib: fix incorrect IRQ requesting of an active-low lineevent

Douglas Anderson <dianders@chromium.org>
    mmc: dw_mmc: Fix occasional hang after tuning on eMMC

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix incremental send failure after deduplication

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: initialize CLANG_FLAGS correctly in the top Makefile

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    x86, boot: Remove multiple copy of static function sanitize_boot_params()

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/kvm: Don't call kvm_spurious_fault() from .fixup

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

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: fix GCC compiler warning emitted with -Wmaybe-uninitialized

Jeff Layton <jlayton@kernel.org>
    ceph: return -ERANGE if virtual xattr value didn't fit in buffer

Andrea Parri <andrea.parri@amarulasolutions.com>
    ceph: fix improper use of smp_mb__before_atomic()

David Sterba <dsterba@suse.com>
    btrfs: fix minimum number of chunk errors for DUP

Russell King <rmk+kernel@armlinux.org.uk>
    fs/adfs: super: fix use-after-free bug

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
 arch/x86/boot/compressed/misc.c             |  1 +
 arch/x86/boot/compressed/misc.h             |  1 -
 arch/x86/include/asm/apic.h                 |  2 +-
 arch/x86/include/asm/kvm_host.h             | 34 +++++++------
 arch/x86/kernel/apic/apic.c                 |  2 +-
 arch/x86/math-emu/fpu_emu.h                 |  2 +-
 arch/x86/math-emu/reg_constant.c            |  2 +-
 arch/x86/mm/gup.c                           | 32 +++++++++++-
 drivers/android/binder.c                    |  6 +++
 drivers/dma/sh/rcar-dmac.c                  |  2 +-
 drivers/gpio/gpiolib.c                      |  6 ++-
 drivers/infiniband/hw/mlx4/main.c           |  4 +-
 drivers/infiniband/hw/mlx5/main.c           |  3 ++
 drivers/infiniband/hw/mlx5/qp.c             |  1 -
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
 fs/btrfs/volumes.c                          |  3 +-
 fs/ceph/super.h                             |  7 ++-
 fs/ceph/xattr.c                             | 14 +++---
 fs/coda/psdev.c                             |  5 +-
 fs/proc/task_mmu.c                          | 18 +++++++
 fs/userfaultfd.c                            |  9 ++++
 include/linux/acpi.h                        |  5 +-
 include/linux/coda.h                        |  3 +-
 include/linux/coda_psdev.h                  | 11 +++++
 include/linux/compiler.h                    | 16 ++++++
 include/linux/mm.h                          | 24 +++++++++
 include/linux/module.h                      |  4 +-
 include/uapi/linux/coda_psdev.h             | 13 -----
 ipc/mqueue.c                                | 19 +++----
 kernel/module.c                             |  6 +--
 kernel/trace/ftrace.c                       | 28 ++++++-----
 mm/cma.c                                    | 13 +++++
 mm/khugepaged.c                             |  3 ++
 mm/mmap.c                                   |  6 ++-
 security/selinux/ss/policydb.c              |  6 ++-
 tools/objtool/elf.c                         |  2 +-
 51 files changed, 294 insertions(+), 175 deletions(-)


