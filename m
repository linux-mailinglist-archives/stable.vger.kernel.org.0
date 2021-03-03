Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1667432C846
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379250AbhCDAfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhCCX7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 18:59:08 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C0EC0613A8;
        Wed,  3 Mar 2021 15:58:27 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id m22so40108481lfg.5;
        Wed, 03 Mar 2021 15:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=hdTWvRh7b3hKKxtSTfWpHEJcblQsDd2gyrIh3tHUrEk=;
        b=huVB8A7VQU0Ewn3RxEqOe6egDytwP+Tuohcg0Cs06bAnW+uOnLzkEtvgZY5sPa/lrG
         FM/93nbivPkcKHWFFiGokoxLMnpf6NHAp/wxGjhHnxJGeOqtgL8MyAFmBLwOmBG2LCJC
         SiGucqBLb681G1Y/tmHvJqPqZ/Z2x58/yZ+gNS//9h5CQ9WeMc3Yp4M2ViWTgq5UUNun
         Am3pAmWFkwiJxKgrzowDJ3C4/PRGYPThTaptivNp+Ca8bgmr0QWv1CWyjt/WBrUYMAYT
         q5pWMq15cpsgJk8XvF/7h+Td0peQ7bGa0rb/Hm1yWnfynn8fhbGsEwDvuxowQkGeOe4+
         b53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hdTWvRh7b3hKKxtSTfWpHEJcblQsDd2gyrIh3tHUrEk=;
        b=diiXnPQBvHC5AeK017po7re1xFLT/OfbKKAAohmw/XtzN4/X3LE9o2Iskf4wX/h5OQ
         D4bj0L/aiG7RZrobYX4XDR4ygh5J2KpgrIgs7yaREyx/U2MSsn6lKIUFCrv0UvSm7KJn
         O0zab3C1ZCsfWRwY7nrIERFAoWLaeYeR2Bob+FQUZ9JVe5V32vJCcsEcPsf9IH6bAp3x
         TkA78HN8HV+OnGTbOXerJ4Rgu29wp4X5mn3Q0VEi8XL4/9FZSipirMZhpDMVGXQ7otpq
         JJEUMsUCWrESAOI8hnLne+5eHLKKilmLDHL7GNiLcq4kUhXgmElJF50yyS2oLHnH+fPz
         zgNg==
X-Gm-Message-State: AOAM530U059QaRD+urZ4fzR4GJWp4pu+l/mNEnysosKRwmaLVhFy4Ydv
        W2Ue5jowaR8Xx2rnIG/W2+4=
X-Google-Smtp-Source: ABdhPJyR9XZxXGpXpsdEYObnmX9eLW8vygVnNyvLuXFoop85+BQoGmV6eDpFGAVvzQxBlZMf8TWa9A==
X-Received: by 2002:a19:44:: with SMTP id 65mr709073lfa.104.1614815906100;
        Wed, 03 Mar 2021 15:58:26 -0800 (PST)
Received: from [10.0.0.11] (user-5-173-242-247.play-internet.pl. [5.173.242.247])
        by smtp.googlemail.com with ESMTPSA id q3sm1752386lfr.33.2021.03.03.15.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Mar 2021 15:58:25 -0800 (PST)
Subject: Re: [PATCH 5.10 491/663] USB: serial: option: update interface
 mapping for ZTE P685M
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
References: <20210301161141.760350206@linuxfoundation.org>
 <20210301161206.139213430@linuxfoundation.org>
From:   Lech Perczak <lech.perczak@gmail.com>
Message-ID: <07edca19-417d-4dab-adeb-cae7b2b17708@gmail.com>
Date:   Thu, 4 Mar 2021 00:58:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301161206.139213430@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2021-03-01 at 17:12, Greg Kroah-Hartman wrote:
> From: Lech Perczak <lech.perczak@gmail.com>
>
> commit 6420a569504e212d618d4a4736e2c59ed80a8478 upstream.
>
> This patch prepares for qmi_wwan driver support for the device.
> Previously "option" driver mapped itself to interfaces 0 and 3 (matching
> ff/ff/ff), while interface 3 is in fact a QMI port.
> Interfaces 1 and 2 (matching ff/00/00) expose AT commands,
> and weren't supported previously at all.
> Without this patch, a possible conflict would exist if device ID was
> added to qmi_wwan driver for interface 3.
>
> Update and simplify device ID to match interfaces 0-2 directly,
> to expose QCDM (0), PCUI (1), and modem (2) ports and avoid conflict
> with QMI (3), and ADB (4).
>
> The modem is used inside ZTE MF283+ router and carriers identify it as
> such.
> Interface mapping is:
> 0: QCDM, 1: AT (PCUI), 2: AT (Modem), 3: QMI, 4: ADB
>
> T:  Bus=02 Lev=02 Prnt=02 Port=05 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
> D:  Ver= 2.01 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=19d2 ProdID=1275 Rev=f0.00
> S:  Manufacturer=ZTE,Incorporated
> S:  Product=ZTE Technologies MSM
> S:  SerialNumber=P685M510ZTED0000CP&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&0
> C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> E:  Ad=87(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
> E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
> E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
> Link: https://lore.kernel.org/r/20210207005443.12936-1-lech.perczak@gmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/usb/serial/option.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -1569,7 +1569,8 @@ static const struct usb_device_id option
>   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1272, 0xff, 0xff, 0xff) },
>   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1273, 0xff, 0xff, 0xff) },
>   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1274, 0xff, 0xff, 0xff) },
> -	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1275, 0xff, 0xff, 0xff) },
> +	{ USB_DEVICE(ZTE_VENDOR_ID, 0x1275),	/* ZTE P685M */
> +	  .driver_info = RSVD(3) | RSVD(4) },
>   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1276, 0xff, 0xff, 0xff) },
>   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1277, 0xff, 0xff, 0xff) },
>   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1278, 0xff, 0xff, 0xff) },
>
>
If this patch is selected, then 88eee9b7b42e69fb622ddb3ff6f37e8e4347f5b2 
("net: usb: qmi_wwan: support ZTE P685M modem")
probably should be selected, too. This patch frees up an interface to be 
claimed by qmi_wwan driver by the mentioned patch.
The mentioned patch only adds a device ID to qmi_wwan driver.

In my opinion, those two should come in pair. Regarding version, I think 
that backporting to 5.4.y and later is enough, as OpenWrt,
from which those patches originate is currently on 5.4.y on the target 
requiring it, and will move to 5.10.y soon.
Backporting this would certainly make OpenWrt folks happy, however I 
don't insist on it.

-- 
With kind regards,
Lech Perczak

