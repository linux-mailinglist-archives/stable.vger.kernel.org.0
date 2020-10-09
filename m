Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5803B288383
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732028AbgJIH35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 03:29:57 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:33389 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732006AbgJIH35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:29:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A4D831940B45;
        Fri,  9 Oct 2020 03:29:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 09 Oct 2020 03:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6TJ0BF
        z5ugKwZK03r1uj0fZaQkta31GJEKmQEJuk7eg=; b=T3fz+GjbJ1zedUE9Vms4EY
        xVYdV4BZZ0AnEoLSolIY9icgLA2cBeYvySdbk2Kz2TzjA77hhLbGvSX+Mw0unpYM
        C3qlKcvFUDgODbLvTr84RXTOdEfpSgA6ElWiSjBqW62c5ovWVkCLTMvurtHLWISq
        XbLn49XtjfTamTm+3p57vQ3+Y4ItUq7Vm6BjF0GY3Wx6pJpD76IzWykg/BX8UusJ
        Emw0v71L3FYHvqDwD3EIVldBudXwQcTkkb8VqXBcszgOIAqKmL+5IeRGIrn3o0Eh
        Ngfy7+ReCYLVBTQqXOknu7VlU4Co+9KTAn1pfiamwhIXszh5EaVXyM/0xWCFD7oA
        ==
X-ME-Sender: <xms:dBGAX6WyY9z6qPJIbCSykBbeEd-ucL7t1cIiKrGmnq2xj8QTBSk0Bg>
    <xme:dBGAX2lqBXcR5DdNLWW_HqbMtyUfUEMS8Wc1Z47hFLJbcZLt4bHy9UgIm8D57fZEH
    zv2jbuBKoshtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrhedtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dBGAX-b8FKnR6R3nUv6jA7I68syFuXKcLO66VZ5YZPm1ApFuYHMSDg>
    <xmx:dBGAXxW-EbbBgoqMjwdlmphtQBd5Z8ZtlilsWrUaAfGLxtbkxfiUnQ>
    <xmx:dBGAX0mR9CPwXA84zX1OvO0FAVef0kDfqhupiIvU8rmbuSousb5Hbw>
    <xmx:dBGAX7uQUmRc2gSPs9UFkekMHY2vrhW-8OSUCvlmApBnAeow7IA_Sg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 42586328005A;
        Fri,  9 Oct 2020 03:29:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] vhost: Use vhost_get_used_size() in vhost_vring_set_addr()" failed to apply to 4.19-stable tree
To:     groug@kaod.org, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Oct 2020 09:30:35 +0200
Message-ID: <160222863513621@kroah.com>
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

From 71878fa46c7e3b40fa7b3f1b6e4ba3f92f1ac359 Mon Sep 17 00:00:00 2001
From: Greg Kurz <groug@kaod.org>
Date: Sat, 3 Oct 2020 12:02:03 +0200
Subject: [PATCH] vhost: Use vhost_get_used_size() in vhost_vring_set_addr()

The open-coded computation of the used size doesn't take the event
into account when the VIRTIO_RING_F_EVENT_IDX feature is present.
Fix that by using vhost_get_used_size().

Fixes: 8ea8cf89e19a ("vhost: support event index")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kurz <groug@kaod.org>
Link: https://lore.kernel.org/r/160171932300.284610.11846106312938909461.stgit@bahia.lan
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c3b49975dc28..9d2c225fb518 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1519,8 +1519,7 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
 		/* Also validate log access for used ring if enabled. */
 		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
 			!log_access_ok(vq->log_base, a.log_guest_addr,
-				sizeof *vq->used +
-				vq->num * sizeof *vq->used->ring))
+				       vhost_get_used_size(vq, vq->num)))
 			return -EINVAL;
 	}
 

