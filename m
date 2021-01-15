Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17512F7704
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 11:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbhAOKt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 05:49:56 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:59439 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731827AbhAOKtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 05:49:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E586419C3D91;
        Fri, 15 Jan 2021 05:49:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 05:49:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=f5/l5F
        zZI3ssX5X0eix0J2LjK1WN6H/+Xp1un57SLfk=; b=qBATQwRqxZcG74LS/UmmdE
        wFRT8gcjHY5WoPt2gC72USZew2T5uku7WfW+Ub7O6z+A6P0HJFsHht6u8eoIvjC+
        AZnsgHhDQmw2x6amaDNI+aJ0Molm/8So8ZB7bgQ3HICd/A0e/ZT+HiDYq703mBgy
        rgbE2fvm1FMoy9e59THG0sZYwBNErMIeAgEOZm2fbguCdeoiuvkdPAcMV1c3SxOB
        fzi9PB7d8wy4yWDNr4l7iDAwr3r3fwMZhDrmWfg4tM8AMhGmnpxJHCyc5VUNPbZh
        07Rac8Af4n2LJW3qlrIC5tRibfvQ7pqOc3xyKlefptIM3GBpCgjInfLirJZij6XQ
        ==
X-ME-Sender: <xms:JHMBYDKSexbX7OXx9NWpHqZM_P04RbHXvs39poMRpMTjFIT0JHffow>
    <xme:JHMBYHJHBAJe29IDm8M5sQ_YnJmWv4molbeEDr7UdH8cLUErXZis2ARsSEp2UAswp
    ZMUoRPrbSP_tQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugddugeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:JHMBYLsve2S50t7GSGPiZOgvxbh4eTUve4gZ5konWxsbIkZJSSIVwA>
    <xmx:JHMBYMbAnOSoLFsK2DUYMrl9IyJv5gsfrbKk6tEBwK8z3Sx9VUdiDA>
    <xmx:JHMBYKa8u9IqmBJ3656hEspuY-Wc3s1rTxVb86DnyMR6R8gpHVs3Wg>
    <xmx:JHMBYDBp2qnWn0XkPm0243gwRmAXBqNJokY-HNrtWnTR1IEc2CJZMQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C25E240057;
        Fri, 15 Jan 2021 05:49:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: dont kill fasync under completion_lock" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 11:49:07 +0100
Message-ID: <161070774724333@kroah.com>
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

From 4aa84f2ffa81f71e15e5cffc2cc6090dbee78f8e Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 7 Jan 2021 03:15:42 +0000
Subject: [PATCH] io_uring: dont kill fasync under completion_lock

      CPU0                    CPU1
       ----                    ----
  lock(&new->fa_lock);
                               local_irq_disable();
                               lock(&ctx->completion_lock);
                               lock(&new->fa_lock);
  <Interrupt>
    lock(&ctx->completion_lock);

 *** DEADLOCK ***

Move kill_fasync() out of io_commit_cqring() to io_cqring_ev_posted(),
so it doesn't hold completion_lock while doing it. That saves from the
reported deadlock, and it's just nice to shorten the locking time and
untangle nested locks (compl_lock -> wq_head::lock).

Reported-by: syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91e517ad1421..401316fe2ae2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1345,11 +1345,6 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 
 	/* order cqe stores with ring update */
 	smp_store_release(&rings->cq.tail, ctx->cached_cq_tail);
-
-	if (wq_has_sleeper(&ctx->cq_wait)) {
-		wake_up_interruptible(&ctx->cq_wait);
-		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
-	}
 }
 
 static void io_put_identity(struct io_uring_task *tctx, struct io_kiocb *req)
@@ -1711,6 +1706,10 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
+	if (wq_has_sleeper(&ctx->cq_wait)) {
+		wake_up_interruptible(&ctx->cq_wait);
+		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
+	}
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1721,6 +1720,10 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 	}
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
+	if (wq_has_sleeper(&ctx->cq_wait)) {
+		wake_up_interruptible(&ctx->cq_wait);
+		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
+	}
 }
 
 /* Returns true if there are no backlogged entries after the flush */

