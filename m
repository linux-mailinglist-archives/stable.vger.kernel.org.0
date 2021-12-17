Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA48478633
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 09:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhLQIaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 03:30:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233805AbhLQIaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 03:30:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639729801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+7AgiuEUoi3nQncHSqYFjntzFdXZczz/91mqmHMQafc=;
        b=QZdSy04YEhprZek6PK4RDk+gXZs1woj9RCQDqE+ktHjvZQ+cVE1HI93fuIuW9Y2xVT88+C
        HsDBrL+6W8uwdXOdko3sIYFBRADwJgJUhBEgWJRPShyfBKj6tx8Npe3CTNhQTmFotHFOSQ
        Nd4xuZFN6fvemHR4qFocCC9zHKQaxNk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-16rmgcRXNlOgktKGZILyzg-1; Fri, 17 Dec 2021 03:29:59 -0500
X-MC-Unique: 16rmgcRXNlOgktKGZILyzg-1
Received: by mail-pl1-f197.google.com with SMTP id k9-20020a170902c40900b001421e921ccaso604524plk.22
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 00:29:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+7AgiuEUoi3nQncHSqYFjntzFdXZczz/91mqmHMQafc=;
        b=w77HD5JjAa7Zi/40C+MRnIDgnM/aB7A8YI2xDNWdG3mnTFcSonvvc9GPClbG6Qs2ig
         +mLBu5VRfg+SLdLzsaQWjkwn5NeaTJ9DHMjBcn5ZXuA8dF3JWDXWRyX/SBsxCGHbW1Gl
         YuokRQjEMhrm8q6X9sSkkTg5Oy4zRPlU0rVT3oLP8Xp34rjBiWDnpEUfcB8sic893tXG
         yASgebL4WOsjEcIAiEyvtg7rXeYO+32n5ZGzfGsc2Lgn3/5ThF2vJ6ex1tk93t0RJXSU
         iHoxng3px86fLsDwoAprVrC9FC/MVc/O5eOBwxXs0E3kRgIiXdmV46bBovU0VcczwlMC
         WSUA==
X-Gm-Message-State: AOAM531T32/RvIJxfw7Gwq3o3OCnO5SCFDizYxJGKLnAx5kfm2UIhAQT
        ZGWPxDMJDXvK6JC0MUKjqyjrgQMPkBdZaAJD0eBcth4zaK/N2kgdS8sqJ7Y6jrbg55MetHPkVof
        ZkHVcw0ZpafZFfTb2aVq4JEZr6vwknQrp
X-Received: by 2002:a17:90b:224f:: with SMTP id hk15mr10957588pjb.173.1639729797888;
        Fri, 17 Dec 2021 00:29:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwg5R7B0aUAN0YIUa1Hf2hEt6R7jHQKtWA1O8bOq6EjVzzyR3CeyikpqpHci78L0ckbLUqhcPsgmPN3+aWIC7A=
X-Received: by 2002:a17:90b:224f:: with SMTP id hk15mr10957559pjb.173.1639729797470;
 Fri, 17 Dec 2021 00:29:57 -0800 (PST)
MIME-Version: 1.0
References: <e4efbf13-bd8d-0370-629b-6c80c0044b15@leemhuis.info>
 <42903605-7e8b-4e84-fcd6-1b23169b8639@redhat.com> <YbxJm2d7NJKwmJJu@kroah.com>
In-Reply-To: <YbxJm2d7NJKwmJJu@kroah.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 17 Dec 2021 09:29:46 +0100
Message-ID: <CAO-hwJJ+iHo4pT4RqgoFVthHJxTYG0_cq=DA6-VGk9nFDqVa7w@mail.gmail.com>
Subject: Re: FWD: Holtek mouse stopped working after kernel upgrade from
 5.15.7 to 5.15.8
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        tlinux@cebula.eu.org,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 9:26 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Dec 17, 2021 at 09:13:15AM +0100, Benjamin Tissoires wrote:
> > Hi,
> >
> > On 12/17/21 08:00, Thorsten Leemhuis wrote:
> > > Hi, this is your Linux kernel regression tracker speaking.
> > >
> > > I noticed a bugreport from Tomasz C. (CCed) that sounds a lot like a
> > > regression between v5.15.7..v5.15.8 and likely better dealt with by email:
> > >
> > > To quote from: https://bugzilla.kernel.org/show_bug.cgi?id=215341
> > >
> > > > After updating kernel from 5.15.7 to 5.15.8 on ArchLinux distribution, Holtek USB mouse stopped working.
> > > > Exact model:
> > > > 04d9:a067 Holtek Semiconductor, Inc. USB Gaming Mouse
> > > >
> > > > The dmesg output for this device from kernel version 5.15.8:
> > > >
> > > > [    2.501958] usb 2-1.2.3: new full-speed USB device number 6 using ehci-pci
> > > > [    2.624369] usb 2-1.2.3: New USB device found, idVendor=04d9, idProduct=a067, bcdDevice= 1.16
> > > > [    2.624376] usb 2-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > > > [    2.624379] usb 2-1.2.3: Product: USB Gaming Mouse
> > > > [    2.624382] usb 2-1.2.3: Manufacturer: Holtek
> > > >
> > > > After disconnecting and connecting the USB:
> > > >
> > > > [   71.976731] usb 2-1.2.3: USB disconnect, device number 6
> > > > [   75.013021] usb 2-1.2.3: new full-speed USB device number 8 using ehci-pci
> > > > [   75.135865] usb 2-1.2.3: New USB device found, idVendor=04d9, idProduct=a067, bcdDevice= 1.16
> > > > [   75.135873] usb 2-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > > > [   75.135877] usb 2-1.2.3: Product: USB Gaming Mouse
> > > > [   75.135880] usb 2-1.2.3: Manufacturer: Holtek
> > > >
> > > >
> > > > On kernel version 5.15.7:
> > > >
> > > > [    2.280515] usb 2-1.2.3: new full-speed USB device number 6 using ehci-pci
> > > > [    2.379777] usb 2-1.2.3: New USB device found, idVendor=04d9, idProduct=a067, bcdDevice= 1.16
> > > > [    2.379784] usb 2-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > > > [    2.379787] usb 2-1.2.3: Product: USB Gaming Mouse
> > > > [    2.379790] usb 2-1.2.3: Manufacturer: Holtek
> > > > [    2.398578] input: Holtek USB Gaming Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.3/2-1.2.3:1.0/0003:04D9:A067.0005/input/input11
> > > > [    2.450977] holtek_mouse 0003:04D9:A067.0005: input,hidraw4: USB HID v1.10 Keyboard [Holtek USB Gaming Mouse] on usb-0000:00:1d.0-1.2.3/input0
> > > > [    2.451013] holtek_mouse 0003:04D9:A067.0006: Fixing up report descriptor
> > > > [    2.452189] input: Holtek USB Gaming Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.3/2-1.2.3:1.1/0003:04D9:A067.0006/input/input12
> > > > [    2.468510] usb 2-1.2.4: new high-speed USB device number 7 using ehci-pci
> > > > [    2.503913] holtek_mouse 0003:04D9:A067.0006: input,hiddev96,hidraw5: USB HID v1.10 Mouse [Holtek USB Gaming Mouse] on usb-0000:00:1d.0-1.2.3/input1
> > > > [    2.504105] holtek_mouse 0003:04D9:A067.0007: hiddev97,hidraw6: USB HID v1.10 Device [Holtek USB Gaming Mouse] on usb-0000:00:1d.0-1.2.3/input2
> > > >
> > > > Rolling back the kernel to version 5.15.7 solves the problem.
> >
> > Oops, sorry. An overlook from a precedent commit.
> >
> > Can you confirm the following patch works? (and also tell me if the
> > links I put are sufficient for regzbot)
> > ---
> > rom 8f38596f2620c4b22ff9e2622917ac2b69aa8320 Mon Sep 17 00:00:00 2001
> > From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > Date: Fri, 17 Dec 2021 09:03:32 +0100
> > Subject: [PATCH] HID: holtek: fix mouse probing
> >
> > An overlook from the previous commit: we don't even parse or start the
> > device, meaning that the device is not presented to user space.
> >
> > Fixes: 93020953d0fa ("HID: check for valid USB device for many HID drivers")
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=215341
> > Link: https://lore.kernel.org/regressions/e4efbf13-bd8d-0370-629b-6c80c0044b15@leemhuis.info/
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > ---
> >  drivers/hid/hid-holtek-mouse.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/drivers/hid/hid-holtek-mouse.c b/drivers/hid/hid-holtek-mouse.c
> > index b7172c48ef9f..7c907939bfae 100644
> > --- a/drivers/hid/hid-holtek-mouse.c
> > +++ b/drivers/hid/hid-holtek-mouse.c
> > @@ -65,8 +65,23 @@ static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
> >  static int holtek_mouse_probe(struct hid_device *hdev,
> >                             const struct hid_device_id *id)
> >  {
> > +     int ret;
> > +
> >       if (!hid_is_usb(hdev))
> >               return -EINVAL;
> > +
> > +     ret = hid_parse(hdev);
> > +     if (ret) {
> > +             hid_err(hdev, "hid parse failed: %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
> > +     if (ret) {
> > +             hid_err(hdev, "hw start failed: %d\n", ret);
> > +             return ret;
> > +     }
> > +
> >       return 0;
> >  }
> > --
> > 2.31.1
>
> Ugh, my fault, you did warn me about the probe function, I should have
> noticed this was required, sorry about that.
>

Well, honestly, I should have detected it when reviewing. So we both
share the blame :)

Cheers,
Benjamin

