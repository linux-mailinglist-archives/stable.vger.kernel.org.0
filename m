Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE43E2541
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243728AbhHFISu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239010AbhHFIRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:17:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FCA96103B;
        Fri,  6 Aug 2021 08:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237853;
        bh=HjcaOTKXluZw1spsJ0FrYE389wz+kf36cJ4h/EnsdJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvKMHuBjxDhoRiyIBM8roAAcT1mYEOca288jdkjjSrCNtiSiXg+9X2Y/BoI5eqnEX
         PxK3ANhcEM1csrKlVVvIZM7RZa5Hr/Hx7OOJAZ68HCjKGLjf7a89o6KEJTBJjcNzEp
         jALlLmlf6fOCI2AfoNrjpLRSJN/9zoD3NcODn20w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/23] btrfs: delete duplicated words + other fixes in comments
Date:   Fri,  6 Aug 2021 10:16:33 +0200
Message-Id: <20210806081112.155317492@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 260db43cd2f556677f6ae818ba09f997eed81004 ]

Delete repeated words in fs/btrfs/.
{to, the, a, and old}
and change "into 2 part" to "into 2 parts".

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c      | 2 +-
 fs/btrfs/ctree.c            | 2 +-
 fs/btrfs/disk-io.c          | 2 +-
 fs/btrfs/extent_io.c        | 2 +-
 fs/btrfs/free-space-cache.c | 2 +-
 fs/btrfs/qgroup.c           | 2 +-
 fs/btrfs/tree-log.c         | 4 ++--
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a352c1704042..e98d6ea35ea8 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2637,7 +2637,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 			 * finished yet (no block group item in the extent tree
 			 * yet, etc). If this is the case, wait for all free
 			 * space endio workers to finish and retry. This is a
-			 * a very rare case so no need for a more efficient and
+			 * very rare case so no need for a more efficient and
 			 * complex approach.
 			 */
 			if (ret == -ENOENT) {
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ab69e3563b12..dac30b00d14b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5232,7 +5232,7 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 			slot--;
 		/*
 		 * check this node pointer against the min_trans parameters.
-		 * If it is too old, old, skip to the next one.
+		 * If it is too old, skip to the next one.
 		 */
 		while (slot < nritems) {
 			u64 gen;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e6aa94a583e9..1d28333bb798 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2816,7 +2816,7 @@ int open_ctree(struct super_block *sb,
 	}
 
 	/*
-	 * Verify the type first, if that or the the checksum value are
+	 * Verify the type first, if that or the checksum value are
 	 * corrupted, we'll find out
 	 */
 	csum_type = btrfs_super_csum_type((struct btrfs_super_block *)bh->b_data);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index eca3abc1a7cd..9108a73423f7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3152,7 +3152,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 
 		/*
 		 * If we have a file range that points to a compressed extent
-		 * and it's followed by a consecutive file range that points to
+		 * and it's followed by a consecutive file range that points
 		 * to the same compressed extent (possibly with a different
 		 * offset and/or length, so it either points to the whole extent
 		 * or only part of it), we must make sure we do not submit a
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 23f59d463e24..d2d32fed8f2e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1339,7 +1339,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 	/*
 	 * at this point the pages are under IO and we're happy,
-	 * The caller is responsible for waiting on them and updating the
+	 * The caller is responsible for waiting on them and updating
 	 * the cache and the inode
 	 */
 	io_ctl->entries = entries;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cd8e81c02f63..837bd5e29c8a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2262,7 +2262,7 @@ static int qgroup_update_refcnt(struct btrfs_fs_info *fs_info,
  * Update qgroup rfer/excl counters.
  * Rfer update is easy, codes can explain themselves.
  *
- * Excl update is tricky, the update is split into 2 part.
+ * Excl update is tricky, the update is split into 2 parts.
  * Part 1: Possible exclusive <-> sharing detect:
  *	|	A	|	!A	|
  *  -------------------------------------
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index afc6731bb692..dcbdd0ebea83 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4923,7 +4923,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 		 * Check the inode's logged_trans only instead of
 		 * btrfs_inode_in_log(). This is because the last_log_commit of
 		 * the inode is not updated when we only log that it exists and
-		 * and it has the full sync bit set (see btrfs_log_inode()).
+		 * it has the full sync bit set (see btrfs_log_inode()).
 		 */
 		if (BTRFS_I(inode)->logged_trans == trans->transid) {
 			spin_unlock(&BTRFS_I(inode)->lock);
@@ -6426,7 +6426,7 @@ void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
  *            committed by the caller, and BTRFS_DONT_NEED_TRANS_COMMIT
  *            otherwise.
  * When false: returns BTRFS_DONT_NEED_LOG_SYNC if the caller does not need to
- *             to sync the log, BTRFS_NEED_LOG_SYNC if it needs to sync the log,
+ *             sync the log, BTRFS_NEED_LOG_SYNC if it needs to sync the log,
  *             or BTRFS_NEED_TRANS_COMMIT if the transaction needs to be
  *             committed (without attempting to sync the log).
  */
-- 
2.30.2



