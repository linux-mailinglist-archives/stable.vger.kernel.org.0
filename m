Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108BF338DDF
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhCLMze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:55:34 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:49383 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231664AbhCLMz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:55:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id ADD0A1941E4E;
        Fri, 12 Mar 2021 07:55:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HJv6rS
        Gvf7mI7vPlxuw6hM3gC34JYovAo7kgau1AI1g=; b=WgQs5fvsZWfoGa5c1V/I89
        4dT+U+rOcXbVoNAmZgWg60TE6txNHsnfUyDK7KfbtBeMXZ/D8df9BILmxH11hXg0
        eYC571Pl02o6wc11pXuA/LjUlNkCLLrk99mAz9+pZMm2q2rdJBr57HteNC1ds9ps
        RewLhWgHUrLKiIhPpmIvIfasO4SmvI2OdSWNrd2IxJjGTGfq+2etnEoxkJqU8zgW
        5c0Bu3ogKz7v9K3z4+clVHSEqvyIWgv1t5bi/NDaanY3oSNRJ6LtIeiJBlRfa1Wf
        GAK6Y7DnYe+rEpl3TP3p2xgjXBMWn1YgbJDmpem6NVchasIk/vkeuUOeKMeLz5sA
        ==
X-ME-Sender: <xms:v2RLYOn50eVurJZ3GKZpxKItOu2t2XKWo1fXJct38nrU1A0eBN4iSQ>
    <xme:v2RLYF3asDkZSTKTjxB0Pz18DMp46vV83V8RPai6HykERUCS3HatjECmJbg4Sg6US
    PmDdmLyjYFgaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:v2RLYMrfmF-8kZbxVDoXaCHWVHz5zuNfgOMOhhn6JvwgW7XulPBiew>
    <xmx:v2RLYCkxQsz4EoH83sasiQUyk_UNtDO0-iI-LWdCKo7tHXdHFTzWLA>
    <xmx:v2RLYM2IaYz57SxCOL1xrwfbwwjW_7IH5VEacB9pV2drt83PVd3Qpg>
    <xmx:v2RLYB9sMjw_d_f3f8lUB0FVs1DZoqUxoVP6Jwh26KICikBRk9DocQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 48600108005C;
        Fri, 12 Mar 2021 07:55:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/qeth: schedule TX NAPI on QAOB completion" failed to apply to 4.19-stable tree
To:     jwi@linux.ibm.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:55:22 +0100
Message-ID: <1615553722208142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

