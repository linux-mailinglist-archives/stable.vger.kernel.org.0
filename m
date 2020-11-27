Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E27D2C63A0
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 12:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgK0LLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 06:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbgK0LLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 06:11:22 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8932AC0613D1
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 03:11:21 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id p8so5162617wrx.5
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 03:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=z3xXyVvnY6HxGsNWJKMyBep4P2J+uaQeXDNgTlx03BU=;
        b=YYnwhM162haPoi6GuA37nHaz0CdceQ6/7Z+TDpG6k6GpIaPDgBFPlcy/QmcdK5ef8Y
         JQ/ej8QBp558tLI1SDs5XeyIob6lFlmgTETagw+QbfHAUQ15pPvP7tRfILe9OP41Fnsc
         tpv2a4nhiEDnq44yhFF4HHqNc07yU1PDm5ewM9ZOou/e3DCgg5FGPpw21QdNs2qxDizZ
         m8A/wMB2jM5XJoMweplv7mzruZwRWTBoO/AXbFRGxM/xn0Qr3dHGcg3lAsahHXuU5Okq
         a0tOfoXWiVrb9C1DUeGeabnJceAnsDiLRQvQ157GNjWy4RxkWgvhMHZSEKiHxnwirvvj
         hdRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=z3xXyVvnY6HxGsNWJKMyBep4P2J+uaQeXDNgTlx03BU=;
        b=MnE7gj6NEqtv3exaFUp04/AOhKxekc9gsLPGv5I4bqMFcdRzyfcoGTV3rYS9/OvhaB
         GcS1zYDueoCD/akA1uTOYdCy4gfqOopfeIQ//FkHmkd3Rrxe+nFzimFdNzfzzf50XCNm
         l+8pMQqNDQjR0JL5GH7XcO4/gNP0BLNxajytLV6yUFUEuk4OTyAWgd+LNdXcz1XlK294
         mrEaanK5KZ/tc01JpbrNfD0oSKRm1I5o+j5ZF2dU/vrm/3o0Jd2YHj2XNFTTopKOe04+
         lm48GxcMaE3frr/8tsWEpHex0e+IQtCIJAzzD+0Q9IZCw9FCjJtCZ6ZFB57+bM58WSxQ
         uWXg==
X-Gm-Message-State: AOAM530mK8e5RFfiIlZcEDRubvu7AQmpRPqL3E2mmTPzrjHtAZ20Y8Y0
        AKjTy5O0cWnCQV1kZP31W/Q=
X-Google-Smtp-Source: ABdhPJwDu4DlHXWs75af1+kRlecijZ3ftTSpkNANnzP91XOE4lRzATKeFqnooGbgNMxxeoqJr/xQIA==
X-Received: by 2002:a5d:5552:: with SMTP id g18mr9779503wrw.145.1606475480143;
        Fri, 27 Nov 2020 03:11:20 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id f18sm13918014wru.42.2020.11.27.03.11.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Nov 2020 03:11:19 -0800 (PST)
Date:   Fri, 27 Nov 2020 11:11:17 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: few missing fixes for 4.14-stable
Message-ID: <20201127111117.dgvegz3h53rqjsgz@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qgpl3fbz7rhmloan"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qgpl3fbz7rhmloan
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

These were missing in 4.14-stable. Please apply to your queue.

80e46cf22ba0 ("btrfs: tree-checker: Enhance chunk checker to validate chunk profile")
005d67127fa9 ("btrfs: adjust return values of btrfs_inode_by_name")
6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference")

The second one in only needed to make the backporting of third easier.


--
Regards
Sudip

--qgpl3fbz7rhmloan
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-btrfs-tree-checker-Enhance-chunk-checker-to-validate.patch"

From 702a2b14382e0a063240d0bb7c93920d0130581e Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Wed, 13 Mar 2019 12:17:50 +0800
Subject: [PATCH 1/3] btrfs: tree-checker: Enhance chunk checker to validate chunk profile

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
[sudip: manually backport and use btrfs_err instead of chunk_err]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/volumes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3d92feff249a..3b3c65b7d0c1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6406,6 +6406,13 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 		return -EIO;
 	}
 
+	if (!is_power_of_2(type & BTRFS_BLOCK_GROUP_PROFILE_MASK) &&
+	    (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) != 0) {
+		btrfs_err(fs_info,
+		"invalid chunk profile flag: 0x%llx, expect 0 or 1 bit set",
+			  type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		return -EUCLEAN;
+	}
 	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
 		btrfs_err(fs_info, "missing chunk type flag: 0x%llx", type);
 		return -EIO;
-- 
2.11.0


--qgpl3fbz7rhmloan
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-btrfs-adjust-return-values-of-btrfs_inode_by_name.patch"

From 30009193fdb6573aca0024b5819145cf854ce84c Mon Sep 17 00:00:00 2001
From: Su Yue <suy.fnst@cn.fujitsu.com>
Date: Mon, 5 Mar 2018 17:13:37 +0800
Subject: [PATCH 2/3] btrfs: adjust return values of btrfs_inode_by_name

commit 005d67127fa9dfb3382f2c9e918feed7a243a7fe upstream

Previously, btrfs_inode_by_name() returned 0 which left caller to check
objectid of location even location if the type was invalid.

Let btrfs_inode_by_name() return -EUCLEAN if a corrupted location of a
dir entry is found.  Removal of label out_err also simplifies the
function.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ drop unlikely ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/inode.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e985e820724e..1459010cfde5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5585,7 +5585,8 @@ void btrfs_evict_inode(struct inode *inode)
 
 /*
  * this returns the key found in the dir entry in the location pointer.
- * If no dir entries were found, location->objectid is 0.
+ * If no dir entries were found, returns -ENOENT.
+ * If found a corrupted location in dir entry, returns -EUCLEAN.
  */
 static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 			       struct btrfs_key *location)
@@ -5603,27 +5604,27 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 
 	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(BTRFS_I(dir)),
 			name, namelen, 0);
-	if (IS_ERR(di))
+	if (!di) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
-
-	if (IS_ERR_OR_NULL(di))
-		goto out_err;
+		goto out;
+	}
 
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, location);
 	if (location->type != BTRFS_INODE_ITEM_KEY &&
 	    location->type != BTRFS_ROOT_ITEM_KEY) {
+		ret = -EUCLEAN;
 		btrfs_warn(root->fs_info,
 "%s gets something invalid in DIR_ITEM (name %s, directory ino %llu, location(%llu %u %llu))",
 			   __func__, name, btrfs_ino(BTRFS_I(dir)),
 			   location->objectid, location->type, location->offset);
-		goto out_err;
 	}
 out:
 	btrfs_free_path(path);
 	return ret;
-out_err:
-	location->objectid = 0;
-	goto out;
 }
 
 /*
@@ -5924,9 +5925,6 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	if (location.objectid == 0)
-		return ERR_PTR(-ENOENT);
-
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
 		return inode;
-- 
2.11.0


--qgpl3fbz7rhmloan
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0003-btrfs-inode-Verify-inode-mode-to-avoid-NULL-pointer-.patch"

From 88e4d5edb73b1012ebee0b552c08e0ef793cfeb1 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Wed, 13 Mar 2019 13:55:11 +0800
Subject: [PATCH 3/3] btrfs: inode: Verify inode mode to avoid NULL pointer dereference

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
[sudip: use original btrfs_inode_type()]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/inode.c             | 41 +++++++++++++++++++++++++++++++++--------
 fs/btrfs/tests/inode-tests.c |  1 +
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1459010cfde5..c5ae2f4a7ec3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5584,12 +5584,14 @@ void btrfs_evict_inode(struct inode *inode)
 }
 
 /*
- * this returns the key found in the dir entry in the location pointer.
+ * Return the key found in the dir entry in the location pointer, fill @type
+ * with BTRFS_FT_*, and return 0.
+ *
  * If no dir entries were found, returns -ENOENT.
  * If found a corrupted location in dir entry, returns -EUCLEAN.
  */
 static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
-			       struct btrfs_key *location)
+			       struct btrfs_key *location, u8 *type)
 {
 	const char *name = dentry->d_name.name;
 	int namelen = dentry->d_name.len;
@@ -5622,6 +5624,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 			   __func__, name, btrfs_ino(BTRFS_I(dir)),
 			   location->objectid, location->type, location->offset);
 	}
+	if (!ret)
+		*type = btrfs_dir_type(path->nodes[0], di);
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -5908,6 +5912,11 @@ static struct inode *new_simple_dir(struct super_block *s,
 	return inode;
 }
 
+static inline u8 btrfs_inode_type(struct inode *inode)
+{
+	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
+}
+
 struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(dir->i_sb);
@@ -5915,18 +5924,31 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
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
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
+		if (IS_ERR(inode))
+			return inode;
+
+		/* Do extra check against inode mode with di_type */
+		if (btrfs_inode_type(inode) != di_type) {
+			btrfs_crit(fs_info,
+"inode mode mismatch with dir: inode mode=0%o btrfs type=%u dir type=%u",
+				  inode->i_mode, btrfs_inode_type(inode),
+				  di_type);
+			iput(inode);
+			return ERR_PTR(-EUCLEAN);
+		}
 		return inode;
 	}
 
@@ -6544,11 +6566,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
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
@@ -7160,6 +7177,14 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	extent_start = found_key.offset;
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+		/* Only regular file could have regular/prealloc extent */
+		if (!S_ISREG(inode->vfs_inode.i_mode)) {
+			ret = -EUCLEAN;
+			btrfs_crit(fs_info,
+		"regular/prealloc extent found for non-regular inode %llu",
+				   btrfs_ino(inode));
+			goto out;
+		}
 		extent_end = extent_start +
 		       btrfs_file_extent_num_bytes(leaf, item);
 
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 8c91d03cc82d..94b139e92ff3 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -245,6 +245,7 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 		return ret;
 	}
 
+	inode->i_mode = S_IFREG;
 	BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
 	BTRFS_I(inode)->location.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	BTRFS_I(inode)->location.offset = 0;
-- 
2.11.0


--qgpl3fbz7rhmloan--
