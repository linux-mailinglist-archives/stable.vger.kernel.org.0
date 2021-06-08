Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F7139F85F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhFHODj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:03:39 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:59875 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233089AbhFHODi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:03:38 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 61BE21A33;
        Tue,  8 Jun 2021 10:01:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 08 Jun 2021 10:01:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=LB5vwd
        j3bCrn127gHkL7NrbyA5mh6scqDjRewr2PAYs=; b=S+Jrf99QdKgAIZ6bZocsuh
        i37fAnRb5obfPpjSDht1kC6UCD5FsY57yhoO6p0MQtkLlCyLLd+QWtLUq353zXYS
        tuGprlJ8FNtJRGyRomizK6gzkfEJPo5IVeqUT6n7bJ384X26guhg/zYd/yo1gKpp
        0cZnoGEdApEfYTWo+af3Q+zC+uS4jFTXCvM5vnnClOP6sx7BD9KxqUGVj3XGZu/v
        JCOVaTA+NjeFluq+B/WsKsC+u9gXdMTnDb5u/5fqj0PCoqF9qZk91T4YoyQyuecc
        hMfVn5kdXhMHGovGwVXCDUbKv0qyeXBJVCAJCPeD8oix7ihLdFrFSmMjNrkJYMxQ
        ==
X-ME-Sender: <xms:SHi_YN1PLWgVo5ebszlsjXyaNfD2sYVUM8BQ_b4-RdYeCQ8hDZEiWg>
    <xme:SHi_YEGrvZ6bFH7G_L1QmH-7vNKPtcp-mBOa23BCrKPH9qf-6w5HUDlXOehNFxHyk
    AvkaIpSHRrRQg>
X-ME-Received: <xmr:SHi_YN6o6jMIAj1xj6sXgcsYhYX5cKx01uZEjGpBX2miitGBLlKFxR0mQIgoP21Tepd3OJ2-CL4MFmtcXvZBAiJ0C0Z_wyuh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:SHi_YK3GLGTLk3gTd5NX7gP3pYtxCjjtn00GYhxqa7cSN8PwhG6KIQ>
    <xmx:SHi_YAHKT0u5WsVOsuZBaZWk5soQhVHA3nYnXjAWogU9kUKUAkaJdA>
    <xmx:SHi_YL-ESFjZrpimVDYBOYAeRQKO8VXaf-zjsT-FRtUrP0hu7q0ViA>
    <xmx:SXi_YKMag_4yhccy0uxZ7-8lvQfaE8kTzp6Dl-p1RPynNGHoSse9CZkO-2E>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:01:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: abort in rename_exchange if we fail to insert the" failed to apply to 4.19-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 16:01:29 +0200
Message-ID: <1623160889182219@kroah.com>
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

From dc09ef3562726cd520c8338c1640872a60187af5 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 19 May 2021 14:04:21 -0400
Subject: [PATCH] btrfs: abort in rename_exchange if we fail to insert the
 second ref

Error injection stress uncovered a problem where we'd leave a dangling
inode ref if we failed during a rename_exchange.  This happens because
we insert the inode ref for one side of the rename, and then for the
other side.  If this second inode ref insert fails we'll leave the first
one dangling and leave a corrupt file system behind.  Fix this by
aborting if we did the insert for the first inode ref.

CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e7de0c08b981..f5d32d85247a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9101,6 +9101,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	int ret2;
 	bool root_log_pinned = false;
 	bool dest_log_pinned = false;
+	bool need_abort = false;
 
 	/* we only allow rename subvolume link between subvolumes */
 	if (old_ino != BTRFS_FIRST_FREE_OBJECTID && root != dest)
@@ -9160,6 +9161,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 					     old_idx);
 		if (ret)
 			goto out_fail;
+		need_abort = true;
 	}
 
 	/* And now for the dest. */
@@ -9175,8 +9177,11 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 					     new_ino,
 					     btrfs_ino(BTRFS_I(old_dir)),
 					     new_idx);
-		if (ret)
+		if (ret) {
+			if (need_abort)
+				btrfs_abort_transaction(trans, ret);
 			goto out_fail;
+		}
 	}
 
 	/* Update inode version and ctime/mtime. */

