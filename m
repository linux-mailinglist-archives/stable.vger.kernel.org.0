Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3557729B7CD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901381AbgJ0PSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796371AbgJ0PR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:17:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E912064B;
        Tue, 27 Oct 2020 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811873;
        bh=2IQCHogkcKs4wyqVLIdm+eQnMnRl56eIb51+s9A0i6w=;
        h=From:To:Cc:Subject:Date:From;
        b=edPB3fxXvTi8w2hdYxLRLM2gcthFsexqIqwl3MAYTzv8bn+/E11Bo6HVEo8knXiy+
         1tMY4kiXkq+P9gzVMWdOGTB8WzXbnwfeAcjXlbkiuDnTlUbUQmdS5wUl8nlZOb8WGD
         YOPefEsDvlVXKhreLGDp02afAH329+syaZNDzlZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.9 000/757] 5.9.2-rc1 review
Date:   Tue, 27 Oct 2020 14:44:10 +0100
Message-Id: <20201027135450.497324313@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.9.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.9.2-rc1
X-KernelTest-Deadline: 2020-10-29T13:55+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.9.2 release.
There are 757 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 29 Oct 2020 13:52:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.9.2-rc1

Lorenzo Colitti <lorenzo@google.com>
    usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.

Christian Eggers <ceggers@arri.de>
    eeprom: at25: set minimum read/write access stride to 1

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: gadget: free interrupt after gadget has deleted

Oliver Neukum <oneukum@suse.com>
    USB: cdc-wdm: Make wdm_flush() interruptible and add wdm_fsync().

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    usb: cdc-acm: add quirk to blacklist ETAS ES58X devices

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: gadget: bcm63xx_udc: fix up the error of undeclared usb_debug_root

Peng Fan <peng.fan@nxp.com>
    tty: serial: fsl_lpuart: fix lpuart32_poll_get_char

Peng Fan <peng.fan@nxp.com>
    tty: serial: lpuart: fix lpuart32_write usage

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: don't let HW override the configured port role

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    net: korina: cast KSEG0 address to pointer in kfree

Zekun Shen <bruceshenzk@gmail.com>
    ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/panfrost: perfcnt: fix ref count leak in panfrost_perfcnt_enable_locked

Alvin Lee <alvin.lee2@amd.com>
    drm/amd/display: Disconnect pipe separetely when disable pipe split

Tian Tao <tiantao6@hisilicon.com>
    drm/hisilicon: Code refactoring for hibmc_drv_de

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dmaengine: dw: Activate FIFO-mode for memory peripherals only

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dmaengine: dw: Add DMA-channels mask cell support

Qingqing Zhuo <qingqing.zhuo@amd.com>
    drm/amd/display: Screen corruption on dual displays (DP+USB-C)

Can Guo <cang@codeaurora.org>
    scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: intel: reinitialize IP+DSP in .prepare(), but only when resuming

Eli Billauer <eli.billauer@gmail.com>
    usb: core: Solve race condition in anchor cleanup functions

Wang Yufen <wangyufen@huawei.com>
    brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach

Kevin Barnett <kevin.barnett@microsemi.com>
    scsi: smartpqi: Avoid crashing kernel for controller issues

Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
    ASoC: Intel: sof_rt5682: override quirk data for tgl_max98373_rt5682

Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
    ASoC: SOF: Add topology filename override based on dmi data match

Connor McAdams <conmanx360@gmail.com>
    ALSA: hda/ca0132 - Add new quirk ID for SoundBlaster AE-7.

Connor McAdams <conmanx360@gmail.com>
    ALSA: hda/ca0132 - Add AE-7 microphone selection commands.

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    mwifiex: don't call del_timer_sync() on uninitialized timer

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: strictly order bridge address events

Jan Kara <jack@suse.cz>
    reiserfs: Fix memory leak in reiserfs_parse_options()

Peilin Ye <yepeilin.cs@gmail.com>
    ipvs: Fix uninit-value in do_ip_vs_set_ctl()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    Bluetooth: btusb: Fix memleak in btusb_mtk_submit_wmt_recv_urb

Tong Zhang <ztong0001@gmail.com>
    tty: ipwireless: fix error handling

George Kennedy <george.kennedy@oracle.com>
    fbmem: add margin check to fb_check_caps()

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Fix list_del corruption while removing active I/O

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Protect active command list to avoid list corruption

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Mark all connections for recovery on link down event

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Return SUCCESS if stale rport is encountered

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Add USB id match for Acer One S1003 keyboard dock

Doug Horn <doughorn@google.com>
    Fix use after free in get_capset_info callback.

Chris Chiu <chiu@endlessm.com>
    rtl8xxxu: prevent potential memory leak

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    brcmsmac: fix memory leak in wlc_phy_attach_lcnphy

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence: fix race condition between suspend and Slave device alerts

Yonghong Song <yhs@fb.com>
    selftests/bpf: Fix test_sysctl_loop{1, 2} failure due to clang change

Daniel Wagner <dwagner@suse.de>
    scsi: qla2xxx: Warn if done() or free() are called on an already freed srb

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: ibmvfc: Fix error return in ibmvfc_probe()

Qian Cai <cai@lca.pw>
    iomap: fix WARN_ON_ONCE() from unprivileged users

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/xlnx: Use devm_drm_dev_alloc

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    drm/msm/a6xx: fix a potential overflow issue

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    Bluetooth: Only mark socket zapped after unlocking

Jia Yang <jiayang5@huawei.com>
    drm: fix double free for gbo in drm_gem_vram_init and drm_gem_vram_create

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    usb: ohci: Default to per-port over-current protection

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: make sure the rt allocator doesn't run off the end

Viresh Kumar <viresh.kumar@linaro.org>
    opp: Prevent memory leak in dev_pm_opp_attach_genpd()

Eric Biggers <ebiggers@google.com>
    reiserfs: only call unlock_new_inode() if I_NEW

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    misc: rtsx: Fix memory leak in rtsx_pci_probe

Thomas Tai <thomas.tai@oracle.com>
    dma-direct: Fix potential NULL pointer dereference

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    bpf: Limit caller's stack depth 256 for subprogs with tailcalls

Neil Armstrong <narmstrong@baylibre.com>
    drm/panfrost: add support for vendor quirk

Neil Armstrong <narmstrong@baylibre.com>
    drm/panfrost: add amlogic reset quirk callback

Neil Armstrong <narmstrong@baylibre.com>
    drm/panfrost: add Amlogic GPU integration quirks

Brooke Basile <brookebasile@gmail.com>
    ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()

Mikael Wikström <leakim.wikstrom@gmail.com>
    HID: multitouch: Lenovo X1 Tablet Gen3 trackpoint and buttons

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: flexcan_chip_stop(): add error handling and propagate error value

Oded Gabbay <oded.gabbay@gmail.com>
    habanalabs: cast to u64 before shift > 31 bits

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    usb: dwc3: simple: add support for Hikey 970

Felix Fietkau <nbd@nbd.name>
    mt76: mt7915: do not do any work in napi poll after calling napi_complete_done()

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: handle broken union descriptors

Alan Maguire <alan.maguire@oracle.com>
    selftests/bpf: Fix overflow tests to reflect iter size increase

Tzu-En Huang <tehuang@realtek.com>
    rtw88: increse the size of rx buffer size

Jan Kara <jack@suse.cz>
    udf: Avoid accessing uninitialized data on failed inode read

Jan Kara <jack@suse.cz>
    udf: Limit sparing table size

Kai-Heng Feng <kai.heng.feng@canonical.com>
    rtw88: pci: Power cycle device during shutdown

Zqiang <qiang.zhang@windriver.com>
    usb: gadget: function: printer: fix use-after-free in __lock_acquire

Yu Chen <chenyu56@huawei.com>
    usb: dwc3: Add splitdisable quirk for Hisilicon Kirin Soc

Sherry Sun <sherry.sun@nxp.com>
    misc: vop: add round_up(x,4) for vring_size to avoid kernel panic

Sherry Sun <sherry.sun@nxp.com>
    mic: vop: copy data to kernel space then write to io memory

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: target: core: Add CONTROL field for trace events

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: mvumi: Fix error return in mvumi_io_attach()

Christoph Hellwig <hch@lst.de>
    PM: hibernate: remove the bogus call to get_gendisk() in software_resume()

Song Liu <songliubraving@fb.com>
    bpf: Use raw_spin_trylock() for pcpu_freelist_push/pop in NMI

Hangbin Liu <liuhangbin@gmail.com>
    libbpf: Close map fd if init map slots failed

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix handling of MMIC error

Thomas Pedersen <thomas@adapt-ip.com>
    mac80211: handle lack of sband->bitrates in rates

Cong Wang <xiyou.wangcong@gmail.com>
    ip_gre: set dev->hard_header_len and dev->needed_headroom properly

Rustam Kovhaev <rkovhaev@gmail.com>
    ntfs: add check for mft record size in superblock

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: venus: core: Fix runtime PM imbalance in venus_probe

Rajendra Nayak <rnayak@codeaurora.org>
    media: venus: core: Fix error handling in probe

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix configfs memory leak

Peter Zijlstra <peterz@infradead.org>
    notifier: Fix broken error handling pattern

Vikash Garodia <vgarodia@codeaurora.org>
    media: venus: fixes for list corruption

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: atomisp: fix memleak in ia_css_stream_create

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: saa7134: avoid a shift overflow

Pali Rohár <pali@kernel.org>
    mmc: sdio: Check for CISTPL_VERS_1 buffer size

Adam Goode <agoode@google.com>
    media: uvcvideo: Ensure all probed info is returned to v4l2

Borislav Petkov <bp@suse.de>
    x86/mce: Make mce_rdmsrl() panic on an inaccessible MSR

Ming Lei <ming.lei@redhat.com>
    blk-mq: always allow reserved allocation in hctx_may_queue

Brad Bishop <bradleyb@fuzziesquirrel.com>
    spi: fsi: Fix clock running too fast

Longfang Liu <liulongfang@huawei.com>
    crypto: hisilicon - fixed memory allocation error

Borislav Petkov <bp@suse.de>
    x86/mce: Annotate mce_rd/wrmsrl() with noinstr

Xiaolong Huang <butterflyhuangxx@gmail.com>
    media: media/pci: prevent memory leak in bttv_probe

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: bdisp: Fix runtime PM imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: platform: sti: hva: Fix runtime PM imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: platform: s3c-camif: Fix runtime PM imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: vsp1: Fix runtime PM imbalance on error

Qiushi Wu <wu000273@umn.edu>
    media: exynos4-is: Fix a reference count leak

Qiushi Wu <wu000273@umn.edu>
    media: exynos4-is: Fix a reference count leak due to pm_runtime_get_sync

Qiushi Wu <wu000273@umn.edu>
    media: exynos4-is: Fix several reference count leaks due to pm_runtime_get_sync

Qiushi Wu <wu000273@umn.edu>
    media: sti: Fix reference count leaks

Aditya Pakki <pakki001@umn.edu>
    media: st-delta: Fix reference count leak in delta_run_work

Oliver Neukum <oneukum@suse.com>
    media: ati_remote: sanity check for both endpoints

Pavel Machek <pavel@ucw.cz>
    media: firewire: fix memory leak

Borislav Petkov <bp@suse.de>
    x86/mce: Add Skylake quirk for patrol scrub reported errors

Arvind Sankar <nivedita@alum.mit.edu>
    x86/asm: Replace __force_order with a memory clobber

Pavel Machek <pavel@denx.de>
    crypto: ccp - fix error handling

Mark Mossberg <mark.mossberg@gmail.com>
    x86/dumpstack: Fix misleading instruction pointer error message

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    block: ratelimit handle_bad_sector() message

Zhao Heming <heming.zhao@suse.com>
    md/bitmap: fix memory leak of temporary bitmap

Hans de Goede <hdegoede@redhat.com>
    i2c: core: Restore acpi_walk_dep_device_list() getting called after registering the ACPI i2c devs

George Spelvin <lkml@sdf.org>
    random32: make prandom_u32() output unpredictable

Al Grant <al.grant@foss.arm.com>
    perf: correct SNOOPX field offset

Juri Lelli <juri.lelli@redhat.com>
    sched/features: Fix !CONFIG_JUMP_LABEL case

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ntb: intel: Fix memleak in intel_ntb_pci_probe

Kaige Li <likaige@loongson.cn>
    NTB: hw: amd: fix an issue about leak system resources

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: ioapic: break infinite recursion on lazy EOI

Logan Gunthorpe <logang@deltatee.com>
    nvmet: limit passthru MTDS by BIO_MAX_PAGES

zhenwei pi <pizhenwei@bytedance.com>
    nvmet: fix uninitialized work for zero kato

Ganesh Goudar <ganeshgr@linux.ibm.com>
    powerpc/pseries: Avoid using addr_to_pfn in real mode

Jordan Niethe <jniethe5@gmail.com>
    powerpc/64s: Remove TM from Power10 features

Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
    powerpc/powernv/dump: Fix race while processing OPAL dump

Colin Ian King <colin.king@canonical.com>
    lightnvm: fix out-of-bounds write to array devices->info[]

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8: remove two invalid interrupt lines from the GPU node

Michal Simek <michal.simek@xilinx.com>
    arm64: dts: zynqmp: Remove additional compatible string for i2c IPs

Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>
    drm/mediatek: reduce clear event

Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>
    soc: mediatek: cmdq: add clear option in cmdq_pkt_wfe api

Biju Das <biju.das.jz@bp.renesas.com>
    ARM: dts: iwg20d-q7-common: Fix touch controller probe failure

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix DH PDK2 display PWM channel

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Swap PHY reset GPIO and TSC2004 IRQ on DHCOM SOM

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Move ethernet PHY into DH SoM DT

Holger Assmann <h.assmann@pengutronix.de>
    ARM: dts: stm32: lxa-mc1: Fix kernel warning about PHY delays

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix sdmmc2 pins on AV96

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Restore MPU power domain if cpu_cluster_pm_enter() fails

Krzysztof Kozlowski <krzk@kernel.org>
    soc: fsl: qbman: Fix return value on success

Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
    ARM: dts: owl-s500: Fix incorrect PPI interrupt specifiers

Amit Singh Tomar <amittomer25@gmail.com>
    arm64: dts: actions: limit address range for pinctrl node

Roger Quadros <rogerq@ti.com>
    arm64: dts: ti: k3-j721e: Rename mux header and update macro names

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: dts: mt8173: elm: Fix nor_flash node property

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a774c0: Fix MSIOF1 DMA channels

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a77990: Fix MSIOF1 DMA channels

Corentin Labbe <clabbe.montjoie@gmail.com>
    dt-bindings: crypto: Specify that allwinner, sun8i-a33-crypto needs reset

Sibi Sankar <sibis@codeaurora.org>
    soc: qcom: apr: Fixup the error displayed on lookup failure

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Fix MDP/DSI interrupts

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: pm8916: Remove invalid reg size from wcd_codec

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Remove one more thermal trip point unit name

Sibi Sankar <sibis@codeaurora.org>
    soc: qcom: pdr: Fixup array type of get_domain_list_resp message

Rajendra Nayak <rnayak@codeaurora.org>
    arm64: dts: sdm845: Fixup OPP table for all qup devices

Stephen Boyd <swboyd@chromium.org>
    arm64: dts: qcom: sc7180: Drop flags on mdss irqs

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: dts: imx8mq: Add missing interrupts to GPC

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: ti: k3-udma-glue: Fix parameters for rx ring pair request

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    arm64: dts: qcom: sm8250: Rename UART2 node to UART12

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    arm64: dts: mt8173-elm: fix supported values for regulator-allowed-modes of da9211

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Fix NULL pointer dereference in mailbox_chan_free

Krzysztof Kozlowski <krzk@kernel.org>
    memory: fsl-corenet-cf: Fix handling of platform_get_irq() error

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    arm64: dts: qcom: sc7180: Fix the LLCC base register size

Jonathan Marek <jonathan@marek.ca>
    arm64: dts: qcom: sm8150: fix up primary USB nodes

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: sdm845-db845c: Fix hdmi nodes

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: dts: qcom: msm8992: Fix UART interrupt property

YueHaibing <yuehaibing@huawei.com>
    memory: omap-gpmc: Fix build error without CONFIG_OF

Dan Carpenter <dan.carpenter@oracle.com>
    memory: omap-gpmc: Fix a couple off by ones

Qiang Yu <yuq825@gmail.com>
    arm64: dts: allwinner: h5: remove Mali GPU PMU module

Jernej Skrabec <jernej.skrabec@siol.net>
    ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix dcdc1 regulator

Markus Mayer <mmayer@broadcom.com>
    memory: brcmstb_dpfe: fix array index out of bounds

Arnd Bergmann <arnd@arndb.de>
    ARM: s3c24xx: fix mmc gpio lookup tables

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: of_node_put() after its usage

Horia Geantă <horia.geanta@nxp.com>
    ARM: dts: imx6sl: fix rng node

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: meson: vim3: correct led polarity

Dan Carpenter <dan.carpenter@oracle.com>
    soc: xilinx: Fix error code in zynqmp_pm_probe()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_fwd_netdev: clear timestamp in forwarding path

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: depends on built-in IPv6

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Fix failure to bring link up

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Make use of a specific 16 bit endianness API

Timothée COCAULT <timothee.cocault@orange.com>
    netfilter: ebtables: Fixes dropping of small packets in bridge nat

Francesco Ruggeri <fruggeri@arista.com>
    netfilter: conntrack: connection timeout after re-register

Maxim Kochetkov <fido_max@inbox.ru>
    net: dsa: seville: the packet buffer is 2 megabits, not megabytes

Martin KaFai Lau <kafai@fb.com>
    bpf: Enforce id generation for all may-be-null register type

Ard Biesheuvel <ardb@kernel.org>
    arm64: mm: use single quantity to represent the PA to VA translation

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: bfa: Fix error return in bfad_pci_init()

Krish Sadhukhan <krish.sadhukhan@oracle.com>
    KVM: nSVM: CR3 MBZ bits are only 63:52

Robert Hoo <robert.hu@linux.intel.com>
    KVM: x86: emulating RDPID failure shall return #UD rather than #GP

Krzysztof Kozlowski <krzk@kernel.org>
    Input: sun4i-ps2 - fix handling of platform_get_irq() error

Krzysztof Kozlowski <krzk@kernel.org>
    Input: twl4030_keypad - fix handling of platform_get_irq() error

Krzysztof Kozlowski <krzk@kernel.org>
    Input: omap4-keypad - fix handling of platform_get_irq() error

Krzysztof Kozlowski <krzk@kernel.org>
    Input: ep93xx_keypad - fix handling of platform_get_irq() error

YueHaibing <yuehaibing@huawei.com>
    Input: stmfts - fix a & vs && typo

Dan Carpenter <dan.carpenter@oracle.com>
    Input: imx6ul_tsc - clean up some errors in imx6ul_tsc_resume()

Johnny Chuang <johnny.chuang.emc@gmail.com>
    Input: elants_i2c - fix typo for an attribute to show calibration count

Gwendal Grignou <gwendal@chromium.org>
    platform/chrome: cros_ec_lightbar: Reduce ligthbar get version command

Azhar Shaikh <azhar.shaikh@intel.com>
    platform/chrome: cros_ec_typec: Send enum values to usb_role_switch_set_role()

Dai Ngo <dai.ngo@oracle.com>
    NFSv4.2: Fix NFS4ERR_STALE error when doing inter server copy

Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
    SUNRPC: fix copying of multiple pages in gss_read_proxy_verf()

Abel Vesa <abel.vesa@nxp.com>
    clk: imx8mq: Fix usdhc parents order

Stephen Boyd <sboyd@kernel.org>
    clk: qcom: gdsc: Keep RETAIN_FF bit set if gdsc is already on

Xiaoyang Xu <xuxiaoyang2@huawei.com>
    vfio iommu type1: Fix memory leak in vfio_iommu_type1_pin_pages

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Clear token on bypass registration failure

Darrick J. Wong <darrick.wong@oracle.com>
    ext4: limit entries returned when counting fsmap records

Xiao Yang <yangx.jy@cn.fujitsu.com>
    ext4: disallow modifying DAX inode flag if inline_data has been set

Jan Kara <jack@suse.cz>
    ext4: discard preallocations before releasing group lock

Ye Bin <yebin10@huawei.com>
    ext4: fix dead loop in ext4_mb_new_blocks

Dan Aloni <dan@kernelim.com>
    svcrdma: fix bounce buffers for unaligned offsets and multiple pages

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: sam9x60: support only two programmable clocks

Guenter Roeck <linux@roeck-us.net>
    watchdog: sp5100: Fix definition of EFCH_PM_DECODEEN3

Dinghao Liu <dinghao.liu@zju.edu.cn>
    watchdog: Use put_device on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    watchdog: Fix memleak in watchdog_cdev_register

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: deb-pkg: do not build linux-headers package if CONFIG_MODULES=n

Navid Emamdoost <navid.emamdoost@gmail.com>
    clk: bcm2835: add missing release if devm_clk_hw_register fails

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: clk-main: update key before writing AT91_CKGR_MOR

Daniel Jordan <daniel.m.jordan@oracle.com>
    module: statically initialize init section freeing data

Hanks Chen <hanks.chen@mediatek.com>
    clk: mediatek: add UART0 clock support

Stephen Boyd <sboyd@kernel.org>
    clk: rockchip: Initialize hw to error to avoid undefined behavior

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Fix hibernation in case interrupts are not re-created

Colin Ian King <colin.king@canonical.com>
    remoteproc/mediatek: fix null pointer dereference on null scp pointer

J. Bruce Fields <bfields@redhat.com>
    nfsd: Cache R, RW, and W opens separately

Hauke Mehrtens <hauke@hauke-m.de>
    pwm: img: Fix null pointer access in probe

Simon South <simon@simonsouth.net>
    pwm: rockchip: Keep enabled PWMs running while probing

Tero Kristo <t-kristo@ti.com>
    clk: keystone: sci-clk: fix parsing assigned-clock data during probe

Konrad Dybcio <konradybcio@gmail.com>
    clk: qcom: gcc-sdm660: Fix wrong parent_map

Yan Zhao <yan.y.zhao@intel.com>
    vfio/type1: fix dirty bitmap calculation in vfio_dma_rw

Yan Zhao <yan.y.zhao@intel.com>
    vfio: fix a missed vfio group put in vfio_pin_pages

Matthew Rosato <mjrosato@linux.ibm.com>
    vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks from is_virtfn

Matthew Rosato <mjrosato@linux.ibm.com>
    s390/pci: Mark all VFs as not implementing PCI_COMMAND_MEMORY

Yan Zhao <yan.y.zhao@intel.com>
    vfio: add a singleton check for vfio_group_pin_pages

Matthew Rosato <mjrosato@linux.ibm.com>
    PCI/IOV: Mark VFs as not implementing PCI_COMMAND_MEMORY

Mathieu Poirier <mathieu.poirier@linaro.org>
    remoteproc: stm32: Fix pointer assignement

Nicolas Boichat <drinkcat@chromium.org>
    rpmsg: Avoid double-free in mtk_rpmsg_register_device

Dan Carpenter <dan.carpenter@oracle.com>
    rpmsg: smd: Fix a kobj leak in in qcom_smd_parse_edge()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    PCI: iproc: Set affinity mask on MSI interrupts

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Check for errors from pci_bridge_emul_init() call

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix compilation on s390

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: designware-ep: Fix the Header Type check

Stefan Agner <stefan@agner.ch>
    clk: meson: g12a: mark fclk_div2 as critical

Dirk Behme <dirk.behme@de.bosch.com>
    i2c: rcar: Auto select RESET_CONTROLLER

Chris Packham <chris.packham@alliedtelesis.co.nz>
    rtc: ds1307: Clear OSF flag on DS1388 when setting time

Jerome Brunet <jbrunet@baylibre.com>
    clk: meson: axg-audio: separate axg and g12a regmap tables

Jassi Brar <jaswinder.singh@linaro.org>
    mailbox: avoid timer start from callback

Jing Xiangfeng <jingxiangfeng@huawei.com>
    rapidio: fix the missed put_device() for rio_mport_add_riodev

Souptick Joarder <jrdr.linux@gmail.com>
    rapidio: fix error handling path

Matthew Wilcox (Oracle) <willy@infradead.org>
    ramfs: fix nommu mmap with gaps in the page cache

Tobias Jordan <kernel@cdqe.de>
    lib/crc32.c: fix trivial typo in preprocessor condition

Huang Ying <ying.huang@intel.com>
    mm: fix a race during THP splitting

Kirill A. Shutemov <kirill@shutemov.name>
    mm/huge_memory: fix split assumption of page size

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm/page_owner: change split_page_owner to take a count

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Handle skb_clone() failure in rxe_recv.c

David Howells <dhowells@redhat.com>
    afs: Fix cell removal

David Howells <dhowells@redhat.com>
    afs: Fix cell purging with aliases

David Howells <dhowells@redhat.com>
    afs: Fix cell refcounting by splitting the usage counter

David Howells <dhowells@redhat.com>
    afs: Fix rapid cell addition/removal by not using RCU on cells tree

Jamie Iles <jamie@nuviainc.com>
    f2fs: wait for sysfs kobject removal before freeing f2fs_sb_info

Oliver O'Halloran <oohall@gmail.com>
    selftests/powerpc: Fix eeh-basic.sh exit codes

Jiri Slaby <jirislaby@kernel.org>
    perf trace: Fix off by ones in memset() after realloc() in arches using libaudit

Krzysztof Kozlowski <krzk@kernel.org>
    maiblox: mediatek: Fix handling of platform_get_irq() error

Jing Xiangfeng <jingxiangfeng@huawei.com>
    thermal: core: Adding missing nlmsg_free() in thermal_genl_sampling_temp()

Johannes Berg <johannes.berg@intel.com>
    um: time-travel: Fix IRQ handling in time_travel_handle_message()

Tiezhu Yang <yangtiezhu@loongson.cn>
    um: vector: Use GFP_ATOMIC under spin lock

Eric Biggers <ebiggers@google.com>
    f2fs: reject CASEFOLD inode flag without casefold feature

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix skb lifetime in rxe_rcv_mcast_pkt()

Colin Ian King <colin.king@canonical.com>
    IB/rdmavt: Fix sizeof mismatch

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_reboot_notifier

Vaibhav Jain <vaibhav@linux.ibm.com>
    powerpc/papr_scm: Add PAPR command family to pass-through command-set

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/radix: Make radix_mem_block_size 64bit

Nicholas Piggin <npiggin@gmail.com>
    powerpc/security: Fix link stack flush instruction

Jing Xiangfeng <jingxiangfeng@huawei.com>
    i3c: master: Fix error return in cdns_i3c_master_probe()

Namhyung Kim <namhyung@kernel.org>
    perf stat: Fix out of bounds CPU map access when handling armv8_pmu events

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf/hv-gpci: Fix starting index value

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Exclude pmc5/6 from the irrelevant PMU group constraints

Daniel Axtens <dja@axtens.net>
    powerpc: PPC_SECURE_BOOT should not require PowerNV

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: fix irq replay pt_regs->softe value

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: fix irq replay missing preempt

Kamal Heib <kamalheib1@gmail.com>
    RDMA/ipoib: Set rtnl_link_ops for ipoib interfaces

Florian Fainelli <f.fainelli@gmail.com>
    mtd: parsers: bcm63xx: Do not make it modular

Leon Romanovsky <leon@kernel.org>
    overflow: Include header file with SIZE_MAX declaration

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix pager search for multi-line strings

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    mtd: rawnand: ams-delta: Fix non-OF build warning

Hauke Mehrtens <hauke@hauke-m.de>
    mtd: spinand: gigadevice: Add QE Bit

Hauke Mehrtens <hauke@hauke-m.de>
    mtd: spinand: gigadevice: Only one dummy byte in QUADIO

Evgeny Novikov <novikov@ispras.ru>
    mtd: rawnand: vf610: disable clk on error handling path in probe

Christophe Kerello <christophe.kerello@st.com>
    mtd: rawnand: stm32_fmc2: fix a buffer overflow

Vignesh Raghavendra <vigneshr@ti.com>
    mtd: hyperbus: hbmc-am654: Fix direct mapping setup flash access

Liu Shixin <liushixin2@huawei.com>
    RDMA/mlx5: Fix type warning of sizeof in __mlx5_ib_alloc_counters()

Weihang Li <liweihang@huawei.com>
    RDMA/hns: Fix missing sq_sig_type when querying QP

Weihang Li <liweihang@huawei.com>
    RDMA/hns: Fix configuration of ack_req_freq in QPC

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fix the wrong value of rnr_retry when querying qp

Jiaran Zhang <zhangjiaran@huawei.com>
    RDMA/hns: Solve the overflow of the calc_pg_sz()

Jiaran Zhang <zhangjiaran@huawei.com>
    RDMA/hns: Add check for the validity of sl configuration

Jin Yao <yao.jin@linux.intel.com>
    perf stat: Skip duration_time in setup_system_wide

Sindhu, Devale <sindhu.devale@intel.com>
    i40iw: Add support to make destroy QP synchronous

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Disable IB_DEVICE_MEM_MGT_EXTENSIONS if IB_WR_REG_MR can't work

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Make mkeys always owned by the kernel's PD when not enabled

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Use set_mkc_access_pd_addr_fields() in reg_create()

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Set the unsupported wr opcode

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    RDMA/qedr: Fix resource leak in qedr_create_qp

Ian Rogers <irogers@google.com>
    perf metricgroup: Fix uncore metric expressions

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix "context_switch event has no tid" error

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Fix use after free race in roce multicast join

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Consolidate the destruction of a cma_multicast in one place

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Remove dead code for kernel rdmacm multicast

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Combine cma_ndev_work with cma_work

Vaibhav Jain <vaibhav@linux.ibm.com>
    powerpc/papr_scm: Fix warning triggered by perf_stats_show()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/radix: Fix mm_cpumask trimming race vs kthread_use_mm

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/kasan: Fix CONFIG_KASAN_VMALLOC for 8xx

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Disable TAU between measurements

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Check processor type before enabling TAU interrupt

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Remove duplicated set_thresholds() call

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Convert from timer to workqueue

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Use appropriate temperature sample interval

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/hash/4k: Support large linear mapping range with 4K

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    powerpc/watchpoint: Add hw_len wherever missing

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    powerpc/watchpoint: Fix handling of vector instructions

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    powerpc/watchpoint: Fix quadword instruction handling on p10 predecessors

Thiago Jung Bauermann <bauerman@linux.ibm.com>
    powerpc/pseries/svm: Allocate SWIOTLB buffer anywhere in memory

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix inline size returned for iWARP

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix return code if accept is called on a destroyed qp

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix use of uninitialized field

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix doorbell setting

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix qp structure memory leak

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/umem: Prevent small pages from being returned by ib_umem_find_best_pgsz()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/umem: Fix ib_umem_find_best_pgsz() for mappings that cross a page boundary

Leon Romanovsky <leon@kernel.org>
    RDMA: Restore ability to return error for destroy WQ

Leon Romanovsky <leon@kernel.org>
    RDMA: Change XRCD destroy return value

Leon Romanovsky <leon@kernel.org>
    RDMA: Allow fail of destroy CQ

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Delete function indirection for alloc/free kernel CQ

Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
    RDMA/rtrs-srv: Incorporate ib_register_client into rtrs server init

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix high key handling in the rt allocator's query_range function

Scott Mayhew <smayhew@redhat.com>
    nfs: add missing "posix" local_lock constant table definition

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix deadlock and streamline xfs_getfsmap performance

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: limit entries returned when counting fsmap records

Matthew Wilcox (Oracle) <willy@infradead.org>
    ida: Free allocated bitmap in error path

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    arc: plat-hsdk: fix kconfig dependency warning when !RESET_CONTROLLER

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: include SDHC support only when hardware has it

Dave Chinner <dchinner@redhat.com>
    xfs: fix finobt btree block recovery ordering

Guillaume Tucker <guillaume.tucker@collabora.com>
    ARM: 9007/1: l2c: fix prefetch bits init in L2X0_AUX_CTRL using DT values

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools feature: Add missing -lzstd to the fast path feature detection

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Make GTK2 support opt-in

Jordan Niethe <jniethe5@gmail.com>
    selftests/powerpc: Fix prefixes in alignment_handler signal handler

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    mtd: mtdoops: Don't write panic data twice

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Fix potential race between destroy and CQE poll

Scott Cheloha <cheloha@linux.ibm.com>
    pseries/drmem: don't cache node id in drmem_lmb struct

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: explicitly reschedule during drmem_lmb list traversal

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/umem: Fix signature of stub ib_umem_find_best_pgsz()

Lang Cheng <chenglang@huawei.com>
    RDMA/hns: Add a check for current state before modifying QP

Arnd Bergmann <arnd@arndb.de>
    mtd: lpddr: fix excessive stack usage with clang

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/ucma: Add missing locking around rdma_leave_multicast()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/ucma: Fix locking for ctx->events_reported

Colin Ian King <colin.king@canonical.com>
    refperf: Avoid null pointer dereference when buf fails to allocate

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Properly set rcu_fwds for OOM handling

Neeraj Upadhyay <neeraju@codeaurora.org>
    rcu/tree: Force quiescent state on callback overload

Nicholas Mc Guire <hofrat@osadl.org>
    powerpc/icp-hv: Fix missing of_node_put() in success path

Nicholas Mc Guire <hofrat@osadl.org>
    powerpc/pseries: Fix missing of_node_put() in rng_init()

Håkon Bugge <haakon.bugge@oracle.com>
    IB/mlx4: Adjust delayed work when a dup is observed

Håkon Bugge <haakon.bugge@oracle.com>
    IB/mlx4: Fix starvation in paravirt mux/demux

Parshuram Thombare <pthombar@cadence.com>
    i3c: master add i3c_master_attach_boardinfo to preserve boardinfo

Tom Zanussi <zanussi@kernel.org>
    tracing: Handle synthetic event array field type checking correctly

Tom Zanussi <zanussi@kernel.org>
    selftests/ftrace: Change synthetic event name for inter-event-combined test

Andrii Nakryiko <andrii@kernel.org>
    fs: fix NULL dereference due to data race in prepend_path()

Suren Baghdasaryan <surenb@google.com>
    mm, oom_adj: don't loop through tasks in __set_oom_adj when not necessary

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm/page_alloc.c: fix freeing non-compound pages

Liao Pingfang <liao.pingfang@zte.com.cn>
    mm/mmap.c: replace do_brk with do_brk_flags in comment of insert_vm_struct()

Ralph Campbell <rcampbell@nvidia.com>
    mm/memcg: fix device private memcg accounting

Roman Gushchin <guro@fb.com>
    mm: memcg/slab: fix racy access to page->mem_cgroup in mem_cgroup_from_obj()

Miaohe Lin <linmiaohe@huawei.com>
    mm/swapfile.c: fix potential memory leak in sys_swapon

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_log: missing vlan offload tag and proto

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    net: korina: fix kfree of rx/tx descriptor array

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Remove skb_orphan and let normal skb_kfree do cleanup

Julian Anastasov <ja@ssi.bg>
    ipvs: clear skb->tstamp in forwarding path

Ye Bin <yebin10@huawei.com>
    drm/amdgpu: Fix invalid number of character '{' in amdgpu_acpi_init

Christian Hewitt <christianshewitt@gmail.com>
    drm/panfrost: increase readl_relaxed_poll_timeout values

Tom Rix <trix@redhat.com>
    mwifiex: fix double free

Mike Snitzer <snitzer@redhat.com>
    dm: fix request-based DM to not bounce through indirect dm_submit_bio

Vadim Pasternak <vadimp@nvidia.com>
    platform/x86: mlx-platform: Remove PSU EEPROM configuration

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix BA sessions for older firmwares

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: mediatek: mt8183-da7219: fix wrong ops for I2S3

Tom Zanussi <zanussi@kernel.org>
    tracing: Fix parse_synth_field() error handling

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    ipmi_si: Fix wrong return value in try_smi_init()

Coiby Xu <coiby.xu@gmail.com>
    staging: qlge: fix build breakage with dumping enabled

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: ioat: Allocate correct size for descriptor chunk

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()

John Donnelly <john.p.donnelly@oracle.com>
    scsi: target: tcmu: Fix warning: 'page' may be used uninitialized

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: Fix INTR OUT transfers in DDMA mode.

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix non-split wiphy information

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    ocxl: fix kconfig dependency warning for OCXL

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    bus: mhi: core: Fix the building of MHI module

Lorenzo Colitti <lorenzo@google.com>
    usb: gadget: u_ether: enable qmult on SuperSpeed Plus as well

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: gadget: u_serial: clear suspended flag when disconnecting

Lorenzo Colitti <lorenzo@google.com>
    usb: gadget: f_ncm: fix ncm_bitrate for SuperSpeed and above.

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: dbg: run init_cfg function once per driver load

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: dbg: remove no filter condition

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: split a print to avoid a WARNING in ROC

Adam Brickman <Adam.Brickman@cirrus.com>
    ASoC: wm_adsp: Pass full name to snd_ctl_notify

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8712: Fix enqueue_reorder_recvframe()

Drew Fustini <drew@beagleboard.org>
    pinctrl: single: fix debug output when #pinctrl-cells = 2

Drew Fustini <drew@beagleboard.org>
    pinctrl: single: fix pinctrl_spec.args_count bounds check

Mike Snitzer <snitzer@redhat.com>
    dm: fix missing imposition of queue_limits from dm_wq_work() thread

Dan Carpenter <dan.carpenter@oracle.com>
    mfd: sm501: Fix leaks in probe()

Marc Zyngier <maz@kernel.org>
    mfd: syscon: Don't free allocated name for regmap_config

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    serial: 8250_dw: Fix clk-notifier/port suspend deadlock

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    serial: 8250: Skip uninitialized TTY port baud rate update

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    serial: 8250: Discard RTS/DTS setting from clock update method

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: tigerlake: Fix register offsets for TGL-H variant

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: Fix endianness issues in sk_lookup/ctx_narrow_access

Thomas Gleixner <tglx@linutronix.de>
    net: enic: Cure the enic api locking trainwreck

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: fix runtime autosuspend delay when slow polling

Yu Kuai <yukuai3@huawei.com>
    iommu/qcom: add missing put_device() call in qcom_iommu_of_xlate()

Andrew Jeffery <andrew@aj.id.au>
    pinctrl: aspeed: Use the right pinconf mask

Colin Ian King <colin.king@canonical.com>
    qtnfmac: fix resource leaks on unsupported iftype error return path

Toke Høiland-Jørgensen <toke@redhat.com>
    selftests: Remove fmod_ret from test_overhead

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: disallow attaching modify_return tracing functions to other BPF programs

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: set up 200GBPS speed

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: etm4x: Fix save and restore of TRCVMIDCCTLR1 register

Mike Leach <mike.leach@linaro.org>
    coresight: cti: Fix bug clearing sysfs links on callback

Mike Leach <mike.leach@linaro.org>
    coresight: cti: Fix remove sysfs link error

Tingwei Zhang <tingwei@codeaurora.org>
    coresight: etm: perf: Fix warning caused by etm_setup_aux failure

Matthew Wilcox (Oracle) <willy@infradead.org>
    iomap: Use kzalloc to allocate iomap_page

Rajkumar Manoharan <rmanohar@codeaurora.org>
    nl80211: fix OBSS PD min and max offset validation

Mohammed Gamal <mgamal@redhat.com>
    hv: clocksource: Add notrace attribute to read_hv_sched_clock_*() functions

Vadym Kochan <vadym.kochan@plvision.eu>
    nvmem: core: fix possibly memleak when use nvmem_cell_info_to_nvmem_cell()

Yang Yingliang <yangyingliang@huawei.com>
    tty: serial: imx: fix link error with CONFIG_SERIAL_CORE_CONSOLE=n

Yang Yingliang <yangyingliang@huawei.com>
    tty: hvc: fix link error with CONFIG_SERIAL_CORE_CONSOLE=n

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hid-input: fix stylus battery reporting

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: Instantiate snd_soc_dai_driver

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: crtc: Rework a bit the CRTC state code

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: qcom-ngd-ctrl: disable ngd in qmi server down callback

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: core: do not enter to clock pause mode in core

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: core: check get_addr before removing laddr ida

Eric Dumazet <edumazet@google.com>
    quota: clear padding in v2r1_mem2diskdqb()

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: fix possible memory leak in mt7915_mcu_add_beacon

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7622: fix fw hang on mt7622

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: move drv_own/fw_own in mt7615_mcu_ops

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7663u: fix dma header initialization

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: fix a possible NULL pointer dereference in mt76_testmode_dump

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix a possible NULL pointer dereference in mt7615_pm_wake_work

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix possible memory leak in mt7615_tm_set_tx_power

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7663s: fix resume failure

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: release mutex in mt7615_reset_test_set

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: hold mt76 lock queueing wd in mt7615_queue_key_update

Andreas Färber <afaerber@suse.de>
    rtw88: Fix potential probe error handling race with wow firmware loading

Andreas Färber <afaerber@suse.de>
    rtw88: Fix probe error handling race with firmware loading

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    usb: dwc2: Add missing cleanups when usb_add_gadget_udc() fails

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Properly default unspecified speed

Nathan Chancellor <natechancellor@gmail.com>
    usb: dwc2: Fix parameter type in function pointer prototype

Denis Efremov <efremov@linux.com>
    net/mlx5e: IPsec: Use kvfree() for memory allocated with kvzalloc()

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Avoid mutex lock for a long-time ioctl

Souptick Joarder <jrdr.linux@gmail.com>
    misc: mic: scif: Fix error handling path

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    ASoC: cros_ec_codec: fix kconfig dependency warning for SND_SOC_CROS_EC_CODEC

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dmatest: Check list for emptiness before access its last entry

Tomasz Figa <tfiga@chromium.org>
    phy: rockchip-dphy-rx0: Include linux/delay.h

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: rcar-du: Put reference to VSP device

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: wmi: prevent a shift wrapping bug in ath6kl_wmi_delete_pstream_cmd()

Bo YU <tsu.yubo@gmail.com>
    ath11k: Add checked value for ath11k_ahb_remove

Aswath Govindraju <a-govindraju@ti.com>
    spi: omap2-mcspi: Improve performance waiting for CHSTAT

Dan Murphy <dmurphy@ti.com>
    ASoC: tas2770: Fix unbalanced calls to pm_runtime

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: control: add size checks for ext_bytes control .put()

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366rb: Support all 4096 VLANs

Miquel Raynal <miquel.raynal@bootlin.com>
    ASoC: tlv320aic32x4: Fix bdiv clock rate derivation

Dan Murphy <dmurphy@ti.com>
    ASoC: tas2770: Fix error handling with update_bits

Dan Murphy <dmurphy@ti.com>
    ASoC: tas2770: Fix required DT properties in the code

Dan Murphy <dmurphy@ti.com>
    ASoC: tas2770: Add missing bias level power states

Dan Murphy <dmurphy@ti.com>
    ASoC: tas2770: Fix calling reset in probe

Huang Guobin <huangguobin4@huawei.com>
    net: wilc1000: clean up resource in error path of init mon interface

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Skip PVID setting if not requested

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Refactor VLAN/PVID init

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Check validity of passed VLANs

Jordan Crouse <jcrouse@codeaurora.org>
    drm/msm: Fix the a650 hw_apriv check

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: don't create endpoint debugfs entry before ring buffer is set.

Sonny Sasaka <sonnysasaka@chromium.org>
    Bluetooth: Fix auto-creation of hci_conn at Conn Complete event

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: Fix endianness issue in test_sockopt_sk

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: Fix endianness issue in sk_assign

Grygorii Strashko <grygorii.strashko@ti.com>
    dmaengine: ti: k3-udma-glue: fix channel enable functions

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: interpret \n as a new line

Vadym Kochan <vadym.kochan@plvision.eu>
    nvmem: core: fix missing of_node_put() in of_nvmem_device_get()

Jonathan Zhou <jonathan.zhouwen@huawei.com>
    coresight: etm4x: Fix issues on trcseqevr access

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Handle unreachable sink in perf mode

Tingwei Zhang <tingwei@codeaurora.org>
    coresight: cti: Write regsiters directly in cti_enable_hw()

Jonathan Zhou <jonathan.zhouwen@huawei.com>
    coresight: etm4x: Fix issues within reset interface of sysfs

Mike Leach <mike.leach@linaro.org>
    coresight: etm4x: Ensure default perf settings filter user/kernel

Tingwei Zhang <tingwei@codeaurora.org>
    coresight: cti: remove pm_runtime_get_sync() from CPU hotplug

Tingwei Zhang <tingwei@codeaurora.org>
    coresight: cti: disclaim device only when it's claimed

Mian Yousaf Kaukab <ykaukab@suse.de>
    coresight: fix offset by one error in counting ports

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: etm4x: Fix etm4_count race by moving cpuhp callbacks to init

Camel Guo <camelg@axis.com>
    ASoC: tlv320adcx140: Fix digital gain range

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: topology: disable size checks for bytes_ext controls if needed

KP Singh <kpsingh@google.com>
    ima: Fix NULL pointer dereference in ima_file_hash

Matthias Kaehlcke <mka@chromium.org>
    cpufreq: qcom: Don't add frequencies without an OPP

Stefan Agner <stefan@agner.ch>
    drm: mxsfb: check framebuffer pitch

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Add missing MODULE_DEVICE_TABLE

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: force the log after remapping a synchronous-writes file

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: use netif_tx_start|stop_all_queues() function

Aashish Verma <aashishx.verma@intel.com>
    net: stmmac: Fix incorrect location to set real_num_rx|tx_queues

Tomas Henzl <thenzl@redhat.com>
    scsi: mpt3sas: Fix sync irqs

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: Don't call timecounter cyc2time directly from 1PPS flow

Moshe Tal <moshet@mellanox.com>
    net/mlx5: Fix uninitialized variable warning

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Fix multiple tail calls

Luca Weiss <luca@z3ntu.xyz>
    drm/msm/adreno: fix probe without iommu

Thierry Reding <treding@nvidia.com>
    pinctrl: devicetree: Keep deferring even on timeout

Thomas Preston <thomas.preston@codethink.co.uk>
    pinctrl: mcp23s08: Fix mcp23x17 precious range

Thomas Preston <thomas.preston@codethink.co.uk>
    pinctrl: mcp23s08: Fix mcp23x17_regmap initialiser

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    Bluetooth: Re-order clearing suspend tasks

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Fix memory leak in read_adv_mon_features()

Kees Cook <keescook@chromium.org>
    selftests/lkdtm: Use "comm" instead of "diff" for dmesg

Matthew Wilcox (Oracle) <willy@infradead.org>
    iomap: Mark read blocks uptodate in write_begin

Matthew Wilcox (Oracle) <willy@infradead.org>
    iomap: Clear page error before beginning a write

Steven Price <steven.price@arm.com>
    drm/panfrost: Ensure GPU quirks are always initialised

Stephen Boyd <swboyd@chromium.org>
    drm/msm: Avoid div-by-zero in dpu_crtc_atomic_check()

Dan Carpenter <dan.carpenter@oracle.com>
    ath11k: fix uninitialized return in ath11k_spectral_process_data()

Dan Carpenter <dan.carpenter@oracle.com>
    HID: roccat: add bounds checking in kone_sysfs_write_settings()

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: ufs-mediatek: Fix HOST_PA_TACTIVATE quirk

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: ufs-mediatek: Eliminate error message for unbound mphy

Yu Kuai <yukuai3@huawei.com>
    ASoC: fsl: imx-es8328: add missing put_device() call in imx_es8328_probe()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    video: fbdev: radeon: Fix memleak in radeonfb_pci_register

Tom Rix <trix@redhat.com>
    video: fbdev: sis: fix null ptr dereference

Colin Ian King <colin.king@canonical.com>
    video: fbdev: vga16fb: fix setting of pixclock because a pass-by-value error

Tom Rix <trix@redhat.com>
    ath11k: fix a double free and a memory leak

Edward Cree <ecree@solarflare.com>
    sfc: don't double-down() filters in ef100_reset()

Souptick Joarder <jrdr.linux@gmail.com>
    drivers/virt/fsl_hypervisor: Fix error handling path

Hans de Goede <hdegoede@redhat.com>
    pwm: lpss: Add range limit check for the base_unit register value

Hans de Goede <hdegoede@redhat.com>
    pwm: lpss: Fix off by one error in base_unit math in pwm_lpss_prepare()

Artem Savkov <asavkov@redhat.com>
    pty: do tty_flip_buffer_push without port->lock in pty_write

Tyrel Datwyler <tyreld@linux.ibm.com>
    tty: hvcs: Don't NULL tty->driver_data until hvcs_cleanup()

Tong Zhang <ztong0001@gmail.com>
    tty: serial: earlycon dependency

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: intel: fix NULL/ERR_PTR confusion

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: stream: fix NULL/IS_ERR confusion

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix max_entries calculation v4

Jann Horn <jannh@google.com>
    binder: Remove bogus warning on failed same-process transaction

Eric Biggers <ebiggers@google.com>
    scsi: ufs: Make ufshcd_print_trs() consider UFSHCD_QUIRK_PRDT_BYTE_GRAN

Anatoly Pugachev <matorola@gmail.com>
    selftests: vm: add fragment CONFIG_GUP_BENCHMARK

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    Bluetooth: Clear suspend tasks on unregister

Dinghao Liu <dinghao.liu@zju.edu.cn>
    drm/crc-debugfs: Fix memleak in crc_control_write

Tyler Hicks <tyhicks@linux.microsoft.com>
    ima: Fail rule parsing when asymmetric key measurement isn't supportable

Tyler Hicks <tyhicks@linux.microsoft.com>
    ima: Pre-parse the list of keyrings in a KEY_CHECK rule

Weqaar Janjua <weqaar.a.janjua@intel.com>
    samples/bpf: Fix to xdpsock to avoid recycling frames

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm: panel: Fix bpc for OrtusTech COM43H4M85ULC panel

Alexei Starovoitov <ast@kernel.org>
    mm/error_inject: Fix allow_error_inject function signatures.

Alex Dewar <alex.dewar90@gmail.com>
    VMCI: check return value of get_user_pages_fast() for errors

Alex Dewar <alex.dewar90@gmail.com>
    staging: emxx_udc: Fix passing of NULL to dma_alloc_coherent()

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix frame reordering

dinghao.liu@zju.edu.cn <dinghao.liu@zju.edu.cn>
    backlight: sky81452-backlight: Fix refcount imbalance on error

Miroslav Benes <mbenes@suse.cz>
    selftests/livepatch: Do not check order when using "comm" for dmesg checking

Brian Norris <briannorris@chromium.org>
    rtw88: don't treat NULL pointer as an array

Dinghao Liu <dinghao.liu@zju.edu.cn>
    wilc1000: Fix memleak in wilc_bus_probe

Dinghao Liu <dinghao.liu@zju.edu.cn>
    wilc1000: Fix memleak in wilc_sdio_probe

Alex Gartrell <alexgartrell@gmail.com>
    libbpf: Fix unintentional success return code in bpf_object__load

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    scsi: qla2xxx: Fix wrong return value in qla_nvme_register_hba()

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    scsi: qla2xxx: Fix wrong return value in qlt_chk_unresolv_exchg()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: qla2xxx: Fix the size used in a 'dma_free_coherent()' call

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'

Tom Rix <trix@redhat.com>
    drm/gma500: fix error check

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix test_vmlinux test to use bpf_probe_read_user()

Colin Ian King <colin.king@canonical.com>
    drm/amd/display: fix potential integer overflow when shifting 32 bit variable bl_pwm

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: rtl8192u: Do not use GFP_KERNEL in atomic context

Thomas Zimmermann <tzimmermann@suse.de>
    drm/malidp: Use struct drm_gem_object_funcs.get_sg_table internally

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mwifiex: Do not use GFP_KERNEL in atomic context

Tom Rix <trix@redhat.com>
    brcmfmac: check ndev pointer

Wang Yufen <wangyufen@huawei.com>
    ath11k: Fix possible memleak in ath11k_qmi_init_service

Rohit kumar <rohitkr@codeaurora.org>
    ASoC: qcom: lpass-cpu: fix concurrency issue

Rohit kumar <rohitkr@codeaurora.org>
    ASoC: qcom: lpass-platform: fix memory leak

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ath10k: Fix the size used in a 'dma_free_coherent()' call in an error handling path

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: prevent potential array overflow in ath6kl_add_new_sta()

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm: panel: Fix bus format for OrtusTech COM43H4M85ULC panel

Qinglang Miao <miaoqinglang@huawei.com>
    drm/vkms: add missing platform_device_unregister() in vkms_init()

Qinglang Miao <miaoqinglang@huawei.com>
    drm/vgem: add missing platform_device_unregister() in vgem_init()

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    drm/amd/display: Fix wrong return value in dm_update_plane_state()

Samuel Holland <samuel@sholland.org>
    Bluetooth: hci_uart: Cancel init work before unregistering

Melissa Wen <melissa.srw@gmail.com>
    drm/vkms: fix xrgb on compute crc

Venkateswara Naralasetty <vnaralas@codeaurora.org>
    ath10k: provide survey info as accumulated data

Yang Yang <yang.yang@vivo.com>
    blk-mq: move cancel of hctx->run_work to the front of blk_exit_queue

Qu Wenruo <wqu@suse.com>
    btrfs: add owner and fs_info to alloc_state io_tree

Marek Vasut <marex@denx.de>
    spi: imx: Fix freeing of DMA channels if spi_bitbang_start() fails

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    hwmon: (bt1-pvt) Wait for the completion with timeout

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    hwmon: (bt1-pvt) Cache current update timeout

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    hwmon: (bt1-pvt) Test sensor power supply on probe

Łukasz Stelmach <l.stelmach@samsung.com>
    spi: spi-s3c64xx: Check return values

Łukasz Stelmach <l.stelmach@samsung.com>
    spi: spi-s3c64xx: swap s3c64xx_spi_set_cs() and s3c64xx_enable_datapath()

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    pinctrl: bcm: fix kconfig dependency warning when !GPIOLIB

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: resolve supply after creating regulator

Qiushi Wu <wu000273@umn.edu>
    media: ti-vpe: Fix a missing check and reference count leak

Qiushi Wu <wu000273@umn.edu>
    media: stm32-dcmi: Fix a reference count leak

Qiushi Wu <wu000273@umn.edu>
    media: s5p-mfc: Fix a reference count leak

Qiushi Wu <wu000273@umn.edu>
    media: camss: Fix a reference count leak.

Qiushi Wu <wu000273@umn.edu>
    media: platform: fcp: Fix a reference count leak.

Qiushi Wu <wu000273@umn.edu>
    media: rockchip/rga: Fix a reference count leak.

Qiushi Wu <wu000273@umn.edu>
    media: rcar-vin: Fix a reference count leak.

Christoph Hellwig <hch@lst.de>
    nvme: fix error handling in nvme_ns_report_zones

Tom Rix <trix@redhat.com>
    media: tc358743: cleanup tc358743_cec_isr

Tom Rix <trix@redhat.com>
    media: tc358743: initialize variable

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: mtk-mdp: Fix Null pointer dereference when calling list_add

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: mx2_emmaprp: Fix memleak in emmaprp_probe

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ce - handle endianness of t_common_ctl

Nicolas Toromanoff <nicolas.toromanoff@st.com>
    crypto: stm32/crc32 - Avoid lock if hardware is already used

Xiaoliang Pang <dawning.pang@gmail.com>
    cypto: mediatek - fix leaks in mtk_desc_ring_alloc

Dan Carpenter <dan.carpenter@oracle.com>
    hwmon: (w83627ehf) Fix a resource leak in probe

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/max34440) Fix status register reads for MAX344{51,60,61}

Charles Keepax <ckeepax@opensource.cirrus.com>
    regmap: debugfs: Fix more error path regressions

Kees Cook <keescook@chromium.org>
    selftests/seccomp: powerpc: Fix seccomp return value testing

Kees Cook <keescook@chromium.org>
    selftests/seccomp: Refactor arch register macros to avoid xtensa special case

Kees Cook <keescook@chromium.org>
    selftests/seccomp: Use __NR_mknodat instead of __NR_mknod

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: sa2ul - Fix pm_runtime_get_sync() error checking

Tero Kristo <t-kristo@ti.com>
    crypto: omap-sham - fix digcnt register handling with export/import

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: sa2ul - Select CRYPTO_AUTHENC

Jay Fang <f.fangjian@huawei.com>
    spi: dw-pci: free previously allocated IRQs if desc->setup() fails

Eddie James <eajames@linux.ibm.com>
    spi: fsi: Implement restricted size for certain controllers

Brad Bishop <bradleyb@fuzziesquirrel.com>
    spi: fsi: Fix use of the bneq+ sequencer instruction

Brad Bishop <bradleyb@fuzziesquirrel.com>
    spi: fsi: Handle 9 to 15 byte transfers lengths

Tero Kristo <t-kristo@ti.com>
    crypto: sa2ul - fix compiler warning produced by clang

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: i2c: max9286: Allocate v4l2_async_subdev dynamically

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: rcar-csi2: Allocate v4l2_async_subdev dynamically

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: rcar_drif: Allocate v4l2_async_subdev dynamically

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: rcar_drif: Fix fwnode reference leak when parsing DT

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    media: i2c: ov5640: Enable data pins on poweron for DVP mode

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    media: i2c: ov5640: Separate out mipi configuration from s_power

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    media: i2c: ov5640: Remain in power down for DVP mode unless streaming

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: omap3isp: Fix memleak in isp_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: staging/intel-ipu3: css: Correctly reset some memory

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Silence shift-out-of-bounds warning

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Set media controller entity functions

Eric Biggers <ebiggers@google.com>
    fscrypt: restrict IV_INO_LBLK_32 to ino_bits <= 32

Tom Rix <trix@redhat.com>
    media: m5mols: Check function pointer in m5mols_sensor_power

Colin Ian King <colin.king@canonical.com>
    media: i2c: fix error check on max9286_read call

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: ov5640: Correct Bit Div register in clock tree diagram

Ezequiel Garcia <ezequiel@collabora.com>
    media: hantro: postproc: Fix motion vector space allocation

Ezequiel Garcia <ezequiel@collabora.com>
    media: hantro: h264: Get the correct fallback reference buffer

Sylwester Nawrocki <s.nawrocki@samsung.com>
    media: Revert "media: exynos4-is: Add missed check for pinctrl_lookup_state()"

dinghao.liu@zju.edu.cn <dinghao.liu@zju.edu.cn>
    crypto: ccree - fix runtime PM imbalance on error

Tom Rix <trix@redhat.com>
    media: tuner-simple: fix regression in simple_set_radio_freq

Peilin Ye <yepeilin.cs@gmail.com>
    media: vivid: Fix global-out-of-bounds read in precalculate_color()

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    crypto: picoxcell - Fix potential race condition bug

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: ixp4xx - Fix the size used in a 'dma_free_coherent()' call

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    crypto: mediatek - Fix wrong return value in mtk_desc_ring_alloc()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_skcipher - EBUSY on aio should be an error

Jonathan Marek <jonathan@marek.ca>
    regulator: set of_node for qcom vbus regulator

Jiri Olsa <jolsa@redhat.com>
    perf/core: Fix race in the perf_mmap_close() function

Peter Zijlstra <peterz@infradead.org>
    lockdep: Revert "lockdep: Use raw_cpu_*() for per-cpu variables"

Peter Zijlstra <peterz@infradead.org>
    lockdep: Fix lockdep recursion

Peter Zijlstra <peterz@infradead.org>
    lockdep: Fix usage_traceoverflow

Sasha Levin <sashal@kernel.org>
    perf/x86: Fix n_pair for cancelled txn

Maulik Shah <mkshah@codeaurora.org>
    pinctrl: qcom: Use return value from irq_set_wake() call

Maulik Shah <mkshah@codeaurora.org>
    pinctrl: qcom: Set IRQCHIP_SET_TYPE_MASKED and IRQCHIP_MASK_ON_SUSPEND flags

Colin Ian King <colin.king@canonical.com>
    x86/events/amd/iommu: Fix sizeof mismatch

Libing Zhou <libing.zhou@nokia-sbell.com>
    x86/nmi: Fix nmi_handle() duration miscalculation

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of the IMC free-running events

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix for iio mapping on Skylake Server

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Reduce the number of CBOX counters

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Update Ice Lake uncore units

Alexandru Elisei <alexandru.elisei@arm.com>
    arm64: perf: Add missing ISB in armv8pmu_enable_counter()

Barry Song <song.bao.hua@hisilicon.com>
    sched/fair: Use dst group while checking imbalance for NUMA balancer

Xunlei Pang <xlpang@linux.alibaba.com>
    sched/fair: Fix wrong cpu selecting from isolated domain

Mark Salter <msalter@redhat.com>
    drivers/perf: thunderx2_pmu: Fix memory resource error handling

Mark Salter <msalter@redhat.com>
    drivers/perf: xgene_pmu: Fix uninitialized resource struct

peterz@infradead.org <peterz@infradead.org>
    seqlock: Unbreak lockdep

Amit Daniel Kachhap <amit.kachhap@arm.com>
    arm64: kprobe: add checks for ARMv8.3-PAuth combined instructions

YueHaibing <yuehaibing@huawei.com>
    irqchip/ti-sci-intr: Fix unsigned comparison to zero

YueHaibing <yuehaibing@huawei.com>
    irqchip/ti-sci-inta: Fix unsigned comparison to zero

Arvind Sankar <nivedita@alum.mit.edu>
    x86/fpu: Allow multiple bits in clearcpuid= parameter

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/ds: Fix x86_pmu_stop warning for large PEBS

Krzysztof Kozlowski <krzk@kernel.org>
    EDAC/ti: Fix handling of platform_get_irq() error

Krzysztof Kozlowski <krzk@kernel.org>
    EDAC/aspeed: Fix handling of platform_get_irq() error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    EDAC/i5100: Fix error handling order in i5100_init_one()

Randy Dunlap <rdunlap@infradead.org>
    microblaze: fix kbuild redundant file warning

Lukasz Luba <lukasz.luba@arm.com>
    sched/fair: Fix wrong negative conversion in find_energy_efficient_cpu()

Luca Stefani <luca.stefani.ge1@gmail.com>
    RAS/CEC: Fix cec_init() prototype

Andrei Botila <andrei.botila@nxp.com>
    crypto: caam/qi2 - add support for more XTS key lengths

Andrei Botila <andrei.botila@nxp.com>
    crypto: caam/qi2 - add fallback for XTS with more than 8B IV

Andrei Botila <andrei.botila@nxp.com>
    crypto: caam/jr - add support for more XTS key lengths

Andrei Botila <andrei.botila@nxp.com>
    crypto: caam/jr - add fallback for XTS with more than 8B IV

Andrei Botila <andrei.botila@nxp.com>
    crypto: caam/qi - add support for more XTS key lengths

Andrei Botila <andrei.botila@nxp.com>
    crypto: caam/qi - add fallback for XTS with more than 8B IV

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_aead - Do not set MAY_BACKLOG on the async path

Andrei Botila <andrei.botila@nxp.com>
    crypto: caam - add xts check for block length equal to zero

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Don't ignore errors from crypto_shash_update()

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    KVM: SVM: Initialize prev_ga_tag before use

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: x86: Intercept LA57 to inject #GP fault when it's reserved

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Commit zap of remaining invalid pages when recovering lpages

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Reload vmcs01 if getting vmcs12's pages fails

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Reset the segment cache when stuffing guest segs

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Morph notification vector IRQ on nested VM-Enter to pending PI

Marc Zyngier <maz@kernel.org>
    arm64: Make use of ARCH_WORKAROUND_1 even when KVM is not enabled

Steve French <stfrench@microsoft.com>
    smb3: fix stat when special device file and mounted with modefromsid

Steve French <stfrench@microsoft.com>
    smb3: do not try to cache root directory if dir leases not supported

Steve French <stfrench@microsoft.com>
    SMB3.1.1: Fix ids returned in POSIX query dir

Rohith Surabattula <rohiths@microsoft.com>
    SMB3: Resolve data corruption of TCP server info fields

Shyam Prasad N <sprasad@microsoft.com>
    cifs: Return the error from crypt_message when enc/dec key not found.

Dan Carpenter <dan.carpenter@oracle.com>
    cifs: remove bogus debug code

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable audio jacks of ASUS D700SA with ALC887

Qiu Wenbo <qiuwenbo@kylinos.com.cn>
    ALSA: hda/realtek - Add mute Led support for HP Elitebook 845 G7

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - set mic to auto detect on a HP AIO machine

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek - The front Mic on a HP machine doesn't work

Lukasz Halman <lukasz.halman@gmail.com>
    ALSA: usb-audio: Line6 Pod Go interface requires static clock rate quirk

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Fix the return value if cb func is already registered

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Don't register a cb func if it is registered already

Edward Cree <ecree@solarflare.com>
    sfc: move initialisation of efx->filter_sem to efx_init_struct()

Eelco Chaudron <echaudro@redhat.com>
    net: openvswitch: fix to make sure flow_lookup() is not preempted

Geert Uytterhoeven <geert@linux-m68k.org>
    mptcp: MPTCP_KUNIT_TESTS should depend on MPTCP instead of selecting it

Jakub Kicinski <kuba@kernel.org>
    ixgbe: fix probing of multi-port devices with one MDIO

Guillaume Nault <gnault@redhat.com>
    net/sched: act_gate: Unlock ->tcfa_lock in tc_setup_flow_action()

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    net: ethernet: mtk-star-emac: select REGMAP_MMIO

Neal Cardwell <ncardwell@google.com>
    tcp: fix to update snd_wl1 in bulk receiver fast path

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: rtnetlink: load fou module for kci_test_encap_fou() test

Ido Schimmel <idosch@nvidia.com>
    selftests: forwarding: Add missing 'rp_filter' configuration

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix operation under forced interrupt threading

Defang Bo <bodefang@126.com>
    nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME attribute in nfc_genl_fw_download()

Ido Schimmel <idosch@nvidia.com>
    nexthop: Fix performance regression in nexthop deletion

Ard Biesheuvel <ardb@kernel.org>
    netsec: ignore 'phy-mode' device property on ACPI systems

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_tunnel_key: fix OOB write in case of IPv6 ERSPAN tunnels

Roi Dayan <roid@nvidia.com>
    net/sched: act_ct: Fix adding udp port mangle operation

Ke Li <keli@akamai.com>
    net: Properly typecast int values to set sk_max_pacing_rate

Xie He <xie.he.0141@gmail.com>
    net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag after calling ether_setup

Xie He <xie.he.0141@gmail.com>
    net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device

Dylan Hung <dylan_hung@aspeedtech.com>
    net: ftgmac100: Fix Aspeed ast2600 TX hang issue

Geliang Tang <geliangtang@gmail.com>
    mptcp: initialize mptcp_options_received's ahmac

Eric Dumazet <edumazet@google.com>
    icmp: randomize the global rate limiter

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: save changed mac address to adapter->mac_addr

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix writing freed memory

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: correct function return and return type

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: Fix panic when listen on multiadapter

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix panic when server is on ipv6

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: correct netdevice for vlan interface

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix socket lock

Hoang Huu Le <hoang.h.le@dektech.com.au>
    tipc: fix incorrect setting window for bcast link

Hoang Huu Le <hoang.h.le@dektech.com.au>
    tipc: re-configure queue limit for broadcast link

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: fix jack detection with Realtek codecs when in D3

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: bebob: potential info leak in hwdep_read()

Todd Kjos <tkjos@google.com>
    binder: fix UAF when releasing todo list

Marc Kleine-Budde <mkl@pengutronix.de>
    net: j1939: j1939_session_fresh_new(): fix missing initialization of skbcnt

Cong Wang <xiyou.wangcong@gmail.com>
    can: j1935: j1939_tp_tx_dat_new(): fix missing initialization of skbcnt

Lucas Stach <l.stach@pengutronix.de>
    can: m_can_platform: don't call m_can_class_suspend in runtime suspend

Christian Eggers <ceggers@arri.de>
    socket: don't clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS is disabled

Christian Eggers <ceggers@arri.de>
    socket: fix option SO_TIMESTAMPING_NEW

Cong Wang <xiyou.wangcong@gmail.com>
    tipc: fix the skb_unshare() in tipc_buf_append()

Hoang Huu Le <hoang.h.le@dektech.com.au>
    tipc: fix NULL pointer dereference in tipc_named_rcv

Rohit Maheshwari <rohitm@chelsio.com>
    net/tls: sendfile fails with ktls offload

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: fix valid DMBE buffer sizes

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: fix use-after-free of delayed events

Leon Romanovsky <leon@kernel.org>
    net: sched: Fix suspicious RCU usage while accessing tcf_tunnel_info

Davide Caratti <dcaratti@redhat.com>
    net: mptcp: make DACK4/DACK8 usage consistent among all subflows

Alex Elder <elder@linaro.org>
    net: ipa: skip suspend/resume activities if not set up

Yonghong Song <yhs@fb.com>
    net: fix pos incrementment in ipv6_route_seq_next

Marek Vasut <marex@denx.de>
    net: fec: Fix PHY init after phy_reset_after_clk_enable()

Marek Vasut <marex@denx.de>
    net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()

Christian Eggers <ceggers@arri.de>
    net: dsa: microchip: fix race condition

Paolo Abeni <pabeni@redhat.com>
    mptcp: subflows garbage collection

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix fallback for MP_JOIN subflows

Jonathan Lemon <bsd@fb.com>
    mlx4: handle non-napi callers to napi_poll

David Ahern <dsahern@kernel.org>
    ipv4: Restore flowi4_oif update before call to xfrm_lookup_route

Herat Ramani <herat@chelsio.com>
    cxgb4: handle 4-tuple PEDIT to NAT mode translation

David Wilder <dwilder@us.ibm.com>
    ibmveth: Identify ingress large send packets.

David Wilder <dwilder@us.ibm.com>
    ibmveth: Switch order of ibmveth_helper calls.


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +-
 .../crypto/allwinner,sun4i-a10-crypto.yaml         |   7 +-
 .../devicetree/bindings/net/socionext-netsec.txt   |   4 +-
 Documentation/networking/ip-sysctl.rst             |   4 +-
 Makefile                                           |   4 +-
 arch/arc/plat-hsdk/Kconfig                         |   1 +
 arch/arm/boot/dts/imx6sl.dtsi                      |   2 +
 arch/arm/boot/dts/iwg20d-q7-common.dtsi            |  15 +-
 arch/arm/boot/dts/meson8.dtsi                      |   2 -
 arch/arm/boot/dts/owl-s500.dtsi                    |   6 +-
 arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts          |   2 -
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi      |  35 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi       |  38 +-
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi |   6 +-
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts  |  10 +-
 arch/arm/mach-at91/pm.c                            |   1 +
 arch/arm/mach-omap2/cpuidle44xx.c                  |   4 +-
 arch/arm/mach-s3c24xx/mach-at2440evb.c             |   2 +-
 arch/arm/mach-s3c24xx/mach-h1940.c                 |   4 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c              |   4 +-
 arch/arm/mach-s3c24xx/mach-n30.c                   |   4 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c                |   4 +-
 arch/arm/mm/cache-l2x0.c                           |  16 +-
 arch/arm64/boot/dts/actions/s700.dtsi              |   2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi       |   6 +-
 arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi |   4 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   1 +
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi       |   9 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |  10 +-
 arch/arm64/boot/dts/qcom/msm8992.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/pm8916.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |  12 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   9 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts            |   4 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  11 +-
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi          |   5 +-
 arch/arm64/boot/dts/renesas/r8a77990.dtsi          |   5 +-
 .../boot/dts/ti/k3-j721e-common-proc-board.dts     |  11 +-
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |  13 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +-
 arch/arm64/include/asm/insn.h                      |   4 +
 arch/arm64/include/asm/memory.h                    |   5 +-
 arch/arm64/include/asm/pgtable.h                   |   4 +-
 arch/arm64/kernel/cpu_errata.c                     |   7 +-
 arch/arm64/kernel/insn.c                           |   5 +-
 arch/arm64/kernel/perf_event.c                     |   5 +
 arch/arm64/kernel/probes/decode-insn.c             |   3 +-
 arch/arm64/mm/init.c                               |  30 +-
 arch/m68k/coldfire/device.c                        |   6 +-
 arch/microblaze/include/asm/Kbuild                 |   1 -
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/include/asm/asm-prototypes.h          |   4 +-
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |  13 +-
 arch/powerpc/include/asm/book3s/64/mmu.h           |   2 +-
 arch/powerpc/include/asm/cputable.h                |   2 +-
 arch/powerpc/include/asm/drmem.h                   |  39 +-
 arch/powerpc/include/asm/hw_breakpoint.h           |   1 +
 arch/powerpc/include/asm/reg.h                     |   2 +-
 arch/powerpc/include/asm/svm.h                     |   4 +
 arch/powerpc/include/asm/tlb.h                     |  13 -
 arch/powerpc/kernel/cputable.c                     |  13 +-
 arch/powerpc/kernel/entry_64.S                     |   8 +-
 arch/powerpc/kernel/hw_breakpoint.c                |  14 +-
 arch/powerpc/kernel/irq.c                          |   9 +-
 arch/powerpc/kernel/ptrace/ptrace-noadv.c          |   1 +
 arch/powerpc/kernel/security.c                     |  34 +-
 arch/powerpc/kernel/tau_6xx.c                      | 147 +++----
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   2 +-
 arch/powerpc/mm/book3s64/radix_tlb.c               |  23 +-
 arch/powerpc/mm/drmem.c                            |   6 +-
 arch/powerpc/mm/kasan/kasan_init_32.c              |  12 +-
 arch/powerpc/mm/mem.c                              |   6 +-
 arch/powerpc/perf/hv-gpci-requests.h               |   6 +-
 arch/powerpc/perf/isa207-common.c                  |  10 +
 arch/powerpc/platforms/Kconfig                     |  14 +-
 arch/powerpc/platforms/powernv/opal-dump.c         |  41 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  24 +-
 arch/powerpc/platforms/pseries/papr_scm.c          |   8 +-
 arch/powerpc/platforms/pseries/ras.c               | 118 +++---
 arch/powerpc/platforms/pseries/rng.c               |   1 +
 arch/powerpc/platforms/pseries/svm.c               |  26 ++
 arch/powerpc/sysdev/xics/icp-hv.c                  |   1 +
 arch/powerpc/xmon/xmon.c                           |   1 +
 arch/s390/net/bpf_jit_comp.c                       |  61 ++-
 arch/s390/pci/pci_bus.c                            |   5 +-
 arch/um/drivers/vector_kern.c                      |   4 +-
 arch/um/kernel/time.c                              |  14 +-
 arch/x86/boot/compressed/pgtable_64.c              |   9 -
 arch/x86/events/amd/iommu.c                        |   2 +-
 arch/x86/events/core.c                             |   6 +-
 arch/x86/events/intel/ds.c                         |  32 +-
 arch/x86/events/intel/uncore_snb.c                 |  31 +-
 arch/x86/events/intel/uncore_snbep.c               |  19 +-
 arch/x86/events/perf_event.h                       |   1 +
 arch/x86/include/asm/special_insns.h               |  28 +-
 arch/x86/kernel/cpu/common.c                       |   4 +-
 arch/x86/kernel/cpu/mce/core.c                     |  99 ++++-
 arch/x86/kernel/cpu/mce/internal.h                 |  10 +
 arch/x86/kernel/cpu/mce/severity.c                 |  28 +-
 arch/x86/kernel/dumpstack.c                        |   3 +-
 arch/x86/kernel/fpu/init.c                         |  30 +-
 arch/x86/kernel/nmi.c                              |   5 +-
 arch/x86/kvm/emulate.c                             |   2 +-
 arch/x86/kvm/ioapic.c                              |   5 +-
 arch/x86/kvm/kvm_cache_regs.h                      |   2 +-
 arch/x86/kvm/lapic.c                               |   7 +
 arch/x86/kvm/lapic.h                               |   1 +
 arch/x86/kvm/mmu/mmu.c                             |   1 +
 arch/x86/kvm/svm/avic.c                            |   1 +
 arch/x86/kvm/svm/nested.c                          |   2 +-
 arch/x86/kvm/svm/svm.h                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |  14 +-
 block/blk-core.c                                   |   9 +-
 block/blk-mq-sysfs.c                               |   2 -
 block/blk-mq-tag.c                                 |   3 +-
 block/blk-mq.c                                     |   6 +-
 block/blk-sysfs.c                                  |   9 +-
 crypto/algif_aead.c                                |   7 +-
 crypto/algif_skcipher.c                            |   2 +-
 drivers/android/binder.c                           |  37 +-
 drivers/base/regmap/regmap.c                       |   2 +
 drivers/bluetooth/btusb.c                          |   1 +
 drivers/bluetooth/hci_ldisc.c                      |   1 +
 drivers/bluetooth/hci_serdev.c                     |   2 +
 drivers/bus/mhi/core/Makefile                      |   2 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |   2 +-
 drivers/char/random.c                              |   1 -
 drivers/clk/at91/clk-main.c                        |  11 +-
 drivers/clk/at91/sam9x60.c                         |   2 +-
 drivers/clk/bcm/clk-bcm2835.c                      |   4 +-
 drivers/clk/imx/clk-imx8mq.c                       |   4 +-
 drivers/clk/keystone/sci-clk.c                     |   2 +-
 drivers/clk/mediatek/clk-mt6779.c                  |   2 +
 drivers/clk/meson/axg-audio.c                      | 135 +++++-
 drivers/clk/meson/g12a.c                           |  11 +
 drivers/clk/qcom/gcc-sdm660.c                      |   2 +-
 drivers/clk/qcom/gdsc.c                            |   8 +
 drivers/clk/rockchip/clk-half-divider.c            |   2 +-
 drivers/clocksource/hyperv_timer.c                 |   4 +-
 drivers/cpufreq/armada-37xx-cpufreq.c              |   6 +
 drivers/cpufreq/powernv-cpufreq.c                  |   9 +-
 drivers/cpufreq/qcom-cpufreq-hw.c                  |  21 +-
 drivers/crypto/Kconfig                             |   1 +
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |   5 +-
 drivers/crypto/caam/Kconfig                        |   3 +
 drivers/crypto/caam/caamalg.c                      |  90 +++-
 drivers/crypto/caam/caamalg_qi.c                   |  90 +++-
 drivers/crypto/caam/caamalg_qi2.c                  | 106 ++++-
 drivers/crypto/caam/caamalg_qi2.h                  |   2 +
 drivers/crypto/ccp/ccp-ops.c                       |   2 +-
 drivers/crypto/ccree/cc_pm.c                       |   6 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |  19 +-
 drivers/crypto/chelsio/chtls/chtls_io.c            |   5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  16 +-
 drivers/crypto/ixp4xx_crypto.c                     |   2 +-
 drivers/crypto/mediatek/mtk-platform.c             |   8 +-
 drivers/crypto/omap-sham.c                         |   3 +
 drivers/crypto/picoxcell_crypto.c                  |   9 +-
 drivers/crypto/sa2ul.c                             |   8 +-
 drivers/crypto/stm32/Kconfig                       |   1 +
 drivers/crypto/stm32/stm32-crc32.c                 |  15 +-
 drivers/dma/dmatest.c                              |   5 +-
 drivers/dma/dw/core.c                              |   4 +
 drivers/dma/dw/dw.c                                |   2 +-
 drivers/dma/dw/of.c                                |   7 +-
 drivers/dma/ioat/dma.c                             |   2 +-
 drivers/dma/ti/k3-udma-glue.c                      |  19 +-
 drivers/edac/aspeed_edac.c                         |   4 +-
 drivers/edac/i5100_edac.c                          |  11 +-
 drivers/edac/ti_edac.c                             |   3 +-
 drivers/firmware/arm_scmi/mailbox.c                |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  12 +-
 .../gpu/drm/amd/display/dc/dce/dce_panel_cntl.c    |   2 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  | 146 +++++++
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h  |   6 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c  |   2 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c  |   2 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   3 +
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c  |   2 +
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   3 +
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_init.c  |   2 +
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h  |   4 +
 drivers/gpu/drm/arm/malidp_planes.c                |   2 +-
 drivers/gpu/drm/drm_debugfs_crc.c                  |   4 +-
 drivers/gpu/drm/drm_gem_vram_helper.c              |  28 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |   2 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c     |  55 +--
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h    |   2 +
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  11 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |   2 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |  10 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   8 +-
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                  |  21 +-
 drivers/gpu/drm/panel/panel-simple.c               |   4 +-
 drivers/gpu/drm/panfrost/panfrost_device.h         |   3 +
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  11 +
 drivers/gpu/drm/panfrost/panfrost_gpu.c            |  22 +-
 drivers/gpu/drm/panfrost/panfrost_gpu.h            |   2 +
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c        |  10 +-
 drivers/gpu/drm/panfrost/panfrost_regs.h           |   4 +
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c              |  12 +
 drivers/gpu/drm/vc4/vc4_crtc.c                     |  13 +-
 drivers/gpu/drm/vgem/vgem_drv.c                    |   2 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c               |   2 +
 drivers/gpu/drm/virtio/virtgpu_vq.c                |  10 +-
 drivers/gpu/drm/vkms/vkms_composer.c               |   2 +-
 drivers/gpu/drm/vkms/vkms_drv.c                    |   2 +-
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c                |  27 +-
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-input.c                            |   4 +-
 drivers/hid/hid-ite.c                              |   4 +
 drivers/hid/hid-multitouch.c                       |   6 +
 drivers/hid/hid-roccat-kone.c                      |  23 +-
 drivers/hwmon/bt1-pvt.c                            | 138 ++++--
 drivers/hwmon/bt1-pvt.h                            |   3 +
 drivers/hwmon/pmbus/max34440.c                     |   3 -
 drivers/hwmon/w83627ehf.c                          |   6 +-
 drivers/hwtracing/coresight/coresight-cti.c        |  41 +-
 drivers/hwtracing/coresight/coresight-etm-perf.c   |  14 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   2 +-
 drivers/hwtracing/coresight/coresight-etm4x.c      | 105 ++---
 drivers/hwtracing/coresight/coresight-etm4x.h      |   3 +
 drivers/hwtracing/coresight/coresight-platform.c   |  10 +-
 drivers/hwtracing/coresight/coresight.c            |   2 +-
 drivers/i2c/busses/Kconfig                         |   1 +
 drivers/i2c/i2c-core-acpi.c                        |  11 +-
 drivers/i3c/master.c                               |  19 +-
 drivers/i3c/master/i3c-master-cdns.c               |   4 +-
 drivers/iio/adc/stm32-adc-core.c                   |   9 +-
 drivers/infiniband/core/cma.c                      | 300 ++++++-------
 drivers/infiniband/core/cq.c                       |  30 +-
 drivers/infiniband/core/ucma.c                     |   6 +-
 drivers/infiniband/core/umem.c                     |  15 +-
 drivers/infiniband/core/uverbs_std_types_wq.c      |   2 +-
 drivers/infiniband/core/verbs.c                    |  32 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   3 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |   2 +-
 drivers/infiniband/hw/cxgb4/cq.c                   |   3 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |   2 +-
 drivers/infiniband/hw/efa/efa.h                    |   2 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |   3 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   3 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  41 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   2 +
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   6 +-
 drivers/infiniband/hw/i40iw/i40iw.h                |   9 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |  10 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c          |  59 +--
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |  34 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.h          |   3 +-
 drivers/infiniband/hw/mlx4/cm.c                    |   3 +
 drivers/infiniband/hw/mlx4/cq.c                    |   3 +-
 drivers/infiniband/hw/mlx4/mad.c                   |  34 +-
 drivers/infiniband/hw/mlx4/main.c                  |   3 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   6 +-
 drivers/infiniband/hw/mlx4/qp.c                    |   3 +-
 drivers/infiniband/hw/mlx5/counters.c              |   4 +-
 drivers/infiniband/hw/mlx5/cq.c                    |  14 +-
 drivers/infiniband/hw/mlx5/main.c                  |   4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   6 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  64 ++-
 drivers/infiniband/hw/mlx5/qp.c                    |  12 +-
 drivers/infiniband/hw/mlx5/qp.h                    |   4 +-
 drivers/infiniband/hw/mlx5/qpc.c                   |   5 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |   2 +-
 drivers/infiniband/hw/qedr/main.c                  |   2 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |   6 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  63 +--
 drivers/infiniband/hw/qedr/verbs.h                 |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   4 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c       |   3 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h    |   2 +-
 drivers/infiniband/sw/rdmavt/cq.c                  |   3 +-
 drivers/infiniband/sw/rdmavt/cq.h                  |   2 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |   4 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |  20 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   3 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |   3 +-
 drivers/infiniband/sw/siw/siw_verbs.h              |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   2 +
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |  11 +
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |   2 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |  76 +++-
 drivers/infiniband/ulp/rtrs/rtrs-srv.h             |   7 +
 drivers/input/keyboard/ep93xx_keypad.c             |   4 +-
 drivers/input/keyboard/omap4-keypad.c              |   6 +-
 drivers/input/keyboard/twl4030_keypad.c            |   8 +-
 drivers/input/serio/sun4i-ps2.c                    |   9 +-
 drivers/input/touchscreen/elants_i2c.c             |   2 +-
 drivers/input/touchscreen/imx6ul_tsc.c             |  27 +-
 drivers/input/touchscreen/stmfts.c                 |   2 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |   8 +-
 drivers/irqchip/irq-ti-sci-inta.c                  |   4 +-
 drivers/irqchip/irq-ti-sci-intr.c                  |   4 +-
 drivers/lightnvm/core.c                            |   5 +-
 drivers/mailbox/mailbox.c                          |  12 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   8 +-
 drivers/md/dm.c                                    |  59 +--
 drivers/md/md-bitmap.c                             |   3 +-
 drivers/md/md-cluster.c                            |   1 +
 drivers/media/firewire/firedtv-fw.c                |   6 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   3 +-
 drivers/media/i2c/max9286.c                        |  43 +-
 drivers/media/i2c/ov5640.c                         | 196 +++++----
 drivers/media/i2c/tc358743.c                       |  14 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |  13 +-
 drivers/media/pci/saa7134/saa7134-tvaudio.c        |   3 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   8 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   4 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c      |   2 +-
 drivers/media/platform/mx2_emmaprp.c               |   7 +-
 drivers/media/platform/omap3isp/isp.c              |   6 +-
 drivers/media/platform/qcom/camss/camss-csiphy.c   |   4 +-
 drivers/media/platform/qcom/venus/core.c           |  20 +-
 drivers/media/platform/qcom/venus/vdec.c           |  10 +-
 drivers/media/platform/rcar-fcp.c                  |   4 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c        |  24 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |   4 +-
 drivers/media/platform/rcar_drif.c                 |  30 +-
 drivers/media/platform/rockchip/rga/rga-buf.c      |   1 +
 drivers/media/platform/s3c-camif/camif-core.c      |   5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |   4 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   3 +-
 drivers/media/platform/sti/delta/delta-v4l2.c      |   4 +-
 drivers/media/platform/sti/hva/hva-hw.c            |   4 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |   4 +-
 drivers/media/platform/ti-vpe/vpe.c                |   2 +
 drivers/media/platform/vsp1/vsp1_drv.c             |  11 +-
 drivers/media/rc/ati_remote.c                      |   4 +
 drivers/media/test-drivers/vivid/vivid-meta-out.c  |   9 +-
 drivers/media/tuners/tuner-simple.c                |   5 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   6 +-
 drivers/media/usb/uvc/uvc_entity.c                 |  35 ++
 drivers/media/usb/uvc/uvc_v4l2.c                   |  30 ++
 drivers/memory/brcmstb_dpfe.c                      |  23 +-
 drivers/memory/fsl-corenet-cf.c                    |   6 +-
 drivers/memory/omap-gpmc.c                         |   8 +-
 drivers/mfd/sm501.c                                |   8 +-
 drivers/mfd/syscon.c                               |   2 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |   4 +-
 drivers/misc/eeprom/at25.c                         |   2 +-
 drivers/misc/habanalabs/gaudi/gaudi.c              |   8 +-
 drivers/misc/habanalabs/goya/goya.c                |   8 +-
 drivers/misc/mic/scif/scif_rma.c                   |   4 +-
 drivers/misc/mic/vop/vop_main.c                    |   2 +-
 drivers/misc/mic/vop/vop_vringh.c                  |  24 +-
 drivers/misc/ocxl/Kconfig                          |   3 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |  10 +-
 drivers/mmc/core/sdio_cis.c                        |   3 +
 drivers/mtd/hyperbus/hbmc-am654.c                  |   4 +-
 drivers/mtd/lpddr/lpddr2_nvm.c                     |  35 +-
 drivers/mtd/mtdoops.c                              |  11 +-
 drivers/mtd/nand/raw/ams-delta.c                   |   2 +
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |   2 +-
 drivers/mtd/nand/raw/vf610_nfc.c                   |   6 +-
 drivers/mtd/nand/spi/gigadevice.c                  |  14 +-
 drivers/mtd/parsers/Kconfig                        |   2 +-
 drivers/net/can/flexcan.c                          |  34 +-
 drivers/net/can/m_can/m_can_platform.c             |   2 -
 drivers/net/dsa/microchip/ksz_common.c             |  16 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |   2 +-
 drivers/net/dsa/realtek-smi-core.h                 |   4 +-
 drivers/net/dsa/rtl8366.c                          | 280 +++++++------
 drivers/net/dsa/rtl8366rb.c                        |   2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 175 +++++++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h   |  15 +
 drivers/net/ethernet/cisco/enic/enic.h             |   1 +
 drivers/net/ethernet/cisco/enic/enic_api.c         |   6 +
 drivers/net/ethernet/cisco/enic/enic_main.c        |  27 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |   5 +
 drivers/net/ethernet/faraday/ftgmac100.h           |   8 +
 drivers/net/ethernet/freescale/fec_main.c          |  35 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  19 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  10 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |  23 +-
 drivers/net/ethernet/korina.c                      |   3 +-
 drivers/net/ethernet/mediatek/Kconfig              |   1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   3 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   4 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   5 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   8 +-
 drivers/net/ethernet/sfc/ef100_nic.c               |  12 -
 drivers/net/ethernet/sfc/efx_common.c              |   1 +
 drivers/net/ethernet/sfc/rx_common.c               |   1 -
 drivers/net/ethernet/socionext/netsec.c            |  24 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  41 +-
 drivers/net/ipa/ipa_endpoint.c                     |   6 +
 drivers/net/wan/hdlc.c                             |  10 +-
 drivers/net/wan/hdlc_raw_eth.c                     |   1 +
 drivers/net/wireless/ath/ath10k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   8 +
 drivers/net/wireless/ath/ath10k/mac.c              |   2 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |  10 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   4 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   1 +
 drivers/net/wireless/ath/ath11k/spectral.c         |   2 +
 drivers/net/wireless/ath/ath6kl/main.c             |   3 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |   5 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  19 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   2 +
 drivers/net/wireless/ath/wcn36xx/main.c            |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   2 +
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   9 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +
 drivers/net/wireless/marvell/mwifiex/usb.c         |   3 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 176 ++++----
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |   2 +
 .../net/wireless/mediatek/mt76/mt7615/testmode.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |   4 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  18 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |   8 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |   3 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   5 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |   5 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  10 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   5 +
 drivers/net/wireless/realtek/rtw88/pci.c           |   2 +
 drivers/net/wireless/realtek/rtw88/pci.h           |   4 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |   5 +-
 drivers/ntb/hw/amd/ntb_hw_amd.c                    |   1 +
 drivers/ntb/hw/intel/ntb_hw_gen1.c                 |   2 +-
 drivers/nvme/host/zns.c                            |  41 +-
 drivers/nvme/target/core.c                         |   3 +-
 drivers/nvme/target/passthru.c                     |   9 +-
 drivers/nvmem/core.c                               |  38 +-
 drivers/opp/core.c                                 |   6 +
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   3 +-
 drivers/pci/controller/pci-aardvark.c              |  13 +-
 drivers/pci/controller/pci-hyperv.c                |  50 ++-
 drivers/pci/controller/pcie-iproc-msi.c            |  13 +-
 drivers/pci/iov.c                                  |   1 +
 drivers/perf/thunderx2_pmu.c                       |   7 +-
 drivers/perf/xgene_pmu.c                           |  32 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |   2 +-
 drivers/pinctrl/bcm/Kconfig                        |   1 +
 drivers/pinctrl/devicetree.c                       |   5 +-
 drivers/pinctrl/intel/pinctrl-tigerlake.c          |  42 +-
 drivers/pinctrl/pinctrl-mcp23s08.c                 |  24 +-
 drivers/pinctrl/pinctrl-single.c                   |   4 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  10 +-
 drivers/platform/chrome/cros_ec_lightbar.c         |   2 +
 drivers/platform/chrome/cros_ec_typec.c            |   3 +-
 drivers/platform/x86/mlx-platform.c                |  15 +-
 drivers/pwm/pwm-img.c                              |   3 +-
 drivers/pwm/pwm-lpss.c                             |   7 +-
 drivers/pwm/pwm-rockchip.c                         |   5 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  18 +-
 drivers/ras/cec.c                                  |   9 +-
 drivers/regulator/core.c                           |  21 +-
 drivers/regulator/qcom_usb_vbus-regulator.c        |   1 +
 drivers/remoteproc/mtk_scp_ipi.c                   |   4 +-
 drivers/remoteproc/stm32_rproc.c                   |   2 +-
 drivers/rpmsg/mtk_rpmsg.c                          |   9 +-
 drivers/rpmsg/qcom_smd.c                           |  32 +-
 drivers/rtc/rtc-ds1307.c                           |   4 +
 drivers/s390/net/qeth_core.h                       |   6 +
 drivers/s390/net/qeth_l2_main.c                    |  59 ++-
 drivers/s390/net/qeth_l2_sys.c                     |   1 +
 drivers/scsi/be2iscsi/be_main.c                    |   4 +-
 drivers/scsi/bfa/bfad.c                            |   1 +
 drivers/scsi/csiostor/csio_hw.c                    |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  14 +-
 drivers/scsi/mvumi.c                               |   1 +
 drivers/scsi/qedf/qedf_main.c                      |   2 +-
 drivers/scsi/qedi/qedi_fw.c                        |  23 +-
 drivers/scsi/qedi/qedi_iscsi.c                     |   2 +
 drivers/scsi/qedi/qedi_main.c                      |  10 +
 drivers/scsi/qla2xxx/qla_init.c                    |  10 +
 drivers/scsi/qla2xxx/qla_inline.h                  |   5 +
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   2 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +-
 drivers/scsi/smartpqi/smartpqi.h                   |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c              | 101 +++--
 drivers/scsi/ufs/ufs-mediatek.c                    |  11 +-
 drivers/scsi/ufs/ufs-qcom.c                        |   5 -
 drivers/scsi/ufs/ufshcd.c                          |   3 +
 drivers/slimbus/core.c                             |   6 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |   4 +
 drivers/soc/fsl/qbman/bman.c                       |   2 +-
 drivers/soc/mediatek/mtk-cmdq-helper.c             |   5 +-
 drivers/soc/qcom/apr.c                             |   2 +-
 drivers/soc/qcom/pdr_internal.h                    |   2 +-
 drivers/soc/xilinx/zynqmp_power.c                  |   2 +-
 drivers/soundwire/cadence_master.c                 |  24 +-
 drivers/soundwire/cadence_master.h                 |   5 +
 drivers/soundwire/intel.c                          |  73 +++-
 drivers/soundwire/stream.c                         |   2 +-
 drivers/spi/spi-dw-pci.c                           |  16 +-
 drivers/spi/spi-fsi.c                              |  99 ++++-
 drivers/spi/spi-imx.c                              |   5 +-
 drivers/spi/spi-omap2-mcspi.c                      |  17 +-
 drivers/spi/spi-s3c64xx.c                          |  52 ++-
 drivers/staging/emxx_udc/emxx_udc.c                |   4 +-
 drivers/staging/media/atomisp/pci/sh_css.c         |   2 +-
 drivers/staging/media/hantro/hantro_h264.c         |   2 +-
 drivers/staging/media/hantro/hantro_postproc.c     |   4 +-
 drivers/staging/media/ipu3/ipu3-css-params.c       |   2 +-
 .../phy-rockchip-dphy-rx0/phy-rockchip-dphy-rx0.c  |   1 +
 drivers/staging/qlge/qlge.h                        |  20 +-
 drivers/staging/qlge/qlge_dbg.c                    |  28 +-
 drivers/staging/qlge/qlge_main.c                   |   8 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   2 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |   9 +-
 drivers/staging/wfx/data_rx.c                      |   5 +-
 drivers/staging/wfx/sta.c                          |  19 +-
 drivers/target/target_core_user.c                  |   2 +-
 drivers/thermal/thermal_netlink.c                  |   3 +-
 drivers/tty/hvc/Kconfig                            |   1 +
 drivers/tty/hvc/hvcs.c                             |  14 +-
 drivers/tty/ipwireless/network.c                   |   4 +-
 drivers/tty/ipwireless/tty.c                       |   2 +-
 drivers/tty/pty.c                                  |   2 +-
 drivers/tty/serial/8250/8250_dw.c                  |  54 +--
 drivers/tty/serial/8250/8250_port.c                |   5 +-
 drivers/tty/serial/Kconfig                         |   2 +
 drivers/tty/serial/fsl_lpuart.c                    |  16 +-
 drivers/usb/cdns3/gadget.c                         |   2 +-
 drivers/usb/class/cdc-acm.c                        |  23 +
 drivers/usb/class/cdc-wdm.c                        |  72 +++-
 drivers/usb/core/urb.c                             |  89 ++--
 drivers/usb/dwc2/gadget.c                          |  40 +-
 drivers/usb/dwc2/params.c                          |   2 +-
 drivers/usb/dwc2/platform.c                        |   6 +-
 drivers/usb/dwc3/core.c                            |  60 ++-
 drivers/usb/dwc3/core.h                            |   7 +
 drivers/usb/dwc3/dwc3-of-simple.c                  |   1 +
 drivers/usb/gadget/function/f_ncm.c                |   8 +-
 drivers/usb/gadget/function/f_printer.c            |  16 +-
 drivers/usb/gadget/function/u_ether.c              |   2 +-
 drivers/usb/gadget/function/u_serial.c             |   1 +
 drivers/usb/gadget/udc/bcm63xx_udc.c               |   1 +
 drivers/usb/host/ohci-hcd.c                        |  16 +-
 drivers/usb/host/xhci.c                            |   3 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  12 +-
 drivers/vfio/pci/vfio_pci_config.c                 |  24 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |   4 +-
 drivers/vfio/vfio.c                                |   9 +-
 drivers/vfio/vfio_iommu_type1.c                    |   6 +-
 drivers/video/backlight/sky81452-backlight.c       |   1 +
 drivers/video/fbdev/aty/radeon_base.c              |   2 +-
 drivers/video/fbdev/core/fbmem.c                   |   4 +
 drivers/video/fbdev/sis/init.c                     |  11 +-
 drivers/video/fbdev/vga16fb.c                      |  14 +-
 drivers/virt/fsl_hypervisor.c                      |  17 +-
 drivers/watchdog/sp5100_tco.h                      |   2 +-
 drivers/watchdog/watchdog_dev.c                    |   6 +-
 fs/afs/cell.c                                      | 283 +++++++------
 fs/afs/dynroot.c                                   |  23 +-
 fs/afs/internal.h                                  |  15 +-
 fs/afs/main.c                                      |   2 +-
 fs/afs/mntpt.c                                     |   4 +-
 fs/afs/proc.c                                      |  23 +-
 fs/afs/super.c                                     |  16 +-
 fs/afs/vl_alias.c                                  |   8 +-
 fs/afs/vl_rotate.c                                 |   2 +-
 fs/afs/volume.c                                    |   4 +-
 fs/btrfs/extent-io-tree.h                          |   1 +
 fs/btrfs/volumes.c                                 |   7 +-
 fs/cifs/asn1.c                                     |  16 +-
 fs/cifs/cifsacl.c                                  |   5 +-
 fs/cifs/cifsproto.h                                |   2 +
 fs/cifs/connect.c                                  |   5 +-
 fs/cifs/readdir.c                                  |   5 +-
 fs/cifs/smb2ops.c                                  |  21 +-
 fs/crypto/policy.c                                 |   9 +-
 fs/d_path.c                                        |   6 +-
 fs/dlm/config.c                                    |   3 +
 fs/ext4/ext4.h                                     |   2 +-
 fs/ext4/fsmap.c                                    |   3 +
 fs/ext4/mballoc.c                                  |  37 +-
 fs/f2fs/inode.c                                    |   7 +
 fs/f2fs/sysfs.c                                    |   1 +
 fs/iomap/buffered-io.c                             |  25 +-
 fs/iomap/direct-io.c                               |  10 +
 fs/nfs/fs_context.c                                |   1 +
 fs/nfs/nfs4file.c                                  |  38 +-
 fs/nfs/nfs4super.c                                 |   5 +
 fs/nfs/super.c                                     |  17 +
 fs/nfs_common/Makefile                             |   1 +
 fs/nfs_common/nfs_ssc.c                            |  94 +++++
 fs/nfsd/Kconfig                                    |   2 +-
 fs/nfsd/filecache.c                                |   2 +-
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/ntfs/inode.c                                    |   6 +
 fs/proc/base.c                                     |   3 +-
 fs/quota/quota_v2.c                                |   1 +
 fs/ramfs/file-nommu.c                              |   2 +-
 fs/reiserfs/inode.c                                |   3 +-
 fs/reiserfs/super.c                                |   8 +-
 fs/udf/inode.c                                     |  25 +-
 fs/udf/super.c                                     |   6 +
 fs/xfs/libxfs/xfs_rtbitmap.c                       |  11 +-
 fs/xfs/xfs_buf_item_recover.c                      |   2 +
 fs/xfs/xfs_file.c                                  |  17 +-
 fs/xfs/xfs_fsmap.c                                 |  48 ++-
 fs/xfs/xfs_fsmap.h                                 |   6 +-
 fs/xfs/xfs_ioctl.c                                 | 144 +++++--
 fs/xfs/xfs_rtalloc.c                               |  11 +
 include/dt-bindings/mux/mux-j721e-wiz.h            |  53 ---
 include/dt-bindings/mux/ti-serdes.h                |  71 ++++
 include/linux/bpf_verifier.h                       |   1 +
 include/linux/dma-direct.h                         |   3 -
 include/linux/lockdep.h                            |  29 +-
 include/linux/lockdep_types.h                      |   8 +-
 include/linux/mailbox/mtk-cmdq-mailbox.h           |   3 +-
 include/linux/nfs_ssc.h                            |  67 +++
 include/linux/notifier.h                           |  15 +-
 include/linux/oom.h                                |   1 +
 include/linux/overflow.h                           |   1 +
 include/linux/page_owner.h                         |   6 +-
 include/linux/pci.h                                |   1 +
 include/linux/platform_data/dma-dw.h               |   2 +
 include/linux/prandom.h                            |  36 +-
 include/linux/sched/coredump.h                     |   1 +
 include/linux/seqlock.h                            |  23 +-
 include/linux/soc/mediatek/mtk-cmdq.h              |   5 +-
 include/net/netfilter/nf_log.h                     |   1 +
 include/net/tc_act/tc_tunnel_key.h                 |   5 +-
 include/rdma/ib_umem.h                             |   9 +-
 include/rdma/ib_verbs.h                            |  74 +---
 include/scsi/scsi_common.h                         |   7 +
 include/sound/hda_codec.h                          |   1 +
 include/trace/events/target.h                      |  12 +-
 include/uapi/linux/pci_regs.h                      |   1 +
 include/uapi/linux/perf_event.h                    |   2 +-
 kernel/bpf/percpu_freelist.c                       | 101 ++++-
 kernel/bpf/percpu_freelist.h                       |   1 +
 kernel/bpf/verifier.c                              |  45 +-
 kernel/cpu_pm.c                                    |  48 +--
 kernel/debug/kdb/kdb_io.c                          |   8 +-
 kernel/dma/mapping.c                               |  11 +
 kernel/events/core.c                               |   7 +-
 kernel/fork.c                                      |  21 +
 kernel/locking/lockdep.c                           | 131 +++---
 kernel/locking/lockdep_internals.h                 |   7 +-
 kernel/module.c                                    |  13 +-
 kernel/notifier.c                                  | 144 ++++---
 kernel/power/hibernate.c                           |  50 +--
 kernel/power/main.c                                |   8 +-
 kernel/power/power.h                               |   3 +-
 kernel/power/suspend.c                             |  14 +-
 kernel/power/user.c                                |  14 +-
 kernel/rcu/rcutorture.c                            |  13 +-
 kernel/rcu/refscale.c                              |   8 +-
 kernel/rcu/tree.c                                  |   2 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/fair.c                                |  20 +-
 kernel/sched/sched.h                               |  13 +-
 kernel/time/timer.c                                |   7 -
 kernel/trace/trace_events_synth.c                  |  18 +-
 lib/Kconfig.debug                                  |   9 +
 lib/Makefile                                       |   1 +
 lib/crc32.c                                        |   2 +-
 lib/idr.c                                          |   1 +
 lib/random32.c                                     | 464 +++++++++++++--------
 lib/test_free_pages.c                              |  42 ++
 mm/filemap.c                                       |   8 +-
 mm/huge_memory.c                                   |  28 +-
 mm/memcontrol.c                                    |  16 +-
 mm/mmap.c                                          |   2 +-
 mm/oom_kill.c                                      |   2 +
 mm/page_alloc.c                                    |   7 +-
 mm/page_owner.c                                    |   4 +-
 mm/swapfile.c                                      |   4 +-
 net/bluetooth/hci_core.c                           |  11 +
 net/bluetooth/hci_event.c                          |  17 +-
 net/bluetooth/l2cap_sock.c                         |   7 +-
 net/bluetooth/mgmt.c                               |  12 +-
 net/bridge/netfilter/ebt_dnat.c                    |   2 +-
 net/bridge/netfilter/ebt_redirect.c                |   2 +-
 net/bridge/netfilter/ebt_snat.c                    |   2 +-
 net/can/j1939/transport.c                          |   2 +
 net/core/filter.c                                  |   3 +-
 net/core/skmsg.c                                   |  14 +-
 net/core/sock.c                                    |  13 +-
 net/ipv4/icmp.c                                    |   7 +-
 net/ipv4/ip_gre.c                                  |  15 +-
 net/ipv4/netfilter/nf_log_arp.c                    |  19 +-
 net/ipv4/netfilter/nf_log_ipv4.c                   |   6 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/tcp_input.c                               |   2 +
 net/ipv6/ip6_fib.c                                 |   4 +-
 net/ipv6/netfilter/nf_log_ipv6.c                   |   8 +-
 net/mac80211/cfg.c                                 |   3 +-
 net/mac80211/sta_info.c                            |   4 +
 net/mptcp/Kconfig                                  |   4 +-
 net/mptcp/options.c                                |  35 +-
 net/mptcp/protocol.c                               |  17 +
 net/mptcp/protocol.h                               |   4 +-
 net/mptcp/subflow.c                                |  19 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   7 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   6 +
 net/netfilter/nf_conntrack_proto_tcp.c             |  19 +-
 net/netfilter/nf_dup_netdev.c                      |   1 +
 net/netfilter/nf_log_common.c                      |  12 +
 net/netfilter/nft_fwd_netdev.c                     |   1 +
 net/nfc/netlink.c                                  |   2 +-
 net/openvswitch/flow_table.c                       |  58 ++-
 net/openvswitch/flow_table.h                       |   8 +-
 net/sched/act_ct.c                                 |   4 +-
 net/sched/act_tunnel_key.c                         |   2 +-
 net/sched/cls_api.c                                |   2 +-
 net/smc/smc_core.c                                 |   2 +-
 net/smc/smc_llc.c                                  |  13 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  27 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |   3 +-
 net/tipc/bcast.c                                   |  10 +-
 net/tipc/msg.c                                     |   3 +-
 net/tipc/name_distr.c                              |  10 +-
 net/tipc/node.c                                    |   2 +-
 net/tls/tls_device.c                               |  11 +-
 net/wireless/nl80211.c                             |  21 +-
 samples/bpf/xdpsock_user.c                         |  10 +-
 samples/mic/mpssd/mpssd.c                          |   4 +-
 scripts/package/builddeb                           |   6 +-
 scripts/package/mkdebian                           |  19 +-
 security/integrity/ima/ima_crypto.c                |   2 +
 security/integrity/ima/ima_main.c                  |  10 +
 security/integrity/ima/ima_policy.c                | 142 +++++--
 sound/core/seq/oss/seq_oss.c                       |   7 +-
 sound/firewire/bebob/bebob_hwdep.c                 |   3 +-
 sound/pci/hda/hda_intel.c                          |  14 +-
 sound/pci/hda/hda_jack.c                           |  22 +-
 sound/pci/hda/patch_ca0132.c                       |  24 +-
 sound/pci/hda/patch_hdmi.c                         |  20 +-
 sound/pci/hda/patch_realtek.c                      |  56 +++
 sound/soc/codecs/Kconfig                           |   1 +
 sound/soc/codecs/tas2770.c                         |  93 ++---
 sound/soc/codecs/tlv320adcx140.c                   |   2 +-
 sound/soc/codecs/tlv320aic32x4.c                   |   9 +-
 sound/soc/codecs/wm_adsp.c                         |  20 +-
 sound/soc/fsl/fsl_sai.c                            |  19 +-
 sound/soc/fsl/fsl_sai.h                            |   1 +
 sound/soc/fsl/imx-es8328.c                         |  12 +-
 sound/soc/intel/boards/sof_rt5682.c                |  13 +
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |   2 +-
 sound/soc/qcom/lpass-cpu.c                         |  16 -
 sound/soc/qcom/lpass-platform.c                    |   3 +-
 sound/soc/soc-topology.c                           |  11 +
 sound/soc/sof/control.c                            |  11 +
 sound/soc/sof/intel/hda.c                          |   8 +-
 sound/soc/sof/sof-pci-dev.c                        |  24 ++
 sound/usb/format.c                                 |   1 +
 tools/build/Makefile.feature                       |   5 +-
 tools/build/feature/Makefile                       |   2 +-
 tools/build/feature/test-all.c                     |  10 -
 tools/lib/bpf/libbpf.c                             |  57 ++-
 tools/lib/perf/evlist.c                            |   3 +
 tools/perf/Makefile.config                         |   4 +-
 tools/perf/Makefile.perf                           |   6 +-
 tools/perf/builtin-stat.c                          |   4 +-
 tools/perf/builtin-trace.c                         |   6 +-
 tools/perf/builtin-version.c                       |   1 -
 tools/perf/util/intel-pt.c                         |   8 +-
 tools/perf/util/metricgroup.c                      |  75 +++-
 tools/power/pm-graph/sleepgraph.py                 |   2 +-
 tools/testing/radix-tree/idr-test.c                |  29 ++
 tools/testing/selftests/bpf/bench.c                |   3 -
 tools/testing/selftests/bpf/benchs/bench_rename.c  |  17 -
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  14 +-
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |   2 +-
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |   4 +-
 .../selftests/bpf/prog_tests/test_overhead.c       |  14 +-
 tools/testing/selftests/bpf/progs/test_overhead.c  |   6 -
 tools/testing/selftests/bpf/progs/test_sk_lookup.c | 216 +++++-----
 .../selftests/bpf/progs/test_sysctl_loop1.c        |   4 +-
 .../selftests/bpf/progs/test_sysctl_loop2.c        |   4 +-
 tools/testing/selftests/bpf/progs/test_vmlinux.c   |  12 +-
 .../trigger-inter-event-combined-hist.tc           |   8 +-
 tools/testing/selftests/livepatch/functions.sh     |   2 +-
 tools/testing/selftests/lkdtm/run.sh               |   2 +-
 tools/testing/selftests/net/config                 |   1 +
 .../selftests/net/forwarding/vxlan_asymmetric.sh   |  10 +
 .../selftests/net/forwarding/vxlan_symmetric.sh    |  10 +
 tools/testing/selftests/net/mptcp/config           |   1 +
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   4 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   4 +-
 tools/testing/selftests/net/rtnetlink.sh           |   5 +
 .../powerpc/alignment/alignment_handler.c          |  10 +-
 tools/testing/selftests/powerpc/eeh/eeh-basic.sh   |   9 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      | 114 ++---
 tools/testing/selftests/vm/config                  |   1 +
 815 files changed, 7972 insertions(+), 4280 deletions(-)


