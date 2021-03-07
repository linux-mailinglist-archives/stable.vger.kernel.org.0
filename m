Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169D033015A
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhCGNrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:47:37 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:37367 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231484AbhCGNrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:47:16 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AF38718EA;
        Sun,  7 Mar 2021 08:47:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:47:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=d+UEqF
        WlEZKuZ2PbNCebFQ/EUPZwlLnBx2rfTQE/fBM=; b=tPNy24AArLuu5R7nMkh0rp
        NXeZwaySIs/pprNCZVXRs9x5g1BMc6ZB+0Ej3m/napCpVtux0cWSvgXE1I0maTON
        xvbRHtp+vFaIYZleFW078t+C04fs9S8Wcn08sI9C2/pGeKp+Xx740ENBflHR+1hA
        zOELKPSi/5M9acpHaFrog3ck3aLNcLVzU8UmEI2DaIQmNxtSFE30GX76qXSOdVvH
        aZtSEQm4hBwB++zTdZ00IirDbzSUTYgE5hQZo6Egm6Ls+yyb5QUlY02dq7DGrp6S
        i+UAqlS7WogjRN8dg3m8SM752Bb1XSeCnEc15rhbAThxSnmrqdIb08ioWf5G01qg
        ==
X-ME-Sender: <xms:Y9lEYPr2B4P1buPIJeniclHYeDU8WNXqqPOC4aYz4_laChPe1YuXuw>
    <xme:Y9lEYJrgtrSD77smjrNuVq4MM2W__lHaeLUR7RlA42VUqChxpEuPeOo4Jr8Mdz6zb
    5Aeq6W81k5v5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Y9lEYMNVANGKpn3yL8i36SBDkLLL7Ox8BQl5UvHZcJUfw2a2IVjppg>
    <xmx:Y9lEYC4i2bhOU-FG_VBo9-EHrIwdZnixmX04vmkgKnUP-MCB39tTpQ>
    <xmx:Y9lEYO6l1Gvna38IufRUVyg_JxaQq-rjQQk7O8CaDFvGFdbuAvFg0g>
    <xmx:Y9lEYDhIy9A2gBoV14AKY9RhRUQpzWLcFwQsmcJHBs9MWBoHiuSjeHiU9KE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 04D2D1080057;
        Sun,  7 Mar 2021 08:47:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: avoid double put of block group when emptying cluster" failed to apply to 5.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:47:05 +0100
Message-ID: <161512482516394@kroah.com>
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

