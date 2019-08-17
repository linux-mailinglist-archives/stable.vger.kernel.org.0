Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1612C91126
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 17:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfHQPKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 11:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfHQPKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Aug 2019 11:10:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1C942086C;
        Sat, 17 Aug 2019 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566054635;
        bh=D2O0LokQSIhHpQhaVicYKnwz8QiZSe3unfyfczo7gWw=;
        h=Subject:To:From:Date:From;
        b=zxp4u8sEitIJELNO8AhGocXVB1Ml+mbl54FjN0OgEET1axwdiPK02G5gKrvNyr/27
         kP5LAkFYxMhph+apPE5SUPOsQsyISsa3D4VXW7smDbwDhyP3paamMU/9NIPkdfANvD
         O5FQp4J+l5Cy5xuVe5Pzx9Fl9i7owW8BYHlCJNl0=
Subject: patch "USB: serial: option: add the BroadMobi BM818 card" added to usb-linus
To:     bob.ham@puri.sm, angus@akkea.ca, johan@kernel.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 17 Aug 2019 17:10:24 +0200
Message-ID: <15660546241249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: option: add the BroadMobi BM818 card

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e5d8badf37e6b547842f2fcde10361b29e08bd36 Mon Sep 17 00:00:00 2001
From: Bob Ham <bob.ham@puri.sm>
Date: Wed, 24 Jul 2019 07:52:26 -0700
Subject: USB: serial: option: add the BroadMobi BM818 card

Add a VID:PID for the BroadMobi BM818 M.2 card

T:  Bus=01 Lev=03 Prnt=40 Port=03 Cnt=01 Dev#= 44 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2020 ProdID=2060 Rev=00.00
S:  Manufacturer=Qualcomm, Incorporated
S:  Product=Qualcomm CDMA Technologies MSM
C:  #Ifs= 5 Cfg#= 1 Atr=e0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=fe Prot=ff Driver=(none)
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

Signed-off-by: Bob Ham <bob.ham@puri.sm>
Signed-off-by: Angus Ainslie (Purism) <angus@akkea.ca>
Cc: stable <stable@vger.kernel.org>
[ johan: use USB_DEVICE_INTERFACE_CLASS() ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 546d7f610a24..38e920ac7f82 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1965,6 +1965,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x7e11, 0xff, 0xff, 0xff) },	/* D-Link DWM-156/A3 */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2020, 0x2031, 0xff),			/* Olicard 600 */
 	  .driver_info = RSVD(4) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x2020, 0x2060, 0xff),			/* BroadMobi BM818 */
+	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2020, 0x4000, 0xff) },			/* OLICARD300 - MT6225 */
 	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
 	{ USB_DEVICE(VIATELECOM_VENDOR_ID, VIATELECOM_PRODUCT_CDS7) },
-- 
2.22.1


