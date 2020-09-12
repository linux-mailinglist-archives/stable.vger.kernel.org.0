Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50E6267A56
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 14:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgILMn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 08:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgILMnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 08:43:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 734AF221EF;
        Sat, 12 Sep 2020 12:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599914569;
        bh=4y0IBtTMlvoht0YjCFO9ucgKCXgT+Bg6kqd9ORudE70=;
        h=From:To:Cc:Subject:Date:From;
        b=q2Zpg6EKVU0Pm44cgwTrsATKHQvccd1xAgv+Zp8CA0cVqqGEvU54frkq4D4skNGa1
         V+SUyd2AKhSv3Gd1JDmdEe1If/I2ZeiRr7ADVa2Nz20R3x5JMw47OQ/PCGzorBEP8C
         0WTZf1/btNTrZF4zfa8Qi2qMFQPrI+YbMQH5l09Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.145
Date:   Sat, 12 Sep 2020 14:42:49 +0200
Message-Id: <1599914569200227@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.145 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 block/blk-core.c                                 |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |    2 
 drivers/net/usb/dm9601.c                         |    4 +
 net/core/dev.c                                   |    3 -
 net/core/netpoll.c                               |    2 
 net/netlabel/netlabel_domainhash.c               |   59 +++++++++++------------
 net/sctp/socket.c                                |   16 ++----
 net/tipc/socket.c                                |    9 ++-
 sound/firewire/tascam/tascam.c                   |   30 +++++++++++
 10 files changed, 82 insertions(+), 47 deletions(-)

Greg Kroah-Hartman (1):
      Linux 4.19.145

Jakub Kicinski (1):
      net: disable netpoll on fresh napis

Jens Axboe (1):
      block: ensure bdi->io_pages is always initialized

Kamil Lorenc (1):
      net: usb: dm9601: Add USB ID of Keenetic Plus DSL

Paul Moore (1):
      netlabel: fix problems with mapping removal

Roi Dayan (1):
      net/mlx5e: Don't support phys switch id if not in switchdev mode

Takashi Sakamoto (1):
      ALSA; firewire-tascam: exclude Tascam FE-8 from detection

Tetsuo Handa (1):
      tipc: fix shutdown() of connectionless socket

Xin Long (1):
      sctp: not disable bh in the whole sctp_get_port_local()

