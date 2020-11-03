Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF992A4804
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgKCO0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:26:32 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:44135 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729730AbgKCO03 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 3 Nov 2020 09:26:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1C8EB194275C;
        Tue,  3 Nov 2020 09:26:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:26:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=S0MkwF
        ktGevRcUW/gVfh2spJ0Z0oyRB22N2y5NDJrgU=; b=BxHJ2cudWEjIxF9P5MzkHb
        4bcE6Wez+tdTscrjRrzABclHLGkAjYbETgeZjoJkaVooQ8KmCYj6e8Xsb5T0irHa
        Tv1xUuLWhyb/fTiKDOD4wKQa2VrGrAlXvPZyuFDXtb6OD1zYwng7GddRtJq4H7Wt
        pNC9J2t1IyVCo4eJy8z+BrakNEZo6qU8kVzblnfkGJxbInbogmrIVpRkoPIDXqRy
        RzsRe9V1li/zxcaWY7GiXKeEY/tgeFdYCSmKUbiY42OM86XKvKD6twD8KRVESoIh
        ahX6GjcWUOOf9XlR2PjfQckhtI8UEW28nYPXS6LVJ7fFMS81blDPf4/y0iyqbfjA
        ==
X-ME-Sender: <xms:k2ihX2DDlHpkiYZi4qWU8EzxZT8tFjsdqxUTC4K94cobVhL4Svvf4Q>
    <xme:k2ihXwiMVX0pe52HxHuQEmBoxBPmGFQq8RUHA6Wj5mFuCAaNgysbAS4J11SHgCWM6
    N14fK3oLXqRjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:k2ihX5kn_DcMghNG5zyvm94u4B8dEP0nSzSnkmoKvOfHHEt6IkeYFA>
    <xmx:k2ihX0y-39VSWn8bYJTuUm6ZPAcSMFLrinWhoZE3K-ut-EUAi7nr0A>
    <xmx:k2ihX7QSkKfLZqdBDhjovJ-n_R94D4SLX4fMFVc_cFJ1APdVS-XqLg>
    <xmx:lGihX2dC_1FHdRAizOXLso53xHgGnGu4G05ExlMo4uDfn3Jcy5kU2Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52EB23064674;
        Tue,  3 Nov 2020 09:26:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio:imu:inv_mpu6050 Fix dma and ts alignment and data leak" failed to apply to 4.9-stable tree
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, jmaneyrol@invensense.com,
        lars@metafoo.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:27:21 +0100
Message-ID: <160441364116699@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 6b0cc5dce0725ae8f1a2883514da731c55eeb35e Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:53 +0100
Subject: [PATCH] iio:imu:inv_mpu6050 Fix dma and ts alignment and data leak
 issues.

This case is a bit different to the rest of the series.  The driver
was doing a regmap_bulk_read into a buffer that wasn't dma safe
as it was on the stack with no guarantee of it being in a cacheline
on it's own.   Fixing that also dealt with the data leak and
alignment issues that Lars-Peter pointed out.

Also removed some unaligned handling as we are now aligned.

Fixes tag is for the dma safe buffer issue. Potentially we would
need to backport timestamp alignment futher but that is a totally
different patch.

Fixes: fd64df16f40e ("iio: imu: inv_mpu6050: Add SPI support for MPU6000")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200722155103.979802-18-jic23@kernel.org

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
index cd38b3fccc7b..eb522b38acf3 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -122,6 +122,13 @@ struct inv_mpu6050_chip_config {
 	u8 user_ctrl;
 };
 
+/*
+ * Maximum of 6 + 6 + 2 + 7 (for MPU9x50) = 21 round up to 24 and plus 8.
+ * May be less if fewer channels are enabled, as long as the timestamp
+ * remains 8 byte aligned
+ */
+#define INV_MPU6050_OUTPUT_DATA_SIZE         32
+
 /**
  *  struct inv_mpu6050_hw - Other important hardware information.
  *  @whoami:	Self identification byte from WHO_AM_I register
@@ -165,6 +172,7 @@ struct inv_mpu6050_hw {
  *  @magn_raw_to_gauss:	coefficient to convert mag raw value to Gauss.
  *  @magn_orient:       magnetometer sensor chip orientation if available.
  *  @suspended_sensors:	sensors mask of sensors turned off for suspend
+ *  @data:		dma safe buffer used for bulk reads.
  */
 struct inv_mpu6050_state {
 	struct mutex lock;
@@ -190,6 +198,7 @@ struct inv_mpu6050_state {
 	s32 magn_raw_to_gauss[3];
 	struct iio_mount_matrix magn_orient;
 	unsigned int suspended_sensors;
+	u8 data[INV_MPU6050_OUTPUT_DATA_SIZE] ____cacheline_aligned;
 };
 
 /*register and associated bit definition*/
@@ -334,9 +343,6 @@ struct inv_mpu6050_state {
 #define INV_ICM20608_TEMP_OFFSET	     8170
 #define INV_ICM20608_TEMP_SCALE		     3059976
 
-/* 6 + 6 + 2 + 7 (for MPU9x50) = 21 round up to 24 and plus 8 */
-#define INV_MPU6050_OUTPUT_DATA_SIZE         32
-
 #define INV_MPU6050_REG_INT_PIN_CFG	0x37
 #define INV_MPU6050_ACTIVE_HIGH		0x00
 #define INV_MPU6050_ACTIVE_LOW		0x80
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
index b533fa2dad0a..d8e6b88ddffc 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -13,7 +13,6 @@
 #include <linux/interrupt.h>
 #include <linux/poll.h>
 #include <linux/math64.h>
-#include <asm/unaligned.h>
 #include "inv_mpu_iio.h"
 
 /**
@@ -121,7 +120,6 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 	struct inv_mpu6050_state *st = iio_priv(indio_dev);
 	size_t bytes_per_datum;
 	int result;
-	u8 data[INV_MPU6050_OUTPUT_DATA_SIZE];
 	u16 fifo_count;
 	s64 timestamp;
 	int int_status;
@@ -160,11 +158,11 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 	 * read fifo_count register to know how many bytes are inside the FIFO
 	 * right now
 	 */
-	result = regmap_bulk_read(st->map, st->reg->fifo_count_h, data,
-				  INV_MPU6050_FIFO_COUNT_BYTE);
+	result = regmap_bulk_read(st->map, st->reg->fifo_count_h,
+				  st->data, INV_MPU6050_FIFO_COUNT_BYTE);
 	if (result)
 		goto end_session;
-	fifo_count = get_unaligned_be16(&data[0]);
+	fifo_count = be16_to_cpup((__be16 *)&st->data[0]);
 
 	/*
 	 * Handle fifo overflow by resetting fifo.
@@ -182,7 +180,7 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 	inv_mpu6050_update_period(st, pf->timestamp, nb);
 	for (i = 0; i < nb; ++i) {
 		result = regmap_bulk_read(st->map, st->reg->fifo_r_w,
-					  data, bytes_per_datum);
+					  st->data, bytes_per_datum);
 		if (result)
 			goto flush_fifo;
 		/* skip first samples if needed */
@@ -191,7 +189,7 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 			continue;
 		}
 		timestamp = inv_mpu6050_get_timestamp(st);
-		iio_push_to_buffers_with_timestamp(indio_dev, data, timestamp);
+		iio_push_to_buffers_with_timestamp(indio_dev, st->data, timestamp);
 	}
 
 end_session:

