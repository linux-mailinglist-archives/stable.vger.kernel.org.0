Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686132C641E
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 12:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgK0Lyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 06:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgK0Lya (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 06:54:30 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297A3C0613D1
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 03:54:30 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id g14so5263808wrm.13
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 03:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=GqZlUjBeCngaw8Gs4CahZtVewB1i/GN3mvcky0Ik3qE=;
        b=eKtNfJR+E7BAGlw0BUeKUYpr3PTgfNr43L+0P75xbxYtL4O+TKNupcPTp5Q1gofAQk
         Y4/vlj6GUOfb1uylzNnrOiw02gUTvKOqFg3XOwYQgJdJbRZAXhUJk/M5k6681GzdOFUF
         Qnx6HbamQs8w2fWRS8TCFaHoNKVN6cHAKzy3pBD3DxcImtM9mZB469JGw0YoXRK4mqNg
         JCzyzr7FWjtwY7B/mKUrLxXG8PQJLwM7cp5vvarIeHK53pTRKuxBYRgcHYLHQoXKABvU
         53pmMDdPZjFGbsHKJC51q89CD/Zza8IrbL5xsu8mxK53vqnxXINI/Tn3qFvNDdRidaUn
         sCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=GqZlUjBeCngaw8Gs4CahZtVewB1i/GN3mvcky0Ik3qE=;
        b=Bvl3NmItTSrqEr0W84ND926WUVdOEZ7PxWH4QJzs2T3pZI8JmqQ3k4FT0ArIZgYIOY
         cUZb1976pW7ZgnL/1PMbT1unbwhnepj2Fa97qQtKsBzNa6ii3HAcjw7fXReTcxarDJMo
         493gNsJC9ogeH+3g27R+llBB3ZM6slFG99CJNcR/te9JND0cwmz9wnmprq15DOQRYWte
         lYcr/nnqrFqkvwW+ZzqAsfl8r+0je00GWypEDgtyDA/w95D5jj6vHcs6qXHIv4aH0ZBo
         zUGCvt7sqdNDRIEqQmEcuclbzQ8tDjGpT0STDkUp96WgFLinm+cfIo9bmiInjHLinu89
         F9hQ==
X-Gm-Message-State: AOAM531SdkegOnr+FV/mKTaABGswfI1hC63BEF4tvtbeDdcSlGNXpRDv
        r/9MkiL5Moh8c9CoKfLYDSo=
X-Google-Smtp-Source: ABdhPJxrNLXea6Bi6BZpaKEdwA/o36dIznvXV4wQ5RSuIPqZbNC1vj1hsrLZCq3QRVGkWQBM+YJc1g==
X-Received: by 2002:adf:902d:: with SMTP id h42mr9840826wrh.175.1606478068953;
        Fri, 27 Nov 2020 03:54:28 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id w11sm13031803wmg.36.2020.11.27.03.54.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Nov 2020 03:54:28 -0800 (PST)
Date:   Fri, 27 Nov 2020 11:54:26 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: few missing fixes for 4.4-stable
Message-ID: <20201127115426.yo7j35prdvfiyhgy@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zqcnocgp5wzxynsb"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zqcnocgp5wzxynsb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

These two were missing in 4.4-stable. Please apply to your queue.

80e46cf22ba0 ("btrfs: tree-checker: Enhance chunk checker to validate chunk profile")
6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference")


--
Regards
Sudip

--zqcnocgp5wzxynsb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-btrfs-tree-checker-Enhance-chunk-checker-to-validate.patch"

From c5d445abc052532ded78586dc62d062546f815b3 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Wed, 13 Mar 2019 12:17:50 +0800
Subject: [PATCH 1/2] btrfs: tree-checker: Enhance chunk checker to validate chunk profile

commit 80e46cf22ba0bcb57b39c7c3b52961ab3a0fd5f2 upstream

Btrfs-progs already have a comprehensive type checker, to ensure there
is only 0 (SINGLE profile) or 1 (DUP/RAID0/1/5/6/10) bit set for chunk
profile bits.

Do the same work for kernel.

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202765
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: manually backport, use btrfs_err with root->fs_info]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/volumes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2d10b818399b..cd1e9411f926 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6262,6 +6262,13 @@ static int btrfs_check_chunk_valid(struct btrfs_root *root,
 		return -EIO;
 	}
 
+	if (!is_power_of_2(type & BTRFS_BLOCK_GROUP_PROFILE_MASK) &&
+	    (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) != 0) {
+		btrfs_err(root->fs_info,
+		"invalid chunk profile flag: 0x%llx, expect 0 or 1 bit set",
+			  type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		return -EUCLEAN;
+	}
 	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
 		btrfs_err(root->fs_info, "missing chunk type flag: 0x%llx", type);
 		return -EIO;
-- 
2.11.0


--zqcnocgp5wzxynsb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-btrfs-inode-Verify-inode-mode-to-avoid-NULL-pointer-.patch"

From 6bdcf8c246aa2a0289e59413a61ee67ab0c6a1f8 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Wed, 13 Mar 2019 13:55:11 +0800
Subject: [PATCH 2/2] btrfs: inode: Verify inode mode to avoid NULL pointer dereference

commit 6bf9e4bd6a277840d3fe8c5d5d530a1fbd3db592 upstream

[BUG]
When accessing a file on a crafted image, btrfs can crash in block layer:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  PGD 136501067 P4D 136501067 PUD 124519067 PMD 0
  CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.0.0-rc8-default #252
  RIP: 0010:end_bio_extent_readpage+0x144/0x700
  Call Trace:
   <IRQ>
   blk_update_request+0x8f/0x350
   blk_mq_end_request+0x1a/0x120
   blk_done_softirq+0x99/0xc0
   __do_softirq+0xc7/0x467
   irq_exit+0xd1/0xe0
   call_function_single_interrupt+0xf/0x20
   </IRQ>
  RIP: 0010:default_idle+0x1e/0x170

[CAUSE]
The crafted image has a tricky corruption, the INODE_ITEM has a
different type against its parent dir:

        item 20 key (268 INODE_ITEM 0) itemoff 2808 itemsize 160
                generation 13 transid 13 size 1048576 nbytes 1048576
                block group 0 mode 121644 links 1 uid 0 gid 0 rdev 0
                sequence 9 flags 0x0(none)

This mode number 0120000 means it's a symlink.

But the dir item think it's still a regular file:

        item 8 key (264 DIR_INDEX 5) itemoff 3707 itemsize 32
                location key (268 INODE_ITEM 0) type FILE
                transid 13 data_len 0 name_len 2
                name: f4
        item 40 key (264 DIR_ITEM 51821248) itemoff 1573 itemsize 32
                location key (268 INODE_ITEM 0) type FILE
                transid 13 data_len 0 name_len 2
                name: f4

For symlink, we don't set BTRFS_I(inode)->io_tree.ops and leave it
empty, as symlink is only designed to have inlined extent, all handled
by tree block read.  Thus no need to trigger btrfs_submit_bio_hook() for
inline file extent.

However end_bio_extent_readpage() expects tree->ops populated, as it's
reading regular data extent.  This causes NULL pointer dereference.

[FIX]
This patch fixes the problem in two ways:

- Verify inode mode against its dir item when looking up inode
  So in btrfs_lookup_dentry() if we find inode mode mismatch with dir
  item, we error out so that corrupted inode will not be accessed.

- Verify inode mode when getting extent mapping
  Only regular file should have regular or preallocated extent.
  If we found regular/preallocated file extent for symlink or
  the rest, we error out before submitting the read bio.

With this fix that crafted image can be rejected gracefully:

  BTRFS critical (device loop0): inode mode mismatch with dir: inode mode=0121644 btrfs type=7 dir type=1

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202763
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: use original btrfs_inode_type(), btrfs_crit with root->fs_info,
ISREG with inode->i_mode and adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/inode.c             | 41 +++++++++++++++++++++++++++++++++--------
 fs/btrfs/tests/inode-tests.c |  1 +
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b1125778b908..9e1f9910bdf2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5370,11 +5370,13 @@ no_delete:
 }
 
 /*
- * this returns the key found in the dir entry in the location pointer.
+ * Return the key found in the dir entry in the location pointer, fill @type
+ * with BTRFS_FT_*, and return 0.
+ *
  * If no dir entries were found, location->objectid is 0.
  */
 static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
-			       struct btrfs_key *location)
+			       struct btrfs_key *location, u8 *type)
 {
 	const char *name = dentry->d_name.name;
 	int namelen = dentry->d_name.len;
@@ -5396,6 +5398,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 		goto out_err;
 
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, location);
+	if (!ret)
+		*type = btrfs_dir_type(path->nodes[0], di);
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -5681,19 +5685,25 @@ static struct inode *new_simple_dir(struct super_block *s,
 	return inode;
 }
 
+static inline u8 btrfs_inode_type(struct inode *inode)
+{
+	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
+}
+
 struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
+	u8 di_type = 0;
 	int index;
 	int ret = 0;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ret = btrfs_inode_by_name(dir, dentry, &location);
+	ret = btrfs_inode_by_name(dir, dentry, &location, &di_type);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
@@ -5702,6 +5712,18 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
+		if (IS_ERR(inode))
+			return inode;
+
+		/* Do extra check against inode mode with di_type */
+		if (btrfs_inode_type(inode) != di_type) {
+			btrfs_crit(root->fs_info,
+"inode mode mismatch with dir: inode mode=0%o btrfs type=%u dir type=%u",
+				  inode->i_mode, btrfs_inode_type(inode),
+				  di_type);
+			iput(inode);
+			return ERR_PTR(-EUCLEAN);
+		}
 		return inode;
 	}
 
@@ -6315,11 +6337,6 @@ fail:
 	return ERR_PTR(ret);
 }
 
-static inline u8 btrfs_inode_type(struct inode *inode)
-{
-	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
-}
-
 /*
  * utility function to add 'inode' into 'parent_inode' with
  * a give name and a given sequence number.
@@ -6904,6 +6921,14 @@ again:
 	extent_start = found_key.offset;
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+		/* Only regular file could have regular/prealloc extent */
+		if (!S_ISREG(inode->i_mode)) {
+			ret = -EUCLEAN;
+			btrfs_crit(root->fs_info,
+		"regular/prealloc extent found for non-regular inode %llu",
+				   btrfs_ino(inode));
+			goto out;
+		}
 		extent_end = extent_start +
 		       btrfs_file_extent_num_bytes(leaf, item);
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 054fc0d97131..5ff676df698f 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -235,6 +235,7 @@ static noinline int test_btrfs_get_extent(void)
 		return ret;
 	}
 
+	inode->i_mode = S_IFREG;
 	BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
 	BTRFS_I(inode)->location.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	BTRFS_I(inode)->location.offset = 0;
-- 
2.11.0


--zqcnocgp5wzxynsb--
