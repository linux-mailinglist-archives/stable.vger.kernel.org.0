Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416CCD65B8
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 16:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733130AbfJNO7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 10:59:43 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:41991 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732518AbfJNO7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 10:59:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 875DD913;
        Mon, 14 Oct 2019 10:59:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 10:59:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=MlX7i8
        hFfaEvfWP+ger+nOBHaisVCGEP01sa0jHKb1c=; b=gGLoY0PuVtX+sC8sSEAKNY
        FnfzqKXCQZVZw0tSk8xoOb6cTIq1JOpT4Iwgcu71skYHHtDA58j6sVKkX866JeDr
        ykBomYm1YN0YtxhQ1Mx0wQzjHumyTowWweDtv4O9K1L2pFC9bSzmCXW+cNWOvNt2
        5Wn0WPtOHh9Vf3yXazXV0EEfUd5SMprcRM3K9tMNsbG9zdFhTQXfQSrJpvJxeSMJ
        sChhPLIvqSxi4ZkxCE9hLSFx9u/Qzjwtsw/f1U4y38puZ0+Jou8/a13QXLdIZBd/
        Eze8erew6nhitKe9y6wdBYb0s+kIuNndRKX7YeW8/J4jMNwkvCiMIlmbUzw6PIBA
        ==
X-ME-Sender: <xms:Xo2kXTQaydSteqPUFqt3XA1gsgVnsILWcSlehIm_Vpt6jTK7HBAwJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:Xo2kXZDVPyhafOrNSjHiI8FSdz5XdLZ8uMqH54h_4filkIHXKA6C7w>
    <xmx:Xo2kXT07eP9Os4aj02Get69hoU9Dr4vUglImgN0w81Atu6CMee_PSQ>
    <xmx:Xo2kXXUQpVw8wmvx1H1_RLsjjZ96fyun_60VXS5m1TwzoaWl_urSNw>
    <xmx:Xo2kXZi3w5VsfCAJXtfQ0RfsE2eAWwE17BoP7zxFvPD0OV1y9riryQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C098CD6005F;
        Mon, 14 Oct 2019 10:59:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc" failed to apply to 4.14-stable tree
To:     navid.emamdoost@gmail.com, dan.carpenter@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 16:59:31 +0200
Message-ID: <1571065171233128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5bdea6060618cfcf1459dca137e89aee038ac8b9 Mon Sep 17 00:00:00 2001
From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Sun, 29 Sep 2019 22:09:45 -0500
Subject: [PATCH] Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc

In fbtft_framebuffer_alloc the error handling path should take care of
releasing frame buffer after it is allocated via framebuffer_alloc, too.
Therefore, in two failure cases the goto destination is changed to
address this issue.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190930030949.28615-1-navid.emamdoost@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index cf5700a2ea66..a0a67aa517f0 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -714,7 +714,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	if (par->gamma.curves && gamma) {
 		if (fbtft_gamma_parse_str(par, par->gamma.curves, gamma,
 					  strlen(gamma)))
-			goto alloc_fail;
+			goto release_framebuf;
 	}
 
 	/* Transmit buffer */
@@ -731,7 +731,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	if (txbuflen > 0) {
 		txbuf = devm_kzalloc(par->info->device, txbuflen, GFP_KERNEL);
 		if (!txbuf)
-			goto alloc_fail;
+			goto release_framebuf;
 		par->txbuf.buf = txbuf;
 		par->txbuf.len = txbuflen;
 	}
@@ -753,6 +753,9 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 
 	return info;
 
+release_framebuf:
+	framebuffer_release(info);
+
 alloc_fail:
 	vfree(vmem);
 

