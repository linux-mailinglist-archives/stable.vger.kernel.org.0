Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88149200AA9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732878AbgFSNuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:50:14 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40267 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728606AbgFSNuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:50:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2E4FA19457AF;
        Fri, 19 Jun 2020 09:50:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:50:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6wVq33
        bQp6DmIq7PQ+AaACGGy/MF12DD68SW86ZKpZI=; b=jZebKrdXFCHzBzbAH+Q5HI
        xaKb3g1nRUHgmPgarEp0lGaFb/kssR4eJtKrd1Qxq+SZ88s7LRgmSVBakiMpjfmF
        uYOl3qFserZzpcRH9OS7MxlYrnKc/4bBnUpocDsj5a7N7wB4BHm6Ft2JBKjSOOOi
        qtUioOhDDmQz7o8Ymfco/+UR0Yyiz31ikoFOxQ57g6hkUAL8ky3Qc6qEgz4qEj+A
        LOWIPm7fN6dbhyGVnHJZeI++9RgEpOlb8WVQAZ2eCqWeyC85sVMgRkn6pKoxlGpA
        B8325xJwnlzmABBDwaORM01t2PWrP9tR4JTUDKBuOzPu3CCVJ/bDUlnMfUd0seMA
        ==
X-ME-Sender: <xms:lMLsXhP-z7JXBhILUCpI1-XkajHW1e_zseXAurxxBrAlcTcUlORglQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudejnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:lMLsXj9cTvyu19-j-GlYC29L-rCQ8DVaL59Ml3RIcWnGMdj2lZKOrA>
    <xmx:lMLsXgQ5sne-x9oedImZXZiHxwr1CEkQWP2XiXloYH_dFgzyUphfxg>
    <xmx:lMLsXttKr2L2_4tHSnSFyK6L_tqVB0fz1o-8Gss-GsqWzP5HoTfkhg>
    <xmx:lMLsXjr4rE1pY3w4daE3QcOZe1VYb-1pZMBtxOS-svY6Cq8wWpvZaA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB79A3060FE7;
        Fri, 19 Jun 2020 09:50:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: sunxi: Fix the probe error path" failed to apply to 4.4-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:50:09 +0200
Message-ID: <159257460922592@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

