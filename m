Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6CB2E7386
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 21:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgL2URf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 15:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgL2URd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 15:17:33 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A27BC061574
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 12:16:53 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id o11so12905241ote.4
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 12:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8/ff/aC/FhYEg52rqnXpLoUks3WoQxxG1cMVlDozpaU=;
        b=x5tXRrCUmPqoAHYnFM5l7WEJv/r9L1hCwRG0EgRdosgP1OgQXTy66XjccTckZ/yndt
         4rfKYGmjl+khza2KyQguPE/MZC215djf138sF1RDdbjjDjd7SUMUFPvyTo8EfugZAFqi
         Edin5dcBoKAU4EywLnF9uA/RXEzvdOEdgBYiB2eQRps5Cj1sigIxZPO23b7/cdhn/e/v
         20CI5dW3F0EMMw+wMRPoB6xTOAyM2RXVYUU1PD+cjCf/Uixywgr3sICImkLxMJuNPdjL
         Ig2KS1J3BOUe/W5/ltS97G9q4F7mXWzq/hgEc/vC+fbdLj8+I5/WRFPg8O32MU1fAiPF
         A67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8/ff/aC/FhYEg52rqnXpLoUks3WoQxxG1cMVlDozpaU=;
        b=Znc0nME19zvKLPxip/YJNpYtwAj5w0+H1XT6Itz7LE5Ecp40gAqubUKpdB15FP/zSu
         FDceGNof0v2BqlyiC3b+lOwMOuMUYmiJi3FcNVS0BF8bYCR7VosecdwVIVFF7gpi0gFW
         a/0Q+XvLreDw/WfkCHIoPosgqHNvTY5DqbIhYzgZUr9oFxBGbDSnU7JN3lcUVCsOUbVb
         psh0kVyMkPkPNokNFXMzZYGPXl42WFwoM4pfoZG7bXCxyKQ1V3xwWGaKKcir4VcpxVR0
         2WB4v0/jmTDJj9xe/aPm7l0ZwLYyuIH/gIYedWzVsauGSick4JmAiFneCDOZNeO6CA+S
         STEw==
X-Gm-Message-State: AOAM532c+IFaeXGusNmH3wgRe1EddzG0kHUZvcmFHoVNoggyuVMUcq6L
        hb2mH+UZa+t9Us/Pat1Fi2HEpw==
X-Google-Smtp-Source: ABdhPJxKumJC6mzfR9r1ZhYYuJaUFurnw/1OUTdKkOqcYu3tKhJ7K0CksMbCXe3nC6OqOPfMyzOZDg==
X-Received: by 2002:a9d:479a:: with SMTP id b26mr36730205otf.297.1609273012821;
        Tue, 29 Dec 2020 12:16:52 -0800 (PST)
Received: from [192.168.17.50] (CableLink-189-219-75-19.Hosts.InterCable.net. [189.219.75.19])
        by smtp.gmail.com with ESMTPSA id c204sm9819205oob.44.2020.12.29.12.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Dec 2020 12:16:52 -0800 (PST)
Subject: Re: [PATCH 5.4 000/450] 5.4.86-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20201229103747.123668426@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <e2c7797f-1a92-0082-b41c-23d11a0c73aa@linaro.org>
Date:   Tue, 29 Dec 2020 14:16:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201229103747.123668426@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 12/29/20 4:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.86 release.
> There are 450 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 31 Dec 2020 10:36:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.86-rc2.gz
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

kernel: 5.4.86-rc2
git repo: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
git branch: linux-5.4.y
git commit: d797ea26c4313e38eb3eaddba53ae3316eae7a98
git describe: v5.4.85-451-gd797ea26c431
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.85-451-gd797ea26c431

No regressions (compared to build v5.4.85)

No fixes (compared to build v5.4.85)

Ran 43508 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
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


Happy new year, greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
