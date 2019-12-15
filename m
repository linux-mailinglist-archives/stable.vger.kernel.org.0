Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58FFA11F701
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 10:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfLOJaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 04:30:05 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:50601 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726192AbfLOJaE (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 15 Dec 2019 04:30:04 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DCD9C6B7;
        Sun, 15 Dec 2019 04:30:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 04:30:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5C2YOc
        TBfC7YsfwyGtF59d17P75Rtf1vz4owBRnUlro=; b=WxCBdVjL5UaF6NjhJ2HVps
        32LHjAHEGW+7tCvEfiKUtKLFHhztMCB2N76H9n5MxNrpYpMKa8yBvg3oy/SjEkv+
        NKJeNSm+EKjfK4pFDEaNqY9qXN5Cz1kjVJGKaCmBSgZCscxRSOHddYcAoves++fV
        kDjstIupEpsFIvBuT1+zX3t1M0jimj8K++zXn9OeITujQjCYPc7JxA4FEkRyEEHa
        ZeVKrhnCXPZhNer3WJaiyluUlh8ttO+C76m33+3jF+RnsRczdZZhPIzdtoznberJ
        2hM/Uh0axZkepqjdwL48Se8AOf6cplDnThbNDdCBGT0AQM8pT9p4nNZYoP6xK89w
        ==
X-ME-Sender: <xms:G_31Xea_glORz8vcXbr-lNfQGW0HeiR7CVntstkDtU526sQ01-y1Lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:G_31XbFmblmC9nWkjykjzUuuwNn6QhvXlazG_yJ4jg-WFl2hFgDnBg>
    <xmx:G_31Xf6e6SiITxOumDdKKYtpznXGj6mGxviI1v3obpObkxxURs6T6g>
    <xmx:G_31XUsDscqPeoHbaOlnGiy7Di74Jjxo5XWPLgtIzPPTST0q09f1lA>
    <xmx:G_31XdhIM30zKK5WTwP0_VZzV_PkkGI-vDrrtVWxlPA8Fs7TsKjlAA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1899D80063;
        Sun, 15 Dec 2019 04:30:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: adis16480: Add debugfs_reg_access entry" failed to apply to 4.9-stable tree
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 10:30:00 +0100
Message-ID: <1576402200163201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

