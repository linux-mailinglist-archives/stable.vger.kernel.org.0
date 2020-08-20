Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11324BA8E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgHTMLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730358AbgHTJ5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:57:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D938E2067C;
        Thu, 20 Aug 2020 09:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917461;
        bh=CbqwO4/PeU9yQYYtgn53lvGaKHCfl9FXIszWMtlfIvY=;
        h=From:To:Cc:Subject:Date:From;
        b=D7M5ee1EPWYi2JCNia8huEVbcXBAxY9nz9yX4doN5XRzmA1ALxmn48BvG7k9/R+6I
         n8MpI5zwBCewo15qpv10cdViJFq0piwFmrwYGgsemNw5OtX1eHKptzi+IgYvvdXL5t
         b+VphGq3jp8xnlU+w/9MTqSPku17zsdmFqFOb35c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/212] 4.9.233-rc1 review
Date:   Thu, 20 Aug 2020 11:19:33 +0200
Message-Id: <20200820091602.251285210@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.233-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.233-rc1
X-KernelTest-Deadline: 2020-08-22T09:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.233 release.
There are 212 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.233-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.233-rc1

Denis Efremov <efremov@linux.com>
    drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Oscar Salvador <osalvador@suse.de>
    mm: Avoid calling build_all_zonelists_init under hotplug context

Hugh Dickins <hughd@google.com>
    khugepaged: retract_page_tables() remember to test exit

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: landisk: Add missing initialization of sh_io_port_base

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ALSA: echoaudio: Fix potential Oops in snd_echo_resume()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: dln2: Run event handler loop under spinlock

Colin Ian King <colin.king@canonical.com>
    fs/ufs: avoid potential u32 multiplication overflow

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    nfs: Fix getxattr kernel panic and memory overflow

Wang Hai <wanghai38@huawei.com>
    net: qcom/emac: add missed clk_disable_unprepare in error path of emac_clks_phase1_init

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Fix two list_for_each loop exit tests

Colin Ian King <colin.king@canonical.com>
    Input: sentelic - fix error return when fsp_reg_write fails

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

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: image-convert: Combine rotate/no-rotate irq handlers

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix break and sysrq handling

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: clean up receive processing

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: make process-packet buffer unsigned

Charles Keepax <ckeepax@opensource.cirrus.com>
    mfd: arizona: Ensure 32k clock is put on driver unbind and error

Anton Blanchard <anton@ozlabs.org>
    pseries: Fix 64 bit logical memory block panic

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: clear watchdog timeout occurred flag

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: remove use of wrong watchdog_info option

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: indicate WDIOF_CARDRESET support in watchdog_info.options

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

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: make the balloon wait interruptible

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: fix accounting in alloc_xenballooned_pages error path

Nathan Huckleberry <nhuck@google.com>
    ARM: 8992/1: Fix unwind_frame for clang-built kernels

Sven Schnelle <svens@stackframe.org>
    parisc: mask out enable and reserved bits from sba imask

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

Qingyu Li <ieatmuttonchuan@gmail.com>
    net/nfc/rawsock.c: add CAP_NET_RAW check.

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Added needed_headroom and a skb->len check

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

Wang Hai <wanghai38@huawei.com>
    wl1251: fix always return 0 error

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: don't process empty bridge port events

Sandipan Das <sandipan@linux.ibm.com>
    selftests/powerpc: Fix online CPU selection

Harish <harish@linux.ibm.com>
    selftests/powerpc: Fix CPU affinity for child process

Tom Rix <trix@redhat.com>
    power: supply: check if calc_soc succeeded in pm860x_init_battery

Dan Carpenter <dan.carpenter@oracle.com>
    Smack: prevent underflow in smk_set_cipso()

Dan Carpenter <dan.carpenter@oracle.com>
    Smack: fix another vsscanf out of bounds

Finn Thain <fthain@telegraphics.com.au>
    scsi: mesh: Fix panic after host or bus reset

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc2: Fix error path in gadget registration

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

Chuhong Yuan <hslester96@gmail.com>
    media: omap3isp: Add missed v4l2_ctrl_handler_free() for preview_init_entities()

Arnd Bergmann <arnd@arndb.de>
    leds: lm355x: avoid enum conversion warning

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

Sasi Kumar <sasi.kumar@broadcom.com>
    bdc: Fix bug causing crash after multiple disconnects

Evgeny Novikov <novikov@ispras.ru>
    usb: gadget: net2280: fix memory leak on probe error handling paths

Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
    iwlegacy: Check the return value of pcie_capability_read_*()

Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>
    brcmfmac: To fix Bss Info flag definition Bug

Paul E. McKenney <paulmck@kernel.org>
    mm/mmap.c: Add cond_resched() for exit_mmap() CPU stalls

Michael Tretter <m.tretter@pengutronix.de>
    drm/debugfs: fix plain echo to connector "force" attribute

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau: fix multiple instances of reference count leaks

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

Yang Yingliang <yangyingliang@huawei.com>
    cgroup: add missing skcd->no_refcnt check in cgroup_sk_clone()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    gpio: fix oops resulting from calling of_get_named_gpio(NULL, ...)

Nick Desaulniers <ndesaulniers@google.com>
    tracepoint: Mark __tracepoint_string's __used

Eric Biggers <ebiggers@google.com>
    Smack: fix use-after-free in smk_write_relabel_self()

Rustam Kovhaev <rkovhaev@gmail.com>
    usb: hso: check for return value in hso_serial_common_create()

Hangbin Liu <liuhangbin@gmail.com>
    Revert "vxlan: fix tos value before xmit"

Johan Hovold <johan@kernel.org>
    net: lan78xx: replace bogus endpoint lookup

Ido Schimmel <idosch@mellanox.com>
    vxlan: Ensure FDB dump is performed under RCU

Cong Wang <xiyou.wangcong@gmail.com>
    ipv6: fix memory leaks on IPV6_ADDRFORM path

Ido Schimmel <idosch@mellanox.com>
    ipv4: Silence suspicious RCU usage warning

Jann Horn <jannh@google.com>
    binder: Prevent context manager from incrementing ref 0

Frank van der Linden <fllinden@amazon.com>
    xattr: break delegations in {set,remove}xattr

Philippe Duplessis-Guindon <pduplessis@efficios.com>
    tools lib traceevent: Fix memory leak in process_dynamic_array_len

Xin Xiong <xiongx18@fudan.edu.cn>
    atm: fix atm_dev refcnt leaks in atmtcp_remove_persistent

Francesco Ruggeri <fruggeri@arista.com>
    igb: reinit_locked() should be called with rtnl_lock

Julian Squires <julian@cipht.net>
    cfg80211: check vendor command doit pointer before use

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

Adam Ford <aford173@gmail.com>
    omapfb: dss: Fix max fclk divider for omap36xx

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Serialize ioctls

Roi Dayan <roid@mellanox.com>
    net/mlx5e: Don't support phys switch id if not in switchdev mode

Erik Ekman <erik@kryo.se>
    USB: serial: qcserial: add EM7305 QDL product ID

Jiang Ying <jiangying8582@126.com>
    ext4: fix direct I/O read error

Linus Torvalds <torvalds@linux-foundation.org>
    random32: move the pseudo-random 32-bit definitions to prandom.h

Linus Torvalds <torvalds@linux-foundation.org>
    random32: remove net_rand_state from the latent entropy gcc plugin

Willy Tarreau <w@1wt.eu>
    random: fix circular include dependency on arm64 after addition of percpu.h

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: percpu.h: fix build error

Willy Tarreau <w@1wt.eu>
    random32: update the net random state on interrupt and activity

Thomas Gleixner <tglx@linutronix.de>
    x86/i8259: Use printk_deferred() to prevent deadlock

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled

Andrea Righi <andrea.righi@canonical.com>
    xen-netfront: fix potential deadlock in xennet_remove()

Raviteja Narayanam <raviteja.narayanam@xilinx.com>
    Revert "i2c: cadence: Fix the hold bit setting"

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ethernet: ravb: exit if re-initialization fails in tx timeout

Liam Beguin <liambeguin@gmail.com>
    parisc: add support for cmpxchg on u8 pointers

Navid Emamdoost <navid.emamdoost@gmail.com>
    nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame

Laurence Oberman <loberman@redhat.com>
    qed: Disable "MFW indication via attention" SPAM every 5 minutes

Geert Uytterhoeven <geert@linux-m68k.org>
    usb: hso: Fix debug compile warning on sparc32

Robin Murphy <robin.murphy@arm.com>
    arm64: csum: Fix handling of bad packets

Remi Pommarel <repk@triplefau.lt>
    mac80211: mesh: Free pending skb when destroying a mpath

Remi Pommarel <repk@triplefau.lt>
    mac80211: mesh: Free ie data when leaving mesh

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Fix IRQ mapping disposal in error path

Ido Schimmel <idosch@mellanox.com>
    mlxsw: core: Free EMAD transactions using kfree_rcu()

Ido Schimmel <idosch@mellanox.com>
    mlxsw: core: Increase scope of RCU read-side critical section

Jakub Kicinski <kuba@kernel.org>
    mlx4: disable device on shutdown

Johan Hovold <johan@kernel.org>
    net: lan78xx: fix transfer-buffer memory leak

Johan Hovold <johan@kernel.org>
    net: lan78xx: add missing endpoint sanity check

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sh: Fix validation of system call number

YueHaibing <yuehaibing@huawei.com>
    net/x25: Fix null-ptr-deref in x25_disconnect

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/x25: Fix x25_neigh refcnt leak when x25 disconnect

Rolf Eike Beer <eb@emlix.com>
    install several missing uapi headers

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    uapi: includes linux/types.h before exporting files

Rik van Riel <riel@surriel.com>
    xfs: fix missed wakeup on l_flush_wait

Peilin Ye <yepeilin.cs@gmail.com>
    rds: Prevent kernel-infoleak in rds_notify_queue_get()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fbdev: Detect integer underflow at "struct fbcon_ops"->clear_margins.

Joerg Roedel <jroedel@suse.de>
    x86, vmlinux.lds: Page-align end of ..page_aligned sections

Sami Tolvanen <samitolvanen@google.com>
    x86/build/lto: Fix truncated .bss with -fdata-sections

Wang Hai <wanghai38@huawei.com>
    9p/trans_fd: Fix concurrency del of req_list in p9_fd_cancelled/p9_read_work

Dominique Martinet <dominique.martinet@cea.fr>
    9p/trans_fd: abort p9_read_work if req status changed

Sheng Yong <shengyong1@huawei.com>
    f2fs: check if file namelen exceeds max value

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: check memory boundary by insane namelen

Steve Cohen <cohens@codeaurora.org>
    drm: hold gem reference until object is no longer accessed

Peilin Ye <yepeilin.cs@gmail.com>
    drm/amdgpu: Prevent kernel-infoleak in amdgpu_info_ioctl()

Will Deacon <will@kernel.org>
    ARM: 8986/1: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Robert Hancock <hancockrwd@gmail.com>
    PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge

Navid Emamdoost <navid.emamdoost@gmail.com>
    ath9k: release allocated buffer if timed out

Navid Emamdoost <navid.emamdoost@gmail.com>
    ath9k_htc: release allocated buffer if timed out

Navid Emamdoost <navid.emamdoost@gmail.com>
    media: rc: prevent memory leak in cx23888_ir_probe

Navid Emamdoost <navid.emamdoost@gmail.com>
    crypto: ccp - Release all allocated memory if sha type is invalid

Wei Yongjun <weiyongjun1@huawei.com>
    net: phy: mdio-bcm-unimac: fix potential NULL dereference in unimac_mdio_probe()

Eric Sandeen <sandeen@sandeen.net>
    xfs: don't call xfs_da_shrink_inode with NULL bp

Dave Chinner <dchinner@redhat.com>
    xfs: validate cached inodes are free when allocated

Dave Chinner <dchinner@redhat.com>
    xfs: catch inode allocation state mismatch corruption


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio            |   3 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/percpu.h                      |   2 +
 arch/arm/kernel/hw_breakpoint.c                    |  27 ++++-
 arch/arm/kernel/stacktrace.c                       |  24 +++++
 arch/arm/mach-at91/pm.c                            |  11 +-
 arch/arm/mach-socfpga/pm.c                         |   8 +-
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts    |   1 +
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi         |  10 +-
 arch/arm64/include/asm/checksum.h                  |   5 +-
 arch/m68k/mac/iop.c                                |  21 ++--
 arch/mips/include/uapi/asm/Kbuild                  |   3 +
 arch/mips/kernel/topology.c                        |   2 +-
 arch/parisc/include/asm/cmpxchg.h                  |   2 +
 arch/parisc/lib/bitops.c                           |  12 +++
 arch/powerpc/include/asm/percpu.h                  |   4 +-
 arch/powerpc/include/uapi/asm/Kbuild               |   1 +
 arch/powerpc/kernel/vdso.c                         |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +-
 arch/sh/boards/mach-landisk/setup.c                |   3 +
 arch/sh/kernel/entry-common.S                      |   6 +-
 arch/x86/kernel/i8259.c                            |   2 +-
 arch/x86/kernel/vmlinux.lds.S                      |   3 +-
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/xtensa/kernel/perf_event.c                    |   2 +-
 drivers/acpi/acpica/exprep.c                       |   4 -
 drivers/acpi/acpica/utdelete.c                     |   6 +-
 drivers/android/binder.c                           |   9 ++
 drivers/atm/atmtcp.c                               |  10 +-
 drivers/char/agp/intel-gtt.c                       |   4 +-
 drivers/char/random.c                              |   1 +
 drivers/clk/sirf/clk-atlas6.c                      |   2 +-
 drivers/crypto/ccp/ccp-dev.h                       |   1 +
 drivers/crypto/ccp/ccp-ops.c                       |  40 +++++---
 drivers/crypto/qat/qat_common/qat_uclo.c           |   9 +-
 drivers/edac/edac_device_sysfs.c                   |   1 +
 drivers/edac/edac_pci_sysfs.c                      |   2 +-
 drivers/gpio/gpiolib-of.c                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   3 +-
 drivers/gpu/drm/drm_debugfs.c                      |   8 +-
 drivers/gpu/drm/drm_gem.c                          |  10 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |   6 +-
 drivers/gpu/drm/imx/imx-tve.c                      |  20 ++--
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   8 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   1 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   4 +-
 drivers/gpu/drm/panel/panel-simple.c               |   2 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |   2 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   4 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   4 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   4 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   8 +-
 drivers/gpu/ipu-v3/ipu-image-convert.c             |  58 ++++-------
 drivers/i2c/busses/i2c-cadence.c                   |   9 +-
 drivers/i2c/busses/i2c-rcar.c                      |   7 +-
 drivers/iio/dac/ad5592r-base.c                     |   4 +-
 drivers/input/mouse/sentelic.c                     |   2 +-
 drivers/iommu/omap-iommu-debug.c                   |   3 +
 drivers/leds/led-class.c                           |   1 +
 drivers/leds/leds-88pm860x.c                       |  14 ++-
 drivers/leds/leds-da903x.c                         |  14 ++-
 drivers/leds/leds-lm3533.c                         |  12 ++-
 drivers/leds/leds-lm355x.c                         |   7 +-
 drivers/leds/leds-wm831x-status.c                  |  14 ++-
 drivers/md/bcache/bset.c                           |   2 +-
 drivers/md/bcache/btree.c                          |   2 +-
 drivers/md/bcache/journal.c                        |   4 +-
 drivers/md/bcache/super.c                          |  11 +-
 drivers/md/md-cluster.c                            |   1 +
 drivers/md/raid5.c                                 |   3 +-
 drivers/media/firewire/firedtv-fw.c                |   2 +
 drivers/media/pci/cx23885/cx23888-ir.c             |   5 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   3 +
 drivers/media/platform/omap3isp/isppreview.c       |   4 +-
 drivers/mfd/arizona-core.c                         |  18 ++++
 drivers/mfd/dln2.c                                 |   4 +
 drivers/misc/cxl/sysfs.c                           |   2 +-
 drivers/mtd/mtdchar.c                              |  56 ++++++++--
 drivers/net/ethernet/freescale/fman/fman.c         |   3 +-
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |   4 +-
 drivers/net/ethernet/freescale/fman/fman_mac.h     |   2 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c   |   3 +-
 drivers/net/ethernet/freescale/fman/fman_port.c    |   9 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c    |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   9 ++
 drivers/net/ethernet/mellanox/mlx4/main.c          |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   8 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c          |   3 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |  17 +++-
 drivers/net/ethernet/renesas/ravb_main.c           |  26 ++++-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   3 +
 drivers/net/ethernet/toshiba/spider_net.c          |   4 +-
 drivers/net/phy/mdio-bcm-unimac.c                  |   2 +
 drivers/net/usb/hso.c                              |  10 +-
 drivers/net/usb/lan78xx.c                          | 113 ++++++---------------
 drivers/net/vxlan.c                                |  10 +-
 drivers/net/wan/lapbether.c                        |  10 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   3 +
 drivers/net/wireless/ath/ath9k/wmi.c               |   1 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |   2 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   4 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  22 ++--
 drivers/net/wireless/ti/wl1251/event.c             |   2 +-
 drivers/net/xen-netfront.c                         |  64 ++++++++----
 drivers/nfc/s3fwrn5/core.c                         |   1 +
 drivers/parisc/sba_iommu.c                         |   2 +-
 drivers/pci/access.c                               |   8 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |  14 ++-
 drivers/pci/pcie/aspm.c                            |   1 +
 drivers/pci/quirks.c                               |  13 +++
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
 drivers/scsi/scsi_debug.c                          |   6 ++
 drivers/staging/rtl8192u/r8192U_core.c             |   2 +-
 drivers/usb/dwc2/platform.c                        |   4 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c              |   4 +
 drivers/usb/gadget/udc/bdc/bdc_ep.c                |  16 +--
 drivers/usb/gadget/udc/net2280.c                   |   4 +-
 drivers/usb/serial/cp210x.c                        |  19 ++++
 drivers/usb/serial/ftdi_sio.c                      |  57 ++++++-----
 drivers/usb/serial/iuu_phoenix.c                   |  14 +--
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/video/console/bitblit.c                    |   4 +-
 drivers/video/console/fbcon_ccw.c                  |   4 +-
 drivers/video/console/fbcon_cw.c                   |   4 +-
 drivers/video/console/fbcon_ud.c                   |   4 +-
 drivers/video/console/newport_con.c                |  12 ++-
 drivers/video/console/vgacon.c                     |   4 +
 drivers/video/fbdev/neofb.c                        |   1 +
 drivers/video/fbdev/omap2/omapfb/dss/dss.c         |   2 +-
 drivers/video/fbdev/pxafb.c                        |   4 +-
 drivers/video/fbdev/sm712fb.c                      |   2 +
 drivers/watchdog/f71808e_wdt.c                     |  13 ++-
 drivers/xen/balloon.c                              |  12 ++-
 fs/9p/v9fs.c                                       |   5 +-
 fs/btrfs/disk-io.c                                 |  13 ++-
 fs/btrfs/extent_io.c                               |   2 +
 fs/btrfs/free-space-cache.c                        |   4 +-
 fs/btrfs/tree-log.c                                |   8 +-
 fs/cifs/smb2pdu.c                                  |   2 +
 fs/dlm/lockspace.c                                 |   6 +-
 fs/ext2/ialloc.c                                   |   3 +-
 fs/ext4/inode.c                                    |   5 +
 fs/f2fs/dir.c                                      |  12 ++-
 fs/minix/inode.c                                   |  36 ++++++-
 fs/minix/itree_common.c                            |   8 +-
 fs/nfs/nfs4proc.c                                  |   2 -
 fs/nfs/nfs4xdr.c                                   |   6 +-
 fs/ocfs2/ocfs2.h                                   |   4 +-
 fs/ocfs2/suballoc.c                                |   4 +-
 fs/ocfs2/super.c                                   |   4 +-
 fs/ufs/super.c                                     |   2 +-
 fs/xattr.c                                         |  84 +++++++++++++--
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   5 +-
 fs/xfs/xfs_icache.c                                |  58 +++++++++--
 fs/xfs/xfs_log.c                                   |   9 +-
 fs/xfs/xfs_reflink.c                               |  21 ++--
 include/asm-generic/vmlinux.lds.h                  |   5 +-
 include/linux/intel-iommu.h                        |   4 +-
 include/linux/mmzone.h                             |   3 +-
 include/linux/prandom.h                            |  78 ++++++++++++++
 include/linux/random.h                             |  63 +-----------
 include/linux/tracepoint.h                         |   2 +-
 include/linux/xattr.h                              |   2 +
 include/net/addrconf.h                             |   1 +
 include/net/sock.h                                 |   4 +
 include/uapi/drm/Kbuild                            |   3 +
 include/uapi/linux/Kbuild                          |  20 ++++
 include/uapi/linux/bcache.h                        |   2 +-
 include/uapi/linux/btrfs_tree.h                    |   2 +
 include/uapi/linux/cifs/Kbuild                     |   1 +
 include/uapi/linux/cryptouser.h                    |   2 +
 include/uapi/linux/genwqe/Kbuild                   |   1 +
 include/uapi/linux/pr.h                            |   2 +
 include/uapi/linux/qrtr.h                          |   1 +
 init/main.c                                        |   2 +-
 kernel/cgroup.c                                    |   2 +
 kernel/kprobes.c                                   |   7 ++
 kernel/time/timer.c                                |   8 ++
 kernel/trace/ftrace.c                              |  11 +-
 lib/dynamic_debug.c                                |  23 ++---
 lib/random32.c                                     |   2 +-
 mm/khugepaged.c                                    |  22 ++--
 mm/memory_hotplug.c                                |  10 +-
 mm/mmap.c                                          |   1 +
 mm/page_alloc.c                                    |   7 +-
 net/9p/trans_fd.c                                  |  56 +++++++---
 net/bluetooth/6lowpan.c                            |   5 +
 net/bluetooth/hci_event.c                          |  11 +-
 net/compat.c                                       |   1 +
 net/core/sock.c                                    |  21 ++++
 net/ipv4/fib_trie.c                                |   2 +-
 net/ipv6/anycast.c                                 |  17 +++-
 net/ipv6/ipv6_sockglue.c                           |   1 +
 net/mac80211/cfg.c                                 |   1 +
 net/mac80211/mesh_pathtbl.c                        |   1 +
 net/mac80211/sta_info.c                            |   2 +-
 net/nfc/rawsock.c                                  |   7 +-
 net/rds/recv.c                                     |   3 +-
 net/socket.c                                       |   2 +-
 net/wireless/nl80211.c                             |   6 +-
 net/x25/x25_subr.c                                 |   6 ++
 security/smack/smackfs.c                           |  19 +++-
 sound/core/seq/oss/seq_oss.c                       |   8 +-
 sound/pci/echoaudio/echoaudio.c                    |   2 -
 sound/usb/card.h                                   |   1 +
 sound/usb/mixer_quirks.c                           |   1 +
 sound/usb/pcm.c                                    |   6 ++
 sound/usb/quirks-table.h                           |  64 +++++++++++-
 sound/usb/quirks.c                                 |   3 +
 sound/usb/stream.c                                 |   1 +
 tools/lib/traceevent/event-parse.c                 |   1 +
 .../selftests/powerpc/benchmarks/context_switch.c  |  21 +++-
 tools/testing/selftests/powerpc/utils.c            |  37 ++++---
 227 files changed, 1495 insertions(+), 635 deletions(-)


