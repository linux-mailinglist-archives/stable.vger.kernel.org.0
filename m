Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EBF1E0FDF
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 15:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403838AbgEYNxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 09:53:37 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:50029 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403805AbgEYNxg (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 25 May 2020 09:53:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A34901940959;
        Mon, 25 May 2020 09:53:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 May 2020 09:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SH3lsJ
        ap6kEF5gV1xRSOvWO2oMe5TSd/h+6x9haI4BQ=; b=BSfwIKMpRG1gnPVwe6W6IY
        RfuQddpOOoyXZmyHp3jeckzUaNjB19kQfSmaKSQT8cwZHNJyR2y6H+nGD6J3Pp8M
        CK1vMvt4IUa7KKWfs5xmCwSxJQrFFqeugpupdZ2a5F4AbdH5epSgq2ly3zWG8efK
        2b0+VxQhk0jPhyeeyo1ZCQJOBecbZmLUt8J9lGtc7+xAbb5V+5xBTmpprZdDFayu
        EKmp2ivwmWWVfUA1mu0Xip9EcL+RN1FATXb/9OlEUUGrc1tN7tH07mkEkqprJcXW
        qL3USiHP2GLXotin+ZfRNFiPQ842lUZe7X4s+vG9pO5xkVx/BS5mtoTCIzWc7SuA
        ==
X-ME-Sender: <xms:3s3LXsviRHw0kHykhy4yQ9RcHyeE_E-yWIKxkqqp5P1c7MRu3SfUPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:383LXpcOMTKO_lsPLLbVwS89eG9pxdFe5wfq_aw1O-zTuZw8ZYMCTw>
    <xmx:383LXnw4k86a6gCGMOXdKNnQoAJACbAkrHZyrCVSKxSgy_92cFkpOA>
    <xmx:383LXvPgoRhcH0k5coRC0BkhL-m10XLQgUhg91lP8m7VmgdEqMrBgw>
    <xmx:383LXlLd-URPmg5Qm8bZwsMNmP1XRN3jxOWo_NLptOjPGUCFXPRtbQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1C36328005A;
        Mon, 25 May 2020 09:53:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: stm32-adc: fix device used to request dma" failed to apply to 4.14-stable tree
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 15:53:31 +0200
Message-ID: <159041481114272@kroah.com>
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
 

