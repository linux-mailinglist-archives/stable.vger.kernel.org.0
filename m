Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01FD40F719
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 14:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243174AbhIQMHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 08:07:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241146AbhIQMHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 08:07:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631880383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L97TUz1xWc6TzQ+IcmlxbSLmNNa0zoKrjEpKyTwM0eA=;
        b=bMU5t8m5EWxbjNNHb2BPmWtKJz4x58tAwLfDyGXVTJ5K0X4LxlpIl0Om9oGCG8epXfnpUB
        Zb4DJ+tfiQUQfHn20TVpshGfWONlYLGY2IN88aQDbPOv40UBU2t7F0QRwa+VolQH2pejtS
        M0X0kcR7Ik2qJ6tAYsAeU3bLh60Ssog=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-lLBSMwjwPFq9ikZcwRkSHw-1; Fri, 17 Sep 2021 08:06:21 -0400
X-MC-Unique: lLBSMwjwPFq9ikZcwRkSHw-1
Received: by mail-wr1-f69.google.com with SMTP id h5-20020a5d6885000000b0015e21e37523so3651193wru.10
        for <stable@vger.kernel.org>; Fri, 17 Sep 2021 05:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=L97TUz1xWc6TzQ+IcmlxbSLmNNa0zoKrjEpKyTwM0eA=;
        b=IX4BFinvUFU1RAZsKlCms1ZQYS84qvduXJ8k3jWjS+mdKvHYu0sONtoJmVJpfL51C3
         91MLQUT1NeUNiw8i8JC7tCDRx+r+0ZojU90+LxOek57bqpqGY+Mop5gErYk8WYU/srnG
         s99O0aEPlZN2QByF+SZw+A9XtRO+Wp73FDt6pz4dETbg/Drw1SsnaBZOvX6vwnBvpsoo
         7C+d0RZXv3mMOcH/npeNFb01vCcu4ZukQfLKk0CBbmgOGEwgjwIoVYZcqj2Rz1qZnq1N
         3F8o3J77ScHfqvyMZ6Dq1/vQ2w0kC7Ti+StZcO9ojY9MUYNGXAWTYnpjMIVth+7U9HpE
         qwzA==
X-Gm-Message-State: AOAM533pLjXLIYa5BBU6D3hMgph4BgPDK+1P3TrcTyqXhWeGQNS+LYDL
        3STDGFZu7B4wBlDhqgzd4XZVoi9NNYcpyzjxyRIuSI94hTbE5qtseBTD8bisavRMGBDCGghkdjh
        3eRUsuGZURJswyvpj
X-Received: by 2002:a05:600c:2259:: with SMTP id a25mr10001159wmm.133.1631880380615;
        Fri, 17 Sep 2021 05:06:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIwHvpD2xCIqN7faUULU4FtSKHM7KBAyrEpYYE8O1JQP3xzInvOPkd3xBF2s+MSXmJ9nZoKw==
X-Received: by 2002:a05:600c:2259:: with SMTP id a25mr10001116wmm.133.1631880380402;
        Fri, 17 Sep 2021 05:06:20 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c655a.dip0.t-ipconnect.de. [91.12.101.90])
        by smtp.gmail.com with ESMTPSA id w1sm10461987wmc.19.2021.09.17.05.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 05:06:19 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] mm/memory_hotplug: use "unsigned long" for
 PFN in" failed to apply to 4.14-stable tree
To:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        anton@ozlabs.org, ardb@kernel.org, bauerman@linux.ibm.com,
        benh@kernel.crashing.org, bhe@redhat.com, borntraeger@de.ibm.com,
        bp@alien8.de, catalin.marinas@arm.com, cheloha@linux.ibm.com,
        christophe.leroy@c-s.fr, dalias@libc.org, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hpa@zytor.com,
        jasowang@redhat.com, joe@perches.com, justin.he@arm.com,
        ldufour@linux.ibm.com, lenb@kernel.org, luto@kernel.org,
        mhocko@kernel.org, michel@lespinasse.org, mingo@redhat.com,
        mpe@ellerman.id.au, mst@redhat.com, nathanl@linux.ibm.com,
        npiggin@gmail.com, osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pankaj.gupta@ionos.com, pasha.tatashin@soleen.com,
        paulus@samba.org, peterz@infradead.org, pmorel@linux.ibm.com,
        rafael.j.wysocki@intel.com, richard.weiyang@linux.alibaba.com,
        rjw@rjwysocki.net, rppt@kernel.org, slyfox@gentoo.org,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vishal.l.verma@intel.com, vkuznets@redhat.com,
        wangkefeng.wang@huawei.com, will@kernel.org,
        ysato@users.sourceforge.jp
References: <1631796969176240@kroah.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <5873f775-a9a8-7d8e-f8a6-a314ad14a6ef@redhat.com>
Date:   Fri, 17 Sep 2021 14:06:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1631796969176240@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.09.21 14:56, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 7cf209ba8a86410939a24cb1aeb279479a7e0ca6 Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Tue, 7 Sep 2021 19:54:59 -0700
> Subject: [PATCH] mm/memory_hotplug: use "unsigned long" for PFN in
>   zone_for_pfn_range()
> 
> Patch series "mm/memory_hotplug: preparatory patches for new online policy and memory"
> 
> These are all cleanups and one fix previously sent as part of [1]:
> [PATCH v1 00/12] mm/memory_hotplug: "auto-movable" online policy and memory
> groups.
> 
> These patches make sense even without the other series, therefore I pulled
> them out to make the other series easier to digest.
> 
> [1] https://lkml.kernel.org/r/20210607195430.48228-1-david@redhat.com
> 
> This patch (of 4):
> 
> Checkpatch complained on a follow-up patch that we are using "unsigned"
> here, which defaults to "unsigned int" and checkpatch is correct.
> 
> As we will search for a fitting zone using the wrong pfn, we might end
> up onlining memory to one of the special kernel zones, such as ZONE_DMA,
> which can end badly as the onlined memory does not satisfy properties of
> these zones.
> 
> Use "unsigned long" instead, just as we do in other places when handling
> PFNs.  This can bite us once we have physical addresses in the range of
> multiple TB.
> 
> Link: https://lkml.kernel.org/r/20210712124052.26491-2-david@redhat.com
> Fixes: e5e689302633 ("mm, memory_hotplug: display allowed zones in the preferred ordering")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> Cc: Anton Blanchard <anton@ozlabs.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jia He <justin.he@arm.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: Michel Lespinasse <michel@lespinasse.org>
> Cc: Nathan Lynch <nathanl@linux.ibm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Pierre Morel <pmorel@linux.ibm.com>
> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Scott Cheloha <cheloha@linux.ibm.com>
> Cc: Sergei Trofimovich <slyfox@gentoo.org>
> Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index a7fd2c3ccb77..d01b504ce06f 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -339,8 +339,8 @@ extern void sparse_remove_section(struct mem_section *ms,
>   		unsigned long map_offset, struct vmem_altmap *altmap);
>   extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
>   					  unsigned long pnum);
> -extern struct zone *zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
> -		unsigned long nr_pages);
> +extern struct zone *zone_for_pfn_range(int online_type, int nid,
> +		unsigned long start_pfn, unsigned long nr_pages);
>   extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
>   				      struct mhp_params *params);
>   void arch_remove_linear_mapping(u64 start, u64 size);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index f829805fe1ca..fa349acb8810 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -708,8 +708,8 @@ static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn
>   	return movable_node_enabled ? movable_zone : kernel_zone;
>   }
>   
> -struct zone *zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
> -		unsigned long nr_pages)
> +struct zone *zone_for_pfn_range(int online_type, int nid,
> +		unsigned long start_pfn, unsigned long nr_pages)
>   {
>   	if (online_type == MMOP_ONLINE_KERNEL)
>   		return default_kernel_zone_for_pfn(nid, start_pfn, nr_pages);
> 

AFAIKS, there are only contextual differences and they are pretty easy 
to sort out. @Greg, I can send a backport if it helps.

-- 
Thanks,

David / dhildenb

