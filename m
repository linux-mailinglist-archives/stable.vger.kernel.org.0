Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0514AED49
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 09:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241720AbiBIIxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 03:53:48 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiBIIxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 03:53:46 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F04DF498B1
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 00:53:41 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id q7so2683845wrc.13
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 00:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9CFnL3qqWXJ1KIjkWA+dHMJeCeGe72XRflrV9wguz2M=;
        b=JRulG9jECURsOXXwkSZgDkDeQzFs5+h5DWCk/fYUmBRzTJMhgMUinIx+1EQsR/mx6+
         C9wBe9whiV2GeWBIYK4xhljDUm5yu9uP+GZ3LLSew7D7c2ihM+RWPaJfMuhNbHTXhBOV
         eQoOT3bZqobZrPN2A/FXMhqLvoNR1HF9z8z2nlV6bEk3FpmYPi0c1StxOCw8F+0OOQXS
         K7RRytLP/4yIrcKR6+rklhTDAMrKvbvPQ3Z2c7qOWtxtzz5acMMqFW6YxUkRN7cHqtuj
         2DTtVagZc0yxQP25VQMjLdQmHLmRBPJvbEdrqplUDDq4l5dcOycIhuaAebVlCZagvkh3
         p9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9CFnL3qqWXJ1KIjkWA+dHMJeCeGe72XRflrV9wguz2M=;
        b=G3RK5X2mI2PAx7M4vpwMVcBDfo/K/kJnTFAPMCos5uY6+to/CHn1BezRb1Rnh5pEK6
         DNUOBD0htlsYe+o1GOYKwS2BiVrJaRSyIjVRKs+LAa+U+TT33qY6yXvpxpxQqDRsAxaa
         xPy4EEDUrF8P8CE5LMdJydNwKUUvX4GDJNp/A556E7LMLnoBxnwS26ojvrygirOgciYp
         Oi0oFTQJ2/BH9nLQc6qs71pvgaJBPto1j+6uBYC+mt1r5aBEbnxYazXf9WELDs50K12X
         UnqzpEL+mQfptvxFSJ/zTB0DyfD/nfEYA/cmXXSeX6BAAUY8pmRLZ4mN9ygx77kunc6w
         aM8A==
X-Gm-Message-State: AOAM532VJR3Z3g5YWgRPfajWzJ3eTE1HDu5t1pKD980sxol7bR/aHYIf
        9HltzcEGPfw3HbSLzLl4a1OiWQ==
X-Google-Smtp-Source: ABdhPJwXuq9MmDuIMVKZWowVlwiE642Lp/YhwcVfgvw7YAHEe7zzhYAt78+1XmvRvqOgIOwAyTn7zw==
X-Received: by 2002:a05:6000:2c2:: with SMTP id o2mr1194369wry.30.1644396799839;
        Wed, 09 Feb 2022 00:53:19 -0800 (PST)
Received: from joneslee.c.googlers.com.com (205.215.190.35.bc.googleusercontent.com. [35.190.215.205])
        by smtp.gmail.com with ESMTPSA id i3sm13854286wrq.72.2022.02.09.00.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 00:53:19 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Subject: [PATCH 1/1] Revert "iomap: fall back to buffered writes for invalidation failures"
Date:   Wed,  9 Feb 2022 08:52:43 +0000
Message-Id: <20220209085243.3136536-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 60263d5889e6dc5987dc51b801be4955ff2e4aa7.

Reverting since this commit opens a potential avenue for abuse.

The C-reproducer and more information can be found at the link below.

With this patch applied, I can no longer get the repro to trigger.

  kernel BUG at fs/ext4/inode.c:2647!
  invalid opcode: 0000 [#1] PREEMPT SMP KASAN
  CPU: 0 PID: 459 Comm: syz-executor359 Tainted: G        W         5.10.93-syzkaller-01028-g0347b1658399 #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:mpage_prepare_extent_to_map+0xbe9/0xc00 fs/ext4/inode.c:2647
  Code: e8 fc bd c3 ff e9 80 f6 ff ff 44 89 e9 80 e1 07 38 c1 0f 8c a6 fe ff ff 4c 89 ef e8 e1 bd c3 ff e9 99 fe ff ff e8 87 c9 89 ff <0f> 0b e8 80 c9 89 ff 0f 0b e8 79 1e b8 02 66 0f 1f 84 00 00 00 00
  RSP: 0018:ffffc90000e2e9c0 EFLAGS: 00010293
  RAX: ffffffff81e321f9 RBX: 0000000000000000 RCX: ffff88810c12cf00
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
  RBP: ffffc90000e2eb90 R08: ffffffff81e31e71 R09: fffff940008d68b1
  R10: fffff940008d68b1 R11: 0000000000000000 R12: ffffea00046b4580
  R13: ffffc90000e2ea80 R14: 000000000000011e R15: dffffc0000000000
  FS:  00007fcfd0717700(0000) GS:ffff8881f7000000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fcfd07d5520 CR3: 000000010a142000 CR4: 00000000003506b0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   ext4_writepages+0xcbb/0x3950 fs/ext4/inode.c:2776
   do_writepages+0x13a/0x280 mm/page-writeback.c:2358
   __filemap_fdatawrite_range+0x356/0x420 mm/filemap.c:427
   filemap_write_and_wait_range+0x64/0xe0 mm/filemap.c:660
   __iomap_dio_rw+0x621/0x10c0 fs/iomap/direct-io.c:495
   iomap_dio_rw+0x35/0x80 fs/iomap/direct-io.c:611
   ext4_dio_write_iter fs/ext4/file.c:571 [inline]
   ext4_file_write_iter+0xfc5/0x1b70 fs/ext4/file.c:681
   do_iter_readv_writev+0x548/0x740 include/linux/fs.h:1941
   do_iter_write+0x182/0x660 fs/read_write.c:866
   vfs_iter_write+0x7c/0xa0 fs/read_write.c:907
   iter_file_splice_write+0x7fb/0xf70 fs/splice.c:686
   do_splice_from fs/splice.c:764 [inline]
   direct_splice_actor+0xfe/0x130 fs/splice.c:933
   splice_direct_to_actor+0x4f4/0xbc0 fs/splice.c:888
   do_splice_direct+0x28b/0x3e0 fs/splice.c:976
   do_sendfile+0x914/0x1390 fs/read_write.c:1257

Link: https://syzkaller.appspot.com/bug?extid=41c966bf0729a530bd8d

From the patch:
Cc: Stable <stable@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Theodore Ts'o <tytso@mit.edu> # for ext4
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>

Others:
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Cc: cluster-devel@redhat.com

Fixes: 60263d5889e6d ("iomap: fall back to buffered writes for invalidation failures")
Reported-by: syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 fs/ext4/file.c       |  2 --
 fs/gfs2/file.c       |  3 +--
 fs/iomap/direct-io.c | 16 +++++-----------
 fs/iomap/trace.h     |  1 -
 fs/xfs/xfs_file.c    |  4 ++--
 fs/zonefs/super.c    |  7 ++-----
 6 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3ed8c048fb12c..cb347c3b35535 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -551,8 +551,6 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		iomap_ops = &ext4_iomap_overwrite_ops;
 	ret = iomap_dio_rw(iocb, from, iomap_ops, &ext4_dio_write_ops,
 			   is_sync_kiocb(iocb) || unaligned_io || extend);
-	if (ret == -ENOTBLK)
-		ret = 0;
 
 	if (extend)
 		ret = ext4_handle_inode_extension(inode, offset, ret, count);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index b39b339feddc9..847adb97380d3 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -835,8 +835,7 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 
 	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL,
 			   is_sync_kiocb(iocb));
-	if (ret == -ENOTBLK)
-		ret = 0;
+
 out:
 	gfs2_glock_dq(gh);
 out_uninit:
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 933f234d5becd..ddcd06c0c452d 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -10,7 +10,6 @@
 #include <linux/backing-dev.h>
 #include <linux/uio.h>
 #include <linux/task_io_accounting_ops.h>
-#include "trace.h"
 
 #include "../internal.h"
 
@@ -413,9 +412,6 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
  * can be mapped into multiple disjoint IOs and only a subset of the IOs issued
  * may be pure data writes. In that case, we still need to do a full data sync
  * completion.
- *
- * Returns -ENOTBLK In case of a page invalidation invalidation failure for
- * writes.  The callers needs to fall back to buffered I/O in this case.
  */
 struct iomap_dio *
 __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
@@ -493,15 +489,13 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == WRITE) {
 		/*
 		 * Try to invalidate cache pages for the range we are writing.
-		 * If this invalidation fails, let the caller fall back to
-		 * buffered I/O.
+		 * If this invalidation fails, tough, the write will still work,
+		 * but racing two incompatible write paths is a pretty crazy
+		 * thing to do, so we don't support it 100%.
 		 */
 		if (invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
-				end >> PAGE_SHIFT)) {
-			trace_iomap_dio_invalidate_fail(inode, pos, count);
-			ret = -ENOTBLK;
-			goto out_free_dio;
-		}
+				end >> PAGE_SHIFT))
+			dio_warn_stale_pagecache(iocb->ki_filp);
 
 		if (!wait_for_completion && !inode->i_sb->s_dio_done_wq) {
 			ret = sb_init_dio_done_wq(inode->i_sb);
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index fdc7ae388476f..5693a39d52fb6 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -74,7 +74,6 @@ DEFINE_EVENT(iomap_range_class, name,	\
 DEFINE_RANGE_EVENT(iomap_writepage);
 DEFINE_RANGE_EVENT(iomap_releasepage);
 DEFINE_RANGE_EVENT(iomap_invalidatepage);
-DEFINE_RANGE_EVENT(iomap_dio_invalidate_fail);
 
 #define IOMAP_TYPE_STRINGS \
 	{ IOMAP_HOLE,		"HOLE" }, \
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5b0f93f738372..43e2c057214d9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -589,8 +589,8 @@ xfs_file_dio_aio_write(
 	xfs_iunlock(ip, iolock);
 
 	/*
-	 * No fallback to buffered IO after short writes for XFS, direct I/O
-	 * will either complete fully or return an error.
+	 * No fallback to buffered IO on errors for XFS, direct IO will either
+	 * complete fully or fail.
 	 */
 	ASSERT(ret < 0 || ret == count);
 	return ret;
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index bec47f2d074be..d54fbef3db4df 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -851,11 +851,8 @@ static ssize_t zonefs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_pos >= ZONEFS_I(inode)->i_max_size)
 		return -EFBIG;
 
-	if (iocb->ki_flags & IOCB_DIRECT) {
-		ssize_t ret = zonefs_file_dio_write(iocb, from);
-		if (ret != -ENOTBLK)
-			return ret;
-	}
+	if (iocb->ki_flags & IOCB_DIRECT)
+		return zonefs_file_dio_write(iocb, from);
 
 	return zonefs_file_buffered_write(iocb, from);
 }
-- 
2.35.0.263.gb82422642f-goog

