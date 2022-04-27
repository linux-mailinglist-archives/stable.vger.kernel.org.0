Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF41511FCD
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242726AbiD0Q1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 12:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243136AbiD0Q0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 12:26:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94584263C98
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cvcOaXCpruv4T1c9qiJWLMyaDmKLEQmVrfnev71Sng=;
        b=f2AxcsMvXuQXhtf/mx6TsHncyuVlkdl9IgnhpGBAfKnNIPF6Ozkxop1q4fdqAIM9p6eI55
        6vlSEsnPcqP046bqmTiukMhos2BR4TspnT71Zo3tm3SVHuKrEEjQY6LMCP5NeVSawdJsFu
        aSbD5ACGm7Pf12AEBgBSI7gmutkeyYU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-OYy-N-GEM2OoBXmXmlFQDw-1; Wed, 27 Apr 2022 12:19:33 -0400
X-MC-Unique: OYy-N-GEM2OoBXmXmlFQDw-1
Received: by mail-ed1-f69.google.com with SMTP id ch28-20020a0564021bdc00b00425cb227ab4so1274209edb.4
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:19:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1cvcOaXCpruv4T1c9qiJWLMyaDmKLEQmVrfnev71Sng=;
        b=YHDTJhIG+3GndIvC0dc0QITfA4HfcQUNwE496s+BUtdEzKcfYtIXJWFNB0my1rw9j6
         WAKSkRZQbhtDwNjFrMnPrCI6P+uNkFQfmvGgPmX4C0faWwOnfKc7YUOBgvvWRfSO1TSi
         tseyA2YO5NRiVNQCCKhz2qlnjZbBPIId8in+S4/7e/CLh3T3VvCh9F2xgfBxib1eKQA2
         J3pzRR8sKnn75I7MKzNynn4Ngztn9kUks/8Wfy6W4G8gNrVxyiM0/Q93IsfNjKRD4Mmm
         C1ry5Ww0OnczBzD/2Vvan2CgQ+Vv/JVSobAcYvFAKMvbYQGTw6DWpU5KxTJkQnjibTpv
         Kgaw==
X-Gm-Message-State: AOAM532T3kq7ceQiewdar1i5rFWhPGis+PFpPqQMPyZWWqtr+ZUv73Ad
        nR4sgfDznKmHpLEYhXvQmpIzjcFz+VamFtSHvR61pNTrYGytEj9uT3nN4RN1B6FYLBhKvLFrT9P
        TjoJ6xVb6FlAGfwvF
X-Received: by 2002:a17:907:1c8d:b0:6f2:eb2:1cd6 with SMTP id nb13-20020a1709071c8d00b006f20eb21cd6mr19630439ejc.568.1651076372547;
        Wed, 27 Apr 2022 09:19:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOw3/rr2uhK+bOiKaMJvU87tDXfQr2FFam0AAS2cqlmruwG3KHI4kJpoc4faRL6UiMeQMUlQ==
X-Received: by 2002:a17:907:1c8d:b0:6f2:eb2:1cd6 with SMTP id nb13-20020a1709071c8d00b006f20eb21cd6mr19630317ejc.568.1651076370838;
        Wed, 27 Apr 2022 09:19:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id q6-20020a17090622c600b006f3876cd90csm5206122eja.198.2022.04.27.09.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:19:29 -0700 (PDT)
Message-ID: <ede8b06a-1458-b96d-917a-2de75736a53a@redhat.com>
Date:   Wed, 27 Apr 2022 18:19:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.15 3/7] x86/kvm: Preserve BSP
 MSR_KVM_POLL_CONTROL across suspend/resume
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155431.19458-1-sashal@kernel.org>
 <20220427155431.19458-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155431.19458-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/22 17:54, Sasha Levin wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> [ Upstream commit 0361bdfddca20c8855ea3bdbbbc9c999912b10ff ]
> 
> MSR_KVM_POLL_CONTROL is cleared on reset, thus reverting guests to
> host-side polling after suspend/resume.  Non-bootstrap CPUs are
> restored correctly by the haltpoll driver because they are hot-unplugged
> during suspend and hot-plugged during resume; however, the BSP
> is not hotpluggable and remains in host-sde polling mode after
> the guest resume.  The makes the guest pay for the cost of vmexits
> every time the guest enters idle.
> 
> Fix it by recording BSP's haltpoll state and resuming it during guest
> resume.
> 
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1650267752-46796-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kernel/kvm.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index bd7b65081eb0..d36b58e705b6 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -66,6 +66,7 @@ static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __align
>   DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
>   static int has_steal_clock = 0;
>   
> +static int has_guest_poll = 0;
>   /*
>    * No need for any "IO delay" on KVM
>    */
> @@ -650,14 +651,26 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
>   
>   static int kvm_suspend(void)
>   {
> +	u64 val = 0;
> +
>   	kvm_guest_cpu_offline(false);
>   
> +#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
> +	if (kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
> +		rdmsrl(MSR_KVM_POLL_CONTROL, val);
> +	has_guest_poll = !(val & 1);
> +#endif
>   	return 0;
>   }
>   
>   static void kvm_resume(void)
>   {
>   	kvm_cpu_online(raw_smp_processor_id());
> +
> +#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
> +	if (kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL) && has_guest_poll)
> +		wrmsrl(MSR_KVM_POLL_CONTROL, 0);
> +#endif
>   }
>   
>   static struct syscore_ops kvm_syscore_ops = {

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

