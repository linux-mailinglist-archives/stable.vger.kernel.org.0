Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B2E20D172
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgF2Sl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:41:57 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33545 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729000AbgF2Sl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id EE2A96A5;
        Mon, 29 Jun 2020 07:01:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kbqkcM
        YhL8f7Cc/AAGIkGCw6Xu5A++7ovx8c/a0F+Cw=; b=ndamHcSq6IWw5nbptSjw0O
        a72py4Hx1HRetOjG8TKqE1xI5vVKcfy2Ay4rw9ZfyoWBaQvMXROX/iPCyZqQywbL
        L+IvxZjdIscJr9WwA3nlfeslIF43C1hWjFybFshxWMdHW/qpwRW9oJ0ayFSBpGXU
        1Eh+5n1cUTRBjaLP14gc7PPcsxD9AtQXatGmiDbRD8h6LjMJiJsruYQUqOVnVVz7
        q6xAUm4ofaHNomPPcXLFwBXDd55hpl8VZMNxmn6WLoCh/h0Ax6a3DfdLLyi9gj+D
        I6nHXud9tp6+6TUBYZW1/Ze0EYf5ZoADN+BDxHrxqp230gHoHvONx2/+iFP81aqQ
        ==
X-ME-Sender: <xms:B8r5XuVLnJC0n3DfX3U21DFRAXW-7VKB50GPjgujVMDpmCJLY4N-Uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepfeetteehueetheekueevhfefveejheegtdeiudehue
    ekheeijeefgfeuhfeigefhnecuffhomhgrihhnpehqvghmuhdrohhrghenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:B8r5XqkqztP6bhd17-b5ActbQpNCRBOIBKC8jbTXYt5cJLTbLikNYg>
    <xmx:B8r5XiZYSEJrifJAPV6_HiC96as8qb_wYFEvKNeXDSrtQkgM5OUuaw>
    <xmx:B8r5XlUY67PGrpLEGfBLZdPsyRHluz36TKZwQR5VmOkAiKmzZBCU6w>
    <xmx:B8r5XvsT3vmlbhYXr-8k2RtLsN0FGNXbJMOuMXpjJlVl8hwHAreQ3nGBceA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 371483067C80;
        Mon, 29 Jun 2020 07:01:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix bytes_may_use underflow when running balance and" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:01:19 +0200
Message-ID: <1593428479147177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6bd335b469f945f75474c11e3f577f85409f39c3 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 8 Jun 2020 13:33:05 +0100
Subject: [PATCH] btrfs: fix bytes_may_use underflow when running balance and
 scrub in parallel

When balance and scrub are running in parallel it is possible to end up
with an underflow of the bytes_may_use counter of the data space_info
object, which triggers a warning like the following:

   [134243.793196] BTRFS info (device sdc): relocating block group 1104150528 flags data
   [134243.806891] ------------[ cut here ]------------
   [134243.807561] WARNING: CPU: 1 PID: 26884 at fs/btrfs/space-info.h:125 btrfs_add_reserved_bytes+0x1da/0x280 [btrfs]
   [134243.808819] Modules linked in: btrfs blake2b_generic xor (...)
   [134243.815779] CPU: 1 PID: 26884 Comm: kworker/u8:8 Tainted: G        W         5.6.0-rc7-btrfs-next-58 #5
   [134243.816944] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
   [134243.818389] Workqueue: writeback wb_workfn (flush-btrfs-108483)
   [134243.819186] RIP: 0010:btrfs_add_reserved_bytes+0x1da/0x280 [btrfs]
   [134243.819963] Code: 0b f2 85 (...)
   [134243.822271] RSP: 0018:ffffa4160aae7510 EFLAGS: 00010287
   [134243.822929] RAX: 000000000000c000 RBX: ffff96159a8c1000 RCX: 0000000000000000
   [134243.823816] RDX: 0000000000008000 RSI: 0000000000000000 RDI: ffff96158067a810
   [134243.824742] RBP: ffff96158067a800 R08: 0000000000000001 R09: 0000000000000000
   [134243.825636] R10: ffff961501432a40 R11: 0000000000000000 R12: 000000000000c000
   [134243.826532] R13: 0000000000000001 R14: ffffffffffff4000 R15: ffff96158067a810
   [134243.827432] FS:  0000000000000000(0000) GS:ffff9615baa00000(0000) knlGS:0000000000000000
   [134243.828451] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   [134243.829184] CR2: 000055bd7e414000 CR3: 00000001077be004 CR4: 00000000003606e0
   [134243.830083] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   [134243.830975] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
   [134243.831867] Call Trace:
   [134243.832211]  find_free_extent+0x4a0/0x16c0 [btrfs]
   [134243.832846]  btrfs_reserve_extent+0x91/0x180 [btrfs]
   [134243.833487]  cow_file_range+0x12d/0x490 [btrfs]
   [134243.834080]  fallback_to_cow+0x82/0x1b0 [btrfs]
   [134243.834689]  ? release_extent_buffer+0x121/0x170 [btrfs]
   [134243.835370]  run_delalloc_nocow+0x33f/0xa30 [btrfs]
   [134243.836032]  btrfs_run_delalloc_range+0x1ea/0x6d0 [btrfs]
   [134243.836725]  ? find_lock_delalloc_range+0x221/0x250 [btrfs]
   [134243.837450]  writepage_delalloc+0xe8/0x150 [btrfs]
   [134243.838059]  __extent_writepage+0xe8/0x4c0 [btrfs]
   [134243.838674]  extent_write_cache_pages+0x237/0x530 [btrfs]
   [134243.839364]  extent_writepages+0x44/0xa0 [btrfs]
   [134243.839946]  do_writepages+0x23/0x80
   [134243.840401]  __writeback_single_inode+0x59/0x700
   [134243.841006]  writeback_sb_inodes+0x267/0x5f0
   [134243.841548]  __writeback_inodes_wb+0x87/0xe0
   [134243.842091]  wb_writeback+0x382/0x590
   [134243.842574]  ? wb_workfn+0x4a2/0x6c0
   [134243.843030]  wb_workfn+0x4a2/0x6c0
   [134243.843468]  process_one_work+0x26d/0x6a0
   [134243.843978]  worker_thread+0x4f/0x3e0
   [134243.844452]  ? process_one_work+0x6a0/0x6a0
   [134243.844981]  kthread+0x103/0x140
   [134243.845400]  ? kthread_create_worker_on_cpu+0x70/0x70
   [134243.846030]  ret_from_fork+0x3a/0x50
   [134243.846494] irq event stamp: 0
   [134243.846892] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
   [134243.847682] hardirqs last disabled at (0): [<ffffffffb2abdedf>] copy_process+0x74f/0x2020
   [134243.848687] softirqs last  enabled at (0): [<ffffffffb2abdedf>] copy_process+0x74f/0x2020
   [134243.849913] softirqs last disabled at (0): [<0000000000000000>] 0x0
   [134243.850698] ---[ end trace bd7c03622e0b0a96 ]---
   [134243.851335] ------------[ cut here ]------------

When relocating a data block group, for each extent allocated in the
block group we preallocate another extent with the same size for the
data relocation inode (we do it at prealloc_file_extent_cluster()).
We reserve space by calling btrfs_check_data_free_space(), which ends
up incrementing the data space_info's bytes_may_use counter, and
then call btrfs_prealloc_file_range() to allocate the extent, which
always decrements the bytes_may_use counter by the same amount.

The expectation is that writeback of the data relocation inode always
follows a NOCOW path, by writing into the preallocated extents. However,
when starting writeback we might end up falling back into the COW path,
because the block group that contains the preallocated extent was turned
into RO mode by a scrub running in parallel. The COW path then calls the
extent allocator which ends up calling btrfs_add_reserved_bytes(), and
this function decrements the bytes_may_use counter of the data space_info
object by an amount corresponding to the size of the allocated extent,
despite we haven't previously incremented it. When the counter currently
has a value smaller then the allocated extent we reset the counter to 0
and emit a warning, otherwise we just decrement it and slowly mess up
with this counter which is crucial for space reservation, the end result
can be granting reserved space to tasks when there isn't really enough
free space, and having the tasks fail later in critical places where
error handling consists of a transaction abort or hitting a BUG_ON().

Fix this by making sure that if we fallback to the COW path for a data
relocation inode, we increment the bytes_may_use counter of the data
space_info object. The COW path will then decrement it at
btrfs_add_reserved_bytes() on success or through its error handling part
by a call to extent_clear_unlock_delalloc() (which ends up calling
btrfs_clear_delalloc_extent() that does the decrement operation) in case
of an error.

Test case btrfs/061 from fstests could sporadically trigger this.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 62c3f4972ff6..62b49d2db928 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1378,6 +1378,8 @@ static int fallback_to_cow(struct inode *inode, struct page *locked_page,
 			   int *page_started, unsigned long *nr_written)
 {
 	const bool is_space_ino = btrfs_is_free_space_inode(BTRFS_I(inode));
+	const bool is_reloc_ino = (BTRFS_I(inode)->root->root_key.objectid ==
+				   BTRFS_DATA_RELOC_TREE_OBJECTID);
 	const u64 range_bytes = end + 1 - start;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	u64 range_start = start;
@@ -1408,18 +1410,23 @@ static int fallback_to_cow(struct inode *inode, struct page *locked_page,
 	 *    data space info, which we incremented in the step above.
 	 *
 	 * If we need to fallback to cow and the inode corresponds to a free
-	 * space cache inode, we must also increment bytes_may_use of the data
-	 * space_info for the same reason. Space caches always get a prealloc
+	 * space cache inode or an inode of the data relocation tree, we must
+	 * also increment bytes_may_use of the data space_info for the same
+	 * reason. Space caches and relocated data extents always get a prealloc
 	 * extent for them, however scrub or balance may have set the block
-	 * group that contains that extent to RO mode.
+	 * group that contains that extent to RO mode and therefore force COW
+	 * when starting writeback.
 	 */
 	count = count_range_bits(io_tree, &range_start, end, range_bytes,
 				 EXTENT_NORESERVE, 0);
-	if (count > 0 || is_space_ino) {
-		const u64 bytes = is_space_ino ? range_bytes : count;
+	if (count > 0 || is_space_ino || is_reloc_ino) {
+		u64 bytes = count;
 		struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 		struct btrfs_space_info *sinfo = fs_info->data_sinfo;
 
+		if (is_space_ino || is_reloc_ino)
+			bytes = range_bytes;
+
 		spin_lock(&sinfo->lock);
 		btrfs_space_info_update_bytes_may_use(fs_info, sinfo, bytes);
 		spin_unlock(&sinfo->lock);

