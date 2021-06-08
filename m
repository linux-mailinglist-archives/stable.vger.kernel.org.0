Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF67D39F850
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhFHOCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:02:41 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:34971 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232675AbhFHOCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:02:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 4BE2218DE;
        Tue,  8 Jun 2021 10:00:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Jun 2021 10:00:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yGgerx
        pNyzuu0Cm5xrem4m/pJ1teUnac6mKKhOBxxjs=; b=nx3StpVrZHFKP1zLdE2ZJf
        2P0q45vshTT2IAKl/E1g29XxBSa2gCea+Aa5E4dOmamsZKtnukxPFuxAjSvGG4aR
        OcrUr99YV32zOWbKeYHXDtTXfJ1BisBdu2gZ+notK3HIVVchSN0wwuD8N5KymMaf
        88VwutgYY5ZksnzjZO+DLL93oIVH4+qy/yCm49dwTS2JSYvlIlB9cqvr9mYUWy8a
        /KeGsO3rPxivWlKm9/+Nv26BJlq6rbh+HMbDyb2goAtG50PM68SfYLWurWOYcHc8
        GvxdUF+G80l5/NVnHsyRaUMC06EMEGg6028f44RwoDvmodGSDEtFZYI246UzQQtw
        ==
X-ME-Sender: <xms:D3i_YGnYdJfC2SteXvRkTIgfb4xHIrtHkHbC2oX_Ice1lcNklSPU0Q>
    <xme:D3i_YN2W8E1KtiSCQhCtRWc7wigX5VGZoV_MD2F0OfTKnFaN9HZYOmk7DYtEG5-6n
    2nyuaaxhbLo2w>
X-ME-Received: <xmr:D3i_YEoiFwimrWDELqLvX-A2A1lImNVxLHDuBIyO9dKVPWxORfDzuc1OinQ6w8Aessx5l8qGXOU79OjfX18vPy74VKOWCZfm>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:D3i_YKmBw0fFsoo6VLNMIORvLNHg6xol9fFy7VmSJx0jgBJ0y6PPmA>
    <xmx:D3i_YE3Py4bjJfIjzTJoj5q28zBujmt8Ahk6rjuA4zwl-zf1HXz_GA>
    <xmx:D3i_YBsO6eJZ2grWfHlaXv7nCeRtyzqIumO2e1m4KOgkeXWo9A7pdg>
    <xmx:D3i_YBz8XLRwDwUeUR2vEzB4OrgHGEbsA8WwuqKOEaLUIblu5lhcXU2rWHc>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:00:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: check error value from btrfs_update_inode in tree log" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 16:00:44 +0200
Message-ID: <1623160844251152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f96d44743a44e3332f75d23d2075bb8270900e1d Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 19 May 2021 11:26:25 -0400
Subject: [PATCH] btrfs: check error value from btrfs_update_inode in tree log

Error injection testing uncovered a case where we ended up with invalid
link counts on an inode.  This happened because we failed to notice an
error when updating the inode while replaying the tree log, and
committed the transaction with an invalid file system.

Fix this by checking the return value of btrfs_update_inode.  This
resolved the link count errors I was seeing, and we already properly
handle passing up the error values in these paths.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 375c4642f480..e4820e88cba0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1574,7 +1574,9 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			if (ret)
 				goto out;
 
-			btrfs_update_inode(trans, root, BTRFS_I(inode));
+			ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
+			if (ret)
+				goto out;
 		}
 
 		ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
@@ -1749,7 +1751,9 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 
 	if (nlink != inode->i_nlink) {
 		set_nlink(inode, nlink);
-		btrfs_update_inode(trans, root, BTRFS_I(inode));
+		ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
+		if (ret)
+			goto out;
 	}
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 

