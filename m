Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9110DFDB10
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 11:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfKOKSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 05:18:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbfKOKSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 05:18:08 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40FC520748;
        Fri, 15 Nov 2019 10:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573813087;
        bh=3Dt8QA++wQm9U9dfB0bvgxh0uJgF//B5E0vy24ciiE8=;
        h=Subject:To:From:Date:From;
        b=nToP5pjom20NuOiqtg+Cj9o2j9qammgRf3xSyIsfxJEzvEYzaEMzyrm8Or9Ldx5+J
         mtBrkO8/g8WxpRMzCAu3mjwGCN0IURriMN8Gl5pTe6RVH1uIXC4OChp+uom2Cxef44
         2G59Vy0DPgnbfQgJu/DnFARpIY42gMl1Xjnclfeo=
Subject: patch "USB: serial: option: add support for Foxconn T77W968 LTE modules" added to usb-testing
To:     aleksander@aleksander.es, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Nov 2019 18:17:36 +0800
Message-ID: <1573813056109108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: option: add support for Foxconn T77W968 LTE modules

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From f0797095423e6ea3b4be61134ee353c7f504d440 Mon Sep 17 00:00:00 2001
From: Aleksander Morgado <aleksander@aleksander.es>
Date: Wed, 13 Nov 2019 11:14:05 +0100
Subject: USB: serial: option: add support for Foxconn T77W968 LTE modules

These are the Foxconn-branded variants of the Dell DW5821e modules,
same USB layout as those. The device exposes AT, NMEA and DIAG ports
in both USB configurations.

P:  Vendor=0489 ProdID=e0b4 Rev=03.18
S:  Manufacturer=FII
S:  Product=T77W968 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

P:  Vendor=0489 ProdID=e0b4 Rev=03.18
S:  Manufacturer=FII
S:  Product=T77W968 LTE
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
[ johan: drop id defines ]
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/option.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 2023f1f4edaf..e9491d400a24 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1993,6 +1993,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0xa31d, 0xff, 0x06, 0x13) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0xa31d, 0xff, 0x06, 0x14) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0xa31d, 0xff, 0x06, 0x1b) },
+	{ USB_DEVICE(0x0489, 0xe0b4),						/* Foxconn T77W968 */
+	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
+	{ USB_DEVICE(0x0489, 0xe0b5),						/* Foxconn T77W968 ESIM */
+	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x2cb7, 0x0104),						/* Fibocom NL678 series */
-- 
2.24.0


