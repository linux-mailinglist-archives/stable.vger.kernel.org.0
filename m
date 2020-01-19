Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A92EB141E43
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 14:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgASNfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 08:35:15 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:57907 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726816AbgASNfO (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 19 Jan 2020 08:35:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A48EB56E;
        Sun, 19 Jan 2020 08:35:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 08:35:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=P9N+3H
        F9OZmf9SVrBPOrWHcWTnaQorOyJrj4vYUd0K4=; b=vm2vrzSPn6JLYpvxDjqZhs
        na7zPxP4Atmo5AsVBrM/+KIIssKXSIcPMqyp8ToHSa+8NtUnSFFZNS/hkvzxKLEy
        ZcEW7R3HSiJ65Y9dTP8PuPyl/KpnS3s5Y7HwIICjyqp2VDVoVC7GkGwfTuxDhuyT
        X3AiUuJiIa28ukdQ6ULlPOlCYWiBbxlA8avR0MbLqWH9xP46IyHbZPu4PlXsJTwS
        uWaC82ggs3AX0WMyqZpk1PyYgGJb/b69Nala8IlH2OPnfBIIgU+Ge7g9zOP2nE4B
        ypN7O4YqEfRlGxOIOJPR16vxi8IO3XJSQAg+XiF5f4/qFlpZhwWQtIFa0J2jCkDg
        ==
X-ME-Sender: <xms:EFskXo8hylu5up1b8tZMmER84_qUd3vQ0iTvifnxB1nEk6uzhfFXwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:EFskXgQDKT8qIxwdGvCPStPj-ySQ5U7yi5h2e-16_KM2fY9tngAVTA>
    <xmx:EFskXiV0V9_OmMJ0YMw7kWHSHmCm6-n8rcW-ZszYoMtgLJDojU1oKw>
    <xmx:EFskXq8xkhNoWI_qkHDaiYxJbJxEObpN1Mx7k4Nl2dxvf5gWn8q2QA>
    <xmx:EVskXtTFoUklTSMNoqCJvXIHoUYJtlI74ZJ5CDiXlpUM-dSP73nbmg>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C4D33060B16;
        Sun, 19 Jan 2020 08:35:11 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: buffer: align the size of scan bytes to size of the" failed to apply to 4.4-stable tree
To:     lars.moellendorf@plating.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, gregkh@linuxfoundation.org, lars@metafoo.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 14:35:10 +0100
Message-ID: <157944091042104@kroah.com>
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

From 883f616530692d81cb70f8a32d85c0d2afc05f69 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Lars=20M=C3=B6llendorf?= <lars.moellendorf@plating.de>
Date: Fri, 13 Dec 2019 14:50:55 +0100
Subject: [PATCH] iio: buffer: align the size of scan bytes to size of the
 largest element
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Previous versions of `iio_compute_scan_bytes` only aligned each element
to its own length (i.e. its own natural alignment). Because multiple
consecutive sets of scan elements are buffered this does not work in
case the computed scan bytes do not align with the natural alignment of
the first scan element in the set.

This commit fixes this by aligning the scan bytes to the natural
alignment of the largest scan element in the set.

Fixes: 959d2952d124 ("staging:iio: make iio_sw_buffer_preenable much more general.")
Signed-off-by: Lars Möllendorf <lars.moellendorf@plating.de>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index c193d64e5217..112225c0e486 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -566,7 +566,7 @@ static int iio_compute_scan_bytes(struct iio_dev *indio_dev,
 				const unsigned long *mask, bool timestamp)
 {
 	unsigned bytes = 0;
-	int length, i;
+	int length, i, largest = 0;
 
 	/* How much space will the demuxed element take? */
 	for_each_set_bit(i, mask,
@@ -574,13 +574,17 @@ static int iio_compute_scan_bytes(struct iio_dev *indio_dev,
 		length = iio_storage_bytes_for_si(indio_dev, i);
 		bytes = ALIGN(bytes, length);
 		bytes += length;
+		largest = max(largest, length);
 	}
 
 	if (timestamp) {
 		length = iio_storage_bytes_for_timestamp(indio_dev);
 		bytes = ALIGN(bytes, length);
 		bytes += length;
+		largest = max(largest, length);
 	}
+
+	bytes = ALIGN(bytes, largest);
 	return bytes;
 }
 

