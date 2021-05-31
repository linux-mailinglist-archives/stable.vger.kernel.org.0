Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74BB3961C7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhEaOp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233223AbhEaOni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:43:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74E1A61923;
        Mon, 31 May 2021 13:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469274;
        bh=S78sY9r90rEsJwTbMjaIObNTqewgKcIdJn/MlXV7X9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBAAFcXC9r0mHEl6D9mwDjJ1WP4cmy+3U2jHFJ3c6wN3NkHjpxxZaTTfxKMlNkhrI
         0eZf7EEmUS2t3P17dbK8fo6hArKc+2j4CRpWzbfei3DacpxkqU2SvZnkH4WMi+8jZ5
         Nj+YOfqRN9JxWHjo363nOIRvmGCt82IuOc4xLjNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zolton Jheng <s6668c2t@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.12 101/296] USB: serial: pl2303: add device id for ADLINK ND-6530 GC
Date:   Mon, 31 May 2021 15:12:36 +0200
Message-Id: <20210531130707.318860809@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
@@ -113,6 +113,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
+	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530GC_PRODUCT_ID) },
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
 	{ }					/* Terminating entry */
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -158,6 +158,7 @@
 /* ADLINK ND-6530 RS232,RS485 and RS422 adapter */
 #define ADLINK_VENDOR_ID		0x0b63
 #define ADLINK_ND6530_PRODUCT_ID	0x6530
+#define ADLINK_ND6530GC_PRODUCT_ID	0x653a
 
 /* SMART USB Serial Adapter */
 #define SMART_VENDOR_ID	0x0b8c


