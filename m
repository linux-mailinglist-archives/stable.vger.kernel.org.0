Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A8224B893
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgHTLXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730508AbgHTKHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:07:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51067206DA;
        Thu, 20 Aug 2020 10:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918024;
        bh=VFS8MctRq9z6oYMS8Dqp6kOmFwdW15Qi5dDU+3G65fU=;
        h=From:To:Cc:Subject:Date:From;
        b=1HRCN2CG1Q7UXaNxpHIPXCatrWlKSZ3MTzBddtk56idq4wbD6y766mcN/5UeoPPeQ
         DZXmJpfha4pzFfc7vkl5mf1ho7vaw9efVWp2bo2WA58NfzXDPGjj3J9HTrsqnKFFiN
         Vo5CZntpFmqaw/ApEiMDxoYU4S6jvDpNAp2Q+1/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/228] 4.14.194-rc1 review
Date:   Thu, 20 Aug 2020 11:19:35 +0200
Message-Id: <20200820091607.532711107@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.194-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.194-rc1
X-KernelTest-Deadline: 2020-08-22T09:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.194 release.
There are 228 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.194-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.194-rc1

Denis Efremov <efremov@linux.com>
    drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Mike Snitzer <snitzer@redhat.com>
    dm cache: remove all obsolete writethrough-specific code

Mike Snitzer <snitzer@redhat.com>
    dm cache: submit writethrough writes in parallel to origin and cache

Mike Snitzer <snitzer@redhat.com>
    dm cache: pass cache structure to mode functions

Tomasz Maciej Nowak <tmn505@gmail.com>
    arm64: dts: marvell: espressobin: add ethernet alias

Thomas Gleixner <tglx@linutronix.de>
    genirq/affinity: Make affinity setting if activated opt-in

Thomas Gleixner <tglx@linutronix.de>
    genirq/affinity: Handle affinity setting on inactive interrupts correctly

Hugh Dickins <hughd@google.com>
    khugepaged: retract_page_tables() remember to test exit

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: landisk: Add missing initialization of sh_io_port_base

Daniel Díaz <daniel.diaz@linaro.org>
    tools build feature: Quote CC and CXX for their arguments

Vincent Whitchurch <vincent.whitchurch@axis.com>
    perf bench mem: Always memset source before memcpy

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ALSA: echoaudio: Fix potential Oops in snd_echo_resume()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: dln2: Run event handler loop under spinlock

Tiezhu Yang <yangtiezhu@loongson.cn>
    test_kmod: avoid potential double free in trigger_config_run_type()

Colin Ian King <colin.king@canonical.com>
    fs/ufs: avoid potential u32 multiplication overflow

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    nfs: Fix getxattr kernel panic and memory overflow

Wang Hai <wanghai38@huawei.com>
    net: qcom/emac: add missed clk_disable_unprepare in error path of emac_clks_phase1_init

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Fix two list_for_each loop exit tests

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Use correct vmw_legacy_display_unit pointer

Colin Ian King <colin.king@canonical.com>
    Input: sentelic - fix error return when fsp_reg_write fails

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: avoid race when unregistering slave

Thomas Hebb <tommyhebb@gmail.com>
    tools build feature: Use CC and CXX from parent

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    pwm: bcm-iproc: handle clk_get_rate() return

Xu Wang <vulab@iscas.ac.cn>
    clk: clk-atlas6: fix return value check in atlas6_clk_init()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: slave: only send STOP event when we have been addressed

Liu Yi L <yi.l.liu@intel.com>
    iommu/vt-d: Enforce PASID devTLB field mask

Colin Ian King <colin.king@canonical.com>
    iommu/omap: Check for failure of a call to omap_iommu_dump_ctx

Ming Lei <ming.lei@redhat.com>
    dm rq: don't call blk_mq_queue_stopped() in dm_stop_queue()

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: image-convert: Combine rotate/no-rotate irq handlers

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix break and sysrq handling

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: clean up receive processing

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: make process-packet buffer unsigned

Kamal Heib <kamalheib1@gmail.com>
    RDMA/ipoib: Return void from ipoib_ib_dev_stop()

Charles Keepax <ckeepax@opensource.cirrus.com>
    mfd: arizona: Ensure 32k clock is put on driver unbind and error

Liu Ying <victor.liu@nxp.com>
    drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix FUP packet state

Anton Blanchard <anton@ozlabs.org>
    pseries: Fix 64 bit logical memory block panic

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: clear watchdog timeout occurred flag

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: remove use of wrong watchdog_info option

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: indicate WDIOF_CARDRESET support in watchdog_info.options

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Use trace_sched_process_free() instead of exit() for pid tracing

Kevin Hao <haokexin@gmail.com>
    tracing/hwlat: Honor the tracing_cpumask

Muchun Song <songmuchun@bytedance.com>
    kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler

Chengming Zhou <zhouchengming@bytedance.com>
    ftrace: Setup correct FTRACE_FL_REGS flags for module

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: change slot number type s16 to u16

Mikulas Patocka <mpatocka@redhat.com>
    ext2: fix missing percpu_counter_inc

Huacai Chen <chenhc@lemote.com>
    MIPS: CPU#0 is not hotpluggable

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix misplaced while instead of if

Coly Li <colyli@suse.de>
    bcache: allocate meta data pages as compound pages

ChangSyun Peng <allenpeng@synology.com>
    md/raid5: Fix Force reconstruct-write io stuck in degraded raid5

Kees Cook <keescook@chromium.org>
    net/compat: Add missing sock updates for SCM_RIGHTS

Jonathan McDowell <noodles@earth.li>
    net: stmmac: dwmac1000: provide multicast filter fallback

Jonathan McDowell <noodles@earth.li>
    net: ethernet: stmmac: Disable hardware multicast filter

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Fix circular dependency between percpu.h and mmu.h

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix xtensa_pmu_setup prototype

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()

Christian Eggers <ceggers@arri.de>
    dt-bindings: iio: io-channel-mux: Fix compatible string in example code

Filipe Manana <fdmanana@suse.com>
    btrfs: fix memory leaks after failure to lookup checksums during inode logging

Josef Bacik <josef@toxicpanda.com>
    btrfs: only search for left_info if there is no right_info in try_merge_free_space

Qu Wenruo <wqu@suse.com>
    btrfs: don't allocate anonymous block device for user invisible roots

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: hotplug: ACPI: Fix context refcounting in acpiphp_grab_context()

Steve French <stfrench@microsoft.com>
    smb3: warn on confusing error scenario with sec=krb5

Tim Froidcoeur <tim.froidcoeur@tessares.net>
    net: initialize fastreuse on inet_inherit_port

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: make the balloon wait interruptible

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: fix accounting in alloc_xenballooned_pages error path

Jon Derrick <jonathan.derrick@intel.com>
    irqdomain/treewide: Free firmware node after domain removal

Nathan Huckleberry <nhuck@google.com>
    ARM: 8992/1: Fix unwind_frame for clang-built kernels

Sven Schnelle <svens@stackframe.org>
    parisc: mask out enable and reserved bits from sba imask

John David Anglin <dave.anglin@bell.net>
    parisc: Implement __smp_store_release and __smp_load_acquire barriers

Sivaprakash Murugesan <sivaprak@codeaurora.org>
    mtd: rawnand: qcom: avoid write to unavailable register

Christian Eggers <ceggers@arri.de>
    spi: spidev: Align buffers for DMA

Zheng Bin <zhengbin13@huawei.com>
    9p: Fix memory leak in v9fs_mount

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109

Eric Biggers <ebiggers@google.com>
    fs/minix: reject too-large maximum file size

Eric Biggers <ebiggers@google.com>
    fs/minix: don't allow getting deleted inodes

Eric Biggers <ebiggers@google.com>
    fs/minix: check return value of sb_getblk()

Jakub Kicinski <kuba@kernel.org>
    bitfield.h: don't compile-time validate _val in FIELD_FIT

Mikulas Patocka <mpatocka@redhat.com>
    crypto: cpt - don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified

John Allen <john.allen@amd.com>
    crypto: ccp - Fix use of merged scatterlists

Tom Rix <trix@redhat.com>
    crypto: qat - fix double free in qat_uclo_create_batch_init_list

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: add quirk for Pioneer DDJ-RB

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: fix overeager device match for MacroSilicon MS2109

Mirko Dietrich <buzz@l4m1.de>
    ALSA: usb-audio: Creative USB X-Fi Pro SB1095 volume knob support

Brant Merryman <brant.merryman@silabs.com>
    USB: serial: cp210x: enable usb generic throttle/unthrottle

Brant Merryman <brant.merryman@silabs.com>
    USB: serial: cp210x: re-enable auto-RTS on open

Miaohe Lin <linmiaohe@huawei.com>
    net: Set fput_needed iff FDPUT_FPUT is set

Tim Froidcoeur <tim.froidcoeur@tessares.net>
    net: refactor bind_bucket fastreuse into helper

Qingyu Li <ieatmuttonchuan@gmail.com>
    net/nfc/rawsock.c: add CAP_NET_RAW check.

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Added needed_headroom and a skb->len check

John Ogness <john.ogness@linutronix.de>
    af_packet: TPACKET_V3: fix fill status rwlock imbalance

Jian Cai <caij2003@gmail.com>
    crypto: aesni - add compatibility with IAS

Eric Dumazet <edumazet@google.com>
    x86/fsgsbase/64: Fix NULL deref in 86_fsgsbase_read_task

Drew Fustini <drew@beagleboard.org>
    pinctrl-single: fix pcs_parse_pinconf() return value

Wang Hai <wanghai38@huawei.com>
    dlm: Fix kobject memleak

Florinel Iordache <florinel.iordache@nxp.com>
    fsl/fman: fix eth hash table allocation

Florinel Iordache <florinel.iordache@nxp.com>
    fsl/fman: check dereferencing null pointer

Florinel Iordache <florinel.iordache@nxp.com>
    fsl/fman: fix unreachable code

Florinel Iordache <florinel.iordache@nxp.com>
    fsl/fman: fix dereference null return value

Florinel Iordache <florinel.iordache@nxp.com>
    fsl/fman: use 32-bit unsigned integer

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: spider_net: Fix the size used in a 'dma_free_coherent()' call

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    liquidio: Fix wrong return value in cn23xx_get_pf_num()

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    net: ethernet: aquantia: Fix wrong return value

Andrii Nakryiko <andriin@fb.com>
    tools, build: Propagate build failures from tools/build/Makefile.build

Wang Hai <wanghai38@huawei.com>
    wl1251: fix always return 0 error

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: don't process empty bridge port events

Sandipan Das <sandipan@linux.ibm.com>
    selftests/powerpc: Fix online CPU selection

Hanjun Guo <guohanjun@huawei.com>
    PCI: Release IVRS table in AMD ACS quirk

Harish <harish@linux.ibm.com>
    selftests/powerpc: Fix CPU affinity for child process

Nicolas Boichat <drinkcat@chromium.org>
    Bluetooth: hci_serdev: Only unregister device if it was registered

Tom Rix <trix@redhat.com>
    power: supply: check if calc_soc succeeded in pm860x_init_battery

Dan Carpenter <dan.carpenter@oracle.com>
    Smack: prevent underflow in smk_set_cipso()

Dan Carpenter <dan.carpenter@oracle.com>
    Smack: fix another vsscanf out of bounds

Chris Packham <chris.packham@alliedtelesis.co.nz>
    net: dsa: mv88e6xxx: MV88E6097 does not support jumbo configuration

Finn Thain <fthain@telegraphics.com.au>
    scsi: mesh: Fix panic after host or bus reset

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc2: Fix error path in gadget registration

Yu Kuai <yukuai3@huawei.com>
    MIPS: OCTEON: add missing put_device() call in dwc3_octeon_device_init()

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: tmc: Fix TMC mode read in tmc_read_unprepare_etb()

Dan Carpenter <dan.carpenter@oracle.com>
    thermal: ti-soc-thermal: Fix reversed condition in ti_thermal_expose_sensor()

Johan Hovold <johan@kernel.org>
    USB: serial: iuu_phoenix: fix led-activity helpers

Marco Felsch <m.felsch@pengutronix.de>
    drm/imx: tve: fix regulator_disable error path

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    PCI/ASPM: Add missing newline in sysfs 'policy'

Colin Ian King <colin.king@canonical.com>
    staging: rtl8192u: fix a dubious looking mask before a shift

Milton Miller <miltonm@us.ibm.com>
    powerpc/vdso: Fix vdso cpu truncation

Dan Carpenter <dan.carpenter@oracle.com>
    mwifiex: Prevent memory corruption handling keys

John Garry <john.garry@huawei.com>
    scsi: scsi_debug: Add check for sdebug_max_queue during module init

Tom Rix <trix@redhat.com>
    drm/bridge: sil_sii8620: initialize return of sii8620_readb

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: panel: simple: Fix bpc for LG LB070WV8 panel

Kai-Heng Feng <kai.heng.feng@canonical.com>
    leds: core: Flush scheduled work for system suspend

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Fix pci_cfg_wait queue locking problem

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix reflink quota reservation accounting error

Chuhong Yuan <hslester96@gmail.com>
    media: exynos4-is: Add missed check for pinctrl_lookup_state()

Dan Carpenter <dan.carpenter@oracle.com>
    media: firewire: Using uninitialized values in node_probe()

Julian Anastasov <ja@ssi.bg>
    ipvs: allow connection reuse for unconfirmed conntrack

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: eesox: Fix different dev_id between request_irq() and free_irq()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: powertec: Fix different dev_id between request_irq() and free_irq()

Colin Ian King <colin.king@canonical.com>
    drm/radeon: fix array out-of-bounds read and write issues

Wang Hai <wanghai38@huawei.com>
    cxl: Fix kobject memleak

Emil Velikov <emil.velikov@collabora.com>
    drm/mipi: use dcs write for mipi_dsi_dcs_set_tear_scanline

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: bxt_rt298: add missing .owner field

Chuhong Yuan <hslester96@gmail.com>
    media: omap3isp: Add missed v4l2_ctrl_handler_free() for preview_init_entities()

Arnd Bergmann <arnd@arndb.de>
    leds: lm355x: avoid enum conversion warning

Colin Ian King <colin.king@canonical.com>
    drm/arm: fix unintentional integer overflow on left shift

Tomasz Duszynski <tomasz.duszynski@octakon.com>
    iio: improve IIO_CONCENTRATION channel type description

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    video: pxafb: Fix the function used to balance a 'dma_alloc_coherent()' call

Dejin Zheng <zhengdejin5@gmail.com>
    console: newport_con: fix an issue about leak related system resources

Dejin Zheng <zhengdejin5@gmail.com>
    video: fbdev: sm712fb: fix an issue about iounmap for a wrong address

Qiushi Wu <wu000273@umn.edu>
    agp/intel: Fix a memory leak on module initialisation failure

Erik Kaneda <erik.kaneda@intel.com>
    ACPICA: Do not increment operation_region reference counts for field units

Coly Li <colyli@suse.de>
    bcache: fix super block seq numbers comparision in register_cache_set()

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix a BUG_ON in ddebug_describe_flags

Danesh Petigara <danesh.petigara@broadcom.com>
    usb: bdc: Halt controller on suspend

Sasi Kumar <sasi.kumar@broadcom.com>
    bdc: Fix bug causing crash after multiple disconnects

Evgeny Novikov <novikov@ispras.ru>
    usb: gadget: net2280: fix memory leak on probe error handling paths

Dmitry Osipenko <digetx@gmail.com>
    gpu: host1x: debug: Fix multiple channels emitting messages simultaneously

Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
    iwlegacy: Check the return value of pcie_capability_read_*()

Wright Feng <wright.feng@cypress.com>
    brcmfmac: set state of hanger slot to FREE when flushing PSQ

Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>
    brcmfmac: To fix Bss Info flag definition Bug

Paul E. McKenney <paulmck@kernel.org>
    mm/mmap.c: Add cond_resched() for exit_mmap() CPU stalls

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    irqchip/irq-mtk-sysirq: Replace spinlock with raw_spinlock

Michael Tretter <m.tretter@pengutronix.de>
    drm/debugfs: fix plain echo to connector "force" attribute

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau: fix multiple instances of reference count leaks

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    arm64: dts: hisilicon: hikey: fixes to comply with adi, adv7533 DT binding

Zhao Heming <heming.zhao@suse.com>
    md-cluster: fix wild pointer of unlock_all_bitmaps()

Evgeny Novikov <novikov@ispras.ru>
    video: fbdev: neofb: fix memory leak in neo_scan_monitor()

Aditya Pakki <pakki001@umn.edu>
    drm/radeon: Fix reference count leaks caused by pm_runtime_get_sync

Paul E. McKenney <paulmck@kernel.org>
    fs/btrfs: Add cond_resched() for try_release_extent_mapping() stalls

Lihong Kou <koulihong@huawei.com>
    Bluetooth: add a mutex lock to avoid UAF in do_enale_set

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/tilcdc: fix leak & null ref in panel_connector_get_modes

Yu Kuai <yukuai3@huawei.com>
    ARM: socfpga: PM: add missing put_device() call in socfpga_setup_ocram_self_refresh()

Dilip Kota <eswara.kota@linux.intel.com>
    spi: lantiq: fix: Rx overflow error in full duplex mode

yu kuai <yukuai3@huawei.com>
    ARM: at91: pm: add missing put_device() call in at91_pm_sram_init()

Lu Wei <luwei32@huawei.com>
    platform/x86: intel-vbtn: Fix return value check in check_acpi_dev()

Lu Wei <luwei32@huawei.com>
    platform/x86: intel-hid: Fix return value check in check_acpi_dev()

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Fix IOP status/control register writes

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Don't send IOP message until channel is idle

Alim Akhtar <alim.akhtar@samsung.com>
    arm64: dts: exynos: Fix silent hang after boot on Espresso

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Replace invalid bias-pull-none property

Qiushi Wu <wu000273@umn.edu>
    EDAC: Fix reference count leaks

Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
    arm64: dts: rockchip: fix rk3399-puma gmac reset gpio

Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
    arm64: dts: rockchip: fix rk3399-puma vcc5v0-host gpio

Peng Liu <iwtbavbm@gmail.com>
    sched: correct SD_flags returned by tl->sd_flags()

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    x86/mce/inject: Fix a wrong assignment of i_mce.status

Yang Yingliang <yangyingliang@huawei.com>
    cgroup: add missing skcd->no_refcnt check in cgroup_sk_clone()

Grant Likely <grant.likely@secretlab.ca>
    HID: input: Fix devices that return multiple bytes in battery report

Nick Desaulniers <ndesaulniers@google.com>
    tracepoint: Mark __tracepoint_string's __used

Eric Biggers <ebiggers@google.com>
    Smack: fix use-after-free in smk_write_relabel_self()

David Howells <dhowells@redhat.com>
    rxrpc: Fix race between recvmsg and sendmsg on immediate call failure

Rustam Kovhaev <rkovhaev@gmail.com>
    usb: hso: check for return value in hso_serial_common_create()

Willem de Bruijn <willemb@google.com>
    selftests/net: relax cpu affinity requirement in msg_zerocopy test

Hangbin Liu <liuhangbin@gmail.com>
    Revert "vxlan: fix tos value before xmit"

Peilin Ye <yepeilin.cs@gmail.com>
    openvswitch: Prevent kernel-infoleak in ovs_ct_put_key()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: gre: recompute gre csum for sctp over gre tunnels

Stephen Hemminger <stephen@networkplumber.org>
    hv_netvsc: do not use VF device if link is down

Johan Hovold <johan@kernel.org>
    net: lan78xx: replace bogus endpoint lookup

Ido Schimmel <idosch@mellanox.com>
    vxlan: Ensure FDB dump is performed under RCU

Landen Chao <landen.chao@mediatek.com>
    net: ethernet: mtk_eth_soc: fix MTU warnings

Cong Wang <xiyou.wangcong@gmail.com>
    ipv6: fix memory leaks on IPV6_ADDRFORM path

Ido Schimmel <idosch@mellanox.com>
    ipv4: Silence suspicious RCU usage warning

Frank van der Linden <fllinden@amazon.com>
    xattr: break delegations in {set,remove}xattr

Dexuan Cui <decui@microsoft.com>
    Drivers: hv: vmbus: Ignore CHANNELMSG_TL_CONNECT_RESULT(23)

Philippe Duplessis-Guindon <pduplessis@efficios.com>
    tools lib traceevent: Fix memory leak in process_dynamic_array_len

Xin Xiong <xiongx18@fudan.edu.cn>
    atm: fix atm_dev refcnt leaks in atmtcp_remove_persistent

Francesco Ruggeri <fruggeri@arista.com>
    igb: reinit_locked() should be called with rtnl_lock

Julian Squires <julian@cipht.net>
    cfg80211: check vendor command doit pointer before use

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: slave: add sanity check when unregistering

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: slave: improve sanity check when registering

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/fbcon: zero-initialise the mode_cmd2 structure

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/fbcon: fix module unload when fbcon init has failed for some reason

Christoph Hellwig <hch@lst.de>
    net/9p: validate fds in p9_fd_open

Johan Hovold <johan@kernel.org>
    leds: 88pm860x: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: lm3533: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: da903x: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: wm831x-status: fix use-after-free on unbind

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    mtd: properly check all write ioctls for permissions

Yunhai Zhang <zhangyunhai@nsfocus.com>
    vgacon: Fix for missing check in scrollback handling

Jann Horn <jannh@google.com>
    binder: Prevent context manager from incrementing ref 0

Adam Ford <aford173@gmail.com>
    omapfb: dss: Fix max fclk divider for omap36xx

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()

Suren Baghdasaryan <surenb@google.com>
    staging: android: ashmem: Fix lockdep warning for write operation

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Serialize ioctls

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: Fix ASMedia ASM1142 DMA addressing

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: define IDs for various ASMedia host controllers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: iowarrior: fix up report size handling for some devices

Roi Dayan <roid@mellanox.com>
    net/mlx5e: Don't support phys switch id if not in switchdev mode

Erik Ekman <erik@kryo.se>
    USB: serial: qcserial: add EM7305 QDL product ID


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio            |   3 +-
 .../bindings/iio/multiplexer/io-channel-mux.txt    |   2 +-
 Makefile                                           |   4 +-
 arch/arm/kernel/stacktrace.c                       |  24 +++
 arch/arm/mach-at91/pm.c                            |  11 +-
 arch/arm/mach-socfpga/pm.c                         |   8 +-
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts    |   1 +
 arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts  |  11 ++
 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts     |   2 +-
 .../boot/dts/marvell/armada-3720-espressobin.dts   |   6 +
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi         |  10 +-
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   4 +-
 arch/m68k/mac/iop.c                                |  21 +--
 arch/mips/cavium-octeon/octeon-usb.c               |   5 +-
 arch/mips/kernel/topology.c                        |   2 +-
 arch/parisc/include/asm/barrier.h                  |  61 ++++++++
 arch/powerpc/include/asm/percpu.h                  |   4 +-
 arch/powerpc/kernel/vdso.c                         |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +-
 arch/sh/boards/mach-landisk/setup.c                |   3 +
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S            |  14 +-
 arch/x86/kernel/apic/io_apic.c                     |   5 +
 arch/x86/kernel/apic/vector.c                      |   4 +
 arch/x86/kernel/cpu/mcheck/mce-inject.c            |   2 +-
 arch/x86/kernel/ptrace.c                           |   2 +-
 arch/xtensa/kernel/perf_event.c                    |   2 +-
 drivers/acpi/acpica/exprep.c                       |   4 -
 drivers/acpi/acpica/utdelete.c                     |   6 +-
 drivers/android/binder.c                           |  15 +-
 drivers/atm/atmtcp.c                               |  10 +-
 drivers/bluetooth/hci_serdev.c                     |   3 +-
 drivers/char/agp/intel-gtt.c                       |   4 +-
 drivers/clk/sirf/clk-atlas6.c                      |   2 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |   1 +
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |  12 +-
 drivers/crypto/cavium/cpt/request_manager.h        |   2 +
 drivers/crypto/ccp/ccp-dev.h                       |   1 +
 drivers/crypto/ccp/ccp-ops.c                       |  37 +++--
 drivers/crypto/qat/qat_common/qat_uclo.c           |   9 +-
 drivers/edac/edac_device_sysfs.c                   |   1 +
 drivers/edac/edac_pci_sysfs.c                      |   2 +-
 drivers/gpu/drm/arm/malidp_planes.c                |   2 +-
 drivers/gpu/drm/bridge/sil-sii8620.c               |   2 +-
 drivers/gpu/drm/drm_debugfs.c                      |   8 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |   6 +-
 drivers/gpu/drm/imx/imx-ldb.c                      |   7 +-
 drivers/gpu/drm/imx/imx-tve.c                      |  20 +--
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   8 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   3 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   4 +-
 drivers/gpu/drm/panel/panel-simple.c               |   2 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |   2 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   4 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   4 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   4 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |   5 +-
 drivers/gpu/host1x/debug.c                         |   4 +
 drivers/gpu/ipu-v3/ipu-image-convert.c             |  58 +++----
 drivers/hid/hid-input.c                            |   6 +-
 drivers/hv/channel_mgmt.c                          |  21 +--
 drivers/hv/vmbus_drv.c                             |   4 +
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |  13 +-
 drivers/i2c/busses/i2c-rcar.c                      |  15 +-
 drivers/i2c/i2c-core-slave.c                       |   7 +-
 drivers/iio/dac/ad5592r-base.c                     |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   4 +-
 drivers/input/mouse/sentelic.c                     |   2 +-
 drivers/iommu/intel_irq_remapping.c                |   8 +
 drivers/iommu/omap-iommu-debug.c                   |   3 +
 drivers/irqchip/irq-gic-v3-its.c                   |   5 +-
 drivers/irqchip/irq-mtk-sysirq.c                   |   8 +-
 drivers/leds/led-class.c                           |   1 +
 drivers/leds/leds-88pm860x.c                       |  14 +-
 drivers/leds/leds-da903x.c                         |  14 +-
 drivers/leds/leds-lm3533.c                         |  12 +-
 drivers/leds/leds-lm355x.c                         |   7 +-
 drivers/leds/leds-wm831x-status.c                  |  14 +-
 drivers/md/bcache/bset.c                           |   2 +-
 drivers/md/bcache/btree.c                          |   2 +-
 drivers/md/bcache/journal.c                        |   4 +-
 drivers/md/bcache/super.c                          |  11 +-
 drivers/md/dm-cache-target.c                       | 166 +++++++--------------
 drivers/md/dm-rq.c                                 |   3 -
 drivers/md/md-cluster.c                            |   1 +
 drivers/md/raid5.c                                 |   3 +-
 drivers/media/firewire/firedtv-fw.c                |   2 +
 drivers/media/platform/exynos4-is/media-dev.c      |   3 +
 drivers/media/platform/omap3isp/isppreview.c       |   4 +-
 drivers/mfd/arizona-core.c                         |  18 +++
 drivers/mfd/dln2.c                                 |   4 +
 drivers/misc/cxl/sysfs.c                           |   2 +-
 drivers/mtd/mtdchar.c                              |  56 +++++--
 drivers/mtd/nand/qcom_nandc.c                      |   7 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   1 -
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c  |   2 +-
 .../ethernet/cavium/liquidio/cn23xx_pf_device.c    |   2 +-
 drivers/net/ethernet/freescale/fman/fman.c         |   3 +-
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |   4 +-
 drivers/net/ethernet/freescale/fman/fman_mac.h     |   2 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c   |   3 +-
 drivers/net/ethernet/freescale/fman/fman_port.c    |   9 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c    |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   9 ++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |  17 ++-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   3 +
 drivers/net/ethernet/toshiba/spider_net.c          |   4 +-
 drivers/net/hyperv/netvsc_drv.c                    |   7 +-
 drivers/net/usb/hso.c                              |   5 +-
 drivers/net/usb/lan78xx.c                          | 117 ++++-----------
 drivers/net/vxlan.c                                |  10 +-
 drivers/net/wan/lapbether.c                        |  10 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |   2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   4 +
 drivers/net/wireless/intel/iwlegacy/common.c       |   4 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  22 ++-
 drivers/net/wireless/ti/wl1251/event.c             |   2 +-
 drivers/parisc/sba_iommu.c                         |   2 +-
 drivers/pci/access.c                               |   8 +-
 drivers/pci/host/vmd.c                             |   3 +
 drivers/pci/hotplug/acpiphp_glue.c                 |  14 +-
 drivers/pci/pcie/aspm.c                            |   1 +
 drivers/pci/quirks.c                               |   2 +
 drivers/pinctrl/pinctrl-single.c                   |  11 +-
 drivers/platform/x86/intel-hid.c                   |   2 +-
 drivers/platform/x86/intel-vbtn.c                  |   2 +-
 drivers/power/supply/88pm860x_battery.c            |   6 +-
 drivers/pwm/pwm-bcm-iproc.c                        |   9 +-
 drivers/s390/net/qeth_l2_main.c                    |   4 +
 drivers/scsi/arm/cumana_2.c                        |   2 +-
 drivers/scsi/arm/eesox.c                           |   2 +-
 drivers/scsi/arm/powertec.c                        |   2 +-
 drivers/scsi/mesh.c                                |   8 +-
 drivers/scsi/scsi_debug.c                          |   6 +
 drivers/spi/spi-lantiq-ssc.c                       |  10 ++
 drivers/spi/spidev.c                               |  21 ++-
 drivers/staging/android/ashmem.c                   |  12 ++
 drivers/staging/rtl8192u/r8192U_core.c             |   2 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |   2 +-
 drivers/usb/dwc2/platform.c                        |   4 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c              |  13 +-
 drivers/usb/gadget/udc/bdc/bdc_ep.c                |  16 +-
 drivers/usb/gadget/udc/net2280.c                   |   4 +-
 drivers/usb/host/xhci-pci.c                        |  10 +-
 drivers/usb/misc/iowarrior.c                       |  35 +++--
 drivers/usb/serial/cp210x.c                        |  19 +++
 drivers/usb/serial/ftdi_sio.c                      |  57 ++++---
 drivers/usb/serial/iuu_phoenix.c                   |  14 +-
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/video/console/newport_con.c                |  12 +-
 drivers/video/console/vgacon.c                     |   4 +
 drivers/video/fbdev/neofb.c                        |   1 +
 drivers/video/fbdev/omap2/omapfb/dss/dss.c         |   2 +-
 drivers/video/fbdev/pxafb.c                        |   4 +-
 drivers/video/fbdev/sm712fb.c                      |   2 +
 drivers/watchdog/f71808e_wdt.c                     |  13 +-
 drivers/xen/balloon.c                              |  12 +-
 fs/9p/v9fs.c                                       |   5 +-
 fs/btrfs/disk-io.c                                 |  13 +-
 fs/btrfs/extent_io.c                               |   2 +
 fs/btrfs/free-space-cache.c                        |   4 +-
 fs/btrfs/tree-log.c                                |   8 +-
 fs/cifs/smb2pdu.c                                  |   2 +
 fs/dlm/lockspace.c                                 |   6 +-
 fs/ext2/ialloc.c                                   |   3 +-
 fs/minix/inode.c                                   |  36 ++++-
 fs/minix/itree_common.c                            |   8 +-
 fs/nfs/nfs4proc.c                                  |   2 -
 fs/nfs/nfs4xdr.c                                   |   6 +-
 fs/ocfs2/ocfs2.h                                   |   4 +-
 fs/ocfs2/suballoc.c                                |   4 +-
 fs/ocfs2/super.c                                   |   4 +-
 fs/ufs/super.c                                     |   2 +-
 fs/xattr.c                                         |  84 ++++++++++-
 fs/xfs/xfs_reflink.c                               |  21 ++-
 include/linux/bitfield.h                           |   2 +-
 include/linux/hyperv.h                             |   2 +
 include/linux/intel-iommu.h                        |   4 +-
 include/linux/irq.h                                |  12 ++
 include/linux/tracepoint.h                         |   2 +-
 include/linux/xattr.h                              |   2 +
 include/net/addrconf.h                             |   1 +
 include/net/inet_connection_sock.h                 |   4 +
 include/net/ip_vs.h                                |  10 +-
 include/net/sock.h                                 |   4 +
 kernel/cgroup/cgroup.c                             |   2 +
 kernel/irq/manage.c                                |  41 ++++-
 kernel/kprobes.c                                   |   7 +
 kernel/sched/topology.c                            |   2 +-
 kernel/trace/ftrace.c                              |  15 +-
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_hwlat.c                         |   5 +-
 lib/dynamic_debug.c                                |  23 ++-
 lib/test_kmod.c                                    |   2 +-
 mm/khugepaged.c                                    |  22 +--
 mm/mmap.c                                          |   1 +
 net/9p/trans_fd.c                                  |  24 ++-
 net/bluetooth/6lowpan.c                            |   5 +
 net/bluetooth/hci_event.c                          |  11 +-
 net/compat.c                                       |   1 +
 net/core/sock.c                                    |  21 +++
 net/ipv4/fib_trie.c                                |   2 +-
 net/ipv4/gre_offload.c                             |  13 +-
 net/ipv4/inet_connection_sock.c                    |  93 ++++++------
 net/ipv4/inet_hashtables.c                         |   1 +
 net/ipv6/anycast.c                                 |  17 ++-
 net/ipv6/ipv6_sockglue.c                           |   1 +
 net/mac80211/sta_info.c                            |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  12 +-
 net/nfc/rawsock.c                                  |   7 +-
 net/openvswitch/conntrack.c                        |  38 ++---
 net/packet/af_packet.c                             |   9 +-
 net/rxrpc/call_object.c                            |  27 +++-
 net/rxrpc/conn_object.c                            |   8 +-
 net/rxrpc/recvmsg.c                                |   2 +-
 net/rxrpc/sendmsg.c                                |   3 +
 net/socket.c                                       |   2 +-
 net/wireless/nl80211.c                             |   6 +-
 security/smack/smackfs.c                           |  19 ++-
 sound/core/seq/oss/seq_oss.c                       |   8 +-
 sound/pci/echoaudio/echoaudio.c                    |   2 -
 sound/soc/intel/boards/bxt_rt298.c                 |   2 +
 sound/usb/card.h                                   |   1 +
 sound/usb/mixer_quirks.c                           |   1 +
 sound/usb/pcm.c                                    |   6 +
 sound/usb/quirks-table.h                           |  64 +++++++-
 sound/usb/quirks.c                                 |   3 +
 sound/usb/stream.c                                 |   1 +
 tools/build/Build.include                          |   3 +-
 tools/build/Makefile.feature                       |   2 +-
 tools/build/feature/Makefile                       |   2 -
 tools/lib/traceevent/event-parse.c                 |   1 +
 tools/perf/bench/mem-functions.c                   |  21 +--
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  21 +--
 tools/testing/selftests/net/msg_zerocopy.c         |   5 +-
 .../selftests/powerpc/benchmarks/context_switch.c  |  21 ++-
 tools/testing/selftests/powerpc/utils.c            |  37 +++--
 243 files changed, 1619 insertions(+), 825 deletions(-)


