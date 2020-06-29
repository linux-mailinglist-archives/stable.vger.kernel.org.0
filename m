Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312A620D167
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgF2Slv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:41:51 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39523 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727986AbgF2Slt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id A19FE31F;
        Mon, 29 Jun 2020 07:02:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=v9eps6
        kVsN48LQ8sXlqtCSL+MUR0R8xqHpiDicHq1mA=; b=cYSfqjRJXIkXye/tFVvi0u
        VW7bcE0+0xoIBvVUqEJd3AeU1nztGe/oNbqzJVURng1pjd11LKxEpN7PQqtHIfiC
        XZslzliVvMyDBAn4IOwNSm1BJtqtuSpmo9fVFv1wsh1wm2smDqT7IuwMHujQHvRD
        9gdXH8ujtwVJSdgLYMclIxec20RB+eUmA3J7AoweXEgZecspsJAZhHQFA/VX815u
        oNWIbKVOAEMi2s8gBn/dSTl87MVUrIp5JakP6LzN0OOAbic9EK6LSPHs/Ay4UqWt
        MiXP2XThLOuSov/bZipwF/wXuNfzE/f/o5kCUt4z1ND/s+PUaa66D6W4+2TsRYOg
        ==
X-ME-Sender: <xms:Ksr5Xi23sIRtNh66-JFA1KMAwnn3auGnjk7Wda7epicCJc3rNCxEdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepfeetteehueetheekueevhfefveejheegtdeiudehue
    ekheeijeefgfeuhfeigefhnecuffhomhgrihhnpehqvghmuhdrohhrghenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Ksr5XlGIQm-J5Y2P0g6DgCBfYbTEsbY1Sedgk0xRTuO45bHqyAuuyg>
    <xmx:Ksr5Xq4o2QXcOk_Z6tJWuLPUyy-UUd4DklwXp_4elmi7bnHvvEeJmQ>
    <xmx:Ksr5Xj0STkEOHYWmD7xxjfoo5Ib1YX4LEO7dbwhWDiqR50uDwIwutQ>
    <xmx:Ksr5XkwUtxy-1NlcHmFiVzXIUdqbmDtVr5JDiVWyO6iYtLxhOm8FBT_RHdM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B8C653280065;
        Mon, 29 Jun 2020 07:02:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix race between block group removal and block group" failed to apply to 4.19-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:01:53 +0200
Message-ID: <15934285134248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From ffcb9d44572afbaf8fa6dbf5115bff6dab7b299e Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 1 Jun 2020 19:12:19 +0100
Subject: [PATCH] btrfs: fix race between block group removal and block group
 creation

There is a race between block group removal and block group creation
when the removal is completed by a task running fitrim or scrub. When
this happens we end up failing the block group creation with an error
-EEXIST since we attempt to insert a duplicate block group item key
in the extent tree. That results in a transaction abort.

The race happens like this:

1) Task A is doing a fitrim, and at btrfs_trim_block_group() it freezes
   block group X with btrfs_freeze_block_group() (until very recently
   that was named btrfs_get_block_group_trimming());

2) Task B starts removing block group X, either because it's now unused
   or due to relocation for example. So at btrfs_remove_block_group(),
   while holding the chunk mutex and the block group's lock, it sets
   the 'removed' flag of the block group and it sets the local variable
   'remove_em' to false, because the block group is currently frozen
   (its 'frozen' counter is > 0, until very recently this counter was
   named 'trimming');

3) Task B unlocks the block group and the chunk mutex;

4) Task A is done trimming the block group and unfreezes the block group
   by calling btrfs_unfreeze_block_group() (until very recently this was
   named btrfs_put_block_group_trimming()). In this function we lock the
   block group and set the local variable 'cleanup' to true because we
   were able to decrement the block group's 'frozen' counter down to 0 and
   the flag 'removed' is set in the block group.

   Since 'cleanup' is set to true, it locks the chunk mutex and removes
   the extent mapping representing the block group from the mapping tree;

5) Task C allocates a new block group Y and it picks up the logical address
   that block group X had as the logical address for Y, because X was the
   block group with the highest logical address and now the second block
   group with the highest logical address, the last in the fs mapping tree,
   ends at an offset corresponding to block group X's logical address (this
   logical address selection is done at volumes.c:find_next_chunk()).

   At this point the new block group Y does not have yet its item added
   to the extent tree (nor the corresponding device extent items and
   chunk item in the device and chunk trees). The new group Y is added to
   the list of pending block groups in the transaction handle;

6) Before task B proceeds to removing the block group item for block
   group X from the extent tree, which has a key matching:

   (X logical offset, BTRFS_BLOCK_GROUP_ITEM_KEY, length)

   task C while ending its transaction handle calls
   btrfs_create_pending_block_groups(), which finds block group Y and
   tries to insert the block group item for Y into the exten tree, which
   fails with -EEXIST since logical offset is the same that X had and
   task B hasn't yet deleted the key from the extent tree.
   This failure results in a transaction abort, producing a stack like
   the following:

------------[ cut here ]------------
 BTRFS: Transaction aborted (error -17)
 WARNING: CPU: 2 PID: 19736 at fs/btrfs/block-group.c:2074 btrfs_create_pending_block_groups+0x1eb/0x260 [btrfs]
 Modules linked in: btrfs blake2b_generic xor raid6_pq (...)
 CPU: 2 PID: 19736 Comm: fsstress Tainted: G        W         5.6.0-rc7-btrfs-next-58 #5
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
 RIP: 0010:btrfs_create_pending_block_groups+0x1eb/0x260 [btrfs]
 Code: ff ff ff 48 8b 55 50 f0 48 (...)
 RSP: 0018:ffffa4160a1c7d58 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: ffff961581909d98 RCX: 0000000000000000
 RDX: 0000000000000001 RSI: ffffffffb3d63990 RDI: 0000000000000001
 RBP: ffff9614f3356a58 R08: 0000000000000000 R09: 0000000000000001
 R10: ffff9615b65b0040 R11: 0000000000000000 R12: ffff961581909c10
 R13: ffff9615b0c32000 R14: ffff9614f3356ab0 R15: ffff9614be779000
 FS:  00007f2ce2841e80(0000) GS:ffff9615bae00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000555f18780000 CR3: 0000000131d34005 CR4: 00000000003606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  btrfs_start_dirty_block_groups+0x398/0x4e0 [btrfs]
  btrfs_commit_transaction+0xd0/0xc50 [btrfs]
  ? btrfs_attach_transaction_barrier+0x1e/0x50 [btrfs]
  ? __ia32_sys_fdatasync+0x20/0x20
  iterate_supers+0xdb/0x180
  ksys_sync+0x60/0xb0
  __ia32_sys_sync+0xa/0x10
  do_syscall_64+0x5c/0x280
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7f2ce1d4d5b7
 Code: 83 c4 08 48 3d 01 (...)
 RSP: 002b:00007ffd8b558c58 EFLAGS: 00000202 ORIG_RAX: 00000000000000a2
 RAX: ffffffffffffffda RBX: 000000000000002c RCX: 00007f2ce1d4d5b7
 RDX: 00000000ffffffff RSI: 00000000186ba07b RDI: 000000000000002c
 RBP: 0000555f17b9e520 R08: 0000000000000012 R09: 000000000000ce00
 R10: 0000000000000078 R11: 0000000000000202 R12: 0000000000000032
 R13: 0000000051eb851f R14: 00007ffd8b558cd0 R15: 0000555f1798ec20
 irq event stamp: 0
 hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 hardirqs last disabled at (0): [<ffffffffb2abdedf>] copy_process+0x74f/0x2020
 softirqs last  enabled at (0): [<ffffffffb2abdedf>] copy_process+0x74f/0x2020
 softirqs last disabled at (0): [<0000000000000000>] 0x0
 ---[ end trace bd7c03622e0b0a9c ]---

Fix this simply by making btrfs_remove_block_group() remove the block
group's item from the extent tree before it flags the block group as
removed. Also make the free space deletion from the free space tree
before flagging the block group as removed, to avoid a similar race
with adding and removing free space entries for the free space tree.

Fixes: 04216820fe83d5 ("Btrfs: fix race between fs trimming and block group remove/allocation")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 6462dd0b155c..c037ef514b64 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1092,6 +1092,25 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	spin_unlock(&block_group->space_info->lock);
 
+	/*
+	 * Remove the free space for the block group from the free space tree
+	 * and the block group's item from the extent tree before marking the
+	 * block group as removed. This is to prevent races with tasks that
+	 * freeze and unfreeze a block group, this task and another task
+	 * allocating a new block group - the unfreeze task ends up removing
+	 * the block group's extent map before the task calling this function
+	 * deletes the block group item from the extent tree, allowing for
+	 * another task to attempt to create another block group with the same
+	 * item key (and failing with -EEXIST and a transaction abort).
+	 */
+	ret = remove_block_group_free_space(trans, block_group);
+	if (ret)
+		goto out;
+
+	ret = remove_block_group_item(trans, path, block_group);
+	if (ret < 0)
+		goto out;
+
 	mutex_lock(&fs_info->chunk_mutex);
 	spin_lock(&block_group->lock);
 	block_group->removed = 1;
@@ -1126,14 +1145,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	mutex_unlock(&fs_info->chunk_mutex);
 
-	ret = remove_block_group_free_space(trans, block_group);
-	if (ret)
-		goto out;
-
-	ret = remove_block_group_item(trans, path, block_group);
-	if (ret < 0)
-		goto out;
-
 	if (remove_em) {
 		struct extent_map_tree *em_tree;
 

