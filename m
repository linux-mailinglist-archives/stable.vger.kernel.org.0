Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC432F11B5
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 12:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbhAKLoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 06:44:32 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45747 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729658AbhAKLoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 06:44:32 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id DD85F2938;
        Mon, 11 Jan 2021 06:43:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 11 Jan 2021 06:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=f5/l5F
        zZI3ssX5X0eix0J2LjK1WN6H/+Xp1un57SLfk=; b=WOwBXeiVwNfsQjM+GrHNFi
        jCRwWA0sLMMqK3kDDK+ZxrPF7vMcDJHEHszGmzqxK8e/mgs6jpHv7w21g/hDSCZt
        9tZQ+Pc4cqk9qvgXseXsBJKBPVTKT0ycGk6OuuJ3RYiLI9GPRkGVOC+B6YGnr2eK
        vkSQo9Jy2Il7UvYY8RDTcJLhMf6tmVXGHS3Zk4ce9j8+DDNXamLcwdZaPRwnEUQE
        LAVC18SgZ1uo2xmg/BoCVQatVnB1YYuYL3i/R688VgtuTYjbB2CAvsPkJB2VVUZO
        s2m+V9iuQdU71ZRCSS8cC/bwGuANXoKq4zVoTnrwRXFG7gIVm5mLgVgKf8D0Ltlg
        ==
X-ME-Sender: <xms:3Tn8X2FVtaoGqSQePMDlKLywkBSP1bYz85xJ3FGpJSO8gbMqFqAe0g>
    <xme:3Tn8Xy0TaRCwvGqm9qxwl0GMj-01A_Rd-b9_FyFAklBRyYobmZOr2TcGGdfYt8QTI
    rKkyTVj3epptQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehuddgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:3Tn8X2nCFJ0DlpctdyWDY-83P6DJ4-qCUVxjQt7dnNSQay-yzrZN7A>
    <xmx:3Tn8X6_ZYgT8F78gsbqZk_9atPs5sOxT-nm7ao4-xuj_QqhquVDhrQ>
    <xmx:3Tn8XzpD-iCjWO5bBTIpaiM3rz4x-2d76FaOX5Gdp1BaJI3KwLeIPg>
    <xmx:3Tn8X-MXjZXy_olPa8Y4lVSvp8fYran-aHUB-b3mjziw1teK75h-W7ngJeI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4E6C108005C;
        Mon, 11 Jan 2021 06:43:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: dont kill fasync under completion_lock" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 12:44:37 +0100
Message-ID: <161036547722987@kroah.com>
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

