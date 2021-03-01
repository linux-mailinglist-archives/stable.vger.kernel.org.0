Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD24D327C36
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhCAKck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:32:40 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:55353 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234242AbhCAKc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:32:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8EB7C1940669;
        Mon,  1 Mar 2021 05:31:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:31:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SrsTP3
        TGItijDmrgzjsgmXCCAyU8oqr9H3B11KaTWeA=; b=S1RMcLV0c6q+fq7Q64tcSd
        ZJv+VnUu/OwfKlpsl9W4Dv2biLk+Bgu7bFjtjCjqeRCfVMHD/7hsQJIIvBbFviM2
        PLTnuYgkQL1wnmiQrj3ntmM2nrZXoMIBUyLIfbibiCCId1qO/r31CbLjZHcG1OB6
        W/59U7EDF7sZmTn6mR+xzLpZa4j2YW96Z3ESxMit+qIvNaWIMsDdu4/oPDve0Wzz
        3tQUVsunRmEZs5bfKZlS8MkQkRBiuZ2gX2lCzSrpRYJMMTQzGUGtNZ3MsqsTuhYU
        waJOe4EitJVXmQKp9AOewNT+Ji66dF2K6RpbJFNX9GIngtdagNx7Hq56gh1VjHlQ
        ==
X-ME-Sender: <xms:ecI8YO8Ylc0bs03-7UH4DWKS8R1RRUHxqGj7ds9c4_h7eKAbBwBH8Q>
    <xme:ecI8YOtzLANt8OvUJPV67l-s6WHP8yXD47dKO5_OPzXPcjhAHCw33Iv_DWErJqgB0
    b3bqpY-M47fiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:ecI8YEDVFugeQVGaaPZvwobWvBTW59sELglhFsljOawfcz-BBFzMwg>
    <xmx:ecI8YGe4M7HXU21rNvsByo7Mt5s3lrGxA8aeOnKh1WUb53ZKyK-K3w>
    <xmx:ecI8YDPS6Xej_dD2Mat4xF6QA17U90FYpKB20R9n6zEz3KOqxoVI3A>
    <xmx:ecI8YFVa8dP3hPWVtA7ULp9N_LTaYTc6GrC_wMWypN7rnglEICn-cw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1508424005B;
        Mon,  1 Mar 2021 05:31:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] crypto: sun4i-ss - handle BigEndian for cipher" failed to apply to 4.9-stable tree
To:     clabbe@baylibre.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:31:11 +0100
Message-ID: <161459467119062@kroah.com>
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

From 5ab6177fa02df15cd8a02a1f1fb361d2d5d8b946 Mon Sep 17 00:00:00 2001
From: Corentin Labbe <clabbe@baylibre.com>
Date: Mon, 14 Dec 2020 20:02:28 +0000
Subject: [PATCH] crypto: sun4i-ss - handle BigEndian for cipher

Ciphers produce invalid results on BE.
Key and IV need to be written in LE.

Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index c7bf731dad7b..e097f4c3e68f 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writesl(ss->base + SS_IV0 + i * 4, &v, 1);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
@@ -223,13 +223,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writesl(ss->base + SS_IV0 + i * 4, &v, 1);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);

