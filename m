Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA68139F693
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhFHM2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:28:37 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:54885 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232544AbhFHM2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:28:36 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 13A071CD3;
        Tue,  8 Jun 2021 08:26:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 08 Jun 2021 08:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=d7XmUH
        0l3w/EyQEPtLbAam0TxofmE0g4t+cREp6P5o4=; b=Jpyvh5upgnvItrtkljC5pT
        rVL1WwPBvMYZQe+AM/L5TcEcShI1T9/zexm7mAsbV5TMtikJ6WtgE9kX7o+U1Kdf
        ZQWfNydXEQsOfV2a2i9JlHKbo0EN6W5HcWxd31/zLiyXbVrYQjHpw/e9Grj2W2Vl
        xNRp/g2hbjL7b8AlxvGhkbtIZoMd2wlrPPUFPD1SAEdbkX3Rg1vt7g+BW3K/oly9
        CLtlWkU3ozYz8xHiPsFoDAubq864/CSFFNfuWaCtht91AS2A1EohvilyVd9l8RRu
        35+ToAEdcHgOk3AHalt0pJl0XteUoabLkHnJ0mwnEsokYR+6mmGJc2iB/hT43/KA
        ==
X-ME-Sender: <xms:AmK_YMvfBo-SIG8tS5JclcVRAMnpZtC1hJqRyNDp6YLLojIH0iLKEg>
    <xme:AmK_YJfHF7TXZxQRJNKGibM2c__6c5atsbAJHl_7bJRVbBna_xoD7GvMSZnY6Ho6k
    RZOmwrs-0SFAw>
X-ME-Received: <xmr:AmK_YHz9BfT1s5I-I5pg-kmlzz8seqoEMfFEdcHCkRJ9bgpR51lX3ViEi0kUWKDcBj4EONBQEb57RTHhIELI3ZQY2Meoxvf9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:AmK_YPPBfcObnnx8uhcPyr2UuApM4UFTt2zO0b-J5DSzKXWmhLRWfg>
    <xmx:AmK_YM-qE_v52Ub48AtgyxM_xVkAhQRmbOzBKZPb3C6HPlDWeZ74qQ>
    <xmx:AmK_YHVQkAzoSp4x0CHRTbhzezqYtC7nGuwdFcyjxM4WxJtSUobHmg>
    <xmx:AmK_YKn4IV-QixYBf5RlzC0WlVOHpNj5KZzZ2DUd53Hp6NWs2K1407R4AQA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:26:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix memory leak in ext4_mb_init_backend on error path." failed to apply to 4.14-stable tree
To:     phil@philpotter.co.uk, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 14:26:32 +0200
Message-ID: <1623155192116221@kroah.com>
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

