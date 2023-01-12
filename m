Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322236677D2
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbjALOtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240041AbjALOsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:48:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1A125F8
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:35:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CA1F62031
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1531CC433EF;
        Thu, 12 Jan 2023 14:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534154;
        bh=OjFFpLxrD3J4lgMqPzOQ4GVv+610Vc3314ZIhnFI8t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEDeLpGFlhmFpRpb4mxKaj7UAmgC/KX15i4nFHVaX0Ft9JyLfEBdaHfqUrswKRkXi
         6DaYsuNjjqcYpJRj5OheZSXASIibWaxKFrxoIP4NczS+6pq9G561GxTBpHmD4vjokG
         cj+dcHhtvastiRcbuBHPcsczV15gutK8ODVdovFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 714/783] ext4: fix various seppling typos
Date:   Thu, 12 Jan 2023 14:57:10 +0100
Message-Id: <20230112135557.470757751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

[ Upstream commit 3088e5a5153cda27ec26461e5edf2821e15e802c ]

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Link: https://lore.kernel.org/r/cover.1616840203.git.unixbhaskar@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/fast_commit.c | 2 +-
 fs/ext4/indirect.c    | 2 +-
 fs/ext4/inline.c      | 2 +-
 fs/ext4/inode.c       | 2 +-
 fs/ext4/mballoc.h     | 2 +-
 fs/ext4/migrate.c     | 6 +++---
 fs/ext4/namei.c       | 2 +-
 fs/ext4/xattr.c       | 2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 41dcf21558c4..3b2d6106a703 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -66,7 +66,7 @@
  * Fast Commit Ineligibility
  * -------------------------
  * Not all operations are supported by fast commits today (e.g extended
- * attributes). Fast commit ineligiblity is marked by calling one of the
+ * attributes). Fast commit ineligibility is marked by calling one of the
  * two following functions:
  *
  * - ext4_fc_mark_ineligible(): This makes next fast commit operation to fall
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index b7d130f4b5e4..237983cd8cdc 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -712,7 +712,7 @@ static int ext4_ind_trunc_restart_fn(handle_t *handle, struct inode *inode,
 
 /*
  * Truncate transactions can be complex and absolutely huge.  So we need to
- * be able to restart the transaction at a conventient checkpoint to make
+ * be able to restart the transaction at a convenient checkpoint to make
  * sure we don't overflow the journal.
  *
  * Try to extend this transaction for the purposes of truncation.  If
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 88bd1d1cca23..77377befbb1c 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -799,7 +799,7 @@ ext4_journalled_write_inline_data(struct inode *inode,
  *    clear the inode state safely.
  * 2. The inode has inline data, then we need to read the data, make it
  *    update and dirty so that ext4_da_writepages can handle it. We don't
- *    need to start the journal since the file's metatdata isn't changed now.
+ *    need to start the journal since the file's metadata isn't changed now.
  */
 static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
 						 struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d7dbe1eb9da0..2d3004b3fc56 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3885,7 +3885,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
  * starting from file offset 'from'.  The range to be zero'd must
  * be contained with in one block.  If the specified range exceeds
  * the end of the block it will be shortened to end of the block
- * that cooresponds to 'from'
+ * that corresponds to 'from'
  */
 static int ext4_block_zero_page_range(handle_t *handle,
 		struct address_space *mapping, loff_t from, loff_t length)
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index e75b4749aa1c..7be6288e48ec 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -59,7 +59,7 @@
  * by the stream allocator, which purpose is to pack requests
  * as close each to other as possible to produce smooth I/O traffic
  * We use locality group prealloc space for stream request.
- * We can tune the same via /proc/fs/ext4/<parition>/stream_req
+ * We can tune the same via /proc/fs/ext4/<partition>/stream_req
  */
 #define MB_DEFAULT_STREAM_THRESHOLD	16	/* 64K */
 
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 4bfe2252d9a4..b0ea646454ac 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -32,7 +32,7 @@ static int finish_range(handle_t *handle, struct inode *inode,
 	newext.ee_block = cpu_to_le32(lb->first_block);
 	newext.ee_len   = cpu_to_le16(lb->last_block - lb->first_block + 1);
 	ext4_ext_store_pblock(&newext, lb->first_pblock);
-	/* Locking only for convinience since we are operating on temp inode */
+	/* Locking only for convenience since we are operating on temp inode */
 	down_write(&EXT4_I(inode)->i_data_sem);
 	path = ext4_find_extent(inode, lb->first_block, NULL, 0);
 	if (IS_ERR(path)) {
@@ -43,8 +43,8 @@ static int finish_range(handle_t *handle, struct inode *inode,
 
 	/*
 	 * Calculate the credit needed to inserting this extent
-	 * Since we are doing this in loop we may accumalate extra
-	 * credit. But below we try to not accumalate too much
+	 * Since we are doing this in loop we may accumulate extra
+	 * credit. But below we try to not accumulate too much
 	 * of them by restarting the journal.
 	 */
 	needed = ext4_ext_calc_credits_for_single_extent(inode,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c17d5f399f9e..ce4962bb62bc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -995,7 +995,7 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 	 * If the hash is 1, then continue only if the next page has a
 	 * continuation hash of any value.  This is used for readdir
 	 * handling.  Otherwise, check to see if the hash matches the
-	 * desired contiuation hash.  If it doesn't, return since
+	 * desired continuation hash.  If it doesn't, return since
 	 * there's no point to read in the successive index pages.
 	 */
 	bhash = dx_get_hash(p->at);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 795ef72f0d3c..74d045b426dd 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1617,7 +1617,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 		 * If storing the value in an external inode is an option,
 		 * reserve space for xattr entries/names in the external
 		 * attribute block so that a long value does not occupy the
-		 * whole space and prevent futher entries being added.
+		 * whole space and prevent further entries being added.
 		 */
 		if (ext4_has_feature_ea_inode(inode->i_sb) &&
 		    new_size && is_block &&
-- 
2.35.1



