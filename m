Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835AC3C3C2E
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhGKMUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:20:05 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51293 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232710AbhGKMUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:20:03 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id ABCE01AC0D1D;
        Sun, 11 Jul 2021 08:17:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 08:17:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6Ig4RT
        c+C8dKI8TtfyhUTYdy4HesmxvjKgFpE0vPPao=; b=vuNPLKfPuEBLx9H4KGGGdg
        vl29zIYF60LsmpvJt4vPWpAFewqwZZMiee8Jxlwej+d8JK6Ba+AIRwCoZlWn0Dwn
        4XIE2BRKzYdsCjdJX9k0KRtmPm6TGNkZMKp7ut/F2Qw9jGDjJ9/RviLXeOVZUNqY
        GyR5t4U3ZuajJWspVz8jpbOushanT8itS9CvLXa5LpH28F2RGaGc++A2Hqo0k4aA
        Fa3c2sMDQ5ZLEeI4jDMPSBj6hyi+uQDIg95id6oOSG0rCSgb4OD7OYzu/mrTeuIh
        3B1+rMqB/KB1YDcIAiaKBO005h7C9YWRrnCXBQMxvJ0UW5jppYNaVBWLUqlxxM3g
        ==
X-ME-Sender: <xms:TOHqYGjwIuqoZTYvnnBLYCyIPosSRTFHftYl0CKq3XyhiB-nO-OhLw>
    <xme:TOHqYHDosywXNC3B_hnOXNE2w5C2ETCeAJVSjPBhwNvc1GTsFl_73fEUMYrxFrmoo
    kTkMOah-j5aTQ>
X-ME-Received: <xmr:TOHqYOHvDgqlrI0ZH7u-lgwUx9wVfzBVe7y1E0LwH3WDCa19KWwP1U9lFzG5ziWEj7P1hfi4n9aC_K557jMW35gJUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TOHqYPS0LzqCQH45-kfY2n_-Q4ubMc3UKkBnz2BlMP7rs04BRyx9aA>
    <xmx:TOHqYDwIF0g6ZlULpApSVDslpG7PZyI_5MHi7egJHVNceYwmI_7gFA>
    <xmx:TOHqYN4Fa4M3Skrxk1-vgx0UsI1bNvOKF1OZxpu60Lj7KHA51-nyGg>
    <xmx:TOHqYMrqJPCwTheVJGnlN2siHt_xoUocVjC1bUBlroz7UhJzNzmVOkWh9pI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:17:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: nx - Fix memcpy() over-reading in nonce" failed to apply to 5.4-stable tree
To:     keescook@chromium.org, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:17:06 +0200
Message-ID: <1626005826161102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 74c66120fda6596ad57f41e1607b3a5d51ca143d Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Wed, 16 Jun 2021 13:34:59 -0700
Subject: [PATCH] crypto: nx - Fix memcpy() over-reading in nonce

Fix typo in memcpy() where size should be CTR_RFC3686_NONCE_SIZE.

Fixes: 030f4e968741 ("crypto: nx - Fix reentrancy bugs")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
index 13f518802343..6120e350ff71 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -118,7 +118,7 @@ static int ctr3686_aes_nx_crypt(struct skcipher_request *req)
 	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 	u8 iv[16];
 
-	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_IV_SIZE);
+	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_NONCE_SIZE);
 	memcpy(iv + CTR_RFC3686_NONCE_SIZE, req->iv, CTR_RFC3686_IV_SIZE);
 	iv[12] = iv[13] = iv[14] = 0;
 	iv[15] = 1;

