Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A93333015D
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhCGNsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:48:09 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54767 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231439AbhCGNrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:47:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B1E091A13;
        Sun,  7 Mar 2021 08:47:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:47:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lYVBlr
        qjx6jHnLXSw7XiyQYJs3DS0JX4RovlxDcM0n0=; b=iUZj+35JQWhX6tilFN2R9l
        Tj8+IXlVlbbeJ3SddG/PAZ/97IWvY0wJ4w33GEzlVCOyQklagkaqc50ixLWqGAXd
        tM9EezwH0SEsgFcDVcIvER9/gNNL8WHSHEUSaugB/40x4V9t00QsOX7SsLr1R5zb
        h2xkdyqJJ544UyapAT6awDGVaqhEEPpGvqEVaWiJ8+7kfDzR88esP0RtRoMb3Kzc
        0LZ7WM4X+LCpRSiR0YOWqJsd7k1preU201VbG7py158JTmexM+xzM3wZwcRzj/Pv
        ln9otJxPzg9Kqre/P07lVTiwdtxXmpiqqcT7ECist/gd5AUFk2jEhoqtmJzxikwg
        ==
X-ME-Sender: <xms:itlEYO-5ozMW9bIrJYOVg9uDoxywVeipd7zQQ1vEqdKllv8JpFQKVA>
    <xme:itlEYOsADQiISywPL_hn79l8m7NsoKfNoSBUeEFXVT95sa45fsl08c2PYB7dq48AA
    VAlXenm1Wf1fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:itlEYEDeYLZ8qf5cXVM3KxErZgltyqfAh7V0azO7iwDOjbrSODqRmA>
    <xmx:itlEYGeNz1ZA1sBzy5uNCWjlUihPPfRVxk4E5JcqjcByNr_v38WFTg>
    <xmx:itlEYDODoVgPumOMo-JY76uqu639uW2jZ5NWYtnRxu8K-KtELCcwUA>
    <xmx:itlEYMajeB1jtAr6xnJfWzMQdoFcNVweJUlgwLfVqg8VIYsTwzh7t-v87wI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 06E3624005A;
        Sun,  7 Mar 2021 08:47:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix race between swap file activation and snapshot" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, anand.jain@oracle.com, dsterba@suse.com,
        josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:47:52 +0100
Message-ID: <161512487216750@kroah.com>
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

From dd0734f2a866f9d619d4abf97c3d71bcdee40ea9 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Fri, 5 Feb 2021 12:55:38 +0000
Subject: [PATCH] btrfs: fix race between swap file activation and snapshot
 creation

When creating a snapshot we check if the current number of swap files, in
the root, is non-zero, and if it is, we error out and warn that we can not
create the snapshot because there are active swap files.

However this is racy because when a task started activation of a swap
file, another task might have started already snapshot creation and might
have seen the counter for the number of swap files as zero. This means
that after the swap file is activated we may end up with a snapshot of the
same root successfully created, and therefore when the first write to the
swap file happens it has to fall back into COW mode, which should never
happen for active swap files.

Basically what can happen is:

1) Task A starts snapshot creation and enters ioctl.c:create_snapshot().
   There it sees that root->nr_swapfiles has a value of 0 so it continues;

2) Task B enters btrfs_swap_activate(). It is not aware that another task
   started snapshot creation but it did not finish yet. It increments
   root->nr_swapfiles from 0 to 1;

3) Task B checks that the file meets all requirements to be an active
   swap file - it has NOCOW set, there are no snapshots for the inode's
   root at the moment, no file holes, no reflinked extents, etc;

4) Task B returns success and now the file is an active swap file;

5) Task A commits the transaction to create the snapshot and finishes.
   The swap file's extents are now shared between the original root and
   the snapshot;

6) A write into an extent of the swap file is attempted - there is a
   snapshot of the file's root, so we fall back to COW mode and therefore
   the physical location of the extent changes on disk.

So fix this by taking the snapshot lock during swap file activation before
locking the extent range, as that is the order in which we lock these
during buffered writes.

Fixes: ed46ff3d42378 ("Btrfs: support swap files")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 30358a2e2bc0..4f2f1e932751 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10298,7 +10298,8 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 			       sector_t *span)
 {
 	struct inode *inode = file_inode(file);
-	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_state *cached_state = NULL;
 	struct extent_map *em = NULL;
@@ -10349,13 +10350,27 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	   "cannot activate swapfile while exclusive operation is running");
 		return -EBUSY;
 	}
+
+	/*
+	 * Prevent snapshot creation while we are activating the swap file.
+	 * We do not want to race with snapshot creation. If snapshot creation
+	 * already started before we bumped nr_swapfiles from 0 to 1 and
+	 * completes before the first write into the swap file after it is
+	 * activated, than that write would fallback to COW.
+	 */
+	if (!btrfs_drew_try_write_lock(&root->snapshot_lock)) {
+		btrfs_exclop_finish(fs_info);
+		btrfs_warn(fs_info,
+	   "cannot activate swapfile because snapshot creation is in progress");
+		return -EINVAL;
+	}
 	/*
 	 * Snapshots can create extents which require COW even if NODATACOW is
 	 * set. We use this counter to prevent snapshots. We must increment it
 	 * before walking the extents because we don't want a concurrent
 	 * snapshot to run after we've already checked the extents.
 	 */
-	atomic_inc(&BTRFS_I(inode)->root->nr_swapfiles);
+	atomic_inc(&root->nr_swapfiles);
 
 	isize = ALIGN_DOWN(inode->i_size, fs_info->sectorsize);
 
@@ -10501,6 +10516,8 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	if (ret)
 		btrfs_swap_deactivate(file);
 
+	btrfs_drew_write_unlock(&root->snapshot_lock);
+
 	btrfs_exclop_finish(fs_info);
 
 	if (ret)

