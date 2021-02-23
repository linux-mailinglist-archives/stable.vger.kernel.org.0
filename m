Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19528322D34
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 16:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhBWPL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 10:11:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232618AbhBWPLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 10:11:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 715CF60234;
        Tue, 23 Feb 2021 15:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614093061;
        bh=qKTn9YoJjyO9t4cQqeYKyBYJDNb6eBVuVSb3Mxi58I8=;
        h=From:To:Cc:Subject:Date:From;
        b=KF60KMpgQBQvLW6/caXLGBUOvGi7UnSm5rRdUAQS787x/sWdyJPCsMaoCtiTeAYLK
         3pRgn0+7xorWNWNqxrnJ1zHGkgwBVRmilFvBQKWNqtIj0gWGm0AxVgfEljJveEfc8Q
         hMs9CIL3aeUmhokRPn0DcWhJe1r5CxDZBHhBKUEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.18
Date:   Tue, 23 Feb 2021 16:10:57 +0100
Message-Id: <161409305750190@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.18 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/arm/xen/p2m.c                              |    6 +
 arch/x86/xen/p2m.c                              |   15 +---
 drivers/block/xen-blkback/blkback.c             |   32 ++++----
 drivers/bluetooth/btusb.c                       |   20 +----
 drivers/infiniband/ulp/isert/ib_isert.c         |   27 +++++++
 drivers/infiniband/ulp/isert/ib_isert.h         |    6 +
 drivers/media/usb/pwc/pwc-if.c                  |   22 +++--
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c |   89 +++++++++++++++++-------
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c |   87 ++++++++++++++++++-----
 drivers/net/xen-netback/netback.c               |    4 -
 drivers/tty/tty_io.c                            |    5 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c                |   83 ++++++++++++++++------
 drivers/xen/gntdev.c                            |   37 +++++----
 drivers/xen/xen-scsiback.c                      |    4 -
 fs/btrfs/ctree.h                                |    6 -
 fs/btrfs/inode.c                                |    6 +
 include/xen/grant_table.h                       |    1 
 net/bridge/br.c                                 |    5 +
 net/core/dev.c                                  |    2 
 net/mptcp/protocol.c                            |    5 +
 net/openvswitch/actions.c                       |   15 +---
 net/packet/af_packet.c                          |    2 
 net/qrtr/qrtr.c                                 |    2 
 net/sched/Kconfig                               |    6 -
 net/tls/tls_proc.c                              |    3 
 26 files changed, 336 insertions(+), 156 deletions(-)

David Sterba (1):
      btrfs: fix backport of 2175bf57dc952 in 5.10.13

Eelco Chaudron (1):
      net: openvswitch: fix TTL decrement exception action execution

Felix Fietkau (1):
      mt76: mt7915: fix endian issues

Filipe Manana (1):
      btrfs: fix crash after non-aligned direct IO write with O_DSYNC

Florian Westphal (1):
      mptcp: skip to next candidate if subflow has unacked data

Greg Kroah-Hartman (1):
      Linux 5.10.18

Jan Beulich (8):
      Xen/x86: don't bail early from clear_foreign_p2m_mapping()
      Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
      Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()
      Xen/gntdev: correct error checking in gntdev_map_grant_pages()
      xen-blkback: don't "handle" error by BUG()
      xen-netback: don't "handle" error by BUG()
      xen-scsiback: don't "handle" error by BUG()
      xen-blkback: fix error handling in xen_blkbk_map()

Linus Torvalds (1):
      tty: protect tty_write from odd low-level tty disciplines

Loic Poulain (1):
      net: qrtr: Fix port ID for control messages

Lorenzo Bianconi (1):
      mt76: mt7615: fix rdd mcu cmd endianness

Matwey V. Kornilov (1):
      media: pwc: Use correct device for DMA

Max Gurtovoy (2):
      vdpa_sim: remove hard-coded virtq count
      IB/isert: add module param to set sg_tablesize for IO cmd

Pablo Neira Ayuso (1):
      net: sched: incorrect Kconfig dependencies on Netfilter modules

Stefano Garzarella (4):
      vdpa_sim: add struct vdpasim_dev_attr for device attributes
      vdpa_sim: store parsed MAC address in a buffer
      vdpa_sim: make 'config' generic and usable for any device type
      vdpa_sim: add get_config callback in vdpasim_dev_attr

Stefano Stabellini (1):
      xen/arm: don't ignore return errors from set_phys_to_machine

Trent Piepho (1):
      Bluetooth: btusb: Always fallback to alt 1 for WBS

Wang Hai (1):
      net: bridge: Fix a warning when del bridge sysfs

Yonatan Linik (1):
      net: fix proc_fs init handling in af_packet and tls

wenxu (1):
      net/sched: fix miss init the mru in qdisc_skb_cb

