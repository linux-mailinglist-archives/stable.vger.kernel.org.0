Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581662EB3C6
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 20:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbhAET6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 14:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730887AbhAET6v (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 5 Jan 2021 14:58:51 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5244DC061574
        for <Stable@vger.kernel.org>; Tue,  5 Jan 2021 11:58:11 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c5so378313wrp.6
        for <Stable@vger.kernel.org>; Tue, 05 Jan 2021 11:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8n4ESl6xaaG/7sGT1g5N5u2EO9BUG0oxKiHZJOTesl0=;
        b=GqOcWvp+n+zl9113/bdTGSLAR9MtyGnmORNUJdVu0iUmRNv0NLPeNJkg63lSnM2DEw
         8qwYGIFeyjSkpKwf2xS26dQ2H8PvAW8qEFjPZ/azKlmJx4ISoJ0P5YKiGBOlPiGnjblC
         KBdwxEWM0Ddwt9wl2p8iDTqb9xRSQtDITbzhrecDwqFwYIaaLNhYJbKejDEr5jwr6rwc
         rDq/cz3DmJqaqSCvGfku/uTPr8M6ZxAI1QsBvNKIxUB72Znr3uLeyTdddOEkErO753bK
         V/89Un5laYF2Hazqq5rTpmU6e5l8CQK15fcB/qHnqoDb442qQMzCFv0CjgdHrp0BYlT5
         Vj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8n4ESl6xaaG/7sGT1g5N5u2EO9BUG0oxKiHZJOTesl0=;
        b=GBKpKC8x17ms2umhrenSYQ3AJztgx5ctM4k73fr7C7eiwUHPjJ2GnzjfP1QZeK+RCt
         czVCKC074f1vp+ClT3nhfXfscJsu0ZtZxYSaGRyx76XUiFxBBMYRjESWEhx8FmWeIOYf
         gXTN/LATzkjIRxKuQRiUyftWjbVx5JjlMP8FkL3sQxZbPbUwbk/9qRBQiy7xsFR0qWoP
         zzeqo6dsAtfIPbC+5tMn0BhvVOzct+greBdRzSWDNMVic17cnNVZYwGEvkq+FgYSUmzO
         MYNkca0RvPfUq9GsE0EvsAdsci5ZkEPRElPJR3GCTF3hDhVdZUj1O6teg6HD9nF5y2Yv
         X3JQ==
X-Gm-Message-State: AOAM530eIjWq7L83ACpKPUih05QQXV+ZLC70voQAaSkA52ODOTekkgnP
        IClleKZVRgRjy2WRXSgfEtw=
X-Google-Smtp-Source: ABdhPJzfPsd66Ej88wkBIABGPrES3V/VZJsWjKxZCxVrCkjXuZ9wqZUstCz/erlncgfK3AKIOC3Ypg==
X-Received: by 2002:adf:ab4b:: with SMTP id r11mr1096647wrc.282.1609876690138;
        Tue, 05 Jan 2021 11:58:10 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id f14sm286641wme.14.2021.01.05.11.58.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 11:58:09 -0800 (PST)
Date:   Tue, 5 Jan 2021 19:58:07 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, lars@metafoo.de
Subject: Re: FAILED: patch "[PATCH] iio:magnetometer:mag3110: Fix alignment
 and data leak issues." failed to apply to 4.14-stable tree
Message-ID: <20210105195807.qz4jybetcgwahaeh@debian>
References: <1609154021184226@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yiv2rhoumxsivd4j"
Content-Disposition: inline
In-Reply-To: <1609154021184226@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yiv2rhoumxsivd4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:13:41PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.9-stable.

--
Regards
Sudip

--yiv2rhoumxsivd4j
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-iio-magnetometer-mag3110-Fix-alignment-and-data-leak.patch"

From 35a03dab47f3edb209085833bc20982bc9fd1a4b Mon Sep 17 00:00:00 2001
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
index dad8d57f7402..974e141c0dc0 100644
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
@@ -262,10 +268,9 @@ static irqreturn_t mag3110_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct mag3110_data *data = iio_priv(indio_dev);
-	u8 buffer[16]; /* 3 16-bit channels + 1 byte temp + padding + ts */
 	int ret;
 
-	ret = mag3110_read(data, (__be16 *) buffer);
+	ret = mag3110_read(data, data->scan.channels);
 	if (ret < 0)
 		goto done;
 
@@ -274,10 +279,10 @@ static irqreturn_t mag3110_trigger_handler(int irq, void *p)
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
-- 
2.11.0


--yiv2rhoumxsivd4j--
