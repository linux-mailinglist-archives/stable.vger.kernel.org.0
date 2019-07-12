Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5049666E15
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfGLMcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728127AbfGLMcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:32:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14F6D216E3;
        Fri, 12 Jul 2019 12:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934767;
        bh=T/Oa2dK6GoM4tKHT07w1iRVwjd7s80b2skmvamRAhPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JdtATwvEE7lCqmmTUbGbb7J21kJjTjWefgzoWfUf+V/l6o08I2ORjqH9urrfTnYb
         zpSqr6obShWWO2wBArGZ62ZiRvo2u0TvVbd6k7Qk52GyNXaVGlx4enAqwU1PyBLyGf
         S8BEwlxx92hEzNJnvdUwyh61vWfrVTkF5ZKDGg1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andreas Fritiofson <andreas.fritiofson@unjo.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.2 24/61] USB: serial: ftdi_sio: add ID for isodebug v1
Date:   Fri, 12 Jul 2019 14:19:37 +0200
Message-Id: <20190712121621.931437679@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
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
@@ -1029,6 +1029,7 @@ static const struct usb_device_id id_tab
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


