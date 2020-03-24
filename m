Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC431910E9
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCXNcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgCXNSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:18:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79C4E208CA;
        Tue, 24 Mar 2020 13:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055917;
        bh=/yUkgZdWto5X5Jvg8caTaNLBPOv3Z7TfKUnt0YercZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSwXuNxyNTPaEw5gZk0lsbSPTzqQvATE6c+Qhuw2naJdrqHFHqMl091z4p6KJ6RDJ
         EYSnQenN55QRLrP9v5h3DwA8jb4AAqa6/qu6jDnVfTD2Gtan76cW0f6+xAjPgdFMLz
         GrmCyyJzXL2Y2ikBCdJ4a1PRSiViwuBfbjK/ccFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Chen <scott@labau.com.tw>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 041/102] USB: serial: pl2303: add device-id for HP LD381
Date:   Tue, 24 Mar 2020 14:10:33 +0100
Message-Id: <20200324130810.893677411@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Chen <scott@labau.com.tw>

commit cecc113c1af0dd41ccf265c1fdb84dbd05e63423 upstream.

Add a device id for HP LD381 Display
LD381:   03f0:0f7f

Signed-off-by: Scott Chen <scott@labau.com.tw>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -93,6 +93,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SUPERIAL_VENDOR_ID, SUPERIAL_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220TA_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LD381_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD960_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD960TA_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM220_PRODUCT_ID) },
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -124,6 +124,7 @@
 #define HP_LM920_PRODUCT_ID	0x026b
 #define HP_TD620_PRODUCT_ID	0x0956
 #define HP_LD960_PRODUCT_ID	0x0b39
+#define HP_LD381_PRODUCT_ID	0x0f7f
 #define HP_LCM220_PRODUCT_ID	0x3139
 #define HP_LCM960_PRODUCT_ID	0x3239
 #define HP_LD220_PRODUCT_ID	0x3524


