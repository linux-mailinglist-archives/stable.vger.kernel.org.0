Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D5A338DD3
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhCLMzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:55:00 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:47043 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230512AbhCLMyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:54:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id BFE691942B5B;
        Fri, 12 Mar 2021 07:54:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:54:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=C5Q91Z
        cqCh12xiUJ8WcJ3VTgU2JQY+Ac0ggY0fW+3iE=; b=gB5uEemAO9tw7vNFhbsfgp
        K04F1RLGZPI2ZWs4RlF7ZgTAv+fKBpOo3xPZafeqRNDTIREttOsinn0h/tsUBe81
        0oVlvo40ve17yuVOulrWAutiFma6DGY7szMo20vaD5qnvpIuqaPXSPeolaOK5Kw/
        vrt6YKHW5ZnPqEVoJk3/OsXQrZ+gZMet7AaqmboJdCKu4sR85z30xLnQ2tv9lmgo
        pSlpeD4f3Hbb4+7wEPGYAWSSUR/r1YxB3vgKPUA0//IOEZR5yFwqIFB7Ue/NAyct
        sbhbC5NjgR5BTCN8U2RI1/FC27YE8mI+TrpcprwYAiiRNRxEgTDZuP3nywGLGEAg
        ==
X-ME-Sender: <xms:nWRLYEBLJFzZZce89-vjI_hdqwZXCEunaGM_3VGtgjpR233z9t_jrw>
    <xme:nWRLYGimBf6Ml_9qVDO2jVXUw02Bss5V5n7OKWpW22X9eQVyZwuyO2NxSRa60kUqV
    T4FMaGXaNP5tQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:nWRLYHmiKct7IjS7whab9HLWKMEVGzM6AiclV722JOQKtl2yHIqyiw>
    <xmx:nWRLYKxPIuObkcfOwQJgYkT2iE8CHiFCcAWBgF1rSSIQ7AFkVp0vXw>
    <xmx:nWRLYJQ4BGB4caB80hC9EVuYKaBLLh_xzq9CNkmBJvRoT1fXcq9-cA>
    <xmx:nWRLYIIkGwrMcTn-F9_ycETbd-QuIXEVNCzN1wnXUdWchJ5TrGsNVA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6DA151080054;
        Fri, 12 Mar 2021 07:54:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/qeth: fix memory leak after failed TX Buffer allocation" failed to apply to 4.9-stable tree
To:     jwi@linux.ibm.com, davem@davemloft.net, wintera@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:54:40 +0100
Message-ID: <1615553680210245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

