Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5453E7E5D
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhHJRct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhHJRcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:32:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1C2060EE7;
        Tue, 10 Aug 2021 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616734;
        bh=yZOt5VO0MiAmwfVp3htw5q0uyivcUqZ6nEL8gkf3chg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2kdUJqxtOJRa/nk0K9VFylqBElc535u0GcYl4kzXH1/PMnLT42VlxWeNT05HTKkZ
         Tt5pMK1Tz/j4AYZkaEIJfEF1iUWTKmaGagsAdOOUWBhJ6eMoD2tjhfh1rFnL9U1pOL
         CDb9QeJbo6EPKQhKSdEv02l7rApmJ6k0Q6umQjdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Bauer <mail@david-bauer.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 24/54] USB: serial: ftdi_sio: add device ID for Auto-M3 OP-COM v2
Date:   Tue, 10 Aug 2021 19:30:18 +0200
Message-Id: <20210810172944.966316016@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Bauer <mail@david-bauer.net>

commit 8da0e55c7988ef9f08a708c38e5c75ecd8862cf8 upstream.

The Auto-M3 OP-COM v2 is a OBD diagnostic device using a FTD232 for the
USB connection.

Signed-off-by: David Bauer <mail@david-bauer.net>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -209,6 +209,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_6_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_R2000KU_TRUE_RNG) },
 	{ USB_DEVICE(FTDI_VID, FTDI_VARDAAN_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_AUTO_M3_OP_COM_V2_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0100_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0101_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0102_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -159,6 +159,9 @@
 /* Vardaan Enterprises Serial Interface VEUSB422R3 */
 #define FTDI_VARDAAN_PID	0xF070
 
+/* Auto-M3 Ltd. - OP-COM USB V2 - OBD interface Adapter */
+#define FTDI_AUTO_M3_OP_COM_V2_PID	0x4f50
+
 /*
  * Xsens Technologies BV products (http://www.xsens.com).
  */


