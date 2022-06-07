Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EC1541FFD
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 02:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442686AbiFHAE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 20:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452846AbiFGXOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 19:14:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED6B1114AA3
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 14:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654635708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zMQUJ6VpnePS1F8wqFGjy68aQ9DDcdIV369uxqQKcZA=;
        b=FWyWh7uai9nOxejIMOrPgnwZ0LWMGjxyL+4gqgD5v1TU0xTZDSFLWhpku5IaEofreKqepC
        cwol2L78EhiP849j0gXPgo2YI/zxZF+NcKUSyDFuMnevtOlo3IspRJmumcSRDu5BGTPEfH
        KnKCvQpqMw8N42lyiXda7nMFkTLzOIk=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-MLBcbRicMDywYWfFoPkrbw-1; Tue, 07 Jun 2022 17:01:46 -0400
X-MC-Unique: MLBcbRicMDywYWfFoPkrbw-1
Received: by mail-io1-f69.google.com with SMTP id q5-20020a6b2a05000000b006696f97731aso2543177ioq.8
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 14:01:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zMQUJ6VpnePS1F8wqFGjy68aQ9DDcdIV369uxqQKcZA=;
        b=56z1Rvx7UCezK6CsXbJyNANpTT273x4mRusazrLVkLDq9Ts0XF2oUr2lu88hn6WZgN
         zPrsWdlL2Smsxxt57PPvZpqmkdx1h/cL/qdmxqkpbxQV0SVmR5BwvayHArEmaxYQoPPc
         URkZXamEMbur8Lh+4pfhryJUt6EjJoiXZSFFyCveYX8zcWxUbcIihgXwoKfQ5gRNJhtp
         QR5LkOYlP3FAX2RP45K1qbRS+cv5PBVqqAZK8csuwfYz1STeN+p65LWCA9CTJVi0z6Tk
         kIS5h+nwEy7lUuszK1oYHr1I7gcfcNvCBPMwweCezZay3NO3PyIb3B6P/4xocLzJOGey
         dHeQ==
X-Gm-Message-State: AOAM5302+6UMPrxT/16mXlU3j5ijShnss7IcY6aJUP/NnpWGGni8xXqT
        4rd9m14/e7pJz4EBP3fjA8T49Cnaxzj5hABZhb5v/oZ2vN7evtj44gTh1VuVFOqBsRN4uoU+Lf+
        iwmC9yZUWGtrqN+EM
X-Received: by 2002:a05:6602:1409:b0:5e7:487:133c with SMTP id t9-20020a056602140900b005e70487133cmr14460057iov.196.1654635706169;
        Tue, 07 Jun 2022 14:01:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqMxm0HPA4ioMPd0WVFUe/3BPbKwjOS/Yp7gvqjTrpfq71Xz0vKW4J0DAiDTeXf0UgcTTX6Q==
X-Received: by 2002:a05:6602:1409:b0:5e7:487:133c with SMTP id t9-20020a056602140900b005e70487133cmr14460043iov.196.1654635705911;
        Tue, 07 Jun 2022 14:01:45 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id ca12-20020a0566381c0c00b0032eabb4d87dsm6956527jab.111.2022.06.07.14.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 14:01:45 -0700 (PDT)
Date:   Tue, 7 Jun 2022 17:01:43 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        chang.seok.bae@intel.com, luto@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest
 user_xfeatures to supported bits of XCR0
Message-ID: <Yp+8t7vEcwj2KhX5@xz-m1.local>
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-7-sashal@kernel.org>
 <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com>
 <YppVupW+IWsm7Osr@xz-m1.local>
 <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com>
 <Yp5xSi6P3q187+A+@xz-m1.local>
 <9d336622-6964-454a-605f-1ca90b902836@redhat.com>
 <Yp9o+y0NcRW/0puA@google.com>
 <Yp+WUoA+6x7ZpsaM@xz-m1.local>
 <Yp+dTU4NOaIELJh8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yp+dTU4NOaIELJh8@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 06:47:41PM +0000, Sean Christopherson wrote:
> On Tue, Jun 07, 2022, Peter Xu wrote:
> > On Tue, Jun 07, 2022 at 03:04:27PM +0000, Sean Christopherson wrote:
> > > On Tue, Jun 07, 2022, Paolo Bonzini wrote:
> > > > On 6/6/22 23:27, Peter Xu wrote:
> > > > > On Mon, Jun 06, 2022 at 06:18:12PM +0200, Paolo Bonzini wrote:
> > > > > > > However there seems to be something missing at least to me, on why it'll
> > > > > > > fail a migration from 5.15 (without this patch) to 5.18 (with this patch).
> > > > > > > In my test case, user_xfeatures will be 0x7 (FP|SSE|YMM) if without this
> > > > > > > patch, but 0x0 if with it.
> > > > > > 
> > > > > > What CPU model are you using for the VM?
> > > > > 
> > > > > I didn't specify it, assuming it's qemu64 with no extra parameters.
> > > > 
> > > > Ok, so indeed it lacks AVX and this patch can have an effect.
> > > > 
> > > > > > For example, if the source lacks this patch but the destination has it,
> > > > > > the source will transmit YMM registers, but the destination will fail to
> > > > > > set them if they are not available for the selected CPU model.
> > > > > > 
> > > > > > See the commit message: "As a bonus, it will also fail if userspace tries to
> > > > > > set fpu features (with the KVM_SET_XSAVE ioctl) that are not compatible to
> > > > > > the guest configuration.  Such features will never be returned by
> > > > > > KVM_GET_XSAVE or KVM_GET_XSAVE2."
> > > > > 
> > > > > IIUC you meant we should have failed KVM_SET_XSAVE when they're not aligned
> > > > > (probably by failing validate_user_xstate_header when checking against the
> > > > > user_xfeatures on dest host). But that's probably not my case, because here
> > > > > KVM_SET_XSAVE succeeded, it's just that the guest gets a double fault after
> > > > > the precopy migration completes (or for postcopy when the switchover is
> > > > > done).
> > > > 
> > > > Difficult to say what's happening without seeing at least the guest code
> > > > around the double fault (above you said "fail a migration" and I thought
> > > > that was a different scenario than the double fault), and possibly which was
> > > > the first exception that contributed to the double fault.
> > > 
> > > Regardless of why the guest explodes in the way it does, is someone planning on
> > > bisecting this (if necessary?) and sending a backport to v5.15?  There's another
> > > bug report that is more than likely hitting the same bug.
> > 
> > What's the bisection you mentioned?  I actually did a bisection and I also
> > checked reverting Leo's change can also fix this issue.  Or do you mean
> > something else?
> 
> Oooooh, sorry!  I got completely turned around.  You ran into a bug with the
> fix.  I thought that you were hitting the same issues as Mike where migrating
> between hosts with different capabilities is broken in v5.15, but works in v5.18.

Aha, no worry.

> 
> > > https://lore.kernel.org/all/48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net
> > 
> > That is kvm64, and I agree it could be the same problem since both qemu64
> > and kvm64 models do not have any xsave feature bit declared in cpuid 0xd,
> > so potentially we could be migrating some fpu states to it even with
> > user_xfeatures==0 on dest host.
> > 
> > So today I continued the investigation, and I think what's really missing
> > is qemu seems to be ignoring the user_xfeatures check for KVM_SET_XSAVE and
> > continues even if it returns -EINVAL.  IOW, I'm wondering whether we should
> > fail properly and start to check kvm_arch_put_registers() retcode.  But
> > that'll be a QEMU fix, and it'll at least not causing random faults
> > (e.g. double faults) in guest but we should fail the migration gracefully.
> > 
> > Sean: a side note is that I can also easily trigger one WARN_ON_ONCE() in
> > your commit 98c25ead5eda5 in kvm_arch_vcpu_ioctl_run():
> > 
> > 	WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
> > 
> > It'll be great if you'd like to check that up.
> 
> Ugh, userspace can force KVM_MP_STATE_UNINITIALIZED via KVM_SET_MP_STATE.  Looks
> like QEMU does that when emulating RESET.
> 
> Logically, a full RESET of the xAPIC seems like the right thing to do.  I think
> we can get away with that without breaking ABI?  And kvm_lapic_reset() has a
> related bug where it stops the HR timer but not doesn't handle the HV timer :-/
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e69b83708f05..948aba894245 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2395,7 +2395,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>                 return;
> 
>         /* Stop the timer in case it's a reset to an active apic */
> -       hrtimer_cancel(&apic->lapic_timer.timer);
> +       cancel_apic_timer(&apic->lapic_timer.timer);

Needs to be:

  +       cancel_apic_timer(apic);

> 
>         /* The xAPIC ID is set at RESET even if the APIC was already enabled. */
>         if (!init_event)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 540651cd28d7..ed2c7cb1642d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10912,6 +10912,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>              mp_state->mp_state == KVM_MP_STATE_INIT_RECEIVED))
>                 goto out;
> 
> +       if (mp_state->mp_state == KVM_MP_STATE_UNINITIALIZED)
> +               kvm_lapic_reset(vcpu, false);
> +
>         if (mp_state->mp_state == KVM_MP_STATE_SIPI_RECEIVED) {
>                 vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
>                 set_bit(KVM_APIC_SIPI, &vcpu->arch.apic->pending_events);
> 

The change looks reasonable, but sadly I did a quick run and it still
triggers.. :-/ So there seems to be something else missing.

-- 
Peter Xu

