Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2493C6A8716
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 17:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjCBQnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 11:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCBQno (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 11:43:44 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38C0D312
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 08:43:41 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t15so17158326wrz.7
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 08:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1677775420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cTZfZHAIhgJirPC83OpTOerMsHpSjvj4Zqm6PqES9bI=;
        b=FLTFY/6ogRnvXZl26ubXndP14EhvGLTYCaDMe0E+v+D4uEwk1Rf1gm8Wy4t72NV9+G
         S2u9Rd31ML2znI5/txqXW9xO8qEdvpSLfA4nUC5xX4FJ8Rn52hhXWVYAPXNHYm4RztqV
         +eyaeMhr4GjL6r89L46CdH+M4AIl9tBtg5fByudIoWTMFpWLu2DH/FyyuQ8ntB/y+EZ5
         AjwqXrF1xBPY0rvjE7U33tFVEoS2genDOGPbVYTo/j0DwP+aNLVolMZSeGVGfvBIFjeg
         NoshzMBVoFFa/EWXz4d7VqG+xkFixPL0l9ODMScmp+7WYwuyWLGt8fnsecXh2/MuTKvI
         552w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677775420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cTZfZHAIhgJirPC83OpTOerMsHpSjvj4Zqm6PqES9bI=;
        b=NytXNWtA0rgfXZA75n8VDlQzqls5y6SfsQnrcfOCqEEYIwU40hzf1Dbqq8TSB89pg1
         ELqPKxru/ZRKxyGDRCkqtIVDlcrTNFrTxabl2yBAUcysPkIwiqVoeJyrkznUz3UJXFKD
         pyh/yANjtUfM1VTRoAVTb2NJ8L7j0GQud1hgfLWr5kEI8XjyBtIAiQDVbBQb49tFAoE7
         vL4BG/kfjQSxM9Mj/dMdmCvgAuRpWrczJBdBXHscEQUPvvHjS2WjUxdVSf7kcjby/EU7
         recmHhuziavYqasv/x5UE07xrCnJVNKYEi6VHKcdqAOB12Lfejcn8LOKDq/T945LCQ1X
         Q4dQ==
X-Gm-Message-State: AO0yUKWohnRQ5ljCPz6prEtC1+bJu08BsVIQqF5mvXnRpwnSOjM67rF5
        /7P6BxGiO0y2EgkfD50iPj0EmqKzdeVk3rbW6YDGaGQbo/5C0Sb/
X-Google-Smtp-Source: AK7set+vXKnI+Vramuu8NtDo2jEQGC5AgWDJT3qnrylYvn5UhjJ2TtTG/B1cjhWFAaWc/NDHXS6Z7OUXdMf+VKgpBck=
X-Received: by 2002:adf:dd8b:0:b0:2c5:5941:a04b with SMTP id
 x11-20020adfdd8b000000b002c55941a04bmr594881wrl.7.1677775420157; Thu, 02 Mar
 2023 08:43:40 -0800 (PST)
MIME-Version: 1.0
References: <20230301075751.43839-1-lma@semihalf.com> <Y/8PUdEwskXuWZHA@kroah.com>
 <CAFJ_xbp+qD-_MGd3+SgBY=8zruZNy7k3CO3OMMmWhMGhA-tARQ@mail.gmail.com>
 <Y/9Ddl7c2PKSEpsR@kroah.com> <CAFJ_xbr_petJ8=wKNLSnJ=97t+cERre07=hNYFeBVHp0nvPtWw@mail.gmail.com>
In-Reply-To: <CAFJ_xbr_petJ8=wKNLSnJ=97t+cERre07=hNYFeBVHp0nvPtWw@mail.gmail.com>
From:   Lukasz Majczak <lma@semihalf.com>
Date:   Thu, 2 Mar 2023 17:43:28 +0100
Message-ID: <CAFJ_xbrK9pGh_5muDKCCPz1gvaue7sKKELJfZ6TZHCU+gibtYg@mail.gmail.com>
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

=C5=9Br., 1 mar 2023 o 15:09 Lukasz Majczak <lma@semihalf.com> napisa=C5=82=
(a):
>
> =C5=9Br., 1 mar 2023 o 13:22 Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> napisa=C5=82(a):
> >
> > On Wed, Mar 01, 2023 at 10:51:31AM +0100, Lukasz Majczak wrote:
> > > =C5=9Br., 1 mar 2023 o 09:39 Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> napisa=C5=82(a):
> > > >
> > > > On Wed, Mar 01, 2023 at 08:57:51AM +0100, Lukasz Majczak wrote:
> > > > > Re-enable the console device after suspending, causes its cflags,
> > > > > ispeed and ospeed to be set anew, basing on the values stored in
> > > > > uport->cons. The issue is that these values are set only once,
> > > > > when parsing console parameters after boot (see uart_set_options(=
)),
> > > > > next after configuring a port in uart_port_startup() these parame=
teres
> > > > > (cflags, ispeed and ospeed) are copied to termios structure and
> > > > > the orginal one (stored in uport->cons) are cleared, but there is=
 no place
> > > > > in code where those fields are checked against 0.
> > > > > When kernel calls uart_resume_port() and setups console, it copie=
s cflags,
> > > > > ispeed and ospeed values from uart->cons,but those are alread cle=
ared.
> > > > > The efect is that console is broken.
> > > > > This patch address this by preserving the cflags, ispeed and
> > > > > ospeed fields in uart->cons during uart_port_startup().
> > > > >
> > > > > Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > >  drivers/tty/serial/serial_core.c | 3 ---
> > > > >  1 file changed, 3 deletions(-)
> > > > >
> > > > > diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/seria=
l/serial_core.c
> > > > > index 2bd32c8ece39..394a05c09d87 100644
> > > > > --- a/drivers/tty/serial/serial_core.c
> > > > > +++ b/drivers/tty/serial/serial_core.c
> > > > > @@ -225,9 +225,6 @@ static int uart_port_startup(struct tty_struc=
t *tty, struct uart_state *state,
> > > > >                       tty->termios.c_cflag =3D uport->cons->cflag=
;
> > > > >                       tty->termios.c_ispeed =3D uport->cons->ispe=
ed;
> > > > >                       tty->termios.c_ospeed =3D uport->cons->ospe=
ed;
> > > > > -                     uport->cons->cflag =3D 0;
> > > > > -                     uport->cons->ispeed =3D 0;
> > > > > -                     uport->cons->ospeed =3D 0;
> > > > >               }
> > > > >               /*
> > > > >                * Initialise the hardware port settings.
> > > > > --
> > > > > 2.39.2.722.g9855ee24e9-goog
> > > > >
> > > >
> > > > What commit id does this fix?
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > Hi Greg,
> > >
> > > There are actually two commits that introduce problematic uport flags
> > > clearing in uart_startup (for the sake of simplicity I'd ignore the
> > > older history):
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?h=3Dv6.2&id=3Dc7d7abff40c27f82fe78b1091ab3fad69b2546f9
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?h=3Dv6.2&id=3D027b57170bf8bb6999a28e4a5f3d78bf1db0f90c
> > > It's 10 years between those 2 and to me it was hard to decide about
> > > picking a proper one for the `Fixes:` tag.
> > > How would you recommend to proceed wrt applying this patch on the
> > > stable releases?
> >
> > Where do you think this needs to go to?  Pick something?
> >
> > And as you have obviously found this on a device running an older kerne=
l
> > version, what kernel tree(s) did you test it on?
> >
> > thanks,
> >
> > greg k-h
>
> As this patch applies without conflict on 4.14, I would suggest 4.14+.
> I have tested the patch on chromes-5.15 (cannonlake device).
>
> Best regards,
> Lukasz

I have tested my patch also with 4.14 and 6.1 (again chromeos tree).
On 4.14 it fixed the issue, but on 6.1 although the console survived
the suspend/resume,
it is printing different characters than requested - I will try to
debug it further.

Best regards
Lukasz
