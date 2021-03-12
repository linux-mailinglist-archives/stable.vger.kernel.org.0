Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D195338DDD
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhCLMzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:55:31 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:59101 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231474AbhCLMzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:55:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CD5781941E4E;
        Fri, 12 Mar 2021 07:55:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:55:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/jVw1D
        Y4U2jaZWKzu9H1++ayumvDTgccTiuaTmyJCNw=; b=H7KuPApPSzfTEI+otg2mqM
        8911BOMctT+S2+16jduEs4LVae1FIDk8lvjMWfKFA/LJ0vo1LJ3lMiUe4j+xw2In
        ScdxpQYgJCJ+WFbFOHRCnZRdlbffgD3TDVNqxXZdx17wpSQdWB2Vtx0r/3JPZatZ
        h2rq+d9pQ3YSTX7N2ZaJysIUuh9lbVHgY9mOISHjwOgRtL2hyKzzN7fzGRUTE2/6
        t6N4jvSZXakVheGFqoUkLg5CQMH1vcwAW+wFHEiOJWPrtedtSnFw1tDQjycuuWC9
        OCwiaE7BFwxFAu0rt/kMQo7C+cxLW+0/vhm96MVVtbOwD4ks006Rx/0qjtA++0cQ
        ==
X-ME-Sender: <xms:rGRLYOoPe_57PT73TGgzlRoUMK-aqTyfa0Gh6CtzCASD2sX98FpRwg>
    <xme:rGRLYMoeYMqLIIgpq5cL_2Jbn80v-LFrFIv7F4olXRP6jpQMTLRKg3gJ1o6B4D3HY
    J8L9PYgK0vsGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:rGRLYDPwLgybhrF8cmUj_VZJwVRoRFfUoGl1cpjm7sM18FWzHMHu4w>
    <xmx:rGRLYN6DsUlT1ZjgwBQ0-0wPgp27X45kqOzh8g9twbwQIhCS4-a1bA>
    <xmx:rGRLYN5d-i3IfVD4Ku-wOjtX-13XIdw3gGyHLZXVn1OmfeYjt77WBg>
    <xmx:rGRLYKjA6EVJJInHRY-bKzGTdb_UlTACUT0NOp3735ccxUJ332Zrbg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7B2061080063;
        Fri, 12 Mar 2021 07:55:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/qeth: improve completion of pending TX buffers" failed to apply to 4.9-stable tree
To:     jwi@linux.ibm.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:55:00 +0100
Message-ID: <1615553700108243@kroah.com>
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

From c20383ad1656b0f6354dd50e4acd894f9d94090d Mon Sep 17 00:00:00 2001
From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Tue, 9 Mar 2021 17:52:19 +0100
Subject: [PATCH] s390/qeth: improve completion of pending TX buffers

The current design attaches a pending TX buffer to a custom
single-linked list, which is anchored at the buffer's slot on the
TX ring. The buffer is then checked for final completion whenever
this slot is processed during a subsequent TX NAPI poll cycle.

But if there's insufficient traffic on the ring, we might never make
enough progress to get back to this ring slot and discover the pending
buffer's final TX completion. In particular if this missing TX
completion blocks the application from sending further traffic.

So convert the custom single-linked list code to a per-queue list_head,
and scan this list on every TX NAPI cycle.

Fixes: 0da9581ddb0f ("qeth: exploit asynchronous delivery of storage blocks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index a1da83b0b0ef..91acff493612 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -436,7 +436,7 @@ struct qeth_qdio_out_buffer {
 	int is_header[QDIO_MAX_ELEMENTS_PER_BUFFER];
 
 	struct qeth_qdio_out_q *q;
-	struct qeth_qdio_out_buffer *next_pending;
+	struct list_head list_entry;
 };
 
 struct qeth_card;
@@ -500,6 +500,7 @@ struct qeth_qdio_out_q {
 	struct qdio_buffer *qdio_bufs[QDIO_MAX_BUFFERS_PER_Q];
 	struct qeth_qdio_out_buffer *bufs[QDIO_MAX_BUFFERS_PER_Q];
 	struct qdio_outbuf_state *bufstates; /* convenience pointer */
+	struct list_head pending_bufs;
 	struct qeth_out_q_stats stats;
 	spinlock_t lock;
 	unsigned int priority;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f7bc0ca6909b..3763cd6d14f8 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -73,8 +73,6 @@ static void qeth_free_qdio_queues(struct qeth_card *card);
 static void qeth_notify_skbs(struct qeth_qdio_out_q *queue,
 		struct qeth_qdio_out_buffer *buf,
 		enum iucv_tx_notify notification);
-static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
-				 int budget);
 
 static void qeth_close_dev_handler(struct work_struct *work)
 {
@@ -465,41 +463,6 @@ static enum iucv_tx_notify qeth_compute_cq_notification(int sbalf15,
 	return n;
 }
 
-static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
-					 int forced_cleanup)
-{
-	if (q->card->options.cq != QETH_CQ_ENABLED)
-		return;
-
-	if (q->bufs[bidx]->next_pending != NULL) {
-		struct qeth_qdio_out_buffer *head = q->bufs[bidx];
-		struct qeth_qdio_out_buffer *c = q->bufs[bidx]->next_pending;
-
-		while (c) {
-			if (forced_cleanup ||
-			    atomic_read(&c->state) == QETH_QDIO_BUF_EMPTY) {
-				struct qeth_qdio_out_buffer *f = c;
-
-				QETH_CARD_TEXT(f->q->card, 5, "fp");
-				QETH_CARD_TEXT_(f->q->card, 5, "%lx", (long) f);
-				/* release here to avoid interleaving between
-				   outbound tasklet and inbound tasklet
-				   regarding notifications and lifecycle */
-				qeth_tx_complete_buf(c, forced_cleanup, 0);
-
-				c = f->next_pending;
-				WARN_ON_ONCE(head->next_pending != f);
-				head->next_pending = c;
-				kmem_cache_free(qeth_qdio_outbuf_cache, f);
-			} else {
-				head = c;
-				c = c->next_pending;
-			}
-
-		}
-	}
-}
-
 static void qeth_qdio_handle_aob(struct qeth_card *card,
 				 unsigned long phys_aob_addr)
 {
@@ -537,7 +500,7 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 		qeth_notify_skbs(buffer->q, buffer, notification);
 
 		/* Free dangling allocations. The attached skbs are handled by
-		 * qeth_cleanup_handled_pending().
+		 * qeth_tx_complete_pending_bufs().
 		 */
 		for (i = 0;
 		     i < aob->sb_count && i < QETH_MAX_BUFFER_ELEMENTS(card);
@@ -1488,14 +1451,35 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 	atomic_set(&buf->state, QETH_QDIO_BUF_EMPTY);
 }
 
+static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
+					  struct qeth_qdio_out_q *queue,
+					  bool drain)
+{
+	struct qeth_qdio_out_buffer *buf, *tmp;
+
+	list_for_each_entry_safe(buf, tmp, &queue->pending_bufs, list_entry) {
+		if (drain || atomic_read(&buf->state) == QETH_QDIO_BUF_EMPTY) {
+			QETH_CARD_TEXT(card, 5, "fp");
+			QETH_CARD_TEXT_(card, 5, "%lx", (long) buf);
+
+			qeth_tx_complete_buf(buf, drain, 0);
+
+			list_del(&buf->list_entry);
+			kmem_cache_free(qeth_qdio_outbuf_cache, buf);
+		}
+	}
+}
+
 static void qeth_drain_output_queue(struct qeth_qdio_out_q *q, bool free)
 {
 	int j;
 
+	qeth_tx_complete_pending_bufs(q->card, q, true);
+
 	for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
 		if (!q->bufs[j])
 			continue;
-		qeth_cleanup_handled_pending(q, j, 1);
+
 		qeth_clear_output_buffer(q, q->bufs[j], true, 0);
 		if (free) {
 			kmem_cache_free(qeth_qdio_outbuf_cache, q->bufs[j]);
@@ -2615,7 +2599,6 @@ static int qeth_init_qdio_out_buf(struct qeth_qdio_out_q *q, int bidx)
 	skb_queue_head_init(&newbuf->skb_list);
 	lockdep_set_class(&newbuf->skb_list.lock, &qdio_out_skb_queue_key);
 	newbuf->q = q;
-	newbuf->next_pending = q->bufs[bidx];
 	atomic_set(&newbuf->state, QETH_QDIO_BUF_EMPTY);
 	q->bufs[bidx] = newbuf;
 	return 0;
@@ -2697,6 +2680,7 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		card->qdio.out_qs[i] = queue;
 		queue->card = card;
 		queue->queue_no = i;
+		INIT_LIST_HEAD(&queue->pending_bufs);
 		spin_lock_init(&queue->lock);
 		timer_setup(&queue->timer, qeth_tx_completion_timer, 0);
 		queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
@@ -6106,6 +6090,8 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 					qeth_schedule_recovery(card);
 				}
 
+				list_add(&buffer->list_entry,
+					 &queue->pending_bufs);
 				/* Skip clearing the buffer: */
 				return;
 			case QETH_QDIO_BUF_QAOB_OK:
@@ -6161,6 +6147,8 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 		unsigned int bytes = 0;
 		int completed;
 
+		qeth_tx_complete_pending_bufs(card, queue, false);
+
 		if (qeth_out_queue_is_empty(queue)) {
 			napi_complete(napi);
 			return 0;
@@ -6193,7 +6181,6 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 
 			qeth_handle_send_error(card, buffer, error);
 			qeth_iqd_tx_complete(queue, bidx, error, budget);
-			qeth_cleanup_handled_pending(queue, bidx, false);
 		}
 
 		netdev_tx_completed_queue(txq, packets, bytes);

