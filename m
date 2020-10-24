Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4630297BEB
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 12:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755238AbgJXKh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 06:37:58 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:40969 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755236AbgJXKh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 06:37:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 39B3FC26;
        Sat, 24 Oct 2020 06:37:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 06:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wLFy6X
        z24Hj7lIX5MZbCr3ufjv78iYkI9n8Xg5P7kBI=; b=p3Cz7EkZQz0zE64I0PU1mg
        gzHGlJrceYI2Wk3vUxtJPRp80sjCZHmu5HeOlHhwUjtrV+ZkASW67Z+Th8D4H4pD
        R53wFBPtG+IfyO0XUkyECWdjdChsUz0bpiW7ZFnZFDeDVBELOPO1zmkQzHJx6j5B
        dpCoksO3RWsKqSK9bAKnc4bzHQTP/dXqiHLcpvQXfKEYwm1Cg7MBOhITO+yeZ2ft
        zXa2cneAc0G12h4mcpFk7VdMZbyF8B+qbhhA1BSwCuChBqRaPiVprz33de9RboYT
        Vc/LPUYQh/YUXOZBj9n/eFeHoLwj+AF2b2q+Wy55q0w6mHaEYBFDWIyGCCdy/e7g
        ==
X-ME-Sender: <xms:BASUX7vo9FkPPiNbBqqOh6R9ouIkdzUPufInTverZ-6TiRlZ7p7Bzg>
    <xme:BASUX8c1uVQi78VW-dNolX7jOXdBSTFeIScG44VLXcAkiIawgmZYhaVW6CYiFch3b
    eisuvb_wJ0qAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedutdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:BASUX-wHAZYS_JxRhmgKuw2hTzZlm9XdXDkGLpPX1jJ2G_k_Eq6NLg>
    <xmx:BASUX6PTAQZu7C1jrkcUexsSAvSX2iZlHx5mNxGM0_YVDnpBMipEAA>
    <xmx:BASUX79Sc-OBXHmNbxRzqFLjullGKJ5j5mK5reTmSFD7ZCNsOSRIZg>
    <xmx:BASUX1mQlNcnJYNK1xLKQl-JlnkHl4XjEnSQOynVQqaOnDe_k8ljUy4wixE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B6AD3064680;
        Sat, 24 Oct 2020 06:37:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam/qi2 - add fallback for XTS with more than 8B IV" failed to apply to 5.4-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 12:38:23 +0200
Message-ID: <1603535903182202@kroah.com>
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

From 36e2d7cfdcf17b6126863d884d4200191e922524 Mon Sep 17 00:00:00 2001
From: Andrei Botila <andrei.botila@nxp.com>
Date: Tue, 22 Sep 2020 19:03:21 +0300
Subject: [PATCH] crypto: caam/qi2 - add fallback for XTS with more than 8B IV
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A hardware limitation exists for CAAM until Era 9 which restricts
the accelerator to IVs with only 8 bytes. When CAAM has a lower era
a fallback is necessary to process 16 bytes IV.

Fixes: 226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 8169e6cd04e6..84ea7cba5ee5 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -167,6 +167,7 @@ config CRYPTO_DEV_FSL_DPAA2_CAAM
 	select CRYPTO_AEAD
 	select CRYPTO_HASH
 	select CRYPTO_DES
+	select CRYPTO_XTS
 	help
 	  CAAM driver for QorIQ Data Path Acceleration Architecture 2.
 	  It handles DPSECI DPAA2 objects that sit on the Management Complex
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 076c6b04bea9..c36d11820db3 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -19,6 +19,7 @@
 #include <linux/fsl/mc.h>
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
+#include <asm/unaligned.h>
 
 #define CAAM_CRA_PRIORITY	2000
 
@@ -80,6 +81,7 @@ struct caam_ctx {
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
+	struct crypto_skcipher *fallback;
 };
 
 static void *dpaa2_caam_iova_to_virt(struct dpaa2_caam_priv *priv,
@@ -1056,12 +1058,17 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	struct device *dev = ctx->dev;
 	struct caam_flc *flc;
 	u32 *desc;
+	int err;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
 		dev_dbg(dev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
+	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	if (err)
+		return err;
+
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
@@ -1443,6 +1450,14 @@ static void skcipher_decrypt_done(void *cbk_ctx, u32 status)
 	skcipher_request_complete(req, ecode);
 }
 
+static inline bool xts_skcipher_ivsize(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+
+	return !!get_unaligned((u64 *)(req->iv + (ivsize / 2)));
+}
+
 static int skcipher_encrypt(struct skcipher_request *req)
 {
 	struct skcipher_edesc *edesc;
@@ -1454,6 +1469,18 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
+	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
+		skcipher_request_set_callback(&caam_req->fallback_req,
+					      req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(&caam_req->fallback_req, req->src,
+					   req->dst, req->cryptlen, req->iv);
+
+		return crypto_skcipher_encrypt(&caam_req->fallback_req);
+	}
+
 	/* allocate extended descriptor */
 	edesc = skcipher_edesc_alloc(req);
 	if (IS_ERR(edesc))
@@ -1484,6 +1511,19 @@ static int skcipher_decrypt(struct skcipher_request *req)
 
 	if (!req->cryptlen)
 		return 0;
+
+	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
+		skcipher_request_set_callback(&caam_req->fallback_req,
+					      req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(&caam_req->fallback_req, req->src,
+					   req->dst, req->cryptlen, req->iv);
+
+		return crypto_skcipher_decrypt(&caam_req->fallback_req);
+	}
+
 	/* allocate extended descriptor */
 	edesc = skcipher_edesc_alloc(req);
 	if (IS_ERR(edesc))
@@ -1537,9 +1577,34 @@ static int caam_cra_init_skcipher(struct crypto_skcipher *tfm)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct caam_skcipher_alg *caam_alg =
 		container_of(alg, typeof(*caam_alg), skcipher);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
+	int ret = 0;
+
+	if (alg_aai == OP_ALG_AAI_XTS) {
+		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
+		struct crypto_skcipher *fallback;
+
+		fallback = crypto_alloc_skcipher(tfm_name, 0,
+						 CRYPTO_ALG_NEED_FALLBACK);
+		if (IS_ERR(fallback)) {
+			dev_err(ctx->dev, "Failed to allocate %s fallback: %ld\n",
+				tfm_name, PTR_ERR(fallback));
+			return PTR_ERR(fallback);
+		}
+
+		ctx->fallback = fallback;
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request) +
+					    crypto_skcipher_reqsize(fallback));
+	} else {
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request));
+	}
 
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request));
-	return caam_cra_init(crypto_skcipher_ctx(tfm), &caam_alg->caam, false);
+	ret = caam_cra_init(ctx, &caam_alg->caam, false);
+	if (ret && ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+
+	return ret;
 }
 
 static int caam_cra_init_aead(struct crypto_aead *tfm)
@@ -1562,7 +1627,11 @@ static void caam_exit_common(struct caam_ctx *ctx)
 
 static void caam_cra_exit(struct crypto_skcipher *tfm)
 {
-	caam_exit_common(crypto_skcipher_ctx(tfm));
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+	caam_exit_common(ctx);
 }
 
 static void caam_cra_exit_aead(struct crypto_aead *tfm)
@@ -1665,6 +1734,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam-qi2",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -2912,8 +2982,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init_skcipher;
 	alg->exit = caam_cra_exit;
diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamalg_qi2.h
index f29cb7bd7dd3..d35253407ade 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -13,6 +13,7 @@
 #include <linux/netdevice.h>
 #include "dpseci.h"
 #include "desc_constr.h"
+#include <crypto/skcipher.h>
 
 #define DPAA2_CAAM_STORE_SIZE	16
 /* NAPI weight *must* be a multiple of the store size. */
@@ -186,6 +187,7 @@ struct caam_request {
 	void (*cbk)(void *ctx, u32 err);
 	void *ctx;
 	void *edesc;
+	struct skcipher_request fallback_req;
 };
 
 /**

