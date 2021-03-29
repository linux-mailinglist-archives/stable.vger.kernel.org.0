Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB22334C2C5
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 07:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhC2FJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 01:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhC2FJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 01:09:29 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F337DC061574;
        Sun, 28 Mar 2021 22:09:28 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id i9so11375537qka.2;
        Sun, 28 Mar 2021 22:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6K/n1z5flduQO9Za4oeuyKWh7T1jG0wmXR9a9mLYgOo=;
        b=LyXrnofLcSHD3bXf5KpyknpKjgkHu3IGN/WMuYeG+P50K73vS2EvAwqjAnSVa1Mw3F
         n/THlHke7KeO8zWMVqq9EJHMUqaIIJrndgh186o0JEm75bprJocS3EsGOBdZhukFr4UI
         tunYGp1HQmlOPT4H6e0ytLECTSnsCICOX6BN7hW2Eic4H7gRiiK+nH7UfQOB1yGPVOTq
         77HrsCgPyL6sgZPmJdmLApOwx8TuK0YLe2CGc+RjRhIM97acrtco9GoK5asCQJrFUCcu
         abI1uZGNLgncbaZPgEAYlYNcJ+8OEHgHVqanqi5fkB8ZJgCcWD68ornH3Y2BpI+EDaWe
         2JCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6K/n1z5flduQO9Za4oeuyKWh7T1jG0wmXR9a9mLYgOo=;
        b=cHa4GKQFHfQSS4k11bJH5wK5qTrvn/5qSiMNtTe7YkMseNX8O+rSzBAHbvpimXFrMR
         AaMDe9Jj9z47A3r2gGzJ3mpb+1FHYfjrT5vyJ3uwHAuni9ewdaY30Hl3WBWTScZ3qzMF
         8N8gn8dV4M4mhx1bq2aiwP8/r5dGGOcEINVQ7TtYeoMl3chxRHTWd7G0v2y8TcND3y9/
         VMSLxrhI6ZGk2NSB4576LIRKqioIfSgU6iDSK80FvH/V78Fx96GUqg/CgFcWSVdcx8AZ
         waYwZyRRPKkMwbwFCpQpi1AdQ1MPDf/mDC1zkCFTftFhdHFf3IB7CA57vrIcU2C4iWrF
         xWyw==
X-Gm-Message-State: AOAM531db8xNG4v4q3Cs9pbAeDKPDUNh8UprA9sQ7Za+Zym4VPI1vnFY
        HAgMEszuxxTdeQMqUcuic/zMqk9NjzU+3cjLfkPnxi8Uy5mmqQ==
X-Google-Smtp-Source: ABdhPJz04RyRTTFANDqD9D8QCA4kD/gUaWMkOHOn44ugWK63iBBsp4fk0Vd6fXRxSsDp2TvUcRlCdshzGtCzGJactwQ=
X-Received: by 2002:a05:620a:1442:: with SMTP id i2mr24272783qkl.469.1616994568109;
 Sun, 28 Mar 2021 22:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210322015902.18451-1-yunqiang.su@cipunited.com>
In-Reply-To: <20210322015902.18451-1-yunqiang.su@cipunited.com>
From:   YunQiang Su <wzssyqa@gmail.com>
Date:   Mon, 29 Mar 2021 13:09:18 +0800
Message-ID: <CAKcpw6UPQFOt2DyY9EbKxziWyJXOsUwcf4khrAyFC=yTX1EuAg@mail.gmail.com>
Subject: Re: [PATCH v9] MIPS: force use FR=0 for FPXX binaries
To:     YunQiang Su <yunqiang.su@cipunited.com>
Cc:     linux-mips <linux-mips@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

YunQiang Su <yunqiang.su@cipunited.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8822=
=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8810:00=E5=86=99=E9=81=93=EF=BC=
=9A
>
> The MIPS FPU may have 3 mode:
>   FR=3D0: MIPS I style, all of the FPR are single.
>   FR=3D1: all 32 FPR can be double.
>   FRE: redirecting the rw of odd-FPR to the upper 32bit of even-double FP=
R.
>
> The binary may have 3 mode:
>   FP32: can only work with FR=3D0 and FRE mode
>   FPXX: can work with all of FR=3D0/FR=3D1/FRE mode.
>   FP64: can only work with FR=3D1 mode
>
> Some binary, for example the output of golang, may be mark as FPXX,
> while in fact they are FP32. It is caused by the bug of design and linker=
:
>   Object produced by pure Go has no FP annotation while in fact they are =
FP32;
>   if we link them with the C module which marked as FPXX,
>   the result will be marked as FPXX. If these fake-FPXX binaries is execu=
ted
>   in FR=3D1 mode, some problem will happen.
>
> In Golang, now we add the FP32 annotation, so the future golang programs
> won't have this problem. While for the existing binaries, we need a
> kernel workaround.
>

We meet a new problem in Debian: with the O32_FP64 enabled kernel,
mips64el may also be affected.
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D983583



> Currently, FR=3D1 mode is used for all FPXX binary if O32_FP64 supported =
is enabled,
> it makes some wrong behivour of the binaries.
> Since FPXX binary can work with both FR=3D1 and FR=3D0, we force it to us=
e FR=3D0.
>
> Reference:
>
> https://web.archive.org/web/20180828210612/https://dmz-portal.mips.com/wi=
ki/MIPS_O32_ABI_-_FR0_and_FR1_Interlinking
>
> https://go-review.googlesource.com/c/go/+/239217
> https://go-review.googlesource.com/c/go/+/237058
>
> Signed-off-by: YunQiang Su <yunqiang.su@cipunited.com>
> Cc: stable@vger.kernel.org # 4.19+
> ---
> v7->v8->v9:
>         Rollback to use FR=3D1 for FPXX on R6 CPU.
>
> v6->v7:
>         Use FRE mode for pre-R6 binaries on R6 CPU.
>
> v5->v6:
>         Rollback to V3, aka remove config option.
>
> v4->v5:
>         Fix CONFIG_MIPS_O32_FPXX_USE_FR0 usage: if -> ifdef
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
>
>  arch/mips/kernel/elf.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
> index 7b045d2a0b51..554561d5c1f8 100644
> --- a/arch/mips/kernel/elf.c
> +++ b/arch/mips/kernel/elf.c
> @@ -232,11 +232,16 @@ int arch_check_elf(void *_ehdr, bool has_interprete=
r, void *_interp_ehdr,
>          *   that inherently require the hybrid FP mode.
>          * - If FR1 and FRDEFAULT is true, that means we hit the any-abi =
or
>          *   fpxx case. This is because, in any-ABI (or no-ABI) we have n=
o FPU
> -        *   instructions so we don't care about the mode. We will simply=
 use
> -        *   the one preferred by the hardware. In fpxx case, that ABI ca=
n
> -        *   handle both FR=3D1 and FR=3D0, so, again, we simply choose t=
he one
> -        *   preferred by the hardware. Next, if we only use single-preci=
sion
> -        *   FPU instructions, and the default ABI FPU mode is not good
> +        *   instructions so we don't care about the mode.
> +        *   In fpxx case, that ABI can handle all of FR=3D1/FR=3D0/FRE m=
ode.
> +        *   Here, we need to use FR=3D0 mode instead of FR=3D1, because =
some binaries
> +        *   may be mark as FPXX by mistake due to bugs of design and lin=
ker:
> +        *      The object produced by pure Go has no FP annotation,
> +        *      then is treated as any-ABI by linker, although in fact th=
ey are FP32;
> +        *      if any-ABI object is linked with FPXX object, the result =
will be mark as FPXX.
> +        *      Then the problem happens: run FP32 binaries in FR=3D1 mod=
e.
> +        * - If we only use single-precision FPU instructions,
> +        *   and the default ABI FPU mode is not good
>          *   (ie single + any ABI combination), we set again the FPU mode=
 to the
>          *   one is preferred by the hardware. Next, if we know that the =
code
>          *   will only use single-precision instructions, shown by single=
 being
> @@ -248,8 +253,9 @@ int arch_check_elf(void *_ehdr, bool has_interpreter,=
 void *_interp_ehdr,
>          */
>         if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1)
>                 state->overall_fp_mode =3D FP_FRE;
> -       else if ((prog_req.fr1 && prog_req.frdefault) ||
> -                (prog_req.single && !prog_req.frdefault))
> +       else if (prog_req.fr1 && prog_req.frdefault)
> +               state->overall_fp_mode =3D cpu_has_mips_r6 ? FP_FR1 : FP_=
FR0;
> +       else if (prog_req.single && !prog_req.frdefault)
>                 /* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 */
>                 state->overall_fp_mode =3D ((raw_current_cpu_data.fpu_id =
& MIPS_FPIR_F64) &&
>                                           cpu_has_mips_r2_r6) ?
> --
> 2.20.1
>


--
YunQiang Su
