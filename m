Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D00B45491C
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhKQOtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:49:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238744AbhKQOtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:49:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7389461C4F;
        Wed, 17 Nov 2021 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637160407;
        bh=sM+5t7Z7LqY35LTFSFqsZX8SExCd9QES5dr8rmbQXZI=;
        h=From:To:Cc:Subject:Date:From;
        b=Rn+PPiEf4rfIB2f4Smwt+TlJG9l2APFxnIFP0pcKPJRsczIyvX3sq/1RDRCZmsdam
         uWydtHSimbG8Cf/L60/2jproUGNTSU+0zQaLZsvjuBDQBc9D9A1RMZ/RgeHLRWxfBk
         yoTmwjeJAsk+LCNKdrB+QrEbLVIXjzQn/SXOwzR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/569] 5.10.80-rc4 review
Date:   Wed, 17 Nov 2021 15:46:44 +0100
Message-Id: <20211117144602.341592498@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc4.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.80-rc4
X-KernelTest-Deadline: 2021-11-19T14:46+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.80 release.
There are 569 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 19 Nov 2021 14:44:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc4.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.80-rc4

Borislav Petkov <bp@suse.de>
    x86/sev: Make the #VC exception stacks part of the default stacks storage

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev: Add an x86 version of cc_platform_has()

Tom Lendacky <thomas.lendacky@amd.com>
    arch/cc: Introduce a function to check for confidential computing features

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Fix also no-alu32 strobemeta selftest

Colin Ian King <colin.king@canonical.com>
    mmc: moxart: Fix null pointer dereference on pointer host

Arnd Bergmann <arnd@arndb.de>
    ath10k: fix invalid dma_addr_t token assignment

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Partial revert of commit 6f9f17287e78

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix PCIe Max Payload Size setting

Pali Rohár <pali@kernel.org>
    PCI: Add PCI_EXP_DEVCTL_PAYLOAD_* macros

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: Fix macros in sun8i_csc.h

Xiaoming Ni <nixiaoming@huawei.com>
    powerpc/85xx: fix timebase sync issue when CONFIG_HOTPLUG_CPU=n

Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
    powerpc/powernv/prd: Unregister OPAL_MSG_PRD2 notifier during module unload

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: au1550nd: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: plat_nand: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: orion: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: pasemi: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: gpio: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: mpc5121: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: xway: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: ams-delta: Keep the driver compatible with on-die ECC engines

Halil Pasic <pasic@linux.ibm.com>
    s390/cio: make ccw_device_dma_* more robust

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Fix hanging ioctl caused by orphaned replies

Sven Schnelle <svens@linux.ibm.com>
    s390/tape: fix timer initialization in tape_std_assign()

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: check the subchannel validity for dev_busid

Marek Vasut <marex@denx.de>
    video: backlight: Drop maximum brightness override for brightness zero

Jack Andersen <jackoalan@gmail.com>
    mfd: dln2: Add cell for initializing DLN2 ADC

Michal Hocko <mhocko@suse.com>
    mm, oom: do not trigger out_of_memory from the #PF

Vasily Averin <vvs@virtuozzo.com>
    mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Emit stf barrier instruction sequences for BPF_NOSPEC

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/security: Add a helper to query stf_barrier type

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Validate branch ranges

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/lib: Add helper to check if offset is within conditional branch range

Vasily Averin <vvs@virtuozzo.com>
    memcg: prohibit unconditional exceeding the limit of dying tasks

Dominique Martinet <asmadeus@codewreck.org>
    9p/net: fix missing error check in p9_check_errors

Daniel Borkmann <daniel@iogearbox.net>
    net, neigh: Enable state migration between NUD_PERMANENT and NTF_USE

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: should use GFP_NOFS for directory inodes

Guo Ren <guoren@linux.alibaba.com>
    irqchip/sifive-plic: Fixup EOI failed when masked

Michael Pratt <mpratt@google.com>
    posix-cpu-timers: Clear task::posix_cputimers_work in copy_process()

Dave Jones <davej@codemonkey.org.uk>
    x86/mce: Add errata workaround for Skylake SKX37

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Fix assembly error from MIPSr2 code used within MIPS_ISA_ARCH_LEVEL

Helge Deller <deller@gmx.de>
    parisc: Fix backtrace to always include init funtion names

Arnd Bergmann <arnd@arndb.de>
    ARM: 9156/1: drop cc-option fallbacks for architecture selection

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    ARM: 9155/1: fix early early_iounmap()

Willem de Bruijn <willemb@google.com>
    selftests/net: udpgso_bench_rx: fix port argument

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix eeprom len when diagnostics not implemented

Dust Li <dust.li@linux.alibaba.com>
    net/smc: fix sk_refcnt underflow on linkdown and fallback

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    vsock: prevent unnecessary refcnt inc for nonblocking connect

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: stmmac: allow a tc-taprio base-time of zero

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: allow configure ETS bandwidth of all TCs

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix kernel crash when unload VF while it is being reset

Eric Dumazet <edumazet@google.com>
    net/sched: sch_taprio: fix undefined behavior in ktime_mono_to_any

Muchun Song <songmuchun@bytedance.com>
    seq_file: fix passing wrong private data

Dan Carpenter <dan.carpenter@oracle.com>
    gve: Fix off by one in gve_tx_timeout()

John Fastabend <john.fastabend@gmail.com>
    bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and colliding

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Remove unhash handler for BPF sockmap usage

Arnd Bergmann <arnd@arndb.de>
    arm64: pgtable: make __pte_to_phys/__phys_to_pte_val inline functions

Chengfeng Ye <cyeaa@connect.ust.hk>
    nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails

Eric Dumazet <edumazet@google.com>
    llc: fix out-of-bound array index in llc_sk_dev_hash()

Ian Rogers <irogers@google.com>
    perf bpf: Add missing free to bpf_event__print_bpf_prog_info()

Dan Carpenter <dan.carpenter@oracle.com>
    zram: off by one in read_block_state()

Miaohe Lin <linmiaohe@huawei.com>
    mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and zs_unregister_migration()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_chip_start(): fix error handling for mcp251xfd_chip_rx_int_enable()

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    mfd: core: Add missing of_node_put for loop iteration

Huang Guobin <huangguobin4@huawei.com>
    bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix duplex out of sync problem while changing settings

Chenyuan Mi <cymi20@fudan.edu.cn>
    drm/nouveau/svm: Fix refcount leak bug and missing check against null bug

Hans de Goede <hdegoede@redhat.com>
    ACPI: PMIC: Fix intel_pmic_regs_handler() read accesses

Brett Creeley <brett.creeley@intel.com>
    ice: Fix not stopping Tx queues for VFs

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    ice: Fix replacing VF hardware MAC to existing MAC filter

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: vlan: fix a UAF in vlan_dev_real_dev()

Stafford Horne <shorne@gmail.com>
    openrisc: fix SMP tlb flush NULL pointer dereference

Jakub Kicinski <kuba@kernel.org>
    ethtool: fix ethtool msg len calculation for pause stats

Maxim Kiselev <bigunclemax@gmail.com>
    net: davinci_emac: Fix interrupt pacing disable

YueHaibing <yuehaibing@huawei.com>
    xen-pciback: Fix return in pm_ctrl_init()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: xlr: Fix a resource leak in the error handling path of 'xlr_i2c_probe()'

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a regression in nfs_set_open_stateid_locked()

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Turn off target reset during issue_lip

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix gnl list corruption

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Relogin during fabric disturbance

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Changes to support FCP2 Target

Jackie Liu <liuyun01@kylinos.cn>
    ar7: fix kernel builds for compiler test

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: fix inaccurate report in WDIOC_GETTIMEOUT

Randy Dunlap <rdunlap@infradead.org>
    m68k: set a default value for MEMORY_RESERVE

Eric W. Biederman <ebiederm@xmission.com>
    signal/sh: Use force_sig(SIGKILL) instead of do_group_exit(SIGKILL)

Lars-Peter Clausen <lars@metafoo.de>
    dmaengine: dmaengine_desc_callback_valid(): Check for `callback_result`

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: fix OOB when mac header was cleared

Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
    soc: fsl: dpaa2-console: free buffer before returning from dpaa2_console_read

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: ht16k33: Fix frame buffer device blanking

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: ht16k33: Connect backlight to fbdev

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: img-ascii-lcd: Fix lock-up when displaying empty string

Alexey Gladkov <legion@kernel.org>
    Fix user namespace leak

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix an Oops in pnfs_mark_request_commit()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix up commit deadlocks

Claudiu Beznea <claudiu.beznea@microchip.com>
    dmaengine: at_xdmac: fix AT_XDMAC_CC_PERID() macro

Dan Carpenter <dan.carpenter@oracle.com>
    rtc: rv3032: fix error handling in rv3032_clkout_set_rate()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    remoteproc: Fix a memory leak in an error handling path in 'rproc_handle_vdev()'

Zev Weiss <zev@bewilderbeest.net>
    mtd: core: don't remove debugfs directory if device is in use

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    PCI: uniphier: Serialize INTx masking/unmasking and fix the bit operation

Evgeny Novikov <novikov@ispras.ru>
    mtd: spi-nor: hisi-sfc: Remove excessive clk_disable_unprepare()

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: orangefs: fix error return code of orangefs_revalidate_lookup()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix deadlocks in nfs_scan_commit_list()

YueHaibing <yuehaibing@huawei.com>
    opp: Fix return in _opp_add_static_v2()

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix preserving PCI_EXP_RTCTL_CRSSVE flag on emulated bridge

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Don't spam about PIO Response Status

Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
    drm/plane-helper: fix uninitialized variable reference

Baptiste Lepers <baptiste.lepers@gmail.com>
    pnfs/flexfiles: Fix misplaced barrier in nfs4_ff_layout_prepare_ds

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix dentry verifier races

Kewei Xu <kewei.xu@mediatek.com>
    i2c: mediatek: fixing the incorrect register offset

J. Bruce Fields <bfields@redhat.com>
    nfsd: don't alloc under spinlock in rpc_parse_scope_id

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    rpmsg: Fix rpmsg_create_ept return when RPMSG config is not defined

Tom Rix <trix@redhat.com>
    apparmor: fix error check

Hans de Goede <hdegoede@redhat.com>
    power: supply: bq27xxx: Fix kernel crash on IRQ handler register error

Geert Uytterhoeven <geert+renesas@glider.be>
    mips: cm: Convert to bitfield API to fix out-of-bounds access

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio_ring: check desc == NULL when using indirect with packed

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Correct configuring of switch inversion from ts-inv

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Use device_property API instead of of_property

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs42l42: Disable regulators if probe fails

Bixuan Cui <cuibixuan@linux.alibaba.com>
    powerpc/44x/fsp2: add missing of_node_put

Andrej Shadura <andrew.shadura@collabora.co.uk>
    HID: u2fzero: properly handle timeouts in usb_submit_urb

Andrej Shadura <andrew.shadura@collabora.co.uk>
    HID: u2fzero: clarify error check and length calculations

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: sam9x60-pll: use DIV_ROUND_CLOSEST_ULL

Anssi Hannula <anssi.hannula@bitwise.fi>
    serial: xilinx_uartps: Fix race condition causing stuck TX

Sandeep Maheswaram <quic_c_sanm@quicinc.com>
    phy: qcom-snps: Correct the FSEL_MASK

Dan Carpenter <dan.carpenter@oracle.com>
    phy: ti: gmii-sel: check of_get_address() for failure

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    phy: qcom-qusb2: Fix a memory leak on probe

Rahul Tanwar <rtanwar@maxlinear.com>
    pinctrl: equilibrium: Fix function addition in multiple groups

Wan Jiabing <wanjiabing@vivo.com>
    soc: qcom: apr: Add of_node_put() before return

Guru Das Srinagesh <quic_gurus@quicinc.com>
    firmware: qcom_scm: Fix error retval in __qcom_scm_is_call_available()

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: drd: reset current session before setting the new one

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: drd: fix dwc2_drd_role_sw_set when clock could be disabled

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: drd: fix dwc2_force_mode call in dwc2_ovr_init

Stefan Agner <stefan@agner.ch>
    serial: imx: fix detach/attach of serial console

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    scsi: ufs: ufshcd-pltfrm: Fix memory leak due to probe defer

Can Guo <cang@codeaurora.org>
    scsi: ufs: Refactor ufshcd_setup_clocks() to remove skip_ref_clk

Nuno Sá <nuno.sa@analog.com>
    iio: adis: do not disabe IRQs in 'adis_init()'

Randy Dunlap <rdunlap@infradead.org>
    usb: typec: STUSB160X should select REGMAP_I2C

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: rpmhpd: Make power_on actually enable the domain

Lee Jones <lee.jones@linaro.org>
    soc: qcom: rpmhpd: Provide some missing struct member descriptions

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Defer probe if request_threaded_irq() returns EPROBE_DEFER

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Correct some register default values

Olivier Moysan <olivier.moysan@foss.st.com>
    ARM: dts: stm32: fix AV96 board SAI2 pin muxing on stm32mp15

Olivier Moysan <olivier.moysan@foss.st.com>
    ARM: dts: stm32: fix SAI sub nodes register range

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Reduce DHCOR SPI NOR frequency to 50 MHz

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: checker: Fix off-by-one bug in drive register check

Vegard Nossum <vegard.nossum@oracle.com>
    staging: ks7010: select CRYPTO_HASH/CRYPTO_MICHAEL_MIC

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    staging: most: dim2: do not double-register the same device

Randy Dunlap <rdunlap@infradead.org>
    usb: musb: select GENERIC_PHY instead of depending on it

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Return missed an error if device doesn't support steering

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()

Yang Yingliang <yangyingliang@huawei.com>
    power: supply: max17040: fix null-ptr-deref in max17040_probe()

Jakob Hauser <jahau@rocketmail.com>
    power: supply: rt5033_battery: Change voltage values to µV

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: hid: fix error code in do_config()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_dw: Drop wrong use of ACPI_PTR()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc: fix unbalanced node refcount in check_kvm_guest()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Fix is_kvm_guest() / kvm_para_available()

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc: Reintroduce is_kvm_guest() as a fast-path check

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc: Rename is_kvm_guest() to check_kvm_guest()

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc: Refactor is_kvm_guest() declaration to new header

Christophe Leroy <christophe.leroy@csgroup.eu>
    video: fbdev: chipsfb: use memset_io() instead of memset()

Clément Léger <clement.leger@bootlin.com>
    clk: at91: check pmc node status before registering syscore ops

Dongliang Mu <mudongliangabcd@gmail.com>
    memory: fsl_ifc: fix leak of irq and nand_irq in fsl_ifc_ctrl_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    soc/tegra: Fix an error handling path in tegra_powergate_power_up()

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: topology: do not power down primary core during topology removal

Andreas Kemnade <andreas@kemnade.info>
    arm: dts: omap3-gta04a4: accelerometer irq fix

Yang Yingliang <yangyingliang@huawei.com>
    driver core: Fix possible memory leak in device_link_add()

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Fix misleading log statement in pm8001_mpi_get_nvmd_resp()

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: debugfs: use controller id and link_id for debugfs

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Use position buffer for SKL+ again

Imre Deak <imre.deak@intel.com>
    ALSA: hda: Fix hang during shutdown due to link reset

Imre Deak <imre.deak@intel.com>
    ALSA: hda: Release controller display power during shutdown/reboot

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Reduce udelay() at SKL+ position reporting

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: pm8916: Remove wrong reg-names for rtc@6000

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: beacon: Fix Ethernet PHY mode

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Fix Secondary MI2S bit clock

Dongliang Mu <mudongliangabcd@gmail.com>
    JFS: fix memleak in jfs_mount

Jackie Liu <liuyun01@kylinos.cn>
    MIPS: loongson64: make CPU_LOONGSON64 depends on MIPS_FP_SUPPORT

Tong Zhang <ztong0001@gmail.com>
    scsi: dc395: Fix error case unwinding

Peter Rosin <peda@axentia.se>
    ARM: dts: at91: tse850: the emac<->phy interface is rmii

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix timekeeping_suspended warning on resume

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: meson-g12b: Fix the pwm regulator supply properties

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: meson-g12a: Fix the pwm regulator supply properties

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: k3-j721e-main: Fix "bus-range" upto 256 bus number for PCIe

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: k3-j721e-main: Fix "max-virtual-functions" in PCIe EP nodes

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix query SRQ failure

Marijn Suijten <marijn.suijten@somainline.org>
    ARM: dts: qcom: msm8974: Add xo_board reference clock to DSI0 PHY

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: Fix GPU register width for RK3328

Jackie Liu <liuyun01@kylinos.cn>
    ARM: s3c: irq-s3c24xx: Fix return value check for s3c24xx_init_intc()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    clk: mvebu: ap-cpu-clk: Fix a memory leak in error handling paths

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: Fix memory nodes names

Junji Wei <weijunji@bytedance.com>
    RDMA/rxe: Fix wrong port_cap_flags

Alexandru Ardelean <aardelean@deviqon.com>
    iio: st_sensors: disable regulators after device unregistration

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: st_sensors: Call st_sensors_power_enable() from bus drivers

Frank Rowand <frank.rowand@sony.com>
    of: unittest: fix EXPECT text for gpio hog errors

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix propagation of signed bounds from 64-bit min/max into 32-bit.

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix propagation of bounds from 64-bit min/max into 32-bit and var_off.

Dan Schatzberg <schatzberg.dan@gmail.com>
    cgroup: Fix rootcg cpu.stat guest double counting

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: Process crqs after enabling interrupts

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: don't stop queue in xmit

Jakub Kicinski <kuba@kernel.org>
    udp6: allow SO_MARK ctrl msg to affect routing

Andrea Righi <andrea.righi@canonical.com>
    selftests/bpf: Fix fclose/pclose mismatch in test_progs

Daniel Jordan <daniel.m.jordan@oracle.com>
    crypto: pcrypt - Delay write to padata->info

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: avoid mvneta warning when setting pause parameters

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Toggle PLL settings during rate change

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    selftests/bpf: Fix fd cleanup in sk_lookup test

Lorenz Bauer <lmb@cloudflare.com>
    selftests: bpf: Convert sk_lookup ctx access tests to PROG_TEST_RUN

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gmc6: fix DMA mask from 44 to 40 bits

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix discarded frames due to wrong sequence number

Benjamin Li <benl@squareup.com>
    wcn36xx: add proper DMA memory barriers in rx path

Wang Hai <wanghai38@huawei.com>
    libertas: Fix possible memory leak in probe and disconnect

Wang Hai <wanghai38@huawei.com>
    libertas_tf: Fix possible memory leak in probe and disconnect

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: Fix handle_sske page fault handling

Tiezhu Yang <yangtiezhu@loongson.cn>
    samples/kretprobes: Fix return value if register_kretprobe() failed

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    spi: spi-rpc-if: Check return value of rpcif_sw_init()

Jon Maxwell <jmaxwell37@gmail.com>
    tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()

Ilya Leoshkevich <iii@linux.ibm.com>
    libbpf: Fix endianness detection in BPF_CORE_READ_BITFIELD_PROBED()

Mark Brown <broonie@kernel.org>
    tpm_tis_spi: Add missing SPI ID

Hao Wu <hao.wu@rubrik.com>
    tpm: fix Atmel TPM crash caused by too frequent queries

Mark Rutland <mark.rutland@arm.com>
    irq: mips: avoid nested irq_enter()

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: pv: avoid stalls for kvm_s390_pv_init_vm

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: pv: avoid double free of sida page

David Hildenbrand <david@redhat.com>
    s390/gmap: don't unconditionally call pte_unmap_unlock() in __gmap_zap()

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix BTF header parsing checks

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix overflow in BTF sanity checks

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Allow loading empty BTFs

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix BTF data layout checks and allow empty BTF

Quentin Monnet <quentin@isovalent.com>
    bpftool: Avoid leaking the JSON writer prepared for program metadata

Jim Mattson <jmattson@google.com>
    KVM: selftests: Fix nested SVM tests when built with clang

Ricardo Koller <ricarkol@google.com>
    KVM: selftests: Add operand to vmsave/vmload/vmrun in svm.c

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: use netlbl_cfg_cipsov4_del() for deleting cipso_v4_doi

Jessica Zhang <jesszhan@codeaurora.org>
    drm/msm: Fix potential NULL dereference in DPU SSPP

Joerg Roedel <jroedel@suse.de>
    x86/sev: Fix stack type check in vc_switch_off_ist()

Kees Cook <keescook@chromium.org>
    clocksource/drivers/timer-ti-dm: Select TIMER_OF

Anders Roxell <anders.roxell@linaro.org>
    PM: hibernate: fix sparse warnings

Max Gurtovoy <mgurtovoy@nvidia.com>
    nvme-rdma: fix error code in nvme_rdma_setup_ctrl

Stefan Agner <stefan@agner.ch>
    phy: micrel: ksz8041nl: do not use power down mode

Tim Gardner <tim.gardner@canonical.com>
    net: enetc: unmap DMA in enetc_send_cmd()

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Send DELBA requests according to spec

Ziyang Xuan <william.xuanziyang@huawei.com>
    rsi: stop thread firstly in rsi_91x_init() error handling

Shayne Chen <shayne.chen@mediatek.com>
    mt76: mt7915: fix muar_idx in mt7915_mcu_alloc_sta_req()

Shayne Chen <shayne.chen@mediatek.com>
    mt76: mt7915: fix sta_rec_wtbl tag len

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: fix possible infinite loop release semaphore

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt76x02: fix endianness warnings in mt76x02_mac.c

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix endianness warning in mt7615_mac_write_txwi

Nathan Chancellor <nathan@kernel.org>
    platform/x86: thinkpad_acpi: Fix bitwise vs. logical warning

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: mxs-mmc: disable regulator on error and in the remove function

Sean Young <sean@mess.org>
    media: ir_toy: assignment to be16 should be of correct type

Jakub Kicinski <kuba@kernel.org>
    net: stream: don't purge sk_error_queue in sk_stream_kill_queues()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: uninitialized variable in msm_gem_import()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: potential error pointer dereference in init()

Eric Dumazet <edumazet@google.com>
    tcp: switch orphan_count to bare per-cpu counters

Zhang Qiao <zhangqiao22@huawei.com>
    kernel/sched: Fix sched_fork() access an invalid sched_task_group

Sven Eckelmann <seckelmann@datto.com>
    ath10k: fix max antenna gain unit

Zev Weiss <zev@bewilderbeest.net>
    hwmon: (pmbus/lm25066) Let compiler determine outer dimension of lm25066_coeff

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: Fix possible memleak in __hwmon_device_register()

Daniel Borkmann <daniel@iogearbox.net>
    net, neigh: Fix NTF_EXT_LEARNED in combination with NTF_USE

Dan Carpenter <dan.carpenter@oracle.com>
    memstick: jmb38x_ms: use appropriate free function in jmb38x_ms_alloc_host()

Arnd Bergmann <arnd@arndb.de>
    memstick: avoid out-of-range warning

Tony Lindgren <tony@atomide.com>
    mmc: sdhci-omap: Fix context restore

Tony Lindgren <tony@atomide.com>
    mmc: sdhci-omap: Fix NULL pointer exception if regulator is not configured

John Fraker <jfraker@google.com>
    gve: Recover from queue stall due to missed IRQ

Dan Carpenter <dan.carpenter@oracle.com>
    b43: fix a lower bounds test

Dan Carpenter <dan.carpenter@oracle.com>
    b43legacy: fix a lower bounds test

Markus Schneider-Pargmann <msp@baylibre.com>
    hwrng: mtk - Force runtime pm ops for sleep ops

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - disregard spurious PFVF interrupts

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - detect PFVF collision after ACK

Evgeny Novikov <novikov@ispras.ru>
    media: dvb-frontends: mn88443x: Handle errors of clk_prepare_enable()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: relax superfluous check on set updates

Peter Zijlstra <peterz@infradead.org>
    rcu: Always inline rcu_dynticks_task*_{enter,exit}()

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/amd64: Handle three rank interleaving mode

Vincent Donnefort <vincent.donnefort@arm.com>
    PM: EM: Fix inefficient states detection

Linus Lüssing <ll@simonwunderlich.de>
    ath9k: Fix potential interrupt storm on queue reset

Colin Ian King <colin.king@canonical.com>
    media: em28xx: Don't use ops->suspend if it is NULL

Anel Orazgaliyeva <anelkz@amazon.de>
    cpuidle: Fix kobject memory leaks in error paths

Arnd Bergmann <arnd@arndb.de>
    crypto: ecc - fix CRYPTO_DEFAULT_RNG dependency

Punit Agrawal <punitagrawal@gmail.com>
    kprobes: Do not use local variable when creating debugfs file

Colin Ian King <colin.king@canonical.com>
    media: cx23885: Fix snd_card_free call on null card pointer

Kees Cook <keescook@chromium.org>
    media: tm6000: Avoid card name truncation

Kees Cook <keescook@chromium.org>
    media: si470x: Avoid card name truncation

Kees Cook <keescook@chromium.org>
    media: radio-wl1273: Avoid card name truncation

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: mtk-vpu: Fix a resource leak in the error handling path of 'mtk_vpu_probe()'

Tom Rix <trix@redhat.com>
    media: TDA1997x: handle short reads of hdmi info frame.

Ricardo Ribalda <ribalda@chromium.org>
    media: v4l2-ioctl: S_CTRL output the right value

Pavel Skripkin <paskripkin@gmail.com>
    media: dvb-usb: fix ununit-value in az6027_rc_query

Colin Ian King <colin.king@canonical.com>
    media: cxd2880-spi: Fix a null pointer dereference on error handling path

Pavel Skripkin <paskripkin@gmail.com>
    media: em28xx: add missing em28xx_close_extension

Arnd Bergmann <arnd@arndb.de>
    drm/amdgpu: fix warning for overflow check

Sudarshan Rajagopalan <quic_sudaraja@quicinc.com>
    arm64: mm: update max_pfn after memory hotplug

Matthew Auld <matthew.auld@intel.com>
    drm/ttm: stop calling tt_swapin in vm_access

Fabio Estevam <festevam@denx.de>
    ath10k: sdio: Add missing BH locking around napi_schdule()

Loic Poulain <loic.poulain@linaro.org>
    ath10k: Fix missing frame timestamp for beacon/probe-resp

Baochen Qiang <bqiang@codeaurora.org>
    ath11k: Fix memory leak in ath11k_qmi_driver_event_work

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
    ath11k: fix packet drops due to incorrect 6 GHz freq value in rx status

Sriram R <srirrama@codeaurora.org>
    ath11k: Avoid race during regd updates

Dan Carpenter <dan.carpenter@oracle.com>
    ath11k: fix some sleeping in atomic bugs

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366rb: Fix off-by-one bug

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies()

Michael Walle <michael@walle.cc>
    crypto: caam - disable pkc for non-E SoCs

Dinghao Liu <dinghao.liu@zju.edu.cn>
    Bluetooth: btmtkuart: fix a memleak in mtk_hci_wmt_sync

Ajay Singh <ajay.kathat@microchip.com>
    wilc1000: fix possible memory leak in cfg_scan_result()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Fix Antenna Diversity Switching

Waiman Long <longman@redhat.com>
    cgroup: Make rebind_subsystems() disable v2 controllers all at once

Yajun Deng <yajun.deng@linux.dev>
    net: net_namespace: Fix undefined member in key_remove_domain()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    lockdep: Let lock_is_held_type() detect recursive read as read

liuyuntao <liuyuntao10@huawei.com>
    virtio-gpu: fix possible memory allocation failure

Iago Toral Quiroga <itoral@igalia.com>
    drm/v3d: fix wait for TMU write combiner flush

Peter Zijlstra <peterz@infradead.org>
    objtool: Fix static_call list generation

Peter Zijlstra <peterz@infradead.org>
    x86/xen: Mark cpu_bringup_and_idle() as dead_end_function

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Add xen_start_kernel() to noreturn list

Aleksander Jan Bajkowski <olek2@wp.pl>
    MIPS: lantiq: dma: fix burst length for DEU

Neeraj Upadhyay <neeraju@codeaurora.org>
    rcu: Fix existing exp request check in sync_sched_exp_online_cleanup()

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: fix init and cleanup of sco_conn.timeout_work

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Fix strobemeta selftest regression

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: set on IPS_ASSURED if flows enters internal stream state

Sven Schnelle <svens@stackframe.org>
    parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling

Sven Schnelle <svens@stackframe.org>
    parisc/unwind: fix unwinder when CONFIG_64BIT is enabled

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: don't trigger WARN() when decompression fails

Helge Deller <deller@gmx.de>
    task_stack: Fix end_of_stack() for architectures with upwards-growing stack

Sven Schnelle <svens@stackframe.org>
    parisc: fix warning in flush_tlb_all

Shuah Khan <skhan@linuxfoundation.org>
    selftests/core: fix conflicting types compile error for close_range()

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/display: dcn20_resource_construct reduce scope of FPU enabled

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/hyperv: Protect set_hv_tscchange_cb() against getting preempted

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Correct band/freq reporting on RX

Yang Yingliang <yangyingliang@huawei.com>
    spi: bcm-qspi: Fix missing clk_disable_unprepare() on error in bcm_qspi_probe()

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not take the uuid_mutex in btrfs_rm_device

Sidong Yang <realwakka@gmail.com>
    btrfs: reflink: initialize return value to 0 in btrfs_extent_same()

Stefan Schaeckeler <schaecsn@gmx.net>
    ACPI: AC: Quirk GK45 to skip reading _PSR

Eric Dumazet <edumazet@google.com>
    net: annotate data-race in neigh_output()

Florian Westphal <fw@strlen.de>
    vrf: run conntrack only in context of lower/physdev for locally generated packets

Arnd Bergmann <arnd@arndb.de>
    ARM: 9136/1: ARMv7-M uses BE-8, not BE-32

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix glock_hash_walk bugs

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Cancel remote delete work asynchronously

Stephen Suryaputra <ssuryaextr@gmail.com>
    gre/sit: Don't generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE

Masami Hiramatsu <mhiramat@kernel.org>
    ARM: clang: Do not rely on lr register for stacktrace

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: use __GFP_NOFAIL for smk_cipso_doi()

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: disable RX-diversity in powersave

Jiri Olsa <jolsa@redhat.com>
    selftests/bpf: Fix perf_buffer test on system with offline cpus

Shuah Khan <skhan@linuxfoundation.org>
    selftests: kvm: fix mismatched fclose() after popen()

Ye Bin <yebin10@huawei.com>
    PM: hibernate: Get block device exclusively in swsusp_check()

Hannes Reinecke <hare@suse.de>
    nvme: drop scan_lock and always kick requeue list when removing namespaces

Israel Rukshin <israelr@nvidia.com>
    nvmet-tcp: fix use-after-free when a port is removed

Israel Rukshin <israelr@nvidia.com>
    nvmet-rdma: fix use-after-free when a port is removed

Israel Rukshin <israelr@nvidia.com>
    nvmet: fix use-after-free when a port is removed

Michael Tretter <m.tretter@pengutronix.de>
    media: allegro: ignore interrupt if mailbox is not initialized

Jens Axboe <axboe@kernel.dk>
    block: remove inaccurate requeue check

Zheyu Ma <zheyuma97@gmail.com>
    mwl8k: Fix use-after-free in mwl8k_fw_state_machine()

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7915: fix an off-by-one bound check

Kalesh Singh <kaleshsingh@google.com>
    tracing/cfi: Fix cmp_entries_* functions signature mismatch

Menglong Dong <imagedong@tencent.com>
    workqueue: make sysfs of unbound kworker cpumask more clever

Lasse Collin <lasse.collin@tukaani.org>
    lib/xz: Validate the value before assigning it to an enum variable

Lasse Collin <lasse.collin@tukaani.org>
    lib/xz: Avoid overlapping memcpy() with invalid input with in-place decompression

Zheyu Ma <zheyuma97@gmail.com>
    memstick: r592: Fix a UAF bug when removing the driver

Xiao Ni <xni@redhat.com>
    md: update superblock after changing rdev flags in state_store

Jens Axboe <axboe@kernel.dk>
    block: bump max plugged deferred size from 16 to 32

Tim Gardner <tim.gardner@canonical.com>
    drm/msm: prevent NULL dereference in msm_gpu_crashstate_capture()

Kees Cook <keescook@chromium.org>
    leaking_addresses: Always print a trailing newline

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    net: phy: micrel: make *-skew-ps check more lenient

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdkfd: fix resume error when iommu disabled in Picasso

André Almeida <andrealmeid@collabora.com>
    ACPI: battery: Accept charges over the design capacity as full

Andreas Gruenbacher <agruenba@redhat.com>
    iov_iter: Fix iov_iter_get_pages{,_alloc} page fault return value

Xin Xiong <xiongx18@fudan.edu.cn>
    mmc: moxart: Fix reference count leaks in moxart_probe

Tuo Li <islituo@gmail.com>
    ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Have tracefs directories not set OTH permission bits by default

Antoine Tenart <atenart@kernel.org>
    net-sysfs: try not to restart the syscall if it will fail eventually

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    media: usb: dvd-usb: fix uninit-value bug in dibusb_read_eeprom_byte()

Ricardo Ribalda <ribalda@chromium.org>
    media: ipu3-imgu: VIDIOC_QUERYCAP: Fix bus_info

Ricardo Ribalda <ribalda@chromium.org>
    media: ipu3-imgu: imgu_fmt: Handle properly try

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Avoid evaluating methods too early during system resume

Josh Don <joshdon@google.com>
    fs/proc/uptime.c: Fix idle time reporting in /proc/uptime

Corey Minyard <cminyard@mvista.com>
    ipmi: Disable some operations during a panic

Nadezda Lutovinova <lutovinova@ispras.ru>
    media: rcar-csi2: Add checking to rcsi2_start_receiver()

Hans de Goede <hdegoede@redhat.com>
    brcmfmac: Add DMI nvram filename quirk for Cyberbook T116 tablet

Zong-Zhe Yang <kevin_yang@realtek.com>
    rtw88: fix RX clock gate setting while fifo dump

Randy Dunlap <rdunlap@infradead.org>
    ia64: don't do IA64_CMPXCHG_DEBUG without CONFIG_PRINTK

Rajat Asthana <rajatasthana4@gmail.com>
    media: mceusb: return without resubmitting URB in case of -EPROTO error.

Martin Kepplinger <martink@posteo.de>
    media: imx: set a media_device bus_info string

Nadezda Lutovinova <lutovinova@ispras.ru>
    media: s5p-mfc: Add checking to s5p_mfc_probe().

Tuo Li <islituo@gmail.com>
    media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Set unique vdev name based in type

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Return -EIO for control errors

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Set capability in s_param

Dmitriy Ulitin <ulitin@ispras.ru>
    media: stm32: Potential NULL pointer dereference in dcmi_irq_thread()

Evgeny Novikov <novikov@ispras.ru>
    media: atomisp: Fix error handling in probe

Zheyu Ma <zheyuma97@gmail.com>
    media: netup_unidvb: handle interrupt properly according to the firmware

Dirk Bender <d.bender@phytec.de>
    media: mt9p031: Fix corrupted frame after restarting stream

Alagu Sankar <alagusankar@silex-india.com>
    ath10k: high latency fixes for beacon buffer

Baochen Qiang <bqiang@codeaurora.org>
    ath11k: Change DMA_FROM_DEVICE to DMA_TO_DEVICE when map reinjected packets

Wen Gong <wgong@codeaurora.org>
    ath11k: add handler for scan event WMI_SCAN_EVENT_DEQUEUED

Sriram R <srirrama@codeaurora.org>
    ath11k: Avoid reg rules update during firmware recovery

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amdgpu: Fix MMIO access page fault

Eric Biggers <ebiggers@google.com>
    fscrypt: allow 256-bit master keys with AES-256-XTS

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Properly initialize private structure on interface type changes

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type

Peter Zijlstra <peterz@infradead.org>
    x86: Increase exception stack sizes

Seevalamuthu Mariappan <seevalam@codeaurora.org>
    ath11k: Align bss_chan_info structure with firmware

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    smackfs: Fix use-after-free in netlbl_catmap_walk()

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Move RTGS_WAIT_CBS to beginning of rcu_tasks_kthread() loop

Jakub Kicinski <kuba@kernel.org>
    net: sched: update default qdisc visibility after Tx queue cnt changes

Peter Zijlstra <peterz@infradead.org>
    locking/lockdep: Avoid RCU-induced noinstr fail

Aleksander Jan Bajkowski <olek2@wp.pl>
    MIPS: lantiq: dma: reset correct number of channel

Aleksander Jan Bajkowski <olek2@wp.pl>
    MIPS: lantiq: dma: add small delay after reset

Barnabás Pőcze <pobrn@protonmail.com>
    platform/x86: wmi: do not fail if disabling fails

Scott Wood <swood@redhat.com>
    rcutorture: Avoid problematic critical section nesting on PREEMPT_RT

Simon Ser <contact@emersion.fr>
    drm/panel-orientation-quirks: add Valve Steam Deck

Wang ShaoBo <bobo.shaobowang@huawei.com>
    Bluetooth: fix use-after-free error in lock_sock_nested()

Takashi Iwai <tiwai@suse.de>
    Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for the Samsung Galaxy Book 10.6

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for KD Kurio Smart C15200 2-in-1

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Update the Lenovo Ideapad D330 quirk (v2)

Charan Teja Reddy <charante@codeaurora.org>
    dma-buf: WARN on dmabuf release with pending attachments

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    power: supply: max17042_battery: Clear status bits in interrupt handler

Johan Hovold <johan@kernel.org>
    USB: chipidea: fix interrupt deadlock

Johan Hovold <johan@kernel.org>
    USB: iowarrior: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    most: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    serial: 8250: fix racy uartclk update

Wang Hai <wanghai38@huawei.com>
    USB: serial: keyspan: fix memleak on probe errors

Nuno Sá <nuno.sa@analog.com>
    iio: ad5770r: make devicetree property reading consistent

Pekka Korpinen <pekka.korpinen@iki.fi>
    iio: dac: ad5446: Fix ad5622_write() return value

Tao Zhang <quic_taozha@quicinc.com>
    coresight: cti: Correct the parameter for pm_runtime_put

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: core: fix possible memory leak in pinctrl_enable()

Zhang Yi <yi.zhang@huawei.com>
    quota: correct error number in free_dqentry()

Zhang Yi <yi.zhang@huawei.com>
    quota: check block number when reading the block in quota file

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Set PCI Bridge Class Code to PCI Bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for bus mastering and PCI_COMMAND on emulated bridge

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Read all 16-bits from PCIE_MSI_PAYLOAD_REG

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Fix return value of MSI domain .alloc() method

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix configuring Reference clock

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reporting Data Link Layer Link Active

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Do not unmask unused interrupts

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix checking for link up via LTSSM state

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Do not clear status bits of masked interrupts

Li Chen <lchen@ambarella.com>
    PCI: cadence: Add cdns_plat_pcie_probe() missing return

Marek Behún <kabel@kernel.org>
    PCI: pci-bridge-emul: Fix emulation of W1C bits

yangerkun <yangerkun@huawei.com>
    ovl: fix use after free in struct ovl_aio_req

Juergen Gross <jgross@suse.com>
    xen/balloon: add late_initcall_sync() for initial ballooning done

Pavel Skripkin <paskripkin@gmail.com>
    ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume

Takashi Iwai <tiwai@suse.de>
    ALSA: mixer: oss: Fix racy access to slots

Arnd Bergmann <arnd@arndb.de>
    ifb: fix building without CONFIG_NET_CLS_ACT

Pali Rohár <pali@kernel.org>
    serial: core: Fix initializing and restoring termios speed

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ring-buffer: Protect ring_buffer_reset() from reentrancy

Xiaoming Ni <nixiaoming@huawei.com>
    powerpc/85xx: Fix oops when mpc85xx_smp_guts_ids node cannot be found

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_can_recv(): ignore messages with invalid source address

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_tp_cmd_recv(): ignore abort message in the BAM transport

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Query current VMCS when determining if MSR bitmaps are in use

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Extract ESR_ELx.EC only

Henrik Grimler <henrik@grimler.se>
    power: supply: max17042_battery: use VFSOC for capacity when no rsns

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    power: supply: max17042_battery: Prevent int underflow in set_soc_threshold

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: socrates: Keep the driver compatible with on-die ECC engines

Meng Li <Meng.Li@windriver.com>
    soc: fsl: dpio: use the combined functions to protect critical zone

Meng Li <Meng.Li@windriver.com>
    soc: fsl: dpio: replace smp_processor_id with raw_smp_processor_id

Eric W. Biederman <ebiederm@xmission.com>
    signal/mips: Update (_save|_restore)_fp_context to fail with -EFAULT

Wolfram Sang <wsa+renesas@sang-engineering.com>
    memory: renesas-rpc-if: Correct QSPI data transfer in Manual mode

Eric W. Biederman <ebiederm@xmission.com>
    signal: Remove the bogus sigkill_pending in ptrace_stop

Alok Prasad <palok@marvell.com>
    RDMA/qedr: Fix NULL deref for query_qp on the GSI QP

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix Intel ICX IIO event constraints

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Support extra IMC channel on Ice Lake server

Marek Vasut <marex@denx.de>
    rsi: Fix module dev_oper_mode parameter description

Martin Fuzzey <martin.fuzzey@flowbird.group>
    rsi: fix rate mask set leading to P2P failure

Martin Fuzzey <martin.fuzzey@flowbird.group>
    rsi: fix key enabled check causing unwanted encryption for vap_id > 0

Martin Fuzzey <martin.fuzzey@flowbird.group>
    rsi: fix occasional initialisation failure with BT coex

Benjamin Li <benl@squareup.com>
    wcn36xx: handle connection loss indication

Reimar Döffinger <Reimar.Doeffinger@gmx.de>
    libata: fix checking of DMA state

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Try waking the firmware until we get an interrupt

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Read a PCI register after writing the TX ring write pointer

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Do not let "syscore" devices runtime-suspend during system transitions

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix (QoS) null data frame bitrate/modulation

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix tx_status mechanism

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix HT40 capability for 2Ghz band

Lukas Wunner <lukas@wunner.de>
    ifb: Depend on netfilter alternatively to tc

Austin Kim <austin.kim@lge.com>
    evm: mark evm_fixmode as __ro_after_init

Johan Hovold <johan@kernel.org>
    rtl8187: fix control-message timeouts

Ingmar Klein <ingmar_klein@web.de>
    PCI: Mark Atheros QCA6174 to avoid bus reset

Johan Hovold <johan@kernel.org>
    ath10k: fix division by zero in send path

Johan Hovold <johan@kernel.org>
    ath10k: fix control-message timeout

Johan Hovold <johan@kernel.org>
    ath6kl: fix control-message timeout

Johan Hovold <johan@kernel.org>
    ath6kl: fix division by zero in send path

Johan Hovold <johan@kernel.org>
    mwifiex: fix division by zero in fw download path

Eric Badger <ebadger@purestorage.com>
    EDAC/sb_edac: Fix top-of-high-memory value for Broadwell/Haswell

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    regulator: dt-bindings: samsung,s5m8767: correct s5m8767,pmic-buck-default-dvs-idx property

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    regulator: s5m8767: do not use reset value as DVS voltage if GPIO DVS is disabled

Zev Weiss <zev@bewilderbeest.net>
    hwmon: (pmbus/lm25066) Add offset coefficients

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix race condition when computing ocontext SIDs

Masami Hiramatsu <mhiramat@kernel.org>
    ia64: kprobes: Fix to pass correct trampoline address to the handler

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Unregister posted interrupt wakeup handler on hardware unsetup

Anand Jain <anand.jain@oracle.com>
    btrfs: call btrfs_check_rw_degradable only if there is a missing device

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error handling when replaying directory deletes

Li Zhang <zhanglikernel@gmail.com>
    btrfs: clear MISSING device status bit in btrfs_close_one_device

Christoph Hellwig <hch@lst.de>
    rds: stop using dmapool

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Correct spelling mistake to TCPF_SYN_RECV

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Fix smc_link->llc_testlink_time overflow

Yu Xiao <yu.xiao@corigine.com>
    nfp: bpf: relax prog rejection for mtu check through max_pkt_offset

Dongli Zhang <dongli.zhang@oracle.com>
    vmxnet3: do not stop tx queues after netif_device_detach()

Janghyub Seo <jhyub06@gmail.com>
    r8169: Add device 10ec:8162 to driver r8169

Amit Engel <amit.engel@dell.com>
    nvmet-tcp: fix header digest verification

Naohiro Aota <naohiro.aota@wdc.com>
    block: schedule queue restart after BLK_STS_ZONE_RESOURCE

Mario <awxkrnl@gmail.com>
    drm: panel-orientation-quirks: Add quirk for GPD Win3

Walter Stoll <walter.stoll@duagon.com>
    watchdog: Fix OMAP watchdog early handling

Cyril Strejc <cyril.strejc@skoda.cz>
    net: multicast: calculate csum of looped-back and forwarded packets

Thomas Perrot <thomas.perrot@bootlin.com>
    spi: spl022: fix Microwire full duplex mode

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: fix a memory leak when releasing a queue

Dongli Zhang <dongli.zhang@oracle.com>
    xen/netfront: stop tx queues during live migration

Asmaa Mnebhi <asmaa@nvidia.com>
    gpio: mlxbf2.c: Add check for bgpio_init failure

Lorenz Bauer <lmb@cloudflare.com>
    bpf: Prevent increasing bpf_jit_limit above max

Lorenz Bauer <lmb@cloudflare.com>
    bpf: Define bpf_jit_alloc_exec_limit for arm64 JIT

Florian Westphal <fw@strlen.de>
    fcnal-test: kill hanging ping/nettest binaries on cleanup

Bryant Mairs <bryant@mai.rs>
    drm: panel-orientation-quirks: Add quirk for Aya Neo 2021

Randy Dunlap <rdunlap@infradead.org>
    mmc: winbond: don't build on M68K

Paweł Anikiel <pan@semihalf.com>
    reset: socfpga: add empty driver allowing consumers to probe

Bastien Roucariès <rouca@debian.org>
    ARM: dts: sun7i: A20-olinuxino-lime2: Fix ethernet phy-mode

Arnd Bergmann <arnd@arndb.de>
    hyperv/vmbus: include linux/bitops.h

Erik Ekman <erik@kryo.se>
    sfc: Don't use netif_info before net_device setup

Erik Ekman <erik@kryo.se>
    sfc: Export fibre-specific supported link modes

Zheyu Ma <zheyuma97@gmail.com>
    cavium: Fix return values of the probe function

Zheyu Ma <zheyuma97@gmail.com>
    mISDN: Fix return values of the probe function

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: qla2xxx: Fix unmap of already freed sgl

Zheyu Ma <zheyuma97@gmail.com>
    scsi: qla2xxx: Return -ENOMEM if kzalloc() fails

Zheyu Ma <zheyuma97@gmail.com>
    cavium: Return negative value when pci_alloc_irq_vectors() fails

Davide Baldo <davide@baldo.me>
    ALSA: hda/realtek: Fixes HP Spectre x360 15-eb1xxx speakers

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: soc-core: fix null-ptr-deref in snd_soc_del_component_unlocked()

Sean Christopherson <seanjc@google.com>
    x86/irq: Ensure PI wakeup handler is unregistered before module unload

Jane Malalane <jane.malalane@citrix.com>
    x86/cpu: Fix migration safety with X86_BUG_NULL_SEL

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sme: Use #define USE_EARLY_PGTABLE_L5 in mem_encrypt_identity.c

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix page stealing

yangerkun <yangerkun@huawei.com>
    ext4: refresh the ext4_ext_path struct after dropping i_data_sem.

yangerkun <yangerkun@huawei.com>
    ext4: ensure enough credits in ext4_ext_shift_path_extents

Shaoying Xu <shaoyi@amazon.com>
    ext4: fix lazy initialization next schedule time computation in more granular unit

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Unconditionally unlink slave instances, too

Wang Wensheng <wangwensheng4@huawei.com>
    ALSA: timer: Fix use-after-free problem

Austin Kim <austin.kim@lge.com>
    ALSA: synth: missing check for possible NULL after the call to kstrdup

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Free card instance properly at probe errors

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum 400

Jason Ormes <skryking@gmail.com>
    ALSA: usb-audio: Line6 HX-Stomp XL USB_ID for 48k-fixed quirk

Johan Hovold <johan@kernel.org>
    ALSA: line6: fix control and interrupt message timeouts

Johan Hovold <johan@kernel.org>
    ALSA: 6fire: fix control and bulk message timeouts

Johan Hovold <johan@kernel.org>
    ALSA: ua101: fix division by zero at probe

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Add quirk for HP EliteBook 840 G7 mute LED

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for ASUS UX550VE

Jaroslav Kysela <perex@perex.cz>
    ALSA: hda/realtek: Add a quirk for Acer Spin SP513-54N

Jeremy Soller <jeremy@system76.com>
    ALSA: hda/realtek: Headset fixup for Clevo NH77HJQ

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo PC70HS

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add a quirk for HP OMEN 15 mute LED

Johnathon Clark <john.clark@cantab.net>
    ALSA: hda/realtek: Fix mic mute LED for the HP Spectre x360 14

Ricardo Ribalda <ribalda@chromium.org>
    media: v4l2-ioctl: Fix check_ext_ctrls

Sean Young <sean@mess.org>
    media: ir-kbd-i2c: improve responsiveness of hauppauge zilog receivers

Chen-Yu Tsai <wenst@chromium.org>
    media: rkvdec: Support dynamic resolution changes

Sean Young <sean@mess.org>
    media: ite-cir: IR receiver stop working after receive overflow

Chen-Yu Tsai <wenst@chromium.org>
    media: rkvdec: Do not override sizeimage for output format

Tang Bin <tangbin@cmss.chinamobile.com>
    crypto: s5p-sss - Add error handling in s5p_aes_probe()

jing yangyang <cgel.zte@gmail.com>
    firmware/psci: fix application of sizeof to pointer

Dan Carpenter <dan.carpenter@oracle.com>
    tpm: Check for integer overflow in tpm2_map_response_body()

Helge Deller <deller@gmx.de>
    parisc: Fix ptrace check on syscall return

Helge Deller <deller@gmx.de>
    parisc: Fix set_fixmap() on PA1.x CPUs

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: fix incorrect loading of i_blocks for large files

Christian Löhle <CLoehle@hyperstone.com>
    mmc: dw_mmc: Dont wait for DRTO on Write RSP error

Derong Liu <derong.liu@mediatek.com>
    mmc: mtk-sd: Add wait dma stop done flow

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix use after free in eh_abort path

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix kernel crash when accessing port_speed sysfs file

Tadeusz Struk <tadeusz.struk@linaro.org>
    scsi: core: Remove command size deduction from scsi_setup_scsi_cmnd()

Jan Kara <jack@suse.cz>
    ocfs2: fix data corruption on truncate

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    libata: fix read log timeout value

Takashi Iwai <tiwai@suse.de>
    Input: i8042 - Add quirk for Fujitsu Lifebook T725

Phoenix Huang <phoenix@emc.com.tw>
    Input: elantench - fix misreporting trackpoint coordinates

Johan Hovold <johan@kernel.org>
    Input: iforce - fix control-message timeout

Todd Kjos <tkjos@google.com>
    binder: use cred instead of task for getsecid

Todd Kjos <tkjos@google.com>
    binder: use cred instead of task for selinux checks

Todd Kjos <tkjos@google.com>
    binder: use euid from cred instead of using task

Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
    usb: xhci: Enable runtime-pm by default on AMD Yellow Carp platform

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix USB 3.1 enumeration issues by increasing roothub power-on-good delay


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   7 +
 .../bindings/regulator/samsung,s5m8767.txt         |  23 +-
 Documentation/filesystems/fscrypt.rst              |  10 +-
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   3 +
 arch/arm/Makefile                                  |  22 +-
 arch/arm/boot/dts/at91-tse850-3.dts                |   2 +-
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts        |   2 +-
 arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts        |   2 +-
 arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts  |   2 +-
 arch/arm/boot/dts/bcm4709-linksys-ea9200.dts       |   2 +-
 arch/arm/boot/dts/bcm4709-netgear-r7000.dts        |   2 +-
 arch/arm/boot/dts/bcm4709-netgear-r8000.dts        |   2 +-
 arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dts  |   2 +-
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts      |   2 +-
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts         |   2 +-
 arch/arm/boot/dts/bcm94708.dts                     |   2 +-
 arch/arm/boot/dts/bcm94709.dts                     |   2 +-
 arch/arm/boot/dts/omap3-gta04.dtsi                 |   2 +-
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   4 +-
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi           |   8 +-
 arch/arm/boot/dts/stm32mp151.dtsi                  |  16 +-
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi       |   2 +-
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts    |   2 +-
 arch/arm/kernel/stacktrace.c                       |   3 +-
 arch/arm/mach-s3c/irq-s3c24xx.c                    |  22 +-
 arch/arm/mm/Kconfig                                |   2 +-
 arch/arm/mm/mmu.c                                  |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts  |   2 +-
 arch/arm64/boot/dts/amlogic/meson-g12a-u200.dts    |   2 +-
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts |   2 +-
 .../boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi   |   4 +-
 .../boot/dts/amlogic/meson-g12b-odroid-n2.dtsi     |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi   |   4 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   8 +-
 arch/arm64/boot/dts/qcom/pm8916.dtsi               |   1 -
 .../arm64/boot/dts/renesas/beacon-renesom-som.dtsi |   1 +
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   2 +-
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |  16 +-
 arch/arm64/include/asm/esr.h                       |   1 +
 arch/arm64/include/asm/pgtable.h                   |  12 +-
 arch/arm64/kvm/hyp/hyp-entry.S                     |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |   2 +-
 arch/arm64/mm/mmu.c                                |   5 +
 arch/arm64/net/bpf_jit_comp.c                      |   5 +
 arch/ia64/Kconfig.debug                            |   2 +-
 arch/ia64/kernel/kprobes.c                         |   9 +-
 arch/m68k/Kconfig.machine                          |   1 +
 arch/mips/Kconfig                                  |   1 +
 arch/mips/include/asm/cmpxchg.h                    |   5 +-
 arch/mips/include/asm/mips-cm.h                    |  12 +-
 arch/mips/kernel/mips-cm.c                         |  21 +-
 arch/mips/kernel/r2300_fpu.S                       |   4 +-
 arch/mips/kernel/syscall.c                         |   9 -
 arch/mips/lantiq/xway/dma.c                        |  23 +-
 arch/openrisc/kernel/dma.c                         |   4 +-
 arch/openrisc/kernel/smp.c                         |   6 +-
 arch/parisc/kernel/entry.S                         |   2 +-
 arch/parisc/kernel/smp.c                           |  19 +-
 arch/parisc/kernel/unwind.c                        |  21 +-
 arch/parisc/kernel/vmlinux.lds.S                   |   3 +-
 arch/parisc/mm/fixmap.c                            |   5 +-
 arch/parisc/mm/init.c                              |   4 +-
 arch/powerpc/include/asm/code-patching.h           |   1 +
 arch/powerpc/include/asm/firmware.h                |   6 -
 arch/powerpc/include/asm/kvm_guest.h               |  25 ++
 arch/powerpc/include/asm/kvm_para.h                |   2 +-
 arch/powerpc/include/asm/security_features.h       |   5 +
 arch/powerpc/kernel/firmware.c                     |  12 +-
 arch/powerpc/kernel/security.c                     |   5 +
 arch/powerpc/lib/code-patching.c                   |   7 +-
 arch/powerpc/net/bpf_jit.h                         |  33 ++-
 arch/powerpc/net/bpf_jit64.h                       |   8 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  64 +++++-
 arch/powerpc/platforms/44x/fsp2.c                  |   2 +
 arch/powerpc/platforms/85xx/Makefile               |   4 +-
 arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c       |   7 +-
 arch/powerpc/platforms/85xx/smp.c                  |  12 +-
 arch/powerpc/platforms/powernv/opal-prd.c          |  12 +-
 arch/powerpc/platforms/pseries/smp.c               |   3 +
 arch/s390/kvm/priv.c                               |   2 +
 arch/s390/kvm/pv.c                                 |  21 +-
 arch/s390/mm/gmap.c                                |   5 +-
 arch/sh/kernel/cpu/fpu.c                           |  10 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/events/intel/uncore_snbep.c               |   6 +-
 arch/x86/hyperv/hv_init.c                          |   5 +-
 arch/x86/include/asm/cpu_entry_area.h              |   8 +-
 arch/x86/include/asm/mem_encrypt.h                 |   1 +
 arch/x86/include/asm/page_64_types.h               |   2 +-
 arch/x86/kernel/Makefile                           |   6 +
 arch/x86/kernel/cc_platform.c                      |  69 ++++++
 arch/x86/kernel/cpu/amd.c                          |   2 +
 arch/x86/kernel/cpu/common.c                       |  44 +++-
 arch/x86/kernel/cpu/cpu.h                          |   1 +
 arch/x86/kernel/cpu/hygon.c                        |   2 +
 arch/x86/kernel/cpu/mce/intel.c                    |   5 +-
 arch/x86/kernel/irq.c                              |   4 +-
 arch/x86/kernel/sev-es.c                           |  32 ---
 arch/x86/kernel/traps.c                            |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |  15 +-
 arch/x86/mm/cpu_entry_area.c                       |   7 +
 arch/x86/mm/mem_encrypt.c                          |   1 +
 arch/x86/mm/mem_encrypt_identity.c                 |   9 +
 block/blk-mq.c                                     |  18 +-
 block/blk.h                                        |   6 +
 crypto/Kconfig                                     |   2 +-
 crypto/pcrypt.c                                    |  12 +-
 drivers/acpi/ac.c                                  |  19 ++
 drivers/acpi/acpica/acglobal.h                     |   2 +
 drivers/acpi/acpica/hwesleep.c                     |   8 +-
 drivers/acpi/acpica/hwsleep.c                      |  11 +-
 drivers/acpi/acpica/hwxfsleep.c                    |   7 +
 drivers/acpi/battery.c                             |   2 +-
 drivers/acpi/pmic/intel_pmic.c                     |  51 +++--
 drivers/android/binder.c                           |  22 +-
 drivers/ata/libata-core.c                          |   2 +-
 drivers/ata/libata-eh.c                            |   8 +
 drivers/auxdisplay/ht16k33.c                       |  66 +++---
 drivers/auxdisplay/img-ascii-lcd.c                 |  10 +
 drivers/base/core.c                                |   4 +-
 drivers/base/power/main.c                          |   9 +-
 drivers/block/zram/zram_drv.c                      |   2 +-
 drivers/bluetooth/btmtkuart.c                      |  13 +-
 drivers/bus/ti-sysc.c                              |  65 +++++-
 drivers/char/hw_random/mtk-rng.c                   |   9 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  10 +-
 drivers/char/ipmi/ipmi_watchdog.c                  |  17 +-
 drivers/char/tpm/tpm2-space.c                      |   3 +
 drivers/char/tpm/tpm_tis_core.c                    |  26 ++-
 drivers/char/tpm/tpm_tis_core.h                    |   4 +
 drivers/char/tpm/tpm_tis_spi_main.c                |   1 +
 drivers/clk/at91/clk-sam9x60-pll.c                 |   4 +-
 drivers/clk/at91/pmc.c                             |   5 +
 drivers/clk/mvebu/ap-cpu-clk.c                     |  14 +-
 drivers/clocksource/Kconfig                        |   1 +
 drivers/cpuidle/sysfs.c                            |   5 +-
 drivers/crypto/caam/caampkc.c                      |  19 +-
 drivers/crypto/caam/regs.h                         |   3 +
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |  13 ++
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |   6 +
 drivers/crypto/s5p-sss.c                           |   2 +
 drivers/dma-buf/dma-buf.c                          |   1 +
 drivers/dma/at_xdmac.c                             |   2 +-
 drivers/dma/dmaengine.h                            |   2 +-
 drivers/edac/amd64_edac.c                          |  22 +-
 drivers/edac/sb_edac.c                             |   2 +-
 drivers/firmware/psci/psci_checker.c               |   2 +-
 drivers/firmware/qcom_scm.c                        |   2 +-
 drivers/gpio/gpio-mlxbf2.c                         |   5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h        |   2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |   8 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |  17 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   1 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |  16 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  47 +++-
 drivers/gpu/drm/drm_plane_helper.c                 |   1 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c        |   8 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   4 +
 drivers/gpu/drm/msm/msm_gem.c                      |   4 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   2 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |   4 +
 drivers/gpu/drm/sun4i/sun8i_csc.h                  |   4 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |   5 -
 drivers/gpu/drm/v3d/v3d_gem.c                      |   4 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   8 +-
 drivers/hid/hid-u2fzero.c                          |  10 +-
 drivers/hv/hyperv_vmbus.h                          |   1 +
 drivers/hwmon/hwmon.c                              |   6 +-
 drivers/hwmon/pmbus/lm25066.c                      |  25 +-
 drivers/hwtracing/coresight/coresight-cti-core.c   |   2 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
 drivers/i2c/busses/i2c-xlr.c                       |   6 +-
 drivers/iio/accel/st_accel_core.c                  |  21 +-
 drivers/iio/accel/st_accel_i2c.c                   |  17 +-
 drivers/iio/accel/st_accel_spi.c                   |  17 +-
 drivers/iio/dac/ad5446.c                           |   9 +-
 drivers/iio/dac/ad5770r.c                          |   2 +-
 drivers/iio/gyro/st_gyro_core.c                    |  15 +-
 drivers/iio/gyro/st_gyro_i2c.c                     |  17 +-
 drivers/iio/gyro/st_gyro_spi.c                     |  17 +-
 drivers/iio/imu/adis.c                             |   4 +-
 drivers/iio/magnetometer/st_magn_core.c            |  15 +-
 drivers/iio/magnetometer/st_magn_i2c.c             |  14 +-
 drivers/iio/magnetometer/st_magn_spi.c             |  14 +-
 drivers/iio/pressure/st_pressure_core.c            |  15 +-
 drivers/iio/pressure/st_pressure_i2c.c             |  17 +-
 drivers/iio/pressure/st_pressure_spi.c             |  17 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   3 +-
 drivers/infiniband/hw/mlx4/qp.c                    |   4 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  15 +-
 drivers/infiniband/sw/rxe/rxe_param.h              |   2 +-
 drivers/input/joystick/iforce/iforce-usb.c         |   2 +-
 drivers/input/mouse/elantech.c                     |  13 ++
 drivers/input/serio/i8042-x86ia64io.h              |  14 ++
 drivers/irqchip/irq-bcm6345-l1.c                   |   2 +-
 drivers/irqchip/irq-sifive-plic.c                  |   8 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |   8 +-
 drivers/md/md.c                                    |  11 +-
 drivers/media/dvb-frontends/mn88443x.c             |  18 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   1 +
 drivers/media/i2c/mt9p031.c                        |  28 ++-
 drivers/media/i2c/tda1997x.c                       |   8 +-
 drivers/media/pci/cx23885/cx23885-alsa.c           |   3 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  27 ++-
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |   5 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c        |   2 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   6 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |  19 +-
 drivers/media/radio/radio-wl1273.c                 |   2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   2 +-
 drivers/media/rc/ir_toy.c                          |   2 +-
 drivers/media/rc/ite-cir.c                         |   2 +-
 drivers/media/rc/mceusb.c                          |   1 +
 drivers/media/spi/cxd2880-spi.c                    |   2 +-
 drivers/media/usb/dvb-usb/az6027.c                 |   1 +
 drivers/media/usb/dvb-usb/dibusb-common.c          |   2 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   5 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   5 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   3 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   7 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   7 +-
 drivers/media/usb/uvc/uvc_video.c                  |   5 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |  67 ++++--
 drivers/memory/fsl_ifc.c                           |  13 +-
 drivers/memory/renesas-rpc-if.c                    | 113 +++++++---
 drivers/memstick/core/ms_block.c                   |   2 +-
 drivers/memstick/host/jmb38x_ms.c                  |   2 +-
 drivers/memstick/host/r592.c                       |   8 +-
 drivers/mfd/dln2.c                                 |  18 ++
 drivers/mfd/mfd-core.c                             |   2 +
 drivers/mmc/host/Kconfig                           |   2 +-
 drivers/mmc/host/dw_mmc.c                          |   3 +-
 drivers/mmc/host/moxart-mmc.c                      |  29 ++-
 drivers/mmc/host/mtk-sd.c                          |   5 +
 drivers/mmc/host/mxs-mmc.c                         |  10 +
 drivers/mmc/host/sdhci-omap.c                      |  18 +-
 drivers/most/most_usb.c                            |   5 +-
 drivers/mtd/mtdcore.c                              |   4 +-
 drivers/mtd/nand/raw/ams-delta.c                   |  12 +-
 drivers/mtd/nand/raw/au1550nd.c                    |  12 +-
 drivers/mtd/nand/raw/gpio.c                        |  12 +-
 drivers/mtd/nand/raw/mpc5121_nfc.c                 |  12 +-
 drivers/mtd/nand/raw/orion_nand.c                  |  12 +-
 drivers/mtd/nand/raw/pasemi_nand.c                 |  12 +-
 drivers/mtd/nand/raw/plat_nand.c                   |  12 +-
 drivers/mtd/nand/raw/socrates_nand.c               |  12 +-
 drivers/mtd/nand/raw/xway_nand.c                   |  12 +-
 drivers/mtd/spi-nor/controllers/hisi-sfc.c         |   1 -
 drivers/net/Kconfig                                |   2 +-
 drivers/net/bonding/bond_sysfs_slave.c             |  36 +--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   2 +-
 drivers/net/dsa/rtl8366rb.c                        |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |   8 +
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  20 +-
 drivers/net/ethernet/cavium/thunder/nic_main.c     |   2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |   7 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h         |   2 +
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   2 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.h         |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  18 +-
 drivers/net/ethernet/google/gve/gve.h              |   4 +-
 drivers/net/ethernet/google/gve/gve_adminq.h       |   1 +
 drivers/net/ethernet/google/gve/gve_main.c         |  48 +++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   5 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   2 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |   5 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  20 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.c      |  16 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.h      |   2 +
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |  17 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   1 +
 drivers/net/ethernet/sfc/mcdi_port_common.c        |  37 ++-
 drivers/net/ethernet/sfc/ptp.c                     |   4 +-
 drivers/net/ethernet/sfc/siena_sriov.c             |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   2 -
 drivers/net/ethernet/ti/davinci_emac.c             |  16 +-
 drivers/net/ifb.c                                  |   2 +
 drivers/net/phy/micrel.c                           |   9 +-
 drivers/net/phy/phy.c                              |   7 +-
 drivers/net/phy/phylink.c                          |   2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   1 -
 drivers/net/vrf.c                                  |  28 ++-
 drivers/net/wireless/ath/ath10k/mac.c              |  45 +++-
 drivers/net/wireless/ath/ath10k/sdio.c             |   5 +-
 drivers/net/wireless/ath/ath10k/usb.c              |   7 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   4 +
 drivers/net/wireless/ath/ath10k/wmi.h              |   3 +
 drivers/net/wireless/ath/ath11k/dbring.c           |  16 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  13 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   2 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   4 +-
 drivers/net/wireless/ath/ath11k/reg.c              |  11 +-
 drivers/net/wireless/ath/ath11k/reg.h              |   2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  40 ++--
 drivers/net/wireless/ath/ath11k/wmi.h              |   3 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |   7 +-
 drivers/net/wireless/ath/ath9k/main.c              |   4 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |  10 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |  49 ++--
 drivers/net/wireless/ath/wcn36xx/main.c            |   8 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |  44 +++-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |  64 +++---
 drivers/net/wireless/ath/wcn36xx/txrx.h            |   3 +-
 drivers/net/wireless/broadcom/b43/phy_g.c          |   2 +-
 drivers/net/wireless/broadcom/b43legacy/radio.c    |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  10 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   3 +
 drivers/net/wireless/marvell/libertas/if_usb.c     |   2 +
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   2 +
 drivers/net/wireless/marvell/mwifiex/11n.c         |   5 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  32 +--
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  36 ++-
 drivers/net/wireless/marvell/mwifiex/usb.c         |  16 ++
 drivers/net/wireless/marvell/mwl8k.c               |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  15 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   8 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   3 +-
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c |  14 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   7 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |   1 +
 drivers/net/wireless/rsi/rsi_91x_core.c            |   2 +
 drivers/net/wireless/rsi/rsi_91x_hal.c             |  10 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |  74 ++----
 drivers/net/wireless/rsi/rsi_91x_main.c            |  17 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |  24 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   5 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   5 +-
 drivers/net/wireless/rsi/rsi_hal.h                 |  11 +
 drivers/net/wireless/rsi/rsi_main.h                |  15 +-
 drivers/net/xen-netfront.c                         |   8 +
 drivers/nfc/pn533/pn533.c                          |   6 +-
 drivers/nvme/host/multipath.c                      |   9 +-
 drivers/nvme/host/rdma.c                           |   2 +
 drivers/nvme/target/configfs.c                     |   2 +
 drivers/nvme/target/rdma.c                         |  24 ++
 drivers/nvme/target/tcp.c                          |  21 +-
 drivers/of/unittest.c                              |  16 +-
 drivers/opp/of.c                                   |   2 +-
 drivers/pci/controller/cadence/pcie-cadence-plat.c |   2 +
 drivers/pci/controller/dwc/pcie-uniphier.c         |  26 +--
 drivers/pci/controller/pci-aardvark.c              | 251 ++++++++++++++++++---
 drivers/pci/pci-bridge-emul.c                      |  13 ++
 drivers/pci/quirks.c                               |   1 +
 drivers/phy/qualcomm/phy-qcom-qusb2.c              |  16 +-
 drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c      |   2 +-
 drivers/phy/ti/phy-gmii-sel.c                      |   2 +
 drivers/pinctrl/core.c                             |   2 +
 drivers/pinctrl/pinctrl-equilibrium.c              |   7 +-
 drivers/pinctrl/renesas/core.c                     |   2 +-
 drivers/platform/x86/thinkpad_acpi.c               |   2 +-
 drivers/platform/x86/wmi.c                         |   9 +-
 drivers/power/supply/bq27xxx_battery_i2c.c         |   3 +-
 drivers/power/supply/max17040_battery.c            |   2 +
 drivers/power/supply/max17042_battery.c            |  12 +-
 drivers/power/supply/rt5033_battery.c              |   2 +-
 drivers/regulator/s5m8767.c                        |  21 +-
 drivers/remoteproc/remoteproc_core.c               |   8 +-
 drivers/reset/reset-socfpga.c                      |  26 +++
 drivers/rtc/rtc-rv3032.c                           |   4 +-
 drivers/s390/char/tape_std.c                       |   3 +-
 drivers/s390/cio/css.c                             |   4 +-
 drivers/s390/cio/device_ops.c                      |  12 +-
 drivers/s390/crypto/ap_queue.c                     |   2 +
 drivers/scsi/csiostor/csio_lnode.c                 |   2 +-
 drivers/scsi/dc395x.c                              |   1 +
 drivers/scsi/pm8001/pm8001_hwi.c                   |   2 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |  24 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   2 -
 drivers/scsi/qla2xxx/qla_init.c                    |  54 ++++-
 drivers/scsi/qla2xxx/qla_mr.c                      |  23 --
 drivers/scsi/qla2xxx/qla_os.c                      |  47 ++--
 drivers/scsi/qla2xxx/qla_target.c                  |  14 +-
 drivers/scsi/scsi_lib.c                            |   2 -
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   6 +-
 drivers/scsi/ufs/ufshcd.c                          |  29 +--
 drivers/scsi/ufs/ufshcd.h                          |   3 +
 drivers/soc/fsl/dpaa2-console.c                    |   1 +
 drivers/soc/fsl/dpio/dpio-service.c                |   2 +-
 drivers/soc/fsl/dpio/qbman-portal.c                |   9 +-
 drivers/soc/qcom/apr.c                             |   2 +
 drivers/soc/qcom/rpmhpd.c                          |  21 +-
 drivers/soc/tegra/pmc.c                            |   2 +-
 drivers/soundwire/debugfs.c                        |   2 +-
 drivers/spi/spi-bcm-qspi.c                         |   5 +-
 drivers/spi/spi-pl022.c                            |   5 +-
 drivers/spi/spi-rpc-if.c                           |   4 +-
 drivers/staging/ks7010/Kconfig                     |   3 +
 drivers/staging/media/allegro-dvt/allegro-core.c   |   9 +
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c |  37 +--
 drivers/staging/media/imx/imx-media-dev-common.c   |   2 +
 drivers/staging/media/ipu3/ipu3-v4l2.c             |   7 +-
 drivers/staging/media/rkvdec/rkvdec-h264.c         |   5 +-
 drivers/staging/media/rkvdec/rkvdec.c              |  40 ++--
 drivers/staging/most/dim2/Makefile                 |   2 +-
 drivers/staging/most/dim2/dim2.c                   |  24 +-
 drivers/staging/most/dim2/sysfs.c                  |  49 ----
 drivers/staging/most/dim2/sysfs.h                  |  11 -
 drivers/tty/serial/8250/8250_dw.c                  |   2 +-
 drivers/tty/serial/8250/8250_port.c                |  21 +-
 drivers/tty/serial/imx.c                           |   4 +-
 drivers/tty/serial/serial_core.c                   |  16 +-
 drivers/tty/serial/xilinx_uartps.c                 |   3 +-
 drivers/usb/chipidea/core.c                        |  23 +-
 drivers/usb/dwc2/drd.c                             |  24 +-
 drivers/usb/gadget/legacy/hid.c                    |   4 +-
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/host/xhci-pci.c                        |  16 ++
 drivers/usb/misc/iowarrior.c                       |   8 +-
 drivers/usb/musb/Kconfig                           |   2 +-
 drivers/usb/serial/keyspan.c                       |  15 +-
 drivers/usb/typec/Kconfig                          |   4 +-
 drivers/video/backlight/backlight.c                |   6 -
 drivers/video/fbdev/chipsfb.c                      |   2 +-
 drivers/virtio/virtio_ring.c                       |  14 +-
 drivers/watchdog/Kconfig                           |   2 +-
 drivers/watchdog/f71808e_wdt.c                     |   4 +-
 drivers/watchdog/omap_wdt.c                        |   6 +-
 drivers/xen/balloon.c                              |  86 +++++--
 drivers/xen/xen-pciback/conf_space_capability.c    |   2 +-
 fs/btrfs/disk-io.c                                 |   3 +-
 fs/btrfs/reflink.c                                 |   2 +-
 fs/btrfs/tree-log.c                                |   4 +-
 fs/btrfs/volumes.c                                 |  14 +-
 fs/crypto/fscrypt_private.h                        |   5 +-
 fs/crypto/hkdf.c                                   |  11 +-
 fs/crypto/keysetup.c                               |  57 ++++-
 fs/erofs/decompressor.c                            |   1 -
 fs/exfat/inode.c                                   |   2 +-
 fs/ext4/extents.c                                  |  63 +++---
 fs/ext4/super.c                                    |   9 +-
 fs/f2fs/inode.c                                    |   2 +-
 fs/f2fs/namei.c                                    |   2 +-
 fs/fuse/dev.c                                      |  14 +-
 fs/gfs2/glock.c                                    |  24 +-
 fs/jfs/jfs_mount.c                                 |  51 ++---
 fs/nfs/dir.c                                       |   7 +-
 fs/nfs/direct.c                                    |   2 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   4 +-
 fs/nfs/nfs4idmap.c                                 |   2 +-
 fs/nfs/nfs4proc.c                                  |  15 +-
 fs/nfs/pnfs.h                                      |   2 +-
 fs/nfs/pnfs_nfs.c                                  |   6 +-
 fs/nfs/write.c                                     |  26 +--
 fs/ocfs2/file.c                                    |   8 +-
 fs/orangefs/dcache.c                               |   4 +-
 fs/overlayfs/file.c                                |  16 +-
 fs/proc/stat.c                                     |   4 +-
 fs/proc/uptime.c                                   |  14 +-
 fs/quota/quota_tree.c                              |  15 ++
 fs/tracefs/inode.c                                 |   3 +-
 include/linux/blkdev.h                             |   2 -
 include/linux/cc_platform.h                        |  88 ++++++++
 include/linux/console.h                            |   2 +
 include/linux/ethtool_netlink.h                    |   3 +
 include/linux/filter.h                             |   1 +
 include/linux/kernel_stat.h                        |   1 +
 include/linux/libata.h                             |   2 +-
 include/linux/lsm_hook_defs.h                      |  14 +-
 include/linux/lsm_hooks.h                          |  14 +-
 include/linux/nfs_fs.h                             |   1 +
 include/linux/posix-timers.h                       |   2 +
 include/linux/rpmsg.h                              |   2 +-
 include/linux/sched/task.h                         |   3 +-
 include/linux/sched/task_stack.h                   |   4 +
 include/linux/security.h                           |  33 +--
 include/linux/seq_file.h                           |   2 +-
 include/linux/tpm.h                                |   1 +
 include/memory/renesas-rpc-if.h                    |   1 +
 include/net/inet_connection_sock.h                 |   2 +-
 include/net/llc.h                                  |   4 +-
 include/net/neighbour.h                            |  12 +-
 include/net/sch_generic.h                          |   4 +
 include/net/sock.h                                 |   2 +-
 include/net/strparser.h                            |  16 +-
 include/net/tcp.h                                  |  17 +-
 include/net/udp.h                                  |   5 +-
 include/uapi/linux/ethtool_netlink.h               |   4 +-
 include/uapi/linux/pci_regs.h                      |   6 +
 kernel/bpf/core.c                                  |   4 +-
 kernel/bpf/verifier.c                              |   4 +-
 kernel/cgroup/cgroup.c                             |  31 ++-
 kernel/cgroup/rstat.c                              |   2 -
 kernel/fork.c                                      |   3 +-
 kernel/kprobes.c                                   |   3 +-
 kernel/locking/lockdep.c                           |   4 +-
 kernel/power/energy_model.c                        |  23 +-
 kernel/power/swap.c                                |   7 +-
 kernel/rcu/rcutorture.c                            |  48 +++-
 kernel/rcu/tasks.h                                 |   3 +-
 kernel/rcu/tree_exp.h                              |   2 +-
 kernel/rcu/tree_plugin.h                           |   8 +-
 kernel/sched/core.c                                |  43 ++--
 kernel/signal.c                                    |  18 +-
 kernel/time/posix-cpu-timers.c                     |  19 +-
 kernel/trace/ring_buffer.c                         |   5 +
 kernel/trace/tracing_map.c                         |  40 ++--
 kernel/workqueue.c                                 |  15 +-
 lib/decompress_unxz.c                              |   2 +-
 lib/iov_iter.c                                     |   5 +-
 lib/xz/xz_dec_lzma2.c                              |  21 +-
 lib/xz/xz_dec_stream.c                             |   6 +-
 mm/memcontrol.c                                    |  27 +--
 mm/oom_kill.c                                      |  23 +-
 mm/zsmalloc.c                                      |   7 +-
 net/8021q/vlan.c                                   |   3 -
 net/8021q/vlan_dev.c                               |   3 +
 net/9p/client.c                                    |   2 +
 net/bluetooth/l2cap_sock.c                         |  10 +-
 net/bluetooth/sco.c                                |  33 +--
 net/can/j1939/main.c                               |   7 +
 net/can/j1939/transport.c                          |   6 +
 net/core/dev.c                                     |   5 +-
 net/core/filter.c                                  |  21 ++
 net/core/neighbour.c                               |  48 ++--
 net/core/net-sysfs.c                               |  55 +++++
 net/core/net_namespace.c                           |   4 +
 net/core/stream.c                                  |   3 -
 net/core/sysctl_net_core.c                         |   2 +-
 net/dccp/dccp.h                                    |   2 +-
 net/dccp/proto.c                                   |  14 +-
 net/ethtool/pause.c                                |   3 +-
 net/ipv4/inet_connection_sock.c                    |   4 +-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/proc.c                                    |   2 +-
 net/ipv4/tcp.c                                     |  40 +++-
 net/ipv4/tcp_bpf.c                                 |   1 -
 net/ipv6/addrconf.c                                |   3 +
 net/ipv6/udp.c                                     |   2 +-
 net/netfilter/nf_conntrack_proto_udp.c             |   7 +-
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/netfilter/nft_dynset.c                         |  11 +-
 net/rds/ib.c                                       |  10 -
 net/rds/ib.h                                       |   6 -
 net/rds/ib_cm.c                                    | 128 +++++++----
 net/rds/ib_recv.c                                  |  18 +-
 net/rds/ib_send.c                                  |   8 +
 net/rxrpc/rtt.c                                    |   2 +-
 net/sched/sch_generic.c                            |   9 +
 net/sched/sch_mq.c                                 |  24 ++
 net/sched/sch_mqprio.c                             |  23 ++
 net/sched/sch_taprio.c                             |  27 ++-
 net/smc/af_smc.c                                   |  20 +-
 net/smc/smc_llc.c                                  |   2 +-
 net/strparser/strparser.c                          |  10 +-
 net/sunrpc/addr.c                                  |  40 ++--
 net/sunrpc/xprt.c                                  |  28 +--
 net/vmw_vsock/af_vsock.c                           |   2 +
 samples/kprobes/kretprobe_example.c                |   2 +-
 scripts/leaking_addresses.pl                       |   3 +-
 security/apparmor/label.c                          |   4 +-
 security/integrity/evm/evm_main.c                  |   2 +-
 security/security.c                                |  14 +-
 security/selinux/hooks.c                           |  36 ++-
 security/selinux/ss/services.c                     | 162 +++++++------
 security/smack/smackfs.c                           |  11 +-
 sound/core/oss/mixer_oss.c                         |  43 +++-
 sound/core/timer.c                                 |  17 +-
 sound/pci/hda/hda_intel.c                          |  74 +++---
 sound/pci/hda/patch_realtek.c                      |  82 +++++++
 sound/soc/codecs/cs42l42.c                         |  88 ++++----
 sound/soc/soc-core.c                               |   1 +
 sound/soc/sof/topology.c                           |   9 +
 sound/synth/emux/emux.c                            |   2 +-
 sound/usb/6fire/comm.c                             |   2 +-
 sound/usb/6fire/firmware.c                         |   6 +-
 sound/usb/format.c                                 |   1 +
 sound/usb/line6/driver.c                           |  14 +-
 sound/usb/line6/driver.h                           |   2 +-
 sound/usb/line6/podhd.c                            |   6 +-
 sound/usb/line6/toneport.c                         |   2 +-
 sound/usb/misc/ua101.c                             |   4 +-
 sound/usb/quirks.c                                 |   1 +
 tools/bpf/bpftool/prog.c                           |  16 +-
 tools/lib/bpf/bpf_core_read.h                      |   2 +-
 tools/lib/bpf/btf.c                                |  25 +-
 tools/objtool/check.c                              |  19 +-
 tools/perf/util/bpf-event.c                        |   4 +-
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |   4 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |  85 +++++--
 tools/testing/selftests/bpf/progs/strobemeta.h     |   4 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |  62 +++--
 tools/testing/selftests/bpf/test_progs.c           |   4 +-
 .../testing/selftests/bpf/verifier/array_access.c  |   2 +-
 tools/testing/selftests/core/close_range_test.c    |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c       |  22 +-
 .../selftests/kvm/x86_64/mmio_warning_test.c       |   2 +-
 tools/testing/selftests/net/fcnal-test.sh          |   3 +
 tools/testing/selftests/net/udpgso_bench_rx.c      |  11 +-
 598 files changed, 4823 insertions(+), 2403 deletions(-)


