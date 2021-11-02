Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044D5442F2A
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 14:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhKBNoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 09:44:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229712AbhKBNoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 09:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635860489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQLlgC2+pa37FKsjZxqtI9j/y4YM779H4bT7Ffbeg8Y=;
        b=b16TKqhWXH1EKwBRGONpA+05DMhvLnj+8IN9I1xgV1RFeTkZWhoCncJHbMUZA970wQKDDr
        MmE/MBs4MlkuGzZe3jdE9rHzYgaHIBak6xkOgKz9n/sHIiS3QU/o3yXWafNKW6EKvoQ1nj
        uN87DnMWv51ryYiiwK+Wdj/FCiuJNPw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-5Fr5l_MQOfC1Xcqzpf8vHw-1; Tue, 02 Nov 2021 09:41:28 -0400
X-MC-Unique: 5Fr5l_MQOfC1Xcqzpf8vHw-1
Received: by mail-wm1-f72.google.com with SMTP id z138-20020a1c7e90000000b003319c5f9164so1154560wmc.7
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 06:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=QQLlgC2+pa37FKsjZxqtI9j/y4YM779H4bT7Ffbeg8Y=;
        b=rqQQ4xPgTYuAYe6RXVUGNNKdsAz4gMtbgMMOZhgA/1n4sNxyLK8JIr+UH3hGMBrQut
         gS/rGM7RYJbjBl8FR/McGVGad+BD3GuoFos2gPV895sB5Uo+S7dUlAbevbOtbw4hlwkN
         PvfGHmz9Sx2d/MXTmiGV90VPMEGXI2D4U9nlhkZT+z/EINewc8FW9L4ryQcsKRjC5/hn
         iQekIdNOeCvrcziGEQhrGYVYtz4JA3b3JQYejXiZ8wPUxwLWOqVTC4tKV6Xn14l05jz8
         ry6Km8DYGm4LPrYpDS0VqqGpVFBNoutKcUkXYkQc5g0Qr2orV1jkX0Xibfb6IZWyCGLU
         evmw==
X-Gm-Message-State: AOAM5332bBfojt2oA7E/giKPWEVmkpNv/J9CNixgmTReqDSulX3L7dkj
        bwoDFbMpk1kF5E9IhkVUGiXNvJWZWoVoaxxbljLnsCXh4pt++GTtBB7BP8/jmhp4nPrF3W61ENS
        bWf2Nz9wLBLEhTnba
X-Received: by 2002:a05:6000:2a4:: with SMTP id l4mr20861700wry.238.1635860487360;
        Tue, 02 Nov 2021 06:41:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzljnTgliElH/Zh8xTvWK6IlBoYotDE7+Q/yAvlPzs5SnQ+krLEegJ6Pm58VdcUkdgkuD90Yw==
X-Received: by 2002:a05:6000:2a4:: with SMTP id l4mr20861664wry.238.1635860487135;
        Tue, 02 Nov 2021 06:41:27 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6810.dip0.t-ipconnect.de. [91.12.104.16])
        by smtp.gmail.com with ESMTPSA id u15sm2896627wmq.12.2021.11.02.06.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 06:41:26 -0700 (PDT)
Message-ID: <ccf05348-e1b6-58a7-2626-701e60b662e6@redhat.com>
Date:   Tue, 2 Nov 2021 14:41:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
References: <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
 <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
 <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
 <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
 <YYEun6s/mF9bE+rQ@dhcp22.suse.cz>
 <e7aed7c0-b7b1-4a94-f323-0bcde2f879d2@redhat.com>
 <YYE8L4gs8/+HH6bf@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
In-Reply-To: <YYE8L4gs8/+HH6bf@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.11.21 14:25, Michal Hocko wrote:
> On Tue 02-11-21 13:39:06, David Hildenbrand wrote:
>>>> Yes, but a zonelist cannot be correct for an offline node, where we might
>>>> not even have an allocated pgdat yet. No pgdat, no zonelist. So as soon as
>>>> we allocate the pgdat and set the node online (->hotadd_new_pgdat()), the zone lists have to be correct. And I can spot an build_all_zonelists() in hotadd_new_pgdat().
>>>
>>> Yes, that is what I had in mind. We are talking about two things here.
>>> Memoryless nodes and offline nodes. The later sounds like a bug to me.
>>
>> Agreed. memoryless nodes should just have proper zonelists -- which
>> seems to be the case.
>>
>>>> Maybe __alloc_pages_bulk() and alloc_pages_node() should bail out directly
>>>> (VM_BUG()) in case we're providing an offline node with eventually no/stale pgdat as
>>>> preferred nid.
>>>
>>> Historically, those allocation interfaces were not trying to be robust
>>> against wrong inputs because that adds cpu cycles for everybody for
>>> "what if buggy" code. This has worked (surprisingly) well. Memory less
>>> nodes have brought in some confusion but this is still something that we
>>> can address on a higher level. Nobody give arbitrary nodes as an input.
>>> cpu_to_node might be tricky because it can point to a memory less node
>>> which along with __GFP_THISNODE is very likely not something anybody
>>> wants. Hence cpu_to_mem should be used for allocations. I hate we have
>>> two very similar APIs...
>>
>> To be precise, I'm wondering if we should do:
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index 55b2ec1f965a..8c49b88336ee 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -565,7 +565,7 @@ static inline struct page *
>>  __alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
>>  {
>>         VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
>> -       VM_WARN_ON((gfp_mask & __GFP_THISNODE) && !node_online(nid));
>> +       VM_WARN_ON(!node_online(nid));
>>
>>         return __alloc_pages(gfp_mask, order, nid, NULL);
>>  }
>>
>> (Or maybe VM_BUG_ON)
>>
>> Because it cannot possibly work and we'll dereference NULL later.
> 
> VM_BUG_ON would be silent for most configurations and crash would happen
> even without it so I am not sure about the additional value. VM_WARN_ON
> doesn't really add much on top - except it would crash in some
> configurations. If we really care to catch this case then we would have
> to do a reasonable fallback with a printk note and a dumps stack.

As I learned, VM_BUG_ON and friends are active for e.g., Fedora, which
can catch quite some issues early, before they end up in enterprise
distro kernels. I think it has value.

> Something like
> 	if (unlikely(!node_online(nid))) {
> 		pr_err("%d is an offline numa node and using it is a bug in a caller. Please report...\n");
> 		dump_stack();
> 		nid = numa_mem_id();
> 	}
> 
> But again this is adding quite some cycles to a hotpath of the page
> allocator. Is this worth it?

Don't think a fallback makes sense.

> 
>>> But something seems wrong in this case. cpu_to_node shouldn't return
>>> offline nodes. That is just a land mine. It is not clear to me how the
>>> cpu has been brought up so that the numa node allocation was left
>>> behind. As pointed in other email add_cpu resp. cpu_up is not it.
>>> Is it possible that the cpu bring up was only half way?
>>
>> I tried to follow the code (what sets a CPU present, what sets a CPU
>> online, when do we update cpu_to_node() mapping) and IMHO it's all a big
>> mess. Maybe it's clearer to people familiar with that code, but CPU
>> hotplug in general seems to be a confusing piece of (arch-specific) code.
> 
> Yes there are different arch specific parts that make this quite hard to
> follow.
> 
> I think we want to learn how exactly Alexey brought that cpu up. Because
> his initial thought on add_cpu resp cpu_up doesn't seem to be correct.
> Or I am just not following the code properly. Once we know all those
> details we can get in touch with cpu hotplug maintainers and see what
> can we do.

Yes.

> 
> Btw. do you plan to send a patch for pcp allocator to use cpu_to_mem?

You mean s/cpu_to_node/cpu_to_mem/ or also handling offline nids?

cpu_to_mem() corresponds to cpu_to_node() unless on ia64+ppc IIUC, so it
won't help for this very report.

> One last thing, there were some mentions of __GFP_THISNODE but I fail to
> see connection with the pcp allocator...

Me to. If pcpu would be using __GFP_THISNODE, we'd be hitting the
VM_WARN_ON but still crash.

-- 
Thanks,

David / dhildenb

