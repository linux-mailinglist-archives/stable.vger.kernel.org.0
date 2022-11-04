Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12392619204
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 08:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiKDHb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 03:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiKDHb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 03:31:56 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D785F29CBB;
        Fri,  4 Nov 2022 00:31:54 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id k15so3809146pfg.2;
        Fri, 04 Nov 2022 00:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z/2ddx3QK9qVmB+YZPn4XwRTbYZOHRH73PR/5mzfEfs=;
        b=VMp82LIS3vwEtXJO+/+qulhDA06eeVOiufgCORgqh+ukznplIhIOFxydjlGiDfIpqY
         UXc7qz9WXOAUh0Zkxs49Ghh30Bvcf8K8IHjeVFs94dlpDBS09g4nt9weckjZgunEm2OI
         n99KXR/LbdhfaiDbWFhmOuw4GyzDc+iw5QiZWsBTmkVMpWE5qkm74GfUv9hEszTSSO/F
         mQe33R6q5DoI5gWUb435ifIWgEG5j/HfVHuETy6uPq8SYbX7D2FTNqpu3K6nXgJg4/SN
         vZz9LE3DjAHomW5KRTf9Ng8KTAgn8q00HkDlW2fM9BNBO39I3ZaNp7nri8rfn/KHZ3Ab
         h+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z/2ddx3QK9qVmB+YZPn4XwRTbYZOHRH73PR/5mzfEfs=;
        b=50If4sZKgIByADnHsZ6x0Vf7naPadevkP59RlmIckbE9LoyXzXuNpKQjwgKvM4Ni1d
         zZ8GsEabvr/bNexo6kHMU0cto4yT9hRRz12b7wfWnpO/PiM7qUJGEYhO9T3NjrRYw4Pg
         Mn8QJc6ghjeMpGR5Oo7ZR4QoWgwvJNE7Ncxr70xwvB14JbWSadHQpQONpwXr3nlYg7Ga
         52fVvbfLsmEK1ivw9OevUsHrvgno+xpki/PVud2b+yqWkfLVeBzQUENJugBM5nYYi8pn
         dZkRvjEyanhMIWEFEVr+SUrZaiA8kqHDZ4gU2qmo9g97MgI5s679Na3bET47ClkMcR0j
         mIlA==
X-Gm-Message-State: ACrzQf3x/10TkSgKYa1AY6UFsPZMCsUa6lxxu0FO+hVIkxV9NNmLO9dO
        4o1bfCYnle87hy6ymzOWvWjQ3XcyG+6pbQ==
X-Google-Smtp-Source: AMsMyM4DOu8z9+w2S8sFcStYPjXJIlaR24z6iOen4ZQnFO1xlWcOOFlfIIWQREkSfp6bE+UOMspzpQ==
X-Received: by 2002:a63:4955:0:b0:44e:d36e:4c2e with SMTP id y21-20020a634955000000b0044ed36e4c2emr29441324pgk.326.1667547114380;
        Fri, 04 Nov 2022 00:31:54 -0700 (PDT)
Received: from [172.20.12.203] ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id b3-20020aa79503000000b0056d2797bf05sm1926784pfp.217.2022.11.04.00.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 00:31:53 -0700 (PDT)
Message-ID: <fe95b054-e720-ebbf-ba03-4ea6662974ad@gmail.com>
Date:   Fri, 4 Nov 2022 15:31:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Cc:     xiongxin@kylinos.cn, len.brown@intel.com, pavel@ucw.cz,
        huanglei@kylinos.cn, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH -next 1/2] PM: hibernate: fix spelling mistake for
 annotation
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>
References: <20221101022840.1351163-1-tgsp002@gmail.com>
 <20221101022840.1351163-2-tgsp002@gmail.com>
 <CAJZ5v0iPFPbbconOoQ7x_4X5yJ31pP7aduLqG4dq6KgAsprKbA@mail.gmail.com>
From:   TGSP <tgsp002@gmail.com>
In-Reply-To: <CAJZ5v0iPFPbbconOoQ7x_4X5yJ31pP7aduLqG4dq6KgAsprKbA@mail.gmail.com>
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

在 2022/11/4 00:25, Rafael J. Wysocki 写道:
> On Tue, Nov 1, 2022 at 3:28 AM TGSP <tgsp002@gmail.com> wrote:
>>
>> From: xiongxin <xiongxin@kylinos.cn>
>>
>> The actual calculation formula in the code below is:
>>
>> max_size = (count - (size + PAGES_FOR_IO)) / 2
>>              - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);
>>
>> But function comments are written differently, the comment is wrong?
> 
> It is, and it is more serious than just a spelling mistake.
> 
>> By the way, what exactly do the "/ 2" and "2 *" mean?
> 
> Every page in the image is a copy of an existing allocated page, so
> room needs to be made for the two, except for the "IO pages" and
> metadata pages that are not copied.  Hence, the division by 2.
> 
> Now, the "reserved_size" pages will be allocated right before creating
> the image and there will be a copy of each of them in the image, so
> there needs to be room for twice as many.

According to your interpretation, the formula should be：
max_size = (count - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
                - (size + PAGES_FOR_IO)) / 2

Am I right?

> 
> I'll adjust the changelog and queue up the path for 6.2.
> 
>> Cc: stable@vger.kernel.org
> 
> I'll add a Fixes tag instead.
> 
>> Signed-off-by: xiongxin <xiongxin@kylinos.cn>
>> ---
>>   kernel/power/snapshot.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
>> index 2a406753af90..c20ca5fb9adc 100644
>> --- a/kernel/power/snapshot.c
>> +++ b/kernel/power/snapshot.c
>> @@ -1723,8 +1723,8 @@ static unsigned long minimum_image_size(unsigned long saveable)
>>    * /sys/power/reserved_size, respectively).  To make this happen, we compute the
>>    * total number of available page frames and allocate at least
>>    *
>> - * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2
>> - *  + 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
>> + * ([page frames total] - PAGES_FOR_IO - [metadata pages]) / 2
>> + *  - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
>>    *
>>    * of them, which corresponds to the maximum size of a hibernation image.
>>    *
>> --
>> 2.25.1
>>

