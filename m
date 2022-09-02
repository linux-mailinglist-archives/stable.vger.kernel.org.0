Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90725AA853
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 08:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiIBGvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 02:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiIBGvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 02:51:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2598DA223D
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 23:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662101499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CzecCuEjT8bsZhw/7187r3Lof871WwEw17oDlg4yQ4A=;
        b=LSOdTCIm0Pp5vLo/pUKYONOScResI8d5KzAe3/HWNJmi1iNnFJQKBHnbFTHDhKjyJKKhwJ
        Qwv2H1iJOlB6n1y+sR0I7U/b+4rSLeNGy2oe14LU3p6pzejm4YTohMfvGZRnKh2bOz6YSK
        BmaBje1cZIPLJvvYd/XxheMAz8Pv2og=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-85VoCzKqNJK-inupeAunng-1; Fri, 02 Sep 2022 02:51:38 -0400
X-MC-Unique: 85VoCzKqNJK-inupeAunng-1
Received: by mail-wm1-f71.google.com with SMTP id q16-20020a1cf310000000b003a626026ed1so284090wmq.4
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 23:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=CzecCuEjT8bsZhw/7187r3Lof871WwEw17oDlg4yQ4A=;
        b=21r5o8IqpVBY9odmCPkc7Rn2asiqA3Z/+hWGSPlw0rFhoz3kGs9kMtsXQCm7RSmybx
         S99DclOw2t2V1vfrGd2i7MCTD5XacSuD8eLdtd9T7bK50e7T47hQNc1iDu0aKeLUC7kx
         A6wCLxSqz2LPOkZmJjuddsdfa76m2Sk90llHN5ovoIENTgdz8HW74mYOfm22cCGjHKSb
         B+edVEWTZYMrQAlYvMt2EqHTACHxYmSLu2ntITCjiQD9rvOJydfhW4GC37VKsfvfbLMN
         TDElNWGhn+Io3xF2McfOs2kJK/BvZFSJZ1IONDALDVyJ99LkFVpuEehKP9UwgknFJG3h
         caAA==
X-Gm-Message-State: ACgBeo1fIIEAxTa5aS0ylMjAdYcc7ciLLqF8AHkvhoR2CvBqgPSkSD91
        5m+GuLoVSrG1DtKuX/wMPO8czasV2Vw5P9yxCMvGj6kAOrmACcf9iuO+M9fPBHeO/U3LXfHJ8gV
        6gTdmpHueeQpgAd/M
X-Received: by 2002:a5d:5a82:0:b0:224:f744:1799 with SMTP id bp2-20020a5d5a82000000b00224f7441799mr16343589wrb.582.1662101497174;
        Thu, 01 Sep 2022 23:51:37 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6iZBZuSEIjazOLEKCa9lgC4RY/uchGV2EbWYG93tx8iwY/c8Hx5sRdwdAfHdsyv+pj+sX/bA==
X-Received: by 2002:a5d:5a82:0:b0:224:f744:1799 with SMTP id bp2-20020a5d5a82000000b00224f7441799mr16343574wrb.582.1662101496869;
        Thu, 01 Sep 2022 23:51:36 -0700 (PDT)
Received: from ?IPV6:2003:cb:c714:4800:2077:1bf6:40e7:2833? (p200300cbc714480020771bf640e72833.dip0.t-ipconnect.de. [2003:cb:c714:4800:2077:1bf6:40e7:2833])
        by smtp.gmail.com with ESMTPSA id x1-20020a5d6b41000000b002250c35826dsm727061wrw.104.2022.09.01.23.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 23:51:36 -0700 (PDT)
Message-ID: <cdca9b14-18fc-8cf2-5139-49a397098380@redhat.com>
Date:   Fri, 2 Sep 2022 08:51:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 2/4] mm/migrate_device.c: Add missing
 flush_cache_page()
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <9f801e9d8d830408f2ca27821f606e09aa856899.1662078528.git-series.apopple@nvidia.com>
 <5676f30436ab71d1a587ac73f835ed8bd2113ff5.1662078528.git-series.apopple@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <5676f30436ab71d1a587ac73f835ed8bd2113ff5.1662078528.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.09.22 02:35, Alistair Popple wrote:
> Currently we only call flush_cache_page() for the anon_exclusive case,
> however in both cases we clear the pte so should flush the cache.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
> Cc: stable@vger.kernel.org
> 
> ---
> 
> New for v4
> ---
>  mm/migrate_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 6a5ef9f..4cc849c 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -193,9 +193,9 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			bool anon_exclusive;
>  			pte_t swp_pte;
>  
> +			flush_cache_page(vma, addr, pte_pfn(*ptep));
>  			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
>  			if (anon_exclusive) {
> -				flush_cache_page(vma, addr, pte_pfn(*ptep));
>  				ptep_clear_flush(vma, addr, ptep);
>  
>  				if (page_try_share_anon_rmap(page)) {

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

