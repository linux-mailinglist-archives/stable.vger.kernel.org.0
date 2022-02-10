Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39384B12EA
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244281AbiBJQgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:36:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244276AbiBJQgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:36:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DFC2CC6
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UqSpSbLAke/1OnLd6EmGmfWxLdKIpRgwdlPw5Vgh4vE=;
        b=ElqIO/0CrkZOnKLP5RogCOAFlI0RNnAcQzDSQVdzxPHP1EMij87lrqHrY9qsmN6gROnogG
        HLp03RliVOm79dnCEHFa03G/9MERhPX6+PoqPZ6tZ0y/jb45YYMwufr5SLuH7efJq3NwQL
        /fzF+SLVz9rCKnnuIWoQ6l2Nbr12IkA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-12UcVsugM82d-GK3gUqyyA-1; Thu, 10 Feb 2022 11:36:50 -0500
X-MC-Unique: 12UcVsugM82d-GK3gUqyyA-1
Received: by mail-ed1-f72.google.com with SMTP id u24-20020a50d518000000b0040f8cef2463so3629984edi.21
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:36:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UqSpSbLAke/1OnLd6EmGmfWxLdKIpRgwdlPw5Vgh4vE=;
        b=Kl6LTnwH8hf9wM0GDg0EmQ8dW6hqSafCezZI0sRu+RO0sl1v00xDdjfV+79eMHsiH7
         Ak5UzZQTACdufSuxuDTrqK2jD9ycTvResyNMsdf4hzSIUARHiqvKfmR52ZLr9T8sO9ld
         VKN+F+o4HAFcVbFFbpH+1Sp8p1tHHfjT7zb/7a9bw5IpcdJYMLC0oj0FaMHcQj/wF0gA
         /mK1xOca8IJuB/nyGeFlHGxvRdGPM3b2EwAy9BxXWalEl+iLWyxriVEgk/hZZ6sEyVsy
         3jA5YvlkG1KSoJ3zzXqHUSPGnE35Kh96s9s6023XfW5Gdaa8ZReGX2clHkb42meKP+vj
         Ajyg==
X-Gm-Message-State: AOAM531s6rgfvKERJzD5XHnRi4w2BZbnY0nJVwxVO93dYbKveH5R7FuB
        y67ftFstWi8TQ6YJB1s16ZnGP03mA9n+CEz/3TSPE2a3PNxNkPbiNr8JbdOxb6HIjUhHV55eBk7
        v001qi+tRzt4Fua1Z
X-Received: by 2002:a17:907:c01a:: with SMTP id ss26mr7188153ejc.734.1644511008816;
        Thu, 10 Feb 2022 08:36:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsICHo+zXE5V4n/hNFUlselQb7/jJjtRQ0Tylf3AFGMRI+O1AdLAbOvro//iFc+e5nfma5eg==
X-Received: by 2002:a17:907:c01a:: with SMTP id ss26mr7188140ejc.734.1644511008634;
        Thu, 10 Feb 2022 08:36:48 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.240])
        by smtp.googlemail.com with ESMTPSA id m25sm7118243edr.104.2022.02.10.08.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:36:47 -0800 (PST)
Message-ID: <d1d25157-6511-a37d-0e19-2ef8335a7882@redhat.com>
Date:   Thu, 10 Feb 2022 17:35:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.4 1/2] KVM: nVMX: eVMCS: Filter out
 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185733.49157-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185733.49157-1-sashal@kernel.org>
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
> index 07ebf6882a458..632bed227152e 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -58,7 +58,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
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

