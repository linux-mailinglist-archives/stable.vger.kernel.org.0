Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D393F17124C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 09:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgB0ISP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 03:18:15 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54373 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726999AbgB0ISP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 03:18:15 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 6D0A621EAE;
        Thu, 27 Feb 2020 03:18:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 03:18:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6TLw9W
        WA/NQsp03lgqTM11Y4LP3g7jftjVtAyk7tgrA=; b=JMXXKxSBHIW2YeFWygsJTP
        fb9qFJ7oYqs5/JYOCMRsuEASq7X43/ppM3OHghFh2wdLhiaivcMXWi3EkILyhwXl
        3W7OtrCAb7liw29DOq+ieACmcfgNEtN7thwrqM1EfetHRu9/PzvQ42BrbKuO7B2w
        0kXThCM/EyWQoR3yuW9d+OUdly/w0SNjmUKuHLnMlUdugNkL+HesvhhgkuPiaDPM
        0JCqoKHVc0FrzezmQe8LTkNF9lmDi8JeLZ/uL0K328ycxuFCkCDVx0Lq6Bn0GTlK
        G9Mlq61U7SgGL3K0AMb27zW69O6ofercU9VINIWvOVoN8Uw5zAeAmnOugkno8hsA
        ==
X-ME-Sender: <xms:RntXXmJXuDKbb-PpmUNy0OT8cbk5dHX6IVHbwDnZJFf32gvDtCkLxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleehgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:RntXXklDv9BZ9W4EgP_MsbajUCu0PzRIpHuVFozl-JJ-hFXXs-7bNA>
    <xmx:RntXXvhyXtuiX3vOt27XQlJxx2kn-QFNJn0o6m-02U-B_FPwxjB5Ww>
    <xmx:RntXXqq30b-sWzHCjLfuf1j4lOqqLSvQuz-tm7IPBMzrSS7DOwrJ6w>
    <xmx:RntXXkRiqGuCeOCHKbtGXAvpWsb53U82eaok6vlLd_w8OlToD43qcw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB7E43060FCB;
        Thu, 27 Feb 2020 03:18:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: rename s_journal_flag_rwsem to s_writepages_rwsem" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 09:18:11 +0100
Message-ID: <158279149142227@kroah.com>
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

From bbd55937de8f2754adc5792b0f8e5ff7d9c0420e Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Wed, 19 Feb 2020 10:30:46 -0800
Subject: [PATCH] ext4: rename s_journal_flag_rwsem to s_writepages_rwsem

In preparation for making s_journal_flag_rwsem synchronize
ext4_writepages() with changes to both the EXTENTS and JOURNAL_DATA
flags (rather than just JOURNAL_DATA as it does currently), rename it to
s_writepages_rwsem.

Link: https://lore.kernel.org/r/20200219183047.47417-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 614fefa7dc7a..4b986ad42b9d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1553,7 +1553,7 @@ struct ext4_sb_info {
 	struct ratelimit_state s_msg_ratelimit_state;
 
 	/* Barrier between changing inodes' journal flags and writepages ops. */
-	struct percpu_rw_semaphore s_journal_flag_rwsem;
+	struct percpu_rw_semaphore s_writepages_rwsem;
 	struct dax_device *s_daxdev;
 #ifdef CONFIG_EXT4_DEBUG
 	unsigned long s_simulate_fail;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6e1d81ed44ad..fa0ff78dc033 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2628,7 +2628,7 @@ static int ext4_writepages(struct address_space *mapping,
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
 		return -EIO;
 
-	percpu_down_read(&sbi->s_journal_flag_rwsem);
+	percpu_down_read(&sbi->s_writepages_rwsem);
 	trace_ext4_writepages(inode, wbc);
 
 	/*
@@ -2849,7 +2849,7 @@ static int ext4_writepages(struct address_space *mapping,
 out_writepages:
 	trace_ext4_writepages_result(inode, wbc, ret,
 				     nr_to_write - wbc->nr_to_write);
-	percpu_up_read(&sbi->s_journal_flag_rwsem);
+	percpu_up_read(&sbi->s_writepages_rwsem);
 	return ret;
 }
 
@@ -2864,13 +2864,13 @@ static int ext4_dax_writepages(struct address_space *mapping,
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
 		return -EIO;
 
-	percpu_down_read(&sbi->s_journal_flag_rwsem);
+	percpu_down_read(&sbi->s_writepages_rwsem);
 	trace_ext4_writepages(inode, wbc);
 
 	ret = dax_writeback_mapping_range(mapping, sbi->s_daxdev, wbc);
 	trace_ext4_writepages_result(inode, wbc, ret,
 				     nr_to_write - wbc->nr_to_write);
-	percpu_up_read(&sbi->s_journal_flag_rwsem);
+	percpu_up_read(&sbi->s_writepages_rwsem);
 	return ret;
 }
 
@@ -5861,7 +5861,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		}
 	}
 
-	percpu_down_write(&sbi->s_journal_flag_rwsem);
+	percpu_down_write(&sbi->s_writepages_rwsem);
 	jbd2_journal_lock_updates(journal);
 
 	/*
@@ -5878,7 +5878,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		err = jbd2_journal_flush(journal);
 		if (err < 0) {
 			jbd2_journal_unlock_updates(journal);
-			percpu_up_write(&sbi->s_journal_flag_rwsem);
+			percpu_up_write(&sbi->s_writepages_rwsem);
 			return err;
 		}
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
@@ -5886,7 +5886,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	ext4_set_aops(inode);
 
 	jbd2_journal_unlock_updates(journal);
-	percpu_up_write(&sbi->s_journal_flag_rwsem);
+	percpu_up_write(&sbi->s_writepages_rwsem);
 
 	if (val)
 		up_write(&EXT4_I(inode)->i_mmap_sem);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6b7e628b7903..6928fc229799 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1064,7 +1064,7 @@ static void ext4_put_super(struct super_block *sb)
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
-	percpu_free_rwsem(&sbi->s_journal_flag_rwsem);
+	percpu_free_rwsem(&sbi->s_writepages_rwsem);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(get_qf_name(sb, sbi, i));
@@ -4626,7 +4626,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0,
 					  GFP_KERNEL);
 	if (!err)
-		err = percpu_init_rwsem(&sbi->s_journal_flag_rwsem);
+		err = percpu_init_rwsem(&sbi->s_writepages_rwsem);
 
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "insufficient memory");
@@ -4726,7 +4726,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
-	percpu_free_rwsem(&sbi->s_journal_flag_rwsem);
+	percpu_free_rwsem(&sbi->s_writepages_rwsem);
 failed_mount5:
 	ext4_ext_release(sb);
 	ext4_release_system_zone(sb);

