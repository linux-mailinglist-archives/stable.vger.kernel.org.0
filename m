Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C982E363C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgL1LNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:13:12 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:37129 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727094AbgL1LNL (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Dec 2020 06:13:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9015A82C;
        Mon, 28 Dec 2020 06:12:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TK0yNB
        UIxmFCx4brGIWY49xiB2PJrYrdB8eN3owvzgg=; b=A5Xy+KaMevCjfpFw7jmiC6
        cbpq2WUWQQEDGvZKgKzhqtprLEYgsombHFUsqy0+1XHacbhwxdgT8cuYmPWxFvdT
        GRIzOlh3zyxhzrkOl3lWJ3W0lIc2V3AxOjtvOjq6I//rhv6UISI2fCX+t776vWUK
        Fql1FXOz38G2voSdWussXuJmqL6oZ9cUnJtwAw0ar1lBoyulJSXOC2yGIVEapXrf
        eXQVPpVtBhn8suPo9c/3f8BdBbRyHZ/y9xv4U5CVOJARjP1W8LRHlRVpAvC2rHby
        qYk5gtKFUP64cnWk8Ween4vYtPgLaLTF6VuAm3Sw/G+XLiSX1Rj2zNnTUjEPFGLA
        ==
X-ME-Sender: <xms:mb3pXwNjjLW4MiIf-B4GTgBCFr5Ciz_im_PUmHrfSikcfS7ZCpiyPQ>
    <xme:mb3pX2_2dJbp8pkxZ3ztsIG-4CNqCI20mJI1ChAwNLkHI0TUveuLe0_jbC1VYTuBV
    1qN8YM42r-Ckw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:mb3pX3T_6Ix5xoxOybZHBQpZCMIzZkh9Zp8xwnVZBROHfdyrcnYuAw>
    <xmx:mb3pX4toirB94QBHZidgb6siAtGR-lSXiaTz8jNtd3zyA8WruZuMuw>
    <xmx:mb3pX4cpQ6ulK36dHGmsSoorBbbAxeKGnkFh6w3Uyf36geo1j_JVfg>
    <xmx:mb3pX0HaM0UajLlY_uOZB6QclLKayNravvlI6WKXCp-MGm40eKZUMfGi2RE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D597824005E;
        Mon, 28 Dec 2020 06:12:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio:magnetometer:mag3110: Fix alignment and data leak issues." failed to apply to 4.19-stable tree
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, lars@metafoo.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:13:42 +0100
Message-ID: <160915402290189@kroah.com>
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

