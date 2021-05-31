Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE41139600C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhEaOW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232850AbhEaORF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:17:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A13DA613D7;
        Mon, 31 May 2021 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468614;
        bh=G9Djgm5+D9+1oVWiiL+Z96/5chrPLDcwDNTHkHXHhyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4Hi8rmtI+WuVX8xB9S2I4fC+fpxj3LCrv3mUMbwCR1ap1BBNYcxTb3VPbi8VIMmZ
         SoTDFwQk9wqzjpu4P1u2zLwfe7Xx37qZfyJAC73MR+cox4Gjbf7tz2emum7s5P/dR8
         xsa8g6DRS20UVvxeuPACnM5tSWDu3baOGcsK8fO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zolton Jheng <s6668c2t@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 059/177] USB: serial: pl2303: add device id for ADLINK ND-6530 GC
Date:   Mon, 31 May 2021 15:13:36 +0200
Message-Id: <20210531130649.954228936@linuxfoundation.org>
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

From: Zolton Jheng <s6668c2t@gmail.com>

commit f8e8c1b2f782e7391e8a1c25648ce756e2a7d481 upstream.

This adds the device id for the ADLINK ND-6530 which is a PL2303GC based
device.

Signed-off-by: Zolton Jheng <s6668c2t@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -107,6 +107,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
+	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530GC_PRODUCT_ID) },
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
 	{ }					/* Terminating entry */
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -152,6 +152,7 @@
 /* ADLINK ND-6530 RS232,RS485 and RS422 adapter */
 #define ADLINK_VENDOR_ID		0x0b63
 #define ADLINK_ND6530_PRODUCT_ID	0x6530
+#define ADLINK_ND6530GC_PRODUCT_ID	0x653a
 
 /* SMART USB Serial Adapter */
 #define SMART_VENDOR_ID	0x0b8c


