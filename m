Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D27446C24C
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 19:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240348AbhLGSHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 13:07:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240353AbhLGSHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 13:07:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638900212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eqw4DoNoRPNIxom496Pc+xv9s4RxxJr7evCd8ALX3L4=;
        b=L79s9uhaO9euBZDm1pMMYh0V9KQ3qdVgxHa8JrqnW03YILB/wPQ19jdrFfobdIdWBA/sL1
        sofru0v+x9VFdPjN9uE59ol3Fr9iDMEnvvX0NCAAtdpcVf/FdEd2NhgnG+3k/7V2OrzWnD
        9jhN+R91Y+7GM008GovCt9ZEgy9MJNw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-cK-pKgT0NruMah-VhSIyxQ-1; Tue, 07 Dec 2021 13:03:31 -0500
X-MC-Unique: cK-pKgT0NruMah-VhSIyxQ-1
Received: by mail-wm1-f72.google.com with SMTP id j25-20020a05600c1c1900b00332372c252dso39104wms.1
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 10:03:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=Eqw4DoNoRPNIxom496Pc+xv9s4RxxJr7evCd8ALX3L4=;
        b=685BSeKNhJUAPKt9jpzr+mwMBlpX4MtNx3AKWMzmng3rtT5iNh6rk3UupD/Pme/tYM
         +rke7iekYiAmm4+0i8CB/eN39CnAc/yYGgFZVehrJNcjMGPrh/l2gmkCEpr5YLc3EjEL
         9m3nGxEFnQ2GZM5i3vtXwUwxwrAZmstih7xVq6tp3HBK96eQzVEvIxPKh7+nXtdqhL2n
         +V1+fORTvkxQFhORbLZuB9NDWeaibb8dnG7sKygC2jEhM0vOGgv57S++o36noTeYQl28
         U0SimK3O1r02lJzagxd/54+JmQA/OStlXyJ+4XDsZ0NgpeEAXoZK4BZHNi9HCoacHGkp
         xtMg==
X-Gm-Message-State: AOAM5305unQlYzF8gYeHOtg8MpEaRLZQstVuJ2Vfj2FtL6j+IaJMATUi
        zX236yZOaOygDXmmBQf4SnU1odOAbSvYpvnwQqfj9o/eCDJ2IqeSjFytOv3vIFwgpbkwoXOGtzL
        8FjdM3eJ+ccz7y8jz
X-Received: by 2002:a5d:6d86:: with SMTP id l6mr52287893wrs.304.1638900209769;
        Tue, 07 Dec 2021 10:03:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwi72F1ctCVXtt4jzHgXreODAaisUhpw5bIQfwl5selrgG8TcO2EZzvZhkkxevEpYYqSoZBCA==
X-Received: by 2002:a5d:6d86:: with SMTP id l6mr52287864wrs.304.1638900209553;
        Tue, 07 Dec 2021 10:03:29 -0800 (PST)
Received: from [192.168.3.132] (p4ff23e57.dip0.t-ipconnect.de. [79.242.62.87])
        by smtp.gmail.com with ESMTPSA id c10sm397552wrb.81.2021.12.07.10.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 10:03:29 -0800 (PST)
Message-ID: <f9786109-518f-38d4-0270-a3e87a13c4ef@redhat.com>
Date:   Tue, 7 Dec 2021 19:03:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Michal Hocko <mhocko@suse.com>, Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
 <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
 <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
 <Ya9gN3rZ1eQou3rc@dhcp22.suse.cz>
 <77e785e6-cf34-0cff-26a5-852d3786a9b8@redhat.com>
 <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
 <b7deaf90-8c3c-c22a-b8dc-e6d98bc93ae6@redhat.com>
 <Ya+EHUYgzo8GaCeq@dhcp22.suse.cz>
 <d01c20fe-86d2-1dc8-e56d-15c0da49afb3@redhat.com>
 <Ya+LbaD8mkvIdq+c@dhcp22.suse.cz> <Ya+Nq2fWrSgl79Bn@dhcp22.suse.cz>
 <2E174230-04F3-4798-86D5-1257859FFAD8@vmware.com>
 <21539fc8-15a8-1c8c-4a4f-8b85734d2a0e@redhat.com>
 <78E39A43-D094-4706-B4BD-18C0B18EB2C3@vmware.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
In-Reply-To: <78E39A43-D094-4706-B4BD-18C0B18EB2C3@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.12.21 18:17, Alexey Makhalov wrote:
> 
> 
>> On Dec 7, 2021, at 9:13 AM, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 07.12.21 18:02, Alexey Makhalov wrote:
>>>
>>>
>>>> On Dec 7, 2021, at 8:36 AM, Michal Hocko <mhocko@suse.com> wrote:
>>>>
>>>> On Tue 07-12-21 17:27:29, Michal Hocko wrote:
>>>> [...]
>>>>> So your proposal is to drop set_node_online from the patch and add it as
>>>>> a separate one which handles
>>>>> 	- sysfs part (i.e. do not register a node which doesn't span a
>>>>> 	  physical address space)
>>>>> 	- hotplug side of (drop the pgd allocation, register node lazily
>>>>> 	  when a first memblocks are registered)
>>>>
>>>> In other words, the first stage
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index c5952749ad40..f9024ba09c53 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -6382,7 +6382,11 @@ static void __build_all_zonelists(void *data)
>>>> 	if (self && !node_online(self->node_id)) {
>>>> 		build_zonelists(self);
>>>> 	} else {
>>>> -		for_each_online_node(nid) {
>>>> +		/*
>>>> +		 * All possible nodes have pgdat preallocated
>>>> +		 * free_area_init
>>>> +		 */
>>>> +		for_each_node(nid) {
>>>> 			pg_data_t *pgdat = NODE_DATA(nid);
>>>>
>>>> 			build_zonelists(pgdat);
>>>
>>> Will it blow up memory usage for the nodes which might never be onlined?
>>> I prefer the idea of init on demand.
>>>
>>> Even now there is an existing problem.
>>> In my experiments, I observed _huge_ memory consumption increase by increasing number
>>> of possible numa nodes. I’m going to report it in separate mail thread.
>>
>> I already raised that PPC might be problematic in that regard. Which
>> architecture / setup do you have in mind that can have a lot of possible
>> nodes?
>>
> It is x86_64 VMware VM, not the regular one, but specially configured (1 vCPU per node,
> with hot-plug support, 128 possible nodes)  

I thought the pgdat would be smaller but I just gave it a test:

On my system, pgdata_t is 173824 bytes. So 128 nodes would correspond to
21 MiB, which is indeed a lot. I assume it's due to "struct zonelist",
which has MAX_ZONES_PER_ZONELIST == (MAX_NUMNODES * MAX_NR_ZONES) zone
references ...

-- 
Thanks,

David / dhildenb

