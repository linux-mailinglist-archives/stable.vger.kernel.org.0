Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A24C30A818
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhBAMyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:54:55 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:43605 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231840AbhBAMyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:54:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D9822614;
        Mon,  1 Feb 2021 07:53:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 07:53:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=E6LJMB
        lORwo5HLbXjl0MGYFv3dqAnRgkvx/TFK7niPI=; b=irHLs54igP6uiDHb3Izx73
        vhTCsLcJGB6/fz7Yhq9STa9iRJ0ILd6HCfme+TsW4pt5Db9+E2GlKf+6M+r6djAn
        I7owj8fsDhY58Fr3Ws233nYmjqPzlqK7a4to3oYzbRXKlvfYgJJkECkRX3C6CEqJ
        f7qEiRyjpScKY+bafRIWY737PtO60BbEH0kdDxKkk8wGNPHwWXxpBaBItmy5O0cq
        OIML6ewMsXiyEFxeK92PvvWWbYp7bFg3afl3918oeG8lHZuYcR4iojDyCWpdCZm9
        MLlEYQbRSQhJdIcrcZg284VVLAl7zgEUwDiJFt3JwmIgbbTvy12ah3wG2kFv5Z8Q
        ==
X-ME-Sender: <xms:4_kXYK9AArt6m7hKJ9DuqDhCv2FTwlPsmX53ZfsniX5w7c8SqGwO_Q>
    <xme:4_kXYKvgXFFKDpPWbaYUJQ9J0vwu8snMxYDxcIjFT0r_IERWuMTyB4WbWfeGdPFTu
    butvX3jsrDjcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:4_kXYACjaXVc7Szoyh0Utxdq2nrdbL4lDoRC24nK-3T-ofOcaz9cow>
    <xmx:4_kXYCfTT291DoPkt2_0e79v6FL5-QMg6FkAZzcQ_RC3_jbQv8zt9Q>
    <xmx:4_kXYPO16dI8mymubyAKwm7dXLkpmRSGToaifpYez3d1EiO4yflN3A>
    <xmx:4_kXYBUgKHYGPsSDNtte2iZOHwQw-g20fGIs38r1bzWyQ5sNj_pzkNB9n_Y>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA34D24005C;
        Mon,  1 Feb 2021 07:53:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: if we see flush on exit, cancel related tasks" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk, josef.grieb@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:53:52 +0100
Message-ID: <1612184032183129@kroah.com>
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

From 84965ff8a84f0368b154c9b367b62e59c1193f30 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 23 Jan 2021 15:51:11 -0700
Subject: [PATCH] io_uring: if we see flush on exit, cancel related tasks

Ensure we match tasks that belong to a dead or dying task as well, as we
need to reap those in addition to those belonging to the exiting task.

Cc: stable@vger.kernel.org # 5.9+
Reported-by: Josef Grieb <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c07913ec0cca..695fe00bafdc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1069,8 +1069,12 @@ static bool io_match_task(struct io_kiocb *head,
 {
 	struct io_kiocb *req;
 
-	if (task && head->task != task)
+	if (task && head->task != task) {
+		/* in terms of cancelation, always match if req task is dead */
+		if (head->task->flags & PF_EXITING)
+			return true;
 		return false;
+	}
 	if (!files)
 		return true;
 
@@ -9136,6 +9140,9 @@ static int io_uring_flush(struct file *file, void *data)
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_ring_ctx *ctx = file->private_data;
 
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+		io_uring_cancel_task_requests(ctx, NULL);
+
 	if (!tctx)
 		return 0;
 

