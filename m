Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4723CF0E0
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 02:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbhGTADQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 20:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350766AbhGSXvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 19:51:46 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752AAC061766
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:30:39 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so20123172otl.0
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JBEFIV0XL2J68tzt17US2OdqB56YyMOePx3AQtfIwJQ=;
        b=K2blgaSIjlMuyqQGzioBpYDipFPjiHST190MEURx0Htl2v0Glh/2sm6Xas+k4y0MTt
         XkYsgt91nO+Dtp4+4ZFfKrPIuDN7cq78PBccpKsZkfpGEI4TYIGQsuDyvTnCu/z2IPww
         6Qx3qHiHeRVHLJ6OLYm6lRkcK/DlbDQBYH4So=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JBEFIV0XL2J68tzt17US2OdqB56YyMOePx3AQtfIwJQ=;
        b=bPxMP3w37vAQ7gCaVI72X9UV5S7p3SpJM2al20bhUy3ojQHPBQfKVuxVN5aOE70H33
         8rjXhVYYrmFN157CgnxkCOu9djx5Xis5Em5h6gbNdTN4qv4ua5tNYAUt4NZrqwNUwjop
         /Fg8AZr8A+3nVlE8DqhIewNwNJrNpSyrZEFBURB0F1/1Jd8BfIz2ARQDNNS1AXuo3UMV
         TAvInXMf7O8lsHqQLc8N/0s2xaq+vEZgjBTcwA2XKOu1uT3TejKVRXxe0vbkErcxueMW
         0ExZNsbel+tmHZY+ci2/sRo52iyQZoJaKSCFxWriOwGyT/fTTbJB+OnqUFeO4bjeWv40
         CU4g==
X-Gm-Message-State: AOAM532nBTXjY92yOdQjzGh6dvg9+ptUvVUUsNv58Z8K/WBz2uJrtoB6
        1A2jO/jwo4kda+ZMVk1LGwLqvQ==
X-Google-Smtp-Source: ABdhPJwUWlQaf9ATPmJ2XgrLGFvvJUSa1/b7u9NQyC+EtY6EWufREDttC8UEsNFuar+wDv9VbIXIbQ==
X-Received: by 2002:a9d:650e:: with SMTP id i14mr20409210otl.233.1626741038873;
        Mon, 19 Jul 2021 17:30:38 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t16sm2928410otm.63.2021.07.19.17.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 17:30:38 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/239] 5.10.52-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210719184320.888029606@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f04cb3c7-c4a1-734e-d640-6f627e5e812f@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 18:30:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210719184320.888029606@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 12:45 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.52 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.52-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

