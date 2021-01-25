Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E696D304B90
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbhAZEik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:38:40 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:56071 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729248AbhAYOKj (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 25 Jan 2021 09:10:39 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id A5C07E1D;
        Mon, 25 Jan 2021 09:09:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 25 Jan 2021 09:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZoLVCC
        33einsGjLWBX7nHwrBWlXuPbt+DCcHg7qJyQw=; b=oNY4SoRJlOKCyzWOgiTuLC
        R0T5/uX5KxXN13uF6hhpPWAm354c/yeX1Ef7E0PSH5NRszRWxyciCviAv56Bxqn4
        WYi0v2RZmJfKgpXip42/FQIgyIw2NS5Aq2at1iuZ8uBe7Qe6slkfbYuhqpE4mKY1
        xNxcKYBgrZIDNpsw8DDpADmQq80ulq0qKyHY8ZGzjZgf7nEKgK69Vq3Yb0gqcQAP
        43/Dp0+1PbGNq+klDaEXNaPtWD3DVHQQf3vDA4FnsNGdObYrtupipG1mEhb2vqsY
        lDc37idqO5CdJpRbHp2sOKY20cPsNz1/WXpyoy5kVlc59AF/k8K9qrVG7MkTTQoA
        ==
X-ME-Sender: <xms:K9EOYMLwN-4BIqnXsECqV1381mNIzzCr3ZGsqvRtVKEKKd_B9dxDWQ>
    <xme:K9EOYMFPbUcM6TpBfEvrq-_QubC-RCr8HCj8wFh-0byi8OPmUBf11dSt0Aol51z19
    6C-kkCknlAnRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:K9EOYJlQQyRlRxfA9LT9D3ndYfor7Gej5iHcvDsD5CK5oZWx7p9www>
    <xmx:K9EOYBK0yacW5z6rCkALMQdU17fBlBoF5eDXnHm3dYf6f5ZZHp16wg>
    <xmx:K9EOYCbhQFTo5yhR-gccFIW70c8AEIrgGEB4O76umGDbkZx_7yRsMQ>
    <xmx:LNEOYOWZLqrfnM1wYcoQ1wArtCBZPCcD6i3PggYNjKbOTsue8ERvI1zeXvs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 371011080063;
        Mon, 25 Jan 2021 09:09:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: common: st_sensors: fix possible infinite loop in" failed to apply to 5.4-stable tree
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, jic23@kernel.org, linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:09:44 +0100
Message-ID: <161158378469210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

