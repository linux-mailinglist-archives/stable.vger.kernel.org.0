Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120B24188D1
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhIZMwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231555AbhIZMvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:51:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB2E661041;
        Sun, 26 Sep 2021 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632660615;
        bh=0/KkYYgij780OKpzYPMRrqjWzTk1qB9g56pbFDh/yF4=;
        h=From:To:Cc:Subject:Date:From;
        b=zIwYA0CdKkVlSRj5O4CcrBg/NrgeGJmjqEDmF/Pi4PIEiLVQeJHP8lnGX0OPGdRIW
         6yuHlFa5RjOlrirIlpYUQDcPzczE4ovPt/tsCixrQU2dMmua8aHyGdfyxR5aorA5rC
         yfxsET/+3rsQk9tSh4KQYxmJ5dg6NVdUP75yFJlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.69
Date:   Sun, 26 Sep 2021 14:50:00 +0200
Message-Id: <163266060020176@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.69 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/include/asm/ftrace.h                       |    3 
 arch/arm/include/asm/insn.h                         |    8 -
 arch/arm/include/asm/module.h                       |   10 ++
 arch/arm/kernel/ftrace.c                            |   46 ++++++++-
 arch/arm/kernel/insn.c                              |   19 ++--
 arch/arm/kernel/module-plts.c                       |   49 ++++++++--
 arch/arm/mm/init.c                                  |    6 +
 arch/arm64/kernel/cacheinfo.c                       |    7 -
 arch/mips/kernel/cacheinfo.c                        |    7 -
 arch/riscv/kernel/cacheinfo.c                       |    7 -
 arch/s390/pci/pci_mmio.c                            |    2 
 arch/um/drivers/virtio_uml.c                        |    4 
 arch/x86/kernel/cpu/cacheinfo.c                     |    7 -
 block/blk-mq.c                                      |   14 ++
 block/blk-throttle.c                                |    1 
 drivers/base/power/main.c                           |    2 
 drivers/dma-buf/Kconfig                             |    1 
 drivers/dma/Kconfig                                 |    4 
 drivers/dma/acpi-dma.c                              |   10 +-
 drivers/dma/idxd/submit.c                           |    2 
 drivers/dma/sprd-dma.c                              |    1 
 drivers/dma/xilinx/xilinx_dma.c                     |    2 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c |   17 +++
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c   |    2 
 drivers/iommu/amd/init.c                            |   31 +++++-
 drivers/misc/habanalabs/gaudi/gaudi.c               |    6 +
 drivers/misc/habanalabs/goya/goya.c                 |    6 +
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c   |   51 ----------
 drivers/parisc/dino.c                               |   18 +--
 drivers/pci/controller/pci-aardvark.c               |   67 +++++++++++++-
 drivers/pci/pci-bridge-emul.h                       |    2 
 drivers/platform/chrome/Makefile                    |    2 
 drivers/platform/chrome/cros_ec_sensorhub_ring.c    |   14 ++
 drivers/platform/chrome/cros_ec_trace.h             |   94 ++++++++++++++++++++
 drivers/pwm/pwm-img.c                               |   16 ---
 drivers/pwm/pwm-lpc32xx.c                           |   10 +-
 drivers/pwm/pwm-mxs.c                               |   13 +-
 drivers/pwm/pwm-rockchip.c                          |   14 --
 drivers/pwm/pwm-stm32-lp.c                          |    2 
 drivers/rtc/Kconfig                                 |    1 
 drivers/staging/rtl8192u/r8192U_core.c              |    2 
 drivers/thermal/samsung/exynos_tmu.c                |    1 
 drivers/tty/vt/vt.c                                 |   31 +++++-
 fs/btrfs/volumes.c                                  |   25 ++---
 fs/ceph/caps.c                                      |   70 +++++++++++---
 fs/ceph/dir.c                                       |    3 
 fs/ceph/file.c                                      |   32 +++---
 fs/ceph/inode.c                                     |    6 -
 fs/ceph/mds_client.c                                |   38 +++++++-
 fs/ceph/metric.c                                    |    7 -
 fs/ceph/super.h                                     |    6 +
 fs/coredump.c                                       |    4 
 fs/nilfs2/sysfs.c                                   |   26 ++---
 fs/nilfs2/the_nilfs.c                               |    9 -
 include/linux/cacheinfo.h                           |   18 ---
 include/linux/thermal.h                             |    5 -
 kernel/profile.c                                    |   21 ++--
 kernel/sched/idle.c                                 |    4 
 kernel/sys.c                                        |    7 -
 lib/Kconfig.debug                                   |    1 
 net/9p/trans_virtio.c                               |    4 
 net/sctp/input.c                                    |    3 
 net/sctp/sm_make_chunk.c                            |   13 ++
 tools/bootconfig/scripts/ftrace2bconf.sh            |    4 
 tools/include/linux/string.h                        |    1 
 tools/lib/string.c                                  |   58 ++++++++++++
 tools/perf/tests/bpf.c                              |    2 
 tools/perf/util/dso.c                               |   10 ++
 69 files changed, 676 insertions(+), 315 deletions(-)

Alex Sverdlin (4):
      ARM: 9077/1: PLT: Move struct plt_entries definition to header
      ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
      ARM: 9079/1: ftrace: Add MODULE_PLTS support
      ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE

Anand Jain (1):
      btrfs: fix lockdep warning while mounting sprout fs

Andy Shevchenko (1):
      dmaengine: acpi: Avoid comparison GSI with Linux vIRQ

Arnd Bergmann (1):
      thermal/core: Fix thermal_cooling_device_register() prototype

Cyrill Gorcunov (1):
      prctl: allow to setup brk for et_dyn executables

Dan Carpenter (1):
      thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()

Dave Jiang (1):
      dmaengine: idxd: fix wq slot allocation index check

David Hildenbrand (1):
      s390/pci_mmio: fully validate the VMA before calling follow_pte()

Florian Fainelli (1):
      ARM: Qualify enabling of swiotlb_init()

Geert Uytterhoeven (1):
      dma-buf: DMABUF_MOVE_NOTIFY should depend on DMA_SHARED_BUFFER

Greg Kroah-Hartman (2):
      Revert "net/mlx5: Register to devlink ingress VLAN filter trap"
      Linux 5.10.69

Guenter Roeck (2):
      parisc: Move pci_dev_is_behind_card_dino to where it is used
      drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV

Gwendal Grignou (2):
      platform/chrome: sensorhub: Add trace events for sample
      platform/chrome: cros_ec_trace: Fix format warnings

Jeff Layton (4):
      ceph: allow ceph_put_mds_session to take NULL or ERR_PTR
      ceph: cancel delayed work instead of flushing on mdsc teardown
      ceph: request Fw caps before updating the mtime in ceph_write_iter
      ceph: lockdep annotations for try_nonblocking_invalidate

Jiri Olsa (1):
      tools lib: Adopt memchr_inv() from kernel

Johannes Berg (3):
      um: virtio_uml: fix memory leak on init failures
      dmaengine: idxd: depends on !UML
      dmaengine: ioat: depends on !UML

Josef Bacik (1):
      btrfs: update the bdev time directly when closing

Koba Ko (1):
      drm/amdgpu: Disable PCIE_DPM on Intel RKL Platform

Li Jinlin (1):
      blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()

Lukas Bulwahn (1):
      Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Marcelo Ricardo Leitner (2):
      sctp: validate chunk size in __rcv_asconf_lookup
      sctp: add param size validation for SCTP_PARAM_SET_PRIMARY

Masami Hiramatsu (1):
      tools/bootconfig: Fix tracing_on option checking in ftrace2bconf.sh

Michael Petlan (1):
      perf test: Fix bpf test sample mismatch reporting

Namhyung Kim (1):
      perf tools: Allow build-id with trailing zeros

Nanyong Sun (6):
      nilfs2: fix memory leak in nilfs_sysfs_create_device_group
      nilfs2: fix NULL pointer in nilfs_##name##_attr_release
      nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

Nathan Chancellor (1):
      staging: rtl8192u: Fix bitwise vs logical operator in TranslateRxSignalStuff819xUsb()

Ofir Bitton (1):
      habanalabs: add validity check for event ID received from F/W

Pali Rohár (2):
      PCI: pci-bridge-emul: Add PCIe Root Capabilities Register
      PCI: aardvark: Fix reporting CRS value

Pavel Skripkin (1):
      profiling: fix shift-out-of-bounds bugs

Prasad Sodagudi (1):
      PM: sleep: core: Avoid setting power.must_resume to false

QiuXi (1):
      coredump: fix memleak in dump_vma_snapshot()

Radhey Shyam Pandey (1):
      dmaengine: xilinx_dma: Set DMA mask for coherent APIs

Sebastian Andrzej Siewior (1):
      sched/idle: Make the idle timer expire in hard interrupt context

Song Liu (1):
      blk-mq: allow 4x BLK_MAX_REQUEST_COUNT at blk_plug for multiple_queues

Thomas Gleixner (1):
      drivers: base: cacheinfo: Get rid of DEFINE_SMP_CALL_CACHE_FUNCTION()

Uwe Kleine-König (5):
      pwm: lpc32xx: Don't modify HW state in .probe() after the PWM chip was registered
      pwm: mxs: Don't modify HW state in .probe() after the PWM chip was registered
      pwm: img: Don't modify HW state in .remove() callback
      pwm: rockchip: Don't modify HW state in .remove() callback
      pwm: stm32-lp: Don't modify HW state in .remove() callback

Wei Huang (1):
      iommu/amd: Relocate GAMSup check to early_enable_iommus

Xie Yongji (1):
      9p/trans_virtio: Remove sysfs file on probe failure

Xiubo Li (1):
      ceph: remove the capsnaps when removing caps

Yu-Tung Chang (1):
      rtc: rx8010: select REGMAP_I2C

Zhen Lei (1):
      nilfs2: use refcount_dec_and_lock() to fix potential UAF

Zou Wei (1):
      dmaengine: sprd: Add missing MODULE_DEVICE_TABLE

nick black (1):
      console: consume APC, DM, DCS

