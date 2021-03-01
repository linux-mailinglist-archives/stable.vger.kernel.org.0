Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44999327BB5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhCAKPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:15:35 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:44593 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232216AbhCAKPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:15:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8328D19407A8;
        Mon,  1 Mar 2021 05:14:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:14:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+CUEIZ
        4mTWxZtR0NYqZM78Wul1TMJy+nbZ46V7ApRcY=; b=B9O/n3wdH05FHNFYV3YyXk
        4CraNJYW7kd9maAr1QLzcxh2x/gtY//X31NCoO3djJ2fY/YA/9EMcn0B+fYuykE3
        9uk9LqUXQQOYijStrU83S4v4/FvqfRDsyDWLRDQicdqiJDtRDUvyhYY1j9UJKhqz
        5F2FGcHk0rqJtZA+EyF2loNhrTI8UDZIpSRN9eBt+/ev8RLHySz69HsYdAYr2iRI
        ncZqemwvKYC7TcSok/r8K1tXrGZwhpOpPm+9EIlIT0Bp7nFom39my+LpKv4qyJ51
        XUDf/z6AofaY6b02ZfuXwUOvPoAq5M5escZuvz9j8jxHeWzHeckrdZ8DFAHX0j4w
        ==
X-ME-Sender: <xms:lL48YB8e3er8QBVpWFqLo_jYzM6Jd_l6z_HKtvE5ixQbUbpaNJyUBw>
    <xme:lL48YFvJv5eSlrUIBB_cnf0GexVf8DrxhIfI6U7KZ-PjYiwqaX0Xxa-zzW9XJtecT
    MNptXqVyQ1Lig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:lL48YPDV1GwQNM4ewDLmYdUpiMytJfAf0K2WvDF_5TZaZ0oF5hKICg>
    <xmx:lL48YFcj-CyNLuOEIGR5Yk1Uf9B5rbPAerlfbs-cHxLMk_BfLYilLg>
    <xmx:lL48YGP63lcahQC1Q3nFAMPl065WcR7WxbGUVZ3hN9dzyMdOx6PPDQ>
    <xmx:lb48YI2i2SkRtDeNY2eHTMD7VeNXYBMh1LmMT9wuauvMQh6cGsB0EA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1CF09240069;
        Mon,  1 Mar 2021 05:14:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: do not cleanup upper nodes in" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:14:42 +0100
Message-ID: <161459368218569@kroah.com>
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

From 7e2a870a599d4699a626ec26430c7a1ab14a2a49 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 16 Dec 2020 11:22:16 -0500
Subject: [PATCH] btrfs: do not cleanup upper nodes in
 btrfs_backref_cleanup_node

Zygo reported the following panic when testing my error handling patches
for relocation:

  kernel BUG at fs/btrfs/backref.c:2545!
  invalid opcode: 0000 [#1] SMP KASAN PTI CPU: 3 PID: 8472 Comm: btrfs Tainted: G        W 14
  Hardware name: QEMU Standard PC (i440FX + PIIX,

  Call Trace:
   btrfs_backref_error_cleanup+0x4df/0x530
   build_backref_tree+0x1a5/0x700
   ? _raw_spin_unlock+0x22/0x30
   ? release_extent_buffer+0x225/0x280
   ? free_extent_buffer.part.52+0xd7/0x140
   relocate_tree_blocks+0x2a6/0xb60
   ? kasan_unpoison_shadow+0x35/0x50
   ? do_relocation+0xc10/0xc10
   ? kasan_kmalloc+0x9/0x10
   ? kmem_cache_alloc_trace+0x6a3/0xcb0
   ? free_extent_buffer.part.52+0xd7/0x140
   ? rb_insert_color+0x342/0x360
   ? add_tree_block.isra.36+0x236/0x2b0
   relocate_block_group+0x2eb/0x780
   ? merge_reloc_roots+0x470/0x470
   btrfs_relocate_block_group+0x26e/0x4c0
   btrfs_relocate_chunk+0x52/0x120
   btrfs_balance+0xe2e/0x18f0
   ? pvclock_clocksource_read+0xeb/0x190
   ? btrfs_relocate_chunk+0x120/0x120
   ? lock_contended+0x620/0x6e0
   ? do_raw_spin_lock+0x1e0/0x1e0
   ? do_raw_spin_unlock+0xa8/0x140
   btrfs_ioctl_balance+0x1f9/0x460
   btrfs_ioctl+0x24c8/0x4380
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

This occurs because of this check

  if (RB_EMPTY_NODE(&upper->rb_node))
	  BUG_ON(!list_empty(&node->upper));

As we are dropping the backref node, if we discover that our upper node
in the edge we just cleaned up isn't linked into the cache that we are
now done with this node, thus the BUG_ON().

However this is an erroneous assumption, as we will look up all the
references for a node first, and then process the pending edges.  All of
the 'upper' nodes in our pending edges won't be in the cache's rb_tree
yet, because they haven't been processed.  We could very well have many
edges still left to cleanup on this node.

The fact is we simply do not need this check, we can just process all of
the edges only for this node, because below this check we do the
following

  if (list_empty(&upper->lower)) {
	  list_add_tail(&upper->lower, &cache->leaves);
	  upper->lowest = 1;
  }

If the upper node truly isn't used yet, then we add it to the
cache->leaves list to be cleaned up later.  If it is still used then the
last child node that has it linked into its node will add it to the
leaves list and then it will be cleaned up.

Fix this problem by dropping this logic altogether.  With this fix I no
longer see the panic when testing with error injection in the backref
code.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 9cadacf3ec27..ef71aba5bc15 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2541,13 +2541,6 @@ void btrfs_backref_cleanup_node(struct btrfs_backref_cache *cache,
 		list_del(&edge->list[UPPER]);
 		btrfs_backref_free_edge(cache, edge);
 
-		if (RB_EMPTY_NODE(&upper->rb_node)) {
-			BUG_ON(!list_empty(&node->upper));
-			btrfs_backref_drop_node(cache, node);
-			node = upper;
-			node->lowest = 1;
-			continue;
-		}
 		/*
 		 * Add the node to leaf node list if no other child block
 		 * cached.

