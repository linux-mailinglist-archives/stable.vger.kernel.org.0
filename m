Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B2733016E
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhCGNwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:52:40 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:36223 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231655AbhCGNw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:52:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6194B1A5D;
        Sun,  7 Mar 2021 08:52:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5Qd28c
        vyU1NSE0cLx7q/WXN7mekmMZD7c+FENtOiZhQ=; b=dgjIKwfKSgBikK6I/2OYmF
        Q0t4X3PFDKYUYUbsauU33qmltdDfuZJbbQ/ABXNNYZKYmGVw+zH0Uvj552dg4H6i
        SXMysdlXgqwyO3QoMHnJiXnsVWMbIp7ueW+BTuTbkmb47dd4bRYVI6SaS/P14yIK
        BuCYutK+N7lFBcuyzWtL1Kw5MRPdEzP92eJcel7fh5DdlUyaL0Y0EHgZebkhVORo
        pC0xUx9694LSJwqWQPO97W2pYNuvlhVr/nBQWiHASDhsaHS5IdOGiGqbo2gtlodY
        mX40fw+c1Jidg0ypppTRKDekrz8FleLfmcM335HAU84wWbEicE+lMX54BiTC9IGA
        ==
X-ME-Sender: <xms:nNpEYKximan9DBjicZcbuwY2DPmnspPmPinTyccR0vCqM4S9T4Uslg>
    <xme:nNpEYGSne2sWYYM3-yeFgC0Iz8a_exr_AVSgFhu_EV8vO73eiseEwrSik8ZeGwPB7
    BSFpXXUfT7lxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:nNpEYMV1mtu3MrkQdbaqYSrnl-cmwwB5QtKJHCL1qrhq6H3Yw_xvZw>
    <xmx:nNpEYAiPEvMKGjLRzIj-bb9Ms4CfgHAmLmADXzNJHKFxPQyKJiMUjg>
    <xmx:nNpEYMDaCzOx6irbhbxVeapuWZI5vxAo9aOH1ZSzZ0jnhMh7uiRHwQ>
    <xmx:ndpEYL_iH2XZA1H4zoD8JkwEChdToWMaZfhxZdWYSDvzpD4K4K5M7LUmozw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA95424005A;
        Sun,  7 Mar 2021 08:52:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: don't keep looping for more events if we can't" failed to apply to 5.11-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:52:27 +0100
Message-ID: <161512514718842@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca0a26511c679a797f86589894a4523db36d833e Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 4 Mar 2021 17:15:48 -0700
Subject: [PATCH] io_uring: don't keep looping for more events if we can't
 flush overflow

It doesn't make sense to wait for more events to come in, if we can't
even flush the overflow we already have to the ring. Return -EBUSY for
that condition, just like we do for attempts to submit with overflow
pending.

Cc: stable@vger.kernel.org # 5.11
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 76e243c056b5..044170165402 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1451,18 +1451,22 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	return all_flushed;
 }
 
-static void io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
+static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 				     struct task_struct *tsk,
 				     struct files_struct *files)
 {
+	bool ret = true;
+
 	if (test_bit(0, &ctx->cq_check_overflow)) {
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		__io_cqring_overflow_flush(ctx, force, tsk, files);
+		ret = __io_cqring_overflow_flush(ctx, force, tsk, files);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
+
+	return ret;
 }
 
 static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
@@ -6883,11 +6887,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		/* if we can't even flush overflow, don't wait for more */
+		if (!io_cqring_overflow_flush(ctx, false, NULL, NULL)) {
+			ret = -EBUSY;
+			break;
+		}
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		finish_wait(&ctx->wait, &iowq.wq);
+		cond_resched();
 	} while (ret > 0);
 
 	restore_saved_sigmask_unless(ret == -EINTR);

