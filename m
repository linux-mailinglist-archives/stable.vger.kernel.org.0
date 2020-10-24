Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12A2297C78
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 14:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761546AbgJXMsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 08:48:33 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:33055 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1761477AbgJXMsc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 08:48:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 28E5BC70;
        Sat, 24 Oct 2020 08:48:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 08:48:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cmvwPE
        Wki5TNYrcKErgNGQ+TxgucjvCJtxyZwwNH5Cc=; b=iApQqeZKTDDS9B4eAV15Fa
        XEK0T2adfcHms5/5Xz/2e/r4lx6sNeOWCgekwUQe+oYI8276RqRiANWDdOydO6Yo
        dhTRPUfcsRpwC87te9BEpyumyLQ8n7LXKFrn0qFnY1SOQOgZIH3+bmnFiIS0po6I
        FKTUMYnejY/X4C7K1hcE4Qd/MOlK4HOhJyKZ3Yoc+s3+aUJvvrZAtqOVluckjq2T
        YrEZSyUFKu+sN1QSDTSvc+tbKjfzRcDR054fW0PoM10wD0flMO+tBETERt0I5BIo
        k0JUQS7sN4deGcbWBkRNd7m2Qif8Z7ilGM3fGjI7WbITFh4s+0a3lMQ0nDsI7bTw
        ==
X-ME-Sender: <xms:nSKUX8ObqGfxKZK9URi8UKiFXKOLejoAPNuFLxaIMoXEXujDwU1Azg>
    <xme:nSKUXy-gdZg-BPmYZwDIP2jPxmrlOGbidtNpoovJf5-nHPdIIOihJvuKDzkU9v1uK
    m8-vSjzsiIziw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:nSKUXzTGs_whUIko-xs_0kRzRiGOh6Z53-YpG_SztDyZyfLIqy9qHg>
    <xmx:nSKUX0uIcTGL4CJAcYXlDiE3oal8-Hy7mABk8INeGNWyLLnpMnp1BA>
    <xmx:nSKUX0cuMvmqHNp-IujUTpKWtfGCzfYD42XTEULrjMKxJ42hb_BGbg>
    <xmx:niKUXwEyd0bydhe8Y-63RRAN14NJawcnzrQ5zAtTfN1MBiTXCQ4VGPnzwXI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CC353064674;
        Sat, 24 Oct 2020 08:48:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam - add xts check for block length equal to zero" failed to apply to 5.8-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 14:49:03 +0200
Message-ID: <16035437437927@kroah.com>
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

From 297b931c2a3cada230d8b84432ee982fc68cf76a Mon Sep 17 00:00:00 2001
From: Andrei Botila <andrei.botila@nxp.com>
Date: Tue, 22 Sep 2020 19:03:25 +0300
Subject: [PATCH] crypto: caam - add xts check for block length equal to zero
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

XTS should not return succes when dealing with block length equal to zero.
This is different than the rest of the skcipher algorithms.

Fixes: 31bb2f0da1b50 ("crypto: caam - check zero-length input")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a79b26f84169..e72aa3e2e065 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1787,7 +1787,12 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	u32 *desc;
 	int ret = 0;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 30aceaf325d7..efcc7cb050fc 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1405,7 +1405,12 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	int ret;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 255b818c82b2..4cbd7e834888 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1472,7 +1472,12 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	struct caam_request *caam_req = skcipher_request_ctx(req);
 	int ret;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
@@ -1516,7 +1521,12 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	struct caam_request *caam_req = skcipher_request_ctx(req);
 	int ret;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	if (ctx->fallback && (xts_skcipher_ivsize(req) ||

