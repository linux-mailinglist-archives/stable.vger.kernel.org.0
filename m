Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5200F3225EA
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 07:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhBWG3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 01:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhBWG2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 01:28:42 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9ADC06174A;
        Mon, 22 Feb 2021 22:28:01 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id h8so15207496qkk.6;
        Mon, 22 Feb 2021 22:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZAXVcgl6x9yI+qM37vgapLbBz+FqNZMLl50ftKO4zUU=;
        b=dPJAF4aP/hkaWTwlV23Rui3hxrzYgDLnTWPj7pwYDrSte184D1UCN8e2/ZuuKjXfJ3
         CKkhSpdvvElaYDiNnfm0ZNpRt8KpVTox/XK5/wIeIGUCMsYpVfupGbmXJKYMKIGK3MAt
         9vmd0FnTLRBwOOU/ZAKjXCNsukLbz1DqwCkI39YoGxYquasWJfcnrkapiwNnpExzkXN8
         lAmVFY1CmuovfftX659//CpvX43Lnicw8EJIvJwVo8Jh8pWJ2m0QXeClMkmxY8Ggc19D
         eowKC17aNry7YT3U39JwIO6A+UuHzaAh8sNPGKoNRJRHQduSZQxj3lGzpVO9RmRuEi/B
         xjQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZAXVcgl6x9yI+qM37vgapLbBz+FqNZMLl50ftKO4zUU=;
        b=b2ZMJunyxRrjzSf2nvC2QmdrBUpvL/civOEhgLyOw1478Mfj/S1a4TlNO7pmb0BV7C
         4S5NvoT8WB2CD+BQSBvJXJ+g9GJlh4IZgvzxgN501AZPwqXwkjiJxpnh5X+5DBjaq4Dd
         uqpcVWM+CSW0uFUfiMkZCeFplsK30HH2VJ4EnWudvGcXTaxXHdozugS5eQWgO1isMwob
         AIRg20RRlZhl7OQSpOb0q+hPJ+YWKTU4euFnXACnrsxjoBWqXo9fqA0jLXVW4e21yHzQ
         S4WMYmXbOz/CGYtPUl+/aipeuIoDn+wz8ffNe1+9QjdlVx9kWvtdXSdKbsy4H6ho82IB
         WX1A==
X-Gm-Message-State: AOAM530487fTKDuSy1TYr6lY20qa6rHNgWmOado+5TIcueKZ0+AY14/p
        vV6nyPIztNPBOKMUWQ6hGbXIyToqFrd7bfD1bzD4VhuaD8wd8w==
X-Google-Smtp-Source: ABdhPJz6FkjH1xdJKTqEl8zYEkQU2J5XXjqCfQhRz2XIj4bVjzTbnulUiKvObIE4qKl04P+E8ymB1cOsbJ4Hqq3AdxQ=
X-Received: by 2002:a37:4d09:: with SMTP id a9mr8617635qkb.469.1614061680873;
 Mon, 22 Feb 2021 22:28:00 -0800 (PST)
MIME-Version: 1.0
References: <20210222034342.13136-1-yunqiang.su@cipunited.com>
In-Reply-To: <20210222034342.13136-1-yunqiang.su@cipunited.com>
From:   YunQiang Su <wzssyqa@gmail.com>
Date:   Tue, 23 Feb 2021 14:29:38 +0800
Message-ID: <CAKcpw6UgEUUCG2=9E9KFpTYF23fWshdcFtmB_O+YT0xEoS3swA@mail.gmail.com>
Subject: Re: [PATCH v4] MIPS: introduce config option to force use FR=0 for
 FPXX binary
To:     YunQiang Su <yunqiang.su@cipunited.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        linux-mips <linux-mips@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

YunQiang Su <yunqiang.su@cipunited.com> =E4=BA=8E2021=E5=B9=B42=E6=9C=8822=
=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8811:45=E5=86=99=E9=81=93=EF=BC=
=9A
>
> some binary, for example the output of golang, may be mark as FPXX,
> while in fact they are still FP32.
>
> Since FPXX binary can work with both FR=3D1 and FR=3D0, we introduce a
> config option CONFIG_MIPS_O32_FPXX_USE_FR0 to force it to use FR=3D0 here=
.

As the diffination, .gnu.attribution 4,0 is the same as no
.gnu.attribution section.
Its meaning is that the binary has no float operation at all.

I worry about that if we force 4,0 as 4,1, it may cause some
compatible problems.

>
> https://go-review.googlesource.com/c/go/+/239217
> https://go-review.googlesource.com/c/go/+/237058
>
> v3->v4:
>         introduce a config option: CONFIG_MIPS_O32_FPXX_USE_FR0
>
> v2->v3:
>         commit message: add Signed-off-by and Cc to stable.
>
> v1->v2:
>         Fix bad commit message: in fact, we are switching to FR=3D0
>
> Signed-off-by: YunQiang Su <yunqiang.su@cipunited.com>
> Cc: stable@vger.kernel.org # 4.19+
> ---
>  arch/mips/Kconfig      | 11 +++++++++++
>  arch/mips/kernel/elf.c | 13 ++++++++++---
>  2 files changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 0a17bedf4f0d..442db620636f 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -3100,6 +3100,17 @@ config MIPS_O32_FP64_SUPPORT
>
>           If unsure, say N.
>
> +config MIPS_O32_FPXX_USE_FR0
> +       bool "Use FR=3D0 mode for O32 FPXX binaries" if !CPU_MIPSR6
> +       depends on MIPS_O32_FP64_SUPPORT
> +       help
> +         O32 FPXX can works on both FR=3D0 and FR=3D1 mode, so by defaul=
t, the
> +         mode preferred by hardware is used.
> +
> +         While some binaries may be marked as FPXX by mistake, for examp=
le
> +         output of golang: they are in fact FP32 mode. To compatiable wi=
th
> +         these binaries, we should use FR=3D0 mode for them.
> +
>  config USE_OF
>         bool
>         select OF
> diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
> index 7b045d2a0b51..443ced26ee60 100644
> --- a/arch/mips/kernel/elf.c
> +++ b/arch/mips/kernel/elf.c
> @@ -234,9 +234,10 @@ int arch_check_elf(void *_ehdr, bool has_interpreter=
, void *_interp_ehdr,
>          *   fpxx case. This is because, in any-ABI (or no-ABI) we have n=
o FPU
>          *   instructions so we don't care about the mode. We will simply=
 use
>          *   the one preferred by the hardware. In fpxx case, that ABI ca=
n
> -        *   handle both FR=3D1 and FR=3D0, so, again, we simply choose t=
he one
> -        *   preferred by the hardware. Next, if we only use single-preci=
sion
> -        *   FPU instructions, and the default ABI FPU mode is not good
> +        *   handle both FR=3D1 and FR=3D0. Here, we may need to use FR=
=3D0, because
> +        *   some binaries may be mark as FPXX by mistake (ie, output of =
golang).
> +        * - If we only use single-precision FPU instructions,
> +        *   and the default ABI FPU mode is not good
>          *   (ie single + any ABI combination), we set again the FPU mode=
 to the
>          *   one is preferred by the hardware. Next, if we know that the =
code
>          *   will only use single-precision instructions, shown by single=
 being
> @@ -248,8 +249,14 @@ int arch_check_elf(void *_ehdr, bool has_interpreter=
, void *_interp_ehdr,
>          */
>         if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1)
>                 state->overall_fp_mode =3D FP_FRE;
> +#if CONFIG_MIPS_O32_FPXX_USE_FR0
> +       else if (prog_req.fr1 && prog_req.frdefault)
> +               state->overall_fp_mode =3D FP_FR0;
> +       else if (prog_req.single && !prog_req.frdefault)
> +#else
>         else if ((prog_req.fr1 && prog_req.frdefault) ||
>                  (prog_req.single && !prog_req.frdefault))
> +#endif
>                 /* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 */
>                 state->overall_fp_mode =3D ((raw_current_cpu_data.fpu_id =
& MIPS_FPIR_F64) &&
>                                           cpu_has_mips_r2_r6) ?
> --
> 2.20.1
>


--=20
YunQiang Su
