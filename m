Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B520F2EA531
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 07:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbhAEGHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 01:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbhAEGHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 01:07:23 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8CCC061793
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 22:06:43 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id b24so28383591otj.0
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 22:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ov1BW2jrSogHx5WA00oTYWFFaSTIwzL0Iboyie4P7Y8=;
        b=roTsOt06ODtm2Dtfmfti80j17SR6WoOHQzAXza1AVJFv0RlEEUrfzSllVUihzl11sf
         K+JCZIM4/LVlZ3YDxUkTEMCEo2hnFY4IApRjQTrbs/mERB+WsOkNsiQb87B1TsVTjwbU
         9BM2sKmEgmIanlxwaYg54TuXPdJ0apJrPwtokcsmQqnSyu5hRP2IxEed6gGOXV8BDPU8
         UQCfOjXwnqHJLQIIRgSDqjvUiO/8VFu5jtlxHnJR8uqctxDeMNJrQcGaDkenXMMu5WsJ
         emV4C+fFFCGPKBD40yEpLBKiykwYOTOD9AQC9FLhyEOXVS4zkErgPWkgUiAz6qIuzQW7
         TeAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ov1BW2jrSogHx5WA00oTYWFFaSTIwzL0Iboyie4P7Y8=;
        b=FgcVJuqeMwK7iFMvMRh5YzDcaK+irqbIZgLo1/pKsmNfHSYbNJIe31QbCaSqrXgF7C
         YdWetGvrNmUf7tHyfLpooiVjS83k54v7KAmTpCVVGEFJaTjt7sGLHotdEcgxFf0fdOtk
         xTIvPlQdoqlb2gLDXQLj5BR1+eIOdpAB90NZubGNURxj+bV7FXY39xXbSJiYDxUI1W1Z
         Md6A4N6Sb4dmoYtMI01M2GUStzRkV8mU3YgWODwBmSmaDq7wZFHLXQrMNcrcctIYWrV+
         LoMTlbM3U2Z3hRUEA746oN0UklXoaacRCcHLUoRMZxjKevjqk8qYvWE0GFXc4q4rjg+w
         HQqA==
X-Gm-Message-State: AOAM531fENSyRZioFLVJfys3ZdQan8zKbmJhN6cdxlWL+6Xth5nsol/s
        1mCHLsB0RnXIZHk1OeZvOpC06Q==
X-Google-Smtp-Source: ABdhPJx1sYejqOWDEftFo2DD5+NPWs9P44vt9wG+wHnleaHZI+B+5/LZG4X6vzLI0xmShKtdYqGMCw==
X-Received: by 2002:a05:6830:10d2:: with SMTP id z18mr54715963oto.90.1609826802321;
        Mon, 04 Jan 2021 22:06:42 -0800 (PST)
Received: from [192.168.17.50] (CableLink-189-219-73-83.Hosts.InterCable.net. [189.219.73.83])
        by smtp.gmail.com with ESMTPSA id x20sm13675682oov.33.2021.01.04.22.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 22:06:41 -0800 (PST)
Subject: Re: [PATCH 5.10 00/63] 5.10.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210104155708.800470590@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <d13294c0-84b8-38ee-d92c-4025b30929b9@linaro.org>
Date:   Tue, 5 Jan 2021 00:06:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/4/21 9:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.5 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

kernel: 5.10.5-rc1
git repo: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
git branch: linux-5.10.y
git commit: 18347c4f07814f2fef15f3b1518b6b8a88bae75a
git describe: v5.10.4-64-g18347c4f0781
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.4-64-g18347c4f0781

No regressions (compared to build v5.10.4)

No fixes (compared to build v5.10.4)

Ran 53801 total tests in the following environments and test suites.

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
- qemu-i386-clang
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
* kunit
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
