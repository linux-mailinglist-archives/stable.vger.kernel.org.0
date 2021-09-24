Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE2F417385
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344779AbhIXM5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344810AbhIXMzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E9C661351;
        Fri, 24 Sep 2021 12:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487864;
        bh=x09bA/RdVHB8WdDYaiGd7H1inQyVRPDkCENondkoyVo=;
        h=From:To:Cc:Subject:Date:From;
        b=QTn0mQUm0P8cBUZQp9nlt/h78JZ+Pa1gVE0fQHtH4M999Pk3LXjZSfHVZIefsq8YJ
         zZXqxujyfB0UEWixoiltJmHY5POX1AI22VukzapovHgI5+b+JacVBklhxQFsI7NXue
         bDehpSUMqo77KMKVW1xlWH7bNrV7w3s91zFzFNow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/50] 5.4.149-rc1 review
Date:   Fri, 24 Sep 2021 14:43:49 +0200
Message-Id: <20210924124332.229289734@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.149-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.149-rc1
X-KernelTest-Deadline: 2021-09-26T12:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.149 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.149-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.149-rc1

Guenter Roeck <linux@roeck-us.net>
    drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV

Yu-Tung Chang <mtwget@gmail.com>
    rtc: rx8010: select REGMAP_I2C

Li Jinlin <lijinlin3@huawei.com>
    blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: stm32-lp: Don't modify HW state in .remove() callback

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: rockchip: Don't modify HW state in .remove() callback

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: img: Don't modify HW state in .remove() callback

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix NULL pointer in nilfs_##name##_attr_release

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix memory leak in nilfs_sysfs_create_device_group

Anand Jain <anand.jain@oracle.com>
    btrfs: fix lockdep warning while mounting sprout fs

Jeff Layton <jlayton@kernel.org>
    ceph: lockdep annotations for try_nonblocking_invalidate

Jeff Layton <jlayton@kernel.org>
    ceph: request Fw caps before updating the mtime in ceph_write_iter

Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
    dmaengine: xilinx_dma: Set DMA mask for coherent APIs

Johannes Berg <johannes.berg@intel.com>
    dmaengine: ioat: depends on !UML

Zou Wei <zou_wei@huawei.com>
    dmaengine: sprd: Add missing MODULE_DEVICE_TABLE

Guenter Roeck <linux@roeck-us.net>
    parisc: Move pci_dev_is_behind_card_dino to where it is used

Thomas Gleixner <tglx@linutronix.de>
    drivers: base: cacheinfo: Get rid of DEFINE_SMP_CALL_CACHE_FUNCTION()

Arnd Bergmann <arnd@arndb.de>
    thermal/core: Fix thermal_cooling_device_register() prototype

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Jongsung Kim <neidhard.kim@lge.com>
    net: stmmac: reset Tx desc base address before restarting Tx

Petr Oros <poros@redhat.com>
    phy: avoid unnecessary link-up delay in polling mode

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: mxs: Don't modify HW state in .probe() after the PWM chip was registered

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc32xx: Don't modify HW state in .probe() after the PWM chip was registered

Pavel Skripkin <paskripkin@gmail.com>
    profiling: fix shift-out-of-bounds bugs

Zhen Lei <thunder.leizhen@huawei.com>
    nilfs2: use refcount_dec_and_lock() to fix potential UAF

Cyrill Gorcunov <gorcunov@gmail.com>
    prctl: allow to setup brk for et_dyn executables

Xie Yongji <xieyongji@bytedance.com>
    9p/trans_virtio: Remove sysfs file on probe failure

Dan Carpenter <dan.carpenter@oracle.com>
    thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: acpi: Avoid comparison GSI with Linux vIRQ

Johannes Berg <johannes.berg@intel.com>
    um: virtio_uml: fix memory leak on init failures

Nathan Chancellor <nathan@kernel.org>
    staging: rtl8192u: Fix bitwise vs logical operator in TranslateRxSignalStuff819xUsb()

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: add param size validation for SCTP_PARAM_SET_PRIMARY

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: validate chunk size in __rcv_asconf_lookup

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9079/1: ftrace: Add MODULE_PLTS support

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9077/1: PLT: Move struct plt_entries definition to header

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    apparmor: remove duplicate macro list_entry_is_head()

Florian Fainelli <f.fainelli@gmail.com>
    ARM: Qualify enabling of swiotlb_init()

David Hildenbrand <david@redhat.com>
    s390/pci_mmio: fully validate the VMA before calling follow_pte()

nick black <dankamongmen@gmail.com>
    console: consume APC, DM, DCS

Radim Krčmář <rkrcmar@redhat.com>
    KVM: remember position in kvm->vcpus array

Tuan Phan <tuanphan@os.amperecomputing.com>
    PCI/ACPI: Add Ampere Altra SOC MCFG quirk

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reporting CRS value

Pali Rohár <pali@kernel.org>
    PCI: pci-bridge-emul: Add PCIe Root Capabilities Register

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Indicate error in 'val' when config read fails

Grzegorz Jaszczyk <jaz@semihalf.com>
    PCI: pci-bridge-emul: Fix big-endian support


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/arm/include/asm/ftrace.h                     |  3 +
 arch/arm/include/asm/insn.h                       |  8 +--
 arch/arm/include/asm/module.h                     | 10 +++
 arch/arm/kernel/ftrace.c                          | 46 ++++++++++---
 arch/arm/kernel/insn.c                            | 19 +++---
 arch/arm/kernel/module-plts.c                     | 49 ++++++++++----
 arch/arm/mm/init.c                                |  6 +-
 arch/arm64/kernel/cacheinfo.c                     |  7 +-
 arch/mips/kernel/cacheinfo.c                      |  7 +-
 arch/riscv/kernel/cacheinfo.c                     |  7 +-
 arch/s390/pci/pci_mmio.c                          |  2 +-
 arch/um/drivers/virtio_uml.c                      |  4 +-
 arch/x86/kernel/cpu/cacheinfo.c                   |  7 +-
 block/blk-throttle.c                              |  1 +
 drivers/acpi/pci_mcfg.c                           | 20 ++++++
 drivers/dma/Kconfig                               |  2 +-
 drivers/dma/acpi-dma.c                            | 10 ++-
 drivers/dma/sprd-dma.c                            |  1 +
 drivers/dma/xilinx/xilinx_dma.c                   |  2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +
 drivers/net/phy/phy-c45.c                         |  5 +-
 drivers/net/phy/phy_device.c                      |  5 +-
 drivers/parisc/dino.c                             | 18 +++---
 drivers/pci/controller/pci-aardvark.c             | 71 +++++++++++++++++++--
 drivers/pci/ecam.c                                | 10 +++
 drivers/pci/pci-bridge-emul.c                     | 25 ++++----
 drivers/pci/pci-bridge-emul.h                     | 78 +++++++++++------------
 drivers/pwm/pwm-img.c                             | 16 -----
 drivers/pwm/pwm-lpc32xx.c                         | 10 +--
 drivers/pwm/pwm-mxs.c                             | 13 ++--
 drivers/pwm/pwm-rockchip.c                        | 14 ----
 drivers/pwm/pwm-stm32-lp.c                        |  2 -
 drivers/rtc/Kconfig                               |  1 +
 drivers/staging/rtl8192u/r8192U_core.c            |  2 +-
 drivers/thermal/samsung/exynos_tmu.c              |  1 +
 drivers/tty/vt/vt.c                               | 31 +++++++--
 fs/btrfs/volumes.c                                |  7 +-
 fs/ceph/caps.c                                    |  2 +
 fs/ceph/file.c                                    | 32 +++++-----
 fs/nilfs2/sysfs.c                                 | 26 ++++----
 fs/nilfs2/the_nilfs.c                             |  9 ++-
 include/linux/cacheinfo.h                         | 18 ------
 include/linux/kvm_host.h                          | 11 +---
 include/linux/pci-ecam.h                          |  1 +
 include/linux/thermal.h                           |  5 +-
 kernel/profile.c                                  | 21 +++---
 kernel/sys.c                                      |  7 --
 lib/Kconfig.debug                                 |  1 -
 net/9p/trans_virtio.c                             |  4 +-
 net/sctp/input.c                                  |  3 +
 net/sctp/sm_make_chunk.c                          | 13 +++-
 security/apparmor/apparmorfs.c                    |  3 -
 virt/kvm/kvm_main.c                               |  5 +-
 55 files changed, 414 insertions(+), 275 deletions(-)


