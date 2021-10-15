Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD3E42FE95
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 01:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243483AbhJOXNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 19:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243477AbhJOXNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 19:13:50 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E765CC061570
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 16:11:43 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id y207so15183504oia.11
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 16:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EC0kJnu6bT1KCV0QTTsc1q9gjgvVry2x+/hU79zV+y8=;
        b=ZH6PT1ICNF4TTkAQzEBIlRgueYlRGldJGhK5KII5/zTOk8X2Uyp1zpilDOUx3t+28o
         EZnKcxJz3cW4HpQEFWAdcy5GPhMdW15tUi9M4uPKuDjr2zTRw00xuxOAVPSV2NTO4bim
         YZgSLWgDs8zS+p5J1y6O2OYfJGOzoqUsr0NT1rdPNwWcFXNWWawyzhRxp5ui5P1quur7
         gGFs2mRcGxo95UihU/nZsLjNSpLIEEE3UyY3pTDYui7SWmfZM0sCrK0rXVxGtqZ0irKt
         ENoxTZPniQm5pxm3Sf+MQQCIKp/sgQq9m2CktTtOBtFNfhnPUjrxvzUiRbFSkkTdRU8R
         41RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EC0kJnu6bT1KCV0QTTsc1q9gjgvVry2x+/hU79zV+y8=;
        b=Xxxn5wAJIH9US5CL7VFK2U2bP2qp90wBKvi3+tEnA5Nb0KnwvYAjxW+kvx0p2v9YeM
         uWg8+D6wznL66DGVDoSzqDjPz1nF7kdmofD5SOnNo++4uwWPEpf0zlNY7ycESaDSKsMg
         ztqQlr7Nk9hQKCZ5W+fpJEZPb1QDYOeBIMcBQgTntmp0Ikzce0Xby8W6KPdl+JOs0MYZ
         kbmZCGQosNYMMq1aEOyOfeYSCqUpXeGKoToNsldwvXTygyAxDSjqrbUNQhwFZaMmecBa
         jb1QHAgQb+heqZ8nO7Jrv4U0x1llSZjgYNRNbzb2Vydmqge/IVgM4o1g7rvuVz7+1iDZ
         qGuw==
X-Gm-Message-State: AOAM530d4yjSqXV6jtkXj32ESjlnP/3pDVcoQzy4+8RjPC2Pvk/h4rFj
        scOoxEAYVX3N1jVQx4ekyYA1yVaHgsvfFPKz
X-Google-Smtp-Source: ABdhPJwdl4PYi6aqkad4kJV0X4BJyQf3As8t/5DTM41Z3RJ5ruHOJTmIXaVn6PXiM+8IasLbQRRQGg==
X-Received: by 2002:a05:6808:1805:: with SMTP id bh5mr4099182oib.47.1634339502907;
        Fri, 15 Oct 2021 16:11:42 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.72.19])
        by smtp.gmail.com with ESMTPSA id i13sm1556994oig.35.2021.10.15.16.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 16:11:42 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/18] 4.4.289-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211014145206.330102860@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <0dbedba1-a6b7-89b3-2ba9-23f0c0afa60f@linaro.org>
Date:   Fri, 15 Oct 2021 18:11:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014145206.330102860@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 10/14/21 9:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.289 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.289-rc1.gz
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
* kernel: 4.4.289-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.4.y
* git commit: f9c6c370e0b0668289ebd46e9b1311e1a8b6e7a1
* git describe: v4.4.288-19-gf9c6c370e0b0
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.288-19-gf9c6c370e0b0

## No regressions (compared to v4.4.288)

## No fixes (compared to v4.4.288)

## Test result summary
total: 53612, pass: 42920, fail: 246, skip: 9117, xfail: 1329

## Build Summary
* arm: 128 total, 128 passed, 0 failed
* arm64: 33 total, 33 passed, 0 failed
* i386: 17 total, 17 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
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
