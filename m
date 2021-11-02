Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB415442923
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 09:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhKBIOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 04:14:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231126AbhKBIOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 04:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635840727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=np1qThQAeJX33GQTcesiUPc23jDJuGnAxWws7e0zgcE=;
        b=afGLKxDVNTG60LowLeggZzqZ3MHvCTLIt9YmaFwCrMGs0DBBrWYv3zD8WOzUFsTwD5FGVy
        KYqgWvzTdmzH6eUbPhFttRSF7P1OifWnhxKJNLwiikNvTKF2u0tJF2Oxqy/DsJa0R1k8kv
        ibpLPW0OvfaiiIAUCvHONZl0neT4rqo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-dGE5nuNlN_SD_l2qFWsTDA-1; Tue, 02 Nov 2021 04:12:05 -0400
X-MC-Unique: dGE5nuNlN_SD_l2qFWsTDA-1
Received: by mail-wr1-f71.google.com with SMTP id a2-20020a5d4d42000000b0017b3bcf41b9so4486408wru.23
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 01:12:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=np1qThQAeJX33GQTcesiUPc23jDJuGnAxWws7e0zgcE=;
        b=zqd8cvm+30M8W1eRYHc2mknjXw0BQ/6uFAxfUKlkMXi8rB/QXVfhBJKTxlKwLPLcCG
         6vrvEY0cFMtyzOekgFY2vCl3CMpUmUXTnaBYIsL/iP39kAuNdOpwVA6/nQ6Lngaah3Pp
         oDyuzHuJuHM6dIIr2la3F4jk/TXoaPm9Zwyo3dUIa/q+mV1e31pHXJIVfsJaRBPXPGRq
         yzQ3PRDGeJGXy1wM8ZaPVXenxiZAU4/E4KSddME5+Cdzb9jcqfCG5WTBx3nLsJccu4ms
         3ogRtgYHjyE4oBG/iJTb96w8aGUBxrAcpCpksPy85pBW+/8L4M8Dp4mshQNSiLWg8Vte
         Oa8w==
X-Gm-Message-State: AOAM530Eoqjbx+CxkrAyN20AiuetqogyxLoirleYYEJhFhhJLknz3a2t
        XjXUNpf/K6B/MmQYhryf22Km1bfmq0BouY3vsH5xkzIVz7pvBLntc41sdZW2/NoJCEL1feOf2z6
        xUr7V8Cn23wwTp8tB
X-Received: by 2002:a05:600c:202:: with SMTP id 2mr4991431wmi.167.1635840724637;
        Tue, 02 Nov 2021 01:12:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVsG7mgH2x69dUZcIdMg+BCcAEU4bmITDKbMyxAlIVSIddBG70EtJqHxXUxhsMataQ3vdK9A==
X-Received: by 2002:a05:600c:202:: with SMTP id 2mr4991403wmi.167.1635840724380;
        Tue, 02 Nov 2021 01:12:04 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6810.dip0.t-ipconnect.de. [91.12.104.16])
        by smtp.gmail.com with ESMTPSA id f6sm1663245wmj.40.2021.11.02.01.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 01:12:03 -0700 (PDT)
Message-ID: <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
Date:   Tue, 2 Nov 2021 09:12:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>,
        Alexey Makhalov <amakhalov@vmware.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oscar Salvador <OSalvador@suse.com>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
In-Reply-To: <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.11.21 08:47, Michal Hocko wrote:
> [CC Oscar and David]
> 
> On Mon 01-11-21 13:13:12, Alexey Makhalov wrote:
>> There is a kernel panic caused by __alloc_pages() accessing
>> uninitialized NODE_DATA(nid). Uninitialized node data exists
>> during the time when CPU with memoryless node was added but
>> not onlined yet. Panic can be easy reproduced by disabling
>> udev rule for automatic onlining hot added CPU followed by
>> CPU with memoryless node hot add.
>>
>> This is a panic caused by percpu code doing allocations for
>> all possible CPUs and hitting this issue:
>>
>>  CPU2 has been hot-added
>>  BUG: unable to handle page fault for address: 0000000000001608
>>  #PF: supervisor read access in kernel mode
>>  #PF: error_code(0x0000) - not-present page
>>  PGD 0 P4D 0
>>  Oops: 0000 [#1] SMP PTI
>>  CPU: 0 PID: 1 Comm: systemd Tainted: G            E     5.15.0-rc7+ #11
>>  Hardware name: VMware, Inc. VMware7,1/440BX Desktop Reference Platform, BIOS VMW
>>
>>  RIP: 0010:__alloc_pages+0x127/0x290
> 
> Could you resolve this into a specific line of the source code please?
> 
>>  Code: 4c 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 e0 48 8b 55 b8 c1 e8 0c 83 e0 01 88 45 d0 4c 89 c8 48 85 d2 0f 85 1a 01 00 00 <45> 3b 41 08 0f 82 10 01 00 00 48 89 45 c0 48 8b 00 44 89 e2 81 e2
>>  RSP: 0018:ffffc900006f3bc8 EFLAGS: 00010246
>>  RAX: 0000000000001600 RBX: 0000000000000000 RCX: 0000000000000000
>>  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc2
>>  RBP: ffffc900006f3c18 R08: 0000000000000001 R09: 0000000000001600
>>  R10: ffffc900006f3a40 R11: ffff88813c9fffe8 R12: 0000000000000cc2
>>  R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000cc2
>>  FS:  00007f27ead70500(0000) GS:ffff88807ce00000(0000) knlGS:0000000000000000
>>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>  CR2: 0000000000001608 CR3: 000000000582c003 CR4: 00000000001706b0
>>  Call Trace:
>>   pcpu_alloc_pages.constprop.0+0xe4/0x1c0
>>   pcpu_populate_chunk+0x33/0xb0
>>   pcpu_alloc+0x4d3/0x6f0
>>   __alloc_percpu_gfp+0xd/0x10
>>   alloc_mem_cgroup_per_node_info+0x54/0xb0
>>   mem_cgroup_alloc+0xed/0x2f0
>>   mem_cgroup_css_alloc+0x33/0x2f0
>>   css_create+0x3a/0x1f0
>>   cgroup_apply_control_enable+0x12b/0x150
>>   cgroup_mkdir+0xdd/0x110
>>   kernfs_iop_mkdir+0x4f/0x80
>>   vfs_mkdir+0x178/0x230
>>   do_mkdirat+0xfd/0x120
>>   __x64_sys_mkdir+0x47/0x70
>>   ? syscall_exit_to_user_mode+0x21/0x50
>>   do_syscall_64+0x43/0x90
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Node can be in one of the following states:
>> 1. not present (nid == NUMA_NO_NODE)
>> 2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) == 0,
>> 				NODE_DATA(nid) == NULL)
>> 3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
>> 				NODE_DATA(nid) != NULL)
>>
>> alloc_page_{bulk_array}node() functions verify for nid validity only
>> and do not check if nid is online. Enhanced verification check allows
>> to handle page allocation when node is in 2nd state.
> 
> I do not think this is a correct approach. We should make sure that the
> proper fallback node is used instead. This means that the zone list is
> initialized properly. IIRC this has been a problem in the past and it
> has been fixed. The initialization code is quite subtle though so it is
> possible that this got broken again.

I'm a little confused:

In add_memory_resource() we hotplug the new node if required and set it
online. Memory might get onlined later, via online_pages().

So after add_memory_resource()->__try_online_node() succeeded, we have
an online pgdat -- essentially 3.

This patch detects if we're past 3. but says that it reproduced by
disabling *memory* onlining.

Before we online memory for a hotplugged node, all zones are !populated.
So once we online memory for a !populated zone in online_pages(), we
trigger setup_zone_pageset().


The confusing part is that this patch checks for 3. but says it can be
reproduced by not onlining *memory*. There seems to be something missing.

Do we maybe need a proper populated_zone() check before accessing zone data?

-- 
Thanks,

David / dhildenb

