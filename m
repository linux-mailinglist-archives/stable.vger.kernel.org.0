Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DC75120BD
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242296AbiD0Q1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 12:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243307AbiD0Q0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 12:26:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D6FB56238
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsca3nN9F0L3L7CF4f4/JIiLe+nDncGsHBTvE+SQpns=;
        b=Nh6Dhltmu0r/XkRi+yKiSHncdF3ktBBthQizASkd9Leo34UPb+lkTiZVFQIgsM/71UjB2m
        qbI+q+nV8gGG3MiJXsXI3gP6Qrl1M2rjtcTGnb3RILKzLPtYG2F7rClpdJZcdu00rVltoH
        aRZ3VYMziPowuxVW50v/ujUr+L5npMQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-hGyweWS7NuSPnQPt04JY_w-1; Wed, 27 Apr 2022 12:20:43 -0400
X-MC-Unique: hGyweWS7NuSPnQPt04JY_w-1
Received: by mail-ej1-f70.google.com with SMTP id jg25-20020a170907971900b006f010192c19so1426991ejc.21
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:20:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rsca3nN9F0L3L7CF4f4/JIiLe+nDncGsHBTvE+SQpns=;
        b=HOcaOKFZ8uDjx6q6lJGIMPUznV8VJmVu3mjaLDOZisXkov2UvUAxwr5BAbhDC1iv7p
         x8z84CMLUIFAnnnO4TTVCzksgM5jvZ778De3nxbs5CBEtAdS878XqcwYUVQqF8mcJ/j7
         zGsDBOp79hQiU1v6J3pKvtHPGVnA0ggV+qyGYsVW3YcG0sM7wvtr4OO5pqzNqfytN6Jq
         OOzKBcp5oY3OpdmqkftVVg8tlTn6uaIrziTphSNIzoHthLbZ1VFfAEHhA1GRqU6dPbaT
         2YyTG4zXYnYRpUCpjbF2KUkQMuicGPZrxJ1jwcXJLqthEp+6K7nCBy6QmrM5canp5IqV
         kWZA==
X-Gm-Message-State: AOAM532bAFPv1qLJSH77vRKH539YAEp1/Y8gISTlB3xuVv0bntU/QkUP
        Fwaa/Egd/KP4Adfbl1y3gtgpzqBmt9istNQ2arGgwNZLPZNTIo7I7a+FgrWdIYvLwB3gYPthTbM
        0J6eMWePRLCEBudVr
X-Received: by 2002:a05:6402:1a42:b0:424:20bb:3e37 with SMTP id bf2-20020a0564021a4200b0042420bb3e37mr31381784edb.29.1651076441831;
        Wed, 27 Apr 2022 09:20:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzy79Ti+40bhX02i6AE/YohVsvCl0+6reMKemh3Hg1j7DTh1D/TMmfHWFR50FWzqoAwUbxSgA==
X-Received: by 2002:a05:6402:1a42:b0:424:20bb:3e37 with SMTP id bf2-20020a0564021a4200b0042420bb3e37mr31381758edb.29.1651076441571;
        Wed, 27 Apr 2022 09:20:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id s12-20020a1709062ecc00b006e8558c9a5csm7003572eji.94.2022.04.27.09.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:20:40 -0700 (PDT)
Message-ID: <143ede94-5231-de84-9e8a-97a5f9ca8563@redhat.com>
Date:   Wed, 27 Apr 2022 18:20:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.15 6/7] KVM: x86/mmu: avoid NULL-pointer
 dereference on page freeing bugs
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155431.19458-1-sashal@kernel.org>
 <20220427155431.19458-6-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155431.19458-6-sashal@kernel.org>
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
> index 34e828badc51..806f9d42bcce 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3314,6 +3314,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>   		return;
>   
>   	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> +	if (WARN_ON(!sp))
> +		return;
>   
>   	if (is_tdp_mmu_page(sp))
>   		kvm_tdp_mmu_put_root(kvm, sp, false);

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

