Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36536B7F79
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 18:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjCMR1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 13:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCMR1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 13:27:44 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D157388D
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:27:09 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id v27so11674737vsa.7
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678728420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LKAQ9vOuh2KbA3c9Dmk/0KLdau6scnjMAijm65LwHDQ=;
        b=bFrBbd9MqoqKlf1DgxJOA+BZad7IJjXfnDtmNdGIvMWWZzPBWRyKirnvrmAP/kn1SO
         dPoF3gsxlTZI1AOU/bIL2ObFYQ3CJn0OSrfvzYNnhQvptRzTvvkKqRctcmljpPmFcxXZ
         /qS46H511O4zxtXRLEXiUOEJraFXS9j5skvYBGRKrlgjNAoqI74347EFc2V6Rx6EMx3O
         jZtNaAcdWrQYPZBnGTFMvh3682X6/x12D35XAuJnww2ew/HArrdrucosNn2yLE7st4mp
         vzO/9I8tW/dIOyiMcJMmo1BYKQY6EFWL/9ye+/PUA7HEipzX6FaHfCYwU2kqU0WZKSQg
         lTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678728420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LKAQ9vOuh2KbA3c9Dmk/0KLdau6scnjMAijm65LwHDQ=;
        b=33nC6eiZeoApSgJeHb3tXmWa7c2CRMJJxwTB1X5orgyOGkecq9+LuyGXBcFmIRBC0m
         whp65Mt6dL96KSlB782Og6TEEF4V9oFrXsRL2KNeoK1QxRz1WtGj0DiNKZO0F9Bp2l/2
         LT7ZVoPpzLMTY7fAr67wcTIPNr8DIwMu1RY6aBs5lYEmRedQJggSjOWPHeZDXr7frnLj
         Qr7vWFHfg5mKLL8OUT6SU04QAH5KktexkfJL1XY+726yTzR/Syd8hDFj6Tk33oTEd4cF
         RS8opCswKInGuFFcAd7lmrFG+aWSJLhSQFoD7ZJmhIjfxdU0D+kjZMbWLfb49hL8CPWL
         nYlA==
X-Gm-Message-State: AO0yUKW/mFUKK5NbkukEWLmThFGdY09ayl1az47Ofwzcvu+G4xwN5QfS
        ilLof8ASeew84kkbJ4T9CSDskXtMc4MjWU3sOGsBGw==
X-Google-Smtp-Source: AK7set+zFXTcBkpbscHx01ebZLKXIBXMOwslWE6/EuYSMnF7TkuGSMjDEta44Nky4LY+x1Soyzr9BWRcwRkI0Eq1Mo4=
X-Received: by 2002:a67:f350:0:b0:423:e6b4:9582 with SMTP id
 p16-20020a67f350000000b00423e6b49582mr4032552vsm.4.1678728419924; Mon, 13 Mar
 2023 10:26:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230313091425.1962708-1-maz@kernel.org> <20230313091425.1962708-2-maz@kernel.org>
 <ZA9HAQtkCDwFXcsm@google.com> <CALzav=c3aKNT-7CzkrFC8YCCwj-E16JYWwsmOV-HaLbODG67hQ@mail.gmail.com>
 <ZA9bhVQBtgES7Qqi@google.com>
In-Reply-To: <ZA9bhVQBtgES7Qqi@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 13 Mar 2023 10:26:33 -0700
Message-ID: <CALzav=dx=nAL=kW0fvtuHdj0T68VXSs7dnsVMB7qQcHo6v5mVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disable interrupts while walking
 userspace PTs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 10:21=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Mar 13, 2023, David Matlack wrote:
> > On Mon, Mar 13, 2023 at 8:53=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > +David
> > >
> > > On Mon, Mar 13, 2023, Marc Zyngier wrote:
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 7113587222ff..d7b8b25942df 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -666,14 +666,23 @@ static int get_user_mapping_size(struct kvm *=
kvm, u64 addr)
> > > >                                  CONFIG_PGTABLE_LEVELS),
> > > >               .mm_ops         =3D &kvm_user_mm_ops,
> > > >       };
> > > > +     unsigned long flags;
> > > >       kvm_pte_t pte =3D 0;      /* Keep GCC quiet... */
> > > >       u32 level =3D ~0;
> > > >       int ret;
> > > >
> > > > +     /*
> > > > +      * Disable IRQs so that we hazard against a concurrent
> > > > +      * teardown of the userspace page tables (which relies on
> > > > +      * IPI-ing threads).
> > > > +      */
> > > > +     local_irq_save(flags);
> > > >       ret =3D kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
> > > > -     VM_BUG_ON(ret);
> > > > -     VM_BUG_ON(level >=3D KVM_PGTABLE_MAX_LEVELS);
> > > > -     VM_BUG_ON(!(pte & PTE_VALID));
> > > > +     local_irq_restore(flags);
> > > > +
> > > > +     /* Oops, the userspace PTs are gone... */
> > > > +     if (ret || level >=3D KVM_PGTABLE_MAX_LEVELS || !(pte & PTE_V=
ALID))
> > > > +             return -EFAULT;
> > >
> > > I don't think this should return -EFAULT all the way out to userspace=
.  Unless
> > > arm64 differs from x86 in terms of how the userspace page tables are =
managed, not
> > > having a valid translation _right now_ doesn't mean that one can't be=
 created in
> > > the future, e.g. by way of a subsequent hva_to_pfn().
> > >
> > > FWIW, the approach x86 takes is to install a 4KiB (smallest granuale)=
 translation,
> >
> > If I'm reading the ARM code correctly, returning -EFAULT here will
> > have that effect. get_user_mapping_size() is only called by
> > transparent_hugepage_adjust() which returns PAGE_SIZE if
> > get_user_mapping_size() returns anything less than PMD_SIZE.
>
> No, this patch adds
>
> +               int sz =3D get_user_mapping_size(kvm, hva);
> +
> +               if (sz < 0)
> +                       return sz;
> +
> +               if (sz < PMD_SIZE)
> +                       return PAGE_SIZE;
> +

Gah, I just looked at the trimmed patch in the reply. Thanks for
pointing that out.
