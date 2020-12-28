Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C5D2E3845
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgL1NIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:08:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730825AbgL1NIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:08:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFDBA208BA;
        Mon, 28 Dec 2020 13:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160843;
        bh=MhrMwf/YJPO8kFaWfxomr/44p63vu8TaW46b9FEM3d0=;
        h=From:To:Cc:Subject:Date:From;
        b=CiQE117FIziTPqpjr5S8L2bkJ7tbPUjz6wlF6Jw7Dt46AMjBbKWIoypfQjDvWQV/+
         9iYoe6s5vzPXsByJ5MEevYCb/LrXyE7VMSVUqEIJ9DUSZc1dzK/9UpylgcRYgqO1PS
         OFDLXbrKbp4W12Nc5TCt25bMmQEJmhyabpV2l2dU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.14 000/242] 4.14.213-rc1 review
Date:   Mon, 28 Dec 2020 13:46:45 +0100
Message-Id: <20201228124904.654293249@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.213-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.213-rc1
X-KernelTest-Deadline: 2020-12-30T12:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.213 release.
There are 242 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.213-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.213-rc1

Jubin Zhong <zhongjubin@huawei.com>
    PCI: Fix pci_slot_release() NULL pointer dereference

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/namespace: Fix reaping of invalidated block-window-namespace labels

SeongJae Park <sjpark@amazon.de>
    xenbus/xenbus_backend: Disallow pending watch messages

SeongJae Park <sjpark@amazon.de>
    xen/xenbus: Count pending messages for each watch

SeongJae Park <sjpark@amazon.de>
    xen/xenbus/xen_bus_type: Support will_handle watch callback

SeongJae Park <sjpark@amazon.de>
    xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()

SeongJae Park <sjpark@amazon.de>
    xen/xenbus: Allow watches discard events before queueing

Pawel Wieczorkiewicz <wipawel@amazon.de>
    xen-blkback: set ring->xenblkd to NULL after kthread_stop()

Terry Zhou <bjzhou@marvell.com>
    clk: mvebu: a3700: fix the XTAL MODE pin to MPP1_9

Zhao Heming <heming.zhao@suse.com>
    md/cluster: fix deadlock when node is doing resync job

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:bmi160: Fix too large a buffer.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:pressure:mpl3115: Force alignment of buffer

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:rpr0521: Fix timestamp alignment and prevent data leak.

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

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Don't modify file descriptor mode on the fly

David Hildenbrand <david@redhat.com>
    powerpc/powernv/memtrace: Don't leak kernel memory to user space

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/xmon: Change printk() to pr_cont()

Tyrel Datwyler <tyreld@linux.ibm.com>
    powerpc/rtas: Fix typo of ibm,open-errinjct in RTAS filter

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: at91: sama5d2: fix CAN message ram offset and size

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Introduce handling of AArch32 TTBCR2 traps

Jan Kara <jack@suse.cz>
    ext4: fix deadlock with fs freezing and EA inodes

Chunguang Xu <brookxu@tencent.com>
    ext4: fix a memory leak of ext4_free_data

Pavel Machek <pavel@denx.de>
    btrfs: fix return value mixup in btrfs_get_extent

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix selftests failure due to uninitialized i_mode in test inodes

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

Borislav Petkov <bp@suse.de>
    EDAC/amd64: Fix PCI component registration

Ard Biesheuvel <ardb@kernel.org>
    crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()

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

Sven Schnelle <svens@linux.ibm.com>
    s390/smp: perform initial CPU reset also for SMT siblings

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Disable sample read check if firmware doesn't give back

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix a few more UBSAN fixes

Chris Chiu <chiu@endlessos.org>
    ALSA: hda/realtek - Enable headset mic of ASUS Q524UQK with ALC255

Hui Wang <hui.wang@canonical.com>
    ACPI: PNP: compare the string length in the matching_id()

Daniel Scally <djrscally@gmail.com>
    Revert "ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: ACPI: PCI: Drop acpi_pm_set_bridge_wakeup()

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

Serge Hallyn <shallyn@cisco.com>
    fix namespaced fscaps when !CONFIG_SECURITY

Sara Sharon <sara.sharon@intel.com>
    cfg80211: initialize rekey_data

Jernej Skrabec <jernej.skrabec@siol.net>
    clk: sunxi-ng: Make sure divider tables have sentinel

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    clk: s2mps11: Fix a resource leak in error handling paths in the probe function

Dan Carpenter <dan.carpenter@oracle.com>
    qlcnic: Fix error code in probe

Zheng Zengkai <zhengzengkai@huawei.com>
    perf record: Fix memory leak when using '--user-regs=?' to list registers

Lokesh Vutla <lokeshvutla@ti.com>
    pwm: lp3943: Dynamically allocate PWM chip base

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: zx: Add missing cleanup in error path

Zhang Qilong <zhangqilong3@huawei.com>
    clk: ti: Fix memleak in ti_fapll_synth_setup

Arnd Bergmann <arnd@arndb.de>
    watchdog: coh901327: add COMMON_CLK dependency

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

Guenter Roeck <linux@roeck-us.net>
    watchdog: sirfsoc: Add missing dependency on HAS_IOMEM

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
    powerpc/pseries/hibernation: remove redundant cacheinfo update

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/hibernation: drop pseries_suspend_begin() from suspend ops

Zhang Changzhong <zhangchangzhong@huawei.com>
    scsi: fnic: Fix error return code in fnic_probe()

Arnd Bergmann <arnd@arndb.de>
    seq_buf: Avoid type mismatch for seq_buf_init

Zhang Qilong <zhangqilong3@huawei.com>
    scsi: pm80xx: Fix error return in pm8001_pci_probe()

Qinglang Miao <miaoqinglang@huawei.com>
    scsi: qedi: Fix missing destroy_workqueue() on error in __qedi_probe

Pali Rohár <pali@kernel.org>
    cpufreq: scpi: Add missing MODULE_ALIAS

Pali Rohár <pali@kernel.org>
    cpufreq: loongson1: Add missing MODULE_ALIAS

Pali Rohár <pali@kernel.org>
    cpufreq: st: Add missing MODULE_DEVICE_TABLE

Pali Rohár <pali@kernel.org>
    cpufreq: mediatek: Add missing MODULE_DEVICE_TABLE

Pali Rohár <pali@kernel.org>
    cpufreq: highbank: Add missing MODULE_DEVICE_TABLE

Keqian Zhu <zhukeqian1@huawei.com>
    clocksource/drivers/arm_arch_timer: Correct fault programming of CNTKCTL_EL1.EVNTI

Qinglang Miao <miaoqinglang@huawei.com>
    dm ioctl: fix error return code in target_message

Chuhong Yuan <hslester96@gmail.com>
    ASoC: jz4740-i2s: add missed checks for clk_get()

Leon Romanovsky <leonro@nvidia.com>
    net/mlx5: Properly convey driver version to firmware

Jing Xiangfeng <jingxiangfeng@huawei.com>
    memstick: r592: Fix error return in r592_probe()

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: rockchip: Fix UART pull-ups on rk3328

Yu Kuai <yukuai3@huawei.com>
    pinctrl: falcon: add missing put_device() call in pinctrl_falcon_probe()

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d2: map securam as device

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ath10k: Release some resources in an error handling path

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ath10k: Fix an error handling path

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: at91: at91sam9rl: fix ADC triggers

Bharat Gooty <bharat.gooty@broadcom.com>
    PCI: iproc: Fix out-of-bound array accesses

Marc Zyngier <maz@kernel.org>
    genirq/irqdomain: Don't try to free an interrupt that has no mapping

Zhang Qilong <zhangqilong3@huawei.com>
    power: supply: bq24190_charger: fix reference leak

Chris Packham <chris.packham@alliedtelesis.co.nz>
    ARM: dts: Remove non-existent i2c1 from 98dx3236

Jing Xiangfeng <jingxiangfeng@huawei.com>
    HSI: omap_ssi: Don't jump to free ID in ssi_add_controller()

Dan Carpenter <dan.carpenter@oracle.com>
    media: max2175: fix max2175_set_csm_mode() error code

Qinglang Miao <miaoqinglang@huawei.com>
    mips: cdmm: fix use-after-free in mips_cdmm_bus_discover

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: Fix lwt_len_hist reusing previous BPF map

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

Zhang Qilong <zhangqilong3@huawei.com>
    Input: omap4-keypad - fix runtime PM error handling

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

David Jander <david@protonic.nl>
    Input: ads7846 - fix race that causes missing releases

Yang Yingliang <yangyingliang@huawei.com>
    drm/omap: dmm_tiler: fix return error code in omap_dmm_probe()

Qinglang Miao <miaoqinglang@huawei.com>
    media: solo6x10: fix missing snd_card_free in error handling case

Martin Wilck <mwilck@suse.com>
    scsi: core: Fix VPD LUN ID designator priorities

Yu Kuai <yukuai3@huawei.com>
    media: mtk-vcodec: add missing put_device() call in mtk_vcodec_release_dec_pm()

Zhang Qilong <zhangqilong3@huawei.com>
    staging: greybus: codecs: Fix reference counter leak in error handling

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    MIPS: BCM47XX: fix kconfig dependency bug for BCM47XX_BCMA

Arnd Bergmann <arnd@arndb.de>
    RDMa/mthca: Work around -Wenum-conversion warning

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: arizona: Fix a wrong free in wm8997_probe

Vincent Bernat <vincent@bernat.ch>
    net: evaluate net.ipv4.conf.all.proxy_arp_pvlan

Vincent Bernat <vincent@bernat.ch>
    net: evaluate net.ipvX.conf.all.ignore_routes_with_linkdown

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm8998: Fix PM disable depth imbalance on error

Tsuchiya Yuto <kitakar@gmail.com>
    mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure

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

Paul Moore <paul@paul-moore.com>
    selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: pcm: DRAIN support reactivation

Zhang Qilong <zhangqilong3@huawei.com>
    spi: img-spfi: fix reference leak in img_spfi_resume

Christophe Leroy <christophe.leroy@csgroup.eu>
    crypto: talitos - Fix return type of current_desc_hdr()

Thomas Gleixner <tglx@linutronix.de>
    sched: Reenable interrupts in do_sched_yield()

Peng Liu <iwtbavbm@gmail.com>
    sched/deadline: Fix sched_dl_global_validate()

Ard Biesheuvel <ardb@kernel.org>
    ARM: p2v: fix handling of LPAE translation in BE mode

Arvind Sankar <nivedita@alum.mit.edu>
    x86/mm/ident_map: Check for errors from ident_pud_init()

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Compute PSN windows correctly

Tianyue Ren <rentianyue@kylinos.cn>
    selinux: fix error initialization in inode_doinit_with_dentry()

Kamal Heib <kamalheib1@gmail.com>
    RDMA/bnxt_re: Set queue pair state when being queried

Nicolas Boichat <drinkcat@chromium.org>
    soc: mediatek: Check if power domains can be powered on at boot time

Dan Carpenter <dan.carpenter@oracle.com>
    soc: renesas: rmobile-sysc: Fix some leaks in rmobile_init_pm_domains()

Tom Rix <trix@redhat.com>
    drm/gma500: fix double free of gma_connector

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()

Dae R. Jeong <dae.r.jeong@kaist.ac.kr>
    md: fix a warning caused by a race between concurrent md_ioctl()s

Eric Biggers <ebiggers@google.com>
    crypto: af_alg - avoid undefined behavior accessing salg_name

Antti Palosaari <crope@iki.fi>
    media: msi2500: assign SPI bus number dynamically

Jan Kara <jack@suse.cz>
    quota: Sanity-check quota file headers on load

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

Will McVicker <willmcvicker@google.com>
    USB: gadget: f_rndis: fix bitrate for SuperSpeed and above

Jack Pham <jackp@codeaurora.org>
    usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus

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

Sven Eckelmann <sven@narfation.org>
    vxlan: Copy needed_tailroom from lowerdev

Sven Eckelmann <sven@narfation.org>
    vxlan: Add needed_headroom for lower device

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

Baruch Siach <baruch@tkos.co.il>
    gpio: mvebu: fix potential user-after-free on probe

Icenowy Zheng <icenowy@aosc.io>
    ARM: dts: sun8i: v3s: fix GIC node memory range

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: baytrail: Avoid clearing debounce value when turning it off

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: merrifield: Set default bias in case no particular value given

Xin Xiong <xiongx18@fudan.edu.cn>
    drm: fix drm_dp_mst_port refcount leaks in drm_dp_mst_allocate_vcpi

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix potential out-of-bounds shift

Thomas Gleixner <tglx@linutronix.de>
    USB: sisusbvga: Make console support depend on BROKEN

Oliver Neukum <oneukum@suse.com>
    USB: UAS: introduce a quirk to set no_write_same

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

Moshe Shemesh <moshe@mellanox.com>
    net/mlx4_en: Handle TX error CQE

Moshe Shemesh <moshe@mellanox.com>
    net/mlx4_en: Avoid scheduling restart task if it is already running

Neal Cardwell <ncardwell@google.com>
    tcp: fix cwnd-limited bug for TSO deferral where we send nothing

Fugang Duan <fugang.duan@nxp.com>
    net: stmmac: free tx skb buffer in stmmac_resume()

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Add missing reset for ipq806x

Arvind Sankar <nivedita@alum.mit.edu>
    x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: be2iscsi: Revert "Fix a theoretical leak in beiscsi_create_eqs()"

Arnd Bergmann <arnd@arndb.de>
    kbuild: avoid static_assert for genksyms

Coiby Xu <coiby.xu@gmail.com>
    pinctrl: amd: remove debounce filter setting in IRQ type setting

Chris Chiu <chiu@endlessos.org>
    Input: i8042 - add Acer laptops to the i8042 reset list

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: cm109 - do not stomp on control URB

Timo Witte <timo.witte@gmail.com>
    platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE

Hao Si <si.hao@zte.com.cn>
    soc: fsl: dpio: Get the cpumask through cpumask_of(cpu)

Can Guo <cang@codeaurora.org>
    scsi: ufs: Make sure clk scaling happens only when HBA is runtime ACTIVE

Vineet Gupta <vgupta@synopsys.com>
    ARC: stack unwinding: don't assume non-current task is sleeping

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: fix kernel panic in case of assert during CSA

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

 Documentation/admin-guide/kernel-parameters.txt    |   1 +
 Documentation/networking/ip-sysctl.txt             |   3 +
 Makefile                                           |   4 +-
 arch/arc/kernel/stacktrace.c                       |  23 ++--
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi          |   5 -
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   7 ++
 arch/arm/boot/dts/at91-sama5d4_xplained.dts        |   7 ++
 arch/arm/boot/dts/at91sam9rl.dtsi                  |  19 ++--
 arch/arm/boot/dts/exynos5410-odroidxu.dts          |   6 +-
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi          |  28 +++++
 arch/arm/boot/dts/exynos5410.dtsi                  |   4 +
 arch/arm/boot/dts/sama5d2.dtsi                     |   7 +-
 arch/arm/boot/dts/sun8i-v3s.dtsi                   |   2 +-
 arch/arm/kernel/head.S                             |   6 +-
 arch/arm/mach-shmobile/pm-rmobile.c                |   1 +
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |  16 +--
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   3 +
 arch/arm64/include/asm/kvm_host.h                  |   1 +
 arch/arm64/kvm/sys_regs.c                          |   1 +
 arch/mips/bcm47xx/Kconfig                          |   1 +
 arch/powerpc/include/asm/cputable.h                |   5 -
 arch/powerpc/kernel/rtas.c                         |   2 +-
 arch/powerpc/perf/core-book3s.c                    |  10 ++
 arch/powerpc/platforms/powernv/memtrace.c          |  22 ++++
 arch/powerpc/platforms/pseries/suspend.c           |   4 -
 arch/powerpc/xmon/nonstdio.c                       |   2 +-
 arch/s390/kernel/smp.c                             |  18 +--
 arch/um/drivers/xterm.c                            |   5 +
 arch/x86/include/asm/pgtable_types.h               |   1 +
 arch/x86/kernel/kprobes/core.c                     |   5 +
 arch/x86/mm/ident_map.c                            |  12 +-
 arch/x86/mm/mem_encrypt.c                          |   4 +-
 crypto/af_alg.c                                    |  10 +-
 crypto/ecdh.c                                      |   9 +-
 drivers/acpi/acpi_pnp.c                            |   3 +
 drivers/acpi/device_pm.c                           |  41 ++-----
 drivers/acpi/resource.c                            |   2 +-
 drivers/block/xen-blkback/xenbus.c                 |   4 +-
 drivers/bus/mips_cdmm.c                            |   4 +-
 drivers/clk/clk-s2mps11.c                          |   1 +
 drivers/clk/mvebu/armada-37xx-xtal.c               |   4 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c              |   1 +
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                |   1 +
 drivers/clk/tegra/clk-id.h                         |   1 +
 drivers/clk/tegra/clk-tegra-periph.c               |   2 +-
 drivers/clk/ti/fapll.c                             |  11 +-
 drivers/clocksource/arm_arch_timer.c               |  23 ++--
 drivers/clocksource/cadence_ttc_timer.c            |  18 +--
 drivers/cpufreq/highbank-cpufreq.c                 |   7 ++
 drivers/cpufreq/loongson1-cpufreq.c                |   1 +
 drivers/cpufreq/mediatek-cpufreq.c                 |   1 +
 drivers/cpufreq/scpi-cpufreq.c                     |   1 +
 drivers/cpufreq/sti-cpufreq.c                      |   7 ++
 drivers/crypto/omap-aes.c                          |   3 +-
 drivers/crypto/talitos.c                           |   6 +-
 drivers/edac/amd64_edac.c                          |  26 +++--
 drivers/extcon/extcon-max77693.c                   |   2 +-
 drivers/gpio/gpio-mvebu.c                          |  16 ++-
 drivers/gpu/drm/drm_dp_aux_dev.c                   |   2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   7 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |   2 +-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c           |   1 +
 drivers/gpu/drm/tegra/sor.c                        |  10 +-
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |   8 ++
 drivers/hsi/controllers/omap_ssi_core.c            |   2 +-
 drivers/iio/adc/rockchip_saradc.c                  |   2 +-
 drivers/iio/imu/bmi160/bmi160_core.c               |   4 +-
 drivers/iio/industrialio-buffer.c                  |   6 +-
 drivers/iio/light/rpr0521.c                        |  17 ++-
 drivers/iio/pressure/mpl3115.c                     |   9 +-
 drivers/infiniband/core/cm.c                       |   2 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   1 +
 drivers/infiniband/hw/cxgb4/cq.c                   |   3 +
 drivers/infiniband/hw/mthca/mthca_cq.c             |   2 +-
 drivers/infiniband/hw/mthca/mthca_dev.h            |   1 -
 drivers/infiniband/sw/rxe/rxe_req.c                |   3 +-
 drivers/input/keyboard/cros_ec_keyb.c              |   1 +
 drivers/input/keyboard/omap4-keypad.c              |  89 +++++++++------
 drivers/input/misc/cm109.c                         |   7 +-
 drivers/input/mouse/cyapa_gen6.c                   |   2 +-
 drivers/input/serio/i8042-x86ia64io.h              |  42 +++++++
 drivers/input/touchscreen/ads7846.c                |  52 +++++----
 drivers/input/touchscreen/goodix.c                 |  12 ++
 drivers/irqchip/irq-alpine-msi.c                   |   3 +-
 drivers/md/dm-ioctl.c                              |   1 +
 drivers/md/dm-table.c                              |   6 -
 drivers/md/md-cluster.c                            |  67 ++++++-----
 drivers/md/md.c                                    |  13 ++-
 drivers/media/common/siano/smsdvb-main.c           |   5 +-
 drivers/media/i2c/max2175.c                        |   2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c  |   5 +-
 drivers/media/pci/saa7146/mxb.c                    |  19 ++--
 drivers/media/pci/solo6x10/solo6x10-g723.c         |   2 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  |   1 +
 drivers/media/rc/sunxi-cir.c                       |   2 +
 drivers/media/usb/gspca/gspca.c                    |   1 +
 drivers/media/usb/msi2500/msi2500.c                |   2 +-
 drivers/memstick/core/memstick.c                   |   1 -
 drivers/memstick/host/r592.c                       |  12 +-
 drivers/mtd/cmdlinepart.c                          |  14 ++-
 drivers/net/can/softing/softing_main.c             |   9 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   7 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +-
 drivers/net/ethernet/korina.c                      |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  21 ++--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |  40 +++++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  27 ++++-
 drivers/net/vxlan.c                                |   3 +
 drivers/net/wireless/ath/ath10k/usb.c              |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  36 ++++--
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |  14 +--
 drivers/net/wireless/marvell/mwifiex/main.c        |   2 +
 drivers/net/wireless/st/cw1200/main.c              |   2 +
 drivers/net/xen-netback/xenbus.c                   |   6 +-
 drivers/nfc/s3fwrn5/firmware.c                     |   4 +-
 drivers/nvdimm/label.c                             |   9 ++
 drivers/pci/dwc/pcie-qcom.c                        |  12 ++
 drivers/pci/host/pcie-iproc.c                      |  10 +-
 drivers/pci/pci-acpi.c                             |   4 +-
 drivers/pci/slot.c                                 |   6 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c           |   8 +-
 drivers/pinctrl/intel/pinctrl-merrifield.c         |   8 ++
 drivers/pinctrl/pinctrl-amd.c                      |   7 --
 drivers/pinctrl/pinctrl-falcon.c                   |  14 ++-
 drivers/platform/x86/acer-wmi.c                    |   1 +
 drivers/power/supply/bq24190_charger.c             |  20 +++-
 drivers/ps3/ps3stor_lib.c                          |   2 +-
 drivers/pwm/pwm-lp3943.c                           |   1 +
 drivers/pwm/pwm-zx.c                               |   1 +
 drivers/s390/block/dasd_alias.c                    |  12 +-
 drivers/scsi/be2iscsi/be_main.c                    |   4 +-
 drivers/scsi/bnx2i/Kconfig                         |   1 +
 drivers/scsi/fnic/fnic_main.c                      |   1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   2 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   3 +-
 drivers/scsi/qedi/qedi_main.c                      |   4 +-
 drivers/scsi/scsi_lib.c                            | 126 ++++++++++++++-------
 drivers/scsi/ufs/ufshcd.c                          |   7 ++
 drivers/soc/mediatek/mtk-scpsys.c                  |   5 +-
 drivers/soc/qcom/smp2p.c                           |   5 +-
 drivers/soc/tegra/fuse/speedo-tegra210.c           |   2 +-
 drivers/soc/ti/knav_dma.c                          |  13 ++-
 drivers/soc/ti/knav_qmss_queue.c                   |   4 +-
 drivers/spi/spi-bcm2835aux.c                       |  17 +--
 drivers/spi/spi-davinci.c                          |   2 +-
 drivers/spi/spi-img-spfi.c                         |   4 +-
 drivers/spi/spi-pic32.c                            |   1 +
 drivers/spi/spi-rb4xx.c                            |   2 +-
 drivers/spi/spi-sc18is602.c                        |  13 +--
 drivers/spi/spi-sh.c                               |  13 +--
 drivers/spi/spi-st-ssc4.c                          |   5 +-
 drivers/spi/spi-tegra114.c                         |   2 +
 drivers/spi/spi-tegra20-sflash.c                   |   1 +
 drivers/spi/spi-tegra20-slink.c                    |   2 +
 drivers/spi/spi-ti-qspi.c                          |   1 +
 drivers/staging/comedi/drivers/mf6x4.c             |   3 +-
 drivers/staging/fsl-mc/bus/dpio/dpio-driver.c      |   5 +-
 drivers/staging/greybus/audio_codec.c              |   2 +
 drivers/staging/speakup/speakup_dectlk.c           |   2 +-
 drivers/tty/serial/8250/8250_omap.c                |   5 -
 drivers/tty/serial/serial_core.c                   |   4 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |   3 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/function/f_acm.c                |   2 +-
 drivers/usb/gadget/function/f_fs.c                 |   5 +-
 drivers/usb/gadget/function/f_midi.c               |   6 +
 drivers/usb/gadget/function/f_rndis.c              |   4 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |   2 +-
 drivers/usb/host/ehci-omap.c                       |   1 +
 drivers/usb/host/oxu210hp-hcd.c                    |   4 +-
 drivers/usb/host/xhci-hub.c                        |   4 +
 drivers/usb/misc/sisusbvga/Kconfig                 |   2 +-
 drivers/usb/serial/keyspan_pda.c                   |  63 ++++++-----
 drivers/usb/serial/mos7720.c                       |   2 +
 drivers/usb/serial/option.c                        |  23 +++-
 drivers/usb/storage/uas.c                          |   3 +
 drivers/usb/storage/unusual_uas.h                  |   7 +-
 drivers/usb/storage/usb.c                          |   3 +
 drivers/vfio/pci/vfio_pci.c                        |   4 +-
 drivers/watchdog/Kconfig                           |   3 +-
 drivers/watchdog/qcom-wdt.c                        |   2 +-
 drivers/xen/xen-pciback/xenbus.c                   |   2 +-
 drivers/xen/xenbus/xenbus.h                        |   2 +
 drivers/xen/xenbus/xenbus_client.c                 |   8 +-
 drivers/xen/xenbus/xenbus_probe.c                  |   1 +
 drivers/xen/xenbus/xenbus_probe_backend.c          |   7 ++
 drivers/xen/xenbus/xenbus_xs.c                     |  34 ++++--
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/tests/btrfs-tests.c                       |   8 +-
 fs/ceph/caps.c                                     |  11 +-
 fs/ext4/inode.c                                    |  19 +++-
 fs/ext4/mballoc.c                                  |   1 +
 fs/jffs2/readinode.c                               |  16 +++
 fs/jfs/jfs_dmap.h                                  |   2 +-
 fs/lockd/host.c                                    |  20 ++--
 fs/nfs/inode.c                                     |   2 +-
 fs/nfs/nfs4proc.c                                  |  10 +-
 fs/nfs_common/grace.c                              |   6 +-
 fs/nfsd/nfssvc.c                                   |   3 +-
 fs/quota/quota_v2.c                                |  19 ++++
 include/acpi/acpi_bus.h                            |   5 -
 include/linux/build_bug.h                          |   5 +
 include/linux/inetdevice.h                         |   4 +-
 include/linux/security.h                           |   2 +-
 include/linux/seq_buf.h                            |   2 +-
 include/linux/sunrpc/xprt.h                        |   1 +
 include/linux/trace_seq.h                          |   4 +-
 include/linux/usb_usual.h                          |   2 +
 include/uapi/linux/if_alg.h                        |  16 +++
 include/xen/xenbus.h                               |  15 ++-
 kernel/cpu.c                                       |   6 +-
 kernel/irq/irqdomain.c                             |  11 +-
 kernel/sched/core.c                                |   6 +-
 kernel/sched/deadline.c                            |   5 +-
 kernel/sched/sched.h                               |  42 +++----
 net/bluetooth/hci_event.c                          |  17 +--
 net/bridge/br_vlan.c                               |   4 +-
 net/ipv4/tcp_output.c                              |   9 +-
 net/mac80211/mesh_pathtbl.c                        |   4 +-
 net/sunrpc/xprt.c                                  |  65 ++++++++---
 net/sunrpc/xprtrdma/module.c                       |   1 +
 net/sunrpc/xprtrdma/transport.c                    |   1 +
 net/sunrpc/xprtsock.c                              |   4 +
 net/wireless/nl80211.c                             |   2 +-
 samples/bpf/lwt_len_hist.sh                        |   2 +
 samples/bpf/test_lwt_bpf.sh                        |   0
 scripts/checkpatch.pl                              |   2 +-
 security/integrity/ima/ima_crypto.c                |  20 +---
 security/selinux/hooks.c                           |  16 ++-
 sound/core/oss/pcm_oss.c                           |  28 +++--
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/wm8997.c                          |   2 +
 sound/soc/codecs/wm8998.c                          |   4 +-
 sound/soc/codecs/wm_adsp.c                         |   5 +-
 sound/soc/jz4740/jz4740-i2s.c                      |   4 +
 sound/soc/soc-pcm.c                                |   2 +
 sound/usb/clock.c                                  |   6 +
 sound/usb/format.c                                 |   2 +
 sound/usb/stream.c                                 |   6 +-
 tools/perf/util/parse-regs-options.c               |   2 +-
 246 files changed, 1453 insertions(+), 675 deletions(-)


