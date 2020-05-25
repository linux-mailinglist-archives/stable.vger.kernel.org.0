Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179371E0FE8
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 15:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403874AbgEYNyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 09:54:11 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40495 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403812AbgEYNyL (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 25 May 2020 09:54:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 682251940A1E;
        Mon, 25 May 2020 09:54:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 May 2020 09:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iTPh7L
        Ikp4UA6sIlqkcwKnKxbMuPj1IHUDyp65UK1oM=; b=2Al4CVHdZAbpsZ5UCTsGAz
        MLKw0AEcaF8G9IiTCwQmWo8zSIUQA1gu994tJXWBK9llISIMmxOuN2Wcz9Gh6yx+
        k8c3AYl3NVgp/9r9IepmZ3ICH/3zpy141evXfK8oJjjgCxNdFhNh5nCKZdg9a4NO
        zg/73NvEy3EzutX1tDtpxjEYPnQbOdqJ3NO7iK0tMIzV1kLGALL+y7CI4/D9wL+N
        HRZ3in9/BniCwEwu89GM1MyP8jwGBuHerHmWGkb6TtdznLi8ny8zS+eVy7qbhzO3
        9pwNvpCosdpKKjldFhvp52NH8UOzfy4/qcImMtxgUw0KtkyZwHWiWP93iye3aoyA
        ==
X-ME-Sender: <xms:As7LXql8Ljt3joEhBnoiOAWQk0FQhdReASRIRv28oDOltn2vY4VWgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:As7LXh0Gjbhi0AiE0y0ww4AGVshCwsFyOIORZQkL8aPq78nc5GPpZQ>
    <xmx:As7LXooApgdEG0sZ6WxV6ik91lRryr9Mb64Us1CSBh55CqgWPzl7ZA>
    <xmx:As7LXumiRdYsJqdn_jSyEhpINrdQb4_ZWHqsIFdh0Kyo_TBWFY0F1g>
    <xmx:As7LXpj_7rUlqRTAUUg5SfS4eOYELNjws0vQFyqf7Vxm7v6vX-6EuA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A3D1328005E;
        Mon, 25 May 2020 09:54:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: stm32-dfsdm: fix device used to request dma" failed to apply to 5.4-stable tree
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 15:54:00 +0200
Message-ID: <159041484016177@kroah.com>
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

From b455d06e6fb3c035711e8aab1ca18082ccb15d87 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Thu, 30 Apr 2020 11:28:46 +0200
Subject: [PATCH] iio: adc: stm32-dfsdm: fix device used to request dma

DMA channel request should use device struct from platform device struct.
Currently it's using iio device struct. But at this stage when probing,
device struct isn't yet registered (e.g. device_register is done in
iio_device_register). Since commit 71723a96b8b1 ("dmaengine: Create
symlinks between DMA channels and slaves"), a warning message is printed
as the links in sysfs can't be created, due to device isn't yet registered:
- Cannot create DMA slave symlink
- Cannot create DMA dma:rx symlink

Fix this by using device struct from platform device to request dma chan.

Fixes: eca949800d2d ("IIO: ADC: add stm32 DFSDM support for PDM microphone")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/stm32-dfsdm-adc.c b/drivers/iio/adc/stm32-dfsdm-adc.c
index 76a60d93fe23..506bf519f64c 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -62,7 +62,7 @@ enum sd_converter_type {
 
 struct stm32_dfsdm_dev_data {
 	int type;
-	int (*init)(struct iio_dev *indio_dev);
+	int (*init)(struct device *dev, struct iio_dev *indio_dev);
 	unsigned int num_channels;
 	const struct regmap_config *regmap_cfg;
 };
@@ -1365,11 +1365,12 @@ static void stm32_dfsdm_dma_release(struct iio_dev *indio_dev)
 	}
 }
 
-static int stm32_dfsdm_dma_request(struct iio_dev *indio_dev)
+static int stm32_dfsdm_dma_request(struct device *dev,
+				   struct iio_dev *indio_dev)
 {
 	struct stm32_dfsdm_adc *adc = iio_priv(indio_dev);
 
-	adc->dma_chan = dma_request_chan(&indio_dev->dev, "rx");
+	adc->dma_chan = dma_request_chan(dev, "rx");
 	if (IS_ERR(adc->dma_chan)) {
 		int ret = PTR_ERR(adc->dma_chan);
 
@@ -1425,7 +1426,7 @@ static int stm32_dfsdm_adc_chan_init_one(struct iio_dev *indio_dev,
 					  &adc->dfsdm->ch_list[ch->channel]);
 }
 
-static int stm32_dfsdm_audio_init(struct iio_dev *indio_dev)
+static int stm32_dfsdm_audio_init(struct device *dev, struct iio_dev *indio_dev)
 {
 	struct iio_chan_spec *ch;
 	struct stm32_dfsdm_adc *adc = iio_priv(indio_dev);
@@ -1452,10 +1453,10 @@ static int stm32_dfsdm_audio_init(struct iio_dev *indio_dev)
 	indio_dev->num_channels = 1;
 	indio_dev->channels = ch;
 
-	return stm32_dfsdm_dma_request(indio_dev);
+	return stm32_dfsdm_dma_request(dev, indio_dev);
 }
 
-static int stm32_dfsdm_adc_init(struct iio_dev *indio_dev)
+static int stm32_dfsdm_adc_init(struct device *dev, struct iio_dev *indio_dev)
 {
 	struct iio_chan_spec *ch;
 	struct stm32_dfsdm_adc *adc = iio_priv(indio_dev);
@@ -1499,17 +1500,17 @@ static int stm32_dfsdm_adc_init(struct iio_dev *indio_dev)
 	init_completion(&adc->completion);
 
 	/* Optionally request DMA */
-	ret = stm32_dfsdm_dma_request(indio_dev);
+	ret = stm32_dfsdm_dma_request(dev, indio_dev);
 	if (ret) {
 		if (ret != -ENODEV) {
 			if (ret != -EPROBE_DEFER)
-				dev_err(&indio_dev->dev,
+				dev_err(dev,
 					"DMA channel request failed with %d\n",
 					ret);
 			return ret;
 		}
 
-		dev_dbg(&indio_dev->dev, "No DMA support\n");
+		dev_dbg(dev, "No DMA support\n");
 		return 0;
 	}
 
@@ -1622,7 +1623,7 @@ static int stm32_dfsdm_adc_probe(struct platform_device *pdev)
 		adc->dfsdm->fl_list[adc->fl_id].sync_mode = val;
 
 	adc->dev_data = dev_data;
-	ret = dev_data->init(iio);
+	ret = dev_data->init(dev, iio);
 	if (ret < 0)
 		return ret;
 

