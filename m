Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE631223F24
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 17:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgGQPJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 11:09:02 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:60547 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbgGQPJC (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 17 Jul 2020 11:09:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 68CD1F54;
        Fri, 17 Jul 2020 11:09:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 17 Jul 2020 11:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RQ2EWv
        H6H/FHOexdT5GdekIdx8vI6AmKqCrcHPQJ6yQ=; b=kp2C02etJvhVyDSP6WFfV/
        OE9Y8RUSJbq9wbQB8Fd1UI8kPMEMGGZmhzgFL68DSv487KAJI+nas9ivFSMRByrM
        lCBiYVwG7gyFDlKEovkFNieWXbJ8UatnukZdUD1SGAeJcGDl2m04wsWNKRdxiK6a
        6IGjEXKpPX0U2UKGS0E1t5L67hz6slInTMaKDQuGqINDRTQ1UeCvPT1d/qEV9F9N
        Vxu25aYvFDxZNi7/gJZeh2eRAYmNytFWW1duOrPdyzOwW6jVVqSAvu77q/6mgVkY
        IgKtdkEkE29v53ZAo4k6teRozUPIXX9GmvaKl7Guu3PoWNfWw4m/F7tD1kXn2bqQ
        ==
X-ME-Sender: <xms:DL8RX_L6KqufEj3TAUfJgLu0NolWfUfJ7bLymKhSKJf8kQKVbZFSRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfeeigdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:DL8RXzJh0PkRkE6MWdNM0irv64Pv5mBPWuoCMTlURyERX-_vYzo0Sw>
    <xmx:DL8RX3umhIJT1RfFNXKUQsG9vcdZBwi70R0Ht5zh44x56OXK5fJVdw>
    <xmx:DL8RX4bQVCjtYSEij9s5S8n9qU-BzOjNOF9d6zhgr1Ak4rsfuxreBw>
    <xmx:Db8RX_D3k9P5KimRHehzpsswJ52zh5c1RDKEXx3DD_g72bo_NBojhgdiPUM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B33C328006A;
        Fri, 17 Jul 2020 11:08:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio:humidity:hts221 Fix alignment and data leak issues" failed to apply to 4.14-stable tree
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        lars@metafoo.de, lorenzo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Jul 2020 17:08:52 +0200
Message-ID: <1594998532206185@kroah.com>
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

From 5c49056ad9f3c786f7716da2dd47e4488fc6bd25 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 7 Jun 2020 16:53:53 +0100
Subject: [PATCH] iio:humidity:hts221 Fix alignment and data leak issues

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data.
This data is allocated with kzalloc so no data can leak
apart from previous readings.

Explicit alignment of ts needed to ensure consistent padding
on all architectures (particularly x86_32 with it's 4 byte alignment
of s64)

Fixes: e4a70e3e7d84 ("iio: humidity: add support to hts221 rh/temp combo device")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>

diff --git a/drivers/iio/humidity/hts221.h b/drivers/iio/humidity/hts221.h
index 7d6771f7cf47..b2eb5abeaccd 100644
--- a/drivers/iio/humidity/hts221.h
+++ b/drivers/iio/humidity/hts221.h
@@ -14,8 +14,6 @@
 
 #include <linux/iio/iio.h>
 
-#define HTS221_DATA_SIZE	2
-
 enum hts221_sensor_type {
 	HTS221_SENSOR_H,
 	HTS221_SENSOR_T,
@@ -39,6 +37,11 @@ struct hts221_hw {
 
 	bool enabled;
 	u8 odr;
+	/* Ensure natural alignment of timestamp */
+	struct {
+		__le16 channels[2];
+		s64 ts __aligned(8);
+	} scan;
 };
 
 extern const struct dev_pm_ops hts221_pm_ops;
diff --git a/drivers/iio/humidity/hts221_buffer.c b/drivers/iio/humidity/hts221_buffer.c
index 9fb3f33614d4..ba7d413d75ba 100644
--- a/drivers/iio/humidity/hts221_buffer.c
+++ b/drivers/iio/humidity/hts221_buffer.c
@@ -160,7 +160,6 @@ static const struct iio_buffer_setup_ops hts221_buffer_ops = {
 
 static irqreturn_t hts221_buffer_handler_thread(int irq, void *p)
 {
-	u8 buffer[ALIGN(2 * HTS221_DATA_SIZE, sizeof(s64)) + sizeof(s64)];
 	struct iio_poll_func *pf = p;
 	struct iio_dev *iio_dev = pf->indio_dev;
 	struct hts221_hw *hw = iio_priv(iio_dev);
@@ -170,18 +169,20 @@ static irqreturn_t hts221_buffer_handler_thread(int irq, void *p)
 	/* humidity data */
 	ch = &iio_dev->channels[HTS221_SENSOR_H];
 	err = regmap_bulk_read(hw->regmap, ch->address,
-			       buffer, HTS221_DATA_SIZE);
+			       &hw->scan.channels[0],
+			       sizeof(hw->scan.channels[0]));
 	if (err < 0)
 		goto out;
 
 	/* temperature data */
 	ch = &iio_dev->channels[HTS221_SENSOR_T];
 	err = regmap_bulk_read(hw->regmap, ch->address,
-			       buffer + HTS221_DATA_SIZE, HTS221_DATA_SIZE);
+			       &hw->scan.channels[1],
+			       sizeof(hw->scan.channels[1]));
 	if (err < 0)
 		goto out;
 
-	iio_push_to_buffers_with_timestamp(iio_dev, buffer,
+	iio_push_to_buffers_with_timestamp(iio_dev, &hw->scan,
 					   iio_get_time_ns(iio_dev));
 
 out:

