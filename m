Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC37301C1C
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbhAXNWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:22:00 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56255 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbhAXNV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:21:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A384BEAA;
        Sun, 24 Jan 2021 08:20:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:20:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9N3o44
        VLpRLACpbwnS9hTfRk8HxRhMmyGFoWD7KMP70=; b=fFBt8AGvi0lFVflRY+q3BP
        8wzyl0n5JIssnsMLKK+MLVnT5/T74dZf8JfRzT2HLZT6oySeffVTet1B7qUuL7av
        0+geM2MN0yiv8ZRDsNkNjhbC3dP0dkuHxWLQ2Gq9t6M4CM8D5VVJ3zAsyyT7Pa+Z
        XpJeMmmuXy6wgUjtpoMHFpyR1P/OCZ1a+iKwhGP4f+d+GJIU7OZZ10mcKvemGSH2
        7iK83oMQVobMc6FBd71o8Lv2Dsr8UYs6zO8WRfI6GRtfj/6JwSABPvsutKzPGRDP
        dyLKKuN7Ap7jRlMLojdYBuKp9TylXNTHkMxFIBW1EAulAjHGlux/xohwR7ZLjvZA
        ==
X-ME-Sender: <xms:NXQNYBJAmG84E5FoleShmO_5lXTpeq8P4-gtD_3DpN6cOKdp-DmXrQ>
    <xme:NXQNYNKP8UGpAlKofv_LiWTPcFpot4QgdiyNITG5hSVZEjCxgTy6EhZZAheXXVnNH
    gR5U8m4ePhvcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:NXQNYJtACcSZBXghb2Gpc1bT5XUNGKcOMI8RNu8BJaycVWy-g3bVpg>
    <xmx:NXQNYCYwwwXEL5JvGvAzBgvo8IR1fyi7eG78CKSijTmmmrbkNxmPCg>
    <xmx:NXQNYIZoqWSSsy3mnKUa4uWrt4ug0-kDs4UHywh2NwVt6FU3d8x_rw>
    <xmx:NXQNYBC2Bch4UOfTsSuBztkMXoZJOIcefAI4LSOW0AeMKd6StIGwajF11Es>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F0CE224005A;
        Sun, 24 Jan 2021 08:20:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: do not double free backref nodes on error" failed to apply to 5.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:20:47 +0100
Message-ID: <161149444720137@kroah.com>
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

From 49ecc679ab48b40ca799bf94b327d5284eac9e46 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 16 Dec 2020 11:22:11 -0500
Subject: [PATCH] btrfs: do not double free backref nodes on error

Zygo reported the following KASAN splat:

  BUG: KASAN: use-after-free in btrfs_backref_cleanup_node+0x18a/0x420
  Read of size 8 at addr ffff888112402950 by task btrfs/28836

  CPU: 0 PID: 28836 Comm: btrfs Tainted: G        W         5.10.0-e35f27394290-for-next+ #23
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  Call Trace:
   dump_stack+0xbc/0xf9
   ? btrfs_backref_cleanup_node+0x18a/0x420
   print_address_description.constprop.8+0x21/0x210
   ? record_print_text.cold.34+0x11/0x11
   ? btrfs_backref_cleanup_node+0x18a/0x420
   ? btrfs_backref_cleanup_node+0x18a/0x420
   kasan_report.cold.10+0x20/0x37
   ? btrfs_backref_cleanup_node+0x18a/0x420
   __asan_load8+0x69/0x90
   btrfs_backref_cleanup_node+0x18a/0x420
   btrfs_backref_release_cache+0x83/0x1b0
   relocate_block_group+0x394/0x780
   ? merge_reloc_roots+0x4a0/0x4a0
   btrfs_relocate_block_group+0x26e/0x4c0
   btrfs_relocate_chunk+0x52/0x120
   btrfs_balance+0xe2e/0x1900
   ? check_flags.part.50+0x6c/0x1e0
   ? btrfs_relocate_chunk+0x120/0x120
   ? kmem_cache_alloc_trace+0xa06/0xcb0
   ? _copy_from_user+0x83/0xc0
   btrfs_ioctl_balance+0x3a7/0x460
   btrfs_ioctl+0x24c8/0x4360
   ? __kasan_check_read+0x11/0x20
   ? check_chain_key+0x1f4/0x2f0
   ? __asan_loadN+0xf/0x20
   ? btrfs_ioctl_get_supported_features+0x30/0x30
   ? kvm_sched_clock_read+0x18/0x30
   ? check_chain_key+0x1f4/0x2f0
   ? lock_downgrade+0x3f0/0x3f0
   ? handle_mm_fault+0xad6/0x2150
   ? do_vfs_ioctl+0xfc/0x9d0
   ? ioctl_file_clone+0xe0/0xe0
   ? check_flags.part.50+0x6c/0x1e0
   ? check_flags.part.50+0x6c/0x1e0
   ? check_flags+0x26/0x30
   ? lock_is_held_type+0xc3/0xf0
   ? syscall_enter_from_user_mode+0x1b/0x60
   ? do_syscall_64+0x13/0x80
   ? rcu_read_lock_sched_held+0xa1/0xd0
   ? __kasan_check_read+0x11/0x20
   ? __fget_light+0xae/0x110
   __x64_sys_ioctl+0xc3/0x100
   do_syscall_64+0x37/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f4c4bdfe427

  Allocated by task 28836:
   kasan_save_stack+0x21/0x50
   __kasan_kmalloc.constprop.18+0xbe/0xd0
   kasan_kmalloc+0x9/0x10
   kmem_cache_alloc_trace+0x410/0xcb0
   btrfs_backref_alloc_node+0x46/0xf0
   btrfs_backref_add_tree_node+0x60d/0x11d0
   build_backref_tree+0xc5/0x700
   relocate_tree_blocks+0x2be/0xb90
   relocate_block_group+0x2eb/0x780
   btrfs_relocate_block_group+0x26e/0x4c0
   btrfs_relocate_chunk+0x52/0x120
   btrfs_balance+0xe2e/0x1900
   btrfs_ioctl_balance+0x3a7/0x460
   btrfs_ioctl+0x24c8/0x4360
   __x64_sys_ioctl+0xc3/0x100
   do_syscall_64+0x37/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

  Freed by task 28836:
   kasan_save_stack+0x21/0x50
   kasan_set_track+0x20/0x30
   kasan_set_free_info+0x1f/0x30
   __kasan_slab_free+0xf3/0x140
   kasan_slab_free+0xe/0x10
   kfree+0xde/0x200
   btrfs_backref_error_cleanup+0x452/0x530
   build_backref_tree+0x1a5/0x700
   relocate_tree_blocks+0x2be/0xb90
   relocate_block_group+0x2eb/0x780
   btrfs_relocate_block_group+0x26e/0x4c0
   btrfs_relocate_chunk+0x52/0x120
   btrfs_balance+0xe2e/0x1900
   btrfs_ioctl_balance+0x3a7/0x460
   btrfs_ioctl+0x24c8/0x4360
   __x64_sys_ioctl+0xc3/0x100
   do_syscall_64+0x37/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

This occurred because we freed our backref node in
btrfs_backref_error_cleanup(), but then tried to free it again in
btrfs_backref_release_cache().  This is because
btrfs_backref_release_cache() will cycle through all of the
cache->leaves nodes and free them up.  However
btrfs_backref_error_cleanup() freed the backref node with
btrfs_backref_free_node(), which simply kfree()d the backref node
without unlinking it from the cache.  Change this to a
btrfs_backref_drop_node(), which does the appropriate cleanup and
removes the node from the cache->leaves list, so when we go to free the
remaining cache we don't trip over items we've already dropped.

Fixes: 75bfb9aff45e ("Btrfs: cleanup error handling in build_backref_tree")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 02d7d7b2563b..9cadacf3ec27 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3117,7 +3117,7 @@ void btrfs_backref_error_cleanup(struct btrfs_backref_cache *cache,
 		list_del_init(&lower->list);
 		if (lower == node)
 			node = NULL;
-		btrfs_backref_free_node(cache, lower);
+		btrfs_backref_drop_node(cache, lower);
 	}
 
 	btrfs_backref_cleanup_node(cache, node);

