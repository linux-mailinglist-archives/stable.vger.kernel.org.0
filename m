Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2DA56C71D
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390527AbfGRDVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389191AbfGRDKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:10:02 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1FFE205F4;
        Thu, 18 Jul 2019 03:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419401;
        bh=Ix3N8KWDwTYPs8Mxo+aWS0wG+HgdX7s0rAmBv06dUIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOYyHDhRI+FX02xkKMZ5Uawj8mw+RqD2/lCx4+tfHURzFu++lkxIzK1qF80iQjYgv
         hriBZu3G7owdaWOqj4wvZVRPyM+zgcw1Ny6mPcXvAMyll4AcAdepwiVjLojS+DGtu1
         rwkoaag8QiF/aUgqSlFWMOOMzSPWnKAzvJnUcdNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andreas Fritiofson <andreas.fritiofson@unjo.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 50/80] USB: serial: ftdi_sio: add ID for isodebug v1
Date:   Thu, 18 Jul 2019 12:01:41 +0900
Message-Id: <20190718030102.485337081@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Fritiofson <andreas.fritiofson@unjo.com>

commit f8377eff548170e8ea8022c067a1fbdf9e1c46a8 upstream.

This adds the vid:pid of the isodebug v1 isolated JTAG/SWD+UART. Only the
second channel is available for use as a serial port.

Signed-off-by: Andreas Fritiofson <andreas.fritiofson@unjo.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1024,6 +1024,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(AIRBUS_DS_VID, AIRBUS_DS_P8GR) },
 	/* EZPrototypes devices */
 	{ USB_DEVICE(EZPROTOTYPES_VID, HJELMSLUND_USB485_ISO_PID) },
+	{ USB_DEVICE_INTERFACE_NUMBER(UNJO_VID, UNJO_ISODEBUG_V1_PID, 1) },
 	{ }					/* Terminating entry */
 };
 
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


