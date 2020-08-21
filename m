Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DA324D430
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 13:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgHULji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 07:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbgHULiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 07:38:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B03F420732;
        Fri, 21 Aug 2020 11:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598009913;
        bh=3TPbJB8na8N6xSZGFPAq4vzMpKOqk7peFbFYxCUuoAk=;
        h=From:To:Cc:Subject:Date:From;
        b=fgUUn/3zOECFdLDXpKCu6QnILRuyedtkg6amsl0yOrrJsI+DkHolShy5Cpec6lO7A
         XaZbFF8rtbykrJGGqdbg6E081bYrij7yleyJ7sYUVGQrLyO4WfSR0/IztPC6h7nzmB
         8M3p8nsMkGUI2oYxITyROQnuDdRqUIb80najUutw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.233
Date:   Fri, 21 Aug 2020 13:38:51 +0200
Message-Id: <159800993112016@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.233 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio              |    3 
 Makefile                                             |    2 
 arch/arm/include/asm/percpu.h                        |    2 
 arch/arm/kernel/hw_breakpoint.c                      |   27 +++-
 arch/arm/kernel/stacktrace.c                         |   24 ++++
 arch/arm/mach-at91/pm.c                              |   11 +
 arch/arm/mach-socfpga/pm.c                           |    8 -
 arch/m68k/mac/iop.c                                  |   21 +--
 arch/mips/kernel/topology.c                          |    2 
 arch/powerpc/include/asm/percpu.h                    |    4 
 arch/powerpc/kernel/vdso.c                           |    2 
 arch/powerpc/platforms/pseries/hotplug-memory.c      |    2 
 arch/sh/boards/mach-landisk/setup.c                  |    3 
 arch/sh/kernel/entry-common.S                        |    6 -
 arch/x86/kernel/i8259.c                              |    2 
 drivers/acpi/acpica/exprep.c                         |    4 
 drivers/acpi/acpica/utdelete.c                       |    6 -
 drivers/android/binder.c                             |    9 +
 drivers/atm/atmtcp.c                                 |   10 +
 drivers/char/agp/intel-gtt.c                         |    4 
 drivers/char/random.c                                |    1 
 drivers/clk/sirf/clk-atlas6.c                        |    2 
 drivers/crypto/qat/qat_common/qat_uclo.c             |    9 +
 drivers/edac/edac_device_sysfs.c                     |    1 
 drivers/edac/edac_pci_sysfs.c                        |    2 
 drivers/gpio/gpiolib-of.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c              |    3 
 drivers/gpu/drm/drm_debugfs.c                        |    8 -
 drivers/gpu/drm/drm_gem.c                            |   10 -
 drivers/gpu/drm/nouveau/nouveau_drm.c                |    8 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c              |    1 
 drivers/gpu/drm/nouveau/nouveau_gem.c                |    4 
 drivers/gpu/drm/panel/panel-simple.c                 |    2 
 drivers/gpu/drm/radeon/ci_dpm.c                      |    2 
 drivers/gpu/drm/radeon/radeon_display.c              |    4 
 drivers/gpu/drm/radeon/radeon_drv.c                  |    4 
 drivers/gpu/drm/radeon/radeon_kms.c                  |    4 
 drivers/gpu/drm/tilcdc/tilcdc_panel.c                |    6 -
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                  |    8 -
 drivers/i2c/busses/i2c-cadence.c                     |    9 -
 drivers/i2c/busses/i2c-rcar.c                        |    7 -
 drivers/input/mouse/sentelic.c                       |    2 
 drivers/iommu/omap-iommu-debug.c                     |    3 
 drivers/leds/leds-lm355x.c                           |    7 -
 drivers/md/bcache/bset.c                             |    2 
 drivers/md/bcache/btree.c                            |    2 
 drivers/md/bcache/journal.c                          |    4 
 drivers/md/bcache/super.c                            |   11 +
 drivers/md/raid5.c                                   |    3 
 drivers/media/firewire/firedtv-fw.c                  |    2 
 drivers/media/pci/cx23885/cx23888-ir.c               |    5 
 drivers/media/platform/exynos4-is/media-dev.c        |    3 
 drivers/media/platform/omap3isp/isppreview.c         |    4 
 drivers/mfd/dln2.c                                   |    4 
 drivers/misc/cxl/sysfs.c                             |    5 
 drivers/mtd/mtdchar.c                                |   56 +++++++--
 drivers/net/ethernet/intel/igb/igb_main.c            |    9 +
 drivers/net/ethernet/mellanox/mlxsw/core.c           |    6 -
 drivers/net/ethernet/renesas/ravb_main.c             |   26 ++++
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c  |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |    3 
 drivers/net/ethernet/toshiba/spider_net.c            |    4 
 drivers/net/phy/mdio-bcm-unimac.c                    |    2 
 drivers/net/usb/hso.c                                |    5 
 drivers/net/usb/lan78xx.c                            |  112 +++++--------------
 drivers/net/vxlan.c                                  |    8 +
 drivers/net/wan/lapbether.c                          |   10 +
 drivers/net/wireless/ath/ath9k/htc_hst.c             |    3 
 drivers/net/wireless/ath/ath9k/wmi.c                 |    1 
 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h |    2 
 drivers/net/wireless/iwlegacy/common.c               |    4 
 drivers/net/wireless/mwifiex/sta_cmdresp.c           |   22 ++-
 drivers/net/wireless/ti/wl1251/event.c               |    2 
 drivers/net/xen-netfront.c                           |   64 +++++++---
 drivers/nfc/s3fwrn5/core.c                           |    1 
 drivers/parisc/sba_iommu.c                           |    2 
 drivers/pci/hotplug/acpiphp_glue.c                   |   14 +-
 drivers/pci/pcie/aspm.c                              |    1 
 drivers/pci/quirks.c                                 |   13 ++
 drivers/pinctrl/pinctrl-single.c                     |   11 +
 drivers/power/88pm860x_battery.c                     |    6 -
 drivers/s390/net/qeth_l2_main.c                      |    4 
 drivers/scsi/arm/cumana_2.c                          |    2 
 drivers/scsi/arm/eesox.c                             |    2 
 drivers/scsi/arm/powertec.c                          |    2 
 drivers/scsi/mesh.c                                  |    8 +
 drivers/usb/dwc2/platform.c                          |    4 
 drivers/usb/gadget/udc/bdc/bdc_core.c                |    4 
 drivers/usb/gadget/udc/bdc/bdc_ep.c                  |   16 +-
 drivers/usb/gadget/udc/net2280.c                     |    4 
 drivers/usb/serial/ftdi_sio.c                        |   37 +++---
 drivers/usb/serial/qcserial.c                        |    1 
 drivers/video/console/bitblit.c                      |    4 
 drivers/video/console/fbcon_ccw.c                    |    4 
 drivers/video/console/fbcon_cw.c                     |    4 
 drivers/video/console/fbcon_ud.c                     |    4 
 drivers/video/console/newport_con.c                  |   12 +-
 drivers/video/console/vgacon.c                       |    4 
 drivers/video/fbdev/neofb.c                          |    1 
 drivers/video/fbdev/sm712fb.c                        |    2 
 drivers/xen/balloon.c                                |   12 +-
 fs/9p/v9fs.c                                         |    5 
 fs/btrfs/extent_io.c                                 |    2 
 fs/btrfs/free-space-cache.c                          |    4 
 fs/btrfs/tree-log.c                                  |    8 -
 fs/dlm/lockspace.c                                   |    6 -
 fs/ext2/ialloc.c                                     |    3 
 fs/ext4/inode.c                                      |    7 +
 fs/f2fs/dir.c                                        |   12 +-
 fs/minix/inode.c                                     |   36 +++++-
 fs/minix/itree_common.c                              |    8 +
 fs/nfs/nfs4proc.c                                    |   55 ++++++---
 fs/nfs/nfs4xdr.c                                     |    6 -
 fs/ocfs2/ocfs2.h                                     |    4 
 fs/ocfs2/suballoc.c                                  |    4 
 fs/ocfs2/super.c                                     |    4 
 fs/ufs/super.c                                       |    2 
 fs/xattr.c                                           |    4 
 fs/xfs/libxfs/xfs_attr_leaf.c                        |    5 
 include/linux/intel-iommu.h                          |    4 
 include/linux/prandom.h                              |   78 +++++++++++++
 include/linux/random.h                               |   63 ----------
 include/linux/tracepoint.h                           |    2 
 include/net/addrconf.h                               |    1 
 kernel/kprobes.c                                     |    7 +
 kernel/time/timer.c                                  |    8 +
 lib/dynamic_debug.c                                  |   23 +--
 lib/random32.c                                       |    2 
 mm/mmap.c                                            |    1 
 net/9p/trans_fd.c                                    |   24 ++--
 net/bluetooth/6lowpan.c                              |    5 
 net/bluetooth/hci_event.c                            |   11 +
 net/ipv4/fib_trie.c                                  |    2 
 net/ipv4/udp.c                                       |    3 
 net/ipv6/anycast.c                                   |   17 ++
 net/ipv6/ip6_tunnel.c                                |   32 ++---
 net/ipv6/ipv6_sockglue.c                             |    1 
 net/ipv6/udp.c                                       |    6 -
 net/mac80211/cfg.c                                   |    1 
 net/mac80211/sta_info.c                              |    2 
 net/nfc/rawsock.c                                    |    7 -
 net/rds/recv.c                                       |    3 
 net/socket.c                                         |    2 
 net/wireless/nl80211.c                               |    6 -
 net/x25/x25_subr.c                                   |    6 +
 security/smack/smack_lsm.c                           |    2 
 security/smack/smackfs.c                             |   19 ++-
 sound/core/seq/oss/seq_oss.c                         |    8 +
 sound/pci/echoaudio/echoaudio.c                      |    2 
 sound/usb/card.h                                     |    1 
 sound/usb/mixer_quirks.c                             |    1 
 sound/usb/pcm.c                                      |    6 +
 sound/usb/quirks-table.h                             |   64 ++++++++++
 sound/usb/quirks.c                                   |    3 
 sound/usb/stream.c                                   |    1 
 tools/lib/traceevent/event-parse.c                   |    1 
 156 files changed, 956 insertions(+), 469 deletions(-)

Aditya Pakki (2):
      drm/radeon: Fix reference count leaks caused by pm_runtime_get_sync
      drm/nouveau: fix multiple instances of reference count leaks

Andrea Righi (1):
      xen-netfront: fix potential deadlock in xennet_remove()

Andreas Gruenbacher (1):
      nfs: Move call to security_inode_listsecurity into nfs_listxattr

Andy Shevchenko (1):
      mfd: dln2: Run event handler loop under spinlock

Anton Blanchard (1):
      pseries: Fix 64 bit logical memory block panic

Arnd Bergmann (1):
      leds: lm355x: avoid enum conversion warning

Ben Skeggs (1):
      drm/nouveau/fbcon: fix module unload when fbcon init has failed for some reason

Bolarinwa Olayemi Saheed (1):
      iwlegacy: Check the return value of pcie_capability_read_*()

ChangSyun Peng (1):
      md/raid5: Fix Force reconstruct-write io stuck in degraded raid5

Christoph Hellwig (1):
      net/9p: validate fds in p9_fd_open

Christophe JAILLET (4):
      scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()
      scsi: powertec: Fix different dev_id between request_irq() and free_irq()
      scsi: eesox: Fix different dev_id between request_irq() and free_irq()
      net: spider_net: Fix the size used in a 'dma_free_coherent()' call

Chuhong Yuan (2):
      media: omap3isp: Add missed v4l2_ctrl_handler_free() for preview_init_entities()
      media: exynos4-is: Add missed check for pinctrl_lookup_state()

Colin Ian King (4):
      drm/radeon: fix array out-of-bounds read and write issues
      iommu/omap: Check for failure of a call to omap_iommu_dump_ctx
      Input: sentelic - fix error return when fsp_reg_write fails
      fs/ufs: avoid potential u32 multiplication overflow

Coly Li (2):
      bcache: fix super block seq numbers comparision in register_cache_set()
      bcache: allocate meta data pages as compound pages

Cong Wang (1):
      ipv6: fix memory leaks on IPV6_ADDRFORM path

Dan Carpenter (5):
      media: firewire: Using uninitialized values in node_probe()
      mwifiex: Prevent memory corruption handling keys
      Smack: fix another vsscanf out of bounds
      Smack: prevent underflow in smk_set_cipso()
      drm/vmwgfx: Fix two list_for_each loop exit tests

Dejin Zheng (2):
      video: fbdev: sm712fb: fix an issue about iounmap for a wrong address
      console: newport_con: fix an issue about leak related system resources

Dexuan Cui (1):
      udp: drop corrupt packets earlier to avoid data corruption

Dinghao Liu (1):
      ALSA: echoaudio: Fix potential Oops in snd_echo_resume()

Drew Fustini (1):
      pinctrl-single: fix pcs_parse_pinconf() return value

Eric Biggers (4):
      Smack: fix use-after-free in smk_write_relabel_self()
      fs/minix: check return value of sb_getblk()
      fs/minix: don't allow getting deleted inodes
      fs/minix: reject too-large maximum file size

Eric Sandeen (1):
      xfs: don't call xfs_da_shrink_inode with NULL bp

Erik Ekman (1):
      USB: serial: qcserial: add EM7305 QDL product ID

Erik Kaneda (1):
      ACPICA: Do not increment operation_region reference counts for field units

Evgeny Novikov (2):
      video: fbdev: neofb: fix memory leak in neo_scan_monitor()
      usb: gadget: net2280: fix memory leak on probe error handling paths

Filipe Manana (1):
      btrfs: fix memory leaks after failure to lookup checksums during inode logging

Finn Thain (3):
      m68k: mac: Don't send IOP message until channel is idle
      m68k: mac: Fix IOP status/control register writes
      scsi: mesh: Fix panic after host or bus reset

Francesco Ruggeri (1):
      igb: reinit_locked() should be called with rtnl_lock

Geert Uytterhoeven (1):
      sh: landisk: Add missing initialization of sh_io_port_base

Greg Kroah-Hartman (2):
      mtd: properly check all write ioctls for permissions
      Linux 4.4.233

Grygorii Strashko (1):
      ARM: percpu.h: fix build error

Hangbin Liu (1):
      Revert "vxlan: fix tos value before xmit"

Hector Martin (3):
      ALSA: usb-audio: fix overeager device match for MacroSilicon MS2109
      ALSA: usb-audio: add quirk for Pioneer DDJ-RB
      ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109

Huacai Chen (1):
      MIPS: CPU#0 is not hotpluggable

Ido Schimmel (3):
      mlxsw: core: Increase scope of RCU read-side critical section
      ipv4: Silence suspicious RCU usage warning
      vxlan: Ensure FDB dump is performed under RCU

Jaegeuk Kim (1):
      f2fs: check memory boundary by insane namelen

Jann Horn (1):
      binder: Prevent context manager from incrementing ref 0

Jeffrey Mitchell (1):
      nfs: Fix getxattr kernel panic and memory overflow

Jiang Ying (1):
      ext4: fix direct I/O read error

Jim Cromie (1):
      dyndbg: fix a BUG_ON in ddebug_describe_flags

Johan Hovold (5):
      net: lan78xx: add missing endpoint sanity check
      net: lan78xx: fix transfer-buffer memory leak
      net: lan78xx: replace bogus endpoint lookup
      USB: serial: ftdi_sio: make process-packet buffer unsigned
      USB: serial: ftdi_sio: clean up receive processing

Johannes Berg (1):
      mac80211: fix misplaced while instead of if

Jonathan McDowell (2):
      net: ethernet: stmmac: Disable hardware multicast filter
      net: stmmac: dwmac1000: provide multicast filter fallback

Josef Bacik (1):
      btrfs: only search for left_info if there is no right_info in try_merge_free_space

Julian Squires (1):
      cfg80211: check vendor command doit pointer before use

Julian Wiedmann (1):
      s390/qeth: don't process empty bridge port events

Junxiao Bi (1):
      ocfs2: change slot number type s16 to u16

Laurent Pinchart (1):
      drm: panel: simple: Fix bpc for LG LB070WV8 panel

Lihong Kou (1):
      Bluetooth: add a mutex lock to avoid UAF in do_enale_set

Linus Torvalds (2):
      random32: remove net_rand_state from the latent entropy gcc plugin
      random32: move the pseudo-random 32-bit definitions to prandom.h

Liu Yi L (1):
      iommu/vt-d: Enforce PASID devTLB field mask

Marek Szyprowski (1):
      usb: dwc2: Fix error path in gadget registration

Miaohe Lin (1):
      net: Set fput_needed iff FDPUT_FPUT is set

Michael Ellerman (1):
      powerpc: Fix circular dependency between percpu.h and mmu.h

Michael Karcher (1):
      sh: Fix validation of system call number

Michael Tretter (1):
      drm/debugfs: fix plain echo to connector "force" attribute

Mikulas Patocka (1):
      ext2: fix missing percpu_counter_inc

Milton Miller (1):
      powerpc/vdso: Fix vdso cpu truncation

Mirko Dietrich (1):
      ALSA: usb-audio: Creative USB X-Fi Pro SB1095 volume knob support

Muchun Song (1):
      kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler

Nathan Huckleberry (1):
      ARM: 8992/1: Fix unwind_frame for clang-built kernels

Navid Emamdoost (4):
      media: rc: prevent memory leak in cx23888_ir_probe
      ath9k_htc: release allocated buffer if timed out
      ath9k: release allocated buffer if timed out
      nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame

Nick Desaulniers (1):
      tracepoint: Mark __tracepoint_string's __used

Paul E. McKenney (2):
      fs/btrfs: Add cond_resched() for try_release_extent_mapping() stalls
      mm/mmap.c: Add cond_resched() for exit_mmap() CPU stalls

Peilin Ye (5):
      drm/amdgpu: Prevent kernel-infoleak in amdgpu_info_ioctl()
      rds: Prevent kernel-infoleak in rds_notify_queue_get()
      Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()

Philippe Duplessis-Guindon (1):
      tools lib traceevent: Fix memory leak in process_dynamic_array_len

Prasanna Kerekoppa (1):
      brcmfmac: To fix Bss Info flag definition Bug

Qingyu Li (1):
      net/nfc/rawsock.c: add CAP_NET_RAW check.

Qiushi Wu (2):
      EDAC: Fix reference count leaks
      agp/intel: Fix a memory leak on module initialisation failure

Rafael J. Wysocki (1):
      PCI: hotplug: ACPI: Fix context refcounting in acpiphp_grab_context()

Raviteja Narayanam (1):
      Revert "i2c: cadence: Fix the hold bit setting"

Remi Pommarel (1):
      mac80211: mesh: Free ie data when leaving mesh

Robert Hancock (1):
      PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge

Roger Pau Monne (2):
      xen/balloon: fix accounting in alloc_xenballooned_pages error path
      xen/balloon: make the balloon wait interruptible

Rustam Kovhaev (1):
      usb: hso: check for return value in hso_serial_common_create()

Sasi Kumar (1):
      bdc: Fix bug causing crash after multiple disconnects

Sheng Yong (1):
      f2fs: check if file namelen exceeds max value

Steve Cohen (1):
      drm: hold gem reference until object is no longer accessed

Sven Schnelle (1):
      parisc: mask out enable and reserved bits from sba imask

Takashi Iwai (1):
      ALSA: seq: oss: Serialize ioctls

Tetsuo Handa (1):
      fbdev: Detect integer underflow at "struct fbcon_ops"->clear_margins.

Thomas Gleixner (1):
      x86/i8259: Use printk_deferred() to prevent deadlock

Tom Rix (2):
      power: supply: check if calc_soc succeeded in pm860x_init_battery
      crypto: qat - fix double free in qat_uclo_create_batch_init_list

Tomasz Duszynski (1):
      iio: improve IIO_CONCENTRATION channel type description

Tomi Valkeinen (1):
      drm/tilcdc: fix leak & null ref in panel_connector_get_modes

Uwe Kleine-König (1):
      gpio: fix oops resulting from calling of_get_named_gpio(NULL, ...)

WANG Cong (1):
      ipv6: check skb->protocol before lookup for nexthop

Wang Hai (3):
      cxl: Fix kobject memleak
      wl1251: fix always return 0 error
      dlm: Fix kobject memleak

Wei Yongjun (1):
      net: phy: mdio-bcm-unimac: fix potential NULL dereference in unimac_mdio_probe()

Will Deacon (1):
      ARM: 8986/1: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Willy Tarreau (2):
      random32: update the net random state on interrupt and activity
      random: fix circular include dependency on arm64 after addition of percpu.h

Wolfram Sang (1):
      i2c: rcar: slave: only send STOP event when we have been addressed

Xie He (1):
      drivers/net/wan/lapbether: Added needed_headroom and a skb->len check

Xin Xiong (1):
      atm: fix atm_dev refcnt leaks in atmtcp_remove_persistent

Xiongfeng Wang (1):
      PCI/ASPM: Add missing newline in sysfs 'policy'

Xiyu Yang (1):
      net/x25: Fix x25_neigh refcnt leak when x25 disconnect

Xu Wang (1):
      clk: clk-atlas6: fix return value check in atlas6_clk_init()

Yoshihiro Shimoda (1):
      net: ethernet: ravb: exit if re-initialization fails in tx timeout

Yu Kuai (1):
      ARM: socfpga: PM: add missing put_device() call in socfpga_setup_ocram_self_refresh()

YueHaibing (1):
      net/x25: Fix null-ptr-deref in x25_disconnect

Yunhai Zhang (1):
      vgacon: Fix for missing check in scrollback handling

Zheng Bin (1):
      9p: Fix memory leak in v9fs_mount

yu kuai (1):
      ARM: at91: pm: add missing put_device() call in at91_pm_sram_init()

