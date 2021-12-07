Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5761046BF6A
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 16:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbhLGPiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 10:38:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238861AbhLGPiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 10:38:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638891274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5R4cWI/77swxdmILy6TLQB1mcQwz65GKbFISlyFEK3A=;
        b=h2kUqCn6ptufREwU/kjwt3brBTLOErb46E+5PRxXMCc7Ge5ZkRETnCU88SGpP5syTLJV6K
        PBystBDPrAYBAlq/sSZYtOue7Rqgoveh/QV40mO8rbP4k0WnUWNhD4iCKXAXbB6XZME9HT
        aDRSHOLFOKRY1Xa8Is4DiUCTpCDIjBY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-JO3Kag4mNnCWD8I7o_ujrA-1; Tue, 07 Dec 2021 10:34:33 -0500
X-MC-Unique: JO3Kag4mNnCWD8I7o_ujrA-1
Received: by mail-wm1-f71.google.com with SMTP id g11-20020a1c200b000000b003320d092d08so7877811wmg.9
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 07:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=5R4cWI/77swxdmILy6TLQB1mcQwz65GKbFISlyFEK3A=;
        b=jw8rHo6ktj7SiPusGJdYiAG/tnIrPWrmgEtFFlvyqNCB4v5FxmI3cv877FiNswp6vB
         SlQj56j7AdUmvV/bQKlcP1ODmR1RFfNQKUuHEEN/gxoAnNsYGk/QcZdcAVCVbxFaWK1H
         PPni4sD8uDX0VxOj8t+tFc3Yx0/4CQ+oLWS8BHGj/K2kUbWKirQu/XKc0j8ckx/PKm2v
         h0zYOQ6t/bAigUgbhXpcxO0FxpachCjZmdP5wDayuLsfct7WuWbsjuG6ogDPoA8rlqgV
         cD+mZiCOWvNuOVrV2TsaB5groKRGUR5yD9iRZ0+yW6CPRxw0YwM2cjUtOqC+2Nt/M7TZ
         9Zvg==
X-Gm-Message-State: AOAM531Z+7Rjt9LvK7GfZTEzkmG+cWDPewo8gPEjTvL2cy/3NWC+xdl9
        4lkYqLSenufNMAumdC+3IoNS6cKEJwO854sjrcwNuwXiJWbzbPDkhppkBJSBWdIlZYXcWq11MdD
        P1rva/wuKA5iwSDAf
X-Received: by 2002:a7b:ca4c:: with SMTP id m12mr8181087wml.119.1638891271939;
        Tue, 07 Dec 2021 07:34:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwXEaJl0z2dys15JkIB8rW+3kQcC9hiHyw/zWxJiPPVgwvP0S/xlOyINcduVvGYZyw5MfY0w==
X-Received: by 2002:a7b:ca4c:: with SMTP id m12mr8181047wml.119.1638891271719;
        Tue, 07 Dec 2021 07:34:31 -0800 (PST)
Received: from [192.168.3.132] (p4ff23e57.dip0.t-ipconnect.de. [79.242.62.87])
        by smtp.gmail.com with ESMTPSA id f7sm3775406wmg.6.2021.12.07.07.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 07:34:31 -0800 (PST)
Message-ID: <b7deaf90-8c3c-c22a-b8dc-e6d98bc93ae6@redhat.com>
Date:   Tue, 7 Dec 2021 16:34:30 +0100
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
References: <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz> <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
 <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
 <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
 <Ya9gN3rZ1eQou3rc@dhcp22.suse.cz>
 <77e785e6-cf34-0cff-26a5-852d3786a9b8@redhat.com>
 <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.12.21 16:29, Michal Hocko wrote:
> On Tue 07-12-21 16:09:39, David Hildenbrand wrote:
>> On 07.12.21 14:23, Michal Hocko wrote:
>>> On Tue 07-12-21 13:28:31, David Hildenbrand wrote:
>>> [...]
>>>> But maybe I am missing something important regarding online vs. offline
>>>> nodes that your patch changes?
>>>
>>> I am relying on alloc_node_data setting the node online. But if we are
>>> to change the call to arch_alloc_node_data then the patch needs to be
>>> more involved. Here is what I have right now. If this happens to be the
>>> right way then there is some additional work to sync up with the hotplug
>>> code.
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index c5952749ad40..a296e934ad2f 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -8032,8 +8032,23 @@ void __init free_area_init(unsigned long *max_zone_pfn)
>>>  	/* Initialise every node */
>>>  	mminit_verify_pageflags_layout();
>>>  	setup_nr_node_ids();
>>> -	for_each_online_node(nid) {
>>> -		pg_data_t *pgdat = NODE_DATA(nid);
>>> +	for_each_node(nid) {
>>> +		pg_data_t *pgdat;
>>> +
>>> +		if (!node_online(nid)) {
>>> +			pr_warn("Node %d uninitialized by the platform. Please report with memory map.\n", nid);
>>> +			pgdat = arch_alloc_nodedata(nid);
>>> +			pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
>>> +			arch_refresh_nodedata(nid, pgdat);
>>> +			node_set_online(nid);
>>
>> Setting all possible nodes online might result in quite some QE noice,
>> because all these nodes will then be visible in the sysfs and
>> try_offline_nodes() is essentially for the trash.
> 
> I am not sure I follow. I believe sysfs will not get populate because I
> do not call register_one_node.

arch/x86/kernel/topology.c:topology_init()

for_each_online_node(i)
	register_one_node(i);



> 
> You are right that try_offline_nodes will be reduce which is good imho.
> More changes will be possible (hopefully to drop some ugly code) on top
> of this change (or any other that achieves that there are no NULL pgdat
> for possible nodes).
> 

No to exposing actually offline nodes to user space via sysfs.
Let's concentrate on preallocating the pgdat and fixing the issue at
hand. One step at a time please.


>> I agree to prealloc the pgdat, I don't think we should actually set the
>> nodes online. Node onlining/offlining should be done when we do have
>> actual CPUs/memory populated.
> 
> If we keep the offline/online node state notion we are not solving an
> important aspect of the problem - confusing api.

I don't think it's that confusing. Just like we do have online and
offline CPUs. Or online and offline memory blocks. Similarly, a node is
either online or offline.

-- 
Thanks,

David / dhildenb

