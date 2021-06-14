Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6249C3A6074
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhFNKeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233188AbhFNKdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:33:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A682611CA;
        Mon, 14 Jun 2021 10:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666666;
        bh=eds8IOZtnGhaffiJTb92aYTjf9GAJf65MJFEnvDn35c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p52qRJfstU7B4Cj/qlO3E+SyPNHB3O62SU5C3tDhA3zPdulrEZWdejQ0FUKG4Rs+k
         k8//GZzWDA+UViAhly7cacUKr4zhdTkn+xGcmBeGDpiUs1Qa5Dg6tugSnehlXDC0a3
         1vbVNVvHvkDMz+iTSv1QGgDylNjd6Fp9AJ3IlGng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 27/42] USB: serial: ftdi_sio: add NovaTech OrionMX product ID
Date:   Mon, 14 Jun 2021 12:27:18 +0200
Message-Id: <20210614102643.569927932@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
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
@@ -606,6 +606,7 @@ static const struct usb_device_id id_tab
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONLX_PLUS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORION_IO_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONMX_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SYNAPSE_SS200_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CUSTOMWARE_MINIPLEX_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CUSTOMWARE_MINIPLEX2_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -580,6 +580,7 @@
 #define FTDI_NT_ORIONLXM_PID		0x7c90	/* OrionLXm Substation Automation Platform */
 #define FTDI_NT_ORIONLX_PLUS_PID	0x7c91	/* OrionLX+ Substation Automation Platform */
 #define FTDI_NT_ORION_IO_PID		0x7c92	/* Orion I/O */
+#define FTDI_NT_ORIONMX_PID		0x7c93	/* OrionMX */
 
 /*
  * Synapse Wireless product ids (FTDI_VID)


