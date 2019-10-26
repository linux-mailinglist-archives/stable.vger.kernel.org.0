Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2544E5DF6
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 17:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfJZPqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 11:46:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33191 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfJZPqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Oct 2019 11:46:08 -0400
Received: by mail-wm1-f66.google.com with SMTP id 6so6385032wmf.0
        for <stable@vger.kernel.org>; Sat, 26 Oct 2019 08:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DDYkWpxszNp2WM+zJ/kXHlyI7L/XFZkvww5qDq0WlIg=;
        b=G0/mM8zl61cG0qLKtQQhuUl9TL99unzmbs+7aWTAuHNg0LqHA/xiqADwuNaE2F9wPb
         uqmXqLNJdF0vEXU3sBnNhdNc8zMYtBif5/WBCwMdW9gEtY6XGegNUHvbQpJc6wLI3QLM
         DJrEFpsO2zF24Dq7iZ+QlQJvyU+4A25IXc/mp2Xtn0kBo2avMXCCiPcFpjVeZcfBo9ZJ
         YKVau7XZea5w7EENgDDHAySg1Fb/+PG0/LQqQm/AsQ/7v6sPQorfcdsGPQAbUFK1tdQE
         MNYkbKX3fqnaScBmRfrlXzt6ZcgCRZQFBSKBuvuTG7ENd3dsTcdcSEbGC7RY0NGduQtB
         QdTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DDYkWpxszNp2WM+zJ/kXHlyI7L/XFZkvww5qDq0WlIg=;
        b=XfHpxcADAtKUQtTgqMr4A8jOb6sW1AbhNIVoCo2JOMSANhTE8Qp4najj/pafyk2xHg
         tIHqV8VShspjwtBgjvUqvwVca9e6AJNprLlne3iR2SZaQHvcoiwbh9wH2+SwTQc6rq+5
         tUbSQB8iM3svorHhC1ol31PIQijnbZOzLWFDlnxEtjVP8ziUP5MmB7xPtw2IK9MhsQmt
         O+5xSH+IFhK0jpvBDqcqRk0ht7yiSlkXPmA+DeBTjuBBOx7ixtj4S+cuY2Qrur2ABTLZ
         PxCXfQPh8s4mvz2tPoyccbbUwemlVdo53t2dimHxg9GtyZYg5vjhqlpztky2PSw4DChs
         k5ww==
X-Gm-Message-State: APjAAAXJ6H9Pnw38AZv+8I2C04IueyG28twjZ0v7K0BISIzaDXFYVKU7
        d34TUOkBdm/ChI//19VpYeUwIkko0QH0PZBbAgLqgIiEOh0=
X-Google-Smtp-Source: APXvYqzjP7WsbG/TIUGoLEtj5TXYvcv92NBWYqYtgCYW/nXD97mvYWl88+heaOwg+Zs3RGmIa2nN2Ux3HTTvq2hBnfE=
X-Received: by 2002:a1c:64d6:: with SMTP id y205mr7706101wmb.136.1572104765228;
 Sat, 26 Oct 2019 08:46:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
 <20191024124833.4158-43-ard.biesheuvel@linaro.org> <b41df418-2e09-ac29-92cd-3910f0c05c50@arm.com>
 <CAKv+Gu8zW08_TKgvU4yHh=8E4_cnhx7iLoeOrYfmoy4m7ofwsA@mail.gmail.com>
 <20191025152534.GF31224@sasha-vm> <CAKv+Gu9_BtF2Zd9=9_wDukwKinmSMwes5R7Eu9jx315PQFk8dA@mail.gmail.com>
 <CAKv+Gu-2LXayWyP=3Eur_toGo4xqhENWeK6n+TCDcEy8xrKmXQ@mail.gmail.com>
 <20191026080121.GB554748@kroah.com> <20191026154020.GK31224@sasha-vm>
In-Reply-To: <20191026154020.GK31224@sasha-vm>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 26 Oct 2019 17:46:03 +0200
Message-ID: <CAKv+Gu86eKUFz0TKOZxMzTXrWtW7Sq8EyHdZ=vWSBxOeRWfhVg@mail.gmail.com>
Subject: Re: [PATCH for-stable-4.14 42/48] arm64: Always enable spectre-v2
 vulnerability detection
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <greg@kroah.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
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

On Sat, 26 Oct 2019 at 17:40, Sasha Levin <sashal@kernel.org> wrote:
>
> On Sat, Oct 26, 2019 at 10:01:21AM +0200, Greg KH wrote:
> >On Fri, Oct 25, 2019 at 05:39:44PM +0200, Ard Biesheuvel wrote:
> >> On Fri, 25 Oct 2019 at 17:28, Ard Biesheuvel <ard.biesheuvel@linaro.or=
g> wrote:
> >> >
> >> > On Fri, 25 Oct 2019 at 17:25, Sasha Levin <sashal@kernel.org> wrote:
> >> > >
> >> > > On Thu, Oct 24, 2019 at 04:37:12PM +0200, Ard Biesheuvel wrote:
> >> > > >On Thu, 24 Oct 2019 at 16:34, Alexandru Elisei <alexandru.elisei@=
arm.com> wrote:
> >> > > >>
> >> > > >> Hi,
> >> > > >>
> >> > > >> On 10/24/19 1:48 PM, Ard Biesheuvel wrote:
> >> > > >> > From: Jeremy Linton <jeremy.linton@arm.com>
> >> > > >> >
> >> > > >> > [ Upstream commit 8c1e3d2bb44cbb998cb28ff9a18f105fee7f1eb3 ]
> >> > > >> >
> >> > > >> > Ensure we are always able to detect whether or not the CPU is=
 affected
> >> > > >> > by Spectre-v2, so that we can later advertise this to userspa=
ce.
> >> > > >> >
> >> > > >> > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> >> > > >> > Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> >> > > >> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> >> > > >> > Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
> >> > > >> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> >> > > >> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> > > >> > ---
> >> > > >> >  arch/arm64/kernel/cpu_errata.c | 15 ++++++++-------
> >> > > >> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >> > > >> >
> >> > > >> > diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kern=
el/cpu_errata.c
> >> > > >> > index bf6d8aa9b45a..647c533cfd90 100644
> >> > > >> > --- a/arch/arm64/kernel/cpu_errata.c
> >> > > >> > +++ b/arch/arm64/kernel/cpu_errata.c
> >> > > >> > @@ -76,7 +76,6 @@ cpu_enable_trap_ctr_access(const struct arm=
64_cpu_capabilities *__unused)
> >> > > >> >       config_sctlr_el1(SCTLR_EL1_UCT, 0);
> >> > > >> >  }
> >> > > >> >
> >> > > >> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> >> > > >> >  #include <asm/mmu_context.h>
> >> > > >> >  #include <asm/cacheflush.h>
> >> > > >> >
> >> > > >> > @@ -217,11 +216,11 @@ static int detect_harden_bp_fw(void)
> >> > > >> >           ((midr & MIDR_CPU_MODEL_MASK) =3D=3D MIDR_QCOM_FALK=
OR_V1))
> >> > > >> >               cb =3D qcom_link_stack_sanitization;
> >> > > >> >
> >> > > >> > -     install_bp_hardening_cb(cb, smccc_start, smccc_end);
> >> > > >> > +     if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR))
> >> > > >> > +             install_bp_hardening_cb(cb, smccc_start, smccc_=
end);
> >> > > >> >
> >> > > >> >       return 1;
> >> > > >> >  }
> >> > > >> > -#endif       /* CONFIG_HARDEN_BRANCH_PREDICTOR */
> >> > > >> >
> >> > > >> >  DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required=
);
> >> > > >> >
> >> > > >> > @@ -457,7 +456,6 @@ static bool has_ssbd_mitigation(const str=
uct arm64_cpu_capabilities *entry,
> >> > > >> >       .type =3D ARM64_CPUCAP_LOCAL_CPU_ERRATUM,              =
   \
> >> > > >> >       CAP_MIDR_RANGE_LIST(midr_list)
> >> > > >> >
> >> > > >> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> >> > > >> >  /*
> >> > > >> >   * List of CPUs that do not need any Spectre-v2 mitigation a=
t all.
> >> > > >> >   */
> >> > > >> > @@ -489,6 +487,12 @@ check_branch_predictor(const struct arm6=
4_cpu_capabilities *entry, int scope)
> >> > > >> >       if (!need_wa)
> >> > > >> >               return false;
> >> > > >> >
> >> > > >> > +     if (!IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR)) {
> >> > > >> > +             pr_warn_once("spectrev2 mitigation disabled by =
kernel configuration\n");
> >> > > >> > +             __hardenbp_enab =3D false;
> >> > > >>
> >> > > >> This breaks when building, because __hardenbp_enab is declared =
in the next patch:
> >> > > >>
> >> > > >> $ make -j32 defconfig && make -j32
> >> > > >>
> >> > > >> [..]
> >> > > >> arch/arm64/kernel/cpu_errata.c: In function =E2=80=98check_bran=
ch_predictor=E2=80=99:
> >> > > >> arch/arm64/kernel/cpu_errata.c:492:3: error: =E2=80=98__hardenb=
p_enab=E2=80=99 undeclared (first
> >> > > >> use in this function)
> >> > > >>    __hardenbp_enab =3D false;
> >> > > >>    ^~~~~~~~~~~~~~~
> >> > > >> arch/arm64/kernel/cpu_errata.c:492:3: note: each undeclared ide=
ntifier is reported
> >> > > >> only once for each function it appears in
> >> > > >> make[1]: *** [scripts/Makefile.build:326: arch/arm64/kernel/cpu=
_errata.o] Error 1
> >> > > >> make[1]: *** Waiting for unfinished jobs....
> >> > > >>
> >> > > >
> >> > > >Indeed, but as discussed, this matches the state of both mainline=
 and
> >> > > >v4.19, which carry these patches in the same [wrong] order as wel=
l.
> >> > > >
> >> > > >Greg should confirm, but as I understand it, it is preferred to b=
e
> >> > > >bug-compatible with mainline rather than fixing problems when spo=
tting
> >> > > >them while doing the backport.
> >> > >
> >> > > Is it just patch ordering? If so I'd rather fix it, there's no rea=
son to
> >> > > carry this issue into the stable trees.
> >> > >
> >> > > We reserve "bug compatibility" for functional issues that are not =
yet
> >> > > fixed upstream, it doesn't seem to be the case here.
> >> > >
> >> >
> >> > The patches don't apply cleanly in the opposite order.
> >>
> >> What we could do is squash the two patches together. That way, we
> >> avoid the breakage without having to modify the patches in order to be
> >> able to apply them.
> >
> >No, don't do that.  Just take all of the needed commits.
>
> Right, just make the patches apply in reverse, this shouldn't be more
> than moving some code from the 2nd patch back to the 1st one, right?
>
> We usually don't do this in stable backports, but there are three good
> reasons to do it here:
>
> 1. It'll be nice to maintain bisectability.
> 2. The end result should be exactly the same, so there's no room for
> error here.
> 3. It's a backport for an older kernel to begin with, so there are
> changes from upstream already.
>

I really don't see the point of doing this for v4.14 while v4.19 and
mainline have the two patches in the opposite order.

Would you like me to resend the entire 48 piece series for this?
