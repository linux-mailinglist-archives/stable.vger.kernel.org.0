Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E845B476F29
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 11:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhLPKwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 05:52:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231640AbhLPKwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 05:52:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639651951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K8uTzGYoOBRJY7w+8Ql8RIVF0k5wL483NDOt+n6WV+4=;
        b=K0yjGxetYG0wi3kMZYwWL1tsYpqw/t/wa81aXTVYmvy2LtiwAEUjaGsAS4zRG9WOrLhiCL
        gJUQxLmfBQAIkabdD1SG/t487PmCt5EMnbWl/EyS7Hrq7loKoV2HGqDfT/M6ENYbWaIdt0
        DluTJC5KEjO0VYPVncPbXhrkfYG6rCk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-ofr9kNEcOoGr4AI0FKIiLg-1; Thu, 16 Dec 2021 05:52:29 -0500
X-MC-Unique: ofr9kNEcOoGr4AI0FKIiLg-1
Received: by mail-wr1-f72.google.com with SMTP id k11-20020adfc70b000000b001a2333d9406so1171906wrg.3
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 02:52:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=K8uTzGYoOBRJY7w+8Ql8RIVF0k5wL483NDOt+n6WV+4=;
        b=pd4j4skHlSMk4MRzfp1WaDKrUD9Ws0BcNAr31EzgL9cP2u73HAuzdwJJdGPJM6VJ/j
         dfg8nSzizBlNC3M57CIlxo4ylCVxehHCAXAACeYUaHd1jZ0oLXYCru6SopDrWefqc9US
         pRWiyy1YvhGqQl9v22uKFooiJu82V5kaFCj3qr41LmU7sQVfnDWCsKjL8xhff50/pyjE
         MwtMEiPka2og8Y9mhYYixPHa/n/b+FFO+PGBF0Oinb8ukWRHeqgKzBzfEppm933ZikWp
         p0wRuB9HKUAvwIbirvObYV61s6Zi/+DpKV+8KeogFQHT77HCEdxZe85TYl2iMtpVGsLk
         6Lbw==
X-Gm-Message-State: AOAM530AutF904oy9Ow75Gj+SD8QF2mB5XtGf/QU3j1DNSfSVL3J4Tny
        6PCkYtQ6lSX/QM4eF9Ots1gVOQDUj8Lzdf4QErSfNpKhLUB9WKpVVs8umPyGU05xhmvAcYAI8BO
        AQeYiSmiYRZ9Uglvd
X-Received: by 2002:a5d:6b81:: with SMTP id n1mr8498338wrx.56.1639651948620;
        Thu, 16 Dec 2021 02:52:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHuwZkDO7xDTGVXnkIzmCOOqyhEHNs5qWSXjlASQ9huiT2CqWmGIwoAlwyq1QAUc8hqk8taw==
X-Received: by 2002:a5d:6b81:: with SMTP id n1mr8498324wrx.56.1639651948362;
        Thu, 16 Dec 2021 02:52:28 -0800 (PST)
Received: from [192.168.3.132] (p4ff23dcd.dip0.t-ipconnect.de. [79.242.61.205])
        by smtp.gmail.com with ESMTPSA id e11sm5582137wrq.28.2021.12.16.02.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 02:52:27 -0800 (PST)
Message-ID: <0091b689-54b6-7cc9-d5ee-ae12a2f8376d@redhat.com>
Date:   Thu, 16 Dec 2021 11:52:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 3/5] mm_zone: add function to check if managed dma zone
 exists
Content-Language: en-US
To:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, John.p.donnelly@oracle.com,
        kexec@lists.infradead.org, stable@vger.kernel.org
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-4-bhe@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211213122712.23805-4-bhe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.12.21 13:27, Baoquan He wrote:
> In some places of the current kernel, it assumes that dma zone must have
> managed pages if CONFIG_ZONE_DMA is enabled. While this is not always true.
> E.g in kdump kernel of x86_64, only low 1M is presented and locked down
> at very early stage of boot, so that there's no managed pages at all in
> DMA zone. This exception will always cause page allocation failure if page
> is requested from DMA zone.
> 
> Here add function has_managed_dma() and the relevant helper functions to
> check if there's DMA zone with managed pages. It will be used in later
> patches.
> 
> Fixes: 6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
> v2->v3:
>  Rewrite has_managed_dma() in a simpler and more efficient way which is
>  sugggested by DavidH. 
> 
>  include/linux/mmzone.h |  9 +++++++++
>  mm/page_alloc.c        | 15 +++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 58e744b78c2c..6e1b726e9adf 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1046,6 +1046,15 @@ static inline int is_highmem_idx(enum zone_type idx)
>  #endif
>  }
>  
> +#ifdef CONFIG_ZONE_DMA
> +bool has_managed_dma(void);
> +#else
> +static inline bool has_managed_dma(void)
> +{
> +	return false;
> +}
> +#endif
> +
>  /**
>   * is_highmem - helper function to quickly check if a struct zone is a
>   *              highmem zone or not.  This is an attempt to keep references
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c5952749ad40..7c7a0b5de2ff 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -9460,3 +9460,18 @@ bool take_page_off_buddy(struct page *page)
>  	return ret;
>  }
>  #endif
> +
> +#ifdef CONFIG_ZONE_DMA
> +bool has_managed_dma(void)
> +{
> +	struct pglist_data *pgdat;
> +
> +	for_each_online_pgdat(pgdat) {
> +		struct zone *zone = &pgdat->node_zones[ZONE_DMA];
> +
> +		if (managed_zone(zone))
> +			return true;
> +	}
> +	return false;
> +}
> +#endif /* CONFIG_ZONE_DMA */
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

