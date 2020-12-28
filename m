Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2CD2E363E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgL1LNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:13:25 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50687 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727172AbgL1LNY (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Dec 2020 06:13:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DF81F811;
        Mon, 28 Dec 2020 06:12:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:12:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PQx3Ba
        iQWarbkpWIBEFmuVQFu325pvhSpcog3isC1hI=; b=NzgX/gpfjuqdCm8KutNEFo
        nqq1Tsh5BJclCiu5Sj/e5A1hqQwe6DckDZViwBG8R/3A7W97Xy1le8rwEyIJbBgM
        JojzOoUg6d9bqzmFht9AqZY6y4rKw0vOyu3pwa0kZoGXHGqiOyrKBX0qxvPSjo0/
        rKo1rP26BO4IXnG3C6TPp1NxIG+EYYq3XcdvLVZ967GU2K++1HkS3vmmTKGEyNip
        +l4tiNKASfnWGJv6ybm5eu+V1900XxeUOW1fHf65dDVi5MB2hBMNKUjoQ3n1wCKU
        HgSyCduwWQVxAEoi0n2U+ohq4sgjlPnfQRIK3ssB2e7SkMWMBsYDWtgheSjjZn3g
        ==
X-ME-Sender: <xms:kr3pX77lPNwEYwdJhs2trTsaZkE0qamShTTtMwyPGpnz3IA8PxWBQw>
    <xme:kr3pXw6idFPfK8C6UhVABwAaRc0f6-wfydIVnPCtNMNCF-UsIjIcVFHo6U6RNH5zu
    cbaKC9DXiAy2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:kr3pXyfsidK7Jh1tvYSYnE5pOz4kvHYUuFIraJtbbm5Pv5t7Q6cyLg>
    <xmx:kr3pX8ICvFlBCaqx43BNQtz1kUicHbYRIGtbwLs7UVBNlfmgKrkELA>
    <xmx:kr3pX_I8oyI3c1b6F-JDK1PWh-2lpOOuNVkMc7tfX8OrGdkf2R5rGw>
    <xmx:kr3pX1jkU1ar9s-3S1t9Ew6wQPVcBSR9Tbn013Wye4NgUuC7EYZGrUwEprY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3980B24005C;
        Mon, 28 Dec 2020 06:12:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio:magnetometer:mag3110: Fix alignment and data leak issues." failed to apply to 4.9-stable tree
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, lars@metafoo.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:13:40 +0100
Message-ID: <160915402011278@kroah.com>
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

From 89deb1334252ea4a8491d47654811e28b0790364 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 20 Sep 2020 12:27:37 +0100
Subject: [PATCH] iio:magnetometer:mag3110: Fix alignment and data leak issues.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp() assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data.
This data is allocated with kzalloc() so no data can leak apart from
previous readings.

The explicit alignment of ts is not necessary in this case but
does make the code slightly less fragile so I have included it.

Fixes: 39631b5f9584 ("iio: Add Freescale mag3110 magnetometer driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-4-jic23@kernel.org

diff --git a/drivers/iio/magnetometer/mag3110.c b/drivers/iio/magnetometer/mag3110.c
index 838b13c8bb3d..c96415a1aead 100644
--- a/drivers/iio/magnetometer/mag3110.c
+++ b/drivers/iio/magnetometer/mag3110.c
@@ -56,6 +56,12 @@ struct mag3110_data {
 	int sleep_val;
 	struct regulator *vdd_reg;
 	struct regulator *vddio_reg;
+	/* Ensure natural alignment of timestamp */
+	struct {
+		__be16 channels[3];
+		u8 temperature;
+		s64 ts __aligned(8);
+	} scan;
 };
 
 static int mag3110_request(struct mag3110_data *data)
@@ -387,10 +393,9 @@ static irqreturn_t mag3110_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct mag3110_data *data = iio_priv(indio_dev);
-	u8 buffer[16]; /* 3 16-bit channels + 1 byte temp + padding + ts */
 	int ret;
 
-	ret = mag3110_read(data, (__be16 *) buffer);
+	ret = mag3110_read(data, data->scan.channels);
 	if (ret < 0)
 		goto done;
 
@@ -399,10 +404,10 @@ static irqreturn_t mag3110_trigger_handler(int irq, void *p)
 			MAG3110_DIE_TEMP);
 		if (ret < 0)
 			goto done;
-		buffer[6] = ret;
+		data->scan.temperature = ret;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 		iio_get_time_ns(indio_dev));
 
 done:

