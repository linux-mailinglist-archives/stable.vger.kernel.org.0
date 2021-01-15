Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D8E2F7709
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 11:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732001AbhAOKuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 05:50:50 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:44979 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbhAOKut (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 05:50:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3167A19C3DAA;
        Fri, 15 Jan 2021 05:49:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 05:49:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hkMqZu
        RMrP4A+CFoC1WgQTHo37S5oP3+Liiv6KvaxD4=; b=IE5xGoF+OPfK25pgwtayo0
        35cecbmlptRDNqEe47QiFIfz6UU28b766Siu+Vcg9XoaiyGVlmdI+uWuAaajIWyY
        pW/7BGNMwlffMr1RKJg2eu/vvHCjhApJjoUVB/msg53LAsoOXNoFE/RocC0GDoT8
        3aPDuNUc3xyywUfVrVl7vMP7BdV/Kx+qXI+kxy0OUG6Fj4W4+JmalhC+YLLmvG7O
        ps+fXLhvlyzNCSoH2JzoNS7vj9GT62Axa5kfedAiWSpGsUPQMUBOsoa98dKu+4rm
        ZoKfje2mio1TvCJDo7GdHd6CRc6ze5IFmElfNsGPQDafoObccSY462RwUT8dHnAQ
        ==
X-ME-Sender: <xms:RnMBYFiJxn5EL6stDTQEifQNBQYqlY0AYPEvSNzkLURKs9TzMq0Aig>
    <xme:RnMBYKCmA4-UuFt4Dkw2L0N4deWbaADHgjWPQJPoJS9-5eziyuRkcsin0IgPbj9bT
    F5fRwOGMHiJsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugddugeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:RnMBYFEKIn8N-ppm6eqMeYmXE1N_QqAL1B9Ihi48bvHo1VwyAHgcvg>
    <xmx:RnMBYKSWUrySdugUwDoLO9IIWrh417DJs1KGTuR4Z17X_ZK91DO36w>
    <xmx:RnMBYCxA9bVZTaWurMRNLowYnGg8m4e3yKR0Yt8tXS2_c-58fz4_Rw>
    <xmx:RnMBYIbAzXxgVKxOyqjtTCROAlDn6XlEeLTjYa8MUg8Elktab4EZPQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB49F1080064;
        Fri, 15 Jan 2021 05:49:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: fix files cancellation" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 11:49:40 +0100
Message-ID: <1610707780152185@kroah.com>
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

From bee749b187ac57d1faf00b2ab356ff322230fce8 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 25 Nov 2020 02:19:23 +0000
Subject: [PATCH] io_uring: fix files cancellation

io_uring_cancel_files()'s task check condition mistakenly got flipped.

1. There can't be a request in the inflight list without
IO_WQ_WORK_FILES, kill this check to keep the whole condition simpler.
2. Also, don't call the function for files==NULL to not do such a check,
all that staff is already handled well by its counter part,
__io_uring_cancel_task_requests().

With that just flip the task check.

Also, it iowq-cancels all request of current task there, don't forget to
set right ->files into struct io_task_cancel.

Fixes: c1973b38bf639 ("io_uring: cancel only requests of current task")
Reported-by: syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e66888d45778..f47de27e5125 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8688,15 +8688,14 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_task_cancel cancel = { .task = task, .files = NULL, };
+		struct io_task_cancel cancel = { .task = task, .files = files };
 		struct io_kiocb *req;
 		DEFINE_WAIT(wait);
 		bool found = false;
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->task == task &&
-			    (req->work.flags & IO_WQ_WORK_FILES) &&
+			if (req->task != task ||
 			    req->work.identity->files != files)
 				continue;
 			found = true;
@@ -8768,10 +8767,11 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
-	io_uring_cancel_files(ctx, task, files);
 
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
+	else
+		io_uring_cancel_files(ctx, task, files);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);

