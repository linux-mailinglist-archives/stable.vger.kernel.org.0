Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52ADB525069
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 16:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351321AbiELOki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 10:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355478AbiELOk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 10:40:29 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602B12608F7
        for <stable@vger.kernel.org>; Thu, 12 May 2022 07:40:28 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id e194so5510380iof.11
        for <stable@vger.kernel.org>; Thu, 12 May 2022 07:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tsPOjGZkV1TRXRSZHVdMkg4WSWe9S/brR44ecalBW+Y=;
        b=A0esQkq9PHwmQSISlQbpNaX5qgKu73+heQ3oCIbowIY9dgZmOqSX7N55l0ncpfh4CV
         xKyEy46M9CJgE+mIN4M04NHOu/ErbReQwc9IQGoYnU/7+SC4vlDkEIuCy4X6xN1/eeEV
         cFuHk618dZNLO91IRCELZoBer/LE/Bcsii2GNr0nyriwf8BdP/EFyFnYQAbpFTp9jpx7
         ICttUv651EnD5OLy6eCNl6etkGvEutLh228oT27gWiI7GDAPt7dGDLY2gsiyAaQjdonf
         m8HjNYZC9ossttYOWs6ZAMITHXF9C+qkq3lrfJUcRMEdhxyC7I34Q/W10C3YpR/JAVlz
         J/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tsPOjGZkV1TRXRSZHVdMkg4WSWe9S/brR44ecalBW+Y=;
        b=t8PUPsg8qt/DdiucxOd+suVFCt6mhRGVB2p5OoNkONGYMj+Jb2UNPzahMTkfPr7XNa
         XH/Sa+F7UXRDINDZCg/evjVyaBen25GXTc8Hj1c+WyY3PKlyVgy0Ls0UJrqealblnGTN
         qsVaXxOxRPFD870LPGgf04/j+WC4ZBF0tyYztEJRGy/e1llg+qAQxA/ujX3QDns9rDxu
         +TVExP1BH/roeXgjZGz/QtJ1l+TZ+DU1/2kpf1A0ov94+nYxoXkRStaYH4Ct94aT/HLH
         fQJ1aeNxKjNdxFaXhBsleSsDIV6ADe7+tccKQ4tgDEFGXH4oWkisrhM4yVUZ7utJhuZG
         yqGg==
X-Gm-Message-State: AOAM531RE4pI3l5cQjxZ+nUbP3kmHNYvInMdwtN/dXAgOU79hjcPvDf7
        n3r8ULv2m7ahSSxiK6vaIDhD/vbDUOXXbpLmVvXoFOTIITruMw==
X-Google-Smtp-Source: ABdhPJwmPP2LZSKrgUfRxTEvzrEVkaP3cD7YWuanlJpIU3C/Pbc2U7VtOGJeSH9MVC2CBT33UdedT5BUu9sGwkTEnYk=
X-Received: by 2002:a05:6638:1515:b0:32b:eb62:97c8 with SMTP id
 b21-20020a056638151500b0032beb6297c8mr147705jat.61.1652366427691; Thu, 12 May
 2022 07:40:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220508165434.119000-1-khuey@kylehuey.com> <29767a7d-d887-1a0c-296e-5bed220f1c9e@redhat.com>
 <YnpOZAfLdJ6cj5b9@kroah.com> <YnpOsDgrwCBsMs35@kroah.com> <CAP045Aq6vJxMJaVFjAX7gqQkBbMRArZJhea3U6LJVQEQB9Ea4Q@mail.gmail.com>
 <CAP045AoFcMeJBH7SWbLFJMYymqPJNKz9PDaYSwhSHYfbeByP8Q@mail.gmail.com> <Yn0QIxxeHFc8BIw6@kroah.com>
In-Reply-To: <Yn0QIxxeHFc8BIw6@kroah.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Thu, 12 May 2022 07:40:15 -0700
Message-ID: <CAP045Ap-N6pCP3vo-Ar5wSDnFUkKnfhnL+W9TKCfwYnQbhobZA@mail.gmail.com>
Subject: Re: [PATCH 5.4] KVM: x86/svm: Account for family 17h event
 renumberings in amd_pmc_perf_hw_id
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        "Robert O'Callahan" <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 6:48 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, May 10, 2022 at 09:01:32AM -0700, Kyle Huey wrote:
> > On Tue, May 10, 2022 at 6:11 AM Kyle Huey <me@kylehuey.com> wrote:
> > >
> > > On Tue, May 10, 2022 at 4:38 AM Greg KH <gregkh@linuxfoundation.org> =
wrote:
> > > >
> > > > On Tue, May 10, 2022 at 01:37:08PM +0200, Greg KH wrote:
> > > > > On Mon, May 09, 2022 at 01:41:20PM +0200, Paolo Bonzini wrote:
> > > > > > On 5/8/22 18:54, Kyle Huey wrote:
> > > > > > > From: Kyle Huey <me@kylehuey.com>
> > > > > > >
> > > > > > > commit 5eb849322d7f7ae9d5c587c7bc3b4f7c6872cd2f upstream
> > > > > > >
> > > > > > > Zen renumbered some of the performance counters that correspo=
nd to the
> > > > > > > well known events in perf_hw_id. This code in KVM was never u=
pdated for
> > > > > > > that, so guest that attempt to use counters on Zen that corre=
spond to the
> > > > > > > pre-Zen perf_hw_id values will silently receive the wrong val=
ues.
> > > > > > >
> > > > > > > This has been observed in the wild with rr[0] when running in=
 Zen 3
> > > > > > > guests. rr uses the retired conditional branch counter 00d1 w=
hich is
> > > > > > > incorrectly recognized by KVM as PERF_COUNT_HW_STALLED_CYCLES=
_BACKEND.
> > > > > > >
> > > > > > > [0] https://rr-project.org/
> > > > > > >
> > > > > > > Signed-off-by: Kyle Huey <me@kylehuey.com>
> > > > > > > Message-Id: <20220503050136.86298-1-khuey@kylehuey.com>
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > [Check guest family, not host. - Paolo]
> > > > > > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > > [Backport to 5.4: adjusted context]
> > > > > > > Signed-off-by: Kyle Huey <me@kylehuey.com>
> > > > > > > ---
> > > > > > >   arch/x86/kvm/pmu_amd.c | 28 +++++++++++++++++++++++++---
> > > > > > >   1 file changed, 25 insertions(+), 3 deletions(-)
> > > > > > >
> > > > > > > diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
> > > > > > > index 6bc656abbe66..3ccfd1abcbad 100644
> > > > > > > --- a/arch/x86/kvm/pmu_amd.c
> > > > > > > +++ b/arch/x86/kvm/pmu_amd.c
> > > > > > > @@ -44,6 +44,22 @@ static struct kvm_event_hw_type_mapping am=
d_event_mapping[] =3D {
> > > > > > >           [7] =3D { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_=
BACKEND },
> > > > > > >   };
> > > > > > > +/* duplicated from amd_f17h_perfmon_event_map. */
> > > > > > > +static struct kvm_event_hw_type_mapping amd_f17h_event_mappi=
ng[] =3D {
> > > > > > > + [0] =3D { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
> > > > > > > + [1] =3D { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
> > > > > > > + [2] =3D { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
> > > > > > > + [3] =3D { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
> > > > > > > + [4] =3D { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
> > > > > > > + [5] =3D { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> > > > > > > + [6] =3D { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND=
 },
> > > > > > > + [7] =3D { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND =
},
> > > > > > > +};
> > > > > > > +
> > > > > > > +/* amd_pmc_perf_hw_id depends on these being the same size *=
/
> > > > > > > +static_assert(ARRAY_SIZE(amd_event_mapping) =3D=3D
> > > > > > > +      ARRAY_SIZE(amd_f17h_event_mapping));
> > > > > > > +
> > > > > > >   static unsigned int get_msr_base(struct kvm_pmu *pmu, enum =
pmu_type type)
> > > > > > >   {
> > > > > > >           struct kvm_vcpu *vcpu =3D pmu_to_vcpu(pmu);
> > > > > > > @@ -130,17 +146,23 @@ static unsigned amd_find_arch_event(str=
uct kvm_pmu *pmu,
> > > > > > >                                       u8 event_select,
> > > > > > >                                       u8 unit_mask)
> > > > > > >   {
> > > > > > > + struct kvm_event_hw_type_mapping *event_mapping;
> > > > > > >           int i;
> > > > > > > + if (guest_cpuid_family(pmc->vcpu) >=3D 0x17)
> > > > > > > +         event_mapping =3D amd_f17h_event_mapping;
> > > > > > > + else
> > > > > > > +         event_mapping =3D amd_event_mapping;
> > > > > > > +
> > > > > > >           for (i =3D 0; i < ARRAY_SIZE(amd_event_mapping); i+=
+)
> > > > > > > -         if (amd_event_mapping[i].eventsel =3D=3D event_sele=
ct
> > > > > > > -             && amd_event_mapping[i].unit_mask =3D=3D unit_m=
ask)
> > > > > > > +         if (event_mapping[i].eventsel =3D=3D event_select
> > > > > > > +             && event_mapping[i].unit_mask =3D=3D unit_mask)
> > > > > > >                           break;
> > > > > > >           if (i =3D=3D ARRAY_SIZE(amd_event_mapping))
> > > > > > >                   return PERF_COUNT_HW_MAX;
> > > > > > > - return amd_event_mapping[i].event_type;
> > > > > > > + return event_mapping[i].event_type;
> > > > > > >   }
> > > > > > >   /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed event=
s */
> > > > > >
> > > > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > > >
> > > > > > Thanks,
> > > > > >
> > > > > > Paolo
> > > > > >
> > > > >
> > > > > Wait, how was this tested?
> > > > >
> > > > > It breaks the build:
> > > > >
> > > > > arch/x86/kvm/pmu_amd.c: In function =E2=80=98amd_find_arch_event=
=E2=80=99:
> > > > > arch/x86/kvm/pmu_amd.c:152:32: error: =E2=80=98pmc=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98pmu=E2=80=99?
> > > > >   152 |         if (guest_cpuid_family(pmc->vcpu) >=3D 0x17)
> > > > >       |                                ^~~
> > > > >       |                                pmu
> > > > >
> > > > >
> > > > > I'll do the obvious fixup, but this is odd.  Always at least test=
-build
> > > > > your changes...
> > > >
> > > > Hm, no, I don't know what the correct fix is here.  I'll wait for a
> > > > fixed up (and tested) patch to be resubmited please.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > Sorry, I tested an earlier version without the guest_cpuid_family fix
> > > that Paolo made when he committed my patch, and of course that's the
> > > hang up here. I'll get this fixed up for you.
> > >
> > > - Kyle
> >
> > Hi Greg,
> >
> > I've just sent a backport of Like Xu's "KVM: x86/pmu: Refactoring
> > find_arch_event() to pmc_perf_hw_id()" for 5.4. It had to be trivially
> > adjusted because kvm_x86_ops is a pointer on pre-5.7 kernels.
> >
> > After you apply that, the patch that you applied here for 5.10 will
> > apply to 5.4.
>
> I do not know what I "applied here" at all, sorry.  Please realize we
> deal with hundreds of stable patches a week.
>
> Please send me a patch series of what I needs to be applied and I will
> be glad to queue them up.

Alright, I sent you the one remaining patch for 5.4 in a separate thread.

- Kyle

> thanks,
>
> greg k-h
