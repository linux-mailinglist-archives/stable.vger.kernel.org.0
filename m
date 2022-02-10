Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C009D4B1315
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244432AbiBJQkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:40:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243856AbiBJQkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:40:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A40A397
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nigEQRbvPayjvXW0XlHeZl0iZUMoL4B76AS5wQcOkCU=;
        b=AC53FpwGN9DWO2HdGXwmnQzLpdDYJdUhdiD75IWktoZH2C2ymgffygmX2CGDRSplrhP9Mf
        YpVmb9q/bbYflDMjOV2jhKTLP+DSc5JLXgrbZABjR9ZNUU0u6b4QCMY+k3uhBxvhlGP5eT
        bvdaA7cPV1E0W0z5gvkhlBi+RDxYLnQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586--_qzw1mNNMSnhZfUKhTsOg-1; Thu, 10 Feb 2022 11:40:14 -0500
X-MC-Unique: -_qzw1mNNMSnhZfUKhTsOg-1
Received: by mail-ed1-f71.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso3646895edt.20
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:40:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nigEQRbvPayjvXW0XlHeZl0iZUMoL4B76AS5wQcOkCU=;
        b=X3AXPicWGFTLLPDzRqVVJuDbZWRkNrP4LuJj6hoVSOgxTSpaM5Ome1JV2cMIvQYj7+
         5JTVQbvVEIVHOUfIRcrquRqFcGSb8gLuLlN0/o15+SYLN39ofjZAbavpUOQ5b6rcCLob
         gqLIDZdL4tUo4ANLi75TnBgQYGxeh0fNEMrBMRSlTUyMejBlmHCwM1IR7A7OR35LDVct
         mg7fypG/VHcxj6wwMXxcgnlo+LQWUAYhmCTmDQmEyztO1zAvhEVjI9PfXNjK0Sm7J9lx
         dlQvtG7kiIg2MDK+j+XWHPaZI6AVOVXc4FQLhszueM3PrdbtEwSNsoBUtEX9KAqgwatE
         gJGQ==
X-Gm-Message-State: AOAM532l09A9mWBg7cO/CKHvLEOwM9+y4+dsjimts4D0xVZIUefWXg/F
        tnAIbkAKqhrRySDaDJqIE83EsqD1KQ1oK/18EKo85YuIQXOa1tY5YUrgsnu80YZPCZzKmguAgbv
        ExRz9LpL03j+ESLFL
X-Received: by 2002:a17:907:2d8b:: with SMTP id gt11mr7139411ejc.569.1644511212965;
        Thu, 10 Feb 2022 08:40:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQZvjS9s8eet7LG+6PKKUUfksHgZbeDe2kZG8ReoUuVkfOdo/bc9hM5bkSQ3rawe8Em+Icdg==
X-Received: by 2002:a17:907:2d8b:: with SMTP id gt11mr7139394ejc.569.1644511212725;
        Thu, 10 Feb 2022 08:40:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id b7sm5051849ejv.71.2022.02.10.08.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:40:12 -0800 (PST)
Message-ID: <75878676-53d4-62a3-9b22-deeedbaa24b8@redhat.com>
Date:   Thu, 10 Feb 2022 17:40:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.15 2/8] KVM: nVMX: eVMCS: Filter out
 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185653.48833-1-sashal@kernel.org>
 <20220209185653.48833-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185653.48833-2-sashal@kernel.org>
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
> [ Upstream commit 7a601e2cf61558dfd534a9ecaad09f5853ad8204 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Enlightened VMCS v1 doesn't have VMX_PREEMPTION_TIMER_VALUE field,
> PIN_BASED_VMX_PREEMPTION_TIMER is also filtered out already so it makes
> sense to filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER too.
> 
> Note, none of the currently existing Windows/Hyper-V versions are known
> to enable 'save VMX-preemption timer value' when eVMCS is in use, the
> change is aimed at making the filtering future proof.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220112170134.1904308-3-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/evmcs.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index 152ab0aa82cf6..b43976e4b9636 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -59,7 +59,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>   	 SECONDARY_EXEC_SHADOW_VMCS |					\
>   	 SECONDARY_EXEC_TSC_SCALING |					\
>   	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
> -#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> +#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
> +	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
> +	 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
>   #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
>   #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
>   

