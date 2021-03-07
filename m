Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F2733015C
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhCGNsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:48:09 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:55153 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231414AbhCGNrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:47:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B741F18EA;
        Sun,  7 Mar 2021 08:47:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6dER1x
        x5cmAU/vss7K8mDLDrqx/nwkL53izXVHKxEXI=; b=i6aNMUdWGhZ3X8J1eLDSyd
        sPH49uNCHxqKfDoQWs9i7vKudUo7uX/aKAhaPNxsvjzQEw7uZ8kzlC7B3QsDd1Jg
        6ppHw+S/uYTs4hxUGNc6DeAMbkibH6sXnDlAB0F02LiVPGIcwG6Y0WFhFdoTxW2P
        3HmquAbe4/r0/ibkX2xuWQI2+ENwT/Oc8RlqzlknHbEa7o7g7PwsKKTKdwmw8/pm
        DqnHgf/GXhsrkPVamtWe04deoRpyQQg53sawvAvWPQcNQUtWkZZ79Nk92wvyrPGx
        5M/32tzECPC6/RkgBhVdIb7qiyP4foNsRwT44UkuCaQiupQa+YJdmprfKfHDRQzg
        ==
X-ME-Sender: <xms:etlEYOvD3QFGobXYYmtyMJ2CR1zswBCd3fpkCedjUzTLAdMCDrsYsw>
    <xme:etlEYDepC7izONlOfioSBQ44Zb_2vE2sNbvXUTKIrk5zKWAQqmHLIGD62oYc5T9oX
    E0oqsWT9oIitw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:etlEYJzOEn_dqE-wZ_zj7i1zr2F4-QhPVY-T60WiYrB9A0PzcQAxMA>
    <xmx:etlEYJOMVQUqH4rJiaE-KhSrQuqA1hemWTCQWWtPVK2NvELlrVphuw>
    <xmx:etlEYO-wgG9SFuH7742EpKk_MKaKTAlChZKtgkr_ynIBOe3BH9i7aQ>
    <xmx:etlEYAJN0Q3t4oZJuZ6JF7QLg2z4lDU-S93QXA8KrntBJnxMuE5F8-HVfCI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0297D240054;
        Sun,  7 Mar 2021 08:47:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix race between writes to swap files and scrub" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, anand.jain@oracle.com, dsterba@suse.com,
        josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:47:36 +0100
Message-ID: <161512485617131@kroah.com>
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

From 195a49eaf655eb914896c92cecd96bc863c9feb3 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Fri, 5 Feb 2021 12:55:37 +0000
Subject: [PATCH] btrfs: fix race between writes to swap files and scrub

When we active a swap file, at btrfs_swap_activate(), we acquire the
exclusive operation lock to prevent the physical location of the swap
file extents to be changed by operations such as balance and device
replace/resize/remove. We also call there can_nocow_extent() which,
among other things, checks if the block group of a swap file extent is
currently RO, and if it is we can not use the extent, since a write
into it would result in COWing the extent.

However we have no protection against a scrub operation running after we
activate the swap file, which can result in the swap file extents to be
COWed while the scrub is running and operating on the respective block
group, because scrub turns a block group into RO before it processes it
and then back again to RW mode after processing it. That means an attempt
to write into a swap file extent while scrub is processing the respective
block group, will result in COWing the extent, changing its physical
location on disk.

Fix this by making sure that block groups that have extents that are used
by active swap files can not be turned into RO mode, therefore making it
not possible for a scrub to turn them into RO mode. When a scrub finds a
block group that can not be turned to RO due to the existence of extents
used by swap files, it proceeds to the next block group and logs a warning
message that mentions the block group was skipped due to active swap
files - this is the same approach we currently use for balance.

Fixes: ed46ff3d42378 ("Btrfs: support swap files")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 5064be59dac5..744b99ddc28c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1162,6 +1162,11 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, int force)
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 
+	if (cache->swap_extents) {
+		ret = -ETXTBSY;
+		goto out;
+	}
+
 	if (cache->ro) {
 		cache->ro++;
 		ret = 0;
@@ -2307,7 +2312,7 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	}
 
 	ret = inc_block_group_ro(cache, 0);
-	if (!do_chunk_alloc)
+	if (!do_chunk_alloc || ret == -ETXTBSY)
 		goto unlock_out;
 	if (!ret)
 		goto out;
@@ -2316,6 +2321,8 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	if (ret < 0)
 		goto out;
 	ret = inc_block_group_ro(cache, 0);
+	if (ret == -ETXTBSY)
+		goto unlock_out;
 out:
 	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
 		alloc_flags = btrfs_get_alloc_profile(fs_info, cache->flags);
@@ -3406,6 +3413,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		ASSERT(list_empty(&block_group->io_list));
 		ASSERT(list_empty(&block_group->bg_list));
 		ASSERT(refcount_read(&block_group->refs) == 1);
+		ASSERT(block_group->swap_extents == 0);
 		btrfs_put_block_group(block_group);
 
 		spin_lock(&info->block_group_cache_lock);
@@ -3472,3 +3480,26 @@ void btrfs_unfreeze_block_group(struct btrfs_block_group *block_group)
 		__btrfs_remove_free_space_cache(block_group->free_space_ctl);
 	}
 }
+
+bool btrfs_inc_block_group_swap_extents(struct btrfs_block_group *bg)
+{
+	bool ret = true;
+
+	spin_lock(&bg->lock);
+	if (bg->ro)
+		ret = false;
+	else
+		bg->swap_extents++;
+	spin_unlock(&bg->lock);
+
+	return ret;
+}
+
+void btrfs_dec_block_group_swap_extents(struct btrfs_block_group *bg, int amount)
+{
+	spin_lock(&bg->lock);
+	ASSERT(!bg->ro);
+	ASSERT(bg->swap_extents >= amount);
+	bg->swap_extents -= amount;
+	spin_unlock(&bg->lock);
+}
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 29678426247d..3ecc3372a5ce 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -186,6 +186,12 @@ struct btrfs_block_group {
 	/* Flag indicating this block group is placed on a sequential zone */
 	bool seq_zone;
 
+	/*
+	 * Number of extents in this block group used for swap files.
+	 * All accesses protected by the spinlock 'lock'.
+	 */
+	int swap_extents;
+
 	/* Record locked full stripes for RAID5/6 block group */
 	struct btrfs_full_stripe_locks_tree full_stripe_locks_root;
 
@@ -312,4 +318,7 @@ static inline int btrfs_block_group_done(struct btrfs_block_group *cache)
 void btrfs_freeze_block_group(struct btrfs_block_group *cache);
 void btrfs_unfreeze_block_group(struct btrfs_block_group *cache);
 
+bool btrfs_inc_block_group_swap_extents(struct btrfs_block_group *bg);
+void btrfs_dec_block_group_swap_extents(struct btrfs_block_group *bg, int amount);
+
 #endif /* BTRFS_BLOCK_GROUP_H */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3bc00aed13b2..40ec3393d2a1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -524,6 +524,11 @@ struct btrfs_swapfile_pin {
 	 * points to a struct btrfs_device.
 	 */
 	bool is_block_group;
+	/*
+	 * Only used when 'is_block_group' is true and it is the number of
+	 * extents used by a swapfile for this block group ('ptr' field).
+	 */
+	int bg_extent_count;
 };
 
 bool btrfs_pinned_by_swapfile(struct btrfs_fs_info *fs_info, void *ptr);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d6f0e1ad3711..30358a2e2bc0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10192,6 +10192,7 @@ static int btrfs_add_swapfile_pin(struct inode *inode, void *ptr,
 	sp->ptr = ptr;
 	sp->inode = inode;
 	sp->is_block_group = is_block_group;
+	sp->bg_extent_count = 1;
 
 	spin_lock(&fs_info->swapfile_pins_lock);
 	p = &fs_info->swapfile_pins.rb_node;
@@ -10205,6 +10206,8 @@ static int btrfs_add_swapfile_pin(struct inode *inode, void *ptr,
 			   (sp->ptr == entry->ptr && sp->inode > entry->inode)) {
 			p = &(*p)->rb_right;
 		} else {
+			if (is_block_group)
+				entry->bg_extent_count++;
 			spin_unlock(&fs_info->swapfile_pins_lock);
 			kfree(sp);
 			return 1;
@@ -10230,8 +10233,11 @@ static void btrfs_free_swapfile_pins(struct inode *inode)
 		sp = rb_entry(node, struct btrfs_swapfile_pin, node);
 		if (sp->inode == inode) {
 			rb_erase(&sp->node, &fs_info->swapfile_pins);
-			if (sp->is_block_group)
+			if (sp->is_block_group) {
+				btrfs_dec_block_group_swap_extents(sp->ptr,
+							   sp->bg_extent_count);
 				btrfs_put_block_group(sp->ptr);
+			}
 			kfree(sp);
 		}
 		node = next;
@@ -10446,6 +10452,17 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 			goto out;
 		}
 
+		if (!btrfs_inc_block_group_swap_extents(bg)) {
+			btrfs_warn(fs_info,
+			   "block group for swapfile at %llu is read-only%s",
+			   bg->start,
+			   atomic_read(&fs_info->scrubs_running) ?
+				       " (scrub running)" : "");
+			btrfs_put_block_group(bg);
+			ret = -EINVAL;
+			goto out;
+		}
+
 		ret = btrfs_add_swapfile_pin(inode, bg, true);
 		if (ret) {
 			btrfs_put_block_group(bg);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 310fce00fcda..70a90ca2c8da 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3767,6 +3767,13 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			 * commit_transactions.
 			 */
 			ro_set = 0;
+		} else if (ret == -ETXTBSY) {
+			btrfs_warn(fs_info,
+		   "skipping scrub of block group %llu due to active swapfile",
+				   cache->start);
+			scrub_pause_off(fs_info);
+			ret = 0;
+			goto skip_unfreeze;
 		} else {
 			btrfs_warn(fs_info,
 				   "failed setting block group ro: %d", ret);
@@ -3862,7 +3869,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		} else {
 			spin_unlock(&cache->lock);
 		}
-
+skip_unfreeze:
 		btrfs_unfreeze_block_group(cache);
 		btrfs_put_block_group(cache);
 		if (ret)

