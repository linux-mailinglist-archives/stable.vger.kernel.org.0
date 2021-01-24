Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46B6301C28
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbhAXNXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:23:44 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:42205 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbhAXNXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:23:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 61920EB1;
        Sun, 24 Jan 2021 08:23:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:23:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=M/rNLF
        iOuaQK3chHm5a5jPicgyAEx2LHJQTsyiM3MyM=; b=hy9ZYAeUl35aAvBrL0g5dw
        HOjCiu9oEXGF5rrC4M1edE1P6Pl1yOFCb7cyBlO6trtrt80WDYVBUotu//ZJ/VW2
        r3WvYTnHUvtGDl/h/GkbS0ajCJ4k98R8K4CrvwPd6Ob5KKlWYT13214uXVbzy/Xe
        4lCOFQHidIQCY4spIhi3NzR0iEFgLyRh7tlWRcxZwx0poRVlm6y3W8E4rtms7Z0j
        DTypLGESIk+3RCzRcVDm0xKW7D5BObRvUcHl2CtvZmPFYwBCUWJLuVMx1hCBy+XX
        sBkhXxZfjZSA1lVNBSvkugz028A4zjyQtZoELYcy9EdBpsUXHlNGfWpo/isph0Ig
        ==
X-ME-Sender: <xms:tHQNYI2EWZ45w-tAClHwpK_PHEQvBReBdkYTGCUvUxXQNOuWz6P0dA>
    <xme:tHQNYDE6JpmVZbxKriEMzL-5lyapDeLYkzh_jPD7uZX7DJf02SgFbufHorgksIwzd
    Ujj4x-haaHckA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tHQNYA4lG6gRumzekgpdY5YhLz3vHGpLL2w2YsX0PFrpzmm2jPzRjw>
    <xmx:tHQNYB3HpIjd3lK9NAyb0yeZKuoXayPx7wwmtWQ93_v3-sD84Xbk_A>
    <xmx:tHQNYLGZDCqjEZKbS3W_PrLz4RyIJMWmnwnna3atpC_f7Z2uWOM8Ow>
    <xmx:tXQNYBO5cNqKTJA384e4uciLM_ySMQFwbD4_VkUXnNBd0j2OVAb1eF3Uv1s>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A0E1024005E;
        Sun, 24 Jan 2021 08:23:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] fs: fix lazytime expiration handling in" failed to apply to 4.14-stable tree
To:     ebiggers@google.com, hch@lst.de, jack@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:22:57 +0100
Message-ID: <1611494577227185@kroah.com>
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

From 1e249cb5b7fc09ff216aa5a12f6c302e434e88f9 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 12 Jan 2021 11:02:43 -0800
Subject: [PATCH] fs: fix lazytime expiration handling in
 __writeback_single_inode()

When lazytime is enabled and an inode is being written due to its
in-memory updated timestamps having expired, either due to a sync() or
syncfs() system call or due to dirtytime_expire_interval having elapsed,
the VFS needs to inform the filesystem so that the filesystem can copy
the inode's timestamps out to the on-disk data structures.

This is done by __writeback_single_inode() calling
mark_inode_dirty_sync(), which then calls ->dirty_inode(I_DIRTY_SYNC).

However, this occurs after __writeback_single_inode() has already
cleared the dirty flags from ->i_state.  This causes two bugs:

- mark_inode_dirty_sync() redirties the inode, causing it to remain
  dirty.  This wastefully causes the inode to be written twice.  But
  more importantly, it breaks cases where sync_filesystem() is expected
  to clean dirty inodes.  This includes the FS_IOC_REMOVE_ENCRYPTION_KEY
  ioctl (as reported at
  https://lore.kernel.org/r/20200306004555.GB225345@gmail.com), as well
  as possibly filesystem freezing (freeze_super()).

- Since ->i_state doesn't contain I_DIRTY_TIME when ->dirty_inode() is
  called from __writeback_single_inode() for lazytime expiration,
  xfs_fs_dirty_inode() ignores the notification.  (XFS only cares about
  lazytime expirations, and it assumes that i_state will contain
  I_DIRTY_TIME during those.)  Therefore, lazy timestamps aren't
  persisted by sync(), syncfs(), or dirtytime_expire_interval on XFS.

Fix this by moving the call to mark_inode_dirty_sync() to earlier in
__writeback_single_inode(), before the dirty flags are cleared from
i_state.  This makes filesystems be properly notified of the timestamp
expiration, and it avoids incorrectly redirtying the inode.

This fixes xfstest generic/580 (which tests
FS_IOC_REMOVE_ENCRYPTION_KEY) when run on ext4 or f2fs with lazytime
enabled.  It also fixes the new lazytime xfstest I've proposed, which
reproduces the above-mentioned XFS bug
(https://lore.kernel.org/r/20210105005818.92978-1-ebiggers@kernel.org).

Alternatively, we could call ->dirty_inode(I_DIRTY_SYNC) directly.  But
due to the introduction of I_SYNC_QUEUED, mark_inode_dirty_sync() is the
right thing to do because mark_inode_dirty_sync() now knows not to move
the inode to a writeback list if it is currently queued for sync.

Fixes: 0ae45f63d4ef ("vfs: add support for a lazytime mount option")
Cc: stable@vger.kernel.org
Depends-on: 5afced3bf281 ("writeback: Avoid skipping inode writeback")
Link: https://lore.kernel.org/r/20210112190253.64307-2-ebiggers@kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index acfb55834af2..c41cb887eb7d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1474,21 +1474,25 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	}
 
 	/*
-	 * Some filesystems may redirty the inode during the writeback
-	 * due to delalloc, clear dirty metadata flags right before
-	 * write_inode()
+	 * If the inode has dirty timestamps and we need to write them, call
+	 * mark_inode_dirty_sync() to notify the filesystem about it and to
+	 * change I_DIRTY_TIME into I_DIRTY_SYNC.
 	 */
-	spin_lock(&inode->i_lock);
-
-	dirty = inode->i_state & I_DIRTY;
 	if ((inode->i_state & I_DIRTY_TIME) &&
-	    ((dirty & I_DIRTY_INODE) ||
-	     wbc->sync_mode == WB_SYNC_ALL || wbc->for_sync ||
+	    (wbc->sync_mode == WB_SYNC_ALL || wbc->for_sync ||
 	     time_after(jiffies, inode->dirtied_time_when +
 			dirtytime_expire_interval * HZ))) {
-		dirty |= I_DIRTY_TIME;
 		trace_writeback_lazytime(inode);
+		mark_inode_dirty_sync(inode);
 	}
+
+	/*
+	 * Some filesystems may redirty the inode during the writeback
+	 * due to delalloc, clear dirty metadata flags right before
+	 * write_inode()
+	 */
+	spin_lock(&inode->i_lock);
+	dirty = inode->i_state & I_DIRTY;
 	inode->i_state &= ~dirty;
 
 	/*
@@ -1509,8 +1513,6 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 
 	spin_unlock(&inode->i_lock);
 
-	if (dirty & I_DIRTY_TIME)
-		mark_inode_dirty_sync(inode);
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & ~I_DIRTY_PAGES) {
 		int err = write_inode(inode, wbc);

