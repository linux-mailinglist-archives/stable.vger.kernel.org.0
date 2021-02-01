Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23EA30A7C6
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhBAMje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:39:34 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:46963 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhBAMjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:39:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0F5507F4;
        Mon,  1 Feb 2021 07:38:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 07:38:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3r/q21
        YLpU8Lp8rXKonZazJTo+0zNWpaB/XpqRYwWNo=; b=GsC8VfcIleo3Q6PtXaqYEJ
        e4mbI4gn9sJW43VKk3qlwyNu7lgibQFo/zlGHx6MVdJIam5oWqDMXv6vCpqZZqpf
        8DM/zTv13/l96+QiF35scfNmjuVEzzAqNNxiVWsSkxZ+sDXU2tz6h/aiBsHLJiGL
        ZVdKfeA+UWjYtT9EXMjeMrC/n6k9qwhQkBMBp1tqLubkGQkyXgskuP1iUtauOvxN
        8ZciUJrU3jOGF6T9RzMouS96AO98xtm0n2Ef9HF27RPxjwhDb7xeGNv3v4yDhF0N
        8BbeafDPjECRZRUU5aVPhagFL0ZIKsGpx07U33eQuMnOP/GhEu5wm9lC8Ki3+PZQ
        ==
X-ME-Sender: <xms:P_YXYGX--aIFFep9ehX6tafiq2eAEWWu7NGNl1klMXl2ImoJtoFUkA>
    <xme:P_YXYCkrEmKNyyFEjPQSVCJcS-vkBqYKQNR4gbWe-j2pWqX5TzrtHqzG9wx1ts3E4
    wjWkg-tekc9-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:P_YXYKaOr2PXTuxsm6SVY8I_iqTRTRRI5z5YaZIC49q6stdqUartKg>
    <xmx:P_YXYNVM1OVl8wDOF2XX_FRfNm7tRVv4j8UIlryb0knpT6ssZ2cd_Q>
    <xmx:P_YXYAnZC1-9oAR6ajfaxTfQETku6sJkL7-kWNfEWn6TOFsJHPygtw>
    <xmx:P_YXYMs9Nv34NZ_SwhVS6pDm7yz8lCDxRP6ExoXRRXnMWlQF74faRVdgfzM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E61841080057;
        Mon,  1 Feb 2021 07:38:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix possible free space tree corruption with online" failed to apply to 4.19-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:38:20 +0100
Message-ID: <161218310042187@kroah.com>
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

From 2f96e40212d435b328459ba6b3956395eed8fa9f Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 15 Jan 2021 16:26:17 -0500
Subject: [PATCH] btrfs: fix possible free space tree corruption with online
 conversion

While running btrfs/011 in a loop I would often ASSERT() while trying to
add a new free space entry that already existed, or get an EEXIST while
adding a new block to the extent tree, which is another indication of
double allocation.

This occurs because when we do the free space tree population, we create
the new root and then populate the tree and commit the transaction.
The problem is when you create a new root, the root node and commit root
node are the same.  During this initial transaction commit we will run
all of the delayed refs that were paused during the free space tree
generation, and thus begin to cache block groups.  While caching block
groups the caching thread will be reading from the main root for the
free space tree, so as we make allocations we'll be changing the free
space tree, which can cause us to add the same range twice which results
in either the ASSERT(ret != -EEXIST); in __btrfs_add_free_space, or in a
variety of different errors when running delayed refs because of a
double allocation.

Fix this by marking the fs_info as unsafe to load the free space tree,
and fall back on the old slow method.  We could be smarter than this,
for example caching the block group while we're populating the free
space tree, but since this is a serious problem I've opted for the
simplest solution.

CC: stable@vger.kernel.org # 4.9+
Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 0886e81e5540..48ebc106a606 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -673,7 +673,15 @@ static noinline void caching_thread(struct btrfs_work *work)
 		wake_up(&caching_ctl->wait);
 	}
 
-	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
+	/*
+	 * If we are in the transaction that populated the free space tree we
+	 * can't actually cache from the free space tree as our commit root and
+	 * real root are the same, so we could change the contents of the blocks
+	 * while caching.  Instead do the slow caching in this case, and after
+	 * the transaction has committed we will be safe.
+	 */
+	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE) &&
+	    !(test_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags)))
 		ret = load_free_space_tree(caching_ctl);
 	else
 		ret = load_extent_tree_free(caching_ctl);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0225c5208f44..47ca8edafb5e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -564,6 +564,9 @@ enum {
 
 	/* Indicate that we need to cleanup space cache v1 */
 	BTRFS_FS_CLEANUP_SPACE_CACHE_V1,
+
+	/* Indicate that we can't trust the free space tree for caching yet */
+	BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
 };
 
 /*
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index e33a65bd9a0c..a33bca94d133 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1150,6 +1150,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 		return PTR_ERR(trans);
 
 	set_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	set_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	free_space_root = btrfs_create_tree(trans,
 					    BTRFS_FREE_SPACE_TREE_OBJECTID);
 	if (IS_ERR(free_space_root)) {
@@ -1171,11 +1172,18 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID);
 	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	ret = btrfs_commit_transaction(trans);
 
-	return btrfs_commit_transaction(trans);
+	/*
+	 * Now that we've committed the transaction any reading of our commit
+	 * root will be safe, so we can cache from the free space tree now.
+	 */
+	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
+	return ret;
 
 abort:
 	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	btrfs_abort_transaction(trans, ret);
 	btrfs_end_transaction(trans);
 	return ret;

