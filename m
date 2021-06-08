Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E8F39F696
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhFHM2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:28:45 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:47757 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232590AbhFHM2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:28:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B3CD91D0D;
        Tue,  8 Jun 2021 08:26:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Jun 2021 08:26:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vZtB57
        lY2smm0LElprDzE6THczvq2cqTKVwvm+V6M70=; b=YOntDyjMNIyOknnO6KZ/fA
        0tROB9gZX4hkLdetruhkyyqr2o23ja5FnNJtsCapjsa7WBbAA41y7LIYXBlHGc5X
        q6QIv58NpbwRGd9OueG2+QiApipWLilGeuvIPwAefdaTN06EVHUtF6CdcI6Xfr10
        78TYJdRI4wH14K0o89A1JCc+/zRw8FJ8ztDVD8UL6aGE55IFcCv/l6zfft2FMTkv
        k8wsQzd//mYIwWS6POLeFjtS3jkzJFl90sAtgg7vvxCKWk3fRIeswJDItEW5UiUr
        3UieSg3WOANffwMqvP1cZz1VpmKKxr6GUJl8kgAPKY7U+wyP9Go5q/oV5Gu6sz5A
        ==
X-ME-Sender: <xms:C2K_YOUlpgDGkz1_4yAe5sXUpZ_o2-2V2Ks4C-nxuDgiXkEAt7XGrw>
    <xme:C2K_YKn821nRoEuU0CsLAjKLnxk-SWgpOVRsvLBgnG2Q6MJz_CjRGAPQ6qMA6USUe
    NXgGCcyVhvF-w>
X-ME-Received: <xmr:C2K_YCbC1ljwaDb1lqHmqPTNZNAE20INC_alxCHXcWdPV3BOMzcwimpz1VfVx7E7xNI1HkqFPUp6yQXwUSPLNaK9lOubzd1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:C2K_YFU6yvmVdC8fAW6YQK9fbozNRhSsP66dKvecxsMBicQh0dPI8A>
    <xmx:C2K_YIn4IsRE0xyh36yL1utEhXtGD0pjuRXhLxEY1SRTnvy3M_cEHA>
    <xmx:C2K_YKeEYVvnHQyMzFtaQnVawxUvqWsqD3Ic-3TXXwyD5IKKysPPHw>
    <xmx:C2K_YEtb7CFmh2k8hzuBuZKUaph0rEOdM08rBRrpMV4aCFRsGzPs8XfOElI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:26:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix memory leak in ext4_mb_init_backend on error path." failed to apply to 4.4-stable tree
To:     phil@philpotter.co.uk, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 14:26:33 +0200
Message-ID: <1623155193206104@kroah.com>
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

From a8867f4e3809050571c98de7a2d465aff5e4daf5 Mon Sep 17 00:00:00 2001
From: Phillip Potter <phil@philpotter.co.uk>
Date: Mon, 12 Apr 2021 08:38:37 +0100
Subject: [PATCH] ext4: fix memory leak in ext4_mb_init_backend on error path.

Fix a memory leak discovered by syzbot when a file system is corrupted
with an illegally large s_log_groups_per_flex.

Reported-by: syzbot+aa12d6106ea4ca1b6aae@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20210412073837.1686-1-phil@philpotter.co.uk
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3239e6669e84..c2c22c2baac0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3217,7 +3217,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		 */
 		if (sbi->s_es->s_log_groups_per_flex >= 32) {
 			ext4_msg(sb, KERN_ERR, "too many log groups per flexible block group");
-			goto err_freesgi;
+			goto err_freebuddy;
 		}
 		sbi->s_mb_prefetch = min_t(uint, 1 << sbi->s_es->s_log_groups_per_flex,
 			BLK_MAX_SEGMENT_SIZE >> (sb->s_blocksize_bits - 9));

