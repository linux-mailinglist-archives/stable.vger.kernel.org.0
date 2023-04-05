Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9275C6D818E
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 17:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238655AbjDEPTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 11:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238617AbjDEPTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 11:19:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D13D6A65
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 08:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680707855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Khj7fGp65bIkZuQFK2A/k7JCX9p+b8UVeQzdSnDwvw=;
        b=DVnCmIcRWXrMV9MBzK0MMQeD4+r3n+DlnJx04od//yaJVg+85yWOZxPocaz2imeB8IMHVF
        7L9dxzik7nj6ARj+B4Ht7c///ajqbKfYhkVZ9anqZmQYad9GRlIatPsKnKLNEhZbsyu957
        0CNhza/NOygyrkyxSZxyKKObEP5VGg0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-CdqWLcuMPKejeXwUkad3Lw-1; Wed, 05 Apr 2023 11:17:34 -0400
X-MC-Unique: CdqWLcuMPKejeXwUkad3Lw-1
Received: by mail-wm1-f70.google.com with SMTP id bi27-20020a05600c3d9b00b003ef6ee937b8so14077570wmb.2
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 08:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680707853;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Khj7fGp65bIkZuQFK2A/k7JCX9p+b8UVeQzdSnDwvw=;
        b=x/tcJOcdiCbq3VZl7LGqo0GmrxVGsUVSQA+bXfnlN0XQFDycUp5IHby5XamcsHC9y6
         jnTRlBYJa3Qc7BSUkjbuE+92LoEK58FW7xF6j+tLf01kw8wwqbC+H0MA6GuAa9DKkXtW
         N+pn5+guqrgJ1Ti7mCfVps0dOv7eKoyaEtx3K9cgPv61foruKnw4gHJ0CDGf5/MWQuiI
         Lq3i1HhDsovm6IKNzOA2rao9EtBbKpkjDlEZAScLuWdnHUJqpBm0948+M6QlSdPOW+3L
         Wvvfbu0Tc+m1RZy8c6ZZBBpB1FMD757Ce8NOt6Iyt0icG4kG/jyzZ8pPbSVKe9HlXqBB
         XA6A==
X-Gm-Message-State: AAQBX9dOnYutpYfWHG5i1iVGPHNr5XvfJWgvAwzNMBlH5iZtKcOJ3hl2
        Ywi5fKJOCyhNXM1z7kMlnS6EuuZusnrw08OScrXSlOHFURlkHBo6ckL6WEGLvcmPBgtIP4c0jMV
        vEkF3awwQGRDb6ACy
X-Received: by 2002:a05:600c:21cb:b0:3e1:f8af:8772 with SMTP id x11-20020a05600c21cb00b003e1f8af8772mr5063741wmj.9.1680707853189;
        Wed, 05 Apr 2023 08:17:33 -0700 (PDT)
X-Google-Smtp-Source: AKy350bocAt4RSTmZaoEeHyJOCYXfUktWpTPaw9Y+yH03cnlXYDn9H9wtt0G+cONkQNJJY+ej69ctA==
X-Received: by 2002:a05:600c:21cb:b0:3e1:f8af:8772 with SMTP id x11-20020a05600c21cb00b003e1f8af8772mr5063726wmj.9.1680707852818;
        Wed, 05 Apr 2023 08:17:32 -0700 (PDT)
Received: from ?IPV6:2003:cb:c703:d00:ca74:d9ea:11e0:dfb? (p200300cbc7030d00ca74d9ea11e00dfb.dip0.t-ipconnect.de. [2003:cb:c703:d00:ca74:d9ea:11e0:dfb])
        by smtp.gmail.com with ESMTPSA id e38-20020a5d5966000000b002d78a96cf5fsm15373262wri.70.2023.04.05.08.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 08:17:32 -0700 (PDT)
Message-ID: <c4c3ddb7-66fe-08e3-e59a-352f8aec6c6f@redhat.com>
Date:   Wed, 5 Apr 2023 17:17:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v1 1/2] mm/userfaultfd: fix uffd-wp handling for THP
 migration entries
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        stable@vger.kernel.org
References: <20230405142535.493854-1-david@redhat.com>
 <20230405142535.493854-2-david@redhat.com> <ZC2P7Z7S87myvSst@x1n>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZC2P7Z7S87myvSst@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.04.23 17:12, Peter Xu wrote:
> On Wed, Apr 05, 2023 at 04:25:34PM +0200, David Hildenbrand wrote:
>> Looks like what we fixed for hugetlb in commit 44f86392bdd1 ("mm/hugetlb:
>> fix uffd-wp handling for migration entries in hugetlb_change_protection()")
>> similarly applies to THP.
>>
>> Setting/clearing uffd-wp on THP migration entries is not implemented
>> properly. Further, while removing migration PMDs considers the uffd-wp
>> bit, inserting migration PMDs does not consider the uffd-wp bit.
>>
>> We have to set/clear independently of the migration entry type in
>> change_huge_pmd() and properly copy the uffd-wp bit in
>> set_pmd_migration_entry().
>>
>> Verified using a simple reproducer that triggers migration of a THP, that
>> the set_pmd_migration_entry() no longer loses the uffd-wp bit.
>>
>> Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> 
> Thanks, one trivial nitpick:
> 
>> ---
>>   mm/huge_memory.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 032fb0ef9cd1..bdda4f426d58 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1838,10 +1838,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>   	if (is_swap_pmd(*pmd)) {
>>   		swp_entry_t entry = pmd_to_swp_entry(*pmd);
>>   		struct page *page = pfn_swap_entry_to_page(entry);
>> +		pmd_t newpmd;
>>   
>>   		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
>>   		if (is_writable_migration_entry(entry)) {
>> -			pmd_t newpmd;
>>   			/*
>>   			 * A protection check is difficult so
>>   			 * just be safe and disable write
>> @@ -1855,8 +1855,16 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>   				newpmd = pmd_swp_mksoft_dirty(newpmd);
>>   			if (pmd_swp_uffd_wp(*pmd))
>>   				newpmd = pmd_swp_mkuffd_wp(newpmd);
>> -			set_pmd_at(mm, addr, pmd, newpmd);
>> +		} else {
>> +			newpmd = *pmd;
>>   		}
>> +
>> +		if (uffd_wp)
>> +			newpmd = pmd_swp_mkuffd_wp(newpmd);
>> +		else if (uffd_wp_resolve)
>> +			newpmd = pmd_swp_clear_uffd_wp(newpmd);
>> +		if (!pmd_same(*pmd, newpmd))
>> +			set_pmd_at(mm, addr, pmd, newpmd);
>>   		goto unlock;
>>   	}
>>   #endif
>> @@ -3251,6 +3259,8 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>>   	pmdswp = swp_entry_to_pmd(entry);
>>   	if (pmd_soft_dirty(pmdval))
>>   		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
>> +	if (pmd_swp_uffd_wp(*pvmw->pmd))
>> +		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
> 
> I think it's fine to use *pmd, but maybe still better to use pmdval?  I
> worry pmdp_invalidate()) can be something else in the future that may
> affect the bit.

Wondering how I ended up with that, I realized that it's actually
wrong and might have worked by chance for my reproducer on x86.

That should make it work:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f977c965fdad..fffc953fa6ea 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3257,7 +3257,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
         pmdswp = swp_entry_to_pmd(entry);
         if (pmd_soft_dirty(pmdval))
                 pmdswp = pmd_swp_mksoft_dirty(pmdswp);
-       if (pmd_swp_uffd_wp(*pvmw->pmd))
+       if (pmd_uffd_wp(pmdval))
                 pmdswp = pmd_swp_mkuffd_wp(pmdswp);
         set_pmd_at(mm, address, pvmw->pmd, pmdswp);
         page_remove_rmap(page, vma, true);


-- 
Thanks,

David / dhildenb

