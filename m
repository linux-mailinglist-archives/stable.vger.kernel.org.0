Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3958B442C04
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 12:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhKBLDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 07:03:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230511AbhKBLDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 07:03:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635850861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yPuvfc021Apc8nEN/ZWlC8IBwOSwrXQgsH2pNayQZNU=;
        b=GfBDgLznwr1NqQ2o3gC/jOCcg5OUJ3lxE2/G2Y4YcUQ7V4BC1dSj2cqi6YcDAOn/71corL
        nKFUxoRB39tk4oLGoYVoDFuB3vUMBCS3op28F7VJAW97AzRPkxoLSZ+HrrXrU2xkAhZyi+
        mBtmhd4gH0DstU2fQ9FKNCJ/9KW48xE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-Y3iLOPhwPt2TE7qmBiFNtg-1; Tue, 02 Nov 2021 07:01:00 -0400
X-MC-Unique: Y3iLOPhwPt2TE7qmBiFNtg-1
Received: by mail-wm1-f69.google.com with SMTP id m1-20020a1ca301000000b003231d5b3c4cso940612wme.5
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 04:01:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=yPuvfc021Apc8nEN/ZWlC8IBwOSwrXQgsH2pNayQZNU=;
        b=mGGnKa11wRH+gmB+dqOxXCA3rS3f1CCv87Qhv9bhPG4clPXBYF1SzuD22rkGPHC8+g
         1H2JaMX+uhhad6pcp5Iotubem0YbU5YIWWTBBAlD7nGSW69VcP5194QpvKrI3XTEBsHJ
         01tFmPsPMyi7vkp099mxkuNbNWzgPRhF3p0QUrAU9t0X2ZrGb9cKvkBKGxSxvO+Es1Ri
         Oz5/+9K/0DgJoTdJp3V//sScy+HQeMm2Kca3IuItkJIx1Xn2z+sNfC8EOL2HxTigSjSd
         Z1ukOg9jqF5k7FdyfvnZt3m0Jkh7Ba2cMRjWeVJuNFSsk/7YGnQ1Zgcnj6BJKUXEHK1C
         hZVQ==
X-Gm-Message-State: AOAM532Qd6DzWYOVsjFm89e4AhmpBMVuRkTnrRB9lYGtXr0Bo+KN6FBy
        1zbbivh+qatJnAR6RjOvRvPMh/rB3kzWYkQGMYTBORukyVEJmNlta9f2sMxNksrPxGjzAW8n/WY
        LyUCyGl9pBrXJMckw
X-Received: by 2002:a05:600c:210d:: with SMTP id u13mr5946514wml.82.1635850858973;
        Tue, 02 Nov 2021 04:00:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCOtg2Gm13Yy+uIpzsEFzMnGdZBMoaq+xd83sWDYqRGCHbXXbMnnvj3csbxCrlKqVyco3Eyw==
X-Received: by 2002:a05:600c:210d:: with SMTP id u13mr5946483wml.82.1635850858716;
        Tue, 02 Nov 2021 04:00:58 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6810.dip0.t-ipconnect.de. [91.12.104.16])
        by smtp.gmail.com with ESMTPSA id m36sm964644wms.25.2021.11.02.04.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 04:00:58 -0700 (PDT)
Message-ID: <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
Date:   Tue, 2 Nov 2021 12:00:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Michal Hocko <mhocko@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
In-Reply-To: <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.11.21 11:34, Alexey Makhalov wrote:
> 
>>>>> In add_memory_resource() we hotplug the new node if required and set it
>>>>> online. Memory might get onlined later, via online_pages().
>>>>
>>>> You are correct. In case of memory hot add, it is true. But in case of adding
>>>> CPU with memoryless node, try_node_online() will be called only during CPU
>>>> onlining, see cpu_up().
>>>>
>>>> Is there any reason why try_online_node() resides in cpu_up() and not in add_cpu()?
>>>> I think it would be correct to online node during the CPU hot add to align with
>>>> memory hot add.
>>>
>>> I am not familiar with cpu hotplug, but this doesn't seem to be anything
>>> new so how come this became problem only now?
>>
>> So IIUC, the issue is that we have a node
>>
>> a) That has no memory
>> b) That is offline
>>
>> This node will get onlined when onlining the CPU as Alexey says. Yet we
>> have some code that stumbles over the node and goes ahead trying to use
>> the pgdat -- that code is broken.
> 
> You are correct.
> 
>>
>>
>> If we take a look at build_zonelists() we indeed skip any
>> !node_online(node). Any other code should do the same. If the node is
>> not online, it shall be ignored because we might not even have a pgdat
>> yet -- see hotadd_new_pgdat(). Without node_online(), the pgdat might be
>> stale or non-existant.
> 
> Agree, alloc_pages_node() should also do the same. Not exactly to skip the node,
> but to fallback to another node if !node_online(node).
> alloc_pages_node() can also be hit while onlining the node, creating chicken-egg
> problem, see below

Right, the issue is also a bit involved when calling alloc_pages_node()
on an offline NID. See below.

> 
>>
>>
>> The node onlining logic when onlining a CPU sounds bogus as well: Let's
>> take a look at try_offline_node(). It checks that:
>> 1) That no memory is *present*
>> 2) That no CPU is *present*
>>
>> We should online the node when adding the CPU ("present"), not when
>> onlining the CPU.
> 
> Possible.
> Assuming try_online_node was moved under add_cpu(), let’s
> take look on this call stack:
> add_cpu()
>   try_online_node()
>     __try_online_node()
>       hotadd_new_pgdat()
> At line 1190 we'll have a problem:
> 1183         pgdat = NODE_DATA(nid);
> 1184         if (!pgdat) {
> 1185                 pgdat = arch_alloc_nodedata(nid);
> 1186                 if (!pgdat)
> 1187                         return NULL;
> 1188
> 1189                 pgdat->per_cpu_nodestats =
> 1190                         alloc_percpu(struct per_cpu_nodestat);
> 1191                 arch_refresh_nodedata(nid, pgdat);
> 
> alloc_percpu() will go for all possible CPUs and will eventually end up
> calling alloc_pages_node() trying to use subject nid for corresponding CPU
> hitting the same state #2 problem as NODE_DATA(nid) is still NULL and nid
> is not yet online.

Right, we will end up calling pcpu_alloc_pages()->alloc_pages_node() for
each possible CPU. We use cpu_to_node() to come up with the NID.

I can only assume that we usually don't get an offline NID for an
offline CPU, but instead either NODE=0 or NODE=NUMA_NO_NODE, because ...


alloc_pages_node()->__alloc_pages_node() will:

VM_WARN_ON((gfp_mask & __GFP_THISNODE) && !node_online(nid));

BUT: prepare_alloc_pages()

ac->zonelist = node_zonelist(preferred_nid, gfp_mask);

should similarly fail. when de-referencing NULL.

-- 
Thanks,

David / dhildenb

