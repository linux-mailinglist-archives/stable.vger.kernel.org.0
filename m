Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD68139F678
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhFHMZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:25:50 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:34613 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232541AbhFHMZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:25:50 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 05BEA1CCD;
        Tue,  8 Jun 2021 08:23:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 08 Jun 2021 08:23:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=nW2zlY
        B16tfPEJzho6PDnKVlF1p1PF3yoRuzhIVwnD4=; b=JLazVctJ0PwocGF4zs4mrY
        pIa0Xq68KZORW0QBZyXwynVcjTUXmLdSFDe4OQFhOHpjp8hdOJAWfFyu4L/XmML5
        o4dxcDAzcBEkLFTJaKU1QQ4FGvwYKsWMKRkJKjJEoaSeKdIY4MR5utTxsjWrtLJr
        5d59WMwD9T4urnZTga9B/7IwnbfwG3fpmpKXFd83Ehe8QuG2bvCSrb1kMI7hbEgw
        Xfrz4Pbsa3wBxPA1A2wg4mNa4d4f+ta1P7W/zelNqP08jBFqBt25Y45Ui93hkk1c
        Fp9/R2NXMAwLKgNb4LqWPDtQ8h058jJCZIVo6mwZXmBMpA8+74K6O9Ca369wkw3Q
        ==
X-ME-Sender: <xms:XGG_YCMc8f9ffER_MsscO4UzSOLIQU0kcn8tRf0yoVxogW9PC2oU8g>
    <xme:XGG_YA-JKiscELLsfzmQ5ui6olB_1dWnqwevpU9gGTRCcA6ZdtUY1vxhltWDTtpjG
    5Oh6TGFBWWYCg>
X-ME-Received: <xmr:XGG_YJQtdOtdzE8GlyFSa9_8HqqrlanQ5EtdDWk_WaHvISylg9iT-QvOtacH4aDCH3RsEywEP0IzcroYHnw6AimjPwrc9EOr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:XGG_YCvMvUKq48PwdXEG6buQDrPF7IVOqE1zbLipQ2MjPhDzgHVwPg>
    <xmx:XGG_YKdUJq7R2KIhVIGv3uIz1q-EhR3sIrkzl43uLKHIkG0OHEL76Q>
    <xmx:XGG_YG2xOvPFjZY1DoUmbC66UyCU62M7tvu2iWa_bOJuTFYYOt4Bug>
    <xmx:XGG_YOER1M4fAh7Gn7t7NjQEAnA2nmnNgjb0sAa4Gp1dZr1Su8to_6eqrZ4>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:23:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix memory leak in ext4_fill_super" failed to apply to 4.19-stable tree
To:     amakhalov@vmware.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 14:23:51 +0200
Message-ID: <162315503119041@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

