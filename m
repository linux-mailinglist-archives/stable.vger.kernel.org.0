Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61198338DD4
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhCLMzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:55:00 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:53631 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230388AbhCLMyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:54:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2DBDB1940B4E;
        Fri, 12 Mar 2021 07:54:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Q/jMqU
        F3HBNy4ryVWdyh61vzYRO8KPBMszVHzWnd5j0=; b=Qnj3ZbcWXILbyEXqLHlEze
        dlX5M4OODZfP95cSj6yhiH/a/FR7LoEjxvgjcC12ZuPTkNKglzEx3F8+1zWQC2LP
        UfgoIJKm0TQoUIipKoGBwtcnzoruj+rOththzV/VwkCnk6t8niAPcLyA0iVsriVZ
        81KsqFZe0zLjGPuZpsjKvt1BPchZeZWfAYo1Lx2SDc+Tduha1N+3KqJ4AY1R6WqA
        k0iY9h09tbtHAMjlhZMNOjNQmGC+mciCFfs4WuHsYpTrf2JWZ3FuUXGbfHKXmc+W
        hqLgFeM/CR6HIcllvETDzjgp8TFdonlIUktBhR3Yenn/yLU0TV3xDGK0A/f0nEwg
        ==
X-ME-Sender: <xms:nGRLYES7t-Tl4kRuMS7uzcg9bbrlb5XN5J5CcMIQtAVM5nxsLwgxdg>
    <xme:nGRLYBzwH1cH4MmkKCKcjMKxiWcryuB4cihc3hbgYtSahVwIBMkio4lypsvz3aEIf
    uZvhsQn9K4I-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:nGRLYB28gmMyoHgej0DeGXZtgBTKmE1-aRVi4t_q-8PJA2S7hReKpQ>
    <xmx:nGRLYICSS6lV3RRXLrICFWn9x4v25ec34P5adIelDGOGk_i5MB54ug>
    <xmx:nGRLYNgkEEWMuuuZdAZ-lU39Idy77Mq2pUZ4BoUgTBqy55_MDJGcgg>
    <xmx:nGRLYNZtkoroA-nfoyyWgA8dvg4cVeOXQVob7_P0beEcztaP1R6cEw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C99F924005D;
        Fri, 12 Mar 2021 07:54:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/qeth: fix memory leak after failed TX Buffer allocation" failed to apply to 4.14-stable tree
To:     jwi@linux.ibm.com, davem@davemloft.net, wintera@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:54:39 +0100
Message-ID: <1615553679236206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From e7a36d27f6b9f389e41d8189a8a08919c6835732 Mon Sep 17 00:00:00 2001
From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Tue, 9 Mar 2021 17:52:18 +0100
Subject: [PATCH] s390/qeth: fix memory leak after failed TX Buffer allocation

When qeth_alloc_qdio_queues() fails to allocate one of the buffers that
back an Output Queue, the 'out_freeoutqbufs' path will free all
previously allocated buffers for this queue. But it misses to free the
half-finished queue struct itself.

Move the buffer allocation into qeth_alloc_output_queue(), and deal with
such errors internally.

Fixes: 0da9581ddb0f ("qeth: exploit asynchronous delivery of storage blocks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index b71b8902d1c4..f7bc0ca6909b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2634,15 +2634,28 @@ static void qeth_free_output_queue(struct qeth_qdio_out_q *q)
 static struct qeth_qdio_out_q *qeth_alloc_output_queue(void)
 {
 	struct qeth_qdio_out_q *q = kzalloc(sizeof(*q), GFP_KERNEL);
+	unsigned int i;
 
 	if (!q)
 		return NULL;
 
-	if (qdio_alloc_buffers(q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q)) {
-		kfree(q);
-		return NULL;
+	if (qdio_alloc_buffers(q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q))
+		goto err_qdio_bufs;
+
+	for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; i++) {
+		if (qeth_init_qdio_out_buf(q, i))
+			goto err_out_bufs;
 	}
+
 	return q;
+
+err_out_bufs:
+	while (i > 0)
+		kmem_cache_free(qeth_qdio_outbuf_cache, q->bufs[--i]);
+	qdio_free_buffers(q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q);
+err_qdio_bufs:
+	kfree(q);
+	return NULL;
 }
 
 static void qeth_tx_completion_timer(struct timer_list *timer)
@@ -2655,7 +2668,7 @@ static void qeth_tx_completion_timer(struct timer_list *timer)
 
 static int qeth_alloc_qdio_queues(struct qeth_card *card)
 {
-	int i, j;
+	unsigned int i;
 
 	QETH_CARD_TEXT(card, 2, "allcqdbf");
 
@@ -2689,13 +2702,6 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
 		queue->max_coalesced_frames = QETH_TX_MAX_COALESCED_FRAMES;
 		queue->priority = QETH_QIB_PQUE_PRIO_DEFAULT;
-
-		/* give outbound qeth_qdio_buffers their qdio_buffers */
-		for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
-			WARN_ON(queue->bufs[j]);
-			if (qeth_init_qdio_out_buf(queue, j))
-				goto out_freeoutqbufs;
-		}
 	}
 
 	/* completion */
@@ -2704,13 +2710,6 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 
 	return 0;
 
-out_freeoutqbufs:
-	while (j > 0) {
-		--j;
-		kmem_cache_free(qeth_qdio_outbuf_cache,
-				card->qdio.out_qs[i]->bufs[j]);
-		card->qdio.out_qs[i]->bufs[j] = NULL;
-	}
 out_freeoutq:
 	while (i > 0) {
 		qeth_free_output_queue(card->qdio.out_qs[--i]);

