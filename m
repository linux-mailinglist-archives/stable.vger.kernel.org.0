Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E71CBC8C
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 16:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389052AbfJDOCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 10:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388625AbfJDOCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 10:02:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7C2720700;
        Fri,  4 Oct 2019 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570197720;
        bh=2uU3W0HwoMES+XqvBEOoY4CHJS/h1+xmqh1RgbG+jmg=;
        h=Subject:To:From:Date:From;
        b=nBOgvwCDrHv+MnkCpFFdOFMQQ03ddeAA2If6AeITwkOVEkrybcwYTEcquwJxCHeAk
         2gBcsYxSauapDiKHIn5bBA4lUULLMNfdNfQuPlQx9WgRLGysB7c8SQHE9YE+tLeG/a
         PEngacttTQcu6MiE7CvJGMNkl3Rh1WMqrWsqkcJ8=
Subject: patch "USB: serial: option: add Telit FN980 compositions" added to usb-linus
To:     dnlplm@gmail.com, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 16:01:50 +0200
Message-ID: <157019771023174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: option: add Telit FN980 compositions

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5eb3f4b87a0e7e949c976f32f296176a06d1a93b Mon Sep 17 00:00:00 2001
From: Daniele Palmas <dnlplm@gmail.com>
Date: Mon, 23 Sep 2019 12:23:28 +0200
Subject: USB: serial: option: add Telit FN980 compositions

This patch adds the following Telit FN980 compositions:

0x1050: tty, adb, rmnet, tty, tty, tty, tty
0x1051: tty, adb, mbim, tty, tty, tty, tty
0x1052: rndis, tty, adb, tty, tty, tty, tty
0x1053: tty, adb, ecm, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/option.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 38e920ac7f82..10ac3610d922 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1154,6 +1154,14 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, TELIT_PRODUCT_LE922_USBCFG5, 0xff),
 	  .driver_info = RSVD(0) | RSVD(1) | NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1050, 0xff),	/* Telit FN980 (rmnet) */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1051, 0xff),	/* Telit FN980 (MBIM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1052, 0xff),	/* Telit FN980 (RNDIS) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1053, 0xff),	/* Telit FN980 (ECM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),
-- 
2.23.0


