Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A643D1E0FE3
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 15:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403837AbgEYNxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 09:53:44 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:42217 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403805AbgEYNxo (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 25 May 2020 09:53:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id F27331940941;
        Mon, 25 May 2020 09:53:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 May 2020 09:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bHnSaH
        AwBklENLIrcmqJtNbPkb5YyQYQOi71XtWJpoM=; b=IbcCEUAeqK7JHWVovYIItm
        s/UZBmhQsPVemzQ3+JNWJUhn9J0VTUCEvAnE6N8EKfoPqy3fXTLCFEx8BOcG0ZsQ
        gu4ArwIPwqIOyKwlNzLuXrT+zq+Rr4tk/nwd20yLFITEHY1E8Xrvy4eYAG5agt4l
        rcJoJj+tIqcJx8tnrXwxlLEmdrqWiJLEBhsmOJ3MFqUB6w/yK2S9veqE3IbQDHBq
        A2KWdGBC+WXY0vVqPAi6XWNLtrjCxTMK4FZk6Rf4awgm3PlfSbIp3mwWqaEnkoP8
        vgnnDZ3qgXlAYRi90xCX09qXW+QHo4lC7X7Qvfgmk3hRp45MjI/CHGcJIx4uLA+A
        ==
X-ME-Sender: <xms:5s3LXrhb5lvceLMTfzPxmioUXEi_6KbdrOC97afsa4mH0_lijRbkdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:5s3LXoB5En2sbJAW6X147_9y9_yMORVpkVT76qUeWux7Xa87gkMRAQ>
    <xmx:5s3LXrETZ9MFLA8QUQlmFDd16w21nHMifRquxRX1GQsd_zPzlChJ4Q>
    <xmx:5s3LXoTUo4gjUkotg9EprSnVk8lHjOVSATMHWYylWf2fVnU7zcmWJw>
    <xmx:5s3LXltcHBiPW8WFO0thG9dWhMhQgGrHZsTrLvFBksq_MwsYL4IdWQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 90DE73280063;
        Mon, 25 May 2020 09:53:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: stm32-adc: fix device used to request dma" failed to apply to 5.4-stable tree
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 15:53:32 +0200
Message-ID: <15904148129183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 52cd91c27f3908b88e8b25aed4a4d20660abcc45 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Thu, 30 Apr 2020 11:28:45 +0200
Subject: [PATCH] iio: adc: stm32-adc: fix device used to request dma

DMA channel request should use device struct from platform device struct.
Currently it's using iio device struct. But at this stage when probing,
device struct isn't yet registered (e.g. device_register is done in
iio_device_register). Since commit 71723a96b8b1 ("dmaengine: Create
symlinks between DMA channels and slaves"), a warning message is printed
as the links in sysfs can't be created, due to device isn't yet registered:
- Cannot create DMA slave symlink
- Cannot create DMA dma:rx symlink

Fix this by using device struct from platform device to request dma chan.

Fixes: 2763ea0585c99 ("iio: adc: stm32: add optional dma support")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index ae622ee6d08c..dfc3a306c667 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1812,18 +1812,18 @@ static int stm32_adc_chan_of_init(struct iio_dev *indio_dev)
 	return 0;
 }
 
-static int stm32_adc_dma_request(struct iio_dev *indio_dev)
+static int stm32_adc_dma_request(struct device *dev, struct iio_dev *indio_dev)
 {
 	struct stm32_adc *adc = iio_priv(indio_dev);
 	struct dma_slave_config config;
 	int ret;
 
-	adc->dma_chan = dma_request_chan(&indio_dev->dev, "rx");
+	adc->dma_chan = dma_request_chan(dev, "rx");
 	if (IS_ERR(adc->dma_chan)) {
 		ret = PTR_ERR(adc->dma_chan);
 		if (ret != -ENODEV) {
 			if (ret != -EPROBE_DEFER)
-				dev_err(&indio_dev->dev,
+				dev_err(dev,
 					"DMA channel request failed with %d\n",
 					ret);
 			return ret;
@@ -1930,7 +1930,7 @@ static int stm32_adc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	ret = stm32_adc_dma_request(indio_dev);
+	ret = stm32_adc_dma_request(dev, indio_dev);
 	if (ret < 0)
 		return ret;
 

