Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F332EB560
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 23:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbhAEWa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 17:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbhAEWa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 17:30:26 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AA2C061574
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 14:29:46 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id j8so334612oon.3
        for <stable@vger.kernel.org>; Tue, 05 Jan 2021 14:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tzwPnllRGpPq+JMC2/C6n5zcPtVFcgP7qaRdi2p0Kuk=;
        b=bXzwDDt+YiVG4+6CrlSbMFPNRn4/7LFzmfI6N6qeitk6XcRWG6zQ66mre5UQ3oWP27
         ikQltLzmfPJ1nlwTewgj3AhFZBtMqNq/PcRqp1YuY7pR0IJ+k49/av6fpjP8fzrnEYgd
         ZPXDvvSAF/WW/HFRS44MEc3Zcc05akK8KZQWra3uvyukaQVWXmtrb1k3K8n+H+Gj0hkd
         A0BJAN52m2StSC6g3yty0agYV6qriKn0uCsJxt0lg9LBB6I34SovG1uJg4Hur6LkI+YL
         5Mhkwgv19AW9/LdaSEn+sAH+5OPMAtuP6hn53o3Z974wjMmTRpMLSMaMbbm+KZ9yiaqF
         c77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tzwPnllRGpPq+JMC2/C6n5zcPtVFcgP7qaRdi2p0Kuk=;
        b=hLUu6e+IQ+P7+kdM51K/gmLkRI4U79KWHfp3wsSP8rSoD9DHqz57q1WpPQqXZgmOWZ
         TYvN2fzxUs2639nXwKa0/IMLKryE0CD25esIrpKzMOmw1w8Dflp2HznqifDsmeZ+lj3z
         eLMdFdjLQU0/TufQy48G1SNqLEL6N2iZv5vIAW3fJ8mrRRg9yTUcqcNNBYr1rN/+taXc
         kRBEWXjtzx2Mj475DXHCe+sH0otdLuLE6vZXrrI22t9+0+kXeT0J9I0NDco7LDyJ4Dhr
         1rK+NpoeIr4k0SbGGLUfe+R5skjIts3fxipBr4K0ig9mTwIfJ1TEA2Fv2T8kEEYQW6cO
         Dp4w==
X-Gm-Message-State: AOAM530CKLau+pNCCrF4v3boOLR88CrUHRp0sSKRGwl3/I6U3y2vuwW5
        OxiItlqKH471XQBzH8OcbxwpOQ==
X-Google-Smtp-Source: ABdhPJwOnPtsiGBsasM2Z1tuNjYR9CIJKcySfhP2VdmczTkyNOAs7debEwchFzhJxqdqwwoa3bLCLQ==
X-Received: by 2002:a4a:da44:: with SMTP id f4mr905753oou.84.1609885785615;
        Tue, 05 Jan 2021 14:29:45 -0800 (PST)
Received: from [192.168.17.50] (CableLink-189-219-73-83.Hosts.InterCable.net. [189.219.73.83])
        by smtp.gmail.com with ESMTPSA id a26sm149973oos.46.2021.01.05.14.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 14:29:44 -0800 (PST)
Subject: Re: [PATCH 4.19 00/29] 4.19.165-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210105090818.518271884@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <6e2c8118-fa1a-1b56-a969-73501b002bcc@linaro.org>
Date:   Tue, 5 Jan 2021 16:29:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/5/21 3:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.165 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jan 2021 09:08:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.165-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.165-rc2
git repo: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
git branch: linux-4.19.y
git commit: 40a2b34effd3cc1b96cad6ef78e18879d4145c09
git describe: v4.19.164-30-g40a2b34effd3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.164-30-g40a2b34effd3


No regressions (compared to build v4.19.164)

No fixes (compared to build v4.19.164)

Ran 40433 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* fwts
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
