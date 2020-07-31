Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A7B234A12
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 19:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbgGaRQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 13:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387609AbgGaRQf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jul 2020 13:16:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F35D2074B;
        Fri, 31 Jul 2020 17:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596215794;
        bh=KTaJrz9cOB7peEzwW1YQWYo6+kHy2WkhEKkVvTo+/NM=;
        h=From:To:Cc:Subject:Date:From;
        b=RN40sjF6IpM1vYpS8S9X9yfsBxIMgzDMNFH+BnoJhjtxbsm5uJExmnmvmRKsqz9Vt
         wgOlVHi6PrNfhAtpsKFpFMfqKze5dbHqsp+M8lzBmwFvduv9tWHrxd0QZh1o37BBej
         UFCBZpgS7sYu2UnQTncHF6muGi3uevSyulTJ2FRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.136
Date:   Fri, 31 Jul 2020 19:16:15 +0200
Message-Id: <159621577667130@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.136 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 +-
 drivers/base/regmap/regmap-debugfs.c |    6 ++++++
 drivers/net/wan/x25_asy.c            |   21 ++++++++++++++-------
 include/linux/tcp.h                  |    4 +++-
 net/ax25/af_ax25.c                   |   10 ++++++++--
 net/core/dev.c                       |    2 +-
 net/core/net-sysfs.c                 |    2 +-
 net/core/rtnetlink.c                 |    3 ++-
 net/core/sock_reuseport.c            |    1 +
 net/ipv4/tcp_input.c                 |   11 ++++++-----
 net/ipv4/tcp_output.c                |   13 ++++++++-----
 net/ipv4/udp.c                       |   17 ++++++++++-------
 net/ipv6/ip6_gre.c                   |   11 ++++++-----
 net/ipv6/udp.c                       |   17 ++++++++++-------
 net/qrtr/qrtr.c                      |    1 +
 net/rxrpc/recvmsg.c                  |    2 +-
 net/rxrpc/sendmsg.c                  |    2 +-
 net/sctp/stream.c                    |   27 ++++++++++++++++++---------
 18 files changed, 98 insertions(+), 54 deletions(-)

Cong Wang (1):
      qrtr: orphan socket in qrtr_release()

Dan Carpenter (1):
      AX.25: Prevent integer overflows in connect and sendmsg

David Howells (1):
      rxrpc: Fix sendmsg() returning EPIPE due to recvmsg() returning ENODATA

Greg Kroah-Hartman (1):
      Linux 4.19.136

Kuniyuki Iwashima (2):
      udp: Copy has_conns in reuseport_grow().
      udp: Improve load balancing for SO_REUSEPORT.

Miaohe Lin (1):
      net: udp: Fix wrong clean up for IS_UDPLITE macro

Peilin Ye (2):
      AX.25: Fix out-of-bounds read in ax25_connect()
      AX.25: Prevent out-of-bounds read in ax25_sendmsg()

Peng Fan (1):
      regmap: debugfs: check count when read regmap file

Subash Abhinov Kasiviswanathan (1):
      dev: Defer free of skbs in flush_backlog

Wei Yongjun (1):
      ip6_gre: fix null-ptr-deref in ip6gre_init_net()

Weilong Chen (1):
      rtnetlink: Fix memory(net_device) leak when ->newlink fails

Xie He (1):
      drivers/net/wan/x25_asy: Fix to make it work

Xin Long (2):
      sctp: shrink stream outq only when new outcnt < old outcnt
      sctp: shrink stream outq when fails to do addstream reconf

Xiongfeng Wang (1):
      net-sysfs: add a newline when printing 'tx_timeout' by sysfs

Yuchung Cheng (1):
      tcp: allow at most one TLP probe per flight

