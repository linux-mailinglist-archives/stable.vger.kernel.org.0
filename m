Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF4F2C01AA
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 09:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgKWIt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 03:49:57 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:42309 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgKWIt4 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 23 Nov 2020 03:49:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C5854F1C;
        Mon, 23 Nov 2020 03:49:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 03:49:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FAHJkR
        Z4jldacSC0mYJSI+urTw268BjIvoU0X160tBk=; b=ls3WWnbVotbnUMBPlq3BOZ
        N6gKy4HVM5TdsSnRIdxJvL1+xiXN2m1q+ofM6Hh5HvSD288QjqC1BKfNK/DpN3xN
        tJhYvtYxBpVDwBXaSRB/Di9phLm1E/GLowtcPHz2I/1u5O+rUiVVBMMNTE269+x8
        EBHuREiOhAaGvs1mVTIBOUym1FnfgduWV5WcBWCaej7IxSxxnbuXc+81V2MgECxZ
        sgiEdU++lTvKiOtHvJpSqF5VorXYgSKPYUlAKUVoHfHAAZ1OWHA19bKcCmY1orqj
        OJNExm0EZ0/+oNtwfdXr6d7iZ0Y4/Qv75NmOiGIo4fggrQxBvcbrARsdxeGCHZ+w
        ==
X-ME-Sender: <xms:s3e7X1vkrct04do-PSKYrUXIt1mxP0huvtJ01aJkiICe59sxO3GuZw>
    <xme:s3e7X-cYDqpk60Czgz6-g6JB-QAQ6zD6iNBQfgE3VKHtzncUCYEwoyBQMowAFKqeq
    _VlHD874oKvYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:s3e7X4x8tFAmM71Ayj3trsBcyti8VbJSRJZVULAJIz0HBUE9l414bg>
    <xmx:s3e7X8M7sgJ5uzyWgWZblEnF6_3-O-QJO1-bMsvkJbbv2__iW7KHYw>
    <xmx:s3e7X19onLXmxuR0Ew3PNAiOfcVvsyJIhdmUYIzPY2bbakwLpvPJOA>
    <xmx:s3e7X3ncnedNywDKg0zcjgTjV7gYW3VnITi01RdaOwVfs35tYb1ixuCL5O0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5C5E328005A;
        Mon, 23 Nov 2020 03:49:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: cros_ec: Use default frequencies when EC returns invalid" failed to apply to 5.4-stable tree
To:     gwendal@chromium.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, enric.balletbo@collabora.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 09:51:02 +0100
Message-ID: <1606121462098@kroah.com>
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

From 56e4f2dda23c6d39d327944faa89efaa4eb290d1 Mon Sep 17 00:00:00 2001
From: Gwendal Grignou <gwendal@chromium.org>
Date: Tue, 30 Jun 2020 08:37:30 -0700
Subject: [PATCH] iio: cros_ec: Use default frequencies when EC returns invalid
 information

Minimal and maximal frequencies supported by a sensor is queried.
On some older machines, these frequencies are not returned properly and
the EC returns 0 instead.
When returned maximal frequency is 0, ignore the information and use
default frequencies instead.

Fixes: ae7b02ad2f32 ("iio: common: cros_ec_sensors: Expose cros_ec_sensors frequency range via iio sysfs")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20200630153730.3302889-1-gwendal@chromium.org
CC: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
index c62cacc04672..e3f507771f17 100644
--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
@@ -256,7 +256,7 @@ int cros_ec_sensors_core_init(struct platform_device *pdev,
 	struct cros_ec_sensorhub *sensor_hub = dev_get_drvdata(dev->parent);
 	struct cros_ec_dev *ec = sensor_hub->ec;
 	struct cros_ec_sensor_platform *sensor_platform = dev_get_platdata(dev);
-	u32 ver_mask;
+	u32 ver_mask, temp;
 	int frequencies[ARRAY_SIZE(state->frequencies) / 2] = { 0 };
 	int ret, i;
 
@@ -311,10 +311,16 @@ int cros_ec_sensors_core_init(struct platform_device *pdev,
 						 &frequencies[2],
 						 &state->fifo_max_event_count);
 		} else {
-			frequencies[1] = state->resp->info_3.min_frequency;
-			frequencies[2] = state->resp->info_3.max_frequency;
-			state->fifo_max_event_count =
-			    state->resp->info_3.fifo_max_event_count;
+			if (state->resp->info_3.max_frequency == 0) {
+				get_default_min_max_freq(state->resp->info.type,
+							 &frequencies[1],
+							 &frequencies[2],
+							 &temp);
+			} else {
+				frequencies[1] = state->resp->info_3.min_frequency;
+				frequencies[2] = state->resp->info_3.max_frequency;
+			}
+			state->fifo_max_event_count = state->resp->info_3.fifo_max_event_count;
 		}
 		for (i = 0; i < ARRAY_SIZE(frequencies); i++) {
 			state->frequencies[2 * i] = frequencies[i] / 1000;

