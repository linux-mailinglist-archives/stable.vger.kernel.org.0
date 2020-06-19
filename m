Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A99C200AA3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732944AbgFSNtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:49:24 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:57265 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbgFSNtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:49:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B4A6A1945791;
        Fri, 19 Jun 2020 09:49:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:49:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hr6as8
        dtb2R8y0d2YoxAPScp2bUQ8TxlQUzoqrILZPQ=; b=bBqbRCn6PVNiTbw0ZxXy/1
        jogFgd9xfuS2gUQyPiBwhVI14Ep21Y1bB0gnZPj2y2MTHR0LR2H8AjjFCzDpTVCa
        tUGxP1/Tz6t7wGGUfmCgGMMCD+df4dvd7T+EkOPAR1RMaOLQWSxiK4gFn+wR7nUn
        sITaB9XcgAGLWVJC0rZ/LEAp9bYvrk3Q0k6kF9vMNzzriMMD28WQFNDUGCnkFQOy
        zN9oz5W5V/4gRYwwzW68eihK4rq/4gJ4qOeqArjLTk5/mK7qiRx3qfRFmO7Lqf7b
        83WUWilkwWxjMJfSUTI986wCld/1ggJJ/Hklb4hLz8nyvuTWrTsOqnbUVI+t2HOg
        ==
X-ME-Sender: <xms:YsLsXpBxw4XC9ercO4E87XtTCe1UN4CtBD-K79ReUYbrJ9miX4nV4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudefnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:YsLsXnjW9GRHY7aLmTiIRbozp5kJPs1CIM945m7TIftI3NpfwNhtQQ>
    <xmx:YsLsXkl577Jb1mVYPjClQCquA_Jyw0JMZ80-sD45sKvpQ_MVN79Dgw>
    <xmx:YsLsXjymHbkcqvicwekFer3pDvuHqcOQ95DIElSVbgJ_oaVFEVbxxQ>
    <xmx:YsLsXld-2geMGj-N5DoADej2rj_ib2aOYu4NWxlgAQB4_C3tdQ1k6Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 537E63061856;
        Fri, 19 Jun 2020 09:49:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: orion: Fix the probe error path" failed to apply to 4.14-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:49:12 +0200
Message-ID: <1592574552179220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From be238fbf78e4c7c586dac235ab967d3e565a4d1a Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:06 +0200
Subject: [PATCH] mtd: rawnand: orion: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-34-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/orion_nand.c b/drivers/mtd/nand/raw/orion_nand.c
index d27b39a7223c..a3dcdf25f5f2 100644
--- a/drivers/mtd/nand/raw/orion_nand.c
+++ b/drivers/mtd/nand/raw/orion_nand.c
@@ -180,7 +180,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	mtd->name = "orion_nand";
 	ret = mtd_device_register(mtd, board->parts, board->nr_parts);
 	if (ret) {
-		nand_release(nc);
+		nand_cleanup(nc);
 		goto no_dev;
 	}
 

