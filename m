Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D8F42FA87
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 19:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241480AbhJORvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 13:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241260AbhJORvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 13:51:43 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339A1C061570
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 10:49:36 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id r4-20020a4aa2c4000000b002b6f374cac9so3236217ool.6
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 10:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=43KZbMJr+Za/CNOJToS0Ey8f/TY2vPY1kQzcAcOdopM=;
        b=YTiUa+HFYnA0o1Z2gpCbYBvWeYGppMCfqFoE2X5PEhx2+NwhYomxfWx+aHRhRSvplx
         dqc0hKBO07Ro7uJI/E52v8+IS4FH+P52az9ZsHmzlSfyI23bskaZ03TY6nyP7gUmar+t
         rjsZNG2pgtErYBo2LaxjInI0oq5azme9n7DT0MK8RxM0JEaW6FRizx04otp4sbN4TIno
         jNscTvYs75Rr8fP779NIaEp9YkO6efg8rI01/pkfTrlsHRtDUfilCrlV+mZ6eBFjzaSG
         ZnNfe+LDNH6puZFGF/udVwjSK8+b85RYT40FKQ5P1tAkFYfiGPS6jKlj4/lA2BFjzx1m
         1uGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=43KZbMJr+Za/CNOJToS0Ey8f/TY2vPY1kQzcAcOdopM=;
        b=tEUfhHWnRtQ/pgAMapftY4ZaJ/Lp5v0zM3I0QP8Ck4HlsWGKjYFpMrdEdv32kgSCOr
         5tAWHlt3S6QKNA7fFeRpkMMps3feCRrbCwrFS/fDPrmvrm0LBB4FiUqjXatpYwS/8JiX
         Rneyjb59JueIktpNBLTNBwRh3D73vOjaMpsq1vtjjEJg/W6FooX6w8vNyQU5Lj4iej1D
         Dr9vrqnilzlEmeU2ANci5K6/iJgRlcyR68lBFFSZ+GdkxU11QoysAqAtFEX3WhZlBWov
         x9NgKQqBmDaNsH8kQrmzz/u13goWKokx1D+CPiiVfx8v8CDQdUmN5wTffjiiG0dFrWqU
         /lFQ==
X-Gm-Message-State: AOAM532vcrDnelwRdeqX8wpzxTSlRK0kX0nQu6e2lNFkkAt4eOOxrPM0
        GQ1u3E6u7++iOWgKCPDKgfqArw==
X-Google-Smtp-Source: ABdhPJy5oKG3E+9PYxHwpivZZuKT3ljoxKicrpxx1cZFrU0NpgMwdeMpkmY/9ESYGm77RHZswHQ43Q==
X-Received: by 2002:a4a:e9f0:: with SMTP id w16mr10102024ooc.3.1634320175509;
        Fri, 15 Oct 2021 10:49:35 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.72.19])
        by smtp.gmail.com with ESMTPSA id r22sm1084472otq.5.2021.10.15.10.49.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 10:49:35 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/33] 4.14.251-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20211014145208.775270267@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <e1379685-c2b7-e7d3-8829-3a9db2e53bf7@linaro.org>
Date:   Fri, 15 Oct 2021 12:49:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 10/14/21 9:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.251 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.251-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

## Build
* kernel: 4.14.251-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.14.y
* git commit: dc0579022db410506fd874cd458c580df7f09db3
* git describe: v4.14.250-34-gdc0579022db4
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.250-34-gdc0579022db4

## No regressions (compared to v4.14.250)

## No fixes (compared to v4.14.250)

## Test result summary
total: 77548, pass: 61810, fail: 761, skip: 12833, xfail: 2144

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 18 total, 18 passed, 0 failed

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

-- 
Linaro LKFT
https://lkft.linaro.org
