Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46CF341232
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 02:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhCSBir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 21:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhCSBig (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 21:38:36 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FF8C06174A;
        Thu, 18 Mar 2021 18:38:36 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id d10so4269439qve.7;
        Thu, 18 Mar 2021 18:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZmSzVVpmo0MtaciQ2QFbjecrxNhJhjyXdrgqPn23/6c=;
        b=LdEGvWESa7I9KhH0QvFpOg+mK6MMwbQPClw/rG+OvS+qYnWwIWv3cXmAk/oOcn5i6Z
         PBLC9e5eTBoBmb/wj1r/FVKItmK9U0d52AsK9qL2vi7EKjwqocwn3EdFhr4r8lgqMv/P
         MWeX/nDNO7HgHJoyt55wg42WiJpOhRWz1c9q5Y5NYIbOKftI3GOnW9Wk/N6KiMMal7y4
         mfeZRliINgvrlAZ/cv/2oXmECJqqayEAgowSX/VG8ZkNl4zTt+G3zJfqZRC/CuLGWX88
         8rlt+yocE9M//WYrXlbR5L5MA/NigftKkONWggWHql4pfQeCKENyZ74mNfU0wjACWy2c
         rKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZmSzVVpmo0MtaciQ2QFbjecrxNhJhjyXdrgqPn23/6c=;
        b=jIELuxR8+jMk3NzxrW5XvvS2QA8h1UHy0JJE0qB+0qswsbBflfXRPbJF7QsPJ2t/sD
         B3p5wgiXasBG8ET7d1wNyKeEv0xoX5OFgOIbQ+6rZo3IXJ3ROW++PDlSODUYK89VdYwg
         jkQ8Cz72wR4e1li+xo8GPrz3JkbN4hnbrmmbkXoXuVXrGUMKSM5F5w0Ldxo3rFL8TmJd
         tTaFkzdoNVhv1ZEIoNi9WX54Z94L2XoiDB5Nya3TwmocIA+s7iAR91X/dmUiwpXeGSRX
         XeXfed97D/0MGx7+0uAnepmpvKnSJUNcmgl1XGPvtiTv/SgxglLK+g1rvBVG3HByjpOF
         Ml6Q==
X-Gm-Message-State: AOAM530frBoElLVm4dD3BsuGsQT1xZmRq5o0fXH6CIO54VBQJb7Tg+bF
        8yDiQJkJ0m67JtO934V+Dbg69l5geC4Wfdg0u+Q=
X-Google-Smtp-Source: ABdhPJySF1SYctAhCxn1zb4yDZEwd9pjSKQPUHwA5ZnW6gKIAAylUBtc/ozVMNDHOZfO/G47XaqZ80EiBZnb7dGaUHs=
X-Received: by 2002:a05:6214:d84:: with SMTP id e4mr7130545qve.26.1616117915782;
 Thu, 18 Mar 2021 18:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210312104859.16337-1-yunqiang.su@cipunited.com>
 <20210315145850.GA12494@alpha.franken.de> <alpine.DEB.2.21.2103172345020.21463@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2103172345020.21463@angie.orcam.me.uk>
From:   YunQiang Su <wzssyqa@gmail.com>
Date:   Fri, 19 Mar 2021 09:38:25 +0800
Message-ID: <CAKcpw6UwYXYMCGw1C+nrRQLcqouxXCgdkDLZfK4fNFz+nVwZiQ@mail.gmail.com>
Subject: Re: [PATCH v7 RESEND] MIPS: force use FR=0 or FRE for FPXX binaries
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Maciej W. Rozycki <macro@orcam.me.uk> =E4=BA=8E2021=E5=B9=B43=E6=9C=8818=E6=
=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=887:16=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, 15 Mar 2021, Thomas Bogendoerfer wrote:
>
> > > In Golang, now we add the FP32 annotation, so the future golang progr=
ams
> > > won't have this problem. While for the existing binaries, we need a
> > > kernel workaround.
> >
> > what about just rebuilding them ? They are broken, so why should we fix
> > broken user binaries with kernel hacks ?
>
>  I agree.
>
>  I went ahead and double-checked myself what the situation is here since =
I
> could not have otherwise obtained the answer to the question I asked, and
> indeed as I suspected even the simplest Go program will include a dynamic
> libgo reference (`libgo.so.17' with the snapshot of GCC 11 I have built
> for the MIPS target).  So a userland workaround is as simple as relinking
> this single library for the FP32 model.  This will make the dynamic loade=
r
> force the FR=3D0 mode for all the executables that load the library.
>

In fact gccgo has no problem here at all.
The problem is about Google's golang: golang.org

>  Since as YunQiang says they're going to rebuild Golang with FP32
> annotation anyway, which will naturally apply to the dynamic libgo librar=
y
> as well, this will fix the problem with the existing binaries in the
> current distribution.  Given that this is actually a correct fix (another
> one is required for the linker bug) I see no reason to clutter the kernel
> with a hack.  Especially as users will have to update a component anyway,
> in this case the Go runtime rather than the kernel (which is better even,
> as you don't have to reboot).
>

Normally Go has no runtime. For Debian, we patched golang-1.15, and all
go objects in Debian bullseye will be OK.

While, the objects in Debian buster or previous version or other distributi=
on
may still broken.

The user may need to run these application on a kernel with O32_FP64
support enabled.

>  Once Golang has been modernised to use the FPXX mode the problem will go
> away, and given the frequent version bumps in libgo's soname the current
> breakage won't be an issue for whatever future version of Debian includes
> it as the whole distribution will of course have been rebuilt against the
> new library and any old broken executables kept by the user with a system
> upgrade will continue using the old FP32 dynamic library.
>

Yes. As show on commit-msg, the patches for Golang have been accepted.
https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058

The bad news is  that (Google's) Go has no runtime.

> > > Currently, FR=3D1 mode is used for all FPXX binary, it makes some wro=
ng
> > > behivour of the binaries. Since FPXX binary can work with both FR=3D1=
 and FR=3D0,
> > > we force it to use FR=3D0 or FRE (for R6 CPU).
> >
> > I'm not sure, if I want to take this patch.
> >
> > Maciej, what's your take on this ?
>
>  Given what I have written previously and especially above I maintain my
> objection.  I don't understand why we're supposed to do people's homework
> though and solve their problems.
>
>   Maciej



--=20
YunQiang Su
