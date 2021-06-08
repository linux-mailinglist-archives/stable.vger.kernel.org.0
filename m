Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D6339F67B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhFHMZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:25:57 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:42413 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232453AbhFHMZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:25:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id D4D281CCD;
        Tue,  8 Jun 2021 08:24:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Jun 2021 08:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8+/NTk
        J9+i9dRSARj0bTezzjsLCzVFsTAFTpBBb5VMg=; b=muJSibEQKBME3Rr9gHhnqu
        SMJD+EeOELthaLDKtne6djNTORp/g8dglm/1VRzgUf/dqoRV2BfPpn4qAvSK1Yz4
        daJ0waw3Cwk24IvyVV3mpAoc9EHjJj25qh9wvaNPA8UbeDbo+ha0HPNbSe26Xjnc
        57sTo3HF2rEMmGXruNkB21Nw6wNw5ja8tk7PS8WuRLuuQHYYIlhr3yBIAdGeWF5m
        Mjo9roR4mscWmfIbBz+VcQpR2h9ZHlV4g/HVSuYnl1Cec92jdb9q0Fkuox2IdbYC
        fkjV7btYl6QoVYi9qSKEbFEwaEco/8VK/RwT3XOdzfLranaN5BoPV4q6PTBP9DpA
        ==
X-ME-Sender: <xms:Y2G_YFRQJAuW25760HwU7ItxnNWvOpSEw_dJkfRfCrJH3naM0iK5Dg>
    <xme:Y2G_YOzHB4xRzrfn-iO293LFVGIuvf5vfTNSDJMMzBU9JCrv5zeCk4qMGnOwl-a99
    kDPg8HGl7X8YA>
X-ME-Received: <xmr:Y2G_YK1_3oke8Nsll1kCz8dWetyusZqlab9kIPW766-ok09jnUMOwUYK059Z2L2ybWLnY4uEUzr1JyvIOrk6cc3JHL0iovDC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:Y2G_YNA20ZhgH4LCB5f4yNCkKUenpq-qTf2-68bUiE3RcEvxpAgzwA>
    <xmx:Y2G_YOj6ViwgmeD5CDv9GbpxubvvErSOmz1tN5bczDoiKhYfXK35rA>
    <xmx:Y2G_YBrhOwUltI337lTzXuzeAbUpasq2yyh5Lbb2ox4D7QSzHqB-lw>
    <xmx:Y2G_YCZMatsmxVq8OWUQWT2J5em3ee8egyltDYggPUaToKSldbNdAKdggSE>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:24:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix memory leak in ext4_fill_super" failed to apply to 4.9-stable tree
To:     amakhalov@vmware.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 14:23:53 +0200
Message-ID: <162315503326133@kroah.com>
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

