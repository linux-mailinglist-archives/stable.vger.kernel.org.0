Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5870A3603DB
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 10:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhDOIHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 04:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhDOIHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 04:07:00 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03741C061574;
        Thu, 15 Apr 2021 01:06:38 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id 6so19441284ilt.9;
        Thu, 15 Apr 2021 01:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQjML/19fS2KYb4gv13QovtbXXbNQiltUsF/J2T/nMk=;
        b=VtbzxXkkAQY51C48ZXBSjT+nti+po3LqJUEy1wpMjLi58hxNwIaNtiCA9dv7Nzw9AE
         WBJMJsjjn/7WmpuXgnXRY89V2hPw8ls7xUGrR3omEi5NpuTAhqcqSfvkFmRGJwELxAnZ
         kdvS78Dr+GDGPhu45Lc6YPevgqIr0LQKWl2TaVKBLT4+onwEJeRN+nexea2Xn58yBRNj
         Q9+UO8OTOBod5mgj8l4W2SHZET0jwREFbC92Hpm5Cm7cwhR0KG1lcweSHBs0hZynXjFa
         RmrCR+UZaKXVHeOXgpI+V98lOOzRaa5OZHXPnOBvgi7RDjXvmts+Ukk93vzQvPs7/Ql3
         ikBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQjML/19fS2KYb4gv13QovtbXXbNQiltUsF/J2T/nMk=;
        b=lAQBm9MFv+1V13jOFzFCq41dR+qMPi4QMeiBWTGlznkTEH7JWInOQpsAuLiVgWMFY5
         iCCi6BC8vtX+531SzK1dHUJHFYNzz79PaKyDTYbd73PuTWkoagTINiumMHmWx+bh9h4G
         JFLMzqDelkDKeqpGnNm2cMytaKwgYwgHm2qm6W8PNebSEpkAnNujFEftf4BKgyIECQEP
         m2RSXBvk1LyVzqcRLZHlhRleLPVsW7vHqi9SglavhcbZntjSaQq9cANA1CJBNfHwdIYW
         WDU18Oyt8XEWu50hEvxqLV/BsmBTX0puaQZWOPfNkwsYiek1X44iTxo6v6SBbuYmeB9L
         ce2A==
X-Gm-Message-State: AOAM531F0FyJpy/rmosIJJh6KNaqaLcTys60h5CiJERdydRySKnfKxnV
        a9Wy5nsJWuQf1QZOtMHmiXMHoYoLhCX8VNckxNQ=
X-Google-Smtp-Source: ABdhPJyg0LaNjQ9QuiIOCdf+zmUHw145GSPPkmdZIEUUSfLsySMUTdMHe7e43fw1bqPQ2tUDo71PTwZSHuMv+5HzU14=
X-Received: by 2002:a05:6e02:1282:: with SMTP id y2mr1862926ilq.308.1618473997519;
 Thu, 15 Apr 2021 01:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201127112114.3219360-1-pbonzini@redhat.com> <20201127112114.3219360-3-pbonzini@redhat.com>
 <CAJhGHyCdqgtvK98_KieG-8MUfg1Jghd+H99q+FkgL0ZuqnvuAw@mail.gmail.com>
 <YHS/BxMiO6I1VOEY@google.com> <CAJhGHyAcnwkCfTcnxXcgAHnF=wPbH2EDp7H+e74ce+oNOWJ=_Q@mail.gmail.com>
 <80b013dc-0078-76f4-1299-3cff261ef7d8@redhat.com> <CAJhGHyChfXdcAMzzD7P3aC8tnhFW5GvOt88vOY=D3pyb7hgNAA@mail.gmail.com>
 <6d9dafb1-b8ff-82ef-93dc-da869fe7ba0f@redhat.com> <CAJhGHyA=v_va2QTvo7Ve8JyZO4j5LjiCdB9CLnvRXGwGwa3e+A@mail.gmail.com>
 <5b422691-ffc5-d73a-1bda-f1ee61116756@redhat.com>
In-Reply-To: <5b422691-ffc5-d73a-1bda-f1ee61116756@redhat.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Thu, 15 Apr 2021 16:06:26 +0800
Message-ID: <CAJhGHyAM6e_XW7iTgYZ3CBv_ANUx4cAZh8+Hq7uXyM6OT1Sf8Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Fix split-irqchip vs interrupt injection
 window request
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "v4.7+" <stable@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 2:07 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 15/04/21 02:59, Lai Jiangshan wrote:
> > The next call to inject_pending_event() will reach here AT FIRST with
> > vcpu->arch.exception.injected==false and vcpu->arch.exception.pending==false
> >
> >>           ... if (!vcpu->arch.exception.pending) {
> >>                   if (vcpu->arch.nmi_injected) {
> >>                           static_call(kvm_x86_set_nmi)(vcpu);
> >>                           can_inject = false;
> >>                   } else if (vcpu->arch.interrupt.injected) {
> >>                           static_call(kvm_x86_set_irq)(vcpu);
> >>                           can_inject = false;
> >
> > And comes here and vcpu->arch.interrupt.injected is true for there is
> > an interrupt queued by KVM_INTERRUPT for pure user irqchip. It then does
> > the injection of the interrupt without checking the EFLAGS.IF.
>
> Ok, understood now.  Yeah, that could be a problem for userspace irqchip
> so we should switch it to use pending_external_vector instead.  Are you
> going to write the patch or should I?
>

I wish you do it.  I haven't figured out how to write a clean test for
it and confirm it in upstream.  But I will backport your patch and test it.

My fix is changing the behavior back to before 664f8e26b00c7 where
arch.exception.pending=true would prevent ready_for_interrupt_injection
to be non-zero.  So that KVM_INTERRUPT maintains the original behavior
that it can immediately inject IRQ into guests. (Userspace may regret
an unearthly injected IRQ for it has no right to revise the IRQ or cancel
it.)  But your fix will unify the behaviors of all kinds of irqchips.

Thanks
Lai


> Thanks!
>
> Paolo
>
> > My question is that what stops the next call to inject_pending_event()
> > to reach here when KVM_INTERRUPT is called with exepction pending.
>
