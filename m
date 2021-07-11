Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63003C3CBD
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhGKNMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:12:22 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:35189 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhGKNMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:12:22 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 07AF51AC10D3;
        Sun, 11 Jul 2021 09:09:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 09:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4g04bn
        dBbRowNqWk2SEhp530e816bLbmz/j3NYgIUYI=; b=RBVG0N22ePa0s60KRPobGe
        Pu/lJ112JhtiML+ObMDTNE6I2Q/pQkpENuzHBDyedzcvWzbHfMpFgi4havGblei7
        9byvd+WQ6nGo6DzoZsuI+RjdJwauBd1iCVyRRUgJ/cX8K4xmNec2875cwhn+c5U7
        JleoJUtYwRNf0WpcdheyV3BD1mvOVM7524+EnV34k6cLATPy3zWBf94fkxAV9u2F
        nYXxag46if7VAv/UfFq3i0nANtkFq7DKa946HuBUAJuP8EIQaxRxP4/UcnbpGzvv
        EtldbEkZQwoGJKie9zzEqHiM9N41XUkF66woo9gIaPpaG++2i/KJMWYjP8TkLycw
        ==
X-ME-Sender: <xms:ju3qYIv2VvZa61A9KhJRAFEt8dI_7NXQ1Lh6HmQPqaGOp4ynDc-JBw>
    <xme:ju3qYFf3oR4lLD_yczoe6pFUiguG-qXTLjePwGlX_p_n6tttNK_ZiMz4tisqG-ld9
    3fWH6L-aBayqw>
X-ME-Received: <xmr:ju3qYDzSwvzepS-USBhege5iPnFRQzolipx5uJx3GgZROJyRyEXjv2sBXD0GTbsI1OAYpc2N8xCVsvjI_haDQPF8LA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ju3qYLPXCMSbMa8a8OlFVCtv16JU2Ndysph_NgvpQ0XqkGWi_bnE5Q>
    <xmx:ju3qYI9t1rj7M75jQObhq67orjzOuzEaMFoFcx0qcABmZhZ57ZkwHg>
    <xmx:ju3qYDW8ddyUJvFagd6noRKJ3rdfulv7BlU-DWZjP1BAEEWJ5zisIw>
    <xmx:ju3qYGkGUji97gMmr1M-h9SsIBvuOYSfrCZqJJ4X1iVtj280mJa4Oetc4HI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:09:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] evm: Execute evm_inode_init_security() only when an HMAC key" failed to apply to 4.14-stable tree
To:     roberto.sassu@huawei.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:09:32 +0200
Message-ID: <1626008972189223@kroah.com>
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

From 9eea2904292c2d8fa98df141d3bf7c41ec9dc1b5 Mon Sep 17 00:00:00 2001
From: Roberto Sassu <roberto.sassu@huawei.com>
Date: Fri, 14 May 2021 17:27:42 +0200
Subject: [PATCH] evm: Execute evm_inode_init_security() only when an HMAC key
 is loaded

evm_inode_init_security() requires an HMAC key to calculate the HMAC on
initial xattrs provided by LSMs. However, it checks generically whether a
key has been loaded, including also public keys, which is not correct as
public keys are not suitable to calculate the HMAC.

Originally, support for signature verification was introduced to verify a
possibly immutable initial ram disk, when no new files are created, and to
switch to HMAC for the root filesystem. By that time, an HMAC key should
have been loaded and usable to calculate HMACs for new files.

More recently support for requiring an HMAC key was removed from the
kernel, so that signature verification can be used alone. Since this is a
legitimate use case, evm_inode_init_security() should not return an error
when no HMAC key has been loaded.

This patch fixes this problem by replacing the evm_key_loaded() check with
a check of the EVM_INIT_HMAC flag in evm_initialized.

Fixes: 26ddabfe96b ("evm: enable EVM when X509 certificate is loaded")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org # 4.5.x
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 0de367aaa2d3..7ac5204c8d1f 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -521,7 +521,7 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
 }
 
 /*
- * evm_inode_init_security - initializes security.evm
+ * evm_inode_init_security - initializes security.evm HMAC value
  */
 int evm_inode_init_security(struct inode *inode,
 				 const struct xattr *lsm_xattr,
@@ -530,7 +530,8 @@ int evm_inode_init_security(struct inode *inode,
 	struct evm_xattr *xattr_data;
 	int rc;
 
-	if (!evm_key_loaded() || !evm_protected_xattr(lsm_xattr->name))
+	if (!(evm_initialized & EVM_INIT_HMAC) ||
+	    !evm_protected_xattr(lsm_xattr->name))
 		return 0;
 
 	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);

