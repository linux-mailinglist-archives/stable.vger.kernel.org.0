Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503DC297BEC
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 12:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761001AbgJXKiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 06:38:04 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:60643 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760995AbgJXKiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 06:38:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4F0A8B26;
        Sat, 24 Oct 2020 06:38:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 06:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hRBWk4
        BYAmQUxksujPxmg9BcfCq06BthT0tsx436b6k=; b=HX2H/RONEnfjMZyVNzUH9w
        dTtINbxHh17WwGUZxWzXGO4GJfBQPvf41uHSmcdad9Ksbjf5g1GdSgs5A7ylLGYW
        tKbjfaBQvfhtZVfrDlUJ0jKW/AlvK8HYjFArQul+oqmOz1wo1ObRq1rgH/6T5uyP
        8pqk4yt1KAKrsrMpCNJFGInHPqCpUcAk41e5QOr1NCGwh1qw9lqsICq2gTwxxWjH
        xupKQHDhlZe/4M04xvn2rBQwRlrLT1LtYVXa5rTl1QDodxfPktdQnfsAPA2Z4tzR
        r92NUA+Ztyps5ht1XkiOoIc/y3RcLg7ue93LTDnhimNSVz6M10ccNB4lQ9p1H86g
        ==
X-ME-Sender: <xms:CgSUX4RpY0X88FQTXmJkznhq1ExGawwUs4wCHzjiuXwxIVA6GU3Tqw>
    <xme:CgSUX1yhxuH1dS4DOG35N6N9NSG1NDRW8k11TmpGFdUiQZ7QCQ-QRxBAkF-xFYSTh
    RFMkmGMlmVgfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeduudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:CgSUX120uxY3l1BFVrcU-h5lJtXL3eIbBPmCBNowWWn_pIlPaNohPA>
    <xmx:CgSUX8DFloJySV90w2EcifAtMd1-FOKKnhN2vgTnTsEDTbn5XKQOaA>
    <xmx:CgSUXxh3IBn0yI_TqKN5_B9f6CCyL0rU17m-u6vn1rO5QVlRiGAQTA>
    <xmx:CgSUXxbJWGr8k57XliIy3qa1WRDZksnWB_Dk4W7NJ4jKJZSMsLsvNyTemfA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6CE97328005E;
        Sat, 24 Oct 2020 06:38:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam/qi2 - add support for more XTS key lengths" failed to apply to 5.8-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 12:38:37 +0200
Message-ID: <160353591714690@kroah.com>
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

