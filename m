Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53357442D7E
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 13:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhKBMIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 08:08:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhKBMIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 08:08:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635854771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Db4CzAP+L3jtj1KLq/9Mushjs5f9BjiScDLfHzCS5nU=;
        b=P1ACbCILkjZil25ZNScu+pLnDGWVMkIjZtmjhLK652safurufGR4PuwYX16sWkQEhxZk3u
        BBPuLF05buf/IghbsXbBL45EO6X+iBpM+1YOegukHa9lPak6rPdnMWxRSWW3/tJrssuD5a
        2HP6S5I2XqNTjbSwp6XwovYz6B/F7Ek=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-cGBN1EXXM-WWbKmmkIRrcw-1; Tue, 02 Nov 2021 08:06:10 -0400
X-MC-Unique: cGBN1EXXM-WWbKmmkIRrcw-1
Received: by mail-wm1-f71.google.com with SMTP id 145-20020a1c0197000000b0032efc3eb9bcso1054718wmb.0
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 05:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=Db4CzAP+L3jtj1KLq/9Mushjs5f9BjiScDLfHzCS5nU=;
        b=4QaO17D/ibFCHxpuBUN+2XZctkQ2i8TNUcSu3I8KKbn8U8o5nUtG44vbyB+4i34dmG
         bcmdarQ8s1ov4mZHwPeCzCajkGjjF6uiDyj7q6Sx+WDL7q5Y0nIzmXdgQQ86vj3iraqW
         WdSI5Hx+zqTM7cYKPEh8gZgiNwWtVG1U4xp1sUSo2W4BYPNgxft6ELS5yL1OfIpXe796
         we2ikHXTMrK8X+3BeJ3nXmTpMY9Fc11WzEUR8WHLUx3pXNsFR70tRTbHnC+JmQPf1kEu
         YtZnm+LWgk6BfndF/IWeGkmnfthBmWKuEyuZAcFfD2quuoAg3Q+bGRlwF37qflQhBw09
         ohKA==
X-Gm-Message-State: AOAM5313i9DmjazPV+DzkSFkzL/wiNXx18UDS8zRzwrn+o54MsQes+m7
        XfaQzQzhOHLOQrC+mFMfFZo4WyLbnERSCfJvop6BD0NXn9nXLxehMFHWJiY5J6K5JIINIuJQI44
        0u7pJi+92iTATiqun
X-Received: by 2002:a1c:2904:: with SMTP id p4mr6585050wmp.49.1635854768837;
        Tue, 02 Nov 2021 05:06:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5hLAbJGUIkd4RxXJdsL7Kb8mcCW4AsapmE12n3CdKQp54BoRsQmVs+BhrOG9Oye9TiSqHwQ==
X-Received: by 2002:a1c:2904:: with SMTP id p4mr6584984wmp.49.1635854768338;
        Tue, 02 Nov 2021 05:06:08 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6810.dip0.t-ipconnect.de. [91.12.104.16])
        by smtp.gmail.com with ESMTPSA id g10sm2746870wmq.13.2021.11.02.05.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 05:06:07 -0700 (PDT)
Message-ID: <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
Date:   Tue, 2 Nov 2021 13:06:06 +0100
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
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
 <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
 <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
In-Reply-To: <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.11.21 12:44, Michal Hocko wrote:
> On Tue 02-11-21 12:00:57, David Hildenbrand wrote:
>> On 02.11.21 11:34, Alexey Makhalov wrote:
> [...]
>>>> The node onlining logic when onlining a CPU sounds bogus as well: Let's
>>>> take a look at try_offline_node(). It checks that:
>>>> 1) That no memory is *present*
>>>> 2) That no CPU is *present*
>>>>
>>>> We should online the node when adding the CPU ("present"), not when
>>>> onlining the CPU.
>>>
>>> Possible.
>>> Assuming try_online_node was moved under add_cpu(), let’s
>>> take look on this call stack:
>>> add_cpu()
>>>   try_online_node()
>>>     __try_online_node()
>>>       hotadd_new_pgdat()
>>> At line 1190 we'll have a problem:
>>> 1183         pgdat = NODE_DATA(nid);
>>> 1184         if (!pgdat) {
>>> 1185                 pgdat = arch_alloc_nodedata(nid);
>>> 1186                 if (!pgdat)
>>> 1187                         return NULL;
>>> 1188
>>> 1189                 pgdat->per_cpu_nodestats =
>>> 1190                         alloc_percpu(struct per_cpu_nodestat);
>>> 1191                 arch_refresh_nodedata(nid, pgdat);
>>>
>>> alloc_percpu() will go for all possible CPUs and will eventually end up
>>> calling alloc_pages_node() trying to use subject nid for corresponding CPU
>>> hitting the same state #2 problem as NODE_DATA(nid) is still NULL and nid
>>> is not yet online.
>>
>> Right, we will end up calling pcpu_alloc_pages()->alloc_pages_node() for
>> each possible CPU. We use cpu_to_node() to come up with the NID.
> 
> Shouldn't this be numa_mem_id instead? Memory less nodes are odd little

Hm, good question. Most probably yes for offline nodes.

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 2054c9213c43..c21ff5bb91dc 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -84,15 +84,19 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
                            gfp_t gfp)
 {
        unsigned int cpu, tcpu;
-       int i;
+       int i, nid;
 
        gfp |= __GFP_HIGHMEM;
 
        for_each_possible_cpu(cpu) {
+               nid = cpu_to_node(cpu);
+
+               if (nid == NUMA_NO_NODE || !node_online(nid))
+                       nid = numa_mem_id();
                for (i = page_start; i < page_end; i++) {
                        struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
 
-                       *pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
+                       *pagep = alloc_pages_node(nid, gfp, 0);
                        if (!*pagep)
                                goto err;
                }


> critters crafted into the MM code without wider considerations. From
> time to time we are struggling with some fallouts but the primary thing
> is that zonelists should be valid for all memory less nodes.

Yes, but a zonelist cannot be correct for an offline node, where we might
not even have an allocated pgdat yet. No pgdat, no zonelist. So as soon as
we allocate the pgdat and set the node online (->hotadd_new_pgdat()), the zone lists have to be correct. And I can spot an build_all_zonelists() in hotadd_new_pgdat().

I agree that someone passing an offline NID into an allocator function
should be fixed.

Maybe __alloc_pages_bulk() and alloc_pages_node() should bail out directly
(VM_BUG()) in case we're providing an offline node with eventually no/stale pgdat as
preferred nid.

-- 
Thanks,

David / dhildenb

