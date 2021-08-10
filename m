Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C303E7EF9
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhHJRgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233394AbhHJRfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:35:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8707A610FC;
        Tue, 10 Aug 2021 17:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616895;
        bh=W8NlvFR/LFRA+J81U64OIbg5JgaHepadmXcuitAwP1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riKDwENFcc33BoPMpwjORvyoZXKxEiezb3qX/xgQ7UmGYmGxq/QbE4MspmGAHt81O
         KkY1tmaRygTxla9L83HlKmb5rDZaGMTFafxbHRtrs1/Aec6mxxTiG3cn8iNo6RU/NH
         wNQmRAmilrQSt8Guf9vI5sXJlP5zbHR0saNYv7eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Bauer <mail@david-bauer.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 39/85] USB: serial: ftdi_sio: add device ID for Auto-M3 OP-COM v2
Date:   Tue, 10 Aug 2021 19:30:12 +0200
Message-Id: <20210810172949.541477647@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
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
@@ -219,6 +219,7 @@ static const struct usb_device_id id_tab
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


