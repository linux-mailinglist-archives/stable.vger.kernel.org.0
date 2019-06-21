Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9F74E3D9
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 11:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfFUJjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 05:39:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51342 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfFUJjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 05:39:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so5727642wma.1
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 02:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tCSZObn4a/YkM2JAH2j+KdG48+wzGYYqeP2XgZ3tMeY=;
        b=MMZqON8CNj4GiImlQOmlemxOApWK1nsOWrxXxLlGk5LpQK8T7mLaiGdK7EJRljj7Ll
         toYbsBpsU6cAkvm9ZW8HNbkaKS5O5cXdO5F4hozKS5r+4wl7JRM8EEuLR3tcoa2PRIA9
         aU5HX1Aos2ijIUAenZdYt9D05JN0b6w/EnLayoZieRc4DMJMsjKFDEtYlTG/pBSqyxy7
         y11RzBb6OhiWUqtwY7WpJnYjMejiJWj0SGmCJyFhHIG/6rTp6XoWdww4q3y2HNa9ARJC
         KXkS6dwhU3bPjyK1wbRPzPBdu8FL4uTSZ8rSI+ayxqpZWn4/JgEWsnC45LHcHuLJz0JL
         1P6g==
X-Gm-Message-State: APjAAAUDCQ5mDKBtogB7AtQy61X8+9NpPXhGbpk2EuHqh+cB+XDbazc9
        OSwR/gQMlAT88G47ETv7kHr3DQ==
X-Google-Smtp-Source: APXvYqzM9oOLAkPcVl9UgYKRoHEoC82gzvdXDPhG6xeeOkRVWt+sbdw++p/1R4m41vGI3ysV22v3TQ==
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr3503725wmj.41.1561109962865;
        Fri, 21 Jun 2019 02:39:22 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c1sm3040319wrh.1.2019.06.21.02.39.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 02:39:22 -0700 (PDT)
Date:   Fri, 21 Jun 2019 11:39:21 +0200
From:   Oleksandr Natalenko <oleksandr@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sebastian Parschauer <s.parschauer@gmx.de>,
        Dave Young <dyoung@redhat.com>,
        "Herton R . Krzesinski" <herton@redhat.com>,
        Oliver Neukum <oneukum@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] hid: add another quirk for Chicony PixArt mouse
Message-ID: <20190621093920.qlnhbneoww7c6axw@butterfly.localdomain>
References: <20190621091736.14503-1-oleksandr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621091736.14503-1-oleksandr@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Erm. Cc: s.parschauer@gmx.de instead of inactive @suse address.

On Fri, Jun 21, 2019 at 11:17:36AM +0200, Oleksandr Natalenko wrote:
> I've spotted another Chicony PixArt mouse in the wild, which requires
> HID_QUIRK_ALWAYS_POLL quirk, otherwise it disconnects each minute.
> 
> USB ID of this device is 0x04f2:0x0939.
> 
> We've introduced quirks like this for other models before, so lets add
> this mouse too.
> 
> Link: https://github.com/sriemer/fix-linux-mouse#usb-mouse-disconnectsreconnects-every-minute-on-linux
> Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
> ---
>  drivers/hid/hid-ids.h    | 1 +
>  drivers/hid/hid-quirks.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index eac0c54c5970..69f0553d9d95 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -269,6 +269,7 @@
>  #define USB_DEVICE_ID_CHICONY_MULTI_TOUCH	0xb19d
>  #define USB_DEVICE_ID_CHICONY_WIRELESS	0x0618
>  #define USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE	0x1053
> +#define USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE2	0x0939
>  #define USB_DEVICE_ID_CHICONY_WIRELESS2	0x1123
>  #define USB_DEVICE_ID_ASUS_AK1D		0x1125
>  #define USB_DEVICE_ID_CHICONY_TOSHIBA_WT10A	0x1408
> diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
> index e5ca6fe2ca57..671a285724f9 100644
> --- a/drivers/hid/hid-quirks.c
> +++ b/drivers/hid/hid-quirks.c
> @@ -42,6 +42,7 @@ static const struct hid_device_id hid_quirks[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM), HID_QUIRK_NOGET },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_TOUCH), HID_QUIRK_MULTI_INPUT },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE2), HID_QUIRK_ALWAYS_POLL },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS), HID_QUIRK_MULTI_INPUT },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CHIC, USB_DEVICE_ID_CHIC_GAMEPAD), HID_QUIRK_BADPAD },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_3AXIS_5BUTTON_STICK), HID_QUIRK_NOGET },
> -- 
> 2.22.0
> 

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
