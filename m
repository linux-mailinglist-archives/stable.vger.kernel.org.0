Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70252E3603
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgL1Krw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:47:52 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43713 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727163AbgL1Krw (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Dec 2020 05:47:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EEFAB7BA;
        Mon, 28 Dec 2020 05:47:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 05:47:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OouhOD
        CVQvXQCuedRdESd7UzFylPVfQ0xpeQDrZdPFU=; b=KwM1mJ3wGgeOxha4TMhXhr
        8A0lDXFwS4slBjXTWCbrHl1stnbUjLshDNa3Nu77yjpdr7F3HxNfns6LWTvVLzzr
        IfDBwgElrtJ4S0ESs98g3QMlPu25emADFatwKw8e0UpnHfqkJL1tI23B/y06v+2D
        DKB2aNeSvPnqE0tnibESwK8vYy5S+paYqod3NKJ471SYXwvCUZISp3U2YKkXrHu6
        QQzbSwsHURx2MHXeqgiDe+sWLElM5UTjJ8rYVo6zng7ZAW4wL6jj6OtUFFrpk/6j
        Q+letoBb2HMWlc39WnmSLeUhZvrnUiM0L+cSPd/Hpb6ll2wJeZpQ69JhhX66aRSA
        ==
X-ME-Sender: <xms:pbfpX9iXPaZh89RpEcOBZick8mAh88gK63yNXljrqEKGqOL9ssuVsA>
    <xme:pbfpXyDTu7HUaDxRTTZRbCc4l3QJlDcB0yKm9KFtA9UNsIqKrQ0sDGhWpLfGYXxG1
    oPQXrnNeb31Bg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pbfpX9H8h8WDWH9FYjOOeig6DbVCjtDFffDsy7go426AAuE-TD1Dfg>
    <xmx:pbfpXyTXmds-AbI-pHxozCiW4NYXiwPwF0F08nBhPgePCtQhimX7nA>
    <xmx:pbfpX6y2PoECdGDXO4BN5Jeoouib4rVOhphbuuGpwmdwW7lVB10ulQ>
    <xmx:pbfpX_oi_2pKscG_bjM8-Kui5cgBm4qWhRn2VpnHh-U5jRWKVOZ4Up5_2E8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 429BD1080059;
        Mon, 28 Dec 2020 05:47:01 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: ad_sigma_delta: Don't put SPI transfer buffer on the" failed to apply to 4.19-stable tree
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, alexandru.ardelean@analog.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:48:21 +0100
Message-ID: <1609152501101133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 0fb6ee8d0b5e90b72f870f76debc8bd31a742014 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Tue, 24 Nov 2020 14:38:07 +0200
Subject: [PATCH] iio: ad_sigma_delta: Don't put SPI transfer buffer on the
 stack

Use a heap allocated memory for the SPI transfer buffer. Using stack memory
can corrupt stack memory when using DMA on some systems.

This change moves the buffer from the stack of the trigger handler call to
the heap of the buffer of the state struct. The size increases takes into
account the alignment for the timestamp, which is 8 bytes.

The 'data' buffer is split into 'tx_buf' and 'rx_buf', to make a clearer
separation of which part of the buffer should be used for TX & RX.

Fixes: af3008485ea03 ("iio:adc: Add common code for ADI Sigma Delta devices")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20201124123807.19717-1-alexandru.ardelean@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index 86039e9ecaca..3a6f239d4acc 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -57,7 +57,7 @@ EXPORT_SYMBOL_GPL(ad_sd_set_comm);
 int ad_sd_write_reg(struct ad_sigma_delta *sigma_delta, unsigned int reg,
 	unsigned int size, unsigned int val)
 {
-	uint8_t *data = sigma_delta->data;
+	uint8_t *data = sigma_delta->tx_buf;
 	struct spi_transfer t = {
 		.tx_buf		= data,
 		.len		= size + 1,
@@ -99,7 +99,7 @@ EXPORT_SYMBOL_GPL(ad_sd_write_reg);
 static int ad_sd_read_reg_raw(struct ad_sigma_delta *sigma_delta,
 	unsigned int reg, unsigned int size, uint8_t *val)
 {
-	uint8_t *data = sigma_delta->data;
+	uint8_t *data = sigma_delta->tx_buf;
 	int ret;
 	struct spi_transfer t[] = {
 		{
@@ -146,22 +146,22 @@ int ad_sd_read_reg(struct ad_sigma_delta *sigma_delta,
 {
 	int ret;
 
-	ret = ad_sd_read_reg_raw(sigma_delta, reg, size, sigma_delta->data);
+	ret = ad_sd_read_reg_raw(sigma_delta, reg, size, sigma_delta->rx_buf);
 	if (ret < 0)
 		goto out;
 
 	switch (size) {
 	case 4:
-		*val = get_unaligned_be32(sigma_delta->data);
+		*val = get_unaligned_be32(sigma_delta->rx_buf);
 		break;
 	case 3:
-		*val = get_unaligned_be24(&sigma_delta->data[0]);
+		*val = get_unaligned_be24(sigma_delta->rx_buf);
 		break;
 	case 2:
-		*val = get_unaligned_be16(sigma_delta->data);
+		*val = get_unaligned_be16(sigma_delta->rx_buf);
 		break;
 	case 1:
-		*val = sigma_delta->data[0];
+		*val = sigma_delta->rx_buf[0];
 		break;
 	default:
 		ret = -EINVAL;
@@ -395,11 +395,9 @@ static irqreturn_t ad_sd_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ad_sigma_delta *sigma_delta = iio_device_get_drvdata(indio_dev);
+	uint8_t *data = sigma_delta->rx_buf;
 	unsigned int reg_size;
 	unsigned int data_reg;
-	uint8_t data[16];
-
-	memset(data, 0x00, 16);
 
 	reg_size = indio_dev->channels[0].scan_type.realbits +
 			indio_dev->channels[0].scan_type.shift;
diff --git a/include/linux/iio/adc/ad_sigma_delta.h b/include/linux/iio/adc/ad_sigma_delta.h
index a3a838dcf8e4..7199280d89ca 100644
--- a/include/linux/iio/adc/ad_sigma_delta.h
+++ b/include/linux/iio/adc/ad_sigma_delta.h
@@ -79,8 +79,12 @@ struct ad_sigma_delta {
 	/*
 	 * DMA (thus cache coherency maintenance) requires the
 	 * transfer buffers to live in their own cache lines.
+	 * 'tx_buf' is up to 32 bits.
+	 * 'rx_buf' is up to 32 bits per sample + 64 bit timestamp,
+	 * rounded to 16 bytes to take into account padding.
 	 */
-	uint8_t				data[4] ____cacheline_aligned;
+	uint8_t				tx_buf[4] ____cacheline_aligned;
+	uint8_t				rx_buf[16] __aligned(8);
 };
 
 static inline int ad_sigma_delta_set_channel(struct ad_sigma_delta *sd,

