Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3D815098A
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 16:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgBCPPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 10:15:06 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58682 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728994AbgBCPPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 10:15:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580742905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vvAOIdqyqx/SfTUYH6RESTQuqbob7Z1UEonfiEAsQcc=;
        b=TTD3FxC3rBxdbaZH+d7ffKNwGmVYDHSmb1k1NtoCiqTeuU97pnH807yGE7qVURfQmn1RKU
        jD7rihNPjr+8giMbf48COE91VF9AVZ/Gdnf6NMXHYS1dO6DpwIPIX/OvW9G3fIMod16MtU
        D0+G7dPB0rd/9DXMHrQy69KuPF5MVQs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-EjXR7q9TNZKOeRp8HuVS6w-1; Mon, 03 Feb 2020 10:14:49 -0500
X-MC-Unique: EjXR7q9TNZKOeRp8HuVS6w-1
Received: by mail-qv1-f72.google.com with SMTP id u11so9591881qvo.8
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 07:14:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vvAOIdqyqx/SfTUYH6RESTQuqbob7Z1UEonfiEAsQcc=;
        b=JRMtUOXsE+eoGBz6nOthZUgwvVsgrIu7ltjwIATusZ4dMZWA2/K+QBdMoAomeFkrLF
         0wWfbmDKgHc2qWp92ssMKrHSbnq6pN0O/y15M4wfEcelEuuVuGGtptvp9UgnWgUxDcuR
         BXxDx1NASoKUAObJNCu6t+ZlaVvWct9IS3MlcZr+Q1ZU2oCM3Bo6FirpRRmLgfUSgT5g
         9i1XyP7L7Rruo0Mm+PXntoRVwM1LNGLLnKbuxG72VnwoIxndBBvMD6qN0Az+qMWPQke+
         2tPabQHYzBS4cV+OaA71dKq6KisZTyDMXYSlc+7fT50ghS0/PmWmo2/GnDYHc8DBgzXS
         FERQ==
X-Gm-Message-State: APjAAAVRxZfrMa95YTZSGNqsDoraSEpMyAoLGIYQgYj03Y745IpxfN7N
        tF7OTBnCq6HcIDuCIbmLt3hh4GSwTB37jIn7Kqi3d6XmrFrsbSOQWmp9LlC6pcfDg1SNg7jTguY
        8LaLwWyrmGl2MXyzFzwLDutyO7FwsluKP
X-Received: by 2002:ac8:365c:: with SMTP id n28mr23784698qtb.260.1580742889449;
        Mon, 03 Feb 2020 07:14:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqyFOn/ctSE/lHLxNoXgBZwk1V8z2vglXr15EI8xoDgCeHfh09Hldee8sBgneJREA21yRxhWmIca+dHatL2VFYQ=
X-Received: by 2002:ac8:365c:: with SMTP id n28mr23784668qtb.260.1580742889152;
 Mon, 03 Feb 2020 07:14:49 -0800 (PST)
MIME-Version: 1.0
References: <20200201115648.3934-1-hdegoede@redhat.com>
In-Reply-To: <20200201115648.3934-1-hdegoede@redhat.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 3 Feb 2020 16:14:37 +0100
Message-ID: <CAO-hwJK0BjKQMeUT11MxR4TaDN4sdMvN-4YtVBk+V_-JBOrEuw@mail.gmail.com>
Subject: Re: [PATCH v2] HID: ite: Only bind to keyboard USB interface on Acer
 SW5-012 keyboard dock
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>,
        =?UTF-8?Q?Zden=C4=9Bk_Rampas?= <zdenda.rampas@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 1, 2020 at 12:56 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboar=
d
> dock") added the USB id for the Acer SW5-012's keyboard dock to the
> hid-ite driver to fix the rfkill driver not working.
>
> Most keyboard docks with an ITE 8595 keyboard/touchpad controller have th=
e
> "Wireless Radio Control" bits which need the special hid-ite driver on th=
e
> second USB interface (the mouse interface) and their touchpad only suppor=
ts
> mouse emulation, so using generic hid-input handling for anything but
> the "Wireless Radio Control" bits is fine. On these devices we simply bin=
d
> to all USB interfaces.
>
> But unlike other ITE8595 using keyboard docks, the Acer Aspire Switch 10
> (SW5-012)'s touchpad not only does mouse emulation it also supports
> HID-multitouch and all the keys including the "Wireless Radio Control"
> bits have been moved to the first USB interface (the keyboard intf).
>
> So we need hid-ite to handle the first (keyboard) USB interface and have
> it NOT bind to the second (mouse) USB interface so that that can be
> handled by hid-multitouch.c and we get proper multi-touch support.
>
> This commit changes the hid_device_id for the SW5-012 keyboard dock to
> only match on hid devices from the HID_GROUP_GENERIC group, this way
> hid-ite will not bind the the mouse/multi-touch interface which has
> HID_GROUP_MULTITOUCH_WIN_8 as group.
> This fixes the regression to mouse-emulation mode introduced by adding
> the keyboard dock USB id.
>
> Cc: stable@vger.kernel.org
> Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboar=
d dock")
> Reported-by: Zden=C4=9Bk Rampas <zdenda.rampas@gmail.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> - Extend hid_device_id to also match on the HID_GROUP_GENERIC group,
>   instead of adding a match callback which peeks at the USB descriptors

Thanks for the quick revision.

Applied to for-5.6/upstream-fixes

And for the record, 2 MR have been added to hid-tools for regression testin=
g:
- https://gitlab.freedesktop.org/libevdev/hid-tools/merge_requests/70
(keyboard and wifi key)
- https://gitlab.freedesktop.org/libevdev/hid-tools/merge_requests/69
(touchpad, which currently fails on Linux master unless this patch
gets in)

Cheers,
Benjamin

> ---
>  drivers/hid/hid-ite.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
> index c436e12feb23..6c55682c5974 100644
> --- a/drivers/hid/hid-ite.c
> +++ b/drivers/hid/hid-ite.c
> @@ -41,8 +41,9 @@ static const struct hid_device_id ite_devices[] =3D {
>         { HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
>         /* ITE8595 USB kbd ctlr, with Synaptics touchpad connected to it.=
 */
> -       { HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS,
> -                        USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
> +       { HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
> +                    USB_VENDOR_ID_SYNAPTICS,
> +                    USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
>         { }
>  };
>  MODULE_DEVICE_TABLE(hid, ite_devices);
> --
> 2.23.0
>

