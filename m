Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06ABD590CEF
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbiHLHyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbiHLHyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:54:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD692A721F
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ir0F7Es7ZuDaIDw62L7Egcu3/W0efmSmSnbNzL8xtaA=;
        b=PWMuRbRzWA6yAnwUPPKBoqcBYen2wQ3DGUTxN9tcnH+atUdnfZyg/eKZ9hBQUTK4LU2kP7
        2FZRafa9Nq/KgLSt7J2Qkb1iGCr2cVmTDy7K/Nwe0teFsDg+IaSfcl1+WW1Au94C1D9PD8
        SJj+QAiIjuYcNuJRZCoJmXdwPyTiZh8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-85-dGJWVLCRMtK27HdA0F7WJA-1; Fri, 12 Aug 2022 03:54:09 -0400
X-MC-Unique: dGJWVLCRMtK27HdA0F7WJA-1
Received: by mail-ed1-f69.google.com with SMTP id t13-20020a056402524d00b0043db1fbefdeso199286edd.2
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Ir0F7Es7ZuDaIDw62L7Egcu3/W0efmSmSnbNzL8xtaA=;
        b=d5kYS2lndPsowMXNbyrcCknFwEptNkBoe7gT1Urj/dWGjYG0mO7R6HVDmwvClx+gJZ
         AXtLnRZBvwGB/B0p4y0/B6YG4OmWkhpl9d5w83jgsuxC3AFI1YR99sm4gc8JNEMpmov1
         07iBxr1pWPMFUfLVcVNtRH5TehVDVSMoehpAJTLP3UDDNleRt5EqiGY6xe1nVZIkUtHE
         d9lOWQeRfmuzwqkBSfyqOjRnOm7G+xaW5lEs+OkgQdhp/VzonfTCX2b280mXlATrhBbz
         0cUr+8uqM4DyZDj05xhrSfWF8TZxvU2Id0HygVu/YxYPdPVW5RnqUjYqitdOEOF4i6wU
         LFKg==
X-Gm-Message-State: ACgBeo3qz1g1c7zIITVSmDmQhHel2rTcK1ASS2N19wYEySnR6+tW5ANG
        hDfkT5PuS693Fh9fAdPjFwmUks4nKwkdrldVz28UNAR1KeVSVGipB+JG79q0HicZrMPrWP4jnHF
        Go+RSrubEHznkYiUR
X-Received: by 2002:a17:906:cc5a:b0:730:8374:7ba5 with SMTP id mm26-20020a170906cc5a00b0073083747ba5mr1919482ejb.144.1660290848396;
        Fri, 12 Aug 2022 00:54:08 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4wiqAaFnDyyAR+Td3+IvIqa8c6abtjkeQh50o/V3ZtK22eBSG90m0oX2Ol40A83oD0ckifMg==
X-Received: by 2002:a17:906:cc5a:b0:730:8374:7ba5 with SMTP id mm26-20020a170906cc5a00b0073083747ba5mr1919473ejb.144.1660290848196;
        Fri, 12 Aug 2022 00:54:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id b10-20020a0564021f0a00b0043df40e4cfdsm933016edb.35.2022.08.12.00.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:54:07 -0700 (PDT)
Message-ID: <1f4e4c4b-a5af-a37e-b7f5-330694c963f7@redhat.com>
Date:   Fri, 12 Aug 2022 09:54:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.4 2/3] KVM: x86: Check lapic_in_kernel() before
 attempting to set a SynIC irq
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220810202552.32242-1-stefan.ghinea@windriver.com>
 <20220810202552.32242-2-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202552.32242-2-stefan.ghinea@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/22 22:25, Stefan Ghinea wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> commit 7ec37d1cbe17d8189d9562178d8b29167fe1c31a upstream
> 
> When KVM_CAP_HYPERV_SYNIC{,2} is activated, KVM already checks for
> irqchip_in_kernel() so normally SynIC irqs should never be set. It is,
> however,  possible for a misbehaving VMM to write to SYNIC/STIMER MSRs
> causing erroneous behavior.
> 
> The immediate issue being fixed is that kvm_irq_delivery_to_apic()
> (kvm_irq_delivery_to_apic_fast()) crashes when called with
> 'irq.shorthand = APIC_DEST_SELF' and 'src == NULL'.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220325132140.25650-2-vkuznets@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
> ---
>   arch/x86/kvm/hyperv.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index ca66459a2e89..f9603df799bf 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -309,6 +309,9 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
>   	struct kvm_lapic_irq irq;
>   	int ret, vector;
>   
> +	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
> +		return -EINVAL;
> +
>   	if (sint >= ARRAY_SIZE(synic->sint))
>   		return -EINVAL;
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

