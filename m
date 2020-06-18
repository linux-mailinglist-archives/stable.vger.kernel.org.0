Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D591FF59C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbgFROss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:48:48 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:44141 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726927AbgFROss (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 10:48:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id E196F7AB;
        Thu, 18 Jun 2020 10:48:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 10:48:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=htTgT3
        nvlcIBzFIsROUBENJ7ZozbVNEEWdIfaMMwItw=; b=l+2bq92ojzsnSVFTy0LPab
        Hvh4bATvyAH8b1Ye9QSoZhmtXKdJtBV8C6kiD/HZznu2EL3ZcPVjpdAMusO9Uq+k
        JnQr67GT2s5ei+uVKA5h1Mn26y9XVy5fYW6upTGNBcDJvK+FDt8hLW+kV65WJCO2
        dj/B8tAE0jwYOq+mYQtkow87roSobhJijyPhPiT6YDmV7/GidofPEw2RmZUpndu5
        cNI2r9nvGjuqsL0ClyhStOPyZx612OqJzzfO0xSXzWz2Som0gGaYPKNpHwdhDHaJ
        HhHNGJ5CKfuV2qKIjjNkaQ8isQhSP171ixznR5+BTI5cLdV+bAaCOAclU05f9xYA
        ==
X-ME-Sender: <xms:zn7rXhluMHxvMzJInEeqiWhHGRSoKOvhCy1gtLEe3uiuZxcEcMBQxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepfeetteehueetheekueevhfefveejheegtdeiudehue
    ekheeijeefgfeuhfeigefhnecuffhomhgrihhnpehqvghmuhdrohhrghenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zn7rXs1yi9iHL_J2RpfULq6nASUl7wsjmq3jl3ZavVxufF9lH5BSYQ>
    <xmx:zn7rXnpn4A7LOgbnyj34lsBzKi5iSt3RfZeTCEr93OM-wIQS1CkPUA>
    <xmx:zn7rXhkX32c60ACUc20-Jl7UNCrKqybcgzoUFZcxgdpswyGAPnhZ3g>
    <xmx:zn7rXkhSrOBduSkcHnKb6mLV5pj5UKCJ6K7oKAiBwduZd_l7G93KwVHBq_s>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2BA2C3280065;
        Thu, 18 Jun 2020 10:48:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix space_info bytes_may_use underflow during space" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 16:48:39 +0200
Message-ID: <1592491719254115@kroah.com>
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

From 2166e5edce9ac1edf3b113d6091ef72fcac2d6c4 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 27 May 2020 11:16:19 +0100
Subject: [PATCH] btrfs: fix space_info bytes_may_use underflow during space
 cache writeout

We always preallocate a data extent for writing a free space cache, which
causes writeback to always try the nocow path first, since the free space
inode has the prealloc bit set in its flags.

However if the block group that contains the data extent for the space
cache has been turned to RO mode due to a running scrub or balance for
example, we have to fallback to the cow path. In that case once a new data
extent is allocated we end up calling btrfs_add_reserved_bytes(), which
decrements the counter named bytes_may_use from the data space_info object
with the expection that this counter was previously incremented with the
same amount (the size of the data extent).

However when we started writeout of the space cache at cache_save_setup(),
we incremented the value of the bytes_may_use counter through a call to
btrfs_check_data_free_space() and then decremented it through a call to
btrfs_prealloc_file_range_trans() immediately after. So when starting the
writeback if we fallback to cow mode we have to increment the counter
bytes_may_use of the data space_info again to compensate for the extent
allocation done by the cow path.

When this issue happens we are incorrectly decrementing the bytes_may_use
counter and when its current value is smaller then the amount we try to
subtract we end up with the following warning:

 ------------[ cut here ]------------
 WARNING: CPU: 3 PID: 657 at fs/btrfs/space-info.h:115 btrfs_add_reserved_bytes+0x3d6/0x4e0 [btrfs]
 Modules linked in: btrfs blake2b_generic xor raid6_pq libcrc32c (...)
 CPU: 3 PID: 657 Comm: kworker/u8:7 Tainted: G        W         5.6.0-rc7-btrfs-next-58 #5
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
 Workqueue: writeback wb_workfn (flush-btrfs-1591)
 RIP: 0010:btrfs_add_reserved_bytes+0x3d6/0x4e0 [btrfs]
 Code: ff ff 48 (...)
 RSP: 0000:ffffa41608f13660 EFLAGS: 00010287
 RAX: 0000000000001000 RBX: ffff9615b93ae400 RCX: 0000000000000000
 RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff9615b96ab410
 RBP: fffffffffffee000 R08: 0000000000000001 R09: 0000000000000000
 R10: ffff961585e62a40 R11: 0000000000000000 R12: ffff9615b96ab400
 R13: ffff9615a1a2a000 R14: 0000000000012000 R15: ffff9615b93ae400
 FS:  0000000000000000(0000) GS:ffff9615bb200000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055cbbc2ae178 CR3: 0000000115794006 CR4: 00000000003606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  find_free_extent+0x4a0/0x16c0 [btrfs]
  btrfs_reserve_extent+0x91/0x180 [btrfs]
  cow_file_range+0x12d/0x490 [btrfs]
  btrfs_run_delalloc_range+0x9f/0x6d0 [btrfs]
  ? find_lock_delalloc_range+0x221/0x250 [btrfs]
  writepage_delalloc+0xe8/0x150 [btrfs]
  __extent_writepage+0xe8/0x4c0 [btrfs]
  extent_write_cache_pages+0x237/0x530 [btrfs]
  extent_writepages+0x44/0xa0 [btrfs]
  do_writepages+0x23/0x80
  __writeback_single_inode+0x59/0x700
  writeback_sb_inodes+0x267/0x5f0
  __writeback_inodes_wb+0x87/0xe0
  wb_writeback+0x382/0x590
  ? wb_workfn+0x4a2/0x6c0
  wb_workfn+0x4a2/0x6c0
  process_one_work+0x26d/0x6a0
  worker_thread+0x4f/0x3e0
  ? process_one_work+0x6a0/0x6a0
  kthread+0x103/0x140
  ? kthread_create_worker_on_cpu+0x70/0x70
  ret_from_fork+0x3a/0x50
 irq event stamp: 0
 hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 hardirqs last disabled at (0): [<ffffffffb2abdedf>] copy_process+0x74f/0x2020
 softirqs last  enabled at (0): [<ffffffffb2abdedf>] copy_process+0x74f/0x2020
 softirqs last disabled at (0): [<0000000000000000>] 0x0
 ---[ end trace bd7c03622e0b0a52 ]---
 ------------[ cut here ]------------

So fix this by incrementing the bytes_may_use counter of the data
space_info when we fallback to the cow path. If the cow path is successful
the counter is decremented after extent allocation (by
btrfs_add_reserved_bytes()), if it fails it ends up being decremented as
well when clearing the delalloc range (extent_clear_unlock_delalloc()).

This could be triggered sporadically by the test case btrfs/061 from
fstests.

Fixes: 82d5902d9c681b ("Btrfs: Support reading/writing on disk free ino cache")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 486b1da2fc5c..1242d0aa108d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1359,6 +1359,8 @@ static int fallback_to_cow(struct inode *inode, struct page *locked_page,
 			   const u64 start, const u64 end,
 			   int *page_started, unsigned long *nr_written)
 {
+	const bool is_space_ino = btrfs_is_free_space_inode(BTRFS_I(inode));
+	const u64 range_bytes = end + 1 - start;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	u64 range_start = start;
 	u64 count;
@@ -1386,19 +1388,27 @@ static int fallback_to_cow(struct inode *inode, struct page *locked_page,
 	 *    that if the COW path fails for any reason, it decrements (through
 	 *    extent_clear_unlock_delalloc()) the bytes_may_use counter of the
 	 *    data space info, which we incremented in the step above.
+	 *
+	 * If we need to fallback to cow and the inode corresponds to a free
+	 * space cache inode, we must also increment bytes_may_use of the data
+	 * space_info for the same reason. Space caches always get a prealloc
+	 * extent for them, however scrub or balance may have set the block
+	 * group that contains that extent to RO mode.
 	 */
-	count = count_range_bits(io_tree, &range_start, end, end + 1 - start,
+	count = count_range_bits(io_tree, &range_start, end, range_bytes,
 				 EXTENT_NORESERVE, 0);
-	if (count > 0) {
+	if (count > 0 || is_space_ino) {
+		const u64 bytes = is_space_ino ? range_bytes : count;
 		struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 		struct btrfs_space_info *sinfo = fs_info->data_sinfo;
 
 		spin_lock(&sinfo->lock);
-		btrfs_space_info_update_bytes_may_use(fs_info, sinfo, count);
+		btrfs_space_info_update_bytes_may_use(fs_info, sinfo, bytes);
 		spin_unlock(&sinfo->lock);
 
-		clear_extent_bit(io_tree, start, end, EXTENT_NORESERVE, 0, 0,
-				 NULL);
+		if (count > 0)
+			clear_extent_bit(io_tree, start, end, EXTENT_NORESERVE,
+					 0, 0, NULL);
 	}
 
 	return cow_file_range(inode, locked_page, start, end, page_started,

