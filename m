Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B7539F85E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhFHODi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:03:38 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:43121 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233168AbhFHODg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:03:36 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 6C6921769;
        Tue,  8 Jun 2021 10:01:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 08 Jun 2021 10:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wW1NX7
        BNgDFFU02X5VF6k5mRfj3mJU7UDNWGm/+jIwY=; b=Kp0c9AoeOzWjIPrG0zIpLR
        inUuFHPDyRdb2HoJveCOstuIX0f3pePAQHMHaQwi3KRAyD6CVJtIDy/zfAiDzBqJ
        C+hYZMupOuGy8fD25wnXbF8isa8WmOCJstC3eOXKwoGaO5I3FLKZkGWXBBQL9uLb
        tkjpSwOrKfpChQguNjwe4vqg9cXm8wWoWs9GasIuUQClm9FTKtN34hX1Ec+VDbpJ
        QwgMt1fRvY6OxoVdsuu8vIZsP8mSmLmX03fIOAnLXwZr/fzVl5AfaYszzi1WsefL
        at/2ShmjgUGRr5NcMTywbB4TIqJAj0lxCf3t7UL3x34mRNA77u6ShE9eL4DDmxxA
        ==
X-ME-Sender: <xms:RXi_YHtxn1JB5Gu6N-YHhhM3Rwv3z6Qcc1IJrEN4ySYCR2_xgZrjAg>
    <xme:RXi_YIfvMf3Y7L6Ew3l_p4nLQIAgYZVSyQSh2ZC-Ou9y7UuPwg6g0Anxh6RSD04dr
    cV3RWKQDE2GRw>
X-ME-Received: <xmr:RXi_YKyeSoV9-YcFxupBSrgmbq2VhbkwHTQfs7Li2VH_cEXRb1_kUQ5Nh6zHoThNYVsEURhAwML3CkyTq7Q7xadDXlCfehvc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:RXi_YGODx35i7N-s5MToxkUzaX_6NVn4KhNCA0JSpNAjY7AdK55vaA>
    <xmx:RXi_YH-nhXChKXrSfxf9EVFsdFHtqsEN_FhlVmRs1oNV7lM0wZZr5A>
    <xmx:RXi_YGUHXwnMSQ67wG0ye6lPwQJ-Q6dVEgMADspHrjKgWUN2I4gWYg>
    <xmx:Rni_YBl4-Ne2S2oTYZ4FAzLpqPA_vNHM_gogOHM7u5lqlyJxx_Z95yAckvc>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:01:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: abort in rename_exchange if we fail to insert the" failed to apply to 5.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 16:01:29 +0200
Message-ID: <16231608894299@kroah.com>
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

