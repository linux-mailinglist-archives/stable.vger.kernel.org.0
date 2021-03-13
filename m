Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540FA339E3D
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhCMN3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:29:16 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:40701 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233629AbhCMN3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 08:29:14 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C35F01941EA1;
        Sat, 13 Mar 2021 08:29:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 13 Mar 2021 08:29:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YcE2vX
        nywc+hYoBC7zz/5MY4XRBg9o23j8C0seV0m8E=; b=Wx0q9N22uEWUlA5VKr2ETr
        zAV2JWLu2BbaEOD/RQ7rCG7R9F+gso+xiPldhx19GiUN4agTqcyyXXpeHF/Wc7ve
        iLAQYPWLEXRmc/WecY1nPEwT75W/sy6hhh94dSxeFKx4KxnfpgWWbLx/vXuuzOrL
        J7DiLQCxG3UgUyFn+SGejw0zs5QQYle8W5zw39wkOJJ+pHPbprELzc/wm5YjpoxT
        72t7JnLx7S+xYo0NgKyPsyizOrkSewExjmWv0HjJQ7vZbl3HAxyrkfKD1HBBL2cS
        EdXw8XLXS4aGC2n5y6boiy6FDfhto3nfCmOG5Ex9NJ4/WzbbtWhgIYVpBnT9d+Rg
        ==
X-ME-Sender: <xms:Kb5MYKRobJlEm9x4Vmc7wO84eiopyDfvAMpiilZt8n1WNMOtEuC9LQ>
    <xme:Kb5MYPwBUrBZwr4mIgXC8vu4wMNeJo14sthhA9koB7P6gVdYx6gDf9HOEskbRJ49k
    _v6tJIjrOthWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Kb5MYH2YYxTHzQ92UuItdSviU3SDAXahJyqmlt5hXru-48OjPP4VMQ>
    <xmx:Kb5MYGCnh2fnwND3wFHbGCy-hINqvvtzFGWrTS6Z_Bu1PN6wyXjNvw>
    <xmx:Kb5MYDhI5r3c2A1kzUHp2EwIOT64nsQ32qRVxaKMaj0eO8__w61AZQ>
    <xmx:Kb5MYGskbXZr5_0CIFrvgeXE48hA9pp_PnRph_6CIvHnyGYIDn9k2Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D7B324005B;
        Sat, 13 Mar 2021 08:29:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] xen/events: avoid handling the same event on two cpus at the" failed to apply to 4.19-stable tree
To:     jgross@suse.com, boris.ostrovsky@oracle.com, jgrall@amazon.com,
        julien@xen.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Mar 2021 14:29:09 +0100
Message-ID: <161564214910490@kroah.com>
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

From b6622798bc50b625a1e62f82c7190df40c1f5b21 Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Sat, 6 Mar 2021 17:18:33 +0100
Subject: [PATCH] xen/events: avoid handling the same event on two cpus at the
 same time

When changing the cpu affinity of an event it can happen today that
(with some unlucky timing) the same event will be handled on the old
and the new cpu at the same time.

Avoid that by adding an "event active" flag to the per-event data and
call the handler only if this flag isn't set.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Link: https://lore.kernel.org/r/20210306161833.4552-4-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index b27c012c86b5..8236e2364eeb 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -103,6 +103,7 @@ struct irq_info {
 #define EVT_MASK_REASON_EXPLICIT	0x01
 #define EVT_MASK_REASON_TEMPORARY	0x02
 #define EVT_MASK_REASON_EOI_PENDING	0x04
+	u8 is_active;		/* Is event just being handled? */
 	unsigned irq;
 	evtchn_port_t evtchn;   /* event channel */
 	unsigned short cpu;     /* cpu bound */
@@ -810,6 +811,12 @@ static void xen_evtchn_close(evtchn_port_t port)
 		BUG();
 }
 
+static void event_handler_exit(struct irq_info *info)
+{
+	smp_store_release(&info->is_active, 0);
+	clear_evtchn(info->evtchn);
+}
+
 static void pirq_query_unmask(int irq)
 {
 	struct physdev_irq_status_query irq_status;
@@ -828,14 +835,15 @@ static void pirq_query_unmask(int irq)
 
 static void eoi_pirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn = evtchn_from_irq(data->irq);
+	struct irq_info *info = info_for_irq(data->irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 	struct physdev_eoi eoi = { .irq = pirq_from_irq(data->irq) };
 	int rc = 0;
 
 	if (!VALID_EVTCHN(evtchn))
 		return;
 
-	clear_evtchn(evtchn);
+	event_handler_exit(info);
 
 	if (pirq_needs_eoi(data->irq)) {
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
@@ -1666,6 +1674,8 @@ void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl)
 	}
 
 	info = info_for_irq(irq);
+	if (xchg_acquire(&info->is_active, 1))
+		return;
 
 	dev = (info->type == IRQT_EVTCHN) ? info->u.interdomain : NULL;
 	if (dev)
@@ -1853,12 +1863,11 @@ static void disable_dynirq(struct irq_data *data)
 
 static void ack_dynirq(struct irq_data *data)
 {
-	evtchn_port_t evtchn = evtchn_from_irq(data->irq);
-
-	if (!VALID_EVTCHN(evtchn))
-		return;
+	struct irq_info *info = info_for_irq(data->irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
-	clear_evtchn(evtchn);
+	if (VALID_EVTCHN(evtchn))
+		event_handler_exit(info);
 }
 
 static void mask_ack_dynirq(struct irq_data *data)
@@ -1874,7 +1883,7 @@ static void lateeoi_ack_dynirq(struct irq_data *data)
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
 
@@ -1885,7 +1894,7 @@ static void lateeoi_mask_ack_dynirq(struct irq_data *data)
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EXPLICIT);
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 	}
 }
 
@@ -1998,10 +2007,11 @@ static void restore_cpu_ipis(unsigned int cpu)
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq)
 {
-	evtchn_port_t evtchn = evtchn_from_irq(irq);
+	struct irq_info *info = info_for_irq(irq);
+	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
 	if (VALID_EVTCHN(evtchn))
-		clear_evtchn(evtchn);
+		event_handler_exit(info);
 }
 EXPORT_SYMBOL(xen_clear_irq_pending);
 void xen_set_irq_pending(int irq)

