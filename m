Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70F648AF3E
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 15:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241246AbiAKOO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 09:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238763AbiAKOO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 09:14:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D614C06173F;
        Tue, 11 Jan 2022 06:14:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E29F261665;
        Tue, 11 Jan 2022 14:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5487C36AEB;
        Tue, 11 Jan 2022 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641910497;
        bh=TIwCoIo+wYfFyiYX/E8C5ej4SYpUVnhdmgm/W602+is=;
        h=From:To:Cc:Subject:Date:From;
        b=xhWD9F2AXhgGPUEUXzteYw7ye+awGoEJbh4lPNufkIJrN5WGZXM0dw2hwdb9N9haI
         ueMxRrpzP/H/uNnPoVhuoPEiBChbd3AjyVw7O5MP/KvoJVXfBYmCUq0LLAwxtwf8B1
         470fujIYsd5m2D40bM57uj9d6vhqS+pYr8zxpyfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.262
Date:   Tue, 11 Jan 2022 15:14:53 +0100
Message-Id: <16419104934282@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.262 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 -
 drivers/bluetooth/btusb.c                   |   32 ++++++++++++----
 drivers/infiniband/core/uverbs_marshall.c   |    2 -
 drivers/isdn/mISDN/core.c                   |    6 +--
 drivers/isdn/mISDN/core.h                   |    4 +-
 drivers/isdn/mISDN/layer1.c                 |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c |   56 ++++++++++++++++++++++++----
 drivers/net/ieee802154/atusb.c              |   10 +++--
 drivers/net/usb/rndis_host.c                |    5 ++
 drivers/power/reset/ltc2952-poweroff.c      |    4 +-
 drivers/scsi/libiscsi.c                     |    6 ++-
 drivers/virtio/virtio_pci_common.c          |    7 +++
 fs/xfs/xfs_ioctl.c                          |    3 +
 kernel/trace/trace.c                        |    6 +--
 net/ipv4/udp.c                              |    2 -
 net/ipv6/ip6_vti.c                          |    2 +
 net/ipv6/route.c                            |   28 +++++++++++++-
 net/mac80211/mlme.c                         |    2 -
 net/phonet/pep.c                            |    1 
 net/sched/sch_qfq.c                         |    6 +--
 20 files changed, 145 insertions(+), 43 deletions(-)

Darrick J. Wong (1):
      xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate

David Ahern (4):
      ipv6: Check attribute length for RTA_GATEWAY in multipath route
      ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route
      ipv6: Continue processing multipath route even if gateway attribute is invalid
      ipv6: Do cleanup if attribute validation fails in multipath route

Di Zhu (1):
      i40e: fix use-after-free in i40e_sync_filters_subtask()

Eric Dumazet (1):
      sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc

Greg Kroah-Hartman (1):
      Linux 4.14.262

Hangyu Hua (1):
      phonet: refcount leak in pep_sock_accep

Jedrzej Jagielski (1):
      i40e: Fix incorrect netdev's real number of RX/TX queues

Leon Romanovsky (1):
      RDMA/core: Don't infoleak GRH fields

Lixiaokeng (1):
      scsi: libiscsi: Fix UAF in iscsi_conn_get_param()/iscsi_conn_teardown()

Nathan Chancellor (1):
      power: reset: ltc2952: Fix use of floating point literals

Naveen N. Rao (2):
      tracing: Fix check for trace_percpu_buffer validity in get_trace_buf()
      tracing: Tag trace_percpu_buffer as a percpu pointer

Parav Pandit (1):
      virtio_pci: Support surprise removal of virtio pci device

Pavel Skripkin (1):
      ieee802154: atusb: fix uninit value in atusb_set_extended_addr

Takashi Iwai (1):
      Bluetooth: btusb: Apply QCA Rome patches for some ATH3012 models

Thomas Toye (1):
      rndis_host: support Hytera digital radios

Tom Rix (1):
      mac80211: initialize variable have_higher_than_11mbit

William Zhao (1):
      ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate

wolfgang huang (1):
      mISDN: change function names to avoid conflicts

yangxingwu (1):
      net: udp: fix alignment problem in udp4_seq_show()

