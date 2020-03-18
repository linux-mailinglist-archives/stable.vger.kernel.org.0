Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393F218993E
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgCRKYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRKYo (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:24:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E69632077C;
        Wed, 18 Mar 2020 10:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527083;
        bh=jxYFwz3xfvQm7RGyF1jEiP9b5r6Hs45Spag0BJiq0p8=;
        h=Subject:To:From:Date:From;
        b=iasz2tBF+E7nHdtB2tQ/6jUZilOnBgmG4NxVqLOUkYFA9jcblOSZvPahMcI3nim/C
         fUw9k1U4GJOkiHSQAHaBKehfeuEk5gY90IlkJ/vuyCQGoNJ30PsMEwToaQEcZ25ftO
         2lP1dlLcUTUnjyfhgfwwkoywVVyXujyPiKUjdyUs=
Subject: patch "iio: st_sensors: remap SMO8840 to LIS2DH12" added to staging-linus
To:     jesse.sung@canonical.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hdegoede@redhat.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 11:24:21 +0100
Message-ID: <1584527061254113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: st_sensors: remap SMO8840 to LIS2DH12

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e43d110cdc206b6df4dd438cd10c81d1da910aad Mon Sep 17 00:00:00 2001
From: Wen-chien Jesse Sung <jesse.sung@canonical.com>
Date: Mon, 24 Feb 2020 17:54:26 +0800
Subject: iio: st_sensors: remap SMO8840 to LIS2DH12

According to ST, the HID is for LIS2DH12.

Fixes: 3d56e19815b3 ("iio: accel: st_accel: Add support for the SMO8840 ACPI id")
Signed-off-by: Wen-chien Jesse Sung <jesse.sung@canonical.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/st_accel_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/st_accel_i2c.c b/drivers/iio/accel/st_accel_i2c.c
index 633955d764cc..849cf74153c4 100644
--- a/drivers/iio/accel/st_accel_i2c.c
+++ b/drivers/iio/accel/st_accel_i2c.c
@@ -110,7 +110,7 @@ MODULE_DEVICE_TABLE(of, st_accel_of_match);
 
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id st_accel_acpi_match[] = {
-	{"SMO8840", (kernel_ulong_t)LNG2DM_ACCEL_DEV_NAME},
+	{"SMO8840", (kernel_ulong_t)LIS2DH12_ACCEL_DEV_NAME},
 	{"SMO8A90", (kernel_ulong_t)LNG2DM_ACCEL_DEV_NAME},
 	{ },
 };
-- 
2.25.1


