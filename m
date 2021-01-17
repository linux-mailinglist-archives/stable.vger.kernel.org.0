Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357712F92C6
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbhAQOQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:16:38 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:59977 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728875AbhAQOQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:16:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 479A01981D6C;
        Sun, 17 Jan 2021 09:15:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:15:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6SI7rc
        QCKv3kMT6eh8LOY6kDsKyzMhIpKGTG4rcgxtU=; b=lHvRsnhweMyeMwWfyqxXQ7
        3pzFEzw/qcazeBoqTXYNpkem5jv7yrHaibV2BLMqZsebU1jkB+H+PNIbLLwy51Tm
        gw9rSoZV29aB/AYJH/ECEycXgD55Ll1j7UUHgvO+vqn7qXAI2CjlvP9+WFUW5rIk
        7MVyopV9TAKnYAt3+QXmAYBajrstgajysRjWzlEi9wupruXUUTpErPfgxyDlAtjF
        pVdIOKz2BSk3dMOMCm8M6aiN0GQ/ocq3KaZdQT/7DB06Rhn5qb3RgNU7Z/5sk59j
        yLC4vr9jSCNZCiQ1Ptgl3bwFcvl/vJREg6Kl1RvOJrk0Y3+oYTqnKq0l8ayKj4cw
        ==
X-ME-Sender: <xms:lkYEYN84ASZ3-6-B4TmvTw6DdGJ3nX1CQBeqqgTwnIj0vX-8XzAjCA>
    <xme:lkYEYButJ18j2T6OkP_N_vwdxYJmdEnhESN8oGXbxJH4_zRAapDGGCJnHIPZmQmgr
    WTaY0dwwKywkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:lkYEYLBOrx9LMfHAvLgcemFBd1siD2--IzEg3N_lG9bzLtY9uozL9Q>
    <xmx:lkYEYBcNem1qJO2DeJXlOGFhSYkGoOy2WO4LlHEMhk7mrHRicsfc4A>
    <xmx:lkYEYCMBMoSv0rxfs12Bz4mNi7Eoz0MfRsbLdyqnac_3bl4xzla_OQ>
    <xmx:lkYEYE0EhzORy2bxa4_gwfpUv-zZRKXCQUMotq18GFNL-DjAmwy8Hw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E6E3B240057;
        Sun, 17 Jan 2021 09:15:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: fix bug for rename with RENAME_WHITEOUT" failed to apply to 4.14-stable tree
To:     yangerkun@huawei.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:15:46 +0100
Message-ID: <1610892946127115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6b4b8e6b4ad8553660421d6360678b3811d5deb9 Mon Sep 17 00:00:00 2001
From: yangerkun <yangerkun@huawei.com>
Date: Tue, 5 Jan 2021 14:28:57 +0800
Subject: [PATCH] ext4: fix bug for rename with RENAME_WHITEOUT

We got a "deleted inode referenced" warning cross our fsstress test. The
bug can be reproduced easily with following steps:

  cd /dev/shm
  mkdir test/
  fallocate -l 128M img
  mkfs.ext4 -b 1024 img
  mount img test/
  dd if=/dev/zero of=test/foo bs=1M count=128
  mkdir test/dir/ && cd test/dir/
  for ((i=0;i<1000;i++)); do touch file$i; done # consume all block
  cd ~ && renameat2(AT_FDCWD, /dev/shm/test/dir/file1, AT_FDCWD,
    /dev/shm/test/dir/dst_file, RENAME_WHITEOUT) # ext4_add_entry in
    ext4_rename will return ENOSPC!!
  cd /dev/shm/ && umount test/ && mount img test/ && ls -li test/dir/file1
  We will get the output:
  "ls: cannot access 'test/dir/file1': Structure needs cleaning"
  and the dmesg show:
  "EXT4-fs error (device loop0): ext4_lookup:1626: inode #2049: comm ls:
  deleted inode referenced: 139"

ext4_rename will create a special inode for whiteout and use this 'ino'
to replace the source file's dir entry 'ino'. Once error happens
latter(the error above was the ENOSPC return from ext4_add_entry in
ext4_rename since all space has been consumed), the cleanup do drop the
nlink for whiteout, but forget to restore 'ino' with source file. This
will trigger the bug describle as above.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Fixes: cd808deced43 ("ext4: support RENAME_WHITEOUT")
Link: https://lore.kernel.org/r/20210105062857.3566-1-yangerkun@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a3b28ef2455a..fa625a247e9a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3601,9 +3601,6 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 			return retval2;
 		}
 	}
-	brelse(ent->bh);
-	ent->bh = NULL;
-
 	return retval;
 }
 
@@ -3802,6 +3799,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
+	old_file_type = old.de->file_type;
 	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
 		ext4_handle_sync(handle);
 
@@ -3829,7 +3827,6 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	force_reread = (new.dir->i_ino == old.dir->i_ino &&
 			ext4_test_inode_flag(new.dir, EXT4_INODE_INLINE_DATA));
 
-	old_file_type = old.de->file_type;
 	if (whiteout) {
 		/*
 		 * Do this before adding a new entry, so the old entry is sure
@@ -3927,15 +3924,19 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = 0;
 
 end_rename:
-	brelse(old.dir_bh);
-	brelse(old.bh);
-	brelse(new.bh);
 	if (whiteout) {
-		if (retval)
+		if (retval) {
+			ext4_setent(handle, &old,
+				old.inode->i_ino, old_file_type);
 			drop_nlink(whiteout);
+		}
 		unlock_new_inode(whiteout);
 		iput(whiteout);
+
 	}
+	brelse(old.dir_bh);
+	brelse(old.bh);
+	brelse(new.bh);
 	if (handle)
 		ext4_journal_stop(handle);
 	return retval;

