Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4845FCC17
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 22:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJLUea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 16:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJLUeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 16:34:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215D6102DED
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 13:34:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D251BB81BD6
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 20:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB61C4347C;
        Wed, 12 Oct 2022 20:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665606860;
        bh=zr7G8PZnMCsv5Y2rZJmozVtsrmEbLjfCMeVsfMZZ1pY=;
        h=Subject:To:Cc:From:Date:From;
        b=H654RDQ4tjmkZuRoIzPYRZqb5vPbPMNmGK0IfQ1WuE4z5111ctI12/wOeWwyn3QJ7
         WFrO2+IDkFzwJUqMLuQW44MTDPYzVl2R1TjTZ888vRBVRV9dd0VBGsqQjVjaTshkMH
         MfXlcTm0avuCBMhYrbpZt1VOGVbKvtzzBScBlhOM=
Subject: FAILED: patch "[PATCH] nilfs2: fix use-after-free bug of struct nilfs_root" failed to apply to 4.9-stable tree
To:     konishi.ryusuke@gmail.com, akpm@linux-foundation.org,
        khalid.masum.92@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Oct 2022 22:35:04 +0200
Message-ID: <1665606904196222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,CONTENT_AFTER_HTML,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

<!DOCTYPE html>
<html lang='en'>
<head>
<title>kernel/git/sashal/deps.git - Sashas dependency resolver</title>
<meta name='generator' content='cgit '/>
<meta name='robots' content='noindex, nofollow'/>
<link rel='stylesheet' type='text/css' href='/cgit-data/cgit.css'/>
<link rel='shortcut icon' href='/favicon.ico'/>
<link rel='alternate' title='Atom feed' href='http://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/atom/?h=master' type='application/atom+xml'/>
<link rel='vcs-git' href='git://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git' title='kernel/git/sashal/deps.git Git repository'/>
<link rel='vcs-git' href='https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git' title='kernel/git/sashal/deps.git Git repository'/>
<link rel='vcs-git' href='https://kernel.googlesource.com/pub/scm/linux/kernel/git/sashal/deps.git' title='kernel/git/sashal/deps.git Git repository'/>
</head>
<body>
<div id='cgit'><table id='header'>
<tr>
<td class='logo' rowspan='2'><a href='/'><img src='/cgit-data/cgit.png' alt='cgit logo'/></a></td>
<td class='main'><a href='/'>index</a> : <a title='kernel/git/sashal/deps.git' href='/pub/scm/linux/kernel/git/sashal/deps.git/'>kernel/git/sashal/deps.git</a></td><td class='form'><form method='get'>
<select name='h' onchange='this.form.submit();'>
<option value='master' selected='selected'>master</option>
</select> <input type='submit' value='switch'/></form></td></tr>
<tr><td class='sub'>Sashas dependency resolver</td><td class='sub right'>Sasha Levin</td></tr></table>
<table class='tabs'><tr><td>
<a href='/pub/scm/linux/kernel/git/sashal/deps.git/'>summary</a><a href='/pub/scm/linux/kernel/git/sashal/deps.git/refs/'>refs</a><a href='/pub/scm/linux/kernel/git/sashal/deps.git/log/'>log</a><a href='/pub/scm/linux/kernel/git/sashal/deps.git/tree/'>tree</a><a href='/pub/scm/linux/kernel/git/sashal/deps.git/commit/'>commit</a><a href='/pub/scm/linux/kernel/git/sashal/deps.git/diff/'>diff</a><a href='/pub/scm/linux/kernel/git/sashal/deps.git/stats/'>stats</a></td><td class='form'><form class='right' method='get' action='/pub/scm/linux/kernel/git/sashal/deps.git/log/'>
<select name='qt'>
<option value='grep'>log msg</option>
<option value='author'>author</option>
<option value='committer'>committer</option>
<option value='range'>range</option>
</select>
<input class='txt' type='search' size='10' name='q' value=''/>
<input type='submit' value='search'/>
</form>
</td></tr></table>
<div class='content'><div class='error'>Not found</div>
</div> <!-- class=content -->
<div class='footer'>generated by <a href='https://git.zx2c4.com/cgit/about/'>cgit </a> (<a href='https://git-scm.com/'>git 2.34.1</a>) at 2022-10-12 20:34:18 +0000</div>
</div> <!-- id=cgit -->
</body>
</html>

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d325dc6eb763c10f591c239550b8c7e5466a5d09 Mon Sep 17 00:00:00 2001
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 4 Oct 2022 00:05:19 +0900
Subject: [PATCH] nilfs2: fix use-after-free bug of struct nilfs_root

If the beginning of the inode bitmap area is corrupted on disk, an inode
with the same inode number as the root inode can be allocated and fail
soon after.  In this case, the subsequent call to nilfs_clear_inode() on
that bogus root inode will wrongly decrement the reference counter of
struct nilfs_root, and this will erroneously free struct nilfs_root,
causing kernel oopses.

This fixes the problem by changing nilfs_new_inode() to skip reserved
inode numbers while repairing the inode bitmap.

Link: https://lkml.kernel.org/r/20221003150519.39789-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+b8c672b0e22615c80fe0@syzkaller.appspotmail.com
Reported-by: Khalid Masum <khalid.masum.92@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 67f63cfeade5..b074144f6f83 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -328,6 +328,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
+	struct buffer_head *bh;
 	int err = -ENOMEM;
 	ino_t ino;
 
@@ -343,11 +344,25 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	ii->i_state = BIT(NILFS_I_NEW);
 	ii->i_root = root;
 
-	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
+	err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
 
+	if (unlikely(ino < NILFS_USER_INO)) {
+		nilfs_warn(sb,
+			   "inode bitmap is inconsistent for reserved inodes");
+		do {
+			brelse(bh);
+			err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
+			if (unlikely(err))
+				goto failed_ifile_create_inode;
+		} while (ino < NILFS_USER_INO);
+
+		nilfs_info(sb, "repaired inode bitmap for reserved inodes");
+	}
+	ii->i_bh = bh;
+
 	atomic64_inc(&root->inodes_count);
 	inode_init_owner(&init_user_ns, inode, dir, mode);
 	inode->i_ino = ino;

