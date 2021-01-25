Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D00303116
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 02:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbhAYThG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 14:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731937AbhAYTgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 14:36:46 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574FEC06174A
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 11:36:06 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id n127so3531937ooa.13
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 11:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wN8bDXKo/sZdUhtHCToUyQ3G6xkD7paHpTxxTd1ufLM=;
        b=WbRk46YONVHeZi/3+ZiWIUaQcnSv9l67FxIgWDrgf1bf+dZuuZOSjD2iUm7tCn7/yX
         pt4UflePxgsbkY74+CGgpvVhgtnvVJdjV8OiYIdYaGUmmLSqnS/uwZqcAijNVlhej3C8
         aiKXJJPjhQWvJQMJgX0RKRNKYO+UErA/3n4J4yFekhI/4oaf/4CJfJALYtlqGDIlpBFN
         0Le7/buE0UrUgqlKxJcmfdxZBPnyC13WsB4MDyu6kSJ6tr7N+7OyrrCPSWSbmJK3SzNC
         VVl7+gTbbRbp4cq9ru6b+J8T3X1a1BYx0O+xweGZlxOLAf2R/vBUdSnQpXk2F8MirS/f
         aKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wN8bDXKo/sZdUhtHCToUyQ3G6xkD7paHpTxxTd1ufLM=;
        b=l/6LN37kdAIz8oja2Jfo8HIru8abLeI5vAm2LnxkRGqG5FkrOZP9rGfgOqVuCGPod5
         +Bmw8Smwt/TnsRsTQsLwfAxDDS9qXAVoSaoy+cKD2jGPdfEQ4+5jDbed0n2WUI23yESa
         u1XmBj/UMvKKwptoiE9OgsLI08ogoOPMX342Dyu7uQO6ShAC0jKHyDYQsuCGcrPQK5jv
         S+XTCHrikk3fOoiZNwx+DaxV79O2/h1AoAy/Xt5IX3oDsL3LkBwEMyVMxd5cf1YEl4oR
         sV6fqUKlyIe6rGbMxkcaOXrz9ZsrQ9n2pdH+1HnIyqzdXuGqfW5E8Z0hPDUyBwt7jjhT
         kM8Q==
X-Gm-Message-State: AOAM531JcfJQM7hp85gNLs1+xwwLtFoDRDNQ8NhcUxgJ+xgM2E3CW7tr
        MlHF2J8GDO/yvCtj+GrqxSabgQ==
X-Google-Smtp-Source: ABdhPJzucnNcQz80GA4WZVw/O/3diSasE4sizJswZ3mk6abs9v0QeFWG5Y+BVHw9DPLioim8kXZt9g==
X-Received: by 2002:a4a:4f88:: with SMTP id c130mr87535oob.60.1611603365685;
        Mon, 25 Jan 2021 11:36:05 -0800 (PST)
Received: from [192.168.17.50] (CableLink-189-219-73-147.Hosts.InterCable.net. [189.219.73.147])
        by smtp.gmail.com with ESMTPSA id a71sm251051oob.48.2021.01.25.11.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 11:36:05 -0800 (PST)
Subject: Re: [PATCH 5.10 000/199] 5.10.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210125183216.245315437@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <ef5b0670-83ea-e754-033c-2f3f56a8c822@linaro.org>
Date:   Mon, 25 Jan 2021 13:36:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!


On 1/25/21 12:37 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.11 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Sanity results from Linaro’s test farm.
Regressions detected.

Summary
------------------------------------------------------------------------

kernel: 5.10.11-rc1
git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
git branch: linux-5.10.y
git commit: efec2624e657b370b1621e8514a1fa6d65eb20a0
git describe: v5.10.10-200-gefec2624e657
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y-sanity/build/v5.10.10-200-gefec2624e657

Regressions (compared to build v5.10.10)
------------------------------------------------------------------------

x86_64:
   build:
     * clang-10-allnoconfig
     * clang-10-tinyconfig
     * gcc-8-allnoconfig
     * gcc-8-tinyconfig
     * gcc-9-allnoconfig
     * gcc-9-tinyconfig
     * gcc-10-allnoconfig
     * gcc-10-tinyconfig

i386:
   build:
     * clang-10-allnoconfig
     * clang-10-tinyconfig
     * clang-11-allnoconfig
     * clang-11-tinyconfig
     * gcc-8-allnoconfig
     * gcc-8-tinyconfig
     * gcc-9-allnoconfig
     * gcc-9-tinyconfig
     * gcc-10-allnoconfig
     * gcc-10-tinyconfig


No fixes (compared to build v5.10.10)

Ran 704 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- i386
- juno-r2
- mips
- parisc
- powerpc
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* ltp-smoketest-tests


Errors look like the following:

   make --silent --keep-going --jobs=8 O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc' 'HOSTCC=sccache gcc'
   /builds/1nZbYji0zW0SkEnWMrDznWWzerI/arch/x86/kernel/cpu/amd.c: In function 'bsp_init_amd':
   /builds/1nZbYji0zW0SkEnWMrDznWWzerI/arch/x86/kernel/cpu/amd.c:572:3: error: '__max_die_per_package' undeclared (first use in this function); did you mean 'topology_max_die_per_package'?
     572 |   __max_die_per_package = nodes_per_socket = ((ecx >> 8) & 7) + 1;
         |   ^~~~~~~~~~~~~~~~~~~~~
         |   topology_max_die_per_package

Will find out more soon.

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
