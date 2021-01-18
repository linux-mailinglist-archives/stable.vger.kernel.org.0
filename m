Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6DF2F9CD4
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389306AbhARK0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:26:42 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:40517 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388605AbhARJu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 04:50:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id BDFFE1647;
        Mon, 18 Jan 2021 04:49:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 18 Jan 2021 04:49:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WMhHQa
        BtdE0koHtp1O7dNhl8xpE9ZJzgduWes2ch98w=; b=Q2z3mCwd99ieerFAEWiS6/
        Wz+OLNxVQBniF4a+FVxxzwh/36bPJNjSuaboj4WJzTP8UK+jt+gDgCvzNrqDVmqn
        IBjFH27xsu/kc51/wlyycrVvVfL+qCDs19+ZoN17702FFhlULs3ORcT2EOAro2FO
        9puFTDRslf8yz7McftOfwOi21VpTCJBmpwMaDz3BILuvKp2wzqPseoavwPZfIht1
        R3T/+2HWUi8Rr//TKax5caae9n785yvXplDLRnwoS9W2c6bhOJSfmAArkVFxHtOO
        7sc6OQ1pVe0XSvdOi2gSGAKkxf/Z8Ai4zADx7/96r0LL2eZJ1fa2s1ScUoz7+6gQ
        ==
X-ME-Sender: <xms:sFkFYAy1Bq5DqDe8RtqrwsELktfpw0vixVwzCmoMJjQ3zab_HUSjJQ>
    <xme:sFkFYET6ibZ7PwBNGIaAqKHh646engOJ3sDF5VnenQljc1v9KsGiRGxchA59XEAzA
    zsSIzJ5qzm8CA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:sFkFYCX_qFVO2AQ3UgP11qS1CUk7VuV-WheszKr-rgJI6AjL3lnjJA>
    <xmx:sFkFYOhML98JE6HJkZ2fVkVtgW739_etegAlYarOP1zkOFQMGzEYxQ>
    <xmx:sFkFYCDzX9iTZuF4QdFMgJggtD2eT_2qc1DiA7BeMtFwg13o3muE0w>
    <xmx:sFkFYJ-x0REbAIf4Vj0vjEPiKjGryikeZokBUeX7hvfQdurUMp_vLBCee4I>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC2B424005A;
        Mon, 18 Jan 2021 04:49:35 -0500 (EST)
Subject: FAILED: patch "[PATCH] NFS: nfs_delegation_find_inode_server must first reference" failed to apply to 4.19-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jan 2021 10:49:34 +0100
Message-ID: <1610963374833@kroah.com>
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

From 113aac6d567bda783af36d08f73bfda47d8e9a40 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Sun, 10 Jan 2021 15:46:06 -0500
Subject: [PATCH] NFS: nfs_delegation_find_inode_server must first reference
 the superblock

Before referencing the inode, we must ensure that the superblock can be
referenced. Otherwise, we can end up with iput() calling superblock
operations that are no longer valid or accessible.

Fixes: e39d8a186ed0 ("NFSv4: Fix an Oops during delegation callbacks")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 816e1427f17e..04bf8066980c 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -1011,22 +1011,24 @@ nfs_delegation_find_inode_server(struct nfs_server *server,
 				 const struct nfs_fh *fhandle)
 {
 	struct nfs_delegation *delegation;
-	struct inode *freeme, *res = NULL;
+	struct super_block *freeme = NULL;
+	struct inode *res = NULL;
 
 	list_for_each_entry_rcu(delegation, &server->delegations, super_list) {
 		spin_lock(&delegation->lock);
 		if (delegation->inode != NULL &&
 		    !test_bit(NFS_DELEGATION_REVOKED, &delegation->flags) &&
 		    nfs_compare_fh(fhandle, &NFS_I(delegation->inode)->fh) == 0) {
-			freeme = igrab(delegation->inode);
-			if (freeme && nfs_sb_active(freeme->i_sb))
-				res = freeme;
+			if (nfs_sb_active(server->super)) {
+				freeme = server->super;
+				res = igrab(delegation->inode);
+			}
 			spin_unlock(&delegation->lock);
 			if (res != NULL)
 				return res;
 			if (freeme) {
 				rcu_read_unlock();
-				iput(freeme);
+				nfs_sb_deactive(freeme);
 				rcu_read_lock();
 			}
 			return ERR_PTR(-EAGAIN);

