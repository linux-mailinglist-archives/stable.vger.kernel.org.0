Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BDF423CAE
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbhJFLZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:25:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51551 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238449AbhJFLZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 07:25:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cwJDi3dXbHoGWrH9UTdaW4pqTLM9RuzG7yK9uGbXyIc=;
        b=WsOq9i9zpTuPMzPIHjhpBywxnOBmEqBUFU4C7ULz34OR2yLKbrUJv543+57O97ozULD2rU
        0zw0Z6xMZN8S0QSw4BP5epli2fWfqtxnMOsv2V1Xr3g5OFx7eFJx86eoAPSlqef6oio/58
        vi5a5ES7VobY14pWfmJYsKzLd1grV3s=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-uvWWLmjsMheYfBJqs0lOaw-1; Wed, 06 Oct 2021 07:23:15 -0400
X-MC-Unique: uvWWLmjsMheYfBJqs0lOaw-1
Received: by mail-ed1-f71.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so2288092ede.16
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 04:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cwJDi3dXbHoGWrH9UTdaW4pqTLM9RuzG7yK9uGbXyIc=;
        b=ohWtix7oKRxxUb+We6oH5FU7V7apGABQeslTIFf52bh+kUGN8wvP6tRp9Hpbon2c3b
         sQbvGr+V8fqb3KFoesSL8/o4C5u0H0R+0p/GXVnJjTHY5tvNTNK3B4AhmTrGjbujCtR+
         svDR3EuMdJJ+pGxst53G3MtO8WJzu259iQJSVAn76h+/XExSxGEN7iY+gvTavW3GEfyM
         jgl60aETPp1AZP/I/7u7lq3272aCTulivQnCfBm/xjL+ER3ol910LYIs6EG848tDTA/v
         3/i/8oLYBvXYo6NRO89MclJbx/7+43j2ZnTx2h54/eo8xDbQ5whmI8+2Cct0R2//C4d4
         YHag==
X-Gm-Message-State: AOAM531QoiWLzb9hEbLwUTpAzrdJuKDV6ISfB+orCuD7LWT2iBxtBcPm
        OxBnjZd46WqqXV6FSOoRNPmF03onSgqhRIycWSGLY1JUh0E6gkrknHgdCHmI7OpTZGamv4XWRoA
        d7mmbwbJ2oJ85bn4M
X-Received: by 2002:a17:907:869e:: with SMTP id qa30mr32209596ejc.249.1633519394533;
        Wed, 06 Oct 2021 04:23:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE3suZXUr4cp0B3UpwBcE2Rj9bs3G/seiS/zIPgZInL2THx7fKpkf+oaSVxGKyv1s/LKAwpA==
X-Received: by 2002:a17:907:869e:: with SMTP id qa30mr32209572ejc.249.1633519394351;
        Wed, 06 Oct 2021 04:23:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id u16sm8749641ejy.14.2021.10.06.04.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:23:13 -0700 (PDT)
Message-ID: <90e9e5e8-0f9f-e31f-ba76-2d46b6a44736@redhat.com>
Date:   Wed, 6 Oct 2021 13:23:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.10 5/7] kvm: x86: Add AMD PMU MSRs to
 msrs_to_save_all[]
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Fares Mehanna <faresx@amazon.de>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006111234.264020-1-sashal@kernel.org>
 <20211006111234.264020-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006111234.264020-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/21 13:12, Sasha Levin wrote:
> From: Fares Mehanna <faresx@amazon.de>
> 
> [ Upstream commit e1fc1553cd78292ab3521c94c9dd6e3e70e606a1 ]
> 
> Intel PMU MSRs is in msrs_to_save_all[], so add AMD PMU MSRs to have a
> consistent behavior between Intel and AMD when using KVM_GET_MSRS,
> KVM_SET_MSRS or KVM_GET_MSR_INDEX_LIST.
> 
> We have to add legacy and new MSRs to handle guests running without
> X86_FEATURE_PERFCTR_CORE.
> 
> Signed-off-by: Fares Mehanna <faresx@amazon.de>
> Message-Id: <20210915133951.22389-1-faresx@amazon.de>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/x86.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d65da3b5837b..b885063dc393 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1250,6 +1250,13 @@ static const u32 msrs_to_save_all[] = {
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> +
> +	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
> +	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
> +	MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
> +	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
> +	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
> +	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
>   };
>   
>   static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

