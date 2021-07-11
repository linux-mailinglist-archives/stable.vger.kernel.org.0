Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21B43C3C2B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhGKMTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:19:54 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:46827 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:19:54 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id E8A261AC0D1D;
        Sun, 11 Jul 2021 08:17:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 08:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kZkMQu
        /x2SAzJ1VAA4ZSK+MQxBhIbSx6tQHOEOXsc6A=; b=hqSBIhvkLMeqBGnG/KiPEm
        tsdZuHN62gO83b8pxQ8KnObS+xXsZ5MjIwdotTaJPCM4Eh3I8+aYYHY7cIhz88qr
        4VH88hfxDRLs1kglG4XuwswBuUZrMZqodVe6nHtWzDRKKmcaqhhXHe6nqxIePGv4
        jG8p7Hc/Pw3KeHVnNP1KwOdy5iRx/ESNfDjEHyP5tsBFItiLY2Nr+XBvJer9dvGj
        fwhhtd9kwLCoDod5t6vHefWPh3uEUsbE3pF51gt2D/3lnPDzt5QOTtJZGWMDZ5q7
        W+B7sea/t6xvS+vHahrv83JLRepKFO9eZg6+qCic2/o2Mo1MgLEt05gziYEMEYkA
        ==
X-ME-Sender: <xms:QuHqYMLpv2UIiOsR8hF5VoVA7tH92_z5sLsMixHgv8JycNOtC5IuFQ>
    <xme:QuHqYMLviMGQnPiWqQnSE5Mjv05CDWJNXpFdV1QdV0FBqMgeI_Pa3ypUYR9fPro5s
    vOZRgkUve9yyg>
X-ME-Received: <xmr:QuHqYMu57qjjp60xV_6DLwW9Lzrhf7ZTr6WHoj80sX7OH32DvlcpXv5EV0uqD-0ab9ezp3LvAK8lDoN84kNpdFAHxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QuHqYJbpmP7fhOsOSRfCVZepg8K3VY5tk9cRPMkTbuaGps4EL2qIbw>
    <xmx:QuHqYDb9g296_-Jcmyg7Rav961QMxPkm5VBBC09UXNgQuMK5DC52VA>
    <xmx:QuHqYFDwX9MLrhLh4Kqm8oHYepK-P2eyXj1gRPk745USGh6_K9kuhg>
    <xmx:Q-HqYKxRz9K6gT2PO1DeInLHYzWZ3tUxMEucwcjxzPQqMAhTUYvQHLmiOZc>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:17:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: nx - Fix memcpy() over-reading in nonce" failed to apply to 4.9-stable tree
To:     keescook@chromium.org, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:17:01 +0200
Message-ID: <162600582161223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

