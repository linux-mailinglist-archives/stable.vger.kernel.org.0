Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5C0301C24
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbhAXNXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:23:08 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56469 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbhAXNXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:23:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E0A40B0A;
        Sun, 24 Jan 2021 08:22:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:22:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QwObxT
        lC8X13AMXv+2wvMQgO9fBylLq2eW05Ep2ZqwY=; b=fKnJYACl76lu/+F/HWyXJB
        a09cEO9E1gXVk8gFaTDiUYKne2icRSVAo8f6wReJfH1zYiowW7S39gw892OzPDDB
        lXsIGIgR7PBB5urC5yRnH0OEfPClhk+W1DVvjuxcBoAIQXh6jvblsmp7NfItDYU3
        clyS3kbHR0CL0/H3QQYMjkYwqeGHjB9elOk2Oec2vOzkTbuUk92sj2UozyKADDyf
        PS1Neic54KbvMjPPSCLmCqhWjgu3QxCfkG36iMdCwt/MHev7trve6ZT6sib3OmzT
        ZUxF2q+yQCM8N9gcREHsXlvLNcxQWH2GVjAmrH6pGZbbr1xVE3x7cLVy+MVBNnCA
        ==
X-ME-Sender: <xms:jHQNYPYbXlcUX2zLe-ejS0uIoCN2Pt2HnvBchHBJNiVqNSf_9U7_EQ>
    <xme:jHQNYOYH7yLv0T4fuTCU0yGps1dE6200JUPYRDf1YbemAxnKcJFS_j-hCu5dTOpcX
    pXxixrfX1Sbnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:jHQNYB9ZR1QzgTdJEhj6-xg9vIgHhRdVMDCOkzHxGfEqtPr1milYBw>
    <xmx:jHQNYFo46kvDbxvOkAF9yHgBlK8cTJ2QXpdI1F-gtc3rcob7oYq6tw>
    <xmx:jHQNYKqelvy32wxw_dM8WDkf6Y8b0a2gfMR1p1wFPgkmWua-xTee9w>
    <xmx:jHQNYB0XU11STBYw5rUwKVX-afndFZo7cJkrh3EnwUA6CH2hdcd402xNZjo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1EFD6240057;
        Sun, 24 Jan 2021 08:22:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: don't clear ret in btrfs_start_dirty_block_groups" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:22:16 +0100
Message-ID: <16114945361964@kroah.com>
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

From 34d1eb0e599875064955a74712f08ff14c8e3d5f Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 16 Dec 2020 11:22:17 -0500
Subject: [PATCH] btrfs: don't clear ret in btrfs_start_dirty_block_groups

If we fail to update a block group item in the loop we'll break, however
we'll do btrfs_run_delayed_refs and lose our error value in ret, and
thus not clean up properly.  Fix this by only running the delayed refs
if there was no failure.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 52f2198d44c9..0886e81e5540 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2669,7 +2669,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 	 * Go through delayed refs for all the stuff we've just kicked off
 	 * and then loop back (just once)
 	 */
-	ret = btrfs_run_delayed_refs(trans, 0);
+	if (!ret)
+		ret = btrfs_run_delayed_refs(trans, 0);
 	if (!ret && loops == 0) {
 		loops++;
 		spin_lock(&cur_trans->dirty_bgs_lock);

