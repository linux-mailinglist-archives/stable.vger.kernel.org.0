Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686B3391056
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 08:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhEZGJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 02:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhEZGJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 02:09:51 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90852C061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 23:08:20 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id v22so489410oic.2
        for <stable@vger.kernel.org>; Tue, 25 May 2021 23:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6AUTDLd3DV4BBlDLPVeTrJG2G+5j5mRNGfe1/rQ712E=;
        b=EDQ5GVJIvy1e8a/YqRx9X2eNVnDfpqvz98MrTBes2BEwUwt3lx2g0c4atj/fko3tTT
         DtiO0zDi9Rm1q9TAEIFPQxuRL6+KfiOSY1haj+eDHxJ4rOZQ7VwdFBHyPaDaa3Jg8e8E
         PRNSH8EJaHfknRj0JuFityJ+lK66xHVNCuR2cbsNVGruZTvMqVHzrXVsBNgpBNbZhoJL
         J8u5mgaJfenykGxVUS4wy0ry/gmq6Nqwite572JZgrBPDO1ofxiw07lmReUFmdQFH6C7
         QEuU4j3j5vwceUDY9Y2d5V9BRxyAZ5OgOPhjhbWRCu48UZ5iAV90MNjpadm3VpjZXpyW
         eRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6AUTDLd3DV4BBlDLPVeTrJG2G+5j5mRNGfe1/rQ712E=;
        b=Yaq5C9f6G6Fq7odyFereJ5uasa6iqlJrwfpYXAgcT6bsb2mkulF7czThoyTioYGqjn
         8G7qX0mr0cDj9dfxJjfTNbYOZw9hNQfmp6UdcPROZ7HMw9c0mnrzr0gEOpt6Uj/ONHBR
         9mZ7Pv2FyAX3VdCEa5Wd8eA+5Ppc+oOpNtvpploWZc53weHy38AhQ0YqEs56MbmqXDkE
         X64INR3wktZZMgzUKzR/KyZ5XMAIWJjFM5jqdmwJvHNMXnVy9xC+RvwsKw1OLDLkDxJQ
         KS5k7YhlHf/92bSeexYj+iGdYJcQH6pHtA0L8eaiGMR+tD7MAKy+x3cqcQ7q/pvd0Ney
         APGA==
X-Gm-Message-State: AOAM5327Zoc6lXk05MnHsmmPH2K/vXpbsxhmZbswhf8/Rs6jWvHCPGDS
        z1AsVZQ4hkWG4wvHj+q50pBS0jlhOGjTcECLvcE=
X-Google-Smtp-Source: ABdhPJykp/xJAPe03Tt51VWoH3pRFK9TnGVSfFAfmxKiIEg1yXgZwAkk78u9wZosNixK/BV/yzhcQoF8oy6micigJmw=
X-Received: by 2002:aca:d805:: with SMTP id p5mr808997oig.60.1622009299910;
 Tue, 25 May 2021 23:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <1621006676203106@kroah.com>
In-Reply-To: <1621006676203106@kroah.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Wed, 26 May 2021 08:08:09 +0200
Message-ID: <CA+res+S2Jb2_pJFFDRQvizzm2s7yuaKJkqO16WoUT6hM9c0Neg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Defer vtime accounting 'til
 after IRQ handling" failed to apply to 5.10-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     wanpengli@tencent.com, seanjc@google.com, tglx@linutronix.de,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<gregkh@linuxfoundation.org> =E4=BA=8E2021=E5=B9=B45=E6=9C=8814=E6=97=A5=E5=
=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=889:32=E5=86=99=E9=81=93=EF=BC=9A
>
>
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

If I first apply 866a6dadbb02 ("context_tracking: Move guest exit
context tracking to separate helpers")
and 88d8220bbf06 ("context_tracking: Move guest exit vtime accounting
to separate helpers")

then I can apply this commit cleanly to latest 5.10.y, I suppose it
will work for 5.12.

>
> thanks,
>
> greg k-h
Thanks!
Jack Wang
>
> ------------------ original commit in Linus's tree ------------------
>
> From 160457140187c5fb127b844e5a85f87f00a01b14 Mon Sep 17 00:00:00 2001
> From: Wanpeng Li <wanpengli@tencent.com>
> Date: Tue, 4 May 2021 17:27:30 -0700
> Subject: [PATCH] KVM: x86: Defer vtime accounting 'til after IRQ handling
>
> Defer the call to account guest time until after servicing any IRQ(s)
> that happened in the guest or immediately after VM-Exit.  Tick-based
> accounting of vCPU time relies on PF_VCPU being set when the tick IRQ
> handler runs, and IRQs are blocked throughout the main sequence of
> vcpu_enter_guest(), including the call into vendor code to actually
> enter and exit the guest.
>
> This fixes a bug where reported guest time remains '0', even when
> running an infinite loop in the guest:
>
>   https://bugzilla.kernel.org/show_bug.cgi?id=3D209831
>
> Fixes: 87fa7f3e98a131 ("x86/kvm: Move context tracking where it belongs")
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20210505002735.1684165-4-seanjc@google.co=
m
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9790c73f2a32..c400def6220b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3753,15 +3753,15 @@ static noinstr void svm_vcpu_enter_exit(struct kv=
m_vcpu *vcpu)
>          * have them in state 'on' as recorded before entering guest mode=
.
>          * Same as enter_from_user_mode().
>          *
> -        * guest_exit_irqoff() restores host context and reinstates RCU i=
f
> -        * enabled and required.
> +        * context_tracking_guest_exit() restores host context and reinst=
ates
> +        * RCU if enabled and required.
>          *
>          * This needs to be done before the below as native_read_msr()
>          * contains a tracepoint and x86_spec_ctrl_restore_host() calls
>          * into world and some more.
>          */
>         lockdep_hardirqs_off(CALLER_ADDR0);
> -       guest_exit_irqoff();
> +       context_tracking_guest_exit();
>
>         instrumentation_begin();
>         trace_hardirqs_off_finish();
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b21d751407b5..e108fb47855b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6703,15 +6703,15 @@ static noinstr void vmx_vcpu_enter_exit(struct kv=
m_vcpu *vcpu,
>          * have them in state 'on' as recorded before entering guest mode=
.
>          * Same as enter_from_user_mode().
>          *
> -        * guest_exit_irqoff() restores host context and reinstates RCU i=
f
> -        * enabled and required.
> +        * context_tracking_guest_exit() restores host context and reinst=
ates
> +        * RCU if enabled and required.
>          *
>          * This needs to be done before the below as native_read_msr()
>          * contains a tracepoint and x86_spec_ctrl_restore_host() calls
>          * into world and some more.
>          */
>         lockdep_hardirqs_off(CALLER_ADDR0);
> -       guest_exit_irqoff();
> +       context_tracking_guest_exit();
>
>         instrumentation_begin();
>         trace_hardirqs_off_finish();
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cebdaa1e3cf5..6eda2834fc05 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9315,6 +9315,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         local_irq_disable();
>         kvm_after_interrupt(vcpu);
>
> +       /*
> +        * Wait until after servicing IRQs to account guest time so that =
any
> +        * ticks that occurred while running the guest are properly accou=
nted
> +        * to the guest.  Waiting until IRQs are enabled degrades the acc=
uracy
> +        * of accounting via context tracking, but the loss of accuracy i=
s
> +        * acceptable for all known use cases.
> +        */
> +       vtime_account_guest_exit();
> +
>         if (lapic_in_kernel(vcpu)) {
>                 s64 delta =3D vcpu->arch.apic->lapic_timer.advance_expire=
_delta;
>                 if (delta !=3D S64_MIN) {
>
