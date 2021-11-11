Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAD744DD25
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 22:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhKKVjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 16:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbhKKVjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 16:39:01 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BDAC061767
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 13:36:10 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id y16so8689945ioc.8
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 13:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E3VV7uh5c+wN1000HyR81BxkFplBNT0BtJEN5rQLMHU=;
        b=ACljz+RtrdcqkNXyR0qeDDk5tm0T9Zxc99IxB3oC1d/Ai9hznTfbj23gljrq5IHtIt
         D3wjk2FBl9KhpYSEs5ir63UXTEAjiYulXq5D0DhVSrkACE7qjhVlQIlEuyvIjiH02IBx
         ul6kJpeN/LIeAAXkn/Vil+HWWQxQYvrTgzNW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E3VV7uh5c+wN1000HyR81BxkFplBNT0BtJEN5rQLMHU=;
        b=40FwZOOpASTm1rWVWQZdvkDHDquuu6gWN+hxdJVp6nwBoQ+kQXkk5nzw+GFD/D9A+i
         Yx/FTu+x6teWOTVOFNKVNxH03Mk29OT5ouulfCfTEy6iG+MkHX2pzcJFGJcRiHoKQqim
         ZT8gW7xr4Ic1dVfpphZyKl6WhyGyuPaelq9uTA2IqLi/f1AWgODV0/KfgAG1YnDXqRnC
         Yn9/cp3+8ILQbBu/66yCd3C95IYywoVD4XriJlVrEpyws54QEGO2KYElIunxNPgCObHa
         NnjEdxYwn0hIFxkO3qJIasHDIjS0Eyg1ULhJcA/jpR/yZi0aq/P9pSDwNtUiG8CqDdvJ
         f5WQ==
X-Gm-Message-State: AOAM530b11FPEYUkSOh1y3QfMSONPgiB8amVo8S4XFBBihxVwRZI74ic
        D4hv1N9SGFWkls11sN70Nzx1WQ==
X-Google-Smtp-Source: ABdhPJzGpTK9ZoAxZwfjMH08M6bq9mSGFtC4qBO3A7MsfI4GKH+tGLc/mR9+DaABJ1XjACRCLmv5Yg==
X-Received: by 2002:a05:6638:2487:: with SMTP id x7mr7797197jat.94.1636666570207;
        Thu, 11 Nov 2021 13:36:10 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y1sm2658825ilp.43.2021.11.11.13.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 13:36:09 -0800 (PST)
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211110182002.964190708@linuxfoundation.org>
 <YY0UQAQ54Vq4vC3z@debian>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dc99862f-f4a5-4351-e4c8-43237238377e@linuxfoundation.org>
Date:   Thu, 11 Nov 2021 14:36:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YY0UQAQ54Vq4vC3z@debian>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/11/21 6:01 AM, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Nov 10, 2021 at 07:43:46PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.79 release.
>> There are 21 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
>> Anything received after that time might be too late.
> 
> systemd-journal-flush.service failed due to a timeout resulting in a very very
> slow boot on my test laptop. qemu test on openqa failed due to the same problem.
> 
> https://openqa.qa.codethink.co.uk/tests/365
> 
> A bisect showed the problem to be 8615ff6dd1ac ("mm: filemap: check if THP has
> hwpoisoned subpage for PMD page fault"). Reverting it on top of 5.10.79-rc1
> fixed the problem.
> Incidentally, I was having similar problem with Linus's tree
> for last few days and was failing since 20211106 (did not get the time to check).
> I will test mainline again with this commit reverted.
> 
> 

Reverting mm: filemap: check if THP has hwpoisoned subpage for PMD page fault"
worked for me on my test system.

With this commit boots are long and shutdown was at the 20+ minute m ark when
I powered it down. This commit isn't in any of the other release candidates.

thanks,
-- Shuah
