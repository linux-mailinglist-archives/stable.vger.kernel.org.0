Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97048207A3C
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 19:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405438AbgFXR1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 13:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405318AbgFXR1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 13:27:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EFF32078D;
        Wed, 24 Jun 2020 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593019622;
        bh=zLGID0qA14ID2zlnaDy1lOpYgeZ8FC0BuCfMXLRgb1g=;
        h=From:To:Cc:Subject:Date:From;
        b=iQ0LYNPQSVQblSfizmqX0fuNYiHTP+skrv21bk2Lde0CEb866/uhMwp3thVQy7e3Z
         TXHwt0JONDj/8A57rVPG5MPzPvSYWQiPZx6iyIVgdVKYjTx8Tde+7uPGL4Y57XWZbi
         r57UtDh2LY0gDbS2FiNP550+urVVbC2LOhfW4hes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/139] 4.14.186-rc3 review
Date:   Wed, 24 Jun 2020 19:26:56 +0200
Message-Id: <20200624172341.891497820@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc3
X-KernelTest-Deadline: 2020-06-26T17:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.186 release.
There are 139 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 26 Jun 2020 17:23:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.186-rc3

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't be generated

Kai Huang <kai.huang@linux.intel.com>
    kvm: x86: Fix reserved bits related calculation errors caused by MKTME

Kai Huang <kai.huang@linux.intel.com>
    kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c

NeilBrown <neilb@suse.de>
    md: add feature flag MD_FEATURE_RAID0_LAYOUT

Ahmed S. Darwish <a.darwish@linutronix.de>
    net: core: device_rename: Use rwsem instead of a seqcount

Thomas Gleixner <tglx@linutronix.de>
    sched/rt, net: Use CONFIG_PREEMPTION.patch

Jiri Olsa <jolsa@redhat.com>
    kretprobe: Prevent triggering kretprobe from within kprobe_flush_task

Chen Yu <yu.c.chen@intel.com>
    e1000e: Do not wake up the system via WOL if device wakeup is disabled

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix to protect kick_kprobe_optimizer() by kprobe_mutex

Eric Biggers <ebiggers@google.com>
    crypto: algboss - don't wait during notifier callback

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_skcipher - Cap recv SG list at ctx->used

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

Ahmed S. Darwish <a.darwish@linutronix.de>
    block: nr_sects_write(): Disable preemption on seqcount write

Ard Biesheuvel <ardb@kernel.org>
    x86/boot/compressed: Relax sed symbol type regex for LLVM ld.lld

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Increase ACT retry timeout to 3s

Jeffle Xu <jefflexu@linux.alibaba.com>
    ext4: fix partial cluster initialization when splitting extent

Tom Rix <trix@redhat.com>
    selinux: fix double free

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

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    bcache: fix potential deadlock problem in btree_gc_coalesce

Gaurav Singh <gaurav1086@gmail.com>
    perf report: Fix NULL pointer dereference in hists__fprintf_nr_sample_events()

Qais Yousef <qais.yousef@arm.com>
    usb/ehci-platform: Set PM runtime as active on resume

Qais Yousef <qais.yousef@arm.com>
    usb/xhci-plat: Set PM runtime as active on resume

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: acornscsi: Fix an error handling path in acornscsi_probe()

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: hdmi ddc clk: Fix size of m divider

tannerlove <tannerlove@google.com>
    selftests/net: in timestamping, strncpy needs to preserve null byte

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

Qiushi Wu <wu000273@umn.edu>
    vfio/mdev: Fix reference count leak in add_mdev_supported_type

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    ASoC: fsl_asrc_dma: Fix dma_chan leak when config DMA channel failed

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    extcon: adc-jack: Fix an error handling path in 'adc_jack_probe()'

huhai <huhai@tj.kylinos.cn>
    powerpc/4xx: Don't unmap NULL mbase

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    NFSv4.1 fix rpc_call_done assignment for BIND_CONN_TO_SESSION

Fedor Tokarev <ftokarev@gmail.com>
    net: sunrpc: Fix off-by-one issues in 'rpc_ntop6'

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    scsi: ufs-qcom: Fix scheduling while atomic issue

Nathan Chancellor <natechancellor@gmail.com>
    clk: bcm2835: Fix return type of bcm2835_register_gate

Borislav Petkov <bp@suse.de>
    x86/apic: Make TSC deadline timer detection message visible

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

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PTM: Inherit Switch Downstream Port PTM settings from Upstream Port

Hannes Reinecke <hare@suse.de>
    dm zoned: return NULL if dmz_get_zone_for_reclaim() fails to find a zone

Qian Cai <cai@lca.pw>
    powerpc/64s/pgtable: fix an undefined behaviour

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos5433: Add IGNORE_UNUSED flag to sclk_i2s1

Gregory CLEMENT <gregory.clement@bootlin.com>
    tty: n_gsm: Fix bogus i++ in gsm_data_kick

Tang Bin <tangbin@cmss.chinamobile.com>
    USB: host: ehci-mxc: Add error handling in ehci_mxc_drv_probe()

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

Gregory CLEMENT <gregory.clement@bootlin.com>
    tty: n_gsm: Fix waking up upper tty layer when room available

Gregory CLEMENT <gregory.clement@bootlin.com>
    tty: n_gsm: Fix SOF skipping

Rob Herring <robh@kernel.org>
    PCI: Fix pci_register_host_bridge() device_register() error handling

Tero Kristo <t-kristo@ti.com>
    clk: ti: composite: fix memory leak

Arnd Bergmann <arnd@arndb.de>
    dlm: remove BUG() before panic()

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

Matej Dujava <mdujava@kocurkovo.cz>
    staging: sm750fb: add missing case while setting FB_VISUAL

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    thermal/drivers/ti-soc-thermal: Avoid dereferencing ERR_PTR

Raghavendra Rao Ananta <rananta@codeaurora.org>
    tty: hvc: Fix data abort due to race in hvc_open

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: put thinint indicator after early error

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Improve frames size computation

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Do not flush offload work if ARP not resolved

Chen Zhou <chenzhou10@huawei.com>
    staging: greybus: fix a missing-check bug in gb_lights_light_config()

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsi: Don't send host info in adapter info MAD after LPM

Simon Arlott <simon@octiron.net>
    scsi: sr: Fix sr_probe() missing deallocate of device minor

John Johansen <john.johansen@canonical.com>
    apparmor: fix introspection of of task mode for unconfined tasks

ashimida <ashimida@linux.alibaba.com>
    mksysmap: Fix the mismatch of '.L' symbols in System.map

Logan Gunthorpe <logang@deltatee.com>
    NTB: Fix the default port and peer numbers for legacy drivers

Wang Hai <wanghai38@huawei.com>
    yam: fix possible memory leak in yam_init_driver

Pingfan Liu <kernelfans@gmail.com>
    powerpc/crashkernel: Take "mem=" option into account

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    m68k/PCI: Fix a memory leak in an error handling path

Qian Cai <cai@lca.pw>
    vfio/pci: fix memory leaks in alloc_perm_bits()

Emmanuel Nicolet <emmanuel.nicolet@gmail.com>
    ps3disk: use the default segment boundary

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Don't blindly enable ASPM L0s and don't write to read-only register

Martin Wilck <mwilck@suse.com>
    dm mpath: switch paths in dm_blk_ioctl() code path

Oliver Neukum <oneukum@suse.com>
    usblp: poison URBs upon disconnect

Russell King <rmk+kernel@armlinux.org.uk>
    i2c: pxa: clear all master action bits in i2c_pxa_stop_message()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    f2fs: report delalloc reserve as non-free in statfs for project quota

Andreas Klinger <ak@it-klinger.de>
    iio: bmp280: fix compensation of humidity

Viacheslav Dubeyko <v.dubeiko@yadro.com>
    scsi: qla2xxx: Fix issue with adapter's stopping state

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: isa/wavefront: prevent out of bounds write in ioctl

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

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    clk: sunxi: Fix incorrect usage of round_down()

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    power: supply: bq24257_charger: Replace depends on REGMAP_I2C with select

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Whitelist context-local timestamp in the gen9 cmdparser

Dmitry V. Levin <ldv@altlinux.org>
    s390: fix syscall_get_error for compat processes


-------------

Diffstat:

 Documentation/driver-api/mtdnand.rst               |  2 +-
 Makefile                                           |  4 +-
 arch/arm/mach-integrator/Kconfig                   |  7 +-
 arch/arm64/kernel/hw_breakpoint.c                  | 44 ++++++-----
 arch/m68k/coldfire/pci.c                           |  4 +-
 arch/openrisc/kernel/entry.S                       |  4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       | 23 +++++-
 arch/powerpc/kernel/machine_kexec.c                |  8 +-
 arch/powerpc/perf/hv-24x7.c                        | 10 ---
 arch/powerpc/platforms/4xx/pci.c                   |  4 +-
 arch/powerpc/platforms/ps3/mm.c                    | 22 +++---
 arch/powerpc/platforms/pseries/ras.c               |  5 +-
 arch/s390/include/asm/syscall.h                    | 12 ++-
 arch/x86/boot/Makefile                             |  2 +-
 arch/x86/kernel/apic/apic.c                        |  2 +-
 arch/x86/kernel/kprobes/core.c                     | 16 +---
 arch/x86/kvm/mmu.c                                 | 51 +++++++++++-
 arch/x86/kvm/x86.c                                 | 31 --------
 crypto/algboss.c                                   |  2 -
 crypto/algif_skcipher.c                            |  6 +-
 drivers/ata/libata-core.c                          | 11 ++-
 drivers/base/platform.c                            |  2 +
 drivers/block/ps3disk.c                            |  1 -
 drivers/clk/bcm/clk-bcm2835.c                      | 10 +--
 drivers/clk/qcom/gcc-msm8916.c                     |  8 +-
 drivers/clk/samsung/clk-exynos5433.c               |  3 +-
 drivers/clk/st/clk-flexgen.c                       |  1 +
 drivers/clk/sunxi/clk-sunxi.c                      |  2 +-
 drivers/clk/ti/composite.c                         |  1 +
 drivers/crypto/omap-sham.c                         | 64 ++++++++-------
 drivers/extcon/extcon-adc-jack.c                   |  3 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              | 58 ++++++++------
 drivers/gpu/drm/drm_encoder_slave.c                |  5 +-
 drivers/gpu/drm/i915/i915_cmd_parser.c             |  4 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c            |  3 +-
 drivers/gpu/drm/qxl/qxl_kms.c                      |  2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi.h                 |  2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c         |  2 +-
 drivers/i2c/busses/i2c-piix4.c                     |  3 +-
 drivers/i2c/busses/i2c-pxa.c                       | 13 ++--
 drivers/iio/pressure/bmp280-core.c                 |  7 +-
 drivers/infiniband/core/cma_configfs.c             | 13 ++++
 drivers/md/bcache/btree.c                          |  8 +-
 drivers/md/dm-mpath.c                              |  2 +-
 drivers/md/dm-zoned-metadata.c                     |  4 +-
 drivers/md/dm-zoned-reclaim.c                      |  4 +-
 drivers/md/md.c                                    | 13 ++++
 drivers/md/raid0.c                                 |  3 +
 drivers/mfd/wm8994-core.c                          |  1 +
 drivers/mtd/nand/ams-delta.c                       |  2 +-
 drivers/mtd/nand/au1550nd.c                        |  2 +-
 drivers/mtd/nand/bcm47xxnflash/main.c              |  2 +-
 drivers/mtd/nand/bf5xx_nand.c                      |  2 +-
 drivers/mtd/nand/brcmnand/brcmnand.c               |  2 +-
 drivers/mtd/nand/cafe_nand.c                       |  2 +-
 drivers/mtd/nand/cmx270_nand.c                     |  2 +-
 drivers/mtd/nand/cs553x_nand.c                     |  2 +-
 drivers/mtd/nand/davinci_nand.c                    |  2 +-
 drivers/mtd/nand/denali.c                          |  4 +-
 drivers/mtd/nand/diskonchip.c                      |  9 +--
 drivers/mtd/nand/docg4.c                           |  4 +-
 drivers/mtd/nand/fsl_elbc_nand.c                   |  2 +-
 drivers/mtd/nand/fsl_ifc_nand.c                    |  2 +-
 drivers/mtd/nand/fsl_upm.c                         |  2 +-
 drivers/mtd/nand/fsmc_nand.c                       |  2 +-
 drivers/mtd/nand/gpio.c                            |  2 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |  2 +-
 drivers/mtd/nand/hisi504_nand.c                    |  5 +-
 drivers/mtd/nand/jz4740_nand.c                     |  4 +-
 drivers/mtd/nand/jz4780_nand.c                     |  4 +-
 drivers/mtd/nand/lpc32xx_mlc.c                     |  5 +-
 drivers/mtd/nand/lpc32xx_slc.c                     |  5 +-
 drivers/mtd/nand/mpc5121_nfc.c                     |  2 +-
 drivers/mtd/nand/mtk_nand.c                        |  4 +-
 drivers/mtd/nand/mxc_nand.c                        |  2 +-
 drivers/mtd/nand/nand_base.c                       |  8 +-
 drivers/mtd/nand/nandsim.c                         |  4 +-
 drivers/mtd/nand/ndfc.c                            |  2 +-
 drivers/mtd/nand/nuc900_nand.c                     |  2 +-
 drivers/mtd/nand/omap2.c                           |  2 +-
 drivers/mtd/nand/orion_nand.c                      |  5 +-
 drivers/mtd/nand/oxnas_nand.c                      | 16 ++--
 drivers/mtd/nand/pasemi_nand.c                     |  2 +-
 drivers/mtd/nand/plat_nand.c                       |  4 +-
 drivers/mtd/nand/pxa3xx_nand.c                     |  2 +-
 drivers/mtd/nand/qcom_nandc.c                      |  2 +-
 drivers/mtd/nand/r852.c                            |  4 +-
 drivers/mtd/nand/s3c2410.c                         |  2 +-
 drivers/mtd/nand/sh_flctl.c                        |  2 +-
 drivers/mtd/nand/sharpsl.c                         |  4 +-
 drivers/mtd/nand/socrates_nand.c                   |  5 +-
 drivers/mtd/nand/sunxi_nand.c                      |  4 +-
 drivers/mtd/nand/tango_nand.c                      |  2 +-
 drivers/mtd/nand/tmio_nand.c                       |  4 +-
 drivers/mtd/nand/txx9ndfmc.c                       |  2 +-
 drivers/mtd/nand/vf610_nfc.c                       |  2 +-
 drivers/mtd/nand/xway_nand.c                       |  4 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         | 14 +++-
 drivers/net/geneve.c                               |  7 +-
 drivers/net/hamradio/yam.c                         |  1 +
 drivers/ntb/ntb.c                                  |  8 +-
 drivers/pci/host/pci-aardvark.c                    |  4 -
 drivers/pci/host/pcie-rcar.c                       |  9 ++-
 drivers/pci/pcie/aspm.c                            | 10 ---
 drivers/pci/pcie/ptm.c                             | 22 ++++--
 drivers/pci/probe.c                                |  5 +-
 drivers/pinctrl/freescale/pinctrl-imx.c            | 19 +----
 drivers/pinctrl/freescale/pinctrl-imx1-core.c      |  1 -
 drivers/power/supply/Kconfig                       |  2 +-
 drivers/power/supply/lp8788-charger.c              | 18 +----
 drivers/power/supply/smb347-charger.c              |  1 +
 drivers/remoteproc/remoteproc_core.c               |  3 +-
 drivers/s390/cio/qdio.h                            |  1 -
 drivers/s390/cio/qdio_setup.c                      |  1 -
 drivers/s390/cio/qdio_thinint.c                    | 14 ++--
 drivers/scsi/arm/acornscsi.c                       |  4 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |  2 +
 drivers/scsi/iscsi_boot_sysfs.c                    |  2 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  2 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  2 +
 drivers/scsi/qedi/qedi_iscsi.c                     |  7 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  2 +
 drivers/scsi/sr.c                                  |  6 +-
 drivers/scsi/ufs/ufs-qcom.c                        |  6 +-
 drivers/scsi/ufs/ufshcd.c                          |  1 -
 drivers/staging/greybus/light.c                    |  3 +-
 drivers/staging/sm750fb/sm750.c                    |  1 +
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  6 +-
 drivers/tty/hvc/hvc_console.c                      | 16 +++-
 drivers/tty/n_gsm.c                                | 26 ++++---
 drivers/tty/serial/amba-pl011.c                    |  1 +
 drivers/usb/class/usblp.c                          |  5 +-
 drivers/usb/dwc2/core_intr.c                       |  7 +-
 drivers/usb/gadget/composite.c                     | 78 +++++++++++++++----
 drivers/usb/gadget/udc/lpc32xx_udc.c               | 11 +--
 drivers/usb/gadget/udc/m66592-udc.c                |  2 +-
 drivers/usb/gadget/udc/s3c2410_udc.c               |  4 -
 drivers/usb/host/ehci-mxc.c                        |  2 +
 drivers/usb/host/ehci-platform.c                   |  5 ++
 drivers/usb/host/ohci-platform.c                   |  5 ++
 drivers/usb/host/xhci-plat.c                       | 10 ++-
 drivers/vfio/mdev/mdev_sysfs.c                     |  2 +-
 drivers/vfio/pci/vfio_pci_config.c                 | 14 +++-
 drivers/video/backlight/lp855x_bl.c                | 20 ++++-
 drivers/watchdog/da9062_wdt.c                      |  5 --
 fs/block_dev.c                                     | 12 +--
 fs/dlm/dlm_internal.h                              |  1 -
 fs/ext4/extents.c                                  |  2 +-
 fs/f2fs/super.c                                    |  3 +-
 fs/gfs2/log.c                                      | 11 ++-
 fs/gfs2/ops_fstype.c                               |  2 +-
 fs/nfs/nfs4proc.c                                  |  2 +-
 fs/nfsd/nfs4callback.c                             |  2 +
 include/linux/bitops.h                             |  2 +-
 include/linux/elfnote.h                            |  2 +-
 include/linux/genhd.h                              |  2 +
 include/linux/kprobes.h                            |  4 +
 include/linux/libata.h                             |  3 +
 include/linux/mtd/rawnand.h                        |  6 +-
 include/linux/usb/composite.h                      |  3 +
 include/uapi/linux/raid/md_p.h                     |  2 +
 kernel/kprobes.c                                   | 27 ++++++-
 kernel/trace/blktrace.c                            | 30 +++----
 lib/zlib_inflate/inffast.c                         | 91 +++++++++-------------
 net/core/dev.c                                     | 40 +++++-----
 net/sunrpc/addr.c                                  |  4 +-
 scripts/mksysmap                                   |  2 +-
 security/apparmor/label.c                          |  4 +-
 security/selinux/ss/services.c                     |  4 +
 sound/isa/wavefront/wavefront_synth.c              |  8 +-
 sound/soc/davinci/davinci-mcasp.c                  |  4 +-
 sound/soc/fsl/fsl_asrc_dma.c                       |  1 +
 sound/usb/card.h                                   |  4 +
 sound/usb/endpoint.c                               | 43 ++++++++--
 sound/usb/endpoint.h                               |  1 +
 sound/usb/pcm.c                                    |  2 +
 tools/perf/builtin-report.c                        |  3 +-
 .../networking/timestamping/timestamping.c         | 10 ++-
 tools/testing/selftests/x86/protection_keys.c      |  3 +-
 180 files changed, 824 insertions(+), 588 deletions(-)


