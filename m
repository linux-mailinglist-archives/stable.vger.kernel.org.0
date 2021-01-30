Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8589A30961F
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 16:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhA3O5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 09:57:03 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:48467 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232258AbhA3O42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 09:56:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E13BE195EE0A;
        Sat, 30 Jan 2021 09:55:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 30 Jan 2021 09:55:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ExVEyf
        LVyfI8/Aj4fPxbM0aV8jKSzuKT7bs53gila+o=; b=Xx2WZFhc+Ppo2IDLHFWRQY
        DXPUHZDoOTUTjBIJWV0GFpLjxW6M4g5xIZUcRHNqkMV+lnubczgk4txEchYwht3F
        bCwMgn/OaiZYCJyw2Eumuvj1VGPVg7RxOwsinghbG2vTF8yGgLAzs1Jp75BZfNgE
        wbKMYo501Jq7ZYHiwjMeBXqMDQtPfVmV/O7S/qxN2KMul9oVz0O11eWxnk1NLUKz
        RZscL2+FYapcWrEMvSQXjCLLnuAzK354E9KEA1aMzZWo5M355wjnrsSNUqsY9Wgj
        StnYueaTc6Br1PKi6ql2NrMx1tMLkBO10mM813h/bPMy6wZaXplm0X3/rc9+pQVA
        ==
X-ME-Sender: <xms:R3MVYEaa0rcPBQbORJ__f7EL8kSwznFbZRrIPcjEwi4n5YB3Pe_ctw>
    <xme:R3MVYPavxK8wBIhaIno_oBd1UCdK-tKkW6ENs-NDvFimFFQUUlRsrogPu5QUNPhaP
    QSvGjvTs6MtPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeggdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:R3MVYO9H_g6U-NcDxvwKUdvOjMdxM9mCoz7JMMe3G8C5I6qrmGV9QQ>
    <xmx:R3MVYOrGHK62h0w22khf1-Wf1MO_1j-QLW0HXmtAQ-FhleVtRpKBhg>
    <xmx:R3MVYPqx8oQvfAxB0fepX3VNibzrX26Gh8U1yxwgoNrFD85k-ORPRA>
    <xmx:R3MVYOTTTNxYtEJpdRN18yt-en-ZR7GR5bqxu1bYANH6gq-x0KKcNA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8CC781080059;
        Sat, 30 Jan 2021 09:55:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] nbd: freeze the queue while we're adding connections" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Jan 2021 15:54:54 +0100
Message-ID: <161201849425159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

