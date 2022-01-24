Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2279A49886A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbiAXSeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:34:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48625 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235396AbiAXSeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:34:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643049258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ziCbcCwfUYjtsYcltI2SlvRg00Xk4c7ek7nsSQb5keo=;
        b=GYiXFwoV1hMyKJkr6b4tRNej1HuQChG47wU9cP7Ev56if2zxuM1pUMC88I0H/WLP9X+kfQ
        qOlQiLN4jxWiueFVdTLoTrC9qWAHt6haFDfGxcQmuf95GXkMCJKy8ChC8bOt6S9wYVUhXF
        m/ydkGmbFhW92j+BC4/VPTJPm3GotvI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-i5hwPceDM82wONNW8BWYdg-1; Mon, 24 Jan 2022 13:34:16 -0500
X-MC-Unique: i5hwPceDM82wONNW8BWYdg-1
Received: by mail-ej1-f71.google.com with SMTP id l18-20020a1709063d3200b006a93f7d4941so2463383ejf.1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 10:34:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ziCbcCwfUYjtsYcltI2SlvRg00Xk4c7ek7nsSQb5keo=;
        b=hk9VCc58CFSF5mbZ6zfmDXBwW9PdtPl0O4B3HdCfqOEAhtx4nf/3J0y5GRc5YWTKpN
         epFCjF/0gQlwgqEIosfKvjoi5Au6uSZIloCK7xe90jK51c5uEayLTZWBdc33SjwsfZ6L
         /YCB3PxzguhKCLwbIapXXk8IjdRN0nCGNmWLu4Xb9R2925qfnA4CsaRxp8KULnwmW7jf
         fWYfLKHlINe21zMvhdM4ZjZz/fxKZTmxXuctzUtr7W8qxwxSG6myNZC+IPZcdFAYoi6L
         1AmsXDuJfUCM93xGSmyYAXJ8qENRvmvovLb000AcwZ+DaIr4uoNFdIBJsjA7FAtWfMGg
         rj+g==
X-Gm-Message-State: AOAM530rVo6U7nh0GfFVbbAMPdFiHP/Q67KV3T+usF4AsG/4hpo/RcXI
        bWxm7i/SBV0es3rMkGRd4DPyRjCYnwKVIig8jRibbeEmGvlT6DxvWe2JRO1olhOVaJnbAYkCFMT
        OUuAVAZX5N0XZILNx
X-Received: by 2002:aa7:c7d1:: with SMTP id o17mr16781840eds.412.1643049254968;
        Mon, 24 Jan 2022 10:34:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzU8vKdhnUeojXtJ3Njeeu7pUMZeLl9ZzuhAd8ehBnZLNe4VcXJAYuHxJ18x8YY4za9AM/Hlw==
X-Received: by 2002:aa7:c7d1:: with SMTP id o17mr16781814eds.412.1643049254712;
        Mon, 24 Jan 2022 10:34:14 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id f19sm2318237edu.22.2022.01.24.10.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 10:34:14 -0800 (PST)
Message-ID: <51961d32-f45f-15d4-b21f-3ed75465c5da@redhat.com>
Date:   Mon, 24 Jan 2022 19:34:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 5.10] KVM: x86/mmu: Fix write-protection of PTs mapped by
 the TDP MMU
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, seanjc@google.com
References: <20220124183302.263017-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220124183302.263017-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 19:33, David Matlack wrote:
> commit 7c8a4742c4abe205ec9daf416c9d42fd6b406e8e upstream.
> 
> When the TDP MMU is write-protection GFNs for page table protection (as
> opposed to for dirty logging, or due to the HVA not being writable), it
> checks if the SPTE is already write-protected and if so skips modifying
> the SPTE and the TLB flush.
> 
> This behavior is incorrect because it fails to check if the SPTE
> is write-protected for page table protection, i.e. fails to check
> that MMU-writable is '0'.  If the SPTE was write-protected for dirty
> logging but not page table protection, the SPTE could locklessly be made
> writable, and vCPUs could still be running with writable mappings cached
> in their TLB.
> 
> Fix this by only skipping setting the SPTE if the SPTE is already
> write-protected *and* MMU-writable is already clear.  Technically,
> checking only MMU-writable would suffice; a SPTE cannot be writable
> without MMU-writable being set.  But check both to be paranoid and
> because it arguably yields more readable code.
> 
> Fixes: 46044f72c382 ("kvm: x86/mmu: Support write protection for nesting in tdp MMU")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Matlack <dmatlack@google.com>
> Message-Id: <20220113233020.3986005-2-dmatlack@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f2ddf663e72e..7e08efb06839 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1130,12 +1130,12 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
>   	bool spte_set = false;
>   
>   	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
> -		if (!is_writable_pte(iter.old_spte))
> -			break;
> -
>   		new_spte = iter.old_spte &
>   			~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
>   
> +		if (new_spte == iter.old_spte)
> +			break;
> +
>   		tdp_mmu_set_spte(kvm, &iter, new_spte);
>   		spte_set = true;
>   	}
> 
> base-commit: fd187a4925578f8743d4f266c821c7544d3cddae

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

