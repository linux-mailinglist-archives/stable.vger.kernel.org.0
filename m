Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DD14F7EC4
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 14:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbiDGMOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 08:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238712AbiDGMOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 08:14:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 789FF1EC625
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 05:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649333562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=He8h+g9gcpriqclLdlbV5LzBn0WlLmTvUFHHwXaoICE=;
        b=GxmHoz3mvqVkuOjk50fkuE1bi4h4MZKOWFLKa8nWsAp4YZeFb+45Jq3XxZW8Ch4/bqxTCH
        NiSizmijzHDzMGDBd2VjGmFse/ElX8XZmscI9WhNXKHw3EiJQhL/mgoijBx40taApubI6I
        /svwLnGe2oH6OIOks9qZNBG3rOYe4mg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-SZw6S6uwOHK6HUBILXxytA-1; Thu, 07 Apr 2022 08:12:41 -0400
X-MC-Unique: SZw6S6uwOHK6HUBILXxytA-1
Received: by mail-wm1-f72.google.com with SMTP id j6-20020a05600c1c0600b0038e7d07ebcaso1434392wms.0
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 05:12:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=He8h+g9gcpriqclLdlbV5LzBn0WlLmTvUFHHwXaoICE=;
        b=w/WRmTxgVk/kPO8K58YsCVjWiei6nAO7luYcqRMYnSulfMGGWCe9cEebcZfvAVagLy
         q0ujZs1JFdBjmCJZwUGUeyCQBLZPJf4fLfG4UT5/PfJkMVfaOjLT2BEwTMvp2kyAsRwt
         hN+lzd+NHfSa7PaEtDyvHtgy+D988ANiKpDAHXJNAtTQ9QOzaXOg8GapOLpI/hqEfuym
         dPW8jts8soOGe00CXqu8OklMJZkdeh9+65tiRi+I7hvlOnxu29TD5TBcfWJu7vEigPqh
         cVnjyqh20PP8eL4oG7sX3VZHYD7t8DtMbWsRGlHm4+DZE4+S8BmOLyKiGxQ94G+L1slB
         ie6A==
X-Gm-Message-State: AOAM532IEE7FGtzL4ior6IKue3EGaw6sxaJ5s/6t8mvxZQykWFbNMUKA
        q6ZPdVUerR8AkFW7ztF85owpkNSxn51qHYUBtFMY6oMYgGesTXbYadM/3YhvWhkVTIgMimm/3No
        orftYTr2iXFqhr6q9
X-Received: by 2002:a05:600c:4f08:b0:38c:93fd:570f with SMTP id l8-20020a05600c4f0800b0038c93fd570fmr12048346wmq.136.1649333559830;
        Thu, 07 Apr 2022 05:12:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8VD2jmyYCLdT1LS37dFQHExBQz5m/CcSM2lhqIzro2UScARspuOQOmGyPtwzTU/phPmvvNw==
X-Received: by 2002:a05:600c:4f08:b0:38c:93fd:570f with SMTP id l8-20020a05600c4f0800b0038c93fd570fmr12048327wmq.136.1649333559539;
        Thu, 07 Apr 2022 05:12:39 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:20af:34be:985b:b6c8? ([2a09:80c0:192:0:20af:34be:985b:b6c8])
        by smtp.gmail.com with ESMTPSA id b8-20020a05600c4e0800b0038c6c37efc3sm7370765wmq.12.2022.04.07.05.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 05:12:38 -0700 (PDT)
Message-ID: <ca22625e-b72c-059a-9242-f10b291be4fe@redhat.com>
Date:   Thu, 7 Apr 2022 14:12:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 <770d8283-4315-3d83-4f8b-723308fffe5c@redhat.com>
 <Yk7TMKBAkuSVZRLT@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Yk7TMKBAkuSVZRLT@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.04.22 14:04, Michal Hocko wrote:
> On Thu 07-04-22 13:58:44, David Hildenbrand wrote:
> [...]
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 3589febc6d31..130a2feceddc 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -6112,10 +6112,8 @@ static int build_zonerefs_node(pg_data_t *pgdat, struct zoneref *zonerefs)
>>>  	do {
>>>  		zone_type--;
>>>  		zone = pgdat->node_zones + zone_type;
>>> -		if (managed_zone(zone)) {
>>> -			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
>>> -			check_highest_zone(zone_type);
>>> -		}
>>> +		zoneref_set_zone(zone, &zonerefs[nr_zones++]);
>>> +		check_highest_zone(zone_type);
>>>  	} while (zone_type);
>>>  
>>>  	return nr_zones;
>>
>> I don't think having !populated zones in the zonelist is a particularly
>> good idea. Populated vs !populated changes only during page
>> onlininge/offlining.
>>
>> If I'm not wrong, with your patch we'd even include ZONE_DEVICE here ...
> 
> What kind of problem that would cause? The allocator wouldn't see any
> pages at all so it would fallback to the next one. Maybe kswapd would
> need some tweak to have a bail out condition but as mentioned in the
> thread already. !populated or !managed for that matter are not all that
> much different from completely depleted zones. The fact that we are
> making that distinction has led to some bugs and I suspect it makes the
> code more complex without a very good reason.

I assume performance problems. Assume you have an ordinary system with
multiple NUMA nodes and no MOVABLE memory. Most nodes will only have
ZONE_NORMAL. Yet, you'd include ZONE_DMA* and ZONE_MOVABLE that will
always remain empty to be traversed on each and every allocation
fallback. Of course, we could measure, but IMHO at least *that* part of
memory onlining/offlining is not the complicated part :D

Populated vs. !populated is under pretty good control via page
onlining/offlining. We have to be careful with "managed pages", because
that's a moving target, especially with memory ballooning. And I assume
that's the bigger source of bugs.

> 
>> I'd vote for going with the simple fix first, which should be good
>> enough AFAIKT.
> 
> yes, see the other reply
> 

I think we were composing almost simultaneously :)

-- 
Thanks,

David / dhildenb

