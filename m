Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD7A2EA53B
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 07:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbhAEGIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 01:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbhAEGIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 01:08:39 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6A6C061574
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 22:07:59 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id x203so6828262ooa.9
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 22:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tYMDLoLvQMkoSCOCUG01TjHV9H9vp7Q/U9Rhw7lDbYg=;
        b=Pyg7kBgL9jNM1u+xQ1FZOZK90jvc3D2mkhoNz+wDBSLX23waqr5s4PwHme7iNogrpC
         QAWZwnVbV9C93RhwySziY45zQzJtRwr/84g5BGhVCHxqg97JdrlQJ5lRNXHRGxladj75
         3CkaxQOW2ga/pDMP94hKGadshNrsAYc/37I3ScT78yYxHd+bQ2R0wMykdkw1je7Mzxn/
         BYPPmnAG0QMCZx/w5vI8BVQoyE73MnO82IA4pTG17UhaTZ0FVchcTPw4QAmb54WixgpV
         k6lok4QsGH4qKOj651LpMVnwPsPAbTsj7IlBYg5Eg0ZYTZdoN6V1uYWgKhWTSi7Caec2
         EpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tYMDLoLvQMkoSCOCUG01TjHV9H9vp7Q/U9Rhw7lDbYg=;
        b=SahUeKcBRaf46lVmzxHyTtkaGS/CJwIdw6HLhFaFhyRcrmlY04dpJoO+B9eVfa3JER
         5bnDqJfrSzOJ6CmVTA4oKAID6rUfuy+K7IT2EAfEG8CsrmVSKWCxthuy325e9y2lDkq+
         sXjmhYvIHX8YT3sbG9AW519vvZGDZl9wTuhLB3X/3v90YFu/Ls4+yw3BIiP9a0cqOyZE
         WNTXjV8se6MfLOe/E5dXkZQm7CNQRxIQY25xZIMEKQVyPgEy6wO5x5t8efl4e8ZzVx1o
         kz89GMn6j4JQsSISC6K8zBlh5dXagDzplg4GqCkk2vwPD4VluijHjyQMZxCD+8unAnSw
         xtkg==
X-Gm-Message-State: AOAM531RiQUViej6Msr6TkdpNwPuZGkt5GHo6rkvLC1DDb1CQLCVSutg
        LLjDyN8aqaG0QkWHMvc3Nm3hYg==
X-Google-Smtp-Source: ABdhPJx9C3sbA7NIuX8WPOVcneT3/1b/wpENscgstsZ5DxtgtOwOjeaq+9c7TBi3KK13Ss+19itOqw==
X-Received: by 2002:a4a:751a:: with SMTP id j26mr51645638ooc.68.1609826879057;
        Mon, 04 Jan 2021 22:07:59 -0800 (PST)
Received: from [192.168.17.50] (CableLink-189-219-73-83.Hosts.InterCable.net. [189.219.73.83])
        by smtp.gmail.com with ESMTPSA id i25sm13866630oto.56.2021.01.04.22.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 22:07:58 -0800 (PST)
Subject: Re: [PATCH 5.4 00/47] 5.4.87-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210104155705.740576914@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <7322d006-5030-cd2c-2114-a49efdfe1d8e@linaro.org>
Date:   Tue, 5 Jan 2021 00:07:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/4/21 9:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.87 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.87-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions detected.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.87-rc1
git repo: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
git branch: linux-5.4.y
git commit: 01678c93fa9e3da85a53deb1510c25fdcd2e5d6d
git describe: v5.4.86-48-g01678c93fa9e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.86-48-g01678c93fa9e

No regressions (compared to build v5.4.86)

No fixes (compared to build v5.4.86)

Ran 48522 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fs-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
