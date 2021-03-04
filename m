Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA0A32D57C
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhCDOjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:39:16 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:44871 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232113AbhCDOi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:38:57 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 61CF2157E;
        Thu,  4 Mar 2021 09:37:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 04 Mar 2021 09:37:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MG88y0
        txRqSWuuVVZvYbr6rgTUWPM1RE8LyD++TV0KM=; b=WGKkZxL32e0xk5roZD58so
        W1rcA9cNymCkSWnzAONQtYdQezkgjASU5xHq5C2G1UpnvE7cLsZ0g6COFt+1x3C+
        Hl4kCjBTOScbr2+WxBgwpQlmYGQ5onuDxmlipwmmQL7RmDU5Dk9UW4zKH3Mz5ZzY
        i1H8S1SfZnYqIVCegajvR1IS6xgSMGyz8/R5RHIHSa3ijobTcJPtxmAItN3mgaGy
        pWIN/R/fUN783CiEyT+2WmV63jCo2juYKqhWHqihzfOEEdvjAv+wIwyinsVckVcR
        UJlpDvZLvlG0Ipx1UQFykw7is4IDMXctqVNBZrNBw+Vkk0zYWkvB0XFWd2kHTWAA
        ==
X-ME-Sender: <xms:vvBAYE7WLadjhr07Xw5F5bmsZ0wJim6_pVAtP-EbXiFEnRzJo4vi2A>
    <xme:vvBAYF5v7NhtX_EpIt-FvotXLY1tBwDhUAG9_7meVmH4XQCw9WqShml_mUdUEA2JM
    nIGUNPOV4CE5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:vvBAYDc3wu611bcweSlbb5cYluTpFLIV2dDkkfz9sQKRpkJsDV_9ng>
    <xmx:vvBAYJJY5AOosom0doUARr6wcwUX87gGu2P4wXrK3NJWUtCfNTL40Q>
    <xmx:vvBAYIKmqE7xSLvTulHC6n1GPqWgdBM-KZZ1wPtR14iQogu6H1sx4g>
    <xmx:v_BAYCgk4-n_27fCLA2LTKrrGB2abNegNsI01bZTzh4Cx_XMHPhxNpoHfFM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB81524005C;
        Thu,  4 Mar 2021 09:37:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] RDMA/rxe: Fix FIXME in rxe_udp_encap_recv()" failed to apply to 5.4-stable tree
To:     rpearsonhpe@gmail.com, jgg@nvidia.com, rpearson@hpe.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 15:37:40 +0100
Message-ID: <161486866019281@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 899aba891cab1555c9ca16a558769efb177baf44 Mon Sep 17 00:00:00 2001
From: Bob Pearson <rpearsonhpe@gmail.com>
Date: Thu, 28 Jan 2021 17:33:19 -0600
Subject: [PATCH] RDMA/rxe: Fix FIXME in rxe_udp_encap_recv()

rxe_udp_encap_recv() drops the reference to rxe->ib_dev taken by
rxe_get_dev_from_net() which should be held until each received skb is
freed. This patch moves the calls to ib_device_put() to each place a
received skb is freed. It also takes references to the ib_device for each
cloned skb created to process received multicast packets.

Fixes: 4c173f596b3f ("RDMA/rxe: Use ib_device_get_by_netdev() instead of open coding")
Link: https://lore.kernel.org/r/20210128233318.2591-1-rpearson@hpe.com
Signed-off-by: Bob Pearson <rpearson@hpe.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 0a1e6393250b..a8ac791a1bb9 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -515,6 +515,7 @@ static void rxe_drain_resp_pkts(struct rxe_qp *qp, bool notify)
 	while ((skb = skb_dequeue(&qp->resp_pkts))) {
 		rxe_drop_ref(qp);
 		kfree_skb(skb);
+		ib_device_put(qp->ibqp.device);
 	}
 
 	while ((wqe = queue_head(qp->sq.queue))) {
@@ -527,6 +528,17 @@ static void rxe_drain_resp_pkts(struct rxe_qp *qp, bool notify)
 	}
 }
 
+static void free_pkt(struct rxe_pkt_info *pkt)
+{
+	struct sk_buff *skb = PKT_TO_SKB(pkt);
+	struct rxe_qp *qp = pkt->qp;
+	struct ib_device *dev = qp->ibqp.device;
+
+	kfree_skb(skb);
+	rxe_drop_ref(qp);
+	ib_device_put(dev);
+}
+
 int rxe_completer(void *arg)
 {
 	struct rxe_qp *qp = (struct rxe_qp *)arg;
@@ -624,11 +636,8 @@ int rxe_completer(void *arg)
 			break;
 
 		case COMPST_DONE:
-			if (pkt) {
-				rxe_drop_ref(pkt->qp);
-				kfree_skb(skb);
-				skb = NULL;
-			}
+			if (pkt)
+				free_pkt(pkt);
 			goto done;
 
 		case COMPST_EXIT:
@@ -671,12 +680,8 @@ int rxe_completer(void *arg)
 			 */
 			if (qp->comp.started_retry &&
 			    !qp->comp.timeout_retry) {
-				if (pkt) {
-					rxe_drop_ref(pkt->qp);
-					kfree_skb(skb);
-					skb = NULL;
-				}
-
+				if (pkt)
+					free_pkt(pkt);
 				goto done;
 			}
 
@@ -699,13 +704,8 @@ int rxe_completer(void *arg)
 					qp->comp.started_retry = 1;
 					rxe_run_task(&qp->req.task, 0);
 				}
-
-				if (pkt) {
-					rxe_drop_ref(pkt->qp);
-					kfree_skb(skb);
-					skb = NULL;
-				}
-
+				if (pkt)
+					free_pkt(pkt);
 				goto done;
 
 			} else {
@@ -726,9 +726,7 @@ int rxe_completer(void *arg)
 				mod_timer(&qp->rnr_nak_timer,
 					  jiffies + rnrnak_jiffies(aeth_syn(pkt)
 						& ~AETH_TYPE_MASK));
-				rxe_drop_ref(pkt->qp);
-				kfree_skb(skb);
-				skb = NULL;
+				free_pkt(pkt);
 				goto exit;
 			} else {
 				rxe_counter_inc(rxe,
@@ -742,13 +740,8 @@ int rxe_completer(void *arg)
 			WARN_ON_ONCE(wqe->status == IB_WC_SUCCESS);
 			do_complete(qp, wqe);
 			rxe_qp_error(qp);
-
-			if (pkt) {
-				rxe_drop_ref(pkt->qp);
-				kfree_skb(skb);
-				skb = NULL;
-			}
-
+			if (pkt)
+				free_pkt(pkt);
 			goto exit;
 		}
 	}
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 0d4125b867b7..36d56163afac 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -152,10 +152,14 @@ static struct dst_entry *rxe_find_route(struct net_device *ndev,
 static int rxe_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 {
 	struct udphdr *udph;
+	struct rxe_dev *rxe;
 	struct net_device *ndev = skb->dev;
-	struct rxe_dev *rxe = rxe_get_dev_from_net(ndev);
 	struct rxe_pkt_info *pkt = SKB_TO_PKT(skb);
 
+	/* takes a reference on rxe->ib_dev
+	 * drop when skb is freed
+	 */
+	rxe = rxe_get_dev_from_net(ndev);
 	if (!rxe)
 		goto drop;
 
@@ -174,12 +178,6 @@ static int rxe_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 
 	rxe_rcv(skb);
 
-	/*
-	 * FIXME: this is in the wrong place, it needs to be done when pkt is
-	 * destroyed
-	 */
-	ib_device_put(&rxe->ib_dev);
-
 	return 0;
 drop:
 	kfree_skb(skb);
diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 2bbcea61b780..8a48a33d587b 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -274,6 +274,10 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
 		 */
 		if (mce->qp_list.next != &mcg->qp_list) {
 			per_qp_skb = skb_clone(skb, GFP_ATOMIC);
+			if (WARN_ON(!ib_device_try_get(&rxe->ib_dev))) {
+				kfree_skb(per_qp_skb);
+				continue;
+			}
 		} else {
 			per_qp_skb = skb;
 			/* show we have consumed the skb */
@@ -296,6 +300,7 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
 err1:
 	/* free skb if not consumed */
 	kfree_skb(skb);
+	ib_device_put(&rxe->ib_dev);
 }
 
 /**
@@ -405,4 +410,5 @@ void rxe_rcv(struct sk_buff *skb)
 		rxe_drop_ref(pkt->qp);
 
 	kfree_skb(skb);
+	ib_device_put(&rxe->ib_dev);
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 5a098083a9d2..5fd26786d79b 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -99,6 +99,7 @@ static inline enum resp_states get_req(struct rxe_qp *qp,
 		while ((skb = skb_dequeue(&qp->req_pkts))) {
 			rxe_drop_ref(qp);
 			kfree_skb(skb);
+			ib_device_put(qp->ibqp.device);
 		}
 
 		/* go drain recv wr queue */
@@ -1012,6 +1013,7 @@ static enum resp_states cleanup(struct rxe_qp *qp,
 		skb = skb_dequeue(&qp->req_pkts);
 		rxe_drop_ref(qp);
 		kfree_skb(skb);
+		ib_device_put(qp->ibqp.device);
 	}
 
 	if (qp->resp.mr) {
@@ -1176,6 +1178,7 @@ static void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)
 	while ((skb = skb_dequeue(&qp->req_pkts))) {
 		rxe_drop_ref(qp);
 		kfree_skb(skb);
+		ib_device_put(qp->ibqp.device);
 	}
 
 	if (notify)

