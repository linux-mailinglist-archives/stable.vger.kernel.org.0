Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411193032C3
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbhAZEio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:38:44 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52935 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729278AbhAYOL0 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 25 Jan 2021 09:11:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CD47FE18;
        Mon, 25 Jan 2021 09:09:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:09:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XPTMlv
        XeBv+42wmdnVajCcW/cz9AefDA9wWf/95kqZg=; b=d1bFjvvZJj0xlWBnueuLRu
        i7WG6cT3gMf1AxHP4pXecrjeSQWouVOkUHmGra1E1rI59C+REmfcQkJgOMUe9Nj/
        XYEa6Jktz9ecD+v5qdRJ3uOnmbmFPA/kdi6fMHgyl/PTEPgQgA57i3tCsodHU1ii
        bt7dzQTgHfqFcJi6zNIoHXAoltKR+kOqJ0lSeD5ed8ywiwQlpcyfJkubXKL0/QBj
        YKXZV4E5hZsRBzMUlV5MXCthH8BcxWArrE8FgHR6pu0lpyXLVvnlYZdrrRmgjE09
        B4Ljqz4LXZ7wyRd2M4CMz1lthG/kGWgjiBPVjNHaKWoRJcJNGfU9d9HF4NP0uGIQ
        ==
X-ME-Sender: <xms:NNEOYBcQ-2iOQYTUYLHKTQhyPkfpEX-8aplRDCKYaYT6Z6SmsCR70Q>
    <xme:NNEOYPOfhFKepojGlkgW-sUMhTAQq66uV53d9r2gBfZZ7X0YpJ3t67NoYjY4jQ_YC
    Do9t-F_Nxp4Sw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:NNEOYKjEkG9Jb8uLAd5ng8DMHvApEVSoo_6tV-atrvs571919QxS4w>
    <xmx:NNEOYK8XFtEOxSbtZBPjCkYRPyAWx2yE-gcCq_U95cazfwjMqy19HA>
    <xmx:NNEOYNsTR7OxxoGdiT4Fy5xDvXkL0CW5Uw54mFbPeX-4hgA0kHU3sQ>
    <xmx:NNEOYG6h8OEll42mlMf-72l53LPQbtMCQBPAJPCr7uxpIsFahhzZLnFv4cs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1F321080066;
        Mon, 25 Jan 2021 09:09:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: common: st_sensors: fix possible infinite loop in" failed to apply to 4.19-stable tree
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, jic23@kernel.org, linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:09:45 +0100
Message-ID: <161158378543221@kroah.com>
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

From 40c48fb79b9798954691f24b8ece1d3a7eb1b353 Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Tue, 8 Dec 2020 15:36:40 +0100
Subject: [PATCH] iio: common: st_sensors: fix possible infinite loop in
 st_sensors_irq_thread

Return a boolean value in st_sensors_new_samples_available routine in
order to avoid an infinite loop in st_sensors_irq_thread if
stat_drdy.addr is not defined or stat_drdy read fails

Fixes: 90efe05562921 ("iio: st_sensors: harden interrupt handling")
Reported-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/c9ec69ed349e7200c779fd7a5bf04c1aaa2817aa.1607438132.git.lorenzo@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/common/st_sensors/st_sensors_trigger.c b/drivers/iio/common/st_sensors/st_sensors_trigger.c
index 0507283bd4c1..2dbd2646e44e 100644
--- a/drivers/iio/common/st_sensors/st_sensors_trigger.c
+++ b/drivers/iio/common/st_sensors/st_sensors_trigger.c
@@ -23,35 +23,31 @@
  * @sdata: Sensor data.
  *
  * returns:
- * 0 - no new samples available
- * 1 - new samples available
- * negative - error or unknown
+ * false - no new samples available or read error
+ * true - new samples available
  */
-static int st_sensors_new_samples_available(struct iio_dev *indio_dev,
-					    struct st_sensor_data *sdata)
+static bool st_sensors_new_samples_available(struct iio_dev *indio_dev,
+					     struct st_sensor_data *sdata)
 {
 	int ret, status;
 
 	/* How would I know if I can't check it? */
 	if (!sdata->sensor_settings->drdy_irq.stat_drdy.addr)
-		return -EINVAL;
+		return true;
 
 	/* No scan mask, no interrupt */
 	if (!indio_dev->active_scan_mask)
-		return 0;
+		return false;
 
 	ret = regmap_read(sdata->regmap,
 			  sdata->sensor_settings->drdy_irq.stat_drdy.addr,
 			  &status);
 	if (ret < 0) {
 		dev_err(sdata->dev, "error checking samples available\n");
-		return ret;
+		return false;
 	}
 
-	if (status & sdata->sensor_settings->drdy_irq.stat_drdy.mask)
-		return 1;
-
-	return 0;
+	return !!(status & sdata->sensor_settings->drdy_irq.stat_drdy.mask);
 }
 
 /**
@@ -180,9 +176,15 @@ int st_sensors_allocate_trigger(struct iio_dev *indio_dev,
 
 	/* Tell the interrupt handler that we're dealing with edges */
 	if (irq_trig == IRQF_TRIGGER_FALLING ||
-	    irq_trig == IRQF_TRIGGER_RISING)
+	    irq_trig == IRQF_TRIGGER_RISING) {
+		if (!sdata->sensor_settings->drdy_irq.stat_drdy.addr) {
+			dev_err(&indio_dev->dev,
+				"edge IRQ not supported w/o stat register.\n");
+			err = -EOPNOTSUPP;
+			goto iio_trigger_free;
+		}
 		sdata->edge_irq = true;
-	else
+	} else {
 		/*
 		 * If we're not using edges (i.e. level interrupts) we
 		 * just mask off the IRQ, handle one interrupt, then
@@ -190,6 +192,7 @@ int st_sensors_allocate_trigger(struct iio_dev *indio_dev,
 		 * interrupt handler top half again and start over.
 		 */
 		irq_trig |= IRQF_ONESHOT;
+	}
 
 	/*
 	 * If the interrupt pin is Open Drain, by definition this

