Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC833B5AD8
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 11:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhF1JHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 05:07:22 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:53355 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhF1JHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 05:07:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1624871102; x=1656407102;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6uSPGUyNkDPsei8sdD5x6baQxsNXEDijVlYyArW2wxg=;
  b=q9KkT3hK3imv9MUk49tkB/xUa8kLEM41Lz7othYAy+H11AKqYlBAO0I5
   vpCVyP3cKetwoMSR6zxk0JIBnet/Svm5WEawwnOHa1PkRj+z2rbbUGBXt
   RUh+OwUvQTtA2Vp+ZLxDluUu+pJIkOeK6NR+OvWHZjTQNP8g8/7iuaCtT
   BXnwTeRfvoBdjOk8gSlg9rs23ffjfF65F3ymqPOzE1H5xtTnckkglZUTS
   xg/R1OV+Zi0LPOZMP8lfy3hhSYsGp3hua4oX8MJnBX3ChvRAN5Eous4p6
   2d12ldrhfpPt18NhTadQm9vpBln63eZd+HMezIqmWSROL4UzUSSplvqqq
   Q==;
IronPort-SDR: GU9QBf/VepvQncWN8lqquefqGwLajwqI9bAEoQflJx5vf5oRoEDlkEqYvayblbCe2yQJYT08UH
 QQDmmBPrrxfgv6D7QkajdCecZDxVvVUUzhiwCLU9mSisGBI1u0KEM5unuQSXV09m7VuaUH3yod
 t9I8sqC0IybV3jY9Q+Y7xTG5NvJqiahiWHAKuv7bcUpXGMXOcGR4MmmTutanY4lDCKd/zEQlXN
 rUawgo+v+gXYhU78ctFu9IveOQvugMdc7VQS/zmoHIhG7+2KcoOmq9v8pKYJYumiXEEWn/hiy7
 Yg0=
X-IronPort-AV: E=Sophos;i="5.83,305,1616428800"; 
   d="scan'208";a="276870746"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jun 2021 17:05:01 +0800
IronPort-SDR: Rg6WV2cpAtNtIfrtV9YLgjGsRLzxuHdighyIxmZXlF+FWd0ngX4RQ3f9FQq1+dPzB3eQYqy+We
 0ubbrvuWa+ICNicbXTx/5i36p2u4IYQug0PEMKke6d1VnvLYQ7p6U1XC+LN4ZTqMlLzVEsRL+e
 Rtgl3XGH9xzfMHN/ANcqkLaridMI852ySt6BiMayKVFix/YiNTjBgTbsLOMPGggI966JfttpIH
 0jn0r4HwvhGKIB8XqcGZK+XgrLPApU1XltNkfuYP/X0Y2+HtDYPJm1D14/W7M/w4dymhrAeeCb
 3WEklHu5fli6qAT6KRLUfaNK
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 01:43:25 -0700
IronPort-SDR: XYrBNVs+a+htwD77tnRPOf+tIXsN+BsuIscl6FyNLdkYofq403yimpus1cUbqQp04znnk6VTu2
 7hkedBYLuoU1p2/GXQ4C5nvyScxc5CkmYIFza061/r33bz2MPFXRbuyMcz2Me2Ya7gicR/Uda+
 jmrG6Q3PTlGpDvfCB7r8KF4H/6tFcQOvlz1U4i6f+1I5UO8OZkE3bdKdbmW72KQS3E4hvO88HD
 mdwPlsxYX1kYYJPDz01/Jp5mMro7GNO8QBuG4k6Or97L3Cfjr6cmkXcNJY2jePcZ/96Mf6RY+c
 6FU=
WDCIronportException: Internal
Received: from jpf010022.ad.shared (HELO naota-xeon.wdc.com) ([10.225.48.131])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Jun 2021 02:04:55 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: properly split extent_map for REQ_OP_ZONE_APPEND
Date:   Mon, 28 Jun 2021 17:57:28 +0900
Message-Id: <20210628085728.2813793-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Damien reported a test failure with btrfs/209. The test itself ran fine,
but the fsck run afterwards reported a corrupted filesystem.

The filesystem corruption happens because we're splitting an extent and
then writing the extent twice. We have to split the extent though, because
we're creating too large extents for a REQ_OP_ZONE_APPEND operation.

When dumping the extent tree, we can see two EXTENT_ITEMs at the same
start address but different lengths.

$ btrfs inspect dump-tree /dev/nullb1 -t extent
...
   item 19 key (269484032 EXTENT_ITEM 126976) itemoff 15470 itemsize 53
           refs 1 gen 7 flags DATA
           extent data backref root FS_TREE objectid 257 offset 786432 count 1
   item 20 key (269484032 EXTENT_ITEM 262144) itemoff 15417 itemsize 53
           refs 1 gen 7 flags DATA
           extent data backref root FS_TREE objectid 257 offset 786432 count 1

The duplicated EXTENT_ITEMs originally come from wrongly split extent_map in
extract_ordered_extent(). Since extract_ordered_extent() uses
create_io_em() to split an existing extent_map, we will have
split->orig_start != split->start. Then, it will be logged with non-zero
"extent data offset". Finally, the logged entries are replayed into
a duplicated EXTENT_ITEM.

Introduce and use proper splitting function for extent_map. The function is
intended to be simple and specific usage for extract_ordered_extent() e.g.
not supporting compression case (we do not allow splitting compressed
extent_map anyway).

Fixes: d22002fd37bd ("btrfs: zoned: split ordered extent when bio is sent")
Cc: stable@vger.kernel.org # 5.12+
Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/inode.c | 151 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 122 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6eb20987351..79cdcaeab8de 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2271,13 +2271,131 @@ static blk_status_t btrfs_submit_bio_start(struct inode *inode, struct bio *bio,
 	return btrfs_csum_one_bio(BTRFS_I(inode), bio, 0, 0);
 }
 
+/*
+ * split_zoned_em - split an extent_map at [start, start+len]
+ *
+ * This function is intended to be used only for extract_ordered_extent().
+ */
+static int split_zoned_em(struct btrfs_inode *inode, u64 start, u64 len,
+			  u64 pre, u64 post)
+{
+	struct extent_map_tree *em_tree = &inode->extent_tree;
+	struct extent_map *em;
+	struct extent_map *split_pre = NULL;
+	struct extent_map *split_mid = NULL;
+	struct extent_map *split_post = NULL;
+	int ret = 0;
+	int modified;
+	unsigned long flags;
+
+	/* Sanity check */
+	if (pre == 0 && post == 0)
+		return 0;
+
+	split_pre = alloc_extent_map();
+	if (pre)
+		split_mid = alloc_extent_map();
+	if (post)
+		split_post = alloc_extent_map();
+	if (!split_pre || (pre && !split_mid) || (post && !split_post)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ASSERT(pre + post < len);
+
+	lock_extent(&inode->io_tree, start, start + len - 1);
+	write_lock(&em_tree->lock);
+	em = lookup_extent_mapping(em_tree, start, len);
+	if (!em) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	ASSERT(em->len == len);
+	ASSERT(!test_bit(EXTENT_FLAG_COMPRESSED, &em->flags));
+	ASSERT(em->block_start < EXTENT_MAP_LAST_BYTE);
+
+	flags = em->flags;
+	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
+	clear_bit(EXTENT_FLAG_LOGGING, &flags);
+	modified = !list_empty(&em->list);
+
+	/*
+	 * First, replace the em with a new extent_map starting from
+	 * em->start
+	 */
+
+	split_pre->start = em->start;
+	split_pre->len = pre ? pre : (em->len - post);
+	split_pre->orig_start = split_pre->start;
+	split_pre->block_start = em->block_start;
+	split_pre->block_len = split_pre->len;
+	split_pre->orig_block_len = split_pre->block_len;
+	split_pre->ram_bytes = split_pre->len;
+	split_pre->flags = flags;
+	split_pre->compress_type = em->compress_type;
+	split_pre->generation = em->generation;
+
+	replace_extent_mapping(em_tree, em, split_pre, modified);
+
+	/*
+	 * Now we only have an extent_map at:
+	 *     [em->start, em->start + pre] if pre != 0
+	 *     [em->start, em->start + em->len - post] if pre == 0
+	 */
+
+	if (pre) {
+		/* Insert the middle extent_map */
+		split_mid->start = em->start + pre;
+		split_mid->len = em->len - pre - post;
+		split_mid->orig_start = split_mid->start;
+		split_mid->block_start = em->block_start + pre;
+		split_mid->block_len = split_mid->len;
+		split_mid->orig_block_len = split_mid->block_len;
+		split_mid->ram_bytes = split_mid->len;
+		split_mid->flags = flags;
+		split_mid->compress_type = em->compress_type;
+		split_mid->generation = em->generation;
+		add_extent_mapping(em_tree, split_mid, modified);
+	}
+
+	if (post) {
+		split_post->start = em->start + em->len - post;
+		split_post->len = post;
+		split_post->orig_start = split_post->start;
+		split_post->block_start = em->block_start + em->len - post;
+		split_post->block_len = split_post->len;
+		split_post->orig_block_len = split_post->block_len;
+		split_post->ram_bytes = split_post->len;
+		split_post->flags = flags;
+		split_post->compress_type = em->compress_type;
+		split_post->generation = em->generation;
+		add_extent_mapping(em_tree, split_post, modified);
+	}
+
+	/* once for us */
+	free_extent_map(em);
+	/* once for the tree */
+	free_extent_map(em);
+
+out_unlock:
+	write_unlock(&em_tree->lock);
+	unlock_extent(&inode->io_tree, start, start + len - 1);
+out:
+	free_extent_map(split_pre);
+	free_extent_map(split_mid);
+	free_extent_map(split_post);
+
+	return ret;
+}
+
 static blk_status_t extract_ordered_extent(struct btrfs_inode *inode,
 					   struct bio *bio, loff_t file_offset)
 {
 	struct btrfs_ordered_extent *ordered;
-	struct extent_map *em = NULL, *em_new = NULL;
-	struct extent_map_tree *em_tree = &inode->extent_tree;
 	u64 start = (u64)bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	u64 file_len;
 	u64 len = bio->bi_iter.bi_size;
 	u64 end = start + len;
 	u64 ordered_end;
@@ -2317,41 +2435,16 @@ static blk_status_t extract_ordered_extent(struct btrfs_inode *inode,
 		goto out;
 	}
 
+	file_len = ordered->num_bytes;
 	pre = start - ordered->disk_bytenr;
 	post = ordered_end - end;
 
 	ret = btrfs_split_ordered_extent(ordered, pre, post);
 	if (ret)
 		goto out;
-
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, ordered->file_offset, len);
-	if (!em) {
-		read_unlock(&em_tree->lock);
-		ret = -EIO;
-		goto out;
-	}
-	read_unlock(&em_tree->lock);
-
-	ASSERT(!test_bit(EXTENT_FLAG_COMPRESSED, &em->flags));
-	/*
-	 * We cannot reuse em_new here but have to create a new one, as
-	 * unpin_extent_cache() expects the start of the extent map to be the
-	 * logical offset of the file, which does not hold true anymore after
-	 * splitting.
-	 */
-	em_new = create_io_em(inode, em->start + pre, len,
-			      em->start + pre, em->block_start + pre, len,
-			      len, len, BTRFS_COMPRESS_NONE,
-			      BTRFS_ORDERED_REGULAR);
-	if (IS_ERR(em_new)) {
-		ret = PTR_ERR(em_new);
-		goto out;
-	}
-	free_extent_map(em_new);
+	ret = split_zoned_em(inode, file_offset, file_len, pre, post);
 
 out:
-	free_extent_map(em);
 	btrfs_put_ordered_extent(ordered);
 
 	return errno_to_blk_status(ret);
-- 
2.32.0

