Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206C2FB495
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 17:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfKMQDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 11:03:33 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33254 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfKMQDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 11:03:33 -0500
Received: by mail-lf1-f67.google.com with SMTP id d6so2426286lfc.0;
        Wed, 13 Nov 2019 08:03:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Gfy5KxCnLCEyuV8EWhYYDNn9loPT0q/WSL5LOF/F6ic=;
        b=mqRqgdVR7v2n6dUoIUcPvwZADZ2CucJLNqO1GTFwDsQ+WEZWUXtq3LBrgXCiwujSmx
         PXH+xr0G1tKCb7kkhb3eHhtVf8oj1rHwNSmmaD2pgPLD8qNDb2yfjiLqvb20V3EkCV5X
         HFoPnRPS+wPGDLMHOzvujuyyNYa/lpUVHDUq0snQqS7gX/D+ryzWNYiGgKGPc5DggNUN
         Cwm2GLfvwmfwvlbTp4ShGofImJNAhV+k7D+ZaurhvG1E/tN5IugAtmxX7bTykVKQpwfH
         BXxuDgHIIFjFsWqcj5MaAB3VE57cojOdj4ckG0WlZf6fAka95mTTfidNsfwHFMQlwFcP
         P0ug==
X-Gm-Message-State: APjAAAW+LaLswR0GiGhadFZv7P83jRkY81mBrwen9KgLApD6DFwdMODC
        97dPPDrg/oEDVcxT3osAhMA=
X-Google-Smtp-Source: APXvYqxmMrumdAtvQO7iALK86Izaa9ATYjWqG1jIuSuPXuai5OKfFaUN4JUcdm3x7N9qr3tCgNIwog==
X-Received: by 2002:ac2:5503:: with SMTP id j3mr1985425lfk.8.1573661011352;
        Wed, 13 Nov 2019 08:03:31 -0800 (PST)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id t16sm1082094ljc.106.2019.11.13.08.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 08:03:30 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iUv7L-0000BG-Dd; Wed, 13 Nov 2019 17:03:39 +0100
Date:   Wed, 13 Nov 2019 17:03:39 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     johan@kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: option: add support for Foxconn T77W968 LTE
 modules
Message-ID: <20191113160339.GX11035@localhost>
References: <20191113101405.496557-1-aleksander@aleksander.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113101405.496557-1-aleksander@aleksander.es>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 11:14:05AM +0100, Aleksander Morgado wrote:
> These are the Foxconn-branded variants of the Dell DW5821e modules,
> same USB layout as those. The device exposes AT, NMEA and DIAG ports
> in both USB configurations.
> 
> P:  Vendor=0489 ProdID=e0b4 Rev=03.18
> S:  Manufacturer=FII
> S:  Product=T77W968 LTE
> S:  SerialNumber=0123456789ABCDEF
> C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> 
> P:  Vendor=0489 ProdID=e0b4 Rev=03.18
> S:  Manufacturer=FII
> S:  Product=T77W968 LTE
> S:  SerialNumber=0123456789ABCDEF
> C:  #Ifs= 7 Cfg#= 2 Atr=a0 MxPwr=500mA
> I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
> I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> I:  If#=0x6 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> 
> Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
> ---
>  drivers/usb/serial/option.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index 2023f1f4edaf..787f004f24fc 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -555,6 +555,11 @@ static void option_instat_callback(struct urb *urb);
>  #define WETELECOM_PRODUCT_6802			0x6802
>  #define WETELECOM_PRODUCT_WMD300		0x6803
>  
> +/* Foxconn products */
> +#define FOXCONN_VENDOR_ID			0x0489
> +#define FOXCONN_PRODUCT_T77W968			0xe0b4
> +#define FOXCONN_PRODUCT_T77W968_ESIM		0xe0b5
> +

I dropped these new defines in favour of using numerical constants
before applying:

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 2023f1f4edaf..e9491d400a24 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1993,6 +1993,10 @@ static const struct usb_device_id option_ids[] = {
        { USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0xa31d, 0xff, 0x06, 0x13) },
        { USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0xa31d, 0xff, 0x06, 0x14) },
        { USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0xa31d, 0xff, 0x06, 0x1b) },
+       { USB_DEVICE(0x0489, 0xe0b4),                                           /* Foxconn T77W968 */
+         .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
+       { USB_DEVICE(0x0489, 0xe0b5),                                           /* Foxconn T77W968 ESIM */
+         .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
        { USB_DEVICE(0x1508, 0x1001),                                           /* Fibocom NL668 */
          .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
        { USB_DEVICE(0x2cb7, 0x0104),                                           /* Fibocom NL678 series */

>  /* Device flags */
>  
> @@ -1999,6 +2004,10 @@ static const struct usb_device_id option_ids[] = {
>  	  .driver_info = RSVD(4) | RSVD(5) },
>  	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0105, 0xff),			/* Fibocom NL678 series */
>  	  .driver_info = RSVD(6) },
> +	{ USB_DEVICE(FOXCONN_VENDOR_ID, FOXCONN_PRODUCT_T77W968),
> +	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
> +	{ USB_DEVICE(FOXCONN_VENDOR_ID, FOXCONN_PRODUCT_T77W968_ESIM),
> +	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
>  	{ } /* Terminating entry */
>  };
>  MODULE_DEVICE_TABLE(usb, option_ids);

I'm trying to avoid adding new defines, but sometimes make exceptions
when when we already have related entries in place.

Thanks,
Johan
