Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867D045DE5E
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 17:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356163AbhKYQNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 11:13:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354079AbhKYQLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 11:11:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 462FF610E8;
        Thu, 25 Nov 2021 16:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637856490;
        bh=YL/iWHBf2VNfZYu9/GTPbU3/S5M9Gx3YrK7Ifze2AzA=;
        h=From:To:Cc:Subject:Date:From;
        b=IobSaUdUD4vpJhUZFtFaC1v0xDUnS7JQgwsy00pUPZXcFCvVu/62jj53fYzHBj4iz
         fl0EOswDd0unXeObd4FzTQ9cd0cHAmUdvY+QP7LtXTgQms0PoW3Nrtg1qdtBHlWfTe
         6JOkVv7b/u05YU6JiBQDHzYyOsTUWsyS06Rm1heA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 000/248] 4.14.256-rc3 review
Date:   Thu, 25 Nov 2021 17:07:22 +0100
Message-Id: <20211125160530.072182872@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.256-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.256-rc3
X-KernelTest-Deadline: 2021-11-27T16:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.256 release.
There are 248 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 27 Nov 2021 16:04:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.256-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.256-rc3

Dmitry Osipenko <digetx@gmail.com>
    soc/tegra: pmc: Fix imbalanced clock disabling in error code path

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: max-3421: Use driver data instead of maintaining a list of bound devices

Takashi Iwai <tiwai@suse.de>
    ASoC: DAPM: Cover regression by kctl change notification fix

Leon Romanovsky <leonro@nvidia.com>
    RDMA/netlink: Add __maybe_unused to static inline in C file

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't always reallocate the fragmentation skb head

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reserve needed_*room for fragments

Sven Eckelmann <sven@narfation.org>
    batman-adv: Consider fragmentation for needed_headroom

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN

Greg Thelen <gthelen@google.com>
    perf/core: Avoid put_page() when GUP fails

hongao <hongao@uniontech.com>
    drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors

Johan Hovold <johan@kernel.org>
    drm/udl: fix control-message timeout

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Sven Schnelle <svens@stackframe.org>
    parisc/sticon: fix reverse colors

Nikolay Borisov <nborisov@suse.com>
    btrfs: fix memory ordering between normal and ordered work functions

Rustam Kovhaev <rkovhaev@gmail.com>
    mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

Nathan Chancellor <nathan@kernel.org>
    hexagon: export raw I/O routines for modules

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    tun: fix bonding active backup with arp monitoring

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix IIO event constraints for Skylake Server

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix filter_tid mask for CHA events on Skylake Server

Lin Ma <linma@zju.edu.cn>
    NFC: reorder the logic in nfc_{un,}register_device

Lin Ma <linma@zju.edu.cn>
    NFC: reorganize the functions in nci_request

Michal Maloszewski <michal.maloszewski@intel.com>
    i40e: Fix NULL ptr dereference on VSI filter sync

Jonathan Davies <jonathan.davies@nutanix.com>
    net: virtio_net_hdr_to_skb: count transport header in UFO

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    platform/x86: hp_accel: Fix an error handling path in 'lis3lv02d_probe()'

Randy Dunlap <rdunlap@infradead.org>
    mips: lantiq: add support for clk_get_parent()

Randy Dunlap <rdunlap@infradead.org>
    mips: bcm63xx: add support for clk_get_parent()

Colin Ian King <colin.i.king@googlemail.com>
    MIPS: generic/yamon-dt: fix uninitialized variable error

Surabhi Boob <surabhi.boob@intel.com>
    iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset

Pavel Skripkin <paskripkin@gmail.com>
    net: bnx2x: fix variable dereferenced before check

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()

Randy Dunlap <rdunlap@infradead.org>
    mips: BCM63XX: ensure that CPU_SUPPORTS_32BIT_KERNEL is set

Randy Dunlap <rdunlap@infradead.org>
    sh: define __BIG_ENDIAN for math-emu

Randy Dunlap <rdunlap@infradead.org>
    sh: fix kconfig unmet dependency warning for FRAME_POINTER

Lu Wei <luwei32@huawei.com>
    maple: fix wrong return value of maple_bus_init().

Nick Desaulniers <ndesaulniers@google.com>
    sh: check return code of request_irq

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/dcr: Use cmplwi instead of 3-argument cmpli

Chengfeng Ye <cyeaa@connect.ust.hk>
    ALSA: gus: fix null pointer dereference on pointer block

Anatolij Gustschin <agust@denx.de>
    powerpc/5200: dts: fix memory node unit name

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix alua_tg_pt_gps_count tracking

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix ordered tag handling

Bart Van Assche <bvanassche@acm.org>
    MIPS: sni: Fix the build

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    tty: tty_buffer: Fix the softlockup issue in flush_to_ldisc

Yang Yingliang <yangyingliang@huawei.com>
    usb: host: ohci-tmio: check return value after calling platform_get_resource()

Roger Quadros <rogerq@kernel.org>
    ARM: dts: omap: fix gpmc,mux-add-data type

Guo Zhi <qtxuning1999@sjtu.edu.cn>
    scsi: advansys: Fix kernel pointer leak

Yang Yingliang <yangyingliang@huawei.com>
    usb: musb: tusb6010: check return value after calling platform_get_resource()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()

Michal Simek <michal.simek@xilinx.com>
    arm64: zynqmp: Fix serial compatible string

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Destroy sysfs before freeing entries

Sven Schnelle <svens@stackframe.org>
    parisc/entry: fix trace test in syscall exit path

Paul Burton <paulburton@google.com>
    tracing: Resize tgid_map to pid_max, not PID_MAX_DEFAULT

Shaoying Xu <shaoyi@amazon.com>
    ext4: fix lazy initialization next schedule time computation in more granular unit

Pali Rohár <pali@kernel.org>
    PCI: Add PCI_EXP_DEVCTL_PAYLOAD_* macros

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: check the subchannel validity for dev_busid

Michal Hocko <mhocko@suse.com>
    mm, oom: do not trigger out_of_memory from the #PF

Vasily Averin <vvs@virtuozzo.com>
    mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix BPF_SUB when imm == 0x80000000

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Validate branch ranges

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/lib: Add helper to check if offset is within conditional branch range

Arnd Bergmann <arnd@arndb.de>
    ARM: 9156/1: drop cc-option fallbacks for architecture selection

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    ARM: 9155/1: fix early early_iounmap()

Johan Hovold <johan@kernel.org>
    USB: chipidea: fix interrupt deadlock

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    vsock: prevent unnecessary refcnt inc for nonblocking connect

Chengfeng Ye <cyeaa@connect.ust.hk>
    nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails

Eric Dumazet <edumazet@google.com>
    llc: fix out-of-bound array index in llc_sk_dev_hash()

Miaohe Lin <linmiaohe@huawei.com>
    mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and zs_unregister_migration()

Huang Guobin <huangguobin4@huawei.com>
    bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed

Hans de Goede <hdegoede@redhat.com>
    ACPI: PMIC: Fix intel_pmic_regs_handler() read accesses

Maxim Kiselev <bigunclemax@gmail.com>
    net: davinci_emac: Fix interrupt pacing disable

YueHaibing <yuehaibing@huawei.com>
    xen-pciback: Fix return in pm_ctrl_init()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: xlr: Fix a resource leak in the error handling path of 'xlr_i2c_probe()'

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Turn off target reset during issue_lip

Jackie Liu <liuyun01@kylinos.cn>
    ar7: fix kernel builds for compiler test

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: fix inaccurate report in WDIOC_GETTIMEOUT

Randy Dunlap <rdunlap@infradead.org>
    m68k: set a default value for MEMORY_RESERVE

Lars-Peter Clausen <lars@metafoo.de>
    dmaengine: dmaengine_desc_callback_valid(): Check for `callback_result`

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: fix OOB when mac header was cleared

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: ht16k33: Fix frame buffer device blanking

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: ht16k33: Connect backlight to fbdev

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: img-ascii-lcd: Fix lock-up when displaying empty string

Claudiu Beznea <claudiu.beznea@microchip.com>
    dmaengine: at_xdmac: fix AT_XDMAC_CC_PERID() macro

Evgeny Novikov <novikov@ispras.ru>
    mtd: spi-nor: hisi-sfc: Remove excessive clk_disable_unprepare()

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: orangefs: fix error return code of orangefs_revalidate_lookup()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix deadlocks in nfs_scan_commit_list()

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Don't spam about PIO Response Status

Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
    drm/plane-helper: fix uninitialized variable reference

Baptiste Lepers <baptiste.lepers@gmail.com>
    pnfs/flexfiles: Fix misplaced barrier in nfs4_ff_layout_prepare_ds

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    rpmsg: Fix rpmsg_create_ept return when RPMSG config is not defined

Tom Rix <trix@redhat.com>
    apparmor: fix error check

Hans de Goede <hdegoede@redhat.com>
    power: supply: bq27xxx: Fix kernel crash on IRQ handler register error

Geert Uytterhoeven <geert+renesas@glider.be>
    mips: cm: Convert to bitfield API to fix out-of-bounds access

Anssi Hannula <anssi.hannula@bitwise.fi>
    serial: xilinx_uartps: Fix race condition causing stuck TX

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Defer probe if request_threaded_irq() returns EPROBE_DEFER

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Correct some register default values

Leon Romanovsky <leonro@nvidia.com>
    RDMA/mlx4: Return missed an error if device doesn't support steering

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()

Jakob Hauser <jahau@rocketmail.com>
    power: supply: rt5033_battery: Change voltage values to µV

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: hid: fix error code in do_config()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_dw: Drop wrong use of ACPI_PTR()

Christophe Leroy <christophe.leroy@csgroup.eu>
    video: fbdev: chipsfb: use memset_io() instead of memset()

Dongliang Mu <mudongliangabcd@gmail.com>
    memory: fsl_ifc: fix leak of irq and nand_irq in fsl_ifc_ctrl_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    soc/tegra: Fix an error handling path in tegra_powergate_power_up()

Andreas Kemnade <andreas@kemnade.info>
    arm: dts: omap3-gta04a4: accelerometer irq fix

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Reduce udelay() at SKL+ position reporting

Dongliang Mu <mudongliangabcd@gmail.com>
    JFS: fix memleak in jfs_mount

Jackie Liu <liuyun01@kylinos.cn>
    MIPS: loongson64: make CPU_LOONGSON64 depends on MIPS_FP_SUPPORT

Tong Zhang <ztong0001@gmail.com>
    scsi: dc395: Fix error case unwinding

Peter Rosin <peda@axentia.se>
    ARM: dts: at91: tse850: the emac<->phy interface is rmii

Jackie Liu <liuyun01@kylinos.cn>
    ARM: s3c: irq-s3c24xx: Fix return value check for s3c24xx_init_intc()

Junji Wei <weijunji@bytedance.com>
    RDMA/rxe: Fix wrong port_cap_flags

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: Process crqs after enabling interrupts

Daniel Jordan <daniel.m.jordan@oracle.com>
    crypto: pcrypt - Delay write to padata->info

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: avoid mvneta warning when setting pause parameters

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Toggle PLL settings during rate change

Wang Hai <wanghai38@huawei.com>
    libertas: Fix possible memory leak in probe and disconnect

Wang Hai <wanghai38@huawei.com>
    libertas_tf: Fix possible memory leak in probe and disconnect

Tiezhu Yang <yangtiezhu@loongson.cn>
    samples/kretprobes: Fix return value if register_kretprobe() failed

Mark Rutland <mark.rutland@arm.com>
    irq: mips: avoid nested irq_enter()

David Hildenbrand <david@redhat.com>
    s390/gmap: don't unconditionally call pte_unmap_unlock() in __gmap_zap()

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: use netlbl_cfg_cipsov4_del() for deleting cipso_v4_doi

Anders Roxell <anders.roxell@linaro.org>
    PM: hibernate: fix sparse warnings

Stefan Agner <stefan@agner.ch>
    phy: micrel: ksz8041nl: do not use power down mode

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Send DELBA requests according to spec

Nathan Chancellor <nathan@kernel.org>
    platform/x86: thinkpad_acpi: Fix bitwise vs. logical warning

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: mxs-mmc: disable regulator on error and in the remove function

Jakub Kicinski <kuba@kernel.org>
    net: stream: don't purge sk_error_queue in sk_stream_kill_queues()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: uninitialized variable in msm_gem_import()

Sven Eckelmann <seckelmann@datto.com>
    ath10k: fix max antenna gain unit

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: Fix possible memleak in __hwmon_device_register()

Dan Carpenter <dan.carpenter@oracle.com>
    memstick: jmb38x_ms: use appropriate free function in jmb38x_ms_alloc_host()

Arnd Bergmann <arnd@arndb.de>
    memstick: avoid out-of-range warning

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

Linus Lüssing <ll@simonwunderlich.de>
    ath9k: Fix potential interrupt storm on queue reset

Anel Orazgaliyeva <anelkz@amazon.de>
    cpuidle: Fix kobject memory leaks in error paths

Colin Ian King <colin.king@canonical.com>
    media: cx23885: Fix snd_card_free call on null card pointer

Kees Cook <keescook@chromium.org>
    media: si470x: Avoid card name truncation

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: mtk-vpu: Fix a resource leak in the error handling path of 'mtk_vpu_probe()'

Pavel Skripkin <paskripkin@gmail.com>
    media: dvb-usb: fix ununit-value in az6027_rc_query

Waiman Long <longman@redhat.com>
    cgroup: Make rebind_subsystems() disable v2 controllers all at once

Sven Schnelle <svens@stackframe.org>
    parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling

Helge Deller <deller@gmx.de>
    task_stack: Fix end_of_stack() for architectures with upwards-growing stack

Sven Schnelle <svens@stackframe.org>
    parisc: fix warning in flush_tlb_all

Yang Yingliang <yangyingliang@huawei.com>
    spi: bcm-qspi: Fix missing clk_disable_unprepare() on error in bcm_qspi_probe()

Arnd Bergmann <arnd@arndb.de>
    ARM: 9136/1: ARMv7-M uses BE-8, not BE-32

Stephen Suryaputra <ssuryaextr@gmail.com>
    gre/sit: Don't generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE

Masami Hiramatsu <mhiramat@kernel.org>
    ARM: clang: Do not rely on lr register for stacktrace

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: use __GFP_NOFAIL for smk_cipso_doi()

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: disable RX-diversity in powersave

Ye Bin <yebin10@huawei.com>
    PM: hibernate: Get block device exclusively in swsusp_check()

Zheyu Ma <zheyuma97@gmail.com>
    mwl8k: Fix use-after-free in mwl8k_fw_state_machine()

Kalesh Singh <kaleshsingh@google.com>
    tracing/cfi: Fix cmp_entries_* functions signature mismatch

Lasse Collin <lasse.collin@tukaani.org>
    lib/xz: Validate the value before assigning it to an enum variable

Lasse Collin <lasse.collin@tukaani.org>
    lib/xz: Avoid overlapping memcpy() with invalid input with in-place decompression

Zheyu Ma <zheyuma97@gmail.com>
    memstick: r592: Fix a UAF bug when removing the driver

Kees Cook <keescook@chromium.org>
    leaking_addresses: Always print a trailing newline

André Almeida <andrealmeid@collabora.com>
    ACPI: battery: Accept charges over the design capacity as full

Tuo Li <islituo@gmail.com>
    ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Have tracefs directories not set OTH permission bits by default

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    media: usb: dvd-usb: fix uninit-value bug in dibusb_read_eeprom_byte()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Avoid evaluating methods too early during system resume

Randy Dunlap <rdunlap@infradead.org>
    ia64: don't do IA64_CMPXCHG_DEBUG without CONFIG_PRINTK

Rajat Asthana <rajatasthana4@gmail.com>
    media: mceusb: return without resubmitting URB in case of -EPROTO error.

Nadezda Lutovinova <lutovinova@ispras.ru>
    media: s5p-mfc: Add checking to s5p_mfc_probe().

Tuo Li <islituo@gmail.com>
    media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Set capability in s_param

Zheyu Ma <zheyuma97@gmail.com>
    media: netup_unidvb: handle interrupt properly according to the firmware

Dirk Bender <d.bender@phytec.de>
    media: mt9p031: Fix corrupted frame after restarting stream

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Properly initialize private structure on interface type changes

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type

Peter Zijlstra <peterz@infradead.org>
    x86: Increase exception stack sizes

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    smackfs: Fix use-after-free in netlbl_catmap_walk()

Peter Zijlstra <peterz@infradead.org>
    locking/lockdep: Avoid RCU-induced noinstr fail

Aleksander Jan Bajkowski <olek2@wp.pl>
    MIPS: lantiq: dma: reset correct number of channel

Aleksander Jan Bajkowski <olek2@wp.pl>
    MIPS: lantiq: dma: add small delay after reset

Barnabás Pőcze <pobrn@protonmail.com>
    platform/x86: wmi: do not fail if disabling fails

Wang ShaoBo <bobo.shaobowang@huawei.com>
    Bluetooth: fix use-after-free error in lock_sock_nested()

Takashi Iwai <tiwai@suse.de>
    Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()

Johan Hovold <johan@kernel.org>
    USB: iowarrior: fix control-message timeouts

Wang Hai <wanghai38@huawei.com>
    USB: serial: keyspan: fix memleak on probe errors

Pekka Korpinen <pekka.korpinen@iki.fi>
    iio: dac: ad5446: Fix ad5622_write() return value

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: core: fix possible memory leak in pinctrl_enable()

Zhang Yi <yi.zhang@huawei.com>
    quota: correct error number in free_dqentry()

Zhang Yi <yi.zhang@huawei.com>
    quota: check block number when reading the block in quota file

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Read all 16-bits from PCIE_MSI_PAYLOAD_REG

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Fix return value of MSI domain .alloc() method

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Do not unmask unused interrupts

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Do not clear status bits of masked interrupts

Juergen Gross <jgross@suse.com>
    xen/balloon: add late_initcall_sync() for initial ballooning done

Pavel Skripkin <paskripkin@gmail.com>
    ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume

Takashi Iwai <tiwai@suse.de>
    ALSA: mixer: oss: Fix racy access to slots

Pali Rohár <pali@kernel.org>
    serial: core: Fix initializing and restoring termios speed

Xiaoming Ni <nixiaoming@huawei.com>
    powerpc/85xx: Fix oops when mpc85xx_smp_guts_ids node cannot be found

Henrik Grimler <henrik@grimler.se>
    power: supply: max17042_battery: use VFSOC for capacity when no rsns

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    power: supply: max17042_battery: Prevent int underflow in set_soc_threshold

Eric W. Biederman <ebiederm@xmission.com>
    signal/mips: Update (_save|_restore)_fp_context to fail with -EFAULT

Eric W. Biederman <ebiederm@xmission.com>
    signal: Remove the bogus sigkill_pending in ptrace_stop

Alok Prasad <palok@marvell.com>
    RDMA/qedr: Fix NULL deref for query_qp on the GSI QP

Benjamin Li <benl@squareup.com>
    wcn36xx: handle connection loss indication

Reimar Döffinger <Reimar.Doeffinger@gmx.de>
    libata: fix checking of DMA state

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Read a PCI register after writing the TX ring write pointer

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix HT40 capability for 2Ghz band

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

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error handling when replaying directory deletes

Dongli Zhang <dongli.zhang@oracle.com>
    vmxnet3: do not stop tx queues after netif_device_detach()

Walter Stoll <walter.stoll@duagon.com>
    watchdog: Fix OMAP watchdog early handling

Thomas Perrot <thomas.perrot@bootlin.com>
    spi: spl022: fix Microwire full duplex mode

Dongli Zhang <dongli.zhang@oracle.com>
    xen/netfront: stop tx queues during live migration

Lorenz Bauer <lmb@cloudflare.com>
    bpf: Prevent increasing bpf_jit_limit above max

Randy Dunlap <rdunlap@infradead.org>
    mmc: winbond: don't build on M68K

Arnd Bergmann <arnd@arndb.de>
    hyperv/vmbus: include linux/bitops.h

Erik Ekman <erik@kryo.se>
    sfc: Don't use netif_info before net_device setup

Zheyu Ma <zheyuma97@gmail.com>
    cavium: Fix return values of the probe function

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: qla2xxx: Fix unmap of already freed sgl

Zheyu Ma <zheyuma97@gmail.com>
    cavium: Return negative value when pci_alloc_irq_vectors() fails

Sean Christopherson <seanjc@google.com>
    x86/irq: Ensure PI wakeup handler is unregistered before module unload

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Unconditionally unlink slave instances, too

Wang Wensheng <wangwensheng4@huawei.com>
    ALSA: timer: Fix use-after-free problem

Austin Kim <austin.kim@lge.com>
    ALSA: synth: missing check for possible NULL after the call to kstrdup

Johan Hovold <johan@kernel.org>
    ALSA: line6: fix control and interrupt message timeouts

Johan Hovold <johan@kernel.org>
    ALSA: 6fire: fix control and bulk message timeouts

Johan Hovold <johan@kernel.org>
    ALSA: ua101: fix division by zero at probe

Sean Young <sean@mess.org>
    media: ite-cir: IR receiver stop working after receive overflow

Dan Carpenter <dan.carpenter@oracle.com>
    tpm: Check for integer overflow in tpm2_map_response_body()

Helge Deller <deller@gmx.de>
    parisc: Fix ptrace check on syscall return

Christian Löhle <CLoehle@hyperstone.com>
    mmc: dw_mmc: Dont wait for DRTO on Write RSP error

Jan Kara <jack@suse.cz>
    ocfs2: fix data corruption on truncate

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    libata: fix read log timeout value

Takashi Iwai <tiwai@suse.de>
    Input: i8042 - Add quirk for Fujitsu Lifebook T725

Phoenix Huang <phoenix@emc.com.tw>
    Input: elantench - fix misreporting trackpoint coordinates

Todd Kjos <tkjos@google.com>
    binder: use cred instead of task for selinux checks

Todd Kjos <tkjos@google.com>
    binder: use euid from cred instead of using task

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix USB 3.1 enumeration issues by increasing roothub power-on-good delay


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   7 ++
 .../bindings/regulator/samsung,s5m8767.txt         |  23 ++---
 Makefile                                           |   4 +-
 arch/arm/Makefile                                  |  22 ++---
 arch/arm/boot/dts/at91-tse850-3.dts                |   2 +-
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi          |   2 +-
 arch/arm/boot/dts/omap3-gta04.dtsi                 |   2 +-
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi  |   2 +-
 arch/arm/kernel/stacktrace.c                       |   3 +-
 arch/arm/mm/Kconfig                                |   2 +-
 arch/arm/mm/mmu.c                                  |   4 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +-
 arch/hexagon/lib/io.c                              |   4 +
 arch/ia64/Kconfig.debug                            |   2 +-
 arch/m68k/Kconfig.machine                          |   1 +
 arch/mips/Kconfig                                  |   4 +
 arch/mips/bcm63xx/clk.c                            |   6 ++
 arch/mips/generic/yamon-dt.c                       |   2 +-
 arch/mips/include/asm/mips-cm.h                    |  12 +--
 arch/mips/kernel/mips-cm.c                         |  21 ++---
 arch/mips/kernel/r2300_fpu.S                       |   4 +-
 arch/mips/kernel/syscall.c                         |   9 --
 arch/mips/lantiq/clk.c                             |   6 ++
 arch/mips/lantiq/xway/dma.c                        |  14 ++-
 arch/mips/sni/time.c                               |   4 +-
 arch/parisc/kernel/entry.S                         |   4 +-
 arch/parisc/kernel/smp.c                           |  19 +++-
 arch/parisc/mm/init.c                              |   4 +-
 arch/powerpc/boot/dts/charon.dts                   |   2 +-
 arch/powerpc/boot/dts/digsy_mtc.dts                |   2 +-
 arch/powerpc/boot/dts/lite5200.dts                 |   2 +-
 arch/powerpc/boot/dts/lite5200b.dts                |   2 +-
 arch/powerpc/boot/dts/media5200.dts                |   2 +-
 arch/powerpc/boot/dts/mpc5200b.dtsi                |   2 +-
 arch/powerpc/boot/dts/o2d.dts                      |   2 +-
 arch/powerpc/boot/dts/o2d.dtsi                     |   2 +-
 arch/powerpc/boot/dts/o2dnt2.dts                   |   2 +-
 arch/powerpc/boot/dts/o3dnt.dts                    |   2 +-
 arch/powerpc/boot/dts/pcm032.dts                   |   2 +-
 arch/powerpc/boot/dts/tqm5200.dts                  |   2 +-
 arch/powerpc/include/asm/code-patching.h           |   1 +
 arch/powerpc/lib/code-patching.c                   |   7 +-
 arch/powerpc/net/bpf_jit.h                         |  33 ++++---
 arch/powerpc/net/bpf_jit_comp64.c                  |  37 +++++---
 arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c       |   3 +-
 arch/powerpc/sysdev/dcr-low.S                      |   2 +-
 arch/s390/mm/gmap.c                                |   5 +-
 arch/sh/Kconfig.debug                              |   1 +
 arch/sh/include/asm/sfp-machine.h                  |   8 ++
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                 |   5 +-
 arch/x86/events/intel/uncore_snbep.c               |   4 +
 arch/x86/include/asm/page_64_types.h               |   2 +-
 arch/x86/kernel/irq.c                              |   4 +-
 crypto/pcrypt.c                                    |  12 ++-
 drivers/acpi/acpica/acglobal.h                     |   2 +
 drivers/acpi/acpica/hwesleep.c                     |   8 +-
 drivers/acpi/acpica/hwsleep.c                      |  11 +--
 drivers/acpi/acpica/hwxfsleep.c                    |   7 ++
 drivers/acpi/battery.c                             |   2 +-
 drivers/acpi/pmic/intel_pmic.c                     |  51 +++++-----
 drivers/android/binder.c                           |  20 ++--
 drivers/ata/libata-core.c                          |   2 +-
 drivers/ata/libata-eh.c                            |   8 ++
 drivers/auxdisplay/ht16k33.c                       |  66 +++++++------
 drivers/auxdisplay/img-ascii-lcd.c                 |  10 ++
 drivers/char/hw_random/mtk-rng.c                   |   9 +-
 drivers/char/tpm/tpm2-space.c                      |   3 +
 drivers/cpuidle/sysfs.c                            |   5 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |  13 +++
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |   6 ++
 drivers/dma/at_xdmac.c                             |   2 +-
 drivers/dma/dmaengine.h                            |   2 +-
 drivers/edac/sb_edac.c                             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   1 +
 drivers/gpu/drm/drm_plane_helper.c                 |   1 -
 drivers/gpu/drm/msm/msm_gem.c                      |   4 +-
 drivers/gpu/drm/udl/udl_connector.c                |   2 +-
 drivers/hv/hyperv_vmbus.h                          |   1 +
 drivers/hwmon/hwmon.c                              |   6 +-
 drivers/hwmon/pmbus/lm25066.c                      |  23 +++++
 drivers/i2c/busses/i2c-xlr.c                       |   6 +-
 drivers/iio/dac/ad5446.c                           |   9 +-
 drivers/infiniband/hw/mlx4/qp.c                    |   4 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  15 +--
 drivers/infiniband/sw/rxe/rxe_param.h              |   2 +-
 drivers/input/mouse/elantech.c                     |  13 +++
 drivers/input/serio/i8042-x86ia64io.h              |  14 +++
 drivers/irqchip/irq-bcm6345-l1.c                   |   2 +-
 drivers/irqchip/irq-s3c24xx.c                      |  22 ++++-
 drivers/media/i2c/mt9p031.c                        |  28 +++++-
 drivers/media/pci/cx23885/cx23885-alsa.c           |   3 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  27 +++---
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |   5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   6 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   2 +-
 drivers/media/rc/ite-cir.c                         |   2 +-
 drivers/media/rc/mceusb.c                          |   1 +
 drivers/media/usb/dvb-usb/az6027.c                 |   1 +
 drivers/media/usb/dvb-usb/dibusb-common.c          |   2 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   7 +-
 drivers/memory/fsl_ifc.c                           |  13 ++-
 drivers/memstick/core/ms_block.c                   |   2 +-
 drivers/memstick/host/jmb38x_ms.c                  |   2 +-
 drivers/memstick/host/r592.c                       |   8 +-
 drivers/mmc/host/Kconfig                           |   2 +-
 drivers/mmc/host/dw_mmc.c                          |   3 +-
 drivers/mmc/host/mxs-mmc.c                         |  10 ++
 drivers/mtd/spi-nor/hisi-sfc.c                     |   1 -
 drivers/net/bonding/bond_sysfs_slave.c             |  36 +++----
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |   8 ++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  20 +++-
 .../net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h   |   4 +-
 drivers/net/ethernet/cavium/thunder/nic_main.c     |   2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   3 +
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +-
 drivers/net/ethernet/intel/i40evf/i40evf_main.c    |   2 +-
 drivers/net/ethernet/sfc/ptp.c                     |   4 +-
 drivers/net/ethernet/sfc/siena_sriov.c             |   2 +-
 drivers/net/ethernet/ti/davinci_emac.c             |  16 +++-
 drivers/net/phy/micrel.c                           |   5 +-
 drivers/net/phy/phylink.c                          |   2 +-
 drivers/net/tun.c                                  |   5 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   1 -
 drivers/net/wireless/ath/ath10k/mac.c              |   6 +-
 drivers/net/wireless/ath/ath10k/usb.c              |   7 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   3 +
 drivers/net/wireless/ath/ath6kl/usb.c              |   7 +-
 drivers/net/wireless/ath/ath9k/main.c              |   4 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |  10 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   4 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |  44 ++++++---
 drivers/net/wireless/broadcom/b43/phy_g.c          |   2 +-
 drivers/net/wireless/broadcom/b43legacy/radio.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   3 +
 drivers/net/wireless/marvell/libertas/if_usb.c     |   2 +
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   2 +
 drivers/net/wireless/marvell/mwifiex/11n.c         |   5 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  32 +++----
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   8 ++
 drivers/net/wireless/marvell/mwifiex/usb.c         |  16 ++++
 drivers/net/wireless/marvell/mwl8k.c               |   2 +-
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c |  14 +--
 drivers/net/xen-netfront.c                         |   8 ++
 drivers/nfc/pn533/pn533.c                          |   6 +-
 drivers/pci/host/pci-aardvark.c                    |  23 +++--
 drivers/pci/msi.c                                  |  24 ++---
 drivers/pci/quirks.c                               |   1 +
 drivers/pinctrl/core.c                             |   2 +
 drivers/platform/x86/hp_accel.c                    |   2 +
 drivers/platform/x86/thinkpad_acpi.c               |   2 +-
 drivers/platform/x86/wmi.c                         |   9 +-
 drivers/power/supply/bq27xxx_battery_i2c.c         |   3 +-
 drivers/power/supply/max17042_battery.c            |   8 +-
 drivers/power/supply/rt5033_battery.c              |   2 +-
 drivers/regulator/s5m8767.c                        |  21 ++---
 drivers/s390/cio/css.c                             |   4 +-
 drivers/scsi/advansys.c                            |   4 +-
 drivers/scsi/csiostor/csio_lnode.c                 |   2 +-
 drivers/scsi/dc395x.c                              |   1 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   1 +
 drivers/scsi/qla2xxx/qla_gbl.h                     |   2 -
 drivers/scsi/qla2xxx/qla_mr.c                      |  23 -----
 drivers/scsi/qla2xxx/qla_os.c                      |  27 +-----
 drivers/scsi/qla2xxx/qla_target.c                  |  14 +--
 drivers/sh/maple/maple.c                           |   5 +-
 drivers/soc/tegra/pmc.c                            |   4 +-
 drivers/spi/spi-bcm-qspi.c                         |   5 +-
 drivers/spi/spi-pl022.c                            |   5 +-
 drivers/target/target_core_alua.c                  |   1 -
 drivers/target/target_core_device.c                |   2 +
 drivers/target/target_core_internal.h              |   1 +
 drivers/target/target_core_transport.c             |  76 ++++++++++-----
 drivers/tty/serial/8250/8250_dw.c                  |   2 +-
 drivers/tty/serial/serial_core.c                   |  16 +++-
 drivers/tty/serial/xilinx_uartps.c                 |   3 +-
 drivers/tty/tty_buffer.c                           |   3 +
 drivers/usb/chipidea/core.c                        |  19 +++-
 drivers/usb/gadget/legacy/hid.c                    |   4 +-
 drivers/usb/host/max3421-hcd.c                     |  25 +----
 drivers/usb/host/ohci-tmio.c                       |   2 +-
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/misc/iowarrior.c                       |   8 +-
 drivers/usb/musb/tusb6010.c                        |   5 +
 drivers/usb/serial/keyspan.c                       |  15 ++-
 drivers/video/console/sticon.c                     |  12 +--
 drivers/video/fbdev/chipsfb.c                      |   2 +-
 drivers/watchdog/Kconfig                           |   2 +-
 drivers/watchdog/f71808e_wdt.c                     |   4 +-
 drivers/watchdog/omap_wdt.c                        |   6 +-
 drivers/xen/balloon.c                              |  86 ++++++++++++-----
 drivers/xen/xen-pciback/conf_space_capability.c    |   2 +-
 fs/btrfs/async-thread.c                            |  14 +++
 fs/btrfs/tree-log.c                                |   4 +-
 fs/ext4/super.c                                    |   9 +-
 fs/jfs/jfs_mount.c                                 |  51 +++++-----
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   4 +-
 fs/nfs/pnfs_nfs.c                                  |   4 +-
 fs/nfs/write.c                                     |  17 +---
 fs/ocfs2/file.c                                    |   8 +-
 fs/orangefs/dcache.c                               |   4 +-
 fs/quota/quota_tree.c                              |  15 +++
 fs/tracefs/inode.c                                 |   3 +-
 include/linux/console.h                            |   2 +
 include/linux/filter.h                             |   1 +
 include/linux/libata.h                             |   2 +-
 include/linux/lsm_hooks.h                          |  28 +++---
 include/linux/rpmsg.h                              |   2 +-
 include/linux/sched/task_stack.h                   |   4 +
 include/linux/security.h                           |  28 +++---
 include/linux/virtio_net.h                         |   7 +-
 include/net/llc.h                                  |   4 +-
 include/rdma/rdma_netlink.h                        |   2 +-
 include/target/target_core_base.h                  |   6 +-
 include/uapi/linux/pci_regs.h                      |   6 ++
 kernel/bpf/core.c                                  |   4 +-
 kernel/cgroup/cgroup.c                             |  31 ++++++-
 kernel/events/core.c                               |  10 +-
 kernel/locking/lockdep.c                           |   2 +-
 kernel/power/swap.c                                |   7 +-
 kernel/sched/core.c                                |   3 +
 kernel/signal.c                                    |  19 +---
 kernel/trace/trace.c                               |  62 ++++++++++---
 kernel/trace/tracing_map.c                         |  40 ++++----
 lib/decompress_unxz.c                              |   2 +-
 lib/xz/xz_dec_lzma2.c                              |  21 ++++-
 lib/xz/xz_dec_stream.c                             |   6 +-
 mm/oom_kill.c                                      |  23 ++---
 mm/slab.h                                          |   2 +-
 mm/zsmalloc.c                                      |   7 +-
 net/batman-adv/bridge_loop_avoidance.c             | 103 +++++++++++++++++----
 net/batman-adv/fragmentation.c                     |  26 ++++--
 net/batman-adv/hard-interface.c                    |   3 +
 net/batman-adv/multicast.c                         |  31 +++++++
 net/batman-adv/multicast.h                         |  15 +++
 net/batman-adv/soft-interface.c                    |   5 +-
 net/bluetooth/l2cap_sock.c                         |  10 +-
 net/bluetooth/sco.c                                |  24 +++--
 net/core/stream.c                                  |   3 -
 net/core/sysctl_net_core.c                         |   2 +-
 net/ipv6/addrconf.c                                |   3 +
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/nfc/core.c                                     |  32 ++++---
 net/nfc/nci/core.c                                 |  11 ++-
 net/vmw_vsock/af_vsock.c                           |   2 +
 net/wireless/util.c                                |   1 +
 samples/kprobes/kretprobe_example.c                |   2 +-
 scripts/leaking_addresses.pl                       |   3 +-
 security/apparmor/label.c                          |   4 +-
 security/integrity/evm/evm_main.c                  |   2 +-
 security/security.c                                |  14 +--
 security/selinux/hooks.c                           |  31 +++----
 security/smack/smackfs.c                           |  11 ++-
 sound/core/oss/mixer_oss.c                         |  43 +++++++--
 sound/core/timer.c                                 |  17 ++--
 sound/isa/gus/gus_dma.c                            |   2 +
 sound/pci/hda/hda_intel.c                          |  28 +++++-
 sound/soc/codecs/cs42l42.c                         |   9 +-
 sound/soc/soc-dapm.c                               |  29 ++++--
 sound/synth/emux/emux.c                            |   2 +-
 sound/usb/6fire/comm.c                             |   2 +-
 sound/usb/6fire/firmware.c                         |   6 +-
 sound/usb/line6/driver.c                           |  14 +--
 sound/usb/line6/driver.h                           |   2 +-
 sound/usb/line6/podhd.c                            |   6 +-
 sound/usb/line6/toneport.c                         |   2 +-
 sound/usb/misc/ua101.c                             |   4 +-
 269 files changed, 1681 insertions(+), 911 deletions(-)


