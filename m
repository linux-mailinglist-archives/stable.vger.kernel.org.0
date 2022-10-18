Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C07601EE6
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiJRAOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiJRAON (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:14:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0111208D;
        Mon, 17 Oct 2022 17:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 784A5B81BFA;
        Tue, 18 Oct 2022 00:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735B0C433C1;
        Tue, 18 Oct 2022 00:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051770;
        bh=TV8O8F2fiRXD3tspAeChCoMnXeRn1pA6ztp/kg0kjOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtU+zZbOG4OueDLMM7SPXo8Gv/c0ziCrYmpEh52IH/MKhFtLOpnjKzBFt08inQvsE
         yWF4+Kyl2PiOceLs4kGNO01IHwg2018l/NhUGQYRkGi8DavzjiRQFxIfYUMn2z8jdt
         74p33aNUwb+9UL3cCMovq2weC+To1cjLS/dY91ghjclIFjgToFzGgeLNxC9zolzsFD
         FTw7Nm/GAbnvodelgtusnHpbPTAwvswotEmGvIBlsng+CkjvZGB77NJLI90FH2NTw5
         gVpo2ALdD2tQ2F4x80MZNGHZ8Wvcxw2TLSp0sAnpl/ftGUYudQ11l+fFNbatu3n6A+
         rgMCIvsOLvAAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.19 23/29] f2fs: code clean and fix a type error
Date:   Mon, 17 Oct 2022 20:08:32 -0400
Message-Id: <20221018000839.2730954-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000839.2730954-1-sashal@kernel.org>
References: <20221018000839.2730954-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 544b53dadc208278fd0796f2c22ea24a3fe16564 ]

ERROR: code indent should use tabs where possible
ERROR: spaces required around that ':'
ERROR: incorrect tab

Found serveral code type errors when review the code and fix it.
There is no function change.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c         | 2 +-
 fs/f2fs/debug.c        | 2 +-
 fs/f2fs/extent_cache.c | 2 +-
 fs/f2fs/file.c         | 2 +-
 fs/f2fs/node.c         | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9157d09dde6d..cb8260b1cb4e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -707,7 +707,7 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
 
 	inc_page_count(fio->sbi, is_read_io(fio->op) ?
-			__read_io_type(page): WB_DATA_TYPE(fio->page));
+			__read_io_type(page) : WB_DATA_TYPE(fio->page));
 
 	__submit_bio(fio->sbi, bio, fio->type);
 	return 0;
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index c92625ef16d0..9bac409d31bd 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -347,7 +347,7 @@ static int stat_show(struct seq_file *s, void *v)
 
 		seq_printf(s, "\n=====[ partition info(%pg). #%d, %s, CP: %s]=====\n",
 			si->sbi->sb->s_bdev, i++,
-			f2fs_readonly(si->sbi->sb) ? "RO": "RW",
+			f2fs_readonly(si->sbi->sb) ? "RO" : "RW",
 			is_set_ckpt_flags(si->sbi, CP_DISABLED_FLAG) ?
 			"Disabled" : (f2fs_cp_error(si->sbi) ? "Error" : "Good"));
 		if (si->sbi->s_flag) {
diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 866e72b29bd5..d6b4a1c8ed2f 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -583,7 +583,7 @@ static void f2fs_update_extent_tree_range(struct inode *inode,
 		org_end = dei.fofs + dei.len;
 		f2fs_bug_on(sbi, pos >= org_end);
 
-		if (pos > dei.fofs &&	pos - dei.fofs >= F2FS_MIN_EXTENT_LEN) {
+		if (pos > dei.fofs && pos - dei.fofs >= F2FS_MIN_EXTENT_LEN) {
 			en->ei.len = pos - en->ei.fofs;
 			prev_en = en;
 			parts = 1;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ecd833ba35fc..36e2d0226be4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4627,7 +4627,7 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 skip_write_trace:
 		/* Do the actual write. */
 		ret = dio ?
-			f2fs_dio_write_iter(iocb, from, &may_need_sync):
+			f2fs_dio_write_iter(iocb, from, &may_need_sync) :
 			f2fs_buffered_write_iter(iocb, from);
 
 		if (trace_f2fs_datawrite_end_enabled())
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 3f508b13cb61..c9b10113fcb1 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -585,7 +585,7 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 		ne = nat_in_journal(journal, i);
 		node_info_from_raw_nat(ni, &ne);
 	}
-        up_read(&curseg->journal_rwsem);
+	up_read(&curseg->journal_rwsem);
 	if (i >= 0) {
 		f2fs_up_read(&nm_i->nat_tree_lock);
 		goto cache;
-- 
2.35.1

