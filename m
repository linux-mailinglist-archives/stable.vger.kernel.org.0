Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D6B4174D2
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346437AbhIXNLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346169AbhIXNJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:09:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 420B2613A2;
        Fri, 24 Sep 2021 12:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488248;
        bh=jhbbhH6rYNXIM1psOOupG1Rxl7JbWKz0YDItJ8BGOH4=;
        h=From:To:Cc:Subject:Date:From;
        b=Sx21hG3Xqa9e19hhgnFuQofVyk+C+pZc2lSwFmJ9QyLJgyC14a3tWLf+kRxfz+3lM
         1mvzuu46ExgoNdBQ1sUPpFaN0+d5AaNw024f6uDLL4sauN8Ymv70OLq7Xs8DYO2tDD
         yN1+XI+DDcIuNbyyHE6uPQoytkRqvZII2MYzWSgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/63] 5.10.69-rc1 review
Date:   Fri, 24 Sep 2021 14:44:00 +0200
Message-Id: <20210924124334.228235870@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.69-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.69-rc1
X-KernelTest-Deadline: 2021-09-26T12:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.69 release.
There are 63 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.69-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.69-rc1

Guenter Roeck <linux@roeck-us.net>
    drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    sched/idle: Make the idle timer expire in hard interrupt context

Yu-Tung Chang <mtwget@gmail.com>
    rtc: rx8010: select REGMAP_I2C

Song Liu <songliubraving@fb.com>
    blk-mq: allow 4x BLK_MAX_REQUEST_COUNT at blk_plug for multiple_queues

Li Jinlin <lijinlin3@huawei.com>
    blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: stm32-lp: Don't modify HW state in .remove() callback

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: rockchip: Don't modify HW state in .remove() callback

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: img: Don't modify HW state in .remove() callback

Ofir Bitton <obitton@habana.ai>
    habanalabs: add validity check for event ID received from F/W

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

Josef Bacik <josef@toxicpanda.com>
    btrfs: update the bdev time directly when closing

Jeff Layton <jlayton@kernel.org>
    ceph: lockdep annotations for try_nonblocking_invalidate

Xiubo Li <xiubli@redhat.com>
    ceph: remove the capsnaps when removing caps

Jeff Layton <jlayton@kernel.org>
    ceph: request Fw caps before updating the mtime in ceph_write_iter

Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
    dmaengine: xilinx_dma: Set DMA mask for coherent APIs

Johannes Berg <johannes.berg@intel.com>
    dmaengine: ioat: depends on !UML

Zou Wei <zou_wei@huawei.com>
    dmaengine: sprd: Add missing MODULE_DEVICE_TABLE

Johannes Berg <johannes.berg@intel.com>
    dmaengine: idxd: depends on !UML

Wei Huang <wei.huang2@amd.com>
    iommu/amd: Relocate GAMSup check to early_enable_iommus

Guenter Roeck <linux@roeck-us.net>
    parisc: Move pci_dev_is_behind_card_dino to where it is used

Geert Uytterhoeven <geert@linux-m68k.org>
    dma-buf: DMABUF_MOVE_NOTIFY should depend on DMA_SHARED_BUFFER

Thomas Gleixner <tglx@linutronix.de>
    drivers: base: cacheinfo: Get rid of DEFINE_SMP_CALL_CACHE_FUNCTION()

Koba Ko <koba.ko@canonical.com>
    drm/amdgpu: Disable PCIE_DPM on Intel RKL Platform

Arnd Bergmann <arnd@arndb.de>
    thermal/core: Fix thermal_cooling_device_register() prototype

Masami Hiramatsu <mhiramat@kernel.org>
    tools/bootconfig: Fix tracing_on option checking in ftrace2bconf.sh

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Jeff Layton <jlayton@kernel.org>
    ceph: cancel delayed work instead of flushing on mdsc teardown

Jeff Layton <jlayton@kernel.org>
    ceph: allow ceph_put_mds_session to take NULL or ERR_PTR

Gwendal Grignou <gwendal@chromium.org>
    platform/chrome: cros_ec_trace: Fix format warnings

Gwendal Grignou <gwendal@chromium.org>
    platform/chrome: sensorhub: Add trace events for sample

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix wq slot allocation index check

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: mxs: Don't modify HW state in .probe() after the PWM chip was registered

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc32xx: Don't modify HW state in .probe() after the PWM chip was registered

Prasad Sodagudi <psodagud@codeaurora.org>
    PM: sleep: core: Avoid setting power.must_resume to false

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

Namhyung Kim <namhyung@kernel.org>
    perf tools: Allow build-id with trailing zeros

Michael Petlan <mpetlan@redhat.com>
    perf test: Fix bpf test sample mismatch reporting

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: acpi: Avoid comparison GSI with Linux vIRQ

Johannes Berg <johannes.berg@intel.com>
    um: virtio_uml: fix memory leak on init failures

QiuXi <qiuxi1@huawei.com>
    coredump: fix memleak in dump_vma_snapshot()

Nathan Chancellor <nathan@kernel.org>
    staging: rtl8192u: Fix bitwise vs logical operator in TranslateRxSignalStuff819xUsb()

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: add param size validation for SCTP_PARAM_SET_PRIMARY

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: validate chunk size in __rcv_asconf_lookup

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net/mlx5: Register to devlink ingress VLAN filter trap"

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9079/1: ftrace: Add MODULE_PLTS support

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9077/1: PLT: Move struct plt_entries definition to header

Florian Fainelli <f.fainelli@gmail.com>
    ARM: Qualify enabling of swiotlb_init()

David Hildenbrand <david@redhat.com>
    s390/pci_mmio: fully validate the VMA before calling follow_pte()

nick black <dankamongmen@gmail.com>
    console: consume APC, DM, DCS

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reporting CRS value

Pali Rohár <pali@kernel.org>
    PCI: pci-bridge-emul: Add PCIe Root Capabilities Register


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/include/asm/ftrace.h                      |  3 +
 arch/arm/include/asm/insn.h                        |  8 +-
 arch/arm/include/asm/module.h                      | 10 +++
 arch/arm/kernel/ftrace.c                           | 46 +++++++++--
 arch/arm/kernel/insn.c                             | 19 ++---
 arch/arm/kernel/module-plts.c                      | 49 ++++++++---
 arch/arm/mm/init.c                                 |  6 +-
 arch/arm64/kernel/cacheinfo.c                      |  7 +-
 arch/mips/kernel/cacheinfo.c                       |  7 +-
 arch/riscv/kernel/cacheinfo.c                      |  7 +-
 arch/s390/pci/pci_mmio.c                           |  2 +-
 arch/um/drivers/virtio_uml.c                       |  4 +-
 arch/x86/kernel/cpu/cacheinfo.c                    |  7 +-
 block/blk-mq.c                                     | 14 +++-
 block/blk-throttle.c                               |  1 +
 drivers/base/power/main.c                          |  2 +-
 drivers/dma-buf/Kconfig                            |  1 +
 drivers/dma/Kconfig                                |  4 +-
 drivers/dma/acpi-dma.c                             | 10 ++-
 drivers/dma/idxd/submit.c                          |  2 +-
 drivers/dma/sprd-dma.c                             |  1 +
 drivers/dma/xilinx/xilinx_dma.c                    |  2 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    | 17 +++-
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c  |  2 +-
 drivers/iommu/amd/init.c                           | 31 +++++--
 drivers/misc/habanalabs/gaudi/gaudi.c              |  6 ++
 drivers/misc/habanalabs/goya/goya.c                |  6 ++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  | 51 ------------
 drivers/parisc/dino.c                              | 18 ++---
 drivers/pci/controller/pci-aardvark.c              | 67 ++++++++++++++-
 drivers/pci/pci-bridge-emul.h                      |  2 +-
 drivers/platform/chrome/Makefile                   |  2 +-
 drivers/platform/chrome/cros_ec_sensorhub_ring.c   | 14 ++++
 drivers/platform/chrome/cros_ec_trace.h            | 94 ++++++++++++++++++++++
 drivers/pwm/pwm-img.c                              | 16 ----
 drivers/pwm/pwm-lpc32xx.c                          | 10 +--
 drivers/pwm/pwm-mxs.c                              | 13 ++-
 drivers/pwm/pwm-rockchip.c                         | 14 ----
 drivers/pwm/pwm-stm32-lp.c                         |  2 -
 drivers/rtc/Kconfig                                |  1 +
 drivers/staging/rtl8192u/r8192U_core.c             |  2 +-
 drivers/thermal/samsung/exynos_tmu.c               |  1 +
 drivers/tty/vt/vt.c                                | 31 ++++++-
 fs/btrfs/volumes.c                                 | 25 +++---
 fs/ceph/caps.c                                     | 70 ++++++++++++----
 fs/ceph/dir.c                                      |  3 +-
 fs/ceph/file.c                                     | 32 ++++----
 fs/ceph/inode.c                                    |  6 +-
 fs/ceph/mds_client.c                               | 38 ++++++++-
 fs/ceph/metric.c                                   |  7 +-
 fs/ceph/super.h                                    |  6 ++
 fs/coredump.c                                      |  4 +-
 fs/nilfs2/sysfs.c                                  | 26 +++---
 fs/nilfs2/the_nilfs.c                              |  9 +--
 include/linux/cacheinfo.h                          | 18 -----
 include/linux/thermal.h                            |  5 +-
 kernel/profile.c                                   | 21 ++---
 kernel/sched/idle.c                                |  4 +-
 kernel/sys.c                                       |  7 --
 lib/Kconfig.debug                                  |  1 -
 net/9p/trans_virtio.c                              |  4 +-
 net/sctp/input.c                                   |  3 +
 net/sctp/sm_make_chunk.c                           | 13 ++-
 tools/bootconfig/scripts/ftrace2bconf.sh           |  4 +-
 tools/perf/tests/bpf.c                             |  2 +-
 tools/perf/util/dso.c                              | 10 +++
 67 files changed, 618 insertions(+), 316 deletions(-)


