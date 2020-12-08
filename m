Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C987F2D2B91
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 14:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbgLHNBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 08:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbgLHNBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 08:01:16 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495C2C0613D6
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 05:00:36 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id e25so2297098wme.0
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 05:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tI3e2CqSnRhXifsrp/Mvx8sioK4kqmaqXNcVl6cAD5A=;
        b=P1Pa+PcmsW2DlBcoPoh/dtcgq89wmat8ZmSwSUg6kjCJNY0dYl8KQdN7ziaE+Cvx3+
         ZVFsp5IVMywu94aTsSfLoYP2l2WGDTbU/shHK/kw5dojPmld8oaY4Ga4BFaYrEVkBe64
         fa8jbYT1k9Z13X0//ru+qdUyoZRKGH72ONimvL26j/8SwxD7T5wPGaypy9vcI04m/pIW
         7nwK2RlartfVBO5o0HT1bjSPkfi6WlUItq8ZHQc16/FzfrJNSKAYSU2yAjOW+0Tutrrv
         ipGTvlaPrKeEYIO4I7kcnFbfLDQRp2chccuIYMYJfROEh+sSVR8l5FDIGgPBzzwHH9Et
         UAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tI3e2CqSnRhXifsrp/Mvx8sioK4kqmaqXNcVl6cAD5A=;
        b=aQJG/fpPQ+ZioWKsAkQAqz6dHJI6J5IxwdOQXBqW5pPQKbhxiSY1e+nwIYlWM9AotL
         kgVApN9d0/olR7tidzzpMrEim9XdtzZHk7NmBRY7SrjWQ6ZKBKNyADzKFYpbZrso6N5j
         06WAKmHUZaXsRtkPwDkemSVOwqXaOXxyf+IIaJRdEUuok5nF5y0XCeXvaFr+eHUlc9uC
         cub5ax/7iF3iPau0rh1PN9cfsKtSYPEYKdEkLNbPtO2Bo3vwDp+Lijdcn0XcgEey+csT
         D7oaJy7XquxdgaCLGpaD9SDkxy+bcs0WENrQ3j9hf39+i3+lBK7rGhl/IVaCK7ZkLrUX
         rtfQ==
X-Gm-Message-State: AOAM5317dXqwgeoPlnRIjIaARxWpQ68V8N3nMW2BHytlckuTjhJdbRNX
        xceS+unHLzoVohoN6qH+TabpfBVTlJC/xg==
X-Google-Smtp-Source: ABdhPJz+wERrqp1ckaIr/cM2EVVVr24g5DR2DELhHnQD9JTPICRNB2lhoXWyM1L4I/URrffqTlTBdg==
X-Received: by 2002:a7b:c4d5:: with SMTP id g21mr3821460wmk.92.1607432433904;
        Tue, 08 Dec 2020 05:00:33 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id t1sm7599197wro.27.2020.12.08.05.00.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Dec 2020 05:00:33 -0800 (PST)
Date:   Tue, 8 Dec 2020 13:00:31 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: sysfs: init devices outside of the
 chunk_mutex" failed to apply to 4.9-stable tree
Message-ID: <20201208130031.dxffwwpu5p2lbvjh@debian>
References: <1604411571222140@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hq7pdhsnjjiym53j"
Content-Disposition: inline
In-Reply-To: <1604411571222140@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hq7pdhsnjjiym53j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Tue, Nov 03, 2020 at 02:52:51PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.4-stable.

--
Regards
Sudip

--hq7pdhsnjjiym53j
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-btrfs-sysfs-init-devices-outside-of-the-chunk_mutex.patch"

From d26ba9698041e589a6677bebabca15e7407e4e2d Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 1 Sep 2020 08:09:01 -0400
Subject: [PATCH] btrfs: sysfs: init devices outside of the chunk_mutex

commit ca10845a56856fff4de3804c85e6424d0f6d0cde upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/volumes.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7391634520ab..6afaacb791a1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2431,9 +2431,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	btrfs_set_super_num_devices(root->fs_info->super_copy,
 				    tmp + 1);
 
-	/* add sysfs device entry */
-	btrfs_sysfs_add_device_link(root->fs_info->fs_devices, device);
-
 	/*
 	 * we've got more storage, clear any full flags on the space
 	 * infos
@@ -2441,6 +2438,10 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	btrfs_clear_space_info_full(root->fs_info);
 
 	unlock_chunks(root);
+
+	/* add sysfs device entry */
+	btrfs_sysfs_add_device_link(root->fs_info->fs_devices, device);
+
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	if (seeding_dev) {
-- 
2.11.0


--hq7pdhsnjjiym53j--
