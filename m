Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD8C511DB7
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243284AbiD0Q2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 12:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242605AbiD0Q1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 12:27:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5E1459302
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++UuqgJt9YgxlZT4xRTgU+kEGmMRwOlAsDaCv/rlgcE=;
        b=TfcYhXJengcjLyhsyC3DqCmlA93woNuWH84qEra75jDwfYjwV9GZKpk4U4fWEyL6QyKpUV
        r2S1dEEKEtEDheMu5oqApyEo+7SHxsUHaqSGRC7HSbOoa6QSWeMDEGRlEoWNsgMfCaVUhT
        rpKpBlpyeigJsEsMErzHjjblcvUUeZ8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-8ZsvVsyvPiSbX_Ng6tRaeg-1; Wed, 27 Apr 2022 12:19:13 -0400
X-MC-Unique: 8ZsvVsyvPiSbX_Ng6tRaeg-1
Received: by mail-ed1-f70.google.com with SMTP id r26-20020a50aada000000b00425afa72622so1238644edc.19
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:19:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=++UuqgJt9YgxlZT4xRTgU+kEGmMRwOlAsDaCv/rlgcE=;
        b=3pmOzp24RrHPkJRp2+X2l34L65n69wYeW3gjL6xu63PnJt5l9UQ0fOSo4sv7UzF5tF
         Tb8X3UyJyoIMAFKdFhHPv9uWgVccReR8vmh9lATWvop1dfmW5gpvhB58jmJDXJWsrHBj
         kBTL0xC+ydqJWFDQikBHDDYN1p99g2h2VI+xEjQe1HAjaQc17wk7XUnGBeil7oaOdTgq
         voNSSK0IaajyFhDU+Q2137/18kgVurhQX0oe6Qc6jYxCUSJui1SUYlofV8d/v/fYIOV9
         YjgQmDxXh3F7dMBYv8Y6pC+vVEEVIBFA2c8QeuHeSch4+JUwUid+cdVEdhB541i7gCGN
         x7yg==
X-Gm-Message-State: AOAM5339sbPfti5CT/1ezSP3TiNQTEehp5y7Jtg+KI5GW9vZmy0CcOeF
        9lgHC1IxjNhKC+Jg/tx3xtBdxhJ1ery2HKfALmsBP01Sbrf8BAOKjc0i8LWfJdXzhjfh95Y9zAh
        yJ4Xcy5SVWzqAMHPF
X-Received: by 2002:a05:6402:400b:b0:425:f59a:c221 with SMTP id d11-20020a056402400b00b00425f59ac221mr13331403eda.307.1651076352252;
        Wed, 27 Apr 2022 09:19:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPfGEmBUJ67ZizyPHjPOEfag4PaOgCK7brbyiJjf81tHh9zOvEYRKi3rSxDx1hdZ20vjrEHg==
X-Received: by 2002:a05:6402:400b:b0:425:f59a:c221 with SMTP id d11-20020a056402400b00b00425f59ac221mr13331379eda.307.1651076352033;
        Wed, 27 Apr 2022 09:19:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id cn27-20020a0564020cbb00b00418b0c7fbbfsm8594619edb.32.2022.04.27.09.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:19:11 -0700 (PDT)
Message-ID: <5d9b9296-f116-0661-d1c2-6eb7d132e4f0@redhat.com>
Date:   Wed, 27 Apr 2022 18:19:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.10 3/4] KVM: x86/mmu: avoid NULL-pointer
 dereference on page freeing bugs
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155435.19554-1-sashal@kernel.org>
 <20220427155435.19554-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155435.19554-3-sashal@kernel.org>
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
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit 9191b8f0745e63edf519e4a54a4aaae1d3d46fbd ]
> 
> WARN and bail if KVM attempts to free a root that isn't backed by a shadow
> page.  KVM allocates a bare page for "special" roots, e.g. when using PAE
> paging or shadowing 2/3/4-level page tables with 4/5-level, and so root_hpa
> will be valid but won't be backed by a shadow page.  It's all too easy to
> blindly call mmu_free_root_page() on root_hpa, be nice and WARN instead of
> crashing KVM and possibly the kernel.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 99ea1ec12ffe..70ef5b542681 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3140,6 +3140,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>   		return;
>   
>   	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> +	if (WARN_ON(!sp))
> +		return;
>   
>   	if (kvm_mmu_put_root(kvm, sp)) {
>   		if (sp->tdp_mmu_page)

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

