Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105FA4B1326
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244611AbiBJQlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:41:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244588AbiBJQl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:41:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46123EAE
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c76TY/Lf9vGtdtSKxrTk+CcrzQFfK8X08gIXW4V4h6g=;
        b=f0c/4tUysahIU2kXSOoBn3cNjrzTwCaHRGomJAdHXz7agRIhFUWaeABa1Erd1OWigpkZdE
        lWYa4ycM3bmbdUF0rRE6Ps9QkPYLmb478LLJ1liM9u2T/70JHN6p2t895+UIlTBTiftB0k
        4s/ZiDewt+H92Pbp8rOoTEf9tdUF8nc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-345-8vIJOO_gMDerItcdWU8FVA-1; Thu, 10 Feb 2022 11:41:25 -0500
X-MC-Unique: 8vIJOO_gMDerItcdWU8FVA-1
Received: by mail-ej1-f72.google.com with SMTP id aj9-20020a1709069a4900b006cd205be806so2989450ejc.18
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:41:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c76TY/Lf9vGtdtSKxrTk+CcrzQFfK8X08gIXW4V4h6g=;
        b=pMmVxH+VNNUkBuu4QIdy9itQqTC6hkhOm8zzWQOvJXb+Q76XjcE2cyTadNt9m0dPzV
         SpS2QDV7DlFz+rzgxXhhYpXHyuCCuk3RPZCcwd9GXLtMuqm4JIL17LcGdFbH9nG8JK/X
         0y6s0U1H/mxJKhPB20z9qRAAyXXISXjo0m/Ys8j7rtykQWTfRb/GTIC1kcqtBvBA4WkJ
         0bbWTyML0GGqOi9zey0KGFliT3qXc6Y2s7vTTdiYgGn4YlifxLf72SUGF5tNFObK2SI3
         3fOhNjQF4n7pMopERnLiVBoYeiA7TJWtPeyDqM59kx29d93Jqz5MeTVLG8goL9z8eUUl
         g+OQ==
X-Gm-Message-State: AOAM53265m/wok1ov+R7k1tz2bShCkb/0s87ZhKtPLqnUykcmFh2jj4T
        rwqx3/8FfVOLS5MN0TRjobLMOuhOIdgasAmYODVOl+na82eHFrp2YX4W5kYqr0U0JUXp77+bryD
        admvKSLmZtjvKcxKo
X-Received: by 2002:a17:907:928:: with SMTP id au8mr7140385ejc.72.1644511284003;
        Thu, 10 Feb 2022 08:41:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwIHJWFMcWztpA4HFLOTg5SPTS1NtIgJy8cVRmDYXzjsRfOraiV82VHp5xzZYVu5+fa68b+DQ==
X-Received: by 2002:a17:907:928:: with SMTP id au8mr7140368ejc.72.1644511283794;
        Thu, 10 Feb 2022 08:41:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id w12sm6590943ejv.43.2022.02.10.08.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:41:23 -0800 (PST)
Message-ID: <c4e17af9-a46d-b5d2-d552-bfadbe55af21@redhat.com>
Date:   Thu, 10 Feb 2022 17:41:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.15 4/8] KVM: nVMX: WARN on any attempt to
 allocate shadow VMCS for vmcs02
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185653.48833-1-sashal@kernel.org>
 <20220209185653.48833-4-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185653.48833-4-sashal@kernel.org>
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
> index a0193b11c381d..42559c21fb2cc 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4840,18 +4840,20 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
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

Paolo

