Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD24339E3F
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhCMN3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:29:15 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:56147 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233594AbhCMN3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 08:29:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1F7CD1941E36;
        Sat, 13 Mar 2021 08:29:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 13 Mar 2021 08:29:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XD45sO
        tSt6r0VBVFwLCHCuKmn3lqjxydzyLJCwyQ7mI=; b=QKndHJym5mAyxbCysHX5PC
        sVFX9mjHH+cZz9P8IIKxG+08VN+7MMXcLSWRaYgLTXbvGDlgJ6tuXDxVEcBP8t70
        knpIErL/6+l8dHgtwQUJwzgMYm37yockcomh1Vcjb4ecRPcBydtYCrKCrV8cixtB
        9qA/a0n6qZMt1yIDoslvsHmJ1nMCjiX/Q3NDxhx37ASuSgmVEDAuCak03q6B+JDU
        WbmRzCFil1WRTYymbmTlms+qbzF+BaezcU171br97qimDPq1xjBD5rGe6DucDRBG
        rOq9t9r91gdHQOnWcqQTBIDPT5KVFLvYdTNMGgFUAgfRiNYVc9QsKTQq5Amp9j1g
        ==
X-ME-Sender: <xms:Jr5MYH3owCuPwlvAh-mzidQyFihQYbeMetNvaqvdCHtLkmJ4iec5DQ>
    <xme:Jr5MYGFnNfMIHI9VEAIk6rqXVbQT2XtT3nMdeJsGtwq1BKURLrOIUJyyfeMrCkUIF
    2UhZuZN0GrkoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Jr5MYH6CauuPCmJbGjDwnE4M1F7EHz8sk0UMftN5ArQcnQ-3e1XYkg>
    <xmx:Jr5MYM0vosKvrvaMhkPRjamdymsDDyZbO4-UwBFbA9uT-Rtpl1L1Xw>
    <xmx:Jr5MYKFMQKkJakK9p0Fsttk83CLASfY-iiU7nyOChs8-yqo6jzSmsg>
    <xmx:Jr5MYPTs8Y9qH3Ofhj_Y-PAeXPlSw5UGw17eQaiH150xJ0ViFaHNlQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C1996240057;
        Sat, 13 Mar 2021 08:29:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] xen/events: avoid handling the same event on two cpus at the" failed to apply to 4.4-stable tree
To:     jgross@suse.com, boris.ostrovsky@oracle.com, jgrall@amazon.com,
        julien@xen.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Mar 2021 14:29:08 +0100
Message-ID: <1615642148182206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

