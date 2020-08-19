Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09955249B69
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHSLNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:13:46 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:47241 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726710AbgHSLNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:13:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1A91E19425A3;
        Wed, 19 Aug 2020 07:13:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rr93P+
        Ni5oP2wUTPZkhmjrN5hObw2Gn4IzfFfz3zCPk=; b=t2TxX1UaFwlWylhW2ncYyV
        NxCTRKtGkYGZf8cBV+nbkdCfcD8iITrSV5QpOZDezknO4oTkE/EchCbOQ0TI2LTe
        gPSJRoRYOl/dACyoFDW9EiVBEJk6++44+Zv3EiVcC7SsRT9W9d03IAqNVSDMoZ61
        27gxht/R/rRUFtXGt91X57z7v4cQJLyC+OzH/hKwiXcCoeNiHw2nMkreWEt+q2WH
        bbHUfmcjbhURzLFXTYAv37Mf4oG/sqAPZNd7E6Ze3+ZY5uOmaiFxaJSUbo8/Pw+6
        KoJE4En/uhKEGKB03kS54g85AbXteSYYuduJgwy6KP2PIQvuzZdCGdNzjzuujTXg
        ==
X-ME-Sender: <xms:ZQk9X7Q03jPUPTMX2N4a0jDpg5LZ8uyf4DJVjWAZAYLqgzoVd28Tlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ZQk9X8xE3K7SYuOumK8pD6An4LYTEjiAkJggRhNdOpmw358J5buQVw>
    <xmx:ZQk9Xw3rCKU33UOel_-84mK3grDroZvowTPvYUMpewfPK9GQ7dDglg>
    <xmx:ZQk9X7Au2YIH1Mv38T0bZXaAbsVod6voDsnLafY7XWrfVj4yPtGFkg>
    <xmx:Zgk9XwZgxeyUoo3DGatfF7na0QCOPQ7OoMB_-wcNg4nCdvPKZVJFew>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E331328005D;
        Wed, 19 Aug 2020 07:13:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: free anon block device right after subvolume deletion" failed to apply to 4.4-stable tree
To:     wqu@suse.com, dsterba@suse.com, greedrong@gmail.com,
        josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:14:04 +0200
Message-ID: <15978356441024@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 082b6c970f02fefd278c7833880cda29691a5f34 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Tue, 16 Jun 2020 10:17:37 +0800
Subject: [PATCH] btrfs: free anon block device right after subvolume deletion

[BUG]
When a lot of subvolumes are created, there is a user report about
transaction aborted caused by slow anonymous block device reclaim:

  BTRFS: Transaction aborted (error -24)
  WARNING: CPU: 17 PID: 17041 at fs/btrfs/transaction.c:1576 create_pending_snapshot+0xbc4/0xd10 [btrfs]
  RIP: 0010:create_pending_snapshot+0xbc4/0xd10 [btrfs]
  Call Trace:
   create_pending_snapshots+0x82/0xa0 [btrfs]
   btrfs_commit_transaction+0x275/0x8c0 [btrfs]
   btrfs_mksubvol+0x4b9/0x500 [btrfs]
   btrfs_ioctl_snap_create_transid+0x174/0x180 [btrfs]
   btrfs_ioctl_snap_create_v2+0x11c/0x180 [btrfs]
   btrfs_ioctl+0x11a4/0x2da0 [btrfs]
   do_vfs_ioctl+0xa9/0x640
   ksys_ioctl+0x67/0x90
   __x64_sys_ioctl+0x1a/0x20
   do_syscall_64+0x5a/0x110
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  ---[ end trace 33f2f83f3d5250e9 ]---
  BTRFS: error (device sda1) in create_pending_snapshot:1576: errno=-24 unknown
  BTRFS info (device sda1): forced readonly
  BTRFS warning (device sda1): Skipping commit of aborted transaction.
  BTRFS: error (device sda1) in cleanup_transaction:1831: errno=-24 unknown

[CAUSE]
The anonymous device pool is shared and its size is 1M. It's possible to
hit that limit if the subvolume deletion is not fast enough and the
subvolumes to be cleaned keep the ids allocated.

[WORKAROUND]
We can't avoid the anon device pool exhaustion but we can shorten the
time the id is attached to the subvolume root once the subvolume becomes
invisible to the user.

Reported-by: Greed Rong <greedrong@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CA+UqX+NTrZ6boGnWHhSeZmEY5J76CTqmYjO2S+=tHJX7nb9DPw@mail.gmail.com/
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5d2ce8092531..f066cad2d039 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4026,6 +4026,8 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 		}
 	}
 
+	free_anon_bdev(dest->anon_dev);
+	dest->anon_dev = 0;
 out_end_trans:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;

