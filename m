Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 246AB183C1A
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 23:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgCLWMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 18:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgCLWMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 18:12:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23BAD206CD;
        Thu, 12 Mar 2020 22:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584051167;
        bh=FJ1N/YAMDtP7dYTOG441hyS4xP3z4wsLNJlpQPj4YdE=;
        h=Date:From:To:Cc:Subject:From;
        b=ou2fQSTl6ElxGH7ZYfBbPrM3R4tUHvgPYUNFNgaM6kBvEg6V58dAIXgjeR3UcqJys
         KyaOFoJqWLzj/rHT7dt/PDI+b84lPU/DXHSzlqq6ekaCS5j0yFSW6A/rI172sNnKAV
         SfSnvBJXsJyBoMpQk87OjwvUarxAcYp8aHL7DBKM=
Date:   Thu, 12 Mar 2020 23:12:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.216
Message-ID: <20200312221245.GA616209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.216 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/arm/mach-imx/Makefile               |    2 
 arch/arm/mach-imx/common.h               |    4 -
 arch/arm/mach-imx/resume-imx6.S          |   24 +++++++
 arch/arm/mach-imx/suspend-imx6.S         |   14 ----
 arch/mips/kernel/vpe.c                   |    2 
 arch/powerpc/kernel/cputable.c           |    4 -
 arch/s390/mm/gup.c                       |    6 +
 arch/x86/mm/gup.c                        |    9 ++
 crypto/algif_skcipher.c                  |    2 
 drivers/char/ipmi/ipmi_ssif.c            |   10 ++-
 drivers/dma/coh901318.c                  |    4 -
 drivers/dma/tegra20-apb-dma.c            |    6 -
 drivers/gpu/drm/msm/dsi/dsi_manager.c    |    7 +-
 drivers/hid/hid-core.c                   |    4 -
 drivers/hid/usbhid/hiddev.c              |    2 
 drivers/hwmon/adt7462.c                  |    2 
 drivers/i2c/busses/i2c-jz4780.c          |   36 ----------
 drivers/infiniband/core/cm.c             |    1 
 drivers/infiniband/core/iwcm.c           |    4 -
 drivers/md/dm-cache-target.c             |    4 -
 drivers/net/ethernet/micrel/ks8851_mll.c |   53 ++-------------
 drivers/net/phy/mdio-bcm-iproc.c         |   20 ++++++
 drivers/net/slip/slip.c                  |    1 
 drivers/net/wireless/iwlwifi/pcie/rx.c   |    6 +
 drivers/nfc/pn544/i2c.c                  |    1 
 drivers/s390/cio/blacklist.c             |    5 -
 drivers/tty/serial/ar933x_uart.c         |    8 ++
 drivers/tty/sysrq.c                      |    8 +-
 drivers/tty/vt/selection.c               |   24 ++++++-
 drivers/tty/vt/vt.c                      |    2 
 drivers/usb/core/hub.c                   |    6 +
 drivers/usb/core/port.c                  |   10 ++-
 drivers/usb/core/quirks.c                |    3 
 drivers/usb/gadget/function/f_fs.c       |    5 -
 drivers/usb/gadget/function/u_serial.c   |    4 -
 drivers/usb/storage/unusual_devs.h       |    6 +
 drivers/video/console/vgacon.c           |    3 
 drivers/watchdog/da9062_wdt.c            |    7 --
 fs/cifs/cifsacl.c                        |    4 -
 fs/cifs/connect.c                        |    2 
 fs/cifs/inode.c                          |    8 +-
 fs/ecryptfs/keystore.c                   |    4 -
 fs/ext4/balloc.c                         |   14 +++-
 fs/ext4/ext4.h                           |   30 +++++++--
 fs/ext4/ialloc.c                         |   23 ++++--
 fs/ext4/mballoc.c                        |   61 ++++++++++++------
 fs/ext4/resize.c                         |   62 ++++++++++++++----
 fs/ext4/super.c                          |  103 +++++++++++++++++++++----------
 fs/fat/inode.c                           |   19 ++---
 fs/fuse/dev.c                            |   12 +--
 fs/namei.c                               |    2 
 fs/pipe.c                                |    4 -
 fs/splice.c                              |   12 +++
 include/linux/bitops.h                   |    3 
 include/linux/hid.h                      |    2 
 include/linux/mm.h                       |   23 ++++++
 include/linux/pipe_fs_i.h                |   17 ++++-
 include/net/flow_dissector.h             |    9 ++
 kernel/audit.c                           |   40 ++++++------
 kernel/auditfilter.c                     |   71 +++++++++++----------
 kernel/trace/trace.c                     |    6 +
 mm/gup.c                                 |   51 ++++++++++-----
 mm/hugetlb.c                             |   16 ++++
 mm/internal.h                            |   28 +++++++-
 net/core/fib_rules.c                     |    2 
 net/ipv6/ip6_fib.c                       |    7 +-
 net/ipv6/route.c                         |    1 
 net/mac80211/util.c                      |   18 +++--
 net/netlink/af_netlink.c                 |    5 -
 net/sched/cls_flower.c                   |    1 
 net/sctp/sm_statefuns.c                  |   27 ++++++--
 net/wireless/ethtool.c                   |    8 +-
 net/wireless/nl80211.c                   |    1 
 sound/soc/codecs/pcm512x.c               |    8 +-
 sound/soc/soc-dapm.c                     |    2 
 sound/soc/soc-pcm.c                      |   16 ++--
 virt/kvm/kvm_main.c                      |   12 +--
 78 files changed, 683 insertions(+), 372 deletions(-)

Ahmad Fatoum (1):
      ARM: imx: build v7_cpu_resume() unconditionally

Aleksa Sarai (1):
      namei: only return -ECHILD from follow_dotdot_rcu()

Arun Parameswaran (1):
      net: phy: restore mdio regs in the iproc mdio driver

Benjamin Poirier (2):
      ipv6: Fix nlmsg_flags when splitting a multipath route
      ipv6: Fix route replacement with dev-only route

Bernard Metzler (1):
      RDMA/iwcm: Fix iwcm work deallocation

Charles Keepax (1):
      ASoC: dapm: Correct DAPM handling of active widgets during shutdown

Chris Wilson (1):
      include/linux/bitops.h: introduce BITS_PER_TYPE

Christophe JAILLET (1):
      MIPS: VPE: Fix a double free and a memory leak in 'release_vpe()'

Corey Minyard (1):
      ipmi:ssif: Handle a possible NULL pointer reference

Dan Carpenter (3):
      ext4: potential crash on allocation error in ext4_alloc_flex_bg_array()
      hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()
      dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()

Dan Lazewatsky (1):
      usb: quirks: add NO_LPM quirk for Logitech Screen Share

Daniel Golle (1):
      serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE

Desnes A. Nunes do Rosario (1):
      powerpc: fix hardware PMU exception bug on PowerVM compatibility mode systems

Dmitry Osipenko (3):
      nfc: pn544: Fix occasional HW initialization failure
      dmaengine: tegra-apb: Fix use-after-free
      dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list

Eugeniu Rosca (2):
      usb: core: hub: do error out if usb_autopm_get_interface() fails
      usb: core: port: do error out if usb_autopm_get_interface() fails

Frank Sorenson (1):
      cifs: Fix mode output in debugging statements

Greg Kroah-Hartman (1):
      Linux 4.4.216

Harigovindan P (1):
      drm/msm/dsi: save pll state before dsi host is powered off

Jason Baron (1):
      net: sched: correct flower port blocking

Jason Gunthorpe (1):
      RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()

Jethro Beekman (1):
      net: fib_rules: Correctly set table field when table number exceeds 8 bits

Jim Lin (1):
      usb: storage: Add quirk for Samsung Fit flash

Jiri Slaby (3):
      vt: selection, close sel_buffer race
      vt: selection, push console lock down
      vt: selection, push sel_lock up

Johan Korsnes (2):
      HID: core: fix off-by-one memset in hid_report_raw_event()
      HID: core: increase HID report buffer size to 8KiB

Johannes Berg (2):
      iwlwifi: pcie: fix rb_allocator workqueue allocation
      mac80211: consider more elements in parsing CRC

John Stultz (1):
      drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI

Lars-Peter Clausen (1):
      usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags

Linus Torvalds (3):
      mm: make page ref count overflow check tighter and more explicit
      mm: add 'try_get_page()' helper function
      mm: prevent get_user_pages() from overflowing page refcount

Marco Felsch (1):
      watchdog: da9062: do not ping the hw during stop()

Marek Vasut (3):
      net: ks8851-ml: Remove 8-bit bus accessors
      net: ks8851-ml: Fix 16-bit data access
      net: ks8851-ml: Fix 16-bit IO operation

Matthew Wilcox (1):
      fs: prevent page refcount overflow in pipe_buf_get

Matthias Reichl (1):
      ASoC: pcm512x: Fix unbalanced regulator enable call in probe error path

Miklos Szeredi (1):
      pipe: add pipe_buf_get() helper

Mikulas Patocka (1):
      dm cache: fix a crash due to incorrect work item cancelling

Nathan Chancellor (1):
      ecryptfs: Fix up bad backport of fe2e082f5da5b4a0a92ae32978f81507ef37ec66

Nikolay Aleksandrov (1):
      net: netlink: cap max groups which will be considered in netlink_bind()

OGAWA Hirofumi (1):
      fat: fix uninit-memory access for partial initialized inode

Paul Moore (2):
      audit: fix error handling in audit_data_to_entry()
      audit: always check the netlink payload length in audit_receive_msg()

Petr Mladek (2):
      sysrq: Restore original console_loglevel when sysrq disabled
      sysrq: Remove duplicated sysrq message

Punit Agrawal (1):
      mm, gup: ensure real head page is ref-counted when using hugepages

Ronnie Sahlberg (1):
      cifs: don't leak -EAGAIN for stat() during reconnect

Sean Christopherson (1):
      KVM: Check for a bad hva before dropping into the ghc slow path

Sergey Matyukevich (2):
      cfg80211: check wiphy driver existence for drvinfo report
      cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Sergey Organov (1):
      usb: gadget: serial: fix Tx stall after buffer overflow

Suraj Jitindar Singh (2):
      ext4: fix potential race between s_flex_groups online resizing and access
      ext4: fix potential race between s_group_info online resizing and access

Takashi Iwai (1):
      ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output

Theodore Ts'o (1):
      ext4: fix potential race between online resizing and write operations

Vasily Averin (1):
      s390/cio: cio_ignore_proc_seq_next should increase position index

Will Deacon (1):
      mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages

Wolfram Sang (1):
      i2c: jz4780: silence log flood on txabrt

Xin Long (1):
      sctp: move the format error check out of __sctp_sf_do_9_1_abort

Zhang Xiaoxu (1):
      vgacon: Fix a UAF in vgacon_invert_region

dan.carpenter@oracle.com (1):
      HID: hiddev: Fix race in in hiddev_disconnect()

yangerkun (2):
      slip: stop double free sl->dev in slip_open
      crypto: algif_skcipher - use ZERO_OR_NULL_PTR in skcipher_recvmsg_async

