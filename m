Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79985205160
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbgFWLyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:54:55 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:34631 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732225AbgFWLyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:54:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id CEAC9A1D;
        Tue, 23 Jun 2020 07:54:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=a91elt
        YdeWikXqJOsr9OG7hDF13OGY4MLgOwfMs0JAQ=; b=hO2EF8Y1p0fbYLFhHMQnrl
        XJVZx0xt7ayEjMO4HqCqdFwvXkeISeO7qj5czpHg6YjZHbo78N9Ao//8hMK1vSWe
        lWpOrqSx7RN4yTkhZexhPyZPcaYIFynZbsZq32s9Obexf4SxrqIayKiPu7Hqn8dh
        PsyoTpexI2a+A4E0JVMPZxvOlgreduSok3lvBS6Ihog4C8vGFjOcMpSgtx0bfipp
        GJ0fYoK+DrXiBmk51LbY4VkxVKrSVrHC7CfBs3ztgL1+yZemYDvtMyh9DDkja9PK
        4QH78kjYfw/ewCwuf6vomER2IoPi9+qSod4iRprs9uI9RcNQwZIwo9nh91PaXCMg
        ==
X-ME-Sender: <xms:jO3xXqmYz70JkZm37h7KKyjoDKeEg_ItXWu0-Ck3kySEGVJwnfzTeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:jO3xXh3yTebZQjGXEYRgM09-FVnscO-O2RTLGSxygIcVhd6e8-bWkQ>
    <xmx:jO3xXop80mZbo0-matANm93f1jleFbqsIMqnCZyhS34IxmHxJmiEuw>
    <xmx:jO3xXulunqNH49BkdwFXHjHDonkIVs3HdgVUj-KTFeucuNcYZ5a1HQ>
    <xmx:je3xXphrYYohWDr5qyndocXOgYSCZys8f7X2BjC9HYWL951MEJspamd1dlQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1EC703280063;
        Tue, 23 Jun 2020 07:54:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: algif_skcipher - Cap recv SG list at ctx->used" failed to apply to 4.4-stable tree
To:     herbert@gondor.apana.org.au, smueller@chronox.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:54:47 +0200
Message-ID: <1592913287234176@kroah.com>
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

From 7cf81954705b7e5b057f7dc39a7ded54422ab6e1 Mon Sep 17 00:00:00 2001
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 29 May 2020 14:54:43 +1000
Subject: [PATCH] crypto: algif_skcipher - Cap recv SG list at ctx->used

Somewhere along the line the cap on the SG list length for receive
was lost.  This patch restores it and removes the subsequent test
which is now redundant.

Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index e2c8ab408bed..4c3bdffe0c3a 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -74,14 +74,10 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		return PTR_ERR(areq);
 
 	/* convert iovecs of output buffers into RX SGL */
-	err = af_alg_get_rsgl(sk, msg, flags, areq, -1, &len);
+	err = af_alg_get_rsgl(sk, msg, flags, areq, ctx->used, &len);
 	if (err)
 		goto free;
 
-	/* Process only as much RX buffers for which we have TX data */
-	if (len > ctx->used)
-		len = ctx->used;
-
 	/*
 	 * If more buffers are to be expected to be processed, process only
 	 * full block size buffers.

