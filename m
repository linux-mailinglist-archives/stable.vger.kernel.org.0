Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6BC24B50E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbgHTKRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729352AbgHTKRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:17:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 452F220738;
        Thu, 20 Aug 2020 10:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918632;
        bh=Fd3+vAswcL+9J80H8KsNS6pqWL+TSATqOXnHB7Ldq0Q=;
        h=From:To:Cc:Subject:Date:From;
        b=Npj3xefbBdtrhNpz5sIrDoc8nk+taM+c/WK+TL8Js1EaF68hmB7AXKxo77t6GzDz7
         3zHns73ezhBQQV+Oq5UgdwmVjU4t44DT/HgTtpFc3hp3VTB6U0rAqzmKJt01kwf7wB
         dBwLh02zo061p7R5zBkIuuIRNkPQW7PreADKlfEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 000/149] 4.4.233-rc1 review
Date:   Thu, 20 Aug 2020 11:21:17 +0200
Message-Id: <20200820092125.688850368@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.233-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.233-rc1
X-KernelTest-Deadline: 2020-08-22T09:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.233 release.
There are 149 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 Aug 2020 09:21:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.233-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.233-rc1

WANG Cong <xiyou.wangcong@gmail.com>
    ipv6: check skb->protocol before lookup for nexthop

Denis Efremov <efremov@linux.com>
    drm/radeon: fix fb_div check in ni_init_smc_spll_table()

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

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Fix two list_for_each loop exit tests

Colin Ian King <colin.king@canonical.com>
    Input: sentelic - fix error return when fsp_reg_write fails

Xu Wang <vulab@iscas.ac.cn>
    clk: clk-atlas6: fix return value check in atlas6_clk_init()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: slave: only send STOP event when we have been addressed

Liu Yi L <yi.l.liu@intel.com>
    iommu/vt-d: Enforce PASID devTLB field mask

Colin Ian King <colin.king@canonical.com>
    iommu/omap: Check for failure of a call to omap_iommu_dump_ctx

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix break and sysrq handling

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: clean up receive processing

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: make process-packet buffer unsigned

Anton Blanchard <anton@ozlabs.org>
    pseries: Fix 64 bit logical memory block panic

Muchun Song <songmuchun@bytedance.com>
    kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler

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

Jonathan McDowell <noodles@earth.li>
    net: stmmac: dwmac1000: provide multicast filter fallback

Jonathan McDowell <noodles@earth.li>
    net: ethernet: stmmac: Disable hardware multicast filter

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Fix circular dependency between percpu.h and mmu.h

Filipe Manana <fdmanana@suse.com>
    btrfs: fix memory leaks after failure to lookup checksums during inode logging

Josef Bacik <josef@toxicpanda.com>
    btrfs: only search for left_info if there is no right_info in try_merge_free_space

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: hotplug: ACPI: Fix context refcounting in acpiphp_grab_context()

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

Tom Rix <trix@redhat.com>
    crypto: qat - fix double free in qat_uclo_create_batch_init_list

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: add quirk for Pioneer DDJ-RB

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: fix overeager device match for MacroSilicon MS2109

Mirko Dietrich <buzz@l4m1.de>
    ALSA: usb-audio: Creative USB X-Fi Pro SB1095 volume knob support

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: spider_net: Fix the size used in a 'dma_free_coherent()' call

Wang Hai <wanghai38@huawei.com>
    wl1251: fix always return 0 error

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: don't process empty bridge port events

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

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    PCI/ASPM: Add missing newline in sysfs 'policy'

Milton Miller <miltonm@us.ibm.com>
    powerpc/vdso: Fix vdso cpu truncation

Dan Carpenter <dan.carpenter@oracle.com>
    mwifiex: Prevent memory corruption handling keys

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: panel: simple: Fix bpc for LG LB070WV8 panel

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()

Chuhong Yuan <hslester96@gmail.com>
    media: omap3isp: Add missed v4l2_ctrl_handler_free() for preview_init_entities()

Arnd Bergmann <arnd@arndb.de>
    leds: lm355x: avoid enum conversion warning

Tomasz Duszynski <tomasz.duszynski@octakon.com>
    iio: improve IIO_CONCENTRATION channel type description

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

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Fix IOP status/control register writes

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Don't send IOP message until channel is idle

Qiushi Wu <wu000273@umn.edu>
    EDAC: Fix reference count leaks

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    gpio: fix oops resulting from calling of_get_named_gpio(NULL, ...)

Dexuan Cui <decui@microsoft.com>
    udp: drop corrupt packets earlier to avoid data corruption

Nick Desaulniers <ndesaulniers@google.com>
    tracepoint: Mark __tracepoint_string's __used

Eric Biggers <ebiggers@google.com>
    Smack: fix use-after-free in smk_write_relabel_self()

Ido Schimmel <idosch@mellanox.com>
    vxlan: Ensure FDB dump is performed under RCU

Rustam Kovhaev <rkovhaev@gmail.com>
    usb: hso: check for return value in hso_serial_common_create()

Johan Hovold <johan@kernel.org>
    net: lan78xx: replace bogus endpoint lookup

Hangbin Liu <liuhangbin@gmail.com>
    Revert "vxlan: fix tos value before xmit"

Cong Wang <xiyou.wangcong@gmail.com>
    ipv6: fix memory leaks on IPV6_ADDRFORM path

Ido Schimmel <idosch@mellanox.com>
    ipv4: Silence suspicious RCU usage warning

Jann Horn <jannh@google.com>
    binder: Prevent context manager from incrementing ref 0

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

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    mtd: properly check all write ioctls for permissions

Yunhai Zhang <zhangyunhai@nsfocus.com>
    vgacon: Fix for missing check in scrollback handling

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Serialize ioctls

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

Andrea Righi <andrea.righi@canonical.com>
    xen-netfront: fix potential deadlock in xennet_remove()

Raviteja Narayanam <raviteja.narayanam@xilinx.com>
    Revert "i2c: cadence: Fix the hold bit setting"

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ethernet: ravb: exit if re-initialization fails in tx timeout

Navid Emamdoost <navid.emamdoost@gmail.com>
    nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame

Remi Pommarel <repk@triplefau.lt>
    mac80211: mesh: Free ie data when leaving mesh

Ido Schimmel <idosch@mellanox.com>
    mlxsw: core: Increase scope of RCU read-side critical section

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

Peilin Ye <yepeilin.cs@gmail.com>
    rds: Prevent kernel-infoleak in rds_notify_queue_get()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fbdev: Detect integer underflow at "struct fbcon_ops"->clear_margins.

Will Deacon <will@kernel.org>
    ARM: 8986/1: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Sheng Yong <shengyong1@huawei.com>
    f2fs: check if file namelen exceeds max value

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: check memory boundary by insane namelen

Steve Cohen <cohens@codeaurora.org>
    drm: hold gem reference until object is no longer accessed

Peilin Ye <yepeilin.cs@gmail.com>
    drm/amdgpu: Prevent kernel-infoleak in amdgpu_info_ioctl()

Robert Hancock <hancockrwd@gmail.com>
    PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge

Andreas Gruenbacher <agruenba@redhat.com>
    nfs: Move call to security_inode_listsecurity into nfs_listxattr

Navid Emamdoost <navid.emamdoost@gmail.com>
    ath9k: release allocated buffer if timed out

Navid Emamdoost <navid.emamdoost@gmail.com>
    ath9k_htc: release allocated buffer if timed out

Navid Emamdoost <navid.emamdoost@gmail.com>
    media: rc: prevent memory leak in cx23888_ir_probe

Wei Yongjun <weiyongjun1@huawei.com>
    net: phy: mdio-bcm-unimac: fix potential NULL dereference in unimac_mdio_probe()

Eric Sandeen <sandeen@sandeen.net>
    xfs: don't call xfs_da_shrink_inode with NULL bp


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio            |   3 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/percpu.h                      |   2 +
 arch/arm/kernel/hw_breakpoint.c                    |  27 ++++-
 arch/arm/kernel/stacktrace.c                       |  24 +++++
 arch/arm/mach-at91/pm.c                            |  11 +-
 arch/arm/mach-socfpga/pm.c                         |   8 +-
 arch/m68k/mac/iop.c                                |  21 ++--
 arch/mips/kernel/topology.c                        |   2 +-
 arch/powerpc/include/asm/percpu.h                  |   4 +-
 arch/powerpc/kernel/vdso.c                         |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +-
 arch/sh/boards/mach-landisk/setup.c                |   3 +
 arch/sh/kernel/entry-common.S                      |   6 +-
 arch/x86/kernel/i8259.c                            |   2 +-
 drivers/acpi/acpica/exprep.c                       |   4 -
 drivers/acpi/acpica/utdelete.c                     |   6 +-
 drivers/android/binder.c                           |   9 ++
 drivers/atm/atmtcp.c                               |  10 +-
 drivers/char/agp/intel-gtt.c                       |   4 +-
 drivers/char/random.c                              |   1 +
 drivers/clk/sirf/clk-atlas6.c                      |   2 +-
 drivers/crypto/qat/qat_common/qat_uclo.c           |   9 +-
 drivers/edac/edac_device_sysfs.c                   |   1 +
 drivers/edac/edac_pci_sysfs.c                      |   2 +-
 drivers/gpio/gpiolib-of.c                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   3 +-
 drivers/gpu/drm/drm_debugfs.c                      |   8 +-
 drivers/gpu/drm/drm_gem.c                          |  10 +-
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
 drivers/i2c/busses/i2c-cadence.c                   |   9 +-
 drivers/i2c/busses/i2c-rcar.c                      |   7 +-
 drivers/input/mouse/sentelic.c                     |   2 +-
 drivers/iommu/omap-iommu-debug.c                   |   3 +
 drivers/leds/leds-lm355x.c                         |   7 +-
 drivers/md/bcache/bset.c                           |   2 +-
 drivers/md/bcache/btree.c                          |   2 +-
 drivers/md/bcache/journal.c                        |   4 +-
 drivers/md/bcache/super.c                          |  11 +-
 drivers/md/raid5.c                                 |   3 +-
 drivers/media/firewire/firedtv-fw.c                |   2 +
 drivers/media/pci/cx23885/cx23888-ir.c             |   5 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   3 +
 drivers/media/platform/omap3isp/isppreview.c       |   4 +-
 drivers/mfd/dln2.c                                 |   4 +
 drivers/misc/cxl/sysfs.c                           |   5 +-
 drivers/mtd/mtdchar.c                              |  56 +++++++++--
 drivers/net/ethernet/intel/igb/igb_main.c          |   9 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   6 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  26 ++++-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   3 +
 drivers/net/ethernet/toshiba/spider_net.c          |   4 +-
 drivers/net/phy/mdio-bcm-unimac.c                  |   2 +
 drivers/net/usb/hso.c                              |   5 +-
 drivers/net/usb/lan78xx.c                          | 112 ++++++---------------
 drivers/net/vxlan.c                                |   8 +-
 drivers/net/wan/lapbether.c                        |  10 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   3 +
 drivers/net/wireless/ath/ath9k/wmi.c               |   1 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   2 +-
 drivers/net/wireless/iwlegacy/common.c             |   4 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c         |  22 ++--
 drivers/net/wireless/ti/wl1251/event.c             |   2 +-
 drivers/net/xen-netfront.c                         |  64 ++++++++----
 drivers/nfc/s3fwrn5/core.c                         |   1 +
 drivers/parisc/sba_iommu.c                         |   2 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |  14 ++-
 drivers/pci/pcie/aspm.c                            |   1 +
 drivers/pci/quirks.c                               |  13 +++
 drivers/pinctrl/pinctrl-single.c                   |  11 +-
 drivers/power/88pm860x_battery.c                   |   6 +-
 drivers/s390/net/qeth_l2_main.c                    |   4 +
 drivers/scsi/arm/cumana_2.c                        |   2 +-
 drivers/scsi/arm/eesox.c                           |   2 +-
 drivers/scsi/arm/powertec.c                        |   2 +-
 drivers/scsi/mesh.c                                |   8 +-
 drivers/usb/dwc2/platform.c                        |   4 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c              |   4 +
 drivers/usb/gadget/udc/bdc/bdc_ep.c                |  16 +--
 drivers/usb/gadget/udc/net2280.c                   |   4 +-
 drivers/usb/serial/ftdi_sio.c                      |  57 ++++++-----
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/video/console/bitblit.c                    |   4 +-
 drivers/video/console/fbcon_ccw.c                  |   4 +-
 drivers/video/console/fbcon_cw.c                   |   4 +-
 drivers/video/console/fbcon_ud.c                   |   4 +-
 drivers/video/console/newport_con.c                |  12 ++-
 drivers/video/console/vgacon.c                     |   4 +
 drivers/video/fbdev/neofb.c                        |   1 +
 drivers/video/fbdev/sm712fb.c                      |   2 +
 drivers/xen/balloon.c                              |  12 ++-
 fs/9p/v9fs.c                                       |   5 +-
 fs/btrfs/extent_io.c                               |   2 +
 fs/btrfs/free-space-cache.c                        |   4 +-
 fs/btrfs/tree-log.c                                |   8 +-
 fs/dlm/lockspace.c                                 |   6 +-
 fs/ext2/ialloc.c                                   |   3 +-
 fs/ext4/inode.c                                    |   7 ++
 fs/f2fs/dir.c                                      |  12 ++-
 fs/minix/inode.c                                   |  36 ++++++-
 fs/minix/itree_common.c                            |   8 +-
 fs/nfs/nfs4proc.c                                  |  55 ++++++----
 fs/nfs/nfs4xdr.c                                   |   6 +-
 fs/ocfs2/ocfs2.h                                   |   4 +-
 fs/ocfs2/suballoc.c                                |   4 +-
 fs/ocfs2/super.c                                   |   4 +-
 fs/ufs/super.c                                     |   2 +-
 fs/xattr.c                                         |   4 +
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   5 +-
 include/linux/intel-iommu.h                        |   4 +-
 include/linux/prandom.h                            |  78 ++++++++++++++
 include/linux/random.h                             |  63 +-----------
 include/linux/tracepoint.h                         |   2 +-
 include/net/addrconf.h                             |   1 +
 kernel/kprobes.c                                   |   7 ++
 kernel/time/timer.c                                |   8 ++
 lib/dynamic_debug.c                                |  23 ++---
 lib/random32.c                                     |   2 +-
 mm/mmap.c                                          |   1 +
 net/9p/trans_fd.c                                  |  24 +++--
 net/bluetooth/6lowpan.c                            |   5 +
 net/bluetooth/hci_event.c                          |  11 +-
 net/ipv4/fib_trie.c                                |   2 +-
 net/ipv4/udp.c                                     |   3 +-
 net/ipv6/anycast.c                                 |  17 +++-
 net/ipv6/ip6_tunnel.c                              |  32 +++---
 net/ipv6/ipv6_sockglue.c                           |   1 +
 net/ipv6/udp.c                                     |   6 +-
 net/mac80211/cfg.c                                 |   1 +
 net/mac80211/sta_info.c                            |   2 +-
 net/nfc/rawsock.c                                  |   7 +-
 net/rds/recv.c                                     |   3 +-
 net/socket.c                                       |   2 +-
 net/wireless/nl80211.c                             |   6 +-
 net/x25/x25_subr.c                                 |   6 ++
 security/smack/smack_lsm.c                         |   2 -
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
 157 files changed, 973 insertions(+), 476 deletions(-)


