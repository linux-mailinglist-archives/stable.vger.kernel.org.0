Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA61430AC4D
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 17:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhBAQH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 11:07:56 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:36249 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230267AbhBAQHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 11:07:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4BB68B56;
        Mon,  1 Feb 2021 11:07:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 11:07:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HJNd6Q
        AS+tZk0oxeWLx4gq028NyIHu5LAiKFek0Tl8I=; b=MrIh5yi4aUuWHytlZYUtx2
        GTkHz+OVdbEw6wPvQs9Jpu/P88xVZgsCTbWefDOBaVKBKtZeq/TSafwXFdLRJlus
        aOlgvfa8MylOVkK4P7r5SOJuZ/QTzA5g/PfOjgpCX5ZqJW3nA700oBr1mFJ360vb
        +7YiOWU2tPYafDcP3lvlFdwxhdrlBUnjqkgTevJrvcFf1nnp75bkBXH9nejHiNV8
        Xbjtl1dAjT6ik80DGoQhShSKZmlL6PnipAiZYjaDRtGYFu9hKFOLEWZaHwGpaq82
        3xcsJZFbqixLYD132awm1WF76yJIky2WGGk00B3H8WM75b9J7Sn1kI8i/ehYvL3g
        ==
X-ME-Sender: <xms:KCcYYEHopKF3mm1GHtrV8DriPWjL2xg48FydR3eISdQJTOpcntmYMw>
    <xme:KCcYYNVlw7245kZY0yYFaG6oiSXT-CMfGbFuWC-VCHrz4W4zEiiQhDHGvyJAouA2J
    RLpZ0gwKAO2Sg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:KCcYYOIRbOdDeZuUZEbhZHEORL-0w04-jYiVsm8wjGu8Mfxb1yz9-Q>
    <xmx:KCcYYGEVUF4t20bUWt_iWYTsGb11Ffm4XSEph72pjUHpZ8zatrAKUw>
    <xmx:KCcYYKUE_iqOsUdTbzy0iMESwaZR4MlH243AL6cueQ2LHJ6F_JLFeA>
    <xmx:KCcYYNcL9lY6jOub2dJSXXQcZpspjQBawpHyK815K_K5jjR1OTSGn7C8yuA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7242A240062;
        Mon,  1 Feb 2021 11:07:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm raid: fix discard limits for raid1 and raid10" failed to apply to 5.10-stable tree
To:     snitzer@redhat.com, mpatocka@redhat.com, zkabelac@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 17:07:03 +0100
Message-ID: <1612195623241254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e0910c8e4f87bb9f767e61a778b0d9271c4dc512 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 24 Sep 2020 13:14:52 -0400
Subject: [PATCH] dm raid: fix discard limits for raid1 and raid10

Block core warned that discard_granularity was 0 for dm-raid with
personality of raid1.  Reason is that raid_io_hints() was incorrectly
special-casing raid1 rather than raid0.

But since commit 29efc390b9462 ("md/md0: optimize raid0 discard
handling") even raid0 properly handles large discards.

Fix raid_io_hints() by removing discard limits settings for raid1.
Also, fix limits for raid10 by properly stacking underlying limits as
done in blk_stack_limits().

Depends-on: 29efc390b9462 ("md/md0: optimize raid0 discard handling")
Fixes: 61697a6abd24a ("dm: eliminate 'split_discard_bios' flag from DM target interface")
Cc: stable@vger.kernel.org
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 56b723d012ac..dc8568ab96f2 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3730,12 +3730,14 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
 
 	/*
-	 * RAID1 and RAID10 personalities require bio splitting,
-	 * RAID0/4/5/6 don't and process large discard bios properly.
+	 * RAID10 personality requires bio splitting,
+	 * RAID0/1/4/5/6 don't and process large discard bios properly.
 	 */
-	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
-		limits->discard_granularity = chunk_size_bytes;
-		limits->max_discard_sectors = rs->md.chunk_sectors;
+	if (rs_is_raid10(rs)) {
+		limits->discard_granularity = max(chunk_size_bytes,
+						  limits->discard_granularity);
+		limits->max_discard_sectors = min_not_zero(rs->md.chunk_sectors,
+							   limits->max_discard_sectors);
 	}
 }
 

