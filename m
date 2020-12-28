Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522952E37C3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgL1NAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:00:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbgL1NAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:00:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B84A208BA;
        Mon, 28 Dec 2020 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160368;
        bh=Xhi74Gkc9VBUFGMEd4+4qXtaM3FUvHbkuqw1odvp6VY=;
        h=From:To:Cc:Subject:Date:From;
        b=Ku91NXhPs2wiAfjvjL4FNi9GxcdDlwcUcly7c+QmaC1N2/9ggxzC6kYxOEtGcSW5b
         KoMLlWeuJedgTKUU98azz0XNIqsYh/iI9HacAv+J+5KZuuL6VgX/uafpE63lBlI/A7
         uSZOI1pOkurLM4ZoStQ57ZG6/YmtUc40dRv1cfns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.9 000/175] 4.9.249-rc1 review
Date:   Mon, 28 Dec 2020 13:47:33 +0100
Message-Id: <20201228124853.216621466@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.249-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.249-rc1
X-KernelTest-Deadline: 2020-12-30T12:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.249 release.
There are 175 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.249-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.249-rc1

Jubin Zhong <zhongjubin@huawei.com>
    PCI: Fix pci_slot_release() NULL pointer dereference

Pawel Wieczorkiewicz <wipawel@amazon.de>
    xen-blkback: set ring->xenblkd to NULL after kthread_stop()

Terry Zhou <bjzhou@marvell.com>
    clk: mvebu: a3700: fix the XTAL MODE pin to MPP1_9

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:pressure:mpl3115: Force alignment of buffer

Qinglang Miao <miaoqinglang@huawei.com>
    iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on error in rockchip_saradc_resume

Nuno Sá <nuno.sa@analog.com>
    iio: buffer: Fix demux update

Sven Eckelmann <sven@narfation.org>
    mtd: parser: cmdline: Fix parsing of part-names with colons

Evan Green <evgreen@chromium.org>
    soc: qcom: smp2p: Safely acquire spinlock without IRQs

Lukas Wunner <lukas@wunner.de>
    spi: st-ssc4: Fix unbalanced pm_runtime_disable() in probe error path

Lukas Wunner <lukas@wunner.de>
    spi: sc18is602: Don't leak SPI master in probe error path

Lukas Wunner <lukas@wunner.de>
    spi: rb4xx: Don't leak SPI master in probe error path

Lukas Wunner <lukas@wunner.de>
    spi: pic32: Don't leak DMA channels in probe error path

Lukas Wunner <lukas@wunner.de>
    spi: davinci: Fix use-after-free on unbind

Lukas Wunner <lukas@wunner.de>
    spi: spi-sh: Fix use-after-free on unbind

Zwane Mwaikambo <zwane@yosper.io>
    drm/dp_aux_dev: check aux_dev before use in drm_dp_aux_dev_get_by_minor()

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: Fix array index bounds check in dbAdjTree

Zhe Li <lizhe67@huawei.com>
    jffs2: Fix GC exit abnormally

Luis Henriques <lhenriques@suse.de>
    ceph: fix race in concurrent __ceph_remove_cap invocations

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/xmon: Change printk() to pr_cont()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Introduce handling of AArch32 TTBCR2 traps

Chunguang Xu <brookxu@tencent.com>
    ext4: fix a memory leak of ext4_free_data

Pavel Machek <pavel@denx.de>
    btrfs: fix return value mixup in btrfs_get_extent

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix selftests failure due to uninitialized i_mode in test inodes

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: Don't use inode page cache in scrub_handle_errored_block()

Qu Wenruo <wqu@suse.com>
    btrfs: quota: Set rescan progress to (u64)-1 if we hit last leaf

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix write unthrottling

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix tx-unthrottle use-after-free

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix write-wakeup use-after-free

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix stalled writes

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix write deadlock

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix dropped unthrottle interrupts

Johan Hovold <johan@kernel.org>
    USB: serial: mos7720: fix parallel-port state restore

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Exclude kernel samples while counting events in user space.

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: mf6x4: Fix AI end-of-conversion detection

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix list corruption of lcu list

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix list corruption of pavgroup group list

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: prevent inconsistent LCU device data

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Disable sample read check if firmware doesn't give back

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix a few more UBSAN fixes

Hui Wang <hui.wang@canonical.com>
    ACPI: PNP: compare the string length in the matching_id()

Daniel Scally <djrscally@gmail.com>
    Revert "ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks"

Arnd Bergmann <arnd@arndb.de>
    Input: cyapa_gen6 - fix out-of-bounds stack access

Lukas Wunner <lukas@wunner.de>
    media: netup_unidvb: Don't leak SPI master in probe error path

Sean Young <sean@mess.org>
    media: sunxi-cir: ensure IR is handled when it is continuous

Alan Stern <stern@rowland.harvard.edu>
    media: gspca: Fix memory leak in probe

Simon Beginn <linux@simonmicro.de>
    Input: goodix - add upside-down quirk for Teclast X98 Pro tablet

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: cros_ec_keyb - send 'scancodes' in addition to key events

Sara Sharon <sara.sharon@intel.com>
    cfg80211: initialize rekey_data

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    clk: s2mps11: Fix a resource leak in error handling paths in the probe function

Dan Carpenter <dan.carpenter@oracle.com>
    qlcnic: Fix error code in probe

Zheng Zengkai <zhengzengkai@huawei.com>
    perf record: Fix memory leak when using '--user-regs=?' to list registers

Zhang Qilong <zhangqilong3@huawei.com>
    clk: ti: Fix memleak in ti_fapll_synth_setup

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    watchdog: qcom: Avoid context switch in restart handler

Vincent Stehlé <vincent.stehle@laposte.net>
    net: korina: fix return value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: bcmgenet: Fix a resource leak in an error handling path in the probe functin

Dwaipayan Ray <dwaipayanray1@gmail.com>
    checkpatch: fix unescaped left brace

Vincent Stehlé <vincent.stehle@laposte.net>
    powerpc/ps3: use dma_mapping_error()

Bongsu Jeon <bongsu.jeon@samsung.com>
    nfc: s3fwrn5: Release the nfc firmware

Anton Ivanov <anton.ivanov@cambridgegreys.com>
    um: chan_xterm: Fix fd leak

Marc Zyngier <maz@kernel.org>
    irqchip/alpine-msi: Fix freeing of interrupts on allocation error path

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: wm_adsp: remove "ctl" from list on error in wm_adsp_create_control()

Marek Szyprowski <m.szyprowski@samsung.com>
    extcon: max77693: Fix modalias string

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: Fix duplicated SE clock entry

Masami Hiramatsu <mhiramat@kernel.org>
    x86/kprobes: Restore BTF if the single-stepping is cancelled

Cheng Lin <cheng.lin130@zte.com.cn>
    nfs_common: need lock during iterate through the list

kazuo ito <kzpn200@gmail.com>
    nfsd: Fix message level for normal termination

Yang Yingliang <yangyingliang@huawei.com>
    speakup: fix uninitialized flush_lock

Zhang Qilong <zhangqilong3@huawei.com>
    usb: oxu210hp-hcd: Fix memory leak in oxu_create

Zhang Qilong <zhangqilong3@huawei.com>
    usb: ehci-omap: Fix PM disable depth umbalance in ehci_hcd_omap_probe

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/hibernation: drop pseries_suspend_begin() from suspend ops

Zhang Changzhong <zhangchangzhong@huawei.com>
    scsi: fnic: Fix error return code in fnic_probe()

Arnd Bergmann <arnd@arndb.de>
    seq_buf: Avoid type mismatch for seq_buf_init

Zhang Qilong <zhangqilong3@huawei.com>
    scsi: pm80xx: Fix error return in pm8001_pci_probe()

Pali Rohár <pali@kernel.org>
    cpufreq: scpi: Add missing MODULE_ALIAS

Pali Rohár <pali@kernel.org>
    cpufreq: loongson1: Add missing MODULE_ALIAS

Pali Rohár <pali@kernel.org>
    cpufreq: st: Add missing MODULE_DEVICE_TABLE

Pali Rohár <pali@kernel.org>
    cpufreq: highbank: Add missing MODULE_DEVICE_TABLE

Keqian Zhu <zhukeqian1@huawei.com>
    clocksource/drivers/arm_arch_timer: Correct fault programming of CNTKCTL_EL1.EVNTI

Qinglang Miao <miaoqinglang@huawei.com>
    dm ioctl: fix error return code in target_message

Chuhong Yuan <hslester96@gmail.com>
    ASoC: jz4740-i2s: add missed checks for clk_get()

Jing Xiangfeng <jingxiangfeng@huawei.com>
    memstick: r592: Fix error return in r592_probe()

Yu Kuai <yukuai3@huawei.com>
    pinctrl: falcon: add missing put_device() call in pinctrl_falcon_probe()

Yu Kuai <yukuai3@huawei.com>
    clocksource/drivers/cadence_ttc: Fix memory leak in ttc_setup_clockevent()

Dan Carpenter <dan.carpenter@oracle.com>
    media: saa7146: fix array overflow in vidioc_s_audio()

Jason Gunthorpe <jgg@nvidia.com>
    vfio-pci: Use io_remap_pfn_range() for PCI IO memory

NeilBrown <neilb@suse.de>
    NFS: switch nfsiod to be an UNBOUND workqueue.

Calum Mackay <calum.mackay@oracle.com>
    lockd: don't use interval-based rebinding over TCP

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: xprt_load_transport() needs to support the netid "rdma6"

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.2: condition READDIR's mask for security label based on LSM state

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: at91: at91sam9rl: fix ADC triggers

Jing Xiangfeng <jingxiangfeng@huawei.com>
    HSI: omap_ssi: Don't jump to free ID in ssi_add_controller()

Qinglang Miao <miaoqinglang@huawei.com>
    mips: cdmm: fix use-after-free in mips_cdmm_bus_discover

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    media: siano: fix memory leak of debugfs members in smsdvb_hotplug

Qinglang Miao <miaoqinglang@huawei.com>
    cw1200: fix missing destroy_workqueue() on error in cw1200_init_common

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    orinoco: Move context allocation after processing the skb

Cristian Birsan <cristian.birsan@microchip.com>
    ARM: dts: at91: sama5d3_xplained: add pincontrol for USB Host

Cristian Birsan <cristian.birsan@microchip.com>
    ARM: dts: at91: sama5d4_xplained: add pincontrol for USB Host

Qinglang Miao <miaoqinglang@huawei.com>
    memstick: fix a double-free bug in memstick_check

Kamal Heib <kamalheib1@gmail.com>
    RDMA/cxgb4: Validate the number of CQEs

Zhihao Cheng <chengzhihao1@huawei.com>
    drivers: soc: ti: knav_qmss_queue: Fix error return code in knav_queue_probe

Zhang Qilong <zhangqilong3@huawei.com>
    soc: ti: Fix reference imbalance in knav_dma_probe

Zhang Qilong <zhangqilong3@huawei.com>
    soc: ti: knav_qmss: fix reference leak in knav_queue_probe

Zhang Qilong <zhangqilong3@huawei.com>
    crypto: omap-aes - Fix PM disable depth imbalance in omap_aes_probe

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/feature: Fix CPU_FTRS_ALWAYS by removing CPU_FTRS_GENERIC_32

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ads7846 - fix unaligned access on 7845

Oleksij Rempel <o.rempel@pengutronix.de>
    Input: ads7846 - fix integer overflow on Rt calculation

Yang Yingliang <yangyingliang@huawei.com>
    drm/omap: dmm_tiler: fix return error code in omap_dmm_probe()

Qinglang Miao <miaoqinglang@huawei.com>
    media: solo6x10: fix missing snd_card_free in error handling case

Zhang Qilong <zhangqilong3@huawei.com>
    staging: greybus: codecs: Fix reference counter leak in error handling

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    MIPS: BCM47XX: fix kconfig dependency bug for BCM47XX_BCMA

Arnd Bergmann <arnd@arndb.de>
    RDMa/mthca: Work around -Wenum-conversion warning

Vincent Bernat <vincent@bernat.ch>
    net: evaluate net.ipv4.conf.all.proxy_arp_pvlan

Vincent Bernat <vincent@bernat.ch>
    net: evaluate net.ipvX.conf.all.ignore_routes_with_linkdown

Zhang Qilong <zhangqilong3@huawei.com>
    spi: tegra114: fix reference leak in tegra spi ops

Zhang Qilong <zhangqilong3@huawei.com>
    spi: tegra20-sflash: fix reference leak in tegra_sflash_resume

Zhang Qilong <zhangqilong3@huawei.com>
    spi: tegra20-slink: fix reference leak in slink ops of tegra20

Zhang Qilong <zhangqilong3@huawei.com>
    spi: spi-ti-qspi: fix reference leak in ti_qspi_setup

Anmol Karn <anmol.karan123@gmail.com>
    Bluetooth: Fix null pointer dereference in hci_event_packet()

Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
    arm64: dts: exynos: Correct psci compatible used on Exynos7

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: pcm: DRAIN support reactivation

Zhang Qilong <zhangqilong3@huawei.com>
    spi: img-spfi: fix reference leak in img_spfi_resume

Christophe Leroy <christophe.leroy@csgroup.eu>
    crypto: talitos - Fix return type of current_desc_hdr()

Ard Biesheuvel <ardb@kernel.org>
    ARM: p2v: fix handling of LPAE translation in BE mode

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Compute PSN windows correctly

Tom Rix <trix@redhat.com>
    drm/gma500: fix double free of gma_connector

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()

Dae R. Jeong <dae.r.jeong@kaist.ac.kr>
    md: fix a warning caused by a race between concurrent md_ioctl()s

Antti Palosaari <crope@iki.fi>
    media: msi2500: assign SPI bus number dynamically

Alexey Kardashevskiy <aik@ozlabs.ru>
    serial_core: Check for port state when tty is in error state

Julian Sax <jsbc@gmx.de>
    HID: i2c-hid: add Vero K147 to descriptor override

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: fix USB 3.0 pins supply being turned off on Odroid XU

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: fix USB 3.0 VBUS control and over-current pins on Exynos5410

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: fix roles of USB 3.0 ports on Odroid XU

Fabio Estevam <festevam@gmail.com>
    usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to imx6ul

Jack Pham <jackp@codeaurora.org>
    usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus

Will McVicker <willmcvicker@google.com>
    USB: gadget: f_rndis: fix bitrate for SuperSpeed and above

Will McVicker <willmcvicker@google.com>
    USB: gadget: f_midi: setup SuperSpeed Plus descriptors

taehyun.cho <taehyun.cho@samsung.com>
    USB: gadget: f_acm: add support for SuperSpeed Plus

Johan Hovold <johan@kernel.org>
    USB: serial: option: add interface-number sanity check to flag handling

Nicolin Chen <nicoleotsuka@gmail.com>
    soc/tegra: fuse: Fix index bug in get_process_id

Thomas Gleixner <tglx@linutronix.de>
    dm table: Remove BUG_ON(in_interrupt())

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Increase IOCInit request timeout to 30s

Qinglang Miao <miaoqinglang@huawei.com>
    drm/tegra: sor: Disable clocks on error in tegra_sor_init()

Nicholas Piggin <npiggin@gmail.com>
    kernel/cpu: add arch override for clear_tasks_mm_cpumask() mm handling

Leon Romanovsky <leonro@nvidia.com>
    RDMA/cm: Fix an attempt to use non-valid pointer when cleaning timewait

Zhang Qilong <zhangqilong3@huawei.com>
    can: softing: softing_netdev_open(): fix error handling

Randy Dunlap <rdunlap@infradead.org>
    scsi: bnx2i: Requires MMU

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: baytrail: Avoid clearing debounce value when turning it off

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: merrifield: Set default bias in case no particular value given

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix potential out-of-bounds shift

Thomas Gleixner <tglx@linutronix.de>
    USB: sisusbvga: Make console support depend on BROKEN

Li Jun <jun.li@nxp.com>
    xhci: Give USB2 ports time to enter U3 in bus suspend

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix control 'access overflow' errors from chmap

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential out-of-bounds shift

Oliver Neukum <oneukum@suse.com>
    USB: add RESET_RESUME quirk for Snapscan 1212

Bui Quang Minh <minhquangbui99@gmail.com>
    USB: dummy-hcd: Fix uninitialized array use in init()

Eric Dumazet <edumazet@google.com>
    mac80211: mesh: fix mesh_pathtbl_init() error path

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: bridge: vlan: fix error return code in __vlan_add()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: stmmac: dwmac-meson8b: fix mask definition of the m250_sel mux

Fugang Duan <fugang.duan@nxp.com>
    net: stmmac: delete the eee_ctrl_timer after napi disabled

Neal Cardwell <ncardwell@google.com>
    tcp: fix cwnd-limited bug for TSO deferral where we send nothing

Moshe Shemesh <moshe@mellanox.com>
    net/mlx4_en: Avoid scheduling restart task if it is already running

Lukas Wunner <lukas@wunner.de>
    spi: Prevent adding devices below an unregistering controller

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: be2iscsi: Revert "Fix a theoretical leak in beiscsi_create_eqs()"

Coiby Xu <coiby.xu@gmail.com>
    pinctrl: amd: remove debounce filter setting in IRQ type setting

Chris Chiu <chiu@endlessos.org>
    Input: i8042 - add Acer laptops to the i8042 reset list

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: cm109 - do not stomp on control URB

Timo Witte <timo.witte@gmail.com>
    platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE

Vineet Gupta <vgupta@synopsys.com>
    ARC: stack unwinding: don't assume non-current task is sleeping

Markus Reichl <m.reichl@fivetechno.de>
    arm64: dts: rockchip: Assign a fixed index to mmc devices on rk3399 boards.

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: limit memory read spin time

Nathan Chancellor <natechancellor@gmail.com>
    spi: bcm2835aux: Restore err assignment in bcm2835aux_spi_probe

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835aux: Fix use-after-free on unbind


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt             |  3 +
 Makefile                                           |  4 +-
 arch/arc/kernel/stacktrace.c                       | 23 +++++---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |  7 +++
 arch/arm/boot/dts/at91-sama5d4_xplained.dts        |  7 +++
 arch/arm/boot/dts/at91sam9rl.dtsi                  | 19 ++++---
 arch/arm/boot/dts/exynos5410-odroidxu.dts          |  6 +-
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi          | 28 ++++++++++
 arch/arm/boot/dts/exynos5410.dtsi                  |  4 ++
 arch/arm/kernel/head.S                             |  6 +-
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |  4 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  3 +
 arch/arm64/include/asm/kvm_host.h                  |  1 +
 arch/arm64/kvm/sys_regs.c                          |  1 +
 arch/mips/bcm47xx/Kconfig                          |  1 +
 arch/powerpc/include/asm/cputable.h                |  5 --
 arch/powerpc/perf/core-book3s.c                    | 10 ++++
 arch/powerpc/platforms/pseries/suspend.c           |  1 -
 arch/powerpc/xmon/nonstdio.c                       |  2 +-
 arch/um/drivers/xterm.c                            |  5 ++
 arch/x86/kernel/kprobes/core.c                     |  5 ++
 drivers/acpi/acpi_pnp.c                            |  3 +
 drivers/acpi/resource.c                            |  2 +-
 drivers/block/xen-blkback/xenbus.c                 |  1 +
 drivers/bus/mips_cdmm.c                            |  4 +-
 drivers/clk/clk-s2mps11.c                          |  1 +
 drivers/clk/mvebu/armada-37xx-xtal.c               |  4 +-
 drivers/clk/tegra/clk-id.h                         |  1 +
 drivers/clk/tegra/clk-tegra-periph.c               |  2 +-
 drivers/clk/ti/fapll.c                             | 11 +++-
 drivers/clocksource/arm_arch_timer.c               | 23 +++++---
 drivers/clocksource/cadence_ttc_timer.c            | 18 +++---
 drivers/cpufreq/highbank-cpufreq.c                 |  7 +++
 drivers/cpufreq/loongson1-cpufreq.c                |  1 +
 drivers/cpufreq/scpi-cpufreq.c                     |  1 +
 drivers/cpufreq/sti-cpufreq.c                      |  7 +++
 drivers/crypto/omap-aes.c                          |  3 +-
 drivers/crypto/talitos.c                           |  6 +-
 drivers/extcon/extcon-max77693.c                   |  2 +-
 drivers/gpu/drm/drm_dp_aux_dev.c                   |  2 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |  2 +-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c           |  1 +
 drivers/gpu/drm/tegra/sor.c                        | 10 +++-
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  8 +++
 drivers/hsi/controllers/omap_ssi_core.c            |  2 +-
 drivers/iio/adc/rockchip_saradc.c                  |  2 +-
 drivers/iio/industrialio-buffer.c                  |  6 +-
 drivers/iio/pressure/mpl3115.c                     |  9 ++-
 drivers/infiniband/core/cm.c                       |  2 +
 drivers/infiniband/hw/cxgb4/cq.c                   |  3 +
 drivers/infiniband/hw/mthca/mthca_cq.c             |  2 +-
 drivers/infiniband/hw/mthca/mthca_dev.h            |  1 -
 drivers/infiniband/sw/rxe/rxe_req.c                |  3 +-
 drivers/input/keyboard/cros_ec_keyb.c              |  1 +
 drivers/input/misc/cm109.c                         |  7 ++-
 drivers/input/mouse/cyapa_gen6.c                   |  2 +-
 drivers/input/serio/i8042-x86ia64io.h              | 42 ++++++++++++++
 drivers/input/touchscreen/ads7846.c                |  8 ++-
 drivers/input/touchscreen/goodix.c                 | 12 ++++
 drivers/irqchip/irq-alpine-msi.c                   |  3 +-
 drivers/md/dm-ioctl.c                              |  1 +
 drivers/md/dm-table.c                              |  6 --
 drivers/md/md.c                                    |  7 ++-
 drivers/media/common/siano/smsdvb-main.c           |  5 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c  |  5 +-
 drivers/media/pci/saa7146/mxb.c                    | 19 ++++---
 drivers/media/pci/solo6x10/solo6x10-g723.c         |  2 +-
 drivers/media/rc/sunxi-cir.c                       |  2 +
 drivers/media/usb/gspca/gspca.c                    |  1 +
 drivers/media/usb/msi2500/msi2500.c                |  2 +-
 drivers/memstick/core/memstick.c                   |  1 -
 drivers/memstick/host/r592.c                       | 12 ++--
 drivers/mtd/cmdlinepart.c                          | 14 ++++-
 drivers/net/can/softing/softing_main.c             |  9 ++-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |  7 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  4 +-
 drivers/net/ethernet/korina.c                      |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     | 20 ++++---
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |  7 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |  6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 13 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 36 +++++++++---
 .../net/wireless/intersil/orinoco/orinoco_usb.c    | 14 ++---
 drivers/net/wireless/st/cw1200/main.c              |  2 +
 drivers/nfc/s3fwrn5/firmware.c                     |  4 +-
 drivers/pci/slot.c                                 |  6 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c           |  8 ++-
 drivers/pinctrl/intel/pinctrl-merrifield.c         |  8 +++
 drivers/pinctrl/pinctrl-amd.c                      |  7 ---
 drivers/pinctrl/pinctrl-falcon.c                   | 14 +++--
 drivers/platform/x86/acer-wmi.c                    |  1 +
 drivers/ps3/ps3stor_lib.c                          |  2 +-
 drivers/s390/block/dasd_alias.c                    | 12 +++-
 drivers/scsi/be2iscsi/be_main.c                    |  4 +-
 drivers/scsi/bnx2i/Kconfig                         |  1 +
 drivers/scsi/fnic/fnic_main.c                      |  1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  2 +-
 drivers/scsi/pm8001/pm8001_init.c                  |  3 +-
 drivers/soc/qcom/smp2p.c                           |  5 +-
 drivers/soc/tegra/fuse/speedo-tegra210.c           |  2 +-
 drivers/soc/ti/knav_dma.c                          | 13 ++++-
 drivers/soc/ti/knav_qmss_queue.c                   |  4 +-
 drivers/spi/Kconfig                                |  3 +
 drivers/spi/spi-bcm2835aux.c                       | 17 ++----
 drivers/spi/spi-davinci.c                          |  2 +-
 drivers/spi/spi-img-spfi.c                         |  4 +-
 drivers/spi/spi-pic32.c                            |  1 +
 drivers/spi/spi-rb4xx.c                            |  2 +-
 drivers/spi/spi-sc18is602.c                        | 13 +----
 drivers/spi/spi-sh.c                               | 13 ++---
 drivers/spi/spi-st-ssc4.c                          |  5 +-
 drivers/spi/spi-tegra114.c                         |  2 +
 drivers/spi/spi-tegra20-sflash.c                   |  1 +
 drivers/spi/spi-tegra20-slink.c                    |  2 +
 drivers/spi/spi-ti-qspi.c                          |  1 +
 drivers/spi/spi.c                                  | 21 ++++++-
 drivers/staging/comedi/drivers/mf6x4.c             |  3 +-
 drivers/staging/greybus/audio_codec.c              |  2 +
 drivers/staging/speakup/speakup_dectlk.c           |  2 +-
 drivers/tty/serial/8250/8250_omap.c                |  5 --
 drivers/tty/serial/serial_core.c                   |  4 ++
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  3 +-
 drivers/usb/core/quirks.c                          |  3 +
 drivers/usb/gadget/function/f_acm.c                |  2 +-
 drivers/usb/gadget/function/f_fs.c                 |  5 +-
 drivers/usb/gadget/function/f_midi.c               |  6 ++
 drivers/usb/gadget/function/f_rndis.c              |  4 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  2 +-
 drivers/usb/host/ehci-omap.c                       |  1 +
 drivers/usb/host/oxu210hp-hcd.c                    |  4 +-
 drivers/usb/host/xhci-hub.c                        |  4 ++
 drivers/usb/misc/sisusbvga/Kconfig                 |  2 +-
 drivers/usb/serial/keyspan_pda.c                   | 63 +++++++++++----------
 drivers/usb/serial/mos7720.c                       |  2 +
 drivers/usb/serial/option.c                        | 23 +++++++-
 drivers/vfio/pci/vfio_pci.c                        |  4 +-
 drivers/watchdog/qcom-wdt.c                        |  2 +-
 fs/btrfs/inode.c                                   |  2 +-
 fs/btrfs/qgroup.c                                  |  4 +-
 fs/btrfs/scrub.c                                   | 17 +++---
 fs/btrfs/tests/btrfs-tests.c                       |  8 ++-
 fs/ceph/caps.c                                     | 11 +++-
 fs/ext4/mballoc.c                                  |  1 +
 fs/jffs2/readinode.c                               | 16 ++++++
 fs/jfs/jfs_dmap.h                                  |  2 +-
 fs/lockd/host.c                                    | 20 ++++---
 fs/nfs/inode.c                                     |  2 +-
 fs/nfs/nfs4proc.c                                  | 10 +++-
 fs/nfs_common/grace.c                              |  6 +-
 fs/nfsd/nfssvc.c                                   |  3 +-
 include/linux/inetdevice.h                         |  4 +-
 include/linux/seq_buf.h                            |  2 +-
 include/linux/sunrpc/xprt.h                        |  1 +
 include/linux/trace_seq.h                          |  4 +-
 kernel/cpu.c                                       |  6 +-
 net/bluetooth/hci_event.c                          | 17 +++---
 net/bridge/br_vlan.c                               |  4 +-
 net/ipv4/tcp_output.c                              |  9 ++-
 net/mac80211/mesh_pathtbl.c                        |  4 +-
 net/sunrpc/xprt.c                                  | 65 ++++++++++++++++------
 net/sunrpc/xprtrdma/module.c                       |  1 +
 net/sunrpc/xprtrdma/transport.c                    |  1 +
 net/sunrpc/xprtsock.c                              |  4 ++
 net/wireless/nl80211.c                             |  2 +-
 scripts/checkpatch.pl                              |  2 +-
 sound/core/oss/pcm_oss.c                           | 28 +++++++---
 sound/soc/codecs/wm_adsp.c                         |  5 +-
 sound/soc/jz4740/jz4740-i2s.c                      |  4 ++
 sound/soc/soc-pcm.c                                |  2 +
 sound/usb/clock.c                                  |  6 ++
 sound/usb/format.c                                 |  2 +
 sound/usb/stream.c                                 |  6 +-
 tools/perf/util/parse-regs-options.c               |  2 +-
 174 files changed, 837 insertions(+), 344 deletions(-)


