Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D601A9BBD
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896745AbgDOLGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:06:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41291 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896746AbgDOLG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:06:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 8C12B5C01A7;
        Wed, 15 Apr 2020 07:06:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:06:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uVYwqU
        q7i8tXJD+Ex19gBpJJNbUgtkN7LyFnHCa+V58=; b=0yErcibjVxa2juNBtFZCLx
        aoDbwqLqeq98gxpm1N9LkQGtg7bXK+BjRYJbu7eaGMNMmFA5yWLVnSzTUuyfCprW
        KTuq5E+Ra7a3sqk2hYJVzfe9afo62jmjuytwWNFd4F5cJmoWgskzCwRtaSS2k6Dx
        UqM0z6RlmP+5xbE2zz0UbWXGbI2byZswnbwOel9vVgCx6fMRNCVsK6ZYatee2d5S
        kdk0J4aVFslnVZy9BEkRLNRLSnvkfirbnrQIqU6bdCmX5bpIsuYriNIcZZQKULsO
        fhbX0neQi3/CfE6GU3IXT1Yq7lRNkJUP6brWjFv0RQ9yGYyBgLswF1nSsoj/oZ3g
        ==
X-ME-Sender: <xms:tOqWXlAgX8-Dg7XKw3fig5iVWSvt_shGltXx5DnPHbgjPvA88HvFSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tOqWXvPLc8ppRXMy_McVzhfXoUcDoxjSdQId7VmymsilARo4Tp65HA>
    <xmx:tOqWXgW_sLhBCk4-rEQlmACEVbTudBVwLw17SDlj8g8R7KXa1VQjvg>
    <xmx:tOqWXi_TISYvkbYJLrNX2L5BoexD3hAW2WO_OnSljZhLPOJX0BkN-A>
    <xmx:tOqWXlZ5rMwGfbMMyunkbZLQ6mmw7_fyGm2Q7GP2STBG0zBWbaDoxA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2AEB83060057;
        Wed, 15 Apr 2020 07:06:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam - update xts sector size for large input length" failed to apply to 4.19-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:06:17 +0200
Message-ID: <1586948777215114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 3f142b6a7b573bde6cff926f246da05652c61eb4 Mon Sep 17 00:00:00 2001
From: Andrei Botila <andrei.botila@nxp.com>
Date: Fri, 28 Feb 2020 12:46:48 +0200
Subject: [PATCH] crypto: caam - update xts sector size for large input length
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since in the software implementation of XTS-AES there is
no notion of sector every input length is processed the same way.
CAAM implementation has the notion of sector which causes different
results between the software implementation and the one in CAAM
for input lengths bigger than 512 bytes.
Increase sector size to maximum value on 16 bits.

Fixes: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 6171a8118b5a..d6c58184bb57 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1524,7 +1524,13 @@ EXPORT_SYMBOL(cnstr_shdsc_skcipher_decap);
  */
 void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cdata)
 {
-	__be64 sector_size = cpu_to_be64(512);
+	/*
+	 * Set sector size to a big value, practically disabling
+	 * sector size segmentation in xts implementation. We cannot
+	 * take full advantage of this HW feature with existing
+	 * crypto API / dm-crypt SW architecture.
+	 */
+	__be64 sector_size = cpu_to_be64(BIT(15));
 	u32 *key_jump_cmd;
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
@@ -1577,7 +1583,13 @@ EXPORT_SYMBOL(cnstr_shdsc_xts_skcipher_encap);
  */
 void cnstr_shdsc_xts_skcipher_decap(u32 * const desc, struct alginfo *cdata)
 {
-	__be64 sector_size = cpu_to_be64(512);
+	/*
+	 * Set sector size to a big value, practically disabling
+	 * sector size segmentation in xts implementation. We cannot
+	 * take full advantage of this HW feature with existing
+	 * crypto API / dm-crypt SW architecture.
+	 */
+	__be64 sector_size = cpu_to_be64(BIT(15));
 	u32 *key_jump_cmd;
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);

