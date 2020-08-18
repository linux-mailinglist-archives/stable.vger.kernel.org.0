Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2566E248252
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 11:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgHRJzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 05:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgHRJzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 05:55:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FB7C206B5;
        Tue, 18 Aug 2020 09:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597744517;
        bh=YdeFNodbMw3+5vdZJalInuBsR22EJALQtVkFBtgWiEs=;
        h=Subject:To:From:Date:From;
        b=dIzpwBtRJEIgDtmaVg6YhdokbIzsRrYpr/A+5bMw8x6VwL+xHeHMnqukiYGZTpy5B
         GldcGTaOy12tiB871OpKWAmtKHY+8nEXfsnFpWEZNvgTRokee1pimhGQ0e+JSiDALm
         kKyBXwoA+TRN/6voBGiclgh1Q7leH/XJl5Gl7mm4=
Subject: patch "USB: quirks: Add no-lpm quirk for another Raydium touchscreen" added to usb-linus
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 11:55:40 +0200
Message-ID: <1597744540196250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: quirks: Add no-lpm quirk for another Raydium touchscreen

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5967116e8358899ebaa22702d09b0af57fef23e1 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Fri, 31 Jul 2020 13:16:20 +0800
Subject: USB: quirks: Add no-lpm quirk for another Raydium touchscreen

There's another Raydium touchscreen needs the no-lpm quirk:
[    1.339149] usb 1-9: New USB device found, idVendor=2386, idProduct=350e, bcdDevice= 0.00
[    1.339150] usb 1-9: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.339151] usb 1-9: Product: Raydium Touch System
[    1.339152] usb 1-9: Manufacturer: Raydium Corporation
...
[    6.450497] usb 1-9: can't set config #1, error -110

BugLink: https://bugs.launchpad.net/bugs/1889446
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200731051622.28643-1-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 7c1198f80c23..d1f38956b210 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -465,6 +465,8 @@ static const struct usb_device_id usb_quirk_list[] = {
 
 	{ USB_DEVICE(0x2386, 0x3119), .driver_info = USB_QUIRK_NO_LPM },
 
+	{ USB_DEVICE(0x2386, 0x350e), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
-- 
2.28.0


