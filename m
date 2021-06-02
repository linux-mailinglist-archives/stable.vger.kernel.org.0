Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FE63993DD
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 21:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhFBTuv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 2 Jun 2021 15:50:51 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:45630 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhFBTuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 15:50:50 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id D4A83CED09;
        Wed,  2 Jun 2021 21:57:02 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH 2/2] Bluetooth: btusb: Add 0x0b05:0x190e Realtek 8761BU
 (ASUS BT500) device.
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210528152645.25577-2-joakim.tjernlund@infinera.com>
Date:   Wed, 2 Jun 2021 21:49:04 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A39E37D9-B579-4E78-BD88-7DED43DECD48@holtmann.org>
References: <20210528152645.25577-1-joakim.tjernlund@infinera.com>
 <20210528152645.25577-2-joakim.tjernlund@infinera.com>
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joakim,

> T:  Bus=01 Lev=01 Prnt=01 Port=08 Cnt=04 Dev#= 18 Spd=12   MxCh= 0
> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0b05 ProdID=190e Rev= 2.00
> S:  Manufacturer=Realtek
> S:  Product=ASUS USB-BT500
> S:  SerialNumber=xxxxxxxx
> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
> ---
> drivers/bluetooth/btusb.c | 4 ++++
> 1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 5d603ef39bad..628f4b22cf69 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -425,6 +425,10 @@ static const struct usb_device_id blacklist_table[] = {
> 	{ USB_DEVICE(0x0bda, 0xb009), .driver_info = BTUSB_REALTEK },
> 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
> 
> +	/* Additional Realtek 8761BU Bluetooth devices */
> +	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
> +	  					     BTUSB_WIDEBAND_SPEECH },
> +

Applying: Bluetooth: btusb: Add 0x0b05:0x190e Realtek 8761BU (ASUS BT500) device.
.git/rebase-apply/patch:15: space before tab in indent.
	  					     BTUSB_WIDEBAND_SPEECH },
warning: 1 line adds whitespace errors.

Regards

Marcel

