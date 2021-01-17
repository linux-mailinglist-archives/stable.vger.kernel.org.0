Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE742F92C4
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbhAQOQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:16:33 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:57769 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728858AbhAQOQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:16:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id BC49B1980A59;
        Sun, 17 Jan 2021 09:15:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:15:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ywOSyT
        0wu1BXR9I06Xqq8G4mQLZm43qDlHhporCJjWQ=; b=Eg2n3JxZxXSy5ENIlgYFzP
        8A6OCyRuUO8GJ6OXowUVQx0qZVG4yEQTJrRdPlYD40LbNxWjx5LMic+92V85jW4v
        +0UZadqxnP6d2MMp77z9a4PB2Mz/zpSLzBWehSkgOIXBm+DSwXR8nDS58csM/Azf
        VMNZZTbyGlDkYeen2EQeuCeiTei+NlQL/H+cs6bc5LtMYRfFTjjACmDrANXwy79s
        +SarjKPI0yHgEw7k+0r9VjJOsC3Fy0tW0uAAowQIm88yMyes0eB0L7pA6rqHzpMg
        mQijxqGwbMowComKcrUOCwxQPHG+1bENLNHbdmYvWSq1htzx9Zz5G+MORkmlvO7Q
        ==
X-ME-Sender: <xms:kkYEYOEXXrQ9ddL8ugcLSybiVn8Os4kl1j16iOVaDFrdA_760tlocA>
    <xme:kkYEYPVs5r6JK8wBpegbchzYqHRHSKxHKtKdwv_L4Ju6OZSkCALiZQWSA3avZYGw7
    4-UzJoOt8mx_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kkYEYILaPC1oMKg36AYdqREzGFfyjlrgJwNWpQcyocWCaLj4OjV1qQ>
    <xmx:kkYEYIFB9V-TsY5kdVgilwBZFPHTSnfFE-sbk9Je21QvCdHiU4Pllg>
    <xmx:kkYEYEWOdrFbjdLovd7dSOJatXbN0bWz6C-D2ZDgl9K1T78h94dX-g>
    <xmx:kkYEYPebSGQziZ6ZUBBSldH1p40CWUd9qJH6orPSXW-nK0sNZJbZxQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E136B24005A;
        Sun, 17 Jan 2021 09:15:45 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: fix bug for rename with RENAME_WHITEOUT" failed to apply to 4.4-stable tree
To:     yangerkun@huawei.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:15:44 +0100
Message-ID: <161089294419056@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

