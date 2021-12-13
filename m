Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0272472F3B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbhLMO2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239065AbhLMO2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:28:23 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F58BC06173F;
        Mon, 13 Dec 2021 06:28:23 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id v1so53127254edx.2;
        Mon, 13 Dec 2021 06:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XpsjfJ6sCCL81sYfIZzKOs6+Y3jhsCqXdXuFl+QRYVg=;
        b=UGT6GQ9oNfFhq2bRZrpiM8Az83TPfL+/tndVDXp6H2u717qrJVlQ5wD6q2nLpKz5Gb
         ltZP4aVQOX7G+MbJyU6IudOUhxJby7MMovu6rhJHTnncYP8Rtdx4vKSbBuwQfohzcK2P
         JxNBycN8kBEIOShzLpwl5ct6nSomPYLcTioYiaB0o9QJnqnJDIzVH+hEL930dPIR8ntS
         PE6hs+w3IljVETZCESi1qKABKyao75cfLpy37OLnbPYhkODqZbPpcRgLdjKRgtOTThE/
         ztNJaYJyU99cUH8FBTRoX4+WhA/KcZO7W3/ySOle4+YoiPLCff/qpMxDUtfmavwkCAYO
         fVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XpsjfJ6sCCL81sYfIZzKOs6+Y3jhsCqXdXuFl+QRYVg=;
        b=HEYIlmFco3u/6ZPfEyZcrx7HwSZOcLBj71Rq4Ntq4oQXbxSb5eFGd6bC4qfnACAnrc
         wUCzN1HhWRQeeJ8Mh4788J9nHfiQWFrZC8lAjMjgLFULWLt2nnN7hRDb1nkQSwW467qJ
         mF+/r7kTkjhNJ3fXfrWW5Y5Etn7L+m7LTo2ZrM7ahqRxrtXTwsYXIxcO2sLj953jHUbg
         had+nVtbpu/6fy476gcuAa6Kj6hzEdOeR9Z+CKw75f7PGWN7Kd+NIp+ozacUydtTx290
         44FQB5D6Pg23F4FVp3lrjSOOJVO15mrkpSSr9Lzsg2+X6ku2I+rU9cmtbqiBsD792HwH
         QnvA==
X-Gm-Message-State: AOAM532bvqWoeQiYgv7ZNal0oiaAo3aMFRNNvo1FVTr29a4ImH0HGJbm
        tT2QmoXWfNIyv66uXHj78dI=
X-Google-Smtp-Source: ABdhPJwJaTi3vP5MUx7YFJeLF//40SibGi1gdX/uF9nU5MVOifFLjfJfyEw2vjVnqiootZps1a5URg==
X-Received: by 2002:a17:906:dc90:: with SMTP id cs16mr43657982ejc.432.1639405701448;
        Mon, 13 Dec 2021 06:28:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id p7sm2440806edu.84.2021.12.13.06.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:28:21 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <52078253-01f0-b439-abc3-32b35e2832c4@redhat.com>
Date:   Mon, 13 Dec 2021 15:28:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.15 7/9] KVM: selftests: Avoid KVM_SET_CPUID2
 after KVM_RUN in hyperv_features test
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, shuah@kernel.org,
        seanjc@google.com, ricarkol@google.com, maz@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20211213141944.352249-1-sashal@kernel.org>
 <20211213141944.352249-7-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213141944.352249-7-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 15:19, Sasha Levin wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> [ Upstream commit 6c1186430a808f97e2052bd5d9eff12c5d5defb0 ]
> 
> hyperv_features's sole purpose is to test access to various Hyper-V MSRs
> and hypercalls with different CPUID data. As KVM_SET_CPUID2 after KVM_RUN
> is deprecated and soon-to-be forbidden, avoid it by re-creating test VM
> for each sub-test.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20211122175818.608220-2-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   .../selftests/kvm/x86_64/hyperv_features.c    | 140 +++++++++---------
>   1 file changed, 71 insertions(+), 69 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 91d88aaa98992..672915ce73d8f 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -165,10 +165,10 @@ static void hv_set_cpuid(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid,
>   	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
>   }
>   
> -static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
> -				   struct kvm_cpuid2 *best)
> +static void guest_test_msrs_access(void)
>   {
>   	struct kvm_run *run;
> +	struct kvm_vm *vm;
>   	struct ucall uc;
>   	int stage = 0, r;
>   	struct kvm_cpuid_entry2 feat = {
> @@ -180,11 +180,34 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
>   	struct kvm_cpuid_entry2 dbg = {
>   		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
>   	};
> -	struct kvm_enable_cap cap = {0};
> -
> -	run = vcpu_state(vm, VCPU_ID);
> +	struct kvm_cpuid2 *best;
> +	vm_vaddr_t msr_gva;
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
> +		.args = {1}
> +	};
> +	struct msr_data *msr;
>   
>   	while (true) {
> +		vm = vm_create_default(VCPU_ID, 0, guest_msr);
> +
> +		msr_gva = vm_vaddr_alloc_page(vm);
> +		memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
> +		msr = addr_gva2hva(vm, msr_gva);
> +
> +		vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
> +		vcpu_enable_cap(vm, VCPU_ID, &cap);
> +
> +		vcpu_set_hv_cpuid(vm, VCPU_ID);
> +
> +		best = kvm_get_supported_hv_cpuid();
> +
> +		vm_init_descriptor_tables(vm);
> +		vcpu_init_descriptor_tables(vm, VCPU_ID);
> +		vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
> +
> +		run = vcpu_state(vm, VCPU_ID);
> +
>   		switch (stage) {
>   		case 0:
>   			/*
> @@ -315,6 +338,7 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
>   			 * capability enabled and guest visible CPUID bit unset.
>   			 */
>   			cap.cap = KVM_CAP_HYPERV_SYNIC2;
> +			cap.args[0] = 0;
>   			vcpu_enable_cap(vm, VCPU_ID, &cap);
>   			break;
>   		case 22:
> @@ -461,9 +485,9 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
>   
>   		switch (get_ucall(vm, VCPU_ID, &uc)) {
>   		case UCALL_SYNC:
> -			TEST_ASSERT(uc.args[1] == stage,
> -				    "Unexpected stage: %ld (%d expected)\n",
> -				    uc.args[1], stage);
> +			TEST_ASSERT(uc.args[1] == 0,
> +				    "Unexpected stage: %ld (0 expected)\n",
> +				    uc.args[1]);
>   			break;
>   		case UCALL_ABORT:
>   			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
> @@ -474,13 +498,14 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
>   		}
>   
>   		stage++;
> +		kvm_vm_free(vm);
>   	}
>   }
>   
> -static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall,
> -				     void *input, void *output, struct kvm_cpuid2 *best)
> +static void guest_test_hcalls_access(void)
>   {
>   	struct kvm_run *run;
> +	struct kvm_vm *vm;
>   	struct ucall uc;
>   	int stage = 0, r;
>   	struct kvm_cpuid_entry2 feat = {
> @@ -493,10 +518,38 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
>   	struct kvm_cpuid_entry2 dbg = {
>   		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
>   	};
> -
> -	run = vcpu_state(vm, VCPU_ID);
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
> +		.args = {1}
> +	};
> +	vm_vaddr_t hcall_page, hcall_params;
> +	struct hcall_data *hcall;
> +	struct kvm_cpuid2 *best;
>   
>   	while (true) {
> +		vm = vm_create_default(VCPU_ID, 0, guest_hcall);
> +
> +		vm_init_descriptor_tables(vm);
> +		vcpu_init_descriptor_tables(vm, VCPU_ID);
> +		vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
> +
> +		/* Hypercall input/output */
> +		hcall_page = vm_vaddr_alloc_pages(vm, 2);
> +		hcall = addr_gva2hva(vm, hcall_page);
> +		memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
> +
> +		hcall_params = vm_vaddr_alloc_page(vm);
> +		memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
> +
> +		vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
> +		vcpu_enable_cap(vm, VCPU_ID, &cap);
> +
> +		vcpu_set_hv_cpuid(vm, VCPU_ID);
> +
> +		best = kvm_get_supported_hv_cpuid();
> +
> +		run = vcpu_state(vm, VCPU_ID);
> +
>   		switch (stage) {
>   		case 0:
>   			hcall->control = 0xdeadbeef;
> @@ -606,9 +659,9 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
>   
>   		switch (get_ucall(vm, VCPU_ID, &uc)) {
>   		case UCALL_SYNC:
> -			TEST_ASSERT(uc.args[1] == stage,
> -				    "Unexpected stage: %ld (%d expected)\n",
> -				    uc.args[1], stage);
> +			TEST_ASSERT(uc.args[1] == 0,
> +				    "Unexpected stage: %ld (0 expected)\n",
> +				    uc.args[1]);
>   			break;
>   		case UCALL_ABORT:
>   			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
> @@ -619,66 +672,15 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
>   		}
>   
>   		stage++;
> +		kvm_vm_free(vm);
>   	}
>   }
>   
>   int main(void)
>   {
> -	struct kvm_cpuid2 *best;
> -	struct kvm_vm *vm;
> -	vm_vaddr_t msr_gva, hcall_page, hcall_params;
> -	struct kvm_enable_cap cap = {
> -		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
> -		.args = {1}
> -	};
> -
> -	/* Test MSRs */
> -	vm = vm_create_default(VCPU_ID, 0, guest_msr);
> -
> -	msr_gva = vm_vaddr_alloc_page(vm);
> -	memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
> -	vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
> -	vcpu_enable_cap(vm, VCPU_ID, &cap);
> -
> -	vcpu_set_hv_cpuid(vm, VCPU_ID);
> -
> -	best = kvm_get_supported_hv_cpuid();
> -
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vm, VCPU_ID);
> -	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
> -
>   	pr_info("Testing access to Hyper-V specific MSRs\n");
> -	guest_test_msrs_access(vm, addr_gva2hva(vm, msr_gva),
> -			       best);
> -	kvm_vm_free(vm);
> -
> -	/* Test hypercalls */
> -	vm = vm_create_default(VCPU_ID, 0, guest_hcall);
> -
> -	vm_init_descriptor_tables(vm);
> -	vcpu_init_descriptor_tables(vm, VCPU_ID);
> -	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
> -
> -	/* Hypercall input/output */
> -	hcall_page = vm_vaddr_alloc_pages(vm, 2);
> -	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
> -
> -	hcall_params = vm_vaddr_alloc_page(vm);
> -	memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
> -
> -	vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
> -	vcpu_enable_cap(vm, VCPU_ID, &cap);
> -
> -	vcpu_set_hv_cpuid(vm, VCPU_ID);
> -
> -	best = kvm_get_supported_hv_cpuid();
> +	guest_test_msrs_access();
>   
>   	pr_info("Testing access to Hyper-V hypercalls\n");
> -	guest_test_hcalls_access(vm, addr_gva2hva(vm, hcall_params),
> -				 addr_gva2hva(vm, hcall_page),
> -				 addr_gva2hva(vm, hcall_page) + getpagesize(),
> -				 best);
> -
> -	kvm_vm_free(vm);
> +	guest_test_hcalls_access();
>   }
> 

NACK
