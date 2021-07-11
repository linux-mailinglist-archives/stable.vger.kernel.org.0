Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7A33C3C2A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhGKMTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:19:50 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41961 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:19:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 7E1FD1AC0D21;
        Sun, 11 Jul 2021 08:17:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 11 Jul 2021 08:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4SukoA
        fmu4inGVVOiSOHUezKZbdi1WWT2W50XDH73iA=; b=EYs9VllI1xActsinbqbnV6
        mp9xJUgpZsH3bA5r1trShInI3GbCHUevq+ScTmoK4+CK50u+52WEkQzh6FkcvJqz
        MCITmsl30+ZgptG46jH1uSor5KYNNMRIX2OIk691b8q+q2gZguThVpdrtdMRrTuE
        3a+vc3wJ8/CmucupQl1WuVr39AfLPpaUKj7Gv4Do/2O/WrsqQaJQRBY3itxuB+Y2
        WqoWACBhO2Kw5h0oamD5Oj695m79Vq7L7oj5pgqEKKF+n6GWG1uOBUrA9LhpEz9+
        hbGAI5xhHB7ET+32DlZYOyWchY/RXAx9MQ0gqTSA5r7UKhkzfhd3xhxaWCjVOzGg
        ==
X-ME-Sender: <xms:PeHqYA9Ur3v4zZV6SryOIEn92z-6JloNtGm2OLO3x1XhAUb1NoRM5Q>
    <xme:PeHqYItg9vZjsX0uAlaG49vWnRtQX93z3zkQEbl77g77cXugH4kbSfdxzzn39irkE
    foodBr7dpiIcA>
X-ME-Received: <xmr:PeHqYGBVKAMXOb23E_ZfjAGJ-0c0CBnELZTzr2pJEV_gJlOj5CDNgbpATGtpO_FmopszTkXelSEvthBMcKRKHmkFug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PeHqYAcGRM71VEa9xxyOmUAR12tyyPtOAZ1R3n8quKV0KsGUBobkKQ>
    <xmx:PeHqYFOfGM2Y6OahWT89fp3nuehdlUc_nfyz6xwY-UPxcJeIrEFUKA>
    <xmx:PeHqYKkEC84m8cWLb_ObiE3KzDfOc127IpZB0R6oZgDTvToYu03CBA>
    <xmx:P-HqYD0r3SmdI_2350bX8tRpL5JwIfPQdjl_yr7DYd4ygrt-vYMQgX5PXtg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:17:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: nx - Fix memcpy() over-reading in nonce" failed to apply to 4.4-stable tree
To:     keescook@chromium.org, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:17:00 +0200
Message-ID: <16260058201165@kroah.com>
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

