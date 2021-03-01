Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D892327BDA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhCAKUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:20:22 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53997 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232690AbhCAKSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:18:34 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 028A11940B80;
        Mon,  1 Mar 2021 05:17:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 01 Mar 2021 05:17:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pL9SVO
        w6VNhFUNANc+KtMZ+ETWZjZJ19XcHp6S3Klmo=; b=YWQ92j450XxOcEOdGc+/CT
        4u6wSlf2XxqCwYuEKeYQOWl6+0cRy8I3rN1D50Ifyg67pBmSvuFSpPJXzdfF+XEq
        O5sZjkDntwv4JLStYw6z6/pncy4p+8wxmZ2Fs7HoOh/QKW6wgYtz+iyGZLpFHtD+
        1gPgMqfzCmWqMexzxAQkll2AG8gSPaUjoL5p6ZgziSQ5t1Lw/D7Mwya7oemQkOoG
        doDkHiLCBu3HpwCOgQVFny8PERr9EZCkQTrus3mvC/UWauJLTb3tDZGuOnxofArp
        q1/gdzeUF+7He1PCJSeoCyjrcGnckgjTYev+4rjjEOuIBeJJNLNMpxy2VZ9LHD2g
        ==
X-ME-Sender: <xms:LL88YOy98d9Jd7wBWfvlkoUh5DyPNRXiJpRl0RK4elSJ-2amdv0l_g>
    <xme:LL88YKNmlbBZtxnyOsxTJzUyYU2zbGGDuhz4lb3MUImV-xqPitmYO8EkqIHzu_bbi
    Us5fLWQRjM1Xw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:LL88YNMaPAO0EdUNa1NTmOVOmW5kDUB5i81R81g1ce-eCAjwSUlv2g>
    <xmx:LL88YMTq39ZVvtqwtr90HX7QrZ0ho42OTMmDMxREJSSLvCPgEyqM9A>
    <xmx:LL88YPAW8h3aQ52mOYEl3QcJZGF-3tfbOPOMyyixVyf41phIGm6Rdw>
    <xmx:LL88YODCSybTuXfHMqD7_2B_I3C_VM_9nN1zkioHCSF7kqnd01K87A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 443B31080064;
        Mon,  1 Mar 2021 05:17:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: splice remaining dirty_bg's onto the transaction dirty" failed to apply to 4.19-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:17:14 +0100
Message-ID: <16145938342332@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 938fcbfb0cbcf532a1869efab58e6009446b1ced Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 14 Jan 2021 14:02:43 -0500
Subject: [PATCH] btrfs: splice remaining dirty_bg's onto the transaction dirty
 bg list

While doing error injection testing with my relocation patches I hit the
following assert:

  assertion failed: list_empty(&block_group->dirty_list), in fs/btrfs/block-group.c:3356
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/ctree.h:3357!
  invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 0 PID: 24351 Comm: umount Tainted: G        W         5.10.0-rc3+ #193
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  RIP: 0010:assertfail.constprop.0+0x18/0x1a
  RSP: 0018:ffffa09b019c7e00 EFLAGS: 00010282
  RAX: 0000000000000056 RBX: ffff8f6492c18000 RCX: 0000000000000000
  RDX: ffff8f64fbc27c60 RSI: ffff8f64fbc19050 RDI: ffff8f64fbc19050
  RBP: ffff8f6483bbdc00 R08: 0000000000000000 R09: 0000000000000000
  R10: ffffa09b019c7c38 R11: ffffffff85d70928 R12: ffff8f6492c18100
  R13: ffff8f6492c18148 R14: ffff8f6483bbdd70 R15: dead000000000100
  FS:  00007fbfda4cdc40(0000) GS:ffff8f64fbc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fbfda666fd0 CR3: 000000013cf66002 CR4: 0000000000370ef0
  Call Trace:
   btrfs_free_block_groups.cold+0x55/0x55
   close_ctree+0x2c5/0x306
   ? fsnotify_destroy_marks+0x14/0x100
   generic_shutdown_super+0x6c/0x100
   kill_anon_super+0x14/0x30
   btrfs_kill_super+0x12/0x20
   deactivate_locked_super+0x36/0xa0
   cleanup_mnt+0x12d/0x190
   task_work_run+0x5c/0xa0
   exit_to_user_mode_prepare+0x1b1/0x1d0
   syscall_exit_to_user_mode+0x54/0x280
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

This happened because I injected an error in btrfs_cow_block() while
running the dirty block groups.  When we run the dirty block groups, we
splice the list onto a local list to process.  However if an error
occurs, we only cleanup the transactions dirty block group list, not any
pending block groups we have on our locally spliced list.

In fact if we fail to allocate a path in this function we'll also fail
to clean up the splice list.

Fix this by splicing the list back onto the transaction dirty block
group list so that the block groups are cleaned up.  Then add a 'out'
label and have the error conditions jump to out so that the errors are
handled properly.  This also has the side-effect of fixing a problem
where we would clear 'ret' on error because we unconditionally ran
btrfs_run_delayed_refs().

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 763a3671b7af..dda495b2a862 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2564,8 +2564,10 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 
 	if (!path) {
 		path = btrfs_alloc_path();
-		if (!path)
-			return -ENOMEM;
+		if (!path) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	/*
@@ -2659,16 +2661,14 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 			btrfs_put_block_group(cache);
 		if (drop_reserve)
 			btrfs_delayed_refs_rsv_release(fs_info, 1);
-
-		if (ret)
-			break;
-
 		/*
 		 * Avoid blocking other tasks for too long. It might even save
 		 * us from writing caches for block groups that are going to be
 		 * removed.
 		 */
 		mutex_unlock(&trans->transaction->cache_write_mutex);
+		if (ret)
+			goto out;
 		mutex_lock(&trans->transaction->cache_write_mutex);
 	}
 	mutex_unlock(&trans->transaction->cache_write_mutex);
@@ -2692,7 +2692,12 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 			goto again;
 		}
 		spin_unlock(&cur_trans->dirty_bgs_lock);
-	} else if (ret < 0) {
+	}
+out:
+	if (ret < 0) {
+		spin_lock(&cur_trans->dirty_bgs_lock);
+		list_splice_init(&dirty, &cur_trans->dirty_bgs);
+		spin_unlock(&cur_trans->dirty_bgs_lock);
 		btrfs_cleanup_dirty_bgs(cur_trans, fs_info);
 	}
 

