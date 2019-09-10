Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F42BAE35A
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 07:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404461AbfIJF45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 01:56:57 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40608 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404458AbfIJF45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 01:56:57 -0400
Received: by mail-ot1-f66.google.com with SMTP id y39so16600330ota.7;
        Mon, 09 Sep 2019 22:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0XATUhsdQn5yqTbpQ/1BUB6xCeZGaj0TH98YB5SG9oU=;
        b=oCMOO8R6/kKvrjUStyeavGPpRtNy0Dwuh6F+xyLQoXRIcfitiTG+odj7t08oIO06X6
         P4XKosuQ/HQeHIbaUni/6qOtihRSMqdpkaeTVp/aeBOtJpdEa6oPcB9Fu9AVsSqPJPJP
         AWNgznp0krKLL31ePuwYE3vCenU5X95171Pwa/4UtcFXG0SjqGJuMuEu3uG0//E3jq8k
         pGYDtTUI5SVuoS4S9OONj1eUdR0kLI0KEfKMDcPDruEdauCCJgmQfIt3fa8UwpqQRMNz
         oqjj+7lbfQaetyanGCQZOKQBNsdPVcdGJborG9PFDrNr47wYi3S+DkinbroG72wTHczi
         rrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0XATUhsdQn5yqTbpQ/1BUB6xCeZGaj0TH98YB5SG9oU=;
        b=paCju2f2Wxocqd3qhj8LTOWEJx2tiwXPov/uHKPfUzRu+yq1AtSAPkFU4aLhmMgRnT
         q+/4zvkHPlvQnIUUoUMCg1dU3+I1dfVcOYECK/34WLqajksKP8mhxSJobT1MMECJOH8N
         uj/Ps/MoIQ7360b7OvONRLGany3niowleKj81OovKctK2LCRpvhbjeH0vDRxkZeYOPj4
         8wWionzwTE8g7zAPfuCIkmjzxJM7IfHWAab45SQ8MBZ5zcJ4KSLlqY/DJBrd2ar8mQnz
         zJIrAJctzSLRaPjdKeHhBTFEJW/6cFbGY20DgqP71Ue3CurAnjcDVJUlqjzxM5ZO/dyD
         kNgw==
X-Gm-Message-State: APjAAAWBy6PkFvmvQgGlEQyWTKrx24FtOkxTMmpUPVROdjBAiqcLIhfu
        cCxMctDZuefcby+9LreThwQUyyK3EZk8vBCXusE+3oBD
X-Google-Smtp-Source: APXvYqwGsg4LpHe0jcnmOm2G3S6bnupTBUCqRr8W2oCOwE6/KPn+D7OimxRhO0Drj4EydRZXX++kTSLNpqtPCtJMKK4=
X-Received: by 2002:a9d:3ae:: with SMTP id f43mr21330286otf.254.1568095016004;
 Mon, 09 Sep 2019 22:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <1567993228-23668-1-git-send-email-wanpengli@tencent.com> <29d04ee4-60e7-4df9-0c4f-fc29f2b0c6a8@redhat.com>
In-Reply-To: <29d04ee4-60e7-4df9-0c4f-fc29f2b0c6a8@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 10 Sep 2019 13:56:42 +0800
Message-ID: <CANRm+CxVXsQCmEpxNJSifmQJk5cqoSifFq+huHJE1s7a-=0iXw@mail.gmail.com>
Subject: Re: [PATCH] Revert "locking/pvqspinlock: Don't wait if vCPU is preempted"
To:     Waiman Long <longman@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, loobinliu@tencent.com,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Sep 2019 at 18:56, Waiman Long <longman@redhat.com> wrote:
>
> On 9/9/19 2:40 AM, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > This patch reverts commit 75437bb304b20 (locking/pvqspinlock: Don't wai=
t if
> > vCPU is preempted), we found great regression caused by this commit.
> >
> > Xeon Skylake box, 2 sockets, 40 cores, 80 threads, three VMs, each is 8=
0 vCPUs.
> > The score of ebizzy -M can reduce from 13000-14000 records/s to 1700-18=
00
> > records/s with this commit.
> >
> >           Host                       Guest                score
> >
> > vanilla + w/o kvm optimizes     vanilla               1700-1800 records=
/s
> > vanilla + w/o kvm optimizes     vanilla + revert      13000-14000 recor=
ds/s
> > vanilla + w/ kvm optimizes      vanilla               4500-5000 records=
/s
> > vanilla + w/ kvm optimizes      vanilla + revert      14000-15500 recor=
ds/s
> >
> > Exit from aggressive wait-early mechanism can result in yield premature=
 and
> > incur extra scheduling latency in over-subscribe scenario.
> >
> > kvm optimizes:
> > [1] commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrupts=
)
> > [2] commit 266e85a5ec9 (KVM: X86: Boost queue head vCPU to mitigate loc=
k waiter preemption)
> >
> > Tested-by: loobinliu@tencent.com
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Waiman Long <longman@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: loobinliu@tencent.com
> > Cc: stable@vger.kernel.org
> > Fixes: 75437bb304b20 (locking/pvqspinlock: Don't wait if vCPU is preemp=
ted)
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  kernel/locking/qspinlock_paravirt.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/locking/qspinlock_paravirt.h b/kernel/locking/qspin=
lock_paravirt.h
> > index 89bab07..e84d21a 100644
> > --- a/kernel/locking/qspinlock_paravirt.h
> > +++ b/kernel/locking/qspinlock_paravirt.h
> > @@ -269,7 +269,7 @@ pv_wait_early(struct pv_node *prev, int loop)
> >       if ((loop & PV_PREV_CHECK_MASK) !=3D 0)
> >               return false;
> >
> > -     return READ_ONCE(prev->state) !=3D vcpu_running || vcpu_is_preemp=
ted(prev->cpu);
> > +     return READ_ONCE(prev->state) !=3D vcpu_running;
> >  }
> >
> >  /*
>
> There are several possibilities for this performance regression:
>
> 1) Multiple vcpus calling vcpu_is_preempted() repeatedly may cause some
> cacheline contention issue depending on how that callback is implemented.
>
> 2) KVM may set the preempt flag for a short period whenver an vmexit
> happens even if a vmenter is executed shortly after. In this case, we
> may want to use a more durable vcpu suspend flag that indicates the vcpu
> won't get a real vcpu back for a longer period of time.
>
> Perhaps you can add a lock event counter to count the number of
> wait_early events caused by vcpu_is_preempted() being true to see if it
> really cause a lot more wait_early than without the vcpu_is_preempted()
> call.

pv_wait_again:1:179
pv_wait_early:1:189429
pv_wait_head:1:263
pv_wait_node:1:189429
pv_vcpu_is_preempted:1:45588
=3D=3D=3D=3D=3D=3D=3D=3D=3Dsleep 5=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
pv_wait_again:1:181
pv_wait_early:1:202574
pv_wait_head:1:267
pv_wait_node:1:202590
pv_vcpu_is_preempted:1:46336

The sampling period is 5s, 6% of wait_early events caused by
vcpu_is_preempted() being true.

                Wanpeng
