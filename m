Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79365A2C65
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 18:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243549AbiHZQfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 12:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244060AbiHZQfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 12:35:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0D92558A
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 09:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661531740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xJrtDOE1LS6YjgDSPmg59up2c2x/o9+GnjMuyWVSMCo=;
        b=d3UUSFIsd0uDWBQrlexVVQpHjSWUIuPoIVbzdujCj0dnUEyknNOa3tuwWoBdjOlWABagRD
        of+shh5qJtPHL3m2qfcxS36l6jOcJvHc83QcR3b+D9LbIFbd7AiDNwqMKuE+Bu27V4EYLa
        sjeoTTDmw9Il9F29HZGZ7ESvFCimTtE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-483-Q4MM5zxwNduBNgR1sVmJSg-1; Fri, 26 Aug 2022 12:35:39 -0400
X-MC-Unique: Q4MM5zxwNduBNgR1sVmJSg-1
Received: by mail-wm1-f70.google.com with SMTP id x16-20020a1c7c10000000b003a5cefa5578so684698wmc.7
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 09:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=xJrtDOE1LS6YjgDSPmg59up2c2x/o9+GnjMuyWVSMCo=;
        b=wYMSbR0+WZYSrSl1KqKPXSASynsdWE3PBJqmJSk/+HZhMketaRc/hMdljyFM6vGWso
         CPdJQGRbPSSWrz08PQQdguTrQ6ZzGyV26O2ztRO4G0HKxPpJZX6GMccYtxX9fgaJ//qT
         hJiDtilAnx712SxdkeZQz9SL7ciPT2K4kXoSSUsX6Mw1AWWpQW4ptQOPnRXU9dpXyRYh
         9AERCqtrdjI4W1ToRE6TSLHAy21ex0/dyx5Xx2rb/PRkho1CGSFso//lvq+eq6TbZutv
         8na9xKptYyIe5pJpT6CUfcVyCZEQn2YpZICc9adZfE+98hsN88N3p75mNg2kF+gHs8WH
         +Ehw==
X-Gm-Message-State: ACgBeo1s2HlRSoz2zXW9suo3zgrKQucikB92Awd0XRIL5N5QYrsWeseQ
        uSTDxk0gG5cbi/zUTzfwM6sSOjDFoTIeikHMawF70hbnKtvRb/kckE5XfiIngC4czvJjLgYq6YR
        tQicnvJy+NLF9GjRL
X-Received: by 2002:a05:600c:290a:b0:3a5:515d:4f69 with SMTP id i10-20020a05600c290a00b003a5515d4f69mr244853wmd.127.1661531738256;
        Fri, 26 Aug 2022 09:35:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5EIHMKQi/zXPpLKIV0JdmfWhkQBXmKVB2m1LedfaFyGwzgbKghd2AEaeUXKNQ8MGWtQi3a4A==
X-Received: by 2002:a05:600c:290a:b0:3a5:515d:4f69 with SMTP id i10-20020a05600c290a00b003a5515d4f69mr244839wmd.127.1661531737961;
        Fri, 26 Aug 2022 09:35:37 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:f600:abad:360:c840:33fa? (p200300cbc708f600abad0360c84033fa.dip0.t-ipconnect.de. [2003:cb:c708:f600:abad:360:c840:33fa])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c4f5500b003a327b98c0asm102915wmq.22.2022.08.26.09.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 09:35:37 -0700 (PDT)
Message-ID: <f8e80df6-1c56-6a55-0926-67f5e2c3e204@redhat.com>
Date:   Fri, 26 Aug 2022 18:35:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] mm/mprotect: Only reference swap pfn page if type match
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, stable@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>
References: <20220823221138.45602-1-peterx@redhat.com>
 <411d7b8c-f914-875e-b397-856e6a894366@redhat.com>
 <YwjXxC2BbJ5+3Isx@xz-m1.local>
 <ca62c992-6242-5e82-22de-a6e8ffa824b1@redhat.com>
 <YwjvC1wYcODUuiSf@xz-m1.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <YwjvC1wYcODUuiSf@xz-m1.local>
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

On 26.08.22 18:04, Peter Xu wrote:
> On Fri, Aug 26, 2022 at 04:39:08PM +0200, David Hildenbrand wrote:
>> On 26.08.22 16:25, Peter Xu wrote:
>>> On Fri, Aug 26, 2022 at 12:49:37PM +0200, David Hildenbrand wrote:
>>>> On 24.08.22 00:11, Peter Xu wrote:
>>>>> Yu Zhao reported a bug after the commit "mm/swap: Add swp_offset_pfn() to
>>>>> fetch PFN from swap entry" added a check in swp_offset_pfn() for swap type [1]:
>>>>>
>>>>>   kernel BUG at include/linux/swapops.h:117!
>>>>>   CPU: 46 PID: 5245 Comm: EventManager_De Tainted: G S         O L 6.0.0-dbg-DEV #2
>>>>>   RIP: 0010:pfn_swap_entry_to_page+0x72/0xf0
>>>>>   Code: c6 48 8b 36 48 83 fe ff 74 53 48 01 d1 48 83 c1 08 48 8b 09 f6
>>>>>   c1 01 75 7b 66 90 48 89 c1 48 8b 09 f6 c1 01 74 74 5d c3 eb 9e <0f> 0b
>>>>>   48 ba ff ff ff ff 03 00 00 00 eb ae a9 ff 0f 00 00 75 13 48
>>>>>   RSP: 0018:ffffa59e73fabb80 EFLAGS: 00010282
>>>>>   RAX: 00000000ffffffe8 RBX: 0c00000000000000 RCX: ffffcd5440000000
>>>>>   RDX: 1ffffffffff7a80a RSI: 0000000000000000 RDI: 0c0000000000042b
>>>>>   RBP: ffffa59e73fabb80 R08: ffff9965ca6e8bb8 R09: 0000000000000000
>>>>>   R10: ffffffffa5a2f62d R11: 0000030b372e9fff R12: ffff997b79db5738
>>>>>   R13: 000000000000042b R14: 0c0000000000042b R15: 1ffffffffff7a80a
>>>>>   FS:  00007f549d1bb700(0000) GS:ffff99d3cf680000(0000) knlGS:0000000000000000
>>>>>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>   CR2: 0000440d035b3180 CR3: 0000002243176004 CR4: 00000000003706e0
>>>>>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>>>   Call Trace:
>>>>>    <TASK>
>>>>>    change_pte_range+0x36e/0x880
>>>>>    change_p4d_range+0x2e8/0x670
>>>>>    change_protection_range+0x14e/0x2c0
>>>>>    mprotect_fixup+0x1ee/0x330
>>>>>    do_mprotect_pkey+0x34c/0x440
>>>>>    __x64_sys_mprotect+0x1d/0x30
>>>>>
>>>>> It triggers because pfn_swap_entry_to_page() could be called upon e.g. a
>>>>> genuine swap entry.
>>>>>
>>>>> Fix it by only calling it when it's a write migration entry where the page*
>>>>> is used.
>>>>>
>>>>> [1] https://lore.kernel.org/lkml/CAOUHufaVC2Za-p8m0aiHw6YkheDcrO-C3wRGixwDS32VTS+k1w@mail.gmail.com/
>>>>>
>>>>> Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: <stable@vger.kernel.org>
>>>>> Reported-by: Yu Zhao <yuzhao@google.com>
>>>>> Signed-off-by: Peter Xu <peterx@redhat.com>
>>>>> ---
>>>>>  mm/mprotect.c | 3 ++-
>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>>>>> index f2b9b1da9083..4549f5945ebe 100644
>>>>> --- a/mm/mprotect.c
>>>>> +++ b/mm/mprotect.c
>>>>> @@ -203,10 +203,11 @@ static unsigned long change_pte_range(struct mmu_gather *tlb,
>>>>>  			pages++;
>>>>>  		} else if (is_swap_pte(oldpte)) {
>>>>>  			swp_entry_t entry = pte_to_swp_entry(oldpte);
>>>>> -			struct page *page = pfn_swap_entry_to_page(entry);
>>>>>  			pte_t newpte;
>>>>>  
>>>>>  			if (is_writable_migration_entry(entry)) {
>>>>> +				struct page *page = pfn_swap_entry_to_page(entry);
>>>>> +
>>>>>  				/*
>>>>>  				 * A protection check is difficult so
>>>>>  				 * just be safe and disable write
>>>>
>>>>
>>>> Stumbling over the THP code, I was wondering if we also want to adjust change_huge_pmd()
>>>> and hugetlb_change_protection. There are no actual swap entries, so I assume we're fine.
>>>>
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 482c1826e723..466364e7fc5f 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -1798,10 +1798,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>>>         if (is_swap_pmd(*pmd)) {
>>>>                 swp_entry_t entry = pmd_to_swp_entry(*pmd);
>>>> -               struct page *page = pfn_swap_entry_to_page(entry);
>>>>  
>>>>                 VM_BUG_ON(!is_pmd_migration_entry(*pmd));
>>>>                 if (is_writable_migration_entry(entry)) {
>>>> +                       struct page *page = pfn_swap_entry_to_page(entry);
>>>>                         pmd_t newpmd;
>>>>                         /*
>>>>                          * A protection check is difficult so
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index 2480ba627aa5..559465fae5cd 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -6370,9 +6370,9 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
>>>>                 }
>>>>                 if (unlikely(is_hugetlb_entry_migration(pte))) {
>>>>                         swp_entry_t entry = pte_to_swp_entry(pte);
>>>> -                       struct page *page = pfn_swap_entry_to_page(entry);
>>>>  
>>>>                         if (!is_readable_migration_entry(entry)) {
>>>> +                               struct page *page = pfn_swap_entry_to_page(entry);
>>>>                                 pte_t newpte;
>>>>  
>>>>                                 if (PageAnon(page))
>>>>
>>>>
>>>> @Peter, what's your thought?
>>>
>>> IMHO they're not needed?
>>>
>>> The rule is simple in my mind: we should only pass in a pfn-typed swap
>>> entry into pfn_swap_entry_to_page() (or the new swp_offset_pfn()), or it's
>>> a violation of the API.  In these two cases they do not violate the API and
>>> they're always safe because they're guaranteed to be pfn swap entries when
>>> calling.
>>
>> I was wondering about extreme corner cases regarding the struct page.
>>
>> Assume we have a hwpoison_entry that pointed at a valid struct page. We
>> can succeed in offlining+removing the section it's located on (I was
>> recently challenging if we want to keep that behavior as it's really
>> shaky already), freeing the relevant memmap entry and the memory section.
>>
>> pfn_swap_entry_to_page() -> pfn_to_page() would be problematic if there
>> is no memmap anymore.
>>
>>
>> I assume it's ok to always call it for is_pfn_swap_entry(), but in the
>> PMD case we only check for is_swap_pmd()? Isn't that problematic?
> 
> I don't know extensively enough on hwpoison on validity of fetching page
> from pfn inside on online/offline ops, but.. if the only concern is about
> hwpoison entry existance here I think its fine?  Because iirc we'l split
> thp when any of the subpage got poisoned, so we should never hit a hwpoison
> entry in thp path.

Ah right, so we're good. Thanks!

-- 
Thanks,

David / dhildenb

