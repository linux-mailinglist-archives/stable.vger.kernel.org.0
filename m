Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CDA48AF42
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 15:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241427AbiAKOPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 09:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241443AbiAKOPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 09:15:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F30C061748;
        Tue, 11 Jan 2022 06:15:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6437EB81ACE;
        Tue, 11 Jan 2022 14:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994C7C36AE3;
        Tue, 11 Jan 2022 14:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641910505;
        bh=QuUVScDZH4OKP0aj4rTImdi85Vyg1t60LmrOZXT5ZN8=;
        h=From:To:Cc:Subject:Date:From;
        b=kO8RW3rzVOdnpgK1PLeuZySMQWYWV2ktKKPAk1tBcb/IrqkOnODzheEi4sR96SVgG
         zMFaYsuEMn6EGsGdcKEjS4L0P6R868SqArq4IhH8KxhxLVqOL5FZBV0knt7ipvcm++
         qfWQ1jDoyA3Xy3rE8PH5zKqhiwyOEAiSTEr5AMM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.225
Date:   Tue, 11 Jan 2022 15:14:57 +0100
Message-Id: <1641910498143174@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.225 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 -
 drivers/infiniband/core/uverbs_marshall.c   |    2 -
 drivers/isdn/mISDN/core.c                   |    6 +--
 drivers/isdn/mISDN/core.h                   |    4 +-
 drivers/isdn/mISDN/layer1.c                 |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c |   56 ++++++++++++++++++++++++----
 drivers/net/ieee802154/atusb.c              |   10 +++--
 drivers/net/usb/rndis_host.c                |    5 ++
 drivers/power/reset/ltc2952-poweroff.c      |    4 +-
 drivers/scsi/libiscsi.c                     |    6 ++-
 drivers/usb/mtu3/mtu3_gadget.c              |    4 +-
 fs/xfs/xfs_ioctl.c                          |    3 +
 kernel/trace/trace.c                        |    6 +--
 net/ipv4/udp.c                              |    2 -
 net/ipv6/ip6_vti.c                          |    2 +
 net/ipv6/route.c                            |   28 +++++++++++++-
 net/mac80211/mlme.c                         |    2 -
 net/phonet/pep.c                            |    1 
 net/sched/sch_qfq.c                         |    6 +--
 19 files changed, 115 insertions(+), 38 deletions(-)

Chunfeng Yun (1):
      usb: mtu3: fix interval value for intr and isoc

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
      Linux 4.19.225

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

Pavel Skripkin (1):
      ieee802154: atusb: fix uninit value in atusb_set_extended_addr

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

