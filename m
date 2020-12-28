Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733242E363D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgL1LNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:13:23 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50915 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727211AbgL1LNX (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Dec 2020 06:13:23 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 651FC82B;
        Mon, 28 Dec 2020 06:12:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qnUhiK
        xiXZki3n9J8QtpK8R9qwz9Ug+KoKIaQXVfLPU=; b=pO6ZtciX2o5U7xyp8D63o8
        NdB9KyeJ1HspR3uYyDN89UNEeW2Dv6GXKaUCmR89+IVykJBYIjnb4m3efuPzad4+
        UgnUXAlKSH6lckHz2hqFN0l35ySKAqyfKcAD9i6eZeHEfAJXdalTPOs2mrTpgUCI
        Y1Jv9bxFjzx14ARVnN5dB3sZB6CqJImaN7VDBiF6LArL2DID1PxVDOE93B2OzTnQ
        JFVGT9oW7GEWFcLmEvYIZabihEulVIv90kTyPQMuDpSP1rl6h3bAu9vRfGe11SsA
        ZZdTQzV3T0RStqG9wfiOqNLE5HUcyzlOFTbbeFro8XEmX326yZvY7rJ3tL45F14Q
        ==
X-ME-Sender: <xms:kL3pXy3SLLpr-tk36iJ72pEnId2wLuOepFc6Qvif-nHLm_f1DPnkZw>
    <xme:kL3pX1EHXJnXr7CI18HXm3yN2u8kQhxJ_pYyPo9lT3NEX-wKnDEH8nKn1QdadfhqR
    7uM7UKJCM8-NQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:kL3pX647zu5T-WXz0X67eGmS59eGWm-EcoO8O4fF9h1rR3ZVaWyx6w>
    <xmx:kL3pXz0puSRJem1q3Q654xWI4qlKq5CKRbwrZiI7v8HTqzPLnj8_Wg>
    <xmx:kL3pX1EhYyT-kf-BFtBjRbemAnvFaCTKNfrWBFt2WkIBAEwyAht-eQ>
    <xmx:kb3pXzM_o7B1k3QGJvNUE9Dzdg-G3BIZ9hSISx1TEqIIL8bQbJ44cYJwVpU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 164F9108005B;
        Mon, 28 Dec 2020 06:12:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio:magnetometer:mag3110: Fix alignment and data leak issues." failed to apply to 4.4-stable tree
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, lars@metafoo.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:13:39 +0100
Message-ID: <16091540199679@kroah.com>
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

