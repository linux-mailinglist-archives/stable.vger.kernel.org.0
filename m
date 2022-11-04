Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D631B6191F1
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 08:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKDH2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 03:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiKDH2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 03:28:10 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28EF29828;
        Fri,  4 Nov 2022 00:28:03 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d24so4135775pls.4;
        Fri, 04 Nov 2022 00:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FLeajmmt4OPqluX6qzNLUNCHH3zdvUvIgfbZ+S214BU=;
        b=GOJB+kSCAztTl5M+caF4wc8YttwA+XpwYpWa/wWHHlGGI43rzkz8mGzjRyMIqFhH9m
         j8i/8PY2xF+vutN1Xi4hB+EehJsIjFGDD/uUkTm3ElXwfXruft2PFepH7kBSNQXUdVNg
         omti1zFQGd9C/aRAV4m6ND50lUkotoolyTxt05AM9x4bB/wi/J0fZ5OitA+ts9Ro5zuY
         0asuHq5OQWULWhhUhN0DNsrokEkpgpF1Y7jt0YEQyvzFp2aegFdnFYvJAM5BUsGBJl2T
         bXZ1wYlmnS855rZwISVyu7DvEzTnN5DOPHLGqcstT/RA+ezdEKErw0zlqrkif9HNvezV
         FnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FLeajmmt4OPqluX6qzNLUNCHH3zdvUvIgfbZ+S214BU=;
        b=xHnQE8OVdN2MTuxZ5+CPi7OSnsAvhvpVEPHkkAn4t8kr3YQuoA1xYS8xvOWkrOvLIe
         UKFF6kG4PrkkKpTXC8Qqi7ElFjoC6Pi1Fr/kfcVy90/xWQWsMnbh4ciKbk5PaGgpiz0N
         Lr59NiNKjsh+XnkypIMP0elyxl2wO4MIQXnIlG/Slb15AMzD+WuDlguxEUx3FqyuIJBG
         a9HPATtZUtUM0sH6YMXpb9dZSEAUR2yIhG+dBa62Wxbu9iO/irF+xRoyUChRtPH/zzea
         3eMX/idmrkriigTT+84kA8kMkgtMdYmo0G0abDr21gJULx8j8JSH7vZfRPIUs/gOgB5P
         /2HA==
X-Gm-Message-State: ACrzQf1/gm3n60cFkFN09wLQxVUcBSgIHFxE4wOolKLCovd6h4Vy9q9a
        9deVA5gVw8bO68hCQqtHLKc=
X-Google-Smtp-Source: AMsMyM6TlmV0vIFYVjLSbkFVzEWKMmvlsNiO0yO7V75n+DXAg4e3kcERPBdT6RbSgtl4G4gFFJONSg==
X-Received: by 2002:a17:903:404c:b0:188:602b:5a24 with SMTP id n12-20020a170903404c00b00188602b5a24mr3661082pla.105.1667546883166;
        Fri, 04 Nov 2022 00:28:03 -0700 (PDT)
Received: from [172.20.12.203] ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id z11-20020a1709027e8b00b00186e2d57f79sm1799709pla.288.2022.11.04.00.28.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 00:28:02 -0700 (PDT)
Message-ID: <a6893696-bcac-c57d-7db9-61bcbb0ad414@gmail.com>
Date:   Fri, 4 Nov 2022 15:27:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Cc:     xiongxin@kylinos.cn, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] PM: hibernate: add check of preallocate mem for
 image size pages
Content-Language: en-US
To:     Jiri Slaby <jirislaby@kernel.org>, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz, huanglei@kylinos.cn
References: <20221104054119.1946073-1-tgsp002@gmail.com>
 <20221104054119.1946073-3-tgsp002@gmail.com>
 <90de2e70-1802-b26b-798e-74421389180e@kernel.org>
From:   TGSP <tgsp002@gmail.com>
In-Reply-To: <90de2e70-1802-b26b-798e-74421389180e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2022/11/4 14:25, Jiri Slaby 写道:
> On 04. 11. 22, 6:41, TGSP wrote:
>> From: xiongxin <xiongxin@kylinos.cn>
>>
>> Added a check on the return value of preallocate_image_highmem(). If
>> memory preallocate is insufficient, S4 cannot be done;
>>
>> I am playing 4K video on a machine with AMD or other graphics card and
>> only 8GiB memory, and the kernel is not configured with CONFIG_HIGHMEM.
>> When doing the S4 test, the analysis found that when the pages get from
>> minimum_image_size() is large enough, The preallocate_image_memory() and
>> preallocate_image_highmem() calls failed to obtain enough memory. Add
>> the judgment that memory preallocate is insufficient;
>>
>> The detailed debugging data is as follows:
>>
>> image_size: 3225923584, totalram_pages: 1968948 in
>> hibernate_reserved_size_init();
>>
>> in hibernate_preallocate_memory():
>> code pages = minimum_image_size(saveable) = 717992, at this time(line):
>> count: 2030858
>> avail_normal: 2053753
>> highmem: 0
>> totalreserve_pages: 22895
>> max_size: 1013336
>> size: 787579
>> saveable: 1819905
>>
>> When the code executes to:
>> pages = preallocate_image_memory(alloc, avail_normal), at that
>> time(line):
>> pages_highmem: 0
>> avail_normal: 1335761
>> alloc: 1017522
>> pages: 1017522
>>
>> So enter the else branch judged by (pages < alloc), When executed to
>> size = preallocate_image_memory(alloc, avail_normal):
>> alloc = max_size - size = 225757;
>> size = preallocate_image_memory(alloc, avail_normal) = 168671, That is,
>> preallocate_image_memory() does not apply for all alloc memory pages,
>> because highmem is not enabled, and size_highmem will return 0 here, so
>> there is a memory page that has not been preallocated, so I think a
>> judgment needs to be added here.
>>
>> But what I can't understand is that although pages are not preallocated
>> enough, "pages -= free_unnecessary_pages()" in the code below can also
>> discard some pages that have been preallocated, so I am not sure whether
>> it is appropriate to add a judgment here.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: xiongxin <xiongxin@kylinos.cn>
>> Signed-off-by: huanglei <huanglei@kylinos.cn>
>> ---
>>   kernel/power/snapshot.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
>> index c20ca5fb9adc..546d544cf7de 100644
>> --- a/kernel/power/snapshot.c
>> +++ b/kernel/power/snapshot.c
>> @@ -1854,6 +1854,8 @@ int hibernate_preallocate_memory(void)
>>           alloc = (count - pages) - size;
>>           pages += preallocate_image_highmem(alloc);
>>       } else {
>> +        unsigned long size_highmem = 0;
> 
> This needs not be initialized, right?

If there is no need to make judgments here, then in the (pages < alloc) 
branch, it is necessary to make judgments on (pages_highmem < alloc)? 
should be the same;

> 
>> @@ -1863,8 +1865,13 @@ int hibernate_preallocate_memory(void)
>>           pages_highmem += size;
>>           alloc -= size;
>>           size = preallocate_image_memory(alloc, avail_normal);
>> -        pages_highmem += preallocate_image_highmem(alloc - size);
>> -        pages += pages_highmem + size;
>> +        size_highmem = preallocate_image_highmem(alloc - size);
>> +        if (size_highmem < (alloc - size)) {
>> +            pr_err("Image allocation is %lu pages short, exit\n",
>> +                alloc - size - pages_highmem);
>> +            goto err_out;
>> +        }
>> +        pages += pages_highmem + size_highmem + size;
>>       }
>>       /*
> 

