Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39ABF423C8B
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhJFLYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:24:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231710AbhJFLYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 07:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v/JfOMi35WLM2+MZzOUHUTk7On4MySnDCb/mEC3ZCeE=;
        b=CFtC+3Uv3G/BmiCFIJ6DvBDtwYOXmMHwCI2Rj2GwmUe62qp0GyKIJdHWIC0XiCiNEi0H9o
        yrqViganksXsvjy5PmbLYu2yyuS+Zw+o5Au2CbJt5+tvbUHqI/PmmYqYCH1OWbJumlwONf
        0uH1We5wip3zCZkuIP7qHKWEPydr1eM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-n3SYzJtjMJKV4ou-BpjZlQ-1; Wed, 06 Oct 2021 07:22:14 -0400
X-MC-Unique: n3SYzJtjMJKV4ou-BpjZlQ-1
Received: by mail-ed1-f70.google.com with SMTP id p20-20020a50cd94000000b003db23619472so2295008edi.19
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 04:22:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v/JfOMi35WLM2+MZzOUHUTk7On4MySnDCb/mEC3ZCeE=;
        b=btL7s7/WMv1QjKjU3hlnrljVzFYU/q4iiCzrROPVMk54t8lAoUnuFW0Z56J3jDbSXF
         VEov49kiHZAFek8M4LeoYEeWoxQghi6n/K3/mqLwr38a/CraJ2lEMQYzJFNxzAfMG//l
         lTL+yytlSw9eT3sAwwMg28rxERp8X0RQcRY2rU2I+qjEKhjileJ8BeI1f+UytsfPjknv
         q9rFG2SmgOghSgWLsmeo6scvDpwvZmk7Vw+BQjqJsRiB6VGks7qFhbJn6EKoxwVhXXji
         wqbGeQudwNVIq58N68vvEbjp3wzM/guO81sQtNqjBoLPhK83DZaa2q1BWySA4NZclrl0
         DmbQ==
X-Gm-Message-State: AOAM533L5uHNyCNmZCNsUpBwRDKB7yMLTmnTg/nBQCPA8eAm2jmNaq1U
        UK93Xeut/tRV2jzJ+RdF1BPS7J6aOhxqi3vXDSNx31W5/B1TOJARcJk51t87eO4G28nYu22eUYy
        NBsap5BGFRMha50pi
X-Received: by 2002:a17:906:254b:: with SMTP id j11mr21131207ejb.513.1633519333535;
        Wed, 06 Oct 2021 04:22:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylcfz1yIK5h80nly+MZgOukICPmd/XRFVIy5VZ7eKeiW48E0oVYz9JloSTXJaFKV1/u78H3g==
X-Received: by 2002:a17:906:254b:: with SMTP id j11mr21131186ejb.513.1633519333342;
        Wed, 06 Oct 2021 04:22:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b17sm2149920edd.77.2021.10.06.04.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:22:12 -0700 (PDT)
Message-ID: <689f5883-54aa-51f8-a06b-69d18d6a3c82@redhat.com>
Date:   Wed, 6 Oct 2021 13:22:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.10 4/7] KVM: x86: VMX: synthesize invalid VM
 exit when emulating invalid guest state
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006111234.264020-1-sashal@kernel.org>
 <20211006111234.264020-4-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006111234.264020-4-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/21 13:12, Sasha Levin wrote:
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
> index fcd8bcb7e0ea..e3af56f05a37 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6670,10 +6670,21 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
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
>   	if (vmx->ple_window_dirty) {
>   		vmx->ple_window_dirty = false;
> 

NACK for this one.

The others are good, I'll ack them individually though.  Thanks for 
setting this up!

Paolo

