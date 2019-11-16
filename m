Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD20DFF1BD
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbfKPPrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:47:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbfKPPrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:45 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4A7214DE;
        Sat, 16 Nov 2019 15:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919264;
        bh=ruhtO+Dneox2Nh1Nq6tH35cjmE/6vNUwLM6D2ixRwe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EB0yzlTe/q1y5I3ZwmfMBp8qNDGwZ1yOpvb+QV7yLzeAEpOun3y2OGAk6G6h606Qx
         2gsACX0UnmPSotcH2GY03+ctHoDLkprtVXMhylqf3ZLtljBDQkBkGbQJw1MHBzRekl
         QadxDP2a7aFJ53SQEBij6f7o0OG4uJ9Nx0c0IOYM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Bo <bo.liu@linux.alibaba.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 016/150] Btrfs: fix alignment in declaration and prototype of btrfs_get_extent
Date:   Sat, 16 Nov 2019 10:45:14 -0500
Message-Id: <20191116154729.9573-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Bo <bo.liu@linux.alibaba.com>

[ Upstream commit de2c6615dcddf2af868c5cbd1db2e9e73b4beb58 ]

This fixes btrfs_get_extent to be consistent with our existing
declaration style.

Note: For the record, indentation styles that are accepted are both,
aligning under the opening ( and tab or double tab indentation on the
next line.  Preferrably not spliting the type or long expressions in the
argument lists.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
[ add note ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h | 4 ++--
 fs/btrfs/inode.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 588760c49fe28..087a1e842c508 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3198,8 +3198,8 @@ long btrfs_ioctl_trans_end(struct file *file);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
-		struct page *page, size_t pg_offset,
-		u64 start, u64 end, int create);
+				    struct page *page, size_t pg_offset,
+				    u64 start, u64 end, int create);
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct inode *inode);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ddc1d1d1a29f2..33bf60910b8d7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7066,9 +7066,9 @@ static noinline int uncompress_inline(struct btrfs_path *path,
  * This also copies inline extents directly into the page.
  */
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
-		struct page *page,
-	    size_t pg_offset, u64 start, u64 len,
-		int create)
+				    struct page *page,
+				    size_t pg_offset, u64 start, u64 len,
+				    int create)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	int ret;
-- 
2.20.1

