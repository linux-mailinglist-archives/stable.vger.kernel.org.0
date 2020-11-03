Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83722A46EF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgKCNwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:52:17 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:47903 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729426AbgKCNvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:51:04 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EAAEE228;
        Tue,  3 Nov 2020 08:51:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 08:51:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fNySr3
        1T58peVktKHL+Tspgu9RGd0NDwPP27sL4e9Rc=; b=PfTqBBm7Agpyc+G6AWqAeY
        O+bZN7M7T9BckeeVdakesurunNvvkbu8E8k6DYsygW0cI/suarvxoUhRmTEgbTHv
        eYyxG99eyKQwQJbqlXkthQh4Ixz4pXmZHoyZGdjpobVVy2tRdXVIquYLvgk3EgbX
        Tm5uCovobC0AjfmACVSgW40OSMxi2cIF9/DkmOyTCyhUVeQiP3dOeXzPR9KiW6/j
        HRTRAsKQHrSLIF0ngXqlZC4NMZjeGUz3owpSbUSkTYSegi7xLcS6MFG016mYsNFm
        IVmQHXb7ofC/ZDB2Ueo1NHYEpg4qPDzyAmG4Dk5dljcES8g6aHD9NjO3GnGh7UrQ
        ==
X-ME-Sender: <xms:RmChXyeUUE7D21xN6Uwq_HYpbi94-mNZLT2CofpkQjewNyWyfRjNcA>
    <xme:RmChX8M6VGuKp13WIuCPtGsOskjMJGDvFNb4bVeaxSS51JwTV1l-CfrZM2VipcpPp
    LZfmJmTKe2O7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:RmChXziPzJwvG0jt6aSy_cHAw7VLp6xuQeQIYAlZ3apajnVIaRVLhQ>
    <xmx:RmChX_-2SGjkTUREXUugaKYF5J_A3EkyyxwXXGmSSSsIL36oyjfKKw>
    <xmx:RmChX-vItsyWtjFjmBaRgYr5aoodIvlywPb_9tXBi3yMKJis9vIUGw>
    <xmx:RmChXzUDOopO9Il0Hx4dC2ksmYfYJCC3O2Yr2VVsnnoMlv3ZmLe9Yv0KpN4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22D3F3064610;
        Tue,  3 Nov 2020 08:51:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: qgroup: fix qgroup meta rsv leak for subvolume" failed to apply to 4.19-stable tree
To:     wqu@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 14:51:48 +0100
Message-ID: <160441150821188@kroah.com>
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

From e85fde5162bf1b242cbd6daf7dba0f9b457d592b Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Fri, 24 Jul 2020 14:46:10 +0800
Subject: [PATCH] btrfs: qgroup: fix qgroup meta rsv leak for subvolume
 operations

[BUG]
When quota is enabled for TEST_DEV, generic/013 sometimes fails like this:

  generic/013 14s ... _check_dmesg: something found in dmesg (see xfstests-dev/results//generic/013.dmesg)

And with the following metadata leak:

  BTRFS warning (device dm-3): qgroup 0/1370 has unreleased space, type 2 rsv 49152
  ------------[ cut here ]------------
  WARNING: CPU: 2 PID: 47912 at fs/btrfs/disk-io.c:4078 close_ctree+0x1dc/0x323 [btrfs]
  Call Trace:
   btrfs_put_super+0x15/0x17 [btrfs]
   generic_shutdown_super+0x72/0x110
   kill_anon_super+0x18/0x30
   btrfs_kill_super+0x17/0x30 [btrfs]
   deactivate_locked_super+0x3b/0xa0
   deactivate_super+0x40/0x50
   cleanup_mnt+0x135/0x190
   __cleanup_mnt+0x12/0x20
   task_work_run+0x64/0xb0
   __prepare_exit_to_usermode+0x1bc/0x1c0
   __syscall_return_slowpath+0x47/0x230
   do_syscall_64+0x64/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  ---[ end trace a6cfd45ba80e4e06 ]---
  BTRFS error (device dm-3): qgroup reserved space leaked
  BTRFS info (device dm-3): disk space caching is enabled
  BTRFS info (device dm-3): has skinny extents

[CAUSE]
The qgroup preallocated meta rsv operations of that offending root are:

  btrfs_delayed_inode_reserve_metadata: rsv_meta_prealloc root=1370 num_bytes=131072
  btrfs_delayed_inode_reserve_metadata: rsv_meta_prealloc root=1370 num_bytes=131072
  btrfs_subvolume_reserve_metadata: rsv_meta_prealloc root=1370 num_bytes=49152
  btrfs_delayed_inode_release_metadata: convert_meta_prealloc root=1370 num_bytes=-131072
  btrfs_delayed_inode_release_metadata: convert_meta_prealloc root=1370 num_bytes=-131072

It's pretty obvious that, we reserve qgroup meta rsv in
btrfs_subvolume_reserve_metadata(), but doesn't have corresponding
release/convert calls in btrfs_subvolume_release_metadata().

This leads to the leakage.

[FIX]
To fix this bug, we should follow what we're doing in
btrfs_delalloc_reserve_metadata(), where we reserve qgroup space, and
add it to block_rsv->qgroup_rsv_reserved.

And free the qgroup reserved metadata space when releasing the
block_rsv.

To do this, we need to change the btrfs_subvolume_release_metadata() to
accept btrfs_root, and record the qgroup_to_release number, and call
btrfs_qgroup_convert_reserved_meta() for it.

Fixes: 733e03a0b26a ("btrfs: qgroup: Split meta rsv type into meta_prealloc and meta_pertrans")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index eb7adc069926..f9d4e0958e2e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2622,7 +2622,7 @@ enum btrfs_flush_state {
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
 				     int nitems, bool use_global_rsv);
-void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
+void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 				      struct btrfs_block_rsv *rsv);
 void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a50a40f8bef2..123521aa5595 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4051,7 +4051,7 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 		err = ret;
 	inode->i_flags |= S_DEAD;
 out_release:
-	btrfs_subvolume_release_metadata(fs_info, &block_rsv);
+	btrfs_subvolume_release_metadata(root, &block_rsv);
 out_up_write:
 	up_write(&fs_info->subvol_sem);
 	if (err) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a5355a16eabb..3779a6c12184 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -618,7 +618,7 @@ static noinline int create_subvol(struct inode *dir,
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		btrfs_subvolume_release_metadata(fs_info, &block_rsv);
+		btrfs_subvolume_release_metadata(root, &block_rsv);
 		goto fail_free;
 	}
 	trans->block_rsv = &block_rsv;
@@ -742,7 +742,7 @@ static noinline int create_subvol(struct inode *dir,
 	kfree(root_item);
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
-	btrfs_subvolume_release_metadata(fs_info, &block_rsv);
+	btrfs_subvolume_release_metadata(root, &block_rsv);
 
 	err = btrfs_commit_transaction(trans);
 	if (err && !ret)
@@ -856,7 +856,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (ret && pending_snapshot->snap)
 		pending_snapshot->snap->anon_dev = 0;
 	btrfs_put_root(pending_snapshot->snap);
-	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rsv);
+	btrfs_subvolume_release_metadata(root, &pending_snapshot->block_rsv);
 free_pending:
 	if (pending_snapshot->anon_dev)
 		free_anon_bdev(pending_snapshot->anon_dev);
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index c89697486366..702dc5441f03 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -512,11 +512,20 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 	if (ret && qgroup_num_bytes)
 		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
 
+	if (!ret) {
+		spin_lock(&rsv->lock);
+		rsv->qgroup_rsv_reserved += qgroup_num_bytes;
+		spin_unlock(&rsv->lock);
+	}
 	return ret;
 }
 
-void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
+void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 				      struct btrfs_block_rsv *rsv)
 {
-	btrfs_block_rsv_release(fs_info, rsv, (u64)-1, NULL);
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	u64 qgroup_to_release;
+
+	btrfs_block_rsv_release(fs_info, rsv, (u64)-1, &qgroup_to_release);
+	btrfs_qgroup_convert_reserved_meta(root, qgroup_to_release);
 }

