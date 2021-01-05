Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C09E2EB3C9
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 21:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbhAET7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 14:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbhAET7q (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 5 Jan 2021 14:59:46 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2A8C061574
        for <Stable@vger.kernel.org>; Tue,  5 Jan 2021 11:59:05 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t16so394741wra.3
        for <Stable@vger.kernel.org>; Tue, 05 Jan 2021 11:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CjdPbaRAHRmAluIhrtv3b1QP5BahFZ7EGLzV1VBuC9s=;
        b=E5LYBcL4ZtuuypmDziT9LQWbapXDRwQ6YmSduk3OBp08cDD5ONF1vGMBuF5xNMIvWc
         FK5GPcRog41MHyFqAyebp/H3FL99tpRzPJ3SHF4HAHoF56rdEoMtem0300RUmRddRRSn
         NbSqr/yCptwWOGKqB/Y8XrbXTr1MsOmPEGChnde7ScT+SXwg87HGfND6EFSzxZovbRTX
         M1qCg45ASaGeSTvgq80y2h/35MNObzU1Rjc/5SC2CSIODhN9WI5CV93viGl2XNLGuTBm
         4uQt1CqqkHmDdEWmdzKAER78ypIzKPajlfoR/Rfb9y2gtCkxQk7AIUBFDk/8vfUqClM+
         6Xyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CjdPbaRAHRmAluIhrtv3b1QP5BahFZ7EGLzV1VBuC9s=;
        b=ganeaPcdDN9rXXl4jylayR54Gn2O1o2QHefMuvVaqvUjR5p7RolYpaWqXnjAD4oLBc
         ivKx6nv0QtqffnCc7Ux4sOzJ70uL1C9fLHruEcSkWkTPF/AbTA2e2MysaBSOsyqs7dwf
         9nEMDCXi6Lm+G9S5NriroYrUACGHtJH6kAo6QPLctt4ujftrhcxwt0Kex2ydBcJlSveF
         YWAox/ZZhB11oBVKs1C7EXty5sn2zaaq2jMhRNhboAXajEOMYtokspWcENtGAHrKCdqk
         paqUuDQRHC7fUMMjeQ3Nb0eWvcTwcdNYmjwODLQfX0a+QZH1AgC2UBrm0kmOdPMdcHZG
         rW6Q==
X-Gm-Message-State: AOAM531vB/uhhgPnNrNGOWZvGx2i807+TAQ6aVVEDpUow0AJo4OsSeOO
        UkQQsl2YPG/CjEcaavGnMXBO7qk0VQqZ+g==
X-Google-Smtp-Source: ABdhPJzLgV31/yOXigN0XsFFChNVbNkc02B0Q1JTcdme8aC1IhFcX3w2tkmVMw/C7Ymikth5Gp6kDQ==
X-Received: by 2002:a5d:540f:: with SMTP id g15mr1066556wrv.397.1609876744284;
        Tue, 05 Jan 2021 11:59:04 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id b13sm217849wrt.31.2021.01.05.11.59.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 11:59:03 -0800 (PST)
Date:   Tue, 5 Jan 2021 19:59:01 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, lars@metafoo.de
Subject: Re: FAILED: patch "[PATCH] iio:magnetometer:mag3110: Fix alignment
 and data leak issues." failed to apply to 4.4-stable tree
Message-ID: <20210105195901.stnyoeqaytm3pyif@debian>
References: <16091540199679@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="entagwzqtynetaea"
Content-Disposition: inline
In-Reply-To: <16091540199679@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--entagwzqtynetaea
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:13:39PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--entagwzqtynetaea
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-iio-magnetometer-mag3110-Fix-alignment-and-data-leak.patch"

From 5da42972cddb675e550c414aee17e74d69778678 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 20 Sep 2020 12:27:37 +0100
Subject: [PATCH] iio:magnetometer:mag3110: Fix alignment and data leak issues.

commit 89deb1334252ea4a8491d47654811e28b0790364 upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/magnetometer/mag3110.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/magnetometer/mag3110.c b/drivers/iio/magnetometer/mag3110.c
index 261d517428e4..4900ad1ac51f 100644
--- a/drivers/iio/magnetometer/mag3110.c
+++ b/drivers/iio/magnetometer/mag3110.c
@@ -52,6 +52,12 @@ struct mag3110_data {
 	struct i2c_client *client;
 	struct mutex lock;
 	u8 ctrl_reg1;
+	/* Ensure natural alignment of timestamp */
+	struct {
+		__be16 channels[3];
+		u8 temperature;
+		s64 ts __aligned(8);
+	} scan;
 };
 
 static int mag3110_request(struct mag3110_data *data)
@@ -245,10 +251,9 @@ static irqreturn_t mag3110_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct mag3110_data *data = iio_priv(indio_dev);
-	u8 buffer[16]; /* 3 16-bit channels + 1 byte temp + padding + ts */
 	int ret;
 
-	ret = mag3110_read(data, (__be16 *) buffer);
+	ret = mag3110_read(data, data->scan.channels);
 	if (ret < 0)
 		goto done;
 
@@ -257,10 +262,10 @@ static irqreturn_t mag3110_trigger_handler(int irq, void *p)
 			MAG3110_DIE_TEMP);
 		if (ret < 0)
 			goto done;
-		buffer[6] = ret;
+		data->scan.temperature = ret;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 		iio_get_time_ns());
 
 done:
-- 
2.11.0


--entagwzqtynetaea--
