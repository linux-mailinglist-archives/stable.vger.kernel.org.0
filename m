Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DF1257690
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgHaJfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 05:35:38 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53209 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbgHaJfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 05:35:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 7C16E7F2;
        Mon, 31 Aug 2020 05:35:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 05:35:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=l3Z27O
        sIqT3NMSHJ/p77mLDk2DPVQoUeom6d3X6R4c4=; b=M3KchE89AVmbhf8+cSNPzN
        AphfLyrvQl/tSyTcXvJUZF7c4YRZj9WNLQmu3QGCdKGnt/s0o5Bvp/Wt8nznziHW
        TYcRbPefNTCvRNY7pu93a5WaH+eMS6FlHlAp0TRn8HNgLQUQDSPfKuMRH0kpirB+
        zPVt2ykBudzVL+KM23q5gMqBXQrIMjjIw2qeGUE000q8iJeGIQaV8GStIa5x0HVi
        GX45oISq+qt8yuwpt78am93qCfLZMMS/RtMh2UXNezEtUkYiqgzBUuTuI46YLVDS
        tNpl81FxTU0rPDY1iSSkRuwvCZ+yDrMgyUof1Q4rKN7o/15AhJp1ari4ZTcfA/fg
        ==
X-ME-Sender: <xms:Z8RMX4Y5EDSdkiwd49pzkk67MTPKfWm1zy1QtRupY_bnhs98g-Kyzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeuveffhfffheefteevffdvveetudegveeggeeike
    ffvdegledttdeileekjefgnecuffhomhgrihhnpehlkhhmlhdrohhrghenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Z8RMXzb-FEIaYhUdeTJ5jaIQRvjUSkIzkAaDxsC5VXnRz2ZyKGOBwg>
    <xmx:Z8RMXy8ZfSSPC0eWEo3iIN4YZy9sojX4B3l3z2jrqT8S_vpy9J_ptA>
    <xmx:Z8RMXypfGywzOFHm-pSNLBOs6yWnMvHvkHUowPRmLE4KE_ctf6IoJQ>
    <xmx:aMRMXyUUxRbBtZySfR90cW2btx-qBoa8UCOmcmc5UNO1SJcJtlyF4y7ydbc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BE3CF30600A3;
        Mon, 31 Aug 2020 05:35:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] blk-mq: order adding requests to hctx->dispatch and checking" failed to apply to 4.14-stable tree
To:     ming.lei@redhat.com, axboe@kernel.dk, bvanassche@acm.org,
        djeffery@redhat.com, hch@lst.de, rong.a.chen@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 11:35:43 +0200
Message-ID: <1598866543231251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d7d8535f377e9ba87edbf7fbbd634ac942f3f54f Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Mon, 17 Aug 2020 18:01:15 +0800
Subject: [PATCH] blk-mq: order adding requests to hctx->dispatch and checking
 SCHED_RESTART

SCHED_RESTART code path is relied to re-run queue for dispatch requests
in hctx->dispatch. Meantime the SCHED_RSTART flag is checked when adding
requests to hctx->dispatch.

memory barriers have to be used for ordering the following two pair of OPs:

1) adding requests to hctx->dispatch and checking SCHED_RESTART in
blk_mq_dispatch_rq_list()

2) clearing SCHED_RESTART and checking if there is request in hctx->dispatch
in blk_mq_sched_restart().

Without the added memory barrier, either:

1) blk_mq_sched_restart() may miss requests added to hctx->dispatch meantime
blk_mq_dispatch_rq_list() observes SCHED_RESTART, and not run queue in
dispatch side

or

2) blk_mq_dispatch_rq_list still sees SCHED_RESTART, and not run queue
in dispatch side, meantime checking if there is request in
hctx->dispatch from blk_mq_sched_restart() is missed.

IO hang in ltp/fs_fill test is reported by kernel test robot:

	https://lkml.org/lkml/2020/7/26/77

Turns out it is caused by the above out-of-order OPs. And the IO hang
can't be observed any more after applying this patch.

Fixes: bd166ef183c2 ("blk-mq-sched: add framework for MQ capable IO schedulers")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Jeffery <djeffery@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index a19cdf159b75..d2790e5b06d1 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -78,6 +78,15 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
 		return;
 	clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
 
+	/*
+	 * Order clearing SCHED_RESTART and list_empty_careful(&hctx->dispatch)
+	 * in blk_mq_run_hw_queue(). Its pair is the barrier in
+	 * blk_mq_dispatch_rq_list(). So dispatch code won't see SCHED_RESTART,
+	 * meantime new request added to hctx->dispatch is missed to check in
+	 * blk_mq_run_hw_queue().
+	 */
+	smp_mb();
+
 	blk_mq_run_hw_queue(hctx, true);
 }
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 35f8d0692442..a80f4986e594 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1437,6 +1437,15 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 		list_splice_tail_init(list, &hctx->dispatch);
 		spin_unlock(&hctx->lock);
 
+		/*
+		 * Order adding requests to hctx->dispatch and checking
+		 * SCHED_RESTART flag. The pair of this smp_mb() is the one
+		 * in blk_mq_sched_restart(). Avoid restart code path to
+		 * miss the new added requests to hctx->dispatch, meantime
+		 * SCHED_RESTART is observed here.
+		 */
+		smp_mb();
+
 		/*
 		 * If SCHED_RESTART was set by the caller of this function and
 		 * it is no longer set that means that it was cleared by another

