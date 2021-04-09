Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B03359630
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 09:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhDIHR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 03:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhDIHR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 03:17:29 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1386C061760;
        Fri,  9 Apr 2021 00:17:16 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id q26so4928124qkm.6;
        Fri, 09 Apr 2021 00:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DnnF2ymY1TN3roZwco8QTJ2knkHfa1HyoxrVYAX5FVs=;
        b=uPZDaSXd4MjXwVqnavqeD4gyB7GduC/qsUSD1XSlab/osojf+pY7dqjchIpRk6XBD8
         vmVZvCDLHq0cMKboUbAWDBmxXtiBURVZ2PFu6nNpM0/4Sl2mY1Bg5+kfkkOFT8S1jKZD
         Fq9F9wDb4FofTqk8wP52ymBhDOK12d55G9e29ENzteXiwY0oRJpl+Jf0FaeGS3sZjmaO
         8U1JNcmd/s35GPbBbZaHPAzjRC3tC4Mm115VCjSE8HPZV2W/Q/VH17p6Zm6rJNgo2Pwf
         SA6mbTz1koVrZKpRJpxjs/oxa1CVR+FIB8+WRUTmHE+ULTFkRanopgcB7bCgNDGHD6dR
         yoIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DnnF2ymY1TN3roZwco8QTJ2knkHfa1HyoxrVYAX5FVs=;
        b=Z/rKm8MJfae2kdEVikXQtPNOrcS7+TC2vSPOWJe1EESJYvaK+4rw6NJPVkeyNvX6FJ
         nLupyoYjV2Y6yJSLaANfxhv20352gDwM0tjClEL/7hfMdgB8MTDKPXREOxQT5nt5CcbF
         GR+/hdzWkPAEtP76xbXKG+E9UnVFqh8GAR0MzcKq4YOeZJtBy5i1uMks7pofynOasDoo
         mMzBjwfHiCZS1vEDa/KeddEhfcJjAp/8Kd5MIQoZEp6jILS8KBWtKMClLILWQb6C6h+Q
         W1sIa0jA3BpGXLx8eIKx73yzILrXr7Gdp5anOAHPDSyvg01dpthxsRJUKrwEyFQQgc6k
         qqyA==
X-Gm-Message-State: AOAM532hXT8NFg9V8WxcYvSVKv9DmmCYhO/bVADShoZrRGuwJGogTphP
        VK8Sw/FT/SaAOZfXCz302atA/Mw6uM+EFlZlh78=
X-Google-Smtp-Source: ABdhPJxDhsVRxd1UhLRIFDYHM9Q6kTykN6SNGbeqrpl9zIJ2v9zvCTV6Lxr0HtGtYC4yU2/QpPSgLbMh2oWUwZ8VEVo=
X-Received: by 2002:a05:620a:cf4:: with SMTP id c20mr12272645qkj.134.1617952635903;
 Fri, 09 Apr 2021 00:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210406112404.2671507-1-chenhuacai@loongson.cn>
 <0338A250-3BF9-4B96-B9DE-61BE573CBB4C@goldelico.com> <3e27d0e0-4494-7a94-e0d7-046fb8898603@wanyeetech.com>
 <alpine.DEB.2.21.2104062343250.65251@angie.orcam.me.uk> <CAAhV-H7V2ykFqCv8n8pYs1ujbUYNy5UqPu21VPyj_Qzx5y8upQ@mail.gmail.com>
 <alpine.DEB.2.21.2104071530370.65251@angie.orcam.me.uk> <CAAhV-H7AH3JDHH-Ru_qhTZZt1zE69n4Yvskn8iDi0EPegXfHvQ@mail.gmail.com>
In-Reply-To: <CAAhV-H7AH3JDHH-Ru_qhTZZt1zE69n4Yvskn8iDi0EPegXfHvQ@mail.gmail.com>
From:   YunQiang Su <wzssyqa@gmail.com>
Date:   Fri, 9 Apr 2021 15:17:04 +0800
Message-ID: <CAKcpw6VJURv8kUMXKUWVJoGpufphL9vtVPZc99B+M1KwLVC01w@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Fix a longstanding error in div64.h
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Zhou Yanjie <zhouyu@wanyeetech.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Ralf Baechle <ralf@linux-mips.org>,
        stable <stable@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Huacai Chen <chenhuacai@kernel.org> =E4=BA=8E2021=E5=B9=B44=E6=9C=888=E6=97=
=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=8812:56=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi, Maciej,
>
> On Wed, Apr 7, 2021 at 9:38 PM Maciej W. Rozycki <macro@orcam.me.uk> wrot=
e:
> >
> > On Wed, 7 Apr 2021, Huacai Chen wrote:
> >
> > > >  This code is rather broken in an obvious way, starting from:
> > > >
> > > >         unsigned long long __n;                                    =
     \
> > > >                                                                    =
     \
> > > >         __high =3D *__n >> 32;                                     =
       \
> > > >         __low =3D __n;                                             =
       \
> > > >
> > > > where `__n' is used uninitialised.  Since this is my code originall=
y I'll
> > > > look into it; we may want to reinstate `do_div' too, which didn't h=
ave to
> > > > be removed in the first place.
> > > I think we can reuse the generic do_div().
> >
> >  We can, but it's not clear to me if this is optimal.  We have a DIVMOD
> > instruction which original code took advantage of (although I can see
> > potential in reusing bits from include/asm-generic/div64.h).  The two
> > implementations would have to be benchmarked against each other across =
a
> > couple of different CPUs.
> The original MIPS do_div() has "h" constraint, and this is also the
> reason why Ralf rewrote this file. How can we reintroduce do_div()
> without "h" constraint?
>

I try to figure out a new version:

uint32_t __attribute__ ((noinline)) div64_32n(uint64_t *x, uint32_t b) {
        uint64_t a =3D *x;

        uint64_t t1 =3D ((a>>32)/b)<<32;
        uint32_t t2 =3D (a>>32)%b;

        uint32_t res =3D (uint32_t)a;
        uint32_t t1lo =3D 0;

        uint32_t t3 =3D 0xffffffffu/b;
        uint32_t t4 =3D t3*b;
        uint32_t hi, lo;

        while(t2>0) {
                __asm__ (
                        "multu %2, %3\n"
                        "mfhi %0\n"
                        "mflo %1\n"
                        : "=3Dr" (hi), "=3Dr"(lo)
                        : "r" (t4), "r"(t2)
                );

                // yes, we are sure that t2*t3 will not overflow
                t1lo +=3D (t3*t2);
                t2 -=3D hi;
                if (lo > 0) {
                        t2 --; // we are sure that t2 > 0
                        lo =3D 0xffffffff - lo + 1;
                        unsigned tmp =3D lo + res;
                        // overflow
                        if (tmp < lo || tmp < res) {
                                t2 ++;
                        }
                        res =3D tmp;
                }
        }
        if (res >=3D b) {
                t1lo +=3D (res/b);
                res =3D (res%b);
        }

        t1 +=3D t1lo;
        *x =3D t1;
        return res;
}

With some test the performace: ((uint64_t)(-1))/3 with 0xfffff times

GCC: 5555555555555555, 0, seconds: 5
SYQ: 5555555555555555, 0, seconds: 4
KER: 5555555555555555, 0, seconds: 8
RAL: ffffffff, 2, seconds: 4

1. the MIPS current asm version cost 4s (and wrong result)
2. the simplest C code : a/b && a % b, cost 5s
3. the asm-generic version cost 8s.
4. my version cost 4s.

And the question is why asm-generic version exists
since it has bad performance than the code generated by GCC?

> Huacai
> >
> > > >  Huacai, thanks for your investigation!  Please be more careful in
> > > > verifying your future submissions however.
> > > Sorry, I thought there is only one bug in div64.h, but in fact there
> > > are three...
> >
> >  This just shows the verification you made was not good enough, hence m=
y
> > observation.
> >
> >   Maciej



--=20
YunQiang Su
