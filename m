Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33C8394545
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 17:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbhE1Plu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 11:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235849AbhE1Plu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 11:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEDB56139A;
        Fri, 28 May 2021 15:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622216415;
        bh=ueO2P1BtGwHg2H4Wraddjzj5qun7keBq3GfXopr7rdQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=155cA35jwxgrxjSwxWQUP+DMvf8X5Q1DeOPMlrnAOGFsSa/2aQvQcxVKz9z/V7mna
         4DKvM92iwaY70U32o512a4UgicHQ1ixzlEOsBiczBUJNWULd1bjqICnYKqr5OEhShY
         l8djGsCO/F+pEajhXi3jMyyVzbgpmRG7B8UXeYhk=
Date:   Fri, 28 May 2021 17:40:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc:     linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] Bluetooth: btusb: Add 0x0b05:0x190e Realtek 8761BU
 (ASUS BT500) device.
Message-ID: <YLEO3THmResvvo2F@kroah.com>
References: <20210528152645.25577-1-joakim.tjernlund@infinera.com>
 <20210528152645.25577-2-joakim.tjernlund@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528152645.25577-2-joakim.tjernlund@infinera.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 28, 2021 at 05:26:45PM +0200, Joakim Tjernlund wrote:
> From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
> 
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
>  drivers/bluetooth/btusb.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 5d603ef39bad..628f4b22cf69 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -425,6 +425,10 @@ static const struct usb_device_id blacklist_table[] = {
>  	{ USB_DEVICE(0x0bda, 0xb009), .driver_info = BTUSB_REALTEK },
>  	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
>  
> +	/* Additional Realtek 8761BU Bluetooth devices */
> +	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
> +	  					     BTUSB_WIDEBAND_SPEECH },
> +
>  	/* Additional Realtek 8821AE Bluetooth devices */
>  	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
>  	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },
> -- 
> 2.31.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
