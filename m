Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42C637B896
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhELIwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:52:50 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:40855 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230295AbhELIwt (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 12 May 2021 04:52:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 476791940414;
        Wed, 12 May 2021 04:51:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 04:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eKxa7F
        INuaR4MK4w11nVKgtSZ76V83X+WUGGC+w4tCk=; b=FYOFMT6NS6IrqDea2g9SO4
        RCOI6av/9TlLm80xe5qk1oXDFq/hG2SOHahXdo7cnQanS1athZqSgMAu1c6ELVcK
        pDYAzJslKbl1eyMTfBMB317be97Z+nvRGKAxbIbKrp+codXtFBVw67m8AHFeAMET
        QAhQaUEGSKAG1x92H7J7PY9qAZsd9jI+Be7hsdoUYI4u3RmqB/0UTX1vkdEfscel
        raCmCsjfRQFe6wKwvAWi7IeAEI6bZ/li5VZkFTKPYabApTUz5JsM/3fEqkKA057F
        JCP6kvTl1LAAKY08AMJA9H0FEoWGI02ixMKCaiK0HqgZWx1BC4tSFQST0NFVmIgQ
        ==
X-ME-Sender: <xms:HJebYCyQinUff7_SXQyTeKI_Hz2RMWYa7Gmq6_wv171HWxvBKXboPw>
    <xme:HJebYOQGDeI8MC4kcdbjC035A2htB5gG25CqZFpJdytE9dH14GPyqm991AWP-8SwR
    wwKvE-ZSrrSyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:HJebYEUfTf342ZEfXaS5Q21luGg7eGmZBknZtT8z_GosEcVFpo_v_Q>
    <xmx:HJebYIi6bRIdyQ3sVZnGTR4WjzZoLRc55fsUNvhOtsZXJkBd8caa5w>
    <xmx:HJebYEBg8o-rkHaFXtKccu4m4-2lyy1c1uutp99TSCnaHXywAXYKgg>
    <xmx:HZebYHM1EX5Z7P2m4Wc-cAfjuwJqi1FLT7v8s0PY3Cnp4CR2RFLSig>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:51:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: inv_mpu6050: Fully validate gyro and accel scale writes" failed to apply to 4.9-stable tree
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, jmaneyrol@invensense.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:51:30 +0200
Message-ID: <162080949063171@kroah.com>
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

From e09fe9135399807b8397798a53160e055dc6c29f Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Mon, 5 Apr 2021 13:44:41 +0200
Subject: [PATCH] iio: inv_mpu6050: Fully validate gyro and accel scale writes

When setting the gyro or accelerometer scale the inv_mpu6050 driver ignores
the integer part of the value. As a result e.g. all of 0.13309, 1.13309,
12345.13309, ... are accepted as a valid gyro scale and 0.13309 is the
scale that gets set in all those cases.

Make sure to check that the integer part of the scale value is 0 and reject
it otherwise.

Fixes: 09a642b78523 ("Invensense MPU6050 Device Driver.")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Link: https://lore.kernel.org/r/20210405114441.24167-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index cda7b48981c9..6244a07048df 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -731,12 +731,16 @@ inv_mpu6050_read_raw(struct iio_dev *indio_dev,
 	}
 }
 
-static int inv_mpu6050_write_gyro_scale(struct inv_mpu6050_state *st, int val)
+static int inv_mpu6050_write_gyro_scale(struct inv_mpu6050_state *st, int val,
+					int val2)
 {
 	int result, i;
 
+	if (val != 0)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(gyro_scale_6050); ++i) {
-		if (gyro_scale_6050[i] == val) {
+		if (gyro_scale_6050[i] == val2) {
 			result = inv_mpu6050_set_gyro_fsr(st, i);
 			if (result)
 				return result;
@@ -767,13 +771,17 @@ static int inv_write_raw_get_fmt(struct iio_dev *indio_dev,
 	return -EINVAL;
 }
 
-static int inv_mpu6050_write_accel_scale(struct inv_mpu6050_state *st, int val)
+static int inv_mpu6050_write_accel_scale(struct inv_mpu6050_state *st, int val,
+					 int val2)
 {
 	int result, i;
 	u8 d;
 
+	if (val != 0)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(accel_scale); ++i) {
-		if (accel_scale[i] == val) {
+		if (accel_scale[i] == val2) {
 			d = (i << INV_MPU6050_ACCL_CONFIG_FSR_SHIFT);
 			result = regmap_write(st->map, st->reg->accl_config, d);
 			if (result)
@@ -814,10 +822,10 @@ static int inv_mpu6050_write_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_SCALE:
 		switch (chan->type) {
 		case IIO_ANGL_VEL:
-			result = inv_mpu6050_write_gyro_scale(st, val2);
+			result = inv_mpu6050_write_gyro_scale(st, val, val2);
 			break;
 		case IIO_ACCEL:
-			result = inv_mpu6050_write_accel_scale(st, val2);
+			result = inv_mpu6050_write_accel_scale(st, val, val2);
 			break;
 		default:
 			result = -EINVAL;

