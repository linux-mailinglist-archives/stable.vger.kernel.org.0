Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD5059F3D3
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 08:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiHXG6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 02:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiHXG6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 02:58:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463CD86067
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 23:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661324325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAs0+Z6jR5N0Y1sR4+js+noTp9MgRP8ELyWstgdYreE=;
        b=N0bQCY5oW5kQDsTKmpp1HJKFMDcAjrWJfU5YrpVtsXacvWYvmBj+zaqCf3Cz7MPFC5RJT3
        /cFq+FlmRJ6O9ZznKzXvBA9fBFc8YQ2LFEWkg9WingMemYQsV0O7RWp/uuufUMzKypOVLI
        kLGH2NI5yPWTlpbUvszpwegjkSvVV8g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-m-wsgFNMM12wVjabwsANnA-1; Wed, 24 Aug 2022 02:58:44 -0400
X-MC-Unique: m-wsgFNMM12wVjabwsANnA-1
Received: by mail-wr1-f72.google.com with SMTP id c6-20020adfa706000000b00222c3caa23eso2559580wrd.15
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 23:58:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=qAs0+Z6jR5N0Y1sR4+js+noTp9MgRP8ELyWstgdYreE=;
        b=0nvhOyihmK3n3F9CclEk3kkN9Iw3NVegXH4VZkHnc32l24o9GWN/HkqcqNs/UyEQOU
         WcJh7KUMqkXu0FVO554d1XoyXFdvWH6I1wc+k4S2ELQIGIRlWTd3B6jj4Fh5HcsHvWy9
         318uM87Np5T7uFwOJobUyrjtqf/dGAT63eRwvDiqnHhsTgLWN/dewEojdGHOUPlCraMg
         M9PHEr+QZlb116Qt0MzQLPquUf+CkL7a5IEWbTCUKOEoz85WfmziSQEd8slfKydOBmmO
         Yo/9v0bv9Sbhzzf2RL1GjZlS0wl7mY8Grwal9NJgfxK+iN/+1UBN8Gs0eOwmxYR3Mf/i
         jpXg==
X-Gm-Message-State: ACgBeo0Dhiv71hXJdFPbuBjUZywJ967ZqRKrg3+j5F2yOzzWp9vR8hj7
        sQ+gru+nAvoYOdAMhDJlyLyqTfqZ0qtEASe234aw/dQXmc+rn/0WtasRvmNC9Wo4mKHpNh78JgH
        pMetrmW8qTKAohDXX
X-Received: by 2002:a1c:770f:0:b0:3a5:ef7f:2973 with SMTP id t15-20020a1c770f000000b003a5ef7f2973mr4249255wmi.111.1661324322884;
        Tue, 23 Aug 2022 23:58:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6IAd4FxuuAo4l4o9nQSF0U99ZMbFy+CKt17zPrq56x8SqvVrrlDEcpw1/s0MDPxaxbPrZzHQ==
X-Received: by 2002:a1c:770f:0:b0:3a5:ef7f:2973 with SMTP id t15-20020a1c770f000000b003a5ef7f2973mr4249245wmi.111.1661324322588;
        Tue, 23 Aug 2022 23:58:42 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:c500:5445:cf40:2e32:6e73? (p200300cbc707c5005445cf402e326e73.dip0.t-ipconnect.de. [2003:cb:c707:c500:5445:cf40:2e32:6e73])
        by smtp.gmail.com with ESMTPSA id i7-20020a1c3b07000000b003a5c999cd1asm1065611wma.14.2022.08.23.23.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 23:58:42 -0700 (PDT)
Message-ID: <b90c64fd-1690-aa70-691f-c249586f20d4@redhat.com>
Date:   Wed, 24 Aug 2022 08:58:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, stable@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>
References: <20220823221138.45602-1-peterx@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] mm/mprotect: Only reference swap pfn page if type match
In-Reply-To: <20220823221138.45602-1-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.08.22 00:11, Peter Xu wrote:
> Yu Zhao reported a bug after the commit "mm/swap: Add swp_offset_pfn() to
> fetch PFN from swap entry" added a check in swp_offset_pfn() for swap type [1]:
> 
>   kernel BUG at include/linux/swapops.h:117!

Hi Peter,

Note that Linus recently complained to me that we should not add any new
BUG_ONs (not even VM_BUG_ONs), and even convert all of them to
WARN_ON_ONCE. So  we might want to change that to a WARN_ON_ONCE before
sending it upstream.

>   CPU: 46 PID: 5245 Comm: EventManager_De Tainted: G S         O L 6.0.0-dbg-DEV #2
>   RIP: 0010:pfn_swap_entry_to_page+0x72/0xf0
>   Code: c6 48 8b 36 48 83 fe ff 74 53 48 01 d1 48 83 c1 08 48 8b 09 f6
>   c1 01 75 7b 66 90 48 89 c1 48 8b 09 f6 c1 01 74 74 5d c3 eb 9e <0f> 0b
>   48 ba ff ff ff ff 03 00 00 00 eb ae a9 ff 0f 00 00 75 13 48
>   RSP: 0018:ffffa59e73fabb80 EFLAGS: 00010282
>   RAX: 00000000ffffffe8 RBX: 0c00000000000000 RCX: ffffcd5440000000
>   RDX: 1ffffffffff7a80a RSI: 0000000000000000 RDI: 0c0000000000042b
>   RBP: ffffa59e73fabb80 R08: ffff9965ca6e8bb8 R09: 0000000000000000
>   R10: ffffffffa5a2f62d R11: 0000030b372e9fff R12: ffff997b79db5738
>   R13: 000000000000042b R14: 0c0000000000042b R15: 1ffffffffff7a80a
>   FS:  00007f549d1bb700(0000) GS:ffff99d3cf680000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000440d035b3180 CR3: 0000002243176004 CR4: 00000000003706e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    <TASK>
>    change_pte_range+0x36e/0x880
>    change_p4d_range+0x2e8/0x670
>    change_protection_range+0x14e/0x2c0
>    mprotect_fixup+0x1ee/0x330
>    do_mprotect_pkey+0x34c/0x440
>    __x64_sys_mprotect+0x1d/0x30
> 
> It triggers because pfn_swap_entry_to_page() could be called upon e.g. a
> genuine swap entry.

Right, but the page is not touched in that case and it would simply be
an unused garbage pointer. So the real issue is that we might call
pfn_to_page() on a wrong PFN.

For !FLATMEM I think we just don't care. For SPARSEMEM, however, we
could end up getting a NULL pointer from __pfn_to_section() and end up
de-referencing it when looking up the memmap address inside the section
via __section_mem_map_addr().

I guess that could happen before your changes, for example, when we'd
have a swap offset that's larger than the biggest PFN in the system.

Reviewed-by: David Hildenbrand <david@redhat.com>

> 
> Fix it by only calling it when it's a write migration entry where the page*
> is used.
> 
> [1] https://lore.kernel.org/lkml/CAOUHufaVC2Za-p8m0aiHw6YkheDcrO-C3wRGixwDS32VTS+k1w@mail.gmail.com/
> 
> Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
> Cc: David Hildenbrand <david@redhat.com>
> Cc: <stable@vger.kernel.org>
> Reported-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/mprotect.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index f2b9b1da9083..4549f5945ebe 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -203,10 +203,11 @@ static unsigned long change_pte_range(struct mmu_gather *tlb,
>  			pages++;
>  		} else if (is_swap_pte(oldpte)) {
>  			swp_entry_t entry = pte_to_swp_entry(oldpte);
> -			struct page *page = pfn_swap_entry_to_page(entry);
>  			pte_t newpte;
>  
>  			if (is_writable_migration_entry(entry)) {
> +				struct page *page = pfn_swap_entry_to_page(entry);
> +
>  				/*
>  				 * A protection check is difficult so
>  				 * just be safe and disable write


-- 
Thanks,

David / dhildenb

