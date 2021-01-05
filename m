Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EE52EB3C4
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 20:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbhAET5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 14:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729201AbhAET5L (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 5 Jan 2021 14:57:11 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7739C061574
        for <Stable@vger.kernel.org>; Tue,  5 Jan 2021 11:56:30 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id t30so407095wrb.0
        for <Stable@vger.kernel.org>; Tue, 05 Jan 2021 11:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AbIv4nWDvh+spg018CWjNOMbg+FuI3x7zvhikJ6Qkq0=;
        b=IM0esEWkJks2LIoizDAirfD4gq5rCk8+8xeJFIF3HRDoym3srsIMdGYoj+FiOyr8tP
         +UFZ6KZbB8L3Sye4+8MqMzUleKnWL5jXPtBzy0t6TzsOfSuTirPVymH4Kn2ITqV5HakV
         m91/lYfGw+wFB31+NO+TcmUuWDfLY8lYGvDloL4xCTL/XfCQUE0vef9kqUjx79vHce6b
         IF3dwoeXihrimnjuApmalcR2d/6KjA5Vuil2ZeOQq/2fS8klYi4UauwTFZr9f1CATwkr
         XZdZHtkjKLdW9Zb6lV/zIrFdw8UrkmeUrnovtL8moOzN1x8ndI9lhEIav1k7GjguESMH
         qJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AbIv4nWDvh+spg018CWjNOMbg+FuI3x7zvhikJ6Qkq0=;
        b=CHdhRrUKyg8AHPgDYJhj+hC1mWVWUqHpWcu1luo5oxVWjb3TLOtPEp4Tn64px89QP1
         dZ/kMRuCbDcO6UbWPmKpccy7XG7Fi4/MGOx8eL0mEVVAtpjm4kz0UI3DqbQCI9k3rykG
         NUyWa42lidLrAwUa3TaPmVsXmJxlE/m9s5jky+u+D8UAo71OyaE45+gMK4gBSeihqm68
         FfuzEijXSVSOoKMS9vFe6cAgBkd1Z+Woj6oGLz/HNAIOiVXwK5jZJA/MSwGx2EiT1PpP
         QT3/C34EQLrkNjaZOudtWQ0B64xhfgvIyRDxceCvzJSjvKxctMylWCB3PuyzYgeDMU0/
         QtHA==
X-Gm-Message-State: AOAM530sDHNvJzDwXUQrrtyshxmAndi6Z4lO84Aq7sZfl/qlvsxglSPD
        L8dvkGO7DgBpArey/zjnRPS7L0RfIqRgtA==
X-Google-Smtp-Source: ABdhPJy6qMIuf0hOaLpLhpuPgx4g7sOx5HgDolu09NXd5R+vY3WcthxZWu8SmcprFFO1b+IhHJvTyg==
X-Received: by 2002:a5d:61ca:: with SMTP id q10mr1140832wrv.124.1609876589782;
        Tue, 05 Jan 2021 11:56:29 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id h29sm224066wrc.68.2021.01.05.11.56.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 11:56:29 -0800 (PST)
Date:   Tue, 5 Jan 2021 19:56:27 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, lars@metafoo.de
Subject: Re: FAILED: patch "[PATCH] iio:magnetometer:mag3110: Fix alignment
 and data leak issues." failed to apply to 4.19-stable tree
Message-ID: <20210105195627.umyqen7zqjxmsqqx@debian>
References: <160915402290189@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u5f5dgr7yhayxybv"
Content-Disposition: inline
In-Reply-To: <160915402290189@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u5f5dgr7yhayxybv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:13:42PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--u5f5dgr7yhayxybv
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-iio-magnetometer-mag3110-Fix-alignment-and-data-leak.patch"

From 7bdda7860df0fa2789e893711ff81483dcb970ed Mon Sep 17 00:00:00 2001
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
index f063355480ba..57fbe5bfe883 100644
--- a/drivers/iio/magnetometer/mag3110.c
+++ b/drivers/iio/magnetometer/mag3110.c
@@ -56,6 +56,12 @@ struct mag3110_data {
 	struct mutex lock;
 	u8 ctrl_reg1;
 	int sleep_val;
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
-- 
2.11.0


--u5f5dgr7yhayxybv--
