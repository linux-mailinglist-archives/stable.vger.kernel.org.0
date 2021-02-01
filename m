Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554B830A7C7
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhBAMjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:39:41 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:60163 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhBAMjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:39:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 54CA172F;
        Mon,  1 Feb 2021 07:38:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 01 Feb 2021 07:38:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fenajF
        /nWJFSpwKYWzyyuYgQ5xFGwZxwR1iT1ig1ncU=; b=CmDdMChxxe8bmnZrfYcNy4
        ejfSDuc1NuvDf/eZe2G77Z6EaKHpKQwVUsthC3O+h3jG0DMdjxiVbR7LT0cJU/mV
        oC4s8Dz7m9W+xI5ZJJJr8NpEqcLzPT+3O2LW+/4qmbkDBf8AX8ucf80DPlwiWfMq
        GG3A5oiHW5nGTm7WYQrkMCf4HcnxKRfzWryBXptnBeH/JXvQdpKQNZ4vVDl1r52f
        /xs/Xy80mdcqtjYcGU6LoIv99MSxe6jW+5Aji3byR1c1rTP8e/2oMIvxe+zsOJZC
        KDXruKznN2fkNRUDe6CY7NNI+Bz1mPNmhe2FAu+SKcqSC8Brh0gxQRXmhI787nBA
        ==
X-ME-Sender: <xms:R_YXYFvavXZAVJs0_qZrpWnsXInTl2RS5pWs2U2THX5R1aks0GXDhA>
    <xme:R_YXYIFtfDJkTXeLxALTWvXNd5oSaR2W8nEFZcaLeheAPXdVUKAvsVinC5eUduWy7
    J5V4-x6N9oHKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:R_YXYIx9Gsy7Ij9WqHS5xfqjmTGiUiCTPtyufDhPG2XNhmMsaLWhqA>
    <xmx:R_YXYPhEoQ1GjL8GXxInBCuCvz-ilifb_HBJXkbxWmnKP1JYiDUo7Q>
    <xmx:R_YXYDyxCz_BVcOvaJk8yRxIVQy50wmVS9E8gghLXVMmGdZ6gsoXSw>
    <xmx:R_YXYFu90PqOd12sj-ij63_CmlncIzbWc-Wq00mMBMrsuMkGIVLrT7lgY9Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B942240062;
        Mon,  1 Feb 2021 07:38:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix possible free space tree corruption with online" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:38:21 +0100
Message-ID: <16121831016629@kroah.com>
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

