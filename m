Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595BD101752
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbfKSFpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730519AbfKSFpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:45:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9CD721939;
        Tue, 19 Nov 2019 05:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142332;
        bh=EUnLKOuHnF0ZlO6v/93g7RRFMMe/PYZ4YzqyiVrMdDE=;
        h=From:To:Cc:Subject:Date:From;
        b=ejcgOMLyIg+BTYIR64T8rXT85ihs8wcQ1d1d+95Xny2AiVmh0JFfGPy4AjqF0sIU4
         i+EIjSEsmIl6bqXPw40AUZDm5+qreJn06tsD9x9rdX4IPYbtSaUTygLaOFtLQE6r23
         oKytQFCS8kZe7S+opj0E18dEo0RSVgJWbX6K5Xtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/239] 4.14.155-stable review
Date:   Tue, 19 Nov 2019 06:16:40 +0100
Message-Id: <20191119051255.850204959@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.155-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.155-rc1
X-KernelTest-Deadline: 2019-11-21T05:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.155 release.
There are 239 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.155-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.155-rc1

zhong jiang <zhongjiang@huawei.com>
    memfd: Use radix_tree_deref_slot_protected to avoid the warning.

Arnd Bergmann <arnd@arndb.de>
    net: phy: mdio-bcm-unimac: mark PM functions as __maybe_unused

Israel Rukshin <israelr@mellanox.com>
    IB/iser: Fix possible NULL deref at iser_inv_desc()

Kirill Tkhai <ktkhai@virtuozzo.com>
    fuse: use READ_ONCE on congestion_threshold and max_background

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix ISOC error when interval is zero

Tan Hu <tan.hu@zte.com.cn>
    netfilter: masquerade: don't flush all conntracks if only one address deleted on device

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: armada38x: fix possible race condition

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: enable display nodes on rk3328-rock64

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

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: api: annotate compressed BA notif array sizes

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dbg: don't crash if the firmware crashes in the middle of a debug dump

Dan Aloni <dan@kernelim.com>
    crypto: fix a memory leak in rsa-kcs1pad's encryption mode

Christoph Manszewski <c.manszewski@samsung.com>
    crypto: s5p-sss: Fix Fix argument list alignment

Dexuan Cui <decui@microsoft.com>
    x86/hyperv: Suppress "PCI: Fatal: No config space access function found"

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

Chao Yu <yuchao0@huawei.com>
    f2fs: mark inode dirty explicitly in recover_inode()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to recover inode's project id during POR

YueHaibing <yuehaibing@huawei.com>
    net: faraday: fix return type of ndo_start_xmit function

YueHaibing <yuehaibing@huawei.com>
    net: smsc: fix return type of ndo_start_xmit function

Marc Dietrich <marvin24@gmx.de>
    ARM: dts: paz00: fix wakeup gpio keycode

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: tegra: apalis_t30: fix mmc1 cmd pull-up

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: tegra30: fix xcvr-setup-use-fuses

Hauke Mehrtens <hauke@hauke-m.de>
    phy: lantiq: Fix compile warning

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
    coresight: perf: Disable trace path upon source error

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: perf: Fix per cpu path management

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: Fix handling of sinks

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: gadget: uvc: Only halt video streaming endpoint in bulk mode

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: gadget: uvc: Factor out video USB request queueing

Andreas Kemnade <andreas@kemnade.info>
    phy: phy-twl4030-usb: fix denied runtime access

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: fix vbus_ctrl for role sysfs

Florian Fainelli <f.fainelli@gmail.com>
    phy: brcm-sata: allow PHY_BRCM_SATA driver to be built for DSL SoCs

Brendan Higgins <brendanhiggins@google.com>
    i2c: aspeed: fix invalid clock parameters for very large divisors

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

Vicente Bergas <vicencb@gmail.com>
    arm64: dts: rockchip: Fix microSD in rk3399 sapphire board

Dengcheng Zhu <dzhu@wavecomp.com>
    MIPS: kexec: Relax memory restriction

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

Shahed Shaikh <Shahed.Shaikh@cavium.com>
    bnx2x: Ignore bandwidth attention in single function mode

Baruch Siach <baruch@tkos.co.il>
    ARM: dts: clearfog: fix sdhci supply property name

Borislav Petkov <bp@suse.de>
    x86/mce-inject: Reset injection struct after injection

Rob Herring <robh@kernel.org>
    ARM: dts: marvell: Fix SPI and I2C bus warnings

Stefan Agner <stefan@agner.ch>
    crypto: arm/crc32 - avoid warning when compiling with Clang

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

Jakub Kicinski <jakub.kicinski@netronome.com>
    nfp: provide a better warning when ring allocation fails

Jian Shen <shenjian15@huawei.com>
    net: hns3: Fix parameter type for q_id in hclge_tm_q_to_qs_map_cfg()

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

Andreas Kemnade <andreas@kemnade.info>
    power: supply: twl4030_charger: disable eoc interrupt on linear charge

Andreas Kemnade <andreas@kemnade.info>
    power: supply: twl4030_charger: fix charging current out-of-bounds

Rob Herring <robh@kernel.org>
    libfdt: Ensure INT_MAX is defined in libfdt_env.h

Viresh Kumar <viresh.kumar@linaro.org>
    OPP: Protect dev_list with opp_table lock

Håkon Bugge <Haakon.Bugge@oracle.com>
    RDMA/i40iw: Fix incorrect iterator type

Anton Blanchard <anton@samba.org>
    powerpc: Fix duplicate const clang warning in user access code

Nathan Fontenot <nfont@linux.vnet.ibm.com>
    powerpc/pseries: Disable CPU hotplug across migrations

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/hash: Fix stab_rr off by one initialization

Breno Leitao <leitao@debian.org>
    powerpc/iommu: Avoid derefence before pointer check

YueHaibing <yuehaibing@huawei.com>
    net: hns3: fix return type of ndo_start_xmit function

Corey Minyard <cminyard@mvista.com>
    ipmi:dmi: Ignore IPMI SMBIOS entries with a zero base address

Peter Shih <pihsun@chromium.org>
    spi: mediatek: Don't modify spi_transfer when transfer.

Yonghong Song <yhs@fb.com>
    samples/bpf: fix a compilation failure

Anton Vasilyev <vasilyev@ispras.ru>
    serial: mxs-auart: Fix potential infinite loop

Marek Szyprowski <m.szyprowski@samsung.com>
    serial: samsung: Enable baud clock for UART reset procedure in resume

Nava kishore Manne <nava.manne@xilinx.com>
    serial: uartps: Fix suspend functionality

Sinan Kaya <okaya@kernel.org>
    PCI/ACPI: Correct error message for ASPM disabling

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: invoke softirqs after napi_schedule()

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k: Fix a locking bug in ath9k_add_interface()

Hans de Goede <hdegoede@redhat.com>
    ACPI / LPSS: Exclude I2C busses shared with PUNIT from pmc_atom_d3_mask

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

Rob Herring <robh@kernel.org>
    arm64: dts: meson: Fix erroneous SPI bus warnings

Paolo Valente <paolo.valente@linaro.org>
    blok, bfq: do not plug I/O if all queues are weight-raised

Ganesh Goudar <ganeshgr@chelsio.com>
    cxgb4: Fix endianness issue in t4_fwcache()

Ludovic Desroches <ludovic.desroches@microchip.com>
    pinctrl: at91: don't use the same irqchip with multiple gpiochips

Dinh Nguyen <dinguyen@kernel.org>
    ARM: dts: socfpga: Fix I2C bus unit-address error

Alan Modra <amodra@gmail.com>
    powerpc/vdso: Correct call frame information

Niklas Cassel <niklas.cassel@linaro.org>
    soc: qcom: wcnss_ctrl: Avoid string overflow

Christian Lamparter <chunkeey@gmail.com>
    ARM: dts: qcom: ipq4019: fix cpu0's qcom,saw2 reg value

Cong Wang <xiyou.wangcong@gmail.com>
    llc: avoid blocking in llc_sap_close()

Dan Carpenter <dan.carpenter@oracle.com>
    pinctrl: at91-pio4: fix has_config check in atmel_pctl_dt_subnode_to_map()

Takashi Iwai <tiwai@suse.de>
    ALSA: intel8x0m: Register irq handler after register initializations

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: meson: libretech: update board model

Arnd Bergmann <arnd@arndb.de>
    media: dvb: fix compat ioctl translation

Lao Wei <zrlw@qq.com>
    media: fix: media: pci: meye: validate offset to avoid arbitrary access

Geert Uytterhoeven <geert+renesas@glider.be>
    media: dt-bindings: adv748x: Fix decimal unit addresses

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    nvmem: core: return error code instead of NULL from nvmem_device_get

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Fix synic per-cpu context initialization

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

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Fix dropped srb resource.

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Defer chip reset until target mode is enabled

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Fix iIDMA error

Chao Yu <yuchao0@huawei.com>
    f2fs: fix memory leak of percpu counter in fill_super()

Eric W. Biederman <ebiederm@xmission.com>
    signal: Properly deliver SIGSEGV from x86 uprobes

Eric W. Biederman <ebiederm@xmission.com>
    signal: Properly deliver SIGILL from uprobes

Eric W. Biederman <ebiederm@xmission.com>
    signal: Always ignore SIGKILL and SIGSTOP sent to the global init

Michael J. Ruhl <michael.j.ruhl@intel.com>
    IB/hfi1: Missing return value in error path for user sdma

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

Vicente Bergas <vicencb@gmail.com>
    arm64: dts: rockchip: Fix VCC5V0_HOST_EN on rk3399-sapphire

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    sched/debug: Use symbolic names for task state constants

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

Parav Pandit <parav@mellanox.com>
    RDMA/core: Follow correct unregister order between sysfs and cgroup

Parav Pandit <parav@mellanox.com>
    RDMA/core: Rate limit MAD error messages

Muhammad Sammar <muhammads@mellanox.com>
    IB/ipoib: Ensure that MTU isn't less than minimum permitted

Erik Stromdahl <erik.stromdahl@gmail.com>
    ath10k: wmi: disable softirq's while calling ieee80211_rx

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Disable pull control for S5M8767 PMIC

Colin Ian King <colin.king@canonical.com>
    ASoC: sgtl5000: avoid division by zero if lo_vag is zero

Stefan Wahren <stefan.wahren@i2se.com>
    net: lan78xx: Bail out if lan78xx_get_endpoints fails

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8b: fix the clock controller register size

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8: fix the clock controller register size

Quentin Schulz <quentin.schulz@bootlin.com>
    net: phy: mscc: read 'vsc8531, edge-slowdown' as an u32

Quentin Schulz <quentin.schulz@bootlin.com>
    net: phy: mscc: read 'vsc8531,vddmac' as an u32

Jiada Wang <jiada_wang@mentor.com>
    ASoC: rsnd: ssi: Fix issue in dma data address assignment

Sven Schmitt <Sven.Schmitt@mixed-mode.de>
    soc: imx: gpc: fix PDN delay

Larry Finger <Larry.Finger@lwfinger.net>
    rtl8187: Fix warning generated when strncpy() destination length matches the sixe argument

Marcel Ziswiler <marcel@ziswiler.com>
    ARM: dts: pxa: fix power i2c base address

Robert Jarzmik <robert.jarzmik@free.fr>
    ARM: dts: pxa: fix the rtc controller

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: avoid sending too many BARs

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: don't WARN on trying to dump dead firmware

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

Rick Farrington <ricardo.farrington@cavium.com>
    liquidio: fix race condition in instruction completion processing

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Fix sound in Snow-rev5 Chromebook

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    MIPS: BCM47XX: Enable USB power on Netgear WNDR3400v3

Paul Cercueil <paul@crapouillou.net>
    pinctrl: ingenic: Probe driver at subsys_initcall

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dpcm: Properly initialise hw->rate_max

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't set GFS2_RDF_UPTODATE when the lvb is updated

Sven Eckelmann <sven.eckelmann@openmesh.com>
    ath10k: limit available channels via DT ieee80211-freq-limit

Felix Fietkau <nbd@nbd.name>
    ath9k: fix tx99 with monitor mode interface

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

Jay Foster <jayfoster@ieee.org>
    ARM: dts: at91/trivial: Fix USART1 definition for at91sam9g45

Aapo Vienamo <avienamo@nvidia.com>
    arm64: dts: tegra210-p2180: Correct sdmmc4 vqmmc-supply

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: pcm: signedness bug in snd_pcm_plug_alloc()

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: a64: NanoPi-A64: Fix DCDC1 voltage

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: a64: Olinuxino: fix DRAM voltage

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

Eric Auger <eric.auger@redhat.com>
    iommu/vt-d: Fix QI_DEV_IOTLB_PFSID and QI_DEV_EIOTLB_PFSID macros

Al Viro <viro@zeniv.linux.org.uk>
    ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable either

Al Viro <viro@zeniv.linux.org.uk>
    ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable

Kai-Heng Feng <kai.heng.feng@canonical.com>
    x86/quirks: Disable HPET on Intel Coffe Lake platforms

Hans de Goede <hdegoede@redhat.com>
    i2c: acpi: Force bus speed to 400KHz if a Silead touchscreen is present

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

Henry Lin <henryl@nvidia.com>
    ALSA: usb-audio: not submit urb for stopped endpoint

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix missing error check at mixer resolution test

Jouni Hogander <jouni.hogander@unikie.com>
    slip: Fix memory leak in slip_open error path

Aleksander Morgado <aleksander@aleksander.es>
    net: usb: qmi_wwan: add support for Foxconn T77W968 LTE modules

Oliver Neukum <oneukum@suse.com>
    ax88172a: fix information leak on short answers

Anju T Sudhakar <anju@linux.vnet.ibm.com>
    powerpc/perf: Fix kfree memory allocated for nest pmus

Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
    powerpc/perf: Fix IMC_MAX_PMU macro

Evan Green <evgreen@chromium.org>
    Revert "Input: synaptics-rmi4 - avoid processing unknown IRQs"

Michael Schmitz <schmitzmic@gmail.com>
    scsi: core: Handle drivers which set sg_tablesize to zero

Jonas Gorski <jonas.gorski@gmail.com>
    MIPS: BCM63XX: fix switch core reset on BCM6368

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: introduce is_pae_paging

Junaid Shahid <junaids@google.com>
    kvm: mmu: Don't read PDPTEs when paging is not enabled


-------------

Diffstat:

 .../devicetree/bindings/media/i2c/adv748x.txt      |   4 +-
 .../devicetree/bindings/net/brcm,unimac-mdio.txt   |   3 +
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/libfdt_env.h              |   2 +
 arch/arm/boot/dts/am335x-evm.dts                   |  12 +-
 arch/arm/boot/dts/arm-realview-eb.dtsi             |   2 +-
 arch/arm/boot/dts/arm-realview-pb1176.dts          |   2 +-
 arch/arm/boot/dts/arm-realview-pb11mp.dts          |   2 +-
 arch/arm/boot/dts/arm-realview-pbx.dtsi            |   2 +-
 arch/arm/boot/dts/armada-388-clearfog.dtsi         |   2 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   2 +-
 arch/arm/boot/dts/dove-cubox.dts                   |   2 +-
 arch/arm/boot/dts/dove.dtsi                        |   6 +-
 arch/arm/boot/dts/exynos5250-arndale.dts           |   9 ++
 arch/arm/boot/dts/exynos5250-snow-rev5.dts         |  11 ++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |   3 +
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |   3 +
 arch/arm/boot/dts/lpc32xx.dtsi                     |   4 +-
 arch/arm/boot/dts/meson8.dtsi                      |   2 +-
 arch/arm/boot/dts/meson8b.dtsi                     |   2 +-
 arch/arm/boot/dts/omap3-gta04.dtsi                 |  49 +++++--
 arch/arm/boot/dts/orion5x-linkstation.dtsi         |   2 +-
 arch/arm/boot/dts/pxa25x.dtsi                      |   4 +
 arch/arm/boot/dts/pxa27x.dtsi                      |   6 +-
 arch/arm/boot/dts/qcom-ipq4019.dtsi                |   2 +-
 arch/arm/boot/dts/rk3036.dtsi                      |   2 +-
 arch/arm/boot/dts/rk3188-radxarock.dts             |   8 ++
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
 arch/arm/crypto/crc32-ce-glue.c                    |   2 +-
 arch/arm/mach-imx/pm-imx6.c                        |  25 ++++
 .../boot/dts/allwinner/sun50i-a64-nanopi-a64.dts   |   6 +-
 .../boot/dts/allwinner/sun50i-a64-olinuxino.dts    |   8 +-
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi       |   4 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |   2 +-
 .../dts/amlogic/meson-gxl-s905x-libretech-cc.dts   |   2 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   2 +-
 arch/arm64/boot/dts/lg/lg1312.dtsi                 |   4 +-
 arch/arm64/boot/dts/lg/lg1313.dtsi                 |   4 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |   1 +
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts     |  16 +++
 arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi  |  26 +++-
 arch/mips/bcm47xx/workarounds.c                    |   8 +-
 arch/mips/bcm63xx/reset.c                          |   2 +-
 arch/mips/include/asm/kexec.h                      |   6 +-
 arch/mips/txx9/generic/setup.c                     |   5 +-
 arch/powerpc/boot/libfdt_env.h                     |   2 +
 arch/powerpc/include/asm/imc-pmu.h                 |   6 +-
 arch/powerpc/include/asm/uaccess.h                 |   6 +-
 arch/powerpc/kernel/iommu.c                        |   2 +-
 arch/powerpc/kernel/rtas.c                         |   2 +
 arch/powerpc/kernel/vdso32/datapage.S              |   1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |   1 +
 arch/powerpc/kernel/vdso64/datapage.S              |   1 +
 arch/powerpc/kernel/vdso64/gettimeofday.S          |   1 +
 arch/powerpc/mm/slb.c                              |   2 +-
 arch/powerpc/perf/imc-pmu.c                        |  17 ++-
 arch/powerpc/platforms/powernv/opal-imc.c          |  16 +++
 arch/x86/hyperv/hv_init.c                          |  19 +++
 arch/x86/kernel/cpu/common.c                       |   4 +-
 arch/x86/kernel/cpu/cyrix.c                        |   2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c            |   6 +
 arch/x86/kernel/early-quirks.c                     |   2 +
 arch/x86/kernel/uprobes.c                          |   2 +-
 arch/x86/kvm/vmx.c                                 |   7 +-
 arch/x86/kvm/x86.c                                 |   8 +-
 arch/x86/kvm/x86.h                                 |   5 +
 block/bfq-iosched.c                                |  10 +-
 crypto/rsa-pkcs1pad.c                              |   9 --
 drivers/acpi/acpi_lpss.c                           |  22 ++-
 drivers/acpi/pci_root.c                            |   5 +-
 drivers/base/component.c                           |   6 +-
 drivers/base/power/opp/core.c                      |  21 ++-
 drivers/base/power/opp/cpu.c                       |   2 +
 drivers/base/power/opp/opp.h                       |   2 +-
 drivers/bluetooth/hci_serdev.c                     |   1 +
 drivers/char/ipmi/ipmi_dmi.c                       |   4 +
 drivers/crypto/s5p-sss.c                           |   4 +-
 drivers/dma/Kconfig                                |   2 +-
 drivers/dma/dma-jz4780.c                           |   2 +-
 drivers/edac/sb_edac.c                             |  68 ++++-----
 drivers/extcon/extcon-intel-cht-wc.c               |   2 +-
 drivers/firmware/dell_rbu.c                        |   8 ++
 drivers/hv/hv.c                                    |  15 +-
 drivers/hwtracing/coresight/coresight-etm-perf.c   |  59 +++++---
 drivers/hwtracing/coresight/coresight-etm4x.c      |  40 +++---
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |   4 +-
 drivers/hwtracing/coresight/coresight.c            |  22 ++-
 drivers/i2c/busses/i2c-aspeed.c                    |  65 ++++++---
 drivers/i2c/i2c-core-acpi.c                        |  28 +++-
 drivers/iio/adc/max9611.c                          |   2 +-
 drivers/iio/dac/mcp4922.c                          |  11 +-
 drivers/infiniband/core/device.c                   |   2 +-
 drivers/infiniband/core/mad.c                      |  72 +++++-----
 drivers/infiniband/hw/hfi1/pcie.c                  |   4 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   2 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |  21 ++-
 drivers/infiniband/sw/rxe/rxe_req.c                |  15 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   3 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |  18 ++-
 drivers/input/ff-memless.c                         |   9 ++
 drivers/input/rmi4/rmi_driver.c                    |   6 +-
 drivers/input/rmi4/rmi_f11.c                       |   4 +-
 drivers/input/rmi4/rmi_f12.c                       |  32 ++++-
 drivers/input/rmi4/rmi_f54.c                       |   5 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   2 +-
 drivers/media/pci/meye/meye.c                      |   2 +-
 drivers/media/platform/davinci/vpbe_display.c      |   2 +-
 drivers/media/usb/au0828/au0828-core.c             |   4 +-
 drivers/misc/genwqe/card_utils.c                   |  13 +-
 drivers/misc/kgdbts.c                              |  16 +--
 drivers/mmc/host/sdhci-of-at91.c                   |   2 +-
 drivers/net/ethernet/amd/am79c961a.c               |   2 +-
 drivers/net/ethernet/amd/atarilance.c              |   6 +-
 drivers/net/ethernet/amd/declance.c                |   2 +-
 drivers/net/ethernet/amd/sun3lance.c               |   6 +-
 drivers/net/ethernet/amd/sunlance.c                |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   4 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |   5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  10 ++
 drivers/net/ethernet/broadcom/sb1250-mac.c         |   4 +-
 .../net/ethernet/cavium/liquidio/octeon_device.c   |   5 +-
 drivers/net/ethernet/cavium/liquidio/octeon_iq.h   |   2 +
 .../net/ethernet/cavium/liquidio/request_manager.c |   2 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |   4 +-
 drivers/net/ethernet/faraday/ftmac100.c            |   7 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   3 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |   3 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |   3 +-
 drivers/net/ethernet/freescale/gianfar.c           |   4 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |   3 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   3 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   8 ++
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  10 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   7 +
 drivers/net/ethernet/micrel/ks8695net.c            |   2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |   4 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  16 ++-
 drivers/net/ethernet/smsc/smc911x.c                |   3 +-
 drivers/net/ethernet/smsc/smc91x.c                 |   3 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   3 +-
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
 drivers/net/phy/mdio-bcm-unimac.c                  |  83 ++++++++++-
 drivers/net/phy/mscc.c                             |  11 +-
 drivers/net/slip/slip.c                            |   1 +
 drivers/net/usb/ax88172a.c                         |   2 +-
 drivers/net/usb/lan78xx.c                          |   5 +
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/wireless/ath/ath10k/ahb.c              |   4 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   2 +
 drivers/net/wireless/ath/ath10k/pci.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   3 +-
 drivers/net/wireless/ath/ath9k/main.c              |   1 -
 drivers/net/wireless/ath/ath9k/tx99.c              |  10 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   4 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   8 ++
 .../net/wireless/realtek/rtl818x/rtl8187/leds.c    |   2 +-
 drivers/nvmem/core.c                               |   2 +-
 drivers/of/base.c                                  |   2 +-
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
 drivers/rtc/rtc-mt6397.c                           |  13 +-
 drivers/rtc/rtc-pl030.c                            |  15 +-
 drivers/rtc/rtc-rv8803.c                           |   2 +-
 drivers/s390/net/qeth_l2_main.c                    |   3 +
 drivers/s390/net/qeth_l3_main.c                    |   3 +
 drivers/scsi/NCR5380.c                             | 156 ++++++++++++---------
 drivers/scsi/NCR5380.h                             |   2 +-
 drivers/scsi/libsas/sas_expander.c                 |  13 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   7 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |   6 +
 drivers/scsi/pm8001/pm8001_sas.c                   |   9 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |   1 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  80 ++++++++++-
 drivers/scsi/pm8001/pm80xx_hwi.h                   |   3 +
 drivers/scsi/qla2xxx/qla_gs.c                      |   4 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  28 +++-
 drivers/scsi/scsi_lib.c                            |   3 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |  15 +-
 drivers/soc/imx/gpc.c                              |   2 +-
 drivers/soc/qcom/wcnss_ctrl.c                      |   2 +-
 drivers/spi/spi-mt65xx.c                           |  37 ++---
 drivers/spi/spi-pic32.c                            |   4 +-
 drivers/tee/optee/core.c                           |   2 +-
 drivers/tty/serial/mxs-auart.c                     |   3 +-
 drivers/tty/serial/samsung.c                       |   8 ++
 drivers/tty/serial/xilinx_uartps.c                 |  41 ++----
 drivers/usb/chipidea/otg.c                         |   9 +-
 drivers/usb/chipidea/usbmisc_imx.c                 |   2 +
 drivers/usb/gadget/function/uvc_configfs.c         |   7 +
 drivers/usb/gadget/function/uvc_video.c            |  32 +++--
 drivers/usb/host/xhci-mtk-sch.c                    |   4 +-
 drivers/vfio/pci/vfio_pci.c                        |   8 +-
 drivers/vfio/pci/vfio_pci_config.c                 |  31 +++-
 fs/compat_ioctl.c                                  |  10 +-
 fs/ecryptfs/inode.c                                |  19 ++-
 fs/f2fs/recovery.c                                 |  17 +++
 fs/f2fs/super.c                                    |   6 +-
 fs/fuse/control.c                                  |   4 +-
 fs/gfs2/rgrp.c                                     |   2 +-
 fs/kernfs/symlink.c                                |   5 +-
 include/linux/cpufeature.h                         |   2 +-
 include/linux/edac.h                               |   3 +-
 include/linux/intel-iommu.h                        |   6 +-
 include/linux/libfdt_env.h                         |   1 +
 include/net/llc.h                                  |   1 +
 include/trace/events/sched.h                       |  11 +-
 kernel/events/uprobes.c                            |   4 +-
 kernel/kprobes.c                                   |   8 +-
 kernel/signal.c                                    |   4 +
 mm/hugetlb_cgroup.c                                |   2 +-
 mm/memcontrol.c                                    |   2 +-
 mm/shmem.c                                         |   2 +-
 net/bluetooth/l2cap_core.c                         |  10 ++
 net/ipv4/gre_demux.c                               |   7 +-
 net/ipv4/ip_gre.c                                  |   9 +-
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c        |  22 ++-
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c        |  19 ++-
 net/llc/llc_core.c                                 |   4 +-
 net/wireless/reg.c                                 |  46 ++++++
 samples/bpf/sockex2_kern.c                         |  11 +-
 samples/bpf/sockex3_kern.c                         |   8 +-
 samples/bpf/sockex3_user.c                         |   4 +-
 sound/core/oss/pcm_plugin.c                        |   4 +-
 sound/core/seq/seq_system.c                        |  18 ++-
 sound/pci/intel8x0m.c                              |  20 +--
 sound/soc/codecs/hdac_hdmi.c                       |   6 +
 sound/soc/codecs/sgtl5000.c                        |   2 +-
 sound/soc/sh/rcar/rsnd.h                           |   1 +
 sound/soc/sh/rcar/ssi.c                            |   4 +-
 sound/soc/soc-pcm.c                                |   2 +-
 sound/usb/endpoint.c                               |   3 +
 sound/usb/mixer.c                                  |   4 +-
 274 files changed, 1733 insertions(+), 750 deletions(-)


