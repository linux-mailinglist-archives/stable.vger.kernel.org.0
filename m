Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABCB297BE5
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 12:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760997AbgJXKha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 06:37:30 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:50533 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760995AbgJXKha (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 06:37:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3584EA50;
        Sat, 24 Oct 2020 06:37:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 06:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=har2CT
        +wjp1RBJEIFJDsm7lu+HAmd+Rk4LSmhTOLcaU=; b=EhZ2ZWfsgW6M0XOm97hGVw
        Iw9yQHuwOhqtlzyzIf5h1iKeIxvJd1unp95IO4iuHeM3vNCmF5W6LmJ1mWlFNF62
        ddFE3psdu5F7+e/Bu9tmCDwdxK67MXr3FBUf1Wxzr2KcUbvxRO0OYuK6AGIDYjMh
        CI3tgSv2eUIBbtHYta+LroXgHq9wS7zX0nehtQjdXr59Hq6Eg8IuJu88Td7f41gt
        O6XxT3xJ+Hhq+B44j8nEl0Hxy0Yv7Yfhy5FBa4Arp0MGiJq8M6Yf8/PGgo0uQThV
        fiZoahFc8j/ueX/JmoSpvUO2FUihW1r+NSYAR5Wp1HCJsvZCivwpYxyWISteqydA
        ==
X-ME-Sender: <xms:6AOUX3PHdIK3JVg7gcivjHMzTwvLYXIUTyhbFM5BLiNYLTKZT2oeJw>
    <xme:6AOUXx9a5FZvxxWDUKDmJfvnIMYhU6A95g5Xo0XpmlLk5UBL8kCwl4uXG4TdQa0e9
    6HATgl6xJuxzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:6AOUX2SRJhbYQ7eAE9HV9dNYnR_2P4xUwVdZIitJBkEJmGy_uEFKTA>
    <xmx:6AOUX7srHxpmg-mD4SMD4vo4vqRjsu_8X6dH3GOLPAtuWj5x8RHq_g>
    <xmx:6AOUX_dkN9cjnh1IE5s9dZd2vKZWYSmTmXJdbjOrim01W7MN9PsgLw>
    <xmx:6AOUX3HTi0xZfGfB4z-LPpA8P2W2YZ4ma_CvQpSzJcAc0vWk17ALysOcESM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B4743064674;
        Sat, 24 Oct 2020 06:37:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam/jr - add support for more XTS key lengths" failed to apply to 4.19-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 12:38:02 +0200
Message-ID: <160353588239162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From c91f734862664ca86dc3ee7e55f199e2bde829e4 Mon Sep 17 00:00:00 2001
From: Andrei Botila <andrei.botila@nxp.com>
Date: Tue, 22 Sep 2020 19:03:22 +0300
Subject: [PATCH] crypto: caam/jr - add support for more XTS key lengths
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

CAAM accelerator only supports XTS-AES-128 and XTS-AES-256 since
it adheres strictly to the standard. All the other key lengths
are accepted and processed through a fallback as long as they pass
the xts_verify_key() checks.

Fixes: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index adb2c05a8bde..a79b26f84169 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -57,6 +57,7 @@
 #include "key_gen.h"
 #include "caamalg_desc.h"
 #include <crypto/engine.h>
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 /*
@@ -115,6 +116,7 @@ struct caam_ctx {
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
+	bool xts_key_fallback;
 	struct crypto_skcipher *fallback;
 };
 
@@ -835,11 +837,15 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
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
@@ -1784,7 +1790,8 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);

