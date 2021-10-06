Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B48423C9C
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238355AbhJFLYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:24:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238286AbhJFLYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 07:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/Zgi1wsYZ/utXyyQF+xCXuqHO4iLDqak0bKLEB9Lv4=;
        b=XKm49InDVWfSHNa2QwE08s+LPSzZUaL9UVD6tOXS4LEzRRq9CsCvij+UjnHuzWtLvyr1U5
        QXFBU0Iidb7jkGj/BPUkHBLSmLSAlwbrTH1AVGr5XFM7IekWtg0CxOxos0sn2F5LWTacWL
        pSCcSGLqKrLT+yh9wChGLPM+9n/3//c=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-BeUAm3i9OeSmqaonKxwejw-1; Wed, 06 Oct 2021 07:22:59 -0400
X-MC-Unique: BeUAm3i9OeSmqaonKxwejw-1
Received: by mail-ed1-f69.google.com with SMTP id x5-20020a50f185000000b003db0f796903so2291703edl.18
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 04:22:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C/Zgi1wsYZ/utXyyQF+xCXuqHO4iLDqak0bKLEB9Lv4=;
        b=I4Ux94zwLA6CI/jmP5vBPJpQf/ZvvtQ6NyHYEvgm9KM0/Q7XNtKQdzSNETNvTD3lDp
         /EpHx8++hH+2kBqOg7PjhZWYOdSqX7/JZIgUVUrUM2Wy6AnSyxdulRclsRBJk7nT9IOQ
         MYBfD6akkd1SyVZmkqzVRutJZkLgg9gvzujJh5G3KpI6ot2LqMuRyvyqbRk5KyeQ1HFM
         bXia0Wp2gW8OpzXhpg0/L9WnN4hmzRbZgzidtUgJm9/NgRjWbt+Yv+CY7q5jZd+MM2yf
         jT4ttAmLVEI3xExd80fp24VuI2BkXKsWXIzDBRxqlVGFXCAgSDTmqQSxlYqr8ie7LRUD
         fKPw==
X-Gm-Message-State: AOAM53169t0kdX2jKIhqdMxCcM7U/xcBNvOaxQCJcMdy7EJ5qaCJ9WMC
        RFJZiN6dQ1TEZckYLDc+pglYle1lqRN80aFYJ8IUdvEybt3FKx6KDqWv5PLioyISCH2R94E9Sc/
        vhOn3X6NDurv0RAbg
X-Received: by 2002:a05:6402:1011:: with SMTP id c17mr33666222edu.144.1633519378097;
        Wed, 06 Oct 2021 04:22:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqN+hYPbfU4H4kC/Pj0UZUnKoayGEPwFgezwkfiCLimJ/jquxZ6sU+8+Thig10TBLynhNc+A==
X-Received: by 2002:a05:6402:1011:: with SMTP id c17mr33666198edu.144.1633519377902;
        Wed, 06 Oct 2021 04:22:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d6sm5211684ejd.116.2021.10.06.04.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:22:56 -0700 (PDT)
Message-ID: <3ca1cf75-63d9-942f-e9f0-66ac96357737@redhat.com>
Date:   Wed, 6 Oct 2021 13:22:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.10 2/7] KVM: x86: Handle SRCU initialization
 failure during page track init
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006111234.264020-1-sashal@kernel.org>
 <20211006111234.264020-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006111234.264020-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/21 13:12, Sasha Levin wrote:
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
> index 8443a675715b..81cf4babbd0b 100644
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
> index 75c59ad27e9f..d65da3b5837b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10392,9 +10392,15 @@ void kvm_arch_free_vm(struct kvm *kvm)
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
> @@ -10421,7 +10427,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
>   
>   	kvm_hv_init_vm(kvm);
> -	kvm_page_track_init(kvm);
>   	kvm_mmu_init_vm(kvm);
>   
>   	return kvm_x86_ops.vm_init(kvm);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

