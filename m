Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF36539F67A
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbhFHMZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:25:53 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:58401 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232453AbhFHMZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:25:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2EC781CE5;
        Tue,  8 Jun 2021 08:24:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Jun 2021 08:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wr3gGq
        gpie0GokayzEvHOWhuiAcCKdEaX9ZfEKjYha4=; b=fT/H53EI/d7ez6Oaw174UH
        AroLLsSCpHjwWTQod346pHCsu7zroxh4u8DdqGX/1nScHv2xPWsc5AU1Pm+6oBYJ
        B+oRmXeeVbpvcOe3+ioFOTRvxBxEX7ZdKB346VGyPDZ5w7L2qC8jIL7DaH1FUQiC
        1imFYMS3b7YWlTdHtFxLvQ6TxTExJRwXWe7fhrAPW6aRr1sL5vYcQK+6R6Lj9Pbt
        alfZ+GQgmN1X90SdlZtJ+/iOYAmn6FJhpRjPoRjDDvB3LH6QjM5zg0BOiM+R8Xhg
        YYl4Sxmb3fBCMAd0hdAjWGwZjIsEb0rC1DRbENfx++CnKnRfy9u2mjUkqtlHIXWg
        ==
X-ME-Sender: <xms:X2G_YGGQ4qzSs1fXY1GN2IRo-C_N6ppChSqa3EWiyTWu_C_XpXK_UA>
    <xme:X2G_YHW7kKnTXh7SCjCyMJWUt6Fn1Mkt3uSnzPaUh3R1aShMuO0uvNOoYZ5b9Da1s
    wN_EJOpW26pTA>
X-ME-Received: <xmr:X2G_YAJHR3jmeHYPRDF4uZqt5zWjPfYLMgBl1xzcJKvf8Sm_AOAFwdIFFF6wrKghcmkDylCypqP7mHecmmywZfZD5CPuKjGO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:X2G_YAF04LY3WPpwmpFxI84nWfA2MTeBSh6LNgoj7INugQxbjNWBJg>
    <xmx:X2G_YMUO-pDL0AIB-hQlyyifbr8zGBGeIqxlUfK5FCYeg0tjUdmr1A>
    <xmx:X2G_YDPkP1jie4uvf2kvUoomLpb5sj1jGmeoV28HqvDZMPP3OObsjA>
    <xmx:X2G_YHeed3mHUUrw-a_g6DE4tzVrb-IBlsECoBII5VtU0YffLTNM_PFUjlc>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:23:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix memory leak in ext4_fill_super" failed to apply to 4.14-stable tree
To:     amakhalov@vmware.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 14:23:52 +0200
Message-ID: <1623155032159193@kroah.com>
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

