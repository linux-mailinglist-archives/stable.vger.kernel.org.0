Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E772C200A98
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbgFSNsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:48:09 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:59483 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729134AbgFSNsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:48:08 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3C3C41945775;
        Fri, 19 Jun 2020 09:48:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=z0yVWv
        WfoqCrlhEwbnGvBQqpTVko5PDdFzs7ar5xpLo=; b=ZuXmyyAwscOgEiayPkdTqJ
        6gO/8itUKZ0pI09DwCJvbKBEHCFLaNWmVUv4UeubVM9VMEB84rdCRFSsj9B0Y71a
        7pi6oDkR+pdMMOQ5cMO1nDLwNQduSG3+OaUcycGvrSrSp3zv0OxkK8tP6PhNdvaA
        fFcafOjSTBirGHBida5l8AaiNfUAj8RC5GB+OlbLuFUlXSsGB+K8KlUvF34sRne4
        qRrLUSA1d1FyH014ajX230h/0fm2k4AM63YrH4U9czlfIqc4DIQ0FTlErIr+G+Aj
        0e7QjJLquKbf9LsDnybF+zs7uFSSjykKV6NEnETQdueEd7ouWYK1fsafBMQd02uQ
        ==
X-ME-Sender: <xms:F8LsXhxXaOFe1SiihAwR0IhVqLPTpBX73gKn5FGr6OahC7G3ej8RLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:F8LsXhRbdpUpDAaPtpmM0JaGItItfUoIyh_6guedjCys6W9QHtxYeQ>
    <xmx:F8LsXrUXCT-x1v8LthhjxU_9YlQggp0CSwvlyKcnIfSUxrEInostEw>
    <xmx:F8LsXjgi6xdiNSc0s412J_0lENBEmko5b-ULcy4lp2E9UmmkO4zbRQ>
    <xmx:F8LsXmMJ6mMEV4lX5rGSuI647BBy7JtGls8dDsTSASnhkvNY_mMKQw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D232630618C1;
        Fri, 19 Jun 2020 09:48:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: sharpsl: Fix the probe error path" failed to apply to 4.19-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:48:05 +0200
Message-ID: <15925744858024@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 0f44b3275b3798ccb97a2f51ac85871c30d6fbbc Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:21 +0200
Subject: [PATCH] mtd: rawnand: sharpsl: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-49-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/sharpsl.c b/drivers/mtd/nand/raw/sharpsl.c
index b47a9eaff89b..d8c52a016080 100644
--- a/drivers/mtd/nand/raw/sharpsl.c
+++ b/drivers/mtd/nand/raw/sharpsl.c
@@ -183,7 +183,7 @@ static int sharpsl_nand_probe(struct platform_device *pdev)
 	return 0;
 
 err_add:
-	nand_release(this);
+	nand_cleanup(this);
 
 err_scan:
 	iounmap(sharpsl->io);

