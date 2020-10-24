Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1ACB297BDB
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 12:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760988AbgJXKgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 06:36:36 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:51419 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760913AbgJXKgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 06:36:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B00CE6A3;
        Sat, 24 Oct 2020 06:36:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 06:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AkuHA8
        halI98s+hltDmTfTohXTGCbA+NONytJPEMAwo=; b=UC9bow9JeoKoHJUDS7dkzc
        Umn+fNiLmiAgSVpi+2ymiiUwMC2BffhDa3zalef+Z3VNPsv0wwKIIbMFGa+PP1FC
        dKIsSKCOt7gSuNOwXUfRoqKZktbhiNDj/HRRmAODcWnhIYfCvAGv4hfxaRMmPIvJ
        EyHk86fEmiPhT0E2C0shAjLeuzLSYl0/Poeo/t4uqqwfpmLRrJYbTrKyxiaLqgS4
        qTT67i5wiXC0c8+n7azHA/3s0/o2Jn+bks6djEM2LbhMw+UvKU7UyG0jxWJUuDtE
        lALeBIhaXzFSJ1KiBcbCCk5OaNHD0FRq5DuTQ6zsy6xxWV1swccVOfHUOm2/yz1Q
        ==
X-ME-Sender: <xms:swOUXzMWWzCXFWrXUsLzZtJ31JHIIMypib-O_DNrhQ7aMO3a-v83bg>
    <xme:swOUX99htGVrJr9oNLpmUoGZH-u7l0DqnFQjyhuLplUAAOw_PxRXOGSeYyHaCRv8P
    j2tZGck4l9MeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:swOUXyResPCyzVGLlztWshEpXVg5eFmqr7FY98VpjpBbRFo4LxYY1g>
    <xmx:swOUX3vZvzVVVUYdDyk2y1ijq9_L4mJF1rNGNgqZY-i7DEWL1Widww>
    <xmx:swOUX7ffu6PpdQ14ArdEwlUUak_fiAot4mgNc98XFjZYP-kUOEWUzw>
    <xmx:swOUXzF57AQ8vKho6wZZjui2I7bkvyHuBXOvDHAgqaOGvv_kfkWfRX4nzpQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D42FE3064610;
        Sat, 24 Oct 2020 06:36:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam/qi - add support for more XTS key lengths" failed to apply to 4.14-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 12:37:09 +0200
Message-ID: <16035358291119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

