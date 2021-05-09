Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56CD377628
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 12:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhEIKKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 06:10:12 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57497 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhEIKKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 06:10:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 070D41A01;
        Sun,  9 May 2021 06:09:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 09 May 2021 06:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=d1GCPG
        E51o2QrLvB+LNL7JczirWt3/61b6EXmr/QBx4=; b=Uad+TI98dV2fSWq60qrEds
        Ru51tfDxzymySFd9hw+n18gk9Qu3Rqg9lMMWzVldIdhp2GysG32QZ3/x1fyuWJEq
        5FJDiy+oFsOolRu2cQa7yanfyYB3Hj0IjRjX4OMuZdmuMx5hRo0V5UJ1l7Trd7Aj
        1bBfo4AyTPNhVl0Arn62JBWUjd7Kwc7jKcMPZq7Juu+p09Uegrf8lZl8g3HVgvXH
        CpuBulBPrsHCHvzVQl7xqtKixixuwR+6MQthlaYE40VHd1BEFlwICrvBZUUUdX84
        sus/ILPIKoo3ldL2umqfqg23GdEN6t8pslCduE3NxB6c9T7aQot/y6+t+8hw3y4g
        ==
X-ME-Sender: <xms:wrSXYHlGOa3HuRo2Z8Ph_0PNMvnnFmuDjt_ykXGJAVauN4GRsEU5BA>
    <xme:wrSXYK3TNWTsrRyjbws4fpO_XDZyQe2Jx8w7pd83t_mQ2enh-0ryX1R4jGFc2UEeT
    mn3CnqYJ8TCYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:wrSXYNrm9Ce7ffuWGiqwWBJphU6naoXLYnViFeTWbZ1bl4rDCwhw0g>
    <xmx:wrSXYPmSiSz-3fCZOqHDvLybWpWtyE7qaVd7dsoD65e_gxPJI9owuQ>
    <xmx:wrSXYF0ObziMfbd45FEpxP8fLVIRMOl9Lic9Mn4Lx_ahFQrJs8y-_g>
    <xmx:w7SXYOyfhgY5Mman5l7vmhP3AlWHf4zHOyZE-sVqzlONnyujgSlG3C3Uo1s>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 06:09:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] f2fs: fix error handling in f2fs_end_enable_verity()" failed to apply to 5.4-stable tree
To:     ebiggers@google.com, heyunlei@hihonor.com, jaegeuk@kernel.org,
        stable@vger.kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 May 2021 12:09:04 +0200
Message-ID: <1620554944177170@kroah.com>
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

From 3c0315424f5e3d2a4113c7272367bee1e8e6a174 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 4 Mar 2021 21:43:10 -0800
Subject: [PATCH] f2fs: fix error handling in f2fs_end_enable_verity()

f2fs didn't properly clean up if verity failed to be enabled on a file:

- It left verity metadata (pages past EOF) in the page cache, which
  would be exposed to userspace if the file was later extended.

- It didn't truncate the verity metadata at all (either from cache or
  from disk) if an error occurred while setting the verity bit.

Fix these bugs by adding a call to truncate_inode_pages() and ensuring
that we truncate the verity metadata (both from cache and from disk) in
all error paths.  Also rework the code to cleanly separate the success
path from the error paths, which makes it much easier to understand.

Finally, log a message if f2fs_truncate() fails, since it might
otherwise fail silently.

Reported-by: Yunlei He <heyunlei@hihonor.com>
Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 054ec852b5ea..15ba36926fad 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -152,40 +152,73 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 				  size_t desc_size, u64 merkle_tree_size)
 {
 	struct inode *inode = file_inode(filp);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	u64 desc_pos = f2fs_verity_metadata_pos(inode) + merkle_tree_size;
 	struct fsverity_descriptor_location dloc = {
 		.version = cpu_to_le32(F2FS_VERIFY_VER),
 		.size = cpu_to_le32(desc_size),
 		.pos = cpu_to_le64(desc_pos),
 	};
-	int err = 0;
+	int err = 0, err2 = 0;
 
-	if (desc != NULL) {
-		/* Succeeded; write the verity descriptor. */
-		err = pagecache_write(inode, desc, desc_size, desc_pos);
+	/*
+	 * If an error already occurred (which fs/verity/ signals by passing
+	 * desc == NULL), then only clean-up is needed.
+	 */
+	if (desc == NULL)
+		goto cleanup;
 
-		/* Write all pages before clearing FI_VERITY_IN_PROGRESS. */
-		if (!err)
-			err = filemap_write_and_wait(inode->i_mapping);
-	}
+	/* Append the verity descriptor. */
+	err = pagecache_write(inode, desc, desc_size, desc_pos);
+	if (err)
+		goto cleanup;
+
+	/*
+	 * Write all pages (both data and verity metadata).  Note that this must
+	 * happen before clearing FI_VERITY_IN_PROGRESS; otherwise pages beyond
+	 * i_size won't be written properly.  For crash consistency, this also
+	 * must happen before the verity inode flag gets persisted.
+	 */
+	err = filemap_write_and_wait(inode->i_mapping);
+	if (err)
+		goto cleanup;
+
+	/* Set the verity xattr. */
+	err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_VERITY,
+			    F2FS_XATTR_NAME_VERITY, &dloc, sizeof(dloc),
+			    NULL, XATTR_CREATE);
+	if (err)
+		goto cleanup;
 
-	/* If we failed, truncate anything we wrote past i_size. */
-	if (desc == NULL || err)
-		f2fs_truncate(inode);
+	/* Finally, set the verity inode flag. */
+	file_set_verity(inode);
+	f2fs_set_inode_flags(inode);
+	f2fs_mark_inode_dirty_sync(inode, true);
 
 	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
+	return 0;
 
-	if (desc != NULL && !err) {
-		err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_VERITY,
-				    F2FS_XATTR_NAME_VERITY, &dloc, sizeof(dloc),
-				    NULL, XATTR_CREATE);
-		if (!err) {
-			file_set_verity(inode);
-			f2fs_set_inode_flags(inode);
-			f2fs_mark_inode_dirty_sync(inode, true);
-		}
+cleanup:
+	/*
+	 * Verity failed to be enabled, so clean up by truncating any verity
+	 * metadata that was written beyond i_size (both from cache and from
+	 * disk) and clearing FI_VERITY_IN_PROGRESS.
+	 *
+	 * Taking i_gc_rwsem[WRITE] is needed to stop f2fs garbage collection
+	 * from re-instantiating cached pages we are truncating (since unlike
+	 * normal file accesses, garbage collection isn't limited by i_size).
+	 */
+	down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	err2 = f2fs_truncate(inode);
+	if (err2) {
+		f2fs_err(sbi, "Truncating verity metadata failed (errno=%d)",
+			 err2);
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
-	return err;
+	up_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
+	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
+	return err ?: err2;
 }
 
 static int f2fs_get_verity_descriptor(struct inode *inode, void *buf,

