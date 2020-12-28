Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9112E363B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgL1LNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:13:07 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51433 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727211AbgL1LNG (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Dec 2020 06:13:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D49B1804;
        Mon, 28 Dec 2020 06:12:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:12:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qEvPmu
        0ktFSolw1Jr8c/2wq9cvqstbx0QRjV2hCFFIg=; b=oF9X/Y+OIA8hBeWRvkbPyq
        6tgfxtc44kicCG4waNZghPGJ7HJ4pj+Lo/iuZT3oVPwNVlN2A8lF9gTLhV97XS27
        s7EJu7B8O4RTc0hxYmtG7C37zBrT74up45Tln+hpZX20XNyTR2lrkpOV2ZK4wZ1w
        A7sU6lHm0HEMoweZ7nMIktn6OEzbGvBI5n5K7oQO9aFaZnUxKw9nKMfMLZDr3Wy5
        Ya52dsy2PRbAaP0gJVYtaJ2/0jGr1y7UFEEXFYHnB9tME6kUt8gsgNWFhTRThLu5
        QCbX/cORFgUdn8PVQWuoK0VgNsrV+QBt/CaR438uWBq0mp5X1LMr98NjalKBPevg
        ==
X-ME-Sender: <xms:lL3pX-3u1tE9YHlwRvbvpJXCKwqu2kyIACp4es_IGLcdenoYksTuyA>
    <xme:lL3pXxHFnoN__R30j2FZzDuuKGKCw69waaB6U__hrgRGcBM1vN5NReeHkdmFN2oa5
    CN_NRES0eE0EQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:lL3pX26GsxBnQGHoEvc7eCSqnfAEUDbbBLHoHFT_xSqieY-hU2jMzA>
    <xmx:lL3pX_18gv1gTFs-7xlNIA5HqSOCv7u6KH-m-qC9Mz8bym7S-enZhQ>
    <xmx:lL3pXxFKWggJknOg0OVrWDZ5W-LXLwYZ11mzKnYk0fh8Y7ZluMi1PQ>
    <xmx:lL3pX_NKWwhgW2uTbkoZOOUq9gFJK-30jEWYil4_ySHGsCp_nC9Q9iAZ-R4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 27979108005B;
        Mon, 28 Dec 2020 06:12:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio:magnetometer:mag3110: Fix alignment and data leak issues." failed to apply to 4.14-stable tree
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, lars@metafoo.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:13:41 +0100
Message-ID: <1609154021184226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

