Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEB917E9A1
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgCIUDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:03:23 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45345 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgCIUDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 16:03:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AAE4922033;
        Mon,  9 Mar 2020 16:03:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 09 Mar 2020 16:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U9o+1V
        e3RUmUvRDj8QwCIZ15JpspFm3WXSFQ68lbsos=; b=gCUPBOE02Ezgns08pghrj8
        iBdV9P3uoZ6mLzYzl1c4Q13tAaLuzWUUBGUl3yuiqxXVc5earzKAGEzNrw2XSd0/
        FAbQbbJkt2viemfBAFK1/+Kxi+fGvJoVmoH7OqUZr4WNkw4MGCB+uxW7aMq8HtRv
        QHNVbiwkTqPDP70sC9Pxz4MYtbtjgn1CUYBo2U/EG9rcEuLBbXSdG77LNhJrW8To
        mU1K1nHnHeTmgKWFBZ35Y5LJE//Lov1lRkyJI4l5luHNvq4GMXzVbZ5vehnaS+D3
        SCdfImLoI7kp/2K77pPpVpiLGkTh3NcAK8IrE/7/rHsA+Twanj+LljnHbAHI20xQ
        ==
X-ME-Sender: <xms:CaFmXqRBFLwtrc959hQOPnIpYta265mozo3B7R0pAFx9shvBOma0JA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:CaFmXvUIYdA7nxNlunxWEw5wdlFpeuWDlt4Ft43X7UQv5ej2JUagsA>
    <xmx:CaFmXr6P7PzwenbXsEBklHFVDogGqI1sX52M9GNus0pTbatjU3UzBg>
    <xmx:CaFmXlx3eDSe2pLBi3fQVG2RXavDOAHn3D90GBtzbdCV8nzuRU9DWQ>
    <xmx:CaFmXhG2JSkY9h8h5-My2FPhDPlYeQ7O-lJyA9fUwinVoG3h48nNMw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5068430614B1;
        Mon,  9 Mar 2020 16:03:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dmaengine: imx-sdma: Fix the event id check to include RX" failed to apply to 4.9-stable tree
To:     frieder.schrempf@kontron.de, festevam@gmail.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Mar 2020 21:03:08 +0100
Message-ID: <158378418832224@kroah.com>
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

