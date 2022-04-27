Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29300511E14
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242679AbiD0QU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 12:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242592AbiD0QU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 12:20:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC40B31344
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RzItaAexJm8D+vfjQz5rKxOdybX8BYSOmObiCpIyc/0=;
        b=XSWnIAXMgm59LZWO7PrIMiCKu27lNOkazIWK0nu+1i93NpfEIV6jPuEegrDVAe0SvIrudc
        HHw87tSXgw1pzKVD6JhgiXr6T6OyhvaQ3l5fYKSuk28B1yEQP7EgsRsse6m/aU1spb1odf
        rW/pmpO6lECX31l3+TIxBx/t8fh8GXA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-fSgyFGknMyuOmfo575O68A-1; Wed, 27 Apr 2022 12:16:58 -0400
X-MC-Unique: fSgyFGknMyuOmfo575O68A-1
Received: by mail-ej1-f72.google.com with SMTP id sb36-20020a1709076da400b006f3d4b12d3aso325665ejc.5
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RzItaAexJm8D+vfjQz5rKxOdybX8BYSOmObiCpIyc/0=;
        b=V4IwyaUYvyaeWJJUrTkssgIwsZu/U15blTvvVdEQALT2j+F3W1BSONIH/EgQDUnKBr
         MQX0EdWkSctvQUs7C1108mf+OP9rYvbd/woi0ytE21v3RA3L3XvQ7diY5seDcg7FHWix
         ksXXySN+0PBSlbBFkxwRyj7aIsxE17AgMI+E2304nNBYeaiaiLgnE6xmKmyxmwSYK/2F
         fvT6r1mAz29peSk6Wcr+Fs0J4Kxw40HuLML7tIfXQvDjpW+VRQf3PXRY+uRnzOHxwvlW
         U/h/8//7KwI7TiM8ni0SLtGyOpWk6fFrIKeOGLjAJpaVy5DxNgbBiAYhgMourXT5PNJq
         M4sA==
X-Gm-Message-State: AOAM532lIvytZE8101Iy1sOFPIVo1t1Zaxi54CCtWvjZT56lnOktTVwN
        j8U+u8CiTBl+wAm1fVguCoTYWZxm6RBhrUULd3UmtrID9rfARVW6O7l3rHUv5wqEOLwhCi2WwnO
        Q8YSaQ1Ssdu9lN8DG
X-Received: by 2002:a05:6402:5207:b0:426:1f0:b22 with SMTP id s7-20020a056402520700b0042601f00b22mr6744652edd.186.1651076216840;
        Wed, 27 Apr 2022 09:16:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwb75nHu6t51f1NDMxfZSRIItEiFS+6dOplwZZEazQUSBmfChxMq0wTDyn1DlO9plv/BGY99w==
X-Received: by 2002:a05:6402:5207:b0:426:1f0:b22 with SMTP id s7-20020a056402520700b0042601f00b22mr6744632edd.186.1651076216627;
        Wed, 27 Apr 2022 09:16:56 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id z19-20020a1709067e5300b006f39880d8e5sm4297615ejr.78.2022.04.27.09.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:16:55 -0700 (PDT)
Message-ID: <76dfc0b8-f892-c445-084c-62672293ca92@redhat.com>
Date:   Wed, 27 Apr 2022 18:16:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.17 5/7] KVM: x86/mmu: avoid NULL-pointer
 dereference on page freeing bugs
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155408.19352-1-sashal@kernel.org>
 <20220427155408.19352-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155408.19352-5-sashal@kernel.org>
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
> index 7f009ebb319a..e7cd16e1e0a0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3239,6 +3239,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>   		return;
>   
>   	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> +	if (WARN_ON(!sp))
> +		return;
>   
>   	if (is_tdp_mmu_page(sp))
>   		kvm_tdp_mmu_put_root(kvm, sp, false);

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

