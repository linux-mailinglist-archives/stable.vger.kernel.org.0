Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B58301C22
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbhAXNXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:23:01 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:42205 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbhAXNXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:23:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DFE9BA7C;
        Sun, 24 Jan 2021 08:21:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:21:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=79AR/o
        lkpCfAZaXKfpXEF8L7lhdDqwFo4IexEpg8Svc=; b=O29dAXX7mZkLmzQMLsh5/x
        5qZsmISinkORf03ykS8QPGC1RIqOLzLYccfBIV+Kncwl8nYx+WBuaraXRBZGyzrE
        wA/olce/LADvB9GU6z00awCzwWrarZhgC1dztncbQOwpa1iPGjeOsCcKsjCC92u9
        7EjNYxKuV1TkkTSHmS6UoF4ucxwfYNlz86rT9tOooobuWAwk++y+WR17+R2c3fsz
        82lwfxSECrzdJZuS9o1U7pQBmC/poraUnzScIoIg5QfIT0qiVUPd0D24yYMMCAGP
        9v3SnHeLNAnlTNifuPOV3lmwvsxCs/smvvVQ8ySSOD3Tbmy9VeVBVOdD09Ak1Lew
        ==
X-ME-Sender: <xms:cnQNYOqR_apnmrIV6XgyasvY1QpSEYBEn6YJ17GgaaDfAl_f5UFHag>
    <xme:cnQNYMp4vVZkM9jJKNOVjSPx6v9uZxd1MDSYIZAmUi8KqYFP89iYCSjcJrT6GMpiq
    3n2ij_qfmFCQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:cnQNYDNCyqZTVbt1D_dTLLrql3Qm1UCwlIT9WK2EpwJl3ITkMbhP0Q>
    <xmx:cnQNYN5tf0F2YUFksHxpZ4R1e9AwvsmQeuyyRvdx0FFHWVmTXOG81A>
    <xmx:cnQNYN7_4mhxgf7GwXEIpPEPepA0Dxyl5y6DQdqAiFPTGH1Cj8-vqg>
    <xmx:cnQNYNHqDhwxaZ_4PaFecbz8jxGU9NsU_ypIgXJFgBywW79Zgn_CC_NSgnw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1BFD524005A;
        Sun, 24 Jan 2021 08:21:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix lockdep splat in btrfs_recover_relocation" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:21:52 +0100
Message-ID: <161149451210812@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From fb286100974e7239af243bc2255a52f29442f9c8 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 16 Dec 2020 11:22:14 -0500
Subject: [PATCH] btrfs: fix lockdep splat in btrfs_recover_relocation

While testing the error paths of relocation I hit the following lockdep
splat:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.10.0-rc6+ #217 Not tainted
  ------------------------------------------------------
  mount/779 is trying to acquire lock:
  ffffa0e676945418 (&fs_info->balance_mutex){+.+.}-{3:3}, at: btrfs_recover_balance+0x2f0/0x340

  but task is already holding lock:
  ffffa0e60ee31da8 (btrfs-root-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x27/0x100

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #2 (btrfs-root-00){++++}-{3:3}:
	 down_read_nested+0x43/0x130
	 __btrfs_tree_read_lock+0x27/0x100
	 btrfs_read_lock_root_node+0x31/0x40
	 btrfs_search_slot+0x462/0x8f0
	 btrfs_update_root+0x55/0x2b0
	 btrfs_drop_snapshot+0x398/0x750
	 clean_dirty_subvols+0xdf/0x120
	 btrfs_recover_relocation+0x534/0x5a0
	 btrfs_start_pre_rw_mount+0xcb/0x170
	 open_ctree+0x151f/0x1726
	 btrfs_mount_root.cold+0x12/0xea
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 vfs_kern_mount.part.0+0x71/0xb0
	 btrfs_mount+0x10d/0x380
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 path_mount+0x433/0xc10
	 __x64_sys_mount+0xe3/0x120
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #1 (sb_internal#2){.+.+}-{0:0}:
	 start_transaction+0x444/0x700
	 insert_balance_item.isra.0+0x37/0x320
	 btrfs_balance+0x354/0xf40
	 btrfs_ioctl_balance+0x2cf/0x380
	 __x64_sys_ioctl+0x83/0xb0
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (&fs_info->balance_mutex){+.+.}-{3:3}:
	 __lock_acquire+0x1120/0x1e10
	 lock_acquire+0x116/0x370
	 __mutex_lock+0x7e/0x7b0
	 btrfs_recover_balance+0x2f0/0x340
	 open_ctree+0x1095/0x1726
	 btrfs_mount_root.cold+0x12/0xea
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 vfs_kern_mount.part.0+0x71/0xb0
	 btrfs_mount+0x10d/0x380
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 path_mount+0x433/0xc10
	 __x64_sys_mount+0xe3/0x120
	 do_syscall_64+0x33/0x40
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  other info that might help us debug this:

  Chain exists of:
    &fs_info->balance_mutex --> sb_internal#2 --> btrfs-root-00

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(btrfs-root-00);
				 lock(sb_internal#2);
				 lock(btrfs-root-00);
    lock(&fs_info->balance_mutex);

   *** DEADLOCK ***

  2 locks held by mount/779:
   #0: ffffa0e60dc040e0 (&type->s_umount_key#47/1){+.+.}-{3:3}, at: alloc_super+0xb5/0x380
   #1: ffffa0e60ee31da8 (btrfs-root-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x27/0x100

  stack backtrace:
  CPU: 0 PID: 779 Comm: mount Not tainted 5.10.0-rc6+ #217
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  Call Trace:
   dump_stack+0x8b/0xb0
   check_noncircular+0xcf/0xf0
   ? trace_call_bpf+0x139/0x260
   __lock_acquire+0x1120/0x1e10
   lock_acquire+0x116/0x370
   ? btrfs_recover_balance+0x2f0/0x340
   __mutex_lock+0x7e/0x7b0
   ? btrfs_recover_balance+0x2f0/0x340
   ? btrfs_recover_balance+0x2f0/0x340
   ? rcu_read_lock_sched_held+0x3f/0x80
   ? kmem_cache_alloc_trace+0x2c4/0x2f0
   ? btrfs_get_64+0x5e/0x100
   btrfs_recover_balance+0x2f0/0x340
   open_ctree+0x1095/0x1726
   btrfs_mount_root.cold+0x12/0xea
   ? rcu_read_lock_sched_held+0x3f/0x80
   legacy_get_tree+0x30/0x50
   vfs_get_tree+0x28/0xc0
   vfs_kern_mount.part.0+0x71/0xb0
   btrfs_mount+0x10d/0x380
   ? __kmalloc_track_caller+0x2f2/0x320
   legacy_get_tree+0x30/0x50
   vfs_get_tree+0x28/0xc0
   ? capable+0x3a/0x60
   path_mount+0x433/0xc10
   __x64_sys_mount+0xe3/0x120
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

This is straightforward to fix, simply release the path before we setup
the balance_ctl.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2c0aa03b6437..0c7f4f6237e8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4318,6 +4318,8 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 		btrfs_warn(fs_info,
 	"balance: cannot set exclusive op status, resume manually");
 
+	btrfs_release_path(path);
+
 	mutex_lock(&fs_info->balance_mutex);
 	BUG_ON(fs_info->balance_ctl);
 	spin_lock(&fs_info->balance_lock);

