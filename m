Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C1A616B5E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 19:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiKBSCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 14:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiKBSCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 14:02:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A8920BE3
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 11:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667412062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCufs503dpXhujdx2ITwJq82yoPCeWyuDZvhe6M3z5g=;
        b=VW5DeW+Y/8WH3cx4xXPr7hLEQBz+EoNffDI68pF354AxwL/S+Yd3u9i20Jpx6u9eUS+Ipc
        jAx2fUTmReW/bv6t8larlul/AaGVifTfKonrOEUHGI78t1AblvqXCQeJMmjId1hf+y82WM
        dNfiDCmJh81Hx/3v3AAeBuH0TIV7iqU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-50-6Mdtf2TZP3-yC7imo0kuTw-1; Wed, 02 Nov 2022 14:01:00 -0400
X-MC-Unique: 6Mdtf2TZP3-yC7imo0kuTw-1
Received: by mail-ed1-f71.google.com with SMTP id z11-20020a056402274b00b00461dba91468so12387638edd.6
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 11:01:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rCufs503dpXhujdx2ITwJq82yoPCeWyuDZvhe6M3z5g=;
        b=t7VnqOkCZ6E3fDGl2iED7/O11BmW1CcSUmgCZOyeLRdyRj++ypncJNmlhq6Hx1e7OH
         YeaqLAy4ARXs3IMITN/mXrgV1Osg4nbuJ6ejHgN8+w3hxaQNHzzybvZy1jpU2rtllFHw
         mqPE4AY5m6U1wYd/XGaSaE2JpBrgigki76Lf8Evy02vpBuiED6WYhM3mK0enmXSj/rVW
         +Ns/tkcFpb8j6tJ5QLwNTInKRSiE4rtpvBZEZb4+f+7wpsP9p15xjlyX0GDkxtiEpyo/
         xQ+GKSzBrZA0k1zkoYB4JWOgLqPn1DgVA/HPDilXpuN9xs3THdTy01Uy3Q0APZxzJRzI
         Tasg==
X-Gm-Message-State: ACrzQf2iWp+ypgPmZCVZqq15GAFaDp+PpjWAhgzJu7qq5Id/ktXT0T2X
        CETCz4fd+2z6JImpw5u4CnshU2zPnUbNmi+Wvi3eMHIHyzr9ZxYLMB6B7rdh47DupRR8BcIJ+GZ
        HxzzrNaHuLrXdLERm
X-Received: by 2002:a17:907:162a:b0:7a9:9875:3147 with SMTP id hb42-20020a170907162a00b007a998753147mr24811956ejc.546.1667412059711;
        Wed, 02 Nov 2022 11:00:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6+k26jt8P0meTC5cvtxOQG2A16cOuUyN4Zb9NbzYoBjeJ+Gwhk+kLVvmXBfhREPPfCCMEb7A==
X-Received: by 2002:a17:907:162a:b0:7a9:9875:3147 with SMTP id hb42-20020a170907162a00b007a998753147mr24811931ejc.546.1667412059484;
        Wed, 02 Nov 2022 11:00:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id q16-20020a17090676d000b007ae035374a0sm1016781ejn.214.2022.11.02.11.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 11:00:57 -0700 (PDT)
Message-ID: <28116f0b-4acd-d72c-aaee-c2fc63ad8190@redhat.com>
Date:   Wed, 2 Nov 2022 19:00:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH AUTOSEL 6.0 03/11] kvm: x86: Do proper cleanup if
 kvm_x86_ops->vm_init() fails
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20221014135139.2109024-1-sashal@kernel.org>
 <20221014135139.2109024-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221014135139.2109024-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/14/22 15:51, Sasha Levin wrote:
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
> index b0c47b41c264..11fbd42100be 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12080,6 +12080,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
> @@ -12115,8 +12119,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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

