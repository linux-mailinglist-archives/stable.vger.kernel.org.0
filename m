Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089C22C741F
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgK1Vtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:47 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:40333 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731582AbgK1SEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 13:04:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1C07D1942885;
        Sat, 28 Nov 2020 07:26:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 28 Nov 2020 07:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9CjvhA
        kWIhjJDcCVFnR3BtLEt9AIC7amp0622DZlp1U=; b=IoA6PwEzAy2oayRJscnteD
        8ANShcA2EwWlPb1B/j836ngxXAz15yjEa8QUgu73odmEeB0qMbnvX6NZDHI8On+O
        m3P2v1C19OuCLRJrM+IrL8LPnTq9jM+mh52GeoWLninn7VEmAszQr62odvstVsyB
        Y3UtG21cpBQh5AxnvJ+iuf2Haegvb4kGadciYYlga0l/WQaDP4IhUnzCzyKcevTh
        PubZB6HGh+lj6W56sc623ErDEw1FTaB57Eqz6B4Dfm0I/9bnP60jFMlZI6UE8eXM
        f9JJ02l3RfHingjlIvtIyrW4XUPURukwiWvjmfPuWdY+R20Fk+mPnC/ERLUe03dg
        ==
X-ME-Sender: <xms:30HCX2g-mZqGscTXvMbVKGdBUgEXpOQnrM21y526nh6p5uqwvxb78w>
    <xme:30HCX3AeJ4G0lK68MOe8mtKqjl3p2hml_Xvzon7EJ0_EPu9Wbdp335ySgNL7rr0F1
    78DR5AsVjhhcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehiedggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieffvdduffdvhfefffeuvedugfevhfeuiefghedvvd
    ekgfefuddtudehvedtteffnecuffhomhgrihhnpehgnhhurdhorhhgnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:30HCX-HtoElPLFm-BdC5jsmVTMwuAMQbhPPfN-tZvormVvfPbie4Fg>
    <xmx:30HCX_TajJ3ou9xuO5gZklJ4ngBe5dcg_tnjd77psJIehvrIuOh-Lg>
    <xmx:30HCXzw25E5tpb2QcRoCg5peGHZccDxLKHR-YzbKCq-NTJ6qDBAb5g>
    <xmx:4EHCX8rQwBeauwBTDq5zQ_5zzJP4DxCw3Nmh93hkq-tjXlDniUPKcA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77BEB3064AAE;
        Sat, 28 Nov 2020 07:26:07 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix missing delalloc new bit for new delalloc ranges" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 28 Nov 2020 13:27:16 +0100
Message-ID: <1606566436201143@kroah.com>
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

From c334730988ee07908ba4eb816ce78d3fe06fecaa Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 4 Nov 2020 11:07:31 +0000
Subject: [PATCH] btrfs: fix missing delalloc new bit for new delalloc ranges

When doing a buffered write, through one of the write family syscalls, we
look for ranges which currently don't have allocated extents and set the
'delalloc new' bit on them, so that we can report a correct number of used
blocks to the stat(2) syscall until delalloc is flushed and ordered extents
complete.

However there are a few other places where we can do a buffered write
against a range that is mapped to a hole (no extent allocated) and where
we do not set the 'new delalloc' bit. Those places are:

- Doing a memory mapped write against a hole;

- Cloning an inline extent into a hole starting at file offset 0;

- Calling btrfs_cont_expand() when the i_size of the file is not aligned
  to the sector size and is located in a hole. For example when cloning
  to a destination offset beyond EOF.

So after such cases, until the corresponding delalloc range is flushed and
the respective ordered extents complete, we can report an incorrect number
of blocks used through the stat(2) syscall.

In some cases we can end up reporting 0 used blocks to stat(2), which is a
particular bad value to report as it may mislead tools to think a file is
completely sparse when its i_size is not zero, making them skip reading
any data, an undesired consequence for tools such as archivers and other
backup tools, as reported a long time ago in the following thread (and
other past threads):

  https://lists.gnu.org/archive/html/bug-tar/2016-07/msg00001.html

Example reproducer:

  $ cat reproducer.sh
  #!/bin/bash

  MNT=/mnt/sdi
  DEV=/dev/sdi

  mkfs.btrfs -f $DEV > /dev/null
  # mkfs.xfs -f $DEV > /dev/null
  # mkfs.ext4 -F $DEV > /dev/null
  # mkfs.f2fs -f $DEV > /dev/null
  mount $DEV $MNT

  xfs_io -f -c "truncate 64K"   \
      -c "mmap -w 0 64K"        \
      -c "mwrite -S 0xab 0 64K" \
      -c "munmap"               \
      $MNT/foo

  blocks_used=$(stat -c %b $MNT/foo)
  echo "blocks used: $blocks_used"

  if [ $blocks_used -eq 0 ]; then
      echo "ERROR: blocks used is 0"
  fi

  umount $DEV

  $ ./reproducer.sh
  blocks used: 0
  ERROR: blocks used is 0

So move the logic that decides to set the 'delalloc bit' bit into the
function btrfs_set_extent_delalloc(), since that is what we use for all
those missing cases as well as for the cases that currently work well.

This change is also preparatory work for an upcoming patch that fixes
other problems related to tracking and reporting the number of bytes used
by an inode.

CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 87355a38a654..4373da7bcc0d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -452,46 +452,6 @@ static void btrfs_drop_pages(struct page **pages, size_t num_pages)
 	}
 }
 
-static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
-					 const u64 start,
-					 const u64 len,
-					 struct extent_state **cached_state)
-{
-	u64 search_start = start;
-	const u64 end = start + len - 1;
-
-	while (search_start < end) {
-		const u64 search_len = end - search_start + 1;
-		struct extent_map *em;
-		u64 em_len;
-		int ret = 0;
-
-		em = btrfs_get_extent(inode, NULL, 0, search_start, search_len);
-		if (IS_ERR(em))
-			return PTR_ERR(em);
-
-		if (em->block_start != EXTENT_MAP_HOLE)
-			goto next;
-
-		em_len = em->len;
-		if (em->start < search_start)
-			em_len -= search_start - em->start;
-		if (em_len > search_len)
-			em_len = search_len;
-
-		ret = set_extent_bit(&inode->io_tree, search_start,
-				     search_start + em_len - 1,
-				     EXTENT_DELALLOC_NEW,
-				     NULL, cached_state, GFP_NOFS);
-next:
-		search_start = extent_map_end(em);
-		free_extent_map(em);
-		if (ret)
-			return ret;
-	}
-	return 0;
-}
-
 /*
  * after copy_from_user, pages need to be dirtied and we need to make
  * sure holes are created between the current EOF and the start of
@@ -528,23 +488,6 @@ int btrfs_dirty_pages(struct btrfs_inode *inode, struct page **pages,
 			 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			 0, 0, cached);
 
-	if (!btrfs_is_free_space_inode(inode)) {
-		if (start_pos >= isize &&
-		    !(inode->flags & BTRFS_INODE_PREALLOC)) {
-			/*
-			 * There can't be any extents following eof in this case
-			 * so just set the delalloc new bit for the range
-			 * directly.
-			 */
-			extra_bits |= EXTENT_DELALLOC_NEW;
-		} else {
-			err = btrfs_find_new_delalloc_bytes(inode, start_pos,
-							    num_bytes, cached);
-			if (err)
-				return err;
-		}
-	}
-
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
 					extra_bits, cached);
 	if (err)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index da58c58ef9aa..7e8d8169779d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2253,11 +2253,69 @@ static int add_pending_csums(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
+					 const u64 start,
+					 const u64 len,
+					 struct extent_state **cached_state)
+{
+	u64 search_start = start;
+	const u64 end = start + len - 1;
+
+	while (search_start < end) {
+		const u64 search_len = end - search_start + 1;
+		struct extent_map *em;
+		u64 em_len;
+		int ret = 0;
+
+		em = btrfs_get_extent(inode, NULL, 0, search_start, search_len);
+		if (IS_ERR(em))
+			return PTR_ERR(em);
+
+		if (em->block_start != EXTENT_MAP_HOLE)
+			goto next;
+
+		em_len = em->len;
+		if (em->start < search_start)
+			em_len -= search_start - em->start;
+		if (em_len > search_len)
+			em_len = search_len;
+
+		ret = set_extent_bit(&inode->io_tree, search_start,
+				     search_start + em_len - 1,
+				     EXTENT_DELALLOC_NEW,
+				     NULL, cached_state, GFP_NOFS);
+next:
+		search_start = extent_map_end(em);
+		free_extent_map(em);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
 			      struct extent_state **cached_state)
 {
 	WARN_ON(PAGE_ALIGNED(end));
+
+	if (start >= i_size_read(&inode->vfs_inode) &&
+	    !(inode->flags & BTRFS_INODE_PREALLOC)) {
+		/*
+		 * There can't be any extents following eof in this case so just
+		 * set the delalloc new bit for the range directly.
+		 */
+		extra_bits |= EXTENT_DELALLOC_NEW;
+	} else {
+		int ret;
+
+		ret = btrfs_find_new_delalloc_bytes(inode, start,
+						    end + 1 - start,
+						    cached_state);
+		if (ret)
+			return ret;
+	}
+
 	return set_extent_delalloc(&inode->io_tree, start, end, extra_bits,
 				   cached_state);
 }
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index e6719f7db386..04022069761d 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -983,7 +983,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
 			       BTRFS_MAX_EXTENT_SIZE >> 1,
 			       (BTRFS_MAX_EXTENT_SIZE >> 1) + sectorsize - 1,
-			       EXTENT_DELALLOC | EXTENT_UPTODATE, 0, 0, NULL);
+			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
 		test_err("clear_extent_bit returned %d", ret);
 		goto out;
@@ -1050,7 +1051,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
 			       BTRFS_MAX_EXTENT_SIZE + sectorsize,
 			       BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1,
-			       EXTENT_DELALLOC | EXTENT_UPTODATE, 0, 0, NULL);
+			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
 		test_err("clear_extent_bit returned %d", ret);
 		goto out;
@@ -1082,7 +1084,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 
 	/* Empty */
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
-			       EXTENT_DELALLOC | EXTENT_UPTODATE, 0, 0, NULL);
+			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
 		test_err("clear_extent_bit returned %d", ret);
 		goto out;
@@ -1097,7 +1100,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 out:
 	if (ret)
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
-				 EXTENT_DELALLOC | EXTENT_UPTODATE, 0, 0, NULL);
+				 EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+				 EXTENT_UPTODATE, 0, 0, NULL);
 	iput(inode);
 	btrfs_free_dummy_root(root);
 	btrfs_free_dummy_fs_info(fs_info);

