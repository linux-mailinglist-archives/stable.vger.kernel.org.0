Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6814F7E82
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 13:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243575AbiDGMAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 08:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240773AbiDGMAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 08:00:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 317D713F8C6
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 04:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649332728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mfC6ACVN+r1+9aoelvI2SUHBx6evFIztIF7swQ8/a5o=;
        b=Dwws9Boh1oRHkSaRUIPJpg/DfLJ04our/NAShDLRlZ2ORw+KgxferKAbWMBTSJiRh4fA0V
        d44cNh4kzGFeI9IjEOo2zj6q1zR6O9O4iXyMeuoSmgipwWQXaWnChMZRiMbsvR/zzlJL6J
        GAkeTYzTWL6yIF3GUGoPCsQfZsnKid4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-xQO-iT86PGyNa3NQJrZt4w-1; Thu, 07 Apr 2022 07:58:46 -0400
X-MC-Unique: xQO-iT86PGyNa3NQJrZt4w-1
Received: by mail-wr1-f72.google.com with SMTP id i64-20020adf90c6000000b00203f2b5e090so1195426wri.9
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 04:58:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=mfC6ACVN+r1+9aoelvI2SUHBx6evFIztIF7swQ8/a5o=;
        b=UYC5w+c4Q86y3cNmm7gSG4LaohV3+A92UuGYSc1mupV9OCjiN8B0l4FlK6UAZ/PxyO
         fg837ikZvfqU0aZanpVrUrAizNhQHkNqAkDUIZcURskavCm1pPw3u1CDzefyMnfApR2B
         APaQbqQOvFBrp8AWKTm/M+R74z3OtJdJjqRM0wh6kUIMY5jQF6sEVqIIctosS2CsvQzG
         0b8YUVahkszE4DUsONt911x4gMHkIaTsh6vT54p0hTSP4WtpM45hGLV0lDaYuf+M2hS9
         yswDy7pqEv9uW1ou3+NtLK+kbs88o5CRcoTkzxu9D/u8X0j6HQSWx5UD5779+Dq4wZ3F
         O+0Q==
X-Gm-Message-State: AOAM530lmWNNYszuKoUYzEx+ASi7j9peApeWv9tmhVQGJUESRsqonAFJ
        ddrogQmgI2hRSlLd1Rpa+NWhX+e3Il9vFsSrjtC9DCCpboBbx3ClSGIpWwE41V8RPF8Tcm/ODs3
        pC17WWwxFMXMyKkJw
X-Received: by 2002:a1c:c912:0:b0:37b:e074:dfcb with SMTP id f18-20020a1cc912000000b0037be074dfcbmr11670724wmb.161.1649332725625;
        Thu, 07 Apr 2022 04:58:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiets5YBv99cCr5Y+tvMGupOQmvkvg995AmX+y5wfvqAYms+Yx9LXLB0EbPyOeut+xYOcbkg==
X-Received: by 2002:a1c:c912:0:b0:37b:e074:dfcb with SMTP id f18-20020a1cc912000000b0037be074dfcbmr11670706wmb.161.1649332725340;
        Thu, 07 Apr 2022 04:58:45 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:20af:34be:985b:b6c8? ([2a09:80c0:192:0:20af:34be:985b:b6c8])
        by smtp.gmail.com with ESMTPSA id t6-20020a05600c198600b0038cafe3d47dsm8146389wmq.42.2022.04.07.04.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 04:58:44 -0700 (PDT)
Message-ID: <770d8283-4315-3d83-4f8b-723308fffe5c@redhat.com>
Date:   Thu, 7 Apr 2022 13:58:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>, Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, Mel Gorman <mgorman@suse.de>
References: <20220407093221.1090-1-jgross@suse.com>
 <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
 <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
 <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
 <5e97a7f5-1fc9-d0b4-006e-6894d5653c06@suse.com>
 <Yk7NqTlw7lmFzpKb@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Yk7NqTlw7lmFzpKb@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.04.22 13:40, Michal Hocko wrote:
> On Thu 07-04-22 13:17:19, Juergen Gross wrote:
>> On 07.04.22 13:07, Michal Hocko wrote:
>>> On Thu 07-04-22 12:45:41, Juergen Gross wrote:
>>>> On 07.04.22 12:34, Michal Hocko wrote:
>>>>> Ccing Mel
>>>>>
>>>>> On Thu 07-04-22 11:32:21, Juergen Gross wrote:
>>>>>> Since commit 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist
>>>>>> initialization") only zones with free memory are included in a built
>>>>>> zonelist. This is problematic when e.g. all memory of a zone has been
>>>>>> ballooned out.
>>>>>
>>>>> What is the actual problem there?
>>>>
>>>> When running as Xen guest new hotplugged memory will not be onlined
>>>> automatically, but only on special request. This is done in order to
>>>> support adding e.g. the possibility to use another GB of memory, while
>>>> adding only a part of that memory initially.
>>>>
>>>> In case adding that memory is populating a new zone, the page allocator
>>>> won't be able to use this memory when it is onlined, as the zone wasn't
>>>> added to the zonelist, due to managed_zone() returning 0.
>>>
>>> How is that memory onlined? Because "regular" onlining (online_pages())
>>> does rebuild zonelists if their zone hasn't been populated before.
>>
>> The Xen balloon driver has an own callback for onlining pages. The pages
>> are just added to the ballooned-out page list without handing them to the
>> allocator. This is done only when the guest is ballooned up.
> 
> OK, I see. Let me just rephrase to see whether we are on the same page.
> Xen is overriding the online_page_callback to xen_online_page which
> doesn't free pages to the page allocator which means that a zone might
> remain unpopulated after onlining. This means that the default zone
> lists rebuild is not done and later on when those pages are finally
> released to the allocator there is no build_all_zonelists happening so
> those freed pages are not really visible to the allocator via zonelists
> fallback allocation.
> 
> Now to your patch. I suspect this is not sufficient for the full hotplug
> situation. Consider a new NUMA node to be hotadded. hotadd_new_pgdat
> will call build_all_zonelists but the zone is not populated yet at that
> moment unless I am missing something. We do rely on online_pages to
> rebuild once pages are onlined - which usually means they are freed to
> the page allocator.
> 
> The zonelists building is kinda messy TBH. I have to say that I am not
> really clear on Mel's 6aa303defb74 ("mm, vmscan: only allocate and
> reclaim from zones with pages managed by the buddy allocator") because
> as you have said unpoppulated zone is not (or shouldn't be) really all
> that different from a depleted zone.
> 
> I think a better and more complete fix would be the following. In other
> words the zonelists will be built for all present zones. Not sure
> whether that is going to break 6aa303defb74 though.
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 2a9627dc784c..880c455e2557 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1062,7 +1062,6 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages,
>  		       struct zone *zone, struct memory_group *group)
>  {
>  	unsigned long flags;
> -	int need_zonelists_rebuild = 0;
>  	const int nid = zone_to_nid(zone);
>  	int ret;
>  	struct memory_notify arg;
> @@ -1106,17 +1105,13 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages,
>  	 * This means the page allocator ignores this zone.
>  	 * So, zonelist must be updated after online.
>  	 */
> -	if (!populated_zone(zone)) {
> -		need_zonelists_rebuild = 1;
> +	if (!populated_zone(zone))
>  		setup_zone_pageset(zone);
> -	}
>  
>  	online_pages_range(pfn, nr_pages);
>  	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
>  
>  	node_states_set_node(nid, &arg);
> -	if (need_zonelists_rebuild)
> -		build_all_zonelists(NULL);
>  
>  	/* Basic onlining is complete, allow allocation of onlined pages. */
>  	undo_isolate_page_range(pfn, pfn + nr_pages, MIGRATE_MOVABLE);
> @@ -1985,10 +1980,8 @@ int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  	/* reinitialise watermarks and update pcp limits */
>  	init_per_zone_wmark_min();
>  
> -	if (!populated_zone(zone)) {
> +	if (!populated_zone(zone))
>  		zone_pcp_reset(zone);
> -		build_all_zonelists(NULL);
> -	}
>  
>  	node_states_clear_node(node, &arg);
>  	if (arg.status_change_nid >= 0) {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3589febc6d31..130a2feceddc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6112,10 +6112,8 @@ static int build_zonerefs_node(pg_data_t *pgdat, struct zoneref *zonerefs)
>  	do {
>  		zone_type--;
>  		zone = pgdat->node_zones + zone_type;
> -		if (managed_zone(zone)) {
> -			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
> -			check_highest_zone(zone_type);
> -		}
> +		zoneref_set_zone(zone, &zonerefs[nr_zones++]);
> +		check_highest_zone(zone_type);
>  	} while (zone_type);
>  
>  	return nr_zones;

I don't think having !populated zones in the zonelist is a particularly
good idea. Populated vs !populated changes only during page
onlininge/offlining.

If I'm not wrong, with your patch we'd even include ZONE_DEVICE here ...

I'd vote for going with the simple fix first, which should be good
enough AFAIKT.

-- 
Thanks,

David / dhildenb

