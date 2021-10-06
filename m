Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E6F423F72
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbhJFNiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238945AbhJFNiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 09:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633527386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Y7uP8QRGocqx1FZVyYu93M+isTRRJCiJChkQsmHD78=;
        b=M7sEu0POQRrvt7zrygMEXvp42H/0eLlAmxDfQx683nhnumTuzWdcuoPgD11wllrFWBUtXv
        rwJYUWGcIipBSUe0NLhkK+BXVil7AtufNy3cQglRemt+8H4UZ93GkmaWF9gt5vDiR/opa5
        JnMN4tovdsGPPVWMAyp5qfFR7h885SU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-GBV1lh35PeeXmPBsunNWMA-1; Wed, 06 Oct 2021 09:36:25 -0400
X-MC-Unique: GBV1lh35PeeXmPBsunNWMA-1
Received: by mail-ed1-f69.google.com with SMTP id bo2-20020a0564020b2200b003db3540f206so2451316edb.23
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 06:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5Y7uP8QRGocqx1FZVyYu93M+isTRRJCiJChkQsmHD78=;
        b=I1G7gCUj3FnkW2txkXz5kaufhhijoPkNeCJboLGj/g65s3B2XyrSNPRdanUSU0qZdk
         LM/rDzTC6KhFFIq4qRaCMP9rRyP8OvaztpNjyfynE3AJkO2C51ffIJeX7Vw6X2GjAsy/
         wGh5r6aWTg9FgjTzi4Hjkt6EgVokrnoFcZ3dNrwi8IfKMc2uSE4cBiq/7iAWdCkCHgLl
         AILU+WE3zpT48Vnf0rVQCo2eUSU57J11xJYJmdekA7JghXXgYwE11EWDzFTe3GAXUx43
         98CE8qmcv3QlOfG3zuHrvjNkCMeVrjqxpLMdiw47RztiTzZ8iga2XNO17fR+tjG4lZku
         XSpg==
X-Gm-Message-State: AOAM531DvA+nub88GzB2VAsuSneFjZZKyQnd75KAU+eKhqVHCM74ThG6
        UP18dSl2jtNXh6PSYsXrkIrTfseMwWo82jQBZrVhfaiP9nOad2OAYUTen6qhbD+2ANKJdr8xl5H
        bdmjGLYyGriDn3ND5
X-Received: by 2002:a50:be87:: with SMTP id b7mr35515635edk.382.1633527382864;
        Wed, 06 Oct 2021 06:36:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwobZOH4vhU8yiSwk506kzAz0km9ltn77l54Biy7c8hKVY5ZQU5W14yw6v6WXzxLgrbZkv4QA==
X-Received: by 2002:a50:be87:: with SMTP id b7mr35515607edk.382.1633527382653;
        Wed, 06 Oct 2021 06:36:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id x16sm4468819ejj.8.2021.10.06.06.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 06:36:21 -0700 (PDT)
Message-ID: <fcaf3441-766a-c774-1a1d-d94882719403@redhat.com>
Date:   Wed, 6 Oct 2021 15:36:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 2/9] KVM: x86: Handle SRCU initialization
 failure during page track init
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006133021.271905-1-sashal@kernel.org>
 <20211006133021.271905-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006133021.271905-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/21 15:30, Sasha Levin wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
> 
> [ Upstream commit eb7511bf9182292ef1df1082d23039e856d1ddfb ]
> 
> Check the return of init_srcu_struct(), which can fail due to OOM, when
> initializing the page track mechanism.  Lack of checking leads to a NULL
> pointer deref found by a modified syzkaller.
> 
> Reported-by: TCS Robot <tcs_robot@tencent.com>
> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
> Message-Id: <1630636626-12262-1-git-send-email-tcs_kernel@tencent.com>
> [Move the call towards the beginning of kvm_arch_init_vm. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/include/asm/kvm_page_track.h | 2 +-
>   arch/x86/kvm/mmu/page_track.c         | 4 ++--
>   arch/x86/kvm/x86.c                    | 7 ++++++-
>   3 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index 87bd6025d91d..6a5f3acf2b33 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -46,7 +46,7 @@ struct kvm_page_track_notifier_node {
>   			    struct kvm_page_track_notifier_node *node);
>   };
>   
> -void kvm_page_track_init(struct kvm *kvm);
> +int kvm_page_track_init(struct kvm *kvm);
>   void kvm_page_track_cleanup(struct kvm *kvm);
>   
>   void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 91a9f7e0fd91..68e67228101d 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -163,13 +163,13 @@ void kvm_page_track_cleanup(struct kvm *kvm)
>   	cleanup_srcu_struct(&head->track_srcu);
>   }
>   
> -void kvm_page_track_init(struct kvm *kvm)
> +int kvm_page_track_init(struct kvm *kvm)
>   {
>   	struct kvm_page_track_notifier_head *head;
>   
>   	head = &kvm->arch.track_notifier_head;
> -	init_srcu_struct(&head->track_srcu);
>   	INIT_HLIST_HEAD(&head->track_notifier_list);
> +	return init_srcu_struct(&head->track_srcu);
>   }
>   
>   /*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7ec7c2dce506..b3f855d48f72 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11090,9 +11090,15 @@ void kvm_arch_free_vm(struct kvm *kvm)
>   
>   int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   {
> +	int ret;
> +
>   	if (type)
>   		return -EINVAL;
>   
> +	ret = kvm_page_track_init(kvm);
> +	if (ret)
> +		return ret;
> +
>   	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
>   	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>   	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
> @@ -11125,7 +11131,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   
>   	kvm_apicv_init(kvm);
>   	kvm_hv_init_vm(kvm);
> -	kvm_page_track_init(kvm);
>   	kvm_mmu_init_vm(kvm);
>   
>   	return static_call(kvm_x86_vm_init)(kvm);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

