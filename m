Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACCE10133D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfKSFXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbfKSFXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:23:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AFBE2235D;
        Tue, 19 Nov 2019 05:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141014;
        bh=/sp2jfidY6HgU5XnTSvfIcxZPlaflL8vsM2XeUB8bKY=;
        h=From:To:Cc:Subject:Date:From;
        b=Pmzu50lPx9FlqVNa1tI3lEzUkg43xRFQIXtHFie4sMwnxP/++bqU6ztVCNNRiydzr
         ND+7E2CUfDpIK+a4Yfl68aS/Bdlux+JoYV3x+Qo9qYvKWLQPBJmV5fFCMwktJv+TgE
         ncMpztZOt7Z8oETaJT88IT32M+EAGOxRanSTTP+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/422] 4.19.85-stable review
Date:   Tue, 19 Nov 2019 06:13:17 +0100
Message-Id: <20191119051400.261610025@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.85-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.85-rc1
X-KernelTest-Deadline: 2019-11-21T05:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.85 release.
There are 422 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.85-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.85-rc1

zhong jiang <zhongjiang@huawei.com>
    memfd: Use radix_tree_deref_slot_protected to avoid the warning.

Arnd Bergmann <arnd@arndb.de>
    net: phy: mdio-bcm-unimac: mark PM functions as __maybe_unused

Vasily Gorbik <gor@linux.ibm.com>
    s390/vdso: correct vdso mapping for compat tasks

Rui Miguel Silva <rui.silva@linaro.org>
    media: ov2680: fix null dereference at power on

Israel Rukshin <israelr@mellanox.com>
    IB/iser: Fix possible NULL deref at iser_inv_desc()

Kirill Tkhai <ktkhai@virtuozzo.com>
    fuse: use READ_ONCE on congestion_threshold and max_background

Guido Kiener <guido.kiener@rohde-schwarz.com>
    usb: usbtmc: uninitialized symbol 'actual' in usbtmc_ioctl_clear

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix ISOC error when interval is zero

Tan Hu <tan.hu@zte.com.cn>
    netfilter: masquerade: don't flush all conntracks if only one address deleted on device

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: armada38x: fix possible race condition

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: tx4939: fixup nvmem name and register size

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: isl1208: avoid possible sysfs race

Rob Herring <robh@kernel.org>
    ARM: dts: lpc32xx: Fix SPI controller node names

Rob Herring <robh@kernel.org>
    arm64: dts: lg: Fix SPI controller node names

Rob Herring <robh@kernel.org>
    arm64: dts: amd: Fix SPI bus warnings

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Check for bus reset

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

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Withhold disconnect privilege for REQUEST SENSE

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Have NCR5380_select() return a bool

Hannes Reinecke <hare@suse.com>
    scsi: NCR5380: Clear all unissued commands on host reset

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Allow TKIP for AP mode

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: use correct FIFO length

Golan Ben Ami <golan.ben.ami@intel.com>
    iwlwifi: pcie: fit reclaim msg to MAX_MSG_LEN

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: gen2: build A-MSDU only for GSO

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: api: annotate compressed BA notif array sizes

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: pcie: read correct prph address for newer devices

Erel Geron <erelx.geron@intel.com>
    iwlwifi: fix non_shared_ant for 22000 devices

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dbg: don't crash if the firmware crashes in the middle of a debug dump

Dan Aloni <dan@kernelim.com>
    crypto: fix a memory leak in rsa-kcs1pad's encryption mode

Christoph Manszewski <c.manszewski@samsung.com>
    crypto: s5p-sss: Fix Fix argument list alignment

Christoph Manszewski <c.manszewski@samsung.com>
    crypto: s5p-sss: Fix race in error handling

Dexuan Cui <decui@microsoft.com>
    x86/hyperv: Suppress "PCI: Fatal: No config space access function found"

Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
    Bluetooth: btrsi: fix bt tx timeout issue

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Detect if remote is not able to use the whole MPS

Balakrishna Godavarthi <bgodavar@codeaurora.org>
    Bluetooth: hci_serdev: clear HCI_UART_PROTO_READY to avoid closing proto races

Stuart Hayes <stuart.w.hayes@gmail.com>
    firmware: dell_rbu: Make payload memory uncachable

Rob Herring <robh@kernel.org>
    ARM: dts: realview: Fix SPI controller node names

Justin Ernst <justin.ernst@hpe.com>
    EDAC: Raise the maximum number of memory controllers

Arnd Bergmann <arnd@arndb.de>
    RDMA: Fix dependencies for rdma_user_mmap_io

Chao Yu <yuchao0@huawei.com>
    f2fs: mark inode dirty explicitly in recover_inode()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to recover inode's project id during POR

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: update i_size after DIO completion

Keith Busch <keith.busch@intel.com>
    PCI/ERR: Run error recovery callbacks for all affected devices

YueHaibing <yuehaibing@huawei.com>
    net: faraday: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: smsc: fix return type of ndo_start_xmit function

Marc Dietrich <marvin24@gmx.de>
    ARM: dts: paz00: fix wakeup gpio keycode

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: tegra: colibri_t30: fix mcp2515 can controller interrupt polarity

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: tegra: apalis_t30: fix mcp2515 can controller interrupt polarity

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: tegra: apalis_t30: fix mmc1 cmd pull-up

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: tegra20: restore address order

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: tegra30: fix xcvr-setup-use-fuses

Thierry Reding <treding@nvidia.com>
    arm64: tegra: I2C on Tegra194 is not compatible with Tegra114

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx51-zii-rdu1: Fix the rtc compatible string

Rob Herring <robh@kernel.org>
    arm64: dts: fsl: Fix I2C and SPI bus warnings

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8b: odroidc1: enable the SAR ADC

Hauke Mehrtens <hauke@hauke-m.de>
    phy: lantiq: Fix compile warning

Chengguang Xu <cgxu519@gmx.com>
    f2fs: fix remount problem of option io_bits

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: always unregister the old device if going to discover new

Nathan Chancellor <natechancellor@gmail.com>
    iw_cxgb4: Use proper enumerated type in c4iw_bar2_addrs

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Mask buggy SR-IOV VF INTx support

Li Qiang <liq3ea@gmail.com>
    vfio/pci: Fix potential memory leak in vfio_msi_cap_len

Stephen Hemminger <stephen@networkplumber.org>
    vmbus: keep pointer to ring buffer page

zhong jiang <zhongjiang@huawei.com>
    misc: genwqe: should return proper error value.

Laura Abbott <labbott@redhat.com>
    misc: kgdbts: Fix restrict error

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    silmbus: ngd: register controller after power up.

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: ngd: return proper error code instead of zero

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: ngd: register ngd driver only once.

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: dynamic-replicator: Handle multiple connections

Leo Yan <leo.yan@linaro.org>
    coresight: tmc: Fix byte-address alignment for RRP

Tomasz Nowicki <tnowicki@caviumnetworks.com>
    coresight: etm4x: Configure EL2 exception level when kernel is running in HYP

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: tmc-etr: Handle driver mode specific ETR buffers

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: perf: Disable trace path upon source error

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: perf: Fix per cpu path management

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: Fix handling of sinks

zhong jiang <zhongjiang@huawei.com>
    coresight: Use ERR_CAST instead of ERR_PTR

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: gadget: uvc: Only halt video streaming endpoint in bulk mode

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: gadget: uvc: Factor out video USB request queueing

Anson Huang <Anson.Huang@nxp.com>
    ARM: dts: imx6ull: update vdd_soc voltage for 900MHz operating point

Andreas Kemnade <andreas@kemnade.info>
    phy: phy-twl4030-usb: fix denied runtime access

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: fix vbus_ctrl for role sysfs

Florian Fainelli <f.fainelli@gmail.com>
    phy: brcm-sata: allow PHY_BRCM_SATA driver to be built for DSL SoCs

zhong jiang <zhongjiang@huawei.com>
    ARM: at91: pm: call put_device instead of of_node_put in at91_pm_config_ws

Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
    gpiolib: Fix gpio_direction_* for single direction GPIOs

Brendan Higgins <brendanhiggins@google.com>
    i2c: aspeed: fix invalid clock parameters for very large divisors

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Correct audio subsystem parent clock on Peach Chromebooks

Paul Elder <paul.elder@ideasonboard.com>
    usb: gadget: uvc: configfs: Sort frame intervals upon writing

Joel Pepper <joel.pepper@rwth-aachen.de>
    usb: gadget: uvc: configfs: Prevent format changes after linking header

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: gadget: uvc: configfs: Drop leaked references to config items

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: explicitly set vcc_sd0 pin to gpio on rk3188-radxarock

Nathan Chancellor <natechancellor@gmail.com>
    media: davinci: Fix implicit enum conversion warning

Brad Love <brad@nextdimension.cc>
    media: au0828: Fix incorrect error messages

Jia-Ju Bai <baijiaju1990@gmail.com>
    media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()

Arnd Bergmann <arnd@arndb.de>
    media: imx: work around false-positive warning, again

Petr Machata <petrm@mellanox.com>
    mlxsw: Make MLXSW_SP1_FWREV_MINOR a hard requirement

Vicente Bergas <vicencb@gmail.com>
    arm64: dts: rockchip: Fix microSD in rk3399 sapphire board

Dengcheng Zhu <dzhu@wavecomp.com>
    MIPS: kexec: Relax memory restriction

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC: Correct DIMM capacity unit symbol

Matthew Whitehead <tedheadster@gmail.com>
    x86/CPU: Change query logic so CPUID is enabled before testing

Matthew Whitehead <tedheadster@gmail.com>
    x86/CPU: Use correct macros for Cyrix calls

YueHaibing <yuehaibing@huawei.com>
    net: freescale: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: micrel: fix return type of ndo_start_xmit function

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: mdio-bcm-unimac: Allow configuring MDIO clock divider

Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>
    samples/bpf: fix compilation failure

Keith Busch <keith.busch@intel.com>
    PCI/ERR: Use slot reset if available

Keith Busch <keith.busch@intel.com>
    PCI/AER: Don't read upstream ports below fatal errors

Keith Busch <keith.busch@intel.com>
    PCI/AER: Take reference on error devices

Shahed Shaikh <Shahed.Shaikh@cavium.com>
    bnx2x: Ignore bandwidth attention in single function mode

Rob Herring <robh@kernel.org>
    ARM: dts: stm32: Fix SPI controller node names

Baruch Siach <baruch@tkos.co.il>
    ARM: dts: clearfog: fix sdhci supply property name

Yannick Fertré <yannick.fertre@st.com>
    ARM: dts: stm32: enable display on stm32mp157c-ev1 board

Borislav Petkov <bp@suse.de>
    x86/mce-inject: Reset injection struct after injection

Rob Herring <robh@kernel.org>
    ARM: dts: marvell: Fix SPI and I2C bus warnings

Stefan Agner <stefan@agner.ch>
    crypto: arm/crc32 - avoid warning when compiling with Clang

Stefan Agner <stefan@agner.ch>
    cpufeature: avoid warning when compiling with clang

Eric Biggers <ebiggers@google.com>
    crypto: chacha20 - Fix chacha20_block() keystream alignment (again)

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

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: avoid infinite loop in f2fs_alloc_nid

Rob Herring <robh@kernel.org>
    ARM: dts: ti: Fix SPI and I2C bus warnings

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: dts: am335x-evm: fix number of cpsw

Keith Busch <keith.busch@intel.com>
    PCI: portdrv: Initialize service drivers directly

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum: Init shaper for TCs 8..15

Takashi Iwai <tiwai@suse.de>
    brcmsmac: Use kvmalloc() for ucode allocations

Arend van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: increase buffer for obtaining firmware capabilities

Vasily Gorbik <gor@linux.ibm.com>
    s390/vdso: correct CFI annotations of vDSO functions

Vasily Gorbik <gor@linux.ibm.com>
    s390/vdso: avoid 64-bit vdso mapping for compat tasks

Halil Pasic <pasic@linux.ibm.com>
    s390/zcrypt: enable AP bus scan without a valid default domain

Guido Kiener <guido@kiener-muenchen.de>
    usb: usbtmc: Fix ioctl USBTMC_IOCTL_ABORT_BULK_OUT

Loic Poulain <loic.poulain@linaro.org>
    usb: chipidea: Fix otg event handler

Nicolas Adell <nicolas.adell@actia.fr>
    usb: chipidea: imx: enable OTG overcurrent in case USB subsystem is already started

Jakub Kicinski <jakub.kicinski@netronome.com>
    nfp: provide a better warning when ring allocation fails

Jian Shen <shenjian15@huawei.com>
    net: hns3: Fix parameter type for q_id in hclge_tm_q_to_qs_map_cfg()

Jian Shen <shenjian15@huawei.com>
    net: hns3: Fix client initialize state issue when roce client initialize failed

Jian Shen <shenjian15@huawei.com>
    net: hns3: Clear client pointer when initialize client failed or unintialize finished

Jian Shen <shenjian15@huawei.com>
    net: hns3: Fix cmdq registers initialization issue for vf

Fuyun Liang <liangfuyun1@huawei.com>
    net: hns3: Fix for setting speed for phy failed problem

YueHaibing <yuehaibing@huawei.com>
    net: sun: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: amd: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: broadcom: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: xilinx: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: toshiba: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: marvell: fix return type of ndo_start_xmit function

Antoine Tenart <antoine.tenart@bootlin.com>
    net: mvpp2: fix the number of queues per cpu for PPv2.2

Andreas Kemnade <andreas@kemnade.info>
    power: supply: twl4030_charger: disable eoc interrupt on linear charge

Andreas Kemnade <andreas@kemnade.info>
    power: supply: twl4030_charger: fix charging current out-of-bounds

Rob Herring <robh@kernel.org>
    libfdt: Ensure INT_MAX is defined in libfdt_env.h

Rob Herring <robh@kernel.org>
    of/unittest: Fix I2C bus unit-address error

Viresh Kumar <viresh.kumar@linaro.org>
    OPP: Protect dev_list with opp_table lock

Rob Herring <robh@kernel.org>
    ARM: dts: atmel: Fix I2C and SPI bus warnings

Håkon Bugge <Haakon.Bugge@oracle.com>
    RDMA/i40iw: Fix incorrect iterator type

Anton Blanchard <anton@samba.org>
    powerpc: Fix duplicate const clang warning in user access code

Nathan Fontenot <nfont@linux.vnet.ibm.com>
    powerpc/pseries: Disable CPU hotplug across migrations

Nathan Fontenot <nfont@linux.vnet.ibm.com>
    powerpc/pseries/memory-hotplug: Only update DT once per memory DLPAR request

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/hash: Fix stab_rr off by one initialization

Breno Leitao <leitao@debian.org>
    selftests/powerpc: Do not fail with reschedule

Breno Leitao <leitao@debian.org>
    powerpc/iommu: Avoid derefence before pointer check

YueHaibing <yuehaibing@huawei.com>
    net: ibm: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: cavium: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: hns3: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    ipmi: fix return value of ipmi_set_my_LUN

Corey Minyard <cminyard@mvista.com>
    ipmi:dmi: Ignore IPMI SMBIOS entries with a zero base address

Colin Ian King <colin.king@canonical.com>
    ipmi_si: fix potential integer overflow on large shift

Meelis Roos <mroos@linux.ee>
    ipmi_si_pci: fix NULL device in ipmi_si error message

Shuming Fan <shumingf@realtek.com>
    ASoC: rt5682: Fix the boost volume at the begining of playback

Peter Shih <pihsun@chromium.org>
    spi: mediatek: Don't modify spi_transfer when transfer.

Jonas Gorski <jonas.gorski@gmail.com>
    spi/bcm63xx-hsspi: keep pll clk enabled

Yonghong Song <yhs@fb.com>
    samples/bpf: fix a compilation failure

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: k3-am65: Change #address-cells and #size-cells of interconnect to 2

Douglas Anderson <dianders@chromium.org>
    tty: serial: qcom_geni_serial: Fix serial when not used as console

Anton Vasilyev <vasilyev@ispras.ru>
    serial: mxs-auart: Fix potential infinite loop

Marek Szyprowski <m.szyprowski@samsung.com>
    serial: samsung: Enable baud clock for UART reset procedure in resume

Nava kishore Manne <nava.manne@xilinx.com>
    serial: uartps: Fix suspend functionality

Rob Herring <robh@kernel.org>
    ARM: dts: xilinx: Fix I2C and SPI bus warnings

Gustavo A. R. Silva <gustavo@embeddedor.com>
    PCI: mediatek: Fix unchecked return value

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: socionext: Fix two sleep-in-atomic-context bugs in ave_rxfifo_reset()

Sinan Kaya <okaya@kernel.org>
    PCI/ACPI: Correct error message for ASPM disabling

Javier Martinez Canillas <javierm@redhat.com>
    media: ov2680: don't register the v4l2 subdevice before checking chip ID

Koji Matsuoka <koji.matsuoka.xm@renesas.com>
    media: vsp1: Fix YCbCr planar formats pitch calculation

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: vsp1: Fix vsp1_regs.h license header

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: invoke softirqs after napi_schedule()

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: uninstall IRQ handler on device removal

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k: Fix a locking bug in ath9k_add_interface()

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: avoid BUG_ON usage

Hans de Goede <hdegoede@redhat.com>
    ACPI / LPSS: Exclude I2C busses shared with PUNIT from pmc_atom_d3_mask

Rob Herring <robh@kernel.org>
    arm64: dts: rockchip: Fix I2C bus unit-address error on rk3399-puma-haikou

Rob Herring <robh@kernel.org>
    ARM: dts: rockchip: Fix erroneous SPI bus dtc warnings on rk3036

Vivek Gautam <vivek.gautam@codeaurora.org>
    scsi: ufshcd: Fix NULL pointer dereference for in ufshcd_init

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

Rob Herring <robh@kernel.org>
    arm64: dts: meson: Fix erroneous SPI bus warnings

Paolo Valente <paolo.valente@linaro.org>
    blok, bfq: do not plug I/O if all queues are weight-raised

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: inject other-queue I/O into seeky idle queues on NCQ flash

Hari Vyas <hari.vyas@broadcom.com>
    arm64: fix for bad_mode() handler to always result in panic

Ganesh Goudar <ganeshgr@chelsio.com>
    cxgb4: Fix endianness issue in t4_fwcache()

Sherry Yang <sherryy@android.com>
    android: binder: no outgoing transaction when thread todo has transaction

Rob Herring <robh@kernel.org>
    ARM: dts: sun9i: Fix I2C bus warnings

Ludovic Desroches <ludovic.desroches@microchip.com>
    pinctrl: at91: don't use the same irqchip with multiple gpiochips

Rob Herring <robh@kernel.org>
    ARM: dts: sunxi: Fix I2C bus warnings

Dinh Nguyen <dinguyen@kernel.org>
    ARM: dts: socfpga: Fix I2C bus unit-address error

Alan Modra <amodra@gmail.com>
    powerpc/vdso: Correct call frame information

Rob Herring <robh@kernel.org>
    ARM: dts: aspeed: Fix I2C bus warnings

Rob Herring <robh@kernel.org>
    ARM: dts: bcm: Fix SPI bus warnings

Rob Herring <robh@kernel.org>
    arm64: dts: broadcom: Fix I2C and SPI bus warnings

Lina Iyer <ilina@codeaurora.org>
    drivers: qcom: rpmh-rsc: clear wait_for_compl after use

Niklas Cassel <niklas.cassel@linaro.org>
    soc: qcom: apr: Avoid string overflow

Niklas Cassel <niklas.cassel@linaro.org>
    soc: qcom: wcnss_ctrl: Avoid string overflow

Douglas Anderson <dianders@chromium.org>
    soc: qcom: geni: geni_se_clk_freq_match() should always accept multiples

Douglas Anderson <dianders@chromium.org>
    soc: qcom: geni: Don't ignore clk_round_rate() errors in geni_se_clk_tbl_get()

Christian Lamparter <chunkeey@gmail.com>
    ARM: dts: qcom: ipq4019: fix cpu0's qcom,saw2 reg value

Cong Wang <xiyou.wangcong@gmail.com>
    llc: avoid blocking in llc_sap_close()

Dan Carpenter <dan.carpenter@oracle.com>
    pinctrl: at91-pio4: fix has_config check in atmel_pctl_dt_subnode_to_map()

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a77965: Fix clock/reset for usb2_phy1

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a77965: Fix HS-USB compatible

Magnus Damm <damm+renesas@opensource.se>
    arm64: dts: renesas: r8a77965: Attach the SYS-DMAC to the IPMMU

Kieran Bingham <kieran.bingham@ideasonboard.com>
    arm64: dts: renesas: salvator-common: adv748x: Override secondary addresses

Takashi Iwai <tiwai@suse.de>
    ALSA: intel8x0m: Register irq handler after register initializations

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-axg: use the proper compatible for ethmac

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: meson: libretech: update board model

Andrew Lunn <andrew@lunn.ch>
    net: bcmgenet: Fix speed selection for reverse MII

Arnd Bergmann <arnd@arndb.de>
    media: dvb: fix compat ioctl translation

Lao Wei <zrlw@qq.com>
    media: fix: media: pci: meye: validate offset to avoid arbitrary access

Mark Brown <broonie@kernel.org>
    ALSA: hda: Fix implicit definition of pci_iomap() on SH

Geert Uytterhoeven <geert+renesas@glider.be>
    media: dt-bindings: adv748x: Fix decimal unit addresses

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    nvmem: core: return error code instead of NULL from nvmem_device_get

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Fix synic per-cpu context initialization

Yana Esina <yana.esina@aquantia.com>
    net: aquantia: fix hw_atl_utils_fw_upload_dwords

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

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix errors in log messages.

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Correct invalid EQ doorbell write on if_type=6

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix GFT_ID and PRLI logic for RSCN

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Fix duplicate switch's Nport ID entries

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Fix dropped srb resource.

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Fix port speed display on chip reset

Sawan Chandak <sawan.chandak@cavium.com>
    scsi: qla2xxx: Check for Register disconnect

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Increase abort timeout value

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Fix deadlock between ATIO and HW lock

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Terminate Plogi/PRLI if WWN is 0

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Defer chip reset until target mode is enabled

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Fix iIDMA error

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Use correct qpair for ABTS/CMD

Wang Shilong <wangshilong1991@gmail.com>
    f2fs: fix setattr project check upon fssetxattr ioctl

Chao Yu <yuchao0@huawei.com>
    f2fs: fix memory leak of percpu counter in fill_super()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix memory leak of write_io in fill_super()

Eric W. Biederman <ebiederm@xmission.com>
    signal: Properly deliver SIGSEGV from x86 uprobes

Eric W. Biederman <ebiederm@xmission.com>
    signal: Properly deliver SIGILL from uprobes

Eric W. Biederman <ebiederm@xmission.com>
    signal: Always ignore SIGKILL and SIGSTOP sent to the global init

Michael J. Ruhl <michael.j.ruhl@intel.com>
    IB/hfi1: Missing return value in error path for user sdma

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/hns: Fix an error code in hns_roce_v2_init_eq_table()

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: at_xdmac: remove a stray bottom half unlock

Felix Fietkau <nbd@nbd.name>
    ath9k: add back support for using active monitor interfaces for tx99

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: pl030: fix possible race condition

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: mt6397: fix possible race condition

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC, sb_edac: Return early on ADDRV bit and address type test

Daniel Silsby <dansilsby@gmail.com>
    dmaengine: dma-jz4780: Further residue status fix

Paul Cercueil <paul@crapouillou.net>
    dmaengine: dma-jz4780: Don't depend on MACH_JZ4780

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: disable vbus rise/fall interrupts of ltssm

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Disable pull control for PMIC IRQ line on Artik5 board

Radu Pirea <radu.pirea@microchip.com>
    tty/serial: atmel: Change the driver to work under at91-usart MFD

Vicente Bergas <vicencb@gmail.com>
    arm64: dts: rockchip: Fix VCC5V0_HOST_EN on rk3399-sapphire

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: use strlcpy to ensure NULL-terminated strings

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    sched/debug: Use symbolic names for task state constants

Peter Zijlstra <peterz@infradead.org>
    sched/debug: Explicitly cast sched_feat() to bool

YueHaibing <yuehaibing@huawei.com>
    failover: Fix error return code in net_failover_create

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: submit bio after shutdown

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

Suman Tripathi <stripathi@amperecomputing.com>
    ata: Disable AHCI ALPM feature for Ampere Computing eMAG SATA

Yong Zhi <yong.zhi@intel.com>
    ASoC: Intel: hdac_hdmi: Limit sampling rates at dai creation

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dapm: Avoid uninitialised variable warning

Jan Kara <jack@suse.cz>
    udf: Fix crash during mount

Ding Xiang <dingxiang@cmss.chinamobile.com>
    mips: txx9: fix iounmap related issue

Parav Pandit <parav@mellanox.com>
    RDMA/core: Follow correct unregister order between sysfs and cgroup

Parav Pandit <parav@mellanox.com>
    RDMA/core: Rate limit MAD error messages

Muhammad Sammar <muhammads@mellanox.com>
    IB/ipoib: Ensure that MTU isn't less than minimum permitted

Parav Pandit <parav@mellanox.com>
    IB/mlx5: Don't hold spin lock while checking device state

Jun Gao <jun.gao@mediatek.com>
    i2c: mediatek: Use DMA safe buffers for i2c transactions

Erik Stromdahl <erik.stromdahl@gmail.com>
    ath10k: wmi: disable softirq's while calling ieee80211_rx

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Disable pull control for S5M8767 PMIC

K.T.VIJAYAKUMAAR <vijay.bvb@samsung.com>
    ath10k: avoid possible memory access violation

Colin Ian King <colin.king@canonical.com>
    ASoC: sgtl5000: avoid division by zero if lo_vag is zero

Christian Brauner <christian@brauner.io>
    rtnetlink: move type calculation out of loop

Stefan Wahren <stefan.wahren@i2se.com>
    net: lan78xx: Bail out if lan78xx_get_endpoints fails

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: avoid wrong decrypted data from disk

Stanislaw Gruszka <sgruszka@redhat.com>
    cfg80211: validate wmm rule when setting

Naftali Goldstein <naftali.goldstein@intel.com>
    mac80211: fix saving a few HE values

Peter Wu <peter@lekensteyn.nl>
    qxl: fix null-pointer crash during suspend

Majd Dibbiny <majd@mellanox.com>
    IB/mlx5: Change TX affinity assignment in RoCE LAG mode

Christoph Hellwig <hch@lst.de>
    mtd: rawnand: qcom: don't include dma-direct.h

Kurt Kanzenbach <kurt@linutronix.de>
    mtd: rawnand: fsl_ifc: fixup SRAM init for newer ctrl versions

Kurt Kanzenbach <kurt@linutronix.de>
    mtd: rawnand: fsl_ifc: check result of SRAM initialization

Thomas Petazzoni <thomas.petazzoni@bootlin.com>
    mtd: rawnand: marvell: use regmap_update_bits() for syscon access

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8b: fix the clock controller register size

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8: fix the clock controller register size

Quentin Schulz <quentin.schulz@bootlin.com>
    net: phy: mscc: read 'vsc8531, edge-slowdown' as an u32

Quentin Schulz <quentin.schulz@bootlin.com>
    net: phy: mscc: read 'vsc8531,vddmac' as an u32

Moni Shoua <monis@mellanox.com>
    net/mlx5: Fix atomic_mode enum values

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: Change the dst mac addr of loopback packet

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: Fix for loopback selftest failed problem

Jian Shen <shenjian15@huawei.com>
    net: hns3: Fix error of checking used vlan id

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: Fix for multicast failure

Jiada Wang <jiada_wang@mentor.com>
    ASoC: rsnd: ssi: Fix issue in dma data address assignment

Sven Schmitt <Sven.Schmitt@mixed-mode.de>
    soc: imx: gpc: fix PDN delay

Geert Uytterhoeven <geert@linux-m68k.org>
    mt76: Fix comparisons with invalid hardware key index

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    brcmfmac: fix wrong strnchr usage

Ganapathi Bhat <gbhat@marvell.com>
    mwifex: free rx_cmd skb in suspended state

Ganapathi Bhat <gbhat@marvell.com>
    mwifiex: do no submit URB in suspended state

Larry Finger <Larry.Finger@lwfinger.net>
    rtl8187: Fix warning generated when strncpy() destination length matches the sixe argument

Marcel Ziswiler <marcel@ziswiler.com>
    ARM: dts: pxa: fix power i2c base address

Robert Jarzmik <robert.jarzmik@free.fr>
    ARM: dts: pxa: fix the rtc controller

Alexey Khoroshilov <khoroshilov@ispras.ru>
    media: ov772x: Disable clk on error path

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: Fix pm_runtime_get_if_in_use() usage in sensor drivers

Hans Verkuil <hverkuil@xs4all.nl>
    media: vicodec: fix out-of-range values when decoding

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: avoid sending too many BARs

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: don't WARN on trying to dump dead firmware

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: drop packets with bad status in CD

Vijay Immanuel <vijayi@attalasystems.com>
    IB/rxe: fixes for rdma read retry

Vijay Immanuel <vijayi@attalasystems.com>
    IB/rxe: avoid back-to-back retries

Patryk Małek <patryk.malek@intel.com>
    i40e: Prevent deleting MAC address from VF when set by PF

Lihong Yang <lihong.yang@intel.com>
    i40evf: cancel workqueue sync for adminq when a VF is removed

Patryk Małek <patryk.malek@intel.com>
    i40e: hold the rtnl lock on clearing interrupt scheme

Patryk Małek <patryk.malek@intel.com>
    i40evf: Don't enable vlan stripping when rx offload is turned on

Jan Sokolowski <jan.sokolowski@intel.com>
    i40e: Check and correct speed values for link on open

Lihong Yang <lihong.yang@intel.com>
    i40evf: set IFF_UNICAST_FLT flag for the VF

Mitch Williams <mitch.a.williams@intel.com>
    i40e: use correct length for strncpy

Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
    i40evf: Validate the number of queues a PF sends

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Fix regulators configuration on Peach Pi/Pit Chromebooks

Alan Tull <atull@kernel.org>
    arm64: dts: stratix10: i2c clock running out of spec

Rick Farrington <ricardo.farrington@cavium.com>
    liquidio: fix race condition in instruction completion processing

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Fix sound in Snow-rev5 Chromebook

Andrzej Hajda <a.hajda@samsung.com>
    ARM: dts: exynos: Fix HDMI-HPD line handling on Arndale

Andrzej Hajda <a.hajda@samsung.com>
    ARM: dts: exynos: Use i2c-gpio for HDMI-DDC on Arndale

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    MIPS: BCM47XX: Enable USB power on Netgear WNDR3400v3

Paul Cercueil <paul@crapouillou.net>
    pinctrl: ingenic: Probe driver at subsys_initcall

Akshu Agrawal <akshu.agrawal@amd.com>
    ASoC: AMD: Change MCLK to 48Mhz

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-fifo: report interrupt request failure

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dpcm: Properly initialise hw->rate_max

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dapm: Don't fail creating new DAPM control on NULL pinctrl

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Fix and update driver version string

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't set GFS2_RDF_UPTODATE when the lvb is updated

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Prevent control queue operations during reset

Dan Nowlin <dan.nowlin@intel.com>
    ice: Update request resource command to latest specification

Sven Eckelmann <sven.eckelmann@openmesh.com>
    ath10k: limit available channels via DT ieee80211-freq-limit

Dedy Lansky <dlansky@codeaurora.org>
    wil6210: fix invalid memory access for rx_buff_mgmt debugfs

Maya Erez <merez@codeaurora.org>
    wil6210: prevent usage of tx ring 0 for eDMA

Maya Erez <merez@codeaurora.org>
    wil6210: set edma variables only for Talyn-MB devices

Dedy Lansky <dlansky@codeaurora.org>
    wil6210: drop Rx multicast packets that are looped-back to STA

Felix Fietkau <nbd@nbd.name>
    ath9k: fix tx99 with monitor mode interface

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: skip resetting rx filter for WCN3990

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Do error checks at creating system ports

Rajeev Kumar Sirasanagandla <rsirasan@codeaurora.org>
    cfg80211: Avoid regulatory restore when COUNTRY_IE_IGNORE is set

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    extcon: cht-wc: Return from default case to avoid warnings

Bjorn Andersson <bjorn.andersson@linaro.org>
    remoteproc/davinci: Use %zx for formating size_t

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: rv8803: fix the rv8803 id in the OF table

Dan Carpenter <dan.carpenter@oracle.com>
    rtc: sysfs: fix NULL check in rtc_add_groups()

Jay Foster <jayfoster@ieee.org>
    ARM: dts: at91/trivial: Fix USART1 definition for at91sam9g45

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: rcar: Correct SATA device sizes to 2 MiB

Arnd Bergmann <arnd@arndb.de>
    y2038: make do_gettimeofday() and get_seconds() inline

Aapo Vienamo <avienamo@nvidia.com>
    arm64: dts: tegra210-p2180: Correct sdmmc4 vqmmc-supply

Aapo Vienamo <avienamo@nvidia.com>
    soc/tegra: pmc: Fix pad voltage configuration for Tegra186

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: pcm: signedness bug in snd_pcm_plug_alloc()

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: a64: NanoPi-A64: Fix DCDC1 voltage

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: a64: Olinuxino: fix DRAM voltage

Samuel Holland <samuel@sholland.org>
    arm64: dts: allwinner: a64: Orange Pi Win: Fix SD card node

Vinod Koul <vkoul@kernel.org>
    soundwire: intel: Fix uninitialized adev deref

Shreyas NC <shreyas.nc@intel.com>
    soundwire: Initialize completion for defer messages

Rongyi Chen <chenyi@tt-cool.com>
    clk: sunxi-ng: h6: fix PWM gate/reset offset

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: dac: mcp4922: fix error handling in mcp4922_write_raw

Tamizh chelvam <tamizhr@codeaurora.org>
    ath10k: fix kernel panic by moving pci flush after napi_disable

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    tee: optee: take DT status property into account

Stefan Agner <stefan@agner.ch>
    iio: adc: max9611: explicitly cast gain_selectors

Eugen Hristev <eugen.hristev@microchip.com>
    mmc: sdhci-of-at91: fix quirk2 overwrite

Roman Gushchin <guro@fb.com>
    mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()

Roman Gushchin <guro@fb.com>
    mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()

Yang Shi <yang.shi@linux.alibaba.com>
    mm: mempolicy: fix the wrong return value and potential pages leak of mbind

Eric Auger <eric.auger@redhat.com>
    iommu/vt-d: Fix QI_DEV_IOTLB_PFSID and QI_DEV_EIOTLB_PFSID macros

Corentin Labbe <clabbe@baylibre.com>
    net: ethernet: dwmac-sun8i: Use the correct function in exit path

Al Viro <viro@zeniv.linux.org.uk>
    ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable either

Al Viro <viro@zeniv.linux.org.uk>
    ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable

Kai-Heng Feng <kai.heng.feng@canonical.com>
    x86/quirks: Disable HPET on Intel Coffe Lake platforms

Hans de Goede <hdegoede@redhat.com>
    i2c: acpi: Force bus speed to 400KHz if a Silead touchscreen is present

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Use a common pad buffer for 9B and 16B packets

James Erwin <james.erwin@intel.com>
    IB/hfi1: Ensure full Gen3 speed in a Gen4 system

Chuhong Yuan <hslester96@gmail.com>
    Input: synaptics-rmi4 - destroy F54 poller workqueue when removing

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - clear IRQ enables for F54

Andrew Duggan <aduggan@synaptics.com>
    Input: synaptics-rmi4 - do not consume more data than we have (F11, F12)

Andrew Duggan <aduggan@synaptics.com>
    Input: synaptics-rmi4 - disable the relative position IRQ in the F12 driver

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - fix video buffer size

Oliver Neukum <oneukum@suse.com>
    Input: ff-memless - kill timer in destroy()

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix log context list corruption after rename exchange operation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix incorrect size check for processing/extension units

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix incorrect NULL check in create_yamaha_midi_quirk()

Henry Lin <henryl@nvidia.com>
    ALSA: usb-audio: not submit urb for stopped endpoint

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix missing error check at mixer resolution test

Jiri Pirko <jiri@mellanox.com>
    devlink: disallow reload operation during device cleanup

Jouni Hogander <jouni.hogander@unikie.com>
    slip: Fix memory leak in slip_open error path

Aleksander Morgado <aleksander@aleksander.es>
    net: usb: qmi_wwan: add support for Foxconn T77W968 LTE modules

Chuhong Yuan <hslester96@gmail.com>
    net: gemini: add missed free_netdev

Guillaume Nault <gnault@redhat.com>
    ipmr: Fix skb headroom in ipmr_get_route().

Oliver Neukum <oneukum@suse.com>
    ax88172a: fix information leak on short answers

Michael Schmitz <schmitzmic@gmail.com>
    scsi: core: Handle drivers which set sg_tablesize to zero

Jonas Gorski <jonas.gorski@gmail.com>
    MIPS: BCM63XX: fix switch core reset on BCM6368

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: introduce is_pae_paging


-------------

Diffstat:

 .../devicetree/bindings/media/i2c/adv748x.txt      |   4 +-
 .../devicetree/bindings/net/brcm,unimac-mdio.txt   |   3 +
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/libfdt_env.h              |   2 +
 arch/arm/boot/dts/am335x-boneblack-common.dtsi     |   2 +-
 arch/arm/boot/dts/am335x-evm.dts                   |  12 +-
 arch/arm/boot/dts/am335x-osd3358-sm-red.dts        |   2 +-
 arch/arm/boot/dts/am335x-pdu001.dts                |   2 +-
 arch/arm/boot/dts/am4372.dtsi                      |   2 +-
 arch/arm/boot/dts/am57xx-cl-som-am57x.dts          |   2 +-
 arch/arm/boot/dts/arm-realview-eb.dtsi             |   2 +-
 arch/arm/boot/dts/arm-realview-pb1176.dts          |   2 +-
 arch/arm/boot/dts/arm-realview-pb11mp.dts          |   2 +-
 arch/arm/boot/dts/arm-realview-pbx.dtsi            |   2 +-
 arch/arm/boot/dts/armada-388-clearfog.dtsi         |   2 +-
 arch/arm/boot/dts/aspeed-g4.dtsi                   |   2 +-
 arch/arm/boot/dts/aspeed-g5.dtsi                   |   2 +-
 arch/arm/boot/dts/at91-dvk_su60_somc.dtsi          |   4 +-
 arch/arm/boot/dts/at91-dvk_su60_somc_lcm.dtsi      |   4 +-
 arch/arm/boot/dts/at91-vinco.dts                   |   2 +-
 arch/arm/boot/dts/at91sam9260ek.dts                |   2 +-
 arch/arm/boot/dts/at91sam9261ek.dts                |   2 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   2 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   2 +-
 arch/arm/boot/dts/bcm-hr2.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |   2 +-
 arch/arm/boot/dts/dove-cubox.dts                   |   2 +-
 arch/arm/boot/dts/dove.dtsi                        |   6 +-
 arch/arm/boot/dts/dra7.dtsi                        |   2 +-
 arch/arm/boot/dts/exynos3250-artik5.dtsi           |   7 +
 arch/arm/boot/dts/exynos5250-arndale.dts           |  41 ++++--
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi          |  11 ++
 arch/arm/boot/dts/exynos5250-snow-rev5.dts         |  11 ++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |   5 +-
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |   5 +-
 arch/arm/boot/dts/imx51-zii-rdu1.dts               |   2 +-
 arch/arm/boot/dts/imx6ull.dtsi                     |   2 +-
 arch/arm/boot/dts/keystone-k2g.dtsi                |   2 +-
 arch/arm/boot/dts/lpc32xx.dtsi                     |   4 +-
 arch/arm/boot/dts/meson8.dtsi                      |   2 +-
 arch/arm/boot/dts/meson8b-odroidc1.dts             |   5 +
 arch/arm/boot/dts/meson8b.dtsi                     |   2 +-
 arch/arm/boot/dts/omap2.dtsi                       |   4 +-
 arch/arm/boot/dts/omap2430.dtsi                    |   2 +-
 arch/arm/boot/dts/omap3-gta04.dtsi                 |  49 +++++--
 arch/arm/boot/dts/omap3-n9.dts                     |   2 +-
 arch/arm/boot/dts/orion5x-linkstation.dtsi         |   2 +-
 arch/arm/boot/dts/pxa25x.dtsi                      |   4 +
 arch/arm/boot/dts/pxa27x.dtsi                      |   6 +-
 arch/arm/boot/dts/qcom-ipq4019.dtsi                |   2 +-
 arch/arm/boot/dts/r8a7779.dtsi                     |   2 +-
 arch/arm/boot/dts/r8a7790.dtsi                     |   4 +-
 arch/arm/boot/dts/r8a7791.dtsi                     |   4 +-
 arch/arm/boot/dts/rk3036.dtsi                      |   2 +-
 arch/arm/boot/dts/rk3188-radxarock.dts             |   8 ++
 arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts  |   2 +-
 arch/arm/boot/dts/ste-dbx5x0.dtsi                  |   6 +-
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi     |   8 +-
 arch/arm/boot/dts/ste-hrefprev60.dtsi              |   2 +-
 arch/arm/boot/dts/ste-snowball.dts                 |   2 +-
 arch/arm/boot/dts/ste-u300.dts                     |   2 +-
 arch/arm/boot/dts/stm32mp157c-ev1.dts              |  73 +++++++++-
 arch/arm/boot/dts/stm32mp157c.dtsi                 |   2 +-
 .../boot/dts/sun5i-reference-design-tablet.dtsi    |   3 +-
 .../boot/dts/sun8i-reference-design-tablet.dtsi    |   3 +-
 arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts  |   2 +-
 arch/arm/boot/dts/sun9i-a80.dtsi                   |   2 +-
 arch/arm/boot/dts/tegra20-paz00.dts                |   6 +-
 arch/arm/boot/dts/tegra20.dtsi                     |  26 ++--
 arch/arm/boot/dts/tegra30-apalis.dtsi              |  10 +-
 arch/arm/boot/dts/tegra30-colibri-eval-v3.dts      |   3 +-
 arch/arm/boot/dts/tegra30.dtsi                     |   6 +-
 arch/arm/boot/dts/versatile-ab.dts                 |   2 +-
 arch/arm/boot/dts/zynq-zc702.dts                   |  12 +-
 arch/arm/boot/dts/zynq-zc770-xm010.dts             |   2 +-
 arch/arm/boot/dts/zynq-zc770-xm013.dts             |   2 +-
 arch/arm/crypto/crc32-ce-glue.c                    |   2 +-
 arch/arm/mach-at91/pm.c                            |   6 +-
 arch/arm/mach-imx/pm-imx6.c                        |  25 ++++
 .../boot/dts/allwinner/sun50i-a64-nanopi-a64.dts   |   6 +-
 .../boot/dts/allwinner/sun50i-a64-olinuxino.dts    |   8 +-
 .../boot/dts/allwinner/sun50i-a64-orangepi-win.dts |   4 +-
 .../boot/dts/altera/socfpga_stratix10_socdk.dts    |   2 +
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi       |   4 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |   2 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |   2 +-
 .../dts/amlogic/meson-gxl-s905x-libretech-cc.dts   |   2 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   2 +-
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi   |   4 +-
 .../boot/dts/broadcom/stingray/bcm958742-base.dtsi |   2 +-
 .../arm64/boot/dts/broadcom/stingray/stingray.dtsi |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi     |   2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi     |   6 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts  |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |   4 +-
 arch/arm64/boot/dts/lg/lg1312.dtsi                 |   4 +-
 arch/arm64/boot/dts/lg/lg1313.dtsi                 |   4 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |  16 +--
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |   1 +
 arch/arm64/boot/dts/renesas/r8a77965.dtsi          |  30 +++-
 arch/arm64/boot/dts/renesas/salvator-common.dtsi   |   5 +-
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi  |  26 +++-
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |  10 +-
 arch/arm64/boot/dts/ti/k3-am65.dtsi                |  44 +++---
 arch/arm64/kernel/traps.c                          |   1 -
 arch/mips/bcm47xx/workarounds.c                    |   8 +-
 arch/mips/bcm63xx/reset.c                          |   2 +-
 arch/mips/include/asm/kexec.h                      |   6 +-
 arch/mips/txx9/generic/setup.c                     |   5 +-
 arch/powerpc/boot/libfdt_env.h                     |   2 +
 arch/powerpc/include/asm/drmem.h                   |   5 +
 arch/powerpc/include/asm/uaccess.h                 |   6 +-
 arch/powerpc/kernel/iommu.c                        |   2 +-
 arch/powerpc/kernel/rtas.c                         |   2 +
 arch/powerpc/kernel/vdso32/datapage.S              |   1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |   1 +
 arch/powerpc/kernel/vdso64/datapage.S              |   1 +
 arch/powerpc/kernel/vdso64/gettimeofday.S          |   1 +
 arch/powerpc/mm/slb.c                              |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  55 +++-----
 arch/s390/include/asm/mmu.h                        |   2 +
 arch/s390/include/asm/mmu_context.h                |   1 +
 arch/s390/kernel/vdso.c                            |   7 +-
 arch/s390/kernel/vdso32/clock_gettime.S            |  19 +--
 arch/s390/kernel/vdso32/gettimeofday.S             |   3 +-
 arch/s390/kernel/vdso64/clock_gettime.S            |  25 ++--
 arch/s390/kernel/vdso64/gettimeofday.S             |   3 +-
 arch/x86/hyperv/hv_init.c                          |  19 +++
 arch/x86/kernel/cpu/common.c                       |   4 +-
 arch/x86/kernel/cpu/cyrix.c                        |   2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c            |   6 +
 arch/x86/kernel/early-quirks.c                     |   2 +
 arch/x86/kernel/uprobes.c                          |   2 +-
 arch/x86/kvm/vmx.c                                 |   7 +-
 arch/x86/kvm/x86.c                                 |   8 +-
 arch/x86/kvm/x86.h                                 |   5 +
 block/bfq-iosched.c                                |  78 +++++++++--
 block/bfq-iosched.h                                |  26 ++++
 crypto/chacha20_generic.c                          |   7 +-
 crypto/rsa-pkcs1pad.c                              |   9 --
 drivers/acpi/acpi_lpss.c                           |  22 ++-
 drivers/acpi/pci_root.c                            |   5 +-
 drivers/android/binder.c                           |  44 ++++--
 drivers/ata/ahci_platform.c                        |  15 +-
 drivers/base/component.c                           |   6 +-
 drivers/bluetooth/btrsi.c                          |  13 +-
 drivers/bluetooth/hci_serdev.c                     |   1 +
 drivers/char/ipmi/ipmi_dmi.c                       |   4 +
 drivers/char/ipmi/ipmi_msghandler.c                |   2 +-
 drivers/char/ipmi/ipmi_si_mem_io.c                 |   2 +-
 drivers/char/ipmi/ipmi_si_pci.c                    |   4 +-
 drivers/char/random.c                              |  24 ++--
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c               |   2 +-
 drivers/crypto/s5p-sss.c                           |  16 ++-
 drivers/dma/Kconfig                                |   2 +-
 drivers/dma/at_xdmac.c                             |   2 +-
 drivers/dma/dma-jz4780.c                           |   2 +-
 drivers/edac/i3200_edac.c                          |   2 +-
 drivers/edac/i7core_edac.c                         |   2 +-
 drivers/edac/sb_edac.c                             |  70 ++++-----
 drivers/edac/skx_edac.c                            |   4 +-
 drivers/extcon/extcon-intel-cht-wc.c               |   2 +-
 drivers/firmware/arm_scmi/base.c                   |   2 +-
 drivers/firmware/arm_scmi/clock.c                  |   2 +-
 drivers/firmware/arm_scmi/perf.c                   |   2 +-
 drivers/firmware/arm_scmi/power.c                  |   2 +-
 drivers/firmware/arm_scmi/sensors.c                |   2 +-
 drivers/firmware/dell_rbu.c                        |   8 ++
 drivers/gpio/gpiolib.c                             |  36 +++--
 drivers/gpu/drm/qxl/qxl_drv.c                      |  26 +---
 drivers/hv/channel.c                               |  20 ++-
 drivers/hv/hv.c                                    |  15 +-
 .../coresight/coresight-dynamic-replicator.c       |  64 ++++++---
 drivers/hwtracing/coresight/coresight-etm-perf.c   |  59 +++++---
 drivers/hwtracing/coresight/coresight-etm4x.c      |  40 +++---
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |   4 +-
 drivers/hwtracing/coresight/coresight-tmc-etr.c    |  60 +++++---
 drivers/hwtracing/coresight/coresight-tmc.h        |   2 +
 drivers/hwtracing/coresight/coresight.c            |  22 ++-
 drivers/i2c/busses/i2c-aspeed.c                    |  65 ++++++---
 drivers/i2c/busses/i2c-mt65xx.c                    |  62 +++++++-
 drivers/i2c/i2c-core-acpi.c                        |  28 +++-
 drivers/iio/adc/max9611.c                          |   2 +-
 drivers/iio/dac/mcp4922.c                          |  11 +-
 drivers/infiniband/core/device.c                   |   2 +-
 drivers/infiniband/core/mad.c                      |  72 +++++-----
 drivers/infiniband/hw/cxgb4/cq.c                   |   2 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |   7 +-
 drivers/infiniband/hw/hfi1/pcie.c                  |   4 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   5 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |   4 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |  10 +-
 drivers/infiniband/hw/hns/Kconfig                  |   1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   1 +
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   2 +-
 drivers/infiniband/hw/mlx4/Kconfig                 |   1 +
 drivers/infiniband/hw/mlx5/main.c                  |   8 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   4 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  63 ++++++---
 drivers/infiniband/sw/rxe/rxe_comp.c               |  39 +++++-
 drivers/infiniband/sw/rxe/rxe_req.c                |  15 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   3 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |  18 ++-
 drivers/input/ff-memless.c                         |   9 ++
 drivers/input/rmi4/rmi_f11.c                       |   4 +-
 drivers/input/rmi4/rmi_f12.c                       |  32 ++++-
 drivers/input/rmi4/rmi_f54.c                       |   5 +-
 drivers/media/i2c/ov13858.c                        |   2 +-
 drivers/media/i2c/ov2680.c                         |  26 +---
 drivers/media/i2c/ov2685.c                         |   2 +-
 drivers/media/i2c/ov5670.c                         |   2 +-
 drivers/media/i2c/ov5695.c                         |   2 +-
 drivers/media/i2c/ov772x.c                         |   1 +
 drivers/media/i2c/ov7740.c                         |   2 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   2 +-
 drivers/media/pci/meye/meye.c                      |   2 +-
 drivers/media/platform/davinci/vpbe_display.c      |   2 +-
 drivers/media/platform/vicodec/vicodec-codec.c     |  10 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |  11 +-
 drivers/media/platform/vsp1/vsp1_regs.h            |   2 +-
 drivers/media/usb/au0828/au0828-core.c             |   4 +-
 drivers/misc/genwqe/card_utils.c                   |  13 +-
 drivers/misc/kgdbts.c                              |  16 +--
 drivers/mmc/host/sdhci-of-at91.c                   |   2 +-
 drivers/mtd/nand/raw/fsl_ifc_nand.c                |  36 ++++-
 drivers/mtd/nand/raw/marvell_nand.c                |  23 ++-
 drivers/mtd/nand/raw/qcom_nandc.c                  |   1 -
 drivers/net/ethernet/amd/am79c961a.c               |   2 +-
 drivers/net/ethernet/amd/atarilance.c              |   6 +-
 drivers/net/ethernet/amd/declance.c                |   2 +-
 drivers/net/ethernet/amd/sun3lance.c               |   6 +-
 drivers/net/ethernet/amd/sunlance.c                |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   4 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c |   8 ++
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h |   3 +
 .../aquantia/atlantic/hw_atl/hw_atl_llh_internal.h |  13 ++
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c        |  36 +++--
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h        |   5 +
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |   5 +
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |   5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  10 ++
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   7 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c         |   4 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |   2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |   2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c  |   5 +-
 .../net/ethernet/cavium/liquidio/octeon_device.c   |   5 +-
 drivers/net/ethernet/cavium/liquidio/octeon_iq.h   |   2 +
 .../net/ethernet/cavium/liquidio/request_manager.c |   2 +
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |   5 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   2 +-
 drivers/net/ethernet/cortina/gemini.c              |   1 +
 drivers/net/ethernet/faraday/ftgmac100.c           |   4 +-
 drivers/net/ethernet/faraday/ftmac100.c            |   7 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   3 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |   3 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |   3 +-
 drivers/net/ethernet/freescale/gianfar.c           |   4 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |   3 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   3 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  12 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  18 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  93 +++++++-----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  42 ++++--
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   2 +-
 drivers/net/ethernet/ibm/emac/core.c               |   7 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  35 ++++-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  10 ++
 drivers/net/ethernet/intel/i40evf/i40evf_main.c    |  15 +-
 .../net/ethernet/intel/i40evf/i40evf_virtchnl.c    |  32 +++++
 drivers/net/ethernet/intel/ice/ice_common.c        |  75 +++++++---
 drivers/net/ethernet/intel/ice/ice_common.h        |   2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c      |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c          |  36 ++++-
 drivers/net/ethernet/intel/ice/ice_nvm.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_status.h        |   1 +
 drivers/net/ethernet/intel/ice/ice_type.h          |  10 +-
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   9 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |   3 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   3 +
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   4 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  12 +-
 drivers/net/ethernet/micrel/ks8695net.c            |   2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |   4 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  16 ++-
 drivers/net/ethernet/smsc/smc911x.c                |   3 +-
 drivers/net/ethernet/smsc/smc91x.c                 |   3 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   3 +-
 drivers/net/ethernet/socionext/sni_ave.c           |   4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +-
 drivers/net/ethernet/sun/ldmvsw.c                  |   2 +-
 drivers/net/ethernet/sun/sunbmac.c                 |   3 +-
 drivers/net/ethernet/sun/sunqe.c                   |   2 +-
 drivers/net/ethernet/sun/sunvnet.c                 |   2 +-
 drivers/net/ethernet/sun/sunvnet_common.c          |  14 +-
 drivers/net/ethernet/sun/sunvnet_common.h          |   7 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |   4 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.h       |   2 +-
 drivers/net/ethernet/toshiba/spider_net.c          |   4 +-
 drivers/net/ethernet/toshiba/tc35815.c             |   6 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   3 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   3 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   9 +-
 drivers/net/net_failover.c                         |   4 +-
 drivers/net/netdevsim/netdev.c                     |   5 +
 drivers/net/phy/mdio-bcm-unimac.c                  |  83 ++++++++++-
 drivers/net/phy/mscc.c                             |  11 +-
 drivers/net/slip/slip.c                            |   1 +
 drivers/net/usb/ax88172a.c                         |   2 +-
 drivers/net/usb/lan78xx.c                          |   5 +
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/wireless/ath/ath10k/ahb.c              |   4 +-
 drivers/net/wireless/ath/ath10k/core.c             |  17 ++-
 drivers/net/wireless/ath/ath10k/hw.h               |   5 +
 drivers/net/wireless/ath/ath10k/mac.c              |   2 +
 drivers/net/wireless/ath/ath10k/pci.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  10 +-
 drivers/net/wireless/ath/ath9k/main.c              |   1 -
 drivers/net/wireless/ath/ath9k/tx99.c              |  10 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   3 +
 drivers/net/wireless/ath/wil6210/main.c            |   9 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |   1 +
 drivers/net/wireless/ath/wil6210/txrx.c            |  15 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   2 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   6 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  63 +++++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   9 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   4 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  55 ++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  60 --------
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  16 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   2 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |  13 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  |   2 +-
 .../net/wireless/realtek/rtl818x/rtl8187/leds.c    |   2 +-
 drivers/nvmem/core.c                               |   2 +-
 drivers/of/base.c                                  |   2 +-
 drivers/of/unittest-data/overlay_15.dts            |   4 +-
 drivers/of/unittest-data/tests-overlay.dtsi        |   4 +-
 drivers/opp/core.c                                 |  21 ++-
 drivers/opp/cpu.c                                  |   2 +
 drivers/opp/opp.h                                  |   2 +-
 drivers/pci/controller/pcie-mediatek.c             |   4 +-
 drivers/pci/hotplug/pciehp_core.c                  |   3 +-
 drivers/pci/pci.c                                  |  37 +++++
 drivers/pci/pci.h                                  |   2 +
 drivers/pci/pcie/aer.c                             |  13 +-
 drivers/pci/pcie/dpc.c                             |   3 +-
 drivers/pci/pcie/err.c                             |  87 +++---------
 drivers/pci/pcie/pme.c                             |   3 +-
 drivers/pci/pcie/portdrv.h                         |  24 ++++
 drivers/pci/pcie/portdrv_pci.c                     |   9 ++
 drivers/pci/slot.c                                 |   1 -
 drivers/phy/broadcom/Kconfig                       |   3 +-
 drivers/phy/lantiq/phy-lantiq-rcu-usb2.c           |   1 -
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |   2 +-
 drivers/phy/ti/phy-twl4030-usb.c                   |  29 ++++
 drivers/pinctrl/pinctrl-at91-pio4.c                |   8 +-
 drivers/pinctrl/pinctrl-at91.c                     |  28 ++--
 drivers/pinctrl/pinctrl-ingenic.c                  |   2 +-
 drivers/power/reset/at91-sama5d2_shdwc.c           |   3 +
 drivers/power/supply/ab8500_fg.c                   |  31 ++--
 drivers/power/supply/max8998_charger.c             |   2 +-
 drivers/power/supply/twl4030_charger.c             |  30 +++-
 drivers/remoteproc/da8xx_remoteproc.c              |   2 +-
 drivers/rtc/rtc-armada38x.c                        |  22 +--
 drivers/rtc/rtc-isl1208.c                          |  27 ++--
 drivers/rtc/rtc-mt6397.c                           |  13 +-
 drivers/rtc/rtc-pl030.c                            |  15 +-
 drivers/rtc/rtc-rv8803.c                           |   2 +-
 drivers/rtc/rtc-sysfs.c                            |   4 +-
 drivers/rtc/rtc-tx4939.c                           |   4 +-
 drivers/s390/crypto/ap_bus.c                       |  18 +--
 drivers/s390/net/qeth_core_main.c                  | 102 +++++++-------
 drivers/s390/net/qeth_l2_main.c                    |   3 +
 drivers/s390/net/qeth_l3_main.c                    |   3 +
 drivers/scsi/NCR5380.c                             | 156 ++++++++++++---------
 drivers/scsi/NCR5380.h                             |   2 +-
 drivers/scsi/libsas/sas_expander.c                 |  13 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   5 -
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   3 +
 drivers/scsi/lpfc/lpfc_nvme.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   7 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   6 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |   6 +
 drivers/scsi/pm8001/pm8001_sas.c                   |   9 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |   1 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  80 ++++++++++-
 drivers/scsi/pm8001/pm80xx_hwi.h                   |   3 +
 drivers/scsi/qla2xxx/qla_gs.c                      |  28 +++-
 drivers/scsi/qla2xxx/qla_init.c                    |  36 ++---
 drivers/scsi/qla2xxx/qla_iocb.c                    |  12 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  50 +++----
 drivers/scsi/qla2xxx/qla_os.c                      |  29 +++-
 drivers/scsi/qla2xxx/qla_target.c                  |   6 +
 drivers/scsi/scsi_lib.c                            |   3 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |  15 +-
 drivers/scsi/ufs/ufshcd.c                          |  53 ++++---
 drivers/slimbus/qcom-ngd-ctrl.c                    |  24 ++--
 drivers/soc/imx/gpc.c                              |   2 +-
 drivers/soc/qcom/apr.c                             |   4 +-
 drivers/soc/qcom/qcom-geni-se.c                    |  41 +++---
 drivers/soc/qcom/rpmh-rsc.c                        |   2 +
 drivers/soc/qcom/wcnss_ctrl.c                      |   2 +-
 drivers/soc/tegra/pmc.c                            |  55 +++++---
 drivers/soundwire/bus.c                            |   1 +
 drivers/soundwire/intel_init.c                     |   2 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |  20 ++-
 drivers/spi/spi-mt65xx.c                           |  37 ++---
 drivers/spi/spi-pic32.c                            |   4 +-
 drivers/staging/media/imx/imx-media-csi.c          |   5 +-
 drivers/tee/optee/core.c                           |   2 +-
 drivers/tty/serial/Kconfig                         |   1 +
 drivers/tty/serial/atmel_serial.c                  |  42 ++++--
 drivers/tty/serial/mxs-auart.c                     |   3 +-
 drivers/tty/serial/qcom_geni_serial.c              |  55 ++++----
 drivers/tty/serial/samsung.c                       |   8 ++
 drivers/tty/serial/xilinx_uartps.c                 |  41 ++----
 drivers/uio/uio_hv_generic.c                       |   5 +-
 drivers/usb/chipidea/otg.c                         |   9 +-
 drivers/usb/chipidea/usbmisc_imx.c                 |   2 +
 drivers/usb/class/usbtmc.c                         |  17 ++-
 drivers/usb/gadget/function/uvc_configfs.c         |  20 +++
 drivers/usb/gadget/function/uvc_video.c            |  32 +++--
 drivers/usb/host/xhci-mtk-sch.c                    |   4 +-
 drivers/usb/mtu3/mtu3_core.c                       |   4 +-
 drivers/usb/mtu3/mtu3_gadget.c                     |  22 +--
 drivers/vfio/pci/vfio_pci.c                        |   8 +-
 drivers/vfio/pci/vfio_pci_config.c                 |  31 +++-
 fs/btrfs/inode.c                                   |  15 ++
 fs/compat_ioctl.c                                  |  10 +-
 fs/ecryptfs/inode.c                                |  19 ++-
 fs/f2fs/data.c                                     |  35 ++---
 fs/f2fs/f2fs.h                                     |   3 +-
 fs/f2fs/file.c                                     |  63 +++++----
 fs/f2fs/node.c                                     |   5 +-
 fs/f2fs/recovery.c                                 |  17 +++
 fs/f2fs/segment.c                                  |   6 +-
 fs/f2fs/super.c                                    |  11 +-
 fs/fuse/control.c                                  |   4 +-
 fs/gfs2/rgrp.c                                     |   2 +-
 fs/kernfs/symlink.c                                |   5 +-
 fs/udf/super.c                                     |  65 ++++++++-
 include/crypto/chacha20.h                          |   3 +-
 include/linux/cpufeature.h                         |   2 +-
 include/linux/edac.h                               |   3 +-
 include/linux/fsl_ifc.h                            |   2 +
 include/linux/hyperv.h                             |   2 +-
 include/linux/intel-iommu.h                        |   6 +-
 include/linux/libfdt_env.h                         |   1 +
 include/linux/mlx5/driver.h                        |   5 +-
 include/linux/timekeeping32.h                      |  15 +-
 include/media/vsp1.h                               |   2 +-
 include/net/devlink.h                              |   3 +
 include/net/llc.h                                  |   1 +
 include/soc/tegra/pmc.h                            |   1 +
 include/trace/events/sched.h                       |  11 +-
 kernel/events/uprobes.c                            |   4 +-
 kernel/kprobes.c                                   |   8 +-
 kernel/sched/sched.h                               |   2 +-
 kernel/signal.c                                    |   4 +
 kernel/time/time.c                                 |  15 +-
 kernel/time/timekeeping.c                          |  24 ----
 lib/chacha20.c                                     |   6 +-
 mm/hugetlb_cgroup.c                                |   2 +-
 mm/memcontrol.c                                    |   2 +-
 mm/memfd.c                                         |   2 +-
 mm/mempolicy.c                                     |  14 +-
 net/bluetooth/l2cap_core.c                         |  10 ++
 net/core/devlink.c                                 |  39 +++++-
 net/core/rtnetlink.c                               |   2 +-
 net/ipv4/gre_demux.c                               |   7 +-
 net/ipv4/ip_gre.c                                  |   9 +-
 net/ipv4/ipmr.c                                    |   3 +-
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c        |  22 ++-
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c        |  19 ++-
 net/llc/llc_core.c                                 |   4 +-
 net/mac80211/mlme.c                                |  17 +--
 net/netfilter/nf_tables_api.c                      |   9 +-
 net/netfilter/nft_cmp.c                            |   6 +-
 net/netfilter/nft_reject.c                         |   6 +-
 net/wireless/reg.c                                 | 110 +++++++++++----
 samples/bpf/sockex2_kern.c                         |  11 +-
 samples/bpf/sockex3_kern.c                         |   8 +-
 samples/bpf/sockex3_user.c                         |   4 +-
 sound/core/oss/pcm_plugin.c                        |   4 +-
 sound/core/seq/seq_system.c                        |  18 ++-
 sound/pci/hda/patch_ca0132.c                       |   1 +
 sound/pci/intel8x0m.c                              |  20 +--
 sound/soc/amd/acp-da7219-max98357a.c               |   2 +-
 sound/soc/codecs/hdac_hdmi.c                       |   6 +
 sound/soc/codecs/rt5682.c                          |   5 +
 sound/soc/codecs/sgtl5000.c                        |   2 +-
 sound/soc/meson/axg-fifo.c                         |   2 +
 sound/soc/sh/rcar/rsnd.h                           |   1 +
 sound/soc/sh/rcar/ssi.c                            |   4 +-
 sound/soc/soc-dapm.c                               |   4 +-
 sound/soc/soc-pcm.c                                |   2 +-
 sound/usb/endpoint.c                               |   3 +
 sound/usb/mixer.c                                  |   4 +-
 sound/usb/quirks.c                                 |   4 +-
 sound/usb/validate.c                               |   6 +-
 .../testing/selftests/powerpc/tm/tm-unavailable.c  |   9 +-
 tools/testing/selftests/powerpc/tm/tm.h            |   9 ++
 524 files changed, 3933 insertions(+), 1921 deletions(-)


