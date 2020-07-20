Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A48226A34
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbgGTQbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731592AbgGTP5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:57:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A952B22BEF;
        Mon, 20 Jul 2020 15:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260630;
        bh=xdYTVLFkzgNJ8ZYxDmlZgKFAn8t1hldy/R3MzBe/lPE=;
        h=From:To:Cc:Subject:Date:From;
        b=XtbcJbj/UbsF73m17dKNT+i6WS0Gg3qk02E/uZB/6s1n4b9QqPRgcwMGwKOxzgieD
         PTD8nvYgVn9BRFfH5v2YRuHOGWkjjcu2NU9lx2ii7HXMsk2660wkzej+NDoQpiO51k
         Qv/D48FwYlCwvVfZ3ZtGfDGtBQbexdIW9wBUY5mY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/215] 5.4.53-rc1 review
Date:   Mon, 20 Jul 2020 17:34:42 +0200
Message-Id: <20200720152820.122442056@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.53-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.53-rc1
X-KernelTest-Deadline: 2020-07-22T15:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.53 release.
There are 215 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.53-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.53-rc1

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: disable regmap locking for automatic address incrementing

Colin Xu <colin.xu@intel.com>
    drm/i915/gvt: Fix two CFL MMIO handling caused by regression.

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Make Intel SVM code 64-bit only

Shannon Nelson <snelson@pensando.io>
    ionic: export features for vlans to use

Lingling Xu <ling_ling.xu@unisoc.com>
    spi: sprd: switch the sequence of setting WDG_LOAD_LOW and _HIGH

David Howells <dhowells@redhat.com>
    rxrpc: Fix trace string

Ilya Dryomov <idryomov@gmail.com>
    libceph: don't omit recovery_deletes in target_copy()

Ming Lei <ming.lei@redhat.com>
    block: fix get_max_segment_size() overflow on 32bit arch

Ming Lei <ming.lei@redhat.com>
    block: fix splitting segments on boundary masks

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Ignore irq enabling on the virtual engines

Xiaojie Yuan <xiaojie.yuan@amd.com>
    drm/amdgpu/sdma5: fix wptr overwritten in ->get_wptr()

Thomas Gleixner <tglx@linutronix.de>
    genirq/affinity: Handle affinity setting on inactive interrupts correctly

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: handle case of task_h_load() returning 0

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    sched: Fix unreliable rseq cpu_id for new tasks

Will Deacon <will@kernel.org>
    arm64: compat: Ensure upper 32 bits of x0 are zero on syscall return

Will Deacon <will@kernel.org>
    arm64: ptrace: Consistently use pseudo-singlestep exceptions

Will Deacon <will@kernel.org>
    arm64: ptrace: Override SPSR.SS when single-stepping is enabled

Finley Xiao <finley.xiao@rock-chips.com>
    thermal/drivers/cpufreq_cooling: Fix wrong frequency converted from power

Alex Hung <alex.hung@canonical.com>
    thermal: int3403_thermal: Downgrade error message

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    misc: atmel-ssc: lock with mutex instead of spinlock

Robin Gong <yibin.gong@nxp.com>
    dmaengine: fsl-edma-common: correct DSIZE_32BYTE

Krzysztof Kozlowski <krzk@kernel.org>
    dmaengine: mcf-edma: Fix NULL pointer exception in mcf_edma_tx_handler

Krzysztof Kozlowski <krzk@kernel.org>
    dmaengine: fsl-edma: Fix NULL pointer exception in fsl_edma_tx_handler

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Fix a NULL dereference when hub driver is not loaded

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Emmitsburg PCH support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Tiger Lake PCH-H support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Jasper Lake CPU support

Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
    powerpc/pseries/svm: Fix incorrect check for shared_lppaca_size

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/pkeys: Fix pkey_access_permitted() for execute disable pkey

Vishwas M <vishwas.reddy.vr@gmail.com>
    hwmon: (emc2103) fix unable to change fan pwm1_enable attribute

Andreas Schwab <schwab@suse.de>
    riscv: use 16KB kernel stack on 64-bit

Frederic Weisbecker <frederic@kernel.org>
    timer: Fix wheel index calculation on last level

Frederic Weisbecker <frederic@kernel.org>
    timer: Prevent base->clk from moving backward

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Remove undefined ENABLE_IRQ_POLL macro

Esben Haabendal <esben@geanix.com>
    uio_pdrv_genirq: fix use without device tree and no interrupt

Esben Haabendal <esben@geanix.com>
    uio_pdrv_genirq: Remove warning when irq is not specified

Dave Wang <dave.wang@emc.com.tw>
    Input: elan_i2c - add more hardware ID for Lenovo laptops

David Pedersen <limero1337@gmail.com>
    Input: i8042 - add Lenovo XiaoXin Air 12 to i8042 nomux list

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: don't clean driver pointer

Wade Mealing <wmealing@redhat.com>
    Revert "zram: convert remaining CLASS_ATTR() to CLASS_ATTR_RO()"

Chirantan Ekbote <chirantan@chromium.org>
    fuse: Fix parameter for FS_IOC_{GET,SET}FLAGS

Miklos Szeredi <mszeredi@redhat.com>
    fuse: use ->reconfigure() instead of ->remount_fs()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: ignore 'data' argument of mount(..., MS_REMOUNT)

Amir Goldstein <amir73il@gmail.com>
    ovl: fix unneeded call to ovl_change_flags()

Amir Goldstein <amir73il@gmail.com>
    ovl: relax WARN_ON() when decoding lower directory file handle

youngjun <her0gyugyu@gmail.com>
    ovl: inode reference leak in ovl_is_inuse true case.

Amir Goldstein <amir73il@gmail.com>
    ovl: fix regression with re-formatted lower squashfs

Chuhong Yuan <hslester96@gmail.com>
    serial: mxs-auart: add missed iounmap() in probe failure and remove

Alexander Lobakin <alobakin@pm.me>
    virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial

Jan Kiszka <jan.kiszka@siemens.com>
    Revert "tty: xilinx_uartps: Fix missing id assignment to the console"

Hans de Goede <hdegoede@redhat.com>
    virt: vbox: Fix guest capabilities mask check

Hans de Goede <hdegoede@redhat.com>
    virt: vbox: Fix VBGL_IOCTL_VMMDEV_REQUEST_BIG and _LOG req numbers to match upstream

AceLan Kao <acelan.kao@canonical.com>
    USB: serial: option: add Quectel EG95 LTE modem

Jörgen Storvist <jorgen.storvist@gmail.com>
    USB: serial: option: add GosunCn GM500 series

Igor Moura <imphilippini@gmail.com>
    USB: serial: ch341: add new Product ID for CH340

James Hilliard <james.hilliard1@gmail.com>
    USB: serial: cypress_m8: enable Simply Automated UPB PIM

Johan Hovold <johan@kernel.org>
    USB: serial: iuu_phoenix: fix memory corruption

Zhang Qiang <qiang.zhang@windriver.com>
    usb: gadget: function: fix missing spinlock in f_uac1_legacy

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: core: add wakeup support for extcon

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: Fix shutdown callback in platform

Tom Rix <trix@redhat.com>
    USB: c67x00: fix use after free in c67x00_giveback_urb

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Enable Speaker for ASUS UX563

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Enable Speaker for ASUS UX533 and UX534

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek: Enable headset mic of Acer TravelMate B311R-31 with ALC256

Armas Spann <zappel@retarded.farm>
    ALSA: hda/realtek: enable headset mic of ASUS ROG Zephyrus G14(G401) series with ALC289

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - change to suitable link model for ASUS platform

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix race against the error recovery URB submission

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Sync the pending work cancel at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Perform sanity check for each URB creation

James Hilliard <james.hilliard1@gmail.com>
    HID: quirks: Ignore Simply Automated UPB PIM

Sebastian Parschauer <s.parschauer@gmx.de>
    HID: quirks: Always poll Obins Anne Pro 2 keyboard

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: magicmouse: do not set up autorepeat

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    HID: logitech-hidpp: avoid repeated "multiplier = " log messages

Saravana Kannan <saravanak@google.com>
    slimbus: core: Fix mismatch in of_node_get/put

Vinod Koul <vkoul@kernel.org>
    clk: qcom: gcc: Add missing UFS clocks for SM8150

Vinod Koul <vkoul@kernel.org>
    clk: qcom: gcc: Add GPU and NPU clocks for SM8150

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: oxnas: Release all devices in the _remove() path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: oxnas: Unregister all devices on error

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: oxnas: Keep track of registered devices

Álvaro Fernández Rojas <noltari@gmail.com>
    mtd: rawnand: brcmnand: fix CS0 layout

Álvaro Fernández Rojas <noltari@gmail.com>
    mtd: rawnand: brcmnand: correctly verify erased pages

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: timings: Fix default tR_max and tCCS_min timings

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: marvell: Fix probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: marvell: Use nand_cleanup() when the device is not yet registered

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: marvell: Fix the condition on a return code

Aharon Landau <aharonl@mellanox.com>
    RDMA/mlx5: Verify that QP is created with RQ or SQ

Maulik Shah <mkshah@codeaurora.org>
    soc: qcom: rpmh-rsc: Allow using free WAKE TCS for active request

Raju P.L.S.S.S.N <rplsssn@codeaurora.org>
    soc: qcom: rpmh-rsc: Clear active mode configuration for wake TCS

Maulik Shah <mkshah@codeaurora.org>
    soc: qcom: rpmh: Invalidate SLEEP and WAKE TCSes before flushing new data

Maulik Shah <mkshah@codeaurora.org>
    soc: qcom: rpmh: Update dirty flag only when data changes

Jin Yao <yao.jin@linux.intel.com>
    perf stat: Zero all the 'ena' and 'run' array slot stats for interval mode

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PM: Call .bridge_d3() hook only if non-NULL

Tomer Tayar <ttayar@habana.ai>
    habanalabs: Align protection bits configuration of all TPCs

John Johansen <john.johansen@canonical.com>
    apparmor: ensure that dfa state tables have entries

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soc: qcom: socinfo: add missing soc_id sysfs entry

Sean Wang <sean.wang@mediatek.com>
    arm: dts: mt7623: add phy-mode property for gmac2

Kevin Buettner <kevinb@redhat.com>
    copy_xstate_to_kernel: Fix typo which caused GDB regression

Douglas Anderson <dianders@chromium.org>
    regmap: debugfs: Don't sleep while atomic for fast_io regmaps

Wei Yongjun <weiyongjun1@huawei.com>
    keys: asymmetric: fix error return code in software_key_query()

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: dts: spcfpga: Align GIC, NAND and UART nodenames with dtschema

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: socfpga: Align L2 cache-controller nodename with dtschema

Colin Ian King <colin.king@canonical.com>
    xprtrdma: fix incorrect header size calculations

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    Revert "thermal: mediatek: fix register index error"

dillon min <dillon.minfei@gmail.com>
    ARM: dts: Fix dcan driver probe failed on am437x platform

Vasily Averin <vvs@virtuozzo.com>
    fuse: don't ignore errors from fuse_writepages_fill()

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFS: Fix interrupted slots by sending a solo SEQUENCE operation

Eddie James <eajames@linux.ibm.com>
    clk: AST2600: Add mux for EMMC clock

Nathan Chancellor <natechancellor@gmail.com>
    clk: mvebu: ARMADA_AP_CPU_CLK needs to select ARMADA_AP_CP_HELPER

Dan Carpenter <dan.carpenter@oracle.com>
    staging: comedi: verify array index is correct before using it

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    usb: gadget: udc: atmel: fix uninitialized read in debug printk

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-sun6i: sun6i_spi_transfer_one(): fix setting of clock rate

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: dmatest: stop completed threads when running without set channel

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: Initialize channel before each transfer

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: adc: ad7780: Fix a resource handling path in 'ad7780_probe()'

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Do not disable on suspend for no-idle

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix sleeping function called from invalid context for RTC quirk

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix wakeirq sleeping function called from invalid context

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gxl-s805x: reduce initial Mali450 core frequency

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: meson: add missing gxl rng clock

Colin Ian King <colin.king@canonical.com>
    phy: sun4i-usb: fix dereference of pointer phy0 before it is null checked

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    dmaengine: sh: usb-dmac: set tx_result parameters

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: intel: fix memory leak with devm_kasprintf

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:health:afe4404 Fix timestamp alignment and prevent data leak.

Christoffer Nielsen <cn@obviux.dk>
    ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Flight S

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Use optional clocks on for enable and wait for softreset bit

Paul Menzel <pmenzel@molgen.mpg.de>
    ACPI: video: Use native backlight on Acer TravelMate 5735Z

Stephan Gerhold <stephan@gerhold.net>
    Input: mms114 - add extra compatible for mms345l

Gregor Pintar <grpintar@gmail.com>
    ALSA: usb-audio: Add quirk for Focusrite Scarlett 2i2

Emmanuel Pescosta <emmanuelpescosta099@gmail.com>
    ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Alpha S

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Use native backlight on Acer Aspire 5783z

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Rewrite registration quirk handling

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci: do not enable card detect interrupt for gpio cd type

Neil Armstrong <narmstrong@baylibre.com>
    doc: dt: bindings: usb: dwc3: Update entries for disabling SS instances in park mode

Chris Wulff <crwulff@gmail.com>
    ALSA: usb-audio: Create a registration quirk for Kingston HyperX Amp (0951:16d8)

Sergei A. Trusov <sergei.a.trusov@ya.ru>
    Input: goodix - fix touch coordinates on Cube I15-TC

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add support for MOTU MicroBook IIc

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Detect EDMA and set quirk flags for tptc

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: g12-common: add parkmode_disable_ss_quirk on DWC3 controller

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Detect display subsystem related devices

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Handle module unlock quirk needed for some RTC

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Consider non-existing registers too when matching quirks

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Rename clk related quirks to pre_reset and post_reset quirks

Diego Elio Pettenò <flameeyes@flameeyes.com>
    scsi: sr: remove references to BLK_DEV_SR_VENDOR, leave it enabled

Andrey Lebedev <andrey@lebedev.lt>
    drm/sun4i: tcon: Separate quirks for tcon0 and tcon1 on A20

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: add quirk for sam9x60's ulp1

Hans de Goede <hdegoede@redhat.com>
    HID: quirks: Remove ITE 8595 entry from hid_have_special_driver

Linus Walleij <linus.walleij@linaro.org>
    mmc: mmci: Support any block sizes for ux500v2 and qcom variant

Suman Anna <s-anna@ti.com>
    ARM: OMAP2+: use separate IOMMU pdata to fix DRA7 IPU1 boot

Suman Anna <s-anna@ti.com>
    ARM: OMAP2+: Add workaround for DRA7 DSP MStandby errata i879

Tero Kristo <t-kristo@ti.com>
    ARM: OMAP4+: remove pdata quirks for omap4+ iommus

Russell King <rmk+kernel@armlinux.org.uk>
    net: sfp: add some quirks for GPON modules

Russell King <rmk+kernel@armlinux.org.uk>
    net: sfp: add support for module quirks

Sasha Levin <sashal@kernel.org>
    Revert "usb/xhci-plat: Set PM runtime as active on resume"

Sasha Levin <sashal@kernel.org>
    Revert "usb/ehci-platform: Set PM runtime as active on resume"

Sasha Levin <sashal@kernel.org>
    Revert "usb/ohci-platform: Fix a warning when hibernating"

Sascha Hauer <s.hauer@pengutronix.de>
    net: ethernet: mvneta: Add back interface mode validation

Sascha Hauer <s.hauer@pengutronix.de>
    net: ethernet: mvneta: Do not error out in non serdes modes

Sasha Levin <sashal@kernel.org>
    net: macb: call pm_runtime_put_sync on failure path

Florian Fainelli <f.fainelli@gmail.com>
    of: of_mdio: Correct loop scanning logic

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Fix node reference count

Krzysztof Kozlowski <krzk@kernel.org>
    spi: spi-fsl-dspi: Fix lockup if device is shutdown during SPI transfer

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:health:afe4403 Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:pressure:ms5611 Fix buffer element alignment

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:humidity:hts221 Fix alignment and data leak issues

Navid Emamdoost <navid.emamdoost@gmail.com>
    iio: pressure: zpa2326: handle pm_runtime_get_sync failure

Chuhong Yuan <hslester96@gmail.com>
    iio: mma8452: Add missed iio_device_unregister() call in mma8452_probe()

Matt Ranostay <matt.ranostay@konsulko.com>
    iio: core: add missing IIO_MOD_H2/ETHANOL string identifiers

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iio: magnetometer: ak8974: Fix runtime PM imbalance on error

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:humidity:hdc100x Fix alignment and data leak issues

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:magnetometer:ak8974: Fix alignment and data leak issues

Ard Biesheuvel <ardb@kernel.org>
    arm64/alternatives: don't patch up internal branches

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: eg20t: Load module automatically if ID matches

Bob Peterson <rpeterso@redhat.com>
    gfs2: read-only mounts should grab the sd_freeze_gl glock

Vasily Averin <vvs@virtuozzo.com>
    tpm_tis: extra chip->ops check on error path in tpm_tis_core_init

Ard Biesheuvel <ardb@kernel.org>
    arm64/alternatives: use subsections for replacement sequences

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: prevent truncation from long to int in wait_for_free_credits

Kangmin Park <l4stpr0gr4m@gmail.com>
    dt-bindings: mailbox: zynqmp_ipi: fix unit address

Angelo Dureghello <angelo.dureghello@timesys.com>
    m68k: mm: fix node memblock init

Mike Rapoport <rppt@linux.ibm.com>
    m68k: nommu: register start of the memory with memblock

Hou Tao <houtao1@huawei.com>
    blk-mq-debugfs: update blk_queue_flag_name[] accordingly for new flags

Anson Huang <Anson.Huang@nxp.com>
    thermal/drivers: imx: Fix missing of_node_put() at probe time

Petteri Aimonen <jpa@git.mail.kapsi.fi>
    x86/fpu: Reset MXCSR to default in kernel_fpu_begin()

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/exynos: fix ref count leak in mic_pre_enable

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: Properly propagate return value in drm_iommu_attach_device()

Krishna Manikandan <mkrishn@codeaurora.org>
    drm/msm/dpu: allow initialization of encoder locks during encoder init

Bernard Zhao <bernard@vivo.com>
    drm/msm: fix potential memleak in error branch

Marc Zyngier <maz@kernel.org>
    arm64: arch_timer: Disable the compat vdso for cores affected by ARM64_WORKAROUND_1418040

Marc Zyngier <maz@kernel.org>
    arm64: arch_timer: Allow an workaround descriptor to disable compat vdso

Marc Zyngier <maz@kernel.org>
    arm64: Introduce a way to disable the 32bit vdso

Willem de Bruijn <willemb@google.com>
    ip: Fix SO_MARK in RST, ACK and ICMP packets

Cong Wang <xiyou.wangcong@gmail.com>
    cgroup: Fix sock_cgroup_data on big-endian.

Cong Wang <xiyou.wangcong@gmail.com>
    cgroup: fix cgroup_sk_alloc() for sk_clone_lock()

Eric Dumazet <edumazet@google.com>
    tcp: md5: allow changing MD5 keys in all socket states

Eric Dumazet <edumazet@google.com>
    tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers

Toke Høiland-Jørgensen <toke@redhat.com>
    vlan: consolidate VLAN parsing code and limit max parsing depth

Eric Dumazet <edumazet@google.com>
    tcp: md5: do not send silly options in SYNCOOKIES

Eric Dumazet <edumazet@google.com>
    tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()

Christoph Paasch <cpaasch@apple.com>
    tcp: make sure listeners don't initialize congestion-control state

Eric Dumazet <edumazet@google.com>
    tcp: fix SO_RCVLOWAT possible hangs under high mem pressure

Toke Høiland-Jørgensen <toke@redhat.com>
    sched: consistently handle layer3 header accesses in the presence of VLANs

AceLan Kao <acelan.kao@canonical.com>
    net: usb: qmi_wwan: add support for Quectel EG95 LTE modem

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix a memory leak in atm_tc_init()

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    net: dsa: microchip: set the correct number of ports

Martin Varghese <martin.varghese@nokia.com>
    net: Added pointer check for dst->ops->neigh_lookup in dst_neigh_lookup_skb

Eric Dumazet <edumazet@google.com>
    llc: make sure applications use ARPHRD_ETHER

Xin Long <lucien.xin@gmail.com>
    l2tp: remove skb_dst_set() from l2tp_xmit_skb()

David Ahern <dsahern@kernel.org>
    ipv6: Fix use of anycast address with loopback

David Ahern <dsahern@kernel.org>
    ipv6: fib6_select_path can not use out path for nexthop objects

Sabrina Dubroca <sd@queasysnail.net>
    ipv4: fill fl4_icmp_{type,code} in ping_v4_sendmsg

Sean Tranchetti <stranche@codeaurora.org>
    genetlink: remove genl_bind

Linus Lüssing <linus.luessing@c0d3.blue>
    bridge: mcast: Fix MLD2 Report IPv6 payload length check

Taehee Yoo <ap420073@gmail.com>
    net: rmnet: fix lower interface leak

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: atlantic: fix ip dst and ipv6 address filters

YueHaibing <yuehaibing@huawei.com>
    crypto: atmel - Fix build error of CRYPTO_AUTHENC

Tudor Ambarus <tudor.ambarus@microchip.com>
    crypto: atmel - Fix selection of CRYPTO_AUTHENC


-------------

Diffstat:

 .../bindings/mailbox/xlnx,zynqmp-ipi-mailbox.txt   |   2 +-
 Documentation/devicetree/bindings/usb/dwc3.txt     |   2 +
 Makefile                                           |   4 +-
 arch/alpha/configs/defconfig                       |   1 -
 arch/arm/boot/dts/am437x-l4.dtsi                   |  14 +-
 arch/arm/boot/dts/mt7623n-rfb-emmc.dts             |   1 +
 arch/arm/boot/dts/socfpga.dtsi                     |   2 +-
 arch/arm/boot/dts/socfpga_arria10.dtsi             |   2 +-
 arch/arm/configs/rpc_defconfig                     |   1 -
 arch/arm/configs/s3c2410_defconfig                 |   1 -
 arch/arm/include/asm/clocksource.h                 |  11 +-
 arch/arm/kernel/vdso.c                             |   2 +-
 arch/arm/mach-at91/pm_suspend.S                    |   4 +
 arch/arm/mach-omap2/omap-iommu.c                   |  43 ++-
 arch/arm/mach-omap2/pdata-quirks.c                 |  35 ++-
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |   8 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   1 +
 .../dts/amlogic/meson-gxl-s805x-libretech-ac.dts   |   2 +-
 .../boot/dts/amlogic/meson-gxl-s805x-p241.dts      |   2 +-
 arch/arm64/boot/dts/amlogic/meson-gxl-s805x.dtsi   |  24 ++
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   5 +
 arch/arm64/include/asm/alternative.h               |  16 +-
 arch/arm64/include/asm/arch_timer.h                |   1 +
 arch/arm64/include/asm/clocksource.h               |   5 +-
 arch/arm64/include/asm/debug-monitors.h            |   2 +
 arch/arm64/include/asm/syscall.h                   |  12 +-
 arch/arm64/include/asm/thread_info.h               |   1 +
 arch/arm64/include/asm/vdso/clocksource.h          |  14 +
 arch/arm64/include/asm/vdso/compat_gettimeofday.h  |   5 +-
 arch/arm64/include/asm/vdso/gettimeofday.h         |   6 +-
 arch/arm64/include/asm/vdso/vsyscall.h             |   4 +-
 arch/arm64/kernel/alternative.c                    |  16 +-
 arch/arm64/kernel/debug-monitors.c                 |  20 +-
 arch/arm64/kernel/ptrace.c                         |  29 +-
 arch/arm64/kernel/signal.c                         |  11 +-
 arch/arm64/kernel/syscall.c                        |   5 +-
 arch/arm64/kernel/vmlinux.lds.S                    |   3 -
 arch/ia64/configs/zx1_defconfig                    |   1 -
 arch/m68k/configs/amiga_defconfig                  |   1 -
 arch/m68k/configs/apollo_defconfig                 |   1 -
 arch/m68k/configs/atari_defconfig                  |   1 -
 arch/m68k/configs/bvme6000_defconfig               |   1 -
 arch/m68k/configs/hp300_defconfig                  |   1 -
 arch/m68k/configs/mac_defconfig                    |   1 -
 arch/m68k/configs/multi_defconfig                  |   1 -
 arch/m68k/configs/mvme147_defconfig                |   1 -
 arch/m68k/configs/mvme16x_defconfig                |   1 -
 arch/m68k/configs/q40_defconfig                    |   1 -
 arch/m68k/configs/sun3_defconfig                   |   1 -
 arch/m68k/configs/sun3x_defconfig                  |   1 -
 arch/m68k/kernel/setup_no.c                        |   3 +-
 arch/m68k/mm/mcfmmu.c                              |   2 +-
 arch/mips/configs/bigsur_defconfig                 |   1 -
 arch/mips/configs/fuloong2e_defconfig              |   1 -
 arch/mips/configs/ip27_defconfig                   |   1 -
 arch/mips/configs/ip32_defconfig                   |   1 -
 arch/mips/configs/jazz_defconfig                   |   1 -
 arch/mips/configs/malta_defconfig                  |   1 -
 arch/mips/configs/malta_kvm_defconfig              |   1 -
 arch/mips/configs/malta_kvm_guest_defconfig        |   1 -
 arch/mips/configs/maltaup_xpa_defconfig            |   1 -
 arch/mips/configs/rm200_defconfig                  |   1 -
 arch/powerpc/configs/85xx-hw.config                |   1 -
 arch/powerpc/configs/amigaone_defconfig            |   1 -
 arch/powerpc/configs/chrp32_defconfig              |   1 -
 arch/powerpc/configs/g5_defconfig                  |   1 -
 arch/powerpc/configs/maple_defconfig               |   1 -
 arch/powerpc/configs/pasemi_defconfig              |   1 -
 arch/powerpc/configs/pmac32_defconfig              |   1 -
 arch/powerpc/configs/powernv_defconfig             |   1 -
 arch/powerpc/configs/ppc64_defconfig               |   1 -
 arch/powerpc/configs/ppc64e_defconfig              |   1 -
 arch/powerpc/configs/ppc6xx_defconfig              |   1 -
 arch/powerpc/configs/pseries_defconfig             |   1 -
 arch/powerpc/configs/skiroot_defconfig             |   1 -
 arch/powerpc/kernel/paca.c                         |   2 +-
 arch/powerpc/mm/book3s64/pkeys.c                   |  12 +-
 arch/riscv/include/asm/thread_info.h               |   4 +
 arch/sh/configs/sh03_defconfig                     |   1 -
 arch/sparc/configs/sparc64_defconfig               |   1 -
 arch/x86/configs/i386_defconfig                    |   1 -
 arch/x86/configs/x86_64_defconfig                  |   1 -
 arch/x86/include/asm/fpu/internal.h                |   5 +
 arch/x86/kernel/apic/vector.c                      |  22 +-
 arch/x86/kernel/fpu/core.c                         |   6 +
 arch/x86/kernel/fpu/xstate.c                       |   2 +-
 block/blk-merge.c                                  |  23 +-
 block/blk-mq-debugfs.c                             |   3 +
 crypto/asymmetric_keys/public_key.c                |   1 +
 drivers/acpi/video_detect.c                        |  19 ++
 drivers/base/regmap/regmap-debugfs.c               |  52 ++--
 drivers/block/zram/zram_drv.c                      |   3 +-
 drivers/bus/ti-sysc.c                              | 331 ++++++++++++++-------
 drivers/char/tpm/tpm_tis_core.c                    |   2 +-
 drivers/char/virtio_console.c                      |   3 +-
 drivers/clk/clk-ast2600.c                          |  49 ++-
 drivers/clk/mvebu/Kconfig                          |   1 +
 drivers/clk/qcom/gcc-sm8150.c                      | 148 +++++++++
 drivers/clocksource/arm_arch_timer.c               |  19 +-
 drivers/crypto/Kconfig                             |   8 +-
 drivers/dma/dmatest.c                              |   2 +
 drivers/dma/dw/core.c                              |  12 -
 drivers/dma/fsl-edma-common.h                      |   2 +-
 drivers/dma/fsl-edma.c                             |   7 +
 drivers/dma/mcf-edma.c                             |   7 +
 drivers/dma/sh/usb-dmac.c                          |   2 +
 drivers/gpio/gpio-pca953x.c                        |   1 +
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |  26 +-
 drivers/gpu/drm/exynos/exynos_drm_dma.c            |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_mic.c            |   4 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c                |   1 +
 drivers/gpu/drm/i915/gvt/handlers.c                |   4 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   4 +-
 drivers/gpu/drm/msm/msm_submitqueue.c              |   4 +-
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |   2 +
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-logitech-hidpp.c                   |   2 +-
 drivers/hid/hid-magicmouse.c                       |   6 +
 drivers/hid/hid-quirks.c                           |   5 +-
 drivers/hwmon/emc2103.c                            |   2 +-
 drivers/hwtracing/intel_th/core.c                  |  21 +-
 drivers/hwtracing/intel_th/pci.c                   |  15 +
 drivers/hwtracing/intel_th/sth.c                   |   4 +-
 drivers/i2c/busses/i2c-eg20t.c                     |   1 +
 drivers/iio/accel/mma8452.c                        |   5 +-
 drivers/iio/adc/ad7780.c                           |   2 +-
 drivers/iio/health/afe4403.c                       |  13 +-
 drivers/iio/health/afe4404.c                       |   8 +-
 drivers/iio/humidity/hdc100x.c                     |  10 +-
 drivers/iio/humidity/hts221.h                      |   7 +-
 drivers/iio/humidity/hts221_buffer.c               |   9 +-
 drivers/iio/industrialio-core.c                    |   2 +
 drivers/iio/magnetometer/ak8974.c                  |  29 +-
 drivers/iio/pressure/ms5611_core.c                 |  11 +-
 drivers/iio/pressure/zpa2326.c                     |   4 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   2 +
 drivers/input/serio/i8042-x86ia64io.h              |   7 +
 drivers/input/touchscreen/goodix.c                 |  22 ++
 drivers/input/touchscreen/mms114.c                 |  17 +-
 drivers/iommu/Kconfig                              |   2 +-
 drivers/misc/atmel-ssc.c                           |  24 +-
 drivers/misc/habanalabs/goya/goya_security.c       |  99 +++++-
 drivers/misc/mei/bus.c                             |   3 +-
 drivers/mmc/host/mmci.c                            |  34 ++-
 drivers/mmc/host/mmci.h                            |   8 +-
 drivers/mmc/host/sdhci.c                           |   2 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |  24 +-
 drivers/mtd/nand/raw/marvell_nand.c                |  27 +-
 drivers/mtd/nand/raw/nand_timings.c                |   5 +-
 drivers/mtd/nand/raw/oxnas_nand.c                  |  24 +-
 drivers/net/dsa/bcm_sf2.c                          |   2 +
 drivers/net/dsa/microchip/ksz8795.c                |   3 +
 drivers/net/dsa/microchip/ksz9477.c                |   3 +
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c |   4 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh_internal.h |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |   6 +-
 drivers/net/ethernet/marvell/mvneta.c              |  24 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   1 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |  19 +-
 drivers/net/phy/sfp-bus.c                          |  79 +++++
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/of/of_mdio.c                               |   9 +-
 drivers/pci/pci.c                                  |   4 +-
 drivers/phy/allwinner/phy-sun4i-usb.c              |   5 +-
 drivers/scsi/Kconfig                               |   9 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   2 -
 drivers/scsi/sr_vendor.c                           |   8 -
 drivers/slimbus/core.c                             |   1 +
 drivers/soc/qcom/rpmh-rsc.c                        |  98 +++---
 drivers/soc/qcom/rpmh.c                            |  56 ++--
 drivers/soc/qcom/socinfo.c                         |   2 +
 drivers/soundwire/intel.c                          |   5 +-
 drivers/spi/spi-fsl-dspi.c                         |  15 +-
 drivers/spi/spi-sprd-adi.c                         |   2 +-
 drivers/spi/spi-sun6i.c                            |  14 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |  10 +-
 drivers/thermal/cpu_cooling.c                      |   6 +-
 drivers/thermal/imx_thermal.c                      |   7 +-
 .../intel/int340x_thermal/int3403_thermal.c        |   2 +-
 drivers/thermal/mtk_thermal.c                      |   6 +-
 drivers/tty/serial/mxs-auart.c                     |  12 +-
 drivers/tty/serial/xilinx_uartps.c                 |   1 -
 drivers/uio/uio_pdrv_genirq.c                      |   4 +-
 drivers/usb/c67x00/c67x00-sched.c                  |   2 +-
 drivers/usb/chipidea/core.c                        |  24 ++
 drivers/usb/dwc2/platform.c                        |   3 +-
 drivers/usb/gadget/function/f_uac1_legacy.c        |   2 +
 drivers/usb/gadget/udc/atmel_usba_udc.c            |   2 +-
 drivers/usb/host/ehci-platform.c                   |   4 -
 drivers/usb/host/ohci-platform.c                   |   5 -
 drivers/usb/host/xhci-plat.c                       |  10 +-
 drivers/usb/serial/ch341.c                         |   1 +
 drivers/usb/serial/cypress_m8.c                    |   2 +
 drivers/usb/serial/cypress_m8.h                    |   3 +
 drivers/usb/serial/iuu_phoenix.c                   |   8 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/virt/vboxguest/vboxguest_core.c            |   6 +-
 drivers/virt/vboxguest/vboxguest_core.h            |  15 +
 drivers/virt/vboxguest/vboxguest_linux.c           |   3 +-
 drivers/virt/vboxguest/vmmdev.h                    |   2 +
 fs/cifs/transport.c                                |   2 +-
 fs/fuse/file.c                                     |  14 +-
 fs/fuse/inode.c                                    |  15 +-
 fs/gfs2/ops_fstype.c                               |  12 +-
 fs/nfs/nfs4proc.c                                  |  20 +-
 fs/overlayfs/export.c                              |   2 +-
 fs/overlayfs/file.c                                |  10 +-
 fs/overlayfs/super.c                               |  23 +-
 include/linux/blkdev.h                             |   1 +
 include/linux/cgroup-defs.h                        |   8 +-
 include/linux/cgroup.h                             |   4 +-
 include/linux/if_vlan.h                            |  29 +-
 include/linux/input/elan-i2c-ids.h                 |   7 +
 include/linux/platform_data/ti-sysc.h              |   1 +
 include/net/dst.h                                  |  10 +-
 include/net/genetlink.h                            |   8 -
 include/net/inet_ecn.h                             |  25 +-
 include/net/pkt_sched.h                            |  11 -
 include/trace/events/rxrpc.h                       |   2 +-
 include/uapi/linux/vboxguest.h                     |   4 +-
 kernel/cgroup/cgroup.c                             |  31 +-
 kernel/irq/manage.c                                |  37 ++-
 kernel/sched/core.c                                |   2 +
 kernel/sched/fair.c                                |  16 +-
 kernel/time/timer.c                                |  21 +-
 net/bridge/br_multicast.c                          |   2 +-
 net/ceph/osd_client.c                              |   1 +
 net/core/filter.c                                  |  10 +-
 net/core/sock.c                                    |   2 +-
 net/ipv4/icmp.c                                    |   4 +-
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/ping.c                                    |   3 +
 net/ipv4/tcp.c                                     |  15 +-
 net/ipv4/tcp_cong.c                                |   2 +-
 net/ipv4/tcp_input.c                               |   2 +
 net/ipv4/tcp_ipv4.c                                |  15 +-
 net/ipv4/tcp_output.c                              |   8 +-
 net/ipv6/icmp.c                                    |   4 +-
 net/ipv6/route.c                                   |   7 +-
 net/l2tp/l2tp_core.c                               |   5 +-
 net/llc/af_llc.c                                   |  10 +-
 net/netlink/genetlink.c                            |  49 ---
 net/sched/act_connmark.c                           |   9 +-
 net/sched/act_csum.c                               |   2 +-
 net/sched/act_ct.c                                 |   9 +-
 net/sched/act_ctinfo.c                             |   9 +-
 net/sched/act_mpls.c                               |   2 +-
 net/sched/act_skbedit.c                            |   2 +-
 net/sched/cls_api.c                                |   2 +-
 net/sched/cls_flow.c                               |   8 +-
 net/sched/cls_flower.c                             |   2 +-
 net/sched/em_ipset.c                               |   2 +-
 net/sched/em_ipt.c                                 |   2 +-
 net/sched/em_meta.c                                |   2 +-
 net/sched/sch_atm.c                                |   8 +-
 net/sched/sch_cake.c                               |   4 +-
 net/sched/sch_dsmark.c                             |   6 +-
 net/sched/sch_teql.c                               |   2 +-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |   4 +-
 security/apparmor/match.c                          |   5 +
 sound/pci/hda/patch_realtek.c                      |  27 +-
 sound/usb/card.c                                   |  12 +-
 sound/usb/clock.c                                  |  59 +++-
 sound/usb/line6/capture.c                          |   2 +
 sound/usb/line6/driver.c                           |   2 +-
 sound/usb/line6/playback.c                         |   2 +
 sound/usb/midi.c                                   |  17 +-
 sound/usb/pcm.c                                    |   7 +-
 sound/usb/quirks-table.h                           |  86 +-----
 sound/usb/quirks.c                                 |  67 ++++-
 sound/usb/quirks.h                                 |   2 +
 tools/perf/util/stat.c                             |   6 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  13 +
 273 files changed, 2041 insertions(+), 935 deletions(-)


