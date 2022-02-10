Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3176F4B133C
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244506AbiBJQkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:40:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244494AbiBJQkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:40:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00A8FC26
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C+j0WvNkBk+ZIS2OeBLXFgcqo2ram01O6k15uR5fYqc=;
        b=Cs2iGr7swl0b6Ffr4u72cQkiL28cZ3AqMI9cDfYMWza9MIbilKbGYChUFc3koNwwiA4e+3
        HYGb6dBT+QBIlpyHzruNIOzuHcC57t3MyDZ9nSvg0jhArmvou2S47OUwLVl1v44DSrxJZJ
        VKuOKJHMYsqueCcBZ8xKK3zrSra88kE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-2c1rhy97PmSxkmS6hG3ZtQ-1; Thu, 10 Feb 2022 11:40:31 -0500
X-MC-Unique: 2c1rhy97PmSxkmS6hG3ZtQ-1
Received: by mail-ej1-f70.google.com with SMTP id vj1-20020a170907130100b006ccc4f41d03so2984012ejb.3
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:40:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C+j0WvNkBk+ZIS2OeBLXFgcqo2ram01O6k15uR5fYqc=;
        b=RDE2DV6RQA9N+RW3cxwwGLEzv0DU8u0N6yG+XTBVK3h/vQk1Cd+DxLGuPb/TlOJ4/n
         BVhZWxG97bx6z2wg9Mq8dKbWFB2UA/QDqU3lteNMI6tltOLtPmOFeg4tvsWBa9HgjAs6
         OZqcJDAKP4Csl1A4zOY1e6LNcGaF7jyn2/nS8mVx//xOpUPq1omSawaSdL794XMPTU4y
         NjGjSHzIgWfpoj115RgD60zZ/FjYSuoudPAq+TXeBb2O/QxH77NOKZbGzc37A15ms3mQ
         vwy1fJZddi5jgcVP4ldyt/AyVlmbG0JUukS4DjTNylm1jP2bQpbtJ2WnHNNj8PfZDMGB
         BxZw==
X-Gm-Message-State: AOAM530m/U/hoi/U0+Dbz53vROfr/bqVN1mLomGZcXkXHTB44bqAXfz7
        tjZURxNBMhxZktE+OGY+7ULGbKsXH+CLeSFlAB7px4/JM3AkFev9TpKU5QC9dG1PTAYyYcGcxz4
        vrUb71Wc3ob5l1iMr
X-Received: by 2002:a17:907:1c8e:: with SMTP id nb14mr6955292ejc.313.1644511229883;
        Thu, 10 Feb 2022 08:40:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuXtkysMF8kKJ5FDAcmJi3hszJY/D6Sw2613ypV8pW20QObKINU1acrzpF2biU/Cam6Jdqqw==
X-Received: by 2002:a17:907:1c8e:: with SMTP id nb14mr6955268ejc.313.1644511229595;
        Thu, 10 Feb 2022 08:40:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id w22sm7160231ejc.137.2022.02.10.08.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:40:29 -0800 (PST)
Message-ID: <76901fa6-f26e-7920-4ab4-04129c6d7a2b@redhat.com>
Date:   Thu, 10 Feb 2022 17:40:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.15 7/8] KVM: VMX: Set vmcs.PENDING_DBG.BS on
 #DB in STI/MOVSS blocking shadow
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185653.48833-1-sashal@kernel.org>
 <20220209185653.48833-7-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185653.48833-7-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/22 19:56, Sasha Levin wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> [ Upstream commit b9bed78e2fa9571b7c983b20666efa0009030c71 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Set vmcs.GUEST_PENDING_DBG_EXCEPTIONS.BS, a.k.a. the pending single-step
> breakpoint flag, when re-injecting a #DB with RFLAGS.TF=1, and STI or
> MOVSS blocking is active.  Setting the flag is necessary to make VM-Entry
> consistency checks happy, as VMX has an invariant that if RFLAGS.TF is
> set and STI/MOVSS blocking is true, then the previous instruction must
> have been STI or MOV/POP, and therefore a single-step #DB must be pending
> since the RFLAGS.TF cannot have been set by the previous instruction,
> i.e. the one instruction delay after setting RFLAGS.TF must have already
> expired.
> 
> Normally, the CPU sets vmcs.GUEST_PENDING_DBG_EXCEPTIONS.BS appropriately
> when recording guest state as part of a VM-Exit, but #DB VM-Exits
> intentionally do not treat the #DB as "guest state" as interception of
> the #DB effectively makes the #DB host-owned, thus KVM needs to manually
> set PENDING_DBG.BS when forwarding/re-injecting the #DB to the guest.
> 
> Note, although this bug can be triggered by guest userspace, doing so
> requires IOPL=3, and guest userspace running with IOPL=3 has full access
> to all I/O ports (from the guest's perspective) and can crash/reboot the
> guest any number of ways.  IOPL=3 is required because STI blocking kicks
> in if and only if RFLAGS.IF is toggled 0=>1, and if CPL>IOPL, STI either
> takes a #GP or modifies RFLAGS.VIF, not RFLAGS.IF.
> 
> MOVSS blocking can be initiated by userspace, but can be coincident with
> a #DB if and only if DR7.GD=1 (General Detect enabled) and a MOV DR is
> executed in the MOVSS shadow.  MOV DR #GPs at CPL>0, thus MOVSS blocking
> is problematic only for CPL0 (and only if the guest is crazy enough to
> access a DR in a MOVSS shadow).  All other sources of #DBs are either
> suppressed by MOVSS blocking (single-step, code fetch, data, and I/O),
> are mutually exclusive with MOVSS blocking (T-bit task switch), or are
> already handled by KVM (ICEBP, a.k.a. INT1).
> 
> This bug was originally found by running tests[1] created for XSA-308[2].
> Note that Xen's userspace test emits ICEBP in the MOVSS shadow, which is
> presumably why the Xen bug was deemed to be an exploitable DOS from guest
> userspace.  KVM already handles ICEBP by skipping the ICEBP instruction
> and thus clears MOVSS blocking as a side effect of its "emulation".
> 
> [1] http://xenbits.xenproject.org/docs/xtf/xsa-308_2main_8c_source.html
> [2] https://xenbits.xen.org/xsa/advisory-308.html
> 
> Reported-by: David Woodhouse <dwmw2@infradead.org>
> Reported-by: Alexander Graf <graf@amazon.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20220120000624.655815-1-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2ab0e997e39fa..44da933a756b3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4791,8 +4791,33 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   		dr6 = vmx_get_exit_qual(vcpu);
>   		if (!(vcpu->guest_debug &
>   		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
> +			/*
> +			 * If the #DB was due to ICEBP, a.k.a. INT1, skip the
> +			 * instruction.  ICEBP generates a trap-like #DB, but
> +			 * despite its interception control being tied to #DB,
> +			 * is an instruction intercept, i.e. the VM-Exit occurs
> +			 * on the ICEBP itself.  Note, skipping ICEBP also
> +			 * clears STI and MOVSS blocking.
> +			 *
> +			 * For all other #DBs, set vmcs.PENDING_DBG_EXCEPTIONS.BS
> +			 * if single-step is enabled in RFLAGS and STI or MOVSS
> +			 * blocking is active, as the CPU doesn't set the bit
> +			 * on VM-Exit due to #DB interception.  VM-Entry has a
> +			 * consistency check that a single-step #DB is pending
> +			 * in this scenario as the previous instruction cannot
> +			 * have toggled RFLAGS.TF 0=>1 (because STI and POP/MOV
> +			 * don't modify RFLAGS), therefore the one instruction
> +			 * delay when activating single-step breakpoints must
> +			 * have already expired.  Note, the CPU sets/clears BS
> +			 * as appropriate for all other VM-Exits types.
> +			 */
>   			if (is_icebp(intr_info))
>   				WARN_ON(!skip_emulated_instruction(vcpu));
> +			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
> +				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
> +				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
> +				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
> +					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
>   
>   			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
>   			return 1;

