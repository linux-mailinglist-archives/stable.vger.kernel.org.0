Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B8F39F694
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhFHM2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:28:39 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:54975 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232544AbhFHM2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:28:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 14A921CED;
        Tue,  8 Jun 2021 08:26:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Jun 2021 08:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3SDfdz
        5Ga8DMsI4G939RtOFEtRximV09+piSUJBJ0ss=; b=iEhWqh17ktsfHtFmHFtBzs
        gVvA1c6ogaR1IkwpxMrUcCKyV5mQa43ADCsjaycemA6mFVugL09BKABTJsBUDbqT
        o4X+TfOXv3MQvi5qfntLMM1cpEAeT4KQ331UYo/QT+WdaX7drHipLWx6ivco1MVh
        v6Po/fNa7R4bHC3nHAVYyJQ+v+Gm7XOD38oRD6cDeRfa/pFDeod+0n9E2QmTRvdU
        nsagoTYrXRDAY0eqQJG5BJmV9S+18sMGea9y2vnj1sGafaQ5EumHva4Dt9/8QjNy
        6OqOmkx9r97iFTva98uU6PKsIKAWsdoH/LN38nmO8s4SizbDts9bNxn21wOFUY9Q
        ==
X-ME-Sender: <xms:BWK_YMmC9y8TvtBW0IALZ7MKM4PIpmRa_RBz-BLpAFAOiBVCLARZrg>
    <xme:BWK_YL1hJfMrQb5mofeygXNRCyJYFFa8Sdn7TMPawYSkRI6OVbJKhLn2nsgMVasyZ
    O4AWtWTgzdHSg>
X-ME-Received: <xmr:BWK_YKrDVhRsf-0soVYH9rsMQ1yap11i8vVwMaDtXVeuYt-ch-GUhrAzAhojDljYNFtLXmkvh5Nh3D2tXj7xWfCpVGoIyQto>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:BWK_YIl3V66NcCNTp5Qe5tCYOM0vwCNxBqqBD2GvSo3c0iX28ZO8rw>
    <xmx:BWK_YK2_Mg27XG8WA4vd46ATsMTblX7cZuUz8IDXNA09fUSXPizp_g>
    <xmx:BWK_YPumM3FVPzM6KJ8pFoCzk6j34oRHwSrff8liRq3SiLbwWBXXoQ>
    <xmx:BWK_YP-KqEXIhQvCQNa7lMVB6siXjjAiNn-Lk0gJu6CduFcibYVCcEgjqiY>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:26:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix memory leak in ext4_mb_init_backend on error path." failed to apply to 4.9-stable tree
To:     phil@philpotter.co.uk, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 14:26:32 +0200
Message-ID: <162315519289177@kroah.com>
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

