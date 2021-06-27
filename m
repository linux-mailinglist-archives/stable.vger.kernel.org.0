Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564013B53B1
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhF0OZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:25:34 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:49861 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229922AbhF0OZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 10:25:34 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id DD7C8194060D;
        Sun, 27 Jun 2021 10:23:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 27 Jun 2021 10:23:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=nEQPc7
        j2bB5HF8OWXxhqYVJOIyHhRGOPS/r7jGrg/Xw=; b=LlZ8zEnXG8PYSj7WeBPcUE
        AnkOFJhyZU43RgfrIJilY/GmV40TbM7nYqhz8QZG9rfX6KaVeDlVOhRjKz6eGCV2
        ENtVKWprP/dwc/cqUnmz3EgFTzh8XnP3wZ83vTUPbgPZZMd+2Rik2ko1O4/1OuH+
        0CVJU/U+R1xUR4d/VkprrfkH9LHUxDFW/LRbO4D5JU3ssw/XvrEgAfEeU69xec9T
        3jLMqYcMjWtlP0+dKll238aoivKHw9FlTF4QEdq0SxjemaJkpcnvDclDScyUoLuv
        vSj28szTA2R9idgXuPMJn3Nu/Egg1ksv6YAI/efZmudVWtIcCPF5UI27Q1AbleUA
        ==
X-ME-Sender: <xms:zYnYYJaFM-ndmDUlp4v1Kj5KPA3CghMYofHl3FznuZ7RDqfcKJ0uLA>
    <xme:zYnYYAbBMhdKAHxNLeb6X65dv4cp7iok9R72IkJ3BwYkgLWX2MrjDBOwSX8nEsjQb
    pDFBdyY_EErLg>
X-ME-Received: <xmr:zYnYYL_r75bQZVhemsXKA-c5GpjEXfsuTE0Wloqk74IkLvKGVILZhWViZgTnkHYhXA1CmfJOzcO8-Bc9zYcSMfLm9aoifZF3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:zYnYYHpm7AwONDh7z1sGULJhsJMbRFMM-JD0NSFO7GoOgVnUqFfA7Q>
    <xmx:zYnYYEoCdWWpSC5CjGlnoQQMn3xQ1JISn-LYPu63KWrT-8a8fTnmRg>
    <xmx:zYnYYNQR_xvoVU9GjH56EG7mbN1Wp7Hny_uEcgk_L5DXPFhZSuGC7w>
    <xmx:zYnYYL1O_sfkLZYWw5tCg1m72pu6q1OWA01Z5MnrYHFk2lQW0UR_KQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 10:23:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xen/events: reset active flag for lateeoi events later" failed to apply to 4.4-stable tree
To:     jgross@suse.com, boris.ostrvsky@oracle.com, julien@xen.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Jun 2021 16:23:07 +0200
Message-ID: <1624803787177226@kroah.com>
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
 

