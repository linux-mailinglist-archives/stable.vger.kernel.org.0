Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65B8418A33
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 18:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhIZQi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 12:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhIZQi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 12:38:26 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF22C061575
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:36:49 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id x124so22204467oix.9
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+PwoPfrBXhuENmO4UvDtCtWNHZJkA+z8L0PJ9FCOS6M=;
        b=AsMgaRu4IplmW6aI7AgiWK/gt+0cSIWRgAywabfsqZ6djQyoP0JrzEzz6MA2ue/TkE
         +CXYZ8NYCWXBhWtvhu4Tbgxc052NAIEdRwzl245H1DdzHUEL+LgCzhR9wAUFVmlhCSpO
         ZSHxC/1xv0GkLVOanCewLYy1f1qsIeBaiGK3QMS284WexwSe31OEsHC+hIc9nSdPm+4x
         eCp2gLweX5/1Jw/RR4jCOkp0vEOf64F5uXzI7ZDMCgjXyNH+Y5hEGBbsKgvRNVTwxZ45
         ffqR4KysHShCjYTkb+DqkVUL//CtnteqWnu14T5mA0m07vQ0x1ywltmtQKQwEn1qAdIp
         g/rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+PwoPfrBXhuENmO4UvDtCtWNHZJkA+z8L0PJ9FCOS6M=;
        b=UO+Ei5up/dcE6UIyA3pScGJKBxTMyVSF6qr9g74Y2ZeBF5fwNT5Ut5XVq3N7whi1ak
         7VDHaRw58nf1rlGKuIgAqRsrLsVxKobOCshUOjyP9tNI9bw/aGyKravmKoO7ou885e6n
         DUyRjtA16LP9grTQeoKcFBde7kxqmsXgiirCIBit20zQk/hod+VuZqvrcdktyEs7F06K
         DeLd+0+AgyUPqi6NXm6PzeJ4f3zdvzyOmNGvQ41w76vDUf4AY3oX6CSVL1gYK/ZkJSjo
         TB2C7p6pjiPD6NjgMw/GBBIumaauQYY5vlOkj9fMUE2Cx9ddsIMTUYzs31zYvE593BhN
         BAJQ==
X-Gm-Message-State: AOAM5312vNndd4lGqHD+UbNtQ21eA2UwuLwpMWwQV5XSQEM5tp7Kz68m
        yqL2N1zZ38KnArY9u1pno1akC3r/BVLxjoo5dWA=
X-Google-Smtp-Source: ABdhPJxBp3zRjk7CPr/2JsbLmgh1eoNXlhMAhFtv49m9q+zi1fDlX2Nub9/KgvHJlJxHJ8wj5xFm/Q==
X-Received: by 2002:aca:3c8a:: with SMTP id j132mr9252066oia.171.1632674208685;
        Sun, 26 Sep 2021 09:36:48 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id u17sm3025092ots.22.2021.09.26.09.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 09:36:47 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/33] 4.19.208-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210925120746.034087226@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <a09b04ea-3480-f4c6-9bf6-b7bcbf0c2f64@linaro.org>
Date:   Sun, 26 Sep 2021 11:36:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925120746.034087226@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/25/21 7:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.208 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.208-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.208-rc2
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.19.y
* git commit: 6acc348b20e12abd0f06a270afff377270d60331
* git describe: v4.19.207-34-g6acc348b20e1
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.207-34-g6acc348b20e1

## No regressions (compared to v4.19.207)

## No fixes (compared to v4.19.207)

## Test result summary
total: 71740, pass: 57529, fail: 599, skip: 12013, xfail: 1599

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 41 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 21 total, 21 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
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
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* rcutorture
* ssuite
* v4l2-compliance


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
