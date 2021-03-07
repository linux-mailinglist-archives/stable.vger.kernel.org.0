Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84533016D
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhCGNwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:52:39 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41567 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231633AbhCGNwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:52:23 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 40DBB1A55;
        Sun,  7 Mar 2021 08:52:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:52:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aVloe2
        n7FDv0r2mk98Q7Yegu4mB26Fvo1dFIRnSYL00=; b=dOGbhbL8NEm2gXB4fjUMM6
        CcXsxU5fStOODR8PStSAE0uljKnMdGAHG81+bLGVNE91EmghnSSeq0huAF1UVgUK
        gIwbXbJAhJUTmMyL+EyO0b6ePmCArUFnLICb+o7pa5MPZ90hHeEHhtLb5XqrplQs
        bgGDzAEk+X9kiI3bqnY/yJNqkExsd+4OmPe3OvaONZ9b3GONQ52MTi2LbzBeIiyQ
        2sJR3VflVcLQYPoK+fnL2aiFojlXmfGbwBPNXTMSx/lLfRqMJlDhhDbSbPxeeVQB
        DjCN/jLPvoQM8qv3l3ATTrDb+gYQ/YBAHekGy0icbmksB1we7HqDxsfGxzSaQKVg
        ==
X-ME-Sender: <xms:ltpEYC_GcZ5ugLAYzzUWhQx_XRsuKn9gB311JxmL6RlP8W5IzCqicA>
    <xme:ltpEYCu4yWtxck9WtdVK6F-nj9zI0Cs7N9we7d4AG2ReU0f91pcuMqCuM96HzqIQ9
    rq8vO5PGRrJNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:ltpEYIBkXinMpn0-hhGVrHSe_10UecUuyDM_fLT-wAX6YLxSgB9xXw>
    <xmx:ltpEYKc2X1ajugwJP3cd3woDlvM-AuGqDItrg8UqoW82-94OcXgbiw>
    <xmx:ltpEYHMT3ME-HDrJDTg4XENTApYulYsBjWN9dU3qIskpp17C9CN5vA>
    <xmx:ltpEYN3Psf9_axdt22Mg8oAjTReFXQCkvAkZUTDhsxT3V-X95nlMrEJXZtA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E21D240054;
        Sun,  7 Mar 2021 08:52:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: fix -EAGAIN retry with IOPOLL" failed to apply to 5.11-stable tree
To:     axboe@kernel.dk, abaci@linux.alibaba.com, stable@vger.kernel.org,
        xiaoguang.wang@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:52:13 +0100
Message-ID: <1615125133220183@kroah.com>
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

From 3e6a0d3c7571ce3ed0d25c5c32543a54a7ebcd75 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 1 Mar 2021 13:56:00 -0700
Subject: [PATCH] io_uring: fix -EAGAIN retry with IOPOLL

We no longer revert the iovec on -EIOCBQUEUED, see commit ab2125df921d,
and this started causing issues for IOPOLL on devies that run out of
request slots. Turns out what outside of needing a revert for those, we
also had a bug where we didn't properly setup retry inside the submission
path. That could cause re-import of the iovec, if any, and that could lead
to spurious results if the application had those allocated on the stack.

Catch -EAGAIN retry and make the iovec stable for IOPOLL, just like we do
for !IOPOLL retries.

Cc: <stable@vger.kernel.org> # 5.9+
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reported-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f060dcc1cc86..361befaae28f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2423,23 +2423,32 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 		return false;
 	return !io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
 }
-#endif
 
-static bool io_rw_reissue(struct io_kiocb *req)
+static bool io_rw_should_reissue(struct io_kiocb *req)
 {
-#ifdef CONFIG_BLOCK
 	umode_t mode = file_inode(req->file)->i_mode;
+	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!S_ISBLK(mode) && !S_ISREG(mode))
 		return false;
-	if ((req->flags & REQ_F_NOWAIT) || io_wq_current_is_worker())
+	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
+	    !(ctx->flags & IORING_SETUP_IOPOLL)))
 		return false;
 	/*
 	 * If ref is dying, we might be running poll reap from the exit work.
 	 * Don't attempt to reissue from that path, just let it fail with
 	 * -EAGAIN.
 	 */
-	if (percpu_ref_is_dying(&req->ctx->refs))
+	if (percpu_ref_is_dying(&ctx->refs))
+		return false;
+	return true;
+}
+#endif
+
+static bool io_rw_reissue(struct io_kiocb *req)
+{
+#ifdef CONFIG_BLOCK
+	if (!io_rw_should_reissue(req))
 		return false;
 
 	lockdep_assert_held(&req->ctx->uring_lock);
@@ -2482,6 +2491,19 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
+#ifdef CONFIG_BLOCK
+	/* Rewind iter, if we have one. iopoll path resubmits as usual */
+	if (res == -EAGAIN && io_rw_should_reissue(req)) {
+		struct io_async_rw *rw = req->async_data;
+
+		if (rw)
+			iov_iter_revert(&rw->iter,
+					req->result - iov_iter_count(&rw->iter));
+		else if (!io_resubmit_prep(req))
+			res = -EIO;
+	}
+#endif
+
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
@@ -3230,6 +3252,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_iter_do_read(req, iter);
 
 	if (ret == -EIOCBQUEUED) {
+		if (req->async_data)
+			iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		goto out_free;
 	} else if (ret == -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
@@ -3361,6 +3385,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	/* no retry on NONBLOCK nor RWF_NOWAIT */
 	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
 		goto done;
+	if (ret2 == -EIOCBQUEUED && req->async_data)
+		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
 		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)

