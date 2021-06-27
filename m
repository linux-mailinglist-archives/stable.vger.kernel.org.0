Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F233B53B5
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhF0OZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:25:42 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:42673 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhF0OZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 10:25:41 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5167B1940611;
        Sun, 27 Jun 2021 10:23:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 27 Jun 2021 10:23:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QJbENg
        iOCyacGesNGub8jC9h9l1BOfCYpPohwo7yNDk=; b=jm+1jDHMQwnM1Z1AbVuzjt
        YNV4XLZbYVZCxufPGYXPz6H92UbyKRX49+050zWg91i2wOdA/U8qTBA1kPxcOrqS
        ZxAG8LK1oNfw76CtxLjvhbrycSVlTcG7F3ju4kmvdFjIhZBnbfkUdJq5+n9NCNME
        AWOdCmau4EeTmiZWc58yheKRqY3MMpS5l4qha/1Lpn/D/L7Gkg09s5dLN3gQj93L
        L71R9B/uLegc0vg6H/K5vBnCKGregN68Ok9Fx222CgpbwYkq5sZhbjmte7V7r6k3
        kVmuUtIjDsCyT7ltTJD1/WEeojwRBp4IPNlTiBHEQ0SQH1ia8lqgnOCS/b50sUkQ
        ==
X-ME-Sender: <xms:1YnYYEVvcUntiMQSe-qxDYEL8ApR9m08aMkyUhAwyFTsSTLUSRkLLA>
    <xme:1YnYYIl61uDJxjYrltp0S4rVCCO_P1UU2qey_Y1PUJ6d7CpybsLfDvFXqPp0edzFm
    MzgvOduVLUIxA>
X-ME-Received: <xmr:1YnYYIaaFSl9qgMq7DcG0k10igOgH4IlhzBRAjakih2STTQiRtgAyFM6NEkeYR40rCtdDixuxpasiFvwto8ayewJlVBjpUNz>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:1YnYYDWbctPViD-NOMhWdljE1DvCgXNphm8RGYB6k601dnvU-UUu2w>
    <xmx:1YnYYOl3XUZQSagYncWjV8ty4F5NME1NNbgPjs5r5T6ixE20qRmB6g>
    <xmx:1YnYYIcAOgnkWFymCzCcef3v9PJmwOoP-l-WwL9fMbr_GGsgvhua7w>
    <xmx:1YnYYDw5_ueHRjZclhRf8lHN1ZLuwADWKFOWjTm1TmZOA0PurwZo4A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 10:23:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xen/events: reset active flag for lateeoi events later" failed to apply to 4.19-stable tree
To:     jgross@suse.com, boris.ostrvsky@oracle.com, julien@xen.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Jun 2021 16:23:09 +0200
Message-ID: <162480378948125@kroah.com>
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
 

