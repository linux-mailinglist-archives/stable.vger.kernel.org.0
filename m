Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330B639600D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhEaOW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232267AbhEaORE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:17:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 157BE619A9;
        Mon, 31 May 2021 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468611;
        bh=NCzz0MCtWRPBgWtEN04unSgfqF8uHrAdQhKjuqSnVoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdYTPUkP20zeqs56bpV58yeppGz8+f06/KeeJ5zvnODwXFMzQRsaScbE2tG/HyRKR
         tMs3vKYtwZ5NhYmZXsPiUgHKKGA3zzUcOSWj6t+iN+Ur+4dcSjC+0qxRkguCinNRpo
         ny+GOKhtvllPEnXCnfgtsP0LzbpmxJzmFEtVyWw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Andreas Schorpp <dominik.a.schorpp@ids.de>,
        Juergen Borleis <jbe@pengutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 058/177] USB: serial: ftdi_sio: add IDs for IDS GmbH Products
Date:   Mon, 31 May 2021 15:13:35 +0200
Message-Id: <20210531130649.922614258@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Andreas Schorpp <dominik.a.schorpp@ids.de>

commit c5a80540e425a5f9a82b0f3163e3b6a4331f33bc upstream.

Add the IDS GmbH Vendor ID and the Product IDs for SI31A (2xRS232)
and CM31A (LoRaWAN Modem).

Signed-off-by: Dominik Andreas Schorpp <dominik.a.schorpp@ids.de>
Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    3 +++
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 10 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1034,6 +1034,9 @@ static const struct usb_device_id id_tab
 	/* Sienna devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_SIENNA_PID) },
 	{ USB_DEVICE(ECHELON_VID, ECHELON_U20_PID) },
+	/* IDS GmbH devices */
+	{ USB_DEVICE(IDS_VID, IDS_SI31A_PID) },
+	{ USB_DEVICE(IDS_VID, IDS_CM31A_PID) },
 	/* U-Blox devices */
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ZED_PID) },
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ODIN_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1568,6 +1568,13 @@
 #define UNJO_ISODEBUG_V1_PID		0x150D
 
 /*
+ * IDS GmbH
+ */
+#define IDS_VID				0x2CAF
+#define IDS_SI31A_PID			0x13A2
+#define IDS_CM31A_PID			0x13A3
+
+/*
  * U-Blox products (http://www.u-blox.com).
  */
 #define UBLOX_VID			0x1546


