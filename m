Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B98423CBA
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbhJFLZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:25:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238503AbhJFLZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 07:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lLbP7/+QMokaGn1NBXc1Z3AjxWOqwXbSjUbJPeJPaIY=;
        b=KtdXXi2XX9U2twvEMWcIFAx9JvXf8z4C5cNnS/COEb+ZwV6xDth8j4bqWsjzfeAvr3qm5C
        ZCZnfywWz+eauhn1PAB4e1vcF6rCkfUxYOcOtBYKJT59dc2f2OiwHbv817Lf6uKPP5lFLY
        7nLdH3Dv/3k+R5QPLcK+sR+IanBx4M4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-vC2qzzUSOVWika1708qy-A-1; Wed, 06 Oct 2021 07:23:45 -0400
X-MC-Unique: vC2qzzUSOVWika1708qy-A-1
Received: by mail-ed1-f69.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so2289195ede.16
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 04:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lLbP7/+QMokaGn1NBXc1Z3AjxWOqwXbSjUbJPeJPaIY=;
        b=SwWRKbqCkQ6/aFC061Ihwnrh3w1W5ntGp9F8qCrZUAUVTpIvvSWSP3oXvNJHg4Fgq8
         q3uBd/Imq8Akv0uLCXkzO6DmYeWVrqUW5qvXsklGFeW9Su0P+xBC+uosRIvdK2gl+Lbx
         FrhXRF0tU6NchiwGVPnsZyTZaE+XOnLBBsakuXIvppzTj30A2fgHEGmoe+9AoJewCJAl
         xHPU1xqz2AvWzhgfj5KYTVBQYc7YPgTL0qVrbtE9prp8VVlEzsA1ncz389TCUyrCt3Up
         aYbrK7X7ifXBS7bVEuPSOSljPftNcxYaYrz5wX1eJUHhtXiEwTOCFj17faooNLraV1S8
         93dA==
X-Gm-Message-State: AOAM530IJuwAD4oRLcl7woXEWhA9hO1swULqQdBOUa9HLFo3Ea2sRq0/
        u8BY5TIUI0jnhHdK0jv5antMhVGwQRGERbVTOOhy+C01HI4/vpi9uejPDsByOoWGiLtp4KAdKNL
        QHtSiA2WP2bKlo4o6
X-Received: by 2002:a17:906:a14b:: with SMTP id bu11mr30189268ejb.260.1633519424564;
        Wed, 06 Oct 2021 04:23:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygDnu8ZXnnir5mEL8E0n9PDjKefaJYWYkB2IwPH5Yi8Hw5sZ7kvgpjhj4hinus0SnxtgaQYg==
X-Received: by 2002:a17:906:a14b:: with SMTP id bu11mr30189252ejb.260.1633519424385;
        Wed, 06 Oct 2021 04:23:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id q17sm10126364edd.57.2021.10.06.04.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:23:43 -0700 (PDT)
Message-ID: <da3899d8-7f9a-7425-e370-f8b00eb63123@redhat.com>
Date:   Wed, 6 Oct 2021 13:23:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.4 3/4] kvm: x86: Add AMD PMU MSRs to
 msrs_to_save_all[]
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Fares Mehanna <faresx@amazon.de>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006111250.264294-1-sashal@kernel.org>
 <20211006111250.264294-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006111250.264294-3-sashal@kernel.org>
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
> index 69e286edb2c9..4948bf36bd0a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1239,6 +1239,13 @@ static const u32 msrs_to_save_all[] = {
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

