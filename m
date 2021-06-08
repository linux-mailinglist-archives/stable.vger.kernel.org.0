Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125EB39F85C
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhFHOD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:03:27 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:38891 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233076AbhFHODY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:03:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 30CDE189B;
        Tue,  8 Jun 2021 10:01:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Jun 2021 10:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=u35gLb
        1cdw3aOcDnrqn8MHuC30AP4WIrMMYmy8WPpWY=; b=weapqI0UpeHhf4Y9o+8AVZ
        lB76wjU8ZZTQPpT+swWBmmHNOfN21k1lefuw7OVEhwYyWp6k75UtMgk8KsrDoClV
        90J1sHtKDLWhYp9JfDS2mmCCu4dKBVkrxemubSr8ZbTEyp20ye4f7izmu2ujOiIa
        rRyJVoYsCowKBo3wcjY0IYBLN5NY8PsquwxhLL7it6pDIZdFrzZHHGQOXON2ZC7v
        jkuH0aNb+WdKu5/FLUeF8w21UptVEpb8D5P343slHfSkgwAb0EHVValZ8mbEYYto
        rL3tpd9SDORROxaSXPrK+onc2C5im2+dbOUBqoig1zbvu2s23gRwSh5dQzta2RfQ
        ==
X-ME-Sender: <xms:Oni_YE-Hygx-xVDNTixxOijdy4rbNa7KuR49nA-kPsve1-N_bSM1dQ>
    <xme:Oni_YMuylu6IUf_NWTPnmtD2OzS2Yw4pEmitpZIkvy-isIpv29x1EiH9R8J2g-rz5
    34XK9lfbOC_wA>
X-ME-Received: <xmr:Oni_YKDaUM-KmEWGQODT5FI6xgVDD2RYwhCwVkVks1OMK56S7y5XHnT-gG72ag3Ldvx-S-DRCOpnAOZug_cd-a-fErHxH1FK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Oni_YEdCPHrO-QUMal0quBhxoD66IlTOPOE56XPxwXDGxXkwdGwoCw>
    <xmx:Oni_YJPG6xbI0NX9Gu6eAPvU72PytjwLo7khxe_lsShzyW2Ey45e4Q>
    <xmx:Oni_YOk6NqGf9hQ7eISUMo7Q_7yA0Gk17CP_O3bvB_hlaOOQX4QfVQ>
    <xmx:Oni_YH2viPe-4NCktJys24G5hNQhM_7wdr0iW9L3F6r_qIJXrEb1JL1auvI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:01:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: abort in rename_exchange if we fail to insert the" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 16:01:27 +0200
Message-ID: <1623160887238119@kroah.com>
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

