Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C722D297BED
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 12:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755245AbgJXKiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 06:38:14 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:51429 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755082AbgJXKiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 06:38:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5F109BF9;
        Sat, 24 Oct 2020 06:38:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 06:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kNeGY7
        q5prSix1hnCNGOoA3LNW6ruo20WYubmD0S1eY=; b=I6EmD5DTm/Xgt0BecxMfrv
        hFnvvbDLmER/MmyS5xnhn00c2TJFZYebiufNCKY1oJvh1JcLQvWn3E1SHI2mZpGe
        g+NxnC+7q8zPwgQbLw8RnZ/GrPwE77+0JFyqV95Gx0L/kSJf1Fdk5ZS8Oe7Rzx33
        yS9VBnylioApMj+CCu243LsAQmo8+vsNx6BcDo2gPWfUo+m8uMppFKBMxaGrKeJU
        UrJWl5hrkXdeUYMG674D+am9Nw6gg6YzfHWOqGke9vh1X9R3Sg2x0Os340k710Hj
        opAFKUXm31VgDx8yPgpx2iMmXVMjK0lKZ+kJ/mZJvC+kVdR/Qg1IPYcW3g0m8yTg
        ==
X-ME-Sender: <xms:EwSUX0r7pF9GLkq9KwvuY5pIvfLFyv8zZsHizP3UOvjLlu63vamWlA>
    <xme:EwSUX6qWMQ8-R8MHtNmLr9PJn11PVLAXZOg7OzhcgU1HRS74ULU5kuYJTNVndf5DP
    1Ze-Yq7q13JwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeduvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:EwSUX5M6kk0jxbz2i3_gYSY8JsazsG5MCkxrIGNLYHqnlYUXYf9TxQ>
    <xmx:EwSUX75uSiYw8hA2iYCCnfULtyaTzo2gjYWM-z-DfdQOG-69h_H6ew>
    <xmx:EwSUXz6fm0SAioxaIVjOuqbw6dBx2SvxTZx2LCl2j-XWILDISd5wZw>
    <xmx:FASUX9RTLUmGm77q7ir-wSb4TAM3KBQYGzlWIEFpcF_EdGqvLkLraDsvIow>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B5FA3064674;
        Sat, 24 Oct 2020 06:38:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam/qi2 - add support for more XTS key lengths" failed to apply to 5.4-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 12:38:37 +0200
Message-ID: <160353591713330@kroah.com>
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

From 596efd57cfa1e1bee575e2a2df44fd8ec5e4a42d Mon Sep 17 00:00:00 2001
From: Andrei Botila <andrei.botila@nxp.com>
Date: Tue, 22 Sep 2020 19:03:24 +0300
Subject: [PATCH] crypto: caam/qi2 - add support for more XTS key lengths
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

CAAM accelerator only supports XTS-AES-128 and XTS-AES-256 since
it adheres strictly to the standard. All the other key lengths
are accepted and processed through a fallback as long as they pass
the xts_verify_key() checks.

Fixes: 226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index c36d11820db3..255b818c82b2 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -19,6 +19,7 @@
 #include <linux/fsl/mc.h>
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 #define CAAM_CRA_PRIORITY	2000
@@ -81,6 +82,7 @@ struct caam_ctx {
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
+	bool xts_key_fallback;
 	struct crypto_skcipher *fallback;
 };
 
@@ -1060,11 +1062,15 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(dev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
+	if (keylen != 2 * AES_KEYSIZE_128 && keylen != 2 * AES_KEYSIZE_256)
+		ctx->xts_key_fallback = true;
+
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	if (err)
 		return err;
@@ -1469,7 +1475,8 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
 					      req->base.flags,
@@ -1512,7 +1519,8 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
 					      req->base.flags,

