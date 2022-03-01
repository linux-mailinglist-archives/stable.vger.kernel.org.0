Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3E14C9127
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiCARLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbiCARLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:11:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 172D449F8B
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 09:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646154619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hw768rDeNokjNS2ztSnOtNJE+1C5X3ieaCdhvugFp+Q=;
        b=JUdBqkTe8TgenjcfVc/ge76MpP/DY5LpmbYkJLhnIOQiqcHCI0JvMW0ifTYd/XJvBL/QCq
        IhJanko4nUqO07lrf/5PKD6A4P1fkgHGXWs3OwaDJJzOFhNynLfIGuaAT1Fb7wY2D2aVI1
        rkEZWyHITQ4+qhXSZcY032gxd3jh7pA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-B2-Wt681OgW3DwcJLxG-XQ-1; Tue, 01 Mar 2022 12:10:18 -0500
X-MC-Unique: B2-Wt681OgW3DwcJLxG-XQ-1
Received: by mail-wr1-f71.google.com with SMTP id f9-20020a5d58e9000000b001f0247e5e96so227300wrd.15
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 09:10:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hw768rDeNokjNS2ztSnOtNJE+1C5X3ieaCdhvugFp+Q=;
        b=S1QaS5li403R+xTxECf2OHjJ8tpQxGGVm8cEmeDanpOHAmTqDeBqkfGBKK2YPObvHF
         lOcY7fHusgwL4ASUyzpjF0alKMwQU6PG0dS6Jj7wEskLmDPLC7Kgc7a+mepk/kawngHL
         2tHgf9n0PFEF4XTJgBo/2IRI9kzjl0RZ+bCgjCjxRHK7sr6YPaWoy5JFQpJKsD61pHmc
         le2HX+o2mdCXqQo7HhGMpwM77RBrvHmaDc93t9BnRAs3aTgd+K8qXNRZozBihS9tuboI
         hpUufihBmWkYMv0unqO2FhBZDPWSTvleH33qcmr8QsO4rxjqWgmDpN3WsAz3ECz3s59a
         vORg==
X-Gm-Message-State: AOAM5318iG96+6+wudbf+OpepDnqMZ/zoCg3mkL+qzQ/bZymaa1fRH6E
        pl0gGXS/+6h2DPHW9VpCK3ukc/Vqsbi6R/As9zOl8YMcaNCv7FQZmO/hxpNhF1pHGBqymTJSMj/
        TGm69SJbPNDhnAX/I
X-Received: by 2002:adf:fbc4:0:b0:1e7:2060:d65 with SMTP id d4-20020adffbc4000000b001e720600d65mr19981557wrs.583.1646154617051;
        Tue, 01 Mar 2022 09:10:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxcW8kTPiZjyEQosAULzH9LNNi5qcAy9XoIyi/XnZf3u7/MFJ8aAGzGVLozZ3XC7489ddNLZw==
X-Received: by 2002:adf:fbc4:0:b0:1e7:2060:d65 with SMTP id d4-20020adffbc4000000b001e720600d65mr19981536wrs.583.1646154616784;
        Tue, 01 Mar 2022 09:10:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id o22-20020a05600c4fd600b0038133076dcesm3830827wmq.16.2022.03.01.09.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 09:10:16 -0800 (PST)
Message-ID: <4665e220-2efe-0040-8dda-cf17f0d8e342@redhat.com>
Date:   Tue, 1 Mar 2022 18:10:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.16 2/2] KVM: x86: nSVM: deal with L1
 hypervisor that intercepts interrupts but lets L2 control them
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220222140522.211548-1-sashal@kernel.org>
 <20220222140522.211548-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220222140522.211548-2-sashal@kernel.org>
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

On 2/22/22 15:05, Sasha Levin wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ Upstream commit 2b0ecccb55310a4b8ad5d59c703cf8c821be6260 ]
> 
> Fix a corner case in which the L1 hypervisor intercepts
> interrupts (INTERCEPT_INTR) and either doesn't set
> virtual interrupt masking (V_INTR_MASKING) or enters a
> nested guest with EFLAGS.IF disabled prior to the entry.
> 
> In this case, despite the fact that L1 intercepts the interrupts,
> KVM still needs to set up an interrupt window to wait before
> injecting the INTR vmexit.
> 
> Currently the KVM instead enters an endless loop of 'req_immediate_exit'.
> 
> Exactly the same issue also happens for SMIs and NMI.
> Fix this as well.
> 
> Note that on VMX, this case is impossible as there is only
> 'vmexit on external interrupts' execution control which either set,
> in which case both host and guest's EFLAGS.IF
> are ignored, or not set, in which case no VMexits are delivered.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20220207155447.840194-8-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/svm.c | 17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d6a4acaa65742..2503c99cfde3f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3548,11 +3548,13 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   	if (svm->nested.nested_run_pending)
>   		return -EBUSY;
>   
> +	if (svm_nmi_blocked(vcpu))
> +		return 0;
> +
>   	/* An NMI must not be injected into L2 if it's supposed to VM-Exit.  */
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
>   		return -EBUSY;
> -
> -	return !svm_nmi_blocked(vcpu);
> +	return 1;
>   }
>   
>   static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> @@ -3604,9 +3606,13 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>   static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> +
>   	if (svm->nested.nested_run_pending)
>   		return -EBUSY;
>   
> +	if (svm_interrupt_blocked(vcpu))
> +		return 0;
> +
>   	/*
>   	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
>   	 * e.g. if the IRQ arrived asynchronously after checking nested events.
> @@ -3614,7 +3620,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
>   		return -EBUSY;
>   
> -	return !svm_interrupt_blocked(vcpu);
> +	return 1;
>   }
>   
>   static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
> @@ -4343,11 +4349,14 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   	if (svm->nested.nested_run_pending)
>   		return -EBUSY;
>   
> +	if (svm_smi_blocked(vcpu))
> +		return 0;
> +
>   	/* An SMI must not be injected into L2 if it's supposed to VM-Exit.  */
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_smi(svm))
>   		return -EBUSY;
>   
> -	return !svm_smi_blocked(vcpu);
> +	return 1;
>   }
>   
>   static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)


Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

