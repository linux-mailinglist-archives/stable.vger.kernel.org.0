Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A65418A3B
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 18:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhIZQmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 12:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhIZQmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 12:42:02 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59732C061575
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:40:26 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id g62-20020a9d2dc4000000b0054752cfbc59so15281086otb.1
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hiT35+Z9DjjnkBRIwgszMmQHbQo8aJBH3m4+9c6YEuk=;
        b=blZeGvK3L8rZQoEbhd7hEp1v2mawOi33DSvN2EobPDh6uBpoEjMepgZ7eOozHH0c8g
         umw7MW+tRoYb4ECBw9eVrwmKyOpsY0fnQ3xvUDrGDk1GL3iZID+wGQ8Y2foRqeC7BcF5
         gTSKFRB5R4hyga6XpO0AsFGLUSS0LfXshJXO1ad7LPuLHofmXUhm78sT59WIwQTiDMj1
         23Zjpvvqaa9yhqoPHWJW+mWy88dnmfM96+8VNcS+b1KSZbNhmGI2gVUfelhAfTYuGbEy
         D2f8lTwbm9dkASHIc+hfV0ipdsOXrkqwlTqliSZCedqyz4Y3VdZ6BJH6GhvrFrZkiRjc
         +ysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hiT35+Z9DjjnkBRIwgszMmQHbQo8aJBH3m4+9c6YEuk=;
        b=CdzCIr9fKF43nHN5fNabELHJSAds5YRm+Zgl8uN+YBce99XOlCWmVXRvQXlpxM75Yj
         jf94vujbTgxMRed62rsSNo2PsoDROwlkdQtnQWpmur8HCZOq/zVeEvRMM6sK8OcO0c+x
         gRHn2sGaXClahN0SiWcpv/N2H1vZaeCb8lTqxvLS1lQreqBc5LXBO4SrGX6lQjq12Hs6
         fqrAUoJd8gFLnfe5xsMudbWwtdyU4U95IV5C+nY7PoC8gFwoKJvNI+Xw7NbCafrBjWvV
         OoYioCbBmuO175PIKMv6GmiTXrmGRvQoQhO6g8SMV7RKThbij/EILRm1LXmMVLpX3Xam
         3W4A==
X-Gm-Message-State: AOAM530Y6ySQ3xY9wUWDhZEh7dmdiGfFadeuq+eEX+5TIy4rOLiueVfe
        3y21AlS7yYkYJLYtWQqrxudcJ1AENFqzj2zZSIM=
X-Google-Smtp-Source: ABdhPJz4FErXVXercRc7kAhqD+2Y85ypTRvHtXMNCefJCPj65JnCTqrB9ygNxFqWU7YLStA/XpATEQ==
X-Received: by 2002:a9d:4c0c:: with SMTP id l12mr11001163otf.144.1632674424006;
        Sun, 26 Sep 2021 09:40:24 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id i23sm3345477oof.4.2021.09.26.09.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 09:40:23 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/22] 4.4.285-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210925120743.574120997@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <dcc77a8c-4362-d7c2-a245-f2849b74d178@linaro.org>
Date:   Sun, 26 Sep 2021 11:40:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925120743.574120997@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/25/21 7:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.285 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.285-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.285-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.4.y
* git commit: 0ff0015a9e715ab4808cfd7f9d6e42665131adbc
* git describe: v4.4.284-23-g0ff0015a9e71
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.284-23-g0ff0015a9e71

## No regressions (compared to v4.4.284)

## No fixes (compared to v4.4.284)

## Test result summary
total: 43604, pass: 34654, fail: 200, skip: 7715, xfail: 1035

## Build Summary
* arm: 128 total, 128 passed, 0 failed
* arm64: 33 total, 33 passed, 0 failed
* i386: 17 total, 17 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 17 total, 17 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
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
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
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
* packetdrill
* perf
* ssuite
* v4l2-compliance


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
