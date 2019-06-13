Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DCD44378
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfFMQ3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730923AbfFMIfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:35:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47D4E2146F;
        Thu, 13 Jun 2019 08:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560414913;
        bh=FlcRjAyb6Z35xjWBR6MlZIIgWfAl3FALB5MLplOSV9k=;
        h=From:To:Cc:Subject:Date:From;
        b=aocRYj+h68C+MMcIHQaKDYrKO14UCAUW0cXMiDYdqpytBXaQtksxhWzjvV2CcEMTa
         GmMucLP1Crsc45+5YP1vBERJc7SprH2wSZFkntKG9u/RPrAPraryitkOMEzuRdaTks
         ZK/xubSahCHhA8/2Vf1/YxOpPgzpCQoNkr8hY5xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/81] 4.14.126-stable review
Date:   Thu, 13 Jun 2019 10:32:43 +0200
Message-Id: <20190613075649.074682929@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.126-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.126-rc1
X-KernelTest-Deadline: 2019-06-15T07:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.126 release.
There are 81 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 15 Jun 2019 07:54:51 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.126-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.126-rc1

Helen Koike <helen.koike@collabora.com>
    drm: don't block fb changes for async plane updates

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm/nouveau: add kconfig option to turn off nouveau legacy contexts. (v3)"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: Align minimum encryption key size for LE and BR/EDR connections"

Dennis Zhou <dennis@kernel.org>
    percpu: do not search past bitmap when allocating an area

Andrey Smirnov <andrew.smirnov@gmail.com>
    gpio: vf610: Do not share irq_chip

Hans de Goede <hdegoede@redhat.com>
    usb: typec: fusb302: Check vconn is off when we start toggling

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: exynos: Fix undefined instruction during Exynos5422 resume

Phong Hoang <phong.hoang.wz@renesas.com>
    pwm: Fix deadlock warning when removing PWM device

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: Always enable necessary APIO_1V8 and ABB_1V8 regulators on Arndale Octa

Christoph Vogtländer <c.vogtlaender@sigma-surface-science.com>
    pwm: tiehrpwm: Update shadow register for disabling PWMs

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: idma64: Use actual device for DMA transfers

Tony Lindgren <tony@atomide.com>
    gpio: gpio-omap: add check for off wake capable gpios

Kangjie Lu <kjlu@umn.edu>
    PCI: xilinx: Check for __get_free_pages() failure

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: increase idling for weight-raised queues

Kangjie Lu <kjlu@umn.edu>
    video: imsttfb: fix potential NULL pointer dereferences

Kangjie Lu <kjlu@umn.edu>
    video: hgafb: fix potential NULL pointer dereference

Marek Vasut <marek.vasut+renesas@gmail.com>
    PCI: rcar: Fix 64bit MSI message address handling

Kangjie Lu <kjlu@umn.edu>
    PCI: rcar: Fix a potential NULL pointer dereference

Sven Van Asbroeck <thesven73@gmail.com>
    power: supply: max14656: fix potential use-before-alloc

Junxiao Chang <junxiao.chang@intel.com>
    platform/x86: intel_pmc_ipc: adding error handling

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Protect in-kernel ioctl calls with mutex

Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
    PCI: rpadlpar: Fix leaked device_node references in add/remove paths

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6qdl: Specify IMX6QDL_CLK_IPG as "ipg" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ipg" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6ul: Specify IMX6UL_CLK_IPG as "ipg" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx7d: Specify IMX7D_CLK_IPG as "ipg" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ahb" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx53: Specify IMX5_CLK_IPG as "ahb" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx50: Specify IMX5_CLK_IPG as "ahb" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx51: Specify IMX5_CLK_IPG as "ahb" clock to SDMA

Douglas Anderson <dianders@chromium.org>
    soc: rockchip: Set the proper PWM for rk3288

Douglas Anderson <dianders@chromium.org>
    clk: rockchip: Turn on "aclk_dmac1" for suspend on rk3288

Nathan Chancellor <natechancellor@gmail.com>
    soc: mediatek: pwrap: Zero initialize rdata in pwrap_init_cipher

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Prevent ARM32 specific code to be compiled for ARM64

Enrico Granata <egranata@chromium.org>
    platform/chrome: cros_ec_proto: check for NULL transfer function

Wenwen Wang <wang6495@umn.edu>
    x86/PCI: Fix PCI IRQ routing table memory leak

Farhan Ali <alifm@linux.ibm.com>
    vfio: Fix WARNING "do not call blocking ops when !TASK_RUNNING"

J. Bruce Fields <bfields@redhat.com>
    nfsd: allow fh_want_write to be called twice

Kirill Smelkov <kirr@nexedi.com>
    fuse: retrieve: cap requested size to negotiated max_write

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    nvmem: core: fix read buffer in place

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Register irq handler after the chip initialization

Keith Busch <keith.busch@intel.com>
    nvme-pci: unquiesce admin queue on shutdown

Kishon Vijay Abraham I <kishon@ti.com>
    misc: pci_endpoint_test: Fix test_reg_bar to be updated in pci_endpoint_test

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Set intel_iommu_gfx_mapped correctly

Ming Lei <ming.lei@redhat.com>
    blk-mq: move cancel of requeue_work into blk_mq_release

Vladimir Zapolskiy <vz@mleia.com>
    watchdog: fix compile time error of pretimeout governors

Georg Hofmann <georg@hofmannsweb.com>
    watchdog: imx2_wdt: Fix set_timeout for big timeout values

Serge Semin <fancer.lancer@gmail.com>
    mips: Make sure dt memory regions are valid

Ludovic Barre <ludovic.barre@st.com>
    mmc: mmci: Prevent polling for busy detection in IRQ context

Maciej Żenczykowski <maze@google.com>
    uml: fix a boot splat wrt use of cpu_all_mask

YueHaibing <yuehaibing@huawei.com>
    configfs: fix possible use-after-free in configfs_register_group

John Sperbeck <jsperbeck@google.com>
    percpu: remove spurious lock dependency between percpu and sched

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to do sanity check on valid block count of segment

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to avoid panic in dec_valid_block_count()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to clear dirty inode in error path of f2fs_iget()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to avoid panic in do_recover_data()

Miroslav Lichvar <mlichvar@redhat.com>
    ntp: Allow TAI-UTC offset to be set to zero

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    pwm: meson: Use the spin-lock only to protect register modifications

Michael Ellerman <mpe@ellerman.id.au>
    EDAC/mpc85xx: Prevent building as a module

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Don't use ignore flag for fake jumps

Matt Redfearn <matt.redfearn@thinci.com>
    drm/bridge: adv7511: Fix low refresh rate selection

Stephane Eranian <eranian@google.com>
    perf/x86/intel: Allow PEBS multi-entry in watermark mode

Tony Lindgren <tony@atomide.com>
    mfd: twl6040: Fix device init errors for ACCCTL register

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/disp/dp: respect sink limits when selecting failsafe link configuration

Binbin Wu <binbin.wu@intel.com>
    mfd: intel-lpss: Set the device in reset state when init

Daniel Gomez <dagmcr@gmail.com>
    mfd: tps65912-spi: Add missing of table registration

Amit Kucheria <amit.kucheria@linaro.org>
    drivers: thermal: tsens: Don't print error message on -EPROBE_DEFER

Jiada Wang <jiada_wang@mentor.com>
    thermal: rcar_gen3_thermal: disable interrupt in .remove

Cyrill Gorcunov <gorcunov@gmail.com>
    kernel/sys.c: prctl: fix false positive in validate_prctl_map()

Qian Cai <cai@lca.pw>
    mm/slab.c: fix an infinite loop in leaks_show()

Yue Hu <huyue2@yulong.com>
    mm/cma_debug.c: fix the break condition in cma_maxchunk_get()

Yue Hu <huyue2@yulong.com>
    mm/cma.c: fix the bitmap status to show failed allocation reason

Yue Hu <huyue2@yulong.com>
    mm/cma.c: fix crash on CMA allocation if bitmap allocation fails

Linxu Fang <fanglinxu@huawei.com>
    mem-hotplug: fix node spanned pages when we have a node with only ZONE_MOVABLE

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: on restore reserve error path retain subpool reservation

Jérôme Glisse <jglisse@redhat.com>
    mm/hmm: select mmu notifier when selecting HMM

Arnd Bergmann <arnd@arndb.de>
    ARM: prevent tracing IPI_CPU_BACKTRACE

Li Rongqing <lirongqing@baidu.com>
    ipc: prevent lockup on alloc_msg and free_msg

Christian Brauner <christian@brauner.io>
    sysctl: return -EINVAL if val violates minmax

Hou Tao <houtao1@huawei.com>
    fs/fat/file.c: issue flush after the writeback of FAT

Kangjie Lu <kjlu@umn.edu>
    rapidio: fix a NULL pointer dereference when create_workqueue() fails


-------------

Diffstat:

 Makefile                                         |  4 ++--
 arch/arm/boot/dts/exynos5420-arndale-octa.dts    |  2 ++
 arch/arm/boot/dts/imx50.dtsi                     |  2 +-
 arch/arm/boot/dts/imx51.dtsi                     |  2 +-
 arch/arm/boot/dts/imx53.dtsi                     |  2 +-
 arch/arm/boot/dts/imx6qdl.dtsi                   |  2 +-
 arch/arm/boot/dts/imx6sl.dtsi                    |  2 +-
 arch/arm/boot/dts/imx6sx.dtsi                    |  2 +-
 arch/arm/boot/dts/imx6ul.dtsi                    |  2 +-
 arch/arm/boot/dts/imx7s.dtsi                     |  4 ++--
 arch/arm/include/asm/hardirq.h                   |  1 +
 arch/arm/kernel/smp.c                            |  6 ++++-
 arch/arm/mach-exynos/suspend.c                   | 19 +++++++++++++++
 arch/mips/kernel/prom.c                          | 14 ++++++++++-
 arch/um/kernel/time.c                            |  2 +-
 arch/x86/events/intel/core.c                     |  2 +-
 arch/x86/pci/irq.c                               | 10 ++++++--
 block/bfq-iosched.c                              |  2 ++
 block/blk-core.c                                 |  1 -
 block/blk-mq.c                                   |  2 ++
 drivers/clk/rockchip/clk-rk3288.c                | 11 +++++++++
 drivers/dma/idma64.c                             |  6 +++--
 drivers/dma/idma64.h                             |  2 ++
 drivers/edac/Kconfig                             |  4 ++--
 drivers/gpio/gpio-omap.c                         | 25 +++++++++++++-------
 drivers/gpio/gpio-vf610.c                        | 26 ++++++++++----------
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c     |  6 ++---
 drivers/gpu/drm/drm_atomic_helper.c              | 10 ++++++++
 drivers/gpu/drm/nouveau/Kconfig                  | 13 +---------
 drivers/gpu/drm/nouveau/nouveau_drm.c            |  7 ++----
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c    | 11 +++++++--
 drivers/iommu/intel-iommu.c                      |  7 +++---
 drivers/mfd/intel-lpss.c                         |  3 +++
 drivers/mfd/tps65912-spi.c                       |  1 +
 drivers/mfd/twl6040.c                            | 13 +++++++++-
 drivers/misc/pci_endpoint_test.c                 |  1 +
 drivers/mmc/host/mmci.c                          |  5 ++--
 drivers/nvme/host/pci.c                          |  5 +++-
 drivers/nvmem/core.c                             | 15 ++++++++----
 drivers/pci/dwc/pci-keystone.c                   |  4 ++++
 drivers/pci/host/pcie-rcar.c                     | 10 +++++---
 drivers/pci/host/pcie-xilinx.c                   | 12 ++++++++--
 drivers/pci/hotplug/rpadlpar_core.c              |  4 ++++
 drivers/platform/chrome/cros_ec_proto.c          | 11 +++++++++
 drivers/platform/x86/intel_pmc_ipc.c             |  6 ++++-
 drivers/power/supply/max14656_charger_detector.c | 14 +++++------
 drivers/pwm/core.c                               | 10 ++++----
 drivers/pwm/pwm-meson.c                          | 25 +++++++++++++-------
 drivers/pwm/pwm-tiehrpwm.c                       |  2 ++
 drivers/pwm/sysfs.c                              | 14 +----------
 drivers/rapidio/rio_cm.c                         |  8 +++++++
 drivers/soc/mediatek/mtk-pmic-wrap.c             |  2 +-
 drivers/soc/rockchip/grf.c                       |  2 ++
 drivers/spi/spi-pxa2xx.c                         |  7 +-----
 drivers/staging/typec/fusb302/fusb302.c          |  2 ++
 drivers/thermal/qcom/tsens.c                     |  3 ++-
 drivers/thermal/rcar_gen3_thermal.c              |  3 +++
 drivers/tty/serial/8250/8250_dw.c                |  4 ++--
 drivers/vfio/vfio.c                              | 30 ++++++++----------------
 drivers/video/fbdev/hgafb.c                      |  2 ++
 drivers/video/fbdev/imsttfb.c                    |  5 ++++
 drivers/watchdog/Kconfig                         |  1 +
 drivers/watchdog/imx2_wdt.c                      |  4 +++-
 fs/configfs/dir.c                                | 17 ++++++++++----
 fs/f2fs/f2fs.h                                   | 12 ++++++++--
 fs/f2fs/inode.c                                  |  1 +
 fs/f2fs/recovery.c                               | 10 +++++++-
 fs/f2fs/segment.h                                |  3 +--
 fs/fat/file.c                                    | 11 ++++++---
 fs/fuse/dev.c                                    |  2 +-
 fs/nfsd/vfs.h                                    |  5 +++-
 include/drm/drm_modeset_helper_vtables.h         |  8 +++++++
 include/linux/pwm.h                              |  5 ----
 include/net/bluetooth/hci_core.h                 |  3 ---
 ipc/mqueue.c                                     | 10 ++++++--
 ipc/msgutil.c                                    |  6 +++++
 kernel/sys.c                                     |  2 +-
 kernel/sysctl.c                                  |  6 +++--
 kernel/time/ntp.c                                |  2 +-
 mm/Kconfig                                       |  2 +-
 mm/cma.c                                         | 23 +++++++++++-------
 mm/cma_debug.c                                   |  2 +-
 mm/hugetlb.c                                     | 21 +++++++++++++----
 mm/page_alloc.c                                  |  6 +++--
 mm/percpu.c                                      |  9 +++++--
 mm/slab.c                                        |  6 ++++-
 net/bluetooth/hci_conn.c                         |  8 -------
 sound/core/seq/seq_clientmgr.c                   |  9 +++++--
 sound/pci/hda/hda_intel.c                        |  6 ++---
 tools/objtool/check.c                            |  8 ++++---
 90 files changed, 428 insertions(+), 214 deletions(-)


