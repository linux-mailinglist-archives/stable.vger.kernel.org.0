Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E7633015B
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhCGNrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:47:36 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:35347 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231472AbhCGNrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:47:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D12EA1A46;
        Sun,  7 Mar 2021 08:47:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:47:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XioOAx
        7L45ylAxBGwi5IIB86+MQG5prUdZlRBV2P8o8=; b=AZ34u66DCrQVAvHUBwChxe
        FGZz4/as25IpRUPC96IqxqyUWc0eUbWgDkfUES7UT7Saxk/gjKf2Nd5Ewtg51CRo
        NblqgWKmcaJZMrkyUjsQBwv8B9SsYqeScmWChnJLKKIlp9YIXF+E4fyvKLPRZtMQ
        VuqYr4/SnMQ1ZBf/pf930APjt/cFmCXqep2GuMFBoPFjtiHoR5nK7tCDNbImpLj5
        XZBcdAUP1GN2pgr2XM3wmB0PF3bvzcKyKoarRAZyIzMIUXo3d/QLTh8YYtV36MXd
        n5dkNak4WRuqcI6H+crDrIscxiuiG2snYVDM8PGL3tBk/loBnsPn+ILJ1qOL1Yvw
        ==
X-ME-Sender: <xms:W9lEYO7v0n10LZIPQ8Fgoa7fQTtKXKJGp2hYMAj7KdnSWgcViYJtaA>
    <xme:W9lEYH4YvvFisls04NR_f8QRII4Tk1VJ5xYqIQ95QdKe1kCleAmOdQjlH_M_2HqsF
    6UyDwm1ffvnpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:W9lEYNf5eYfdQFPVcM_6SlIOqDTS0h6eup4lwW52nm4_5NBnHSkxmw>
    <xmx:W9lEYLL2fU7WmiPVuSuI3XKBjxhNqn_I6Z-UlD-FG1Xu9VellFC8KQ>
    <xmx:W9lEYCK6oZsUeAcrIjolJdcOMTW56BRs-qe0Lj8yjmxlD95UWeUV6g>
    <xmx:W9lEYMzaRQZkeAGS3JDCnZr7S9PYaNfbtd1lIIKsv0FBMG5QfZFE7uBSJPM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D6FFA1080057;
        Sun,  7 Mar 2021 08:47:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: avoid double put of block group when emptying cluster" failed to apply to 4.19-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:47:04 +0100
Message-ID: <161512482482@kroah.com>
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

From 95c85fba1f64c3249c67f0078a29f8a125078189 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 25 Jan 2021 16:42:35 -0500
Subject: [PATCH] btrfs: avoid double put of block group when emptying cluster

It's wrong calling btrfs_put_block_group in
__btrfs_return_cluster_to_free_space if the block group passed is
different than the block group the cluster represents. As this means the
cluster doesn't have a reference to the passed block group. This results
in double put and a use-after-free bug.

Fix this by simply bailing if the block group we passed in does not
match the block group on the cluster.

Fixes: fa9c0d795f7b ("Btrfs: rework allocation clustering")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ update changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index abcf951e6b44..711a6a751ae9 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2801,8 +2801,10 @@ static void __btrfs_return_cluster_to_free_space(
 	struct rb_node *node;
 
 	spin_lock(&cluster->lock);
-	if (cluster->block_group != block_group)
-		goto out;
+	if (cluster->block_group != block_group) {
+		spin_unlock(&cluster->lock);
+		return;
+	}
 
 	cluster->block_group = NULL;
 	cluster->window_start = 0;
@@ -2840,8 +2842,6 @@ static void __btrfs_return_cluster_to_free_space(
 				   entry->offset, &entry->offset_index, bitmap);
 	}
 	cluster->root = RB_ROOT;
-
-out:
 	spin_unlock(&cluster->lock);
 	btrfs_put_block_group(block_group);
 }

