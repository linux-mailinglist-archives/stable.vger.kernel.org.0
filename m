Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F2811F700
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 10:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfLOJaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 04:30:03 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:58887 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbfLOJaC (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 15 Dec 2019 04:30:02 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D3A076AC;
        Sun, 15 Dec 2019 04:30:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 04:30:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+fyf52
        WG4oK3xXSviaAITmuUU+ODh7JaFE5LoqZyp5c=; b=m2iP6IlImd0SEF4mEie9DK
        6J7JTITHRsr4JIODmwGUCbMfbnNtly9Dhz4S/59s+e6lskRPcHwh4+6Ln7vEr7mq
        /6sofzPLPAL7VV5vHLf3/cQPAtZJinfRbD/V6AyoXEPGXxO75ugHE2kQkfCZTeq5
        uqcOd4ZOaOCQo6JaXq9r84iyaTLhiN/4tJ7sOdGN5KnQGXi88rI2g603wHqDxPUb
        NwlxewlfiVOhjCLDYmoFHcSjht7Ae6Oe+MGy89QNvPNtEQDbxrcN5nrew5lv6b3U
        tPQCtfQz/b7LGqV86ahwNCtqHD04RrSllpzQm1UP8lIP8fBCn2uDttBC+F0maPPg
        ==
X-ME-Sender: <xms:Gf31XQBjb_UEh2v8xBAZpM_ZIi2TZyoywEALvtOTVAOIQ8bzFl7nwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Gf31XdbbmYnUhGvmUdcETDs6fELG-tol5XuCpf_h4G7lr6qMU7wGcA>
    <xmx:Gf31XWf6MDF3cvGZLzDNoPgL-6jhO2at9BjnDeTExhG3Tw8XIpTtvg>
    <xmx:Gf31XQfdaOYfqHznp9u9O8k-s5DcDK3G4nZ-fS5KT4OyCdPM0E7Iiw>
    <xmx:Gf31XW0OHXGGpkqJ2bo4oi9bANl8kIBPZLm6OH-bZbJcuVxG3wnKQw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B80280060;
        Sun, 15 Dec 2019 04:30:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: adis16480: Add debugfs_reg_access entry" failed to apply to 4.14-stable tree
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 10:29:58 +0100
Message-ID: <15764021987748@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

