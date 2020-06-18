Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7621FF93A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgFRQ3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:29:07 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:35643 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728489AbgFRQ3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 12:29:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 0F3B89CA;
        Thu, 18 Jun 2020 12:29:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 12:29:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+BR4uP
        uvOOWt8b0svqLVQR2CNSTHQF06s2yQfVsq060=; b=brTdSZiFXT8ysyBMWMry3q
        eRuMQM/AsJbkogt7YPa5UyUBBAscrChpw3Y4sb4royV+s0yf1rRMrIUSVuhYpqvp
        zn2XQgDVN1dypIAQySokWQQwYowBQAO1v1DOFwrAgSjBs3nh2ifkQ1+NW4U7Te70
        8Cs5J9me4c3odkhRjVL0cZwMPe1gOy64p0saiJwW2p4BdFLQrS+2mjMQNpg/NoI3
        EzBWoLbOessw+R8E5b1+1t3/wBAzpSwUIpPRG7eoyCkQHgWThJ3gPkiChH+Ciqmg
        axGbRb3qBmeiKRcBYFuHJgWzm0AIa+F5q5CDr1Cmrh1WBqnhOhw1tO+WicdLHSiQ
        ==
X-ME-Sender: <xms:UZbrXk9tYwfD9Xq1dcYw0LhvCYoDMYbBbVEzOHOFJnmgxm9TOA-QSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:UZbrXsugVAjOBPFBBBmiaEHE6gW43aZNzpne5liRwI3WCJCDhjrRAg>
    <xmx:UZbrXqAwA9HMLPb0nhtzEclCe_uxUYtnSlt0CSA8wAW2AnDySx-TXQ>
    <xmx:UZbrXkfgbrQ27WIPezkvsVnnaoqMDfjndkkU8I-QiXtHAMZrJYHrfA>
    <xmx:UZbrXrXBCXxAeLaB1CNX9o4xQSEhMDwVqi5XmGFZW0NDXM-AJkatAX4Fjy0>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F35BA3280059;
        Thu, 18 Jun 2020 12:29:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ima: Directly assign the ima_default_policy pointer to" failed to apply to 4.4-stable tree
To:     roberto.sassu@huawei.com, tiwai@suse.de, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 18:28:55 +0200
Message-ID: <159249773513242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 067a436b1b0aafa593344fddd711a755a58afb3b Mon Sep 17 00:00:00 2001
From: Roberto Sassu <roberto.sassu@huawei.com>
Date: Wed, 3 Jun 2020 17:08:20 +0200
Subject: [PATCH] ima: Directly assign the ima_default_policy pointer to
 ima_rules

This patch prevents the following oops:

[   10.771813] BUG: kernel NULL pointer dereference, address: 0000000000000
[...]
[   10.779790] RIP: 0010:ima_match_policy+0xf7/0xb80
[...]
[   10.798576] Call Trace:
[   10.798993]  ? ima_lsm_policy_change+0x2b0/0x2b0
[   10.799753]  ? inode_init_owner+0x1a0/0x1a0
[   10.800484]  ? _raw_spin_lock+0x7a/0xd0
[   10.801592]  ima_must_appraise.part.0+0xb6/0xf0
[   10.802313]  ? ima_fix_xattr.isra.0+0xd0/0xd0
[   10.803167]  ima_must_appraise+0x4f/0x70
[   10.804004]  ima_post_path_mknod+0x2e/0x80
[   10.804800]  do_mknodat+0x396/0x3c0

It occurs when there is a failure during IMA initialization, and
ima_init_policy() is not called. IMA hooks still call ima_match_policy()
but ima_rules is NULL. This patch prevents the crash by directly assigning
the ima_default_policy pointer to ima_rules when ima_rules is defined. This
wouldn't alter the existing behavior, as ima_rules is always set at the end
of ima_init_policy().

Cc: stable@vger.kernel.org # 3.7.x
Fixes: 07f6a79415d7d ("ima: add appraise action keywords and default rules")
Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index ef7f68cc935e..e493063a3c34 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -204,7 +204,7 @@ static struct ima_rule_entry *arch_policy_entry __ro_after_init;
 static LIST_HEAD(ima_default_rules);
 static LIST_HEAD(ima_policy_rules);
 static LIST_HEAD(ima_temp_rules);
-static struct list_head *ima_rules;
+static struct list_head *ima_rules = &ima_default_rules;
 
 /* Pre-allocated buffer used for matching keyrings. */
 static char *ima_keyrings;
@@ -768,7 +768,6 @@ void __init ima_init_policy(void)
 			  ARRAY_SIZE(default_appraise_rules),
 			  IMA_DEFAULT_POLICY);
 
-	ima_rules = &ima_default_rules;
 	ima_update_policy_flag();
 }
 

