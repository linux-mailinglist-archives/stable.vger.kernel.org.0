Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1B32A46E6
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbgKCNwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:52:09 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44891 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729465AbgKCNwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:52:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 26F209CA;
        Tue,  3 Nov 2020 08:52:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 08:52:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YHomKK
        FTCq9ZH5mKx0sOAsVuM5izkiHB3mPJlbG6G2Q=; b=D6Oln0Mt/UQypVlrRHwrbU
        ttdxQ/kWBudLGUE6CHpp97yz0C+CtRAPdzAiHR89LnANcaWAv98GU31eNZ0roygO
        jLX20Z8UbiuimkcDzD0HfY2+0WctMMDmw9BqQIUDoJFHWqErE0ksKjOaC8HYj6+E
        h+7pBYNAFiPjcWQAFp52vBdM6yeboYsBzqBor2BVJNi58rA403JmB/wGgNkrXuTx
        C6AwdlViQreULnvTW7E8x5lt6vsJ0Q4Lvg3UMUz0KmVA6wAgaLb9qW6BtoCbgFN/
        zm884OlERtpT1uwieiZcvPQmPcFagIygS9r1JqQSMAVuOvqckXm+9BUQR3rRSNlw
        ==
X-ME-Sender: <xms:g2ChX3AZzM7v3LMz2uiweXwPCPTAT16CKYyP1ItNjp5k4QW1H4RRow>
    <xme:g2ChX9iQ90YNzw0S5SxzrbB_dNmQIRRTlQITr1lmtRg6d7l-AKUA3lG3oMPrTsC5x
    ghXHuzdGSwWXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:g2ChXykUC3Lako2hvh5I-G_cyW6S647sjXh4otloepDjhYkFSAB1oQ>
    <xmx:g2ChX5zXg-uQblSjHBm6tDLLhkNf1e8FRErjJaK8NYCZXsdHET5Flw>
    <xmx:g2ChX8S57AIlz5xkgJo_iWezHQDHaHTi5C1Q3EgCaEHL6ut6VoRzjA>
    <xmx:g2ChX14tLR4hc1RIQVqwhoaYDTtHkeynFjgllnj3aV4-knQ0_Xa1tEHAfgM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 676593064610;
        Tue,  3 Nov 2020 08:52:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: sysfs: init devices outside of the chunk_mutex" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 14:52:54 +0100
Message-ID: <160441157478123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca10845a56856fff4de3804c85e6424d0f6d0cde Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 1 Sep 2020 08:09:01 -0400
Subject: [PATCH] btrfs: sysfs: init devices outside of the chunk_mutex

While running btrfs/061, btrfs/073, btrfs/078, or btrfs/178 we hit the
following lockdep splat:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.9.0-rc3+ #4 Not tainted
  ------------------------------------------------------
  kswapd0/100 is trying to acquire lock:
  ffff96ecc22ef4a0 (&delayed_node->mutex){+.+.}-{3:3}, at: __btrfs_release_delayed_node.part.0+0x3f/0x330

  but task is already holding lock:
  ffffffff8dd74700 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #3 (fs_reclaim){+.+.}-{0:0}:
	 fs_reclaim_acquire+0x65/0x80
	 slab_pre_alloc_hook.constprop.0+0x20/0x200
	 kmem_cache_alloc+0x37/0x270
	 alloc_inode+0x82/0xb0
	 iget_locked+0x10d/0x2c0
	 kernfs_get_inode+0x1b/0x130
	 kernfs_get_tree+0x136/0x240
	 sysfs_get_tree+0x16/0x40
	 vfs_get_tree+0x28/0xc0
	 path_mount+0x434/0xc00
	 __x64_sys_mount+0xe3/0x120
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #2 (kernfs_mutex){+.+.}-{3:3}:
	 __mutex_lock+0x7e/0x7e0
	 kernfs_add_one+0x23/0x150
	 kernfs_create_link+0x63/0xa0
	 sysfs_do_create_link_sd+0x5e/0xd0
	 btrfs_sysfs_add_devices_dir+0x81/0x130
	 btrfs_init_new_device+0x67f/0x1250
	 btrfs_ioctl+0x1ef/0x2e20
	 __x64_sys_ioctl+0x83/0xb0
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
	 btrfs_insert_empty_items+0x64/0xb0
	 btrfs_insert_delayed_items+0x90/0x4f0
	 btrfs_commit_inode_delayed_items+0x93/0x140
	 btrfs_log_inode+0x5de/0x2020
	 btrfs_log_inode_parent+0x429/0xc90
	 btrfs_log_new_name+0x95/0x9b
	 btrfs_rename2+0xbb9/0x1800
	 vfs_rename+0x64f/0x9f0
	 do_renameat2+0x320/0x4e0
	 __x64_sys_rename+0x1f/0x30
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (&delayed_node->mutex){+.+.}-{3:3}:
	 __lock_acquire+0x119c/0x1fc0
	 lock_acquire+0xa7/0x3d0
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
    &delayed_node->mutex --> kernfs_mutex --> fs_reclaim

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(fs_reclaim);
				 lock(kernfs_mutex);
				 lock(fs_reclaim);
    lock(&delayed_node->mutex);

   *** DEADLOCK ***

  3 locks held by kswapd0/100:
   #0: ffffffff8dd74700 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30
   #1: ffffffff8dd65c50 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x115/0x290
   #2: ffff96ed2ade30e0 (&type->s_umount_key#36){++++}-{3:3}, at: super_cache_scan+0x38/0x1e0

  stack backtrace:
  CPU: 0 PID: 100 Comm: kswapd0 Not tainted 5.9.0-rc3+ #4
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  Call Trace:
   dump_stack+0x8b/0xb8
   check_noncircular+0x12d/0x150
   __lock_acquire+0x119c/0x1fc0
   lock_acquire+0xa7/0x3d0
   ? __btrfs_release_delayed_node.part.0+0x3f/0x330
   __mutex_lock+0x7e/0x7e0
   ? __btrfs_release_delayed_node.part.0+0x3f/0x330
   ? __btrfs_release_delayed_node.part.0+0x3f/0x330
   ? lock_acquire+0xa7/0x3d0
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
   ? _raw_spin_unlock_irqrestore+0x41/0x50
   ? add_wait_queue_exclusive+0x70/0x70
   ? balance_pgdat+0x670/0x670
   kthread+0x138/0x160
   ? kthread_create_worker_on_cpu+0x40/0x40
   ret_from_fork+0x1f/0x30

This happens because we are holding the chunk_mutex at the time of
adding in a new device.  However we only need to hold the
device_list_mutex, as we're going to iterate over the fs_devices
devices.  Move the sysfs init stuff outside of the chunk_mutex to get
rid of this lockdep splat.

CC: stable@vger.kernel.org # 4.4.x: f3cd2c58110dad14e: btrfs: sysfs, rename device_link add/remove functions
CC: stable@vger.kernel.org # 4.4.x
Reported-by: David Sterba <dsterba@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9d169cba8514..c86ffad04641 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2597,9 +2597,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_set_super_num_devices(fs_info->super_copy,
 				    orig_super_num_devices + 1);
 
-	/* add sysfs device entry */
-	btrfs_sysfs_add_devices_dir(fs_devices, device);
-
 	/*
 	 * we've got more storage, clear any full flags on the space
 	 * infos
@@ -2607,6 +2604,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_clear_space_info_full(fs_info);
 
 	mutex_unlock(&fs_info->chunk_mutex);
+
+	/* Add sysfs device entry */
+	btrfs_sysfs_add_devices_dir(fs_devices, device);
+
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (seeding_dev) {

