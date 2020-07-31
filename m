Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9717234A1B
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 19:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbgGaRQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 13:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732953AbgGaRQY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jul 2020 13:16:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A751322B42;
        Fri, 31 Jul 2020 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596215784;
        bh=ro3lGatHfSU2aYnzZOQu9dDVJyaAfG9ef1xU8u45zk4=;
        h=From:To:Cc:Subject:Date:From;
        b=MkvULP5f/ix/CmFY5IXZUsUV8KvFFIL3Pa/mYovkvSn/WXs3xrn2zWBVJH4L2Tf3t
         98pt0jHIWxSUimqPfamd1wPu9xvbEW8azWAn+VsYknH/N3FeATRQoOuTI+3g3peIY5
         qX0unQQPu7eI5gUxSpKYN3WqUfy5jHWMRh0yr/Yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.191
Date:   Fri, 31 Jul 2020 19:16:06 +0200
Message-Id: <159621576612204@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.191 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 +-
 drivers/base/regmap/regmap-debugfs.c |    6 ++++++
 drivers/net/wan/x25_asy.c            |   21 ++++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.c             |    4 ++++
 include/linux/tcp.h                  |    4 +++-
 mm/page_owner.c                      |    1 -
 net/ax25/af_ax25.c                   |   10 ++++++++--
 net/core/dev.c                       |    2 +-
 net/core/net-sysfs.c                 |    2 +-
 net/core/rtnetlink.c                 |    3 ++-
 net/ipv4/tcp_input.c                 |   11 ++++++-----
 net/ipv4/tcp_output.c                |   13 ++++++++-----
 net/ipv4/udp.c                       |    2 +-
 net/ipv6/ip6_gre.c                   |   11 ++++++-----
 net/ipv6/udp.c                       |    2 +-
 net/rxrpc/recvmsg.c                  |    2 +-
 net/rxrpc/sendmsg.c                  |    2 +-
 17 files changed, 64 insertions(+), 34 deletions(-)

Dan Carpenter (1):
      AX.25: Prevent integer overflows in connect and sendmsg

David Howells (1):
      rxrpc: Fix sendmsg() returning EPIPE due to recvmsg() returning ENODATA

Eric Sandeen (1):
      xfs: set format back to extents if xfs_bmap_extents_to_btree

Greg Kroah-Hartman (1):
      Linux 4.14.191

Miaohe Lin (1):
      net: udp: Fix wrong clean up for IS_UDPLITE macro

Oscar Salvador (1):
      mm/page_owner.c: remove drain_all_pages from init_early_allocated_pages

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

Xiongfeng Wang (1):
      net-sysfs: add a newline when printing 'tx_timeout' by sysfs

Yuchung Cheng (1):
      tcp: allow at most one TLP probe per flight

