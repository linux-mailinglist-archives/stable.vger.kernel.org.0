Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C9F327BDB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhCAKU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:20:28 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59219 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233313AbhCAKSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:18:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A164E1940B7D;
        Mon,  1 Mar 2021 05:17:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OwaTG3
        0Bwz1Z7r0MlSVm6hTme89KFVxUfDVgxcLuTGU=; b=dil8FWgzsl1jkUcBI/4h/c
        vJymGBbRlOlhk5uXb/zurYuX6koHXe6xyb+I9LR4TQnYMl1h/qRUleUGJh06ecxj
        vfvyx+U9ZNyjTTOClLyCTqQD1BandXPe2w+dHxhkZJhOIyQw/DDvPuxh//ipzbW0
        ZYI/9pO7ibm/RaWnwV9/eH1sqL1PY79FgHf9BF94+qCgenQf24S9LGFGddzWnOs7
        eanD7FK/ADMZcuf3xP3ncIM8AdAdCg9ai1IKajfORTZhKGBMQUPX9HnNpQhp5yBg
        mp6+5e+oxVeEhR/0Rv4hT+dZYVSm5a0/fn0mbcYcTvPz8F1LBsGa5DLMGjsNMQow
        ==
X-ME-Sender: <xms:Nb88YC5uQIO5OFIxXcjSC8Ua246LVL7RXUQrpaaoEWWxzFOhkMgHJw>
    <xme:Nb88YL5ZyoNm_pSRP3LzV6zMw1LlYGbVqiqxzpWCqJT0Aip1y509K9zPAvrSuYBYq
    g74HmwovJgU7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:Nb88YBdCUWC8cs4P_lbH1Pgjo1y3zdSzNxq555ZL1eVDo3l06Rlnvg>
    <xmx:Nb88YPI5EShLGwG7XADZrsWpchRk-Z3wEGQJYWwUFQ54YFfNSK0wmw>
    <xmx:Nb88YGLcwAwhlzlSwcbInhk6MyAm2Z0CgSekSIgCaH2prR_f2WXtmg>
    <xmx:Nb88YAzrJeHYiBWq1NXOMxaTynPS2_RvRp3A5OXiJIClrMwQvz2qYw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F4D11080064;
        Mon,  1 Mar 2021 05:17:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: splice remaining dirty_bg's onto the transaction dirty" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:17:19 +0100
Message-ID: <161459383984129@kroah.com>
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
 

