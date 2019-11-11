Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A56F77DF
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 16:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKKPjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 10:39:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbfKKPjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 10:39:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 563E42190F;
        Mon, 11 Nov 2019 15:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573486751;
        bh=ExJIYgF/iMSvMxAZKci+2QCtVJjiIoMzIciiZJTTTgo=;
        h=Subject:To:From:Date:From;
        b=oTn+0eJLaC0vTAOFr64bu6XjX5PVdDvsXViCRrVCJUTtXtY/1e61oHHOpF9kPP+Z8
         zEmVjb7WcXmtwpk2z1+IiKF5BMP46e+81CJFg1fy0MJq/NDDOsEwBq1RwgxoQz6AvG
         dD22FDrl+iEqFzKQJbuJiQ0OfYyRKHsXHPSc9Pxw=
Subject: patch "staging: rtl8723bs: Drop ACPI device ids" added to staging-testing
To:     hdegoede@redhat.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 16:38:54 +0100
Message-ID: <1573486734194107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8723bs: Drop ACPI device ids

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 2d9d2491530a156b9a5614adf9dc79285e35d55e Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 11 Nov 2019 12:38:46 +0100
Subject: staging: rtl8723bs: Drop ACPI device ids

The driver only binds by SDIO device-ids, all the ACPI device-id does
is causing the driver to load unnecessarily on devices where the DSDT
contains a bogus OBDA8723 device.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191111113846.24940-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index c48d2df97285..859f4a0afb95 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -24,13 +24,7 @@ static const struct sdio_device_id sdio_ids[] =
 	{ SDIO_DEVICE(0x024c, 0xb723), },
 	{ /* end: all zeroes */				},
 };
-static const struct acpi_device_id acpi_ids[] = {
-	{"OBDA8723", 0x0000},
-	{}
-};
-
 MODULE_DEVICE_TABLE(sdio, sdio_ids);
-MODULE_DEVICE_TABLE(acpi, acpi_ids);
 
 static int rtw_drv_init(struct sdio_func *func, const struct sdio_device_id *id);
 static void rtw_dev_remove(struct sdio_func *func);
-- 
2.24.0


