Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26461A9BC3
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393927AbgDOLH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:07:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34849 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896746AbgDOLHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:07:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D3A1F5C01AF;
        Wed, 15 Apr 2020 07:07:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eHY83M
        5xMzh0xJSTG7VFr7VDQjAVYKtcIWuJE8uZ/Ho=; b=GkO2HO8a8ns0lpTUUM9Kp/
        J9UWiJS2fwYHkPRMqzcbqourVG7pTFiU6xypJPlXKv9WeHrMCPmf/uqV7Lng4gcF
        HRAj2jZfArYsIShgRhUkG6m0xV6gPnkNMec/5fcHuZpK5TZ0ZZImS1jaFkvcspHc
        1PF/f+rUPq1PqzK3GwcbkwJEdxc5wBA7NAQMKQHmDRATY5kC1pEEOAxgMiJqEhYe
        Ca5HY3WHnOFs3dUth79A9SWpHCcTFOS9dz+OtyKLGobRqEcEpA29Q9w16RRALOrV
        Lz9TBwCWMtR70FkC/XKhuysbBZ8tUqf+Nq+Dd4WrWAVyqpnoH/31V6f00XPnZu/g
        ==
X-ME-Sender: <xms:8eqWXruqQTknsRRSCl-oXlYpzBF7aU4PU5bhj2nrSmnevBWJkkTenA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepuddtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8eqWXtDZrj7kNjMHLDhcRLoAEa66i3cDL1r2wa-D69e7RGfh6_WbGw>
    <xmx:8eqWXnrMhUwSeYUhLUox7kydQeDB5r9a0oDti2Lvw4Gxig9RptgvDw>
    <xmx:8eqWXkb4bz-e_QiKhgZXqtfbQO7ekv5yxJYtaWgrqewg2hGr2GzZnA>
    <xmx:8eqWXg-0IlzAjbLA6ixikaRvTFKCq_fdwK_ijSu10PBpmuVw1gzhWg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6EBFD328005E;
        Wed, 15 Apr 2020 07:07:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: ccree - dec auth tag size from cryptlen map" failed to apply to 4.19-stable tree
To:     gilad@benyossef.com, geert+renesas@glider.be,
        herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:07:27 +0200
Message-ID: <1586948847250254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 8962c6d2c2b8ca51b0f188109015b15fc5f4da44 Mon Sep 17 00:00:00 2001
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Sun, 2 Feb 2020 18:19:14 +0200
Subject: [PATCH] crypto: ccree - dec auth tag size from cryptlen map

Remove the auth tag size from cryptlen before mapping the destination
in out-of-place AEAD decryption thus resolving a crash with
extended testmgr tests.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org # v4.19+
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 885347b5b372..954f14bddf1d 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -894,8 +894,12 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 
 	if (req->src != req->dst) {
 		size_for_map = areq_ctx->assoclen + req->cryptlen;
-		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-				authsize : 0;
+
+		if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT)
+			size_for_map += authsize;
+		else
+			size_for_map -= authsize;
+
 		if (is_gcm4543)
 			size_for_map += crypto_aead_ivsize(tfm);
 

