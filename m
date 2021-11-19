Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644E84575F7
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237193AbhKSRnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237169AbhKSRnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD8E360D42;
        Fri, 19 Nov 2021 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343615;
        bh=AuIBXc5BxpWl+fnhqHjF3InM7o4i6bi4iOOwByJNwB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SPSN2In9zEK/sc6BtiqzuNECgOnsqQEzHmXKBneDp5YFxNs4t06vPsepYjbChxyr
         wu2RNx4BuBkUXsy0yPIBPJg/P7d0sgJw66LAWEJjskyYE9lmUE5JQhJGHyUm6b3zKx
         8ZcfD8/3irC/G/kB49wChs95woo3efB+RJviET84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Flintham <nick@flinny.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Szabolcs Sipos <labuwx@balfug.com>
Subject: [PATCH 5.15 14/20] Bluetooth: btusb: Add support for TP-Link UB500 Adapter
Date:   Fri, 19 Nov 2021 18:39:32 +0100
Message-Id: <20211119171445.120450640@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Flintham <nick@flinny.org>

commit 4fd6d490796171bf786090fee782e252186632e4 upstream.

Add support for TP-Link UB500 Adapter (RTL8761B)

* /sys/kernel/debug/usb/devices
T:  Bus=01 Lev=02 Prnt=05 Port=01 Cnt=01 Dev#= 78 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2357 ProdID=0604 Rev= 2.00
S:  Manufacturer=
S:  Product=TP-Link UB500 Adapter
S:  SerialNumber=E848B8C82000
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Nicholas Flintham <nick@flinny.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Szabolcs Sipos <labuwx@balfug.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -433,6 +433,10 @@ static const struct usb_device_id blackl
 	{ USB_DEVICE(0x0bda, 0xb009), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
+	/* Additional Realtek 8761B Bluetooth devices */
+	{ USB_DEVICE(0x2357, 0x0604), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Additional Realtek 8761BU Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
 	  					     BTUSB_WIDEBAND_SPEECH },


