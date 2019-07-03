Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E175E3D6
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfGCM0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfGCM0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:26:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B4E4218A6;
        Wed,  3 Jul 2019 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562156792;
        bh=NIGVAsVJseEaF4wUyLdsLM/qC/lhHuh0TcgFc3NDcfY=;
        h=Subject:To:From:Date:From;
        b=T1sxAf5WYCVLNahwjs0u5kYuvfBWwElC/TMCc1QDOS5vpmaCjTQvpBrakncSeAnkN
         AJyiMbe3MXip0R0HBrYPwxN5UI/kxUzThU7IYTpIMvQ3aOiDq1/xTq3pUDlVMdMPsi
         9rXiKNBtkKh0+Wa05Hq4ir9uBHoTIRCbEwEKurdY=
Subject: patch "USB: serial: ftdi_sio: add ID for isodebug v1" added to usb-next
To:     andreas.fritiofson@unjo.com, johan@kernel.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 03 Jul 2019 14:26:25 +0200
Message-ID: <156215678521574@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: ftdi_sio: add ID for isodebug v1

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From f8377eff548170e8ea8022c067a1fbdf9e1c46a8 Mon Sep 17 00:00:00 2001
From: Andreas Fritiofson <andreas.fritiofson@unjo.com>
Date: Fri, 28 Jun 2019 15:08:34 +0200
Subject: USB: serial: ftdi_sio: add ID for isodebug v1

This adds the vid:pid of the isodebug v1 isolated JTAG/SWD+UART. Only the
second channel is available for use as a serial port.

Signed-off-by: Andreas Fritiofson <andreas.fritiofson@unjo.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 1d8461ae2c34..23669a584bae 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1029,6 +1029,7 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(AIRBUS_DS_VID, AIRBUS_DS_P8GR) },
 	/* EZPrototypes devices */
 	{ USB_DEVICE(EZPROTOTYPES_VID, HJELMSLUND_USB485_ISO_PID) },
+	{ USB_DEVICE_INTERFACE_NUMBER(UNJO_VID, UNJO_ISODEBUG_V1_PID, 1) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 5755f0df0025..f12d806220b4 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1543,3 +1543,9 @@
 #define CHETCO_SEASMART_DISPLAY_PID	0xA5AD /* SeaSmart NMEA2000 Display */
 #define CHETCO_SEASMART_LITE_PID	0xA5AE /* SeaSmart Lite USB Adapter */
 #define CHETCO_SEASMART_ANALOG_PID	0xA5AF /* SeaSmart Analog Adapter */
+
+/*
+ * Unjo AB
+ */
+#define UNJO_VID			0x22B7
+#define UNJO_ISODEBUG_V1_PID		0x150D
-- 
2.22.0


