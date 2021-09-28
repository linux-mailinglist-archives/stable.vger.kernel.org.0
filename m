Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E1941B686
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 20:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242229AbhI1SrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 14:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242214AbhI1SrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 14:47:09 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB06C06161C;
        Tue, 28 Sep 2021 11:45:30 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id a3so31124723oid.6;
        Tue, 28 Sep 2021 11:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IAgBqDEHnrmsA224Y5MI5Ekae8EarSmAHUekljKLA68=;
        b=lUi7Av3BO/NhEjhpHOQSEQFr7hpC8OHfUdKWGKyIfBB88KlsAeW4Dt/MdASsbZqgu9
         bZ9kH65OSNVxGe3m86XmwSIYB5ori2CyaOjge5CeJiTJilS8bz776qBPjUsHsGL5+plY
         NLQzePW/pQca4E/wCLDiz23zJLUMpEGh/f2eDaCHtLguM7h3AnEO3y0OVzWBP6PlYWlF
         ruxdquKfj5SfwEobcHWScilh+YmSpYvmu6wRGKnKZ0S1xOtoSLvvAXgUMRT1SCbH0o7v
         n6H5pzGUbzHmkKRb8vOwzgdBOhvA/6FR+pJ57py3CF7lK0nSnpOJ3OggVhMhu4Fu5IWh
         Zu+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=IAgBqDEHnrmsA224Y5MI5Ekae8EarSmAHUekljKLA68=;
        b=GGfey4IY23qpj40rDV91stEjbx5KhO23u8si0cZSWswx9bJ+cl5IKXob3vwc/b+rgs
         QEZ/4Sqq1R4df6a7MnP5UgWzBzWDNnvCEKPL2lOUzuTe0pyUiLYEkn8qPhvgK4d4Aim3
         xlvolsHxEPwfpsXiYfXELAji/WGpIFxDG1G38Ld6lXCarjLDdneX0RzRgYu75esgKJ8E
         fG3iwk1H19PbYZiIAkZ+W1nfOBomij0uO3+YC0H1niXh12WytOLUJ6U9lomo+iCcbbnM
         bpdsL2dKaC2BBBPEkC6EHDP3FyEVneN/8JKcRmcyqgwrkLaIGC/H+Sy5IKIrLeIYbVSe
         0AtA==
X-Gm-Message-State: AOAM532rhFJZLlnFMU26VuggIXVv0YMjD2uz1D1trkycHTK9Eg6s7Vtn
        aWTcarw5bjASMHrC9e8KXA8=
X-Google-Smtp-Source: ABdhPJzMiDRAPOD1IorcaznR32sfUJXsCcWdcHa8DJvZuSNjbkjqs6A8l7u0OdrIxgza+jUilI/xpw==
X-Received: by 2002:a54:4d99:: with SMTP id y25mr4628294oix.172.1632854729419;
        Tue, 28 Sep 2021 11:45:29 -0700 (PDT)
Received: from 2603-8090-2005-39b3-0000-0000-0000-1014.res6.spectrum.com.com (2603-8090-2005-39b3-0000-0000-0000-1014.res6.spectrum.com. [2603:8090:2005:39b3::1014])
        by smtp.gmail.com with ESMTPSA id a9sm2423736ooi.3.2021.09.28.11.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 11:45:28 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org, Hilda Wu <hildawu@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH v2] Subject: [PATCH] bluetooth: Add another Bluetooth part for Realtek 8852AE
Date:   Tue, 28 Sep 2021 13:45:20 -0500
Message-Id: <20210928184520.27539-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This Realtek device has both wifi and BT components. The latter reports
a USB ID of 0bda:4852, which is not in the table.

When adding the new device, I noticed that the RTL8852AE was mentioned in
two places. These are now combined.

The portion of /sys/kernel/debug/usb/devices pertaining to this device is

T:  Bus=06 Lev=01 Prnt=01 Port=03 Cnt=02 Dev#=  3 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=4852 Rev= 0.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
S:  SerialNumber=00e04c000001
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
v2 - fixed the merge conflict. I was working from the mainline HEAD that
     does not have the 0x04c5:0x165c device. I also merged the two
     separate locations with RTL8852AE entries.
---
 drivers/bluetooth/btusb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index da85cc14f931..34363d3c85e5 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -384,8 +384,12 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Realtek 8852AE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xc852), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0bda, 0x4852), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x04c5, 0x165c), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x04ca, 0x4006), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
@@ -456,10 +460,6 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Additional Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x04ca, 0x4005), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
-	/* Bluetooth component of Realtek 8852AE device */
-	{ USB_DEVICE(0x04ca, 0x4006), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
-
 	{ USB_DEVICE(0x04c5, 0x161f), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x18ef), .driver_info = BTUSB_REALTEK |
-- 
2.33.0

