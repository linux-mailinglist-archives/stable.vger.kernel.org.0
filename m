Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A88418A1D
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 18:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhIZQTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 12:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhIZQTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 12:19:18 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320BDC061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:17:42 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 97-20020a9d006a000000b00545420bff9eso20886658ota.8
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 09:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Oj2/ISSwvdwJiIU2LQC8td68cx6XDojK8kUtgDQ7Zpc=;
        b=dXhHMwYOhll4Mt92/aHJSYc2w8XeDEZY0dEfxHowVM60PZrXRUypDmaRikuhBlO71k
         qO9p5nr+Umv5wb6M4g6SbkQxqRFY2y0l6kUg3LUbtuKEG7biZKHyFJYfsFoJRlcrPF+S
         aSLVEqNgApBlVnbyUCj48AoAWk0ktT/1mGPP5pLE/DU1nznA/91Cuwk8UmToh/imSn7I
         rI3gnq1izWkttDVS0/3xIQDoEQ1hl1nZPNqKhih4e4UqJknjm3f/OkOwUE6+9tzVClKe
         OjeGOFWrg9g+icQkLRf+9qxOKlERJ6I+A93u6FLcQRfHJulV2tdqqGMxJzZTP/2VtPQW
         c2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Oj2/ISSwvdwJiIU2LQC8td68cx6XDojK8kUtgDQ7Zpc=;
        b=RQACUKF6LkBNKaXZVJQIOY8MXlK3CZbwS/9wdHRbqWDjvlI+sADQMYj0xczD+YGOWE
         ResOwnDuGcgJUQkPjF/yQeM7dHtpm8r0qLPkbaR5H+8bujaivu7X5JRiYNZeNCyQYnY1
         0ySA6Kztl+i9x+H+Yo1bAAzeIid/U53ZLiw1P+8Kh7/nAqhXG4JfTxk1n3AsPHNdaEbX
         x/+fJBg2+hMWpKKaYk1Rqimv8q+Ru1K/ofmhToi/7NjwyGKv4HlRJqPvKxB8A9iPYmok
         vcrw5DdaZgRUVzwqx+rCDHHzwKFG2RhQm+g+Do6nqTIoaqheiaJwYEc44/F9bvPftRdv
         kQ3A==
X-Gm-Message-State: AOAM531dd1lrvjYm51yMbIZNlq6aN4Gonb7wIcu5sH5AaNRF9Rto20ly
        TekO2GaJUFjQ1KK0CXOhXkRftPZaXe3O+K2ZEnI=
X-Google-Smtp-Source: ABdhPJzF+woqLSPc7CGXZTMeZWaBWLEfmTbr3rMdkJx04bcsz6Dsa5ZSz144bn3FKz8qkU9LKIeI/g==
X-Received: by 2002:a9d:8a7:: with SMTP id 36mr1052803otf.263.1632673061169;
        Sun, 26 Sep 2021 09:17:41 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id d10sm3725993ooj.24.2021.09.26.09.17.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 09:17:40 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/98] 5.14.8-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210925120755.238551529@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <ec21dcf7-705a-8748-1c06-030a70c17d08@linaro.org>
Date:   Sun, 26 Sep 2021 11:17:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925120755.238551529@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/25/21 7:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.8 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.149-rc2
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.4.y
* git commit: e9755952d24071ff6f516d4c381e911abec76d27
* git describe: v5.4.148-50-ge9755952d240
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.148-50-ge9755952d240

## No regressions (compared to v5.4.148)

## No fixes (compared to v5.4.148)

## Test result summary
total: 79795, pass: 65537, fail: 605, skip: 12468, xfail: 1185

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 288 total, 288 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
