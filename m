Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D641A395BB0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhEaNXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231845AbhEaNVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:21:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34D51613DB;
        Mon, 31 May 2021 13:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467151;
        bh=0a4NtUaRwsttjvtiHpSuUZHtN0o8mYZWa44xbUKnBbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYZiOmaeY1jqoI6v3QjrBWqZw3YEaHzIStlwnrAlxxVTTy9c0pcmrd9xWphd7FzfK
         FUHtuvdevo3OzO0sIRhXT3s2h11HVXalqySGTlUld+kTWeAUQOPWAcaRSHO0lMS0AG
         pcDyZ5Z82q4bpOQcEbZSnyTcgrYlLlGghQSYzgGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 23/66] USB: serial: option: add Telit LE910-S1 compositions 0x7010, 0x7011
Date:   Mon, 31 May 2021 15:13:56 +0200
Message-Id: <20210531130636.995535329@linuxfoundation.org>
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

From: Daniele Palmas <dnlplm@gmail.com>

commit e467714f822b5d167a7fb03d34af91b5b6af1827 upstream.

Add support for the following Telit LE910-S1 compositions:

0x7010: rndis, tty, tty, tty
0x7011: ecm, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20210428072634.5091-1-dnlplm@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1222,6 +1222,10 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1901, 0xff),	/* Telit LN940 (MBIM) */
 	  .driver_info = NCTRL(0) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x7010, 0xff),	/* Telit LE910-S1 (RNDIS) */
+	  .driver_info = NCTRL(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x7011, 0xff),	/* Telit LE910-S1 (ECM) */
+	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9010),				/* Telit SBL FN980 flashing device */
 	  .driver_info = NCTRL(0) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */


