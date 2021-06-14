Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D413A6210
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhFNKz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234530AbhFNKw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:52:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1737613DE;
        Mon, 14 Jun 2021 10:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667178;
        bh=VFaFoZI8Jf3hiK1LJWeiBM4kXUVgxHwhSn6DJcGEqJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsPTXem1WWhVHXMG7pcdqQvQRh79ceipsftxyZs9sItSFlou1rrp8Rkqj03CckLtu
         TIhAvg1zHC/sMJrlpn1kMGEqhldnwcdmtzTTzB2lVjDv/ZorMGTPhpVhQt5C7uX35T
         pW8WIhXgLue6BT8sRsqwv43tRii3J4ZtcpkWVd0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 55/84] USB: serial: ftdi_sio: add NovaTech OrionMX product ID
Date:   Mon, 14 Jun 2021 12:27:33 +0200
Message-Id: <20210614102648.241902030@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>

commit bc96c72df33ee81b24d87eab953c73f7bcc04f29 upstream.

Add PID for the NovaTech OrionMX so it can be automatically detected.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -611,6 +611,7 @@ static const struct usb_device_id id_tab
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONLX_PLUS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORION_IO_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONMX_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SYNAPSE_SS200_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CUSTOMWARE_MINIPLEX_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CUSTOMWARE_MINIPLEX2_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -581,6 +581,7 @@
 #define FTDI_NT_ORIONLXM_PID		0x7c90	/* OrionLXm Substation Automation Platform */
 #define FTDI_NT_ORIONLX_PLUS_PID	0x7c91	/* OrionLX+ Substation Automation Platform */
 #define FTDI_NT_ORION_IO_PID		0x7c92	/* Orion I/O */
+#define FTDI_NT_ORIONMX_PID		0x7c93	/* OrionMX */
 
 /*
  * Synapse Wireless product ids (FTDI_VID)


