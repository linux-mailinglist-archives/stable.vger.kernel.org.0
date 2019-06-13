Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E622544254
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391391AbfFMQVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731060AbfFMIiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:38:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DB6921479;
        Thu, 13 Jun 2019 08:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415128;
        bh=CwZb56Ku5gi8pi77OtIon+4WRzH22Hd1N+ii3WLGVFU=;
        h=From:To:Cc:Subject:Date:From;
        b=tA3UDUP9X09TRbpfKu+w/16UpL2RvW5WA/OQohTgzYwCs1Stm9giJKsb8MKUbm/Md
         XNt3A/z5AXuLVNjbGGF/rdijPuEGmBmDdAaTt6SZ4FGT9QKH5toFBygzt3Ybs2b++I
         tgzt/7YZVeLIp1/4Wsbus8c367nc1D5DQw8Wnf2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/118] 4.19.51-stable review
Date:   Thu, 13 Jun 2019 10:32:18 +0200
Message-Id: <20190613075643.642092651@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.51-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.51-rc1
X-KernelTest-Deadline: 2019-06-15T07:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.51 release.
There are 118 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 15 Jun 2019 07:54:44 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.51-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.51-rc1

Helen Koike <helen.koike@collabora.com>
    drm/vc4: fix fb references in async update

Amir Goldstein <amir73il@gmail.com>
    ovl: support stacked SEEK_HOLE/SEEK_DATA

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    ovl: check the capability before cred overridden

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm/nouveau: add kconfig option to turn off nouveau legacy contexts. (v3)"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: Align minimum encryption key size for LE and BR/EDR connections"

Dennis Zhou <dennis@kernel.org>
    percpu: do not search past bitmap when allocating an area

Andrey Smirnov <andrew.smirnov@gmail.com>
    gpio: vf610: Do not share irq_chip

Takeshi Kihara <takeshi.kihara.df@renesas.com>
    soc: renesas: Identify R-Car M3-W ES1.3

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

Brett Creeley <brett.creeley@intel.com>
    ice: Add missing case in print_link_msg for printing flow control

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

Giridhar Malavali <gmalavali@marvell.com>
    scsi: qla2xxx: Reset the FCF_ASYNC_{SENT|ACTIVE} flags

Marek Vasut <marek.vasut+renesas@gmail.com>
    PCI: rcar: Fix 64bit MSI message address handling

Kangjie Lu <kjlu@umn.edu>
    PCI: rcar: Fix a potential NULL pointer dereference

Peng Li <lipeng321@huawei.com>
    net: hns3: return 0 and print warning when hit duplicate MAC

Sven Van Asbroeck <thesven73@gmail.com>
    power: supply: max14656: fix potential use-before-alloc

Junxiao Chang <junxiao.chang@intel.com>
    platform/x86: intel_pmc_ipc: adding error handling

Kabir Sahane <x0153567@ti.com>
    ARM: OMAP2+: pm33xx-core: Do not Turn OFF CEFUSE as PPA may be using it

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Protect in-kernel ioctl calls with mutex

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Use plane->color_space for dpp if specified

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
    ARM: dts: imx6sll: Specify IMX6SLL_CLK_IPG as "ipg" clock to SDMA

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

Adam Ludkiewicz <adam.ludkiewicz@intel.com>
    i40e: Queues are reserved despite "Invalid argument" error

Wenwen Wang <wang6495@umn.edu>
    x86/PCI: Fix PCI IRQ routing table memory leak

Mika Westerberg <mika.westerberg@linux.intel.com>
    net: thunderbolt: Unregister ThunderboltIP protocol handler when suspending

Wesley Sheng <wesley.sheng@microchip.com>
    switchtec: Fix unintended mask of MRPC event

Will Deacon <will.deacon@arm.com>
    iommu/arm-smmu-v3: Don't disable SMMU in kdump kernel

Farhan Ali <alifm@linux.ibm.com>
    vfio: Fix WARNING "do not call blocking ops when !TASK_RUNNING"

Arnd Bergmann <arnd@arndb.de>
    nfsd: avoid uninitialized variable warning

J. Bruce Fields <bfields@redhat.com>
    nfsd: allow fh_want_write to be called twice

Kirill Smelkov <kirr@nexedi.com>
    fuse: retrieve: cap requested size to negotiated max_write

Chen-Yu Tsai <wens@csie.org>
    nvmem: sunxi_sid: Support SID on A83T and H5

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    nvmem: core: fix read buffer in place

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Register irq handler after the chip initialization

Taehee Yoo <ap420073@gmail.com>
    netfilter: nf_flow_table: fix netdev refcnt leak

Taehee Yoo <ap420073@gmail.com>
    netfilter: nf_flow_table: check ttl value in flow offload data path

Keith Busch <keith.busch@intel.com>
    nvme-pci: shutdown on timeout during deletion

Keith Busch <keith.busch@intel.com>
    nvme-pci: unquiesce admin queue on shutdown

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: designware-ep: Use aligned ATU window for raising MSI interrupts

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

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix base chain stat rcu_dereference usage

Serge Semin <fancer.lancer@gmail.com>
    mips: Make sure dt memory regions are valid

Jakub Jankowski <shasta@toxcorp.com>
    netfilter: nf_conntrack_h323: restore boundary check correctness

Taehee Yoo <ap420073@gmail.com>
    netfilter: nf_flow_table: fix missing error check for rhashtable_insert_fast

Ludovic Barre <ludovic.barre@st.com>
    mmc: mmci: Prevent polling for busy detection in IRQ context

Amir Goldstein <amir73il@gmail.com>
    ovl: do not generate duplicate fsnotify events for "fake" path

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    PCI: dwc: Free MSI IRQ page in dw_pcie_free_msi()

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    PCI: dwc: Free MSI in dw_pcie_host_init() error path

Maciej Żenczykowski <maze@google.com>
    uml: fix a boot splat wrt use of cpu_all_mask

YueHaibing <yuehaibing@huawei.com>
    configfs: fix possible use-after-free in configfs_register_group

John Sperbeck <jsperbeck@google.com>
    percpu: remove spurious lock dependency between percpu and sched

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to do checksum even if inode page is uptodate

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to do sanity check on valid block count of segment

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to use inline space only if inline_xattr is enable

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to avoid panic in dec_valid_block_count()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to clear dirty inode in error path of f2fs_iget()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to do sanity check on free nid

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to avoid panic in f2fs_remove_inode_page()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to avoid panic in f2fs_inplace_write_data()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to avoid panic in do_recover_data()

Miroslav Lichvar <mlichvar@redhat.com>
    ntp: Allow TAI-UTC offset to be set to zero

Fabien Dessenne <fabien.dessenne@st.com>
    mailbox: stm32-ipcc: check invalid irq

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    pwm: meson: Use the spin-lock only to protect register modifications

Michael Ellerman <mpe@ellerman.id.au>
    EDAC/mpc85xx: Prevent building as a module

Krzesimir Nowak <krzesimir@kinvolk.io>
    bpf: fix undefined behavior in narrow load handling

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/gv100-: fix spurious window immediate interlocks

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Don't use ignore flag for fake jumps

Matt Redfearn <matt.redfearn@thinci.com>
    drm/bridge: adv7511: Fix low refresh rate selection

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/gf119-gp10x: push HeadSetControlOutputResource() mthd when encoders change

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

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm: page_mkclean vs MADV_DONTNEED race

Yue Hu <huyue2@yulong.com>
    mm/cma.c: fix the bitmap status to show failed allocation reason

Christoph Hellwig <hch@lst.de>
    initramfs: free initrd memory if opening /initrd.image fails

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

Guenter Roeck <linux@roeck-us.net>
    drm/pl111: Initialize clock spinlock early

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

 Makefile                                           |   4 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |   2 +
 arch/arm/boot/dts/imx50.dtsi                       |   2 +-
 arch/arm/boot/dts/imx51.dtsi                       |   2 +-
 arch/arm/boot/dts/imx53.dtsi                       |   2 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   2 +-
 arch/arm/boot/dts/imx6sl.dtsi                      |   2 +-
 arch/arm/boot/dts/imx6sll.dtsi                     |   2 +-
 arch/arm/boot/dts/imx6sx.dtsi                      |   2 +-
 arch/arm/boot/dts/imx6ul.dtsi                      |   2 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   4 +-
 arch/arm/include/asm/hardirq.h                     |   1 +
 arch/arm/kernel/smp.c                              |   6 +-
 arch/arm/mach-exynos/suspend.c                     |  19 +++
 arch/arm/mach-omap2/pm33xx-core.c                  |   8 +-
 arch/mips/kernel/prom.c                            |  14 ++-
 arch/um/kernel/time.c                              |   2 +-
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/pci/irq.c                                 |  10 +-
 block/bfq-iosched.c                                |   2 +
 block/blk-core.c                                   |   1 -
 block/blk-mq.c                                     |   2 +
 drivers/clk/rockchip/clk-rk3288.c                  |  11 ++
 drivers/dma/idma64.c                               |   6 +-
 drivers/dma/idma64.h                               |   2 +
 drivers/edac/Kconfig                               |   4 +-
 drivers/gpio/gpio-omap.c                           |  25 ++--
 drivers/gpio/gpio-vf610.c                          |  26 ++---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp.c   |   6 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   2 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |   6 +-
 drivers/gpu/drm/nouveau/Kconfig                    |  13 +--
 drivers/gpu/drm/nouveau/dispnv50/disp.h            |   1 +
 drivers/gpu/drm/nouveau/dispnv50/head.c            |   2 +-
 drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c        |   1 +
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |   2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   7 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c      |  11 +-
 drivers/gpu/drm/pl111/pl111_display.c              |   5 +-
 drivers/gpu/drm/vc4/vc4_plane.c                    |   1 +
 drivers/iommu/arm-smmu-v3.c                        |  10 +-
 drivers/iommu/intel-iommu.c                        |   7 +-
 drivers/mailbox/stm32-ipcc.c                       |  13 ++-
 drivers/mfd/intel-lpss.c                           |   3 +
 drivers/mfd/tps65912-spi.c                         |   1 +
 drivers/mfd/twl6040.c                              |  13 ++-
 drivers/misc/pci_endpoint_test.c                   |   1 +
 drivers/mmc/host/mmci.c                            |   5 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 +
 drivers/net/thunderbolt.c                          |   3 +
 drivers/nvme/host/pci.c                            |  10 +-
 drivers/nvmem/core.c                               |  15 ++-
 drivers/nvmem/sunxi_sid.c                          |   2 +
 drivers/pci/controller/dwc/pci-keystone.c          |   4 +
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   7 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |  21 ++--
 drivers/pci/controller/dwc/pcie-designware.h       |   1 +
 drivers/pci/controller/pcie-rcar.c                 |  10 +-
 drivers/pci/controller/pcie-xilinx.c               |  12 +-
 drivers/pci/hotplug/rpadlpar_core.c                |   4 +
 drivers/pci/switch/switchtec.c                     |   3 +-
 drivers/platform/chrome/cros_ec_proto.c            |  11 ++
 drivers/platform/x86/intel_pmc_ipc.c               |   6 +-
 drivers/power/supply/max14656_charger_detector.c   |  14 +--
 drivers/pwm/core.c                                 |  10 +-
 drivers/pwm/pwm-meson.c                            |  25 ++--
 drivers/pwm/pwm-tiehrpwm.c                         |   2 +
 drivers/pwm/sysfs.c                                |  14 +--
 drivers/rapidio/rio_cm.c                           |   8 ++
 drivers/scsi/qla2xxx/qla_gs.c                      |   3 +
 drivers/soc/mediatek/mtk-pmic-wrap.c               |   2 +-
 drivers/soc/renesas/renesas-soc.c                  |   3 +
 drivers/soc/rockchip/grf.c                         |   2 +
 drivers/spi/spi-pxa2xx.c                           |   7 +-
 drivers/thermal/qcom/tsens.c                       |   3 +-
 drivers/thermal/rcar_gen3_thermal.c                |   3 +
 drivers/tty/serial/8250/8250_dw.c                  |   4 +-
 drivers/usb/typec/fusb302/fusb302.c                |   2 +
 drivers/vfio/vfio.c                                |  30 ++---
 drivers/video/fbdev/hgafb.c                        |   2 +
 drivers/video/fbdev/imsttfb.c                      |   5 +
 drivers/watchdog/Kconfig                           |   1 +
 drivers/watchdog/imx2_wdt.c                        |   4 +-
 fs/configfs/dir.c                                  |  17 ++-
 fs/dax.c                                           |   2 +-
 fs/f2fs/f2fs.h                                     |  16 ++-
 fs/f2fs/inode.c                                    |   5 +-
 fs/f2fs/node.c                                     |  20 +++-
 fs/f2fs/recovery.c                                 |  10 +-
 fs/f2fs/segment.c                                  |   9 +-
 fs/f2fs/segment.h                                  |   3 +-
 fs/fat/file.c                                      |  11 +-
 fs/fuse/dev.c                                      |   2 +-
 fs/nfsd/nfs4xdr.c                                  |   4 +
 fs/nfsd/vfs.h                                      |   5 +-
 fs/overlayfs/file.c                                | 130 +++++++++++++++++----
 include/linux/pwm.h                                |   5 -
 include/net/bluetooth/hci_core.h                   |   3 -
 init/initramfs.c                                   |  14 +--
 ipc/mqueue.c                                       |  10 +-
 ipc/msgutil.c                                      |   6 +
 kernel/bpf/verifier.c                              |   2 +-
 kernel/sys.c                                       |   2 +-
 kernel/sysctl.c                                    |   6 +-
 kernel/time/ntp.c                                  |   2 +-
 mm/Kconfig                                         |   2 +-
 mm/cma.c                                           |  23 ++--
 mm/cma_debug.c                                     |   2 +-
 mm/hugetlb.c                                       |  21 +++-
 mm/page_alloc.c                                    |   6 +-
 mm/percpu.c                                        |   9 +-
 mm/rmap.c                                          |   2 +-
 mm/slab.c                                          |   6 +-
 net/bluetooth/hci_conn.c                           |   8 --
 net/netfilter/nf_conntrack_h323_asn1.c             |   2 +-
 net/netfilter/nf_flow_table_core.c                 |  25 ++--
 net/netfilter/nf_flow_table_ip.c                   |   6 +
 net/netfilter/nf_tables_api.c                      |   9 +-
 net/netfilter/nft_flow_offload.c                   |   1 +
 sound/core/seq/seq_clientmgr.c                     |   9 +-
 sound/pci/hda/hda_intel.c                          |   6 +-
 tools/objtool/check.c                              |   8 +-
 124 files changed, 668 insertions(+), 304 deletions(-)


