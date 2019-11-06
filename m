Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B12CF168B
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 14:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfKFNFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 08:05:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfKFNFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 08:05:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C6AF217F4;
        Wed,  6 Nov 2019 13:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573045503;
        bh=OfrZVaeo2e+1KTxvRpXHnqoV1NiRaNuUB/dOpNsRqV4=;
        h=Date:From:To:Cc:Subject:From;
        b=wCfZUB3Mfopi5hduLfWvdCwIAkjhfv8t4AeTZwaHIR6nUP6adBgw4iEKabxGPbqdV
         GHsaOjjXKvByxzQ4A0d5KKW9FMfg3mZPD4tRmOUCNYOfzr24RmtNnXMvd5QFVlAl0l
         dJAlEy3nbRd1tX0427pEe4tQS5vgLu0kjVpDdOJY=
Date:   Wed, 6 Nov 2019 14:05:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.199
Message-ID: <20191106130501.GA3229566@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.199 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/mips/fw/sni/sniprom.c                |    2 
 arch/s390/mm/cmm.c                        |   12 +-
 arch/x86/include/asm/intel-family.h       |    3 
 arch/x86/platform/efi/efi.c               |    3 
 drivers/firmware/efi/cper.c               |    2 
 drivers/hid/hid-axff.c                    |   11 +
 drivers/hid/hid-core.c                    |    7 -
 drivers/hid/hid-dr.c                      |   12 +-
 drivers/hid/hid-emsff.c                   |   12 +-
 drivers/hid/hid-gaff.c                    |   12 +-
 drivers/hid/hid-holtekff.c                |   12 +-
 drivers/hid/hid-lg2ff.c                   |   12 +-
 drivers/hid/hid-lg3ff.c                   |   11 +
 drivers/hid/hid-lg4ff.c                   |   11 +
 drivers/hid/hid-lgff.c                    |   11 +
 drivers/hid/hid-sony.c                    |   12 +-
 drivers/hid/hid-tmff.c                    |   12 +-
 drivers/hid/hid-zpff.c                    |   12 +-
 drivers/iio/accel/bmc150-accel-core.c     |    2 
 drivers/infiniband/core/cma.c             |    3 
 drivers/md/dm-bio-prison.c                |    2 
 drivers/md/dm-io.c                        |    2 
 drivers/md/dm-kcopyd.c                    |    2 
 drivers/md/dm-region-hash.c               |    2 
 drivers/md/dm-snap.c                      |  178 ++++++++++++++++++++----------
 drivers/md/dm-thin.c                      |    2 
 drivers/net/bonding/bond_main.c           |    2 
 drivers/net/usb/sr9800.c                  |    2 
 drivers/net/wireless/ath/ath6kl/usb.c     |    8 +
 drivers/net/wireless/realtek/rtlwifi/ps.c |    6 +
 drivers/thunderbolt/nhi.c                 |   22 +++
 drivers/tty/serial/sc16is7xx.c            |   28 ++++
 drivers/tty/serial/serial_mctrl_gpio.c    |    3 
 drivers/usb/core/hub.c                    |    7 +
 drivers/usb/misc/ldusb.c                  |    6 -
 drivers/usb/misc/legousbtower.c           |    2 
 drivers/usb/serial/whiteheat.c            |   13 +-
 drivers/usb/serial/whiteheat.h            |    2 
 drivers/usb/storage/uas.c                 |   20 ---
 fs/binfmt_script.c                        |   57 ++++++++-
 fs/cifs/netmisc.c                         |    4 
 fs/fuse/dir.c                             |   13 ++
 fs/fuse/file.c                            |   10 +
 fs/nfs/nfs4proc.c                         |    1 
 fs/ocfs2/ioctl.c                          |    2 
 fs/ocfs2/xattr.c                          |   56 +++------
 fs/xfs/xfs_buf.c                          |    2 
 include/linux/usb/gadget.h                |   10 +
 include/net/llc_conn.h                    |    2 
 include/net/sch_generic.h                 |    5 
 include/net/sctp/sctp.h                   |    2 
 kernel/trace/trace.c                      |    1 
 net/llc/llc_c_ac.c                        |    8 +
 net/llc/llc_conn.c                        |   32 +----
 net/llc/llc_s_ac.c                        |   12 +-
 net/llc/llc_sap.c                         |   23 +--
 net/sched/sch_netem.c                     |    2 
 net/sctp/ipv6.c                           |    2 
 net/sctp/protocol.c                       |    2 
 net/sctp/socket.c                         |   55 ++++-----
 net/wireless/nl80211.c                    |    3 
 scripts/setlocalversion                   |   12 +-
 sound/firewire/bebob/bebob_stream.c       |    3 
 sound/hda/hdac_controller.c               |    2 
 sound/pci/hda/hda_intel.c                 |    2 
 tools/perf/util/map.c                     |    3 
 67 files changed, 532 insertions(+), 279 deletions(-)

Adam Ford (1):
      serial: mctrl_gpio: Check for NULL pointer

Alan Stern (3):
      UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of scatter/gather segments")
      USB: gadget: Reject endpoints with 0 maxpacket value
      HID: Fix assumption that devices have inputs

Austin Kim (1):
      fs: cifs: mute -Wunused-const-variable message

Bart Van Assche (1):
      RDMA/iwcm: Fix a lock inversion issue

Brian Norris (1):
      scripts/setlocalversion: Improve -dirty check with git-status --no-optional-locks

Chuck Lever (1):
      NFSv4: Fix leak of clp->cl_acceptor string

Dan Carpenter (1):
      USB: legousbtower: fix a signedness bug in tower_probe()

Dave Young (1):
      efi/x86: Do not clean dummy variable in kexec path

Eric Biggers (2):
      llc: fix sk_buff leak in llc_sap_state_process()
      llc: fix sk_buff leak in llc_conn_service()

Eric Dumazet (2):
      bonding: fix potential NULL deref in bond_update_slave_arr
      sch_netem: fix rcu splat in netem_enqueue()

Greg Kroah-Hartman (1):
      Linux 4.4.199

Hui Peng (1):
      ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

Jan-Marek Glogowski (1):
      usb: handle warm-reset port requests on hub resume

Jia-Ju Bai (2):
      fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()
      fs: ocfs2: fix a possible null-pointer dereference in ocfs2_info_scan_inode_alloc()

Johan Hovold (4):
      USB: ldusb: fix ring-buffer locking
      USB: ldusb: fix control-message timeout
      USB: serial: whiteheat: fix potential slab corruption
      USB: serial: whiteheat: fix line-speed endianness

Kan Liang (1):
      x86/cpu: Add Atom Tremont (Jacobsville)

Kees Cook (1):
      exec: load_script: Do not exec truncated interpreter path

Kent Overstreet (1):
      dm: Use kzalloc for all structs with embedded biosets/mempools

Laura Abbott (1):
      rtlwifi: Fix potential overflow on P2P code

Lukas Wunner (1):
      efi/cper: Fix endianness of PCIe class code

Markus Theil (1):
      nl80211: fix validation of mesh path nexthop

Michał Mirosław (1):
      HID: fix error message in hid_open_report()

Mika Westerberg (1):
      thunderbolt: Use 32-bit writes when writing ring producer/consumer

Miklos Szeredi (2):
      fuse: flush dirty data/metadata before non-truncate setattr
      fuse: truncate pending writes on O_TRUNC

Mikulas Patocka (3):
      dm snapshot: use mutex instead of rw_semaphore
      dm snapshot: introduce account_start_copy() and account_end_copy()
      dm snapshot: rework COW throttling to fix deadlock

Pascal Bouwmann (1):
      iio: fix center temperature of bmc150-accel-core

Petr Mladek (1):
      tracing: Initialize iter->seq after zeroing in tracing_read_pipe()

Phil Elwell (1):
      sc16is7xx: Fix for "Unexpected interrupt: 8"

Steve MacLean (1):
      perf map: Fix overlapped map handling

Takashi Iwai (1):
      Revert "ALSA: hda: Flush interrupts on disabling"

Takashi Sakamoto (1):
      ALSA: bebob: Fix prototype of helper function to return negative value

Thomas Bogendoerfer (1):
      MIPS: fw: sni: Fix out of bounds init of o32 stack

Valentin Vidic (1):
      net: usb: sr9800: fix uninitialized local variable

Vratislav Bendel (1):
      xfs: Correctly invert xfs_buftarg LRU isolation logic

Xin Long (2):
      sctp: fix the issue that flags are ignored when using kernel_connect
      sctp: not bind the socket in sctp_connect

Yihui ZENG (1):
      s390/cmm: fix information leak in cmm_timeout_handler()

