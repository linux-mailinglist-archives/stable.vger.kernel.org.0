Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73953B53B6
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhF0OZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:25:46 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:60027 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhF0OZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 10:25:44 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3E2ED19405A1;
        Sun, 27 Jun 2021 10:23:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 27 Jun 2021 10:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7Ngri9
        ocYa/LEiPjfHFtG2dg+7odFgMAN3i/57TMaSo=; b=qO+4xrQHaQ7jwJPDA1MOQb
        TVAXXr/+fKypgKDmY6y5NTzUCwy7/nuFrejzVavRVivAP3dQcHyvLPgRTa5HGGqn
        vLVcMgW+K1am+wWiIZb4pzK22yLyoGCzWRBRRdL0sfreSAFkDOOCDRiz1Ww0jjzO
        4yvfkzlzMkRhj+BUgfdztEVIhoGncdHIkxug0pdZpOJdh44cJ1+mPMVKXOIu8Wty
        RLp/SbiNmZ4M1eQkjCgaHoLjRw1L1+vSgMQa3HKgjsO01k3mXTT7wbAAjCKTnxH6
        HyS5Wn100Zex7IQMIksLsVl9VREXSnPaQqx0P4qZhgn4pSDXSp5NfQA+JMb8BzHg
        ==
X-ME-Sender: <xms:14nYYF1EwYrPSKa-n0qrbxjgbQzk1U31PZsJ55ZHwzP0yw9_borjbw>
    <xme:14nYYMHFZ6tqInAQec9f71lPysGLy2N-hV3fEnqWWUbbDCqN40YTPG3BqzSdBR3FK
    U2Dvi5YGjbotg>
X-ME-Received: <xmr:14nYYF7xJtpSy_coARNCiVfs72bfXnYza7i8ecRNea8ZHinM7zemkw9g1WhJEH4Kx4q6armCqnE1JscfDeomsx1XWarOYN9m>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:14nYYC2l-ipMcbN-0aYb6R4PrfSLlNfrnqZeiNDUd1bGMGZsf880Ww>
    <xmx:14nYYIGG3gR4Q_0MVXz96IeNd5v_fuwVOp4QqNbUhbwWsP-r2cTULg>
    <xmx:14nYYD_HaV0O7DKyNabwjlqDRREFgFE9zqFbrNXxv1qpONZP4IpmPA>
    <xmx:14nYYNSCqSLf-dHpE3PY-K5AkrBl9VhD6mwtSJy2oLmJKrVq2QaEfQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 10:23:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xen/events: reset active flag for lateeoi events later" failed to apply to 5.10-stable tree
To:     jgross@suse.com, boris.ostrvsky@oracle.com, julien@xen.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Jun 2021 16:23:10 +0200
Message-ID: <1624803790144136@kroah.com>
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

From 3de218ff39b9e3f0d453fe3154f12a174de44b25 Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Wed, 23 Jun 2021 15:09:13 +0200
Subject: [PATCH] xen/events: reset active flag for lateeoi events later

In order to avoid a race condition for user events when changing
cpu affinity reset the active flag only when EOI-ing the event.

This is working fine as all user events are lateeoi events. Note that
lateeoi_ack_mask_dynirq() is not modified as there is no explicit call
to xen_irq_lateeoi() expected later.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Fixes: b6622798bc50b62 ("xen/events: avoid handling the same event on two cpus at the same time")
Tested-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrvsky@oracle.com>
Link: https://lore.kernel.org/r/20210623130913.9405-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 7bbfd58958bc..d7e361fb0548 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -642,6 +642,9 @@ static void xen_irq_lateeoi_locked(struct irq_info *info, bool spurious)
 	}
 
 	info->eoi_time = 0;
+
+	/* is_active hasn't been reset yet, do it now. */
+	smp_store_release(&info->is_active, 0);
 	do_unmask(info, EVT_MASK_REASON_EOI_PENDING);
 }
 
@@ -811,6 +814,7 @@ static void xen_evtchn_close(evtchn_port_t port)
 		BUG();
 }
 
+/* Not called for lateeoi events. */
 static void event_handler_exit(struct irq_info *info)
 {
 	smp_store_release(&info->is_active, 0);
@@ -1883,7 +1887,12 @@ static void lateeoi_ack_dynirq(struct irq_data *data)
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		event_handler_exit(info);
+		/*
+		 * Don't call event_handler_exit().
+		 * Need to keep is_active non-zero in order to ignore re-raised
+		 * events after cpu affinity changes while a lateeoi is pending.
+		 */
+		clear_evtchn(evtchn);
 	}
 }
 

