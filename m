Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCCD2F92C5
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbhAQOQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:16:35 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:50299 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728858AbhAQOQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:16:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id EC4B919811CD;
        Sun, 17 Jan 2021 09:15:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:15:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zZbb0O
        DZ3c1KKIW0ukBDeKuZpk0++x78+G3aHsP1Ot0=; b=YXQGX8eObHcbwbrC+ibFia
        YJCK8qZUzEN3di0eMg31zkuegaooqSrbc2N+kx9Jc17JT8d8hzligss9Y3a/fNsq
        7lZMkgOpgExg47qdJXD8IxJmRQqaUO0CHnVTu1N0tdlLM7kZPQjuLp5Zor5IbpKV
        ZhWjLyuRoPFAWvKLwK5XTzZuLOjP1vf2+sBSL+DMpPRqO4T+8A0mP/WDC+DTR4Jm
        oreQCHk8/+qqZXVrRwZdjkbDkIAwewUV4aEXhrKu628c8dOlvjhnmrWm+j1xrNAi
        oXwgZBfMIYBIlNgogFDtEz3kNUgXPKntP2YnAQaavOqAwiQm3nIj2tqAwMbC4Nug
        ==
X-ME-Sender: <xms:lEYEYBrh9DsAB03Pkod6e4MDbNNDe0zDvjnCcU-1qNu519cFACbJGw>
    <xme:lEYEYDpQb-Hs1GppdjTYL9YRFt7DQuwFp_1n3flBtkrkHiNhLwACB-bVepboRGpzE
    A3OhAg9PO2PXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:lEYEYOOcUTd5AGgGr6bmDW6Nf1VSW8mbWWAVId9KwqeJdDXlf00Dzw>
    <xmx:lEYEYM4q26A-d66p1sXktia3MaMYAzSPTwcJjrUuo-JDo50gwCkj6Q>
    <xmx:lEYEYA4S8rvYHPbNCYsde8YOnto5UU8B6HN96DxEDUOyxJA6FdxJrQ>
    <xmx:lEYEYOSB8xi8LpjREa3clmfX3dI4f9-BUW0qfVMPKxb4rlCReFzC6g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9901D108005B;
        Sun, 17 Jan 2021 09:15:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: fix bug for rename with RENAME_WHITEOUT" failed to apply to 4.9-stable tree
To:     yangerkun@huawei.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:15:45 +0100
Message-ID: <161089294592108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

