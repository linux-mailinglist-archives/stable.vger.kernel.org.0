Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617B363F467
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 16:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiLAPoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 10:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLAPoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 10:44:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1382C19C2F
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 07:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669909386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1PA8FyCR3/gunJx7DkyWDmKgZ7n6tougFbaW1vOf1yk=;
        b=NWTd2HwqGipQSsCWpNs7tN4cccx7vnVt65ET/nGK/9Kh2kVA3f8ZOS5JfhJJJa1jKnYhqc
        cZ6ccNGjL07hYex1T6jTTYq5G3IJBaOZD08/x2mJVNdKyEKofISzKbSJlq4FySfIydVrKh
        JjSYk+/ggcQx2QKKhgNHiJO08LJDvEA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-597-LulwcultPc25unJ8jaJBRw-1; Thu, 01 Dec 2022 10:43:05 -0500
X-MC-Unique: LulwcultPc25unJ8jaJBRw-1
Received: by mail-wr1-f69.google.com with SMTP id v14-20020adf8b4e000000b0024174021277so533499wra.13
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 07:43:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1PA8FyCR3/gunJx7DkyWDmKgZ7n6tougFbaW1vOf1yk=;
        b=xIfLqTlwQnaxvdEqq4qtfmnt3umhxaOSbRUqQe1p8iYrojd+924zIALd29Ofnd2yl9
         U01vIEykGfKAsA+01mezf8fY2Kmb7shrH+1kxu3/KM7RLzYMs247G2msQZjCYJgj3rxV
         Mgxpo/b596P0x4jKyU96liQkzyl+xcbCOrkHm55jGR2zenw/Iy5M3ylWnyaJFchLcxLx
         c+drL4N1f5lfnaVStvhRJPO29ZwYu+qdpLIZW8dqpfF4OgCdLRiJqc0g/7xl2OnJu2Uv
         5dTkpOyJ94hlm9DlQF2w0bDpEXohr1F9h1WRdByVIm7XaxJAj1bSzTAx8cTAtnMvP7U6
         RyFg==
X-Gm-Message-State: ANoB5plkr1vv+YkquyMjDZ1P8+3DQa2s46mHmurgOXhIkwEYd/wGF4QN
        4nMNh3OEzDwr49FAgMq2cERPI6li+am4bEt3zZWnCA3fO1fIth8qDk4k6ElD0ArczZQyCPrlIuO
        LKgtLwsAl/gbyzaq8
X-Received: by 2002:a05:6000:124d:b0:242:10a:6667 with SMTP id j13-20020a056000124d00b00242010a6667mr23538780wrx.39.1669909381572;
        Thu, 01 Dec 2022 07:43:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5TCeDPeTaqSt4aUGafmCL2GAkina7IU0KvdH18HPecW20emnXyEvE8tc6bqGA+pHGslUBJ3Q==
X-Received: by 2002:a05:6000:124d:b0:242:10a:6667 with SMTP id j13-20020a056000124d00b00242010a6667mr23538465wrx.39.1669909374676;
        Thu, 01 Dec 2022 07:42:54 -0800 (PST)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id u11-20020a5d6acb000000b00241c4bd6c09sm4777074wrw.33.2022.12.01.07.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 07:42:53 -0800 (PST)
Message-ID: <a215fe2f-ef9b-1a15-f1c2-2f0bb5d5f490@redhat.com>
Date:   Thu, 1 Dec 2022 16:42:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
To:     Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Alistair Popple <apopple@nvidia.com>, stable@vger.kernel.org
References: <20221114000447.1681003-1-peterx@redhat.com>
 <20221114000447.1681003-2-peterx@redhat.com>
 <5ddf1310-b49f-6e66-a22a-6de361602558@redhat.com>
 <20221130142425.6a7fdfa3e5954f3c305a77ee@linux-foundation.org>
 <Y4jIHureiOd8XjDX@x1n>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Y4jIHureiOd8XjDX@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01.12.22 16:28, Peter Xu wrote:
> Hi, Andrew,
> 
> On Wed, Nov 30, 2022 at 02:24:25PM -0800, Andrew Morton wrote:
>> On Tue, 15 Nov 2022 19:17:43 +0100 David Hildenbrand <david@redhat.com> wrote:
>>
>>> On 14.11.22 01:04, Peter Xu wrote:
>>>> Ives van Hoorne from codesandbox.io reported an issue regarding possible
>>>> data loss of uffd-wp when applied to memfds on heavily loaded systems.  The
>>>> symptom is some read page got data mismatch from the snapshot child VMs.
>>>>
>>>> Here I can also reproduce with a Rust reproducer that was provided by Ives
>>>> that keeps taking snapshot of a 256MB VM, on a 32G system when I initiate
>>>> 80 instances I can trigger the issues in ten minutes.
>>>>
>>>> It turns out that we got some pages write-through even if uffd-wp is
>>>> applied to the pte.
>>>>
>>>> The problem is, when removing migration entries, we didn't really worry
>>>> about write bit as long as we know it's not a write migration entry.  That
>>>> may not be true, for some memory types (e.g. writable shmem) mk_pte can
>>>> return a pte with write bit set, then to recover the migration entry to its
>>>> original state we need to explicit wr-protect the pte or it'll has the
>>>> write bit set if it's a read migration entry.  For uffd it can cause
>>>> write-through.
>>>>
>>>> The relevant code on uffd was introduced in the anon support, which is
>>>> commit f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration",
>>>> 2020-04-07).  However anon shouldn't suffer from this problem because anon
>>>> should already have the write bit cleared always, so that may not be a
>>>> proper Fixes target, while I'm adding the Fixes to be uffd shmem support.
>>>>
>>>
>>> ...
>>>
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -213,8 +213,14 @@ static bool remove_migration_pte(struct folio *folio,
>>>>    			pte = pte_mkdirty(pte);
>>>>    		if (is_writable_migration_entry(entry))
>>>>    			pte = maybe_mkwrite(pte, vma);
>>>> -		else if (pte_swp_uffd_wp(*pvmw.pte))
>>>> +		else
>>>> +			/* NOTE: mk_pte can have write bit set */
>>>> +			pte = pte_wrprotect(pte);
>>>> +
>>>> +		if (pte_swp_uffd_wp(*pvmw.pte)) {
>>>> +			WARN_ON_ONCE(pte_write(pte));
>>
>> Will this warnnig trigger in the scenario you and Ives have discovered?
> 
> If without the above newly added wr-protect, yes.  This is the case where
> we found we got write bit set even if uffd-wp bit is also set, hence allows
> the write to go through even if marked protected.
> 
>>
>>>>    			pte = pte_mkuffd_wp(pte);
>>>> +		}
>>>>    
>>>>    		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
>>>>    			rmap_flags |= RMAP_EXCLUSIVE;
>>>
>>> As raised, I don't agree to this generic non-uffd-wp change without
>>> further, clear justification.
>>
>> Pater, can you please work this further?
> 
> I didn't reply here because I have already replied with the question in
> previous version with a few attempts.  Quotting myself:
> 
> https://lore.kernel.org/all/Y3KgYeMTdTM0FN5W@x1n/
> 
>          The thing is recovering the pte into its original form is the
>          safest approach to me, so I think we need justification on why it's
>          always safe to set the write bit.
> 
> I've also got another longer email trying to explain why I think it's the
> other way round to be justfied, rather than justifying removal of the write
> bit for a read migration entry, here:
> 

And I disagree for this patch that is supposed to fix this hunk:


@@ -243,11 +243,15 @@ static bool remove_migration_pte(struct page *page, struct vm_area_struct *vma,
                 entry = pte_to_swp_entry(*pvmw.pte);
                 if (is_write_migration_entry(entry))
                         pte = maybe_mkwrite(pte, vma);
+               else if (pte_swp_uffd_wp(*pvmw.pte))
+                       pte = pte_mkuffd_wp(pte);
  
                 if (unlikely(is_zone_device_page(new))) {
                         if (is_device_private_page(new)) {
                                 entry = make_device_private_entry(new, pte_write(pte));
                                 pte = swp_entry_to_pte(entry);
+                               if (pte_swp_uffd_wp(*pvmw.pte))
+                                       pte = pte_mkuffd_wp(pte);
                         }
                 }
  

There is really nothing to justify the other way around here.
If it's broken fix it independently and properly backport it independenty.

But we don't know about any such broken case.

I have no energy to spare to argue further ;)



-- 
Thanks,

David / dhildenb

