Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD123826D3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhEQIYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:24:44 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45967 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235591AbhEQIYj (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 17 May 2021 04:24:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 04EE0745;
        Mon, 17 May 2021 04:23:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 17 May 2021 04:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AWVdcC
        oCKJzaCYV2gePsAL1EuyLSqA2kJXJu5fcEbWs=; b=XbYi9ri0hkohx8PT075F5l
        EVLsdufo4KaprOIsHWbSZDfu16OP5/cZ7l8A7Yg9Jx7wSsfNnABFY9eA88gtmKSF
        RaAMIiKhy0YUguF/FxP0BZjqExmZol0pkoc9IDSntny+N6AbsbKk4h15rHukT9cl
        tZom2kdP8wEraD3Wkj/2kncPIAsDpMF56nidTRDmFZY4J3SbRfw1eQ+8jmf5Q89+
        L1h6XR++Pps7kbtedwjtFuo4Sm75kqpBMOFCKOgtT75sMfD3wx9o4C1c92OgkFmG
        kOk7PUjjJyZSczS8XAFtqMHRu03TwNOsWpQsFTSbfKHzzPl/GCOaYRvZf5cXPR1w
        ==
X-ME-Sender: <xms:-SeiYMEEn-t0dE0Kg3H50j7D0gsqDHzesmeMnoVmXU1sH5hL7SKoKg>
    <xme:-SeiYFWI3Dgj-Bi6hb480PIueOzYjAmp3OHgf1D-TFogyAiqZEqfYfubppMXEysvL
    4qPMbM9DVU5NQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:-SeiYGLCHrSjilMnqrQvWyC5SaifyZGqCaHr5EBky6XCzMUvh9ZjZw>
    <xmx:-SeiYOE7-MaxtIp0ypniThdodxgkviEDyCa5YkynZK9rvlQccB4qow>
    <xmx:-SeiYCVpLUv64rPfDuOVG5Joa45sLLledgU6EHJ-kmxS1xIDvXYGEg>
    <xmx:-SeiYFeCDFXW5ZuMqzZqmXE8-OxPsJVDLx6aH_s-xE1o9HAQbMlWEuJio_4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:23:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: tsl2583: Fix division by a zero lux_val" failed to apply to 4.9-stable tree
To:     colin.king@canonical.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:23:11 +0200
Message-ID: <16212397917189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From af0e1871d79cfbb91f732d2c6fa7558e45c31038 Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Fri, 7 May 2021 19:30:41 +0100
Subject: [PATCH] iio: tsl2583: Fix division by a zero lux_val

The lux_val returned from tsl2583_get_lux can potentially be zero,
so check for this to avoid a division by zero and an overflowed
gain_trim_val.

Fixes clang scan-build warning:

drivers/iio/light/tsl2583.c:345:40: warning: Either the
condition 'lux_val<0' is redundant or there is division
by zero at line 345. [zerodivcond]

Fixes: ac4f6eee8fe8 ("staging: iio: TAOS tsl258x: Device driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
index 0f787bfc88fc..c9d8f07a6fcd 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -341,6 +341,14 @@ static int tsl2583_als_calibrate(struct iio_dev *indio_dev)
 		return lux_val;
 	}
 
+	/* Avoid division by zero of lux_value later on */
+	if (lux_val == 0) {
+		dev_err(&chip->client->dev,
+			"%s: lux_val of 0 will produce out of range trim_value\n",
+			__func__);
+		return -ENODATA;
+	}
+
 	gain_trim_val = (unsigned int)(((chip->als_settings.als_cal_target)
 			* chip->als_settings.als_gain_trim) / lux_val);
 	if ((gain_trim_val < 250) || (gain_trim_val > 4000)) {

