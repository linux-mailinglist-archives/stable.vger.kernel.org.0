Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A3235FF1C
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 03:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhDOA7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 20:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhDOA7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 20:59:43 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7C8C061574;
        Wed, 14 Apr 2021 17:59:21 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p8so1164513iol.11;
        Wed, 14 Apr 2021 17:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MlWKABH2GBAXTBEFNgkeH520s5m+9L7trkfahPYAnUs=;
        b=D6dg/gq1roNisWaVaa20wOSDiOyxuGO7NQIp40zuPtkoC3Tf8n3DdsNQSSG/8tZ5w0
         /ehX2Ou5WWUVl/2Qb6ptPXAjjMOgfy4mW3T1CHAwSUxt6TzR21NYxhlV9pFb6QMhWloO
         2znnc9Sr1cvc8r1qSYA4M0hTLhWd/IquiyvNts//2AN8XyBfcSyMJo7p9Lin5uq+jDkq
         sFQAnLOBsRC0F/iI/vwdcSQovT0vNK/puEdGLFclnZN1CPHQfO6ugB+v0leGs05/N4hw
         daoaKaMc+Cew1EDZ/O6ce4AQ+lue/dsI43M+phi28NRy3jq9qntUwbMl56qlIhRZ5M/V
         vHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MlWKABH2GBAXTBEFNgkeH520s5m+9L7trkfahPYAnUs=;
        b=qMYXaLpMQXYSafgtnGDkEtirKK5gED2X6nGnL6lTFkb9QoUcKQ10aNvEnhjOhYPr7g
         ihIRQ2SNeVML9O32ZTmt1QhjFgxx/deRnzu2mwpRvfy3NKbfaIGIahpnPbwCv3HyRTcc
         0L0uRzyKd8Wm01NTM1LrrlgwVbH7b8tPMTXOtl8YNoWdlDz1rEgl3xCi/f9yYHVJEplf
         2v5hMWwaQ4qJQpvFw5AX1gCIGnhIz+gceKTa5TVyw5gGlx4OCUe4HZf0Rl0DZZxqK9Cl
         +JU6Sl/DEaMGDDkJYMLG9xbOzAOT9rQCY760/qX46eMrA34HgJYWIGAPsgciu4BNfTp6
         WPbA==
X-Gm-Message-State: AOAM531BMOwMmN7I9SR7fmGQlZ4oAUuWHOYyeO5p2W5Igwhft9/4fbmM
        FQcQ3shAahuNQCIFphLBIYDWUkKRj28tqHVgs4U=
X-Google-Smtp-Source: ABdhPJy+BIfqyS5SHXZKcVjMNR8+VE9YOjN1D3/GcWSVAHJ5FiQujpULGdqU7StrBWLELbkRG2ZY0AqWAfgarRzcXtI=
X-Received: by 2002:a5e:cb06:: with SMTP id p6mr642270iom.154.1618448360790;
 Wed, 14 Apr 2021 17:59:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201127112114.3219360-1-pbonzini@redhat.com> <20201127112114.3219360-3-pbonzini@redhat.com>
 <CAJhGHyCdqgtvK98_KieG-8MUfg1Jghd+H99q+FkgL0ZuqnvuAw@mail.gmail.com>
 <YHS/BxMiO6I1VOEY@google.com> <CAJhGHyAcnwkCfTcnxXcgAHnF=wPbH2EDp7H+e74ce+oNOWJ=_Q@mail.gmail.com>
 <80b013dc-0078-76f4-1299-3cff261ef7d8@redhat.com> <CAJhGHyChfXdcAMzzD7P3aC8tnhFW5GvOt88vOY=D3pyb7hgNAA@mail.gmail.com>
 <6d9dafb1-b8ff-82ef-93dc-da869fe7ba0f@redhat.com>
In-Reply-To: <6d9dafb1-b8ff-82ef-93dc-da869fe7ba0f@redhat.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Thu, 15 Apr 2021 08:59:09 +0800
Message-ID: <CAJhGHyA=v_va2QTvo7Ve8JyZO4j5LjiCdB9CLnvRXGwGwa3e+A@mail.gmail.com>
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

On Thu, Apr 15, 2021 at 12:58 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/04/21 04:28, Lai Jiangshan wrote:
> > On Tue, Apr 13, 2021 at 8:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 13/04/21 13:03, Lai Jiangshan wrote:
> >>> This patch claims that it has a place to
> >>> stash the IRQ when EFLAGS.IF=0, but inject_pending_event() seams to ignore
> >>> EFLAGS.IF and queues the IRQ to the guest directly in the first branch
> >>> of using "kvm_x86_ops.set_irq(vcpu)".
> >>
> >> This is only true for pure-userspace irqchip.  For split-irqchip, in
> >> which case the "place to stash" the interrupt is
> >> vcpu->arch.pending_external_vector.
> >>
> >> For pure-userspace irqchip, KVM_INTERRUPT only cares about being able to
> >> stash the interrupt in vcpu->arch.interrupt.injected.  It is indeed
> >> wrong for userspace to call KVM_INTERRUPT if the vCPU is not ready for
> >> interrupt injection, but KVM_INTERRUPT does not return an error.
> >
> > Thanks for the reply.
> >
> > May I ask what is the correct/practical way of using KVM_INTERRUPT ABI
> > for pure-userspace irqchip.
> >
> > gVisor is indeed a pure-userspace irqchip, it will call KVM_INTERRUPT
> > when kvm_run->ready_for_interrupt_injection=1 (along with other conditions
> > unrelated to our discussion).
> >
> > https://github.com/google/gvisor/blob/a9441aea2780da8c93da1c73da860219f98438de/pkg/sentry/platform/kvm/bluepill_amd64_unsafe.go#L105
> >
> > if kvm_run->ready_for_interrupt_injection=1 when expection pending or
> > EFLAGS.IF=0, it would be unexpected for gVisor.
>
> Not with EFLAGS.IF=0.  For pending exception, there is code to handle it
> in inject_pending_event:
>

Thanks for the reply.
(I rearranged your summarization here)

> so what happens is:
>
> - the interrupt will not be injected before the exception
>
> - KVM will schedule an immediate vmexit to inject the interrupt as well
>
> - if (as is likely) the exception has turned off interrupts, the next
> call to inject_pending_event will reach
> static_call(kvm_x86_enable_irq_window) and the interrupt will only be
> injected when IF becomes 1 again.

The next call to inject_pending_event() will reach here AT FIRST with
vcpu->arch.exception.injected==false and vcpu->arch.exception.pending==false

>          ... if (!vcpu->arch.exception.pending) {
>                  if (vcpu->arch.nmi_injected) {
>                          static_call(kvm_x86_set_nmi)(vcpu);
>                          can_inject = false;
>                  } else if (vcpu->arch.interrupt.injected) {
>                          static_call(kvm_x86_set_irq)(vcpu);
>                          can_inject = false;

And comes here and vcpu->arch.interrupt.injected is true for there is
an interrupt queued by KVM_INTERRUPT for pure user irqchip. It then does
the injection of the interrupt without checking the EFLAGS.IF.

My question is that what stops the next call to inject_pending_event()
to reach here when KVM_INTERRUPT is called with exepction pending.

Or what makes kvm_run->ready_for_interrupt_injection be zero when
exception pending to disallow userspace to call KVM_INTERRUPT.


>                  }
>          }
>         ...
>          if (vcpu->arch.exception.pending) {
>                 ...
>                  can_inject = false;
>          }
>         // this is vcpu->arch.interrupt.injected for userspace LAPIC
>          if (kvm_cpu_has_injectable_intr(vcpu)) {
>                  r = can_inject ?
> static_call(kvm_x86_interrupt_allowed)(vcpu, true) : -EBUSY;
>                 if (r < 0)
>                         goto busy;
>                 ...
>         }
>
>
> Paolo
>
