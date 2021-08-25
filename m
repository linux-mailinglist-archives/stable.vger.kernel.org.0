Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30783F7BC3
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 19:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242399AbhHYRvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 13:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242336AbhHYRvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 13:51:48 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64DEC0613C1
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 10:51:01 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id n27so856697oij.0
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 10:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5D1tw3Md08WYLyG5LlUraIj8yn5OS2EuisWDpXs7Tm0=;
        b=IJmgjd1SrVJsVytUowWHxX+s8xRMvY+d97fCybXk+axf5m41xtnE89Hmso4IjQwuL4
         J5nG79B02u+RWaBPXvn7jQ3npVjw8znZNBtKL0cId4o9NEbkVfOGi7J5qpzpuZOvRib0
         WSoqsoZW149123bpcJDlvF3+0y/q6OMu7kapqb19t7wsEx3Ww/ywx3n/JLBMT1DUX3O9
         uFtyLjM7Ue+Ex5mIy7llFg5jPl9vhl5LcB4/S9/zAvC2F4se0xm3DrDl1DUt3rr+vFpr
         BIXomHp8kw1XR0zM3lOvawgfYApCBwgCJll36+eSwmTPaUW/av1QBNUVuOHGMjmrNYPN
         9IUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5D1tw3Md08WYLyG5LlUraIj8yn5OS2EuisWDpXs7Tm0=;
        b=dAxe5SPBG8wcZSvkYrtD1VztaSFU0cYRCZH33/8ojXNzYucruQZzoKm+4j65m2mpiF
         qzEPkZX7RoVVgjF1hCQ6cVkYBPS0MbNJlLjhi+G6QmcVeIg+bl5EUyEX/3ReC6t6vebz
         iwSyuNqHy+MrNS6Kjr0hHSy1LkS8ylBhjjo8zxRUmQnURbe1q9Y2EypPQm+wjKXq6yzs
         hlrh/SwrTNtCBHdYAln1dAIVPlIPAIj3lY2PBBKCz0ObJ0r+Mrs+dOt4/Fqfyf0M1YLk
         XwypxQraGdw9GNUxcvhxMPM/GBE25wM7YVZdFO1xtgc7LjdugTyDfLwPKu+mp/jlutna
         ZyPw==
X-Gm-Message-State: AOAM531okPohcBpUPLMahd6EZFiCBw45vClDwZB1OoaBCLPSV3C0RtKt
        qC7wr0jupBY0dKSai1ayh0Qaig==
X-Google-Smtp-Source: ABdhPJwq88TjIsr+7R11vG5jSL3rxRRZDUnTAvts3GR0h3Zr+Xu4HcRzWgpsQe3VCOhB1MTSOFSXIA==
X-Received: by 2002:aca:1304:: with SMTP id e4mr7927432oii.89.1629913861316;
        Wed, 25 Aug 2021 10:51:01 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.75.147])
        by smtp.gmail.com with ESMTPSA id c14sm88610otd.62.2021.08.25.10.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 10:51:00 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/98] 5.10.61-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        akpm@linux-foundation.org, shuah@kernel.org, linux@roeck-us.net
References: <20210824165908.709932-1-sashal@kernel.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <51db1aba-4035-d7c6-948d-18aaa93c64ca@linaro.org>
Date:   Wed, 25 Aug 2021 12:50:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 8/24/21 11:57 AM, Sasha Levin wrote:
> This is the start of the stable review cycle for the 5.10.61 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 04:58:25 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.60
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.61-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.10.y
* git commit: bd3eb40a9de703ab9ab65f9c583e40d185d6aaad
* git describe: v5.10.60-98-gbd3eb40a9de7
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.60-98-gbd3eb40a9de7

## No regressions (compared to v5.10.60)

## No fixes (compared to v5.10.60)

## Test result summary
total: 78086, pass: 66126, fail: 526, skip: 10629, xfail: 805

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 226 total, 226 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 31 total, 31 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
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
