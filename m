Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA369200A9E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732495AbgFSNtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:49:00 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:48015 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732007AbgFSNs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:48:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4176A1945790;
        Fri, 19 Jun 2020 09:48:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:48:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CnOOsI
        alsQ7cKJAsqCm1skPw1aerlKCyNebiXP6Z8Lo=; b=jLn8KGfKwrOjCg4rzPmby3
        14es5T7y4FTonAkXPFDoJ8rNRLwkLmo78cLlOBd5543FGyfFKAJ61wwPqxxqy0Wo
        YjHZkqPTjWQ3ssB72xkOIB1HUme7j8FXCkqNImdYfZIoguDiIDj3gxccCbVkolHj
        Uf38qeVM1cvC8E5ApDX4GBn+/PeYzlzPvtl/wddlvaO3NsdLOI5bnZNiA5EK1FIY
        F16+TOadHpITpFSHIcrnhkB7aNUwrrf/aUK0Boxc0wRMUh6vm/fyWBiwJjQzt63h
        Vm6USTxICHxD6tW5ft7kgue4TWMiOL+zd6AxZqxelQi3K/xzCUODvZLlQhum07kA
        ==
X-ME-Sender: <xms:SsLsXh_ib8moQHbq93uoVGinf2cMWJFTFDafGEcGFebgCvAjvM0WZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:SsLsXls9VegiA7ORf37AVqZykW5J9x9yrRhe6L_Rlb9-8_HmmCF2VA>
    <xmx:SsLsXvA5r_IS0lD--14fbZZgAtONsOwqvDENh3QhgNwkL26xShFTYQ>
    <xmx:SsLsXle3zJCzwqROz0rojPkgGI2c-Nr51F7MqOfbBykjSQBH_DTVvQ>
    <xmx:SsLsXsbRqPAF671UBn5IMrYLjDmugCuXo5gw91QR6sAvcPqsQJ-SDA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1281328005E;
        Fri, 19 Jun 2020 09:48:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: xway: Fix the probe error path" failed to apply to 4.9-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:48:56 +0200
Message-ID: <1592574536199115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

