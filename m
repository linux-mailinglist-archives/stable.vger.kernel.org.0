Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFC161FDEA
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 19:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiKGSwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 13:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbiKGSw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 13:52:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235BE20F58
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 10:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667847091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwNJ5l0LenrpgzAGzR5lW9fGTrxZv+vJR+aIBTTnE5k=;
        b=Y2sbBLBsBfnVhhOjTRoWNiI9qOfrbbA75WGzUzZW3ZSry71iO639pairEbACFdFkdQvxeJ
        sLznqYJ7AJoH0ddUunf65DBIZuE5tCpRC/goIytGDxBRV0HQta6ySeCbaJC/q3i0yQq4PQ
        BmrGTJOs1/qHoK56I7m9M7iPVWzu/tk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-610-YN6jllRdPdujnHLs2pUmMw-1; Mon, 07 Nov 2022 13:51:30 -0500
X-MC-Unique: YN6jllRdPdujnHLs2pUmMw-1
Received: by mail-wm1-f69.google.com with SMTP id f26-20020a7bcc1a000000b003c03db14864so3388311wmh.6
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 10:51:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TwNJ5l0LenrpgzAGzR5lW9fGTrxZv+vJR+aIBTTnE5k=;
        b=wUZy2MmGyimQDsmDB8v6tl0k1/HMz3tk40mDIA3sqHj43ytAMDVzoEq5rAzg4Bvul7
         gsbpGRHaxDiSGs2iraR6V1e/qqlBzs/vcx/SxqVo4dy/cDNm4YeJMk7hxdmmJxdJeGz5
         hHcV0De9DA2m5mZQyNLCs2kKbOxhh+Z1GUjntS8idayhfN8Myq5DUWLn5+YLFQq6K8lT
         pGeCj4K8scJ81O/x5PDWoCzAeISQxVy/YgwYepDxS7YW6V2GkL2ti0WOJYppWfVeegAO
         oGPT3fKokGmzNU3HxV4dfkxXI6xycyLfixg9z0ryGChUqmLc9gV3Np/iEt6HGvR9H3rp
         s3EQ==
X-Gm-Message-State: ACrzQf0gB8iEsxyNjOsrMMHi9Vz8YYSliO/DD+YPIiRWHHe5bbcr9LQS
        wc2zvpx1AW3csh02WuOCaq5nEisGl5tk2QWfijpzNuyxBNCuzMM1/uTukQMIodLvB7rdQbBNoUH
        MbH1z2ir5Ip2EViDD
X-Received: by 2002:a05:600c:1989:b0:3c6:fabb:ea73 with SMTP id t9-20020a05600c198900b003c6fabbea73mr33484446wmq.19.1667847088687;
        Mon, 07 Nov 2022 10:51:28 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5FqkHG4PLA7haQOcF3RqLp6ElVkM7k4uuYAslxPFp/HquyvkF9ui+ofK7m6K+27wyBlsgorw==
X-Received: by 2002:a05:600c:1989:b0:3c6:fabb:ea73 with SMTP id t9-20020a05600c198900b003c6fabbea73mr33484433wmq.19.1667847088380;
        Mon, 07 Nov 2022 10:51:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id n10-20020a5d420a000000b0023682011c1dsm7958580wrq.104.2022.11.07.10.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 10:51:27 -0800 (PST)
Message-ID: <b4195ffb-f9ce-869b-e3d6-a6ded38d4efb@redhat.com>
Date:   Mon, 7 Nov 2022 19:51:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/8] KVM: SVM: extract VMCB accessors to a new file
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-2-pbonzini@redhat.com> <Y2k7o8i/qhBm9bpC@google.com>
 <3ca5e8b6-c786-2f15-8f81-fd6353c43692@redhat.com>
 <Y2lLFEt3tQBoZTDe@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2lLFEt3tQBoZTDe@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/7/22 19:14, Sean Christopherson wrote:
> On Mon, Nov 07, 2022, Paolo Bonzini wrote:
>> On 11/7/22 18:08, Sean Christopherson wrote:
>>> What about making KVM self-sufficient?
>>
>> You mean having a different asm-offsets.h file just for arch/x86/kvm/?
> 
> Yeah.

I'll try tomorrow, wish me luck. :)

>> The problem is that the _existing_ include of kvm_cache_regs.h in svm.h
>> fails, with
>>
>> arch/x86/kernel/../kvm/svm/svm.h:25:10: fatal error: kvm_cache_regs.h: No
>> such file or directory
>>     25 | #include "kvm_cache_regs.h"
>>        |          ^~~~~~~~~~~~~~~~~~
>> compilation terminated.
> 
> Duh.  Now the changelog makes more sense...

I'll add the commit message, though I also would not mind getting rid of 
this patch.

>> The other two solutions here are:
>>
>> 1) move kvm_cache_regs.h to arch/x86/include/asm/ so it can be included
>> normally
>>
>> 2) extract the structs to arch/x86/kvm/svm/svm_types.h and include that from
>> asm-offsets.h, basically the opposite of this patch.
>>
>> (2) is my preference if having a different asm-offsets.h file turns out to
>> be too complex.  We can do the same for VMX as well.
> 
> What about adding dedicated structs to hold the non-regs params for VM-Enter and
> VMRUN?  Grabbing stuff willy-nilly in the assembly code makes the flows difficult
> to read as there's nothing in the C code that describes what fields are actually
> used.

What fields are actually used is (like with any other function) 
"potentially all, you'll have to read the source code and in fact you 
can just read asm-offsets.c instead".  What I mean is, I cannot offhand 
see or remember what fields are touched by svm_prepare_switch_to_guest, 
why would __svm_vcpu_run be any different?  And the new SVM assembly 
code is quite readable overall.

> And due to 32-bit's restriction on the number of params, maintaining the
> ad hoc approach will be annoying as passing in new info will require shuffling,
> and any KVM refactorings will need updates to asm-offsets.c, e.g. "spec_ctrl"
> should really live in "struct kvm_vcpu" since it's common to both AMD and Intel.

So what? :)  We're talking of 2 fields (regs, spec_ctrl) for VMX and 4 
(regs, spec_ctrl, svm->current_vmcb and svm->vmcb01---for simplicity all 
of them) for SVM, and they don't change very often at all.  If 
hypothetically KVM had used similar assembly code from the get go, there 
would have been 3 changes in 15 years: spec_ctrl was added for SSBD, and 
the other two fields correspond to two changes to the nesed VMCB 
handling (svm->current_vmcb was first introduced together with vmcb02, 
and later VMSAVE/VMLOAD started always using vmcb01).  That's not too bad.

> That would also allow fixing the bugs introduced by commit bb06650634d3 ("KVM:
> VMX: Convert launched argument to flags").  nested_vmx_check_vmentry_hw() never
> fully enters the guest; at worst, it triggers a "VM-Exit on VM-Enter" consistency
> check.  Thus there's no need to load the guest's spec control and zero chance that
> the guest can write to spec control.

Hmm, I'm not sure how it's related to this series.  Is the problem also 
with the three-argument limit?

Paolo

> E.g. as a very rough starting point
> 
> ---
>   arch/x86/include/asm/kvm_host.h |  8 ++++++++
>   arch/x86/kvm/svm/svm.c          | 13 ++++++++++---
>   arch/x86/kvm/svm/svm.h          |  4 ++--
>   arch/x86/kvm/vmx/nested.c       |  8 ++++++--
>   arch/x86/kvm/vmx/run_flags.h    |  8 --------
>   arch/x86/kvm/vmx/vmx.c          | 32 +++++++++-----------------------
>   arch/x86/kvm/vmx/vmx.h          |  4 +---
>   7 files changed, 36 insertions(+), 41 deletions(-)
>   delete mode 100644 arch/x86/kvm/vmx/run_flags.h
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 415113dea951..d56fe6151656 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -204,6 +204,14 @@ enum exit_fastpath_completion {
>   };
>   typedef enum exit_fastpath_completion fastpath_t;
>   
> +struct kvm_vmrun_params {
> +	...
> +};
> +
> +struct kvm_vmenter_params {
> +	...
> +};
> +
>   struct x86_emulate_ctxt;
>   struct x86_exception;
>   union kvm_smram;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 627c126cd9bb..7df9ea3ad3f1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3925,16 +3925,23 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>   static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct kvm_vmrun_params vmrun = {
> +		.regs = vcpu->arch.regs,
> +		.vmcb01 = svm->vmcb01.ptr,
> +		.vmcb = svm->current_vmcb->ptr,
> +		.spec_ctrl = svm->current_vmcb->ptr,
> +		.spec_ctrl_intercepted = spec_ctrl_intercepted,
> +	};
>   
>   	guest_state_enter_irqoff();
>   
>   	if (sev_es_guest(vcpu->kvm)) {
> -		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
> +		__svm_sev_es_vcpu_run(&params);
>   	} else {
>   		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
>   
> -		__svm_vcpu_run(svm, __sme_page_pa(sd->save_area),
> -			       spec_ctrl_intercepted);
> +		params.save_save_pa = __sme_page_pa(sd->save_area);
> +		__svm_vcpu_run(vcpu->arch.regs, &params);
>   	}
>   
>   	guest_state_exit_irqoff();
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9d940d8736f0..bf321b755a15 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -483,7 +483,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>   
>   /* vmenter.S */
>   
> -void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
> -void __svm_vcpu_run(struct vcpu_svm *svm, unsigned long hsave_pa, bool spec_ctrl_intercepted);
> +void __svm_sev_es_vcpu_run(struct kvm_vmrun_params *params);
> +void __svm_vcpu_run(unsigned long *regs, struct kvm_vmrun_params *params);
>   
>   #endif
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 61a2e551640a..da6c9b8c3a4f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3058,6 +3058,11 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>   
>   static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>   {
> +	struct kvm_vmenter_params params = {
> +		.launched = vmx->loaded_vmcs->launched,
> +		.spec_ctrl = this_cpu_read(x86_spec_ctrl_current),
> +		.spec_ctrl_intercepted = true,
> +	};
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   	unsigned long cr3, cr4;
>   	bool vm_fail;
> @@ -3094,8 +3099,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>   		vmx->loaded_vmcs->host_state.cr4 = cr4;
>   	}
>   
> -	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
> -				 __vmx_vcpu_run_flags(vmx));
> +	vm_fail = __vmx_vcpu_run(vcpu->arch.regs, &params);
>   
>   	if (vmx->msr_autoload.host.nr)
>   		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
> deleted file mode 100644
> index edc3f16cc189..000000000000
> --- a/arch/x86/kvm/vmx/run_flags.h
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef __KVM_X86_VMX_RUN_FLAGS_H
> -#define __KVM_X86_VMX_RUN_FLAGS_H
> -
> -#define VMX_RUN_VMRESUME	(1 << 0)
> -#define VMX_RUN_SAVE_SPEC_CTRL	(1 << 1)
> -
> -#endif /* __KVM_X86_VMX_RUN_FLAGS_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 05a747c9a9ff..307380cd2000 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -847,24 +847,6 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
>   	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap, msr);
>   }
>   
> -unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
> -{
> -	unsigned int flags = 0;
> -
> -	if (vmx->loaded_vmcs->launched)
> -		flags |= VMX_RUN_VMRESUME;
> -
> -	/*
> -	 * If writes to the SPEC_CTRL MSR aren't intercepted, the guest is free
> -	 * to change it directly without causing a vmexit.  In that case read
> -	 * it after vmexit and store it in vmx->spec_ctrl.
> -	 */
> -	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
> -		flags |= VMX_RUN_SAVE_SPEC_CTRL;
> -
> -	return flags;
> -}
> -
>   static __always_inline void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>   		unsigned long entry, unsigned long exit)
>   {
> @@ -7065,9 +7047,14 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>   }
>   
>   static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> -					struct vcpu_vmx *vmx,
> -					unsigned long flags)
> +					struct vcpu_vmx *vmx)
>   {
> +	struct kvm_vmenter_params params = {
> +		.launched = vmx->loaded_vmcs->launched,
> +		.spec_ctrl = vmx->spec_ctrl,
> +		.spec_ctrl_intercepted = msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL),
> +	};
> +
>   	guest_state_enter_irqoff();
>   
>   	/* L1D Flush includes CPU buffer clear to mitigate MDS */
> @@ -7084,8 +7071,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>   	if (vcpu->arch.cr2 != native_read_cr2())
>   		native_write_cr2(vcpu->arch.cr2);
>   
> -	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
> -				   flags);
> +	vmx->fail = __vmx_vcpu_run(vcpu->arch.regs, &params);
>   
>   	vcpu->arch.cr2 = native_read_cr2();
>   
> @@ -7185,7 +7171,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   	kvm_wait_lapic_expire(vcpu);
>   
>   	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
> -	vmx_vcpu_enter_exit(vcpu, vmx, __vmx_vcpu_run_flags(vmx));
> +	vmx_vcpu_enter_exit(vcpu, vmx);
>   
>   	/* All fields are clean at this point */
>   	if (static_branch_unlikely(&enable_evmcs)) {
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index a3da84f4ea45..4eb196f88b47 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -421,9 +421,7 @@ struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
>   void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
>   void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
>   void vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx, unsigned int flags);
> -unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
> -bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
> -		    unsigned int flags);
> +bool __vmx_vcpu_run(unsigned long *regs, struct kvm_vmenter_params *params);
>   int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
>   void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
>   
> 
> base-commit: 0443d79faa4575a5871b54801ed4a36eecce32e3

