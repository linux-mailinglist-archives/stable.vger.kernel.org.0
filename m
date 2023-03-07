Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A3F6AE619
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCGQRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjCGQRF (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 7 Mar 2023 11:17:05 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C9D8C0F7
        for <Stable@vger.kernel.org>; Tue,  7 Mar 2023 08:16:52 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id l1so13739756pjt.2
        for <Stable@vger.kernel.org>; Tue, 07 Mar 2023 08:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1678205812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UYrq8v4HuBX2RB3d/VYQuTqaXQLxDy94/DGyKGTa8GE=;
        b=hhzoLo9mKt/chtZRRSOWW58mZp/EbLNymdzmTurgTLcgtj8rNx6VnB/zZIJiN5dEMU
         eVe5J6srcOE82KYyn5ItH6i9pMruynIPB389vTFujaSn/WVOs0lKDCeeyD+wkJS5kmr9
         vRbRLHKU1Jo6wjY7Af+eOUM374qWjJrS6eTxxIL3WGPR9d7y47OHFyNzOdNF5ND96sdP
         XywFbkdI+e0GX6cdCgibnT1u4bIUjU256+5wLjw1VjSrShhAQAX69wZdErCstme3BwZe
         ZjJPbdMR3xt2o0B7+zoNSUs1nlpJj5QYPHkos75VEGPw3Hmk75Dm0DaoigmV72xRC4OF
         5jkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678205812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UYrq8v4HuBX2RB3d/VYQuTqaXQLxDy94/DGyKGTa8GE=;
        b=DkZxVwcnX5mG0pyWbUXThT8hoUGBCCqBYuO642rW86qV9xAJ02k+pIsCWonWTGeydR
         rn1nZsg0jNnYCA3ZprIcXVx84qZtGdvqBEL2WfoVOv9BHeqNUJPki3J9dIM5eis82Zam
         Nir9RtQYSLLofARMGgE/cs5PKu3vclDmrs/xgpu/cC0XCEK/7WDga2JpGUX8LiFUyweb
         n9HgWwrf1hj8x5Bv4EO2u1ijZg9IoCdOaYa8WqjXdf3TdXcx1zLvWaMS53bLxBOfI80M
         p17O7dIdSDDoDH2oXS3jGIMMds8Kk5I0lbDH9LSNHUPKLvG/g+fudi25BmLkZkkK5J4l
         dGkA==
X-Gm-Message-State: AO0yUKUIO2XaYm7gXKBDTNAHZkl+d9DHXemdiIMQWQeV8JMvp1UoA7/W
        tL2IX4XTODIBBazdvPOotd0QXQ==
X-Google-Smtp-Source: AK7set88BIwUJLFdpOXlbPGslKaEFH1+u9BuN0cxiLp2l426wfCtLQ01n+NArA7B7dU5e3lv3y6Fyw==
X-Received: by 2002:a17:90b:3ec9:b0:230:7c78:6a7 with SMTP id rm9-20020a17090b3ec900b002307c7806a7mr15672363pjb.28.1678205812067;
        Tue, 07 Mar 2023 08:16:52 -0800 (PST)
Received: from [10.200.8.102] ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id fv24-20020a17090b0e9800b002340f58e19bsm7568391pjb.45.2023.03.07.08.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 08:16:51 -0800 (PST)
Message-ID: <d0d2f9f9-4ad0-65f8-96e7-39decbb6ac54@bytedance.com>
Date:   Wed, 8 Mar 2023 00:16:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH 1/2] maple_tree: Fix mas_skip_node() end slot detection
To:     Snild Dolkow <snild@sony.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc:     Stable@vger.kernel.org, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
 <cec2dec7-818a-b32c-3ad4-8b23fc1351f3@bytedance.com>
 <73971153-b46e-0332-aa4a-0dbe0a59fd22@sony.com>
From:   Peng Zhang <zhangpeng.00@bytedance.com>
In-Reply-To: <73971153-b46e-0332-aa4a-0dbe0a59fd22@sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Snild,

在 2023/3/7 22:30, Snild Dolkow 写道:
> On 2023-03-07 14:05, Peng Zhang wrote:
>> Hi, Liam,
>>> -    } while (slot > slot_count);
>>> +    } while (mas->offset >= mas_data_end(mas));
>>> -    mas->offset = ++slot;
>>> +    mt = mte_node_type(mas->node);
>>>       pivots = ma_pivots(mas_mn(mas), mt);
>>> -    if (slot > 0)
>>> -        mas->min = pivots[slot - 1] + 1;
>>> -
>>> -    if (slot <= slot_count)
>>> -        mas->max = pivots[slot];
>>> +    mas->min = pivots[mas->offset] + 1;
>>> +    mas->offset++;
>>> +    if (mas->offset < mt_slots[mt])
>>> +        mas->max = pivots[mas->offset];
>> There is a bug here, the assignment of mas->min and mas->max is wrong.
>> The assignment will make them represent the range of a child node, 
>> but it should represent the range of the current node. After 
>> mas_ascend() returns, mas-min and mas->max already represent the 
>> range of the current node, so we should delete these assignments of 
>> mas->min and mas->max.
>
>
> Thanks for your suggestion, Peng. Applying it literally by removing 
> only the min/max assignments:
>
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 6fc1ad42b409..9b6e581cf83f 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5118,10 +5118,7 @@ static inline bool mas_skip_node
>
>         mt = mte_node_type(mas->node);
>         pivots = ma_pivots(mas_mn(mas), mt);
> -       mas->min = pivots[mas->offset] + 1;
>         mas->offset++;
> -       if (mas->offset < mt_slots[mt])
> -               mas->max = pivots[mas->offset];
>
>         return true;
>  }
>
>
> This allowed my test to pass 100/100 runs. Still in qemu with the test 
> as init, so not really stressed in any way except that specific usecase.
>
> //Snild

Thanks for the test, I'm happy if it happens to fix your problem. So a 
patch was made.
This patch needs to be applied after Liam's patch.

Sincerely yours,
Peng.



