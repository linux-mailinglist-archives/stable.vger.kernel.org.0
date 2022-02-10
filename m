Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B274B1343
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244586AbiBJQmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:42:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244614AbiBJQme (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:42:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DCF21E9E
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GiMpyWQBZkNvSUgl12YeYCSR3yRtclrMLG+saR/ZKks=;
        b=VM3L7oEJ6E3ETAmGaz0ZjW+kQsSeeQUVqnxt9Y4C0LVo8/NzUHzhxH7k7QhgGgvW7m116/
        fXdepJSbdIIgyNOVHTNrA20RzDnMb140FIrK4ZMQiP0L4Pux5a3PolYSHv8h4AY0qJxheC
        QMKIFqJcY7NnIvo9efsYgP9CExk27qg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-imaIlBLkMtOkK5SpFkSQbw-1; Thu, 10 Feb 2022 11:42:14 -0500
X-MC-Unique: imaIlBLkMtOkK5SpFkSQbw-1
Received: by mail-ed1-f71.google.com with SMTP id z8-20020a05640240c800b0041003c827edso2029739edb.0
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:42:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GiMpyWQBZkNvSUgl12YeYCSR3yRtclrMLG+saR/ZKks=;
        b=wn0MvNWyY5a333WBMfsyXKiYUjTEFa27XpxBWPAQDYSlo8xYlCYRpZ+BQymuTsyDcV
         TtTmqfrZTub+EEMdyhGBWIIPJKZhTyTEqo4aGUYMlXDwLs0T3DAWv5AX+QDYbEpFX6tp
         KiIZ0fQa5dxAy7s20ZwlKXs5s2CEeiDnNzirmQP8qXiGvUlATGhbz9fQ2dRIK2JsAKFC
         jehLZ/TbMWHxQX3OE3ir4ij91QJ1xjehSXqW4WMzBwEhpzG7c/20rIDkNdeMjt8HWVts
         qQ66Zgj6rgMoh+em0YPWWtNR9X45E5T1x8kjPkRb1JXGgAkZrBRpZtxVM0YO0Meomy6W
         jhyg==
X-Gm-Message-State: AOAM5317vTgt1A6o+kTkIgNLfK+Nu925RAJXrv9bEBDo09e17/J7KOhQ
        HJhwGa8cgihYKssMbx7sBfq4/YSW0IobmDAD3R+EGoWM6cGpEuMXHTYUnYSYAXfj3T0nFnmwANi
        x2dECk9jd7FQa+dfU
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr9076897edd.203.1644511333476;
        Thu, 10 Feb 2022 08:42:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQOd/EnK3UY3ql0GtZd5WhPki0PqFdaJ4y+dLGYLqYsFZVxVpzrSer2fcZ0Dey1LywLiW38w==
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr9076881edd.203.1644511333307;
        Thu, 10 Feb 2022 08:42:13 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id d7sm4054145ejp.98.2022.02.10.08.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:42:12 -0800 (PST)
Message-ID: <24055665-db88-7073-2894-f3dbfe578e49@redhat.com>
Date:   Thu, 10 Feb 2022 17:42:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.16 2/8] KVM: nVMX: eVMCS: Filter out
 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185635.48730-1-sashal@kernel.org>
 <20220209185635.48730-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185635.48730-2-sashal@kernel.org>
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
> index 6255fa7167720..8d70f9aea94bc 100644
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

