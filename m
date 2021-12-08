Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD1A46CEDC
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239809AbhLHIbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:31:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51358 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbhLHIbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 03:31:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28B6FB81FDA;
        Wed,  8 Dec 2021 08:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D8DC00446;
        Wed,  8 Dec 2021 08:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638952068;
        bh=pPmK5y2417ZsfVu+TkcBjwYFHvhuwnmW6X3NkxgdQGo=;
        h=From:To:Cc:Subject:Date:From;
        b=wnILLre7mf2C/9xk8ID3sq98JeW3ZksdNCXV7N0ra2ds8txa3YyOnN9VznPnbuMr8
         tkq9NH4cNaC845A3XqFcfNis4wXq2il5AaXAZZeXNub0iNHQ970cS9i5ujkHqig/Nz
         U7/YT+P4Pdy3RoW5+0by3lBphFrRn5Ck44kSRQUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.294
Date:   Wed,  8 Dec 2021 09:27:44 +0100
Message-Id: <163895206417997@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.294 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/boot/dts/bcm5301x.dtsi                     |    2 
 arch/arm/include/asm/tlb.h                          |    8 
 arch/arm/mach-socfpga/core.h                        |    2 
 arch/arm/mach-socfpga/platsmp.c                     |    8 
 arch/ia64/include/asm/tlb.h                         |   10 
 arch/parisc/install.sh                              |    1 
 arch/s390/include/asm/tlb.h                         |   13 +
 arch/s390/kernel/setup.c                            |    3 
 arch/sh/include/asm/tlb.h                           |   10 
 arch/um/include/asm/tlb.h                           |   12 
 drivers/android/binder.c                            |    2 
 drivers/ata/sata_fsl.c                              |   20 +
 drivers/block/xen-blkfront.c                        |  126 ++++++---
 drivers/net/ethernet/dec/tulip/de4x5.c              |   34 +-
 drivers/net/ethernet/natsemi/xtsonic.c              |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c |   10 
 drivers/net/xen-netfront.c                          |  257 ++++++++++++--------
 drivers/platform/x86/thinkpad_acpi.c                |   12 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                |    2 
 drivers/scsi/scsi_transport_iscsi.c                 |    6 
 drivers/staging/android/ion/ion.c                   |    6 
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c        |    3 
 drivers/tty/hvc/hvc_xen.c                           |   17 +
 drivers/tty/serial/amba-pl011.c                     |    1 
 drivers/tty/serial/msm_serial.c                     |    3 
 drivers/usb/core/hub.c                              |   23 +
 drivers/usb/serial/option.c                         |    5 
 drivers/video/console/vgacon.c                      |   14 -
 drivers/xen/xenbus/xenbus_probe.c                   |   27 ++
 fs/file.c                                           |   19 +
 fs/file_table.c                                     |    9 
 fs/fuse/dev.c                                       |   10 
 fs/nfs/nfs42xdr.c                                   |    3 
 fs/proc/vmcore.c                                    |   15 -
 include/asm-generic/tlb.h                           |    7 
 include/linux/file.h                                |    2 
 include/linux/fs.h                                  |    4 
 include/linux/ipc_namespace.h                       |   15 +
 include/linux/kprobes.h                             |    2 
 include/linux/sched.h                               |    2 
 include/linux/shm.h                                 |   13 -
 include/linux/siphash.h                             |   14 -
 include/net/nfc/nci_core.h                          |    1 
 include/net/nl802154.h                              |    7 
 include/xen/interface/io/ring.h                     |  257 +++++++++-----------
 ipc/shm.c                                           |  176 ++++++++++---
 kernel/kprobes.c                                    |    3 
 kernel/trace/trace_events.c                         |    7 
 lib/siphash.c                                       |   12 
 mm/hugetlb.c                                        |   58 +++-
 net/ipv4/devinet.c                                  |    2 
 net/ipv4/tcp_cubic.c                                |    5 
 net/nfc/nci/core.c                                  |   19 +
 sound/pci/ctxfi/ctamixer.c                          |   14 -
 sound/pci/ctxfi/ctdaio.c                            |   16 -
 sound/pci/ctxfi/ctresource.c                        |    7 
 sound/pci/ctxfi/ctresource.h                        |    4 
 sound/pci/ctxfi/ctsrc.c                             |    7 
 sound/soc/soc-topology.c                            |    3 
 60 files changed, 893 insertions(+), 461 deletions(-)

Alexander Aring (1):
      net: ieee802154: handle iftypes as u32

Alexander Mikhalitsyn (1):
      shm: extend forced shm destroy to support objects from several IPC nses

Arnd Bergmann (1):
      siphash: use _unaligned version by default

Baokun Li (2):
      sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl
      sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl

Dan Carpenter (1):
      staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()

Daniele Palmas (1):
      USB: serial: option: add Telit LE910S1 0x9200 composition

David Hildenbrand (1):
      proc/vmcore: fix clearing user buffer by properly using clear_user()

Eric Dumazet (1):
      tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Florian Fainelli (1):
      ARM: dts: BCM5301X: Add interrupt properties to GPIO node

Greg Kroah-Hartman (1):
      Linux 4.4.294

Helge Deller (1):
      parisc: Fix "make install" on newer debian releases

Jens Axboe (1):
      fs: add fget_many() and fput_many()

Juergen Gross (9):
      xen: sync include/xen/interface/io/ring.h with Xen's newest version
      xen/blkfront: read response from backend only once
      xen/blkfront: don't take local copy of a request from the ring page
      xen/blkfront: don't trust the backend response data blindly
      xen/netfront: read response from backend only once
      xen/netfront: don't read data from request on the ring page
      xen/netfront: disentangle tx_skb_freelist
      xen/netfront: don't trust the backend response data blindly
      tty: hvc: replace BUG_ON() with negative return value

Lee Jones (1):
      staging: ion: Prevent incorrect reference counting behavour

Lin Ma (1):
      NFC: add NCI_UNREG flag to eliminate the race

Linus Torvalds (1):
      fget: check that the fd still exists after getting a ref to it

Maciej W. Rozycki (1):
      vgacon: Propagate console boot parameters before calling `vc_resize'

Masami Hiramatsu (1):
      kprobes: Limit max data_size of the kretprobe instances

Mathias Nyman (2):
      usb: hub: Fix usb enumeration issue due to address0 race
      usb: hub: Fix locking issues with address0_mutex

Mike Christie (1):
      scsi: iscsi: Unblock session then wake up error handler

Mike Kravetz (1):
      hugetlb: take PMD sharing into account when flushing tlb/caches

Miklos Szeredi (2):
      fuse: fix page stealing
      fuse: release pipe buf after last use

Mingjie Zhang (1):
      USB: serial: option: add Fibocom FM101-GL variants

Nadav Amit (1):
      hugetlbfs: flush TLBs correctly after huge_pmd_unshare

Pierre Gondois (1):
      serial: pl011: Add ACPI SBSA UART match id

Randy Dunlap (1):
      natsemi: xtensa: fix section mismatch warnings

Slark Xiao (1):
      platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic during drive powercycle test

Stefano Stabellini (2):
      xen: don't continue xenstore initialization in case of errors
      xen: detect uninitialized xenbus in xenbus_init

Steven Rostedt (VMware) (1):
      tracing: Check pid filtering when creating events

Sven Eckelmann (1):
      tty: serial: msm_serial: Deactivate RX DMA for polling support

Takashi Iwai (3):
      ALSA: ctxfi: Fix out-of-range access
      ASoC: topology: Add missing rwsem around snd_ctl_remove() calls
      ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE

Teng Qi (1):
      net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

Todd Kjos (1):
      binder: fix test regression due to sender_euid change

Trond Myklebust (1):
      NFSv42: Don't fail clone() unless the OP_CLONE operation failed

Vasily Gorbik (1):
      s390/setup: avoid using memblock_enforce_memory_limit

Zhou Qingyang (1):
      net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()

liuguoqiang (1):
      net: return correct error code

zhangyue (1):
      net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

