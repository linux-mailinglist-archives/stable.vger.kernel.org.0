Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F99B39F85D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhFHODd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:03:33 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:53915 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233120AbhFHODc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:03:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2DCB71A40;
        Tue,  8 Jun 2021 10:01:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Jun 2021 10:01:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O1CnW+
        5yicYmXpVIpzLXP2CEn1XrOtn6l66/gGOlvmE=; b=WWDBQjK2DLsWY5QV7c1f+S
        5CQfcQf5Yqfi3fEoqNwceXO3wVzVtgQZljUhcyi2smb0svY6Fy3p+LVp8iKkY9Ut
        mMd7a6vhZoh8Ah04+iC+MxuQZUFAGAveRTbGwWPaUs4wGMUcKsg3+k0vf4WEzNYT
        9qdazwHvywVbqT2k3ofFV60UD/08pW+xBShXtdaL3+0n3G/iYncR66EMoOexzZ0C
        3guDN/IziSNWZmZG+ip1H0doWEEXuFDSSo+cGRYnLjGwaT4U9aCkms06oEPOEp2T
        N9ARtODaBmHoGFkG1e/xBw2byG3kFGXDRlHFHE+QvnMkLmVCfMNPVwCGcVlQo2xQ
        ==
X-ME-Sender: <xms:Qni_YAqiX-qTqlls8DPUQs_ykjkT1aDpD6SmkC60pnK6ZFDT7-nsFA>
    <xme:Qni_YGoWewvSc9VLqAcuYYFC5noCZFtH5ULem-9yo7XFKhR0E4MRq8rnsTa3Sx5hJ
    i1MMG0n2ZfaAA>
X-ME-Received: <xmr:Qni_YFMfpAZV-z624djAutV_BvopclYmDiFlZwknagA0iJ1j3AQox26g5kaQUQKePG02uJN-b_MWYCzyQxNNmc1EhldSo7SO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Qni_YH5UbWe6J1XYlSe4lTpyURYni04MA6wX1pgngrl-4l6mqhzunQ>
    <xmx:Qni_YP7x4aeLT6gbE_bLaVbfbcFvT-zrTOqYlQ6xmMoh_NqWdf0Z6A>
    <xmx:Qni_YHjZrFVsfAvjeIo5Mg1OKEDgtQBZO8hkv23rCtiaovjSWG3Kjg>
    <xmx:Qni_YJQxH9AiNuYe0uRpAgKw1UXpCRIlf10a7cKF9RxNzQngu6BvytQ0Z58>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:01:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: abort in rename_exchange if we fail to insert the" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 16:01:28 +0200
Message-ID: <16231608886613@kroah.com>
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

