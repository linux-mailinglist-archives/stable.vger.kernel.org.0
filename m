Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E917200AAB
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732980AbgFSNuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:50:25 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:53999 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728606AbgFSNuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:50:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 28D2C19457B1;
        Fri, 19 Jun 2020 09:50:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:50:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+cNVS3
        Xpul3pvRpqyZ99ztITftD8zRxZ+WjzcVQhN1Q=; b=gWj61Fl/h6zjZrLSoMgn9Y
        EM+6zYe2P01y4SbxSIgEmPB1FLTBpum/wbP6gquj0X7WaayC2fGbt0LJ8lgUV0VC
        0xDQrpTW6FP3DtRqTvg412OaFn+NLQS1dtSz0087bffGfNxmDBdL1BEUZksLgz8a
        hqEmQhBfvQ2fHRIqNc/Qrh2if99pA8o51oZOCz0LYAaM3c11pAOWWHEt7Jap4k9n
        Qi5DRfeG8fLCcYfM1hXigaxLa7LzZ2IcLQAXsqcPexeomGzinuJP3jpIgvbh/K8B
        oFDOCHCALngvT8ai9lbaPIfDU+DQOy0zJEadSoMuDc5NQf7sIH89WMcs/dtvYQWg
        ==
X-ME-Sender: <xms:ncLsXnFFoLsrco8n7ehd6y8ECGXii0HA95cIZPCKqMjH5QddufDNjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudeknecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ncLsXkUzwytUsXBsyzEtwBNHootNXJ1BHSM4WQXPx9ZwlwEmQk5i6g>
    <xmx:ncLsXpIqKRN2XgCbUla3HqfmI_w16MRHvu7BSHjl8h95yQmaTAbq5Q>
    <xmx:ncLsXlG4QUQ8kL9EB6pp4cCk2H7BDqgGZPAgs_9G8zuKMOfApApP0A>
    <xmx:ncLsXliNb3_Jal0rRdptVtRe7T0Pf9waylrN9NmHinbDLAYxKZPa4A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF9E73061CCB;
        Fri, 19 Jun 2020 09:50:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: sunxi: Fix the probe error path" failed to apply to 4.14-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:50:10 +0200
Message-ID: <159257461036211@kroah.com>
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
 

