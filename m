Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2918493AE
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbfFQV0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730279AbfFQV0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:26:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E05B20657;
        Mon, 17 Jun 2019 21:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806807;
        bh=dFEDfaVOXr8xrEKzzjhSMrHtue7lma0PXPH0Q/4AO0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGnmwWvnyzlxz/dSwUPRkDbg+9RCM9SsXKEdPt4gIAx+fNgBVFFFto3Q1fVISIU87
         Mhu4QUdJlDg89Z9v0FqG6tWIV5+YZk7h8MT9DqnNrFCxzXDeQPU8UtbhG0uXqQIVrq
         aH2p4zWxQ1ZMT7FNeFupcia1Q9q2XSA6ZcHc4HQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 63/75] USB: serial: pl2303: add Allied Telesis VT-Kit3
Date:   Mon, 17 Jun 2019 23:10:14 +0200
Message-Id: <20190617210755.465974328@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit c5f81656a18b271976a86724dadd8344e54de74e upstream.

This is adds the vendor and device id for the AT-VT-Kit3 which is a
pl2303-based device.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -106,6 +106,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
+	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -155,3 +155,6 @@
 #define SMART_VENDOR_ID	0x0b8c
 #define SMART_PRODUCT_ID	0x2303
 
+/* Allied Telesis VT-Kit3 */
+#define AT_VENDOR_ID		0x0caa
+#define AT_VTKIT3_PRODUCT_ID	0x3001


