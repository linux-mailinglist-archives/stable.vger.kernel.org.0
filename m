Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D1C34121F
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 02:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhCSBbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 21:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhCSBb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 21:31:27 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EF4C06174A;
        Thu, 18 Mar 2021 18:31:26 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id v70so1369906qkb.8;
        Thu, 18 Mar 2021 18:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kliP7TmiXlnGehh7UIDqxBqiHpOMdBOej8Ymq2Ig9vg=;
        b=TharANJCxk5fs8O2aoHTJGEXlZ/JQpIoKrGojwRwL9M/k+m4BD2lX/wah69NMLu/bZ
         kG15V3jGMkRYJHlpukSPrgFtlZwF6cOl8CC5egKvUl5woE/T3qt1IzuBscU6hlEtP17p
         J8yeVdBD3wbC0vhWasryznem3SOQ0ehyf865TQm0Vj00bPsLswkZgS//qMMlW1d4sC8I
         eb/qI8vY99OV5h4jl2/7H/d7q1+BwyqAwMOjoaNvn8heoAmuQemjAijk7GEtnEPj0rgN
         eJ/EMGTY2yPEc2wEIoKsJDE0q6HwGBDePc1iHNYsDrPWOokoqHfOZtHh8EVdVC/mZSwZ
         8sTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kliP7TmiXlnGehh7UIDqxBqiHpOMdBOej8Ymq2Ig9vg=;
        b=qpCfODaJqdX1EdphAIzHTL6heG49Lu8xyaYQovDu5tlI1CNsYF16Y9EljPqugPwhjf
         zvBpRZmTq2Ki2td6TeUFweegRWQytAi2soOrPgMdfa1HzI6eCz9l1IF8h5PQtvhZKfV6
         d/lch2rK+vevA+ak8jlVNHIJ0DpNiysLPVSFi5V6GhFSarp//9+z61XoFkkAAUe7KP2k
         CtSl/sWMOtduFfMM+KAHwbHfpkn1X0IOx5Jlwugi+9lxuJSoIAGhU7EZVnZyI7BjHDEw
         X2IV5bBe8KtLHq0/pdNHcodCvaQLK+P1+uX35jKUl3YuksohRos687UJQLfp4XVzMjQk
         6oDQ==
X-Gm-Message-State: AOAM532SHfL4CCmWDlNHE5ZmG54QacPiniXSWfS28AMjARsC9iS3PYTv
        PsFVxa08TUBXFq826TFK/dvyhEs59M60T8eDdDbTyUIU7KE=
X-Google-Smtp-Source: ABdhPJz0RlpNaOhbZ2Xl+2SD91XFWKH/NtGQrRihWNQzPbirwuK07aVAqqswcYhsJ0MqCNbUr8yxxz7Kaqi9f30egvQ=
X-Received: by 2002:a05:620a:cf4:: with SMTP id c20mr513358qkj.134.1616117486008;
 Thu, 18 Mar 2021 18:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210312104859.16337-1-yunqiang.su@cipunited.com> <20210315145850.GA12494@alpha.franken.de>
In-Reply-To: <20210315145850.GA12494@alpha.franken.de>
From:   YunQiang Su <wzssyqa@gmail.com>
Date:   Fri, 19 Mar 2021 09:31:15 +0800
Message-ID: <CAKcpw6X88Z7ZjDfXgeDcBHpf1bzPWZc3KqEGgxfc7T30--wNWQ@mail.gmail.com>
Subject: Re: [PATCH v7 RESEND] MIPS: force use FR=0 or FRE for FPXX binaries
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips <linux-mips@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thomas Bogendoerfer <tsbogend@alpha.franken.de> =E4=BA=8E2021=E5=B9=B43=E6=
=9C=8815=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=8811:00=E5=86=99=E9=81=
=93=EF=BC=9A
>
> On Fri, Mar 12, 2021 at 10:48:59AM +0000, YunQiang Su wrote:
> > The MIPS FPU may have 3 mode:
> >   FR=3D0: MIPS I style, all of the FPR are single.
> >   FR=3D1: all 32 FPR can be double.
> >   FRE: redirecting the rw of odd-FPR to the upper 32bit of even-double =
FPR.
> >
> > The binary may have 3 mode:
> >   FP32: can only work with FR=3D0 and FRE mode
> >   FPXX: can work with all of FR=3D0/FR=3D1/FRE mode.
> >   FP64: can only work with FR=3D1 mode
> >
> > Some binary, for example the output of golang, may be mark as FPXX,
> > while in fact they are FP32. It is caused by the bug of design and link=
er:
> >   Object produced by pure Go has no FP annotation while in fact they ar=
e FP32;
> >   if we link them with the C module which marked as FPXX,
> >   the result will be marked as FPXX. If these fake-FPXX binaries is exe=
cuted
> >   in FR=3D1 mode, some problem will happen.
> >
> > In Golang, now we add the FP32 annotation, so the future golang program=
s
> > won't have this problem. While for the existing binaries, we need a
> > kernel workaround.
>
> what about just rebuilding them ? They are broken, so why should we fix
> broken user binaries with kernel hacks ?
>

In fact without O32_FP64_SUPPORT option is enabled, the FP=3D0 mode is
always used for FPXX.
In fact it doesn't change the behaviour of kernel.

> > Currently, FR=3D1 mode is used for all FPXX binary, it makes some wrong
> > behivour of the binaries. Since FPXX binary can work with both FR=3D1 a=
nd FR=3D0,
> > we force it to use FR=3D0 or FRE (for R6 CPU).
>
> I'm not sure, if I want to take this patch.
>

In fact, I'd prefer to use a config option to control this behivour.

> Maciej, what's your take on this ?
>
> Thomas.
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessaril=
y a
> good idea.                                                [ RFC1925, 2.3 =
]



--=20
YunQiang Su
