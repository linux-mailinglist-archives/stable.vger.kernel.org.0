Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5DC249B77
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHSLPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:15:40 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:41857 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726752AbgHSLPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:15:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 72E9D1942760;
        Wed, 19 Aug 2020 07:15:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=osW2nn
        anXKLzCM4Z+0U8+RfGzQWrN9NIut32kKw4x9Q=; b=mDlGUo9lLfEh++1IE0K+Xv
        6+xY0yQXrbFuHoCGefdeGMDdcxeiomsuViXWOYL2fk5wcTVrnEUgImZAzVBAbuGH
        zgWk4c/ULbQqC0hklLtcgr+spZehyS74hKuN/oEvB6Y0RanqTlUX4FkFtKgEVRa9
        H9y2JJ7DMyvBHOgUWuyaXLg0ZLR3DZakfmmUbqIDaNN6QxMlhHNjdTufYTlut+Dv
        BNe/Q9+Ee+RU0oLt0tVGkrPGfo91TRCUCPsiiS/9fo5Wpfh8mEfFRR9tNbb3beGI
        mOUK9kdZXFHtX7OuLcT1U6FrC05d6bbPzFRvqYTJOK7ecKA+CSecROVgFfQsJTcA
        ==
X-ME-Sender: <xms:2Qk9X5w0yRdjSUFiBCwQ-9hYPoGF7rgzYP5tQGDvnueHEcThLv-0Aw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:2Qk9X5SqtfX-Nfa95cHEXO1WzpDH8tzA9jthBvp0An-gRybLAOHTqg>
    <xmx:2Qk9XzXxamVa27R4WYpdL-6QiJNCzXzVQ-GWh6sXxwFSUPyXYgQffA>
    <xmx:2Qk9X7i9_drYimiykeClljQRRCOgf1DbTUdWb_rgu4EA5Pkp-xqCDQ>
    <xmx:2Qk9X-ofj26-n04pVYxAEdRbwgwnJz7OuvQPUu6MXzDNp2odFaE-RA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 027F430600A3;
        Wed, 19 Aug 2020 07:15:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: only commit the delayed inode when doing a full fsync" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:16:00 +0200
Message-ID: <1597835760267@kroah.com>
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

From 8c8648dd1f6d62aeb912deeb788b6ac33cb782e7 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 2 Jul 2020 12:31:59 +0100
Subject: [PATCH] btrfs: only commit the delayed inode when doing a full fsync

Commit 2c2c452b0cafdc ("Btrfs: fix fsync when extend references are added
to an inode") forced a commit of the delayed inode when logging an inode
in order to ensure we would end up logging the inode item during a full
fsync. By committing the delayed inode, we updated the inode item in the
fs/subvolume tree and then later when copying items from leafs modified in
the current transaction into the log tree (with copy_inode_items_to_log())
we ended up copying the inode item from the fs/subvolume tree into the log
tree. Logging an up to date version of the inode item is required to make
sure at log replay time we get the link count fixup triggered among other
things (replay xattr deletes, etc). The test case generic/040 from fstests
exercises the bug which that commit fixed.

However for a fast fsync we don't need to commit the delayed inode because
we always log an up to date version of the inode item based on the struct
btrfs_inode we have in-memory. We started doing this for fast fsyncs since
commit e4545de5b035c7 ("Btrfs: fix fsync data loss after append write").

So just stop committing the delayed inode if we are doing a fast fsync,
we are only wasting time and adding contention on fs/subvolume tree.

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
index df6d4e3e40b1..44bbf8919883 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5130,7 +5130,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_key max_key;
 	struct btrfs_root *log = root->log_root;
 	int err = 0;
-	int ret;
+	int ret = 0;
 	bool fast_search = false;
 	u64 ino = btrfs_ino(inode);
 	struct extent_map_tree *em_tree = &inode->extent_tree;
@@ -5167,14 +5167,16 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	/*
 	 * Only run delayed items if we are a dir or a new file.
-	 * Otherwise commit the delayed inode only, which is needed in
-	 * order for the log replay code to mark inodes for link count
-	 * fixup (create temporary BTRFS_TREE_LOG_FIXUP_OBJECTID items).
+	 * Otherwise commit the delayed inode only if the full sync flag is set,
+	 * as we want to make sure an up to date version is in the subvolume
+	 * tree so copy_inode_items_to_log() / copy_items() can find it and copy
+	 * it to the log tree. For a non full sync, we always log the inode item
+	 * based on the in-memory struct btrfs_inode which is always up to date.
 	 */
 	if (S_ISDIR(inode->vfs_inode.i_mode) ||
 	    inode->generation > fs_info->last_trans_committed)
 		ret = btrfs_commit_inode_delayed_items(trans, inode);
-	else
+	else if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags))
 		ret = btrfs_commit_inode_delayed_inode(inode);
 
 	if (ret) {

