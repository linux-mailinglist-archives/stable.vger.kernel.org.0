Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1B2EB354
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 20:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbhAETH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 14:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730670AbhAETH3 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 5 Jan 2021 14:07:29 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87777C061574
        for <Stable@vger.kernel.org>; Tue,  5 Jan 2021 11:06:48 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id c5so256432wrp.6
        for <Stable@vger.kernel.org>; Tue, 05 Jan 2021 11:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1ES/giDUMmt0Dz8k2w1FXjMbdrOFrkByykPy9vH2Gho=;
        b=cuRv4sfFdP7gObvgzMRfUkZefzDN/XIb6GP0AYb9zozdhwMIBBXWpwIrFiFz/JW1Fr
         0zigAPw+zcsOZx6x75jwyjUSbg5LzCzEHlYs6QusiFlUUSC5StFaFJORySfhAGOpg354
         sEvEfnU85YbQWq8/E4uL8boUQZ0fJrzJM+k9gOcyTryqGQ8umeZdCp07coCrF0fmUqBc
         Kgu5bUi4+Tj1TKPa4E5XcJeVZysUc0VIJGEhxI7QES6X0QpnH9H1QigRC2fGubQLPgip
         LoWla4ko3QMSwIAl+IcqdtwZCvac4nEmjpO7sQIw6jGi1SbddLESpB3SVNV7I/IHEoiZ
         iFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1ES/giDUMmt0Dz8k2w1FXjMbdrOFrkByykPy9vH2Gho=;
        b=OBE255R5ojfJVEvhqW/gNVlcQhjIW4ptlJFKZ+FARk+jXOFUFbuXtnStdrZQUKzgcc
         FxQYp3LSm8LlTwhtnvwsgot89Gvpa+09ExRJFrSe7v0211vGzViRnr8R4Qt4T4r0tm8b
         WmpVmqxNFZvfnQGar74QALsc27Hwj75rtq0YkNzLn5sCDebEmDvJWIZqX1UwIhxDzT09
         UIuYZxIV04hpXbt1fOsLICMuSuKrpeVYG6uIAP9mVmDS7Wzrc9zRmL4/AoCtkVTRdMEC
         EZFqzASckGcykRMmN0Z0ZQPjC+rRSUq++hnDgcit8CQDEEdOmKvqeyI8nW+P71XZ6oNS
         R4Tw==
X-Gm-Message-State: AOAM530XIWAqzJLbUKQIrqQjb7I4cfSBJocPGTWUGif2Tkyt7izl+GQc
        auSjby7n38++FlepUWeijtI=
X-Google-Smtp-Source: ABdhPJziresl1zlq8HC/Rmn+UM1hEF0WovoFvVKT2ArvSY88gwXDyZqTsr30kG7acRDY74sz1n63ow==
X-Received: by 2002:adf:ae01:: with SMTP id x1mr889722wrc.381.1609873607362;
        Tue, 05 Jan 2021 11:06:47 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id v1sm119290wmj.31.2021.01.05.11.06.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 11:06:46 -0800 (PST)
Date:   Tue, 5 Jan 2021 19:06:44 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, daniel.baluta@gmail.com,
        daniel.baluta@oss.nxp.com, lars@metafoo.de
Subject: Re: FAILED: patch "[PATCH] iio:imu:bmi160: Fix alignment and data
 leak issues" failed to apply to 5.4-stable tree
Message-ID: <20210105190644.nl2bqlerubbhrxib@debian>
References: <160915407049123@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tnwoaip66op5syk6"
Content-Disposition: inline
In-Reply-To: <160915407049123@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tnwoaip66op5syk6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:14:30PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--tnwoaip66op5syk6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-iio-imu-bmi160-Fix-alignment-and-data-leak-issues.patch"

From 95e5471b49cff9a070f68365e2ae6c558203ab07 Mon Sep 17 00:00:00 2001
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/imu/bmi160/bmi160.h      | 7 +++++++
 drivers/iio/imu/bmi160/bmi160_core.c | 6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/imu/bmi160/bmi160.h b/drivers/iio/imu/bmi160/bmi160.h
index 621f5309d735..431f10c2b951 100644
--- a/drivers/iio/imu/bmi160/bmi160.h
+++ b/drivers/iio/imu/bmi160/bmi160.h
@@ -7,6 +7,13 @@
 struct bmi160_data {
 	struct regmap *regmap;
 	struct iio_trigger *trig;
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
index a5994899e396..088694c82327 100644
--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -411,8 +411,6 @@ static irqreturn_t bmi160_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	__le16 buf[12];
-	/* 2 sens x 3 axis x __le16 + 2 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 
@@ -422,10 +420,10 @@ static irqreturn_t bmi160_trigger_handler(int irq, void *p)
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
-- 
2.11.0


--tnwoaip66op5syk6--
