Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EA64B12E9
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244311AbiBJQgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:36:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244303AbiBJQgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:36:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 087E5128
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C2hvu0iP1ozzImdwOawq7RtiNZp/sNLo/TZHQM9dTsg=;
        b=BwlTkMZXpqsUSUb11xzLgJFbYp6LYoHDz9CJaBrt3ipzB1REf4FKQGcTjrriNhsA6K9LUG
        5joyATGbZe3gXjhyd/8QikN7IilYG7Yps/f44cH6RmiZjw0miP7ESyClV3IJ5N5VmgvrJZ
        a4A9H26JeyjtAuK3QJ6grkibsbwPQ4Q=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-_aF0uWsdMPm-9HtRQ_QqxA-1; Thu, 10 Feb 2022 11:36:53 -0500
X-MC-Unique: _aF0uWsdMPm-9HtRQ_QqxA-1
Received: by mail-ej1-f72.google.com with SMTP id aj9-20020a1709069a4900b006cd205be806so2983561ejc.18
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:36:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C2hvu0iP1ozzImdwOawq7RtiNZp/sNLo/TZHQM9dTsg=;
        b=ZS0iEWkce9nwPMPGshln0efhkp1mZS0q8Vmmmt3ruSsr7KKNVKguof7XzvM6eQnRYs
         wBhmijaJmLMIgB9VW2i9FG9g1tzLINGng3CvGmWnCNVHzZIwPNDmhWb7W6sKYN+f9HKi
         meqvF37ycJ+xOpC2LKp6ZN1F0pOR9Fh303IjKiHdZJ5qztQ028i/pAobhj0x0qxyjaPr
         OGb3eE5MuKSKV/jQiXI4xNF7+cwdoulNuNm9Ml7ub5RO0+Ofx8TD4KsyAbZymzD2daLT
         V1VAkQIhvZe4Eil0I5IQ8aPKw2iiEEq4ed2bCjThal4NVQPgzpdJlgWVGSG99ugJibVD
         ziDw==
X-Gm-Message-State: AOAM530FMLT6M1XUySRz8wmduVh6nJR/7PU4KyNCCsYLgB1Anse60pER
        uDjmzuq00ayz877T5QLNakhqKpiIvOoJ2BmzqNHTRYpyjWUpdtFT0MgoEc+y8czWoY2ff/KyCQm
        UVzJQwyesuf/aAml4
X-Received: by 2002:a05:6402:348b:: with SMTP id v11mr9188561edc.58.1644511011943;
        Thu, 10 Feb 2022 08:36:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJfC1GU+5eGfGNQQxuYJPtmnQ9Njp+YLT1I+95acuMLcAIv38IH5OD1zORnBLD/pfnnJ+cWw==
X-Received: by 2002:a05:6402:348b:: with SMTP id v11mr9188549edc.58.1644511011762;
        Thu, 10 Feb 2022 08:36:51 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.240])
        by smtp.googlemail.com with ESMTPSA id g19sm4365247ejd.62.2022.02.10.08.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:36:50 -0800 (PST)
Message-ID: <fd3ffa55-5421-fd18-9dc2-82805b694e14@redhat.com>
Date:   Thu, 10 Feb 2022 17:33:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.16 4/8] KVM: nVMX: WARN on any attempt to
 allocate shadow VMCS for vmcs02
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185635.48730-1-sashal@kernel.org>
 <20220209185635.48730-4-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185635.48730-4-sashal@kernel.org>
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
> index c605c2c01394b..9cd68e1fcf602 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4827,18 +4827,20 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
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

NACK, it's just extra care but not particularly useful.

Paolo

