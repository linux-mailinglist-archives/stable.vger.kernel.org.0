Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E2E249B9F
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgHSLWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:22:47 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:58635 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgHSLW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:22:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 174CD1940178;
        Wed, 19 Aug 2020 07:22:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:22:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ccTa4g
        t9PXthUcNZGb0c+UlLBr0PlhTwB/uU/qdKfmY=; b=hoFD5Bs46A18fBVhWbSqXf
        BKnFufb8YgBsQWavsb4yiScBafz9tN24GZqerZLOrh1ZNAu8V7wMRwqyxAuRlLVn
        qqEirT4ThU7As/i/ak1i6KGSuhQG5/8lLTRoOzB1wfYci53VHFMEA5H6XnmYJHLx
        cw1gsR4RhLXK+aprZ5yMP/DrOEVvBTPW545kZJCF/hm+8mJG6gpxyAB6Ud0AGggM
        ymyKqFMQcPx7Jrl2SDcKQ5IMu0QK32na8WOHQXsIWyGMX+QV0ApCnJOkRC3I8HVW
        yPLWLc7OH9ZV0jV8XUqEVpDYBFCK/u3pbBC575J/g5pi0uwpSd0IFK8EmmaG9MTA
        ==
X-ME-Sender: <xms:aQs9X66t9iWF6_9rVIbDykXuH6ptfixgv-mLqn-cH8b4vf3Nikm_BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnheptdevtefhjeffvdefuedvgfefueektddthffhtdegie
    ffvedvtdekffehueejfefhnecuffhomhgrihhnpehophgvnhhsuhhsvgdrohhrghenucfk
    phepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:aQs9Xz5jcBK59mtIRu_SAwV7XtzbmPh3mU2nmmmDz2zuO8lR3paByA>
    <xmx:aQs9X5dNjAthHc_9nwBNe1xwftmu7tkikvhom01Z1sWbxR0udPwpSA>
    <xmx:aQs9X3IfirZEwQV7sW2Y1UahB-VdaVBZ45qKz8Kgomjd28oJDqvgsQ>
    <xmx:ags9X9l_2ndNSPVo7Pl16LwGaRKdaBusRTc2F7sN42FUUGjTRk3cVw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACC273280059;
        Wed, 19 Aug 2020 07:22:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: sysfs: use NOFS for device creation" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:22:40 +0200
Message-ID: <159783616081156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From a47bd78d0c44621efb98b525d04d60dc4d1a79b0 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 21 Jul 2020 10:17:50 -0400
Subject: [PATCH] btrfs: sysfs: use NOFS for device creation

Dave hit this splat during testing btrfs/078:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.8.0-rc6-default+ #1191 Not tainted
  ------------------------------------------------------
  kswapd0/75 is trying to acquire lock:
  ffffa040e9d04ff8 (&delayed_node->mutex){+.+.}-{3:3}, at: __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]

  but task is already holding lock:
  ffffffff8b0c8040 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #2 (fs_reclaim){+.+.}-{0:0}:
	 __lock_acquire+0x56f/0xaa0
	 lock_acquire+0xa3/0x440
	 fs_reclaim_acquire.part.0+0x25/0x30
	 __kmalloc_track_caller+0x49/0x330
	 kstrdup+0x2e/0x60
	 __kernfs_new_node.constprop.0+0x44/0x250
	 kernfs_new_node+0x25/0x50
	 kernfs_create_link+0x34/0xa0
	 sysfs_do_create_link_sd+0x5e/0xd0
	 btrfs_sysfs_add_devices_dir+0x65/0x100 [btrfs]
	 btrfs_init_new_device+0x44c/0x12b0 [btrfs]
	 btrfs_ioctl+0xc3c/0x25c0 [btrfs]
	 ksys_ioctl+0x68/0xa0
	 __x64_sys_ioctl+0x16/0x20
	 do_syscall_64+0x50/0xe0
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #1 (&fs_info->chunk_mutex){+.+.}-{3:3}:
	 __lock_acquire+0x56f/0xaa0
	 lock_acquire+0xa3/0x440
	 __mutex_lock+0xa0/0xaf0
	 btrfs_chunk_alloc+0x137/0x3e0 [btrfs]
	 find_free_extent+0xb44/0xfb0 [btrfs]
	 btrfs_reserve_extent+0x9b/0x180 [btrfs]
	 btrfs_alloc_tree_block+0xc1/0x350 [btrfs]
	 alloc_tree_block_no_bg_flush+0x4a/0x60 [btrfs]
	 __btrfs_cow_block+0x143/0x7a0 [btrfs]
	 btrfs_cow_block+0x15f/0x310 [btrfs]
	 push_leaf_right+0x150/0x240 [btrfs]
	 split_leaf+0x3cd/0x6d0 [btrfs]
	 btrfs_search_slot+0xd14/0xf70 [btrfs]
	 btrfs_insert_empty_items+0x64/0xc0 [btrfs]
	 __btrfs_commit_inode_delayed_items+0xb2/0x840 [btrfs]
	 btrfs_async_run_delayed_root+0x10e/0x1d0 [btrfs]
	 btrfs_work_helper+0x2f9/0x650 [btrfs]
	 process_one_work+0x22c/0x600
	 worker_thread+0x50/0x3b0
	 kthread+0x137/0x150
	 ret_from_fork+0x1f/0x30

  -> #0 (&delayed_node->mutex){+.+.}-{3:3}:
	 check_prev_add+0x98/0xa20
	 validate_chain+0xa8c/0x2a00
	 __lock_acquire+0x56f/0xaa0
	 lock_acquire+0xa3/0x440
	 __mutex_lock+0xa0/0xaf0
	 __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
	 btrfs_evict_inode+0x3bf/0x560 [btrfs]
	 evict+0xd6/0x1c0
	 dispose_list+0x48/0x70
	 prune_icache_sb+0x54/0x80
	 super_cache_scan+0x121/0x1a0
	 do_shrink_slab+0x175/0x420
	 shrink_slab+0xb1/0x2e0
	 shrink_node+0x192/0x600
	 balance_pgdat+0x31f/0x750
	 kswapd+0x206/0x510
	 kthread+0x137/0x150
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

  3 locks held by kswapd0/75:
   #0: ffffffff8b0c8040 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30
   #1: ffffffff8b0b50b8 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x54/0x2e0
   #2: ffffa040e057c0e8 (&type->s_umount_key#26){++++}-{3:3}, at: trylock_super+0x16/0x50

  stack backtrace:
  CPU: 2 PID: 75 Comm: kswapd0 Not tainted 5.8.0-rc6-default+ #1191
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   dump_stack+0x78/0xa0
   check_noncircular+0x16f/0x190
   check_prev_add+0x98/0xa20
   validate_chain+0xa8c/0x2a00
   __lock_acquire+0x56f/0xaa0
   lock_acquire+0xa3/0x440
   ? __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
   __mutex_lock+0xa0/0xaf0
   ? __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
   ? __lock_acquire+0x56f/0xaa0
   ? __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
   ? lock_acquire+0xa3/0x440
   ? btrfs_evict_inode+0x138/0x560 [btrfs]
   ? btrfs_evict_inode+0x2fe/0x560 [btrfs]
   ? __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
   __btrfs_release_delayed_node.part.0+0x3f/0x310 [btrfs]
   btrfs_evict_inode+0x3bf/0x560 [btrfs]
   evict+0xd6/0x1c0
   dispose_list+0x48/0x70
   prune_icache_sb+0x54/0x80
   super_cache_scan+0x121/0x1a0
   do_shrink_slab+0x175/0x420
   shrink_slab+0xb1/0x2e0
   shrink_node+0x192/0x600
   balance_pgdat+0x31f/0x750
   kswapd+0x206/0x510
   ? _raw_spin_unlock_irqrestore+0x3e/0x50
   ? finish_wait+0x90/0x90
   ? balance_pgdat+0x750/0x750
   kthread+0x137/0x150
   ? kthread_stop+0x2a0/0x2a0
   ret_from_fork+0x1f/0x30

This is because we're holding the chunk_mutex while adding this device
and adding its sysfs entries.  We actually hold different locks in
different places when calling this function, the dev_replace semaphore
for instance in dev replace, so instead of moving this call around
simply wrap it's operations in NOFS.

CC: stable@vger.kernel.org # 4.14+
Reported-by: David Sterba <dsterba@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 38c0b95e0e7f..104c80caaa74 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1278,7 +1278,9 @@ int btrfs_sysfs_add_devices_dir(struct btrfs_fs_devices *fs_devices,
 {
 	int error = 0;
 	struct btrfs_device *dev;
+	unsigned int nofs_flag;
 
+	nofs_flag = memalloc_nofs_save();
 	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
 
 		if (one_device && one_device != dev)
@@ -1306,6 +1308,7 @@ int btrfs_sysfs_add_devices_dir(struct btrfs_fs_devices *fs_devices,
 			break;
 		}
 	}
+	memalloc_nofs_restore(nofs_flag);
 
 	return error;
 }

