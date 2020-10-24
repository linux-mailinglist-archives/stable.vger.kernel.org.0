Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F3E297BE4
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 12:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760996AbgJXKh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 06:37:29 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:36905 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760995AbgJXKh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 06:37:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B6A4B607;
        Sat, 24 Oct 2020 06:37:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 06:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=grk92e
        i/nRHsmFdNg7JFf4g5MXM2Awz8mGLyx/LIw1Y=; b=fRUoburhKZfBindnak5w9l
        WUPXThg20CAKeF4CFpWzviBJHV8tW9w7pNUq2FGkb+up8f9317gFA9abZjJM9Fgs
        Nv96eESatM6wERRf/9PyR+PIEusWUBrqFWgJnJUyiZB72W+cPItRmChF6VoSsA5m
        YsGO8K+TRVTT6bkuffemBC6ANQG6dRWxqfOUalzEHKVAytH+VqFqt8u2mii72LXm
        f1DiewVyowTLZ2LFY1HG0LAChQppGT/3kTeec6g+UR2o1e4W3eDs/2mcc6TWzCvd
        Qko++3OGokT2JPgq8Jp7p+wgSQiqZIqisoe0WYcJoqOrAPjlmn0ChENZEfJfc8WA
        ==
X-ME-Sender: <xms:5wOUX-N_lgmNKhCobqmmHIjl-riTZLs_mLow418fXfGowUo0FfTqhA>
    <xme:5wOUX8-BNFOnGcac0C0qyzlNDf1kjqJl28EQVgHJJ7f7NlnrVlV2zG7OdhdDBD3kh
    R2oahCBB3s0HQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:5wOUX1SXL75N3PsJ-4gKzG0HPNYnQx_UqLiIWJqRKuyZyRwZj1UcVg>
    <xmx:5wOUX-tSjFpIEtc9SUKE7o0R2lqr9AeqlTnYEIZwJuLx1zCBkiXwHA>
    <xmx:5wOUX2c0Jhcg2MooEYwAZUlI4A4SLP8qA6ly3sCNikAytoEgIikT8w>
    <xmx:5wOUX6Gw5N_3SzfKyfwsX8DN24rzT-vtwsvJvTR-6Ex3UG6WzQpnuP6syzU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DAF1E328005D;
        Sat, 24 Oct 2020 06:37:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam/jr - add support for more XTS key lengths" failed to apply to 5.8-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 12:38:01 +0200
Message-ID: <160353588112059@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
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

