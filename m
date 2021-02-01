Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE2430AC52
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 17:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBAQJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 11:09:14 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:48901 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhBAQJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 11:09:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B0933B74;
        Mon,  1 Feb 2021 11:08:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 11:08:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ba2Q+o
        2f9BxiRyEX3rT2qWbHVspnGPiGrYWgb2NquIk=; b=prYsRFX3QAQrU60Ji888/R
        pYJ7ziyse34OethiEqEX2IjaFFJEzvoPLRH4fi3KzKCug1pVFGn3/uIIoeg2pJLM
        BHJSD0kNJVniXWTIWQcJkbQUH1j2X7v4H7880uGStNMo4O5HAak+gjI7tT3J+8A4
        7iqw8sYf2uCXfiKDkp6C8QSL6mu8PCdkfhtOTKZENK41GvyW620dsWT4c+5P17kS
        ah921usMPKH8W7J6yotlssk+ps5HDe8juc/AJl2WwwlN9SNohug+c+Ldxm4VItNm
        3c3DU6M+yYXox2Yyp+66m1pN643AZD/0DUWVeQlckswgwiKKKxGAouyOqLXQmueA
        ==
X-ME-Sender: <xms:eicYYHTt7FFLRu6tz-3i1iiLmfBnVc41Qc_pZ2pwr7MOripTP1Ul8w>
    <xme:eicYYIxuHYbYaWKTxsBkcna4IOfwvHa33vUPrTFTZTYQxHXKujq74qhJ4dJOrUtsa
    nyrteODqMuB5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:eicYYM0xStQUZwVzcXTMwUOy4FCqMn225cIL3WRdwT3toxTvgZCelw>
    <xmx:eicYYHDONADXt9IVxc4Olz_GgFzk1tImX-VfdStohpcCE3rlobE4vw>
    <xmx:eicYYAhKeDNK8-Qi_2bZWTw_e-BAhhfDdu9KoaDUgLLvO1VA7JTB6A>
    <xmx:eicYYOdmdO-S-_RHxs2o-L8CdYORiXfexnttVxpkPy4Bhn8RRGMXz5zAY3c>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC8AD1080066;
        Mon,  1 Feb 2021 11:08:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "dm raid: fix discard limits for raid1 and raid10"" failed to apply to 5.10-stable tree
To:     snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 17:08:23 +0100
Message-ID: <161219570378170@kroah.com>
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

From 0941e3b0653fef1ea68287f6a948c6c68a45c9ba Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 14 Dec 2020 12:12:08 -0500
Subject: [PATCH] Revert "dm raid: fix discard limits for raid1 and raid10"

This reverts commit e0910c8e4f87bb9f767e61a778b0d9271c4dc512.

Reverting 6ffeb1c3f822 ("md: change mddev 'chunk_sectors' from int to
unsigned") exposes dm-raid.c compiler warnings detailed that commit's
header. Clearly this more conservative fix, of simply reverting
e0910c8e4f8, would've been more prudent given how late we were in the
v5.10 release. Lessons have been learned.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index dc8568ab96f2..56b723d012ac 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3730,14 +3730,12 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
 
 	/*
-	 * RAID10 personality requires bio splitting,
-	 * RAID0/1/4/5/6 don't and process large discard bios properly.
+	 * RAID1 and RAID10 personalities require bio splitting,
+	 * RAID0/4/5/6 don't and process large discard bios properly.
 	 */
-	if (rs_is_raid10(rs)) {
-		limits->discard_granularity = max(chunk_size_bytes,
-						  limits->discard_granularity);
-		limits->max_discard_sectors = min_not_zero(rs->md.chunk_sectors,
-							   limits->max_discard_sectors);
+	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
+		limits->discard_granularity = chunk_size_bytes;
+		limits->max_discard_sectors = rs->md.chunk_sectors;
 	}
 }
 

