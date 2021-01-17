Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8BA2F92C1
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbhAQOJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:09:16 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53685 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728709AbhAQOJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:09:16 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 091A3195DF63;
        Sun, 17 Jan 2021 09:08:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:08:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LDnZGA
        OkpdB0DxH3YNF3YqssYffWkfpcVORXx/oSBpo=; b=m6ekwEAfsuqvKovw4/S23n
        qnY7OwKie5OSsOztM2aRy7c+lfcqSQ4cTYQWpRDHGOfrElZfHFHejxNBmf64UrJj
        A7UJCx0HalC6uDkXeaABWBRwRwM2a3axWaKvmEwhKKnes/lJ4jXHQECT6eQhwNW7
        vG4MRgC7++HJ6+a9bXnBIPULO24WJmkRz39nm/zC8o3HMQJbwtc17h2BHlZGd+pB
        S+MaQozlMKqbqsWKNkW00QxFJLsC4tVLJYK0RlRhW6iesGtivklCYN05tHGDXafk
        Op47ej/q33BP6YwZp7lPmLvx2vRrdLGr1SCfsZQG3gWf90kBC3ZKQH+6/SJ95pEQ
        ==
X-ME-Sender: <xms:yEQEYBnk8RzmJ7ac3AXkaetYSTBeVJ9Ri7NzpDFLDc5Ar_K38v6YEg>
    <xme:yEQEYM2w7uJhNKU0A5GXGfyzuOyQpiP_PPWEF-BAH3NowIaEszLwGOUDzWOpLg5FD
    EqbNVEG2tuX-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:yEQEYHrN1cxACizCHdXBB1q913s8vt9uPQQcnv_WlJMddhWuZLJkLA>
    <xmx:yEQEYBmF_8o1BGyoZplQxBmBWpgvDoh0NJyIuLp3QhjBTetz3AgYjw>
    <xmx:yEQEYP3lr51GFK9_MjFVEpBMJsTPgEKPr71TnItBX6W6l_cDz0JMSA>
    <xmx:ykQEYI-6jr38tUYjaCcwaHSPRkM-l_QG3wA_MuyjatQ7RxxxJMamjw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B866F108005B;
        Sun, 17 Jan 2021 09:08:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: prevent NULL pointer dereference in" failed to apply to 4.19-stable tree
To:     l@damenly.su, anand.jain@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:08:07 +0100
Message-ID: <161089248710585@kroah.com>
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

From 29b665cc51e8b602bf2a275734349494776e3dbc Mon Sep 17 00:00:00 2001
From: Su Yue <l@damenly.su>
Date: Sun, 3 Jan 2021 17:28:03 +0800
Subject: [PATCH] btrfs: prevent NULL pointer dereference in
 extent_io_tree_panic

Some extent io trees are initialized with NULL private member (e.g.
btrfs_device::alloc_state and btrfs_fs_info::excluded_extents).
Dereference of a NULL tree->private as inode pointer will cause panic.

Pass tree->fs_info as it's known to be valid in all cases.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208929
Fixes: 05912a3c04eb ("btrfs: drop extent_io_ops::tree_fs_info callback")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Su Yue <l@damenly.su>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6e3b72e63e42..c9cee458e001 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -676,9 +676,7 @@ alloc_extent_state_atomic(struct extent_state *prealloc)
 
 static void extent_io_tree_panic(struct extent_io_tree *tree, int err)
 {
-	struct inode *inode = tree->private_data;
-
-	btrfs_panic(btrfs_sb(inode->i_sb), err,
+	btrfs_panic(tree->fs_info, err,
 	"locking error: extent tree was modified by another thread while locked");
 }
 

