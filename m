Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2D63826D2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhEQIYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:24:37 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53013 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231720AbhEQIYa (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 17 May 2021 04:24:30 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id C64276AB;
        Mon, 17 May 2021 04:23:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 17 May 2021 04:23:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ea/Ioe
        ytNJr140ULmbDUwtDgHjlUz2HoIXrDvrsbLTY=; b=Ro7usvFV3BTDjSa0PgH41w
        JGpynDyqIeRl33RLxolFV83YBmT2x28gS5oUyLpvVw/E2otgLIi2zKuX2RN1pSuy
        OkqGj50vADvwIRofFv/GRi6Kmcbu0urQM8DmlPCrv2iLb9SNoav1EchMMoGURttm
        EY5tAVPuI/8YJ6Ojhip4ETGwsnjCP/pnHUKJ1lVfkMcXlfkOcu3Fls9ABn0t6LZX
        GaZ4cIUAT/vCcJfzJpiN6kGmyq9EhetlPbSvu6LukDE5dVWrkO/FW8G/RW7Nrzk9
        Ntvk4Ox0uV/dmf8bkGiapulheSadsdOY/pAgtUOT1ysxlTiGqPzVrlvA1EFfnIBQ
        ==
X-ME-Sender: <xms:8CeiYO38q7I3GGBTHUBShZbufKhIgAln3A2Ftx1FrELNvBKkvE2caQ>
    <xme:8CeiYBG76ZDugOJ5ehoSjeHpF40VPcmomjXv7noy0Hy_voe9R4ykRupa96pAsGVru
    CvmKuJhtdwBRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:8CeiYG5EotrkaVYaZLkXKWeZScVw7SubALmfsHB-EqXj1iQFp9iWfg>
    <xmx:8CeiYP1i3Z4xu_rPi44IqEhbUi6uRW_92r0BXSMqMXNtANR8rlpMsw>
    <xmx:8CeiYBE4sm6wNc6s2d23lvCGpkwcqErLoPX6GdBrhVJbtGewqQJFIQ>
    <xmx:8SeiYPPw7Ief6KKKf1CAmqex0nCy_Th7tHdZtNU31M8AjUJyB-d9dWGgRp0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:23:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: tsl2583: Fix division by a zero lux_val" failed to apply to 4.4-stable tree
To:     colin.king@canonical.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:23:10 +0200
Message-ID: <16212397902321@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

