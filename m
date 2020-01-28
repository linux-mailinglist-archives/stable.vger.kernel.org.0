Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACEB14B6D5
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgA1OIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgA1OIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:08:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22C6A22522;
        Tue, 28 Jan 2020 14:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220516;
        bh=5huWTV6z8DevSc/pXujO7G9BgOHxWFzse/xN54WNHzw=;
        h=From:To:Cc:Subject:Date:From;
        b=xJvOy5kv0arnkpghLu/0xty9gtv5X+Xq/U99PBzahiSSAND9Due0izn6ywbvzgZNT
         eQtsa0p6jscb5njYG38wk+5szU6MlxU3zebAqHZog3NofF1Rb8cx1ndaOgxhlYILgO
         7H5s6Z3BwHJ+ccD554F8rj2N9uCMa1SoAjrMScGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 000/183] 4.4.212-stable review
Date:   Tue, 28 Jan 2020 15:03:39 +0100
Message-Id: <20200128135829.486060649@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.212-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.212-rc1
X-KernelTest-Deadline: 2020-01-30T13:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.212 release.
There are 183 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.212-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.212-rc1

Wen Huang <huangwenabc@gmail.com>
    libertas: Fix two buffer overflows at parsing bss descriptor

Martin Schiller <ms@dev.tdt.de>
    net/x25: fix nonblocking connect

Kadlecsik József <kadlec@blackhole.kfki.hu>
    netfilter: ipset: use bitmap infrastructure completely

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    md: Avoid namespace collision with bitmap API

Bo Wu <wubo40@huawei.com>
    scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func

Lars Möllendorf <lars.moellendorf@plating.de>
    iio: buffer: align the size of scan bytes to size of the largest element

Al Viro <viro@zeniv.linux.org.uk>
    do_last(): fetch directory ->i_mode and ->i_uid before it's too late

Changbin Du <changbin.du@gmail.com>
    tracing: xen: Ordered comparison of function pointers

Bart Van Assche <bvanassche@acm.org>
    scsi: RDMA/isert: Fix a recently introduced regression related to logout

Gilles Buloz <gilles.buloz@kontron.com>
    hwmon: (nct7802) Fix voltage limits to wrong registers

Johan Hovold <johan@kernel.org>
    Input: aiptek - fix endpoint sanity check

Johan Hovold <johan@kernel.org>
    Input: gtco - fix endpoint sanity check

Johan Hovold <johan@kernel.org>
    Input: sur40 - fix interface sanity checks

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: sdhci: fix minimum clock rate for v3 controller

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 8950/1: ftrace/recordmcount: filter relocation types

Johan Hovold <johan@kernel.org>
    Input: keyspan-remote - fix control-message timeouts

Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
    hwmon: (adt7475) Make volt2reg return same reg as reg2volt input

James Hughes <james.hughes@raspberrypi.org>
    net: usb: lan78xx: Add .ndo_features_check

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix datalen for ematch

William Dauchy <w.dauchy@criteo.com>
    net, ip_tunnel: fix namespaces move

Michael Ellerman <mpe@ellerman.id.au>
    net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM

Wenwen Wang <wenwen@cs.uga.edu>
    firestream: fix memory leaks

Richard Palethorpe <rpalethorpe@suse.com>
    can, slip: Protect tty->disc_data in write_wakeup and close with RCU

Finn Thain <fthain@telegraphics.com.au>
    m68k: Call timer_interrupt() with interrupts disabled

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: juno: Fix UART frequency

Sam Bobroff <sbobroff@linux.ibm.com>
    drm/radeon: fix bad DMA from INTERRUPT_CNTL2

Chuhong Yuan <hslester96@gmail.com>
    dmaengine: ti: edma: fix missed failure handling

Eric Dumazet <edumazet@google.com>
    packet: fix data-race in fanout_flow_is_huge()

Eric Dumazet <edumazet@google.com>
    net: neigh: use long type to store jiffies delta

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson: Fix return value of loongson_hwmon_init

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix .get_fmt() V4L2_SUBDEV_FORMAT_TRY support

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix some format attributes not under control

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix incorrect use of JPEG colorspace

Stefan Wahren <stefan.wahren@in-tech.com>
    net: qca_spi: Move reset_count to struct qcaspi

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: fix size check for sdma script_number

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    drm/msm/dsi: Implement reset correctly

Antonio Borneo <antonio.borneo@st.com>
    net: stmmac: fix length of PTP clock's name string

Eric Biggers <ebiggers@google.com>
    llc: fix sk_buff refcounting in llc_conn_state_process()

Eric Biggers <ebiggers@google.com>
    llc: fix another potential sk_buff leak in llc_ui_sendmsg()

Johannes Berg <johannes.berg@intel.com>
    mac80211: accept deauth frames in IBSS mode

Dan Carpenter <dan.carpenter@oracle.com>
    net: ethernet: stmmac: Fix signedness bug in ipq806x_gmac_of_parse()

Dan Carpenter <dan.carpenter@oracle.com>
    net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    net: hisilicon: Fix signedness bug in hix5hd2_dev_probe()

Filippo Sironi <sironi@amazon.de>
    iommu/amd: Wait for completion of IOTLB flush in attach_device

Gerd Rausch <gerd.rausch@oracle.com>
    net/rds: Fix 'ib_evt_handler_call' element in 'rds_ib_stat_names'

Mao Wenan <maowenan@huawei.com>
    net: sonic: replace dev_kfree_skb in sonic_send_packet

Dan Robertson <dan@dlrobertson.com>
    hwmon: (shtc1) fix shtc1 and shtw1 id mask

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix hang when loading existing inode cache off disk

Mao Wenan <maowenan@huawei.com>
    net: sonic: return NETDEV_TX_OK if failed to map buffer

Lorenzo Bianconi <lorenzo@kernel.org>
    ath9k: dynack: fix possible deadlock in ath_dynack_node_{de}init

Colin Ian King <colin.king@canonical.com>
    iio: dac: ad5380: fix incorrect assignment to val

Colin Ian King <colin.king@canonical.com>
    bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA

Masami Hiramatsu <mhiramat@kernel.org>
    x86, perf: Fix the dependency of the x86 insn decoder selftest

Stephen Boyd <swboyd@chromium.org>
    power: supply: Init device wakeup after device_add()

Linus Torvalds <torvalds@linux-foundation.org>
    Partially revert "kfifo: fix kfifo_alloc() and kfifo_init()"

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ahci: Do not export local variable ahci_em_messages

Nick Desaulniers <ndesaulniers@google.com>
    mips: avoid explicit UB in assignment of mips_io_port_base

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel_ht: fix per-group max throughput rate initialization

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: platform: Switch to acpi_dma_controller_register()

Eric W. Biederman <ebiederm@xmission.com>
    signal: Allow cifs and drbd to receive their terminating signals

YueHaibing <yuehaibing@huawei.com>
    ASoC: wm8737: Fix copy-paste error in wm8737_snd_controls

YueHaibing <yuehaibing@huawei.com>
    ASoC: cs4349: Use PM ops 'cs4349_runtime_pm'

YueHaibing <yuehaibing@huawei.com>
    ASoC: es8328: Fix copy-paste error in es8328_right_line_controls

Colin Ian King <colin.king@canonical.com>
    ext4: set error return correctly when ext4_htree_store_dirent fails

Iuliana Prodan <iuliana.prodan@nxp.com>
    crypto: caam - free resources in case caam_rng registration failed

Steve French <stfrench@microsoft.com>
    cifs: fix rmmod regression in cifs.ko caused by force_sig changes

Johannes Berg <johannes@sipsolutions.net>
    ALSA: aoa: onyx: always initialize register read value

Thomas Gleixner <tglx@linutronix.de>
    x86/kgbd: Use NMI_VECTOR not APIC_DM_NMI

Arnd Bergmann <arnd@arndb.de>
    mic: avoid statically declaring a 'struct device'.

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: host: xhci-hub: fix extra endianness conversion

YueHaibing <yuehaibing@huawei.com>
    libertas_tf: Use correct channel range in lbtf_geo_init

Colin Ian King <colin.king@canonical.com>
    scsi: libfc: fix null pointer dereference on a null lport

Wen Yang <wen.yang99@zte.com.cn>
    net: pasemi: fix an use-after-free in pasemi_mac_phy_init()

Arnd Bergmann <arnd@arndb.de>
    devres: allow const resource arguments

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Release IDA resources

Kevin Mitchell <kevmitch@arista.com>
    iommu/amd: Make iommu_disable safer

Rob Clark <robdclark@chromium.org>
    drm/msm/a3xx: remove TPL1 regs from snapshot

Chen-Yu Tsai <wens@csie.org>
    rtc: pcf8563: Clear event flags and disable interrupts before requesting irq

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: ti: davinci-mcasp: Fix slot mask settings when using multiple AXRs

Julian Wiedmann <jwi@linux.ibm.com>
    net/af_iucv: always register net_device notifier

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    drm/msm/mdp5: Fix mdp5_cfg_init error return

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/cacheinfo: add cacheinfo_teardown, cacheinfo_rebuild

Colin Ian King <colin.king@canonical.com>
    media: vivid: fix incorrect assignment operation when setting video mode

Eric Dumazet <edumazet@google.com>
    inet: frags: call inet_frags_fini() after unregister_pernet_subsys()

Eric W. Biederman <ebiederm@xmission.com>
    signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: Use right function to get group for device

Nathan Chancellor <natechancellor@gmail.com>
    misc: sgi-xp: Properly initialize buf in xpc_get_rsvd_page_pa

Christophe Leroy <christophe.leroy@c-s.fr>
    spi: spi-fsl-spi: call spi_finalize_current_message() at the end

Matthias Kaehlcke <mka@chromium.org>
    thermal: cpu_cooling: Actually trace CPU load in thermal_power_cpu_get_power

Brian Masney <masneyb@onstation.org>
    backlight: lm3630a: Return 0 on success in update_status functions

Dan Carpenter <dan.carpenter@oracle.com>
    kdb: do a sanity check on the cpu in kdb_per_cpu()

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: riscpc: fix lack of keyboard interrupts after irq conversion

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last rule

Dan Carpenter <dan.carpenter@oracle.com>
    platform/x86: alienware-wmi: printing the wrong error code

Dan Carpenter <dan.carpenter@oracle.com>
    media: davinci/vpbe: array underflow in vpbe_enum_outputs()

Dan Carpenter <dan.carpenter@oracle.com>
    media: omap_vout: potential buffer overflow in vidioc_dqbuf()

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Make kernel parameter igfx_off work with vIOMMU

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mlx5: Add missing XRC options to QP optional params mask

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: fix valid stream condition

Willem de Bruijn <willemb@google.com>
    packet: in recvmsg msg_name return at least sizeof sockaddr_ll

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Handle the error from snd_usb_mixer_apply_create_quirk()

Alexandru Ardelean <alexandru.ardelean@analog.com>
    dmaengine: axi-dmac: Don't check the number of frames for alignment

Dan Carpenter <dan.carpenter@oracle.com>
    6lowpan: Off by one handling ->nexthdr

Akinobu Mita <akinobu.mita@gmail.com>
    media: ov2659: fix unbalanced mutex_lock/unlock

Ben Hutchings <ben@decadent.org.uk>
    powerpc: vdso: Make vdso32 installation conditional in vdso_install

Jie Liu <liujie165@huawei.com>
    tipc: set sysctl_tipc_rmem and named_timeout right range

Guenter Roeck <linux@roeck-us.net>
    hwmon: (w83627hf) Use request_muxed_region for Super-IO accesses

YueHaibing <yuehaibing@huawei.com>
    ARM: pxa: ssp: Fix "WARNING: invalid free of devm_ allocated data"

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Unregister chrdev if module initialization fails

YueHaibing <yuehaibing@huawei.com>
    ehea: Fix a copy-paste err in ehea_init_port_res

Martin Sperl <kernel@martin.sperl.org>
    spi: bcm2835aux: fix driver to not allow 65535 (=-1) cs-gpios

Dan Carpenter <dan.carpenter@oracle.com>
    soc/fsl/qe: Fix an error code in qe_pin_request()

Sowjanya Komatineni <skomatineni@nvidia.com>
    spi: tegra114: fix for unpacked mode transfers

Sowjanya Komatineni <skomatineni@nvidia.com>
    spi: tegra114: clear packed bit for unpacked mode

Arnd Bergmann <arnd@arndb.de>
    media: davinci-isif: avoid uninitialized variable use

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix potentially uninitialized return value for _setup_reset()

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Fix VIA timer counter accesses

Arnd Bergmann <arnd@arndb.de>
    jfs: fix bogus variable self-initialization

Nicholas Mc Guire <hofrat@osadl.org>
    media: cx23885: check allocation return

Dan Carpenter <dan.carpenter@oracle.com>
    media: wl128x: Fix an error code in fm_download_firmware()

Dan Carpenter <dan.carpenter@oracle.com>
    media: cx18: update *pos correctly in cx18_read_pos()

Dan Carpenter <dan.carpenter@oracle.com>
    media: ivtv: update *pos correctly in ivtv_read_pos()

Kangjie Lu <kjlu@umn.edu>
    net: sh_eth: fix a missing check of of_get_phy_mode

Dan Carpenter <dan.carpenter@oracle.com>
    xen, cpu_hotplug: Prevent an out of bounds access

Steve Sistare <steven.sistare@oracle.com>
    scsi: megaraid_sas: reduce module load time

Guenter Roeck <linux@roeck-us.net>
    nios2: ksyms: Add missing symbol exports

Axel Lin <axel.lin@ingics.com>
    regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: 8847/1: pm: fix HYP/SVC mode mismatch when MCPM is used

Chen-Yu Tsai <wens@csie.org>
    clocksource/drivers/sun5i: Fail gracefully when clock rate is unavailable

Eric W. Biederman <ebiederm@xmission.com>
    fs/nfs: Fix nfs_parse_devname to not modify it's argument

Takashi Iwai <tiwai@suse.de>
    ASoC: qcom: Fix of-node refcount unbalance in apq8016_sbc_parse_of()

Colin Ian King <colin.king@canonical.com>
    drm/nouveau/pmu: don't print reply values if exec is false

Colin Ian King <colin.king@canonical.com>
    drm/nouveau/bios/ramcfg: fix missing parentheses when calculating RON

YueHaibing <yuehaibing@huawei.com>
    cdc-wdm: pass return value of recover_from_urb_loss

Eric Auger <eric.auger@redhat.com>
    vfio_pci: Enable memory accesses before calling pci_map_rom

Ming Lei <ming.lei@redhat.com>
    block: don't use bio->bi_vcnt to figure out segment number

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: emev2: Add missing pinmux functions

YueHaibing <yuehaibing@huawei.com>
    fbdev: chipsfb: remove set but not used variable 'size'

Colin Ian King <colin.king@canonical.com>
    rtc: pm8xxx: fix unintended sign extension

Colin Ian King <colin.king@canonical.com>
    rtc: 88pm80x: fix unintended sign extension

Colin Ian King <colin.king@canonical.com>
    rtc: 88pm860x: fix unintended sign extension

Colin Ian King <colin.king@canonical.com>
    rtc: ds1672: fix unintended sign extension

YueHaibing <yuehaibing@huawei.com>
    tty: ipwireless: Fix potential NULL pointer dereference

Eric Wong <e@80x24.org>
    rtc: cmos: ignore bogus century byte

Stefan Agner <stefan@agner.ch>
    ASoC: imx-sgtl5000: put of nodes if finding codec fails

Eric Biggers <ebiggers@google.com>
    crypto: tgr192 - fix unaligned memory access

Pawe? Chmiel <pawel.mikolaj.chmiel@gmail.com>
    media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTART_INTERVAL

Gal Pressman <galpress@amazon.com>
    RDMA/ocrdma: Fix out of bounds index check in query pkey

Gal Pressman <galpress@amazon.com>
    IB/usnic: Fix out of bounds index check in query pkey

Yangtao Li <tiny.windzz@gmail.com>
    clk: armada-xp: fix refcount leak in axp_clk_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: kirkwood: fix refcount leak in kirkwood_clk_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: armada-370: fix refcount leak in a370_clk_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: vf610: fix refcount leak in vf610_clocks_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: imx7d: fix refcount leak in imx7d_clocks_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: imx6sx: fix refcount leak in imx6sx_clocks_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: imx6q: fix refcount leak in imx6q_clocks_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()

Yangtao Li <tiny.windzz@gmail.com>
    clk: socfpga: fix refcount leak

Yangtao Li <tiny.windzz@gmail.com>
    clk: qoriq: fix refcount leak in clockgen_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: highbank: fix refcount leak in hb_clk_init()

Dan Carpenter <dan.carpenter@oracle.com>
    Input: nomadik-ske-keypad - fix a loop timeout test

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Remove bogus IPSR10 value

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7269: Add missing PCIOR0 field

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Add missing IPSR11 field

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7794: Remove bogus IPSR9 field

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh73a0: Add missing TO pin to tpu4_to3 group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7791: Remove bogus marks from vin1_b_data18 group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7791: Remove bogus ctrl marks from qspi_data4_b group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7740: Add missing LCD0 marks to lcd0_data24_1 group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7740: Add missing REF125CK pin to gether_gmii group

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Skip validating ports during destruction, just ref

YueHaibing <yuehaibing@huawei.com>
    exportfs: fix 'passing zero to ERR_PTR()' warning

Colin Ian King <colin.king@canonical.com>
    pcrypt: use format specifier in kobject_add

Spencer E. Olson <olsonse@umich.edu>
    staging: comedi: ni_mio_common: protect register write overflow

Nicolas Huaman <nicolas@herochao.de>
    ALSA: usb-audio: update quirk for B&W PX to remove microphone

Anders Roxell <anders.roxell@linaro.org>
    ALSA: hda: fix unused variable warning

Dan Carpenter <dan.carpenter@oracle.com>
    drm/virtio: fix bounds check in virtio_gpu_cmd_get_capset()

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix bbp version check in mt7601u_wait_bbp_ready

Ard Biesheuvel <ardb@kernel.org>
    powerpc/archrandom: fix arch_get_random_seed_int()

Jan Kara <jack@suse.cz>
    xfs: Sanity check flags of Q_XQUOTARM call


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/common/mcpm_entry.c                       |   2 +-
 arch/arm/include/asm/suspend.h                     |   1 +
 arch/arm/kernel/sleep.S                            |  12 +++
 arch/arm/mach-omap2/omap_hwmod.c                   |   2 +-
 arch/arm/mach-rpc/irq.c                            |   3 +-
 arch/arm/plat-pxa/ssp.c                            |   6 --
 arch/arm64/boot/dts/arm/juno-clocks.dtsi           |   4 +-
 arch/m68k/amiga/cia.c                              |   9 ++
 arch/m68k/atari/ataints.c                          |   4 +-
 arch/m68k/atari/time.c                             |  15 ++-
 arch/m68k/bvme6000/config.c                        |  20 ++--
 arch/m68k/hp300/time.c                             |  10 +-
 arch/m68k/mac/via.c                                | 119 ++++++++++++---------
 arch/m68k/mvme147/config.c                         |  18 ++--
 arch/m68k/mvme16x/config.c                         |  21 ++--
 arch/m68k/q40/q40ints.c                            |  19 ++--
 arch/m68k/sun3/sun3ints.c                          |   3 +
 arch/m68k/sun3x/time.c                             |  16 +--
 arch/mips/include/asm/io.h                         |  14 +--
 arch/mips/kernel/setup.c                           |   2 +-
 arch/nios2/kernel/nios2_ksyms.c                    |  12 +++
 arch/powerpc/Makefile                              |   2 +
 arch/powerpc/include/asm/archrandom.h              |   2 +-
 arch/powerpc/kernel/cacheinfo.c                    |  21 ++++
 arch/powerpc/kernel/cacheinfo.h                    |   4 +
 arch/powerpc/sysdev/qe_lib/gpio.c                  |   4 +-
 arch/x86/Kconfig.debug                             |   2 +-
 arch/x86/kernel/kgdb.c                             |   2 +-
 block/blk-merge.c                                  |   8 +-
 crypto/pcrypt.c                                    |   2 +-
 crypto/tgr192.c                                    |   6 +-
 drivers/ata/libahci.c                              |   1 -
 drivers/atm/firestream.c                           |   3 +
 drivers/bcma/driver_pci.c                          |   4 +-
 drivers/block/drbd/drbd_main.c                     |   2 +
 drivers/clk/clk-highbank.c                         |   1 +
 drivers/clk/clk-qoriq.c                            |   1 +
 drivers/clk/imx/clk-imx6q.c                        |   1 +
 drivers/clk/imx/clk-imx6sx.c                       |   1 +
 drivers/clk/imx/clk-imx7d.c                        |   1 +
 drivers/clk/imx/clk-vf610.c                        |   1 +
 drivers/clk/mvebu/armada-370.c                     |   4 +-
 drivers/clk/mvebu/armada-xp.c                      |   4 +-
 drivers/clk/mvebu/kirkwood.c                       |   2 +
 drivers/clk/samsung/clk-exynos4.c                  |   1 +
 drivers/clk/socfpga/clk-pll-a10.c                  |   1 +
 drivers/clk/socfpga/clk-pll.c                      |   1 +
 drivers/clocksource/timer-sun5i.c                  |  10 ++
 drivers/crypto/caam/caamrng.c                      |   5 +-
 drivers/dma/dma-axi-dmac.c                         |   2 +-
 drivers/dma/dw/platform.c                          |  14 ++-
 drivers/dma/edma.c                                 |   6 +-
 drivers/dma/imx-sdma.c                             |   8 ++
 drivers/gpu/drm/drm_dp_mst_topology.c              |  15 ++-
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  24 ++---
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   6 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c            |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gddr3.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c     |   4 +-
 drivers/gpu/drm/radeon/cik.c                       |   4 +-
 drivers/gpu/drm/radeon/r600.c                      |   4 +-
 drivers/gpu/drm/radeon/si.c                        |   4 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   5 +-
 drivers/hwmon/adt7475.c                            |   5 +-
 drivers/hwmon/nct7802.c                            |   4 +-
 drivers/hwmon/shtc1.c                              |   2 +-
 drivers/hwmon/w83627hf.c                           |  42 +++++++-
 drivers/iio/dac/ad5380.c                           |   2 +-
 drivers/iio/industrialio-buffer.c                  |   6 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  21 ++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  12 ---
 drivers/input/keyboard/nomadik-ske-keypad.c        |   2 +-
 drivers/input/misc/keyspan_remote.c                |   9 +-
 drivers/input/tablet/aiptek.c                      |   6 +-
 drivers/input/tablet/gtco.c                        |  10 +-
 drivers/input/touchscreen/sur40.c                  |   2 +-
 drivers/iommu/amd_iommu.c                          |   2 +
 drivers/iommu/amd_iommu_init.c                     |   3 +
 drivers/iommu/intel-iommu.c                        |   5 +-
 drivers/iommu/iommu.c                              |   6 +-
 drivers/md/bitmap.c                                |   8 +-
 drivers/media/i2c/ov2659.c                         |   2 +-
 drivers/media/i2c/soc_camera/ov6650.c              |  72 ++++++++-----
 drivers/media/pci/cx18/cx18-fileops.c              |   2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   5 +-
 drivers/media/pci/ivtv/ivtv-fileops.c              |   2 +-
 drivers/media/platform/davinci/isif.c              |   9 --
 drivers/media/platform/davinci/vpbe.c              |   2 +-
 drivers/media/platform/omap/omap_vout.c            |  15 ++-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   2 +-
 drivers/media/platform/vivid/vivid-osd.c           |   2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   5 +-
 drivers/mfd/intel-lpss.c                           |   1 +
 drivers/misc/mic/card/mic_x100.c                   |  28 +++--
 drivers/misc/sgi-xp/xpc_partition.c                |   2 +-
 drivers/mmc/host/sdhci.c                           |  10 +-
 drivers/net/can/slcan.c                            |  12 ++-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   2 +
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   2 +-
 drivers/net/ethernet/natsemi/sonic.c               |   6 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |   2 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |   9 +-
 drivers/net/ethernet/qualcomm/qca_spi.h            |   1 +
 drivers/net/ethernet/renesas/sh_eth.c              |   6 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +-
 drivers/net/slip/slip.c                            |  12 ++-
 drivers/net/usb/lan78xx.c                          |  15 +++
 drivers/net/wireless/ath/ath9k/dynack.c            |   8 +-
 drivers/net/wireless/libertas/cfg.c                |  16 ++-
 drivers/net/wireless/libertas_tf/cmd.c             |   2 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c        |   2 +-
 drivers/pinctrl/sh-pfc/pfc-emev2.c                 |  20 ++++
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c               |   3 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c               |   8 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7794.c               |   2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                |   2 +-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                |   4 +-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |   4 +-
 drivers/platform/mips/cpu_hwmon.c                  |   2 +-
 drivers/platform/x86/alienware-wmi.c               |   2 +-
 drivers/power/power_supply_core.c                  |  10 +-
 drivers/regulator/wm831x-dcdc.c                    |   4 +-
 drivers/rtc/rtc-88pm80x.c                          |  21 ++--
 drivers/rtc/rtc-88pm860x.c                         |  21 ++--
 drivers/rtc/rtc-ds1672.c                           |   3 +-
 drivers/rtc/rtc-pcf8563.c                          |  11 +-
 drivers/rtc/rtc-pm8xxx.c                           |   6 +-
 drivers/scsi/libfc/fc_exch.c                       |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  34 +++---
 drivers/scsi/scsi_transport_iscsi.c                |   7 ++
 drivers/spi/spi-bcm2835aux.c                       |  13 ++-
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/spi/spi-tegra114.c                         |  45 ++++++--
 drivers/staging/comedi/drivers/ni_mio_common.c     |  24 +++--
 drivers/target/iscsi/iscsi_target.c                |   6 +-
 drivers/thermal/cpu_cooling.c                      |   2 +-
 drivers/tty/ipwireless/hardware.c                  |   2 +
 drivers/usb/class/cdc-wdm.c                        |   2 +-
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/vfio/pci/vfio_pci.c                        |  19 +++-
 drivers/video/backlight/lm3630a_bl.c               |   4 +-
 drivers/video/fbdev/chipsfb.c                      |   3 +-
 drivers/xen/cpu_hotplug.c                          |   2 +-
 fs/btrfs/inode-map.c                               |   1 +
 fs/cifs/connect.c                                  |   3 +-
 fs/exportfs/expfs.c                                |   1 +
 fs/ext4/inline.c                                   |   2 +-
 fs/jfs/jfs_txnmgr.c                                |   3 +-
 fs/namei.c                                         |  17 +--
 fs/nfs/super.c                                     |   2 +-
 fs/xfs/xfs_quotaops.c                              |   3 +
 include/asm-generic/rtc.h                          |   2 +-
 include/linux/bitmap.h                             |   8 ++
 include/linux/device.h                             |   3 +-
 include/linux/netfilter/ipset/ip_set.h             |   7 --
 include/linux/platform_data/dma-imx-sdma.h         |   3 +
 include/linux/signal.h                             |  15 ++-
 include/media/davinci/vpbe.h                       |   2 +-
 include/trace/events/xen.h                         |   6 +-
 kernel/debug/kdb/kdb_main.c                        |   2 +-
 kernel/signal.c                                    |   5 +
 lib/bitmap.c                                       |  20 ++++
 lib/devres.c                                       |   3 +-
 lib/kfifo.c                                        |   3 +-
 net/6lowpan/nhc.c                                  |   2 +-
 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/core/neighbour.c                               |   4 +-
 net/ieee802154/6lowpan/reassembly.c                |   2 +-
 net/ipv4/ip_tunnel.c                               |   4 +-
 net/ipv6/reassembly.c                              |   2 +-
 net/iucv/af_iucv.c                                 |  27 +++--
 net/llc/af_llc.c                                   |  34 +++---
 net/llc/llc_conn.c                                 |  35 ++----
 net/llc/llc_if.c                                   |  12 ++-
 net/mac80211/rc80211_minstrel_ht.c                 |   2 +-
 net/mac80211/rx.c                                  |  11 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   6 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   6 +-
 net/netfilter/ipset/ip_set_bitmap_port.c           |   6 +-
 net/packet/af_packet.c                             |  25 ++++-
 net/rds/ib_stats.c                                 |   2 +-
 net/sched/ematch.c                                 |   2 +-
 net/tipc/sysctl.c                                  |   8 +-
 net/x25/af_x25.c                                   |   6 +-
 scripts/recordmcount.c                             |  17 +++
 sound/aoa/codecs/onyx.c                            |   4 +-
 sound/pci/hda/hda_controller.h                     |   9 +-
 sound/soc/codecs/cs4349.c                          |   1 +
 sound/soc/codecs/es8328.c                          |   2 +-
 sound/soc/codecs/wm8737.c                          |   2 +-
 sound/soc/davinci/davinci-mcasp.c                  |  13 ++-
 sound/soc/fsl/imx-sgtl5000.c                       |   3 +-
 sound/soc/qcom/apq8016_sbc.c                       |  21 +++-
 sound/soc/soc-pcm.c                                |   4 +-
 sound/usb/mixer.c                                  |   4 +-
 sound/usb/quirks-table.h                           |   9 +-
 204 files changed, 1064 insertions(+), 560 deletions(-)


