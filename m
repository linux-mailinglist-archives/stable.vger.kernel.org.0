Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B7BD65B6
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 16:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733057AbfJNO7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 10:59:34 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:47317 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732518AbfJNO7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 10:59:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 33C97913;
        Mon, 14 Oct 2019 10:59:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 10:59:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=okQn0u
        U5r0uNhqp2hY6HXWdEVEQZhr4I+d/NtsAvA4E=; b=OIXogA48D2FG7J8tfMThtQ
        LEkHN+RRwUoG3jyAbag+IiDxhbGgTzL5C3/mbT/ZPwXfrSAtgsf8KFMTmTQOCbaF
        xp2OhPlKsBWGd2qmKaekwINRofiXejPUlZOdRUQn2M/c9zsb4S+J/zyfX7DpUmqf
        LCtbQPkpUp3DusRWcOWKK9TgNA7Bn1TY6KoAZC64Efbgj4PHOzH6qcP204Lpcz7/
        y7X/JqUnFzvGnIOVEnB+T9crZ3J01OS5HD54I8h9Gg2AFVfFzeBvejmZn9Ugru3F
        Lw/cQ3zNdim0vm7BLr9wONS4N+qF54qD/dbGf5LNPug1tBAWmkwqxOXkmrr7YISg
        ==
X-ME-Sender: <xms:VI2kXSpLn4VxUUMBQ3vvQ9rQOQvlOMe2XnjsLCb44oL7r3L2Pr2y2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:VI2kXSj6ftYsPd53z_tUcUcCdaViZQsAwgn5d-GbCTIOm0PcBKkxoQ>
    <xmx:VI2kXbwJLpQHUAgSyp7glnV-eYFHb7mqZaiCLncOgkJX-2bLoFWDeQ>
    <xmx:VI2kXfgN9ORKyqHmGPET3fhsbm97ZwnKuL0nbkGIWYzh6fylMH390w>
    <xmx:VI2kXQg-krRG7UW5uTX_mEAmctt8M92Q76L065vaZAUkEbzHQzCsPQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1183C80062;
        Mon, 14 Oct 2019 10:59:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc" failed to apply to 4.4-stable tree
To:     navid.emamdoost@gmail.com, dan.carpenter@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 16:59:30 +0200
Message-ID: <15710651701597@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
 

