Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF9E190F27
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgCXNSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728673AbgCXNSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:18:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E23220775;
        Tue, 24 Mar 2020 13:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055882;
        bh=0Tl/uLt/DtI6IenNCwj6LwcQMUVo0+qBxc/JUlB4s4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTzG2F88bg8Yyaa0aLLQh00xTrE7olh2uaxgdoy38whXeAomzvqBvMzaFzWoLp2vn
         093vextN9vXccVIaz0/NWMovkcbFNR27SM6iRS8HKw9U694iD1rd3jQr42J20H+NQ9
         O3fzVXgSrXon+KODyrsLsWgE/81gLHR2gmziFTQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wen-chien Jesse Sung <jesse.sung@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 057/102] iio: st_sensors: remap SMO8840 to LIS2DH12
Date:   Tue, 24 Mar 2020 14:10:49 +0100
Message-Id: <20200324130812.491444025@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen-chien Jesse Sung <jesse.sung@canonical.com>

commit e43d110cdc206b6df4dd438cd10c81d1da910aad upstream.

According to ST, the HID is for LIS2DH12.

Fixes: 3d56e19815b3 ("iio: accel: st_accel: Add support for the SMO8840 ACPI id")
Signed-off-by: Wen-chien Jesse Sung <jesse.sung@canonical.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/st_accel_i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/st_accel_i2c.c
+++ b/drivers/iio/accel/st_accel_i2c.c
@@ -114,7 +114,7 @@ MODULE_DEVICE_TABLE(of, st_accel_of_matc
 
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id st_accel_acpi_match[] = {
-	{"SMO8840", (kernel_ulong_t)LNG2DM_ACCEL_DEV_NAME},
+	{"SMO8840", (kernel_ulong_t)LIS2DH12_ACCEL_DEV_NAME},
 	{"SMO8A90", (kernel_ulong_t)LNG2DM_ACCEL_DEV_NAME},
 	{ },
 };


