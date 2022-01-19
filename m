Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AED4941A2
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 21:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbiASUSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 15:18:49 -0500
Received: from p-impout005aa.msg.pkvw.co.charter.net ([47.43.26.136]:57702
        "EHLO p-impout005.msg.pkvw.co.charter.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231146AbiASUSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 15:18:47 -0500
Received: from localhost.localdomain ([24.31.246.181])
        by cmsmtp with ESMTP
        id AHPlndEzHM0uWAHPmnXTMO; Wed, 19 Jan 2022 20:18:44 +0000
X-Authority-Analysis: v=2.4 cv=AY2iolbG c=1 sm=1 tr=0 ts=61e87224
 a=cAe/7qmlxnd6JlJqP68I9A==:117 a=cAe/7qmlxnd6JlJqP68I9A==:17 a=NEAV23lmAAAA:8
 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=JXEDzCox5okIAoVKa0MA:9
 a=SzazLyfi1tnkUD6oumHU:22 a=AjGcO6oz07-iQ99wixmX:22
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org, Hilda Wu <hildawu@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        stable@vger.kernel.org
Subject: [PATCH] Bluetooth: btusb: Add one more Bluetooth part for the Realtek RTL8852AE
Date:   Wed, 19 Jan 2022 14:18:37 -0600
Message-Id: <20220119201837.4135-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfP2vpwKuN2gZq6KKycyaBtg3c00GoQBPa58vKQ2i+Ku9fc3aVGuqSJPISoDbaLxCyBkGUr0fL6qQ6VpDBPr6NBGErOY9wPAI/FkjNh9bY5cU5+dkxrDN
 SzBTDoOd1TiMQOzXrBUoveUvuh7KUSFoauoycBLuanWnjmiKjEZWGuYOPyWdWZmRl3e56L09TxZVRJvCZcyhUOWv5tDSbiyRCnT0Zn1pXC730H+4PhODxdsz
 SGBvyjRqNdYVrVkxuP2zPopZ60Oa8SEXtqbjTQmyLgUBeYdeszhlxN7ygikxWDWWOFVx2HKKnXXD0lsmcBxBkVw7PTr9ejlqa9LxSbSRbeoecv8ARMS9qGdH
 878UtUKRrYDqoJotmSk4CmhZK+mrs5oiys6NLi/nzIqA1IGMo7f37qEtPjiUSUwOrVVG8QdZ
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This Realtek device has both wifi and BT components. The latter reports
a USB ID of 0bda:2852, which is not in the table.

BT device description in /sys/kernel/debug/usb/devices contains the following entries:

T: Bus=01 Lev=01 Prnt=01 Port=03 Cnt=02 Dev#= 3 Spd=12 MxCh= 0
D: Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
P: Vendor=0bda ProdID=2852 Rev= 0.00
S: Manufacturer=Realtek
S: Product=Bluetooth Radio
S: SerialNumber=00e04c000001
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=81(I) Atr=03(Int.) MxPS= 16 Ivl=1ms
E: Ad=02(O) Atr=02(Bulk) MxPS= 64 Ivl=0ms
E: Ad=82(I) Atr=02(Bulk) MxPS= 64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 0 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 0 Ivl=1ms
I: If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 9 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 9 Ivl=1ms
I: If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 17 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 17 Ivl=1ms
I: If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 25 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 25 Ivl=1ms
I: If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 33 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 33 Ivl=1ms
I: If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 49 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 49 Ivl=1ms

The missing USB_ID was reported by user trius65 at https://github.com/lwfinger/rtw89/issues/122

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable@vger.kernel.org
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c30d131da784..cc690f04d2c3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -405,6 +405,8 @@ static const struct usb_device_id blacklist_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek 8852AE Bluetooth devices */
+	{ USB_DEVICE(0x0bda, 0x2852), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0xc852), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0x385a), .driver_info = BTUSB_REALTEK |
-- 
2.34.1

