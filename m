Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26F6200AA2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732942AbgFSNtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:49:15 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:49387 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732007AbgFSNtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:49:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3ED97194579A;
        Fri, 19 Jun 2020 09:49:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2dIC+P
        ctsxJd5Toq/06L7G8LBlTCvxA0kDMldhbauk4=; b=UFt5ICEeUPBmFx/VM6/+DN
        M1SbaLATaJdgQ64Q0CcxXSKi8/CDzhlNbBVg7UwZsUEaqbmsZOLMbF8hz+LIHY9O
        dlUmIp6qEfOkntFcYuVqYnm4/dXfpBm8H/VGUHnNiW71Y7pNFVmwGGrGi/e0/Cwa
        9DRULrqv7NA4f2owTHHyI+r4RRGP0GBjt7/uIqfE6DXQAiCWaFO1VINF41bnYcpq
        sk0byJq/yjvMppF6/465+sHdHeziqnmxpa2qwATRBlQSqSNuFJDZE0p1DaGAXnfR
        A/CyTQ8wfK+g5hRGReR7Jw/c4tPE3AMbTpjiaI9h6d10zsmaAlwvaipzHWwncTWw
        ==
X-ME-Sender: <xms:WsLsXgJuV_aXHarPuS3R8QJnwaie0A_c5VaVaNWHcq2dIbuwh4Vkxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepuddvnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WsLsXgK_3d2oIm70UXlVZcefrGrE2MfbCnr4jvU26k1Uh6sahbz1Cw>
    <xmx:WsLsXgt4PnoXbfTdMSjzBUw1953YqPWxJI1VUQIHxlocEUxm-KQ8LQ>
    <xmx:WsLsXtZqeqXugRM5uxUUFmU70X5qA3_B71UIzOigXOYmfMnqOCGXpA>
    <xmx:WsLsXgnXMr-4248NryrFkk87nrccryl_vUiQOF5-gTNInnSBn5cqEw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E556F328005E;
        Fri, 19 Jun 2020 09:49:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: orion: Fix the probe error path" failed to apply to 4.9-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:49:11 +0200
Message-ID: <1592574551150116@kroah.com>
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
 

