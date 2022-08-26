Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B0A5A3200
	for <lists+stable@lfdr.de>; Sat, 27 Aug 2022 00:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiHZWWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 18:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345358AbiHZWV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 18:21:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F4E1012
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 15:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661552394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q82AOj5mgWsqghXykEygItIBdPuSqpKfW9fkWnf7Xws=;
        b=UKv4nGylS0BVRe9BVetVNaGb5OusJT8n5XwcZoDmWU234V8Pg9P+wFCfBwtBRl04qaoJaQ
        skhEQ884Kgxcglik0yAgnPgJMzbKl/OZ+xTgszAu0csCHAXoSFj2G2+t5DcrNsRxcFmPXx
        h9XZ413e5O4rN5jR9NBi9624dnuSeUk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-369-D2nygUiENnq0vPoaa0WXDg-1; Fri, 26 Aug 2022 18:19:53 -0400
X-MC-Unique: D2nygUiENnq0vPoaa0WXDg-1
Received: by mail-wr1-f72.google.com with SMTP id r7-20020adfbb07000000b00225b9579132so402865wrg.6
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 15:19:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=Q82AOj5mgWsqghXykEygItIBdPuSqpKfW9fkWnf7Xws=;
        b=f13acTUIQW+Y7907qoWE+j1TT6vVy41DSEA5O/nH5L1Io51pypT1Lwkuq+0CSBhr2n
         HbfgdoqM3NJGiNL/PiHEvnocNV/d59/GEy7jevEQsLot5+0WZL4rU+F9jK+DDmUrW4cn
         Idjk2y5eLSRUmmTRvJLNh8lV/6Kz0P7GicK1FkaMD2OYzqxrlYt97LsPchqpf+UDJ0hK
         YPy3P7YSICaJDALKNHjxfIePagwAqRhNcn/4b7I+rJSJIwulza6Mi98f7eqUWz9Izf/P
         +Cjez4nIGv8wPO0aJPlHhYOsgQiPQVtNPNVMXwMOFlqHR1Qx7pbR9zYj/8iZ5w5Ebphw
         yvhg==
X-Gm-Message-State: ACgBeo0XBvJZvnPEaISabFKwBkFtwQcVVSjAK8fYVe0tcUVux6Bb4mLg
        CmqZAzDbquFo7Z6QnIc5Y+Rk8IQl/Zzub0cp7Ic8fuZ6LD5VMpn2d1PManEpLqWC2aqEpDxOhRm
        9UG//08VW5sDM1qCz
X-Received: by 2002:a5d:698e:0:b0:225:72d1:94c with SMTP id g14-20020a5d698e000000b0022572d1094cmr794611wru.381.1661552392055;
        Fri, 26 Aug 2022 15:19:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7uezQ+j0oPcMek2XYoB9iVNLxa90U2dcSyOQ9ZNnqcMKuPPCHXv0+i1qNpul+pt30Kva2P9A==
X-Received: by 2002:a5d:698e:0:b0:225:72d1:94c with SMTP id g14-20020a5d698e000000b0022572d1094cmr794585wru.381.1661552391790;
        Fri, 26 Aug 2022 15:19:51 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70c:d200:fbf4:8c3c:56fa:173d? (p200300cbc70cd200fbf48c3c56fa173d.dip0.t-ipconnect.de. [2003:cb:c70c:d200:fbf4:8c3c:56fa:173d])
        by smtp.gmail.com with ESMTPSA id j2-20020a056000124200b0022537d826f3sm824156wrx.23.2022.08.26.15.19.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 15:19:51 -0700 (PDT)
Message-ID: <a64b2131-5a78-c89d-9e88-b78aee0074b9@redhat.com>
Date:   Sat, 27 Aug 2022 00:19:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
 <ffbc824af5daa2c44b91c66834a341894fba4ce6.1661309831.git-series.apopple@nvidia.com>
 <YwZGHyYJiJ+CGLn2@xz-m1.local> <8735dkeyyg.fsf@nvdebian.thelocal>
 <YwgFRLn43+U/hxwt@xz-m1.local> <8735dj7qwb.fsf@nvdebian.thelocal>
 <YwjZamk4n/dz+Y/M@xz-m1.local>
 <72146725-3d70-0427-50d4-165283a5a85d@redhat.com>
 <Ywjs/i4kIVlxZwpb@xz-m1.local>
 <140e7688-b66d-2f6d-fed8-e39da5045420@redhat.com>
 <Ywk9CKIJMX3z6WIq@xz-m1.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 2/3] mm/migrate_device.c: Copy pte dirty bit to page
In-Reply-To: <Ywk9CKIJMX3z6WIq@xz-m1.local>
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

On 26.08.22 23:37, Peter Xu wrote:
> On Fri, Aug 26, 2022 at 06:46:02PM +0200, David Hildenbrand wrote:
>> On 26.08.22 17:55, Peter Xu wrote:
>>> On Fri, Aug 26, 2022 at 04:47:22PM +0200, David Hildenbrand wrote:
>>>>> To me anon exclusive only shows this mm exclusively owns this page. I
>>>>> didn't quickly figure out why that requires different handling on tlb
>>>>> flushs.  Did I perhaps miss something?
>>>>
>>>> GUP-fast is the magic bit, we have to make sure that we won't see new
>>>> GUP pins, thus the TLB flush.
>>>>
>>>> include/linux/mm.h:gup_must_unshare() contains documentation.
>>>
>>> Hmm.. Shouldn't ptep_get_and_clear() (e.g., xchg() on x86_64) already
>>> guarantees that no other process/thread will see this pte anymore
>>> afterwards?
>>
>> You could have a GUP-fast thread that just looked up the PTE and is
>> going to pin the page afterwards, after the ptep_get_and_clear()
>> returned. You'll have to wait until that thread finished.
> 

Good that we're talking about it, very helpful! If that's actually not
required -- good.


What I learned how GUP-fast and TLB flushes interact is the following:

GUP-fast disables local interrupts. A TLB flush will send an IPI and
wait until it has been processed. This implies, that once the TLB flush
succeeded, that the interrupt was handled and GUP-fast cannot be running
anymore.

BUT, there is the new RCU variant nowadays, and the TLB flush itself
should not actually perform such a sync. They merely protect the page
tables from getting freed and the THP from getting split IIUC. And
you're correct that that wouldn't help.


> IIUC the early tlb flush won't protect concurrent fast-gup from happening,
> but I think it's safe because fast-gup will check pte after pinning, so
> either:
> 
>   (1) fast-gup runs before ptep_get_and_clear(), then
>       page_try_share_anon_rmap() will fail properly, or,
> 
>   (2) fast-gup runs during or after ptep_get_and_clear(), then fast-gup
>       will see that either the pte is none or changed, then it'll fail the
>       fast-gup itself.

I think you're right and I might have managed to confuse myself with the
write_protect_page() comment. I placed the gup_must_unshare() check
explicitly after the "pte changed" check for this reason. So once the
PTE was cleared, GUP-fast would undo any pin performed on a now-stale PTE.

> 
>>
>> Another user that relies on this interaction between GUP-fast and TLB
>> flushing is for example mm/ksm.c:write_protect_page()
>>
>> There is a comment in there explaining the interaction a bit more detailed.
>>
>> Maybe we'll be able to handle this differently in the future (maybe once
>> this turns out to be an actual performance problem). Unfortunately,
>> mm->write_protect_seq isn't easily usable because we'd need have to make
>> sure we're the exclusive writer.
>>
>>
>> For now, it's not too complicated. For PTEs:
>> * try_to_migrate_one() already uses ptep_clear_flush().
>> * try_to_unmap_one() already conditionally used ptep_clear_flush().
>> * migrate_vma_collect_pmd() was the one case that didn't use it already
>>  (and I wonder why it's different than try_to_migrate_one()).
> 
> I'm not sure whether I fully get the point, but here one major difference
> is all the rest handles one page, so a tlb flush alongside with the pte
> clear sounds reasonable.  Even if so try_to_unmap_one() was modified to use
> tlb batching, but then I see that anon exclusive made that batching
> conditional.  I also have question there on whether we can keep using the
> tlb batching even with anon exclusive pages there.
> 
> In general, I still don't see how stall tlb could affect anon exclusive
> pages on racing with fast-gup, because the only side effect of a stall tlb
> is unwanted page update iiuc, the problem is fast-gup doesn't even use tlb,
> afaict..

I have the gut feeling that the comment in write_protect_page() is
indeed stale, and that clearing PageAnonExclusive doesn't strictly need
the TLB flush.

I'll try to refresh my memory if there was any other case that I had to
handle over the weekend.

Thanks!

-- 
Thanks,

David / dhildenb

