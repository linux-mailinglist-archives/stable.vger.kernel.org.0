Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCA5290177
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405619AbgJPJOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405569AbgJPJJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A94E20FC3;
        Fri, 16 Oct 2020 09:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839376;
        bh=obyLQJCiuYh2+g3sEuPUK8kVPiLROvGfjXLrWojQ0KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qU7HzFK5i2Y7d/Wyn1qKG8/H5sdBrBhv6y/QA/ry0FKgvRXCzq/WC/3aikoafONnp
         +raqjRAKMIbbSPCSo19O00EVNXW3nlzGsid1L5I0xPRlW0f06zE7gGqiVjNL3zx/0A
         Kz5jj7Lzz+SO6VnrlBZ+f83R08L0ESVO6r2IyqDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Chen <scott@labau.com.tw>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 15/21] USB: serial: pl2303: add device-id for HP GC device
Date:   Fri, 16 Oct 2020 11:07:34 +0200
Message-Id: <20201016090438.037269073@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.301376476@linuxfoundation.org>
References: <20201016090437.301376476@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Chen <scott@labau.com.tw>

commit 031f9664f8f9356cee662335bc56c93d16e75665 upstream.

This is adds a device id for HP LD381 which is a pl2303GC-base device.

Signed-off-by: Scott Chen <scott@labau.com.tw>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -94,6 +94,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220TA_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD381_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LD381GC_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD960_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD960TA_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM220_PRODUCT_ID) },
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -121,6 +121,7 @@
 
 /* Hewlett-Packard POS Pole Displays */
 #define HP_VENDOR_ID		0x03f0
+#define HP_LD381GC_PRODUCT_ID	0x0183
 #define HP_LM920_PRODUCT_ID	0x026b
 #define HP_TD620_PRODUCT_ID	0x0956
 #define HP_LD960_PRODUCT_ID	0x0b39


