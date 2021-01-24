Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930B4301C23
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAXNXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:23:07 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:42813 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbhAXNXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:23:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 77B34EA1;
        Sun, 24 Jan 2021 08:22:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:22:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pediOY
        8nIjG2PjF8Eo5pRCqMQ+Qdz3RaPBT8m1X20x4=; b=d6doVFANAfk7uYsdbLtkca
        hwUaSuEvMhzgrgAEtJRhnFgJmygh8etE3WIFy1K9GhHEC+pe4pVjoGk1QGr38/zA
        KbtB+BGebG+L9OvGmi21DLXqXkPziaauixK7B/7YkKLgCVZ/u9VTQZz79BWmHAdH
        gduEAsvV0Nq8+efMSOqshi3oNSPgyzM5Zs/5Byc/KkpvDqjSVSnfl81q/foK5I8P
        4D/hwuwFxusEa98uxKH/UcH5LjJ1SV43Gdb6oXcSaInaDPBPisGapJ/fO3Ne2u6Y
        BjJu84Ox4tbIQwgTgDm5gCN5IQX6rvpPvSblUMvbxoFZYRXMLqAbWoBMY6QSSfYA
        ==
X-ME-Sender: <xms:i3QNYP-eZRKJ702t395x8AVdH7rsoSUj1IgqBdp7dV6S9YwuTeMIcQ>
    <xme:i3QNYLvoJx9maM5L6PkV9LW4mUTuxHGQLF_MY09jtyZ-PlvgU7rh_-qwiEERkLG5A
    zprH-GAQ8K9fA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:i3QNYNBx2szBc6u-8LyCgVqq6SNiySvZPV6a63Iunpybl4qHQQg_8g>
    <xmx:i3QNYLfB5gtAwbCj6B_x0_1Li242wtNj98arwwBYDxuqZ_v5dgGLeg>
    <xmx:i3QNYEOpQuZtXltpzFyVErlIj_33JKI8kY9ovz-dPwU7_mxEooqUcQ>
    <xmx:i3QNYNZ7MuaP1-oLHBpkMSjUnBlbKYMKKqaANG3XNnENyjc2tC3j-1AX6UM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C1BCE108005B;
        Sun, 24 Jan 2021 08:22:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: don't clear ret in btrfs_start_dirty_block_groups" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:22:16 +0100
Message-ID: <1611494536239153@kroah.com>
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

