Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44342483571
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbiACRSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiACRSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:18:02 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E80C061784
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 09:18:01 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id s1so71237648wrg.1
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 09:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JJRevD7s7IvUrHy9z67ojL3WjCpHVCxtUnkSqkGfeT4=;
        b=TD5FlY8aQEXiDd15dFrpj9/W4NvQaq3DyZs/XKDt3WSSz6EnU9NhRRV4mS2mNvMo2E
         VRdaWJezADIegSHNXDa3feSIImRQJBXFphmz6AZEibjHmcO27giJc5JzddjOnxG7/FIb
         KAuiF1BgDgqmVT7XV5tlAsbrVeeR80FUUqjXgGFYT/3OeAPmZZ6rK6oJZbjkdPlEYa8T
         4LnvKo5bMOjCFIQ7XoUNMHOhnDBBqwTr8BTQHFDidSvgEgE6ZDHaiw7njagqV6Goebn4
         iqLBSzkXDq+8aVZZl3x2YI51rOVd4zPmkJn/gKxReA13LPryyaJgwEpkeYR+7JP6J2H3
         Ts2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JJRevD7s7IvUrHy9z67ojL3WjCpHVCxtUnkSqkGfeT4=;
        b=AXEVNc1LDlZjOtpQo58sMwMVMcp9EfqkdKYFy8DDzhyYSfqRVcRQVJr359BbSLsHEB
         eI60NbWaT+gUFuAkdRp/fJpIotWCabeoxt9kcq9GQYpzcbdUdDWHU4aktZE4TGpB8XHU
         9mm2h31PJnjpmCX1eh56EP4ivHq8ZLNyxRGXmy8c7kjQw3tOOXtrOj5fL3aUraKRFkEM
         kO19sg6FeESh+wbyolKkHZ4q7MEwG04QvKEUnebXGWCJMFHJGNlJZH5B05zvhDNeH4i9
         akHi1KYYZXubJbAR5fiOMHYUZCRjLaGCTG2UjHsTtaE+HvYHQGWGtAvW6zJE6J6fkD/Y
         thIw==
X-Gm-Message-State: AOAM533pRB8pu+aX8oSclwEz6c/02CwT9HWHdxMaJ6CKEOcVEy65Okq7
        0xB4m+ROGZDSNXrOtgglinNLAw==
X-Google-Smtp-Source: ABdhPJx8KWgGxJJtHBhUia8SBWTVdHIV5WwTcCVWOJMTXP2BriqdoS5S0zTj4MK+5/mW04gaQKtbpA==
X-Received: by 2002:a5d:59af:: with SMTP id p15mr40048704wrr.422.1641230280166;
        Mon, 03 Jan 2022 09:18:00 -0800 (PST)
Received: from ?IPV6:2003:d9:9704:eb00:21bc:9895:cbe3:1ac? (p200300d99704eb0021bc9895cbe301ac.dip0.t-ipconnect.de. [2003:d9:9704:eb00:21bc:9895:cbe3:1ac])
        by smtp.googlemail.com with ESMTPSA id j13sm40504780wmq.11.2022.01.03.09.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 09:17:59 -0800 (PST)
Message-ID: <2cfe35d4-3220-dd60-88d3-90b86eb5084a@colorfullife.com>
Date:   Mon, 3 Jan 2022 18:17:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] ipc/sem: do not sleep with a spin lock held
Content-Language: en-US
To:     Jiri Slaby <jirislaby@kernel.org>, cgel.zte@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     stable@vger.kernel.org, arnd@arndb.de, chi.minghao@zte.com.cn,
        dbueso@suse.de, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org, shakeelb@google.com, unixbhaskar@gmail.com,
        vvs@virtuozzo.com, zealci@zte.com.cn
References: <63840bf3-2199-3240-bdfa-abb55518b5f9@colorfullife.com>
 <20211223031207.556189-1-chi.minghao@zte.com.cn>
 <97e94a27-6f9f-1a21-cf3e-11d97f74cbd8@kernel.org>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <97e94a27-6f9f-1a21-cf3e-11d97f74cbd8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jiri,

On 1/3/22 10:27, Jiri Slaby wrote:
> On 23. 12. 21, 4:12, cgel.zte@gmail.com wrote:
>> From: Minghao Chi <chi.minghao@zte.com.cn>
>>
>> We can't call kvfree() with a spin lock held, so defer it.
>
> Sorry, defer what?
>
First drop the spinlock, then call kvfree().


> There are attempts to fix kvfree instead, not sure which of these 
> approaches (fix kvfree or its callers) won in the end?
>
Exactly. We have three options - but noone volunteered yet to decide:

- change ipc/sem.c [minimal change]

- change kvfree() to use vfree_atomic() [would also fix other changes 
that did s/kfree/kvfree/]

- Modify the vma handling so that it becomes safe to call vfree() while 
holding a spinlock. [perfect approach, but I'm concerned about side effects]


--

     Manfred

