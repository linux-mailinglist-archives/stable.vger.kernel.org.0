Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1472900E2
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405602AbgJPJJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394672AbgJPJJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8092220789;
        Fri, 16 Oct 2020 09:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839394;
        bh=mDsTZngoKU1DWpBnYJSvmbvvyuC+RL4EPG+7t4lNKZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0CLvbvOyz6n+hzSyJTS3bMtCHLQ/cSxAmU/qaSuU4YKD5rapXuqgx7li/dPaIjhd
         SaImhNDSyENY7yv7+D97CrdosU8dOOP+8pGuf0ioNT6PqjL8dnJFU+8Hbau+k9aNbh
         51+foGiA6xDGzMUHGxph57AHF7GOuJzLGjcRXnm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonid Bloch <lb.workbox@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 13/21] USB: serial: option: Add Telit FT980-KS composition
Date:   Fri, 16 Oct 2020 11:07:32 +0200
Message-Id: <20201016090437.954354981@linuxfoundation.org>
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


