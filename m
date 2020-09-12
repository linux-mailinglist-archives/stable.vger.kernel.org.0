Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA36267A5B
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 14:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgILMoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 08:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgILMnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 08:43:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ED5521531;
        Sat, 12 Sep 2020 12:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599914602;
        bh=+6V9AuptSkVP3nTXsc//ymWHR9vSg71Efn2uJroJ82g=;
        h=From:To:Cc:Subject:Date:From;
        b=BeE3WND5ZdxNvBuVyHzNWTzChqW7as6YzqW/UVYVN4vgymWJvfNxwA15DI5Ssh+Zw
         2Oq7odCM//m3oerrP7Z6/bLtrg6E33eNRdG++S7tI/yYB+O3fkXikcQD09pBOlfX4n
         glCpdCdbFAcT2p5P40hjwy/WFaJSk0rc7zi94bsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.9
Date:   Sat, 12 Sep 2020 14:43:24 +0200
Message-Id: <159991460413254@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.9 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 
 drivers/infiniband/core/cma.c      |  257 +++++++++++++++++--------------------
 drivers/net/usb/dm9601.c           |    4 
 fs/io_uring.c                      |   47 ++++++
 net/core/dev.c                     |    3 
 net/core/netpoll.c                 |    2 
 net/ipv4/fib_trie.c                |    3 
 net/ipv6/sysctl_net_ipv6.c         |    3 
 net/mptcp/protocol.c               |    3 
 net/netlabel/netlabel_domainhash.c |   59 ++++----
 net/sched/sch_taprio.c             |   30 +++-
 net/sctp/socket.c                  |   16 --
 net/tipc/crypto.c                  |   12 +
 net/tipc/socket.c                  |    9 -
 14 files changed, 258 insertions(+), 192 deletions(-)

Florian Westphal (1):
      mptcp: free acked data before waiting for more memory

Greg Kroah-Hartman (1):
      Linux 5.8.9

Ido Schimmel (2):
      ipv4: Silence suspicious RCU usage warning
      ipv6: Fix sysctl max for fib_multipath_hash_policy

Jakub Kicinski (1):
      net: disable netpoll on fresh napis

Jason Gunthorpe (4):
      RDMA/cma: Simplify DEVICE_REMOVAL for internal_id
      RDMA/cma: Using the standard locking pattern when delivering the removal event
      RDMA/cma: Remove unneeded locking for req paths
      RDMA/cma: Execute rdma_cm destruction from a handler properly

Kamil Lorenc (1):
      net: usb: dm9601: Add USB ID of Keenetic Plus DSL

Paul Moore (1):
      netlabel: fix problems with mapping removal

Pavel Begunkov (2):
      io_uring: fix cancel of deferred reqs with ->files
      io_uring: fix linked deferred ->files cancellation

Tetsuo Handa (1):
      tipc: fix shutdown() of connectionless socket

Tuong Lien (1):
      tipc: fix using smp_processor_id() in preemptible

Vinicius Costa Gomes (1):
      taprio: Fix using wrong queues in gate mask

Xin Long (1):
      sctp: not disable bh in the whole sctp_get_port_local()

