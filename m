Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D045011F702
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 10:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfLOJaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 04:30:06 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:51907 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726192AbfLOJaG (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 15 Dec 2019 04:30:06 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C4D7F6A5;
        Sun, 15 Dec 2019 04:30:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 04:30:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=iGEAV9
        X2jYhf6Nv3lQDSerdjVVz/Zn+e8UWIdXiP6O0=; b=s3Lf4veh8lrjKssUl1O7Ed
        /vGJqgpGiMSykm0f0ZJMu6L7MyfHXposTCsRsffZ+QsFFFO145u7UuWKhCIx4Avu
        0xBXMmXwzGJbEPGfzKrtfWEcruJ9HFeE+JELNzp+qW5tShSYATxf6zPiWM/F509b
        HDRv5pPlrpOYapA3CvNnxSN+ExJ1nxXPsJZRonRQIWKxpDI077LeJFrPqqU1rLy7
        j0BreimFg95E6lzBM6iylEnLsNcoBaHQ+llBPJ5cSU71ypbL1U5DCNy0Bty3Ob/k
        /ReIVjwpTN4KVp/JkPuE9HvA2cshyO4qXNVG78fxLgDkP06Urp85KLyrFn5Doxkg
        ==
X-ME-Sender: <xms:Hf31XVsbgnYB8b9jvMsbXtlOulqBlNQhdE2tiLHkZIfYYtJdrUOb8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Hf31XapV2Gok_-ENu-WAhwwbc1R9QyXzHg8-uVpSnn2Nh795GUAigw>
    <xmx:Hf31XbrraboyiFpBbm0E6hRqaGQdwuyBt9NXKT5nNZVAT8KmYWFCxQ>
    <xmx:Hf31Xa18XgDk9G0RjSS2k_tBJ4FOhOpz6tFqJRmpWpic-29NLhdUfA>
    <xmx:Hf31XVNPn64L11epda4-ixKjxW4Hz-WLXw1hIO-AVyODU0L8GZQtPg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2086C30600E0;
        Sun, 15 Dec 2019 04:30:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: adis16480: Add debugfs_reg_access entry" failed to apply to 4.4-stable tree
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 10:30:01 +0100
Message-ID: <1576402201169223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 4c35b7a51e2f291471f7221d112c6a45c63e83bc Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Mon, 28 Oct 2019 17:33:49 +0100
Subject: [PATCH] iio: adis16480: Add debugfs_reg_access entry
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The driver is defining debugfs entries by calling
`adis16480_debugfs_init()`. However, those entries are attached to the
iio_dev debugfs entry which won't exist if no debugfs_reg_access
callback is provided.

Fixes: 2f3abe6cbb6c ("iio:imu: Add support for the ADIS16480 and similar IMUs")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index f1d52563951c..078d49deebd4 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -923,6 +923,7 @@ static const struct iio_info adis16480_info = {
 	.read_raw = &adis16480_read_raw,
 	.write_raw = &adis16480_write_raw,
 	.update_scan_mode = adis_update_scan_mode,
+	.debugfs_reg_access = adis_debugfs_reg_access,
 };
 
 static int adis16480_stop_device(struct iio_dev *indio_dev)

