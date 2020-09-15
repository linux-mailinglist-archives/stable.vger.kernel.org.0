Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC735269FE1
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 09:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgIOHfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 03:35:40 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:36741 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgIOHfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 03:35:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 10BBF779;
        Tue, 15 Sep 2020 03:35:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 15 Sep 2020 03:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=h8S8/D
        +9rLRuon47hJQAw2CFpp4dQqWI1kkZm1jsspo=; b=bcyy4ldlqo5UKT4BB8i72u
        pdFk4d6G5roXzB0Xqal8m+efkZ3sC2pmlkPqhO4lqrlRDJoSBp7FT4I5VcVMENsT
        LZGngWpiCSGsbtSXv30OwH97AfAa2Ry1S/U/rew7ALjp2UBDHb9Lq6+3N8PK33Go
        +6CpUIdK7Ca0mLkRVwc8WJN01J7GYNBdeJLhQrnXLLgV1z1z3CSd/9gT/DABalmT
        MFKjlVQgQL4ahFiodIbRerdNoM57eS//RRtDJ3t/Di2IfQHlUthXg/QTHLGMM8M7
        3dXlnMQ87HIAmn/Z+WVdDSWx2fV/EAwLbIGRDZGkdhJHdOPPl/nwkuRXfFVal5bg
        ==
X-ME-Sender: <xms:ym5gX8A9VnSm4pvc5eb5olKDfWkf7Gr4BMa1gaab8B7huo1FbxWcXg>
    <xme:ym5gX-jmKLlIurpQ6Q4XrfiNxitaEmGbe8vGgZMlTBrdfT1c2cMyoaVyRTy17XAEJ
    MFbSmyW92xTPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeijedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ym5gX_kYH5uXlBQHD-QCk--ELcozXRYhjaNSJl71QXuupFul1sQLNQ>
    <xmx:ym5gXyzEHDWKm6cWUYdJyCxXwKerx8WExnNCz2HdZrZt_yVkIBJeuw>
    <xmx:ym5gXxTTUrJLUJ-VmibwuTlyqsic1jp4ly9qWjFfE2wMBAsjfDjPgA>
    <xmx:ym5gX8eudRgUVL0he_5zmOpyVtCrkO8c-qrMNZACslnUpNgsDfLGlG1FDmw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D789306467E;
        Tue, 15 Sep 2020 03:35:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix lockdep splat in add_missing_dev" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, anand.jain@oracle.com, dsterba@suse.com,
        nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Sep 2020 09:35:36 +0200
Message-ID: <160015533617120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fccc0007b8dc952c6bc0805cdf842eb8ea06a639 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 31 Aug 2020 10:52:42 -0400
Subject: [PATCH] btrfs: fix lockdep splat in add_missing_dev

Nikolay reported a lockdep splat in generic/476 that I could reproduce
with btrfs/187.

  ======================================================
  WARNING: possible circular locking dependency detected
  5.9.0-rc2+ #1 Tainted: G        W
  ------------------------------------------------------
  kswapd0/100 is trying to acquire lock:
  ffff9e8ef38b6268 (&delayed_node->mutex){+.+.}-{3:3}, at: __btrfs_release_delayed_node.part.0+0x3f/0x330

  but task is already holding lock:
  ffffffffa9d74700 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #2 (fs_reclaim){+.+.}-{0:0}:
	 fs_reclaim_acquire+0x65/0x80
	 slab_pre_alloc_hook.constprop.0+0x20/0x200
	 kmem_cache_alloc_trace+0x3a/0x1a0
	 btrfs_alloc_device+0x43/0x210
	 add_missing_dev+0x20/0x90
	 read_one_chunk+0x301/0x430
	 btrfs_read_sys_array+0x17b/0x1b0
	 open_ctree+0xa62/0x1896
	 btrfs_mount_root.cold+0x12/0xea
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 vfs_kern_mount.part.0+0x71/0xb0
	 btrfs_mount+0x10d/0x379
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 path_mount+0x434/0xc00
	 __x64_sys_mount+0xe3/0x120
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #1 (&fs_info->chunk_mutex){+.+.}-{3:3}:
	 __mutex_lock+0x7e/0x7e0
	 btrfs_chunk_alloc+0x125/0x3a0
	 find_free_extent+0xdf6/0x1210
	 btrfs_reserve_extent+0xb3/0x1b0
	 btrfs_alloc_tree_block+0xb0/0x310
	 alloc_tree_block_no_bg_flush+0x4a/0x60
	 __btrfs_cow_block+0x11a/0x530
	 btrfs_cow_block+0x104/0x220
	 btrfs_search_slot+0x52e/0x9d0
	 btrfs_lookup_inode+0x2a/0x8f
	 __btrfs_update_delayed_inode+0x80/0x240
	 btrfs_commit_inode_delayed_inode+0x119/0x120
	 btrfs_evict_inode+0x357/0x500
	 evict+0xcf/0x1f0
	 vfs_rmdir.part.0+0x149/0x160
	 do_rmdir+0x136/0x1a0
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (&delayed_node->mutex){+.+.}-{3:3}:
	 __lock_acquire+0x1184/0x1fa0
	 lock_acquire+0xa4/0x3d0
	 __mutex_lock+0x7e/0x7e0
	 __btrfs_release_delayed_node.part.0+0x3f/0x330
	 btrfs_evict_inode+0x24c/0x500
	 evict+0xcf/0x1f0
	 dispose_list+0x48/0x70
	 prune_icache_sb+0x44/0x50
	 super_cache_scan+0x161/0x1e0
	 do_shrink_slab+0x178/0x3c0
	 shrink_slab+0x17c/0x290
	 shrink_node+0x2b2/0x6d0
	 balance_pgdat+0x30a/0x670
	 kswapd+0x213/0x4c0
	 kthread+0x138/0x160
	 ret_from_fork+0x1f/0x30

  other info that might help us debug this:

  Chain exists of:
    &delayed_node->mutex --> &fs_info->chunk_mutex --> fs_reclaim

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(fs_reclaim);
				 lock(&fs_info->chunk_mutex);
				 lock(fs_reclaim);
    lock(&delayed_node->mutex);

   *** DEADLOCK ***

  3 locks held by kswapd0/100:
   #0: ffffffffa9d74700 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30
   #1: ffffffffa9d65c50 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x115/0x290
   #2: ffff9e8e9da260e0 (&type->s_umount_key#48){++++}-{3:3}, at: super_cache_scan+0x38/0x1e0

  stack backtrace:
  CPU: 1 PID: 100 Comm: kswapd0 Tainted: G        W         5.9.0-rc2+ #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  Call Trace:
   dump_stack+0x92/0xc8
   check_noncircular+0x12d/0x150
   __lock_acquire+0x1184/0x1fa0
   lock_acquire+0xa4/0x3d0
   ? __btrfs_release_delayed_node.part.0+0x3f/0x330
   __mutex_lock+0x7e/0x7e0
   ? __btrfs_release_delayed_node.part.0+0x3f/0x330
   ? __btrfs_release_delayed_node.part.0+0x3f/0x330
   ? lock_acquire+0xa4/0x3d0
   ? btrfs_evict_inode+0x11e/0x500
   ? find_held_lock+0x2b/0x80
   __btrfs_release_delayed_node.part.0+0x3f/0x330
   btrfs_evict_inode+0x24c/0x500
   evict+0xcf/0x1f0
   dispose_list+0x48/0x70
   prune_icache_sb+0x44/0x50
   super_cache_scan+0x161/0x1e0
   do_shrink_slab+0x178/0x3c0
   shrink_slab+0x17c/0x290
   shrink_node+0x2b2/0x6d0
   balance_pgdat+0x30a/0x670
   kswapd+0x213/0x4c0
   ? _raw_spin_unlock_irqrestore+0x46/0x60
   ? add_wait_queue_exclusive+0x70/0x70
   ? balance_pgdat+0x670/0x670
   kthread+0x138/0x160
   ? kthread_create_worker_on_cpu+0x40/0x40
   ret_from_fork+0x1f/0x30

This is because we are holding the chunk_mutex when we call
btrfs_alloc_device, which does a GFP_KERNEL allocation.  We don't want
to switch that to a GFP_NOFS lock because this is the only place where
it matters.  So instead use memalloc_nofs_save() around the allocation
in order to avoid the lockdep splat.

Reported-by: Nikolay Borisov <nborisov@suse.com>
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 214856c4ccb1..117b43367629 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/bio.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
@@ -6484,8 +6485,17 @@ static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
 					    u64 devid, u8 *dev_uuid)
 {
 	struct btrfs_device *device;
+	unsigned int nofs_flag;
 
+	/*
+	 * We call this under the chunk_mutex, so we want to use NOFS for this
+	 * allocation, however we don't want to change btrfs_alloc_device() to
+	 * always do NOFS because we use it in a lot of other GFP_KERNEL safe
+	 * places.
+	 */
+	nofs_flag = memalloc_nofs_save();
 	device = btrfs_alloc_device(NULL, &devid, dev_uuid);
+	memalloc_nofs_restore(nofs_flag);
 	if (IS_ERR(device))
 		return device;
 

