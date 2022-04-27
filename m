Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F365511DE8
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242329AbiD0QUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 12:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243901AbiD0QUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 12:20:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6580F86E35
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DJyESBBKfv4Cx6IqvqpIfsWyZ1HDqBgutDwdLC0W60=;
        b=AnGZodbeaucmfxabsgsguzPCMuI0fk8kYbC3SCKFmnrOuXHGg+puAp+0UFbSGC6T+Phz0Z
        IAlLgkiO+Ww0kmnmYbW60+Y0Eucw0N2frHE47MWfz9Y/ZbomZOUsZmrSLgl5kNO3BvGsj+
        pXb0Jjqm8gUKDDjZC+6EbxnsK4lY5JI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-ht0iJ2-9OWuPN_DHDuMC7w-1; Wed, 27 Apr 2022 12:16:24 -0400
X-MC-Unique: ht0iJ2-9OWuPN_DHDuMC7w-1
Received: by mail-ed1-f72.google.com with SMTP id cm1-20020a0564020c8100b0041d6b9cf07eso1253727edb.14
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4DJyESBBKfv4Cx6IqvqpIfsWyZ1HDqBgutDwdLC0W60=;
        b=8HtaibF7NEnXrGn6zyo0B8AbHv39y9cmvLiezDI1PnzVbcR3vVsH9D2G+ObBzQwms6
         zKH48vLIaIZVcZJSAZLZxvWYsP0c38E7q5A4K/0zbyjlBluG3MLA0/J9kB29HjbHenLT
         XmTY7WpjvrbTamKk9fl+W7UdSTV/xU0llKcmhPcVf0dm+qtdA5ghRn6hObAqKLa5D1Fl
         2mqkJ6nYUTtMpgGqYvilQV0K7ua1iD2oSMmyOkbAlkAc4Bc8HEO6GE1MvcbtdWq4LCau
         AFVC7LH76Z99LDDZnp8NtzuBZNTJQNhkqOZpvKjmeAJaOaxY9TJsbAqhtNpoptwQd6kB
         WeTA==
X-Gm-Message-State: AOAM533msqvZ4FjEz0p+9UkSu7M08L9j1CLHxRvEaFRecy8VSgYFobpE
        XuQ3k9VhcDIE8USjSgqt0UukLxgYcx9gNWKETqOmkFZuOWdn/d1zB/YbJ5vF3k+PkmypZcPp2Pu
        vY+DMbbuGNzl+l8tV
X-Received: by 2002:a17:907:3f25:b0:6b0:5e9a:83 with SMTP id hq37-20020a1709073f2500b006b05e9a0083mr28543245ejc.659.1651076183066;
        Wed, 27 Apr 2022 09:16:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbHnMwhrUavgLAEph26Pn2TGlnZOPdIVTeG1iNt5jyDcQ5EQHMMAe9gdm9OdyjsGwOTF1XZw==
X-Received: by 2002:a17:907:3f25:b0:6b0:5e9a:83 with SMTP id hq37-20020a1709073f2500b006b05e9a0083mr28543217ejc.659.1651076182735;
        Wed, 27 Apr 2022 09:16:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id t27-20020a1709063e5b00b006f3a94f5194sm3343922eji.77.2022.04.27.09.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:16:22 -0700 (PDT)
Message-ID: <5847c4b7-aaae-e090-cdf3-2275a8f08685@redhat.com>
Date:   Wed, 27 Apr 2022 18:16:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.17 3/7] x86/kvm: Preserve BSP
 MSR_KVM_POLL_CONTROL across suspend/resume
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155408.19352-1-sashal@kernel.org>
 <20220427155408.19352-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155408.19352-3-sashal@kernel.org>
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

On 4/27/22 17:53, Sasha Levin wrote:
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
> index ed8a13ac4ab2..4c2a158bb6c4 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -69,6 +69,7 @@ static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __align
>   DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
>   static int has_steal_clock = 0;
>   
> +static int has_guest_poll = 0;
>   /*
>    * No need for any "IO delay" on KVM
>    */
> @@ -706,14 +707,26 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
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

