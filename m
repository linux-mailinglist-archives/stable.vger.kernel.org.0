Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51AC8FDB16
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 11:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfKOKSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 05:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfKOKSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 05:18:30 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89587207FA;
        Fri, 15 Nov 2019 10:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573813109;
        bh=Ogkq4/SbaqtkavKjSDwqXcmXSlZEc7Zyj8GeXyRNrsA=;
        h=Subject:To:From:Date:From;
        b=cVwx5fI9JEv/pngh1AZ9+js8GmnnDtm2yL4M+Bu8bLcN9fgW7n6lbG8ERkSHzLBR1
         27DQe3icALfHki7SggQ3LQUlkKBf1b3vvw3Knn7l104eevrQkzzRHqHkEXr0B3QT6Y
         1bFqkVgVBIKX7ZnOuOfadD40mSNu0/MGxGS6kZg4=
Subject: patch "USB: serial: option: add support for DW5821e with eSIM support" added to usb-next
To:     aleksander@aleksander.es, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Nov 2019 18:18:22 +0800
Message-ID: <157381310269251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: option: add support for DW5821e with eSIM support

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 957c31ea082e3fe5196f46d5b04018b10de47400 Mon Sep 17 00:00:00 2001
From: Aleksander Morgado <aleksander@aleksander.es>
Date: Thu, 7 Nov 2019 11:55:08 +0100
Subject: USB: serial: option: add support for DW5821e with eSIM support

The device exposes AT, NMEA and DIAG ports in both USB configurations.
Exactly same layout as the default DW5821e module, just a different
vid/pid.

P:  Vendor=413c ProdID=81e0 Rev=03.18
S:  Manufacturer=Dell Inc.
S:  Product=DW5821e-eSIM Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

P:  Vendor=413c ProdID=81e0 Rev=03.18
S:  Manufacturer=Dell Inc.
S:  Product=DW5821e-eSIM Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 7 Cfg#= 2 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#=0x6 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/option.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 06ab016be0b6..2023f1f4edaf 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -197,6 +197,7 @@ static void option_instat_callback(struct urb *urb);
 #define DELL_PRODUCT_5804_MINICARD_ATT		0x819b  /* Novatel E371 */
 
 #define DELL_PRODUCT_5821E			0x81d7
+#define DELL_PRODUCT_5821E_ESIM			0x81e0
 
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da
@@ -1044,6 +1045,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5804_MINICARD_ATT, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5821E),
 	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5821E_ESIM),
+	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/* ADU-E100, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
-- 
2.24.0


