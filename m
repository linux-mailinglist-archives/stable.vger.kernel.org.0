Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D74377DEF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhEJITe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:19:34 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:41093 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJITd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:19:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 391F11940BCB;
        Mon, 10 May 2021 04:18:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 May 2021 04:18:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lKd3W6
        YmLbbNljcdkZjZaMqxiRB7JPNc2NImKbANiSc=; b=sho5o23wvtdV3ClKzjfWL3
        4OlV1TfNHVBaNqZfbphfqxRvTKMCYQL846c05/QSJcq6X3Dimzl1HMjzg7WmotKN
        dHoQIYyI3MhQPReycR8FRVoEmo5zIhG2E5aAweQPy0JyY4gOtAtypIkbF9Z+7SCL
        dz8+qZDGcTelnCRvawmjALgXLh8hnYeCb5K8dcEC/T1mh3YKCzSlPCYEAHbJ1Y4u
        SdrZkfb16LS0mTn47yMOLHtIRaGlkutzG8VLyQmmpHaAzGs4pSg4J5epK4azdwpT
        +JkbN/sPKSlOcS5gDoX9V0RntbXJHS/0Qme/Asu2kbIjFFPO8XQtPZCkUuNvM+ng
        ==
X-ME-Sender: <xms:VOyYYPX0Irv3q1k2t8xKk-2afiLFNJOQ7shmP5c9JZbR1WpwW-B3aQ>
    <xme:VOyYYHmGyKUGm_J2g_YD25OSkqhU8W4oHvjXLAoYPXjVW2gy_4IkMFPZxirvn_t0V
    YteHVOmOo5lxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VOyYYLZPHpxbzXgVo1OJptHzkJlqZcyKJSD5dgd9zBFlnvXXs2dOiA>
    <xmx:VOyYYKXgMEnquLGwaJfp0LhafYAnAL6EoDfiQIEciLiLkO-IwcfSjQ>
    <xmx:VOyYYJmoA36pglHLXVGflVeSlEZqtsSc-oro4RVsyrpHSdc4LAuxxg>
    <xmx:VOyYYIttBatVI72dsxq6qxQVELNSlSllZTtrfoMMr2PvD_aKcdQ68A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:18:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: remove extra sqpoll submission halting" failed to apply to 5.11-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:18:18 +0200
Message-ID: <1620634698183181@kroah.com>
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

From 3b763ba1c77da5806e4fdc5684285814fe970c98 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 18 Apr 2021 14:52:08 +0100
Subject: [PATCH] io_uring: remove extra sqpoll submission halting

SQPOLL task won't submit requests for a context that is currently dying,
so no need to remove ctx from sqd_list prior the main loop of
io_ring_exit_work(). Kill it, will be removed by io_sq_thread_finish()
and only brings confusion and lockups.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f220c2b786ba0f9499bebc9f3cd9714d29efb6a5.1618752958.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e491b815df8c..4fc54cd40470 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6750,6 +6750,10 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, &nr_events, 0);
 
+		/*
+		 * Don't submit if refs are dying, good for io_uring_register(),
+		 * but also it is relied upon by io_ring_exit_work()
+		 */
 		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
@@ -8540,14 +8544,6 @@ static void io_ring_exit_work(struct work_struct *work)
 	struct io_tctx_node *node;
 	int ret;
 
-	/* prevent SQPOLL from submitting new requests */
-	if (ctx->sq_data) {
-		io_sq_thread_park(ctx->sq_data);
-		list_del_init(&ctx->sqd_list);
-		io_sqd_update_thread_idle(ctx->sq_data);
-		io_sq_thread_unpark(ctx->sq_data);
-	}
-
 	/*
 	 * If we're doing polled IO and end up having requests being
 	 * submitted async (out-of-line), then completions can come in while

