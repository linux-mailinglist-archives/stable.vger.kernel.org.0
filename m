Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C503C3C2C
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGKMT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:19:57 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45947 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:19:57 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 6419F1AC0D1D;
        Sun, 11 Jul 2021 08:17:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 08:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tYmury
        H1Dsm53DHD9VpbqKBSrzy7Zc/+jDPiN0PACQU=; b=Altj3a7AW69LlxsYr5nepA
        ebGCXq1L7uf+WrNd6hJYG4rMre03zlIuDx3zqIG/qVbGrgkVhoF3dKDtjZZQDCQX
        av6aPUjUyGwPA4SGDTRxVMUN9AvQiYoKzdPHnij7P1VlRidOdsru613kDCfkN8am
        ZVQDzWgB314ir2wpMQGZ56PnbUcYQGXiAC4lOqLLpT4Z4iDA2S7AExVXuaD27u1v
        j7jc5QWZAIVIQW0iISpGQvPTIY3m5XzdBUVRUvZuIlEMVnBnTa6yVN757T2Mrf2M
        S9KizfnVvAiyq8IspNleiLCVkNgtwj5nJAohva2saY3Fyv3x6nuL6lh7abZuFg/g
        ==
X-ME-Sender: <xms:ReHqYBAWBvhn1Bz6JrjK1lKi2pXLjRSECqXAJkpZ27dJNlOGPoTpJA>
    <xme:ReHqYPjgH5Ga1tGUzIJIRjVechhcZJeCzDxjFHM7TWtS4lqahsT-Uq9n6EltGWlk5
    xAycVmy9tLFiA>
X-ME-Received: <xmr:ReHqYMnxsdq1gLAA_5Kk-vnBL-Jmgowu96KgsC9K8S1_UGtQcSpN0CI4OPBZajGuSvbyGECoasqZIMHGimKIabunxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ReHqYLz0LXXzpCx05_wuE2WSL8dqjgBwXbnck9HnXTwfICYUMnJEQw>
    <xmx:ReHqYGTgBRDXeM7JwxeWgnozvajCb6SMzgPjxfBnQQsWtChHRbvhbQ>
    <xmx:ReHqYOb-MC-UXkiMyZoBiMU_nKGUjZuPlBPtZLQIGruEyrpSToR2QQ>
    <xmx:RuHqYJJbcOTIGF_F1YbPVwNAJ9tznkmWrV8n05elnXTsU4eEQEgz3-uE6r0>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:17:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: nx - Fix memcpy() over-reading in nonce" failed to apply to 4.14-stable tree
To:     keescook@chromium.org, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:17:03 +0200
Message-ID: <1626005823184244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

