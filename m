Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E972E3643
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgL1LOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:14:19 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:54673 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgL1LOT (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Dec 2020 06:14:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2643C19426E8;
        Mon, 28 Dec 2020 06:13:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:13:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AGw2kx
        +lieLy7xpDTCn3Jvx9xtSAvEzBBBs/uPYQMiw=; b=BgEv5Rkm6LQ6p4rt8TbhEt
        EUDiePHN/UhbCQbjpPP2QcoV7OBQeRn9lwzsqa1u8JvCZS9qnq4Mekxca3/Wc3eG
        jjc4yhyLbaR48560zZ//C9A3skGY6vdDBwezJhTO+OzL57hFxtc/rA5j2YR+ecA+
        rFrOW+vj5ZnX+VTYNQ2J4tpwCr248XjgWd/R2TSg7vUA9yF72mIMTQdGG/CXNUF/
        6vtSryYcqaB4vsKlrmygbFm1+rGZWo2nUoyCiQm3FWIFgljnt0ReGUr0xV0eI7u9
        PcXJBlQ7+UhBLpWo9V5tOdS6Crz+tdqxK1xnY4CJ7YdvOFEJ348zp+4rZXa64YqQ
        ==
X-ME-Sender: <xms:yb3pX18WdxrR_vLEPnNnJGIiJ2gCRR-5-2Psc1tAKjsioDKwoDao6g>
    <xme:yb3pX5v8V4xC_fef0wrYPPa1gySp3g7gBaU-ZFkd2Cd0MIw41WExXIU--wVhe6DbL
    OCO3QCsMUtTLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:yb3pXzAorg7NWJQgRKLQ7lDysBdeAWJGVkqsDpHKowKwLbtuBGtN9w>
    <xmx:yb3pX5eoZanWkWW73VUGSrLPVWeUxROiPLxiEmrZwlCusmlmE1f2ZQ>
    <xmx:yb3pX6M2OA9RcKsFVI1TR-duc0gg5xn0SVOEZISpNY0qBqmw1Aa0Kw>
    <xmx:yb3pX3rVYXqJ76XCoNxap1izpihGyWVmOwHE9CQksoFx1wYNPjXtJg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C8AB724005B;
        Mon, 28 Dec 2020 06:13:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio:imu:bmi160: Fix alignment and data leak issues" failed to apply to 5.4-stable tree
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, daniel.baluta@gmail.com,
        daniel.baluta@oss.nxp.com, lars@metafoo.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:14:30 +0100
Message-ID: <160915407049123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 7b6b51234df6cd8b04fe736b0b89c25612d896b8 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 20 Sep 2020 12:27:39 +0100
Subject: [PATCH] iio:imu:bmi160: Fix alignment and data leak issues

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable array in the iio_priv() data with alignment
explicitly requested.  This data is allocated with kzalloc() so no
data can leak apart from previous readings.

In this driver, depending on which channels are enabled, the timestamp
can be in a number of locations.  Hence we cannot use a structure
to specify the data layout without it being misleading.

Fixes: 77c4ad2d6a9b ("iio: imu: Add initial support for Bosch BMI160")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Daniel Baluta  <daniel.baluta@gmail.com>
Cc: Daniel Baluta <daniel.baluta@oss.nxp.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-6-jic23@kernel.org

diff --git a/drivers/iio/imu/bmi160/bmi160.h b/drivers/iio/imu/bmi160/bmi160.h
index a82e040bd109..32c2ea2d7112 100644
--- a/drivers/iio/imu/bmi160/bmi160.h
+++ b/drivers/iio/imu/bmi160/bmi160.h
@@ -10,6 +10,13 @@ struct bmi160_data {
 	struct iio_trigger *trig;
 	struct regulator_bulk_data supplies[2];
 	struct iio_mount_matrix orientation;
+	/*
+	 * Ensure natural alignment for timestamp if present.
+	 * Max length needed: 2 * 3 channels + 4 bytes padding + 8 byte ts.
+	 * If fewer channels are enabled, less space may be needed, as
+	 * long as the timestamp is still aligned to 8 bytes.
+	 */
+	__le16 buf[12] __aligned(8);
 };
 
 extern const struct regmap_config bmi160_regmap_config;
diff --git a/drivers/iio/imu/bmi160/bmi160_core.c b/drivers/iio/imu/bmi160/bmi160_core.c
index c8e131c29043..290b5ef83f77 100644
--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -427,8 +427,6 @@ static irqreturn_t bmi160_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	__le16 buf[12];
-	/* 2 sens x 3 axis x __le16 + 2 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 
@@ -438,10 +436,10 @@ static irqreturn_t bmi160_trigger_handler(int irq, void *p)
 				       &sample, sizeof(sample));
 		if (ret)
 			goto done;
-		buf[j++] = sample;
+		data->buf[j++] = sample;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(indio_dev, data->buf, pf->timestamp);
 done:
 	iio_trigger_notify_done(indio_dev->trig);
 	return IRQ_HANDLED;

