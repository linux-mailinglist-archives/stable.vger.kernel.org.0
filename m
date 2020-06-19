Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B296200AB5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732997AbgFSNus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:50:48 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:39511 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732879AbgFSNus (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:50:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7CE3419457BB;
        Fri, 19 Jun 2020 09:50:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4oVhRk
        DTUu/vZnga5fYN+nZMhre5cMQKHox10cOHyeo=; b=Hnc7dIV8Ms+84WOnt7w5pK
        gHgFNSIumkCyEbaZoafXPA9ipk4QUE7122gWxAMXmzbFeWUbfL67k0wU6TnicVyO
        C7kIeNZe/SWtluImL9FPFmntIK4OWItM9d26+9lWvv9NeKkVnpW3KQpOe+2sFqkJ
        2axOTCV2D+lXp5l7R67zjIUjwEY9wKkV7/2wiGNO0j1KqW9Kl8xs+idPIlkMe0NH
        OqVc/URgr2PCFpq53xXsRjKPpiLSwT8MmM/nVx26YDo0T+saA+Y+BiUyf53XBWlM
        H9zoe8enVYdUkeRuXyLA/RFucEkvl+L85m+KE+LEjKuRM2XSoVPT/lWjReQhdSUg
        ==
X-ME-Sender: <xms:tsLsXuYxlWVrcJsXpbp0sPwHYkmSdX3WX_qmeLpB3pd5iPpnA3wx-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdehnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:tsLsXhb_WAcyixmpwqaOuuukXeOLvAinaxptHa7BkF0AvST21nAuZw>
    <xmx:tsLsXo-4uknhtagZLPOfJZa8IKcNQ8cRUmbq9qF0N5JwGTsVcoQw0Q>
    <xmx:tsLsXgp7CJFdkn0sDy-tqTOPlk0uhovIBmVQ-R89H4C-mfWfldLZEg>
    <xmx:tsLsXm2zx16CA539isiwP66IcG6M8UV66n7DOX4yQsaoyAafWd-EGw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 303053280064;
        Fri, 19 Jun 2020 09:50:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: plat_nand: Fix the probe error path" failed to apply to 4.19-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:50:37 +0200
Message-ID: <15925746371655@kroah.com>
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

From 5284024b4dac5e94f7f374ca905c7580dbc455e9 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:15 +0200
Subject: [PATCH] mtd: rawnand: plat_nand: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible, hence pointing it as the commit to
fix for backporting purposes, even if this commit is not introducing
any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-43-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/plat_nand.c b/drivers/mtd/nand/raw/plat_nand.c
index dc0f3074ddbf..3a495b233443 100644
--- a/drivers/mtd/nand/raw/plat_nand.c
+++ b/drivers/mtd/nand/raw/plat_nand.c
@@ -92,7 +92,7 @@ static int plat_nand_probe(struct platform_device *pdev)
 	if (!err)
 		return err;
 
-	nand_release(&data->chip);
+	nand_cleanup(&data->chip);
 out:
 	if (pdata->ctrl.remove)
 		pdata->ctrl.remove(pdev);

