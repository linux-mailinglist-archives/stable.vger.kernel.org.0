Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FA529013E
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405957AbgJPJMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405908AbgJPJL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:11:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C700820878;
        Fri, 16 Oct 2020 09:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839518;
        bh=mDsTZngoKU1DWpBnYJSvmbvvyuC+RL4EPG+7t4lNKZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JD/iKehM9IUevhKt4qK0Rh3UyVHhKioRoRMQJEgmXBBWEabwy0CuULuBO5cLwXkMv
         cBasbMdm+DsgpaagAaRw/NGjEtxLxHDXbCbF1oytNFONPGfkAiGq3a4pFP6ytQpzvH
         OUFIRWvta07K8wtdW5lAtd5vmAIVW24x9wmuMHjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonid Bloch <lb.workbox@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.9 06/15] USB: serial: option: Add Telit FT980-KS composition
Date:   Fri, 16 Oct 2020 11:08:08 +0200
Message-Id: <20201016090437.489002612@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.170032996@linuxfoundation.org>
References: <20201016090437.170032996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonid Bloch <lb.workbox@gmail.com>

commit 924a9213358fb92fa3c3225d6d042aa058167405 upstream.

This commit adds the following Telit FT980-KS composition:

0x1054: rndis, diag, adb, nmea, modem, modem, aux

AT commands can be sent to /dev/ttyUSB2.

Signed-off-by: Leonid Bloch <lb.workbox@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/ce86bc05-f4e2-b199-0cdc-792715e3f275@asocscloud.com
Link: https://lore.kernel.org/r/20201004155813.2342-1-lb.workbox@gmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1187,6 +1187,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1053, 0xff),	/* Telit FN980 (ECM) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1054, 0xff),	/* Telit FT980-KS */
+	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),


