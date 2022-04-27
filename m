Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C815B5120E4
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243220AbiD0Q1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 12:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243206AbiD0Q0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 12:26:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECBAC29F
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+nitdFLclz4hCiKOCughHUd8fSeC+5gYj0I0ve8svvE=;
        b=U2X3Z91+qfM/pRxwSLqqCMuQo7hmx75g06Yw4CKy7MiuM4xCz7E7tjpYSlN7mEMcqLuGGs
        Z8pPr5BfMh1bXsRGZ3O6kUR/iMPetostSxozWvWOBbOMwSwQl2XPzqQChUDgZMLBWjHaB0
        1fdO++75yD1q6sgqNtzBt3mKRiQuEEQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-fHEnegM-PFWvJpoSWucqYw-1; Wed, 27 Apr 2022 12:19:01 -0400
X-MC-Unique: fHEnegM-PFWvJpoSWucqYw-1
Received: by mail-ej1-f71.google.com with SMTP id ne12-20020a1709077b8c00b006f3aca1f2b2so1430280ejc.17
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:19:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+nitdFLclz4hCiKOCughHUd8fSeC+5gYj0I0ve8svvE=;
        b=m3+kOesG02deAs0TbhkiE7kTeVz+RMf2IftQ5LJmKCNPGX8WcH4RNt4MAgvfPz5U0S
         vNwN/wkuUAoV5qYpI4DeRFEvtnCSLAP5t8leLHCjaZyyNCpIjnNd8Ps9zqB/1AcGSe3R
         54zA7GDWZIXomiBlBdrh1QAvmjbINls4GOlI5f9ZnMsSdZIYBS35OENAF7B3hky1nyiL
         y9upAezLXhyC0LqFdwJgQz1rsvebm6HwSgQfrLFehICNL8dh/U+nrdsgzaWMXRy51ksK
         HKr+kgSc0coZaJpIAmc0rchLRt6m5L1ATgMa6k59ZlZZYyUIRjnbqQyFkiow98oIrLJj
         xoyQ==
X-Gm-Message-State: AOAM533c/dmIp+u00/DWppf1vSPspRgJFlvuenkcdvUVhmcTw9k46Pi1
        SkWuGTbLEjlq0nsUSWU7iLJ9Xxl+mz2u6dPoSJD65eQcdVtcg+e5Hzjf58SceaSWYtkZcHnJJu8
        PR4bIhmko1mTWvbfa
X-Received: by 2002:a05:6402:510c:b0:424:2fe:62c4 with SMTP id m12-20020a056402510c00b0042402fe62c4mr31563226edd.293.1651076340074;
        Wed, 27 Apr 2022 09:19:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTyVenoACrt8z4k8jOAcABQOrZ08jKt1Kb295SQ02vUCx/pQpGBB+ohT8+i8Xz0BHx0nAMbQ==
X-Received: by 2002:a05:6402:510c:b0:424:2fe:62c4 with SMTP id m12-20020a056402510c00b0042402fe62c4mr31563203edd.293.1651076339869;
        Wed, 27 Apr 2022 09:18:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id mf1-20020a1709071a4100b006f39f556011sm3840985ejc.125.2022.04.27.09.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:18:59 -0700 (PDT)
Message-ID: <acab87c6-cbfc-63e1-1bc0-7f963432c412@redhat.com>
Date:   Wed, 27 Apr 2022 18:18:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.4 2/2] KVM: LAPIC: Enable timer
 posted-interrupt only when mwait/hlt is advertised
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Aili Yao <yaoaili@kingsoft.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155438.19612-1-sashal@kernel.org>
 <20220427155438.19612-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155438.19612-2-sashal@kernel.org>
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
> [ Upstream commit 1714a4eb6fb0cb79f182873cd011a8ed60ac65e8 ]
> 
> As commit 0c5f81dad46 ("KVM: LAPIC: Inject timer interrupt via posted
> interrupt") mentioned that the host admin should well tune the guest
> setup, so that vCPUs are placed on isolated pCPUs, and with several pCPUs
> surplus for *busy* housekeeping.  In this setup, it is preferrable to
> disable mwait/hlt/pause vmexits to keep the vCPUs in non-root mode.
> 
> However, if only some guests isolated and others not, they would not
> have any benefit from posted timer interrupts, and at the same time lose
> VMX preemption timer fast paths because kvm_can_post_timer_interrupt()
> returns true and therefore forces kvm_can_use_hv_timer() to false.
> 
> By guaranteeing that posted-interrupt timer is only used if MWAIT or
> HLT are done without vmexit, KVM can make a better choice and use the
> VMX preemption timer and the corresponding fast paths.
> 
> Reported-by: Aili Yao <yaoaili@kingsoft.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Cc: Aili Yao <yaoaili@kingsoft.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1643112538-36743-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/lapic.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index afe3b8e61514..3696b4de9d99 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -118,7 +118,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>   
>   bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>   {
> -	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> +	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> +		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
>   }
>   EXPORT_SYMBOL_GPL(kvm_can_post_timer_interrupt);
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

