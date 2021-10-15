Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18A742FA5F
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 19:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238050AbhJORhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 13:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238057AbhJORhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 13:37:08 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD83C061570
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 10:35:01 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so13756486otq.12
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 10:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yp8wpT/FzZkt1PcCFDsB182x2tyHjic3yl4SM1t24h4=;
        b=ulkpZhazXJY5FDJqsundVQ7nHnpIisqrlNzAYptDlNlsDMUZ57AesDSih7l6whx1fC
         7bpBeeH3w4592V/OhqRdOcx5MwNAczYp+yB0JUSk06x8YFwtAapUP0nb45zeqtQ4HoLl
         bv/UK7sQxPS+z7/cLsIcRozYiDge+nRzF+suGvgZS9jDt5E1lDLSZAbp3N1O6lWJwdx4
         dX8vP2y1JRQwg/58unCZGDPTGLwCrWl+nJ/qQvsz8eZ8AnuJj7knbQDmMrCr0O5l0NZe
         D+xN+4DZXb/FjBJwvBb2VtOOhZk9c9kbTVDFhqborMoUBHa3Gtz2xVCAMgvClzS9uLvQ
         TdTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yp8wpT/FzZkt1PcCFDsB182x2tyHjic3yl4SM1t24h4=;
        b=uJCccwfm1T1TOLrSYC64mFuVNSw4hNvmWcXbEBkplgOAcUupkXun1T4IhGG1629g8k
         S/dukhkSm6hhYpLankOuKaSEm9NRP1EJrBXGrmsGkZWGiEUtErvpHxNjqV5KhCHbk+WJ
         1zXRUimfRBgW7HtyTe/Zx5mtMXHJnY+HQGHLSZcwW2VPzw7iqKeqG5KeaE7IUuJny2ys
         XJz2pOQAKPNxyM3vbLJprlfTCcRdTme3KlKbXiAW+aWVUrhoxFKvX9tnxGsm2ykK80vN
         PlGaGDqnAIjPsrRze1G0bJjKasDo2Ypc2jo7vwyzczRl4cyQYK7lZr1gLgvpwRScupwm
         X83Q==
X-Gm-Message-State: AOAM533LoSBliOMZ/sq6+BBjs4QrkX4MHLTOO6d2h+rehSwAsKjbf1Aj
        Zl8ZqvZ9HsjizEn6ckNAeSc7zw==
X-Google-Smtp-Source: ABdhPJwluJ8HagwzB2fxTxfIZ9dIg+Ixksl3WHsqTV7pPL2NwEW1bwAXILTNyaz9k9f6vzU+GtpNug==
X-Received: by 2002:a9d:720c:: with SMTP id u12mr9164445otj.95.1634319300806;
        Fri, 15 Oct 2021 10:35:00 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.72.19])
        by smtp.gmail.com with ESMTPSA id i28sm1107939ood.23.2021.10.15.10.34.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 10:35:00 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/12] 4.19.212-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20211014145206.566123760@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <7b02fe6e-b816-6330-486c-fa29fd03d3c9@linaro.org>
Date:   Fri, 15 Oct 2021 12:34:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014145206.566123760@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 10/14/21 9:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.212 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.212-rc1.gz
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
* kernel: 4.19.212-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.19.y
* git commit: 2be6a8418bd1568db7e752ea68f73e6f24fca984
* git describe: v4.19.211-13-g2be6a8418bd1
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.211-13-g2be6a8418bd1

## No regressions (compared to v4.19.211)

## No fixes (compared to v4.19.211)

## Test result summary
total: 83844, pass: 67315, fail: 797, skip: 13617, xfail: 2115

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 29 total, 29 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 21 total, 21 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* kselftest-tc-testing
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
