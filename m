Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719044B12F1
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244355AbiBJQhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:37:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244327AbiBJQg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:36:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C324E137
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f/F8usK/+OWwDrS2Mysaltt+CBSk5zwPQAlyY9XUelc=;
        b=enVV39vcTf/HPRxWPI9XWwNkAhA4HPcqOj0uFgQG6Ebg2Cz4CikAFRn6fracv0cCZiqCa7
        CzZI+yzyK8uoPaO+6rGmnD14UHgFZ2PXslFyU4OBZfFxEjJzRJJGMMcsdLrkx8bqGDX+fq
        ldXxGatXjDnyY3G9PyfPCbm2h3QCdCo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-bZO7b1ogO9eCc9is4sqWuQ-1; Thu, 10 Feb 2022 11:36:56 -0500
X-MC-Unique: bZO7b1ogO9eCc9is4sqWuQ-1
Received: by mail-ej1-f72.google.com with SMTP id k16-20020a17090632d000b006ae1cdb0f07so2979224ejk.16
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:36:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f/F8usK/+OWwDrS2Mysaltt+CBSk5zwPQAlyY9XUelc=;
        b=2QxmJSp2fAvgh3zU+kG31Lgs2j/c9lqNTzEG6bmr0xakUl2wkapYQOoI6GyKV0QwCk
         gds7SFDjivy5K3cPrQdGjdYI6XGOdRKxvEzSKjX0+Ph78SCL5fMfGX0UzM2XstW/827l
         Ie8vDM/ezA2UaogDPzs4H421Mb0IDEIvbmuy09QM1vdhxRlTx9Y+1WLwKCT+FKqsMCjK
         s7pf/UZtpFCm8iwI48B7nbB5xVLKpU1h9A31wGtFGTMVXDnaIGg+rk1Zolf3TJ+oCwP7
         hPe95BjIRQGOGBW0+oObNHMzb/rKLLB0kVx7lhsTnF3+p8UsMwd6rTh8q2bUF+Mp0HiR
         wCRw==
X-Gm-Message-State: AOAM532Uvhe64PBleigbXfBt3HIizNGVjQflns6RlOvTMBN8vEPuPwus
        2LHN2WzFNIirD2HB6dezsT87ju7H7A0GYxhH+m94stDkqVwT68BJ6Hc1jJehB1Cw7GtpO3gIaew
        YZ99I22Y0nACEMsnj
X-Received: by 2002:a17:906:2ed1:: with SMTP id s17mr7342461eji.174.1644511015574;
        Thu, 10 Feb 2022 08:36:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzC0ul3dl+hcrAmDYZTPnQFJaDZrWBZxFPAbbw2BCoE9Jfu0NVY0ZSkzikKjxBe05mTUn5T4A==
X-Received: by 2002:a17:906:2ed1:: with SMTP id s17mr7342447eji.174.1644511015370;
        Thu, 10 Feb 2022 08:36:55 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.240])
        by smtp.googlemail.com with ESMTPSA id b17sm5678470ejd.34.2022.02.10.08.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:36:54 -0800 (PST)
Message-ID: <52ec7622-efcf-dfd6-2560-3114f90f7618@redhat.com>
Date:   Thu, 10 Feb 2022 17:35:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.10 4/6] KVM: nVMX: WARN on any attempt to
 allocate shadow VMCS for vmcs02
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185714.48936-1-sashal@kernel.org>
 <20220209185714.48936-4-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185714.48936-4-sashal@kernel.org>
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

On 2/9/22 19:57, Sasha Levin wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> [ Upstream commit d6e656cd266cdcc95abd372c7faef05bee271d1a ]
> 
> WARN if KVM attempts to allocate a shadow VMCS for vmcs02.  KVM emulates
> VMCS shadowing but doesn't virtualize it, i.e. KVM should never allocate
> a "real" shadow VMCS for L2.
> 
> The previous code WARNed but continued anyway with the allocation,
> presumably in an attempt to avoid NULL pointer dereference.
> However, alloc_vmcs (and hence alloc_shadow_vmcs) can fail, and
> indeed the sole caller does:
> 
> 	if (enable_shadow_vmcs && !alloc_shadow_vmcs(vcpu))
> 		goto out_shadow_vmcs;
> 
> which makes it not a useful attempt.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20220125220527.2093146-1-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/nested.c | 22 ++++++++++++----------
>   1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0c2389d0fdafe..0734a98eaaad1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4786,18 +4786,20 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
>   	struct loaded_vmcs *loaded_vmcs = vmx->loaded_vmcs;
>   
>   	/*
> -	 * We should allocate a shadow vmcs for vmcs01 only when L1
> -	 * executes VMXON and free it when L1 executes VMXOFF.
> -	 * As it is invalid to execute VMXON twice, we shouldn't reach
> -	 * here when vmcs01 already have an allocated shadow vmcs.
> +	 * KVM allocates a shadow VMCS only when L1 executes VMXON and frees it
> +	 * when L1 executes VMXOFF or the vCPU is forced out of nested
> +	 * operation.  VMXON faults if the CPU is already post-VMXON, so it
> +	 * should be impossible to already have an allocated shadow VMCS.  KVM
> +	 * doesn't support virtualization of VMCS shadowing, so vmcs01 should
> +	 * always be the loaded VMCS.
>   	 */
> -	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
> +	if (WARN_ON(loaded_vmcs != &vmx->vmcs01 || loaded_vmcs->shadow_vmcs))
> +		return loaded_vmcs->shadow_vmcs;
> +
> +	loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
> +	if (loaded_vmcs->shadow_vmcs)
> +		vmcs_clear(loaded_vmcs->shadow_vmcs);
>   
> -	if (!loaded_vmcs->shadow_vmcs) {
> -		loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
> -		if (loaded_vmcs->shadow_vmcs)
> -			vmcs_clear(loaded_vmcs->shadow_vmcs);
> -	}
>   	return loaded_vmcs->shadow_vmcs;
>   }
>   

NACK

