Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFBB2EB35E
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 20:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbhAETOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 14:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbhAETOV (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 5 Jan 2021 14:14:21 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85969C061793
        for <Stable@vger.kernel.org>; Tue,  5 Jan 2021 11:13:40 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id w5so242625wrm.11
        for <Stable@vger.kernel.org>; Tue, 05 Jan 2021 11:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VRetRHUNghp1koouvBNUCrPuH8hLkB3TVhP5MPjY9PI=;
        b=NgYwq5ERTccCG/2ek3Vr46DvhdwbM+CVkrqN36gUp2z4mIKqV/83OosfSkr9ER10zR
         3CVKkdweDtK354ouTLJDk94KkMb8qULGFvweszNecXeflkL3lKMftsBN5g0jHxRTKySx
         64entUjeA03AYhH92YMz/OFK+FXpFV5WQ3QJwnXTJvCoj7Mobh36z9EucYoLwy9A3T2S
         akhc3APhna0DA697GjgEJnbTrn5FmCX+JNMJztKU/LneZAr4jEc/6+E1r+toNER+dDD3
         yEGkiJ2giKyjpnWgXRvV74iz901w51jQu6NHfvJisxLMHbt83NVdTgS36vgHPagVoSPZ
         xUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VRetRHUNghp1koouvBNUCrPuH8hLkB3TVhP5MPjY9PI=;
        b=aJk5LICLTR6af6M4bdwEb/7GqSEevYcaDQX2lg+f4Dkz8acECn2OV7e1dZHznEEgQ9
         GvRiOoTxyATXJGIAPR8RL4zLupagdDELQG3H+OI3a8d7+1ugtYl4/sHC0f7fAcx6Nkbm
         jb+AURE93qFowRNhcDPsc5aIiLhRMMhX1AXSZ5Eiy/3dc8CwDmvdzxhAGm4tQX1oZLkw
         ASpCEQoRMOY4RWt+YKN7DcgycvgUL2JRhOOc2vSHC1RTPooSrkRQoNq8U85dptjgw4HZ
         VONMPf2f3FkxUIxFRSVsFqr56mG/yOBpSAoPLTfQALNsIUPFkmPRnvHdNWPr9MNCCw6b
         CbhQ==
X-Gm-Message-State: AOAM530j+psi1s9qgBePLIFnglPKsOZgd6/DZvySu9hEcXObmx4boWz4
        x+37K4kf3UuCkqkQmBqrNXI=
X-Google-Smtp-Source: ABdhPJw+W8m3rFtazxgt01lIaW0OsSyJUPFgUMNKIzfcORQi6VGn0pYQle3mnRvmdNp6S1t17zfOMQ==
X-Received: by 2002:adf:90e3:: with SMTP id i90mr1017189wri.248.1609874019310;
        Tue, 05 Jan 2021 11:13:39 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id a12sm61577wrh.71.2021.01.05.11.13.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 11:13:38 -0800 (PST)
Date:   Tue, 5 Jan 2021 19:13:37 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, daniel.baluta@gmail.com,
        daniel.baluta@oss.nxp.com, lars@metafoo.de
Subject: Re: FAILED: patch "[PATCH] iio:imu:bmi160: Fix alignment and data
 leak issues" failed to apply to 4.9-stable tree
Message-ID: <20210105191337.7pxii235rrxbsa6b@debian>
References: <1609154067196181@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="be4ebfdmi5d6zfk2"
Content-Disposition: inline
In-Reply-To: <1609154067196181@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--be4ebfdmi5d6zfk2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:14:27PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with:
dd4ba3fb2223 ("iio: bmi160_core: Fix sparse warning due to incorrect type
in assignment")
dc7de42d6b50 ("iio:imu:bmi160: Fix too large a buffer.")
which makes backporting easier. dc7de42d6b50 was already marked for stable
but was missing in 4.9-stable.


--
Regards
Sudip

--be4ebfdmi5d6zfk2
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-iio-bmi160_core-Fix-sparse-warning-due-to-incorrect-.patch"

From f837e553556bd1b4ae7eb7513c7ef21b7c70ff01 Mon Sep 17 00:00:00 2001
From: sayli karnik <karniksayli1995@gmail.com>
Date: Tue, 11 Oct 2016 17:07:21 +0530
Subject: [PATCH 1/3] iio: bmi160_core: Fix sparse warning due to incorrect type in assignment

commit dd4ba3fb22233e69f06399ee0aa7ecb11d2b595c upstream

There is a type mismatch between the buffer which is of type s16 and the
samples stored, which are declared as __le16.

Fix the following sparse warning:
drivers/iio/imu/bmi160/bmi160_core.c:411:26: warning: incorrect type
in assignment (different base types)

drivers/iio/imu/bmi160/bmi160_core.c:411:26: expected signed short
[signed] [short] [explicitly-signed] <noident>
drivers/iio/imu/bmi160/bmi160_core.c:411:26: got restricted __le16
[addressable] [usertype] sample

This is a cosmetic-type patch since it does not alter code behaviour.
The le16 is going into a 16bit buf element, and is labelled as IIO_LE in the
channel buffer definition.

Signed-off-by: sayli karnik <karniksayli1995@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/imu/bmi160/bmi160_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/bmi160/bmi160_core.c b/drivers/iio/imu/bmi160/bmi160_core.c
index 5fb571d03153..c9e319bff58b 100644
--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -385,7 +385,8 @@ static irqreturn_t bmi160_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	s16 buf[16]; /* 3 sens x 3 axis x s16 + 3 x s16 pad + 4 x s16 tstamp */
+	__le16 buf[16];
+	/* 3 sens x 3 axis x __le16 + 3 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 
-- 
2.11.0


--be4ebfdmi5d6zfk2
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-iio-imu-bmi160-Fix-too-large-a-buffer.patch"

From c7b1ae8b75394066bc2883b8a86d85f3bab7821f Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 20 Sep 2020 12:27:38 +0100
Subject: [PATCH 2/3] iio:imu:bmi160: Fix too large a buffer.

commit dc7de42d6b50a07b37feeba4c6b5136290fcee81 upstream.

The comment implies this device has 3 sensor types, but it only
has an accelerometer and a gyroscope (both 3D).  As such the
buffer does not need to be as long as stated.

Note I've separated this from the following patch which fixes
the alignment for passing to iio_push_to_buffers_with_timestamp()
as they are different issues even if they affect the same line
of code.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Daniel Baluta <daniel.baluta@oss.nxp.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-5-jic23@kernel.org
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/imu/bmi160/bmi160_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/bmi160/bmi160_core.c b/drivers/iio/imu/bmi160/bmi160_core.c
index c9e319bff58b..1e1788d70eac 100644
--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -385,8 +385,8 @@ static irqreturn_t bmi160_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	__le16 buf[16];
-	/* 3 sens x 3 axis x __le16 + 3 x __le16 pad + 4 x __le16 tstamp */
+	__le16 buf[12];
+	/* 2 sens x 3 axis x __le16 + 2 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 
-- 
2.11.0


--be4ebfdmi5d6zfk2
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0003-iio-imu-bmi160-Fix-alignment-and-data-leak-issues.patch"

From 3b140121949b033460a6baf9152608e00aeeac72 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 20 Sep 2020 12:27:39 +0100
Subject: [PATCH 3/3] iio:imu:bmi160: Fix alignment and data leak issues

commit 7b6b51234df6cd8b04fe736b0b89c25612d896b8 upstream

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
[sudip: adjust context and use bmi160_data in old location]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/imu/bmi160/bmi160_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/imu/bmi160/bmi160_core.c b/drivers/iio/imu/bmi160/bmi160_core.c
index 1e1788d70eac..93c5040c6454 100644
--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -110,6 +110,13 @@ enum bmi160_sensor_type {
 
 struct bmi160_data {
 	struct regmap *regmap;
+	/*
+	 * Ensure natural alignment for timestamp if present.
+	 * Max length needed: 2 * 3 channels + 4 bytes padding + 8 byte ts.
+	 * If fewer channels are enabled, less space may be needed, as
+	 * long as the timestamp is still aligned to 8 bytes.
+	 */
+	__le16 buf[12] __aligned(8);
 };
 
 const struct regmap_config bmi160_regmap_config = {
@@ -385,8 +392,6 @@ static irqreturn_t bmi160_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	__le16 buf[12];
-	/* 2 sens x 3 axis x __le16 + 2 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 
@@ -396,10 +401,10 @@ static irqreturn_t bmi160_trigger_handler(int irq, void *p)
 				       &sample, sizeof(__le16));
 		if (ret < 0)
 			goto done;
-		buf[j++] = sample;
+		data->buf[j++] = sample;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, data->buf,
 					   iio_get_time_ns(indio_dev));
 done:
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.11.0


--be4ebfdmi5d6zfk2--
