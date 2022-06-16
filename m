Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FF754E5AA
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 17:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377788AbiFPPEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 11:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377832AbiFPPEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 11:04:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 480E0403CF
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 08:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655391867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1yesHcFM1zTB7NLF9xER3YapmNtnj5s5fkPYetaCeZg=;
        b=BH+4jeS3nsMVCUPejhONfrCDvcoym56qQZjpNIMk7qXgXpVA6EDVR5Hq7S/epIiie6SqcY
        cIBE4MBOujNXV/he4UglRQVzA0/zzTnrxi9bVtiEi4kP22Pw+SrtngdeTB65w8037b5WDe
        +1YpTtxvfaBDX5/Qpil0CNUqz2KoYJM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-GM0fC9X3NKerR-MD4_H95Q-1; Thu, 16 Jun 2022 11:04:20 -0400
X-MC-Unique: GM0fC9X3NKerR-MD4_H95Q-1
Received: by mail-wm1-f70.google.com with SMTP id r83-20020a1c4456000000b0039c8f5804c4so1272214wma.3
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 08:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=1yesHcFM1zTB7NLF9xER3YapmNtnj5s5fkPYetaCeZg=;
        b=4ZLxzQZWGbCgAha6ZxwvmJEeFvFsRvPt/0+e40mawn3eriNkqm+xGWQloLNI5bNrHT
         H8F/O/nugoInlh8ps5yroN6WMK61m9oLzqRn8M1UHdOjyZHIDFkKH8OfSdfYF3y/0eym
         XTwPICMLVtMpdODXgBLxN9lNbHbDx/TnYvIReFVmh9lQlPDFgD+kAC0F/3oTHsqAo3pV
         YCV/VGs6JPoNw2PmBvQGd6ySVCdWxg+eDnJPgEE7DY7I/6+/wxiXqnMFWJ0/5XW8Cd5P
         pFviEoWl5CcB+iMQSP6qn5zYmA3UC80RPHqZAyQt7C0GVnfHyL+DLmT7JFaQCarLF4iU
         IHQw==
X-Gm-Message-State: AJIora8lKD3/1DYtzgX6NAHlXY0a4j06RDUUO/mm24GGHVj3jEuskmm5
        K7uWcpQCzj9LLkxPSQ30BtodaWlrzDOXQOEdFWgps+YvPoWxlY14AANh4rHLaJtKOH8wMHfRURq
        8DK5TTrYxYjaetjjO
X-Received: by 2002:a7b:c015:0:b0:397:3685:5148 with SMTP id c21-20020a7bc015000000b0039736855148mr5494813wmb.174.1655391859047;
        Thu, 16 Jun 2022 08:04:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sg6hXl6XiHX1+hpayAgDawZOcPYxKoNJl9yNaq+xyCcti+qJEVyXKUTkNuIxtM/wOrItZb2g==
X-Received: by 2002:a7b:c015:0:b0:397:3685:5148 with SMTP id c21-20020a7bc015000000b0039736855148mr5494764wmb.174.1655391858593;
        Thu, 16 Jun 2022 08:04:18 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70b:2d00:73d7:5fab:cc8a:e48c? (p200300cbc70b2d0073d75fabcc8ae48c.dip0.t-ipconnect.de. [2003:cb:c70b:2d00:73d7:5fab:cc8a:e48c])
        by smtp.gmail.com with ESMTPSA id m188-20020a1c26c5000000b0039c4945c753sm6198629wmm.39.2022.06.16.08.04.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 08:04:18 -0700 (PDT)
Message-ID: <20f49e70-32e0-a141-907c-5f58c543d70b@redhat.com>
Date:   Thu, 16 Jun 2022 17:04:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the
 migratetype
Content-Language: en-US
To:     Zi Yan <ziy@nvidia.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     Guo Ren <guoren@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, huanyi.xj@alibaba-inc.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        Hanjun Guo <guohanjun@huawei.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <labbott@redhat.com>
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
 <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com>
 <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
 <D667F530-E286-4E75-B7CE-63E120E440C8@nvidia.com>
 <CAJF2gTSsaaseds=T_y-Ddt5Np2rYhk3ENumzSZDZUSXFwT3u-g@mail.gmail.com>
 <435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com>
 <b65b9edd-ff3e-aa44-029a-49fa5ba66b47@linux.alibaba.com>
 <18330D9A-F433-4136-A226-F24173293BF3@nvidia.com>
 <5526fab6-c7e1-bddc-912b-e4d9b2769d4e@linux.alibaba.com>
 <417EC421-DC05-4B35-954B-35DF873A2C40@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <417EC421-DC05-4B35-954B-35DF873A2C40@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.06.22 16:01, Zi Yan wrote:
> On 15 Jun 2022, at 12:15, Xianting Tian wrote:
> 
>> 在 2022/6/15 下午9:55, Zi Yan 写道:
>>> On 15 Jun 2022, at 2:47, Xianting Tian wrote:
>>>
>>>> 在 2022/6/14 上午8:14, Zi Yan 写道:
>>>>> On 13 Jun 2022, at 19:47, Guo Ren wrote:
>>>>>
>>>>>> On Tue, Jun 14, 2022 at 3:49 AM Zi Yan <ziy@nvidia.com> wrote:
>>>>>>> On 13 Jun 2022, at 12:32, Guo Ren wrote:
>>>>>>>
>>>>>>>> On Mon, Jun 13, 2022 at 11:23 PM Zi Yan <ziy@nvidia.com> wrote:
>>>>>>>>> Hi Xianting,
>>>>>>>>>
>>>>>>>>> Thanks for your patch.
>>>>>>>>>
>>>>>>>>> On 13 Jun 2022, at 9:10, Xianting Tian wrote:
>>>>>>>>>
>>>>>>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its migratetype.")
>>>>>>>>>> added buddy check code. But unfortunately, this fix isn't backported to
>>>>>>>>>> linux-5.17.y and the former stable branches. The reason is it added wrong
>>>>>>>>>> fixes message:
>>>>>>>>>>        Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackable
>>>>>>>>>>                            pageblocks with others")
>>>>>>>>> No, the Fixes tag is right. The commit above does need to validate buddy.
>>>>>>>> I think Xianting is right. The “Fixes:" tag is not accurate and the
>>>>>>>> page_is_buddy() is necessary here.
>>>>>>>>
>>>>>>>> This patch could be applied to the early version of the stable tree
>>>>>>>> (eg: Linux-5.10.y, not the master tree)
>>>>>>> This is quite misleading. Commit 787af64d05cd applies does not mean it is
>>>>>>> intended to fix the preexisting bug. Also it does not apply cleanly
>>>>>>> to commit d9dddbf55667, there is a clear indentation mismatch. At best,
>>>>>>> you can say the way of 787af64d05cd fixing 1dd214b8f21c also fixes d9dddbf55667.
>>>>>>> There is no way you can apply 787af64d05cd to earlier trees and call it a day.
>>>>>>>
>>>>>>> You can mention 787af64d05cd that it fixes a bug in 1dd214b8f21c and there is
>>>>>>> a similar bug in d9dddbf55667 that can be fixed in a similar way too. Saying
>>>>>>> the fixes message is wrong just misleads people, making them think there is
>>>>>>> no bug in 1dd214b8f21c. We need to be clear about this.
>>>>>> First, d9dddbf55667 is earlier than 1dd214b8f21c in Linus tree. The
>>>>>> origin fixes could cover the Linux-5.0.y tree if they give the
>>>>>> accurate commit number and that is the cause we want to point out.
>>>>> Yes, I got that d9dddbf55667 is earlier and commit 787af64d05cd fixes
>>>>> the issue introduced by d9dddbf55667. But my point is that 787af64d05cd
>>>>> is not intended to fix d9dddbf55667 and saying it has a wrong fixes
>>>>> message is misleading. This is the point I want to make.
>>>>>
>>>>>> Second, if the patch is for d9dddbf55667 then it could cover any tree
>>>>>> in the stable repo. Actually, we only know Linux-5.10.y has the
>>>>>> problem.
>>>>> But it is not and does not apply to d9dddbf55667 cleanly.
>>>>>
>>>>>> Maybe, Gregkh could help to direct us on how to deal with the issue:
>>>>>> (Fixup a bug which only belongs to the former stable branch.)
>>>>>>
>>>>> I think you just need to send this patch without saying “commit
>>>>> 787af64d05cd fixes message is wrong” would be a good start. You also
>>>>> need extra fix to mm/page_isolation.c for kernels between 5.15 and 5.17
>>>>> (inclusive). So there will need to be two patches:
>>>>>
>>>>> 1) your patch to stable tree prior to 5.15 and
>>>>>
>>>>> 2) your patch with an additional mm/page_isolation.c fix to stable tree
>>>>> between 5.15 and 5.17.
>>>>>
>>>>>>> Also, you will need to fix the mm/page_isolation.c code too to make this patch
>>>>>>> complete, unless you can show that PFN=0x1000 is never going to be encountered
>>>>>>> in the mm/page_isolation.c code I mentioned below.
>>>>>> No, we needn't fix mm/page_isolation.c in linux-5.10.y, because it had
>>>>>> pfn_valid_within(buddy_pfn) check after __find_buddy_pfn() to prevent
>>>>>> buddy_pfn=0.
>>>>>> The root cause comes from __find_buddy_pfn():
>>>>>> return page_pfn ^ (1 << order);
>>>>> Right. But pfn_valid_within() was removed since 5.15. So your fix is
>>>>> required for kernels between 5.15 and 5.17 (inclusive).
>>>>>
>>>>>> When page_pfn is the same as the order size, it will return the
>>>>>> previous buddy not the next. That is the only exception for this
>>>>>> algorithm, right?
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> In fact, the bug is a very long time to reproduce and is not easy to
>>>>>> debug, so we want to contribute it to the community to prevent other
>>>>>> guys from wasting time. Although there is no new patch at all.
>>>>> Thanks for your reporting and sending out the patch. I really
>>>>> appreciate it. We definitely need your inputs. Throughout the email
>>>>> thread, I am trying to help you clarify the bug and how to fix it
>>>>> properly:
>>>>>
>>>>> 1. The commit 787af64d05cd does not apply cleanly to commits
>>>>> d9dddbf55667, meaning you cannot just cherry-pick that commit to
>>>>> fix the issue. That is why we need your patch to fix the issue.
>>>>> And saying it has a wrong fixes message in this patch’s git log is
>>>>> misleading.
>>>>>
>>>>> 2. For kernels between 5.15 and 5.17 (inclusive), an additional fix
>>>>> to mm/page_isolation.c is also needed, since pfn_valid_within() was
>>>>> removed since 5.15 and the issue can appear during page isolation.
>>>>>
>>>>> 3. For kernels before 5.15, this patch will apply.
>>>> Zi Yan, Guo Ren,
>>>>
>>>> I think we still need some imporvemnt for MASTER branch, as we discussed above, we will get an illegal buddy page if buddy_pfn is 0,
>>>>
>>>> within page_is_buddy(), it still use the illegal buddy page to do the check. I think in most of cases, page_is_buddy() can return false,  but it still may return true with very low probablity.
>>> Can you elaborate more on this? What kind of page can lead to page_is_buddy()
>>> returning true? You said it is buddy_pfn is 0, but if the page is reserved,
>>> if (!page_is_guard(buddy) && !PageBuddy(buddy)) should return false.
>>> Maybe show us the dump_page() that offending page.
>>>
>>> Thanks.
>>
>> Let‘s take the issue we met on RISC-V arch for example,
>>
>> pfn_base is 512 as we reserved 2M RAM for opensbi, mem_map's value is 0xffffffe07e205000, which is the page address of PFN 512.
>>
>> __find_buddy_pfn() returned 0 for PFN 0x2000 with order 0xd.
>> We know PFN 0 is not a valid pfn for buddy system, because 512 is the first PFN for buddy system.
>>
>> Then it use below code to get buddy page with buddy_pfn 0:
>> buddy = page + (buddy_pfn - pfn);
>> So buddy page address is:
>> 0xffffffe07e1fe000 = (struct page*)0xffffffe07e26e000 + (0 - 0x2000)
>>
>> we can know this buddy page's address is less than mem_map(0xffffffe07e1fe000 < 0xffffffe07e205000),
>> actually 0xffffffe07e1fe000 is not a valid page's address. If we use 0xffffffe07e1fe000
>> as the page's address to extract the value of a member in 'struct page', we may get an uncertain value.
>> That's why I say page_is_buddy() may return true with very low probablity.
>>
>> So I think we need to add the code the verify buddy_pfn in the first place:
>> 	pfn_valid(buddy_pfn)
>>
> 
> +DavidH on how memory section works.
> 
> This 2MB RAM reservation does not sound right to me. How does it work in sparsemem?
> RISC-V has SECTION_SIZE_BITS=27, i.e., 128MB a section. All pages within
> a section should have their corresponding struct page (mem_map). So in this case,
> the first 2MB pages should have mem_map and can be marked as PageReserved. As a
> result, page_is_buddy() will return false.

Yes. Unless there is a BUG :)

init_unavailable_range() is supposed to initialize the memap of
unavailable ranges and mark it reserved.

I wonder if we're missing a case in memmap_init(), to also initialize
holes at the beginning of a section, before RAM (we do handle sections
in a special way if the end of RAM falls in the middle of a section).

If it's not initialized, it might contain garbage.

-- 
Thanks,

David / dhildenb

