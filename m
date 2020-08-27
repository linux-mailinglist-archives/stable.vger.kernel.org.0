Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54E5253F47
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgH0HfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbgH0HfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:35:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B0DA20791;
        Thu, 27 Aug 2020 07:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598513709;
        bh=P4YNVNYUh0FeNnaF4nixNGpIDzORDRqaUU67e3RwtBA=;
        h=From:To:Cc:Subject:Date:From;
        b=xOd56YE0SGwnJzkriFiZ6yv0ZpqpiRrldfSSw9YLEukG/C6iJSgpCnnuVWlzBmDNl
         cDuD6DGrM5PBK8UCY5JYLjIBTZzhKZq0h8edbu1y+hnkLRj3pBS2bnXM+uDJq1ECXO
         zebuUrx2ArtrmhJvBfcDMj6uUMbwTtvPZlAbXOMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.5
Date:   Thu, 27 Aug 2020 09:35:22 +0200
Message-Id: <1598513721250116@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.5 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    5 ++++-
 fs/binfmt_flat.c                             |   20 ++++++++++++--------
 fs/io_uring.c                                |    3 ++-
 net/core/skbuff.c                            |    4 ++--
 net/ethtool/features.c                       |   19 ++++++++++---------
 net/ipv4/nexthop.c                           |    5 ++++-
 net/ipv6/ip6_tunnel.c                        |   10 +++++++++-
 net/netlink/policy.c                         |    3 +++
 net/qrtr/qrtr.c                              |   20 +++++++++++---------
 net/sched/act_ct.c                           |    2 +-
 net/sctp/stream.c                            |    6 ++++--
 net/smc/smc_diag.c                           |   16 +++++++++-------
 net/tipc/crypto.c                            |    2 ++
 net/tipc/netlink_compat.c                    |   12 +++++++++++-
 15 files changed, 85 insertions(+), 44 deletions(-)

Alaa Hleihel (1):
      net/sched: act_ct: Fix skb double-free in tcf_ct_handle_fragments() error flow

Cong Wang (1):
      tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

David Laight (1):
      net: sctp: Fix negotiation of the number of data streams.

Greg Kroah-Hartman (1):
      Linux 5.8.5

Johannes Berg (1):
      netlink: fix state reallocation in policy export

Mark Tomlinson (1):
      gre6: Fix reception with IP6_TNL_F_RCV_DSCP_COPY

Max Filippov (1):
      binfmt_flat: revert "binfmt_flat: don't offset the data start"

Maxim Mikityanskiy (3):
      ethtool: Fix preserving of wanted feature bits in netlink interface
      ethtool: Account for hw_features in netlink interface
      ethtool: Don't omit the netlink reply if no features were changed

Miaohe Lin (1):
      net: Fix potential wrong skb->protocol in skb_vlan_untag()

Necip Fazil Yildiran (1):
      net: qrtr: fix usage of idr in port assignment to socket

Nikolay Aleksandrov (1):
      net: nexthop: don't allow empty NHA_GROUP

Pavel Begunkov (1):
      io_uring: fix missing ->mm on exit

Peilin Ye (1):
      net/smc: Prevent kernel-infoleak in __smc_diag_dump()

Shay Agroskin (1):
      net: ena: Make missed_tx stat incremental

Xin Long (1):
      tipc: call rcu_read_lock() in tipc_aead_encrypt_done()

