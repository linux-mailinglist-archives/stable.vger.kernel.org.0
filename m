Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB746200AAC
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgFSNu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:50:26 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:59933 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732972AbgFSNuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:50:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C6B92194579E;
        Fri, 19 Jun 2020 09:50:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:50:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NImMEs
        p4WUq+F+cZEkgofmXcxntY+cgaxcGv9aJ6ci0=; b=Y0EPjruxJbJVt3a5jso1r5
        ds+kRbwFRNRXj2RWWL0Mr6+ojkf1MqirG70pdvL3qeHe+1NbeqAR2CiIlW4JdlN3
        v7bYDAVgIUIlM8lZqDcuMyCtB3SPll0KJ0GV/zqA0vwtzL1cfyKSVOz3M23eoKXM
        BCuTDjqxzpHM0CJQy4yvfPNQ9eWo4FWPoV7K0YhITLZ2l1luKRlxYn82IbueiYDa
        Ashv7m90F/d6nle1A3bquup+9rygfL87BlD97B/D3yaxUJU0BU11rElx5XZEP21J
        qhzJ0QpoRwR3KJscx1vrEqyB6eHWnQKW1q/ZRsNblp2AEm71JG/cMOhm43fcfApA
        ==
X-ME-Sender: <xms:ncLsXn0rvlZH3JJJlSjh81IRL5gusmYK8ThmfeZClcesvdVxwZU9vA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudeknecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ncLsXmHuPI9oYslvbAdWL5mPcsUZHKlgnScRHos2llaaFBpKltJhEw>
    <xmx:ncLsXn796JFRoVz5R1vlwhfbdORCxe12YjqRkJ7smNd-iPI6yeDQhg>
    <xmx:ncLsXs2O_qw3cn4s-4rZeoQz3Bm0dUDCWreVKhKz5i9Ufm_5URqRtA>
    <xmx:ncLsXuSo58NOyT37moKDiUwZlfNvzWIDK0QP_2Hcyuvkxe2zluFTaQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 666A93061CCB;
        Fri, 19 Jun 2020 09:50:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: sunxi: Fix the probe error path" failed to apply to 4.19-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:50:10 +0200
Message-ID: <1592574610151146@kroah.com>
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

From 3d84515ffd8fb657e10fa5b1215e9f095fa7efca Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:26 +0200
Subject: [PATCH] mtd: rawnand: sunxi: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

Fixes: 1fef62c1423b ("mtd: nand: add sunxi NAND flash controller support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-54-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 26d862213cac..9f51fd20a52e 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -2004,7 +2004,7 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "failed to register mtd device: %d\n", ret);
-		nand_release(nand);
+		nand_cleanup(nand);
 		return ret;
 	}
 

