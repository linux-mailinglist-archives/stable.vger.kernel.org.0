Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C388F46B9CF
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 12:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhLGLMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 06:12:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230354AbhLGLMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 06:12:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638875341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E4KlXKiWfB3WzLMuIAg4R7RSI2mbgseCbxor89QUgRs=;
        b=VgTor/Z+bDxyazAwE3NiHw5gp8GdUnG6u2qjanmWQDUyGGOPApIAwm9MECUqQ7Q0VOapTk
        YPMFWMLS3dnU1zZTxmI9HxIs0fNapJWyazIkC+0cSw+blYyh0HHZA5CgTEAuP0qleCh3+8
        0AbTU4Jn/HM+6QCXwVzGppi44oExNgw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-48qf3xTDOaWTmH_2dzO_Wg-1; Tue, 07 Dec 2021 06:09:00 -0500
X-MC-Unique: 48qf3xTDOaWTmH_2dzO_Wg-1
Received: by mail-wr1-f70.google.com with SMTP id q7-20020adff507000000b0017d160d35a8so2830823wro.4
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 03:09:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=E4KlXKiWfB3WzLMuIAg4R7RSI2mbgseCbxor89QUgRs=;
        b=JMOWekLxLLR3Zi+QbNopgVRLZnDrUicLz4EZpwAN7kE0/x9VBHPxqOC6oEg7EywRIi
         2FZAP+faCwKGZSX3ancCteWPna1W6Ht4E1pmMtYmVzaTMjGTmU7upJAQsWOFJXaWWfMw
         VY3inH1PPW8v23cSrMrIY59RHWRNz7URH4ydcWQ65P3whxxZjN9gnDMBhNOQM1xki6E/
         DQoykqxZPzHySxcUge8WPWYe8rKoWAoxpSdlYiKUw4m6t6lNYGUq6tMk7tK5/HXrZkoH
         RC8NxsNf4xDCHtMkvA2aZPrT9qhmh3s3smBhhKPkoebjxjcBvX1mrqehB3qr/oAAElQW
         QrOQ==
X-Gm-Message-State: AOAM532wibtQXangnYVkGNTGRnzReRyR0jjbHPsrudioeQ+ybPu2MT4M
        bDCXaUf5yp4evRgiWJfbICxetn1753Zaff9uCEOP3gI7yoQHq0IdgQa51CrhC4F0mh5mF+30bmX
        Oo4SqRXwyfdlFcFpA
X-Received: by 2002:adf:d1c1:: with SMTP id b1mr28284327wrd.204.1638875339383;
        Tue, 07 Dec 2021 03:08:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMhjIntNhbb6GmcmKPSnU3wgbIsO7E5txyyS/wn67qZyQO5XKttBSa05o8e2CXkMK4y5R0MA==
X-Received: by 2002:adf:d1c1:: with SMTP id b1mr28284299wrd.204.1638875339141;
        Tue, 07 Dec 2021 03:08:59 -0800 (PST)
Received: from [192.168.3.132] (p4ff23e57.dip0.t-ipconnect.de. [79.242.62.87])
        by smtp.gmail.com with ESMTPSA id m9sm2529881wmq.1.2021.12.07.03.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 03:08:58 -0800 (PST)
Message-ID: <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
Date:   Tue, 7 Dec 2021 12:08:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>,
        Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
 <20211108202325.20304-1-amakhalov@vmware.com>
 <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz> <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz> <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
In-Reply-To: <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.12.21 11:54, Michal Hocko wrote:
> Hi,
> I didn't have much time to dive into this deeper and I have hit some
> problems handling this in an arch specific code so I have tried to play
> with this instead:
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c5952749ad40..4d71759d0d9b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -8032,8 +8032,16 @@ void __init free_area_init(unsigned long *max_zone_pfn)
>  	/* Initialise every node */
>  	mminit_verify_pageflags_layout();
>  	setup_nr_node_ids();
> -	for_each_online_node(nid) {
> +	for_each_node(nid) {
>  		pg_data_t *pgdat = NODE_DATA(nid);
> +
> +		if (!node_online(nid)) {
> +			pr_warn("Node %d uninitialized by the platform. Please report with memory map.\n");
> +			alloc_node_data(nid);

That's x86 specific and not exposed to generic code -- at least in my
code base. I think we'd want an arch_alloc_nodedata() variant that
allocates via memblock -- and initializes all fields to 0. So
essentially a generic alloc_node_data().

> +			free_area_init_memoryless_node(nid);

That's really just free_area_init_node() below, I do wonder what value
free_area_init_memoryless_node() has as of today.

> +			continue;
> +		}
> +
>  		free_area_init_node(nid);
>  
>  		/* Any memory on that node */
> 
> Could you give it a try? I do not have any machine which would exhibit
> the problem so I cannot really test this out. I hope build_zone_info
> will not choke on this. I assume the node distance table is
> uninitialized for these nodes and IIUC this should lead to an assumption
> that all other nodes are close. But who knows that can blow up there.
> 
> Btw. does this make any sense at all to others?
> 

__build_all_zonelists() has to update the zonelists of all nodes I think.

-- 
Thanks,

David / dhildenb

