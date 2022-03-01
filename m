Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA0B4C95F7
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237886AbiCAUSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238300AbiCAUSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:18:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31B0E2DA9B
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 12:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646165861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9aSLGBmnPIAJJgrzBhmaCFv1mrgnWp3DUsr0iZuWKl4=;
        b=gXDO4cozJeLOCdHE6S41YdFYGpjjlLHvjIMJ/LsbykHlSYJHN/C+BXQezeGJOwHDIK9/vg
        0L5tcyJbbgRjAG4GDPRoFYTDf87F5I5byS6/0LyzvT2papgeZwkVK5O+L8tQitC7hc6f9h
        jCrf042YZ2iY6gZoNp6m/mw83TngC7o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-PKHUEw6ENkW-VWasAvvu8A-1; Tue, 01 Mar 2022 15:17:40 -0500
X-MC-Unique: PKHUEw6ENkW-VWasAvvu8A-1
Received: by mail-wm1-f70.google.com with SMTP id h19-20020a05600c351300b0038141cf26deso1721089wmq.8
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 12:17:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9aSLGBmnPIAJJgrzBhmaCFv1mrgnWp3DUsr0iZuWKl4=;
        b=VEpmpLYselY0ZPEFf5qDO2xXy4pEniOEhBBmwzJ5xzh2wU23Reggs72Db9WtoAU8BJ
         SmBXGGuggX3MjxpbMBp7R+DvpEg5up4pcC6CoFtKKwW4jx8Lt8UkQP7StMAvmT20TT4S
         e7k14txa+Ttag9elBMHbX9j/dtJp5elR9g9FBqKZYXZqwRDHjxyKo2/oqIx5jdv5WaOE
         z/2Z+t+s/wS3g1mCLHAFC/566y+JcP52TKIeAnUfoXm0xjPdfud7uRgJgy4Exu0Ab4Fo
         AAcv+IQMq3wyeOF6YKghfxzkkzpmB6EZIsQ0KZqacy98dPJ5/UuOff5Q2/SJI5bc3rgU
         ZI5g==
X-Gm-Message-State: AOAM533zX11HV0sslFgv0YjpZNYCHvTOAVy8FXWVg3+ecrd4lTapcxZ6
        YCt+KUfW/NiWwvVHuFxbazQ6QgW8BCufE2T+YMhQUyjBerhhZB0JWzQWpnLR+iPzacxllbGEr7p
        wDzcgRW3bzEYotviU
X-Received: by 2002:a05:600c:3ba9:b0:381:1044:6fd3 with SMTP id n41-20020a05600c3ba900b0038110446fd3mr17960228wms.77.1646165859144;
        Tue, 01 Mar 2022 12:17:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykw7EAKZADuVfNKFsUk1bMuZG85x9BmwnFWCP10oKa09IqiJQdQ6r86+8jOank6umrt77LJA==
X-Received: by 2002:a05:600c:3ba9:b0:381:1044:6fd3 with SMTP id n41-20020a05600c3ba900b0038110446fd3mr17960217wms.77.1646165858931;
        Tue, 01 Mar 2022 12:17:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id b13-20020a05600c4e0d00b003816cb4892csm6799037wmq.0.2022.03.01.12.17.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:17:38 -0800 (PST)
Message-ID: <4665d674-db6d-13b0-a35e-d33f2f152668@redhat.com>
Date:   Tue, 1 Mar 2022 21:17:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.16 12/28] x86/kvm: Don't use pv
 tlb/ipi/sched_yield if on 1 vCPU
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-12-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301201344.18191-12-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/22 21:13, Sasha Levin wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> [ Upstream commit ec756e40e271866f951d77c5e923d8deb6002b15 ]
> 
> Inspired by commit 3553ae5690a (x86/kvm: Don't use pvqspinlock code if
> only 1 vCPU), on a VM with only 1 vCPU, there is no need to enable
> pv tlb/ipi/sched_yield and we can save the memory for __pv_cpu_mask.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1645171838-2855-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kernel/kvm.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 59abbdad7729c..ff3db164e52cb 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -462,19 +462,22 @@ static bool pv_tlb_flush_supported(void)
>   {
>   	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
>   		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> -		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
> +		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
> +		(num_possible_cpus() != 1));
>   }
>   
>   static bool pv_ipi_supported(void)
>   {
> -	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
> +	return (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI) &&
> +	       (num_possible_cpus() != 1));
>   }
>   
>   static bool pv_sched_yield_supported(void)
>   {
>   	return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
>   		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> -	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
> +	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
> +	    (num_possible_cpus() != 1));
>   }
>   
>   #define KVM_IPI_CLUSTER_SIZE	(2 * BITS_PER_LONG)

NACK

Not really necessary.

Paolo

