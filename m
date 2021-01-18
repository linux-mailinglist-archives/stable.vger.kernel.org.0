Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2BC2F9CD5
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389325AbhARK0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:26:43 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47701 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388836AbhARJug (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 04:50:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3624E16D9;
        Mon, 18 Jan 2021 04:49:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 18 Jan 2021 04:49:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=v5WKFj
        XXzoiZB+SymCZjg8Y9oZ/2QnmVQU902w3zFLs=; b=nGwGFZb2QuyfzChjAfnp3K
        NhxKzb2qhB/ompiW6bXa8N39MOXLyDEMAfzg0ZAa6beAt/dc/vefHdH5BfaHcdaD
        PN22NSACVJyltvy0DT3lGE8FKpHA30r0JWE23SuEzgV/Q8JLvb3fESe4zmgyqaO0
        vS7GAIUW1Vqf2XRhatuYQI+bS5/RWHENlYMr6mZusE2NIAkWYnVpawbc+EnkkWvL
        2flfQD3BLxjaj6HQa263Z7rs8jGyPMzq2Zz7UnT+FPJgYyKAnsjPiARlOawZd+P4
        94aZd0tGQJqmCVrAgKjOcfucDug34vR9O0ifCUp15BUm93gURtDr2Iz3FrfTtd7Q
        ==
X-ME-Sender: <xms:uFkFYCV8G144RzC79L-gtQQ8jloFdtWndBQEvX4uFbWl0tSCEzgiXw>
    <xme:uFkFYOk1T5NpJrudcBvmuPfnxBVxBFGV0jlm0DjEFNb8s4boj24nj9v-uVq3Qn1Iu
    08hql46Z8X9KA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:uFkFYGaiVZv0lVVoZG2wAbhecnnkN47x58yaMsChxDtgLlrO4-LHvA>
    <xmx:uFkFYJU1SYK_r1kOhtGt-2GJNsQRyH611i0CwTActPTIlq6d6P0VpQ>
    <xmx:uFkFYMly7xaaUvoshzJIdB8nlVzg8D6ZrYQJ_0DzHHBSPP22s_HuLw>
    <xmx:uFkFYOTcIiEuIof5GsuRKRf7GdqRo60mN0yVIg8eG_JntBOyXwFlyxW_S_k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 81ECC1080057;
        Mon, 18 Jan 2021 04:49:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] NFS: nfs_delegation_find_inode_server must first reference" failed to apply to 5.4-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jan 2021 10:49:35 +0100
Message-ID: <161096337558107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

