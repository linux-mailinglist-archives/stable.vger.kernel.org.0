Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2E6395B36
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhEaNSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231663AbhEaNST (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4AC36135D;
        Mon, 31 May 2021 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622466999;
        bh=MvJFFWkWQkinB1xG6V0udxxPs18hrtjOttKpB5EZfhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9IJZAk4efcwMRkj9crTlybrQUJ2VrYG186lDBBQpMgklCzmi72g66mVPFH4sReUp
         EsWfslroCcV08LGaM1sL+u8z0Dy1mIO5ySAi7EAYsh4zfOdzbJV+rJAv3ISr4wS3gv
         WOw+SM4M3N7zvF3pI62KRSqYgTQTNU64kQE5jeEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zolton Jheng <s6668c2t@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 18/54] USB: serial: pl2303: add device id for ADLINK ND-6530 GC
Date:   Mon, 31 May 2021 15:13:44 +0200
Message-Id: <20210531130635.668182895@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
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
@@ -102,6 +102,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
+	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530GC_PRODUCT_ID) },
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
 	{ }					/* Terminating entry */
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -156,6 +156,7 @@
 /* ADLINK ND-6530 RS232,RS485 and RS422 adapter */
 #define ADLINK_VENDOR_ID		0x0b63
 #define ADLINK_ND6530_PRODUCT_ID	0x6530
+#define ADLINK_ND6530GC_PRODUCT_ID	0x653a
 
 /* SMART USB Serial Adapter */
 #define SMART_VENDOR_ID	0x0b8c


