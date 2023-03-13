Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F128B6B7498
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 11:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjCMKtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 06:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjCMKtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 06:49:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93813526E
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 03:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58ACCB80FF1
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF964C433D2;
        Mon, 13 Mar 2023 10:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678704539;
        bh=krg1rNAXY0P/F6XSWLTRLqcXIO5rxSdH506Hf3qjuQQ=;
        h=Subject:To:Cc:From:Date:From;
        b=BN9Kcv8IKgvuz5WKlsArAXivCBVJ1Q6+0iLqTjF8bEOov504PZ2DzFvB2J2Pb10rR
         crBmSDTgyGU/nEZw5Morjporq1p72rcAvbwB8rP6TXGfVOfCXmAtuqwEUZnN9e2b3+
         9BrUNVtsrKVsAH7skViL72/t8m2y5u8M6JPF2pd4=
Subject: FAILED: patch "[PATCH] ext4: fix cgroup writeback accounting with fs-layer" failed to apply to 4.19-stable tree
To:     ebiggers@google.com, tj@kernel.org, tytso@mit.edu,
        willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Mar 2023 11:48:48 +0100
Message-ID: <16787045285233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x ffec85d53d0f39ee4680a2cf0795255e000e1feb
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16787045285233@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

ffec85d53d0f ("ext4: fix cgroup writeback accounting with fs-layer encryption")
29b83c574b0a ("ext4: remove nr_submitted from ext4_bio_write_page()")
04e568a3b31c ("ext4: handle redirtying in ext4_bio_write_page()")
c75e707fe1aa ("block: remove the per-bio/request write hint")
4c4dad11ff85 ("ext4: pass the operation to bio_alloc")
07888c665b40 ("block: pass a block_device and opf to bio_alloc")
b77c88c2100c ("block: pass a block_device and opf to bio_alloc_kiocb")
609be1066731 ("block: pass a block_device and opf to bio_alloc_bioset")
0a3140ea0fae ("block: pass a block_device and opf to blk_next_bio")
3b005bf6acf0 ("block: move blk_next_bio to bio.c")
7d8d0c658d48 ("xen-blkback: bio_alloc can't fail if it is allow to sleep")
d7b78de2b155 ("rnbd-srv: remove struct rnbd_dev_blk_io")
1fe0640ff94f ("rnbd-srv: simplify bio mapping in process_rdma")
4b1dc86d1857 ("drbd: bio_alloc can't fail if it is allow to sleep")
3f868c09ea8f ("dm-crypt: remove clone_init")
53db984e004c ("dm: bio_alloc can't fail if it is allowed to sleep")
39146b6f66ba ("ntfs3: remove ntfs_alloc_bio")
5d2ca2132f88 ("nfs/blocklayout: remove bl_alloc_init_bio")
f0d911927b3c ("nilfs2: remove nilfs_alloc_seg_bio")
d5f68a42da7a ("fs: remove mpage_alloc")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ffec85d53d0f39ee4680a2cf0795255e000e1feb Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 2 Feb 2023 16:55:03 -0800
Subject: [PATCH] ext4: fix cgroup writeback accounting with fs-layer
 encryption

When writing a page from an encrypted file that is using
filesystem-layer encryption (not inline encryption), ext4 encrypts the
pagecache page into a bounce page, then writes the bounce page.

It also passes the bounce page to wbc_account_cgroup_owner().  That's
incorrect, because the bounce page is a newly allocated temporary page
that doesn't have the memory cgroup of the original pagecache page.
This makes wbc_account_cgroup_owner() not account the I/O to the owner
of the pagecache page as it should.

Fix this by always passing the pagecache page to
wbc_account_cgroup_owner().

Fixes: 001e4a8775f6 ("ext4: implement cgroup writeback support")
Cc: stable@vger.kernel.org
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230203005503.141557-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index beaec6d81074..1e4db96a04e6 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -409,7 +409,8 @@ static void io_submit_init_bio(struct ext4_io_submit *io,
 
 static void io_submit_add_bh(struct ext4_io_submit *io,
 			     struct inode *inode,
-			     struct page *page,
+			     struct page *pagecache_page,
+			     struct page *bounce_page,
 			     struct buffer_head *bh)
 {
 	int ret;
@@ -421,10 +422,11 @@ static void io_submit_add_bh(struct ext4_io_submit *io,
 	}
 	if (io->io_bio == NULL)
 		io_submit_init_bio(io, bh);
-	ret = bio_add_page(io->io_bio, page, bh->b_size, bh_offset(bh));
+	ret = bio_add_page(io->io_bio, bounce_page ?: pagecache_page,
+			   bh->b_size, bh_offset(bh));
 	if (ret != bh->b_size)
 		goto submit_and_retry;
-	wbc_account_cgroup_owner(io->io_wbc, page, bh->b_size);
+	wbc_account_cgroup_owner(io->io_wbc, pagecache_page, bh->b_size);
 	io->io_next_block++;
 }
 
@@ -561,8 +563,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	do {
 		if (!buffer_async_write(bh))
 			continue;
-		io_submit_add_bh(io, inode,
-				 bounce_page ? bounce_page : page, bh);
+		io_submit_add_bh(io, inode, page, bounce_page, bh);
 	} while ((bh = bh->b_this_page) != head);
 unlock:
 	unlock_page(page);

