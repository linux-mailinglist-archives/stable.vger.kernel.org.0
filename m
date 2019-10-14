Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B08D65B7
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 16:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbfJNO7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 10:59:42 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:40591 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732518AbfJNO7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 10:59:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2210D91E;
        Mon, 14 Oct 2019 10:59:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 10:59:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xi+X8i
        bdiSPgaVxz42pqZXEw1wm32Zlh6Xj1YAl/1+k=; b=iaXQdoHuY0Jsnnvx02ATLP
        SEpVlEC3i7HNhEfIgh345s7HnNuC+6aw5hC0KQNZmHUn38mMf4ayA3+MOe4ZeteC
        +HdnH3zWUbVpMz1PzeHtdpABFYcBVJ/NccZPgbU5mujtGWvP95xssGM7xMIbvVr4
        6IUE9/sSKp+ylQ5tGeYa2lndxwSVI0YFpXvWQi3JlqnsnAzJHRoDQPMH9mW4rK/e
        RHrXf2yefvytcN8Nls/YjoYdS0Q/Q4twmZiBohNzMmcqRUhlsgQZTMjn/q0xOepv
        IYgeD3SVJgeFiZc/cjWmcQgoCs2tJKBbU7j27D5BRRPVaCtjnRPc+1SWVwaRmocA
        ==
X-ME-Sender: <xms:XI2kXeBsiX1qmUu-V48etMfTxo8BuS1ckzAmaWfrQTg826xXuVP6AA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:XI2kXZFPhZw7f4EtutgfjOGQ9pJlovLS8SYx6m2aB9hgDMMJu7KQ1w>
    <xmx:XI2kXc85_ew61jYigCn4qzm8mkitBEgtvVuSYlZV07Qh_tNgKN3-QQ>
    <xmx:XI2kXfajL3dg0f0Dw5OC1BhVGKmFN0QNX0YZMR_kzvblRE6dtSr0Ug>
    <xmx:XI2kXUWGUNCQL6gxThKKM_3lE1BCOpHgaOJo4Edq-w-qwdaRFU0liQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5EE06D60062;
        Mon, 14 Oct 2019 10:59:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc" failed to apply to 4.9-stable tree
To:     navid.emamdoost@gmail.com, dan.carpenter@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 16:59:30 +0200
Message-ID: <15710651705320@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
 

