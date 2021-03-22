Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E94E343663
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 02:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhCVBpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Mar 2021 21:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhCVBo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Mar 2021 21:44:59 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC59C061574;
        Sun, 21 Mar 2021 18:44:58 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id m7so11245743qtq.11;
        Sun, 21 Mar 2021 18:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LajPY8QIRosyTBmM7c+e3myyVPcOxPKFRuoIcqW6tFU=;
        b=JopkV+PNmYHffEDdmk9kfvHODJHOAM+WLrew5JypGO9k/69l/EZpsao2fK6WXSDNth
         PB1C4JQ0TtL8rdw677G8D2/e7Mx/9xpXyDg9wTCGf8MBMG6+lB1O7qYh0w2MT8dXZjgM
         tZE1YMSWsCBgjr6obd1WFbnTdYd/7LpgYySiJTWOHIV7oIaV5xADVgxEG/lojpMaw5CZ
         O1g83oZOM+pPhBWcBEhHb4XXpQYUdK4Mv0iPtWILZD+c5fEFRZxv8+i8eAFdwpwhiWGl
         9WF/OT05YweN2VxfgzceWghBsDz8vH7xQ/Qw2xg4Jil30FmpJEqC8HZaabpjFo8TFElI
         8bqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LajPY8QIRosyTBmM7c+e3myyVPcOxPKFRuoIcqW6tFU=;
        b=aj/r6ltmlCInD3rksM07RjB52uQQaYl05ahujLNuF3adJVtQ5VrJJfFCJ1Ma1WP2En
         6kBf1+1qUSpZChqEuSCDjI64s8Z355rCx0RgWg0Sn/8L9Dxg6YVwm0iTPkBLSi8k9s7K
         VItLfofT1eNZcHBC/aC8PENlROatwfbsm8YmCEcLj+G2VsTcOn/8ujr4C2UuOBe/pF8t
         QVAjLOXbpA3GDtF7O3kGV8OgKFqswJ6uDLt2akHR+zsHWK0opkHdgu9lYI9YPpqpmhbL
         QSlMbjSquAjVTLPKSvYqmvRumYiicFdSMigMQuM88zCeDtQ9TcMHw0GwASKvmJhimkH9
         vBpw==
X-Gm-Message-State: AOAM533ZK5MTV0D3brUW2GDlFnsADUL9u+n+WKN0SxmpuYRMonZnPCXd
        6oxGQpH9M+CH7b7K6NOn5tohBWaaOe4kXJS55K7v7T9ywg8=
X-Google-Smtp-Source: ABdhPJzC2ARni/b5iQd8H57nIexnewDQyos8avvgvbrrhXpZHB/pmSIWF3B8T/yXf/MdceTNMMrJNmBhHgTr2WPMuko=
X-Received: by 2002:a05:622a:46:: with SMTP id y6mr4793753qtw.154.1616377497947;
 Sun, 21 Mar 2021 18:44:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210322012859.17083-1-yunqiang.su@cipunited.com>
In-Reply-To: <20210322012859.17083-1-yunqiang.su@cipunited.com>
From:   YunQiang Su <wzssyqa@gmail.com>
Date:   Mon, 22 Mar 2021 09:44:46 +0800
Message-ID: <CAKcpw6VFpz3Vxrm6bgNZk5gqhGaj0vfRwuaqAsymTEkNCDdUyg@mail.gmail.com>
Subject: Re: [PATCH v8] MIPS: force use FR=0 for FPXX binaries
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

Sorry. This is a bad version. I will send v9 later.

YunQiang Su <yunqiang.su@cipunited.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8822=
=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=889:31=E5=86=99=E9=81=93=EF=BC=
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
>  arch/mips/kernel/elf.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
> index 7b045d2a0b51..311c4fde910d 100644
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
> +               state->overall_fp_mode =3D FP_FR0;
> +       else if (prog_req.single && !prog_req.frdefault)
>                 /* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 */
>                 state->overall_fp_mode =3D ((raw_current_cpu_data.fpu_id =
& MIPS_FPIR_F64) &&
>                                           cpu_has_mips_r2_r6) ?
> --
> 2.20.1
>


--=20
YunQiang Su
