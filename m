Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD60E203E66
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 19:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbgFVRu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 13:50:58 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:47713 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730124AbgFVRu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 13:50:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 9F981300;
        Mon, 22 Jun 2020 13:50:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 22 Jun 2020 13:50:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/NoVGl
        xSPg6tONC+Ea9EoSdWvcu6FA6+eBC6fdxgQAY=; b=GoNrYYbRKwjef/1aWaQ2xd
        ucAOZZ4O023EqlTu7ii8j6Z2Bm6xvH/g98SCjBdluGfwRyVKmrT/6pk2EZJloGqJ
        tQqLSKP8MnhSxt8hn9gTegkcRJ+FkGObW+9ZqEmauyhZv2ohXLdDNE2JfSRJdo0/
        CNpPa9m32h4YORfHGVGMS2QOPfCL/pD4NA+S/Dft6E3On3lh5i5PiDJzhxIVb83b
        8PsDXugeR6pIoLPwWtxotX6RcLhCXD4BhAjIfne9sEsuzF7NPqRMcaTbIuJPOsXm
        LxCx6NimS4QZlMAMOcNLqMYxzrNcHwWwyfaraydVItODofmTnhOQ3hn1zHTJewKA
        ==
X-ME-Sender: <xms:gO_wXnzrYtsX1pHGe-SFQtcJZX4IEbxbJegm4AqyFOwsrw-6yHzfVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekvddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:gO_wXvTH9S6Pcl_z86F77XoyttZ9zUClSP45QyNxTP5BbSswA_ckEQ>
    <xmx:gO_wXhWzm7Q5kcT__CRVDGISU7lTfEtePkrVa87mCwJbPkWsAl_V7w>
    <xmx:gO_wXhiKb1sHaUp2L5BMFrYzFgswyLb5lLvykQ0X2BucPvOQ8hGyrA>
    <xmx:gO_wXso9ohHb3oY2p3MBxIvvR_SnY18B7FoQMX8xeL55i6Sxg3eSENQGqhY>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD1D13280059;
        Mon, 22 Jun 2020 13:50:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4, jbd2: ensure panic by fix a race between jbd2 abort and" failed to apply to 4.19-stable tree
To:     yi.zhang@huawei.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 19:50:42 +0200
Message-ID: <159284824210245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

