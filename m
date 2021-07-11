Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567683C3CBF
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhGKNMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:12:35 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47219 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232775AbhGKNMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:12:30 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 22CBB1AC10D2;
        Sun, 11 Jul 2021 09:09:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 09:09:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CmoWSC
        rWIbe2r17CY52cCwfEf5P8bWMQPGtrA3u2J3M=; b=VeVnV/Kma4JtlQcR665oik
        xp7RKC/6OOB2n86eWwhVwFXHfL0MWXFw20X2cwe7ODsUoV24kH7bZFgWkFDks/fM
        oED4bLTdlN68jd16Pe16CS7tkBY5GoYUi+0174HgSmYn8T5apLLzRtGOS1spzw9p
        9adtdUUXeD0OQjqoaCelglStYFvV22pmhdomqd3NQuR6SvDjE1Y6F6CWjS4f5M9L
        MVYKQEjWkRW7iqTHFLgyV52JxP1MigrdW49ERRRy5+5VjWqCPjy81LqA451fBBrT
        f8YVzX6t7LJhCwxeD9beb8SSyp8dq2V3ddegF/w2Y1nw0/xIPRZV6twd1tsxRebQ
        ==
X-ME-Sender: <xms:lu3qYAgmJRxjPtLueEm8dPf_YUQrIz3mlsVNqQdHiKSMtKFi_UOqYw>
    <xme:lu3qYJB9UqNXC5qy-0I0xF2io6XhXESBxxOWPYI2FwBXsWxpHOa6xuGYLThRMrI-9
    KNiBaZHfLyR7w>
X-ME-Received: <xmr:lu3qYIEuDz8fo5o7RwDpm7XZa3sBUCRMduUTuj9BVhkclcnsp2c81Px2OaKDnHAots9NykLrHoPLkVv2CH90xBmrZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:lu3qYBQfDn_Ql9oN4uH8LLUorHjbpMqGxY-DF3Xv0p1JjXvNFO8LEg>
    <xmx:lu3qYNz3ogMzj9a0R2lryyYxdm7MpHR_sARS9myulD8gkQPVFCi53Q>
    <xmx:lu3qYP7Myb7GfLtt1_tVVBvqB9wGS-zsN3xhkI6gV45RTDnjaiYDvA>
    <xmx:lu3qYOp4WivVcWdKXcoRNsrbrCkAt8N3UkslCtO6C6D0ZFsW-5BeK33YBVg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:09:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] evm: Execute evm_inode_init_security() only when an HMAC key" failed to apply to 4.9-stable tree
To:     roberto.sassu@huawei.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:09:33 +0200
Message-ID: <1626008973192214@kroah.com>
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

