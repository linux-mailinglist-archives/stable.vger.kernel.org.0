Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAC83B53B4
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhF0OZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:25:40 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:55867 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhF0OZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 10:25:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9A18D1940613;
        Sun, 27 Jun 2021 10:23:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 27 Jun 2021 10:23:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=phyv6h
        MuXY78KUxchON7/wJZSwghA85oOObltcmGAH0=; b=Z5EJQ7Nlny5VXwx5sNRwFx
        kvoSKBJa7iCu41aRhuGkAs8ivoYC+8QPDn/VTxg9tfg7Y2Zrcx1mpRrCkMTpTtRx
        E8Eo5jW32MObI9EDrqgLyZW737E5yQ1KEZcHeDOdF8YNYXkf+1mQX/HnYEqpEewu
        c4TSz1QrSV570BaWBfjrlxUMqE6bUMjXR7WCKS2k7uBkwN4Pz76SSV2lXyOEMSkV
        zAoZW+H/26Ku2sOpgb5k2QyU+2Pm1uMT8H3+ZjzMyFywIZDz0PY1NST6EEE9ECQ4
        ee4CPIfc8g4eOH19S41E2/0neE6ejNggazbkDonMw+RSklN7jseZHHXZUHa2BveQ
        ==
X-ME-Sender: <xms:04nYYF1cgJLukPBUbb2oGw1haMAsLkALQnvaMAT0MGjzW-gL-uuzoA>
    <xme:04nYYMH9VMeTnM53ZW2tG4f6JS1cRpKBTXXQ2BjDDd3gH0uG_DWq9srAvCboJ51Nq
    5UmHHMCFZVLPg>
X-ME-Received: <xmr:04nYYF7Jd36w96oyouw5NpCHSQfX4sd71gOffo5YQHfMQsMTagVPXbfgctds6ZmyvusIP_wdMAil4zCzvfDjA6RDKqxnC-4r>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:04nYYC2dduNJAWUE8N7yOgCKQ97fSv7M5yPrMPmUBdB3mMWwfFtxXQ>
    <xmx:04nYYIEed5Jc_6So57TEfJmz-Y_9aPFiKCHzYntwOBvTKVt3t9CqFw>
    <xmx:04nYYD9_8t963Kem8cAjZ7W2yJeKKyRBemPmwLMfK0nFqBPb8GMrVg>
    <xmx:04nYYNQavSEDBqjntUUleZTfr6PWZ2txaLbGPuCGhbwzPInI5HXbPw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 10:23:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xen/events: reset active flag for lateeoi events later" failed to apply to 5.4-stable tree
To:     jgross@suse.com, boris.ostrvsky@oracle.com, julien@xen.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Jun 2021 16:23:09 +0200
Message-ID: <1624803789207186@kroah.com>
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
 

