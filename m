Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316BD327C35
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhCAKch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:32:37 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59391 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234251AbhCAKc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:32:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C8BB219406E7;
        Mon,  1 Mar 2021 05:31:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0byPA9
        VBUbfa2LGbjXqYC/ZDI997ot6hUmau/xt+qlI=; b=banmERrh5JGIsCt6JCIyak
        bm1zc6Nj9iMrMH/Lq0wMV71iSYF/gKUMnsKn7ihdnuk0Fr5gwPJXFoJvPe931yjV
        h+fTtqA+yR8uO/Hz3/0ZIt/gswftm3M85ufF7JOgX8szRnDpDFfeWaZFJU/VZRZS
        u55xVpLBe2G4dB4Z4cz9nwsnFr6GaEI7yb9f35IUQgt9WCfcUnilvM1vBuxkX3uw
        VrWWLoN+ilX8NTekQz1LUt2wTOaHV3eRuF4gSIvmNOpS2LMeRrLBz+IODIF/s2oU
        aliaoujol4UX5serFZWiMlF2hamzsQuW2hxZYEiDPs9aEqQZqPEl4SqD6++uiZsA
        ==
X-ME-Sender: <xms:cMI8YLReyJLml0LMR-kU5Qjn4KsK4M9pHXUXTABenO7ub3bkQR46WQ>
    <xme:cMI8YMwmTDJwRE6INv79T0jqAboG33LinRXBI3Pk4551qGvHZzaRy15QEXmQx_AzL
    HgomjwnBNkw_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:cMI8YA0luHhoMfi40W3t6VttvrPxprPlv6lkvCcpHE4uCuaESUK_DA>
    <xmx:cMI8YLDgkIoXMr93HL01Ets_D0TiSlFO8Haj9Wfw1C_qmTw--ybJPA>
    <xmx:cMI8YEiPEShzeDBekCQfelycNph3U2Z9QrHr-e0DRN2G0u6T_BAZcQ>
    <xmx:cMI8YML27YRUZHPwrzRuNGwb5DI-JODKUYmmiizL15eAyZtCFY7xfQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77105240057;
        Mon,  1 Mar 2021 05:31:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] crypto: sun4i-ss - handle BigEndian for cipher" failed to apply to 4.4-stable tree
To:     clabbe@baylibre.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:31:11 +0100
Message-ID: <161459467151197@kroah.com>
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

From 5ab6177fa02df15cd8a02a1f1fb361d2d5d8b946 Mon Sep 17 00:00:00 2001
From: Corentin Labbe <clabbe@baylibre.com>
Date: Mon, 14 Dec 2020 20:02:28 +0000
Subject: [PATCH] crypto: sun4i-ss - handle BigEndian for cipher

Ciphers produce invalid results on BE.
Key and IV need to be written in LE.

Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index c7bf731dad7b..e097f4c3e68f 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writesl(ss->base + SS_IV0 + i * 4, &v, 1);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
@@ -223,13 +223,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writesl(ss->base + SS_IV0 + i * 4, &v, 1);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);

