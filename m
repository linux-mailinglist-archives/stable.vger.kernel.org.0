Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B2439F676
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhFHMZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:25:46 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:51517 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232492AbhFHMZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:25:46 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 472FC1CE6;
        Tue,  8 Jun 2021 08:23:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 08 Jun 2021 08:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ttj6gm
        iCm8VG9wMm87solWYT1hr4kjcqUZ1TIXFATOs=; b=IE3siBwU207v5CAYdoxpMr
        lQMc58q7o6YN8JcxUOrijSY2oyHEgAGry6NrCI3gyfuvASzoEvxkYOwPOse3i9+s
        htVt9J2OqxqTFpA3LdetSsCO7V/eySHuJ2SDv84qgez47l8hSrMbEq147caqk2J1
        i8dwGEwLHUAjWPFJBjoh0pVOtRhVWxUte9r2w624KwsnfILLU5D7UBC1fs5vaVDM
        VZAskH78BQr8tHlZx9GaDqDWiWQ12yF/p5WWFsrawviWUe2nMwYz4CvTKX9OrUEo
        lTpp7qZfFmd987adVy0arg5cFkaklewj4jPYmnspem+Wfb6q6eoscjoC9B/viQ7w
        ==
X-ME-Sender: <xms:WGG_YMY_xB16ukkD4erXu7smaXWy_X04Yu_IZzSTRdo0zNqnTzfZ1w>
    <xme:WGG_YHYnWcTkGYxIxzhS0vXpiFt9HfpjdcsYTwCTV0VJaVeQXGICSBxSI7w4P426Y
    G0jhTIrcWqNQg>
X-ME-Received: <xmr:WGG_YG8pkl8gTOuJD-Amflt3PgGAzIWotV3NBsBVTE0ot4o_UwPU0V-sKmen-buPSdpgfBCj8a0gicDUldbSjpcedSNbUO6R>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:WGG_YGrKrLvyRAwYZhBdZirRyx0yzVMpccNSLd5kvSpReY03qz5XvQ>
    <xmx:WGG_YHovaehBqkfvncPSe2lni785MWW6KZPrcKe-5fPtGIiM1fLM7g>
    <xmx:WGG_YERvz4Yop2nwSAEfoRLCZXT0bjwfv8YuhIN3MNmVCgmhNhHWrg>
    <xmx:WGG_YAD5prVHxcvcZFF69exeSmHtd0XcBHsCVVuEIiRNtQtbVmsEyiqaAb8>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:23:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix memory leak in ext4_fill_super" failed to apply to 5.4-stable tree
To:     amakhalov@vmware.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 14:23:50 +0200
Message-ID: <162315503023234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From afd09b617db3786b6ef3dc43e28fe728cfea84df Mon Sep 17 00:00:00 2001
From: Alexey Makhalov <amakhalov@vmware.com>
Date: Fri, 21 May 2021 07:55:33 +0000
Subject: [PATCH] ext4: fix memory leak in ext4_fill_super

Buffer head references must be released before calling kill_bdev();
otherwise the buffer head (and its page referenced by b_data) will not
be freed by kill_bdev, and subsequently that bh will be leaked.

If blocksizes differ, sb_set_blocksize() will kill current buffers and
page cache by using kill_bdev(). And then super block will be reread
again but using correct blocksize this time. sb_set_blocksize() didn't
fully free superblock page and buffer head, and being busy, they were
not freed and instead leaked.

This can easily be reproduced by calling an infinite loop of:

  systemctl start <ext4_on_lvm>.mount, and
  systemctl stop <ext4_on_lvm>.mount

... since systemd creates a cgroup for each slice which it mounts, and
the bh leak get amplified by a dying memory cgroup that also never
gets freed, and memory consumption is much more easily noticed.

Fixes: ce40733ce93d ("ext4: Check for return value from sb_set_blocksize")
Fixes: ac27a0ec112a ("ext4: initial copy of files from ext3")
Link: https://lore.kernel.org/r/20210521075533.95732-1-amakhalov@vmware.com
Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 886e0d518668..f66c7301b53a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4462,14 +4462,20 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	if (sb->s_blocksize != blocksize) {
+		/*
+		 * bh must be released before kill_bdev(), otherwise
+		 * it won't be freed and its page also. kill_bdev()
+		 * is called by sb_set_blocksize().
+		 */
+		brelse(bh);
 		/* Validate the filesystem blocksize */
 		if (!sb_set_blocksize(sb, blocksize)) {
 			ext4_msg(sb, KERN_ERR, "bad block size %d",
 					blocksize);
+			bh = NULL;
 			goto failed_mount;
 		}
 
-		brelse(bh);
 		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
 		offset = do_div(logical_sb_block, blocksize);
 		bh = ext4_sb_bread_unmovable(sb, logical_sb_block);
@@ -5202,8 +5208,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		kfree(get_qf_name(sb, sbi, i));
 #endif
 	fscrypt_free_dummy_policy(&sbi->s_dummy_enc_policy);
-	ext4_blkdev_remove(sbi);
+	/* ext4_blkdev_remove() calls kill_bdev(), release bh before it. */
 	brelse(bh);
+	ext4_blkdev_remove(sbi);
 out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);

