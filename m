Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA635423F68
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhJFNhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:37:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231356AbhJFNhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 09:37:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633527342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BVoMCOfXvD5eRjXZ/1LeIj3VsaSsMKDZh/N8hEgH5y4=;
        b=VPTOw763QSzpQDnPAxnaMr9eqo6VSQxI2NXoibJoWUnCIPx9Z9qqqXFCL8+XxsiZwSXTlY
        NkaFlUPLtOw7Ja6UE2suIBGloCWobBq4UdT6e2PzfBIVdlmDhlk2qsSAN9i1Td/whUNLNL
        HLH9Qt3xKlr/6gTulG/7xNt2gRiZNnQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-OwFMUP-tPcaN97EmSLkJOA-1; Wed, 06 Oct 2021 09:35:41 -0400
X-MC-Unique: OwFMUP-tPcaN97EmSLkJOA-1
Received: by mail-ed1-f71.google.com with SMTP id t28-20020a508d5c000000b003dad7fc5caeso2652168edt.11
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 06:35:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BVoMCOfXvD5eRjXZ/1LeIj3VsaSsMKDZh/N8hEgH5y4=;
        b=cuzusyjr/4fOuC++zYNowhQv86HOQZVsWeRUt91idfZqNZHMU4lznI04lQELNy+Cze
         TbzVYlBf07DtmGMetJYxQabY71Rh6LWsrAOtf/gr6YB8BY4ySwJvBgJR3FErIKRIo4lG
         dazO7z/fDY0xSrhbMk9lySbODRL8TCPma8O7qZDtGxOa4eO76Aq+W/23hkRNf30YAsvK
         NFxVKrP0O9wM83lm2ibgqJ08qTAB+US5n6BEKyILYjHXQB+1/liY603ormtXwAtrxx8r
         FDVqjDy7ioNUNHCDdMKQH3e3cZOA/d3N+4h8DZWaEBUlXbyQMdyDAElNLpIJolN5KwIZ
         LJsQ==
X-Gm-Message-State: AOAM530sYgqLsurl5HwgdfDVSpDXGv7WK+fYRmzgT7VS9BcyAnHAPmOW
        i+UgFndwuVsGe5glD94t+PqafNPJl/wjc4qsgTI70KLYf3X3awVRvrXc3h9R62xLkmX6a2w3nlT
        ol0zvTl1ks/d28fH5
X-Received: by 2002:a17:906:2f15:: with SMTP id v21mr31920012eji.444.1633527339985;
        Wed, 06 Oct 2021 06:35:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmNcSddW1A8ihFQlZtG1ITjmrkzfacWGG8bGh1T6MT9Fk3SN+xUQ6ql9Ubosa1C0QR4sfaOg==
X-Received: by 2002:a17:906:2f15:: with SMTP id v21mr31919970eji.444.1633527339676;
        Wed, 06 Oct 2021 06:35:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id k22sm8833767eje.89.2021.10.06.06.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 06:35:39 -0700 (PDT)
Message-ID: <b718f654-f9e5-cd23-7e7f-eaf4d2cb0467@redhat.com>
Date:   Wed, 6 Oct 2021 15:35:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 5/9] KVM: x86: VMX: synthesize invalid VM
 exit when emulating invalid guest state
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006133021.271905-1-sashal@kernel.org>
 <20211006133021.271905-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006133021.271905-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/21 15:30, Sasha Levin wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ Upstream commit c42dec148b3e1a88835e275b675e5155f99abd43 ]
> 
> Since no actual VM entry happened, the VM exit information is stale.
> To avoid this, synthesize an invalid VM guest state VM exit.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20210913140954.165665-6-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/vmx.c | 17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 256f8cab4b8b..339116ff236f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6607,10 +6607,21 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   		     vmx->loaded_vmcs->soft_vnmi_blocked))
>   		vmx->loaded_vmcs->entry_time = ktime_get();
>   
> -	/* Don't enter VMX if guest state is invalid, let the exit handler
> -	   start emulation until we arrive back to a valid state */
> -	if (vmx->emulation_required)
> +	/*
> +	 * Don't enter VMX if guest state is invalid, let the exit handler
> +	 * start emulation until we arrive back to a valid state.  Synthesize a
> +	 * consistency check VM-Exit due to invalid guest state and bail.
> +	 */
> +	if (unlikely(vmx->emulation_required)) {
> +		vmx->fail = 0;
> +		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
> +		vmx->exit_reason.failed_vmentry = 1;
> +		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
> +		vmx->exit_qualification = ENTRY_FAIL_DEFAULT;
> +		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2);
> +		vmx->exit_intr_info = 0;
>   		return EXIT_FASTPATH_NONE;
> +	}
>   
>   	trace_kvm_entry(vcpu);
>   
> 

NACK

