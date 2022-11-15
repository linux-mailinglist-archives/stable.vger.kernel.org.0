Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0045362A02C
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 18:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKORXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 12:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiKORXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 12:23:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E892F031
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 09:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668532928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8l4pIGrlIpw/sxoSKlU1ZG63LGDo4ZciEpI8QjHdn0=;
        b=REjm43rG1kStr1lG0116jUobaWMYAxG6/vUaYu/5O7/pNRiGngviGXMLxylW31B2GoniYd
        JfbEoQhpTbbXQKO7FzwYb+d1x3K/GqSxHiMnHLFONdvvu5PJBhzddkOf+o862ImgIF/wTx
        qcBOshnaAfP+N0OrrbUMIcU+gIRRfow=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-492-kylPSH0sMzqrTkKEofkB_g-1; Tue, 15 Nov 2022 12:22:07 -0500
X-MC-Unique: kylPSH0sMzqrTkKEofkB_g-1
Received: by mail-wm1-f69.google.com with SMTP id p14-20020a05600c204e00b003cf4cce4da5so3962245wmg.0
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 09:22:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m8l4pIGrlIpw/sxoSKlU1ZG63LGDo4ZciEpI8QjHdn0=;
        b=mc7D2XWxROpmpy/eusmaAo9bZ+5pr2GHDEQeX+9qMkDnrkXj0o0AsQx7ayKDjGvkBN
         cbU0Gq7wkv/PCOLzIti22f++vWcLvVrWM56SNcVimYcXm6LfNgXinhpxf1HAuagwtlpq
         WsoV8nOCg0jd5mZN3Hd+XoaDWQpMxTgXNvY6Mi619Ab8ICJBpyiZ6FKWPGNbeGkn/m39
         7v2/XLgGIh79X7Jy5LlYAxwlcypE8vDqMaquLLmBwB4HVQE8wHVlmEKahMOoyzkyhDal
         GINpJS7pdGAyiBet8zAyQ5POp2RleoF/4yH7AvfJjFs6DDbL11J25Fzlafxg8HSaK/Jy
         6Bbg==
X-Gm-Message-State: ANoB5pmp3AR1yb4pYtVioyCKD5CwSsaqO+51ad6bgB+FEhiCeoZTi4sw
        Hf9bMYKFV0VOWJnaIO5twvjDt4XadUr7bSNNXuBry6retp6rcVkqS5RrFEj73lzBbmLdBchf+IC
        MX4tFEXSM55ZwAsBp
X-Received: by 2002:adf:bb43:0:b0:22e:6f0d:d69 with SMTP id x3-20020adfbb43000000b0022e6f0d0d69mr11781327wrg.134.1668532925865;
        Tue, 15 Nov 2022 09:22:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7FOlUtjvvU7F7kEfxG6kLCcch/2duEN2plX5JnnVuNV6ZxayUzFm3GisnIqxJlCULGLioKDg==
X-Received: by 2002:adf:bb43:0:b0:22e:6f0d:d69 with SMTP id x3-20020adfbb43000000b0022e6f0d0d69mr11781292wrg.134.1668532925275;
        Tue, 15 Nov 2022 09:22:05 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:9d00:9303:90ce:6dcb:2bc9? (p200300cbc7079d00930390ce6dcb2bc9.dip0.t-ipconnect.de. [2003:cb:c707:9d00:9303:90ce:6dcb:2bc9])
        by smtp.gmail.com with ESMTPSA id r11-20020a5d694b000000b0023691d62cffsm12679101wrw.70.2022.11.15.09.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 09:22:04 -0800 (PST)
Message-ID: <82d7a142-8c78-4168-37e9-7b677b18987a@redhat.com>
Date:   Tue, 15 Nov 2022 18:22:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
 <9af36be3-313b-e39c-85bb-bf30011bccb8@redhat.com> <Y3KgYeMTdTM0FN5W@x1n>
 <ec8b3c86-d3b2-f898-7297-c20a58ae2ac1@redhat.com> <Y3O5bCXSbvKJrjRL@x1n>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
In-Reply-To: <Y3O5bCXSbvKJrjRL@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> I consider UFFD-wp a special case: while the default VMA protection might
>> state that it is writable, you actually want individual PTEs to be
>> write-protected and have to manually remove the protection.
>>
>> softdirty tracking is another special case: however, softdirty tracking is
>> enabled for the whole VMA. For remove_migration_pte() that should be fine (I
>> guess) because writenotify is active when the VMA needs to track softdirty
>> bits, and consequently vma->vm_page_prot has the proper default permissions.
>>
>>
>> I wonder if the following (valid), for example is possible:
>>
>>
>> 1) clear_refs() clears VM_SOFTDIRTY and pte_wrprotect() the pte.
>> -> writenotify is active and vma->vm_page_prot updated accordingly
>>
>> VM_SOFTDIRTY is reset due to VMA merging and vma->vm_page_prot is updated
>> accordingly. See mmap_region() where we set VM_SOFTDIRTY.
>>
>> If you now migrate the (still write-protected in the PTE) page, it was not
>> writable, but it can be writable on the destination.
> 
> I didn't even notice merging could work with soft-dirty enabled, that's
> interesting to know.
> 
> Yes I think it's possible and I agree it's safe, as VM_SOFTDIRTY is set for
> the merged vma so afaiu the write bit is safe to set.  We get a bunch of
> false positives but that's how soft-dirty works.
> 
> I think the whole problem is easier if we see this at a higher level.
> You're discussing this from vma pov and it's fair to do so, at least I
> agree with what you mentioned so far and I can't see anything outside
> uffd-wp that can be affected.  However, it is also true when you noticed we
> already have quite a few paragraphs trying to discuss the safety for this
> and that, that's the part where I think we need justification and it's not
> that "natural".
> 
> For "natural", I meant fundamentally we're talking about page migrations
> here.  The natural way (at least to me) for page migration to happen as a
> fundamental rule is that, we leverag the migration pte to make sure the pte
> being stable so we can do the migration work, then we "recover" the pte to
> present either by a full recovery or just (hopefully) only replace the pfn,
> keeping all the rest untouched.
> 
> One thing to prove that is we have two migration entries not one (I'm
> temporarily put the exclusive read one aside since that's solving different
> problems): MIGRATION_READ and MIGRATION_WRITE.  If we only rely on vma
> flags logically we don't need MIGRATION_READ and MIGRATION_WRITE, we only
> need MIGRATION generic swap pte then we recover the write bit from vma
> flags and other things (like uffd-wp, currently we have the bit set in swap
> pte besides the swap entry type).
> 
> So maybe one day we can use two migration types rather than three
> (MIGRATION and MIGRATION_EXCLUSIVE)?  I can't tell, but hopefully that
> shows what I meant, that we need further justification to grant write bit
> only base on vma, rather than recovering write bit based on migration entry
> type.

That's precisely what I had in mind recently, and I am happy to hear 
that you have similar idea:

https://lkml.kernel.org/r/20221108174652.198904-6-david@redhat.com

"
Note that we don't optimize for the actual migration case:
(1) When migration succeeds the new PTE will not be writable because the
     source PTE was not writable (protnone); in the future we
     might just optimize that case similarly by reusing
     can_change_pte_writable()/can_change_pmd_writable() when removing
     migration PTEs.
"

Currently, "readable_migration_entry" is even wrong: it might be 
PROT_NONE and not even readable.

-- 
Thanks,

David / dhildenb

