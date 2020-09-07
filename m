Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CD825FE2C
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgIGQIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:08:54 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:44051 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729973AbgIGQId (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 12:08:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 424645D5;
        Mon,  7 Sep 2020 12:08:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 07 Sep 2020 12:08:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tM0J9F
        tcxru8d9rFubslXpDEASF6uREYPPAfhKuu/W4=; b=thdqZFVDlNjYMg9UL8ASdT
        W09P1ZXLmtE7nNIwjnNt9sC/cH3W5LtbJ1Ez+fP1oLUj8cfLPfRBcfLbg1bfPGYy
        mynzhYB4fm36qr6dfKncbsHH4hyYAocuCbTwd8L6DSFZ446G2BZsH9itx03AjAvi
        p4BuQuKCpaCk285ZtpKhkiYX6ReGBuL82XKi7EmnUUuzKQSq3/jJDSkZxRevXwyX
        Nqq10K+nhJVGyprIaENjJos676zFltYBGhASBup8lWvsBYCqslw4dDsC6AyGLVIE
        c5d9a2AB1/Zdi4hKCTJeEFj3/eHmYgbcka2s7oQNZdP9iCZKn0diU8mCQi0f9/uA
        ==
X-ME-Sender: <xms:-FpWX8yTqPltS_esBMZ49cqUiUdSLVZ6VSD4Q0pxmX5oz2Y6aGfNBA>
    <xme:-FpWXwRSljFUq0WUxL8L5deQGgzxgyAsUQ9t2l0bThQbeuoBVpPtHSaGhS4uXwBK-
    sJZrqAZyPneDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehtddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:-FpWX-XbwDX-qLfks4mOAT7YZ7KcNiWD_wd-irnlfIK4hEOmvSQWJw>
    <xmx:-FpWX6jKrLq0Pu6XG3-F7E1fZNASv5vq1JtOujNnqa9EK-lLlFhLgQ>
    <xmx:-FpWX-D9yHiA2yILWuDko23ZI8g4bhJWKjyAblud4wFdjwkEk44dJA>
    <xmx:-FpWX_6Cwx8w_J-EPmXliECebhmNdujmqGjwD2jW7aUXYt9aFRAzTcOS7Ds>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D8803064674;
        Mon,  7 Sep 2020 12:08:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: set the lockdep class for log tree extent buffers" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Sep 2020 18:08:39 +0200
Message-ID: <15994949196756@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

