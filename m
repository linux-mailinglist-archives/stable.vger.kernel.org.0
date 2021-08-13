Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8957E3EBEB4
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 01:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbhHMXZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 19:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbhHMXZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 19:25:37 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7F6C061756
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 16:25:09 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id r6so11462015ilt.13
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 16:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GLqcNY1lWx29tRz6tDtGrtTW63/gSieX6SyrfvVVVaw=;
        b=hmO83pg4krziR+ZmmNTm16YQ/QgDWBkWyv84pUQbk1ZF2+hOEIeBoXR+iF9g6bUqdk
         6u9JfD1tXGJ85vTLjCbxO0dsJ/e//4ri6n7wXh60NdBI9a3/noNzRVlUMWICUIyj0w3d
         D2/Dp/N34X6xQ/fSlSec0BCqDYwzp7F0Loy+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GLqcNY1lWx29tRz6tDtGrtTW63/gSieX6SyrfvVVVaw=;
        b=LkKYTg4mPeYSZlXuM5jOzXojaEg0IijQXyh5cYSka297Ki0yWCTisIaGNBLxhhy8yL
         FFK7MuQq9tV7vQfekJPxwCr5ERMeH5O8XcmoJ9CQ0qry3h6leiE4PnN56vZBkZC9uJNk
         biWgLCbVKO2EyMSFq0eM9GNUkYhDN4XmNvUqBt+XwUORNCZnmuFInXNsScaNDjfTzT8u
         /pmrKhxN0J0MuEKjCpb2mCjb3XEfTU382YtJ6GuUS5/c6lzxIKBZggwyPVL7jmdCxzUQ
         Y3YmyBzmijtPjJYqZZvW1nRUvEGAp8tN5WA98wIyAAThpJf5jZyL1wggYUbvCN/nIAU8
         RvRA==
X-Gm-Message-State: AOAM533IzJJntRPp1fO+I+SZQJZj//XHheWxC/I4pPFFSjZqGgg8q27D
        AJdYK/o9qfNp4vvUhI7m+QwHbA==
X-Google-Smtp-Source: ABdhPJwnXLOsAX+tCyhNi18g6k4LKXrkWjVzSl2DBM0Nqd6tF4lBRAgQrp/RXjqOucxWS/JOjP4jtA==
X-Received: by 2002:a92:7b10:: with SMTP id w16mr3629099ilc.241.1628897109405;
        Fri, 13 Aug 2021 16:25:09 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k10sm1500897ili.86.2021.08.13.16.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 16:25:09 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/11] 4.19.204-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210813150520.072304554@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3f77c952-337b-7169-a0c9-0071c037c143@linuxfoundation.org>
Date:   Fri, 13 Aug 2021 17:25:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210813150520.072304554@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/13/21 9:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.204 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.204-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

