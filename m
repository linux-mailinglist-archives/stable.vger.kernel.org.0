Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A569294FEF
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 17:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502465AbgJUPX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 11:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502253AbgJUPX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 11:23:57 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49347C0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 08:23:57 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id b23so1675779pgb.3
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 08:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=xRwf4DqoMUvHNwkwB3XZH8t7Lnkw92COkggpTduZ+jA=;
        b=f5OT90S3NNEZJYktsRffHk7/rB2owOU/c/N9NOViJaDLwvuEKEtqmxWfktPXLFhtRR
         e2LPqLiYNzQdFE9jdVe2Jvn3UWFsyazCYvHtdSGU98rB20V9Px0OBRoaulyXzRHym5nl
         6+bsTaWjCcMHHocYXnPu6Fi+tEAwEoggtKXew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=xRwf4DqoMUvHNwkwB3XZH8t7Lnkw92COkggpTduZ+jA=;
        b=NCS3Vn6KNKuJaoHiXYrvXTQm/HUodUmt7llq1rTQyk9KX5ORxupZAVvrdfdrmSKXFH
         /A877Ld6zUZiZk+A+Hn/Y3pfvdtw8BfU5TZi7SRr5RIeML5BKBrEecrh6o1WrljeRd/L
         vflYHYUqMyBDy2JsS3WG6ywIJKfX/uEL1ahO+VdQAL6FXQay8AhPy3jaZXFRV68IlNnb
         BN9tmDJNcc+mdHJqJBUp+RbjnrlEikLj0NzNmYgU5QV28k8hB/mSIF5yn0ZCrz1YzAiW
         MdsNEFvhMRDQVgwpqcSl6CrfnxrYUdENQjxFjs8i2AAuD9/nw/lnCkeg3rt6WdWBfiTQ
         djbA==
X-Gm-Message-State: AOAM533WtPzGDvGWSbXJnNDP0B9D5iO+LJ71NvQNgn9aWdjlyl87D7ru
        9CYE7/897Dloce6NFvuCvIzJtA==
X-Google-Smtp-Source: ABdhPJwt51nNoKa4JQW4NJKHdHhGHVnSfPJkAa5O/BNFYPCTK14wy34SaToysRnSlcpNeZksQW51Pw==
X-Received: by 2002:a65:5b09:: with SMTP id y9mr3739101pgq.155.1603293836817;
        Wed, 21 Oct 2020 08:23:56 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:201:3e52:82ff:fe6c:83ab])
        by smtp.gmail.com with ESMTPSA id w19sm2647509pfn.174.2020.10.21.08.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 08:23:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201021075722.GA17230@willie-the-truck>
References: <20201020214544.3206838-1-swboyd@chromium.org> <20201020214544.3206838-2-swboyd@chromium.org> <20201021075722.GA17230@willie-the-truck>
Subject: Re: [PATCH 1/2] arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
To:     Will Deacon <will@kernel.org>
Date:   Wed, 21 Oct 2020 08:23:54 -0700
Message-ID: <160329383454.884498.3396883189907056188@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Will Deacon (2020-10-21 00:57:23)
> On Tue, Oct 20, 2020 at 02:45:43PM -0700, Stephen Boyd wrote:
> > According to the SMCCC spec (7.5.2 Discovery) the
> > ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
> > SMCCC_RET_NOT_SUPPORTED corresponding to "workaround required",
> > "workaround not required but implemented", and "who knows, you're on
> > your own" respectively. For kvm hypercalls (hvc), we've implemented this
> > function id to return SMCCC_RET_NOT_SUPPORTED, 1, and
> > SMCCC_RET_NOT_REQUIRED. The SMCCC_RET_NOT_REQUIRED return value is not a
> > thing for this function id, and is probably copy/pasted from the
> > SMCCC_ARCH_WORKAROUND_2 function id that does support it.
> >=20
> > Clean this up by returning 0, 1, and SMCCC_RET_NOT_SUPPORTED
> > appropriately. Changing this exposes the problem that
> > spectre_v2_get_cpu_fw_mitigation_state() assumes a
> > SMCCC_RET_NOT_SUPPORTED return value means we are vulnerable, but really
> > it means we have no idea and should assume we can't do anything about
> > mitigation. Put another way, it better be unaffected because it can't be
> > mitigated in the firmware (in this case kvm) as the call isn't
> > implemented!
> >=20
> > Cc: Andre Przywara <andre.przywara@arm.com>
> > Cc: Steven Price <steven.price@arm.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: stable@vger.kernel.org
> > Fixes: c118bbb52743 ("arm64: KVM: Propagate full Spectre v2 workaround =
state to KVM guests")
> > Fixes: 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or lac=
k thereof")
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >=20
> > This will require a slightly different backport to stable kernels, but
> > at least it looks like this is a problem given that this return value
> > isn't valid per the spec and we've been going around it by returning
> > something invalid for some time.
> >=20
> >  arch/arm64/kernel/proton-pack.c | 3 +--
> >  arch/arm64/kvm/hypercalls.c     | 2 +-
> >  2 files changed, 2 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton=
-pack.c
> > index 68b710f1b43f..00bd54f63f4f 100644
> > --- a/arch/arm64/kernel/proton-pack.c
> > +++ b/arch/arm64/kernel/proton-pack.c
> > @@ -149,10 +149,9 @@ static enum mitigation_state spectre_v2_get_cpu_fw=
_mitigation_state(void)
> >       case SMCCC_RET_SUCCESS:
> >               return SPECTRE_MITIGATED;
> >       case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
> > +     case SMCCC_RET_NOT_SUPPORTED: /* Good luck w/ the Gatekeeper of G=
ozer */
> >               return SPECTRE_UNAFFECTED;
>=20
> Hmm, I'm not sure this is correct. The SMCCC spec is terrifically
> unhelpful:
>=20
>   NOT_SUPPORTED:
>   Either:
>   * None of the PEs in the system require firmware mitigation for CVE-201=
7-5715.
>   * The system contains at least 1 PE affected by CVE-2017-5715 that has =
no firmware
>     mitigation available.
>   * The firmware does not provide any information about whether firmware =
mitigation is
>     required.
>=20
> so we can't tell whether the thing is vulnerable or not in this case, and
> have to assume that it is.

If I'm reading the TF-A code correctly it looks like this will return
SMC_UNK if the platform decides that "This flag can be set to 0 by the
platform if none of the PEs in the system need the workaround." Where
the flag is WORKAROUND_CVE_2017_5715 and the call handler returns 1 if
the errata doesn't apply but the config is enabled, 0 if the errata
applies and the config is enabled, or SMC_UNK (I guess this is
NOT_SUPPORTED?) if the config is disabled[2].

So TF-A could disable this config and then the kernel would think it is
vulnerable when it actually isn't? The spec is a pile of ectoplasma
here.

>=20
> >       default:
> > -             fallthrough;
> > -     case SMCCC_RET_NOT_SUPPORTED:
> >               return SPECTRE_VULNERABLE;
> >       }
> >  }
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 9824025ccc5c..868486957808 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -31,7 +31,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >                               val =3D SMCCC_RET_SUCCESS;
> >                               break;
> >                       case SPECTRE_UNAFFECTED:
> > -                             val =3D SMCCC_RET_NOT_REQUIRED;
> > +                             val =3D SMCCC_RET_NOT_SUPPORTED;
>=20
> Which means we need to return SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED here, I
> suppose?
>=20

Does the kernel implement a workaround in the case that no guest PE is
affected? If so then returning 1 sounds OK to me, but otherwise
NOT_SUPPORTED should work per the spec.

[1] https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git/tree/docs/d=
esign/cpu-specific-build-macros.rst#n14
[2] https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git/tree/servic=
es/arm_arch_svc/arm_arch_svc_setup.c#n30
