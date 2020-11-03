Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA922A4709
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbgKCN4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:56:10 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:38715 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729422AbgKCN4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:56:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 829EFCC2;
        Tue,  3 Nov 2020 08:56:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 08:56:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VfSgrw
        PL8onrgbHD8C6UbAv4fex9NOYvU18iPbYq6Dk=; b=TQmcnEFBC+XBjbWpO68njS
        90IWhjEFcYlt91JRB23TgYLCsje3e+v2McYrgRUB27YW9L+Xf3Po+F3vuppg7li0
        wVhLq6uwT+3BmPVRgXhIiX9XooQnSZw3jj7ZrC+y4kUVKZSCw1R+qsNEDhlhJVIG
        b+gOm7mxdWxmMRuO3084e4VkLgTCLwPJcZlX8vz/oW3kXZUTAoEakb/FYfmE+dq5
        UR4BUj5cp2b2wQMDHhKflR5LyyspnyUUEw32SPMWb8gDQjf7/bIBvxeP6fq3ccvk
        WBdjsEldZFl1CtbG7mzudWjA7DwPPqtMeDgscYwkRBvpHZ6LMAuXwx9k6PxwQ0gw
        ==
X-ME-Sender: <xms:d2GhX8HaBHwoOT_UCV-rkJI7HvHyN5Djw3w30P7hb-EGBJ2qKHNRSg>
    <xme:d2GhX1WmfHpnlTRS73mJ6OLc3C6Eii4_SOpHh4XEiXjEyIPp3414-A1JfqCAcmGWg
    5PXsaq7bq7jtw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnheptdevtefhjeffvdefuedvgfefueektddthffhtdegie
    ffvedvtdekffehueejfefhnecuffhomhgrihhnpehophgvnhhsuhhsvgdrohhrghenucfk
    phepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:d2GhX2KIPyjPalkkAwBz74e6kCwWHWoHgEbomsk0-YUUYFdyvLSjYw>
    <xmx:d2GhX-GJ0DIIbr8ujlr-n3vRMwElP1YSrtxXfNX4LX5Jn9M8q_wjQw>
    <xmx:d2GhXyWfWnQ64g0tw9orFtBnszuOxpPCsTLGprtFcPqh2BEYnJLb3g>
    <xmx:d2GhX1eQYNqrQbyqBqzbQknWCa5PBqd8J7JdkCZonAldLoRbd70CCgJqQoI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B7C21306467D;
        Tue,  3 Nov 2020 08:56:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: reschedule when cloning lots of extents" failed to apply to 4.9-stable tree
To:     johannes.thumshirn@wdc.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 14:57:01 +0100
Message-ID: <1604411821152239@kroah.com>
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

From 6b613cc97f0ace77f92f7bc112b8f6ad3f52baf8 Mon Sep 17 00:00:00 2001
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Date: Tue, 22 Sep 2020 17:27:29 +0900
Subject: [PATCH] btrfs: reschedule when cloning lots of extents

We have several occurrences of a soft lockup from fstest's generic/175
testcase, which look more or less like this one:

  watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [xfs_io:10030]
  Kernel panic - not syncing: softlockup: hung tasks
  CPU: 0 PID: 10030 Comm: xfs_io Tainted: G             L    5.9.0-rc5+ #768
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   <IRQ>
   dump_stack+0x77/0xa0
   panic+0xfa/0x2cb
   watchdog_timer_fn.cold+0x85/0xa5
   ? lockup_detector_update_enable+0x50/0x50
   __hrtimer_run_queues+0x99/0x4c0
   ? recalibrate_cpu_khz+0x10/0x10
   hrtimer_run_queues+0x9f/0xb0
   update_process_times+0x28/0x80
   tick_handle_periodic+0x1b/0x60
   __sysvec_apic_timer_interrupt+0x76/0x210
   asm_call_on_stack+0x12/0x20
   </IRQ>
   sysvec_apic_timer_interrupt+0x7f/0x90
   asm_sysvec_apic_timer_interrupt+0x12/0x20
  RIP: 0010:btrfs_tree_unlock+0x91/0x1a0 [btrfs]
  RSP: 0018:ffffc90007123a58 EFLAGS: 00000282
  RAX: ffff8881cea2fbe0 RBX: ffff8881cea2fbe0 RCX: 0000000000000000
  RDX: ffff8881d23fd200 RSI: ffffffff82045220 RDI: ffff8881cea2fba0
  RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000032
  R10: 0000160000000000 R11: 0000000000001000 R12: 0000000000001000
  R13: ffff8882357fd5b0 R14: ffff88816fa76e70 R15: ffff8881cea2fad0
   ? btrfs_tree_unlock+0x15b/0x1a0 [btrfs]
   btrfs_release_path+0x67/0x80 [btrfs]
   btrfs_insert_replace_extent+0x177/0x2c0 [btrfs]
   btrfs_replace_file_extents+0x472/0x7c0 [btrfs]
   btrfs_clone+0x9ba/0xbd0 [btrfs]
   btrfs_clone_files.isra.0+0xeb/0x140 [btrfs]
   ? file_update_time+0xcd/0x120
   btrfs_remap_file_range+0x322/0x3b0 [btrfs]
   do_clone_file_range+0xb7/0x1e0
   vfs_clone_file_range+0x30/0xa0
   ioctl_file_clone+0x8a/0xc0
   do_vfs_ioctl+0x5b2/0x6f0
   __x64_sys_ioctl+0x37/0xa0
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f87977fc247
  RSP: 002b:00007ffd51a2f6d8 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f87977fc247
  RDX: 00007ffd51a2f710 RSI: 000000004020940d RDI: 0000000000000003
  RBP: 0000000000000004 R08: 00007ffd51a79080 R09: 0000000000000000
  R10: 00005621f11352f2 R11: 0000000000000206 R12: 0000000000000000
  R13: 0000000000000000 R14: 00005621f128b958 R15: 0000000080000000
  Kernel Offset: disabled
  ---[ end Kernel panic - not syncing: softlockup: hung tasks ]---

All of these lockup reports have the call chain btrfs_clone_files() ->
btrfs_clone() in common. btrfs_clone_files() calls btrfs_clone() with
both source and destination extents locked and loops over the source
extent to create the clones.

Conditionally reschedule in the btrfs_clone() loop, to give some time back
to other processes.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 39b3269e5760..99aa87c08912 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -520,6 +520,8 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			ret = -EINTR;
 			goto out;
 		}
+
+		cond_resched();
 	}
 	ret = 0;
 

