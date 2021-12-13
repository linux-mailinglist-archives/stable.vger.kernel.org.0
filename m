Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B53472F37
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239275AbhLMO2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239065AbhLMO2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:28:14 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024EEC061574;
        Mon, 13 Dec 2021 06:28:14 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id e3so53425032edu.4;
        Mon, 13 Dec 2021 06:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fu7D1PiHCGMhAC/K7wAl1cJ0odhOiK16elEls85n5b8=;
        b=CQuDxZS9q+MtKtI3bO6pMndnmbRl6ifkBnK7YVQtkIMHKKoYh9UNwqy47fIuVp48FZ
         UwNS0r+Yg5irWqd+SmUsgapSH+nGeuQ4HHB+MHxLh4Icf/tmL8DAJmq598FwKvm76WCZ
         w/4vLegOCA+t2IoskAOJhuRkoawkprimr+vnwtONYWnB6EtRu+qWvjyP1wTdAbawVHdV
         uYPDjdRnrK3fVUE3PRiQlRghyNECg1j94yOqPrGCBWl3YT0GLEVEEaF5PkTVYWBYKBky
         C0pMtIoDAvcv0kwrgdoaFnOrQtAWX/7X73yJ/1iZyYOARitLGmRgXoC+EtA3noIfkyRF
         gTsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fu7D1PiHCGMhAC/K7wAl1cJ0odhOiK16elEls85n5b8=;
        b=3zEOEtiMg4JdkI4yd72pL37g594sklOxKU2L5lxiUV2jaH6lVB//Ly7uA8MPsoQtef
         KnYoefw+UgOo2oqrxvS5Huwr2lTwB+S4k/bsKUS+yaQKE2TxKJq37pWv3a0bTx74V3Nd
         Tmp3v5G+0UYEkgZ0XwLiWM4Bj1nAeLqqmEOLv/DNmCS9/iXH5dRALPkMX9vJnIlBN7QR
         dbzmedaM6vn3c3NLagz4WHBFNZG6vuRbhGAOzT6QIN1Js0tnl5gm2wp4GcJ+5k7XWxFT
         L7Ysf6yDm2Im1V3KkNuDePhxJjP7bmtrBtjnP4OYJeubOqTJ4DSNZV1FoSqEWgITA4VC
         mmeg==
X-Gm-Message-State: AOAM533/AMm36twHOV6swdUIRWfIMbcoAyFjRfVCsFPAjApyrmdhdQLE
        lcDb7pO7KwQiU1IqWQq3RFE=
X-Google-Smtp-Source: ABdhPJyRd92uW59s3AwTnHrs5w20pXa+foXCWKt8r63t2OEDBQmwNYLCuWXUgmk1+fISQ+pmhbg0Rw==
X-Received: by 2002:a17:907:728a:: with SMTP id dt10mr43805741ejc.526.1639405692487;
        Mon, 13 Dec 2021 06:28:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id w22sm6761851edd.49.2021.12.13.06.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:28:11 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <21a4a92b-3b1e-3620-9d6c-9962d5195aaf@redhat.com>
Date:   Mon, 13 Dec 2021 15:28:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.15 6/9] KVM: x86: Forbid KVM_SET_CPUID{,2}
 after KVM_RUN
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20211213141944.352249-1-sashal@kernel.org>
 <20211213141944.352249-6-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213141944.352249-6-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 15:19, Sasha Levin wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> [ Upstream commit feb627e8d6f69c9a319fe279710959efb3eba873 ]
> 
> Commit 63f5a1909f9e ("KVM: x86: Alert userspace that KVM_SET_CPUID{,2}
> after KVM_RUN is broken") officially deprecated KVM_SET_CPUID{,2} ioctls
> after first successful KVM_RUN and promissed to make this sequence forbiden
> in 5.16. It's time to fulfil the promise.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20211122175818.608220-3-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/mmu/mmu.c | 28 +++++++++++-----------------
>   arch/x86/kvm/x86.c     | 19 +++++++++++++++++++
>   2 files changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0a88cb4f731f4..31392e492ce5e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5022,6 +5022,14 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	/*
>   	 * Invalidate all MMU roles to force them to reinitialize as CPUID
>   	 * information is factored into reserved bit calculations.
> +	 *
> +	 * Correctly handling multiple vCPU models with respect to paging and
> +	 * physical address properties) in a single VM would require tracking
> +	 * all relevant CPUID information in kvm_mmu_page_role. That is very
> +	 * undesirable as it would increase the memory requirements for
> +	 * gfn_track (see struct kvm_mmu_page_role comments).  For now that
> +	 * problem is swept under the rug; KVM's CPUID API is horrific and
> +	 * it's all but impossible to solve it without introducing a new API.
>   	 */
>   	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
>   	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
> @@ -5029,24 +5037,10 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	kvm_mmu_reset_context(vcpu);
>   
>   	/*
> -	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> -	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> -	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> -	 * faults due to reusing SPs/SPTEs.  Alert userspace, but otherwise
> -	 * sweep the problem under the rug.
> -	 *
> -	 * KVM's horrific CPUID ABI makes the problem all but impossible to
> -	 * solve, as correctly handling multiple vCPU models (with respect to
> -	 * paging and physical address properties) in a single VM would require
> -	 * tracking all relevant CPUID information in kvm_mmu_page_role.  That
> -	 * is very undesirable as it would double the memory requirements for
> -	 * gfn_track (see struct kvm_mmu_page_role comments), and in practice
> -	 * no sane VMM mucks with the core vCPU model on the fly.
> +	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
> +	 * kvm_arch_vcpu_ioctl().
>   	 */
> -	if (vcpu->arch.last_vmentry_cpu != -1) {
> -		pr_warn_ratelimited("KVM: KVM_SET_CPUID{,2} after KVM_RUN may cause guest instability\n");
> -		pr_warn_ratelimited("KVM: KVM_SET_CPUID{,2} will fail after KVM_RUN starting with Linux 5.16\n");
> -	}
> +	KVM_BUG_ON(vcpu->arch.last_vmentry_cpu != -1, vcpu->kvm);
>   }
>   
>   void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b7aa845f7beee..2a584070833f9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5088,6 +5088,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		struct kvm_cpuid __user *cpuid_arg = argp;
>   		struct kvm_cpuid cpuid;
>   
> +		/*
> +		 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> +		 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> +		 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> +		 * faults due to reusing SPs/SPTEs.  In practice no sane VMM mucks with
> +		 * the core vCPU model on the fly, so fail.
> +		 */
> +		r = -EINVAL;
> +		if (vcpu->arch.last_vmentry_cpu != -1)
> +			goto out;
> +
>   		r = -EFAULT;
>   		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
>   			goto out;
> @@ -5098,6 +5109,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		struct kvm_cpuid2 __user *cpuid_arg = argp;
>   		struct kvm_cpuid2 cpuid;
>   
> +		/*
> +		 * KVM_SET_CPUID{,2} after KVM_RUN is forbidded, see the comment in
> +		 * KVM_SET_CPUID case above.
> +		 */
> +		r = -EINVAL;
> +		if (vcpu->arch.last_vmentry_cpu != -1)
> +			goto out;
> +
>   		r = -EFAULT;
>   		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
>   			goto out;
> 

NACK

the error says "starting with Linux 5.16" for a reason... :)

Paolo
