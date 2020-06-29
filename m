Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C7E20D17F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgF2SmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:42:02 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39259 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729062AbgF2SmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:42:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8D9DA8E1;
        Mon, 29 Jun 2020 07:05:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zYrkIv
        sPbAdfGbXp9wVNk0Ci/vfZw+du+17yaP26aj0=; b=G6BcGDqW4aMAOMbnGnBKZr
        vFsg4i/pQbmWDfMGglsCKiSJouPGP4KgIqmhsK12HwEsZeTplmKY6cVVKyKs3m9c
        HXLcRbO65HuygmYk1xg8yG53mR8KpEV5R1fe7MKTx/1F36PCTd7v5XyTm42ha2ve
        UKsDHUChj9qXRK/FyVP9sUUcYk90PfbniNlFrdMgENZPWpnbe5W063Hn7Gd9fbV9
        LRChRx4qO792iT6QI5vhKfeKbm5rvFn4E4MQJY8RFievW1GaaHE6c3DfupWgYlAm
        wH2uNZ8sZ+yKeSzmrPZIwJ89g4U7aIWDpPZ2Il5IzcOepgcVp54ze5N0I5LA4sSQ
        ==
X-ME-Sender: <xms:Fsv5Xq2NviA6mLdCxz6iKBOfx3cTtfXktmyXjYJOE1UuUdVWZDVKaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Fsv5XtHc3Q3LHqKnBsjWJzl74GFV1Z2bD8Wv3aqQXe_JhSldmw2tzA>
    <xmx:Fsv5Xi4j5wFUlwxqKhnyu7PjB2PdQvbcX69RabdEO1nA-SJaH4k_fQ>
    <xmx:Fsv5Xr26UBC2ZxcD_jiD1d1SFNvMYa2zqi2gbZJKkSRShnpKbFCNvQ>
    <xmx:Fsv5Xsx4uL7rlptkWwmUv1zQhheprS5LQSsEaPdIDWxUCpqidHxFSCOlgU4>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A25C13280060;
        Mon, 29 Jun 2020 07:05:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix RWF_NOWAIT write not failling when we need to cow" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:05:49 +0200
Message-ID: <159342874939122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 260a63395f90f67d6ab89e4266af9e3dc34a77e9 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 15 Jun 2020 18:49:13 +0100
Subject: [PATCH] btrfs: fix RWF_NOWAIT write not failling when we need to cow

If we attempt to do a RWF_NOWAIT write against a file range for which we
can only do NOCOW for a part of it, due to the existence of holes or
shared extents for example, we proceed with the write as if it were
possible to NOCOW the whole range.

Example:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ touch /mnt/sdj/bar
  $ chattr +C /mnt/sdj/bar

  $ xfs_io -d -c "pwrite -S 0xab -b 256K 0 256K" /mnt/bar
  wrote 262144/262144 bytes at offset 0
  256 KiB, 1 ops; 0.0003 sec (694.444 MiB/sec and 2777.7778 ops/sec)

  $ xfs_io -c "fpunch 64K 64K" /mnt/bar
  $ sync

  $ xfs_io -d -c "pwrite -N -V 1 -b 128K -S 0xfe 0 128K" /mnt/bar
  wrote 131072/131072 bytes at offset 0
  128 KiB, 1 ops; 0.0007 sec (160.051 MiB/sec and 1280.4097 ops/sec)

This last write should fail with -EAGAIN since the file range from 64K to
128K is a hole. On xfs it fails, as expected, but on ext4 it currently
succeeds because apparently it is expensive to check if there are extents
allocated for the whole range, but I'll check with the ext4 people.

Fix the issue by checking if check_can_nocow() returns a number of
NOCOW'able bytes smaller then the requested number of bytes, and if it
does return -EAGAIN.

Fixes: edf064e7c6fec3 ("btrfs: nowait aio support")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 04faa04fccd1..6d5d905281c6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1904,18 +1904,29 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	pos = iocb->ki_pos;
 	count = iov_iter_count(from);
 	if (iocb->ki_flags & IOCB_NOWAIT) {
+		size_t nocow_bytes = count;
+
 		/*
 		 * We will allocate space in case nodatacow is not set,
 		 * so bail
 		 */
 		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 					      BTRFS_INODE_PREALLOC)) ||
-		    check_can_nocow(BTRFS_I(inode), pos, &count) <= 0) {
+		    check_can_nocow(BTRFS_I(inode), pos, &nocow_bytes) <= 0) {
 			inode_unlock(inode);
 			return -EAGAIN;
 		}
 		/* check_can_nocow() locks the snapshot lock on success */
 		btrfs_drew_write_unlock(&root->snapshot_lock);
+		/*
+		 * There are holes in the range or parts of the range that must
+		 * be COWed (shared extents, RO block groups, etc), so just bail
+		 * out.
+		 */
+		if (nocow_bytes < count) {
+			inode_unlock(inode);
+			return -EAGAIN;
+		}
 	}
 
 	current->backing_dev_info = inode_to_bdi(inode);

