Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D816A7AB5
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 06:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCBFEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 00:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjCBFEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 00:04:00 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29B2199CA;
        Wed,  1 Mar 2023 21:03:55 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id y140so6316518iof.6;
        Wed, 01 Mar 2023 21:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677733435;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=60KiwvZdrd5AeMfhMB0UQ2jGnQsEY9nBrdTLeaIqZc8=;
        b=YQb2Tc6xUYMwD5jy5ws5Z6BBD2vvW+xGlhbhl1MRgD5nIATeryJlKNOYYNWS68T9ZS
         PICn4ebH40imbnivO08m4y8r10Ta6rLBnFGWKRcQhq2vgxoosCKrywV4f0ImnytsvIcZ
         uhBCMowvwHMZ2yAP8k5MgnZ4JbJnKPm4vOiikZjMNfrEDLsqC4R8RFnA9wPOw1IDzwZ0
         N6NlCOYJ9IVwX/1oOSN86g4oybz6GlfFr5GIR7PcToG6WpVcxH9m22cODJhHZEy9u2EL
         x8srfS+aD9hrh8+JivIbYEF0IDkRxqMee3351sP9nYdz0eREhFX3JTkxdTlNeyq3gHOj
         7Zig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677733435;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60KiwvZdrd5AeMfhMB0UQ2jGnQsEY9nBrdTLeaIqZc8=;
        b=wDxjZaikr+OYlkICKgwDSCeX+mKolNhpt2UPTfq09ReTbcbG1V+JqC/R+ht/D4tCbQ
         1XxHmdLLyUDqIcLlHyYHV6zvxquIds0IWef5R2iDKYnVzKu85EwIMQkUGG7txi4P/ir+
         55TdW/+YFbN1dJd3driYWTayXgeVQfFQl0ZEIG9mUGzg3TXrw/KhAAxDQSSLwya7ZxAn
         NiY9+Vj4WHpmAfBbb/FVliFIWNXm/BF9VR8hN+UMK7Ttw10wevKXK2NNyXwZdY+2fJZg
         zmkccqZCwJIW1JOgS0LuPJEH4iunWn9g1qn7X7FRyCAblDyuJ3ERnkf+H9aGCRuMw4G2
         0t0A==
X-Gm-Message-State: AO0yUKUlnPu0Ec7JzHmCgAzeTHk6jRS4J0P0oZWGOczBxQsOGd9mFuNf
        KKOOZqBW+IuqU+8vSv68oGU=
X-Google-Smtp-Source: AK7set8dxvsQtH3UTIE69eB/Ys8SNqOnqCRjIBgGXm6Wh+uG60ykBK/GvpmTMEHaEsMNFSgcWLl6EQ==
X-Received: by 2002:a05:6602:81:b0:743:7742:1bc2 with SMTP id h1-20020a056602008100b0074377421bc2mr6664282iob.16.1677733435027;
        Wed, 01 Mar 2023 21:03:55 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q5-20020a02a305000000b003c4840bfd6fsm4320316jai.75.2023.03.01.21.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 21:03:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8e32bdd6-652f-f7db-15a0-9647f74275a1@roeck-us.net>
Date:   Wed, 1 Mar 2023 21:03:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Slade Watkins <srw@sladewatkins.net>, Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kuniyu@amazon.com, stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
References: <20230301180652.316428563@linuxfoundation.org>
 <Y//Lw/zL168J3spQ@duo.ucw.cz>
 <31339d95-a318-ba2e-fdb0-ea7b102fd6fd@sladewatkins.net>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
In-Reply-To: <31339d95-a318-ba2e-fdb0-ea7b102fd6fd@sladewatkins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/23 14:09, Slade Watkins wrote:
> On 3/1/23 17:03, Pavel Machek wrote:
>> Hi!
>>
>>> This is the start of the stable review cycle for the 5.10.171 release.
>>> There are 19 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> AFAICT we should not need this patch -- we don't have b5fc29233d28 in
>> 5.10, so the assertion seems to be at the correct place here.
> 
> This (b5fc29233d28be7a3322848ebe73ac327559cdb9) appears to be in linux-5.10.y,
> though?
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=b5fc29233d28be7a3322848ebe73ac327559cdb9
> 
> Confused,
> -- Slade
> 

Also confused. My script tells me that it is _not_ in v5.10.y, and that it isn't
queued either.

Upstream commit b5fc29233d2 ("inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().")
   Integrated in v6.2-rc1
   Not in 6.1.y
   Not in 5.15.y
   Not in 5.10.y
   Not in 5.4.y
   Not in 4.19.y
   Not in 4.14.y

and:

$ git describe --contains b5fc29233d28be7a3322848ebe73ac327559cdb9
v6.2-rc1~99^2~393^2~4

However, it looks like 62ec33b44e0 is queued everywhere.

Upstream commit 62ec33b44e0 ("net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().")
   Integrated in v6.2
   Expected to be fixed in 6.1.y with next stable release (sha 29d108dc216d)
   Expected to be fixed in 5.15.y with next stable release (sha 07c26a42efc3)
   Expected to be fixed in 5.10.y with next stable release (sha 3ecdc3798eb9)
   Expected to be fixed in 5.4.y with next stable release (sha a88c26a1210e)
   Expected to be fixed in 4.19.y with next stable release (sha 60b390c291e9)
   Expected to be fixed in 4.14.y with next stable release (sha b53a2b4858c2)

Guenter

>>
>>> Kuniyuki Iwashima <kuniyu@amazon.com>
>>>      net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from
>>>      sk_stream_kill_queues().
>>
>> CIP testing did not find any problems here:
>>                                                                                                          
>> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 

