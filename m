Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EAC297BDE
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 12:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760992AbgJXKhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 06:37:09 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:34955 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760913AbgJXKhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 06:37:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 96D356A3;
        Sat, 24 Oct 2020 06:37:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 06:37:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=URoSFz
        qwOMswT0fkP3ABlOjBPENsOdcwlemFNjE7mHg=; b=BC3g5CCP5zYMs6cWuHodDA
        UQvPYNAkcDBDt6cvtS4sUoWNPv9dxVIEVrEZQDwlr2tCwrxrMh2tEZchjt8x87mL
        ON1eJgnLSKcx7azCsA+BCaZvl6Py8SYXmHi/MIUeP6vvOuRKEGDreBNzk4AZvK8k
        /PlUNEJkYyChnm1H1wxD7sPmV3dt2yXTcdPYRlaiymG26KeT27MSJpHgwYrSoA8i
        CT1vbWs0SCZjva2sLbyXwP2LSbFyD7CoicbQzIg7wseJx9GVn0mLQ3cDJvXc1lGI
        jH5BzR0IsM3wsSTL/sVTfe+z7lMiI42P5fAjmYeEI3rt+hrLzQMbL3VQ/Hy6c70Q
        ==
X-ME-Sender: <xms:1AOUX3s4VIlRO8Oe0yK5tCNAO-7OvoQVY7qPa_MczIErP6kZV7FyNQ>
    <xme:1AOUX4eq9CaBR040suhKnb8LWg-Fdm4cb2SSIGIFI2mcyuXl3-WkUilLgMKng1IiI
    uicf2_8B8lp7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeetffffleevkeffteehtedvudetgfekhefhfedvtdfgue
    fhjedtjeethfffkefhjeenucffohhmrghinhepohhprdguohenucfkphepkeefrdekiedr
    jeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1AOUX6w9NqV11pMaBuvgv730eaey1tXlymHBBQ_Ngb1PYLQk6WGIjQ>
    <xmx:1AOUX2M29Fo8U3BegVrrvxXWTPj56A0TQH3tS6m0Yf45M3Qbm1EcMg>
    <xmx:1AOUX3_eX1zk3Aaay4cqvWcQ_xJQhTOsGEvFLLTV8Iz3SpLUW7fv5w>
    <xmx:1AOUXxmL6NtbymX8kCLdeBn4-XlGLDK5qPIqxHgOn6CiAbGETMdPVShoB5k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCDF3328005D;
        Sat, 24 Oct 2020 06:37:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam/jr - add fallback for XTS with more than 8B IV" failed to apply to 5.8-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 12:37:42 +0200
Message-ID: <16035358621471@kroah.com>
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

From 9d9b14dbe077c8704d8c3546e38820d35aff2d35 Mon Sep 17 00:00:00 2001
From: Andrei Botila <andrei.botila@nxp.com>
Date: Tue, 22 Sep 2020 19:03:19 +0300
Subject: [PATCH] crypto: caam/jr - add fallback for XTS with more than 8B IV
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A hardware limitation exists for CAAM until Era 9 which restricts
the accelerator to IVs with only 8 bytes. When CAAM has a lower era
a fallback is necessary to process 16 bytes IV.

Fixes: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index bc35aa0ec07a..dfeaad8dfe81 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -101,6 +101,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 	select CRYPTO_AUTHENC
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
+	select CRYPTO_XTS
 	help
 	  Selecting this will offload crypto for users of the
 	  scatterlist crypto API (such as the linux native IPSec
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 91feda5b63f6..adb2c05a8bde 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -57,6 +57,7 @@
 #include "key_gen.h"
 #include "caamalg_desc.h"
 #include <crypto/engine.h>
+#include <asm/unaligned.h>
 
 /*
  * crypto alg
@@ -114,10 +115,12 @@ struct caam_ctx {
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
+	struct crypto_skcipher *fallback;
 };
 
 struct caam_skcipher_req_ctx {
 	struct skcipher_edesc *edesc;
+	struct skcipher_request fallback_req;
 };
 
 struct caam_aead_req_ctx {
@@ -830,12 +833,17 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	u32 *desc;
+	int err;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
 		dev_dbg(jrdev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
+	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	if (err)
+		return err;
+
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
@@ -1755,6 +1763,14 @@ static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)
 	return ret;
 }
 
+static inline bool xts_skcipher_ivsize(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+
+	return !!get_unaligned((u64 *)(req->iv + (ivsize / 2)));
+}
+
 static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 {
 	struct skcipher_edesc *edesc;
@@ -1768,6 +1784,21 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
+	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
+
+		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
+		skcipher_request_set_callback(&rctx->fallback_req,
+					      req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
+					   req->dst, req->cryptlen, req->iv);
+
+		return encrypt ? crypto_skcipher_encrypt(&rctx->fallback_req) :
+				 crypto_skcipher_decrypt(&rctx->fallback_req);
+	}
+
 	/* allocate extended descriptor */
 	edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
@@ -1905,6 +1936,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -3344,13 +3376,35 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 	struct caam_skcipher_alg *caam_alg =
 		container_of(alg, typeof(*caam_alg), skcipher);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
+	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
+	int ret = 0;
 
 	ctx->enginectx.op.do_one_request = skcipher_do_one_req;
 
-	return caam_init_common(crypto_skcipher_ctx(tfm), &caam_alg->caam,
-				false);
+	if (alg_aai == OP_ALG_AAI_XTS) {
+		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
+		struct crypto_skcipher *fallback;
+
+		fallback = crypto_alloc_skcipher(tfm_name, 0,
+						 CRYPTO_ALG_NEED_FALLBACK);
+		if (IS_ERR(fallback)) {
+			dev_err(ctx->jrdev, "Failed to allocate %s fallback: %ld\n",
+				tfm_name, PTR_ERR(fallback));
+			return PTR_ERR(fallback);
+		}
+
+		ctx->fallback = fallback;
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx) +
+					    crypto_skcipher_reqsize(fallback));
+	} else {
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
+	}
+
+	ret = caam_init_common(ctx, &caam_alg->caam, false);
+	if (ret && ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+
+	return ret;
 }
 
 static int caam_aead_init(struct crypto_aead *tfm)
@@ -3378,7 +3432,11 @@ static void caam_exit_common(struct caam_ctx *ctx)
 
 static void caam_cra_exit(struct crypto_skcipher *tfm)
 {
-	caam_exit_common(crypto_skcipher_ctx(tfm));
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+	caam_exit_common(ctx);
 }
 
 static void caam_aead_exit(struct crypto_aead *tfm)
@@ -3412,8 +3470,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;

