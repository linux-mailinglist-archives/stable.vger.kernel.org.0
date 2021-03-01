Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F92327C33
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhCAKbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:31:50 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59679 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234488AbhCAKbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:31:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C7A391940B95;
        Mon,  1 Mar 2021 05:30:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:30:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=C54Kq6
        ct7/DzubbeY/Kx//7sFfeA01FirZMQIUWhKW8=; b=QzY87UlMU21mtMpg7o3piM
        cxlJfaIm00rk/IP+iGQ0wpGbkSUQvG3gPKIWwfHucBELGzoL+emHJdu/fMq5X5ug
        WXkJwWYfxqs1AM/matjzUgGzOXPrkYlJRnU7Lhm/cpiMpb8drK276bAX091Ikf+n
        F176T1ALT2G4s74cX+fbhBy2p90BFBa49ex+PYiP7l6HWEVpUbCNweoeCUGkHgFF
        DTBuh5YtXM19uhXBs/84r1N3v+bT3i+JwT48hBRryj+uhTsgif/xFCMfWoJWAgb7
        NXmtfBmEqYGqherY5HQFEqeGFKCNj/vdlPoERQAeJllB4cOxJGFWD+nir/iSaMmg
        ==
X-ME-Sender: <xms:SsI8YFphLiz4Spm19pknVVVwi8XaaLh7K254XQgqKiabmEnJdL2b_w>
    <xme:SsI8YL86xuM_NQymix9n_1y0i-LvLd2ayODle5__RJjeI91PSRc-iLnbaIkw_vdxg
    CkBR3shhdBh3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:SsI8YBVQ17m1nDfH7Wxx1GwC5PLalmSJsmBvsv6TiIqj0nKiqRyAMg>
    <xmx:SsI8YJDuzU2NkQq19KA7s69UNGUTbJm0dGS8cGxIqgFi5v5gT4z5fQ>
    <xmx:SsI8YKz7QSay2VAZmm--ev5DnH9baKJBbNosXljyLaH8HaKrJBM1lQ>
    <xmx:SsI8YFe5mWnBca4PnP_0TCZWNjKBM_1j4SWhH1YBe9F7KymzSaBD6A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 612FF240057;
        Mon,  1 Mar 2021 05:30:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] crypto: sun4i-ss - IV register does not work on A10 and A13" failed to apply to 4.4-stable tree
To:     clabbe@baylibre.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:30:32 +0100
Message-ID: <161459463261109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b756f1c8fc9d84e3f546d7ffe056c5352f4aab05 Mon Sep 17 00:00:00 2001
From: Corentin Labbe <clabbe@baylibre.com>
Date: Mon, 14 Dec 2020 20:02:27 +0000
Subject: [PATCH] crypto: sun4i-ss - IV register does not work on A10 and A13

Allwinner A10 and A13 SoC have a version of the SS which produce
invalid IV in IVx register.

Instead of adding a variant for those, let's convert SS to produce IV
directly from data.
Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index f49797588329..c7bf731dad7b 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -20,6 +20,7 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct sun4i_cipher_req_ctx *ctx = skcipher_request_ctx(areq);
 	u32 mode = ctx->mode;
+	void *backup_iv = NULL;
 	/* when activating SS, the default FIFO space is SS_RX_DEFAULT(32) */
 	u32 rx_cnt = SS_RX_DEFAULT;
 	u32 tx_cnt = 0;
@@ -42,6 +43,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 		return -EINVAL;
 	}
 
+	if (areq->iv && ivsize > 0 && mode & SS_DECRYPTION) {
+		backup_iv = kzalloc(ivsize, GFP_KERNEL);
+		if (!backup_iv)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
@@ -102,9 +110,12 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	} while (oleft);
 
 	if (areq->iv) {
-		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-			v = readl(ss->base + SS_IV0 + i * 4);
-			*(u32 *)(areq->iv + i * 4) = v;
+		if (mode & SS_DECRYPTION) {
+			memcpy(areq->iv, backup_iv, ivsize);
+			kfree_sensitive(backup_iv);
+		} else {
+			scatterwalk_map_and_copy(areq->iv, areq->dst, areq->cryptlen - ivsize,
+						 ivsize, 0);
 		}
 	}
 
@@ -161,6 +172,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int ileft = areq->cryptlen;
 	unsigned int oleft = areq->cryptlen;
 	unsigned int todo;
+	void *backup_iv = NULL;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo;	/* offset for in and out */
 	unsigned int ob = 0;	/* offset in buf */
@@ -202,6 +214,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	if (need_fallback)
 		return sun4i_ss_cipher_poll_fallback(areq);
 
+	if (areq->iv && ivsize > 0 && mode & SS_DECRYPTION) {
+		backup_iv = kzalloc(ivsize, GFP_KERNEL);
+		if (!backup_iv)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
@@ -322,9 +341,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 		}
 	}
 	if (areq->iv) {
-		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-			v = readl(ss->base + SS_IV0 + i * 4);
-			*(u32 *)(areq->iv + i * 4) = v;
+		if (mode & SS_DECRYPTION) {
+			memcpy(areq->iv, backup_iv, ivsize);
+			kfree_sensitive(backup_iv);
+		} else {
+			scatterwalk_map_and_copy(areq->iv, areq->dst, areq->cryptlen - ivsize,
+						 ivsize, 0);
 		}
 	}
 

