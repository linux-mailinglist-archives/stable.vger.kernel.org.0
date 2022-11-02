Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB78616B6B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 19:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiKBSDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 14:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiKBSCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 14:02:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2824629C92
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 11:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667412070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1RvRC0SBdFOJn30TlRHeijUE+uZFovyhqvtp0pHaQFo=;
        b=WDZBgqNHnDaNu7W0lQVTzcWTUycuVXzXctTP/eCG1OHOr5CH1oGdUqNHFLj3RjQo2DKEvg
        skiyC8z9HUcbApGkuI/aa2cL7IwqlAjLVdsdWtRkxZElnp9JdjIZkYdX3UH+AuBvVphT2c
        Hfy+sMnp1KtECb1MnNupuht+FKWewVs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-86-UklDo1FcOLqEnZC-pAMqRA-1; Wed, 02 Nov 2022 14:01:08 -0400
X-MC-Unique: UklDo1FcOLqEnZC-pAMqRA-1
Received: by mail-ed1-f71.google.com with SMTP id i17-20020a05640242d100b0044f18a5379aso12846628edc.21
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 11:01:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1RvRC0SBdFOJn30TlRHeijUE+uZFovyhqvtp0pHaQFo=;
        b=atcuaT9h15n7tkpbdPurShgV0xU7gEqTgz3TPDkITo3HNF2910fJOCYxVROnkUjrJ3
         s7wdPU9BuXF7U4jmR+2ocFiu4yuL66MpcIO+b2O3tSAVejRImPwQ/X+tM6Nr7RH2fFNR
         jB3rwYzd7j94tARkg2wgm0B7oW5G1Ya5BLgoEJzKC+F7CIfzmdBdwpklTPWanHEhrt5n
         ovgdFZdvkMzKrHgRlatsXTWZPcrp+NI32thH/S8rRpziBfxzYcXoFS80W7g91qwvkstS
         sZq3w+T0GwQkyRXeS8X72u31PnEI1koGZeVZ5wcO1BOMSqBFIiNs0m9RvWz8n/PByzdH
         xcow==
X-Gm-Message-State: ACrzQf35OLsa23RGjKZDTU11nycWqERhVqCfzu7qvC/EU5M8QkmDKJY+
        HH4RuETN0HtenXIi1/80k6ZzOExjrLtyBLAye+Gh/sUOYhNwsusV0VX+JPR+gQryG93xICzWtux
        lNKy6UemGwg+zU8i8
X-Received: by 2002:a05:6402:4441:b0:454:8a74:5459 with SMTP id o1-20020a056402444100b004548a745459mr25327364edb.155.1667412064844;
        Wed, 02 Nov 2022 11:01:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM57hTgvEfvojkgJ8KYcHKTN9VaUPnKu2iAGaKHsefUDp7ok0INXb6ztlZx81bz1ij1AbEgveA==
X-Received: by 2002:a05:6402:4441:b0:454:8a74:5459 with SMTP id o1-20020a056402444100b004548a745459mr25327335edb.155.1667412064616;
        Wed, 02 Nov 2022 11:01:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id be8-20020a0564021a2800b0045c3f6ad4c7sm5974668edb.62.2022.11.02.11.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 11:01:03 -0700 (PDT)
Message-ID: <a9f099ee-3608-b68c-b089-057bcd9bc4dc@redhat.com>
Date:   Wed, 2 Nov 2022 19:01:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH AUTOSEL 5.19 03/10] kvm: x86: Do proper cleanup if
 kvm_x86_ops->vm_init() fails
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20221014135222.2109334-1-sashal@kernel.org>
 <20221014135222.2109334-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221014135222.2109334-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/14/22 15:52, Sasha Levin wrote:
> From: Junaid Shahid <junaids@google.com>
> 
> [ Upstream commit b24ede22538b4d984cbe20532bbcb303692e7f52 ]
> 
> If vm_init() fails [which can happen, for instance, if a memory
> allocation fails during avic_vm_init()], we need to cleanup some
> state in order to avoid resource leaks.
> 
> Signed-off-by: Junaid Shahid <junaids@google.com>
> Link: https://lore.kernel.org/r/20220729224329.323378-1-junaids@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/x86.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8c2815151864..8d2211b22ff3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11842,6 +11842,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	if (ret)
>   		goto out_page_track;
>   
> +	ret = static_call(kvm_x86_vm_init)(kvm);
> +	if (ret)
> +		goto out_uninit_mmu;
> +
>   	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
>   	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
>   	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
> @@ -11877,8 +11881,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm_hv_init_vm(kvm);
>   	kvm_xen_init_vm(kvm);
>   
> -	return static_call(kvm_x86_vm_init)(kvm);
> +	return 0;
>   
> +out_uninit_mmu:
> +	kvm_mmu_uninit_vm(kvm);
>   out_page_track:
>   	kvm_page_track_cleanup(kvm);
>   out:

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

