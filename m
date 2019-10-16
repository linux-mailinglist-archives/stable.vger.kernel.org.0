Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FB8D9F93
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437863AbfJPVz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437858AbfJPVz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:56 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F12F20872;
        Wed, 16 Oct 2019 21:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262956;
        bh=D7p1egD3uCx9qb4alD0rkTnmhpO0xomFFmgHLmj87RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BE7z7YK5XfzZqLDShyoFmkwpLdaq7NE/4AU2HR+wFqeqJXzzbS7SHJIvuwArZ7jaF
         /JSFo5hhVVSCDAkGslikTRWdbzfmiDnFoKQuYuEunm/lh9evsZs3Hy5Xr+Y1+9z2EO
         jXlwuyiViUIfNNQxb4FiH5ERzA56553HaPQHwKzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Beni Mahler <beni.mahler@gmx.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 25/65] USB: serial: ftdi_sio: add device IDs for Sienna and Echelon PL-20
Date:   Wed, 16 Oct 2019 14:50:39 -0700
Message-Id: <20191016214821.983489547@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Beni Mahler <beni.mahler@gmx.net>

commit 357f16d9e0194cdbc36531ff88b453481560b76a upstream.

Both devices added here have a FTDI chip inside. The device from Echelon
is called 'Network Interface' it is actually a LON network gateway.

 ID 0403:8348 Future Technology Devices International, Ltd
 https://www.eltako.com/fileadmin/downloads/de/datenblatt/Datenblatt_PL-SW-PROF.pdf

 ID 0920:7500 Network Interface
 https://www.echelon.com/products/u20-usb-network-interface

Signed-off-by: Beni Mahler <beni.mahler@gmx.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    3 +++
 drivers/usb/serial/ftdi_sio_ids.h |    9 +++++++++
 2 files changed, 12 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1025,6 +1025,9 @@ static const struct usb_device_id id_tab
 	/* EZPrototypes devices */
 	{ USB_DEVICE(EZPROTOTYPES_VID, HJELMSLUND_USB485_ISO_PID) },
 	{ USB_DEVICE_INTERFACE_NUMBER(UNJO_VID, UNJO_ISODEBUG_V1_PID, 1) },
+	/* Sienna devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_SIENNA_PID) },
+	{ USB_DEVICE(ECHELON_VID, ECHELON_U20_PID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -39,6 +39,9 @@
 
 #define FTDI_LUMEL_PD12_PID	0x6002
 
+/* Sienna Serial Interface by Secyourit GmbH */
+#define FTDI_SIENNA_PID		0x8348
+
 /* Cyber Cortex AV by Fabulous Silicon (http://fabuloussilicon.com) */
 #define CYBER_CORTEX_AV_PID	0x8698
 
@@ -689,6 +692,12 @@
 #define BANDB_ZZ_PROG1_USB_PID	0xBA02
 
 /*
+ * Echelon USB Serial Interface
+ */
+#define ECHELON_VID		0x0920
+#define ECHELON_U20_PID		0x7500
+
+/*
  * Intrepid Control Systems (http://www.intrepidcs.com/) ValueCAN and NeoVI
  */
 #define INTREPID_VID		0x093C


