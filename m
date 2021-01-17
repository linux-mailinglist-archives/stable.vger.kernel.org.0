Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E01E2F92D6
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbhAQOWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:22:08 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:33153 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729105AbhAQOWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:22:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 65B001948404;
        Sun, 17 Jan 2021 09:21:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:21:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3RdXje
        nXG1/NkB7HvgRgBdUAzfzs3OCHjbEbf/Wv/lE=; b=rPGAFDoLQEZ8ZwNBxLz42t
        VJL07dgjXWvL7alAyBOlk+Obxe8+vY4vlDof9PHTgBxkXyqwh6vqt+c/fT3RRfkX
        DRjt5NCuQXTYhlhjNv64o+jmklJY1stYXNizpGSdmcmT1xYEeDXVikMS+l55lfBG
        ahD/9RblGA38d3rCRNPk8VCenQ4pnOLbGRiS9izrVegkNLyQqUCUOAdGNezVyEar
        oBF5F9Sy4NuoaRewCeIqhSpX/sonNrn3Lr6NvyPlBsA1mykaPBfSuFSPevhat1vc
        Tqfj4a140Xj35EdXjtzHucFbheV2chHKkEh94AbaaBTlrvxeJyanpH3KVvkbI6CQ
        ==
X-ME-Sender: <xms:zUcEYMTGsP1XevGXeOYo7I3KOxVSI8a3sdkTFnB8AJOQpFMmAPZD7Q>
    <xme:zUcEYJzVflNbKmjoc1pHtAigUy6vyXyij_UddHTnoXnp3WC58f5VbODDy7BO1I94x
    kEO2g5Sgww3DA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:zUcEYJ1zG6zpPOkOHaYGD0MRqIJChB-2QuXgj3G9emcuGqRxJZOSBQ>
    <xmx:zUcEYAC0LvEA6eDkS6chewYFErDyrXH6UWAMAhLPoNWSO1SiEfBGCg>
    <xmx:zUcEYFho3tJnboK_7CFviXUd1rhfVF_qKPySq_dEyNitG2wpJLUR7Q>
    <xmx:zUcEYPefVb2cuGzjHd9HkfEE1wT716p9EL7vhBWsFF3QzbtyqRfniQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 284E2108005F;
        Sun, 17 Jan 2021 09:21:01 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: ensure finish_wait() is always called in" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:20:59 +0100
Message-ID: <1610893259196164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a8d13dbccb137c46fead2ec1a4f1fbc8cfc9ea91 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Jan 2021 16:04:23 -0700
Subject: [PATCH] io_uring: ensure finish_wait() is always called in
 __io_uring_task_cancel()

If we enter with requests pending and performm cancelations, we'll have
a different inflight count before and after calling prepare_to_wait().
This causes the loop to restart. If we actually ended up canceling
everything, or everything completed in-between, then we'll break out
of the loop without calling finish_wait() on the waitqueue. This can
trigger a warning on exit_signals(), as we leave the task state in
TASK_UNINTERRUPTIBLE.

Put a finish_wait() after the loop to catch that case.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 06cc79d39586..985a9e3f976d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9101,6 +9101,7 @@ void __io_uring_task_cancel(void)
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
+	finish_wait(&tctx->wait, &wait);
 	atomic_dec(&tctx->in_idle);
 
 	io_uring_remove_task_files(tctx);

