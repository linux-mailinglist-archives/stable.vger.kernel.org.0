Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15F4301C26
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbhAXNXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:23:24 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33231 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbhAXNXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:23:23 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 85CD8A1B;
        Sun, 24 Jan 2021 08:22:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:22:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1WaOkr
        Om1UlsiKCtcXn/mZwEkamv8jxfBp8XVVvxzcI=; b=nbd357EFRk86OA460Qzyz0
        Cn3eBCD2zWJH0wud68wcOgPp/2bS9jsc/LcrNVpRPJc1JRc3vs0LnfuyCN/5R8KI
        HwcYtIgI+YpunQ/dIYkEuN+zGKzGPzgOehq5TQNNurlgB+RjrHEr07dOb2NDKLvH
        GCXI55O0aYgyOQMRD0XKzvlsb8tfPBgYjdgEhWrdH6y+BikCg63U+zeblxuTGcqT
        NMFx/GrqzX6QqxFJePmXffei7GN0QPe4tgflU40kkFzpBllxRgrnmh5Kwk3da9vV
        USuUXsfPiXNgC2Gah4lClkkZqo6QI1qG0O2PeGz1qQ05+468sverX6UmPpiw49uQ
        ==
X-ME-Sender: <xms:iXQNYAS8HRvuoBmbgv3jSLE6GCKqxu74X5dkQ5iaQjoQBxzqJ74iqQ>
    <xme:iXQNYNzBOlbg3LXULrrxnx1a7YuQ1pN9rMIt1sJBNznQFGB4ltbtcyk7rcBzLP5yr
    7-b2iBSK1fsDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:iXQNYN2KYPeJCTkO7IfAsWhr3Yurpw9ZkJbAHLr_0et4ITelMUB56w>
    <xmx:iXQNYEAaff_8VL3junGAowEmg0t2PA4m_35f6TLjqSOPuZpcIg8OkA>
    <xmx:iXQNYJhxHR3GVz8NYgP1OGV0QN5ai1VQ5GjI3q2Rm08k1nqHjxXbdw>
    <xmx:iXQNYMsZHJqVXBu9X38Vxl2NE72NhNe2sGu9EFeNcki6fbFlhFSjFZr1BvM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC49A240057;
        Sun, 24 Jan 2021 08:22:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: don't clear ret in btrfs_start_dirty_block_groups" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:22:15 +0100
Message-ID: <161149453515816@kroah.com>
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

