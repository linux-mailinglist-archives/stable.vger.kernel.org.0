Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A44B2EB35A
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 20:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbhAETKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 14:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbhAETKN (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 5 Jan 2021 14:10:13 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDA6C061795
        for <Stable@vger.kernel.org>; Tue,  5 Jan 2021 11:09:33 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a12so250453wrv.8
        for <Stable@vger.kernel.org>; Tue, 05 Jan 2021 11:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8vnl8pGccisfhn5MNb9HL7fTjUscaAZoX3q+t66uruw=;
        b=Ps7tIm9p2zYbfrcmk+NxG1Ual0LkL/ZvSNm0e5fmwNuZLG3rOWVzE27ioReXJYvqN3
         QpRIOim5+7TkXCiCSoxs2B32HnIFrFQYW4shIuBgnyWwKVQ1B+zqvhTPK/2tNP5LKq9S
         YKLwxEB2rgj8/crOBA0cZ8N6qDH0SJbkLHr2FyMR59hjJJr1DsClO9N7HBa/fG5m353G
         tDaYLq3EBHb5oA3oSRozZY4zntz6yvKwLhWqUku/hOa1Iet392WwtwM2FJ/eVPBlsIt3
         zFunHdylblJyGlPuJUYvdt1IwG+v+cqPpD387NR8NIHtS9/y0bfIlm30TRqN+T7eA58i
         8+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8vnl8pGccisfhn5MNb9HL7fTjUscaAZoX3q+t66uruw=;
        b=N0mzhlo5H/JYRFqjMsQMWr+EuB9Y4bFxocyMPGj90eFdZAWoz+ij6dzXK7zqjWUxBy
         WdVrz8k2x+gcNpzWhHkaOUk/e8QdlXxfvybS88RFUaVxe7QuTpvNRkRCMqu0I9WyWq6k
         NoUmmw3IlunyQuNOL9zsgA190QDQFZk+LEZQBEDga7kfJU+g2jR5K/DaPtFB0r8mAKnn
         GF8n6NfeoAMwweUiQaaLISHDICSz/pCCknHX25++wgyfyETsnfEb4HHyUJbz/O9Fqi9Z
         U3kJxYOttr8Cdfv7+b6Mmt+nfs3bRMpw6yfsBv+WMxUz5UjPoGtAdWCLGH5WQ5eTySYf
         FZCw==
X-Gm-Message-State: AOAM5316DiHRAf+bXTp0i6z0f4c8jwQdjrosMspbgJKreR2WJ9OLH99o
        cgGsEqnK88TFMuJ4fKLeTtQ=
X-Google-Smtp-Source: ABdhPJzMj8+ttql3akWwUv7djRHRfgOWYv/XNd8yhxLXd+xRyxP1QOcaK7rBznsdtAi0exPRu7JzjQ==
X-Received: by 2002:a5d:56c3:: with SMTP id m3mr911611wrw.419.1609873771866;
        Tue, 05 Jan 2021 11:09:31 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id w17sm146566wmk.12.2021.01.05.11.09.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 11:09:31 -0800 (PST)
Date:   Tue, 5 Jan 2021 19:09:29 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, daniel.baluta@gmail.com,
        daniel.baluta@oss.nxp.com, lars@metafoo.de
Subject: Re: FAILED: patch "[PATCH] iio:imu:bmi160: Fix alignment and data
 leak issues" failed to apply to 4.14-stable tree
Message-ID: <20210105190929.v7gyao2z23fhsy6u@debian>
References: <160915406818112@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7qiujtoh6e5frubf"
Content-Disposition: inline
In-Reply-To: <160915406818112@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7qiujtoh6e5frubf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:14:28PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, same as the one for 4.19-stable but missed mentioning
in that mail.

--
Regards
Sudip

--7qiujtoh6e5frubf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-iio-imu-bmi160-Fix-alignment-and-data-leak-issues.patch"

From a236af5a527a9aaeb3cbb99d0311d8a3b75e34cf Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 20 Sep 2020 12:27:39 +0100
Subject: [PATCH] iio:imu:bmi160: Fix alignment and data leak issues

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
index e95d817c8390..1e413bb233ae 100644
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
 				       &sample, sizeof(sample));
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


--7qiujtoh6e5frubf--
