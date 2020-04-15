Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF11A9BBA
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896744AbgDOLGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:06:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58245 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896743AbgDOLGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:06:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 012BC5C0145;
        Wed, 15 Apr 2020 07:06:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TTb6Zn
        3A7fGKsHBZEm8rReawoGkBlZN3t0usYQH9oEU=; b=AfhrnTnkMrBJFSJfmGr7nv
        dRsmMVKzpH3nv1zX6B/DJfz2aqJjduYSQvCMKPcyDUHE0lCgxnFfxFlZdz5pfb4Q
        TivflJKf5W41x8lLEi35sJIwYaRrLLnF8FT5dDmoM7pbzKvVnseTW+lerq81495f
        Ok/W0iniqduZ7t8mcgjt04vqJsSiqJqVUEqws1qxbVaGW1dNeOn6Q/CkUh8NZrg1
        jkCT0IPQZzPc42ui/tiLUVxlpvHR/Tn4s4+rNbFzeF6OI0UAt87jZq+nPnboHAqD
        jOsR5NY6MM5F60eDmj7Ma+YQAoMAygdtlylXWWTejY/+9ouB8j1JGVumPKp39dMA
        ==
X-ME-Sender: <xms:qOqWXv8cnEBblZLEZVCY4uMbsCcXKA0nGB_E59ts43yfwitBjSUDrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:qeqWXggXTdQvJ6i6Jv9sF3PuOIDYqeJfKwtGK7IDTXvP6bi0x7Gxrw>
    <xmx:qeqWXvBPzFEBMCmLXHZOZ2TNqdf4s5xE_HHz3AX0v4HGorWLTxPgWg>
    <xmx:qeqWXkiSDOjjkJ8Feubip7YhK0cG2DVIjTE9c10g2j3dNXpjiy4cEA>
    <xmx:q-qWXhXJnfNJW6Kby3-VZ_QCEq3EXBn72IK4CTWs4JEjSC8KuZEHVA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AF3983060067;
        Wed, 15 Apr 2020 07:06:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: caam - update xts sector size for large input length" failed to apply to 4.4-stable tree
To:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:06:15 +0200
Message-ID: <1586948775142123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

