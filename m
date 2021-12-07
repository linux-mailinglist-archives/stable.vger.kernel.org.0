Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1A246C0DF
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 17:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238088AbhLGQoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 11:44:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229481AbhLGQoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 11:44:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638895243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4KoT7MoJZdMHzhKqbC4j9Azc/TQJ3pztEdVibRZgna0=;
        b=BL/2MXLTJvXg9hAP8zvBBy0K7c2zRWOABj+vjy16ALMRM0WyU4pv1A6FRiUSeMO84tNSfd
        RyqoM6v1WK4tFhbDMjthX6cMXljzEdCivQR4Wc0WG9QWYVxyOkmYMpCsWmU+0AB0CDJapj
        NwEJ4/QZ5PkbyRFouVwq6QE2onCTsZ0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-0Ehx1bK8ORyRWVdWjHlCwA-1; Tue, 07 Dec 2021 11:40:40 -0500
X-MC-Unique: 0Ehx1bK8ORyRWVdWjHlCwA-1
Received: by mail-wr1-f70.google.com with SMTP id h13-20020adfa4cd000000b001883fd029e8so3177121wrb.11
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 08:40:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=4KoT7MoJZdMHzhKqbC4j9Azc/TQJ3pztEdVibRZgna0=;
        b=VYOTxPcBP3X12ce+a3qGTd1pf//lYrKqRXsLP1WRGcKnSM9pvIG1sDUkYJ1nN+VcL4
         UQZvKHqtis4qnH+fQy0BnpHmKWULZaLuBZRVTpi/yqwhuPk3IYnwCfzYdINZtDxALEws
         9zbKlPhJ+5G8lFgxE9fxQTXffK97w8ehFl2U2tA+YUlqnQJxsNJPuXtcxTrQ5BvLJwLy
         x6pPaMqAYs27UD25Bnjk+0ndsjOgZUD1Q+Yb2nKlefONf9iBFpXFczyt7KRb25eEMjyw
         zKfTFum/LrKE3UCgaxZlp0zuZQdTzctUHYAzi765ABUdFlEbWsske9WflilwN6rpeTms
         K3sQ==
X-Gm-Message-State: AOAM530a+bX0hOhfBlTBqUHV9prgYOZ8CdECNjY4RmO4Ybo+cToXtnpL
        ve3phOfuZr825KBl2GTjg0ez3aen/aEzyDhQ0dsvKaUezdj+t39iuhHP6Q7KZ8CzIOJT9yqUGlG
        +iazfEYtB1SCkPlK8
X-Received: by 2002:a05:600c:4f48:: with SMTP id m8mr8470697wmq.50.1638895237683;
        Tue, 07 Dec 2021 08:40:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyLRGhMk0hwoWx4NOrHSo4XAoQnohJI6lQltoXOlkpwvXm6WNomi9AzfV9scYz1A7y1asfVmg==
X-Received: by 2002:a05:600c:4f48:: with SMTP id m8mr8470651wmq.50.1638895237427;
        Tue, 07 Dec 2021 08:40:37 -0800 (PST)
Received: from [192.168.3.132] (p4ff23e57.dip0.t-ipconnect.de. [79.242.62.87])
        by smtp.gmail.com with ESMTPSA id k13sm211285wri.6.2021.12.07.08.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 08:40:37 -0800 (PST)
Message-ID: <235e8656-a947-b446-c39c-fa0f72b65ac7@redhat.com>
Date:   Tue, 7 Dec 2021 17:40:36 +0100
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Ya+Nq2fWrSgl79Bn@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.12.21 17:36, Michal Hocko wrote:
> On Tue 07-12-21 17:27:29, Michal Hocko wrote:
> [...]
>> So your proposal is to drop set_node_online from the patch and add it as
>> a separate one which handles 
>> 	- sysfs part (i.e. do not register a node which doesn't span a
>> 	  physical address space)
>> 	- hotplug side of (drop the pgd allocation, register node lazily
>> 	  when a first memblocks are registered)
> 

> In other words, the first stage
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c5952749ad40..f9024ba09c53 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6382,7 +6382,11 @@ static void __build_all_zonelists(void *data)
>  	if (self && !node_online(self->node_id)) {
>  		build_zonelists(self);
>  	} else {
> -		for_each_online_node(nid) {
> +		/*
> +		 * All possible nodes have pgdat preallocated
> +		 * free_area_init
> +		 */
> +		for_each_node(nid) {
>  			pg_data_t *pgdat = NODE_DATA(nid);
>  
>  			build_zonelists(pgdat);
> @@ -8032,8 +8036,24 @@ void __init free_area_init(unsigned long *max_zone_pfn)
>  	/* Initialise every node */
>  	mminit_verify_pageflags_layout();
>  	setup_nr_node_ids();
> -	for_each_online_node(nid) {
> -		pg_data_t *pgdat = NODE_DATA(nid);
> +	for_each_node(nid) {
> +		pg_data_t *pgdat;
> +
> +		if (!node_online(nid)) {
> +			pr_warn("Node %d uninitialized by the platform. Please report with boot dmesg.\n", nid);
> +			pgdat = arch_alloc_nodedata(nid);

Is the buddy fully up an running at that point? I don't think so, so we
might have to allocate via memblock instead. But I might be wrong.

> +			pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
> +			arch_refresh_nodedata(nid, pgdat);
> +			free_area_init_memoryless_node(nid);
> +			/*
> +			 * not marking this node online because we do not want to
> +			 * confuse userspace by sysfs files/directories for node
> +			 * without any memory attached to it (see topology_init)
> +			 */
> +			continue;
> +		}
> +
> +		pgdat = NODE_DATA(nid);
>  		free_area_init_node(nid);
>  
>  		/* Any memory on that node */
> 

Yes, and maybe in the same go, remove/rework hotadd_new_pgdat(), because
there is nothing  to hotadd anymore. (we should double-check the
initialization performed in there, it might all not be necessary anymore)

-- 
Thanks,

David / dhildenb

