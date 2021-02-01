Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F355E30A8F2
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 14:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhBANjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 08:39:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231357AbhBANjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 08:39:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612186692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIidTHAlvNTypJNX4Ptuq/3z20fdadApbhIsv9h3oks=;
        b=VHnq7wLEwtwYq3ICSXCMbg9I3yhoVH3rvsZ/QknWglpQx3VxtwzRjt+EF1B8aGLFJci6l2
        HD/DZGKnRavbkRZrQnOPXGRX5vtL77hlHqZJ2pzVtuzpVyCI2liHlLjPWBsRcj0Z0lt2ZW
        jpJ4ct7jNI/d3rBxo6s8EfzaPUIbLFI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-b3kpS6DqPIazYJbMQaHAkQ-1; Mon, 01 Feb 2021 08:38:08 -0500
X-MC-Unique: b3kpS6DqPIazYJbMQaHAkQ-1
Received: by mail-ej1-f70.google.com with SMTP id m4so8256786ejc.14
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 05:38:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wIidTHAlvNTypJNX4Ptuq/3z20fdadApbhIsv9h3oks=;
        b=hjjgvTxFX9t6yUBpEhorpGIbuBQnsyJYFQ1x+paJUyhAJDGIS9IPfXrlIWeoGbMRNA
         K6+AQkEGY26hO6AdNWrhNweMY1sAPC/bA0v6PQs4jMjksT6Pxe8rtQ/J2Lb2qZCHiQO/
         ELFPVs0gjikEIIa5ecmkyzcf8f7uuQPhYPUp7GxGvHNLBehbXjgwUd1i5Wwpjd6fhoMq
         L3Pwt31tV7tqKRvzxOYelP58AbWKiJvWdhTIFNuGylerFcAxGQe9cmanrKiS3JXqd+JA
         ATKuMb4KDjcBB3FdgvMN0TGDuumO7YB8ZWyoep6xXxhzsWMTGHWKIUstL6M4m2D1m7/G
         ZZqw==
X-Gm-Message-State: AOAM532aupslccf2d3AQri2ZWs4C4CD1dma6ixG/kADFm68XF5qAJy7h
        8R5skj+8XsAEAnzVc1VIKimgseTeKf43e922XJOa5gbOrThvvLlofk8BE7+C3x0KLspB6FhugeF
        LFjcuhORUIDVsp9ok
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr17769659ejb.552.1612186687245;
        Mon, 01 Feb 2021 05:38:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7eaJLZccsr/7XoXoaYOhRjGJ3l7lY+Ixm9zSwzLhn0XeXkuWxpJSlECBzs8FAsL/W8npLDg==
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr17769642ejb.552.1612186687077;
        Mon, 01 Feb 2021 05:38:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bk2sm8137778ejb.98.2021.02.01.05.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 05:38:06 -0800 (PST)
Subject: Re: [stable-5.4][PATCH] KVM: Forbid the use of tagged userspace
 addresses for memslots
To:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, kvm@vger.kernel.org,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210201133137.3541896-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b08e3ccf-9a69-819a-8632-46c82dade2fa@redhat.com>
Date:   Mon, 1 Feb 2021 14:38:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210201133137.3541896-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/02/21 14:31, Marc Zyngier wrote:
> commit 139bc8a6146d92822c866cf2fd410159c56b3648 upstream.
> 
> The use of a tagged address could be pretty confusing for the
> whole memslot infrastructure as well as the MMU notifiers.
> 
> Forbid it altogether, as it never quite worked the first place.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   Documentation/virt/kvm/api.txt | 3 +++
>   virt/kvm/kvm_main.c            | 1 +
>   2 files changed, 4 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index a18e996fa54b..7064efd3b5ea 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -1132,6 +1132,9 @@ field userspace_addr, which must point at user addressable memory for
>   the entire memory slot size.  Any object may back this memory, including
>   anonymous memory, ordinary files, and hugetlbfs.
>   
> +On architectures that support a form of address tagging, userspace_addr must
> +be an untagged address.
> +
>   It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>   be identical.  This allows large pages in the guest to be backed by large
>   pages in the host.
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8f3b40ec02b7..f25b5043cbca 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1017,6 +1017,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	/* We can read the guest memory with __xxx_user() later on. */
>   	if ((id < KVM_USER_MEM_SLOTS) &&
>   	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
> +	     (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
>   	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
>   			mem->memory_size)))
>   		goto out;
> 

Indeed untagged_addr was added in 5.3.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

