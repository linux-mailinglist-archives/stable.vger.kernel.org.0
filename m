Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C0D3B53B2
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhF0OZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:25:36 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53829 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230522AbhF0OZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 10:25:36 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id CCEA1194060E;
        Sun, 27 Jun 2021 10:23:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 27 Jun 2021 10:23:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rsSb0t
        Co4nMDhydx9NE7zRnEdVFEh/kQexx4+dk+qoc=; b=lRnDsKkxPYVtIZ4dBkZOhh
        qjc1oJ7Uve0QX/d/8+l4PHYX2qOXUp23BCFSPFaGJNrFQxh8FAVGauFmkFxKf7x8
        IwJGfeA4XIu5xxZ0xS1pjRtcNK8hPbo9n9EmDOKFtSegkQe6TFywYSY7pxXNq19M
        4guL0j0o5XGZ+XWGVPBZLTIPMNwJlSx0QpvsvCthA0WOQi4oqoStqTlr5KTl7Vx9
        POGreHuxLyXGfENJ5K8hOfnircqzT+U32haDevMip6V76ahdKL9OC8cdocNcte2L
        fX/HqsErMUEC+oIgt20varBsVNDNkwySlEEhWDG1i93usOr9NoZl66tw7/YFZhBw
        ==
X-ME-Sender: <xms:z4nYYP3DuwFFtPBZYRDvpp59bNB-7H3xUm78BEc9mtBLwSk9N06rGA>
    <xme:z4nYYOHcOcpLra78ROvbKCKk72kAMu-aRYDpsACYl4mtgzS9WvovEnApKu5TDmYqa
    NibaufGAwXK4w>
X-ME-Received: <xmr:z4nYYP6J4ctgn_Jlz4-ExvYDtG1RW2znjAeXMsd7CzsTAxqbOvrYXXStI_RvqJryec9bvVFm1UTbslr5sqRKwHuiqLZlGzFe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:z4nYYE1hDTBiBqtJu3Uvo19el5OIwU2kjEzd8QQa5oLWpykfkVd3hQ>
    <xmx:z4nYYCFgXTB7FvPpFfgwsXwurVEFLBiFlWnHHO4oJgnKqXrMgTiVRw>
    <xmx:z4nYYF8wcjkg74CXf1r58dYa7AA01DP6Dw1Yvsj_59PUkzB2g7NizA>
    <xmx:z4nYYHTwTVsF7DWEt-r2MbjcCMsCWPeysLDrTABXw2CA_QQOLbGfzg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 10:23:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xen/events: reset active flag for lateeoi events later" failed to apply to 4.9-stable tree
To:     jgross@suse.com, boris.ostrvsky@oracle.com, julien@xen.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Jun 2021 16:23:07 +0200
Message-ID: <1624803787218150@kroah.com>
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
 

