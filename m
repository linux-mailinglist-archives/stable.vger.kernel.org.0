Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A5F2F0E96
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbhAKI5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:57:12 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:33005 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727841AbhAKI5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:57:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2D64025D5;
        Mon, 11 Jan 2021 03:56:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:56:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8OhSQS
        P6yG8DwxKv+eIlZcnU9ZB0oBgB7/LUl4AsPU0=; b=ArEPwvtKrQWQVgTg6C/+z2
        L20HX+TfqiZIIH3e6OpRNhvmlgba8stWarYtq4ApNlP/B8csoOLbCgKvd2uGFZ6U
        wafLncKYzoaJNemgep7/GGoCE0VZxdXyYWqDveudseHjy89YC5yyRfoQlnWkojsU
        /1kmQmOaadniHLq76jdY317Ht1VmwycHRyEIAT+w4Xr82lkT8Jy4LEyh4OcxPQcR
        M1T65biUJy4hNyOAgN/TZI122qeKnS/XWoOSMwD+KPWvzR9tSq6J5VcMatqGjArP
        UhmyLxOeWiB83io5syOatjXzwM3tnxfu+ZfNtWok/8hQWSSmUJfNVt+7cyqEgyUw
        ==
X-ME-Sender: <xms:uRL8X3PqMvyj_E0jsZTT_o3qkUUWwaoUIqyLJnVpxhnL92uPu_K_tg>
    <xme:uRL8Xx9BS0QgLh4QSqkfL2Eh1BfGfJVDo89GuINbzJCKQpP2bOgAKggZXgPE_XDWZ
    7ihTWgeYSOWRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeitdffteffuddvgfekvefgtdeikeeuudffhefffe
    dtgedvjeeuvddugeduledtieenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:uRL8X2TsgJKVFP5kkv66BlCQkz7WHK8yrnSB9D9ivZ4FOYm9RXFTHQ>
    <xmx:uRL8X7vqWR4fOWfqOYOyQEl8xfOqMgAuSvJv12kHGH5EpwzoEtyZpw>
    <xmx:uRL8X_e31H_dGQ5ikbUT0mHjWGsYtMbnSni4Bso8GlbM5cfDUFV0HQ>
    <xmx:uRL8X3Fyv-97ffTEWDPL5Cf8eX6vS4MzbAE7_pRbiFi1Nf0eSKEYUwWrRX0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7823224005C;
        Mon, 11 Jan 2021 03:56:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: correctly calculate item size used when item key" failed to apply to 4.19-stable tree
To:     ethanwu@synology.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:57:38 +0100
Message-ID: <161035545812159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9a664971569daf68254928149f580b4f5856d274 Mon Sep 17 00:00:00 2001
From: ethanwu <ethanwu@synology.com>
Date: Tue, 1 Dec 2020 17:25:12 +0800
Subject: [PATCH] btrfs: correctly calculate item size used when item key
 collision happens

Item key collision is allowed for some item types, like dir item and
inode refs, but the overall item size is limited by the nodesize.

item size(ins_len) passed from btrfs_insert_empty_items to
btrfs_search_slot already contains size of btrfs_item.

When btrfs_search_slot reaches leaf, we'll see if we need to split leaf.
The check incorrectly reports that split leaf is required, because
it treats the space required by the newly inserted item as
btrfs_item + item data. But in item key collision case, only item data
is actually needed, the newly inserted item could merge into the existing
one. No new btrfs_item will be inserted.

And split_leaf return EOVERFLOW from following code:

  if (extend && data_size + btrfs_item_size_nr(l, slot) +
      sizeof(struct btrfs_item) > BTRFS_LEAF_DATA_SIZE(fs_info))
      return -EOVERFLOW;

In most cases, when callers receive EOVERFLOW, they either return
this error or handle in different ways. For example, in normal dir item
creation the userspace will get errno EOVERFLOW; in inode ref case
INODE_EXTREF is used instead.

However, this is not the case for rename. To avoid the unrecoverable
situation in rename, btrfs_check_dir_item_collision is called in
early phase of rename. In this function, when item key collision is
detected leaf space is checked:

  data_size = sizeof(*di) + name_len;
  if (data_size + btrfs_item_size_nr(leaf, slot) +
      sizeof(struct btrfs_item) > BTRFS_LEAF_DATA_SIZE(root->fs_info))

the sizeof(struct btrfs_item) + btrfs_item_size_nr(leaf, slot) here
refers to existing item size, the condition here correctly calculates
the needed size for collision case rather than the wrong case above.

The consequence of inconsistent condition check between
btrfs_check_dir_item_collision and btrfs_search_slot when item key
collision happens is that we might pass check here but fail
later at btrfs_search_slot. Rename fails and volume is forced readonly

  [436149.586170] ------------[ cut here ]------------
  [436149.586173] BTRFS: Transaction aborted (error -75)
  [436149.586196] WARNING: CPU: 0 PID: 16733 at fs/btrfs/inode.c:9870 btrfs_rename2+0x1938/0x1b70 [btrfs]
  [436149.586227] CPU: 0 PID: 16733 Comm: python Tainted: G      D           4.18.0-rc5+ #1
  [436149.586228] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/05/2016
  [436149.586238] RIP: 0010:btrfs_rename2+0x1938/0x1b70 [btrfs]
  [436149.586254] RSP: 0018:ffffa327043a7ce0 EFLAGS: 00010286
  [436149.586255] RAX: 0000000000000000 RBX: ffff8d8a17d13340 RCX: 0000000000000006
  [436149.586256] RDX: 0000000000000007 RSI: 0000000000000096 RDI: ffff8d8a7fc164b0
  [436149.586257] RBP: ffffa327043a7da0 R08: 0000000000000560 R09: 7265282064657472
  [436149.586258] R10: 0000000000000000 R11: 6361736e61725420 R12: ffff8d8a0d4c8b08
  [436149.586258] R13: ffff8d8a17d13340 R14: ffff8d8a33e0a540 R15: 00000000000001fe
  [436149.586260] FS:  00007fa313933740(0000) GS:ffff8d8a7fc00000(0000) knlGS:0000000000000000
  [436149.586261] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [436149.586262] CR2: 000055d8d9c9a720 CR3: 000000007aae0003 CR4: 00000000003606f0
  [436149.586295] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [436149.586296] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [436149.586296] Call Trace:
  [436149.586311]  vfs_rename+0x383/0x920
  [436149.586313]  ? vfs_rename+0x383/0x920
  [436149.586315]  do_renameat2+0x4ca/0x590
  [436149.586317]  __x64_sys_rename+0x20/0x30
  [436149.586324]  do_syscall_64+0x5a/0x120
  [436149.586330]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [436149.586332] RIP: 0033:0x7fa3133b1d37
  [436149.586348] RSP: 002b:00007fffd3e43908 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
  [436149.586349] RAX: ffffffffffffffda RBX: 00007fa3133b1d30 RCX: 00007fa3133b1d37
  [436149.586350] RDX: 000055d8da06b5e0 RSI: 000055d8da225d60 RDI: 000055d8da2c4da0
  [436149.586351] RBP: 000055d8da2252f0 R08: 00007fa313782000 R09: 00000000000177e0
  [436149.586351] R10: 000055d8da010680 R11: 0000000000000246 R12: 00007fa313840b00

Thanks to Hans van Kranenburg for information about crc32 hash collision
tools, I was able to reproduce the dir item collision with following
python script.
https://github.com/wutzuchieh/misc_tools/blob/master/crc32_forge.py Run
it under a btrfs volume will trigger the abort transaction.  It simply
creates files and rename them to forged names that leads to
hash collision.

There are two ways to fix this. One is to simply revert the patch
878f2d2cb355 ("Btrfs: fix max dir item size calculation") to make the
condition consistent although that patch is correct about the size.

The other way is to handle the leaf space check correctly when
collision happens. I prefer the second one since it correct leaf
space check in collision case. This fix will not account
sizeof(struct btrfs_item) when the item already exists.
There are two places where ins_len doesn't contain
sizeof(struct btrfs_item), however.

  1. extent-tree.c: lookup_inline_extent_backref
  2. file-item.c: btrfs_csum_file_blocks

to make the logic of btrfs_search_slot more clear, we add a flag
search_for_extension in btrfs_path.

This flag indicates that ins_len passed to btrfs_search_slot doesn't
contain sizeof(struct btrfs_item). When key exists, btrfs_search_slot
will use the actual size needed to calculate the required leaf space.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: ethanwu <ethanwu@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 07810891e204..cc89b63d65a4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2555,8 +2555,14 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
  * @p:		Holds all btree nodes along the search path
  * @root:	The root node of the tree
  * @key:	The key we are looking for
- * @ins_len:	Indicates purpose of search, for inserts it is 1, for
- *		deletions it's -1. 0 for plain searches
+ * @ins_len:	Indicates purpose of search:
+ *              >0  for inserts it's size of item inserted (*)
+ *              <0  for deletions
+ *               0  for plain searches, not modifying the tree
+ *
+ *              (*) If size of item inserted doesn't include
+ *              sizeof(struct btrfs_item), then p->search_for_extension must
+ *              be set.
  * @cow:	boolean should CoW operations be performed. Must always be 1
  *		when modifying the tree.
  *
@@ -2717,6 +2723,20 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 		if (level == 0) {
 			p->slots[level] = slot;
+			/*
+			 * Item key already exists. In this case, if we are
+			 * allowed to insert the item (for example, in dir_item
+			 * case, item key collision is allowed), it will be
+			 * merged with the original item. Only the item size
+			 * grows, no new btrfs item will be added. If
+			 * search_for_extension is not set, ins_len already
+			 * accounts the size btrfs_item, deduct it here so leaf
+			 * space check will be correct.
+			 */
+			if (ret == 0 && ins_len > 0 && !p->search_for_extension) {
+				ASSERT(ins_len >= sizeof(struct btrfs_item));
+				ins_len -= sizeof(struct btrfs_item);
+			}
 			if (ins_len > 0 &&
 			    btrfs_leaf_free_space(b) < ins_len) {
 				if (write_lock_level < 1) {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2674f24cf2e0..3935d297d198 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -368,6 +368,12 @@ struct btrfs_path {
 	unsigned int search_commit_root:1;
 	unsigned int need_commit_sem:1;
 	unsigned int skip_release_on_error:1;
+	/*
+	 * Indicate that new item (btrfs_search_slot) is extending already
+	 * existing item and ins_len contains only the data size and not item
+	 * header (ie. sizeof(struct btrfs_item) is not included).
+	 */
+	unsigned int search_for_extension:1;
 };
 #define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info) >> 4) - \
 					sizeof(struct btrfs_item))
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 56ea380f5a17..d79b8369e6aa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -844,6 +844,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	want = extent_ref_type(parent, owner);
 	if (insert) {
 		extra_size = btrfs_extent_inline_ref_size(want);
+		path->search_for_extension = 1;
 		path->keep_locks = 1;
 	} else
 		extra_size = -1;
@@ -996,6 +997,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 out:
 	if (insert) {
 		path->keep_locks = 0;
+		path->search_for_extension = 0;
 		btrfs_unlock_up_safe(path, 1);
 	}
 	return err;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 1545c22ef280..6ccfc019ad90 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -1016,8 +1016,10 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_release_path(path);
+	path->search_for_extension = 1;
 	ret = btrfs_search_slot(trans, root, &file_key, path,
 				csum_size, 1);
+	path->search_for_extension = 0;
 	if (ret < 0)
 		goto out;
 

