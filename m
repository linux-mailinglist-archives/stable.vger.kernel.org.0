Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4263C805C
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 10:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbhGNIjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 04:39:52 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:44564 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238482AbhGNIjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 04:39:52 -0400
Received: by mail-wr1-f54.google.com with SMTP id f9so2137878wrq.11;
        Wed, 14 Jul 2021 01:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GROROvL9gTpopa9rK0I2AZCVqoD2tSZHDr2c/EQ9HJ8=;
        b=gzDjMiKYxXU59AoYgtH+FT1zuWBVw2hFm1koddGjO5NqMDXUVqjm71iOERcROhXiqL
         uPp1xJEJneNmYffZ3GBm/AGUB/NYD/Mq4JlQJnP6Dr39OASohrF5gy/YgzHFf3mu8J+o
         DiLHOFIUA8P25OoksZnSme+MM1/YD/tHrFn5eTHML9737h7SUvU2x8mQKtb4JW5soby1
         Um4C+AdVZf5EocPf+unwhXb/V7JIvhuMPwEVg4Q0JhSxX3KRc79ec/VXbWnAM10By1VF
         Sdgevt0BDPuP/lNKm1CAjTHSQgClshQ5hta7pxoMjy4wQoTvlIOJ2mrmGW2tB4qAIR7I
         O65A==
X-Gm-Message-State: AOAM533YVKPo7Cwh64lnwFoHKl1+QD7M2HNWSFalBBYnjeUz/YaMoqGq
        xZbLNfQv/9gyfi22CPlyuC4vLJ4S7tgxBw==
X-Google-Smtp-Source: ABdhPJxdhFBUJyjXZm21HyX5xoIANyUHLknD4Qe3clWaZoDj9Q/QevlhCLs7FebqTqxJn0JwU1ZDEQ==
X-Received: by 2002:adf:e586:: with SMTP id l6mr11680936wrm.26.1626251819556;
        Wed, 14 Jul 2021 01:36:59 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id p4sm1758210wrt.23.2021.07.14.01.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 01:36:59 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
To:     Holger Kiehl <Holger.Kiehl@dwd.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210712060912.995381202@linuxfoundation.org>
 <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
 <YO56HTE3k95JLeje@kroah.com>
 <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de>
 <20653f1-deaa-6fac-1f8-19319e87623a@praktifix.dwd.de>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <a59b73aa-24f6-7395-6b99-d6c62feb0fc4@kernel.org>
Date:   Wed, 14 Jul 2021 10:36:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20653f1-deaa-6fac-1f8-19319e87623a@praktifix.dwd.de>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14. 07. 21, 10:15, Holger Kiehl wrote:
>> Yes, will try to do that. I think it will take some time ...
>>
> Hmm, I am doing something wrong?

No, you are not: -rcs are not tagged.

>     git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
>     cd linux-5.13.y/
>     git tag|grep v5.13
>     v5.13
>     v5.13-rc1
>     v5.13-rc2
>     v5.13-rc3
>     v5.13-rc4
>     v5.13-rc5
>     v5.13-rc6
>     v5.13-rc7
>     v5.13.1
> 
> There is no v5.13.2-rc1. It is my first time with 'git bisect'. Must be
> doing something wrong. How can I get the correct git kernel rc version?

So just bisect v5.13.1..linux-5.13.y.

regards,
-- 
js
suse labs
