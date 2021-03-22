Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AD3343D18
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhCVJlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:41:23 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:38247 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230070AbhCVJlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 05:41:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 38BB1F07;
        Mon, 22 Mar 2021 05:41:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 22 Mar 2021 05:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XGm0ii
        aG7jpnUD3GQrkoRrLbwveGM0XULEpGuysp6QE=; b=DoddwXJUnN2sRND9Lmi2Uy
        rfsQ2rPwUPBAcWSgYHdHbCSJUc2T+UY54Q39qukYEw4T3BbrPvwu+taF1iQfFJ00
        APr6zAM4O3fq2b4+WTu0lM0lhvfbydCAWW3a84wP9da2Wd/heVekX25eXCHV6nuN
        d5D40x/iFJGIU16JENxohrruWdB2pIyRwuFeHY9fUAYhkKNQS6mlZ1delQXc3jgQ
        oSHmc4haucNvyph9fJBIJCPHuDw5Dt/CUufK4fQQC2pbtooSXHJKcxfWtDXVI09i
        eerFdAGBfOESQDM6EYSp1qvRovNOreh7tiD3Ziv0YH8oWW9rbjW9n0Yty3IuVYDw
        ==
X-ME-Sender: <xms:NGZYYI2xyBXzWVBTyq4ZFQpiBDWWaO1TOY8-yjnEGotttBVs9We6iw>
    <xme:NGZYYDFj6tH7HkFo5N-RzbzinbWKH9jl6QQdCpsoEDLW08xO2CxJHenAavY1kDppk
    oVW3jSB8YjmVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NGZYYA6adtxcefLWLo36aQqFMJlYp1VieJ6Mjo3k3AHuofccw5pWBA>
    <xmx:NGZYYB2Ys9rybSGU8PY8ODWBXaRzpsgybjHJb3im72DnIoCH0N4Alw>
    <xmx:NGZYYLGWIRarm5dC0M0uuLmhiz1EsIsRNzHb2JW39x-kK9N_qOJlZw>
    <xmx:NGZYYBOqKNc6DDOBXG5L-eHvzK6VnEhgkzX_iG3rpqf4hTh-TqUa-c-RXbk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EBA5924041F;
        Mon, 22 Mar 2021 05:41:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix error handling in ext4_end_enable_verity()" failed to apply to 5.4-stable tree
To:     ebiggers@google.com, heyunlei@hihonor.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Mar 2021 10:41:05 +0100
Message-ID: <1616406065253138@kroah.com>
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

From f053cf7aa66cd9d592b0fc967f4d887c2abff1b7 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 2 Mar 2021 12:04:19 -0800
Subject: [PATCH] ext4: fix error handling in ext4_end_enable_verity()

ext4 didn't properly clean up if verity failed to be enabled on a file:

- It left verity metadata (pages past EOF) in the page cache, which
  would be exposed to userspace if the file was later extended.

- It didn't truncate the verity metadata at all (either from cache or
  from disk) if an error occurred while setting the verity bit.

Fix these bugs by adding a call to truncate_inode_pages() and ensuring
that we truncate the verity metadata (both from cache and from disk) in
all error paths.  Also rework the code to cleanly separate the success
path from the error paths, which makes it much easier to understand.

Reported-by: Yunlei He <heyunlei@hihonor.com>
Fixes: c93d8f885809 ("ext4: add basic fs-verity support")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20210302200420.137977-2-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 5b7ba8f71153..00e3cbde472e 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -201,55 +201,76 @@ static int ext4_end_enable_verity(struct file *filp, const void *desc,
 	struct inode *inode = file_inode(filp);
 	const int credits = 2; /* superblock and inode for ext4_orphan_del() */
 	handle_t *handle;
+	struct ext4_iloc iloc;
 	int err = 0;
-	int err2;
 
-	if (desc != NULL) {
-		/* Succeeded; write the verity descriptor. */
-		err = ext4_write_verity_descriptor(inode, desc, desc_size,
-						   merkle_tree_size);
-
-		/* Write all pages before clearing VERITY_IN_PROGRESS. */
-		if (!err)
-			err = filemap_write_and_wait(inode->i_mapping);
-	}
+	/*
+	 * If an error already occurred (which fs/verity/ signals by passing
+	 * desc == NULL), then only clean-up is needed.
+	 */
+	if (desc == NULL)
+		goto cleanup;
 
-	/* If we failed, truncate anything we wrote past i_size. */
-	if (desc == NULL || err)
-		ext4_truncate(inode);
+	/* Append the verity descriptor. */
+	err = ext4_write_verity_descriptor(inode, desc, desc_size,
+					   merkle_tree_size);
+	if (err)
+		goto cleanup;
 
 	/*
-	 * We must always clean up by clearing EXT4_STATE_VERITY_IN_PROGRESS and
-	 * deleting the inode from the orphan list, even if something failed.
-	 * If everything succeeded, we'll also set the verity bit in the same
-	 * transaction.
+	 * Write all pages (both data and verity metadata).  Note that this must
+	 * happen before clearing EXT4_STATE_VERITY_IN_PROGRESS; otherwise pages
+	 * beyond i_size won't be written properly.  For crash consistency, this
+	 * also must happen before the verity inode flag gets persisted.
 	 */
+	err = filemap_write_and_wait(inode->i_mapping);
+	if (err)
+		goto cleanup;
 
-	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
+	/*
+	 * Finally, set the verity inode flag and remove the inode from the
+	 * orphan list (in a single transaction).
+	 */
 
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, credits);
 	if (IS_ERR(handle)) {
-		ext4_orphan_del(NULL, inode);
-		return PTR_ERR(handle);
+		err = PTR_ERR(handle);
+		goto cleanup;
 	}
 
-	err2 = ext4_orphan_del(handle, inode);
-	if (err2)
-		goto out_stop;
+	err = ext4_orphan_del(handle, inode);
+	if (err)
+		goto stop_and_cleanup;
 
-	if (desc != NULL && !err) {
-		struct ext4_iloc iloc;
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (err)
+		goto stop_and_cleanup;
 
-		err = ext4_reserve_inode_write(handle, inode, &iloc);
-		if (err)
-			goto out_stop;
-		ext4_set_inode_flag(inode, EXT4_INODE_VERITY);
-		ext4_set_inode_flags(inode, false);
-		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
-	}
-out_stop:
+	ext4_set_inode_flag(inode, EXT4_INODE_VERITY);
+	ext4_set_inode_flags(inode, false);
+	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+	if (err)
+		goto stop_and_cleanup;
+
+	ext4_journal_stop(handle);
+
+	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
+	return 0;
+
+stop_and_cleanup:
 	ext4_journal_stop(handle);
-	return err ?: err2;
+cleanup:
+	/*
+	 * Verity failed to be enabled, so clean up by truncating any verity
+	 * metadata that was written beyond i_size (both from cache and from
+	 * disk), removing the inode from the orphan list (if it wasn't done
+	 * already), and clearing EXT4_STATE_VERITY_IN_PROGRESS.
+	 */
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	ext4_truncate(inode);
+	ext4_orphan_del(NULL, inode);
+	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
+	return err;
 }
 
 static int ext4_get_verity_descriptor_location(struct inode *inode,

