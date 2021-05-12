Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D58537B895
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhELIwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:52:44 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:54607 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230474AbhELIwk (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 12 May 2021 04:52:40 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6440E19406E1;
        Wed, 12 May 2021 04:51:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 12 May 2021 04:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OHSTnW
        HTzyQsIZplEtfDm+RSVcSMiWdboPmpYYEwsiI=; b=jMUYSIg+tzufPDoptFNmh5
        HEig8mXLA7dJBtgAGjN3wJ6hJPEv+b7ke6EVDt6eA9esfEB4Jvl7D4nxOSQWZF5G
        xHUQ4CDdbIcjEZas6qdM83l4YrN/Ev8W5bZMnFviJl684jLt/Li03n4ncYhHrSTS
        SDeYxJfHRB4cwiayCFfdbeE9X57noMQJ2zKZ6RH6K6ER8XGn+g5IIgeSJgFpsDoi
        /PqBCu1S17xc6uDrTxDJcw6ig2ye4zVDI2c+X3YRzqoLYKkoQxmZO/Batqz86xh8
        jOujx8WmfCH66Z3jNuJpEpOwJdbUh5340dURkNBvF6Uk3C5xcqjgxscU7csafmBQ
        ==
X-ME-Sender: <xms:FJebYFEgo2PpwExg5x6e9cBK0b3DM6mOh_Je_i-X2eAHgs7XPwJFqg>
    <xme:FJebYKWkH0yHK_HNkZA44axI2RwK6isgIPbKGO23IHe_b3eqY4TpV-U41YPPfxV79
    2xjG_0yyEehHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:FJebYHKw4awMU8PcdEo2de6O-2RrUeTnOsBKkF5jz2Ca0OLi2uKrMw>
    <xmx:FJebYLH4mSqTcMSrgRyIdbO4GyoBE0DNFg96XHHkaBRMwRpK55k7XA>
    <xmx:FJebYLWtbXYEC2AANg5PTtT5IyEt-Yrn2qks19_V7mCxVHGbDfj9HQ>
    <xmx:FJebYIjc-qXMKdoFSoANNHOwpe7QhGbtuOuYN8KXGsZOpzQ7gkn0lA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:51:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: inv_mpu6050: Fully validate gyro and accel scale writes" failed to apply to 4.4-stable tree
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, jmaneyrol@invensense.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:51:30 +0200
Message-ID: <162080949015171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

