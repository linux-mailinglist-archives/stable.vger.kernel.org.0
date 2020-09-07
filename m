Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A415325FE26
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgIGQIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:08:44 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:56577 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729941AbgIGQIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 12:08:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 9C371AF7;
        Mon,  7 Sep 2020 12:08:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 07 Sep 2020 12:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+grir8
        nQ+h5/xB26L/AHXwdJiXkiI9J2WXY8EGL0NV8=; b=kEkhbSE4GBDGs+xGtVpvTR
        iL7gaZyC0rF6K6ZnT+9mHw4vLvPCNBhuhsQm11UEzydYTURXJE6R8dmcPB0srCLG
        sx4D5+GvPh8m8MVBdT+8NN7NipDw2Pm5D7rKwbgr0Vh/yU6AStebo3FKMuUm6t9b
        K67MZ+0akS2Mrlm8rskd/e8QYpVSQGXJrR/LgdGQTzg5BWwdZiuDRsayC+mq6FGG
        YR+7SwzyIjc5XYHY8WJ0kh26yymit2f/Ip5pEBVQ2PCyzHTU6HhHQbnA1nuqX/EH
        eVkrKQCYKaIQhTUYmtJAVJhJg+QixRvU3BsfKOS+YZVGhMsXb/GsC1FTDt4sOEIQ
        ==
X-ME-Sender: <xms:AVtWX6kwo9zViKdKCo0qKDXb0Kh8uCslFY6nr2eEZXXR-nZ5VLe0Aw>
    <xme:AVtWXx2q9UAAkKfrDLcq0KPl6bTe0lYs6bur_V4S5dt5ylWVhru3Nr14lSmtXcMzT
    Xh6nAWr1BPJAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehtddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:AVtWX4rUi09ShXYD-axbHbPSTyNT_0e9mc2dV_pzxdn-j4Pk-kGAqA>
    <xmx:AVtWX-nmmF8ygXeTG-UvgIJVzcSPdRfxKdGM58O1e6wgndakSAbVuA>
    <xmx:AVtWX41rnzwdcBvgA5MHAUGiocc8zkP4ERWAa4585NcPKNCgNDdeUw>
    <xmx:AVtWX1-GJHx4syLUUd6dq4n5HrygCLBAonIYQXddG4hDlF3ZGbXhdNyEsqo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2DC5328005A;
        Mon,  7 Sep 2020 12:08:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: set the lockdep class for log tree extent buffers" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Sep 2020 18:08:40 +0200
Message-ID: <159949492041197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From d3beaa253fd6fa40b8b18a216398e6e5376a9d21 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 10 Aug 2020 11:42:31 -0400
Subject: [PATCH] btrfs: set the lockdep class for log tree extent buffers

These are special extent buffers that get rewound in order to lookup
the state of the tree at a specific point in time.  As such they do not
go through the normal initialization paths that set their lockdep class,
so handle them appropriately when they are created and before they are
locked.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index cd1cd673bc0b..cd392da69b81 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1297,6 +1297,8 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	btrfs_tree_read_unlock_blocking(eb);
 	free_extent_buffer(eb);
 
+	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb_rewin),
+				       eb_rewin, btrfs_header_level(eb_rewin));
 	btrfs_tree_read_lock(eb_rewin);
 	__tree_mod_log_rewind(fs_info, eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
@@ -1370,7 +1372,6 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 
 	if (!eb)
 		return NULL;
-	btrfs_tree_read_lock(eb);
 	if (old_root) {
 		btrfs_set_header_bytenr(eb, eb->start);
 		btrfs_set_header_backref_rev(eb, BTRFS_MIXED_BACKREF_REV);
@@ -1378,6 +1379,9 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		btrfs_set_header_level(eb, old_root->level);
 		btrfs_set_header_generation(eb, old_generation);
 	}
+	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb), eb,
+				       btrfs_header_level(eb));
+	btrfs_tree_read_lock(eb);
 	if (tm)
 		__tree_mod_log_rewind(fs_info, eb, time_seq, tm);
 	else

