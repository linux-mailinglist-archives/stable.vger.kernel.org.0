Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F3B423F7F
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbhJFNix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:38:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239026AbhJFNil (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 09:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633527408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H1r1X4bOpqP9McySpdOj88aq9sWNjOIuSeMOSdgf+nE=;
        b=fLoCIZ3yndHO0ITaWsU/4mKaXDmePSR7zL9cj9Tyuhil6XGYNdZ54GP+AMDLq8jzx125VR
        IPSso7s0HiVzzXvummGT3siMu9oYiMZcBpgICQrT6CBl/51eVVxXEg0cWqf9z0/XF5Tz3C
        66JzvqTLWsq61eWoIrbcl//zsefHzNw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-UligXgRjNtaAfC_sMnTwPw-1; Wed, 06 Oct 2021 09:36:48 -0400
X-MC-Unique: UligXgRjNtaAfC_sMnTwPw-1
Received: by mail-ed1-f71.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso2703028edi.1
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 06:36:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H1r1X4bOpqP9McySpdOj88aq9sWNjOIuSeMOSdgf+nE=;
        b=s8gjETT5hntL2/pOuoJWABR0GFlTVP2O/f+ppWxyXK9g3oic64x8eM8KTBfCXCgT0D
         bEJ1Q9YZPHKe2T8Dhmc/o0xU+VdyBu2EZ9TsiuKZSwqM9JMhE3JxcGIjDDwCNM7S15o8
         zCBTI3xhmsr2bGKyPZJNvu4C/s6yVs2zp0HYiFOwSn2jPiMhKEx6PLCEz1epmqEYBeOO
         r/jGKVlcGTEZYMJrbiQ+KmAyx9LMJqlawmPej9Iw+GTO8YPAywzce+JV+NTQwn/UeT1c
         hZwbkP7RhZE/Hne9GC2/YjR9ZyL/yDBPHzRqFLoQ//kv9/ZqT2UgdrdN1OpudT+IT1tK
         10BQ==
X-Gm-Message-State: AOAM531FHyVy6+sBp1fL1oy163F1e7d7l7bIx7180EAHgOg9T+KM2Rjw
        Y/OLkORqg5ukmNYhCUAzFqCgnBZDL4g7kKX9u/b8tmwSdNRcP2W53Lw+Qy05LZO2MvPBExy9Maw
        c2FZmn5K8+LHSl2+V
X-Received: by 2002:a17:906:6558:: with SMTP id u24mr32986825ejn.361.1633527406636;
        Wed, 06 Oct 2021 06:36:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwg8tE1Dxc+9NT6zB2CZ4aGAo7WvRYAbiq4+FBTXyUz2IJSCg4m7bJF/FBN5UEGX6pdSOIcoA==
X-Received: by 2002:a17:906:6558:: with SMTP id u24mr32986801ejn.361.1633527406407;
        Wed, 06 Oct 2021 06:36:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id g10sm8874810ejj.44.2021.10.06.06.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 06:36:45 -0700 (PDT)
Message-ID: <36ee367e-3575-a237-991e-4cab07ce7041@redhat.com>
Date:   Wed, 6 Oct 2021 15:36:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 8/9] KVM: x86: nSVM: restore int_vector in
 svm_clear_vintr
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006133021.271905-1-sashal@kernel.org>
 <20211006133021.271905-8-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006133021.271905-8-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/21 15:30, Sasha Levin wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ Upstream commit aee77e1169c1900fe4248dc186962e745b479d9e ]
> 
> In svm_clear_vintr we try to restore the virtual interrupt
> injection that might be pending, but we fail to restore
> the interrupt vector.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20210914154825.104886-2-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/svm.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 69639f9624f5..19d6ffdd3f73 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1601,6 +1601,8 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
>   
>   		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
>   			V_IRQ_INJECTION_BITS_MASK;
> +
> +		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
>   	}
>   
>   	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

