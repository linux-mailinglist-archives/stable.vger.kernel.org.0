Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4594A200AA1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732893AbgFSNtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:49:07 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:49781 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732007AbgFSNtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:49:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D15581945783;
        Fri, 19 Jun 2020 09:49:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:49:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BohHkJ
        eUGqBim68cHveUTm95H9M37ZDrBjk33BDrYj0=; b=cTPdXvh+7+baCj5BinLsDL
        kQC0B76zJ1QuKPGS1ljNzZeyu5Nx/k+GxJl8Jiw1bR2HNEz8YECEy0aODXpz5tRT
        3CpOBIVbWOm1HwFeCBBGGh2TFbh0e6R4ndEL0nhI0ivtNgPUtO0bOiI00ycat7wQ
        Yw2lrPnO5C/OcsPJFD/JNj2Q5ZDCn+BiO8a6KfbxaSkGimyp0HpzZBZXaz8iAec2
        GDQeREFZjvQVDfvhG68eAvqZHOV1gXRR3rXSxpAhciVVmK9vUTYsknCp7w7JSipp
        pzKmsrrlfkK+AG2J5mgtjQiaGsn9fyq7GutXXHzWxAZ0adF50VWsy8Pqwoy7/Akg
        ==
X-ME-Sender: <xms:TsLsXlXKy1fFgaM01HBMHXpX_3wUiOuuEyJMZKuXw-o4573VI2NbSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepuddtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TsLsXlmg3_0gdp4MsbtPYE-OVcSJFvxWtfuXHMrpNfLVLxnqOKI57g>
    <xmx:TsLsXhaUs_mcZWqwn7OZngPo5SeCyZO14LJHVkNl2rthrVILR7zzKg>
    <xmx:TsLsXoU9rYWsBNOk2AzzRb71HKWvPDqgPPVgpIMVQ5cIvYruIPXxgg>
    <xmx:TsLsXrxKiXnMDgCXkFVP5aBAOSOVejnwiAZAHiVFYf3vbRGO_JDqKw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71AC8328005A;
        Fri, 19 Jun 2020 09:49:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: xway: Fix the probe error path" failed to apply to 4.19-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:48:57 +0200
Message-ID: <159257453721135@kroah.com>
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

From 34531be5e804a8e1abf314a6c3a19fe342e4a154 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:33 +0200
Subject: [PATCH] mtd: rawnand: xway: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-61-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/xway_nand.c b/drivers/mtd/nand/raw/xway_nand.c
index 834f794816a9..018311dc8fe1 100644
--- a/drivers/mtd/nand/raw/xway_nand.c
+++ b/drivers/mtd/nand/raw/xway_nand.c
@@ -210,7 +210,7 @@ static int xway_nand_probe(struct platform_device *pdev)
 
 	err = mtd_device_register(mtd, NULL, 0);
 	if (err)
-		nand_release(&data->chip);
+		nand_cleanup(&data->chip);
 
 	return err;
 }

