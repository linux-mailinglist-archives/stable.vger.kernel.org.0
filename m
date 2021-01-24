Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08D6301C21
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbhAXNW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:22:59 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53377 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbhAXNW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:22:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9636BB6B;
        Sun, 24 Jan 2021 08:21:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:21:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=X4DnOw
        WIDzpvVP6tYh9iApf8IjopiCE/nua/491dE04=; b=SpoZMNgZnP5ep9W5Tn0Idl
        x0wsy7t5nVR/Vlv5opOX8bu11xllX2kv0iqcsB2QujFvtARdcjB5IIF1og+miGTe
        2MKW2Rc8nDHCHVTZnS6GsIbsI00pZvzKumugdilorQANpqM/JgRiZX3ULHi5asDS
        okr5Y5cVAt0stfn+L97VBgPjkXAmu+TOA6oBgKz7VB1uejfPnPDtMBNpSqcOz+tw
        N0y9k7rhdrjyBDJm/A+K/Tl6uejsEo5H1XL18vRtsTtVT9gfVlRwMMd6VJo5x19V
        GCtgoWrBGUaOZPlVRdSHM852C8HBKqqE3/K6VA/IabQuVOidjTVqBf0xjjP4tZuA
        ==
X-ME-Sender: <xms:cHQNYMzzwPSsbLzQqaAy4mG3F0MkYNnA-riQ4M92Nw_xl2od8sxGIA>
    <xme:cHQNYAQyN4EykLYHaW91WiFeBF_uwui4tgaSFU-MgthFie5kGTQhwcUv_gbRzA7xF
    obbbzkhheqRaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:cHQNYOU7gCbON3amZ1VnG6KTFl01Rth_r4mQYuYR_w4zMKqa_JunSQ>
    <xmx:cHQNYKiqaKwiB1Q1PjyC-msmOF8o8ZkbZCuRvxPZTkP1DzcLL4h1FQ>
    <xmx:cHQNYOBdB7GfYRYbUoZYb1a7C3vM6Y97g2YX02RHlil3HmRbeYNIWw>
    <xmx:cHQNYBNHbNNxTE-RDvzSKhmyO5FdskmxfxQAIbS3ChS95waBnjJw7EgGrLc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D12811080057;
        Sun, 24 Jan 2021 08:21:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix lockdep splat in btrfs_recover_relocation" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:21:50 +0100
Message-ID: <161149451017342@kroah.com>
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

