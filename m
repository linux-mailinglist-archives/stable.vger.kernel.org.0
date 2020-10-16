Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5BD2900F2
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405680AbgJPJK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405646AbgJPJKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:10:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50DBA221EB;
        Fri, 16 Oct 2020 09:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839414;
        bh=obyLQJCiuYh2+g3sEuPUK8kVPiLROvGfjXLrWojQ0KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOthrVzY/JZgZ/FM/U4W95ODTng510rF+I9xQ185H2Yq+0yRbtJCZxaPYvPnYLYZ8
         31svMIcUmfVJNHuGeCCx/M71s/fyrs4UrX6BP0noknRHJZLZX5ll2jZGHRHgsHCyb8
         tMx3KzGfUTldsHktK+eXVj8bLof7Cxs+aOhNDo1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Chen <scott@labau.com.tw>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 16/22] USB: serial: pl2303: add device-id for HP GC device
Date:   Fri, 16 Oct 2020 11:07:44 +0200
Message-Id: <20201016090438.111003385@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
References: <20201016090437.308349327@linuxfoundation.org>
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


