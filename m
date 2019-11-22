Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56AE91070D0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKVKjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:39:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728823AbfKVKjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:39:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D187E20721;
        Fri, 22 Nov 2019 10:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419191;
        bh=4EDZy6+jCjIVIWjH+YWPAbflSqJ9/JkJU6kFS110OyU=;
        h=From:To:Cc:Subject:Date:From;
        b=ZkO51tf0hRAZRamHP4iY4I4tFoqtssvGq3xhTqZyaC5RkIGncJRAvlXe7fISDgYB9
         4gUM8dt3lAnDzsPHFnXSBs4zdnlcdGfC2plE1La+lXx8Qm2qOry/Mt2O0qy9XbsEnU
         mtDtTS7La6N9c/ihkZss//e8EY2/7tVR6P5qLaiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/222] 4.9.203-stable review
Date:   Fri, 22 Nov 2019 11:25:40 +0100
Message-Id: <20191122100830.874290814@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.203-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.203-rc1
X-KernelTest-Deadline: 2019-11-24T10:09+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.203 release.
There are 222 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.203-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.203-rc1

Pavel Tatashin <pasha.tatashin@soleen.com>
    arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault

Roger Quadros <rogerq@ti.com>
    ARM: dts: omap5: Fix dual-role mode on Super-Speed port

Huibin Hong <huibin.hong@rock-chips.com>
    spi: rockchip: initialize dma_slave_config properly

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel: fix CCK rate group streams value

zhong jiang <zhongjiang@huawei.com>
    misc: cxl: Fix possible null pointer dereference

Nicolin Chen <nicoleotsuka@gmail.com>
    hwmon: (ina3221) Fix INA3221_CONFIG_MODE macros

Thierry Reding <treding@nvidia.com>
    hwmon: (pwm-fan) Silence error on probe deferral

Colin Ian King <colin.king@canonical.com>
    orangefs: rate limit the client not running info message

Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
    ARM: 8802/1: Call syscall_trace_exit even when system call skipped

Trent Piepho <tpiepho@impinj.com>
    spi: spidev: Fix OF tree warning logic

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

Shenghui Wang <shhuiw@foxmail.com>
    bcache: recal cached_dev_sectors on detach

Geert Uytterhoeven <geert+renesas@glider.be>
    reset: Fix potential use-after-free in __of_reset_control_get()

Dan Carpenter <dan.carpenter@oracle.com>
    fbdev: sbuslib: integer overflow in sbusfb_ioctl_helper()

Dan Carpenter <dan.carpenter@oracle.com>
    fbdev: sbuslib: use checked version of put_user()

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: don't send keys when entering D3

Ronald Tschalär <ronald@innovation.ch>
    ACPI / SBS: Fix rare oops when removing modules

Radu Solea <radu.solea@nxp.com>
    crypto: mxs-dcp - Fix AES issues

Radu Solea <radu.solea@nxp.com>
    crypto: mxs-dcp - Fix SHA null hashes and output length

Borislav Petkov <bp@suse.de>
    x86/olpc: Fix build error with CONFIG_MFD_CS5535=m

Julian Sax <jsbc@gmx.de>
    Input: silead - try firmware reload after unsuccessful resume

Martin Kepplinger <martink@posteo.de>
    Input: st1232 - set INPUT_PROP_DIRECT property

Rami Rosen <ramirose@gmail.com>
    dmaengine: ioat: fix prototype of ioat_enumerate_channels

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.x: fix lock recovery during delegation recall

Florian Fainelli <f.fainelli@gmail.com>
    i2c: brcmstb: Allow enabling the driver on DSL SoCs

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: Use clk_hw API for calling clk framework from clk notifiers

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

Nathan Chancellor <natechancellor@gmail.com>
    media: pxa_camera: Fix check for pdev->dev.of_node

Nathan Chancellor <natechancellor@gmail.com>
    ata: ep93xx: Use proper enums for directions

Bob Moore <robert.moore@intel.com>
    ACPICA: Never run _REG on system_memory and system_IO

Nathan Chancellor <natechancellor@gmail.com>
    IB/mlx4: Avoid implicit enumerated type conversion

Wei Yongjun <weiyongjun1@huawei.com>
    IB/mthca: Fix error return code in __mthca_init_one()

Radoslaw Tyl <radoslawx.tyl@intel.com>
    ixgbe: Fix crash with VFs and flow director on interface flap

Nathan Chancellor <natechancellor@gmail.com>
    mtd: rawnand: sh_flctl: Use proper enum for flctl_dma_fifo0_transfer

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

Nathan Chancellor <natechancellor@gmail.com>
    dmaengine: timb_dma: Use proper enum in td_prep_slave_sg

Nathan Chancellor <natechancellor@gmail.com>
    dmaengine: ep93xx: Return proper enum in ep93xx_dma_chan_direction

Andrew Zaborowski <andrew.zaborowski@intel.com>
    nl80211: Fix a GET_KEY reply attribute

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

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Fix priority queue fairness

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: return correct errno in f2fs_gc

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: omap5: enable OTG role for DWC3 controller

YueHaibing <yuehaibing@huawei.com>
    net: xen-netback: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: ovs: fix return type of ndo_start_xmit function

Jens Axboe <axboe@kernel.dk>
    libata: have ata_scsi_rw_xlat() fail invalid passthrough requests

Christoph Hellwig <hch@lst.de>
    block: introduce blk_rq_is_passthrough

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbdev: Ditch fb_edid_add_monspecs

Masami Hiramatsu <mhiramat@kernel.org>
    uprobes/x86: Prohibit probing on MOV SS instruction

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes/x86: Prohibit probing on exception masking instructions

Peter Zijlstra <peterz@infradead.org>
    x86/atomic: Fix smp_mb__{before,after}_atomic()

Dan Carpenter <dan.carpenter@oracle.com>
    net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()

Jouni Hogander <jouni.hogander@unikie.com>
    slcan: Fix memory leak in error path

zhong jiang <zhongjiang@huawei.com>
    memfd: Use radix_tree_deref_slot_protected to avoid the warning.

Israel Rukshin <israelr@mellanox.com>
    IB/iser: Fix possible NULL deref at iser_inv_desc()

Kirill Tkhai <ktkhai@virtuozzo.com>
    fuse: use READ_ONCE on congestion_threshold and max_background

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix ISOC error when interval is zero

Rob Herring <robh@kernel.org>
    ARM: dts: lpc32xx: Fix SPI controller node names

Rob Herring <robh@kernel.org>
    arm64: dts: lg: Fix SPI controller node names

Rob Herring <robh@kernel.org>
    arm64: dts: amd: Fix SPI bus warnings

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Handle BUS FREE during reselection

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Don't call dsprintk() following reselection interrupt

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Don't clear busy flag when abort fails

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Check for invalid reselection target

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Use DRIVER_SENSE to indicate valid sense data

Hannes Reinecke <hare@suse.com>
    scsi: NCR5380: Clear all unissued commands on host reset

Dan Aloni <dan@kernelim.com>
    crypto: fix a memory leak in rsa-kcs1pad's encryption mode

Christoph Manszewski <c.manszewski@samsung.com>
    crypto: s5p-sss: Fix Fix argument list alignment

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Detect if remote is not able to use the whole MPS

Rob Herring <robh@kernel.org>
    ARM: dts: realview: Fix SPI controller node names

Justin Ernst <justin.ernst@hpe.com>
    EDAC: Raise the maximum number of memory controllers

YueHaibing <yuehaibing@huawei.com>
    net: smsc: fix return type of ndo_start_xmit function

Marc Dietrich <marvin24@gmx.de>
    ARM: dts: paz00: fix wakeup gpio keycode

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: tegra: apalis_t30: fix mmc1 cmd pull-up

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: tegra30: fix xcvr-setup-use-fuses

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: always unregister the old device if going to discover new

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Mask buggy SR-IOV VF INTx support

Li Qiang <liq3ea@gmail.com>
    vfio/pci: Fix potential memory leak in vfio_msi_cap_len

zhong jiang <zhongjiang@huawei.com>
    misc: genwqe: should return proper error value.

Laura Abbott <labbott@redhat.com>
    misc: kgdbts: Fix restrict error

Leo Yan <leo.yan@linaro.org>
    coresight: tmc: Fix byte-address alignment for RRP

Tomasz Nowicki <tnowicki@caviumnetworks.com>
    coresight: etm4x: Configure EL2 exception level when kernel is running in HYP

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: Fix handling of sinks

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: gadget: uvc: Only halt video streaming endpoint in bulk mode

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: gadget: uvc: Factor out video USB request queueing

Andreas Kemnade <andreas@kemnade.info>
    phy: phy-twl4030-usb: fix denied runtime access

Joel Pepper <joel.pepper@rwth-aachen.de>
    usb: gadget: uvc: configfs: Prevent format changes after linking header

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: gadget: uvc: configfs: Drop leaked references to config items

Nathan Chancellor <natechancellor@gmail.com>
    media: davinci: Fix implicit enum conversion warning

Brad Love <brad@nextdimension.cc>
    media: au0828: Fix incorrect error messages

Jia-Ju Bai <baijiaju1990@gmail.com>
    media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()

Dengcheng Zhu <dzhu@wavecomp.com>
    MIPS: kexec: Relax memory restriction

Matthew Whitehead <tedheadster@gmail.com>
    x86/CPU: Use correct macros for Cyrix calls

YueHaibing <yuehaibing@huawei.com>
    net: micrel: fix return type of ndo_start_xmit function

Shahed Shaikh <Shahed.Shaikh@cavium.com>
    bnx2x: Ignore bandwidth attention in single function mode

Rob Herring <robh@kernel.org>
    ARM: dts: marvell: Fix SPI and I2C bus warnings

Stefan Agner <stefan@agner.ch>
    cpufeature: avoid warning when compiling with clang

Nathan Chancellor <natechancellor@gmail.com>
    spi: pic32: Use proper enum in dmaengine_prep_slave_rg

Rob Herring <robh@kernel.org>
    ARM: dts: ste: Fix SPI controller node names

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix LCDA clock line muxing

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: ux500: Correct SCU unit address

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to recover inode's uid/gid during POR

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: dts: am335x-evm: fix number of cpsw

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum: Init shaper for TCs 8..15

Loic Poulain <loic.poulain@linaro.org>
    usb: chipidea: Fix otg event handler

Nicolas Adell <nicolas.adell@actia.fr>
    usb: chipidea: imx: enable OTG overcurrent in case USB subsystem is already started

YueHaibing <yuehaibing@huawei.com>
    net: amd: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: broadcom: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: xilinx: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: toshiba: fix return type of ndo_start_xmit function

Andreas Kemnade <andreas@kemnade.info>
    power: supply: twl4030_charger: disable eoc interrupt on linear charge

Andreas Kemnade <andreas@kemnade.info>
    power: supply: twl4030_charger: fix charging current out-of-bounds

Rob Herring <robh@kernel.org>
    libfdt: Ensure INT_MAX is defined in libfdt_env.h

Håkon Bugge <Haakon.Bugge@oracle.com>
    RDMA/i40iw: Fix incorrect iterator type

Nathan Fontenot <nfont@linux.vnet.ibm.com>
    powerpc/pseries: Disable CPU hotplug across migrations

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/hash: Fix stab_rr off by one initialization

Breno Leitao <leitao@debian.org>
    powerpc/iommu: Avoid derefence before pointer check

Anton Vasilyev <vasilyev@ispras.ru>
    serial: mxs-auart: Fix potential infinite loop

Sinan Kaya <okaya@kernel.org>
    PCI/ACPI: Correct error message for ASPM disabling

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: invoke softirqs after napi_schedule()

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k: Fix a locking bug in ath9k_add_interface()

Rob Herring <robh@kernel.org>
    ARM: dts: rockchip: Fix erroneous SPI bus dtc warnings on rk3036

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    ip_gre: fix parsing gre header in ipgre_err

Bernd Edlinger <bernd.edlinger@hotmail.de>
    kernfs: Fix range checks in kernfs_get_target_path

Banajit Goswami <bgoswami@codeaurora.org>
    component: fix loop condition to call unbind() if bind() fails

Tomasz Figa <tomasz.figa@gmail.com>
    power: supply: max8998-charger: Fix platform data retrieval

Claudiu Beznea <claudiu.beznea@microchip.com>
    power: reset: at91-poweroff: do not procede if at91_shdwc is allocated

Dan Carpenter <dan.carpenter@oracle.com>
    power: supply: ab8500_fg: silence uninitialized variable warnings

Ganesh Goudar <ganeshgr@chelsio.com>
    cxgb4: Fix endianness issue in t4_fwcache()

Ludovic Desroches <ludovic.desroches@microchip.com>
    pinctrl: at91: don't use the same irqchip with multiple gpiochips

Dinh Nguyen <dinguyen@kernel.org>
    ARM: dts: socfpga: Fix I2C bus unit-address error

Alan Modra <amodra@gmail.com>
    powerpc/vdso: Correct call frame information

Christian Lamparter <chunkeey@gmail.com>
    ARM: dts: qcom: ipq4019: fix cpu0's qcom,saw2 reg value

Cong Wang <xiyou.wangcong@gmail.com>
    llc: avoid blocking in llc_sap_close()

Dan Carpenter <dan.carpenter@oracle.com>
    pinctrl: at91-pio4: fix has_config check in atmel_pctl_dt_subnode_to_map()

Takashi Iwai <tiwai@suse.de>
    ALSA: intel8x0m: Register irq handler after register initializations

Arnd Bergmann <arnd@arndb.de>
    media: dvb: fix compat ioctl translation

Lao Wei <zrlw@qq.com>
    media: fix: media: pci: meye: validate offset to avoid arbitrary access

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    nvmem: core: return error code instead of NULL from nvmem_device_get

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Don't call BUG_ON() if there is a kprobe in use on free list

Deepak Ukey <deepak.ukey@microchip.com>
    scsi: pm80xx: Fixed system hang issue during kexec boot

Deepak Ukey <deepak.ukey@microchip.com>
    scsi: pm80xx: Corrected dma_unmap_sg() parameter

Oleksij Rempel <o.rempel@pengutronix.de>
    ARM: imx6: register pm_power_off handler if "fsl,pmic-stby-poweroff" is set

George Kennedy <george.kennedy@oracle.com>
    scsi: sym53c8xx: fix NULL pointer dereference panic in sym_int_sir()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix memory leak of percpu counter in fill_super()

Eric W. Biederman <ebiederm@xmission.com>
    signal: Properly deliver SIGSEGV from x86 uprobes

Eric W. Biederman <ebiederm@xmission.com>
    signal: Properly deliver SIGILL from uprobes

Eric W. Biederman <ebiederm@xmission.com>
    signal: Always ignore SIGKILL and SIGSTOP sent to the global init

Felix Fietkau <nbd@nbd.name>
    ath9k: add back support for using active monitor interfaces for tx99

Daniel Silsby <dansilsby@gmail.com>
    dmaengine: dma-jz4780: Further residue status fix

Paul Cercueil <paul@crapouillou.net>
    dmaengine: dma-jz4780: Don't depend on MACH_JZ4780

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: omap3-gta04: keep vpll2 always on

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: omap3-gta04: make NAND partitions compatible with recent U-Boot

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: omap3-gta04: fix touchscreen tsc2007

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: omap3-gta04: tvout: enable as display1 alias

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: omap3-gta04: fixes for tvout / venc

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: omap3-gta04: give spi_lcd node a label so that we can overwrite in other DTS files

Rob Herring <robh@kernel.org>
    of: make PowerMac cache node search conditional on CONFIG_PPC_PMAC

Yong Zhi <yong.zhi@intel.com>
    ASoC: Intel: hdac_hdmi: Limit sampling rates at dai creation

Ding Xiang <dingxiang@cmss.chinamobile.com>
    mips: txx9: fix iounmap related issue

Erik Stromdahl <erik.stromdahl@gmail.com>
    ath10k: wmi: disable softirq's while calling ieee80211_rx

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Disable pull control for S5M8767 PMIC

Colin Ian King <colin.king@canonical.com>
    ASoC: sgtl5000: avoid division by zero if lo_vag is zero

Stefan Wahren <stefan.wahren@i2se.com>
    net: lan78xx: Bail out if lan78xx_get_endpoints fails

Larry Finger <Larry.Finger@lwfinger.net>
    rtl8187: Fix warning generated when strncpy() destination length matches the sixe argument

Marcel Ziswiler <marcel@ziswiler.com>
    ARM: dts: pxa: fix power i2c base address

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: avoid sending too many BARs

Vijay Immanuel <vijayi@attalasystems.com>
    IB/rxe: fixes for rdma read retry

Patryk Małek <patryk.malek@intel.com>
    i40e: Prevent deleting MAC address from VF when set by PF

Patryk Małek <patryk.malek@intel.com>
    i40e: hold the rtnl lock on clearing interrupt scheme

Mitch Williams <mitch.a.williams@intel.com>
    i40e: use correct length for strncpy

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Fix regulators configuration on Peach Pi/Pit Chromebooks

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Fix sound in Snow-rev5 Chromebook

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    MIPS: BCM47XX: Enable USB power on Netgear WNDR3400v3

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dpcm: Properly initialise hw->rate_max

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't set GFS2_RDF_UPTODATE when the lvb is updated

Felix Fietkau <nbd@nbd.name>
    ath9k: fix tx99 with monitor mode interface

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Do error checks at creating system ports

Rajeev Kumar Sirasanagandla <rsirasan@codeaurora.org>
    cfg80211: Avoid regulatory restore when COUNTRY_IE_IGNORE is set

Jay Foster <jayfoster@ieee.org>
    ARM: dts: at91/trivial: Fix USART1 definition for at91sam9g45

Aapo Vienamo <avienamo@nvidia.com>
    arm64: dts: tegra210-p2180: Correct sdmmc4 vqmmc-supply

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: pcm: signedness bug in snd_pcm_plug_alloc()

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: dac: mcp4922: fix error handling in mcp4922_write_raw

Tamizh chelvam <tamizhr@codeaurora.org>
    ath10k: fix kernel panic by moving pci flush after napi_disable

Eugen Hristev <eugen.hristev@microchip.com>
    mmc: sdhci-of-at91: fix quirk2 overwrite

Roman Gushchin <guro@fb.com>
    mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()

Roman Gushchin <guro@fb.com>
    mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()

Eric Auger <eric.auger@redhat.com>
    iommu/vt-d: Fix QI_DEV_IOTLB_PFSID and QI_DEV_EIOTLB_PFSID macros

Al Viro <viro@zeniv.linux.org.uk>
    ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable either

Al Viro <viro@zeniv.linux.org.uk>
    ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable

James Erwin <james.erwin@intel.com>
    IB/hfi1: Ensure full Gen3 speed in a Gen4 system

Chuhong Yuan <hslester96@gmail.com>
    Input: synaptics-rmi4 - destroy F54 poller workqueue when removing

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - clear IRQ enables for F54

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - fix video buffer size

Oliver Neukum <oneukum@suse.com>
    Input: ff-memless - kill timer in destroy()

Henry Lin <henryl@nvidia.com>
    ALSA: usb-audio: not submit urb for stopped endpoint

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix missing error check at mixer resolution test

Jouni Hogander <jouni.hogander@unikie.com>
    slip: Fix memory leak in slip_open error path

Oliver Neukum <oneukum@suse.com>
    ax88172a: fix information leak on short answers


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/compressed/libfdt_env.h              |   2 +
 arch/arm/boot/dts/am335x-evm.dts                   |  12 +--
 arch/arm/boot/dts/arm-realview-eb.dtsi             |   2 +-
 arch/arm/boot/dts/arm-realview-pb1176.dts          |   2 +-
 arch/arm/boot/dts/arm-realview-pb11mp.dts          |   2 +-
 arch/arm/boot/dts/arm-realview-pbx.dtsi            |   2 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   2 +-
 arch/arm/boot/dts/dove-cubox.dts                   |   2 +-
 arch/arm/boot/dts/dove.dtsi                        |   6 +-
 arch/arm/boot/dts/exynos5250-arndale.dts           |   9 ++
 arch/arm/boot/dts/exynos5250-snow-rev5.dts         |  11 +++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |   3 +
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |   3 +
 arch/arm/boot/dts/lpc32xx.dtsi                     |   4 +-
 arch/arm/boot/dts/omap3-gta04.dtsi                 |  49 ++++++---
 arch/arm/boot/dts/omap5-board-common.dtsi          |   5 +
 arch/arm/boot/dts/orion5x-linkstation.dtsi         |   2 +-
 arch/arm/boot/dts/pxa27x.dtsi                      |   2 +-
 arch/arm/boot/dts/qcom-ipq4019.dtsi                |   2 +-
 arch/arm/boot/dts/rk3036.dtsi                      |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts  |   2 +-
 arch/arm/boot/dts/ste-dbx5x0.dtsi                  |   6 +-
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi     |   8 +-
 arch/arm/boot/dts/ste-hrefprev60.dtsi              |   2 +-
 arch/arm/boot/dts/ste-snowball.dts                 |   2 +-
 arch/arm/boot/dts/ste-u300.dts                     |   2 +-
 arch/arm/boot/dts/tegra20-paz00.dts                |   6 +-
 arch/arm/boot/dts/tegra30-apalis.dtsi              |   6 +-
 arch/arm/boot/dts/tegra30.dtsi                     |   6 +-
 arch/arm/boot/dts/versatile-ab.dts                 |   2 +-
 arch/arm/kernel/entry-common.S                     |   9 +-
 arch/arm/kvm/mmu.c                                 |   3 +-
 arch/arm/mach-imx/pm-imx6.c                        |  25 +++++
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi       |   4 +-
 arch/arm64/boot/dts/lg/lg1312.dtsi                 |   4 +-
 arch/arm64/boot/dts/lg/lg1313.dtsi                 |   4 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |   1 +
 arch/arm64/lib/clear_user.S                        |   2 +
 arch/arm64/lib/copy_from_user.S                    |   2 +
 arch/arm64/lib/copy_in_user.S                      |   2 +
 arch/arm64/lib/copy_to_user.S                      |   2 +
 arch/arm64/mm/numa.c                               |   2 +-
 arch/mips/bcm47xx/workarounds.c                    |   8 +-
 arch/mips/include/asm/kexec.h                      |   6 +-
 arch/mips/txx9/generic/setup.c                     |   5 +-
 arch/powerpc/boot/libfdt_env.h                     |   2 +
 arch/powerpc/kernel/iommu.c                        |   2 +-
 arch/powerpc/kernel/rtas.c                         |   2 +
 arch/powerpc/kernel/vdso32/datapage.S              |   1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |   1 +
 arch/powerpc/kernel/vdso64/datapage.S              |   1 +
 arch/powerpc/kernel/vdso64/gettimeofday.S          |   1 +
 arch/powerpc/kvm/book3s.c                          |   3 +
 arch/powerpc/mm/slb.c                              |   2 +-
 arch/powerpc/platforms/pseries/dtl.c               |   4 +-
 arch/s390/kernel/vdso32/Makefile                   |   3 +-
 arch/s390/kernel/vdso64/Makefile                   |   3 +-
 arch/x86/Kconfig                                   |   3 +-
 arch/x86/include/asm/atomic.h                      |   8 +-
 arch/x86/include/asm/atomic64_64.h                 |   8 +-
 arch/x86/include/asm/barrier.h                     |   4 +-
 arch/x86/include/asm/insn.h                        |  18 ++++
 arch/x86/include/asm/kexec.h                       |   2 +-
 arch/x86/kernel/cpu/cyrix.c                        |   2 +-
 arch/x86/kernel/kprobes/core.c                     |   4 +
 arch/x86/kernel/uprobes.c                          |   6 +-
 crypto/rsa-pkcs1pad.c                              |   9 --
 drivers/acpi/acpica/acevents.h                     |   2 +
 drivers/acpi/acpica/aclocal.h                      |   2 +-
 drivers/acpi/acpica/evregion.c                     |  17 +++-
 drivers/acpi/acpica/evrgnini.c                     |   6 +-
 drivers/acpi/acpica/evxfregn.c                     |   1 -
 drivers/acpi/osl.c                                 |   1 +
 drivers/acpi/pci_root.c                            |   5 +-
 drivers/acpi/sbshc.c                               |   2 +
 drivers/ata/Kconfig                                |   3 +-
 drivers/ata/libata-scsi.c                          |  21 ++++
 drivers/ata/pata_ep93xx.c                          |   8 +-
 drivers/base/component.c                           |   6 +-
 drivers/clk/samsung/clk-cpu.c                      |   6 +-
 drivers/clk/samsung/clk-cpu.h                      |   2 +-
 drivers/crypto/mxs-dcp.c                           |  80 ++++++++++++---
 drivers/crypto/s5p-sss.c                           |   4 +-
 drivers/dma/Kconfig                                |   2 +-
 drivers/dma/dma-jz4780.c                           |   2 +-
 drivers/dma/ioat/init.c                            |   7 +-
 drivers/dma/timb_dma.c                             |   2 +-
 drivers/gpio/gpio-syscon.c                         |   2 +-
 drivers/hwmon/ina3221.c                            |   6 +-
 drivers/hwmon/pwm-fan.c                            |   8 +-
 drivers/hwtracing/coresight/coresight-etm4x.c      |  40 ++++----
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |   4 +-
 drivers/hwtracing/coresight/coresight.c            |  22 +++--
 drivers/i2c/busses/Kconfig                         |   7 +-
 drivers/iio/dac/mcp4922.c                          |  11 ++-
 drivers/infiniband/hw/hfi1/pcie.c                  |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   2 +-
 drivers/infiniband/hw/mthca/mthca_main.c           |   3 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |  21 +++-
 drivers/infiniband/sw/rxe/rxe_req.c                |  15 +--
 drivers/infiniband/ulp/iser/iser_initiator.c       |  18 +++-
 drivers/input/ff-memless.c                         |   9 ++
 drivers/input/rmi4/rmi_f54.c                       |   5 +-
 drivers/input/touchscreen/silead.c                 |  13 +++
 drivers/input/touchscreen/st1232.c                 |   1 +
 drivers/md/bcache/super.c                          |   1 +
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   2 +-
 drivers/media/pci/meye/meye.c                      |   2 +-
 drivers/media/platform/davinci/isif.c              |   3 +-
 drivers/media/platform/davinci/vpbe_display.c      |   2 +-
 drivers/media/platform/pxa_camera.c                |   2 +-
 drivers/media/usb/au0828/au0828-core.c             |   4 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   2 +-
 drivers/mfd/ti_am335x_tscadc.c                     |  13 +++
 drivers/misc/cxl/guest.c                           |   2 -
 drivers/misc/genwqe/card_utils.c                   |  13 +--
 drivers/misc/kgdbts.c                              |  16 ++-
 drivers/mmc/host/sdhci-of-at91.c                   |   2 +-
 drivers/mtd/maps/physmap_of.c                      |  27 +----
 drivers/mtd/nand/sh_flctl.c                        |   4 +-
 drivers/net/can/slcan.c                            |   1 +
 drivers/net/ethernet/amd/am79c961a.c               |   2 +-
 drivers/net/ethernet/amd/atarilance.c              |   6 +-
 drivers/net/ethernet/amd/declance.c                |   2 +-
 drivers/net/ethernet/amd/sun3lance.c               |   6 +-
 drivers/net/ethernet/amd/sunlance.c                |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   4 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |   5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  10 ++
 drivers/net/ethernet/broadcom/sb1250-mac.c         |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c     |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h     |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   8 ++
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  10 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  10 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   7 ++
 drivers/net/ethernet/micrel/ks8695net.c            |   2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |   4 +-
 drivers/net/ethernet/smsc/smc911x.c                |   3 +-
 drivers/net/ethernet/smsc/smc91x.c                 |   3 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   3 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |   4 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.h       |   2 +-
 drivers/net/ethernet/toshiba/spider_net.c          |   4 +-
 drivers/net/ethernet/toshiba/tc35815.c             |   6 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   3 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   3 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   9 +-
 drivers/net/slip/slip.c                            |   1 +
 drivers/net/usb/ax88172a.c                         |   2 +-
 drivers/net/usb/cdc_ncm.c                          |   2 +-
 drivers/net/usb/lan78xx.c                          |   5 +
 drivers/net/wireless/ath/ath10k/ahb.c              |   4 +-
 drivers/net/wireless/ath/ath10k/core.h             |   1 +
 drivers/net/wireless/ath/ath10k/mac.c              |   2 +-
 drivers/net/wireless/ath/ath10k/pci.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  22 ++++-
 drivers/net/wireless/ath/ath10k/wmi.h              |   8 +-
 drivers/net/wireless/ath/ath9k/common-spectral.c   |   2 +-
 drivers/net/wireless/ath/ath9k/main.c              |   1 -
 drivers/net/wireless/ath/ath9k/tx99.c              |  10 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  26 +++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   8 ++
 .../net/wireless/realtek/rtl818x/rtl8187/leds.c    |   2 +-
 drivers/net/xen-netback/interface.c                |   3 +-
 drivers/nvmem/core.c                               |   2 +-
 drivers/of/base.c                                  |   2 +-
 drivers/phy/phy-twl4030-usb.c                      |  29 ++++++
 drivers/pinctrl/pinctrl-at91-pio4.c                |   8 +-
 drivers/pinctrl/pinctrl-at91.c                     |  28 +++---
 drivers/power/reset/at91-sama5d2_shdwc.c           |   3 +
 drivers/power/supply/ab8500_fg.c                   |  31 +++---
 drivers/power/supply/max8998_charger.c             |   2 +-
 drivers/power/supply/twl4030_charger.c             |  30 +++++-
 drivers/reset/core.c                               |  15 +--
 drivers/s390/net/qeth_l2_main.c                    |   3 +
 drivers/s390/net/qeth_l3_main.c                    |   3 +
 drivers/scsi/NCR5380.c                             |  42 +++++---
 drivers/scsi/libsas/sas_expander.c                 |  13 +--
 drivers/scsi/pm8001/pm8001_hwi.c                   |   6 ++
 drivers/scsi/pm8001/pm8001_sas.c                   |   9 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |   1 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  80 +++++++++++++--
 drivers/scsi/pm8001/pm80xx_hwi.h                   |   3 +
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |  15 ++-
 drivers/spi/spi-pic32.c                            |   4 +-
 drivers/spi/spi-rockchip.c                         |   3 +
 drivers/spi/spidev.c                               |   8 +-
 drivers/tty/serial/mxs-auart.c                     |   3 +-
 drivers/usb/chipidea/otg.c                         |   9 +-
 drivers/usb/chipidea/usbmisc_imx.c                 |   2 +
 drivers/usb/gadget/function/uvc_configfs.c         |   7 ++
 drivers/usb/gadget/function/uvc_video.c            |  32 ++++--
 drivers/usb/gadget/udc/fotg210-udc.c               |   2 +-
 drivers/usb/host/xhci-mtk-sch.c                    |   4 +-
 drivers/usb/serial/cypress_m8.c                    |   2 +-
 drivers/vfio/pci/vfio_pci.c                        |   8 +-
 drivers/vfio/pci/vfio_pci_config.c                 |  31 +++++-
 drivers/video/backlight/lm3639_bl.c                |   6 +-
 drivers/video/fbdev/core/fbmon.c                   |  95 ------------------
 drivers/video/fbdev/core/modedb.c                  |  57 -----------
 drivers/video/fbdev/sbuslib.c                      |  28 +++---
 fs/compat_ioctl.c                                  |  10 +-
 fs/ecryptfs/inode.c                                |  19 ++--
 fs/f2fs/gc.c                                       |   2 +-
 fs/f2fs/recovery.c                                 |   2 +
 fs/f2fs/super.c                                    |   6 +-
 fs/fuse/control.c                                  |   4 +-
 fs/gfs2/rgrp.c                                     |   2 +-
 fs/gfs2/super.c                                    |   2 +-
 fs/kernfs/symlink.c                                |   5 +-
 fs/nfs/delegation.c                                |   6 +-
 fs/orangefs/orangefs-sysfs.c                       |   2 +-
 fs/proc/vmcore.c                                   |  10 ++
 include/linux/blkdev.h                             |   9 +-
 include/linux/cpufeature.h                         |   2 +-
 include/linux/edac.h                               |   3 +-
 include/linux/fb.h                                 |   3 -
 include/linux/intel-iommu.h                        |   6 +-
 include/linux/libfdt_env.h                         |   1 +
 include/linux/platform_data/dma-ep93xx.h           |   2 +-
 include/linux/sunrpc/sched.h                       |   2 -
 include/net/llc.h                                  |   1 +
 include/rdma/ib_verbs.h                            |   2 +-
 kernel/cpu.c                                       |   1 +
 kernel/events/uprobes.c                            |   4 +-
 kernel/kprobes.c                                   |   8 +-
 kernel/printk/printk.c                             |  18 ++--
 kernel/signal.c                                    |   4 +
 mm/hugetlb_cgroup.c                                |   2 +-
 mm/memcontrol.c                                    |   2 +-
 mm/shmem.c                                         |   2 +-
 net/bluetooth/l2cap_core.c                         |  10 ++
 net/ipv4/gre_demux.c                               |   7 +-
 net/ipv4/ip_gre.c                                  |   9 +-
 net/llc/llc_core.c                                 |   4 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   2 +-
 net/openvswitch/vport-internal_dev.c               |   5 +-
 net/sunrpc/sched.c                                 | 109 ++++++++++-----------
 net/wireless/nl80211.c                             |   2 +-
 net/wireless/reg.c                                 |  46 +++++++++
 samples/mei/mei-amt-version.c                      |   2 +-
 sound/core/oss/pcm_plugin.c                        |   4 +-
 sound/core/seq/seq_system.c                        |  18 +++-
 sound/pci/hda/patch_sigmatel.c                     |  20 ++++
 sound/pci/intel8x0m.c                              |  20 ++--
 sound/soc/codecs/hdac_hdmi.c                       |   6 ++
 sound/soc/codecs/sgtl5000.c                        |   2 +-
 sound/soc/soc-pcm.c                                |   2 +-
 sound/usb/endpoint.c                               |   3 +
 sound/usb/mixer.c                                  |   4 +-
 256 files changed, 1341 insertions(+), 746 deletions(-)


