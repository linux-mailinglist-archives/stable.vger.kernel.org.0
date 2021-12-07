Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F5646C05C
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 17:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239470AbhLGQNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 11:13:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239468AbhLGQNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 11:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638893394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bnTROK0sRUs6y6/xGbMg2/jiQ98PjmkglwIQKpx2ZZY=;
        b=NOjRsrkYJ5JKAc7K7wDOQUvMMW8ycpY5CTQRsV24tdANBD+5mCNTXbC/FRSUlOVfCygHOn
        vyqfpEWIOgFMDKFwes0TllGxNvpNnBAPemgtf42sqDR2cBiJbrGq8mSiAFGwmcT1gkRllW
        Oh9Mpn1KQc5D18Nmrsl/7t043OOt8GM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-566-dhijZ48cMdSNYYhmNeTPTA-1; Tue, 07 Dec 2021 11:09:53 -0500
X-MC-Unique: dhijZ48cMdSNYYhmNeTPTA-1
Received: by mail-wm1-f69.google.com with SMTP id 138-20020a1c0090000000b00338bb803204so7949343wma.1
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 08:09:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=bnTROK0sRUs6y6/xGbMg2/jiQ98PjmkglwIQKpx2ZZY=;
        b=BQR+ZtSlAnmNLpK7ou9Gy9xCEBiqHuVTxcnwJpfCtXh5yUpggRAcED8MdEmx3vALI5
         0W13J34VATJLQgmZPIFGCBQH/xfbhDUGzY9YVB6yBJs3YMPHEQHkHXW/u2LC9a0YEkAp
         Lm9oWCnpd/U7ZG2VukzZ9rUIEAbRZ1IvMg5PpSm8PocEoBi/EVjIxEQwQ2peYNLwjwHb
         egKy/eda/b5FjLoTXN0zPY0/Q7U1KwvBKKzwt8H4vMZyDAu7dGiLfUkAk7jLnthcfYr5
         gqbPFI4bEM7JqtO8Zg19Il0N6zl/uoS+kNsx8MqQOK3Ei7M6AgsZCboGCQRd9tQuDgih
         tR6g==
X-Gm-Message-State: AOAM531HNPvLa7GAkPwTJB86KnF8nqtEsv7/Z9yKqDJzlig+m7RD4nco
        5gVp1cIahgbiTWMwdjbMdmQ9alBrRDXuhSf+Y60dYcCgTttVzjVQEM6OG2bU7JzJDICZCXLT+ws
        ++mWUQDQvzKZ1n62G
X-Received: by 2002:a5d:5385:: with SMTP id d5mr50448133wrv.132.1638893392054;
        Tue, 07 Dec 2021 08:09:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9ldVyRrmB5nuJ47FSKKSCjaAcG/QjMhUIbKA/W1EzCMV866Dtf4wOnleVEUwats11J6c4lg==
X-Received: by 2002:a5d:5385:: with SMTP id d5mr50448100wrv.132.1638893391795;
        Tue, 07 Dec 2021 08:09:51 -0800 (PST)
Received: from [192.168.3.132] (p4ff23e57.dip0.t-ipconnect.de. [79.242.62.87])
        by smtp.gmail.com with ESMTPSA id q123sm2958207wma.30.2021.12.07.08.09.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 08:09:51 -0800 (PST)
Message-ID: <d01c20fe-86d2-1dc8-e56d-15c0da49afb3@redhat.com>
Date:   Tue, 7 Dec 2021 17:09:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz> <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
 <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
 <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
 <Ya9gN3rZ1eQou3rc@dhcp22.suse.cz>
 <77e785e6-cf34-0cff-26a5-852d3786a9b8@redhat.com>
 <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
 <b7deaf90-8c3c-c22a-b8dc-e6d98bc93ae6@redhat.com>
 <Ya+EHUYgzo8GaCeq@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Ya+EHUYgzo8GaCeq@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.12.21 16:56, Michal Hocko wrote:
> On Tue 07-12-21 16:34:30, David Hildenbrand wrote:
>> On 07.12.21 16:29, Michal Hocko wrote:
>>> On Tue 07-12-21 16:09:39, David Hildenbrand wrote:
>>>> On 07.12.21 14:23, Michal Hocko wrote:
>>>>> On Tue 07-12-21 13:28:31, David Hildenbrand wrote:
>>>>> [...]
>>>>>> But maybe I am missing something important regarding online vs. offline
>>>>>> nodes that your patch changes?
>>>>>
>>>>> I am relying on alloc_node_data setting the node online. But if we are
>>>>> to change the call to arch_alloc_node_data then the patch needs to be
>>>>> more involved. Here is what I have right now. If this happens to be the
>>>>> right way then there is some additional work to sync up with the hotplug
>>>>> code.
>>>>>
>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>> index c5952749ad40..a296e934ad2f 100644
>>>>> --- a/mm/page_alloc.c
>>>>> +++ b/mm/page_alloc.c
>>>>> @@ -8032,8 +8032,23 @@ void __init free_area_init(unsigned long *max_zone_pfn)
>>>>>  	/* Initialise every node */
>>>>>  	mminit_verify_pageflags_layout();
>>>>>  	setup_nr_node_ids();
>>>>> -	for_each_online_node(nid) {
>>>>> -		pg_data_t *pgdat = NODE_DATA(nid);
>>>>> +	for_each_node(nid) {
>>>>> +		pg_data_t *pgdat;
>>>>> +
>>>>> +		if (!node_online(nid)) {
>>>>> +			pr_warn("Node %d uninitialized by the platform. Please report with memory map.\n", nid);
>>>>> +			pgdat = arch_alloc_nodedata(nid);
>>>>> +			pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
>>>>> +			arch_refresh_nodedata(nid, pgdat);
>>>>> +			node_set_online(nid);
>>>>
>>>> Setting all possible nodes online might result in quite some QE noice,
>>>> because all these nodes will then be visible in the sysfs and
>>>> try_offline_nodes() is essentially for the trash.
>>>
>>> I am not sure I follow. I believe sysfs will not get populate because I
>>> do not call register_one_node.
>>
>> arch/x86/kernel/topology.c:topology_init()
>>
>> for_each_online_node(i)
>> 	register_one_node(i);
> 
> Right you are.
>  
>>> You are right that try_offline_nodes will be reduce which is good imho.
>>> More changes will be possible (hopefully to drop some ugly code) on top
>>> of this change (or any other that achieves that there are no NULL pgdat
>>> for possible nodes).
>>>
>>
>> No to exposing actually offline nodes to user space via sysfs.
> 
> Why is that a problem with the sysfs for non-populated nodes?
> 

https://lore.kernel.org/linuxppc-dev/20200428093836.27190-1-srikar@linux.vnet.ibm.com/t/

Contains some points -- certainly nothing unfixable but it clearly shows
that users expect only nodes with actual memory and cpus to be online --
that's why we export the possible+online state to user space. My point
is to be careful with such drastic changes and do one step at a time.

I think preallocation of the pgdat is a reasonable thing to have without
changing user-space visible semantics or even in-kernel semantics.

-- 
Thanks,

David / dhildenb

