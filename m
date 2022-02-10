Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C85C4B134E
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244656AbiBJQmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:42:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244647AbiBJQmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:42:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0172AEB5
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WbSB3R6hIGKbcN8v0UfyEPhUaSJxd4lV0BVYGbHqWLw=;
        b=AhneOZbz559ivCsjIAU/Ba5VJf7rB0GMKMA7dinXE61vrSS830V39FwmbbI/tKQnPXndNc
        8KlPG09qUYVpcI7rjERBT/k0555N4rpHNX8snEqmE1xU4ZS8v/AxUz0qSEVnVpLgvRMRTq
        xSOneVUCk7SOoOkXcc04zu4XBBTWjWU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-mYNl1YQOMt212lM_cncYwg-1; Thu, 10 Feb 2022 11:42:24 -0500
X-MC-Unique: mYNl1YQOMt212lM_cncYwg-1
Received: by mail-ej1-f70.google.com with SMTP id h22-20020a1709060f5600b006b11a2d3dcfso3008758ejj.4
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:42:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WbSB3R6hIGKbcN8v0UfyEPhUaSJxd4lV0BVYGbHqWLw=;
        b=G4g2s8o3DW0bJ0M38rJT3CjAUQ7l+IRLGMw5CR8jryDfAvJ+KaI5NK9AmlhOIeQ72H
         ZuxWMayAZZvCUss+l822RRweuf73jffYzAeASSsfoCML4Lz9rig1+nsXOKjyslKwcEUf
         t2M0n9xBqqM8hvecymemZQLXwLNavNgYbQMCkySZJWXEceLyGGI0PGCqNTeKuEMb4Nnm
         m6DaHWHcyvSTgRvjg7WZDfANyiMM7oihsrI957p2DY4lAhsgeE1knE6691ff34K/hYQx
         87s5/JaGnj2UpPhHl9gxilF1fwqTEcZRW8M1glAyfiK+YQTCZD2qfrz6UYw8yT0gT5Pi
         KQ4A==
X-Gm-Message-State: AOAM530wKjgCp0xRr7WdC1uZ3L1tImLIwEZVAOd1+OC9pyJ4nH6MEcHw
        HHliFQxhI3eoytR0tGtBWj/WwaEHtLHEOmjbvl4LX+pRodRpZHbn4JwPqi4HsEkKA+yB3+vDl8B
        8DQgAyLgzn+r8uAiL
X-Received: by 2002:aa7:db01:: with SMTP id t1mr9168305eds.394.1644511343075;
        Thu, 10 Feb 2022 08:42:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwRpAdwmweVJR5mrpCOkEu5s3jJ7kkaz6E46rw+PJmDvR6QqXd7P3MHY69LFpm8vPahzz5dhw==
X-Received: by 2002:aa7:db01:: with SMTP id t1mr9168289eds.394.1644511342899;
        Thu, 10 Feb 2022 08:42:22 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id f26sm6975948edq.73.2022.02.10.08.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:42:22 -0800 (PST)
Message-ID: <f1222fef-b5cd-f27e-780e-b69ac1b8f704@redhat.com>
Date:   Thu, 10 Feb 2022 17:42:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.16 3/8] KVM: nVMX: Also filter
 MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185635.48730-1-sashal@kernel.org>
 <20220209185635.48730-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185635.48730-3-sashal@kernel.org>
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
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> [ Upstream commit f80ae0ef089a09e8c18da43a382c3caac9a424a7 ]
> 
> Similar to MSR_IA32_VMX_EXIT_CTLS/MSR_IA32_VMX_TRUE_EXIT_CTLS,
> MSR_IA32_VMX_ENTRY_CTLS/MSR_IA32_VMX_TRUE_ENTRY_CTLS pair,
> MSR_IA32_VMX_TRUE_PINBASED_CTLS needs to be filtered the same way
> MSR_IA32_VMX_PINBASED_CTLS is currently filtered as guests may solely rely
> on 'true' MSR data.
> 
> Note, none of the currently existing Windows/Hyper-V versions are known
> to stumble upon the unfiltered MSR_IA32_VMX_TRUE_PINBASED_CTLS, the change
> is aimed at making the filtering future proof.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220112170134.1904308-2-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/evmcs.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 09fac0ddac8bd..87e3dc10edf40 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -361,6 +361,7 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>   	case MSR_IA32_VMX_PROCBASED_CTLS2:
>   		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
>   		break;
> +	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
>   	case MSR_IA32_VMX_PINBASED_CTLS:
>   		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
>   		break;

