Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0C6353C50
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhDEIRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:17:38 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:40327 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhDEIRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 04:17:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4B3C21940A3A;
        Mon,  5 Apr 2021 04:17:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 05 Apr 2021 04:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nsGihG
        CpTyl7frUXMUgIGScDfoNJTL8ZZasoEuiPEeQ=; b=gPr/Ah07LMiSTh5ZcYjldf
        Z0l8zigUjC7LhjasA5iQo8vF06u6JCyQmwt5QhTch8s+xoQ/lD1IjpYBS6n6u5z5
        +RYDb9BNoonl7pxd6dmu1yKyMR9qSe/2uJ3DpwgiQ20ANxYfljOGmtduaFktt/eW
        fwGOgNaXkirTFjqyXoRKIdgWur/mv+LIN55Ac4cIu4WsqQQn7E2gWt2xd1sLer7C
        Ez5tBuQBOoJE1IQ0Er4NyJu/BxRGORnpbYh0EtPDI9f63pbFmQVfLrt7turcnM3m
        ryLU021kP7//AZ4wEMSzFzCLurFEZavB1bcR5/Acme2vU8QEIeeGl+x8nJl5l7Sw
        ==
X-ME-Sender: <xms:m8dqYCiI_Zagy0hzhG7Np5C9n_VxFEhcYg0Re9YOPnifcwj4Aw9kwg>
    <xme:m8dqYDAFHY9I_OkzIeieAwtGGFwnb-gjLbiIRzLQD-7mlaxtvVH78p5ttfKZxMblt
    U-KlzPgcuOr0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejvddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:m8dqYKGtpGHN8MpjvIdddVfWjB7UYkvbsBCTiBC_zJDnkEinTFAFUQ>
    <xmx:m8dqYLT_a3qFOHZ7qVVjidsNPxIPRgafUVvBX6tVQGAUeniMbP5XIA>
    <xmx:m8dqYPxb6zUxUbSKL-78WK7Vtr0SEvXanF97yai8jIdc1kfBLmGHgQ>
    <xmx:nMdqYNZ9ox3AWAI44I40EHhHxZJvb07VARwui6AgGf1w5OKdNp8M5A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7EED91080057;
        Mon,  5 Apr 2021 04:17:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mei: allow map and unmap of client dma buffer only for" failed to apply to 5.11-stable tree
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Apr 2021 10:17:29 +0200
Message-ID: <1617610649156196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ce068bc7da473e39b64d130101e178406023df0c Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Thu, 18 Mar 2021 07:59:59 +0200
Subject: [PATCH] mei: allow map and unmap of client dma buffer only for
 disconnected client

Allow map and unmap of the client dma buffer only when the client is not
connected. The functions return -EPROTO if the client is already connected.
This is to fix the race when traffic may start or stop when buffer
is not available.

Cc: <stable@vger.kernel.org> #v5.11+
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210318055959.305627-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 4378a9b25848..2cc370adb238 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -2286,8 +2286,8 @@ int mei_cl_dma_alloc_and_map(struct mei_cl *cl, const struct file *fp,
 	if (buffer_id == 0)
 		return -EINVAL;
 
-	if (!mei_cl_is_connected(cl))
-		return -ENODEV;
+	if (mei_cl_is_connected(cl))
+		return -EPROTO;
 
 	if (cl->dma_mapped)
 		return -EPROTO;
@@ -2327,9 +2327,7 @@ int mei_cl_dma_alloc_and_map(struct mei_cl *cl, const struct file *fp,
 
 	mutex_unlock(&dev->device_lock);
 	wait_event_timeout(cl->wait,
-			   cl->dma_mapped ||
-			   cl->status ||
-			   !mei_cl_is_connected(cl),
+			   cl->dma_mapped || cl->status,
 			   mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 
@@ -2376,8 +2374,9 @@ int mei_cl_dma_unmap(struct mei_cl *cl, const struct file *fp)
 		return -EOPNOTSUPP;
 	}
 
-	if (!mei_cl_is_connected(cl))
-		return -ENODEV;
+	/* do not allow unmap for connected client */
+	if (mei_cl_is_connected(cl))
+		return -EPROTO;
 
 	if (!cl->dma_mapped)
 		return -EPROTO;
@@ -2405,9 +2404,7 @@ int mei_cl_dma_unmap(struct mei_cl *cl, const struct file *fp)
 
 	mutex_unlock(&dev->device_lock);
 	wait_event_timeout(cl->wait,
-			   !cl->dma_mapped ||
-			   cl->status ||
-			   !mei_cl_is_connected(cl),
+			   !cl->dma_mapped || cl->status,
 			   mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 

