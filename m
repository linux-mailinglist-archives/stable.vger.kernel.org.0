Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C02E6A6E00
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 15:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCAOJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 09:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjCAOJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 09:09:56 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E082E80C
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 06:09:47 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id e13so1831853wro.10
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 06:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1677679786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t2tkGhWdBAa8vzlH7r5oMbSYEhnxp7JkbKglKgSKZPM=;
        b=oUYse4DWw7yraUVmj59PCoIil14gWfqSJGLpk8uuNeWmLJrodJcy6b/gtXgE5biTkP
         GcPvcVQZ3cZ/13zsauESm0SPU9qozBpH3CfZeUwHwG46Zdm85Pyw56Z/C/7MIbiBnWua
         4OXFZBHbVyK0pv84eQaUU/HHUtolfdk2Uugk58+Kngve/qHUMX/LZcSbhTRrtLWC9F+S
         sSPnUzjWtlHvOf3VxgQyviEgwNeLtcPIr10deJxTr7Ktah0l89yiCzF2bFq7OQGWeqF+
         KttFMWWs2TAL0f9D8K66/p8MxDEg/gPJr1OO5NAT9lKSrXGZQXWDkcj4dFoNKN6szQRm
         hkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677679786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2tkGhWdBAa8vzlH7r5oMbSYEhnxp7JkbKglKgSKZPM=;
        b=PH6zRGvYxR+DxBtVpkXSbVweJfx1ffN9L5hdhOoHWxgW921I6NsXzKmyPFD5hDKACI
         kGw8hfWIQn8To0c2bYnVDpijjQtzyIwncBjxMXBHW5GJaOv7CIx0qGLQr05vy//wsAEl
         Ly/i5K5B4wInhRQSosRmD31PZ0hboUwAzILRvtXC1hr7/AJPho/GwS79HDA1l3ifzFXe
         pwHzN7h7lImyHk4dfX9Ryb4BNqOq44H5iARk4wTyH44QwrLC/ymzcOGJMTgzyVSjlvrs
         UB4PnJ5KLW7U6jJXLdFyuoHsKSf6BXjxpjdrf/YN4qbBBsU1BfKHB71LHKHfDA5pFlHU
         xW8Q==
X-Gm-Message-State: AO0yUKVNZx+CZNUiWrHoIwfWKuWhJKNNnA51p0eTJsmA4ueuO6Rir3f3
        ypSzsU40YuqkhsZszRj4gKNAXkU9cAmTtFqv36I1yfbtq43JUA==
X-Google-Smtp-Source: AK7set9C5QJ7lsnqeJK/GewLPn7eFADZyhxWk7KE+HwrjwBBgCiFNzCVKAVfBkPHY46lDxy2+JoL8SXc11QLl/ITKFw=
X-Received: by 2002:a05:6000:1e12:b0:2c5:5941:a04b with SMTP id
 bj18-20020a0560001e1200b002c55941a04bmr4283116wrb.7.1677679786037; Wed, 01
 Mar 2023 06:09:46 -0800 (PST)
MIME-Version: 1.0
References: <20230301075751.43839-1-lma@semihalf.com> <Y/8PUdEwskXuWZHA@kroah.com>
 <CAFJ_xbp+qD-_MGd3+SgBY=8zruZNy7k3CO3OMMmWhMGhA-tARQ@mail.gmail.com> <Y/9Ddl7c2PKSEpsR@kroah.com>
In-Reply-To: <Y/9Ddl7c2PKSEpsR@kroah.com>
From:   Lukasz Majczak <lma@semihalf.com>
Date:   Wed, 1 Mar 2023 15:09:35 +0100
Message-ID: <CAFJ_xbr_petJ8=wKNLSnJ=97t+cERre07=hNYFeBVHp0nvPtWw@mail.gmail.com>
Subject: Re: [PATCH] serial: core: fix broken console after suspend
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=C5=9Br., 1 mar 2023 o 13:22 Greg Kroah-Hartman
<gregkh@linuxfoundation.org> napisa=C5=82(a):
>
> On Wed, Mar 01, 2023 at 10:51:31AM +0100, Lukasz Majczak wrote:
> > =C5=9Br., 1 mar 2023 o 09:39 Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> napisa=C5=82(a):
> > >
> > > On Wed, Mar 01, 2023 at 08:57:51AM +0100, Lukasz Majczak wrote:
> > > > Re-enable the console device after suspending, causes its cflags,
> > > > ispeed and ospeed to be set anew, basing on the values stored in
> > > > uport->cons. The issue is that these values are set only once,
> > > > when parsing console parameters after boot (see uart_set_options())=
,
> > > > next after configuring a port in uart_port_startup() these paramete=
res
> > > > (cflags, ispeed and ospeed) are copied to termios structure and
> > > > the orginal one (stored in uport->cons) are cleared, but there is n=
o place
> > > > in code where those fields are checked against 0.
> > > > When kernel calls uart_resume_port() and setups console, it copies =
cflags,
> > > > ispeed and ospeed values from uart->cons,but those are alread clear=
ed.
> > > > The efect is that console is broken.
> > > > This patch address this by preserving the cflags, ispeed and
> > > > ospeed fields in uart->cons during uart_port_startup().
> > > >
> > > > Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >  drivers/tty/serial/serial_core.c | 3 ---
> > > >  1 file changed, 3 deletions(-)
> > > >
> > > > diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/=
serial_core.c
> > > > index 2bd32c8ece39..394a05c09d87 100644
> > > > --- a/drivers/tty/serial/serial_core.c
> > > > +++ b/drivers/tty/serial/serial_core.c
> > > > @@ -225,9 +225,6 @@ static int uart_port_startup(struct tty_struct =
*tty, struct uart_state *state,
> > > >                       tty->termios.c_cflag =3D uport->cons->cflag;
> > > >                       tty->termios.c_ispeed =3D uport->cons->ispeed=
;
> > > >                       tty->termios.c_ospeed =3D uport->cons->ospeed=
;
> > > > -                     uport->cons->cflag =3D 0;
> > > > -                     uport->cons->ispeed =3D 0;
> > > > -                     uport->cons->ospeed =3D 0;
> > > >               }
> > > >               /*
> > > >                * Initialise the hardware port settings.
> > > > --
> > > > 2.39.2.722.g9855ee24e9-goog
> > > >
> > >
> > > What commit id does this fix?
> > >
> > > thanks,
> > >
> > > greg k-h
> > Hi Greg,
> >
> > There are actually two commits that introduce problematic uport flags
> > clearing in uart_startup (for the sake of simplicity I'd ignore the
> > older history):
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?h=3Dv6.2&id=3Dc7d7abff40c27f82fe78b1091ab3fad69b2546f9
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?h=3Dv6.2&id=3D027b57170bf8bb6999a28e4a5f3d78bf1db0f90c
> > It's 10 years between those 2 and to me it was hard to decide about
> > picking a proper one for the `Fixes:` tag.
> > How would you recommend to proceed wrt applying this patch on the
> > stable releases?
>
> Where do you think this needs to go to?  Pick something?
>
> And as you have obviously found this on a device running an older kernel
> version, what kernel tree(s) did you test it on?
>
> thanks,
>
> greg k-h

As this patch applies without conflict on 4.14, I would suggest 4.14+.
I have tested the patch on chromes-5.15 (cannonlake device).

Best regards,
Lukasz
