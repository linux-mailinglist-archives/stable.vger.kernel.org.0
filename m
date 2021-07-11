Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6595B3C3C2D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhGKMT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:19:59 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:59399 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:19:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C20161AC0D1D;
        Sun, 11 Jul 2021 08:17:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 11 Jul 2021 08:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eRiLqz
        kgl07BySgUkKDe9egFI2sspvtS5QSIc+q2BmU=; b=ancE+wAbjBSUMJac8HgKI8
        TCNIZroZH/7aMnVbhv215Zl3kmAUc5h7HqmxxEsWNKkFQsThOkznZLxp3SsyBF0Q
        QwJ7k0CdBCvUlka/xcVO0p18mG9rCLotEbpsE3FxHSsbsQmhMe4NKEtoUOJ1yJEu
        mwI0kgcHDzTgU6GM/WWoGV1GZqS82WRJzkLABLy3fmtwPAqmgMofvAFLDRdhWRyg
        99cohh3qkTHMkJbKTuymIGZuwTWrEEtdCyUTtaH8GMTNVHtADhpug/Y8/ugiGhJv
        Pt31nge9O7h2Z9HK7a4mZt+YyIQICQeLFnmG9ZpEZHbr/51bAz/TSe7HyxoG4ALw
        ==
X-ME-Sender: <xms:SOHqYNjuL5cba7oLsZV2kaw1MTdsRb_TpDUmRznoSry1Hzq6-J7XHA>
    <xme:SOHqYCDeFDdBezMK9u_YtN97QuTTRBZRDTeOH3aTEklAk4tb5uIGWoi17XI_AT_FF
    j2xOHEIe9VO0A>
X-ME-Received: <xmr:SOHqYNGrU7BGvcH-L-63rUGmaxrTAcWJ4GPWPoKETw2BgLVs-a_pAag-RtncHnSeyoOtX9JGaf_qKr1TnKadHhdl-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SOHqYCRajScqxMThwR6eMCn-DJ6GtgClG19zE-Ff2dVtFseqEyNomw>
    <xmx:SOHqYKx9n2MUQ21PedOk5PLQcfzg8gvAzSItFCIZRrVNqJwgsCgOZQ>
    <xmx:SOHqYI6mRzlpIuEruXHgqQfOHGD_NrdTxaFisVJJ4-eqbVoI6ix8rA>
    <xmx:SOHqYPoFwGLaX8iCmwFkUPE7DE8N4nPKGWeOHnzufu4m_5Z1ZhPilOfmmgg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:17:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: nx - Fix memcpy() over-reading in nonce" failed to apply to 4.19-stable tree
To:     keescook@chromium.org, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:17:04 +0200
Message-ID: <1626005824188175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

