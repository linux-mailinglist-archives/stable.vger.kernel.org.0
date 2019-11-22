Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACF3106F8A
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbfKVKvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbfKVKvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:51:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF87320715;
        Fri, 22 Nov 2019 10:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419862;
        bh=A810buF4A5yzH6mzGFbUbNWPiRUxcWYqMmSRGZ3hVqQ=;
        h=From:To:Cc:Subject:Date:From;
        b=2t0uTzR8e8MdoKiivwWSQNcWSHWHnBJJtO+Kd5WV0CUsIFPpQgzn6RL/mhwNV1Fw7
         AV97eOuDXWo+beQZwgKq8MdiFmiiwrUwMd7DSPxG/lI8VXqqt60Kb7AI28obu/dQMz
         hTnyUMphDM298GEeOXVEGs5X29rle1bJDAdqlJr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/122] 4.14.156-stable review
Date:   Fri, 22 Nov 2019 11:27:33 +0100
Message-Id: <20191122100722.177052205@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.156-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.156-rc1
X-KernelTest-Deadline: 2019-11-24T10:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.156 release.
There are 122 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.156-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.156-rc1

Takeshi Saito <takeshi.saito.xv@renesas.com>
    mmc: tmio: fix SCC error handling to avoid false positive CRC error

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/time: Fix clockevent_decrementer initalisation for PR KVM

Alan Mikhak <alan.mikhak@sifive.com>
    tools: PCI: Fix broken pcitest compilation

Roger Quadros <rogerq@ti.com>
    ARM: dts: omap5: Fix dual-role mode on Super-Speed port

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_switchdev: Check notification relevance based on upper device

Huibin Hong <huibin.hong@rock-chips.com>
    spi: rockchip: initialize dma_slave_config properly

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: fix sampling/reporting of CCK rates in HT mode

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: fix CCK rate group streams value

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: fix using short preamble CCK rates on HT clients

zhong jiang <zhongjiang@huawei.com>
    misc: cxl: Fix possible null pointer dereference

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_compat: do not dump private area

Nicolin Chen <nicoleotsuka@gmail.com>
    hwmon: (ina3221) Fix INA3221_CONFIG_MODE macros

Thierry Reding <treding@nvidia.com>
    hwmon: (pwm-fan) Silence error on probe deferral

Linus Walleij <linus.walleij@linaro.org>
    pinctrl: gemini: Fix up TVC clock group

Colin Ian King <colin.king@canonical.com>
    orangefs: rate limit the client not running info message

Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
    ARM: 8802/1: Call syscall_trace_exit even when system call skipped

Trent Piepho <tpiepho@impinj.com>
    spi: spidev: Fix OF tree warning logic

Linus Walleij <linus.walleij@linaro.org>
    pinctrl: gemini: Mask and set properly

Hieu Tran Dang <dangtranhieu2012@gmail.com>
    spi: fsl-lpspi: Prevent FIFO under/overrun by default

Marek Vasut <marex@denx.de>
    gpio: syscon: Fix possible NULL ptr usage

Bjorn Helgaas <bhelgaas@google.com>
    x86/kexec: Correct KEXEC_BACKUP_SRC_END off-by-one error

Colin Ian King <colin.king@canonical.com>
    media: cx231xx: fix potential sign-extension overflow on large shift

Tim Smith <tim.smith@citrix.com>
    GFS2: Flush the GFS2 delete workqueue before stopping the kernel threads

Wenwen Wang <wang6495@umn.edu>
    media: isif: fix a NULL pointer dereference bug

He Zhe <zhe.he@windriver.com>
    printk: Give error on attempt to set log buffer length to over 2G

Vignesh R <vigneshr@ti.com>
    mfd: ti_am335x_tscadc: Keep ADC interface on if child is wakeup capable

Nathan Chancellor <natechancellor@gmail.com>
    backlight: lm3639: Unconditionally call led_classdev_unregister

Borislav Petkov <bp@suse.de>
    proc/vmcore: Fix i386 build error of missing copy_oldmem_page_encrypted()

Vasily Gorbik <gor@linux.ibm.com>
    s390/kasan: avoid vdso instrumentation

Rajmohan Mani <rajmohan.mani@intel.com>
    media: dw9714: Fix error handling in probe function

Shenghui Wang <shhuiw@foxmail.com>
    bcache: recal cached_dev_sectors on detach

Geert Uytterhoeven <geert+renesas@glider.be>
    reset: Fix potential use-after-free in __of_reset_control_get()

Dan Carpenter <dan.carpenter@oracle.com>
    fbdev: sbuslib: integer overflow in sbusfb_ioctl_helper()

Dan Carpenter <dan.carpenter@oracle.com>
    fbdev: sbuslib: use checked version of put_user()

Masaharu Hayakawa <masaharu.hayakawa.ry@renesas.com>
    mmc: tmio: Fix SCC error detection

Andy Lutomirski <luto@kernel.org>
    x86/fsgsbase/64: Fix ptrace() to read the FS/GS base accurately

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: don't send keys when entering D3

Ronald Tschalär <ronald@innovation.ch>
    ACPI / SBS: Fix rare oops when removing modules

Li RongQing <lirongqing@baidu.com>
    xfrm: use correct size to initialise sp->ovec

Radu Solea <radu.solea@nxp.com>
    crypto: mxs-dcp - Fix AES issues

Radu Solea <radu.solea@nxp.com>
    crypto: mxs-dcp - Fix SHA null hashes and output length

Wolfram Sang <wsa+renesas@sang-engineering.com>
    dmaengine: rcar-dmac: set scatter/gather max segment size

Borislav Petkov <bp@suse.de>
    x86/olpc: Fix build error with CONFIG_MFD_CS5535=m

Lianbo Jiang <lijiang@redhat.com>
    kexec: Allocate decrypted control pages for kdump if SME is enabled

Suman Anna <s-anna@ti.com>
    remoteproc: Check for NULL firmwares in sysfs interface

Julian Sax <jsbc@gmx.de>
    Input: silead - try firmware reload after unsuccessful resume

Martin Kepplinger <martink@posteo.de>
    Input: st1232 - set INPUT_PROP_DIRECT property

Hans Verkuil <hans.verkuil@cisco.com>
    media: cec-gpio: select correct Signal Free Time

Rami Rosen <ramirose@gmail.com>
    dmaengine: ioat: fix prototype of ioat_enumerate_channels

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.x: fix lock recovery during delegation recall

Florian Fainelli <f.fainelli@gmail.com>
    i2c: brcmstb: Allow enabling the driver on DSL SoCs

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: Use clk_hw API for calling clk framework from clk notifiers

Joonyoung Shim <jy0922.shim@samsung.com>
    clk: samsung: exynos5420: Define CLK_SECKEY gate clock only or Exynos5420

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    qtnfmac: drop error reports for out-of-bounds key indexes

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    qtnfmac: pass sgi rate info flag to wireless core

Chung-Hsien Hsu <stanley.hsu@cypress.com>
    brcmfmac: fix full timeout waiting for action frame on-channel tx

Chung-Hsien Hsu <stanley.hsu@cypress.com>
    brcmfmac: reduce timeout for action frame scan

Borislav Petkov <bp@suse.de>
    cpu/SMT: State SMT is disabled even with nosmt and without "=force"

Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
    mtd: physmap_of: Release resources on error

Johan Hovold <johan@kernel.org>
    USB: serial: cypress_m8: fix interrupt-out transfer length

Cameron Kaiser <spectre@floodgap.com>
    KVM: PPC: Book3S PR: Exiting split hack mode needs to fixup both PC and LR

Michael Pobega <mpobega@neverware.com>
    ALSA: hda/sigmatel - Disable automute for Elo VuPoint

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: i2c: adv748x: Support probing a single output

Nathan Chancellor <natechancellor@gmail.com>
    media: pxa_camera: Fix check for pdev->dev.of_node

Matthias Reichl <hias@horus.com>
    media: rc: ir-rc6-decoder: enable toggle bit for Kathrein RCU-676 remote

Nathan Chancellor <natechancellor@gmail.com>
    ata: ep93xx: Use proper enums for directions

Anton Blanchard <anton@ozlabs.org>
    powerpc/time: Use clockevents_register_device(), fixing an issue with large decrementer

Bob Moore <robert.moore@intel.com>
    ACPICA: Never run _REG on system_memory and system_IO

Nathan Chancellor <natechancellor@gmail.com>
    IB/mlx4: Avoid implicit enumerated type conversion

Wei Yongjun <weiyongjun1@huawei.com>
    IB/mthca: Fix error return code in __mthca_init_one()

Radoslaw Tyl <radoslawx.tyl@intel.com>
    ixgbe: Fix crash with VFs and flow director on interface flap

Nathan Chancellor <natechancellor@gmail.com>
    i40e: Use proper enum in i40e_ndo_set_vf_link_state

Radoslaw Tyl <radoslawx.tyl@intel.com>
    ixgbe: Fix ixgbe TX hangs with XDP_TX beyond queue limit

NeilBrown <neilb@suse.com>
    md: allow metadata updates while suspending an array - fix

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    clocksource/drivers/sh_cmt: Fix clocksource width for 32-bit machines

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    clocksource/drivers/sh_cmt: Fixup for 64-bit machines

Gustavo Pimentel <gustavo.pimentel@synopsys.com>
    tools: PCI: Fix compilation warnings

Chen Yu <yu.c.chen@intel.com>
    PM / hibernate: Check the success of generating md5 digest before hibernation

Nathan Chancellor <natechancellor@gmail.com>
    mtd: rawnand: sh_flctl: Use proper enum for flctl_dma_fifo0_transfer

Tudor Ambarus <tudor.ambarus@microchip.com>
    ARM: dts: at91: at91sam9x5cm: fix addressable nand flash size

Tudor Ambarus <tudor.ambarus@microchip.com>
    ARM: dts: at91: sama5d4_xplained: fix addressable nand flash size

zhong jiang <zhongjiang@huawei.com>
    powerpc/xive: Move a dereference below a NULL test

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/pseries: Fix how we iterate over the DTL entries

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/pseries: Fix DTL buffer registration

Nathan Chancellor <natechancellor@gmail.com>
    cxgb4: Use proper enum in IEEE_FAUX_SYNC

Nathan Chancellor <natechancellor@gmail.com>
    cxgb4: Use proper enum in cxgb4_dcb_handle_fw_update

Dan Carpenter <dan.carpenter@oracle.com>
    mei: samples: fix a signedness bug in amt_host_if_call()

Chuck Lever <chuck.lever@oracle.com>
    sunrpc: Fix connect metrics

Nishanth Menon <nm@ti.com>
    clk: keystone: Enable TISCI clocks if K3_ARCH

Gabriel Krisman Bertazi <krisman@collabora.co.uk>
    ext4: fix build error when DX_DEBUG is defined

Nathan Chancellor <natechancellor@gmail.com>
    dmaengine: timb_dma: Use proper enum in td_prep_slave_sg

Nathan Chancellor <natechancellor@gmail.com>
    dmaengine: ep93xx: Return proper enum in ep93xx_dma_chan_direction

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Inform the userspace about TCE update failures

Guenter Roeck <linux@roeck-us.net>
    watchdog: w83627hf_wdt: Support NCT6796D, NCT6797D, NCT6798D

Miquel Raynal <miquel.raynal@bootlin.com>
    irqchip/irq-mvebu-icu: Fix wrong private data retrieval

Andrew Zaborowski <andrew.zaborowski@intel.com>
    nl80211: Fix a GET_KEY reply attribute

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Check ENBLSLPM before sending ep command

Jia-Ju Bai <baijiaju1990@gmail.com>
    usb: gadget: udc: fotg210-udc: Fix a sleep-in-atomic-context bug in fotg210_get_status()

Simon Wunderlich <sw@simonwunderlich.de>
    ath9k: fix reporting calculated new FFT upper max

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Allow using driver or DSL SoCs

Ben Greear <greearb@candelatech.com>
    ath10k: fix vdev-start timeout on error

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/numa: Report correct memblock range for the dummy node

Suzuki K Poulose <suzuki.poulose@arm.com>
    kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table

Robin Murphy <robin.murphy@arm.com>
    iommu/io-pgtable-arm: Fix race handling in split_blk_unmap()

Dennis Dalessandro <dennis.dalessandro@intel.com>
    IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Fix priority queue fairness

Philipp Rossak <embed3d@gmail.com>
    ARM: dts: sun8i: h3-h5: ir register size should be the whole memory block

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: return correct errno in f2fs_gc

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: Fix for netdev not up problem when setting mtu

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: omap5: enable OTG role for DWC3 controller

Vignesh R <vigneshr@ti.com>
    ARM: dts: dra7: Enable workaround for errata i870 in PCIe host mode

YueHaibing <yuehaibing@huawei.com>
    net: xen-netback: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: ovs: fix return type of ndo_start_xmit function

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbdev: Ditch fb_edid_add_monspecs

Pavel Tatashin <pasha.tatashin@soleen.com>
    arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: fix updating the node span

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: don't access uninitialized memmaps in shrink_pgdat_span()

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: Fix idr_get_next race with idr_remove

Dan Carpenter <dan.carpenter@oracle.com>
    net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "OPP: Protect dev_list with opp_table lock"

Julia Lawall <Julia.Lawall@lip6.fr>
    tee: optee: add missing of_node_put after of_device_is_available

Leilk Liu <leilk.liu@mediatek.com>
    spi: mediatek: use correct mata->xfer_len when in fifo transfer


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/at91-sama5d4_xplained.dts        |   2 +-
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |   2 +-
 arch/arm/boot/dts/dra7.dtsi                        |   2 +
 arch/arm/boot/dts/omap5-board-common.dtsi          |   5 +
 arch/arm/boot/dts/sunxi-h3-h5.dtsi                 |   2 +-
 arch/arm/kernel/entry-common.S                     |   9 +-
 arch/arm64/lib/clear_user.S                        |   1 +
 arch/arm64/lib/copy_from_user.S                    |   1 +
 arch/arm64/lib/copy_in_user.S                      |   1 +
 arch/arm64/lib/copy_to_user.S                      |   1 +
 arch/arm64/mm/numa.c                               |   2 +-
 arch/powerpc/kernel/time.c                         |  19 ++--
 arch/powerpc/kvm/book3s.c                          |   3 +
 arch/powerpc/kvm/book3s_64_vio.c                   |   8 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c                |   6 +-
 arch/powerpc/platforms/pseries/dtl.c               |   4 +-
 arch/powerpc/sysdev/xive/common.c                  |   7 +-
 arch/s390/kernel/vdso32/Makefile                   |   3 +-
 arch/s390/kernel/vdso64/Makefile                   |   3 +-
 arch/x86/Kconfig                                   |   3 +-
 arch/x86/include/asm/kexec.h                       |   2 +-
 arch/x86/kernel/ptrace.c                           |  62 ++++++++++--
 arch/x86/power/hibernate_64.c                      |  11 +--
 drivers/acpi/acpica/acevents.h                     |   2 +
 drivers/acpi/acpica/aclocal.h                      |   2 +-
 drivers/acpi/acpica/evregion.c                     |  17 +++-
 drivers/acpi/acpica/evrgnini.c                     |   6 +-
 drivers/acpi/acpica/evxfregn.c                     |   1 -
 drivers/acpi/osl.c                                 |   1 +
 drivers/acpi/sbshc.c                               |   2 +
 drivers/ata/Kconfig                                |   3 +-
 drivers/ata/pata_ep93xx.c                          |   8 +-
 drivers/base/power/opp/core.c                      |  21 +---
 drivers/base/power/opp/cpu.c                       |   2 -
 drivers/base/power/opp/opp.h                       |   2 +-
 drivers/clk/Makefile                               |   1 +
 drivers/clk/keystone/Kconfig                       |   2 +-
 drivers/clk/samsung/clk-cpu.c                      |   6 +-
 drivers/clk/samsung/clk-cpu.h                      |   2 +-
 drivers/clk/samsung/clk-exynos5420.c               |   3 +-
 drivers/clocksource/sh_cmt.c                       |  78 +++++++--------
 drivers/crypto/mxs-dcp.c                           |  80 ++++++++++++---
 drivers/dma/ioat/init.c                            |   7 +-
 drivers/dma/sh/rcar-dmac.c                         |   3 +
 drivers/dma/timb_dma.c                             |   2 +-
 drivers/gpio/gpio-syscon.c                         |   2 +-
 drivers/hwmon/ina3221.c                            |   6 +-
 drivers/hwmon/pwm-fan.c                            |   8 +-
 drivers/i2c/busses/Kconfig                         |   7 +-
 drivers/infiniband/hw/mthca/mthca_main.c           |   3 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c   |   3 +-
 drivers/input/touchscreen/silead.c                 |  13 +++
 drivers/input/touchscreen/st1232.c                 |   1 +
 drivers/iommu/io-pgtable-arm.c                     |   9 +-
 drivers/irqchip/irq-mvebu-icu.c                    |   2 +-
 drivers/md/bcache/super.c                          |   1 +
 drivers/md/md.c                                    |  22 +++--
 drivers/media/cec/cec-pin.c                        |  20 ++++
 drivers/media/i2c/adv748x/adv748x-core.c           |  25 ++++-
 drivers/media/i2c/adv748x/adv748x-csi2.c           |  18 ++--
 drivers/media/i2c/adv748x/adv748x.h                |   2 +
 drivers/media/i2c/dw9714.c                         |   3 +-
 drivers/media/platform/davinci/isif.c              |   3 +-
 drivers/media/platform/pxa_camera.c                |   2 +-
 drivers/media/rc/ir-rc6-decoder.c                  |   9 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   2 +-
 drivers/mfd/ti_am335x_tscadc.c                     |  13 +++
 drivers/misc/cxl/guest.c                           |   2 -
 drivers/mmc/host/tmio_mmc_core.c                   |   5 +-
 drivers/mtd/maps/physmap_of_core.c                 |  27 +----
 drivers/mtd/nand/sh_flctl.c                        |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c     |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h     |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  24 +++--
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   9 +-
 drivers/net/usb/cdc_ncm.c                          |   2 +-
 drivers/net/wireless/ath/ath10k/core.h             |   1 +
 drivers/net/wireless/ath/ath10k/mac.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  19 +++-
 drivers/net/wireless/ath/ath10k/wmi.h              |   8 +-
 drivers/net/wireless/ath/ath9k/common-spectral.c   |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  26 +++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   4 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  13 ++-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   3 +
 drivers/net/xen-netback/interface.c                |   3 +-
 drivers/pinctrl/pinctrl-gemini.c                   |  47 +++++++--
 drivers/remoteproc/remoteproc_sysfs.c              |   5 +
 drivers/reset/core.c                               |  15 +--
 drivers/spi/spi-fsl-lpspi.c                        |   2 +-
 drivers/spi/spi-mt65xx.c                           |   4 +-
 drivers/spi/spi-rockchip.c                         |   3 +
 drivers/spi/spidev.c                               |   8 +-
 drivers/tee/optee/core.c                           |   4 +-
 drivers/usb/dwc3/gadget.c                          |  29 ++++--
 drivers/usb/gadget/udc/fotg210-udc.c               |   2 +-
 drivers/usb/serial/cypress_m8.c                    |   2 +-
 drivers/video/backlight/lm3639_bl.c                |   6 +-
 drivers/video/fbdev/core/fbmon.c                   |  95 ------------------
 drivers/video/fbdev/core/modedb.c                  |  57 -----------
 drivers/video/fbdev/sbuslib.c                      |  28 +++---
 drivers/watchdog/w83627hf_wdt.c                    |   8 +-
 fs/ext4/namei.c                                    |   2 +-
 fs/f2fs/gc.c                                       |   2 +-
 fs/gfs2/super.c                                    |   2 +-
 fs/nfs/delegation.c                                |   6 +-
 fs/orangefs/orangefs-sysfs.c                       |   2 +-
 fs/proc/vmcore.c                                   |  10 ++
 include/linux/fb.h                                 |   3 -
 include/linux/platform_data/dma-ep93xx.h           |   2 +-
 include/linux/sunrpc/sched.h                       |   2 -
 include/rdma/ib_verbs.h                            |   2 +-
 kernel/cpu.c                                       |   1 +
 kernel/kexec_core.c                                |   6 ++
 kernel/printk/printk.c                             |  18 ++--
 lib/idr.c                                          |  20 +++-
 mm/memory_hotplug.c                                |  77 ++++-----------
 net/mac80211/rc80211_minstrel_ht.c                 |  20 ++--
 net/netfilter/nft_compat.c                         |  24 ++++-
 net/openvswitch/vport-internal_dev.c               |   5 +-
 net/sunrpc/sched.c                                 | 109 ++++++++++-----------
 net/sunrpc/xprt.c                                  |  14 +--
 net/sunrpc/xprtrdma/transport.c                    |   6 +-
 net/sunrpc/xprtsock.c                              |  10 +-
 net/wireless/nl80211.c                             |   2 +-
 net/xfrm/xfrm_input.c                              |   2 +-
 samples/mei/mei-amt-version.c                      |   2 +-
 sound/pci/hda/patch_sigmatel.c                     |  20 ++++
 tools/pci/pcitest.c                                |   7 +-
 tools/testing/radix-tree/idr-test.c                |  52 ++++++++++
 virt/kvm/arm/mmu.c                                 |   3 +-
 135 files changed, 857 insertions(+), 649 deletions(-)


