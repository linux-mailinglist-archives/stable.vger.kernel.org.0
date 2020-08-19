Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EAB249B78
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgHSLQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:16:19 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:46657 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726752AbgHSLQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:16:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9EFB5194217F;
        Wed, 19 Aug 2020 07:16:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:16:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gpW54F
        4o6m+zQnqPCJdkyBsKOxUUPlxnSivQWcIhtD4=; b=SWbjwuORLfGPCqmfuYkRru
        kxPlnfRy4RYBJyB3Kk/dK3LImkIPNGPpl9IQQyH/U0cUDDd9Ea7ObWMETLiCHZSR
        hIgqFfM8Llp55plfAN3QxLwhCN8D+IwB84jYdepCxMuSu1afKXTgQ6++eKpeL/Pu
        znEO5I3M9JECaMFj/z2MUty5GVrcixia9M2PEeIEWHee3qyLROJaG2/oW2mQxstO
        fqtRt9jK3am79lGqlQ7Fw5v81d2OukGa9H3I7qiLjINcA85F7VSdaP7MZ486phm6
        Ll2JU3ZYa3YfgzrIQKQWlRP9H4pIwvLLbREJyKXqLDEdSNos+YWknzTqPDkBhArw
        ==
X-ME-Sender: <xms:_gk9XwXFh5JgvGYYK4qvjDs0HjGeb7kNa1Cpgaqh8Z6jDp8FeZNd4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:_gk9X0l9Y51z0SUcxTIC3iNW7R7eIS4H95q9QWJ-d8JTbS6R5_9Ucg>
    <xmx:_gk9X0ZGmCqj7DEZG68mbnRj_rjaafBf_T35XijRnfAVUICfCs6ypQ>
    <xmx:_gk9X_U7ZLPHfQPcvRfNhfiWsEehnY5fC8iAdkk1CbnluUJmp_ZLwg>
    <xmx:_gk9XxumsdtruFh_oJOR4CCd0cZOnse8B_LhRuDEd190gfHJ-4H2HQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 265F73280063;
        Wed, 19 Aug 2020 07:16:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: only commit delayed items at fsync if we are logging a" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:16:37 +0200
Message-ID: <159783579717136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 5aa7d1a7f4a2f8ca6be1f32415e9365d026e8fa7 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 2 Jul 2020 12:32:20 +0100
Subject: [PATCH] btrfs: only commit delayed items at fsync if we are logging a
 directory

When logging an inode we are committing its delayed items if either the
inode is a directory or if it is a new inode, created in the current
transaction.

We need to do it for directories, since new directory indexes are stored
as delayed items of the inode and when logging a directory we need to be
able to access all indexes from the fs/subvolume tree in order to figure
out which index ranges need to be logged.

However for new inodes that are not directories, we do not need to do it
because the only type of delayed item they can have is the inode item, and
we are guaranteed to always log an up to date version of the inode item:

*) for a full fsync we do it by committing the delayed inode and then
   copying the item from the fs/subvolume tree with
   copy_inode_items_to_log();

*) for a fast fsync we always log the inode item based on the contents of
   the in-memory struct btrfs_inode. We guarantee this is always done since
   commit e4545de5b035c7 ("Btrfs: fix fsync data loss after append write").

So stop running delayed items for a new inodes that are not directories,
since that forces committing the delayed inode into the fs/subvolume tree,
wasting time and adding contention to the tree when a full fsync is not
required. We will only do it in case a fast fsync is needed.

This patch is part of a series that has the following patches:

1/4 btrfs: only commit the delayed inode when doing a full fsync
2/4 btrfs: only commit delayed items at fsync if we are logging a directory
3/4 btrfs: stop incremening log_batch for the log root tree when syncing log
4/4 btrfs: remove no longer needed use of log_writers for the log root tree

After the entire patchset applied I saw about 12% decrease on max latency
reported by dbench. The test was done on a qemu vm, with 8 cores, 16Gb of
ram, using kvm and using a raw NVMe device directly (no intermediary fs on
the host). The test was invoked like the following:

  mkfs.btrfs -f /dev/sdk
  mount -o ssd -o nospace_cache /dev/sdk /mnt/sdk
  dbench -D /mnt/sdk -t 300 8
  umount /mnt/dsk

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 44bbf8919883..7c325451d47f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5123,7 +5123,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			   const loff_t end,
 			   struct btrfs_log_ctx *ctx)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_path *path;
 	struct btrfs_path *dst_path;
 	struct btrfs_key min_key;
@@ -5166,15 +5165,17 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	max_key.offset = (u64)-1;
 
 	/*
-	 * Only run delayed items if we are a dir or a new file.
+	 * Only run delayed items if we are a directory. We want to make sure
+	 * all directory indexes hit the fs/subvolume tree so we can find them
+	 * and figure out which index ranges have to be logged.
+	 *
 	 * Otherwise commit the delayed inode only if the full sync flag is set,
 	 * as we want to make sure an up to date version is in the subvolume
 	 * tree so copy_inode_items_to_log() / copy_items() can find it and copy
 	 * it to the log tree. For a non full sync, we always log the inode item
 	 * based on the in-memory struct btrfs_inode which is always up to date.
 	 */
-	if (S_ISDIR(inode->vfs_inode.i_mode) ||
-	    inode->generation > fs_info->last_trans_committed)
+	if (S_ISDIR(inode->vfs_inode.i_mode))
 		ret = btrfs_commit_inode_delayed_items(trans, inode);
 	else if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags))
 		ret = btrfs_commit_inode_delayed_inode(inode);

