Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6398A2E355C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgL1JRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:17:04 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42707 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbgL1JRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:17:04 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 45D3E18A;
        Mon, 28 Dec 2020 04:16:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:16:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OQhzQb
        l7GwfnsZrN3qW8iiXRUeb4zCsQODWxaLfGI6c=; b=FreKHzlrBdzf7iCiRIyqKu
        N5AtsFrwJaX3GoDtZ1j66A9KJM9Tny9L00whhFpknVS8Nf5f89W7KTP0u+P4VOb+
        7Te8uoFnzlUqdkaurwX113YFtuPBxq9DawSRnLC63RHbBQzAD1k8LtalcqNPV+fZ
        Vd8MDUbL3XNylWJFl8OdUs3LYNpQuvWpgHaLVa6UvCRlwtS+bOevlfcPvwlupU2W
        sVaEUGRkSpFDnujeQCLYc1dDxaKpnFIzMaShAHQIsUuN/NMOGN8fSwkJcqtv2f1x
        Smy6622p27COUXI2nOEJUaoWdCGSsjT5Ng37rc0g5h2z20bSWdCg1AM5wQWMhkQg
        ==
X-ME-Sender: <xms:YaLpX6VICUXPHpcnso3s7J0R55w0vkvCKB4BJGT3Rd9-mioWBGjtpA>
    <xme:YaLpX2lIShKVicUArOi0P_64bzvLov9zbcb32m54TTDvo2_XaL_7V3PaLNCZedV1-
    fTgWOxRtxDAlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:YaLpX-aC20yB5lICkWqyf04i777A5AlcijGft7hSPyE7oMGy5kyU_A>
    <xmx:YaLpXxXM_FWnnfV7l63ycyjJzRcGL16d2lzW_WObiLQ2ltnJUMbh7Q>
    <xmx:YaLpX0mHnVGf8ryHzXqwb1nzDMOHuAtybEHYDoCBWrjCe5Am1mCRQw>
    <xmx:YaLpXwtlt72mMT82ZT3uB_su-KxFUOAuf7LP9iQaJ1t3-GDU29aYJfXjOfQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0BADC108005B;
        Mon, 28 Dec 2020 04:16:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: don't remount read-only with errors=continue on reboot" failed to apply to 5.4-stable tree
To:     jack@suse.cz, adilger@dilger.ca, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:17:25 +0100
Message-ID: <1609147045182133@kroah.com>
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

