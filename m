Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7AF203E63
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 19:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbgFVRur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 13:50:47 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:58277 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730200AbgFVRuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 13:50:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 37E3D300;
        Mon, 22 Jun 2020 13:50:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 22 Jun 2020 13:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EfaZ0m
        zvsvQC+w6PaCldwy8nbPwx0ctNQcG+cz5fUGg=; b=s0yUhbHKa0TGVF1XNwcD0G
        lYVYrzq4PAEN9j11i0aqB6TLI8+sbtMRGWH+zWMTA28omVERhn50UOI94bDjJ8f0
        fR3DBVq3che99kCvVLVwbbAezPoM3Hywtl+MAlNp1GevBdzSbeSfjyKTi5edBxb0
        LDrSJRddQslXOYOfzR+IO1RvGxDgBppfm+W3h3HaBb9h82+54D/2sRnITaVtFprX
        g2MVEzRhtvBP+P2ewR66Z6uYwBt/9w5qqLefrSooikn2wkSdO3bdzVKPDlef73dX
        8yT2I00la6H5aQzhF06Apau4ENAQKzwBvz0M36ERQcI9aH0ldUDO6XebAlKlxIiw
        ==
X-ME-Sender: <xms:dO_wXqy92sLwI4F9BttQG3F3Ka8ElNuZcOXX1zAfvhxCw2yEieHQpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekvddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dO_wXmRmEch4XWzui6dMdeS3Cyef9elKNE9H2kRJNTMRE9ABhCIxvQ>
    <xmx:dO_wXsXI9uRp77uacoWVic3JTy6yDSp7IKTUXZwyzN1h4Wz8DKf7WQ>
    <xmx:dO_wXgjm82WidNPaYHb0V9CORlB-jiFB8gWQqQTkASZj1CYwqoF5Bw>
    <xmx:dO_wXnpZSFI3nOOF-XsrDbvBqC82TuYU8c2pNt86xZ6PtIOJylZ4trpgjXs>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 17CAA30673B2;
        Mon, 22 Jun 2020 13:50:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4, jbd2: ensure panic by fix a race between jbd2 abort and" failed to apply to 4.4-stable tree
To:     yi.zhang@huawei.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 19:50:39 +0200
Message-ID: <1592848239109250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7b97d868b7ab2448859668de9222b8af43f76e78 Mon Sep 17 00:00:00 2001
From: "zhangyi (F)" <yi.zhang@huawei.com>
Date: Tue, 9 Jun 2020 15:35:40 +0800
Subject: [PATCH] ext4, jbd2: ensure panic by fix a race between jbd2 abort and
 ext4 error handlers

In the ext4 filesystem with errors=panic, if one process is recording
errno in the superblock when invoking jbd2_journal_abort() due to some
error cases, it could be raced by another __ext4_abort() which is
setting the SB_RDONLY flag but missing panic because errno has not been
recorded.

jbd2_journal_commit_transaction()
 jbd2_journal_abort()
  journal->j_flags |= JBD2_ABORT;
  jbd2_journal_update_sb_errno()
                                    | ext4_journal_check_start()
                                    |  __ext4_abort()
                                    |   sb->s_flags |= SB_RDONLY;
                                    |   if (!JBD2_REC_ERR)
                                    |        return;
  journal->j_flags |= JBD2_REC_ERR;

Finally, it will no longer trigger panic because the filesystem has
already been set read-only. Fix this by introduce j_abort_mutex to make
sure journal abort is completed before panic, and remove JBD2_REC_ERR
flag.

Fixes: 4327ba52afd03 ("ext4, jbd2: ensure entering into panic after recording an error in superblock")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200609073540.3810702-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 127b8efa8d54..2660a7e47eef 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -522,9 +522,6 @@ static void ext4_handle_error(struct super_block *sb)
 		smp_wmb();
 		sb->s_flags |= SB_RDONLY;
 	} else if (test_opt(sb, ERRORS_PANIC)) {
-		if (EXT4_SB(sb)->s_journal &&
-		  !(EXT4_SB(sb)->s_journal->j_flags & JBD2_REC_ERR))
-			return;
 		panic("EXT4-fs (device %s): panic forced after error\n",
 			sb->s_id);
 	}
@@ -725,23 +722,20 @@ void __ext4_abort(struct super_block *sb, const char *function,
 	va_end(args);
 
 	if (sb_rdonly(sb) == 0) {
-		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 		EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
+		if (EXT4_SB(sb)->s_journal)
+			jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
+
+		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 		/*
 		 * Make sure updated value of ->s_mount_flags will be visible
 		 * before ->s_flags update
 		 */
 		smp_wmb();
 		sb->s_flags |= SB_RDONLY;
-		if (EXT4_SB(sb)->s_journal)
-			jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
 	}
-	if (test_opt(sb, ERRORS_PANIC) && !system_going_down()) {
-		if (EXT4_SB(sb)->s_journal &&
-		  !(EXT4_SB(sb)->s_journal->j_flags & JBD2_REC_ERR))
-			return;
+	if (test_opt(sb, ERRORS_PANIC) && !system_going_down())
 		panic("EXT4-fs panic from previous error\n");
-	}
 }
 
 void __ext4_msg(struct super_block *sb,
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index a49d0e670ddf..e4944436e733 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1140,6 +1140,7 @@ static journal_t *journal_init_common(struct block_device *bdev,
 	init_waitqueue_head(&journal->j_wait_commit);
 	init_waitqueue_head(&journal->j_wait_updates);
 	init_waitqueue_head(&journal->j_wait_reserved);
+	mutex_init(&journal->j_abort_mutex);
 	mutex_init(&journal->j_barrier);
 	mutex_init(&journal->j_checkpoint_mutex);
 	spin_lock_init(&journal->j_revoke_lock);
@@ -1402,7 +1403,8 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 		printk(KERN_ERR "JBD2: Error %d detected when updating "
 		       "journal superblock for %s.\n", ret,
 		       journal->j_devname);
-		jbd2_journal_abort(journal, ret);
+		if (!is_journal_aborted(journal))
+			jbd2_journal_abort(journal, ret);
 	}
 
 	return ret;
@@ -2153,6 +2155,13 @@ void jbd2_journal_abort(journal_t *journal, int errno)
 {
 	transaction_t *transaction;
 
+	/*
+	 * Lock the aborting procedure until everything is done, this avoid
+	 * races between filesystem's error handling flow (e.g. ext4_abort()),
+	 * ensure panic after the error info is written into journal's
+	 * superblock.
+	 */
+	mutex_lock(&journal->j_abort_mutex);
 	/*
 	 * ESHUTDOWN always takes precedence because a file system check
 	 * caused by any other journal abort error is not required after
@@ -2167,6 +2176,7 @@ void jbd2_journal_abort(journal_t *journal, int errno)
 			journal->j_errno = errno;
 			jbd2_journal_update_sb_errno(journal);
 		}
+		mutex_unlock(&journal->j_abort_mutex);
 		return;
 	}
 
@@ -2188,10 +2198,7 @@ void jbd2_journal_abort(journal_t *journal, int errno)
 	 * layer could realise that a filesystem check is needed.
 	 */
 	jbd2_journal_update_sb_errno(journal);
-
-	write_lock(&journal->j_state_lock);
-	journal->j_flags |= JBD2_REC_ERR;
-	write_unlock(&journal->j_state_lock);
+	mutex_unlock(&journal->j_abort_mutex);
 }
 
 /**
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index f613d8529863..d56128df2aff 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -765,6 +765,11 @@ struct journal_s
 	 */
 	int			j_errno;
 
+	/**
+	 * @j_abort_mutex: Lock the whole aborting procedure.
+	 */
+	struct mutex		j_abort_mutex;
+
 	/**
 	 * @j_sb_buffer: The first part of the superblock buffer.
 	 */
@@ -1247,7 +1252,6 @@ JBD2_FEATURE_INCOMPAT_FUNCS(csum3,		CSUM_V3)
 #define JBD2_ABORT_ON_SYNCDATA_ERR	0x040	/* Abort the journal on file
 						 * data write error in ordered
 						 * mode */
-#define JBD2_REC_ERR	0x080	/* The errno in the sb has been recorded */
 
 /*
  * Function declarations for the journaling transaction and buffer

