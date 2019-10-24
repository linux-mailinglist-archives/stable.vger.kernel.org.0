Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4479E35AA
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 16:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502679AbfJXOh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 10:37:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37805 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732293AbfJXOh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 10:37:27 -0400
Received: by mail-wr1-f67.google.com with SMTP id e11so17675496wrv.4
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 07:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hw3KjNKdwQRPm/ecs2t6KI7fSZoY132fhN8c2MtLdjo=;
        b=lYXlGcdloschpRTR6HYGebvll+K4v0c/MSReikUqC845/KgIWA8PK69hjxNDb+gihH
         rqL9EiqYClUx3YPEFdwaa1rrsVAi5hojM5pMkpS5cHVhEpUO6q9SoGyqU7uhl3h5KexI
         17VsZSNM84PA31rm59doj3sTtTHoBdFx7cXT2aQBd6uhFi+vC9JHZKUJQT1A10P0b2kD
         MXo+BVLUFBbeFAMUjsEKZTIZfxA2IgYBKVtWeDliDSbi8Q54OYY3F/aTUd0sIwu6q9d0
         GDAHakAvFaWa47lEh++zIzG8ohDxwcpSEZ3TiQmE6BHBue5SboR2WOGxxxBBcVHSWFln
         3hWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hw3KjNKdwQRPm/ecs2t6KI7fSZoY132fhN8c2MtLdjo=;
        b=h3qlD7NqpHdrpGHW3F4RMXQUJeMyJ8YuUmiMGSPBd1pM4Ew4oVu1dCUZQ5626C7RCS
         0+qMlq7/zHTgt4fyNrLh9JyAX2zop320eTMPW3nxIVSDBoNeLz7cuv2ASJXh90o70hG/
         kjckh409D5armB+bQ3QNPUlaJEfymaLXV8Gv08TtA+ReaUwxGDh0iW/y1Zkmtjk+ibOO
         06BmlDjEHUk7/QJ43brjoFtZq4PehMqHoASTmleRqX8FOuIdPfI8TPZnQa5egU14mSuT
         DJrLDgwHw5WFaNJ6dUs11bt4okeibnJMPWxYkPDJWCm1jbEJK8dyjVy1/ramQd5udHVF
         6xHw==
X-Gm-Message-State: APjAAAX50aX4xv1qCWsBNkYyt4M40cJ68JXq69/v4qMkU8stfJ/B8HY4
        +ySVjk5Vohk2kMyEq9Xx+vAG2oI7boAzXksNM9/l+s8aDNQryQ==
X-Google-Smtp-Source: APXvYqwadeBg2+vaHZMDkm+CaEuWFVu9SwaOKpL/erenWh2ZSt1TTIylEjuVed/Ytwtub5iO2z3ai+LxSdJQ9u5LcbE=
X-Received: by 2002:adf:9f08:: with SMTP id l8mr3989827wrf.325.1571927844150;
 Thu, 24 Oct 2019 07:37:24 -0700 (PDT)
MIME-Version: 1.0
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
 <20191024124833.4158-43-ard.biesheuvel@linaro.org> <b41df418-2e09-ac29-92cd-3910f0c05c50@arm.com>
In-Reply-To: <b41df418-2e09-ac29-92cd-3910f0c05c50@arm.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 24 Oct 2019 16:37:12 +0200
Message-ID: <CAKv+Gu8zW08_TKgvU4yHh=8E4_cnhx7iLoeOrYfmoy4m7ofwsA@mail.gmail.com>
Subject: Re: [PATCH for-stable-4.14 42/48] arm64: Always enable spectre-v2
 vulnerability detection
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
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

On Thu, 24 Oct 2019 at 16:34, Alexandru Elisei <alexandru.elisei@arm.com> w=
rote:
>
> Hi,
>
> On 10/24/19 1:48 PM, Ard Biesheuvel wrote:
> > From: Jeremy Linton <jeremy.linton@arm.com>
> >
> > [ Upstream commit 8c1e3d2bb44cbb998cb28ff9a18f105fee7f1eb3 ]
> >
> > Ensure we are always able to detect whether or not the CPU is affected
> > by Spectre-v2, so that we can later advertise this to userspace.
> >
> > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/arm64/kernel/cpu_errata.c | 15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_err=
ata.c
> > index bf6d8aa9b45a..647c533cfd90 100644
> > --- a/arch/arm64/kernel/cpu_errata.c
> > +++ b/arch/arm64/kernel/cpu_errata.c
> > @@ -76,7 +76,6 @@ cpu_enable_trap_ctr_access(const struct arm64_cpu_cap=
abilities *__unused)
> >       config_sctlr_el1(SCTLR_EL1_UCT, 0);
> >  }
> >
> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> >  #include <asm/mmu_context.h>
> >  #include <asm/cacheflush.h>
> >
> > @@ -217,11 +216,11 @@ static int detect_harden_bp_fw(void)
> >           ((midr & MIDR_CPU_MODEL_MASK) =3D=3D MIDR_QCOM_FALKOR_V1))
> >               cb =3D qcom_link_stack_sanitization;
> >
> > -     install_bp_hardening_cb(cb, smccc_start, smccc_end);
> > +     if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR))
> > +             install_bp_hardening_cb(cb, smccc_start, smccc_end);
> >
> >       return 1;
> >  }
> > -#endif       /* CONFIG_HARDEN_BRANCH_PREDICTOR */
> >
> >  DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
> >
> > @@ -457,7 +456,6 @@ static bool has_ssbd_mitigation(const struct arm64_=
cpu_capabilities *entry,
> >       .type =3D ARM64_CPUCAP_LOCAL_CPU_ERRATUM,                 \
> >       CAP_MIDR_RANGE_LIST(midr_list)
> >
> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> >  /*
> >   * List of CPUs that do not need any Spectre-v2 mitigation at all.
> >   */
> > @@ -489,6 +487,12 @@ check_branch_predictor(const struct arm64_cpu_capa=
bilities *entry, int scope)
> >       if (!need_wa)
> >               return false;
> >
> > +     if (!IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR)) {
> > +             pr_warn_once("spectrev2 mitigation disabled by kernel con=
figuration\n");
> > +             __hardenbp_enab =3D false;
>
> This breaks when building, because __hardenbp_enab is declared in the nex=
t patch:
>
> $ make -j32 defconfig && make -j32
>
> [..]
> arch/arm64/kernel/cpu_errata.c: In function =E2=80=98check_branch_predict=
or=E2=80=99:
> arch/arm64/kernel/cpu_errata.c:492:3: error: =E2=80=98__hardenbp_enab=E2=
=80=99 undeclared (first
> use in this function)
>    __hardenbp_enab =3D false;
>    ^~~~~~~~~~~~~~~
> arch/arm64/kernel/cpu_errata.c:492:3: note: each undeclared identifier is=
 reported
> only once for each function it appears in
> make[1]: *** [scripts/Makefile.build:326: arch/arm64/kernel/cpu_errata.o]=
 Error 1
> make[1]: *** Waiting for unfinished jobs....
>

Indeed, but as discussed, this matches the state of both mainline and
v4.19, which carry these patches in the same [wrong] order as well.

Greg should confirm, but as I understand it, it is preferred to be
bug-compatible with mainline rather than fixing problems when spotting
them while doing the backport.



> > +             return false;
> > +     }
> > +
> >       /* forced off */
> >       if (__nospectre_v2) {
> >               pr_info_once("spectrev2 mitigation disabled by command li=
ne option\n");
> > @@ -500,7 +504,6 @@ check_branch_predictor(const struct arm64_cpu_capab=
ilities *entry, int scope)
> >
> >       return (need_wa > 0);
> >  }
> > -#endif
> >
> >  const struct arm64_cpu_capabilities arm64_errata[] =3D {
> >  #if  defined(CONFIG_ARM64_ERRATUM_826319) || \
> > @@ -640,13 +643,11 @@ const struct arm64_cpu_capabilities arm64_errata[=
] =3D {
> >               ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
> >       },
> >  #endif
> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> >       {
> >               .capability =3D ARM64_HARDEN_BRANCH_PREDICTOR,
> >               .type =3D ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
> >               .matches =3D check_branch_predictor,
> >       },
> > -#endif
> >       {
> >               .desc =3D "Speculative Store Bypass Disable",
> >               .type =3D ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
