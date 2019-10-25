Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3997E504E
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 17:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395466AbfJYPj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 11:39:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51499 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395456AbfJYPj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 11:39:59 -0400
Received: by mail-wm1-f65.google.com with SMTP id q70so2640742wme.1
        for <stable@vger.kernel.org>; Fri, 25 Oct 2019 08:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kG3Fj2+GAK5sY4ZShzLOqz+XBQeo1+0v0ugnJe2Juqg=;
        b=pQoxzRCl6NGXFFhIIkphhMFHdCun2ZIfQpaqQr67ikKPATm6r786XA7EB2Ou6xwVEn
         gBqp/NTgfNK6mBW32PFLEsqPgez+MerZJ6H9IAiMjVnjaFnWpD+ZZpWo+JoVp16qN9O1
         2IsLG14ddX4qCYKcl9HlmtftrQ5/p9Rtoio9P3CQ0xtugVm17nXMQH1IOULq1NofjXc8
         RMV0J8cXnAmGFd/NQm3VO1cGPN9ROx10YMs+r5Q8stmO7/9UWB2vRZp+oG+IPMZVRo/X
         IJB3lQUBLlUTMGbfsZc+/8tC4nm4CAIBytaBvltf9tDi//clYmDpecXuRQ7JuBVKVYEO
         pT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kG3Fj2+GAK5sY4ZShzLOqz+XBQeo1+0v0ugnJe2Juqg=;
        b=nh+FimNYqbVW1UYBxzRIpv6w2lMj/bB1QEcGmGl/uua3nu0C1tHF5Rs+a616ihbslX
         vhp0/F2ImXLk7cQc7g3NMYDbGRB+7+ZOyntjMmQH2zWwWWdtSPtjXTwqsU3JxklewFze
         nEieysL4fzRUZcFDvm3BfBJPJHy+N56mcNxG9blobWYlnVMCnMIi1Ts2kKP1udLood/C
         H3mT1jZEa3UpLvuXZJQeSifScmxjwlfs+nBHPKam4CWm4ljI+ry5HNd7Xmtrczn7KObp
         F6m24LIKmBH3OYN5odDieiaHT4Xah9s6m75p9DrifxiVsJbqBO34axUT/XNdVvNLUbde
         bjnQ==
X-Gm-Message-State: APjAAAUF/Obe2BnUZM8aNeOIjxbuPTUQb+IzXbUt3iREVwTC5PNSwhNV
        2Q1D66E9acutYq9esuyX6RDcmZAmgvMlL62FJkYDaw==
X-Google-Smtp-Source: APXvYqwqcEVeWUm9DuuVswgtbp3J/+sDmCdv2/V+lVz+s9d73v73N4yevOF2I0PU5KQfC/nBVg2x8akR2L1ZVj0uNLA=
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr4162329wme.53.1572017995991;
 Fri, 25 Oct 2019 08:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
 <20191024124833.4158-43-ard.biesheuvel@linaro.org> <b41df418-2e09-ac29-92cd-3910f0c05c50@arm.com>
 <CAKv+Gu8zW08_TKgvU4yHh=8E4_cnhx7iLoeOrYfmoy4m7ofwsA@mail.gmail.com>
 <20191025152534.GF31224@sasha-vm> <CAKv+Gu9_BtF2Zd9=9_wDukwKinmSMwes5R7Eu9jx315PQFk8dA@mail.gmail.com>
In-Reply-To: <CAKv+Gu9_BtF2Zd9=9_wDukwKinmSMwes5R7Eu9jx315PQFk8dA@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 25 Oct 2019 17:39:44 +0200
Message-ID: <CAKv+Gu-2LXayWyP=3Eur_toGo4xqhENWeK6n+TCDcEy8xrKmXQ@mail.gmail.com>
Subject: Re: [PATCH for-stable-4.14 42/48] arm64: Always enable spectre-v2
 vulnerability detection
To:     Sasha Levin <sashal@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Oct 2019 at 17:28, Ard Biesheuvel <ard.biesheuvel@linaro.org> wr=
ote:
>
> On Fri, 25 Oct 2019 at 17:25, Sasha Levin <sashal@kernel.org> wrote:
> >
> > On Thu, Oct 24, 2019 at 04:37:12PM +0200, Ard Biesheuvel wrote:
> > >On Thu, 24 Oct 2019 at 16:34, Alexandru Elisei <alexandru.elisei@arm.c=
om> wrote:
> > >>
> > >> Hi,
> > >>
> > >> On 10/24/19 1:48 PM, Ard Biesheuvel wrote:
> > >> > From: Jeremy Linton <jeremy.linton@arm.com>
> > >> >
> > >> > [ Upstream commit 8c1e3d2bb44cbb998cb28ff9a18f105fee7f1eb3 ]
> > >> >
> > >> > Ensure we are always able to detect whether or not the CPU is affe=
cted
> > >> > by Spectre-v2, so that we can later advertise this to userspace.
> > >> >
> > >> > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > >> > Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> > >> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > >> > Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
> > >> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > >> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > >> > ---
> > >> >  arch/arm64/kernel/cpu_errata.c | 15 ++++++++-------
> > >> >  1 file changed, 8 insertions(+), 7 deletions(-)
> > >> >
> > >> > diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cp=
u_errata.c
> > >> > index bf6d8aa9b45a..647c533cfd90 100644
> > >> > --- a/arch/arm64/kernel/cpu_errata.c
> > >> > +++ b/arch/arm64/kernel/cpu_errata.c
> > >> > @@ -76,7 +76,6 @@ cpu_enable_trap_ctr_access(const struct arm64_cp=
u_capabilities *__unused)
> > >> >       config_sctlr_el1(SCTLR_EL1_UCT, 0);
> > >> >  }
> > >> >
> > >> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> > >> >  #include <asm/mmu_context.h>
> > >> >  #include <asm/cacheflush.h>
> > >> >
> > >> > @@ -217,11 +216,11 @@ static int detect_harden_bp_fw(void)
> > >> >           ((midr & MIDR_CPU_MODEL_MASK) =3D=3D MIDR_QCOM_FALKOR_V1=
))
> > >> >               cb =3D qcom_link_stack_sanitization;
> > >> >
> > >> > -     install_bp_hardening_cb(cb, smccc_start, smccc_end);
> > >> > +     if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR))
> > >> > +             install_bp_hardening_cb(cb, smccc_start, smccc_end);
> > >> >
> > >> >       return 1;
> > >> >  }
> > >> > -#endif       /* CONFIG_HARDEN_BRANCH_PREDICTOR */
> > >> >
> > >> >  DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
> > >> >
> > >> > @@ -457,7 +456,6 @@ static bool has_ssbd_mitigation(const struct a=
rm64_cpu_capabilities *entry,
> > >> >       .type =3D ARM64_CPUCAP_LOCAL_CPU_ERRATUM,                 \
> > >> >       CAP_MIDR_RANGE_LIST(midr_list)
> > >> >
> > >> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> > >> >  /*
> > >> >   * List of CPUs that do not need any Spectre-v2 mitigation at all=
.
> > >> >   */
> > >> > @@ -489,6 +487,12 @@ check_branch_predictor(const struct arm64_cpu=
_capabilities *entry, int scope)
> > >> >       if (!need_wa)
> > >> >               return false;
> > >> >
> > >> > +     if (!IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR)) {
> > >> > +             pr_warn_once("spectrev2 mitigation disabled by kerne=
l configuration\n");
> > >> > +             __hardenbp_enab =3D false;
> > >>
> > >> This breaks when building, because __hardenbp_enab is declared in th=
e next patch:
> > >>
> > >> $ make -j32 defconfig && make -j32
> > >>
> > >> [..]
> > >> arch/arm64/kernel/cpu_errata.c: In function =E2=80=98check_branch_pr=
edictor=E2=80=99:
> > >> arch/arm64/kernel/cpu_errata.c:492:3: error: =E2=80=98__hardenbp_ena=
b=E2=80=99 undeclared (first
> > >> use in this function)
> > >>    __hardenbp_enab =3D false;
> > >>    ^~~~~~~~~~~~~~~
> > >> arch/arm64/kernel/cpu_errata.c:492:3: note: each undeclared identifi=
er is reported
> > >> only once for each function it appears in
> > >> make[1]: *** [scripts/Makefile.build:326: arch/arm64/kernel/cpu_erra=
ta.o] Error 1
> > >> make[1]: *** Waiting for unfinished jobs....
> > >>
> > >
> > >Indeed, but as discussed, this matches the state of both mainline and
> > >v4.19, which carry these patches in the same [wrong] order as well.
> > >
> > >Greg should confirm, but as I understand it, it is preferred to be
> > >bug-compatible with mainline rather than fixing problems when spotting
> > >them while doing the backport.
> >
> > Is it just patch ordering? If so I'd rather fix it, there's no reason t=
o
> > carry this issue into the stable trees.
> >
> > We reserve "bug compatibility" for functional issues that are not yet
> > fixed upstream, it doesn't seem to be the case here.
> >
>
> The patches don't apply cleanly in the opposite order.

What we could do is squash the two patches together. That way, we
avoid the breakage without having to modify the patches in order to be
able to apply them.
