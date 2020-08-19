Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972A2249B86
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHSLSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:18:20 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53639 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgHSLSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:18:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id BAA1119426DC;
        Wed, 19 Aug 2020 07:17:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:17:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Fyqe65
        lyCUDRpC86GkDIoEpigd60Lzl2y4H/pYVK1jE=; b=tMCkirPQfkklipnkvzzIhG
        nhdHAq9H8KwBfVkHj1xBYO4BhIISiLZ1ew6gS/3g0+X8WCmj+9DxFZZuiA3DMrNG
        L4VTwx67JV2sGyHpkhmHXvRVY5Sl7EGI+7yJkOp7HdRwZFT1Sv4WTyGpR/Zc+Vq+
        0y1wEhi2zp0Z40tHacNg8V0XSw/5VIv0boPDOMoXbAKKsrOuJUtge6XE26XQxhSy
        L6FDHPw+KcvdQfk1cR+7EoDFaZlwB8Rnc7QEgT4iu7bfmALvrOqcRXJXQuL2NcWH
        6i70FI3+I+AXzbCSrEK35ENEBJ+25/IHW6i7GlpHY/zZjxIhEDl5LcrPviFK9VaA
        ==
X-ME-Sender: <xms:Zwo9X0d4hifqfD-HA6VVQhotBrFGpjXUyK1c279Hg8iC7erZhXWxww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Zwo9X2Mcu18KdGQi1nRTWrFRl-IiyD-aUQTecnALecs0r5r-lcrotg>
    <xmx:Zwo9X1hg0Npsz-r7eZaR7evULxqay2Yao6axzzaUTg1UAfrYJEZ13Q>
    <xmx:Zwo9X5-BS8fjgez_HkMUI8Zh63cB0IieseeXmEj7HyZISFfx7-gZrA>
    <xmx:Zwo9X20wuF0ftp3oxTeQHw0UKGFDiFqrSYSeBY4z5yxlyZ69ypMsSw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 26D80328005D;
        Wed, 19 Aug 2020 07:17:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: move the chunk_mutex in btrfs_read_chunk_tree" failed to apply to 4.19-stable tree
To:     josef@toxicpanda.com, anand.jain@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:18:21 +0200
Message-ID: <15978359018205@kroah.com>
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

From 01d01caf19ff7c537527d352d169c4368375c0a1 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 17 Jul 2020 15:12:28 -0400
Subject: [PATCH] btrfs: move the chunk_mutex in btrfs_read_chunk_tree

We are currently getting this lockdep splat in btrfs/161:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.8.0-rc5+ #20 Tainted: G            E
  ------------------------------------------------------
  mount/678048 is trying to acquire lock:
  ffff9b769f15b6e0 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: clone_fs_devices+0x4d/0x170 [btrfs]

  but task is already holding lock:
  ffff9b76abdb08d0 (&fs_info->chunk_mutex){+.+.}-{3:3}, at: btrfs_read_chunk_tree+0x6a/0x800 [btrfs]

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (&fs_info->chunk_mutex){+.+.}-{3:3}:
	 __mutex_lock+0x8b/0x8f0
	 btrfs_init_new_device+0x2d2/0x1240 [btrfs]
	 btrfs_ioctl+0x1de/0x2d20 [btrfs]
	 ksys_ioctl+0x87/0xc0
	 __x64_sys_ioctl+0x16/0x20
	 do_syscall_64+0x52/0xb0
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (&fs_devs->device_list_mutex){+.+.}-{3:3}:
	 __lock_acquire+0x1240/0x2460
	 lock_acquire+0xab/0x360
	 __mutex_lock+0x8b/0x8f0
	 clone_fs_devices+0x4d/0x170 [btrfs]
	 btrfs_read_chunk_tree+0x330/0x800 [btrfs]
	 open_ctree+0xb7c/0x18ce [btrfs]
	 btrfs_mount_root.cold+0x13/0xfa [btrfs]
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 fc_mount+0xe/0x40
	 vfs_kern_mount.part.0+0x71/0x90
	 btrfs_mount+0x13b/0x3e0 [btrfs]
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 do_mount+0x7de/0xb30
	 __x64_sys_mount+0x8e/0xd0
	 do_syscall_64+0x52/0xb0
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  other info that might help us debug this:

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(&fs_info->chunk_mutex);
				 lock(&fs_devs->device_list_mutex);
				 lock(&fs_info->chunk_mutex);
    lock(&fs_devs->device_list_mutex);

   *** DEADLOCK ***

  3 locks held by mount/678048:
   #0: ffff9b75ff5fb0e0 (&type->s_umount_key#63/1){+.+.}-{3:3}, at: alloc_super+0xb5/0x380
   #1: ffffffffc0c2fbc8 (uuid_mutex){+.+.}-{3:3}, at: btrfs_read_chunk_tree+0x54/0x800 [btrfs]
   #2: ffff9b76abdb08d0 (&fs_info->chunk_mutex){+.+.}-{3:3}, at: btrfs_read_chunk_tree+0x6a/0x800 [btrfs]

  stack backtrace:
  CPU: 2 PID: 678048 Comm: mount Tainted: G            E     5.8.0-rc5+ #20
  Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./890FX Deluxe5, BIOS P1.40 05/03/2011
  Call Trace:
   dump_stack+0x96/0xd0
   check_noncircular+0x162/0x180
   __lock_acquire+0x1240/0x2460
   ? asm_sysvec_apic_timer_interrupt+0x12/0x20
   lock_acquire+0xab/0x360
   ? clone_fs_devices+0x4d/0x170 [btrfs]
   __mutex_lock+0x8b/0x8f0
   ? clone_fs_devices+0x4d/0x170 [btrfs]
   ? rcu_read_lock_sched_held+0x52/0x60
   ? cpumask_next+0x16/0x20
   ? module_assert_mutex_or_preempt+0x14/0x40
   ? __module_address+0x28/0xf0
   ? clone_fs_devices+0x4d/0x170 [btrfs]
   ? static_obj+0x4f/0x60
   ? lockdep_init_map_waits+0x43/0x200
   ? clone_fs_devices+0x4d/0x170 [btrfs]
   clone_fs_devices+0x4d/0x170 [btrfs]
   btrfs_read_chunk_tree+0x330/0x800 [btrfs]
   open_ctree+0xb7c/0x18ce [btrfs]
   ? super_setup_bdi_name+0x79/0xd0
   btrfs_mount_root.cold+0x13/0xfa [btrfs]
   ? vfs_parse_fs_string+0x84/0xb0
   ? rcu_read_lock_sched_held+0x52/0x60
   ? kfree+0x2b5/0x310
   legacy_get_tree+0x30/0x50
   vfs_get_tree+0x28/0xc0
   fc_mount+0xe/0x40
   vfs_kern_mount.part.0+0x71/0x90
   btrfs_mount+0x13b/0x3e0 [btrfs]
   ? cred_has_capability+0x7c/0x120
   ? rcu_read_lock_sched_held+0x52/0x60
   ? legacy_get_tree+0x30/0x50
   legacy_get_tree+0x30/0x50
   vfs_get_tree+0x28/0xc0
   do_mount+0x7de/0xb30
   ? memdup_user+0x4e/0x90
   __x64_sys_mount+0x8e/0xd0
   do_syscall_64+0x52/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

This is because btrfs_read_chunk_tree() can come upon DEV_EXTENT's and
then read the device, which takes the device_list_mutex.  The
device_list_mutex needs to be taken before the chunk_mutex, so this is a
problem.  We only really need the chunk mutex around adding the chunk,
so move the mutex around read_one_chunk.

An argument could be made that we don't even need the chunk_mutex here
as it's during mount, and we are protected by various other locks.
However we already have special rules for ->device_list_mutex, and I'd
rather not have another special case for ->chunk_mutex.

CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 084b8227ea2c..d7670e2a9f39 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7077,7 +7077,6 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 	 * otherwise we don't need it.
 	 */
 	mutex_lock(&uuid_mutex);
-	mutex_lock(&fs_info->chunk_mutex);
 
 	/*
 	 * It is possible for mount and umount to race in such a way that
@@ -7135,7 +7134,9 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
+			mutex_lock(&fs_info->chunk_mutex);
 			ret = read_one_chunk(&found_key, leaf, chunk);
+			mutex_unlock(&fs_info->chunk_mutex);
 			if (ret)
 				goto error;
 		}
@@ -7165,7 +7166,6 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 	}
 	ret = 0;
 error:
-	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&uuid_mutex);
 
 	btrfs_free_path(path);

