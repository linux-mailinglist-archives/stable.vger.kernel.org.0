Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F5117E99F
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgCIUDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:03:18 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35645 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgCIUDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 16:03:18 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 52BE421FAD;
        Mon,  9 Mar 2020 16:03:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 09 Mar 2020 16:03:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RJn+8B
        Ugxfd6iDD8QTKMKjlFtbPcL2HGDrQBh5F0VAY=; b=2XoJXbxoY1U0OhPEigkhLB
        kdtGJiGPkfPlGsJ+P4TDvOQLQYkekrCXlQ5CI2wixgMkLjSWV6OtiWaFki64Kf/U
        NFBwKLmXJOHg1O3vSZxu3EKDKkEDJ3rVrPOONWJ3vU2+uf/9bFsDN7LTktP8x9BA
        gCHosHJeVCNAYPbs105VJ9tF0VM2wXlGv/B64hu3Ff26ACWLorIAbQaIDWiaFVkg
        nT1B1OSlhZkDaPIMA5QmcTwpW5A9adecfPsLHtOE9LHIrTtQtBRRV8YEKg437E9n
        1hsPSn311BGX3zlcOuEWPME6TXX2mgIIHazKKj3SZ9UXy2t6fqqDyJmHHX5CegxA
        ==
X-ME-Sender: <xms:BaFmXqXPPZrmH6UT7dJGeyQKMFALSJmjCqspFi88VPLuAyYP3Bg4Jg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:BaFmXtvYGip_NFMKgtbtZQU64BtP-o2CMEE0C-_ZOEpj9rmeXwQwIg>
    <xmx:BaFmXgyUAdBLrAlcn6jJdoPvN2GdTb7ea94406gFYGUb8VjHweYVvg>
    <xmx:BaFmXrC7HpwcCQUAPmJBKt_2Bj7-XBPHdQXKwg-uTXbf917ND7GS4A>
    <xmx:BaFmXkftvX6h17lsIrGwzZ3H6H5lOocOV7lkYf1sLtBT04w8MIRI7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1EEA328005A;
        Mon,  9 Mar 2020 16:03:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dmaengine: imx-sdma: Fix the event id check to include RX" failed to apply to 4.14-stable tree
To:     frieder.schrempf@kontron.de, festevam@gmail.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Mar 2020 21:03:07 +0100
Message-ID: <158378418790172@kroah.com>
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

From 25962e1a7f1d522f1b57ead2f266fab570042a70 Mon Sep 17 00:00:00 2001
From: Frieder Schrempf <frieder.schrempf@kontron.de>
Date: Tue, 25 Feb 2020 08:23:20 +0000
Subject: [PATCH] dmaengine: imx-sdma: Fix the event id check to include RX
 event for UART6

On i.MX6UL/ULL and i.MX6SX the DMA event id for the RX channel of
UART6 is '0'. To fix the broken DMA support for UART6, we change
the check for event_id0 to include '0' as a valid id.

Fixes: 1ec1e82f2510 ("dmaengine: Add Freescale i.MX SDMA support")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200225082139.7646-1-frieder.schrempf@kontron.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 332ca5034504..4d4477df4ede 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1331,7 +1331,7 @@ static void sdma_free_chan_resources(struct dma_chan *chan)
 
 	sdma_channel_synchronize(chan);
 
-	if (sdmac->event_id0)
+	if (sdmac->event_id0 >= 0)
 		sdma_event_disable(sdmac, sdmac->event_id0);
 	if (sdmac->event_id1)
 		sdma_event_disable(sdmac, sdmac->event_id1);
@@ -1632,7 +1632,7 @@ static int sdma_config(struct dma_chan *chan,
 	memcpy(&sdmac->slave_config, dmaengine_cfg, sizeof(*dmaengine_cfg));
 
 	/* Set ENBLn earlier to make sure dma request triggered after that */
-	if (sdmac->event_id0) {
+	if (sdmac->event_id0 >= 0) {
 		if (sdmac->event_id0 >= sdmac->sdma->drvdata->num_events)
 			return -EINVAL;
 		sdma_event_enable(sdmac, sdmac->event_id0);

