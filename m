Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768FC206C30
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 08:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388946AbgFXGKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 02:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387817AbgFXGKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 02:10:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3E002078A;
        Wed, 24 Jun 2020 06:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592979007;
        bh=8q2lzDnRdz6baiDYLoJaVXjTDil8QZsm8D53tL4Bvog=;
        h=From:To:Cc:Subject:Date:From;
        b=tN9g3QD6pIUSj2EqcTkVX3iGhNkJ1K07t/O/5c5GUZ2gEueP+C4wnO8L0tMazgnDu
         6dj2uG+U4MZE0SYCti7tGvrSeMUSoKfXcSIyMiXk4jCoCbtRWJg9UOb8lW8jWjG/Rh
         Lz2yaxsqFBTfpkdjZXZZMwuyFK42mNE5yN+p5lwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/203] 4.19.130-rc2 review
Date:   Wed, 24 Jun 2020 08:10:06 +0200
Message-Id: <20200624055901.258687997@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.130-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.130-rc2
X-KernelTest-Deadline: 2020-06-26T05:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.130 release.
There are 203 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 26 Jun 2020 05:58:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.130-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.130-rc2

Vladimir Oltean <vladimir.oltean@nxp.com>
    Revert "dpaa_eth: fix usage as DSA master, try 3"

Ahmed S. Darwish <a.darwish@linutronix.de>
    net: core: device_rename: Use rwsem instead of a seqcount

Thomas Gleixner <tglx@linutronix.de>
    sched/rt, net: Use CONFIG_PREEMPTION.patch

Jiri Olsa <jolsa@redhat.com>
    kretprobe: Prevent triggering kretprobe from within kprobe_flush_task

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    net: octeon: mgmt: Repair filling of RX ring

Chen Yu <yu.c.chen@intel.com>
    e1000e: Do not wake up the system via WOL if device wakeup is disabled

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix to protect kick_kprobe_optimizer() by kprobe_mutex

Eric Biggers <ebiggers@google.com>
    crypto: algboss - don't wait during notifier callback

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_skcipher - Cap recv SG list at ctx->used

Imre Deak <imre.deak@intel.com>
    drm/i915/icl+: Fix hotplug interrupt disabling after storm detection

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Whitelist context-local timestamp in the gen9 cmdparser

Dmitry V. Levin <ldv@altlinux.org>
    s390: fix syscall_get_error for compat processes

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: tmio: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: mtk: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: plat_nand: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: socrates: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: oxnas: Fix the probe error path

Nishka Dasgupta <nishkadg.linux@gmail.com>
    mtd: rawnand: oxnas: Add of_node_put()

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: orion: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: xway: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: sharpsl: Fix the probe error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: diskonchip: Fix the probe error path

Boris Brezillon <boris.brezillon@bootlin.com>
    mtd: rawnand: Pass a nand_chip object to nand_release()

Boris Brezillon <boris.brezillon@bootlin.com>
    mtd: rawnand: Pass a nand_chip object to nand_scan()

Ahmed S. Darwish <a.darwish@linutronix.de>
    block: nr_sects_write(): Disable preemption on seqcount write

Ard Biesheuvel <ardb@kernel.org>
    x86/boot/compressed: Relax sed symbol type regex for LLVM ld.lld

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Increase ACT retry timeout to 3s

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid race conditions when remounting with options that change dax

Sasha Levin <sashal@kernel.org>
    ext4: fix partial cluster initialization when splitting extent

Tom Rix <trix@redhat.com>
    selinux: fix double free

Sandeep Raghuraman <sandy.8925@gmail.com>
    drm/amdgpu: Replace invalid device ID with a valid device ID

Huacai Chen <chenhc@lemote.com>
    drm/qxl: Use correct notify port address when creating cursor ring

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Reformat drm_dp_check_act_status() a bit

Wolfram Sang <wsa+renesas@sang-engineering.com>
    drm: encoder_slave: fix refcouting error for modules

Kai-Heng Feng <kai.heng.feng@canonical.com>
    libata: Use per port sync for detach

Will Deacon <will@kernel.org>
    arm64: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Jason Yan <yanaijie@huawei.com>
    block: Fix use-after-free in blkdev_get()

David Howells <dhowells@redhat.com>
    afs: afs_write_end() should change i_size under the right lock

David Howells <dhowells@redhat.com>
    afs: Fix non-setting of mtime when writing into mmap

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    bcache: fix potential deadlock problem in btree_gc_coalesce

yangerkun <yangerkun@huawei.com>
    ext4: stop overwrite the errcode in ext4_setup_super

Gaurav Singh <gaurav1086@gmail.com>
    perf report: Fix NULL pointer dereference in hists__fprintf_nr_sample_events()

Qais Yousef <qais.yousef@arm.com>
    usb/ehci-platform: Set PM runtime as active on resume

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: host: ehci-platform: add a quirk to avoid stuck

Qais Yousef <qais.yousef@arm.com>
    usb/xhci-plat: Set PM runtime as active on resume

Li RongQing <lirongqing@baidu.com>
    xdp: Fix xsk_generic_xmit errno

YiFei Zhu <zhuyifei1999@gmail.com>
    net/filter: Permit reading NET in load_bytes_relative when MAC not set

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/idt: Keep spurious entries unset in system_vectors

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: acornscsi: Fix an error handling path in acornscsi_probe()

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: hdmi ddc clk: Fix size of m divider

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5645: Add platform-data for Asus T101HA

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for Toshiba Encore WT10-A tablet

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: core: only convert non DPCM link to DPCM link

Zhihao Cheng <chengzhihao1@huawei.com>
    afs: Fix memory leak in afs_put_sysnames()

tannerlove <tannerlove@google.com>
    selftests/net: in timestamping, strncpy needs to preserve null byte

Shaokun Zhang <zhangshaokun@hisilicon.com>
    drivers/perf: hisi: Fix wrong value for all counters enable

Logan Gunthorpe <logang@deltatee.com>
    NTB: ntb_test: Fix bug when counting remote files

Logan Gunthorpe <logang@deltatee.com>
    NTB: perf: Fix race condition when run with ntb_test

Logan Gunthorpe <logang@deltatee.com>
    NTB: perf: Fix support for hardware that doesn't have port numbers

Logan Gunthorpe <logang@deltatee.com>
    NTB: perf: Don't require one more memory window than number of peers

Logan Gunthorpe <logang@deltatee.com>
    NTB: Revert the change to use the NTB device dev for DMA allocations

Logan Gunthorpe <logang@deltatee.com>
    NTB: ntb_tool: reading the link file should not end in a NULL byte

Sanjay R Mehta <sanju.mehta@amd.com>
    ntb_tool: pass correct struct device to dma_alloc_coherent

Sanjay R Mehta <sanju.mehta@amd.com>
    ntb_perf: pass correct struct device to dma_alloc_coherent

Bob Peterson <rpeterso@redhat.com>
    gfs2: fix use-after-free on transaction ail lists

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    blktrace: fix endianness for blk_log_remap()

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    blktrace: fix endianness in get_pdu_int()

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    blktrace: use errno instead of bi_status

Ram Pai <linuxram@us.ibm.com>
    selftests/vm/pkeys: fix alloc_random_pkey() to make it really random

Nick Desaulniers <ndesaulniers@google.com>
    elfnote: mark all .note sections SHF_ALLOC

Arnd Bergmann <arnd@arndb.de>
    include/linux/bitops.h: avoid clang shift-count-overflow warnings

Jann Horn <jannh@google.com>
    lib/zlib: remove outdated and incorrect pre-increment optimization

Jiri Benc <jbenc@redhat.com>
    geneve: change from tx_error to tx_dropped on missing metadata

Tero Kristo <t-kristo@ti.com>
    crypto: omap-sham - add proper load balancing support for multicore

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    pinctrl: freescale: imx: Fix an error handling path in 'imx_pinctrl_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    pinctrl: imxl: Fix an error handling path in 'imx1_pinctrl_core_probe()'

Can Guo <cang@codeaurora.org>
    scsi: ufs: Don't update urgent bkops level when toggling auto bkops

Qiushi Wu <wu000273@umn.edu>
    scsi: iscsi: Fix reference count leak in iscsi_boot_create_kobj

Bob Peterson <rpeterso@redhat.com>
    gfs2: Allow lock_nolock mount to specify jid=X

Stafford Horne <shorne@gmail.com>
    openrisc: Fix issue with argument clobbering for clone/fork

David Howells <dhowells@redhat.com>
    rxrpc: Adjust /proc/net/rxrpc/calls to display call->debug_id not user_ID

Qiushi Wu <wu000273@umn.edu>
    vfio/mdev: Fix reference count leak in add_mdev_supported_type

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    ASoC: fsl_asrc_dma: Fix dma_chan leak when config DMA channel failed

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    extcon: adc-jack: Fix an error handling path in 'adc_jack_probe()'

huhai <huhai@tj.kylinos.cn>
    powerpc/4xx: Don't unmap NULL mbase

Dan Carpenter <dan.carpenter@oracle.com>
    of: Fix a refcounting bug in __of_attach_node_sysfs()

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    NFSv4.1 fix rpc_call_done assignment for BIND_CONN_TO_SESSION

Fedor Tokarev <ftokarev@gmail.com>
    net: sunrpc: Fix off-by-one issues in 'rpc_ntop6'

Chunyan Zhang <chunyan.zhang@unisoc.com>
    clk: sprd: return correct type of value for _sprd_pll_recalc_rate

Qian Cai <cai@lca.pw>
    KVM: PPC: Book3S HV: Ignore kmemleak false positives

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    scsi: ufs-qcom: Fix scheduling while atomic issue

Nathan Chancellor <natechancellor@gmail.com>
    clk: bcm2835: Fix return type of bcm2835_register_gate

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()

Qiushi Wu <wu000273@umn.edu>
    ASoC: fix incomplete error-handling in img_i2s_in_probe.

Borislav Petkov <bp@suse.de>
    x86/apic: Make TSC deadline timer detection message visible

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/iw_cxgb4: cleanup device debugfs entries on ULD remove

Pawel Laszczak <pawell@cadence.com>
    usb: gadget: Fix issue with config_ep_by_speed function

Qiushi Wu <wu000273@umn.edu>
    usb: gadget: fix potential double-free in m66592_probe.

Colin Ian King <colin.king@canonical.com>
    usb: gadget: lpc32xx_udc: don't dereference ep pointer before null check

Nathan Chancellor <natechancellor@gmail.com>
    USB: gadget: udc: s3c2410_udc: Remove pointless NULL check in s3c2410_udc_nuke

Fabrice Gasnier <fabrice.gasnier@st.com>
    usb: dwc2: gadget: move gadget resume after the core is in L0 state

Stefan Riedmueller <s.riedmueller@phytec.de>
    watchdog: da9062: No need to ping manually before setting timeout

Maor Gottlieb <maorg@mellanox.com>
    IB/cma: Fix ports memory leak in cma_configfs

Marc Zyngier <maz@kernel.org>
    PCI: dwc: Fix inner MSI IRQ domain registration

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PTM: Inherit Switch Downstream Port PTM settings from Upstream Port

Hannes Reinecke <hare@suse.de>
    dm zoned: return NULL if dmz_get_zone_for_reclaim() fails to find a zone

Qian Cai <cai@lca.pw>
    powerpc/64s/pgtable: fix an undefined behaviour

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix ethernet phy-mode for Jetson Xavier

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: Userspace must not complete queued commands

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos5433: Add IGNORE_UNUSED flag to sclk_i2s1

Souptick Joarder <jrdr.linux@gmail.com>
    fpga: dfl: afu: Corrected error handling levels

Gregory CLEMENT <gregory.clement@bootlin.com>
    tty: n_gsm: Fix bogus i++ in gsm_data_kick

Tang Bin <tangbin@cmss.chinamobile.com>
    USB: host: ehci-mxc: Add error handling in ehci_mxc_drv_probe()

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for Toshiba Encore WT8-A tablet

Roy Spliet <nouveau@spliet.org>
    drm/msm/mdp5: Fix mdp5_init error path for failed mdp5_kms allocation

Qais Yousef <qais.yousef@arm.com>
    usb/ohci-platform: Fix a warning when hibernating

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Mask cap zero

Geoff Levand <geoff@infradead.org>
    powerpc/ps3: Fix kexec shutdown hang

Nicholas Piggin <npiggin@gmail.com>
    powerpc/pseries/ras: Fix FWNMI_VALID off by one

Feng Tang <feng.tang@intel.com>
    ipmi: use vzalloc instead of kmalloc for user creation

Cristian Klein <cristian.klein@elastisys.com>
    HID: Add quirks for Trust Panora Graphic Tablet

Gregory CLEMENT <gregory.clement@bootlin.com>
    tty: n_gsm: Fix waking up upper tty layer when room available

Gregory CLEMENT <gregory.clement@bootlin.com>
    tty: n_gsm: Fix SOF skipping

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Don't initialise init_task->thread.regs

Rob Herring <robh@kernel.org>
    PCI: Fix pci_register_host_bridge() device_register() error handling

Tero Kristo <t-kristo@ti.com>
    clk: ti: composite: fix memory leak

Arnd Bergmann <arnd@arndb.de>
    dlm: remove BUG() before panic()

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    pinctrl: rockchip: fix memleak in rockchip_dt_node_to_map

Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Fix double free warnings

Dmitry Osipenko <digetx@gmail.com>
    power: supply: smb347-charger: IRQSTAT_D is volatile

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    power: supply: lp8788: Fix an error handling path in 'lp8788_charger_probe()'

Viacheslav Dubeyko <v.dubeiko@yadro.com>
    scsi: qla2xxx: Fix warning after FC target reset

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges

Andrew Murray <andrew.murray@arm.com>
    PCI: rcar: Fix incorrect programming of OB windows

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    drivers: base: Fix NULL pointer exception in __platform_driver_probe() if a driver developer is foolish

John Stultz <john.stultz@linaro.org>
    serial: amba-pl011: Make sure we initialize the port.lock spinlock

Russell King <rmk+kernel@armlinux.org.uk>
    i2c: pxa: fix i2c_pxa_scream_blue_murder() debug output

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    PCI: v3-semi: Fix a memory leak in v3_pci_probe() error handling paths

Matej Dujava <mdujava@kocurkovo.cz>
    staging: sm750fb: add missing case while setting FB_VISUAL

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Properly handle failed kick_transfer

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    thermal/drivers/ti-soc-thermal: Avoid dereferencing ERR_PTR

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: ngd: get drvdata from correct device

Raghavendra Rao Ananta <rananta@codeaurora.org>
    tty: hvc: Fix data abort due to race in hvc_open

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: put thinint indicator after early error

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix racy list management in output queue

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Improve frames size computation

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    staging: gasket: Fix mapping refcnt leak when register/store fails

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    staging: gasket: Fix mapping refcnt leak when put attribute fails

Christoph Hellwig <hch@lst.de>
    firmware: qcom_scm: fix bogous abuse of dma-direct internals

Jason Yan <yanaijie@huawei.com>
    pinctrl: rza1: Fix wrong array assignment of rza1l_swio_entries

Chad Dupuis <cdupuis@marvell.com>
    scsi: qedf: Fix crash when MFW calls for protocol stats while function is still probing

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: dwapb: Append MODULE_ALIAS for platform driver

Vincent Stehlé <vincent.stehle@laposte.net>
    ARM: dts: sun8i-h2-plus-bananapi-m2-zero: Fix led polarity

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Do not flush offload work if ARP not resolved

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: dts: mt8173: fix unit name warnings

Chen Zhou <chenzhou10@huawei.com>
    staging: greybus: fix a missing-check bug in gb_lights_light_config()

Hans de Goede <hdegoede@redhat.com>
    x86/purgatory: Disable various profiling and sanitizing options

John Johansen <john.johansen@canonical.com>
    apparmor: fix nnp subset test for unconfined

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsi: Don't send host info in adapter info MAD after LPM

Simon Arlott <simon@octiron.net>
    scsi: sr: Fix sr_probe() missing deallocate of device minor

Pavel Machek (CIP) <pavel@denx.de>
    ASoC: meson: add missing free_irq() in error path

Mauricio Faria de Oliveira <mfo@canonical.com>
    apparmor: check/put label on apparmor_sk_clone_security()

John Johansen <john.johansen@canonical.com>
    apparmor: fix introspection of of task mode for unconfined tasks

ashimida <ashimida@linux.alibaba.com>
    mksysmap: Fix the mismatch of '.L' symbols in System.map

Logan Gunthorpe <logang@deltatee.com>
    NTB: Fix the default port and peer numbers for legacy drivers

Logan Gunthorpe <logang@deltatee.com>
    NTB: ntb_pingpong: Choose doorbells based on port number

Wang Hai <wanghai38@huawei.com>
    yam: fix possible memory leak in yam_init_driver

Navid Emamdoost <navid.emamdoost@gmail.com>
    pwm: img: Call pm_runtime_put() in pm_runtime_get_sync() failed case

Pingfan Liu <kernelfans@gmail.com>
    powerpc/crashkernel: Take "mem=" option into account

Jon Derrick <jonathan.derrick@intel.com>
    PCI: vmd: Filter resource type bits from shadow register

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    nfsd: Fix svc_xprt refcnt leak when setup callback client failed

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf/hv-24x7: Fix inconsistent output values incase multiple hv-24x7 events run

Alain Volmat <avolmat@me.com>
    clk: clk-flexgen: fix clock-critical handling

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event

Marek Szyprowski <m.szyprowski@samsung.com>
    mfd: wm8994: Fix driver operation if loaded as modules

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: dwapb: Call acpi_gpiochip_free_interrupts() on GPIO chip de-registration

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    m68k/PCI: Fix a memory leak in an error handling path

Aharon Landau <aharonl@mellanox.com>
    RDMA/mlx5: Add init2init as a modify command

Qian Cai <cai@lca.pw>
    vfio/pci: fix memory leaks in alloc_perm_bits()

Emmanuel Nicolet <emmanuel.nicolet@gmail.com>
    ps3disk: use the default segment boundary

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Don't blindly enable ASPM L0s and don't write to read-only register

Martin Wilck <mwilck@suse.com>
    dm mpath: switch paths in dm_blk_ioctl() code path

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    serial: 8250: Fix max baud limit in generic 8250 port

Oliver Neukum <oneukum@suse.com>
    usblp: poison URBs upon disconnect

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: Mark top ISP and CAM clocks on Exynos542x as critical

Russell King <rmk+kernel@armlinux.org.uk>
    i2c: pxa: clear all master action bits in i2c_pxa_stop_message()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    f2fs: report delalloc reserve as non-free in statfs for project quota

Andreas Klinger <ak@it-klinger.de>
    iio: bmp280: fix compensation of humidity

Viacheslav Dubeyko <v.dubeiko@yadro.com>
    scsi: qla2xxx: Fix issue with adapter's stopping state

Ard Biesheuvel <ardb@kernel.org>
    PCI: Allow pci_resize_resource() for devices on root bus

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: isa/wavefront: prevent out of bounds write in ioctl

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek - Introduce polarity for micmute LED GPIO

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qedi: Check for buffer overflow in qedi_set_path()

Linus Walleij <linus.walleij@linaro.org>
    ARM: integrator: Add some Kconfig selections

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    ASoC: davinci-mcasp: Fix dma_chan refcnt leak when getting dma type

Jon Hunter <jonathanh@nvidia.com>
    backlight: lp855x: Ensure regulators are disabled on probe failure

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: msm8916: Fix the address location of pll->config_reg

Alex Elder <elder@linaro.org>
    remoteproc: Fix IDR initialisation in rproc_alloc()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: pressure: bmp280: Tolerate IRQ before registering

Adam Honse <calcprogrammer1@gmail.com>
    i2c: piix4: Detect secondary SMBus controller on AMD AM4 chipsets

Dmitry Osipenko <digetx@gmail.com>
    ASoC: tegra: tegra_wm8903: Support nvidia, headset property

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    clk: sunxi: Fix incorrect usage of round_down()

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    power: supply: bq24257_charger: Replace depends on REGMAP_I2C with select


-------------

Diffstat:

 Documentation/driver-api/mtdnand.rst               |   4 +-
 Makefile                                           |   4 +-
 .../boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts    |   2 +-
 arch/arm/mach-integrator/Kconfig                   |   7 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |  22 +--
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi     |   2 +-
 arch/arm64/kernel/hw_breakpoint.c                  |  44 +++---
 arch/m68k/coldfire/pci.c                           |   4 +-
 arch/openrisc/kernel/entry.S                       |   4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  23 ++-
 arch/powerpc/include/asm/processor.h               |   1 -
 arch/powerpc/kernel/head_64.S                      |   9 +-
 arch/powerpc/kernel/machine_kexec.c                |   8 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |  16 ++-
 arch/powerpc/perf/hv-24x7.c                        |  10 --
 arch/powerpc/platforms/4xx/pci.c                   |   4 +-
 arch/powerpc/platforms/ps3/mm.c                    |  22 +--
 arch/powerpc/platforms/pseries/ras.c               |   5 +-
 arch/s390/include/asm/syscall.h                    |  12 +-
 arch/x86/boot/Makefile                             |   2 +-
 arch/x86/kernel/apic/apic.c                        |   2 +-
 arch/x86/kernel/idt.c                              |   6 +-
 arch/x86/kernel/kprobes/core.c                     |  16 +--
 arch/x86/purgatory/Makefile                        |   5 +-
 crypto/algboss.c                                   |   2 -
 crypto/algif_skcipher.c                            |   6 +-
 drivers/ata/libata-core.c                          |  11 +-
 drivers/base/platform.c                            |   2 +
 drivers/block/ps3disk.c                            |   1 -
 drivers/char/ipmi/ipmi_msghandler.c                |   7 +-
 drivers/clk/bcm/clk-bcm2835.c                      |  10 +-
 drivers/clk/qcom/gcc-msm8916.c                     |   8 +-
 drivers/clk/samsung/clk-exynos5420.c               |  16 ++-
 drivers/clk/samsung/clk-exynos5433.c               |   3 +-
 drivers/clk/sprd/pll.c                             |   2 +-
 drivers/clk/st/clk-flexgen.c                       |   1 +
 drivers/clk/sunxi/clk-sunxi.c                      |   2 +-
 drivers/clk/ti/composite.c                         |   1 +
 drivers/crypto/omap-sham.c                         |  64 +++++----
 drivers/extcon/extcon-adc-jack.c                   |   3 +-
 drivers/firmware/qcom_scm.c                        |   9 +-
 drivers/fpga/dfl-afu-dma-region.c                  |   4 +-
 drivers/gpio/gpio-dwapb.c                          |  34 +++--
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c   |   2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  58 ++++----
 drivers/gpu/drm/drm_encoder_slave.c                |   5 +-
 drivers/gpu/drm/i915/i915_cmd_parser.c             |   4 +
 drivers/gpu/drm/i915/i915_irq.c                    |   1 +
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |   3 +-
 drivers/gpu/drm/qxl/qxl_kms.c                      |   2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi.h                 |   2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c         |   2 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/i2c/busses/i2c-piix4.c                     |   3 +-
 drivers/i2c/busses/i2c-pxa.c                       |  13 +-
 drivers/iio/pressure/bmp280-core.c                 |   7 +-
 drivers/infiniband/core/cma_configfs.c             |  13 ++
 drivers/infiniband/hw/cxgb4/device.c               |   1 +
 drivers/infiniband/hw/mlx5/devx.c                  |   1 +
 drivers/md/bcache/btree.c                          |   8 +-
 drivers/md/dm-mpath.c                              |   2 +-
 drivers/md/dm-zoned-metadata.c                     |   4 +-
 drivers/md/dm-zoned-reclaim.c                      |   4 +-
 drivers/mfd/wm8994-core.c                          |   1 +
 drivers/mtd/nand/raw/ams-delta.c                   |   4 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   2 +-
 drivers/mtd/nand/raw/au1550nd.c                    |   4 +-
 drivers/mtd/nand/raw/bcm47xxnflash/main.c          |   2 +-
 drivers/mtd/nand/raw/bcm47xxnflash/ops_bcm4706.c   |   2 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   4 +-
 drivers/mtd/nand/raw/cafe_nand.c                   |   4 +-
 drivers/mtd/nand/raw/cmx270_nand.c                 |   4 +-
 drivers/mtd/nand/raw/cs553x_nand.c                 |   4 +-
 drivers/mtd/nand/raw/davinci_nand.c                |   4 +-
 drivers/mtd/nand/raw/denali.c                      |   6 +-
 drivers/mtd/nand/raw/diskonchip.c                  |  11 +-
 drivers/mtd/nand/raw/docg4.c                       |   4 +-
 drivers/mtd/nand/raw/fsl_elbc_nand.c               |   5 +-
 drivers/mtd/nand/raw/fsl_ifc_nand.c                |   5 +-
 drivers/mtd/nand/raw/fsl_upm.c                     |   4 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   4 +-
 drivers/mtd/nand/raw/gpio.c                        |   4 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   4 +-
 drivers/mtd/nand/raw/hisi504_nand.c                |   5 +-
 drivers/mtd/nand/raw/jz4740_nand.c                 |   4 +-
 drivers/mtd/nand/raw/jz4780_nand.c                 |   6 +-
 drivers/mtd/nand/raw/lpc32xx_mlc.c                 |   5 +-
 drivers/mtd/nand/raw/lpc32xx_slc.c                 |   5 +-
 drivers/mtd/nand/raw/marvell_nand.c                |   6 +-
 drivers/mtd/nand/raw/mpc5121_nfc.c                 |   4 +-
 drivers/mtd/nand/raw/mtk_nand.c                    |   6 +-
 drivers/mtd/nand/raw/mxc_nand.c                    |   4 +-
 drivers/mtd/nand/raw/nand_base.c                   |  29 ++--
 drivers/mtd/nand/raw/nandsim.c                     |   6 +-
 drivers/mtd/nand/raw/ndfc.c                        |   4 +-
 drivers/mtd/nand/raw/nuc900_nand.c                 |   4 +-
 drivers/mtd/nand/raw/omap2.c                       |   4 +-
 drivers/mtd/nand/raw/orion_nand.c                  |   7 +-
 drivers/mtd/nand/raw/oxnas_nand.c                  |  18 +--
 drivers/mtd/nand/raw/pasemi_nand.c                 |   4 +-
 drivers/mtd/nand/raw/plat_nand.c                   |   6 +-
 drivers/mtd/nand/raw/qcom_nandc.c                  |   4 +-
 drivers/mtd/nand/raw/r852.c                        |   4 +-
 drivers/mtd/nand/raw/s3c2410.c                     |   4 +-
 drivers/mtd/nand/raw/sh_flctl.c                    |   4 +-
 drivers/mtd/nand/raw/sharpsl.c                     |   6 +-
 drivers/mtd/nand/raw/sm_common.c                   |   2 +-
 drivers/mtd/nand/raw/socrates_nand.c               |   7 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   6 +-
 drivers/mtd/nand/raw/tango_nand.c                  |   4 +-
 drivers/mtd/nand/raw/tegra_nand.c                  |   2 +-
 drivers/mtd/nand/raw/tmio_nand.c                   |   6 +-
 drivers/mtd/nand/raw/txx9ndfmc.c                   |   4 +-
 drivers/mtd/nand/raw/vf610_nfc.c                   |   4 +-
 drivers/mtd/nand/raw/xway_nand.c                   |   6 +-
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |   5 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |  14 +-
 drivers/net/geneve.c                               |   7 +-
 drivers/net/hamradio/yam.c                         |   1 +
 drivers/ntb/ntb.c                                  |   9 +-
 drivers/ntb/test/ntb_perf.c                        |  30 +++-
 drivers/ntb/test/ntb_pingpong.c                    |  14 +-
 drivers/ntb/test/ntb_tool.c                        |   9 +-
 drivers/of/kobj.c                                  |   3 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |   2 +
 drivers/pci/controller/pci-aardvark.c              |   4 -
 drivers/pci/controller/pci-v3-semi.c               |   2 +-
 drivers/pci/controller/pcie-rcar.c                 |   9 +-
 drivers/pci/controller/vmd.c                       |   6 +-
 drivers/pci/pcie/aspm.c                            |  10 --
 drivers/pci/pcie/ptm.c                             |  22 ++-
 drivers/pci/probe.c                                |   5 +-
 drivers/pci/setup-res.c                            |   9 +-
 drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c       |   2 +-
 drivers/pinctrl/freescale/pinctrl-imx.c            |  19 +--
 drivers/pinctrl/freescale/pinctrl-imx1-core.c      |   1 -
 drivers/pinctrl/pinctrl-rockchip.c                 |   7 +-
 drivers/pinctrl/pinctrl-rza1.c                     |   2 +-
 drivers/power/supply/Kconfig                       |   2 +-
 drivers/power/supply/lp8788-charger.c              |  18 +--
 drivers/power/supply/smb347-charger.c              |   1 +
 drivers/pwm/pwm-img.c                              |   8 +-
 drivers/remoteproc/remoteproc_core.c               |   3 +-
 drivers/s390/cio/qdio.h                            |   1 -
 drivers/s390/cio/qdio_setup.c                      |   1 -
 drivers/s390/cio/qdio_thinint.c                    |  14 +-
 drivers/scsi/arm/acornscsi.c                       |   4 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   2 +
 drivers/scsi/iscsi_boot_sysfs.c                    |   2 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   2 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   2 +
 drivers/scsi/qedf/qedf.h                           |   1 +
 drivers/scsi/qedf/qedf_main.c                      |  35 ++++-
 drivers/scsi/qedi/qedi_iscsi.c                     |   7 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   2 +
 drivers/scsi/sr.c                                  |   6 +-
 drivers/scsi/ufs/ufs-qcom.c                        |   6 +-
 drivers/scsi/ufs/ufshcd.c                          |   1 -
 drivers/slimbus/qcom-ngd-ctrl.c                    |   4 +-
 drivers/staging/gasket/gasket_sysfs.c              |   2 +
 drivers/staging/greybus/light.c                    |   3 +-
 drivers/staging/mt29f_spinand/mt29f_spinand.c      |   2 +-
 drivers/staging/sm750fb/sm750.c                    |   1 +
 drivers/target/target_core_user.c                  | 154 ++++++++++-----------
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |   6 +-
 drivers/tty/hvc/hvc_console.c                      |  16 ++-
 drivers/tty/n_gsm.c                                |  26 ++--
 drivers/tty/serial/8250/8250_port.c                |   4 +-
 drivers/tty/serial/amba-pl011.c                    |   1 +
 drivers/usb/class/usblp.c                          |   5 +-
 drivers/usb/dwc2/core_intr.c                       |   7 +-
 drivers/usb/dwc3/gadget.c                          |  24 ++--
 drivers/usb/gadget/composite.c                     |  78 ++++++++---
 drivers/usb/gadget/udc/lpc32xx_udc.c               |  11 +-
 drivers/usb/gadget/udc/m66592-udc.c                |   2 +-
 drivers/usb/gadget/udc/s3c2410_udc.c               |   4 -
 drivers/usb/host/ehci-mxc.c                        |   2 +
 drivers/usb/host/ehci-platform.c                   | 131 ++++++++++++++++++
 drivers/usb/host/ohci-platform.c                   |   5 +
 drivers/usb/host/xhci-plat.c                       |  10 +-
 drivers/vfio/mdev/mdev_sysfs.c                     |   2 +-
 drivers/vfio/pci/vfio_pci_config.c                 |  14 +-
 drivers/video/backlight/lp855x_bl.c                |  20 ++-
 drivers/watchdog/da9062_wdt.c                      |   5 -
 fs/afs/proc.c                                      |   1 +
 fs/afs/write.c                                     |   5 +-
 fs/block_dev.c                                     |  12 +-
 fs/dlm/dlm_internal.h                              |   1 -
 fs/ext4/extents.c                                  |   2 +-
 fs/ext4/super.c                                    |  23 ++-
 fs/f2fs/super.c                                    |   3 +-
 fs/gfs2/log.c                                      |  11 +-
 fs/gfs2/ops_fstype.c                               |   2 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nfsd/nfs4callback.c                             |   2 +
 include/linux/bitops.h                             |   2 +-
 include/linux/elfnote.h                            |   2 +-
 include/linux/genhd.h                              |   2 +
 include/linux/kprobes.h                            |   4 +
 include/linux/libata.h                             |   3 +
 include/linux/mtd/rawnand.h                        |   9 +-
 include/linux/usb/composite.h                      |   3 +
 include/linux/usb/ehci_def.h                       |   2 +-
 kernel/kprobes.c                                   |  27 +++-
 kernel/trace/blktrace.c                            |  30 ++--
 lib/zlib_inflate/inffast.c                         |  91 +++++-------
 net/core/dev.c                                     |  40 +++---
 net/core/filter.c                                  |  16 ++-
 net/rxrpc/proc.c                                   |   6 +-
 net/sunrpc/addr.c                                  |   4 +-
 net/xdp/xsk.c                                      |   4 +-
 scripts/mksysmap                                   |   2 +-
 security/apparmor/domain.c                         |   9 +-
 security/apparmor/include/label.h                  |   1 +
 security/apparmor/label.c                          |  37 ++++-
 security/apparmor/lsm.c                            |   5 +
 security/selinux/ss/services.c                     |   4 +
 sound/isa/wavefront/wavefront_synth.c              |   8 +-
 sound/pci/hda/patch_realtek.c                      |  14 +-
 sound/soc/codecs/rt5645.c                          |  14 ++
 sound/soc/davinci/davinci-mcasp.c                  |   4 +-
 sound/soc/fsl/fsl_asrc_dma.c                       |   1 +
 sound/soc/img/img-i2s-in.c                         |   1 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  24 ++++
 sound/soc/meson/axg-fifo.c                         |  10 +-
 sound/soc/soc-core.c                               |  22 ++-
 sound/soc/tegra/tegra_wm8903.c                     |   6 +-
 sound/usb/card.h                                   |   4 +
 sound/usb/endpoint.c                               |  49 +++++--
 sound/usb/endpoint.h                               |   1 +
 sound/usb/pcm.c                                    |   2 +
 tools/perf/builtin-report.c                        |   3 +-
 .../networking/timestamping/timestamping.c         |  10 +-
 tools/testing/selftests/ntb/ntb_test.sh            |   2 +-
 tools/testing/selftests/x86/protection_keys.c      |   3 +-
 238 files changed, 1375 insertions(+), 853 deletions(-)


