Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C9D4173F3
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345507AbhIXNBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345021AbhIXM7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7DFF61288;
        Fri, 24 Sep 2021 12:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487992;
        bh=U1a1iFNNWwCngXgG/igGPO6jZA/0RlERfwZRTdheyPs=;
        h=From:To:Cc:Subject:Date:From;
        b=dG1oLUNaMzjtt9OY3Ar1XyIHkVTnvASRHlExzgwaPQ4bwWX4CovYU+oYFDyaRxheK
         ZC/RQLC/W3q14KDvp7x86coh97FIqnAJ1F6yW7yRKlkiumVpYlLwcREZfQG7BYrgYg
         JFgGOKArEGvjJ422LEECkJxVLP9IXV4vxVIgrXYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 000/100] 5.14.8-rc1 review
Date:   Fri, 24 Sep 2021 14:43:09 +0200
Message-Id: <20210924124341.214446495@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.8-rc1
X-KernelTest-Deadline: 2021-09-26T12:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.8 release.
There are 100 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.8-rc1

Guenter Roeck <linux@roeck-us.net>
    drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV

Paul Moore <paul@paul-moore.com>
    selinux,smack: fix subjective/objective credential use mixups

Hao Xu <haoxu@linux.alibaba.com>
    io_uring: fix off-by-one in BUILD_BUG_ON check of __REQ_F_LAST_BIT

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: properly invalidate cached root handle when closing it

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    sched/idle: Make the idle timer expire in hard interrupt context

Yu-Tung Chang <mtwget@gmail.com>
    rtc: rx8010: select REGMAP_I2C

Song Liu <songliubraving@fb.com>
    blk-mq: allow 4x BLK_MAX_REQUEST_COUNT at blk_plug for multiple_queues

Li Jinlin <lijinlin3@huawei.com>
    blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    block: genhd: don't call blkdev_show() with major_names_lock held

Hannes Reinecke <hare@suse.de>
    nvmet: fixup buffer overrun in nvmet_subsys_attr_serial()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: stm32-lp: Don't modify HW state in .remove() callback

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: rockchip: Don't modify HW state in .remove() callback

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: img: Don't modify HW state in .remove() callback

farah kassabri <fkassabri@habana.ai>
    habanalabs: cannot sleep while holding spinlock

Omer Shpigelman <oshpigelman@habana.ai>
    habanalabs: add "in device creation" status

Yuri Nudelman <ynudelman@habana.ai>
    habanalabs: fix mmu node address resolution in debugfs

Ofir Bitton <obitton@habana.ai>
    habanalabs: add validity check for event ID received from F/W

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: fix fdinfo race with process exit

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/display: Fix memory leak reported by coverity

Luben Tuikov <luben.tuikov@amd.com>
    drm/amdgpu: Fixes to returning VBIOS RAS EEPROM address

Koby Elbaz <kelbaz@habana.ai>
    habanalabs: fix race between soft reset and heartbeat

Tomer Tayar <ttayar@habana.ai>
    habanalabs: fix nullifying of destroyed mmu pgt pool

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    thermal/drivers/rcar_gen3_thermal: Store TSC id as unsigned int

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
    btrfs: delay blkdev_put until after the device remove

Josef Bacik <josef@toxicpanda.com>
    btrfs: update the bdev time directly when closing

Vasily Gorbik <gor@linux.ibm.com>
    s390/unwind: use current_frame_address() to unwind current task

Jeff Layton <jlayton@kernel.org>
    ceph: lockdep annotations for try_nonblocking_invalidate

Xiubo Li <xiubli@redhat.com>
    ceph: remove the capsnaps when removing caps

Jeff Layton <jlayton@kernel.org>
    ceph: request Fw caps before updating the mtime in ceph_write_iter

Jeff Layton <jlayton@kernel.org>
    ceph: fix memory leak on decode error in ceph_handle_caps

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: PM: s2idle: Run both AMD and Microsoft methods if both are supported

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: audio-graph: respawn Platform Support

Sven Schnelle <svens@linux.ibm.com>
    s390: add kmemleak annotation in stack_alloc()

Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
    dmaengine: xilinx_dma: Set DMA mask for coherent APIs

Johannes Berg <johannes.berg@intel.com>
    dmaengine: ioat: depends on !UML

Dan Williams <dan.j.williams@intel.com>
    cxl/pci: Introduce cdevm_file_operations

Ben Widawsky <ben.widawsky@intel.com>
    cxl: Move cxl_core to new directory

Zou Wei <zou_wei@huawei.com>
    dmaengine: sprd: Add missing MODULE_DEVICE_TABLE

Johannes Berg <johannes.berg@intel.com>
    dmaengine: idxd: depends on !UML

Adrian Hunter <adrian.hunter@intel.com>
    perf tools: Fix hybrid config terms list corruption

Geert Uytterhoeven <geert@linux-m68k.org>
    riscv: dts: microchip: mpfs-icicle: Fix serial console

Saravana Kannan <saravanak@google.com>
    of: property: Disable fw_devlink DT support for X86

xinhui pan <xinhui.pan@amd.com>
    drm/ttm: Fix a deadlock if the target BO is not idle during swap

Ard Biesheuvel <ardb@kernel.org>
    arm64: mm: limit linear region to 51 bits for KVM in nVHE mode

Fenghua Yu <fenghua.yu@intel.com>
    iommu/vt-d: Fix a deadlock in intel_svm_drain_prq()

Fenghua Yu <fenghua.yu@intel.com>
    iommu/vt-d: Fix PASID leak in intel_svm_unbind_mm()

Wei Huang <wei.huang2@amd.com>
    iommu/amd: Relocate GAMSup check to early_enable_iommus

Guenter Roeck <linux@roeck-us.net>
    parisc: Move pci_dev_is_behind_card_dino to where it is used

Geert Uytterhoeven <geert@linux-m68k.org>
    dma-buf: DMABUF_DEBUG should depend on DMA_SHARED_BUFFER

Geert Uytterhoeven <geert@linux-m68k.org>
    dma-buf: DMABUF_MOVE_NOTIFY should depend on DMA_SHARED_BUFFER

Thomas Gleixner <tglx@linutronix.de>
    drivers: base: cacheinfo: Get rid of DEFINE_SMP_CALL_CACHE_FUNCTION()

Koba Ko <koba.ko@canonical.com>
    drm/amdgpu: Disable PCIE_DPM on Intel RKL Platform

Arnd Bergmann <arnd@arndb.de>
    thermal/core: Fix thermal_cooling_device_register() prototype

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/boot: Fix to loop on only subkeys

Masami Hiramatsu <mhiramat@kernel.org>
    tools/bootconfig: Fix tracing_on option checking in ftrace2bconf.sh

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    init: move usermodehelper_enable() to populate_rootfs()

Geert Uytterhoeven <geert@linux-m68k.org>
    math: RATIONAL_KUNIT_TEST should depend on RATIONAL instead of selecting it

NeilBrown <neilb@suse.de>
    SUNRPC: don't pause on incomplete allocation

Heiko Carstens <hca@linux.ibm.com>
    s390/entry: make oklabel within CHKSTG macro local

Gwendal Grignou <gwendal@chromium.org>
    platform/chrome: cros_ec_trace: Fix format warnings

Gwendal Grignou <gwendal@chromium.org>
    platform/chrome: sensorhub: Add trace events for sample

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: clear block on fault flag when clear wq

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix abort status check

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix wq slot allocation index check

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: have command status always set

Dave Jiang <dave.jiang@intel.com>
    dmanegine: idxd: cleanup all device related bits after disabling device

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: mxs: Don't modify HW state in .probe() after the PWM chip was registered

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc32xx: Don't modify HW state in .probe() after the PWM chip was registered

Jeff Layton <jlayton@kernel.org>
    ceph: cancel delayed work instead of flushing on mdsc teardown

Matthias Kaehlcke <mka@chromium.org>
    thermal/drivers/qcom/spmi-adc-tm5: Don't abort probing if a sensor is not used

Prasad Sodagudi <psodagud@codeaurora.org>
    PM: sleep: core: Avoid setting power.must_resume to false

Pavel Skripkin <paskripkin@gmail.com>
    profiling: fix shift-out-of-bounds bugs

Zhen Lei <thunder.leizhen@huawei.com>
    nilfs2: use refcount_dec_and_lock() to fix potential UAF

Cyrill Gorcunov <gorcunov@gmail.com>
    prctl: allow to setup brk for et_dyn executables

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: ab8500: Fix register offset calculation to not depend on probe order

Xie Yongji <xieyongji@bytedance.com>
    9p/trans_virtio: Remove sysfs file on probe failure

Dan Carpenter <dan.carpenter@oracle.com>
    thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()

Yang Yingliang <yangyingliang@huawei.com>
    n64cart: fix return value check in n64cart_probe()

Fabio Aiuto <fabioaiuto83@gmail.com>
    staging: rtl8723bs: fix wpa_set_auth_algs() function

Namhyung Kim <namhyung@kernel.org>
    perf tools: Allow build-id with trailing zeros

Remi Bernon <rbernon@codeweavers.com>
    perf symbol: Look for ImageBase in PE file to compute .text offset

Michael Petlan <mpetlan@redhat.com>
    perf test: Fix bpf test sample mismatch reporting

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: acpi: Avoid comparison GSI with Linux vIRQ

Niklas Schnelle <schnelle@linux.ibm.com>
    RDMA/mlx5: Fix xlt_chunk_align calculation

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Enable stash feature of HIP09

Johannes Berg <johannes.berg@intel.com>
    um: virtio_uml: fix memory leak on init failures

QiuXi <qiuxi1@huawei.com>
    coredump: fix memleak in dump_vma_snapshot()

Johannes Berg <johannes.berg@intel.com>
    um: fix stub location calculation

Nathan Chancellor <nathan@kernel.org>
    staging: rtl8192u: Fix bitwise vs logical operator in TranslateRxSignalStuff819xUsb()

nick black <dankamongmen@gmail.com>
    console: consume APC, DM, DCS

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reporting CRS value

Pali Rohár <pali@kernel.org>
    PCI: pci-bridge-emul: Add PCIe Root Capabilities Register


-------------

Diffstat:

 Documentation/driver-api/cxl/memory-devices.rst    |  2 +-
 Makefile                                           |  4 +-
 arch/arm64/kernel/cacheinfo.c                      |  7 +-
 arch/arm64/mm/init.c                               | 16 +++-
 arch/mips/kernel/cacheinfo.c                       |  7 +-
 .../dts/microchip/microchip-mpfs-icicle-kit.dts    |  6 +-
 arch/riscv/kernel/cacheinfo.c                      |  7 +-
 arch/s390/include/asm/stacktrace.h                 | 20 ++---
 arch/s390/include/asm/unwind.h                     |  8 +-
 arch/s390/kernel/entry.S                           |  4 +-
 arch/s390/kernel/setup.c                           | 10 ++-
 arch/um/drivers/virtio_uml.c                       |  4 +-
 arch/um/kernel/skas/clone.c                        |  3 +-
 arch/x86/kernel/cpu/cacheinfo.c                    |  7 +-
 arch/x86/um/shared/sysdep/stub_32.h                | 12 +++
 arch/x86/um/shared/sysdep/stub_64.h                | 12 +++
 arch/x86/um/stub_segv.c                            |  3 +-
 block/blk-mq.c                                     | 14 +++-
 block/blk-throttle.c                               |  1 +
 block/genhd.c                                      |  9 +-
 drivers/acpi/x86/s2idle.c                          | 67 ++++++++-------
 drivers/base/power/main.c                          |  2 +-
 drivers/block/n64cart.c                            |  4 +-
 drivers/cxl/Makefile                               |  4 +-
 drivers/cxl/core/Makefile                          |  5 ++
 drivers/cxl/{core.c => core/bus.c}                 |  4 +-
 drivers/cxl/{mem.h => cxlmem.h}                    | 15 ++++
 drivers/cxl/pci.c                                  | 67 ++++++++-------
 drivers/cxl/pmem.c                                 |  2 +-
 drivers/dma-buf/Kconfig                            |  2 +
 drivers/dma/Kconfig                                |  4 +-
 drivers/dma/acpi-dma.c                             | 10 ++-
 drivers/dma/idxd/device.c                          | 98 ++++++++++++++++------
 drivers/dma/idxd/idxd.h                            |  6 +-
 drivers/dma/idxd/irq.c                             | 16 +++-
 drivers/dma/idxd/submit.c                          |  2 +-
 drivers/dma/idxd/sysfs.c                           | 22 ++---
 drivers/dma/sprd-dma.c                             |  1 +
 drivers/dma/xilinx/xilinx_dma.c                    |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   | 50 +++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c         | 11 ++-
 .../drm/amd/display/dc/dcn303/dcn303_resource.c    |  6 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    | 17 +++-
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c  |  2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |  6 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  1 +
 drivers/infiniband/hw/mlx5/mr.c                    |  2 +-
 drivers/iommu/amd/init.c                           | 31 +++++--
 drivers/iommu/intel/svm.c                          | 15 +++-
 drivers/misc/habanalabs/common/command_buffer.c    |  2 -
 drivers/misc/habanalabs/common/debugfs.c           |  2 +-
 drivers/misc/habanalabs/common/device.c            | 56 ++++++++++---
 drivers/misc/habanalabs/common/firmware_if.c       | 18 ++--
 drivers/misc/habanalabs/common/habanalabs.h        |  6 +-
 drivers/misc/habanalabs/common/habanalabs_drv.c    |  8 +-
 drivers/misc/habanalabs/common/hw_queue.c          | 30 +++----
 drivers/misc/habanalabs/common/memory.c            |  2 +-
 drivers/misc/habanalabs/common/mmu/mmu_v1.c        | 12 +--
 drivers/misc/habanalabs/common/sysfs.c             | 20 ++---
 drivers/misc/habanalabs/gaudi/gaudi.c              |  6 ++
 drivers/misc/habanalabs/goya/goya.c                |  6 ++
 drivers/nvme/target/configfs.c                     |  3 +-
 drivers/of/property.c                              |  3 +
 drivers/parisc/dino.c                              | 18 ++--
 drivers/pci/controller/pci-aardvark.c              | 67 ++++++++++++++-
 drivers/pci/pci-bridge-emul.h                      |  2 +-
 drivers/platform/chrome/Makefile                   |  2 +-
 drivers/platform/chrome/cros_ec_sensorhub_ring.c   | 14 ++++
 drivers/platform/chrome/cros_ec_trace.h            | 94 +++++++++++++++++++++
 drivers/pwm/pwm-ab8500.c                           | 17 +++-
 drivers/pwm/pwm-img.c                              | 16 ----
 drivers/pwm/pwm-lpc32xx.c                          | 10 +--
 drivers/pwm/pwm-mxs.c                              | 13 ++-
 drivers/pwm/pwm-rockchip.c                         | 14 ----
 drivers/pwm/pwm-stm32-lp.c                         |  2 -
 drivers/rtc/Kconfig                                |  1 +
 drivers/staging/rtl8192u/r8192U_core.c             |  2 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c     |  6 +-
 drivers/thermal/qcom/qcom-spmi-adc-tm5.c           |  6 ++
 drivers/thermal/rcar_gen3_thermal.c                |  7 +-
 drivers/thermal/samsung/exynos_tmu.c               |  1 +
 drivers/tty/vt/vt.c                                | 31 ++++++-
 fs/btrfs/ioctl.c                                   | 15 +++-
 fs/btrfs/volumes.c                                 | 48 +++++++----
 fs/btrfs/volumes.h                                 |  3 +-
 fs/ceph/caps.c                                     | 75 ++++++++++++-----
 fs/ceph/file.c                                     | 32 +++----
 fs/ceph/mds_client.c                               | 32 ++++++-
 fs/ceph/metric.c                                   |  4 +-
 fs/ceph/super.h                                    |  6 ++
 fs/cifs/smb2ops.c                                  | 20 +++--
 fs/coredump.c                                      |  4 +-
 fs/io_uring.c                                      |  2 +-
 fs/nilfs2/sysfs.c                                  | 26 +++---
 fs/nilfs2/the_nilfs.c                              |  9 +-
 include/linux/cacheinfo.h                          | 18 ----
 include/linux/thermal.h                            |  5 +-
 include/uapi/misc/habanalabs.h                     |  4 +-
 init/initramfs.c                                   |  2 +
 init/main.c                                        |  1 -
 init/noinitramfs.c                                 |  2 +
 kernel/profile.c                                   | 21 ++---
 kernel/sched/idle.c                                |  4 +-
 kernel/sys.c                                       |  7 --
 kernel/trace/trace_boot.c                          |  6 +-
 lib/Kconfig.debug                                  |  4 +-
 net/9p/trans_virtio.c                              |  4 +-
 net/sunrpc/svc_xprt.c                              | 13 +--
 security/selinux/hooks.c                           |  4 +-
 security/smack/smack_lsm.c                         |  4 +-
 sound/soc/generic/audio-graph-card.c               |  6 ++
 tools/bootconfig/scripts/ftrace2bconf.sh           |  4 +-
 tools/perf/tests/bpf.c                             |  2 +-
 tools/perf/util/dso.c                              | 10 +++
 tools/perf/util/parse-events-hybrid.c              | 18 +++-
 tools/perf/util/parse-events.c                     | 18 ++--
 tools/perf/util/symbol.c                           | 20 ++++-
 117 files changed, 1066 insertions(+), 514 deletions(-)


