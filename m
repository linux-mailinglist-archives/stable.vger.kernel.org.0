Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B330A339E42
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhCMN3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:29:48 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:38785 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233645AbhCMN3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 08:29:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7477B1941DF3;
        Sat, 13 Mar 2021 08:29:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 13 Mar 2021 08:29:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PKbuU9
        BYgz+ydGzIecLfmT0oPMwCxTyse1G30YQ1ZXA=; b=q03fucoMwYBXzAr/ARUgX0
        ZKotZO/k3cr4a5o3/guB91L/UE7w+a6rd7KUAc7hDNE670/uo3PLle95U2R75zWj
        71xunJ3Zo7/YlPU5LDWFo6PtA95RrLfj3wOEXByY7KVyc2hMV714Q6EHscmQdB1c
        4I3r0rFUZEI+yS6ep4c357xsb4mlvh+dlHTLXvOH3//lmnp6tl6FwrqRkY69nTUX
        4FLCi1r9Vf9dXX+n0RWTn/oCRiX1peR1vgZ015/9vd8em+j01fbssghGLJZX+qfB
        WsWHGvocSPcNI4kyU0tJ4Ehzg4k5cHWk9KaX6uuHyxNq3rIzL7KIapau5PNyL5Mw
        ==
X-ME-Sender: <xms:L75MYK3WPt1aNEIw5Vo19vLV-nM_il3PyOhc3tfBzboKgxRjhSEDnA>
    <xme:L75MYNHxEt5Z6bbjJstokz72GVb_TF9o8zgwxRV78RoP7DrEGl1SkVKZjqe1i0Gcr
    8kf1y5E1ZYbyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedutdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:L75MYC4UX7VlqqupRQW_C7uugsHm31NnMUsoD6R41h2pOxcsGqDGEw>
    <xmx:L75MYL1X6Ghx3m9RzjV9bpO5jOJwFQsRhWEEr9E63KdQK7rfq0Kjkg>
    <xmx:L75MYNHtQG5CqcbiNjxlLmL0MLhZVzfXms9zgPIah6bVfgXbj5H5yw>
    <xmx:L75MYCSEE3VCN7w-nf5QlQrtbJ3Wa9AbjlR1dXHAJXBTwR8a9WHWLQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 237DD108005C;
        Sat, 13 Mar 2021 08:29:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] xen/events: avoid handling the same event on two cpus at the" failed to apply to 5.10-stable tree
To:     jgross@suse.com, boris.ostrovsky@oracle.com, jgrall@amazon.com,
        julien@xen.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Mar 2021 14:29:10 +0100
Message-ID: <1615642150227179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

