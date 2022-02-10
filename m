Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300B64B1330
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244526AbiBJQkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:40:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244515AbiBJQkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:40:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7F3DD44
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gc6lDZSpHVIw8OQnB9eZkWezLNZIBK4RgA5Yuh75LNE=;
        b=KVpdPmPU+qfI1NZDZWPfrKaS0/yrTeg+LZl380V+PVNly+2JTuEuE7TWpqMhGSl8Bm6A0x
        NP1n9FT+KGvZ1Y3656Oe4y6DSOrczK3Xn2VEQDh6JvvRm2+hh40RjnYG227LW8EWIpAzOE
        MEiSqCFZ4j14S3mNfxTgLf2hj89/mHU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-cqMBhD98M6O4ZKBXYeXLSA-1; Thu, 10 Feb 2022 11:40:38 -0500
X-MC-Unique: cqMBhD98M6O4ZKBXYeXLSA-1
Received: by mail-ej1-f72.google.com with SMTP id o7-20020a170906860700b006cbe6deec1bso2967544ejx.22
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:40:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gc6lDZSpHVIw8OQnB9eZkWezLNZIBK4RgA5Yuh75LNE=;
        b=6eU5hVd7CeNTYn/vwfQyeBhhPS1mgnKD5n/nOkuVUkzWaPqb+7ADev5bciOxC7+Q0N
         mpXqm0RFoL0db/dmnfV5ezQ9J6Xrta2EnVboMrbRi7fKKnd3UIn5qaNFSwagE9XQ8eTl
         Em4LKGf+KdHB5gv8TjlosrGKurHXZeCps8klN+hgGv+MyOedC+Fc/tM5QpBNayi4rI0D
         8QhZNwfN60IcTuH3VAqD8qyMZ2tgUokMrIpHlXcAvWikhwtLKRojPVpBuQqmHcxKFTDy
         vdDvxXU1tXDOzHnnsyfCapO1EZlXkXiYQEUgb1LKv0oYRzzYkt2vK4dNG7nXj0gRd9vm
         jDqA==
X-Gm-Message-State: AOAM531HXzVqr2vpgbD57on3JUMqtpyDRrrGAW1BEEJslP1l1wwL6yj5
        rQ8nsiIpccUGbyBIPntGHn/lR1FImzVdA9nkmqBMJ1M0hASceQNl8D1qAlvC5NXkRRFAq/9W/ds
        3OPdNMlSfI+mzsjTp
X-Received: by 2002:a17:906:490:: with SMTP id f16mr7341991eja.438.1644511237368;
        Thu, 10 Feb 2022 08:40:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJCu0suja1TEmC8U2UFl9bLC7ANkyhhyfRNlUqIFPjixn9yffcCpPhtoPlNE1tZEAHYlhFJg==
X-Received: by 2002:a17:906:490:: with SMTP id f16mr7341966eja.438.1644511237111;
        Thu, 10 Feb 2022 08:40:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id ot38sm4718946ejb.131.2022.02.10.08.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:40:36 -0800 (PST)
Message-ID: <65f23531-4c39-2b1e-9e80-02dcef9c0645@redhat.com>
Date:   Thu, 10 Feb 2022 17:40:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.15 8/8] KVM: x86: Report deprecated x87
 features in supported CPUID
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185653.48833-1-sashal@kernel.org>
 <20220209185653.48833-8-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185653.48833-8-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/22 19:56, Sasha Levin wrote:
> From: Jim Mattson <jmattson@google.com>
> 
> [ Upstream commit e3bcfda012edd3564e12551b212afbd2521a1f68 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> CPUID.(EAX=7,ECX=0):EBX.FDP_EXCPTN_ONLY[bit 6] and
> CPUID.(EAX=7,ECX=0):EBX.ZERO_FCS_FDS[bit 13] are "defeature"
> bits. Unlike most of the other CPUID feature bits, these bits are
> clear if the features are present and set if the features are not
> present. These bits should be reported in KVM_GET_SUPPORTED_CPUID,
> because if these bits are set on hardware, they cannot be cleared in
> the guest CPUID. Doing so would claim guest support for a feature that
> the hardware doesn't support and that can't be efficiently emulated.
> 
> Of course, any software (e.g WIN87EM.DLL) expecting these features to
> be present likely predates these CPUID feature bits and therefore
> doesn't know to check for them anyway.
> 
> Aaron Lewis added the corresponding X86_FEATURE macros in
> commit cbb99c0f5887 ("x86/cpufeatures: Add FDP_EXCPTN_ONLY and
> ZERO_FCS_FDS"), with the intention of reporting these bits in
> KVM_GET_SUPPORTED_CPUID, but I was unable to find a proposed patch on
> the kvm list.
> 
> Opportunistically reordered the CPUID_7_0_EBX capability bits from
> least to most significant.
> 
> Cc: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Message-Id: <20220204001348.2844660-1-jmattson@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/cpuid.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f666fd79d8ad6..5f1d4a5aa8716 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -421,12 +421,13 @@ void kvm_set_cpu_caps(void)
>   	);
>   
>   	kvm_cpu_cap_mask(CPUID_7_0_EBX,
> -		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
> -		F(BMI2) | F(ERMS) | F(INVPCID) | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
> -		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
> -		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
> -		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | 0 /*INTEL_PT*/
> -	);
> +		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
> +		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
> +		F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ | F(AVX512F) |
> +		F(AVX512DQ) | F(RDSEED) | F(ADX) | F(SMAP) | F(AVX512IFMA) |
> +		F(CLFLUSHOPT) | F(CLWB) | 0 /*INTEL_PT*/ | F(AVX512PF) |
> +		F(AVX512ER) | F(AVX512CD) | F(SHA_NI) | F(AVX512BW) |
> +		F(AVX512VL));
>   
>   	kvm_cpu_cap_mask(CPUID_7_ECX,
>   		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |

