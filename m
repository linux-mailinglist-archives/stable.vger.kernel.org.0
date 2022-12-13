Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429AA64BEE1
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 22:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiLMV4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 16:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbiLMVzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 16:55:33 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2EC22B24
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 13:53:48 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id z10-20020a170902ccca00b001898329db72so834458ple.21
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 13:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0GXi/g+ggbU0FYuYKX9BfADcafhhz71xEbH0E1NjCIY=;
        b=SDXqbhIZCEimdIkMXJko5ySehFx0TiwdhvrlDbU115o5iPNZpSvjpV5nvH4QD8RdTe
         Yv6BgZPvPK52gnzRj485u/dBDW9iTo5mWB0av94qZtNaRKw4l4bOcgENa/uv7gwV7CQV
         G8ZXCX97AuyItKhu6n5BoY3YUkRNW099ri8IxTzCbu8+aaI3RiUV2keFZwiqu2NCYI0E
         J1ePgKbhx6S00XWJbQY+2tv3WLgckg6ZN3lmVVeasxLE57Ao37OvSh1ZfSL5gQJo6UNC
         ebVlr4DYSz0cC1ck2iIl/BLT82nIdQibbeUFxr8BQBQH5m3rhZD2RIGAwukwQVUcTo3e
         c8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0GXi/g+ggbU0FYuYKX9BfADcafhhz71xEbH0E1NjCIY=;
        b=hghEgg0faqWspXmNgP4RHbv0dqlSXa8ENV8CtOWAA7T0F5fD6/yQ+R0qiMstdyi2W4
         44g1Oo7lZsTRqhfv9nIglU2S4OZY5QNlA4aZoqulftnA9UldgG5AdJq0c+c1WINOvILL
         d+mhGRDnhlMyCrJsdKh8RNL0fSbMHgs2TKR1Em+L+Q2E3U6P+KEPho2pBW6G0qXvcLNO
         DAUlpp9iuUIvcayVVERVh7zfbrf3rvohiUYSnG5PQIO++iHanJ9TuFtRY+PbcmDME5+i
         MCgL8fC3JmoY5n6uZlUV5MpeMPIfltAzlhcw5x2/lYdKiyXTJKnzBsKBHM/id9zOHqdv
         PEQA==
X-Gm-Message-State: AFqh2kpu+sRj6msJqSOoZoeB26ArJiGLXv3z4WL0NFhj8aUbMpka0OQC
        yr5L/g2Z5OmyRIpfcklexyH07XPhDpLlJVG+t37svPrB3833KU8kwQddYBztwjDbIoQvNAbVPjf
        1fVetR3CqTxLDFed6BfCzoS7iuJtjfw1rdYt1UsmcXmN1q5gQUnp9Uho7/o9AYKP2BK4hb6D56a
        E4bdvik6I=
X-Google-Smtp-Source: AMrXdXtSzruc5C29qHczfjS5HHvqFIGvZwFCSawZD2+Iaop/Pn3F9lc2kumdG9+xYyAKlS9JpghodyB+2IhqMF2NWpilIw==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:90a:b30e:b0:219:e3de:53e3 with
 SMTP id d14-20020a17090ab30e00b00219e3de53e3mr26077pjr.87.1670968428231; Tue,
 13 Dec 2022 13:53:48 -0800 (PST)
Date:   Tue, 13 Dec 2022 21:53:39 +0000
In-Reply-To: <20221213215339.3697182-1-meenashanmugam@google.com>
Mime-Version: 1.0
References: <20221213215339.3697182-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213215339.3697182-2-meenashanmugam@google.com>
Subject: [PATCH 5.15 1/1] xen/netback: don't call kfree_skb() with interrupts disabled
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jgross@suse.com,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jan Beulich <jbeulich@suse.com>,
        Meena Shanmugam <meenashanmugam@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 74e7e1efdad45580cc3839f2a155174cf158f9b5 upstream.

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So remove kfree_skb()
from the spin_lock_irqsave() section and use the already existing
"drop" label in xenvif_start_xmit() for dropping the SKB. At the
same time replace the dev_kfree_skb() call there with a call of
dev_kfree_skb_any(), as xenvif_start_xmit() can be called with
disabled interrupts.

This is XSA-424 / CVE-2022-42328 / CVE-2022-42329.

Fixes: be81992f9086 ("xen/netback: don't queue unlimited number of packages")
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
---
 drivers/net/xen-netback/common.h    | 2 +-
 drivers/net/xen-netback/interface.c | 6 ++++--
 drivers/net/xen-netback/rx.c        | 8 +++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index d9dea4829c86..bdb3139c7162 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -395,7 +395,7 @@ irqreturn_t xenvif_ctrl_irq_fn(int irq, void *data);
 
 bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
 void xenvif_rx_action(struct xenvif_queue *queue);
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
 void xenvif_carrier_on(struct xenvif *vif);
 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index c58996c1e230..6a35772fde7a 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -269,14 +269,16 @@ xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (vif->hash.alg == XEN_NETIF_CTRL_HASH_ALGORITHM_NONE)
 		skb_clear_hash(skb);
 
-	xenvif_rx_queue_tail(queue, skb);
+	if (!xenvif_rx_queue_tail(queue, skb))
+		goto drop;
+
 	xenvif_kick_thread(queue);
 
 	return NETDEV_TX_OK;
 
  drop:
 	vif->dev->stats.tx_dropped++;
-	dev_kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index a0335407be42..c2671eb6ad93 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -82,9 +82,10 @@ static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
 	return false;
 }
 
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 {
 	unsigned long flags;
+	bool ret = true;
 
 	spin_lock_irqsave(&queue->rx_queue.lock, flags);
 
@@ -92,8 +93,7 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 		struct net_device *dev = queue->vif->dev;
 
 		netif_tx_stop_queue(netdev_get_tx_queue(dev, queue->id));
-		kfree_skb(skb);
-		queue->vif->dev->stats.rx_dropped++;
+		ret = false;
 	} else {
 		if (skb_queue_empty(&queue->rx_queue))
 			xenvif_update_needed_slots(queue, skb);
@@ -104,6 +104,8 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 	}
 
 	spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
+
+	return ret;
 }
 
 static struct sk_buff *xenvif_rx_dequeue(struct xenvif_queue *queue)
-- 
2.39.0.rc1.256.g54fd8350bd-goog

