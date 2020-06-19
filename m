Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AD9200AB9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbgFSNv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:51:29 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:44049 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731794AbgFSNv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:51:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B93601945387;
        Fri, 19 Jun 2020 09:51:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vTBQ50
        Yz+8A9xubjsvwTi8CmlnbtFGq+HViCJqcMbcU=; b=USxV1/tUBQQayWQzE3HVDt
        ElK+i9p+HqOooKmZh4cmCCafkCTb5Rm9pimr61RFGWcgNLHOeLgePMb11HN5iHLl
        MiVC+iWGklRcVtaCfrw/9Xy3AF4wuZtGm4sCoMWVMIxVF+kFtD9hfIC8gk0iAW3v
        Tr8Wep8rKFP1u5t34kvk7+lfcwA6Koup0Pw4aQj7/Fo8IOcBb4vJIa5n4vWzzbsM
        U5xe6xCusbytm+pLnpo7lzPvw//hohxUDK57GqCaD+rIq6uC/v+mTTCzxAEJitmU
        rEIeUpHRZB0wV+6cim6OCHXt3T4Qeqe6Q5ZoNK+346lFAL6Qr6a3fel1K0ru8X0Q
        ==
X-ME-Sender: <xms:38LsXoHNyEHGk_6_PFCIvi0XNf0La1Dn0mfhK9eTYbEB4bVotBjRnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdeknecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:38LsXhWCAwSH6UC8x07-zg2YFXNFn_g6mltNcRrrDHLX4a5FiVXuGg>
    <xmx:38LsXiKZGfUftyroKD1zcZBtJOjiA1vTQBj4I4e4LgOXkKc9G6GW1Q>
    <xmx:38LsXqErtkc1QsV6UoLxiLyj1_k2RLZ0SyGljaCPSxJ3DkYZ7QzfXA>
    <xmx:38LsXmgHe5E6LyuHcCyDwVeBOvM-4HDOXm0MrAeLLDA5cxjm-EGoJQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 593983280063;
        Fri, 19 Jun 2020 09:51:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: mtk: Fix the probe error path" failed to apply to 4.14-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:51:17 +0200
Message-ID: <159257467740171@kroah.com>
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

From 8a82bbcadec877f5f938c54026278dfc1f05a332 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:00 +0200
Subject: [PATCH] mtd: rawnand: mtk: Fix the probe error path

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
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-28-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index e7ec30e784fd..9dad08bed2bb 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1419,7 +1419,7 @@ static int mtk_nfc_nand_chip_init(struct device *dev, struct mtk_nfc *nfc,
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "mtd parse partition error\n");
-		nand_release(nand);
+		nand_cleanup(nand);
 		return ret;
 	}
 

