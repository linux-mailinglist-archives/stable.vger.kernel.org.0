Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E2143B6AF
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 18:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbhJZQRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 12:17:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22401 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237287AbhJZQRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 12:17:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635264913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=88Rkl+iSlWV4zTixa3/lQhf8BLub/pRqqTRv2UK1h+Q=;
        b=eMvgOGW3+6g4zqMXdzZLld/edk/OfyF288OFkFnCEpPKzOam5SzFWrw9CQfhtZAZ6zoLoh
        1gs+VdkF1h9EH11VbSLPcZnT1YOkoVjzFbaqO4ddwSttOdmxKiP6mFvJkKIRqIZkMQRqpi
        rEaMh0ZYQgpLwF2eSlpGwkawXdmfZqA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-Ndj4dWGAOFCKGwaVoHi1fA-1; Tue, 26 Oct 2021 12:15:12 -0400
X-MC-Unique: Ndj4dWGAOFCKGwaVoHi1fA-1
Received: by mail-ed1-f72.google.com with SMTP id w7-20020a056402268700b003dd46823a18so7662316edd.18
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 09:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=88Rkl+iSlWV4zTixa3/lQhf8BLub/pRqqTRv2UK1h+Q=;
        b=lsSocQd7mveXIMYotStT6w2PRv2I+qfJqFgPsiTEOWvzwNounh/GryYlwQRh6wgi8B
         fn/bSBD1DRes+yjnSTFGQbU6Hhz0KTr1FwjxeC2e2wB2MtgLCzBF6hETmkKMA/6fZ9Rv
         18G5Z7xRYnECDWIwFAOxoqSK1st72/OXq4UJaTdg8Z+DnfVY0cevJM/uNRK54+RuTLVk
         hiKy30wlh0ZT+TtjwUgVwOgW/Rk1/bbB/WMFleX1N5RbTBqsOvvs1dCXQjLZaFK1tVuB
         hY+aJMDLAURDkg4knLu2kPqu2uUvMyhCSYdNaMqaJ0J8eg1H+xhlI2e+00Hw9Mbb44Ve
         uQEw==
X-Gm-Message-State: AOAM532eHtWXC/M5qfaie7ZaPddoVqvIKCjoIir4avIWPkCM9vORun2Q
        o7+LkkRmeTLz6H9ayZXAAe4qPPxqNk1O9M6bdjdWtjzhud4YwOUghKSlcb6lMjeAiHMtv/Qp808
        cRvrka4vuKcWQQPzo
X-Received: by 2002:a05:6402:40cd:: with SMTP id z13mr36070875edb.220.1635264911080;
        Tue, 26 Oct 2021 09:15:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwE41ue3cWZomm74osuZd1jptLf77Expd0gppG7mZlqK7dcmMgXq3wak4uaqrhU3Ub45Dj+9Q==
X-Received: by 2002:a05:6402:40cd:: with SMTP id z13mr36070836edb.220.1635264910857;
        Tue, 26 Oct 2021 09:15:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ho17sm6910381ejc.101.2021.10.26.09.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 09:15:10 -0700 (PDT)
Message-ID: <35e414f8-c9b4-826c-e679-6b2ac3584536@redhat.com>
Date:   Tue, 26 Oct 2021 18:15:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 2/5] KVM: x86: WARN if APIC HW/SW disable
 static keys are non-zero on unload
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20211025203828.1404503-1-sashal@kernel.org>
 <20211025203828.1404503-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211025203828.1404503-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/10/21 22:38, Sasha Levin wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> [ Upstream commit 9139a7a64581c80d157027ae20e86f2f24d4292c ]
> 
> WARN if the static keys used to track if any vCPU has disabled its APIC
> are left elevated at module exit.  Unlike the underflow case, nothing in
> the static key infrastructure will complain if a key is left elevated,
> and because an elevated key only affects performance, nothing in KVM will
> fail if either key is improperly incremented.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20211013003554.47705-3-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/lapic.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index ba5a27879f1d..18cb699b0a14 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2942,5 +2942,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>   void kvm_lapic_exit(void)
>   {
>   	static_key_deferred_flush(&apic_hw_disabled);
> +	WARN_ON(static_branch_unlikely(&apic_hw_disabled.key));
>   	static_key_deferred_flush(&apic_sw_disabled);
> +	WARN_ON(static_branch_unlikely(&apic_sw_disabled.key));
>   }
> 

NACK

Paolo

