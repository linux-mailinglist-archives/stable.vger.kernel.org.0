Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004C94B12E4
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244289AbiBJQgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:36:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244281AbiBJQgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:36:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0C1AC26
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/fQVdIUzzjQxIpql8Jx49HwHgnVddQNgjxM6PvOna24=;
        b=ZjyXNwg2MHqj5kpWkrnWtCyeqPfHQGeAhnWtxoNHhIssL+tmQf5lqN6fBdsQe46vezovJQ
        Y5v4QeEAOTAyYK/7ACste6wWD4H2On2iwKzv+g2QhJFG8q8KmBXbzFYaY5+pUNTQQpW7fK
        KG9CON76oOxtWXg8NqZpz7xSHpOT4SE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-eDWrWkBkOXOq8Oya5TPyZg-1; Thu, 10 Feb 2022 11:36:49 -0500
X-MC-Unique: eDWrWkBkOXOq8Oya5TPyZg-1
Received: by mail-ed1-f71.google.com with SMTP id bq19-20020a056402215300b0040f276105a4so3669131edb.2
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:36:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/fQVdIUzzjQxIpql8Jx49HwHgnVddQNgjxM6PvOna24=;
        b=D9Z4xsYioyNJvcdQINzbBoYV967eWMO2M/cZtZVUgk/BgEBT4cqr50A/Ql60mlBAXq
         kgstLFjqSXlr7M7uFDwpqSxKp1d19fwVxkVsHBviuIYA9opB+hb3+dHF4teZEyjD/2YK
         hdtCiN9aHHl5aTR1fKkKRMTGcBTCU2HNPLwDwlw+yh8E2bbHn0n+/ZgDLJpX96MT6auP
         4/cIvq6NHo1A3NiMCVahvqakX42DvexjxGG8F9yCgAm1W5h9IatrexCIRsAAn/qmJslD
         y+FCyav223/V2/7X96luP9+exNF77RajlMl7/gJAwW5nMI6zVGHV5O3vJ6pqzkeqaz39
         1H2w==
X-Gm-Message-State: AOAM533gXFqVTA1x3NA/UdjOyEUs11TlGiFQMjOEDCApwzBiddxGkXgs
        69gFj/828kkF8wSA06nHuJorZ14cw3pPDRrjyFBIycPHeGz0I2ctBj72G5i4/7ZmUSU72BAlH7E
        nJXSUTEF5j90o6k8x
X-Received: by 2002:a17:907:7244:: with SMTP id ds4mr7265210ejc.726.1644511008413;
        Thu, 10 Feb 2022 08:36:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6CN/+k3HOwVp0gN4FoNF8oTtdpf2diiDEjSfqTdMHbRz9eh1mpO7OJBm9xmaOP360bR4laQ==
X-Received: by 2002:a17:907:7244:: with SMTP id ds4mr7265187ejc.726.1644511008170;
        Thu, 10 Feb 2022 08:36:48 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.240])
        by smtp.googlemail.com with ESMTPSA id cz12sm4919434edb.30.2022.02.10.08.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:36:47 -0800 (PST)
Message-ID: <d24f6c79-070a-846d-276f-9ab15d8fda3b@redhat.com>
Date:   Thu, 10 Feb 2022 17:35:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.4 2/2] KVM: nVMX: WARN on any attempt to
 allocate shadow VMCS for vmcs02
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185733.49157-1-sashal@kernel.org>
 <20220209185733.49157-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185733.49157-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
> index 3041015b05f71..44e11f6db3efe 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4360,18 +4360,20 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
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

