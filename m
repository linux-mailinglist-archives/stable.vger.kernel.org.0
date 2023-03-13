Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3666B7F59
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 18:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCMRX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 13:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjCMRW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 13:22:57 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2407301D
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:22:07 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id t11-20020a170902e84b00b0019e399b2efaso7521404plg.11
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678728071;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6T1FQzdq6ySi1rIwhJyo74NnzXWN8IL63XLJcIURd30=;
        b=NCrllu0cypSlyHtfYfnDii1y8LyzSvcc2SYpEkINqE5iKRucAG5Swb2pBV5/VHDqJp
         k15ND+xGJzBoEqpqPJnBxygkn2p7oF3VYUZHqjJ+HRSc02ZHRiOrGVZMB9AovrMKQRAw
         LuE3+eFR/EW9HvUCuLcAvpG1+SK+QPGeNLlNON/OPmFpnL3RViya8NRf3AA/hxxwGwib
         qgn7TYoyPKMnMc3GfvBgnOW7WnMa2a8PVnjOqJHFbRsXt3WLmXB9O9R6s0O+h2lvGOO7
         YDqzbMQf6oBxCMTBVuHREGXQHz3euArR6zCyckO+3M1EmdWnXUKYMa7kheZ4k9cK+yu1
         eifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678728071;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6T1FQzdq6ySi1rIwhJyo74NnzXWN8IL63XLJcIURd30=;
        b=GBecJdMLNo7U55gTYhs2F8fcXg3K19jJ4ZyJ+9girVY8RAuSTGS5sc/aiUAcvY0lXC
         hvAk5v7LDmNAFV7MxkbMLdujG1qht0TgZrvU4CbLCKBF9v+IefmozytxfI5uy1r1vzKB
         7vhkaKAF4LTpYqg1w48GC2Mx7bA/3BnDEZiaoB4/C0JZAnibr/Lfnw21B6gqGGCJDOsd
         ERqgLQLpEGWNd1kmMrvYe3L6wqpHy8rFr+RCQn9xox7cGUquQ0FFzNvF0qffMubl/L7x
         vPRkcrGnJbYHU008EcBogLmoIyfiH9LTHQaAACx+H7FD4pyOe3ex1zD5iBSFG4DEOyzP
         iwgw==
X-Gm-Message-State: AO0yUKX4QubgG4Wk5xbPC2Myht3bwtzbpI4C6bVvNJZ9lA1X4XNB2Yll
        Emt5J16dmyvJ4/xpEkI3CjbqMSoVBNw=
X-Google-Smtp-Source: AK7set8B3CeFNCeFlI5qCMlp/uO9ITN1guOuZisHUyY14k69LU+SjjJ6+snECmGiZWES/zdYV86/vdKAdjA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2136:b0:590:3182:7ac3 with SMTP id
 n22-20020a056a00213600b0059031827ac3mr13418688pfj.0.1678728071185; Mon, 13
 Mar 2023 10:21:11 -0700 (PDT)
Date:   Mon, 13 Mar 2023 10:21:09 -0700
In-Reply-To: <CALzav=c3aKNT-7CzkrFC8YCCwj-E16JYWwsmOV-HaLbODG67hQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230313091425.1962708-1-maz@kernel.org> <20230313091425.1962708-2-maz@kernel.org>
 <ZA9HAQtkCDwFXcsm@google.com> <CALzav=c3aKNT-7CzkrFC8YCCwj-E16JYWwsmOV-HaLbODG67hQ@mail.gmail.com>
Message-ID: <ZA9bhVQBtgES7Qqi@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disable interrupts while walking
 userspace PTs
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023, David Matlack wrote:
> On Mon, Mar 13, 2023 at 8:53=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > +David
> >
> > On Mon, Mar 13, 2023, Marc Zyngier wrote:
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 7113587222ff..d7b8b25942df 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -666,14 +666,23 @@ static int get_user_mapping_size(struct kvm *kv=
m, u64 addr)
> > >                                  CONFIG_PGTABLE_LEVELS),
> > >               .mm_ops         =3D &kvm_user_mm_ops,
> > >       };
> > > +     unsigned long flags;
> > >       kvm_pte_t pte =3D 0;      /* Keep GCC quiet... */
> > >       u32 level =3D ~0;
> > >       int ret;
> > >
> > > +     /*
> > > +      * Disable IRQs so that we hazard against a concurrent
> > > +      * teardown of the userspace page tables (which relies on
> > > +      * IPI-ing threads).
> > > +      */
> > > +     local_irq_save(flags);
> > >       ret =3D kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
> > > -     VM_BUG_ON(ret);
> > > -     VM_BUG_ON(level >=3D KVM_PGTABLE_MAX_LEVELS);
> > > -     VM_BUG_ON(!(pte & PTE_VALID));
> > > +     local_irq_restore(flags);
> > > +
> > > +     /* Oops, the userspace PTs are gone... */
> > > +     if (ret || level >=3D KVM_PGTABLE_MAX_LEVELS || !(pte & PTE_VAL=
ID))
> > > +             return -EFAULT;
> >
> > I don't think this should return -EFAULT all the way out to userspace. =
 Unless
> > arm64 differs from x86 in terms of how the userspace page tables are ma=
naged, not
> > having a valid translation _right now_ doesn't mean that one can't be c=
reated in
> > the future, e.g. by way of a subsequent hva_to_pfn().
> >
> > FWIW, the approach x86 takes is to install a 4KiB (smallest granuale) t=
ranslation,
>=20
> If I'm reading the ARM code correctly, returning -EFAULT here will
> have that effect. get_user_mapping_size() is only called by
> transparent_hugepage_adjust() which returns PAGE_SIZE if
> get_user_mapping_size() returns anything less than PMD_SIZE.

No, this patch adds

+               int sz =3D get_user_mapping_size(kvm, hva);
+
+               if (sz < 0)
+                       return sz;
+
+               if (sz < PMD_SIZE)
+                       return PAGE_SIZE;
+

and=20

                        vma_pagesize =3D transparent_hugepage_adjust(kvm, m=
emslot,
                                                                   hva, &pf=
n,
                                                                   &fault_i=
pa);
+
+               if (vma_pagesize < 0) {
+                       ret =3D vma_pagesize;
+                       goto out_unlock;
+               }
