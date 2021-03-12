Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154EA338DE4
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhCLM4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:56:01 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:48243 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230484AbhCLMze (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:55:34 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id EAD701942B74;
        Fri, 12 Mar 2021 07:55:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VYNuGl
        M47JZJW+B84FkrDRuWcsWmnJ3gyi663JWChV4=; b=q7AsoLKqGnXqreb4ZEQc55
        YW90G+LZi8EBv1jSo0k8CYvfq/G69L7Ep7SW+EqEYtrKs2o7Pq1Z0w8jBhzf6FZz
        irFEY7LtcLesuq32ZbnNkf6tn+G+c4aUJ3yZkw2sT0IadcivU3HS1z85Wvwk+Zmf
        yQxtoqQmlQ1fVljKBbM5EBtK+ackjAC3vhXglNhKLWy63Q1tmnkPihE0npuUzdGK
        n+dbxhF+av200LYiT4olo240OwxC2lgV8PmkvkEZ76d5e+pVtB4oHWV4+cW9YPz9
        /I/tJ2qthmq2KMVc8HXiZyy44b/q0XjYh4E0vaxHDU6QR1kvOr4y2DyjT28gsUVw
        ==
X-ME-Sender: <xms:xGRLYJq5Y_WFDAcEJF-g2l-B7Wc548pORNhpzJ1ro7sKqYTnvBg2Uw>
    <xme:xGRLYLp-JAJ78WUUUdaylJQbIlznvWxdby-hTmUOtjs-HdmIZYTKPvJufLawd1a8p
    9IS_a68a9KbRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepuddvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:xGRLYGNpPcqGSKpNKhtgXlqMgwlP_yuDExsrwND-eqhgkyzD5GnUuQ>
    <xmx:xGRLYE49_I4L54Dq9ZZiB6EJ5hrGmmdkMASMXGFxMVBK4w26BjxORw>
    <xmx:xGRLYI7ypeSfhoMCT_NNnOSBwNQnKbm0untpmf5KPFeyEicLxEAD_w>
    <xmx:xGRLYNgv-xaUVHp1AdPjMzjHUqMI8_qNp7LOewv8ggkoVVipmO5U-g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 990E5108005C;
        Fri, 12 Mar 2021 07:55:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/qeth: schedule TX NAPI on QAOB completion" failed to apply to 4.9-stable tree
To:     jwi@linux.ibm.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:55:24 +0100
Message-ID: <1615553724157129@kroah.com>
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

From 3e83d467a08e25b27c44c885f511624a71c84f7c Mon Sep 17 00:00:00 2001
From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Tue, 9 Mar 2021 17:52:20 +0100
Subject: [PATCH] s390/qeth: schedule TX NAPI on QAOB completion

When a QAOB notifies us that a pending TX buffer has been delivered, the
actual TX completion processing by qeth_tx_complete_pending_bufs()
is done within the context of a TX NAPI instance. We shouldn't rely on
this instance being scheduled by some other TX event, but just do it
ourselves.

qeth_qdio_handle_aob() is called from qeth_poll(), ie. our main NAPI
instance. To avoid touching the TX queue's NAPI instance
before/after it is (un-)registered, reorder the code in qeth_open()
and qeth_stop() accordingly.

Fixes: 0da9581ddb0f ("qeth: exploit asynchronous delivery of storage blocks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3763cd6d14f8..d0a56afec028 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -470,6 +470,7 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 	struct qaob *aob;
 	struct qeth_qdio_out_buffer *buffer;
 	enum iucv_tx_notify notification;
+	struct qeth_qdio_out_q *queue;
 	unsigned int i;
 
 	aob = (struct qaob *) phys_to_virt(phys_aob_addr);
@@ -512,7 +513,9 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 			buffer->is_header[i] = 0;
 		}
 
+		queue = buffer->q;
 		atomic_set(&buffer->state, QETH_QDIO_BUF_EMPTY);
+		napi_schedule(&queue->napi);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -7235,9 +7238,7 @@ int qeth_open(struct net_device *dev)
 	card->data.state = CH_STATE_UP;
 	netif_tx_start_all_queues(dev);
 
-	napi_enable(&card->napi);
 	local_bh_disable();
-	napi_schedule(&card->napi);
 	if (IS_IQD(card)) {
 		struct qeth_qdio_out_q *queue;
 		unsigned int i;
@@ -7249,8 +7250,12 @@ int qeth_open(struct net_device *dev)
 			napi_schedule(&queue->napi);
 		}
 	}
+
+	napi_enable(&card->napi);
+	napi_schedule(&card->napi);
 	/* kick-start the NAPI softirq: */
 	local_bh_enable();
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qeth_open);
@@ -7260,6 +7265,11 @@ int qeth_stop(struct net_device *dev)
 	struct qeth_card *card = dev->ml_priv;
 
 	QETH_CARD_TEXT(card, 4, "qethstop");
+
+	napi_disable(&card->napi);
+	cancel_delayed_work_sync(&card->buffer_reclaim_work);
+	qdio_stop_irq(CARD_DDEV(card));
+
 	if (IS_IQD(card)) {
 		struct qeth_qdio_out_q *queue;
 		unsigned int i;
@@ -7280,10 +7290,6 @@ int qeth_stop(struct net_device *dev)
 		netif_tx_disable(dev);
 	}
 
-	napi_disable(&card->napi);
-	cancel_delayed_work_sync(&card->buffer_reclaim_work);
-	qdio_stop_irq(CARD_DDEV(card));
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qeth_stop);

