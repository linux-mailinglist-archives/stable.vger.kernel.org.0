Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD77395BAD
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhEaNXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231663AbhEaNVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD90B613CB;
        Mon, 31 May 2021 13:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467149;
        bh=lt7IgVqniB7ZiD/JA5DsU0X9tS2/T41Pz6ywahkI++M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T23hw/KCWISS5cjFgIOUPkI9fyH2Ch4IPlA1Hgumjdj8iwtMXPtSEWMjFlPg1v2Ed
         IHjvMHywD2oTYGUCWTw4GBErmK68cmBEode0P8o+ZvnkMA8CdIuog1d/qCzVsmSEiK
         3JF+uFGH75Gkkxv1i/LARrxPTQ8hB4KTMVgOhQL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean MacLennan <seanm@seanm.ca>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 22/66] USB: serial: ti_usb_3410_5052: add startech.com device id
Date:   Mon, 31 May 2021 15:13:55 +0200
Message-Id: <20210531130636.963566694@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean MacLennan <seanm@seanm.ca>

commit 89b1a3d811e6f8065d6ae8a25e7682329b4a31e2 upstream.

This adds support for the Startech.com generic serial to USB converter.
It seems to be a bone stock TI_3410. I have been using this patch for
years.

Signed-off-by: Sean MacLennan <seanm@seanm.ca>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ti_usb_3410_5052.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -41,6 +41,7 @@
 /* Vendor and product ids */
 #define TI_VENDOR_ID			0x0451
 #define IBM_VENDOR_ID			0x04b3
+#define STARTECH_VENDOR_ID		0x14b0
 #define TI_3410_PRODUCT_ID		0x3410
 #define IBM_4543_PRODUCT_ID		0x4543
 #define IBM_454B_PRODUCT_ID		0x454b
@@ -378,6 +379,7 @@ static const struct usb_device_id ti_id_
 	{ USB_DEVICE(MXU1_VENDOR_ID, MXU1_1131_PRODUCT_ID) },
 	{ USB_DEVICE(MXU1_VENDOR_ID, MXU1_1150_PRODUCT_ID) },
 	{ USB_DEVICE(MXU1_VENDOR_ID, MXU1_1151_PRODUCT_ID) },
+	{ USB_DEVICE(STARTECH_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ }	/* terminator */
 };
 
@@ -416,6 +418,7 @@ static const struct usb_device_id ti_id_
 	{ USB_DEVICE(MXU1_VENDOR_ID, MXU1_1131_PRODUCT_ID) },
 	{ USB_DEVICE(MXU1_VENDOR_ID, MXU1_1150_PRODUCT_ID) },
 	{ USB_DEVICE(MXU1_VENDOR_ID, MXU1_1151_PRODUCT_ID) },
+	{ USB_DEVICE(STARTECH_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ }	/* terminator */
 };
 


