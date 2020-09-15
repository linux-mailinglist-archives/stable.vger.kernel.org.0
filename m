Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBDE26B3B3
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgIOXIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbgIOOlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:41:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A04922A84;
        Tue, 15 Sep 2020 14:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180249;
        bh=1rVkQ9IRxVFbUdo4qHBHQF0nDwWSpsuccmYngrS+Pgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBuiFZoXr0fbA8tZjMZL3EZqEmcceCdp/89qjMyEqoTYVSRfRfV83nS7CO+0yGwjD
         jLgaSErFZhVbRF2bKsp8J00iU6y7rVpFQwmexp0KT/UbmvvyBZuWuOa66OEM8DjPol
         dEzR2VpPHCzr/1POtERZg1F0Ki/TuCC2/cPJdeMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Patrick Riphagen <patrick.riphagen@xsens.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.8 168/177] USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter
Date:   Tue, 15 Sep 2020 16:13:59 +0200
Message-Id: <20200915140701.750987366@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Riphagen <patrick.riphagen@xsens.com>

commit 6ccc48e0eb2f3a5f3bd39954a21317e5f8874726 upstream.

The device added has an FTDI chip inside.
The device is used to connect Xsens USB Motion Trackers.

Cc: stable@vger.kernel.org
Signed-off-by: Patrick Riphagen <patrick.riphagen@xsens.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -713,6 +713,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_STATION_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_MTDEVBOARD_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_MTIUSBCONVERTER_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
 	{ USB_DEVICE(MOBILITY_VID, MOBILITY_USB_SERIAL_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -160,6 +160,7 @@
 #define XSENS_AWINDA_DONGLE_PID 0x0102
 #define XSENS_MTW_PID		0x0200	/* Xsens MTw */
 #define XSENS_MTDEVBOARD_PID	0x0300	/* Motion Tracker Development Board */
+#define XSENS_MTIUSBCONVERTER_PID	0x0301	/* MTi USB converter */
 #define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
 
 /* Xsens devices using FTDI VID */


