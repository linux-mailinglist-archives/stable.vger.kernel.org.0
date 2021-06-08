Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B7B39F692
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhFHM22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:28:28 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:37737 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232598AbhFHM21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:28:27 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 3E8B61D0E;
        Tue,  8 Jun 2021 08:26:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 08 Jun 2021 08:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2UFwjv
        rrdwC8VLGvYsIzLJiVCdsXS0p7H/oydi5tpks=; b=s/vLh9FBU5wfXRC5MiZ15g
        N1l18uXhPTmi661AhUJariQlyXRcko2NUSaXP0JSS8CSpcAZ7Nmf/V0hljKEBoo0
        dU3uOanJR4QdPJKLt0jgFmg4I0smg5kn1ozf62puQiVzlvCU2xMeCPuCJOBK6I3x
        7OctU0PwDfwm4vyCRotAGqpjWwk2C6pA2pHO6KeCzcnIa2G/hESeMOF/FKPeaZX7
        0yFW3Q5+wSWD02oL90aP74i+5quvT5eBSG+OsQuEyIBbY1Np5t724Fbne4euwhml
        RnEauWK6OhJ18nCycD768KTGY7O95by08sUgIUS+SYraUJ2Y3HwEg918dt6o7JPg
        ==
X-ME-Sender: <xms:-WG_YD2XIw3H5aRHpRPF-sosAvCDt1EEfIdbaFXexFZ5zheuy0LJOg>
    <xme:-WG_YCFPOiye8qvr2iLEHjx2H4j7aTiQipe7IN8DF_s3sQqk21qQGLOqT0qXKHfWU
    cNQh445PsmZzw>
X-ME-Received: <xmr:-WG_YD6vt7_JWGAbXYIsN2lWbia-TW7FCFPx2vGZi3ImyWbumdysczy-s5KzooUYjSFjU-zDwCrZUa20PM3R_ZgpfUkW7MDr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:-WG_YI29sj5rP8i9c5jXR4yN5mgj02ESdlNb0hiEjP_WVwzo0xFgkw>
    <xmx:-WG_YGEnp4jKLuwMihOhmcegeu7O4tRHsba-pdQZptfgIMf47A2fFQ>
    <xmx:-WG_YJ-G30hIdn3nTlWa_gJjOafMHjBMr-QNddfk98N8mYzbAZt5pg>
    <xmx:-WG_YIMNfSyEKJA9Viyo0UeL6pDWDUc34TyDgxlmbZS5w5ajH6CPWbEEty8>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:26:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix memory leak in ext4_mb_init_backend on error path." failed to apply to 5.4-stable tree
To:     phil@philpotter.co.uk, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 14:26:31 +0200
Message-ID: <162315519116094@kroah.com>
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

