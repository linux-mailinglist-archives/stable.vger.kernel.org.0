Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41473309641
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 16:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhA3Pbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 10:31:51 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:49449 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232225AbhA3Oz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 09:55:57 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 10682195F25F;
        Sat, 30 Jan 2021 09:54:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 30 Jan 2021 09:54:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=yNnZrv
        3dPWOrBjbkA042e0c5ZvUViQCq3CdKw5r24uk=; b=UiN6kWiJXJS8/c8Ydn4Pij
        lV+6pW+Sljwff/DL1mVlf12Pb+m3pMi7iEpBcpX3fPb/a1w45JIS1Y0fTe4UMudH
        ZtgGfeqoCArHuwV0UbT9GC6kKbRk9zArItzb6ZxNZ2PSgbh9ozi76z4TsDlIyCpw
        B+q4xJkQzOHBAYNDcUO8SZ080STw5CDZZfddb8G42lx+3KKq9EPcZcbkImMXP9U1
        xx/itSawWGtvFgP2VNnw8dmyTZQ823+YMkly/dVzb3TrVeQ76i2fpcdZyHsYOTuN
        5Yk9tnEn6Iz3SpIVWFHPm0BqDjpTYbvugu8TP/E06OxiWId531prggmPkOQQFe1w
        ==
X-ME-Sender: <xms:P3MVYGSrIca4WN6aWXUgdjGidnMi7FJpQWMuKfAZT0dRruRKcg-KHw>
    <xme:P3MVYLztd5yLXLJKR8i-j8nBrQc6ZLWPgZqlAW5ENriteRhjgL60h09BWdnQ9kihe
    GzG2krqAMBr3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeggdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:P3MVYD15V4dIbJs688pfhaDIdFFuaIIAKrUQWYXpaRuvf9J-gyIepQ>
    <xmx:P3MVYCDZSib82ds-7mEFwT0wYjofEkkji63HT2akCBmzN96MmL9-Wg>
    <xmx:P3MVYPj2tLKdRZJtLog9aGBwXyzCo8T0_1krzA-wJEWp4vRPVI_AVg>
    <xmx:QHMVYPKgsVeou_g4zLouD2WMIyk7qB0_XLp2X_Cegjd4QfpQmaN0XA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64B6724005B;
        Sat, 30 Jan 2021 09:54:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] nbd: freeze the queue while we're adding connections" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Jan 2021 15:54:53 +0100
Message-ID: <16120184933220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b98e762e3d71e893b221f871825dc64694cfb258 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 25 Jan 2021 12:21:02 -0500
Subject: [PATCH] nbd: freeze the queue while we're adding connections

When setting up a device, we can krealloc the config->socks array to add
new sockets to the configuration.  However if we happen to get a IO
request in at this point even though we aren't setup we could hit a UAF,
as we deref config->socks without any locking, assuming that the
configuration was setup already and that ->socks is safe to access it as
we have a reference on the configuration.

But there's nothing really preventing IO from occurring at this point of
the device setup, we don't want to incur the overhead of a lock to
access ->socks when it will never change while the device is running.
To fix this UAF scenario simply freeze the queue if we are adding
sockets.  This will protect us from this particular case without adding
any additional overhead for the normal running case.

Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 6727358e147d..e6ea5d344f87 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1022,6 +1022,12 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
 	if (!sock)
 		return err;
 
+	/*
+	 * We need to make sure we don't get any errant requests while we're
+	 * reallocating the ->socks array.
+	 */
+	blk_mq_freeze_queue(nbd->disk->queue);
+
 	if (!netlink && !nbd->task_setup &&
 	    !test_bit(NBD_RT_BOUND, &config->runtime_flags))
 		nbd->task_setup = current;
@@ -1060,10 +1066,12 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
 	nsock->cookie = 0;
 	socks[config->num_connections++] = nsock;
 	atomic_inc(&config->live_connections);
+	blk_mq_unfreeze_queue(nbd->disk->queue);
 
 	return 0;
 
 put_socket:
+	blk_mq_unfreeze_queue(nbd->disk->queue);
 	sockfd_put(sock);
 	return err;
 }

