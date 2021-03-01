Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E76E327BB9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhCAKQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:16:12 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:33353 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232555AbhCAKQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:16:04 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A927C194074C;
        Mon,  1 Mar 2021 05:14:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:14:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8FLG2m
        rlaXt51nKceGwTAxYY+26ON4isR3y0DPeesUI=; b=J2Eo20uV6k0IOEBFUsZ6IH
        LkuRYZS2UTag5yB4YXXgtlPUvqj6kuLUR7AnkQEPZ5T1Nxg1Cxl3swQ67YyW87vG
        AUUriPoNj0cRM2A7w0sS6LNhAKnagD/EJaLct+9S9rg9fegMDDMWMJxLJuOHmerA
        7QqBDuLaRHllJUexWjTxIo2hZ7HBn2+Ibhqo756DL3Emqmm7xIKR5Kfaf7S5o2hR
        QSbdqAcXN1VEFO15WcPpirsmGiKqOWj9uE4BpoSyQ+UmxSUveTT8CWQ6a+X2Gh57
        6gKq2zQJRR4zF8PJiV4aipAtxleiQz23N/FcGM+VrGPOpf8ONnbSVXoXf7ujZjBQ
        ==
X-ME-Sender: <xms:mr48YKWDJ5AHosRS42J-ZejQkdjZOUNmFemKCjQJqKLCTk0PHgyjHw>
    <xme:mr48YGlnK5tt-5OII4EIhVRkfOan3Ty-ikl_rGa1vE_61K6vMwL5D7an5Ac7BWanV
    5e_UlwzC3fcEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:mr48YOa1j2r_KEKiEkFWJkN6x0-Chb3RexhwuFmmzBY4D2Hh9HZ2oQ>
    <xmx:mr48YBWDiOX1KIdccE0EmnE4tQx8mrzi2jrbv3IPVips_ekn6ClOOQ>
    <xmx:mr48YElyhKp2gHGzEBMXiVu1uWtZy6X2tOem1gbCvin63zN1WjmXTw>
    <xmx:mr48YAv8YngKumP6WszSf_y--FSPy3QPPAhgB8hdmT17zspYC5iVKQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52BCB1080057;
        Mon,  1 Mar 2021 05:14:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: do not cleanup upper nodes in" failed to apply to 5.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:14:49 +0100
Message-ID: <1614593689120121@kroah.com>
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

