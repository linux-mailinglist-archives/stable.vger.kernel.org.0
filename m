Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5D3253F4F
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgH0HgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbgH0HgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:36:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 134D9207DF;
        Thu, 27 Aug 2020 07:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598513784;
        bh=50PWRBRXLcjIwvP2C1Woq0/TcnUPo5Chd796qxCpnVk=;
        h=From:To:Cc:Subject:Date:From;
        b=ADEiGVrTJWFjNSIgQVIGqw5ZS8Kwpb8WOqE+N1XlF0b5P1kOya+ztwEjcNnktCSsF
         JQT9pHReyvcSfV6IVRAr9NIrHv79PuwFuPYa2jgtnk1k2YpY3Q7gAAN2JYiWAiq+Qi
         kls5j5bygriD4QPy2vh6JJ//36NfMA8PFfyrXe7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.7.19
Date:   Thu, 27 Aug 2020 09:36:34 +0200
Message-Id: <15985137402037@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----------
Note, this is the LAST 5.7.y kernel to be released.  This release series
is now end-of-life, please move to 5.8.y at this point in time.
------------

I'm announcing the release of the 5.7.19 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 +-
 arch/powerpc/kernel/cpu_setup_power.S        |    2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    5 ++++-
 fs/binfmt_flat.c                             |   20 ++++++++++++--------
 net/core/skbuff.c                            |    4 ++--
 net/ethtool/features.c                       |   19 ++++++++++---------
 net/ipv4/nexthop.c                           |    5 ++++-
 net/ipv6/ip6_tunnel.c                        |   10 +++++++++-
 net/qrtr/qrtr.c                              |   20 +++++++++++---------
 net/sched/act_ct.c                           |    2 +-
 net/sctp/stream.c                            |    6 ++++--
 net/smc/smc_diag.c                           |   16 +++++++++-------
 net/tipc/crypto.c                            |    2 ++
 net/tipc/netlink_compat.c                    |   12 +++++++++++-
 14 files changed, 81 insertions(+), 44 deletions(-)

Alaa Hleihel (1):
      net/sched: act_ct: Fix skb double-free in tcf_ct_handle_fragments() error flow

Cong Wang (1):
      tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

David Laight (1):
      net: sctp: Fix negotiation of the number of data streams.

Greg Kroah-Hartman (1):
      Linux 5.7.19

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

Michael Ellerman (1):
      powerpc/64s: Don't init FSCR_DSCR in __init_FSCR()

Necip Fazil Yildiran (1):
      net: qrtr: fix usage of idr in port assignment to socket

Nikolay Aleksandrov (1):
      net: nexthop: don't allow empty NHA_GROUP

Peilin Ye (1):
      net/smc: Prevent kernel-infoleak in __smc_diag_dump()

Shay Agroskin (1):
      net: ena: Make missed_tx stat incremental

Xin Long (1):
      tipc: call rcu_read_lock() in tipc_aead_encrypt_done()

