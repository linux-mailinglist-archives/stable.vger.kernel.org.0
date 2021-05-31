Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F151395BB2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhEaNXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231949AbhEaNVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 886D7613D7;
        Mon, 31 May 2021 13:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467157;
        bh=MvJFFWkWQkinB1xG6V0udxxPs18hrtjOttKpB5EZfhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIwOxwsuiC+ln6bHp182wpIsZLAks1G4b8r+pgLJrt9Mhist891kTxbJeN5KseD9Y
         EwXgZm7CE6DO0yh6Gie/BXG5fntKQ1YvyTW1vZ/Oxj8U/J1WizommWmgjbvfhS7Sfl
         PkutjRtqMk0Pr83nmrpiU5ebcVAR/AUih9jMBO0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zolton Jheng <s6668c2t@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 25/66] USB: serial: pl2303: add device id for ADLINK ND-6530 GC
Date:   Mon, 31 May 2021 15:13:58 +0200
Message-Id: <20210531130637.066095345@linuxfoundation.org>
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


