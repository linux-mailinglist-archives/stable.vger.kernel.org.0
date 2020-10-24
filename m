Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1673297BDC
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 12:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760989AbgJXKgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 06:36:45 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:44433 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760913AbgJXKgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 06:36:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 19B736A3;
        Sat, 24 Oct 2020 06:36:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 06:36:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TXYF0N
        SqgR1DX/iBWeXiBAneX3n78Y58adxFB2DGLOw=; b=MJuHiIvMSrZp7L3ZVZQxWe
        n8pvBrt/BKfKNVhBn1b8H0lIJgBMShffQAEFgkWGD8y4XU0uOY4+T+gtq5JyvdL9
        FZDYPwhwEm5d965w3RZW5NVs+4b0dnVoZ/05O8IG6z6YPxN83AYhzN3x8xMVyIRl
        A2hUBKQIbPYqzHIDTkabiIEjiah0Dfejmi3TGcmJNHa/1uE9G/QM1N0oIZNmYfQY
        rjnQkJj5KZbzA9KMHaFz5dy6l+7t0ftQ/9mrloc5dM9S50ZjF7qQHRzEgrpYDNUc
        L/d6gFTgEYSAx9VbPCqydSBKihFeSIlKcjro3yZp1We4WrgItD5fEKErSjJxjLaA
        ==
X-ME-Sender: <xms:uwOUXwT3k9QrhQF7FgC5-dNyhM5NLOjCxfUlNFEZjdDQVppecMCzaQ>
    <xme:uwOUX9zgk-pehnv8zetcyDBqs-jnOpJLYTOlamGHQalnNXFrDrsFCFLcesqVDHmEi
    jt5KIVhn1t4Tg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:uwOUX929LMd4BCenUBnVJvWE50GmA5ygIWFdTTx7bj1MUFrUee8PSA>
    <xmx:uwOUX0DRQPPQpmTvjOJR8ESGTVZh6kYfh345at35W8bdQjKS0TT6HQ>
    <xmx:uwOUX5hc3HH5ecHh25AEkpeWDBRnO-HffzuV-xU1wmPb7esJAJQsOQ>
    <xmx:uwOUX5bE6LYYGsnV4dezgUAFvE9pAb1Y-djUBNYchUgZTM7BkwxHGaVECq0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A5B73280060;
        Sat, 24 Oct 2020 06:36:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam/qi - add support for more XTS key lengths" failed to apply to 5.4-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 12:37:10 +0200
Message-ID: <1603535830177178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 62b9a6690926ee199445b23fd46e6349d9057146 Mon Sep 17 00:00:00 2001
From: Andrei Botila <andrei.botila@nxp.com>
Date: Tue, 22 Sep 2020 19:03:23 +0300
Subject: [PATCH] crypto: caam/qi - add support for more XTS key lengths
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

CAAM accelerator only supports XTS-AES-128 and XTS-AES-256 since
it adheres strictly to the standard. All the other key lengths
are accepted and processed through a fallback as long as they pass
the xts_verify_key() checks.

Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index ee801370c879..30aceaf325d7 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -18,6 +18,7 @@
 #include "qi.h"
 #include "jr.h"
 #include "caamalg_desc.h"
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 /*
@@ -68,6 +69,7 @@ struct caam_ctx {
 	struct device *qidev;
 	spinlock_t lock;	/* Protects multiple init of driver context */
 	struct caam_drv_ctx *drv_ctx[NUM_OP];
+	bool xts_key_fallback;
 	struct crypto_skcipher *fallback;
 };
 
@@ -734,11 +736,15 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	int ret = 0;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(jrdev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
+	if (keylen != 2 * AES_KEYSIZE_128 && keylen != 2 * AES_KEYSIZE_256)
+		ctx->xts_key_fallback = true;
+
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	if (err)
 		return err;
@@ -1402,7 +1408,8 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);

