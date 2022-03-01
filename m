Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE2A4C96B5
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238124AbiCAUZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbiCAUYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:24:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4318392D25
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 12:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646166137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UnhjscoVXwV58qxo7/KqdtLFU4F0yTvnAGVTxy5/ZzA=;
        b=XFSPj90LsCqMl1F+OjWK36l9np/y8CsP2sPJulr9b5iQWRvSSUqQneG8a49p1TyLorYs0j
        t8zz+YXD7d6TgcGeVP3AXoazS2QCI9FdrF0IW5AUsdsthd0wOtuerKe2KeD/sqxYALEAt7
        DvEsPGk0WA/QGrxFDke8buPSZ6WXlAA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-tc2PoX9COtqDJG0ibcYSlQ-1; Tue, 01 Mar 2022 15:22:16 -0500
X-MC-Unique: tc2PoX9COtqDJG0ibcYSlQ-1
Received: by mail-wm1-f72.google.com with SMTP id h206-20020a1c21d7000000b003552c13626cso1179978wmh.3
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 12:22:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UnhjscoVXwV58qxo7/KqdtLFU4F0yTvnAGVTxy5/ZzA=;
        b=7JlSAJznG251BKsTkjDdNcwmv1BBt9J7Z/5o9ukLA2pB1GBZvaIZv/3xhhKoPwTFdV
         lOS8VrY2uiWXBx3yWqdLxYwN3HAoFuaAKsFO/90UMjRNLWNfnKu+uURX930LU+6qEaQm
         9p63oFlZD+mpTAf6HrOpLI+uLzFRoM7pS4IdPwhFhTsSEcMtjZpZdzGoSmAXdZjv2pZr
         04C+ZhE8xAYvPXD7HuCdPrpIsyN8eXbSCRqnZDbizIzg0N/di6tLeueRWdWakZQcVJgW
         FkpfiYCvDvZbj8ZRLvkp7Is8znILATYcmXWa9zL0QjVF/aipks6Mj3SsrK7z2cgAFT1M
         FbQA==
X-Gm-Message-State: AOAM532Gui9cZMplX+QJfN0gl3VG2qln/H5xaWdm+AUnxCpnYeLkkim3
        pOoLJcSQXYdFbXK0ZzH2XLy3X8Q7YUU14vIg6PhFCDjIZ9nYdudlsMA+v6Wuo9jCPdJq4Px2G1t
        YqRkCWdvkhA/xWkMk
X-Received: by 2002:adf:a319:0:b0:1ef:7cc6:d03 with SMTP id c25-20020adfa319000000b001ef7cc60d03mr14982534wrb.411.1646166135156;
        Tue, 01 Mar 2022 12:22:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbaYo2qIYbuusP+S+lSiz716HfdkjaywKNxchsiuC/GXAlgD5Aek/kWgwRhiNQmTC7xvzYSw==
X-Received: by 2002:adf:a319:0:b0:1ef:7cc6:d03 with SMTP id c25-20020adfa319000000b001ef7cc60d03mr14982524wrb.411.1646166134945;
        Tue, 01 Mar 2022 12:22:14 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id u6-20020a05600c19c600b0034f5032b042sm3663786wmq.46.2022.03.01.12.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:22:14 -0800 (PST)
Message-ID: <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com>
Date:   Tue, 1 Mar 2022 21:22:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest
 user_xfeatures to supported bits of XCR0
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Leonardo Bras <leobras@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, chang.seok.bae@intel.com, luto@kernel.org,
        kvm@vger.kernel.org
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-7-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301201344.18191-7-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/22 21:13, Sasha Levin wrote:
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index d28829403ed08..6ac01f9828530 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1563,7 +1563,10 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
>   		fpregs_restore_userregs();
>   
>   	newfps->xfeatures = curfps->xfeatures | xfeatures;
> -	newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
> +
> +	if (!guest_fpu)
> +		newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
> +
>   	newfps->xfd = curfps->xfd & ~xfeatures;
>   
>   	curfps = fpu_install_fpstate(fpu, newfps);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index bf18679757c70..875dce4aa2d28 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -276,6 +276,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	vcpu->arch.guest_supported_xcr0 =
>   		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
>   
> +	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
> +
>   	kvm_update_pv_runtime(vcpu);
>   
>   	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);

Leonardo, was this also buggy in 5.16?  (I should have asked for a Fixes 
tag...).

Paolo

