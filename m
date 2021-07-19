Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717693CDA92
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243584AbhGSOga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243855AbhGSOfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:35:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96DF260720;
        Mon, 19 Jul 2021 15:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707747;
        bh=PX1npHP7wQCds4f/qFkQFKTkC8Ng6o+qFRuo0sHmkeI=;
        h=From:To:Cc:Subject:Date:From;
        b=uo7Sl75/7liXH1SXv7VVZtxExsROnHyO0qmNxIsqBKH+wqXH4tWm1pBHR/GxHGYWE
         xH4Nd8Iag7d9AW12Tfr15FYnDowoFBNKDbmXAxgVu6GrlegSCsE5r8kCLzWJcVfVVN
         9FKpzaDwOGsSvBnmUY6Xjzj20p0nmtq98yFK2rrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 000/315] 4.14.240-rc1 review
Date:   Mon, 19 Jul 2021 16:48:09 +0200
Message-Id: <20210719144942.861561397@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.240-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.240-rc1
X-KernelTest-Deadline: 2021-07-21T14:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.240 release.
There are 315 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.240-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.240-rc1

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: multicast: fix PIM hello router port marking race

Martin Fäcknitz <faecknitz@hotsplots.de>
    MIPS: vdso: Invalid GIC access through VDSO

Randy Dunlap <rdunlap@infradead.org>
    mips: disable branch profiling in boot/decompress.o

Arnd Bergmann <arnd@arndb.de>
    mips: always link byteswap helpers into decompressor

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: be2iscsi: Fix an error handling path in beiscsi_dev_probe()

Aswath Govindraju <a-govindraju@ti.com>
    ARM: dts: am335x: align ti,pindir-d0-out-d1-in property with dt-shema

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: fsl_ifc: fix leak of private memory on probe failure

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: fsl_ifc: fix leak of IO mapping on probe failure

Philipp Zabel <p.zabel@pengutronix.de>
    reset: bail if try_module_get() fails

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: Fixup SPI binding

Petr Vorel <petr.vorel@gmail.com>
    arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a7779, marzen: Fix DU clock names

Dan Carpenter <dan.carpenter@oracle.com>
    rtc: fix snprintf() checking in is_rtc_hctosys()

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: atmel-ebi: add missing of_node_put for loop iteration

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: fix PWM LED max brightness on Odroid XU4

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: fix PWM LED max brightness on Odroid XU/XU3

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    reset: a10sr: add missing of_match_table reference

Nathan Chancellor <nathan@kernel.org>
    hexagon: use common DISCARDS macro

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pNFS: Don't call _nfs4_pnfs_v3_ds_connect multiple times

Zhen Lei <thunder.leizhen@huawei.com>
    ALSA: isa: Fix error return code in snd_cmi8330_probe()

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Limit xstate copy size in xstateregs_set()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Set/Clear I_LINKABLE under i_lock for whiteout inode

Gao Xiang <hsiangkao@linux.alibaba.com>
    nfs: fix acl memory leak of posix_acl_create()

Tao Ren <rentao.bupt@gmail.com>
    watchdog: aspeed: fix hardware timeout calculation

Zhen Lei <thunder.leizhen@huawei.com>
    um: fix error return code in winch_tramp()

Zhen Lei <thunder.leizhen@huawei.com>
    um: fix error return code in slip_open()

Stephan Gerhold <stephan@gerhold.net>
    power: supply: rt5033_battery: Fix device tree enumeration

Krzysztof Wilczyński <kw@linux.com>
    PCI/sysfs: Fix dsm_label_utf16s_to_utf8s() buffer overrun

Chao Yu <yuchao0@huawei.com>
    f2fs: add MODULE_SOFTDEP to ensure crc32 is included in the initramfs

Xie Yongji <xieyongji@bytedance.com>
    virtio_console: Assure used length from device is limited

Xie Yongji <xieyongji@bytedance.com>
    virtio_net: Fix error handling in virtnet_restore()

Xie Yongji <xieyongji@bytedance.com>
    virtio-blk: Fix memory leak among suspend/resume procedure

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add quirk for the Dell Vostro 3350

Liguang Zhang <zhangliguang@linux.alibaba.com>
    ACPI: AMBA: Fix resource name in /proc/iomem

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: tegra: Don't modify HW state in .remove callback

Zou Wei <zou_wei@huawei.com>
    power: supply: ab8500: add missing MODULE_DEVICE_TABLE

Zou Wei <zou_wei@huawei.com>
    power: supply: charger-manager: add missing MODULE_DEVICE_TABLE

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs_find_open_context() may only select open files

Jeff Layton <jlayton@kernel.org>
    ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix orangefs df output.

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Return proper error codes from user access functions

Jan Kiszka <jan.kiszka@siemens.com>
    watchdog: iTCO_wdt: Account for rebooting on second timeout

Zou Wei <zou_wei@huawei.com>
    watchdog: Fix possible use-after-free by calling del_timer_sync()

Zou Wei <zou_wei@huawei.com>
    watchdog: sc520_wdt: Fix possible use-after-free in wdt_turnoff()

Zou Wei <zou_wei@huawei.com>
    watchdog: Fix possible use-after-free in wdt_startup()

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9087/1: kprobes: test-thumb: fix for LLVM_IAS=1

Bixuan Cui <cuibixuan@huawei.com>
    power: reset: gpio-poweroff: add missing MODULE_DEVICE_TABLE

Krzysztof Kozlowski <krzk@kernel.org>
    power: supply: max17042: Do not enforce (incorrect) interrupt trigger type

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500: Avoid NULL pointers

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: spear: Don't modify HW state in .remove callback

Dimitri John Ledkov <dimitri.ledkov@canonical.com>
    lib/decompress_unlz4.c: correctly handle zero-padding around initrds.

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    i2c: core: Disable client irq on reboot/shutdown

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Wait until port is in reset before programming it

Fabio Aiuto <fabioaiuto83@gmail.com>
    staging: rtl8723bs: fix macro value for 2.4Ghz only device

Jiajun Cao <jjcao20@fudan.edu.cn>
    ALSA: hda: Add IRQ check for platform_get_irq()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    backlight: lm3630a: Fix return code of .update_status() callback

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/boot: Fixup device-tree on little endian

Yang Yingliang <yangyingliang@huawei.com>
    usb: gadget: hid: fix error return code in hid_bind()

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_hid: fix endianness issue with descriptors

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: add support for ToneWeal FW66

Zhen Lei <thunder.leizhen@huawei.com>
    ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    selftests/powerpc: Fix "no_handler" EBB selftest

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: ppc: fix error return code in snd_pmac_probe()

Srinivas Neeli <srinivas.neeli@xilinx.com>
    gpio: zynq: Check return value of pm_runtime_get_sync

Geoff Levand <geoff@infradead.org>
    powerpc/ps3: Add dma_mask to ps3_dma_region

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Fix potential double-free of CSP mixer elements

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    s390/sclp_vt220: fix console name to match device

Zou Wei <zou_wei@huawei.com>
    mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE

Mike Christie <michael.christie@oracle.com>
    scsi: qedi: Fix null ref during abort handling

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix shost->max_id use

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Add iscsi_cls_conn refcount helpers

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    fs/jfs: Fix missing error code in lmLogInit()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: serial: 8250: serial_cs: Fix a memory leak in error handling path

John Garry <john.garry@huawei.com>
    scsi: core: Cap scsi_host cmd_per_lun at can_queue

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix "Unexpected timeout" error in direct attach topology

Luiz Sampaio <sampaio.ime@gmail.com>
    w1: ds2438: fixing bug that would always get page0

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    Revert "ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro"

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    misc/libmasm/module: Fix two use after free in ibmasm_init_one

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix kernel panic during PIO transfer

Remi Pommarel <repk@triplefau.lt>
    PCI: aardvark: Don't rely on jiffies while holding spinlock

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do not reference char * as a string in histograms

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: core: Fix bad pointer dereference when ehandler kthread is invalid

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Disable hardware breakpoints unconditionally before kvm_x86->run()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is enabled

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: restrict bytes count in smk_set_cipso()

Pavel Skripkin <paskripkin@gmail.com>
    jfs: fix GPF in diFree

Benjamin Drung <bdrung@posteo.de>
    media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K

Johan Hovold <johan@kernel.org>
    media: gspca/sunplus: fix zero-length control requests

Johan Hovold <johan@kernel.org>
    media: gspca/sq905: fix control-request direction

Pavel Skripkin <paskripkin@gmail.com>
    media: zr364xx: fix memory leak in zr364xx_start_readpipe

Johan Hovold <johan@kernel.org>
    media: dtv5100: fix control-request directions

Hou Tao <houtao1@huawei.com>
    dm btree remove: assign new_root only when removal succeeds

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe

Paul Burton <paulburton@google.com>
    tracing: Simplify & fix saved_tgids logic

Yun Zhou <yun.zhou@windriver.com>
    seq_buf: Fix overflow in seq_buf_putmem_hex()

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500: Fix an old bug

Petr Pavlu <petr.pavlu@suse.com>
    ipmi/watchdog: Stop watchdog timer when the current action is 'none'

Nathan Chancellor <nathan@kernel.org>
    qemu_fw_cfg: Make fw_cfg_rev_attr a proper kobj_attribute

Dmitry Osipenko <digetx@gmail.com>
    ASoC: tegra: Set driver_name=tegra for all machine drivers

Thomas Gleixner <tglx@linutronix.de>
    cpu/hotplug: Cure the cpusets trainwreck

Timo Sigurdsson <public_timo.s@silentcreek.de>
    ata: ahci_sunxi: Disable DIPM

Christian Löhle <CLoehle@hyperstone.com>
    mmc: core: Allow UHS-I voltage switch for SDSC cards if supported

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: core: clear flags before allowing to retune

Al Cooper <alcooperx@gmail.com>
    mmc: sdhci: Fix warning message when accessing RPMB in HS400 mode

Maximilian Luz <luzmaximilian@gmail.com>
    pinctrl/amd: Add device HID for new AMD GPIO controller

Jing Xiangfeng <jingxiangfeng@huawei.com>
    drm/radeon: Add the missed drm_gem_object_put() in radeon_user_framebuffer_create()

Andrew Gabbasov <andrew_gabbasov@mentor.com>
    usb: gadget: f_fs: Fix setting of device and driver data cross-references

Nathan Chancellor <nathan@kernel.org>
    powerpc/barrier: Avoid collision with clang's __lwsync macro

Davis Mosenkovs <davis@mosenkovs.lv>
    mac80211: fix memory corruption in EAPOL handling

Miklos Szeredi <mszeredi@redhat.com>
    fuse: reject internal errno

Mika Westerberg <mika.westerberg@linux.intel.com>
    bdi: Do not use freezable workqueue

Eric Biggers <ebiggers@google.com>
    fscrypt: don't ignore minor_hash when hash is 0

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: add size validation when walking chunks

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: validate from_addr_param return

Tim Jiang <tjiang@codeaurora.org>
    Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Bluetooth: Shutdown controller after workqueues are flushed or cancelled

Yu Liu <yudiliu@google.com>
    Bluetooth: Fix the HCI to MGMT status conversion table

Gerd Rausch <gerd.rausch@oracle.com>
    RDMA/cma: Fix rdma_resolve_route() memory leak

Gustavo A. R. Silva <gustavoars@kernel.org>
    wireless: wext-spy: Fix out-of-bounds warning

Íñigo Huguet <ihuguet@redhat.com>
    sfc: error code if SRIOV cannot be disabled

Íñigo Huguet <ihuguet@redhat.com>
    sfc: avoid double pci_remove of VFs

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: don't change band on bound PHY contexts

Xiao Yang <yangx.jy@fujitsu.com>
    RDMA/rxe: Don't overwrite errno from ib_umem_get()

Longpeng(Mike) <longpeng2@huawei.com>
    vsock: notify server to shutdown when client has pending signal

Zheyu Ma <zheyuma97@gmail.com>
    atm: nicstar: register the interrupt handler in the right place

Zheyu Ma <zheyuma97@gmail.com>
    atm: nicstar: use 'dma_free_coherent' instead of 'kfree'

Huang Pei <huangpei@loongson.cn>
    MIPS: add PMD table accounting into MIPS'pmd_alloc_one

Zou Wei <zou_wei@huawei.com>
    cw1200: add missing MODULE_DEVICE_TABLE

Lee Gibson <leegib@gmail.com>
    wl1251: Fix possible buffer overflow in wl1251_cmd_scan

Tony Lindgren <tony@atomide.com>
    wlcore/wl12xx: Fix wl12xx get_mac error if device is in ELP

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix error reporting in xfrm_state_construct.

Minchan Kim <minchan@kernel.org>
    selinux: use __GFP_NOWARN with GFP_NOWAIT in the AVC

Yang Yingliang <yangyingliang@huawei.com>
    fjes: check return value after calling platform_get_resource()

Yang Yingliang <yangyingliang@huawei.com>
    net: micrel: check return value after calling platform_get_resource()

Yang Yingliang <yangyingliang@huawei.com>
    net: bcmgenet: check return value after calling platform_get_resource()

Xianting Tian <xianting.tian@linux.alibaba.com>
    virtio_net: Remove BUG() to avoid machine dead

Joe Thornber <ejt@redhat.com>
    dm space maps: don't reset space map allocation cursor when committing

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    RDMA/cxgb4: Fix missing error code in create_qp()

Willy Tarreau <w@1wt.eu>
    ipv6: use prandom_u32() for ID generation

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: Ensure that PLLU configuration is applied properly

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    clk: renesas: r8a77995: Add ZA2 clock

Jesse Brandeburg <jesse.brandeburg@intel.com>
    e100: handle eeprom as little endian

Arturo Giusti <koredump@protonmail.com>
    udf: Fix NULL pointer dereference in udf_symlink function

Xie Yongji <xieyongji@bytedance.com>
    drm/virtio: Fix double free on probe failure

Pavel Skripkin <paskripkin@gmail.com>
    reiserfs: add check for invalid 1st journal block

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT

Zou Wei <zou_wei@huawei.com>
    atm: nicstar: Fix possible use-after-free in nicstar_cleanup()

Zou Wei <zou_wei@huawei.com>
    mISDN: fix possible use-after-free in HFC_cleanup()

Zou Wei <zou_wei@huawei.com>
    atm: iphase: fix possible use-after-free in ia_module_exit()

Bibo Mao <maobibo@loongson.cn>
    hugetlb: clear huge pte during flush function on mips platform

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()

Jack Zhang <Jack.Zhang1@amd.com>
    drm/amd/amdgpu/sriov disable all ip hw status by default

Thomas Zimmermann <tzimmermann@suse.de>
    drm/zte: Don't select DRM_KMS_FB_HELPER

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mxsfb: Don't select DRM_KMS_FB_HELPER

Quat Le <quat.le@oracle.com>
    scsi: core: Retry I/O for Notify (Enable Spinup) Required error

Johan Hovold <johan@kernel.org>
    mmc: vub3000: fix control-request direction

Dave Hansen <dave.hansen@linux.intel.com>
    selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really random

Miaohe Lin <linmiaohe@huawei.com>
    mm/huge_memory.c: don't discard hugepage if other processes are mapping it

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    leds: ktd2692: Fix an error handling path

Zhen Lei <thunder.leizhen@huawei.com>
    leds: as3645a: Fix error return code in as3645a_parse_node()

Chung-Chiang Cheng <shepjeng@gmail.com>
    configfs: fix memleak in configfs_release_bin_file

Marek Szyprowski <m.szyprowski@samsung.com>
    extcon: max8997: Add missing modalias string

Stephan Gerhold <stephan@gerhold.net>
    extcon: sm5502: Drop invalid register write in sm5502_reg_data

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    phy: ti: dm816x: Fix the error handling path in 'dm816x_usb_phy_probe()

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: mpt3sas: Fix error return value in _scsih_expander_add()

Geert Uytterhoeven <geert+renesas@glider.be>
    of: Fix truncation of memory sizes on 32-bit platforms

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Correct definition of CS42L42_ADC_PDN_MASK

Dan Carpenter <dan.carpenter@oracle.com>
    staging: gdm724x: check for overflow in gdm_lte_netif_rx()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: gdm724x: check for buffer overflow in gdm_lte_multi_sdu_pkt()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: mxs-lradc: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Andy Shevchenko <andy.shevchenko@gmail.com>
    eeprom: idt_89hpesx: Put fwnode in matching case during ->probe()

Randy Dunlap <rdunlap@infradead.org>
    s390: appldata depends on PROC_SYSCTL

Randy Dunlap <rdunlap@infradead.org>
    scsi: FlashPoint: Rename si_flags field

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: nozomi: Fix the error handling path of 'nozomi_card_init()'

Yu Kuai <yukuai3@huawei.com>
    char: pcmcia: error out if 'num_bytes_read' is greater than 4 in set_protocol()

Zhen Lei <thunder.leizhen@huawei.com>
    Input: hil_kbd - fix error return code in hil_dev_connect()

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: hisilicon: fix missing clk_disable_unprepare() on error in hi6210_i2s_startup()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: potentiostat: lmp91000: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: tcs3414: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: isl29125: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: prox: as3935: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: prox: pulsed-light: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: prox: srf08: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: humidity: am2315: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: gyro: bmg160: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: vf610: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-ads1015: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: stk8ba50: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: stk8312: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: kxcjk-1013: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: hid: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: bma180: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Nuno Sa <nuno.sa@analog.com>
    iio: adis_buffer: do not return ints in irq handlers

Arnd Bergmann <arnd@arndb.de>
    mwifiex: re-fix for unaligned accesses

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: nozomi: Fix a resource leak in an error handling function

Pavel Skripkin <paskripkin@gmail.com>
    net: sched: fix warning in tcindex_alloc_perfect_hash

Muchun Song <songmuchun@bytedance.com>
    writeback: fix obtain a reference to a freeing memcg css

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid

Dany Madden <drt@linux.ibm.com>
    Revert "ibmvnic: remove duplicate napi_schedule call in open function"

Dinghao Liu <dinghao.liu@zju.edu.cn>
    i40e: Fix error handling in i40e_vsi_open

Jian-Hong Pan <jhp@endlessos.org>
    net: bcmgenet: Fix attaching to PYH failed on RPi 4B

Eric Dumazet <edumazet@google.com>
    vxlan: add missing rcu_read_lock() in neigh_reduce()

Eric Dumazet <edumazet@google.com>
    pkt_sched: sch_qfq: fix qfq_change_class() error path

Pavel Skripkin <paskripkin@gmail.com>
    net: ethernet: ezchip: fix error handling

Pavel Skripkin <paskripkin@gmail.com>
    net: ethernet: ezchip: fix UAF in nps_enet_remove

Pavel Skripkin <paskripkin@gmail.com>
    net: ethernet: aeroflex: fix UAF in greth_of_remove

Wang Hai <wanghai38@huawei.com>
    samples/bpf: Fix the error return code of xdp_redirect's main()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_exthdr: check for IPv6 packet before further processing

Liu Shixin <liushixin2@huawei.com>
    netlabel: Fix memory leak in netlbl_mgmt_add_common

Yang Li <yang.lee@linux.alibaba.com>
    ath10k: Fix an error code in ath10k_add_interface()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    brcmsmac: mac80211_if: Fix a resource leak in an error handling path

Randy Dunlap <rdunlap@infradead.org>
    wireless: carl9170: fix LEDS build errors & warnings

Colin Ian King <colin.king@canonical.com>
    drm: qxl: ensure surf.data is ininitialized

Kamal Heib <kamalheib1@gmail.com>
    RDMA/rxe: Fix failure during driver load

Zhen Lei <thunder.leizhen@huawei.com>
    ehea: fix error return code in ehea_restart_qps()

Yang Yingliang <yangyingliang@huawei.com>
    drm/rockchip: cdn-dp-core: add missing clk_disable_unprepare() on error in cdn_dp_grf_write()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    net: pch_gbe: Propagate error from devm_gpio_request_one()

Dan Carpenter <dan.carpenter@oracle.com>
    ocfs2: fix snprintf() checking

Krzysztof Wilczyński <kw@linux.com>
    ACPI: sysfs: Fix a buffer overrun problem with description_show()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: nx - Fix RCU warning in nx842_OF_upd_status

Mirko Vogt <mirko-dev|linux@nanl.de>
    spi: spi-sun6i: Fix chipselect/clock bug

David Sterba <dsterba@suse.com>
    btrfs: clear log tree recovering status if starting transaction fails

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max31790) Fix fan speed reporting for fan7..12

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max31722) Remove non-standard ACPI device IDs

Dillon Min <dillon.minfei@gmail.com>
    media: s5p-g2d: Fix a memory leak on ctx->fh.m2m_ctx

Zhen Lei <thunder.leizhen@huawei.com>
    mmc: usdhi6rol0: fix error return code in usdhi6_probe()

Gustavo A. R. Silva <gustavoars@kernel.org>
    media: siano: Fix out-of-bounds warnings in smscore_load_firmware_family2()

Zhen Lei <thunder.leizhen@huawei.com>
    media: tc358743: Fix error return code in tc358743_probe_of()

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    media: exynos4-is: Fix a use after free in isp_video_release

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_ep93xx: fix deferred probing

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: ccp - Fix a resource leak in an error handling path

Sergey Shtylyov <s.shtylyov@omp.ru>
    pata_octeon_cf: avoid WARN_ON() in ata_host_activate()

Randy Dunlap <rdunlap@infradead.org>
    media: I2C: change 'RST' to "RSET" to fix multiple build errors

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_rb532_cf: fix deferred probing

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sata_highbank: fix deferred probing

Zhen Lei <thunder.leizhen@huawei.com>
    crypto: ux500 - Fix error return code in hash_hw_final()

Corentin Labbe <clabbe@baylibre.com>
    crypto: ixp4xx - dma_unmap the correct address

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: s5p_cec: decrement usage count if disabled

Arnd Bergmann <arnd@arndb.de>
    ia64: mca_drv: fix incorrect array size calculation

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Correct base usage for capacitive ExpressKey status bits

Richard Fitzgerald <rf@opensource.cirrus.com>
    ACPI: tables: Add custom DSDT file as makefile prerequisite

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    platform/x86: toshiba_acpi: Fix missing error code in toshiba_acpi_setup_keyboard()

Hanjun Guo <guohanjun@huawei.com>
    ACPI: bus: Call kobject_put() in acpi_init() error path

Erik Kaneda <erik.kaneda@intel.com>
    ACPICA: Fix memory leak caused by _CID repair function

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix memory leak when fenced

Richard Fitzgerald <rf@opensource.cirrus.com>
    random32: Fix implicit truncation warning in prandom_seed_state()

Alexander Aring <aahringo@redhat.com>
    fs: dlm: cancel work sync othercon

zhangyi (F) <yi.zhang@huawei.com>
    block_dump: remove block_dump feature in mark_inode_dirty()

Chris Chiu <chris.chiu@canonical.com>
    ACPI: EC: Make more Asus laptops use ECDT _GPE

Richard Fitzgerald <rf@opensource.cirrus.com>
    lib: vsprintf: Fix handling of number field widths in vsscanf

YueHaibing <yuehaibing@huawei.com>
    hv_utils: Fix passing zero to 'PTR_ERR' warning

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: processor idle: Fix up C-state latency if not ordered

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: do not use down_interruptible() when unbinding devices

Axel Lin <axel.lin@ingics.com>
    regulator: da9052: Ensure enough delay time for .set_voltage_time_sel

Christophe Leroy <christophe.leroy@csgroup.eu>
    btrfs: disable build on platforms having page size 256K

Josef Bacik <josef@toxicpanda.com>
    btrfs: abort transaction if we fail to update the delayed inode

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix error handling in __btrfs_update_delayed_inode

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: siano: fix device register error path

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvb_net: avoid speculation from net slot

Ard Biesheuvel <ardb@kernel.org>
    crypto: shash - avoid comparing pointers to exported functions under CFI

Zheyu Ma <zheyuma97@gmail.com>
    mmc: via-sdmmc: add a check against NULL pointer dereference

Dongliang Mu <mudongliangabcd@gmail.com>
    media: dvd_usb: memory leak in cinergyt2_fe_attach

Evgeny Novikov <novikov@ispras.ru>
    media: st-hva: Fix potential NULL pointer dereferences

Zheyu Ma <zheyuma97@gmail.com>
    media: bt8xx: Fix a missing check bug in bt878_probe

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release

Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
    media: em28xx: Fix possible memory leak of em28xx struct

Jack Xu <jack.xu@intel.com>
    crypto: qat - remove unused macro in FW loader

Jack Xu <jack.xu@intel.com>
    crypto: qat - check return code of qat_hal_rd_rel_reg()

Anirudh Rayabharam <mail@anirudhrb.com>
    media: pvrusb2: fix warning in pvr2_i2c_core_done

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cobalt: fix race condition in setting HPD

Pavel Skripkin <paskripkin@gmail.com>
    media: cpia2: fix memory leak in cpia2_usb_probe

Bixuan Cui <cuibixuan@huawei.com>
    crypto: nx - add missing MODULE_DEVICE_TABLE

Tian Tao <tiantao6@hisilicon.com>
    spi: omap-100k: Fix the length judgment problem

Jay Fang <f.fangjian@huawei.com>
    spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_messages()

Jay Fang <f.fangjian@huawei.com>
    spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'

Charles Keepax <ckeepax@opensource.cirrus.com>
    spi: Make of_register_spi_device also set the fwnode

Miklos Szeredi <mszeredi@redhat.com>
    fuse: check connected before queueing on fpq->io

Yun Zhou <yun.zhou@windriver.com>
    seq_buf: Make trace_seq_putmem_hex() support data longer than 8

Marek Vasut <marex@denx.de>
    rsi: Assign beacon rate settings to the correct rate_info descriptor field

Michael Buesch <m@bues.ch>
    ssb: sdio: Don't overwrite const buffer if block_write fails

Pali Rohár <pali@kernel.org>
    ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()

Ondrej Zary <linux@zary.sk>
    serial_cs: remove wrong GLOBETROTTER.cis entry

Ondrej Zary <linux@zary.sk>
    serial_cs: Add Option International GSM-Ready 56K/ISDN modem

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    serial: sh-sci: Stop dmaengine transfer in sci_stop_tx()

Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
    iio: ltr501: ltr501_read_ps(): add missing endianness conversion

Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
    iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR

Marc Kleine-Budde <mkl@pengutronix.de>
    iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and PS_DATA as volatile, too

Martin Fuzzey <martin.fuzzey@flowbird.group>
    rtc: stm32: Fix unbalanced clk_disable_unprepare() on probe error path

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: dont call css_wait_for_slow_path() inside a lock

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    SUNRPC: Should wake up the privileged task firstly.

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    SUNRPC: Fix the batch tasks count wraparound.

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path

Oliver Hartkopp <socketcan@hartkopp.net>
    can: gw: synchronize rcu operations before removing gw job entry

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    can: bcm: delay release of struct bcm_op after synchronize_rcu()

Stephen Brennan <stephen.s.brennan@oracle.com>
    ext4: use ext4_grp_locked_error in mb_find_extent

Pan Dong <pandong.peter@bytedance.com>
    ext4: fix avefreec in find_group_orlov

Zhang Yi <yi.zhang@huawei.com>
    ext4: remove check for zero nr_to_scan in ext4_es_scan()

Zhang Yi <yi.zhang@huawei.com>
    ext4: correct the cache_nr in tracepoint ext4_es_shrink_exit

Anirudh Rayabharam <mail@anirudhrb.com>
    ext4: fix kernel infoleak via ext4_extent_header

Zhang Yi <yi.zhang@huawei.com>
    ext4: cleanup in-core orphan list if ext4_truncate() failed to get a transaction handle

David Sterba <dsterba@suse.com>
    btrfs: clear defrag status of a root if starting transaction fails

Filipe Manana <fdmanana@suse.com>
    btrfs: send: fix invalid path for unlink operations after parent orphanization

Ludovic Desroches <ludovic.desroches@microchip.com>
    ARM: dts: at91: sama5d4: fix pinctrl muxing

Alexander Larkin <avlarkin82@gmail.com>
    Input: joydev - prevent use of not validated data in JSIOCSBTNMAP ioctl

Al Viro <viro@zeniv.linux.org.uk>
    iov_iter_fault_in_readable() should do nothing in xarray case

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    ntfs: fix validity check for file name attribute

Hannu Hartikainen <hannu@hrtk.in>
    USB: cdc-acm: blacklist Heimann USB Appset device

Linyu Yuan <linyyuan@codeaurora.com>
    usb: gadget: eem: fix echo command packet response issue

Pavel Skripkin <paskripkin@gmail.com>
    net: can: ems_usb: fix use-after-free in ems_usb_disconnect()

Johan Hovold <johan@kernel.org>
    Input: usbtouchscreen - fix control-request directions

Pavel Skripkin <paskripkin@gmail.com>
    media: dvb-usb: fix wrong definition

Daehwan Jung <dh10.jung@samsung.com>
    ALSA: usb-audio: fix rate on Ozone Z90 USB headset


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/am335x-cm-t335.dts               |  2 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    | 18 ++---
 arch/arm/boot/dts/exynos5422-odroidxu4.dts         |  2 +-
 arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi    |  4 +-
 arch/arm/boot/dts/r8a7779-marzen.dts               |  2 +-
 arch/arm/boot/dts/r8a7779.dtsi                     |  1 +
 arch/arm/boot/dts/sama5d4.dtsi                     |  2 +-
 arch/arm/probes/kprobes/test-thumb.c               | 10 +--
 .../arm64/boot/dts/qcom/msm8994-angler-rev-101.dts |  4 ++
 arch/hexagon/kernel/vmlinux.lds.S                  |  7 +-
 arch/ia64/kernel/mca_drv.c                         |  2 +-
 arch/mips/boot/compressed/Makefile                 |  4 +-
 arch/mips/boot/compressed/decompress.c             |  2 +
 arch/mips/include/asm/hugetlb.h                    |  8 ++-
 arch/mips/include/asm/pgalloc.h                    | 10 ++-
 arch/mips/vdso/vdso.h                              |  2 +-
 arch/powerpc/boot/devtree.c                        | 59 +++++++++-------
 arch/powerpc/boot/ns16550.c                        |  9 ++-
 arch/powerpc/include/asm/barrier.h                 |  2 +
 arch/powerpc/include/asm/ps3.h                     |  2 +
 arch/powerpc/platforms/ps3/mm.c                    | 12 ++++
 arch/s390/Kconfig                                  |  2 +-
 arch/s390/kernel/setup.c                           |  2 +-
 arch/um/drivers/chan_user.c                        |  3 +-
 arch/um/drivers/slip_user.c                        |  3 +-
 arch/x86/include/asm/fpu/internal.h                | 19 +++--
 arch/x86/kernel/fpu/regset.c                       |  2 +-
 arch/x86/kvm/cpuid.c                               |  8 ++-
 arch/x86/kvm/x86.c                                 |  2 +
 crypto/shash.c                                     | 18 ++++-
 drivers/acpi/Makefile                              |  5 ++
 drivers/acpi/acpi_amba.c                           |  1 +
 drivers/acpi/acpi_video.c                          |  9 +++
 drivers/acpi/acpica/nsrepair2.c                    |  7 ++
 drivers/acpi/bus.c                                 |  1 +
 drivers/acpi/device_sysfs.c                        |  2 +-
 drivers/acpi/ec.c                                  | 16 +++++
 drivers/acpi/processor_idle.c                      | 40 +++++++++++
 drivers/ata/ahci_sunxi.c                           |  2 +-
 drivers/ata/pata_ep93xx.c                          |  2 +-
 drivers/ata/pata_octeon_cf.c                       |  5 +-
 drivers/ata/pata_rb532_cf.c                        |  6 +-
 drivers/ata/sata_highbank.c                        |  6 +-
 drivers/atm/iphase.c                               |  2 +-
 drivers/atm/nicstar.c                              | 26 +++----
 drivers/block/virtio_blk.c                         |  2 +
 drivers/bluetooth/btusb.c                          |  5 ++
 drivers/char/ipmi/ipmi_watchdog.c                  | 22 +++---
 drivers/char/pcmcia/cm4000_cs.c                    |  4 ++
 drivers/char/virtio_console.c                      |  4 +-
 drivers/clk/renesas/r8a77995-cpg-mssr.c            |  1 +
 drivers/clk/tegra/clk-pll.c                        |  6 +-
 drivers/crypto/ccp/sp-pci.c                        |  6 +-
 drivers/crypto/ixp4xx_crypto.c                     |  2 +-
 drivers/crypto/nx/nx-842-pseries.c                 |  9 ++-
 drivers/crypto/qat/qat_common/qat_hal.c            |  6 +-
 drivers/crypto/qat/qat_common/qat_uclo.c           |  1 -
 drivers/crypto/ux500/hash/hash_core.c              |  1 +
 drivers/extcon/extcon-max8997.c                    |  1 +
 drivers/extcon/extcon-sm5502.c                     |  1 -
 drivers/firmware/qemu_fw_cfg.c                     |  8 +--
 drivers/gpio/gpio-zynq.c                           |  5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  2 +-
 drivers/gpu/drm/mxsfb/Kconfig                      |  1 -
 drivers/gpu/drm/qxl/qxl_dumb.c                     |  2 +
 drivers/gpu/drm/radeon/radeon_display.c            |  1 +
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |  1 +
 drivers/gpu/drm/virtio/virtgpu_kms.c               |  1 +
 drivers/gpu/drm/zte/Kconfig                        |  1 -
 drivers/hid/hid-core.c                             | 10 +--
 drivers/hid/wacom_wac.h                            |  2 +-
 drivers/hv/hv_util.c                               |  4 +-
 drivers/hwmon/max31722.c                           |  9 ---
 drivers/hwmon/max31790.c                           |  2 +-
 drivers/hwtracing/intel_th/core.c                  | 17 +++++
 drivers/hwtracing/intel_th/gth.c                   | 16 +++++
 drivers/hwtracing/intel_th/intel_th.h              |  3 +
 drivers/i2c/i2c-core-base.c                        |  3 +
 drivers/iio/accel/bma180.c                         | 10 ++-
 drivers/iio/accel/bma220_spi.c                     | 10 ++-
 drivers/iio/accel/hid-sensor-accel-3d.c            | 13 ++--
 drivers/iio/accel/kxcjk-1013.c                     | 24 ++++---
 drivers/iio/accel/stk8312.c                        | 12 ++--
 drivers/iio/accel/stk8ba50.c                       | 17 +++--
 drivers/iio/adc/mxs-lradc-adc.c                    |  3 +-
 drivers/iio/adc/ti-ads1015.c                       | 12 ++--
 drivers/iio/adc/vf610_adc.c                        | 10 ++-
 drivers/iio/gyro/bmg160_core.c                     | 10 ++-
 drivers/iio/humidity/am2315.c                      | 16 +++--
 drivers/iio/imu/adis_buffer.c                      |  3 -
 drivers/iio/light/isl29125.c                       | 10 ++-
 drivers/iio/light/ltr501.c                         | 15 ++--
 drivers/iio/light/tcs3414.c                        | 10 ++-
 drivers/iio/potentiostat/lmp91000.c                |  4 +-
 drivers/iio/proximity/as3935.c                     | 10 ++-
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  | 10 ++-
 drivers/iio/proximity/srf08.c                      | 14 ++--
 drivers/infiniband/core/cma.c                      |  3 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  1 +
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  2 +-
 drivers/infiniband/sw/rxe/rxe_net.c                | 10 ++-
 drivers/input/joydev.c                             |  2 +-
 drivers/input/keyboard/hil_kbd.c                   |  1 +
 drivers/input/touchscreen/usbtouchscreen.c         |  8 +--
 drivers/ipack/carriers/tpci200.c                   |  5 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |  2 +-
 drivers/leds/leds-as3645a.c                        |  1 +
 drivers/leds/leds-ktd2692.c                        | 27 ++++---
 drivers/md/persistent-data/dm-btree-remove.c       |  3 +-
 drivers/md/persistent-data/dm-space-map-disk.c     |  9 ++-
 drivers/md/persistent-data/dm-space-map-metadata.c |  9 ++-
 drivers/media/common/siano/smscoreapi.c            | 22 +++---
 drivers/media/common/siano/smscoreapi.h            |  4 +-
 drivers/media/common/siano/smsdvb-main.c           |  4 ++
 drivers/media/dvb-core/dvb_net.c                   | 25 +++++--
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  6 +-
 drivers/media/i2c/s5c73m3/s5c73m3.h                |  2 +-
 drivers/media/i2c/s5k4ecgx.c                       | 10 +--
 drivers/media/i2c/s5k5baf.c                        |  6 +-
 drivers/media/i2c/s5k6aa.c                         | 10 +--
 drivers/media/i2c/tc358743.c                       |  1 +
 drivers/media/pci/bt8xx/bt878.c                    |  3 +
 drivers/media/pci/cobalt/cobalt-driver.c           |  1 +
 drivers/media/pci/cobalt/cobalt-driver.h           |  7 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  7 +-
 drivers/media/platform/s5p-cec/s5p_cec.c           |  2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |  3 +
 drivers/media/platform/sti/hva/hva-hw.c            |  3 +-
 drivers/media/usb/cpia2/cpia2.h                    |  1 +
 drivers/media/usb/cpia2/cpia2_core.c               | 12 ++++
 drivers/media/usb/cpia2/cpia2_usb.c                | 13 ++--
 drivers/media/usb/dvb-usb/cinergyT2-core.c         |  2 +
 drivers/media/usb/dvb-usb/cxusb.c                  |  2 +-
 drivers/media/usb/dvb-usb/dtv5100.c                |  7 +-
 drivers/media/usb/em28xx/em28xx-input.c            |  8 ++-
 drivers/media/usb/gspca/sq905.c                    |  2 +-
 drivers/media/usb/gspca/sunplus.c                  |  8 ++-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |  4 +-
 drivers/media/usb/uvc/uvc_video.c                  | 27 +++++++
 drivers/media/usb/zr364xx/zr364xx.c                |  1 +
 drivers/media/v4l2-core/v4l2-fh.c                  |  1 +
 drivers/memory/atmel-ebi.c                         |  4 +-
 drivers/memory/fsl_ifc.c                           |  8 +--
 drivers/mfd/da9052-i2c.c                           |  1 +
 drivers/mfd/stmpe-i2c.c                            |  2 +-
 drivers/misc/eeprom/idt_89hpesx.c                  |  1 +
 drivers/misc/ibmasm/module.c                       |  5 +-
 drivers/mmc/core/core.c                            |  7 +-
 drivers/mmc/core/sd.c                              | 10 +--
 drivers/mmc/host/sdhci.c                           |  4 ++
 drivers/mmc/host/sdhci.h                           |  1 +
 drivers/mmc/host/usdhi6rol0.c                      |  1 +
 drivers/mmc/host/via-sdmmc.c                       |  3 +
 drivers/mmc/host/vub300.c                          |  2 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |  4 +-
 drivers/net/can/usb/ems_usb.c                      |  3 +-
 drivers/net/ethernet/aeroflex/greth.c              |  3 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  4 ++
 drivers/net/ethernet/ezchip/nps_enet.c             |  4 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |  9 +--
 drivers/net/ethernet/ibm/ibmvnic.c                 |  5 ++
 drivers/net/ethernet/intel/e100.c                  | 12 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  2 +
 drivers/net/ethernet/micrel/ks8842.c               |  4 ++
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   | 29 ++++----
 drivers/net/ethernet/sfc/ef10_sriov.c              | 25 ++++---
 drivers/net/fjes/fjes_main.c                       |  4 ++
 drivers/net/virtio_net.c                           |  7 +-
 drivers/net/vxlan.c                                |  2 +
 drivers/net/wireless/ath/ath10k/mac.c              |  1 +
 drivers/net/wireless/ath/ath9k/main.c              |  5 ++
 drivers/net/wireless/ath/carl9170/Kconfig          |  8 +--
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |  8 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 24 +++++--
 drivers/net/wireless/marvell/mwifiex/pcie.c        | 10 ++-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |  4 +-
 drivers/net/wireless/st/cw1200/cw1200_sdio.c       |  1 +
 drivers/net/wireless/ti/wl1251/cmd.c               |  9 ++-
 drivers/net/wireless/ti/wl12xx/main.c              |  7 ++
 drivers/of/fdt.c                                   |  8 +--
 drivers/of/of_reserved_mem.c                       |  8 +--
 drivers/pci/host/pci-aardvark.c                    | 59 ++++++++++++----
 drivers/pci/pci-label.c                            |  2 +-
 drivers/phy/ti/phy-dm816x-usb.c                    | 17 +++--
 drivers/pinctrl/pinctrl-amd.c                      |  1 +
 drivers/platform/x86/toshiba_acpi.c                |  1 +
 drivers/power/reset/gpio-poweroff.c                |  1 +
 drivers/power/supply/Kconfig                       |  3 +-
 drivers/power/supply/ab8500_btemp.c                |  1 +
 drivers/power/supply/ab8500_charger.c              | 19 ++++-
 drivers/power/supply/ab8500_fg.c                   |  1 +
 drivers/power/supply/charger-manager.c             |  1 +
 drivers/power/supply/max17042_battery.c            |  2 +-
 drivers/power/supply/rt5033_battery.c              |  7 ++
 drivers/pwm/pwm-spear.c                            |  4 --
 drivers/pwm/pwm-tegra.c                            | 13 ----
 drivers/regulator/da9052-regulator.c               |  3 +-
 drivers/reset/core.c                               |  5 +-
 drivers/reset/reset-a10sr.c                        |  1 +
 drivers/rtc/rtc-proc.c                             |  4 +-
 drivers/rtc/rtc-stm32.c                            |  6 +-
 drivers/s390/char/sclp_vt220.c                     |  4 +-
 drivers/s390/cio/chp.c                             |  3 +
 drivers/s390/cio/chsc.c                            |  2 -
 drivers/scsi/FlashPoint.c                          | 32 ++++-----
 drivers/scsi/be2iscsi/be_main.c                    |  5 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |  4 +-
 drivers/scsi/hosts.c                               |  4 ++
 drivers/scsi/libiscsi.c                            |  7 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  9 +++
 drivers/scsi/lpfc/lpfc_sli.c                       |  5 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  4 +-
 drivers/scsi/qedi/qedi_fw.c                        |  2 +-
 drivers/scsi/qedi/qedi_main.c                      |  2 +-
 drivers/scsi/scsi_lib.c                            |  1 +
 drivers/scsi/scsi_transport_iscsi.c                | 12 ++++
 drivers/spi/spi-loopback-test.c                    |  2 +-
 drivers/spi/spi-omap-100k.c                        |  2 +-
 drivers/spi/spi-sun6i.c                            |  6 +-
 drivers/spi/spi-topcliff-pch.c                     |  4 +-
 drivers/spi/spi.c                                  |  1 +
 drivers/ssb/sdio.c                                 |  1 -
 drivers/staging/gdm724x/gdm_lte.c                  | 20 ++++--
 drivers/staging/rtl8723bs/hal/odm.h                |  5 +-
 drivers/tty/nozomi.c                               |  9 ++-
 drivers/tty/serial/8250/serial_cs.c                | 13 +++-
 drivers/tty/serial/fsl_lpuart.c                    |  3 +
 drivers/tty/serial/sh-sci.c                        |  8 +++
 drivers/usb/class/cdc-acm.c                        |  5 ++
 drivers/usb/gadget/function/f_eem.c                | 43 ++++++++++--
 drivers/usb/gadget/function/f_fs.c                 | 67 +++++++++---------
 drivers/usb/gadget/function/f_hid.c                |  2 +-
 drivers/usb/gadget/legacy/hid.c                    |  4 +-
 drivers/video/backlight/lm3630a_bl.c               | 12 ++--
 drivers/w1/slaves/w1_ds2438.c                      |  4 +-
 drivers/watchdog/aspeed_wdt.c                      |  2 +-
 drivers/watchdog/iTCO_wdt.c                        | 12 +++-
 drivers/watchdog/lpc18xx_wdt.c                     |  2 +-
 drivers/watchdog/sbc60xxwdt.c                      |  2 +-
 drivers/watchdog/sc520_wdt.c                       |  2 +-
 drivers/watchdog/w83877f_wdt.c                     |  2 +-
 fs/btrfs/Kconfig                                   |  2 +
 fs/btrfs/delayed-inode.c                           | 18 +++--
 fs/btrfs/send.c                                    | 11 +++
 fs/btrfs/transaction.c                             |  6 +-
 fs/btrfs/tree-log.c                                |  1 +
 fs/ceph/addr.c                                     | 10 +--
 fs/configfs/file.c                                 | 10 +--
 fs/crypto/fname.c                                  |  9 +--
 fs/dlm/config.c                                    |  9 +++
 fs/dlm/lowcomms.c                                  |  2 +-
 fs/ext4/extents.c                                  |  3 +
 fs/ext4/extents_status.c                           |  4 +-
 fs/ext4/ialloc.c                                   | 11 ++-
 fs/ext4/mballoc.c                                  |  9 +--
 fs/ext4/super.c                                    |  9 ++-
 fs/f2fs/super.c                                    |  1 +
 fs/fs-writeback.c                                  | 34 ++-------
 fs/fuse/dev.c                                      | 11 ++-
 fs/jfs/inode.c                                     |  3 +-
 fs/jfs/jfs_logmgr.c                                |  1 +
 fs/nfs/inode.c                                     |  4 ++
 fs/nfs/nfs3proc.c                                  |  4 +-
 fs/nfs/pnfs_nfs.c                                  | 52 +++++++-------
 fs/ntfs/inode.c                                    |  2 +-
 fs/ocfs2/filecheck.c                               |  6 +-
 fs/ocfs2/stackglue.c                               |  8 +--
 fs/orangefs/super.c                                |  2 +-
 fs/reiserfs/journal.c                              | 14 ++++
 fs/ubifs/dir.c                                     |  7 ++
 fs/udf/namei.c                                     |  4 ++
 include/crypto/internal/hash.h                     |  8 +--
 include/linux/mfd/abx500/ux500_chargalg.h          |  2 +-
 include/linux/nfs_fs.h                             |  1 +
 include/linux/prandom.h                            |  2 +-
 include/net/sctp/structs.h                         |  2 +-
 include/scsi/scsi_transport_iscsi.h                |  2 +
 kernel/cpu.c                                       | 49 +++++++++++++
 kernel/trace/trace.c                               | 38 ++++------
 kernel/trace/trace_events_hist.c                   |  6 +-
 lib/decompress_unlz4.c                             |  8 +++
 lib/iov_iter.c                                     |  2 +-
 lib/kstrtox.c                                      | 13 +++-
 lib/kstrtox.h                                      |  2 +
 lib/seq_buf.c                                      |  8 ++-
 lib/vsprintf.c                                     | 82 +++++++++++++---------
 mm/backing-dev.c                                   |  4 +-
 mm/huge_memory.c                                   |  2 +-
 net/bluetooth/hci_core.c                           | 16 ++---
 net/bluetooth/mgmt.c                               |  6 ++
 net/bridge/br_multicast.c                          |  2 +
 net/can/bcm.c                                      |  7 +-
 net/can/gw.c                                       |  3 +
 net/core/dev.c                                     | 11 ++-
 net/ipv6/output_core.c                             | 28 ++------
 net/mac80211/rx.c                                  |  2 +-
 net/netfilter/nft_exthdr.c                         |  3 +
 net/netlabel/netlabel_mgmt.c                       | 19 ++---
 net/sched/cls_tcindex.c                            |  2 +-
 net/sched/sch_qfq.c                                |  8 +--
 net/sctp/bind_addr.c                               | 19 ++---
 net/sctp/input.c                                   |  8 ++-
 net/sctp/ipv6.c                                    |  7 +-
 net/sctp/protocol.c                                |  7 +-
 net/sctp/sm_make_chunk.c                           | 29 ++++----
 net/sunrpc/sched.c                                 | 12 +++-
 net/vmw_vsock/af_vsock.c                           |  2 +-
 net/wireless/wext-spy.c                            | 14 ++--
 net/xfrm/xfrm_user.c                               | 28 ++++----
 samples/bpf/xdp_redirect_user.c                    |  2 +-
 security/selinux/avc.c                             | 13 ++--
 security/smack/smackfs.c                           |  2 +
 sound/firewire/Kconfig                             |  5 +-
 sound/firewire/bebob/bebob.c                       |  5 +-
 sound/firewire/oxfw/oxfw.c                         |  2 +-
 sound/isa/cmi8330.c                                |  2 +-
 sound/isa/sb/sb16_csp.c                            |  8 ++-
 sound/pci/hda/hda_tegra.c                          |  3 +
 sound/ppc/powermac.c                               |  6 +-
 sound/soc/codecs/cs42l42.h                         |  2 +-
 sound/soc/hisilicon/hi6210-i2s.c                   | 14 ++--
 sound/soc/soc-core.c                               |  2 +-
 sound/soc/tegra/tegra_alc5632.c                    |  1 +
 sound/soc/tegra/tegra_max98090.c                   |  1 +
 sound/soc/tegra/tegra_rt5640.c                     |  1 +
 sound/soc/tegra/tegra_rt5677.c                     |  1 +
 sound/soc/tegra/tegra_sgtl5000.c                   |  1 +
 sound/soc/tegra/tegra_wm8753.c                     |  1 +
 sound/soc/tegra/tegra_wm8903.c                     |  1 +
 sound/soc/tegra/tegra_wm9712.c                     |  1 +
 sound/soc/tegra/trimslice.c                        |  1 +
 sound/usb/format.c                                 |  2 +
 .../selftests/powerpc/pmu/ebb/no_handler_test.c    |  2 -
 tools/testing/selftests/x86/protection_keys.c      |  3 +-
 337 files changed, 1686 insertions(+), 885 deletions(-)


