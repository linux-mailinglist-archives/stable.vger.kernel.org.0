Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECAA330155
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhCGNp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:45:59 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:35217 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230416AbhCGNpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:45:41 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1EF4D1A48;
        Sun,  7 Mar 2021 08:45:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:45:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=D+gzy+
        M5ecdNg94st9ncR+Jn5uxQxXpGjMM2DEdLOwQ=; b=Kn9p+KpcrgJ1X/pc9QU2/7
        QKJKlRJicx7TKa49PwbA4JdU1ZN+gFAMdGDvTB/Q59E9/nUDL5XBiy2oXLvxnlar
        QSGaKRPXUAiwPxE9keJgHKTWcNoKCGlVN0I/8bGKHisq0gOe4HKtsWTaVUX01tTq
        nT1rWNgx882Lw3VqrLBIWU/UbF4AU42B7NGo6XMl+hfCqMsTtixRu5ZWUuFGQmQK
        N1tAQ2Ffh6EXj0uF4/I6kH69IUXPb47N4bZ18PZ425xCpskdwuB+N4o83+HYikkU
        uEFmZInsWggdqrl6u6My5vWV0ugoZPrKSlqDZKiVmK/kjneenlEHl9vwsfIXfAQQ
        ==
X-ME-Sender: <xms:BNlEYFlXC1N20SE_CR6fIiTdNPB2UP3C7uIazCjZ1i7kOJ6DKshnOw>
    <xme:BNlEYA1DUIicLe4n_y-Jgz5HtG_QUHuIFOO5dXK550uY_jzOXBL1NAa20dTKrG-Tk
    tcjL5qv49A47g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:BNlEYLqSxjOC_oDGj08_42wIgmb7fTZYYyAfR_kKn_m2arDBZBN3Xg>
    <xmx:BNlEYFkBu0ejGXYaHvIELP3175z0WZs-0Geeeokin0TxmYhafDtWqQ>
    <xmx:BNlEYD1NJTYKI5X1IxNn9H97lIk5Ny1wWcvXycWcCZmN5ZXEq4xipQ>
    <xmx:BNlEYA-N6eQLvj9HzVJyMgZyN5CY2FESKsarWsXjQpzYWmTZT4rYdnpgmIQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0CF85108005F;
        Sun,  7 Mar 2021 08:45:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: avoid double put of block group when emptying cluster" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:45:38 +0100
Message-ID: <16151247383858@kroah.com>
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

