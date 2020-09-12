Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E82A267A58
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 14:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgILMnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 08:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgILMnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 08:43:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 834AD22204;
        Sat, 12 Sep 2020 12:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599914576;
        bh=1pxj5KMJIIG4YfDalHo+mh/C9ESdaK54gnp78NfKjoU=;
        h=From:To:Cc:Subject:Date:From;
        b=Cs33MsyVx1tPMmbbU4+kMvHDjwxidUYaQ1I6ADsL7t6HwR4zELRMW7qrksagTSVuA
         q3YqwAZMzOFu1r8BDLBMrlUKiJRXoMsO72WRmHAkFBmGVlgEzdUnLzYqMKGSFAuJRh
         wm9LaQdVASbFi8QMN/CqVTBEaVyg4TUtjryR5Q/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.65
Date:   Sat, 12 Sep 2020 14:42:58 +0200
Message-Id: <1599914579255132@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.65 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 -
 drivers/net/usb/dm9601.c           |    4 ++
 net/core/dev.c                     |    3 +
 net/core/netpoll.c                 |    2 -
 net/ipv4/fib_trie.c                |    3 +
 net/ipv6/sysctl_net_ipv6.c         |    3 +
 net/netlabel/netlabel_domainhash.c |   59 ++++++++++++++++++-------------------
 net/sched/sch_taprio.c             |   30 +++++++++++++++---
 net/sctp/socket.c                  |   16 +++-------
 net/tipc/socket.c                  |    9 +++--
 10 files changed, 78 insertions(+), 53 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.4.65

Ido Schimmel (2):
      ipv4: Silence suspicious RCU usage warning
      ipv6: Fix sysctl max for fib_multipath_hash_policy

Jakub Kicinski (1):
      net: disable netpoll on fresh napis

Kamil Lorenc (1):
      net: usb: dm9601: Add USB ID of Keenetic Plus DSL

Paul Moore (1):
      netlabel: fix problems with mapping removal

Tetsuo Handa (1):
      tipc: fix shutdown() of connectionless socket

Vinicius Costa Gomes (1):
      taprio: Fix using wrong queues in gate mask

Xin Long (1):
      sctp: not disable bh in the whole sctp_get_port_local()

