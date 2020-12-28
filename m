Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B81E2E355D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgL1JSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:18:05 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57929 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1JSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:18:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5983F715;
        Mon, 28 Dec 2020 04:16:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:16:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5HkJcj
        mnVBzudvXXO9HZkQ+p/+ati+FH7vMAptcT6yo=; b=gXQKLQ/nEaB9SW9xCUwuRp
        egAcT3nUylKbxSV//+GlyK6Lp/3bf87SWvmjLJze4LP5JbdXB3Vt+CPhSN2tnpoi
        jUIYyyjfZDqjNwrMSnUxuTEsTHF+cTXTeaTKgcEk2dGLhe/NZ1KDhy0URvNl70ML
        5Rz2ro7yPgNazfVeMA0YcN/l6pyJL6Lc5OEJHZJyZL4lT+OjcS7Qg2m5yavGjzDt
        eKbBpRpGEk9sWkdUhzjLttErmpjiBBf3rmnbc5MK9I3jhlGG3rs505TofTl+q6eK
        pX6nXjrdm/0vA1sfge7/mX5l2VNxFUfdiRgvlT4CIYPysvtMiXqFNsoGET9ZKO9w
        ==
X-ME-Sender: <xms:iqLpXz5CAUGgsNvkvwK5ZQXNHtKZshafuTREE9tDo1VvkxfpyTy1aw>
    <xme:iqLpX44EK-xgdKPxDMzxeeFx0m5j6DQ2RpRHPnMt64Y1p5LyiTJmk7glCJslxZ43n
    MGdkkeX-lIoZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iqLpX6fcsILBsgUuT3BRCorNogNfybibhaVMxnu1OPJv4cvnP9q22w>
    <xmx:iqLpX0JpYwyjMJYnHNh5PV12vYkx08Dltrio3xrMb7TJDxrKFp5JSg>
    <xmx:iqLpX3LhABgG7naKGDWYinkch6RvqPkP9TLOM0lENuKyDcMxr62bjQ>
    <xmx:i6LpX9iaEadafy1wBHYO_6724wXy6-6ocmJGGIbMOanRnMBK_t7pCKp8ybg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6306424005C;
        Mon, 28 Dec 2020 04:16:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: don't remount read-only with errors=continue on reboot" failed to apply to 4.19-stable tree
To:     jack@suse.cz, adilger@dilger.ca, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:17:25 +0100
Message-ID: <16091470451704@kroah.com>
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

From b08070eca9e247f60ab39d79b2c25d274750441f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 27 Nov 2020 12:33:54 +0100
Subject: [PATCH] ext4: don't remount read-only with errors=continue on reboot

ext4_handle_error() with errors=continue mount option can accidentally
remount the filesystem read-only when the system is rebooting. Fix that.

Fixes: 1dc1097ff60e ("ext4: avoid panic during forced reboot")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20201127113405.26867-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 872d45a131ca..3ef84e8ab1ae 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -666,19 +666,17 @@ static bool system_going_down(void)
 
 static void ext4_handle_error(struct super_block *sb)
 {
+	journal_t *journal = EXT4_SB(sb)->s_journal;
+
 	if (test_opt(sb, WARN_ON_ERROR))
 		WARN_ON_ONCE(1);
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || test_opt(sb, ERRORS_CONT))
 		return;
 
-	if (!test_opt(sb, ERRORS_CONT)) {
-		journal_t *journal = EXT4_SB(sb)->s_journal;
-
-		ext4_set_mount_flag(sb, EXT4_MF_FS_ABORTED);
-		if (journal)
-			jbd2_journal_abort(journal, -EIO);
-	}
+	ext4_set_mount_flag(sb, EXT4_MF_FS_ABORTED);
+	if (journal)
+		jbd2_journal_abort(journal, -EIO);
 	/*
 	 * We force ERRORS_RO behavior when system is rebooting. Otherwise we
 	 * could panic during 'reboot -f' as the underlying device got already

