Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD9F330156
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhCGNp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:45:59 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60997 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231417AbhCGNpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:45:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6F1361A43;
        Sun,  7 Mar 2021 08:45:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:45:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ccsg14
        +5ycZgN3f3MkyTeg+Mlq5vRx41SNVAEJ2BDqI=; b=ii5nFE5xG86swN6Kv3xDif
        9FXw5x+AI2GfMVhXS25968B/j0hqtbJQmmJEzqeott6r2rOoEk1mlWw3B4aNdJFJ
        JZTInplfKrZamtTO6WYhWmgD0BAukUh689EczoRlJHC7C9N7a1rzrvpbfRS18zF8
        e2CBbJVraALRCuaWhuMcbDlNaKEm6nyJIA/AkVpfxI7d/r8WCoAUtpVos9z3Dx0x
        ZWrT2dURJ+PSlNgqwardIB536SMuX1pLzVe+ugRNcft04zhPnHbOJoIYxyr+Vx+x
        3vEB67OpdOT63fK8DXeCcHZAndwkhloweAGPstSRBwRGz16P6a6Clc6/SfQL1fTw
        ==
X-ME-Sender: <xms:DtlEYHOxgq6MlFtas-RbDhJp5FrBaeuZo3N28dNrSDKGzrQG6wnKVw>
    <xme:DtlEYB_8DFGTNAI4bJ-NT0XOf00-5TYGnEfxof18ZQJ9yDxVECXHHEJa6K0VHGler
    Gc8dRU6SBFV_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:D9lEYGSL_3KNw-5BBYiBVDFrRu4aFAkxDIwrdvfvz9BoXYHc_qIhGA>
    <xmx:D9lEYLudHQtXGhRgZ_6Qc-F3O6uYI8whiJVvrSdkp_qTo1uhY32bHQ>
    <xmx:D9lEYPfu-SUw8eJtPgqBwKadlxjQ8I-CtTwuP1BfWz7jZnx3y6_h6Q>
    <xmx:D9lEYPkwRfTjxPH3OhOwxHIEjMPn64uD0LHmk9pvCrS-7nwNPzNwCygRHDw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B9DCB24005B;
        Sun,  7 Mar 2021 08:45:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: avoid double put of block group when emptying cluster" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:45:39 +0100
Message-ID: <1615124739216100@kroah.com>
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

