Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567F1414145
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 07:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhIVFgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 01:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbhIVFgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 01:36:06 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C032C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:34:36 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id dj4so5319817edb.5
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EyOvEnyX8R7VnSGP/KEqU0uiXq+VKulQ3XLiXib89/s=;
        b=MeKk0NBuXEhwujHu67Xhu/O+OSNWkkIFb3XWbFvWjWYolIQ9ihJCb1K/YAzE0WpXhT
         3uH5bJ0fpX/qQw/J5Z8P47owxpUuvojREOlfv5hiCqTcCeMdOqMxS6LzcFrEDd3JI7li
         3dFYQaWDN40nnsg4cbNAKHl9WwuQZ75Mw8w7Bzen6VyRBKITtCDD709VK3rhPFHBKcvD
         VJw6e1h9HiGONsUaG9kfyT3qhGipkb5cAfomet1hbDjRlxytMn6GFo15eTrYgG9LIFXF
         Dw4KZYUODHNmft3nhKP6SyGACfObYQgfJ5/zCjYqtjPG4ZadzwqLDNJSgnURhocZDSf8
         Nqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EyOvEnyX8R7VnSGP/KEqU0uiXq+VKulQ3XLiXib89/s=;
        b=gz8K5g3GW2IvHSWkgyQz8hg6vfBfv+aqYX3H4I/Z9eKzaDRYRGuW3gDamTizZQNxaf
         XBLK9w+FgNlVH2tKfcowYsj4HmMxtlbZb6UGOEh1ToV3k+Mzg6eCmt5gysaqtpsRbO4o
         xusC03BBOZrw5h5V6hjIRSOpvlwK73mS6s6qP5QGtzQZt8IcGWyqG0KCmzRPFzpEDZKB
         f8p1dMpXdkaDImQXwrvBe9paJLXPILfrfwSaAiqQO4nH4/6LT3avFp67Ont6NBNe+zV7
         AjCiF9gQZq84vIXgKdTqIV7jIyLmRQPUhTLpCIS4AvCGd3vktP1kKBe475Y5DUR9TN3k
         nyhg==
X-Gm-Message-State: AOAM531tjlltY5OrsNcuKGmtBXi7NxmTD7Kq2ZjRIiwrNQBXq91lC0Ma
        fvBKFIEKk9gkXiGs0s604/r/ejxcN4fdSgbhTweGdg==
X-Google-Smtp-Source: ABdhPJz5uShPzNsj4RrbIsFqyQXbXQXGmA/b7yXdhd4Jf7ufCcixWx1TxmrAZWLZRNR/CkhVfh6IXx7Tb5SmG63digk=
X-Received: by 2002:aa7:db4d:: with SMTP id n13mr40522663edt.398.1632288875050;
 Tue, 21 Sep 2021 22:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210920163933.258815435@linuxfoundation.org>
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Sep 2021 11:04:23 +0530
Message-ID: <CA+G9fYso0DxyuSaQCVduZRBMcpHAOdWzCBryLBHtvRdpAPNu6A@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/293] 4.19.207-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sept 2021 at 22:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.207 release.
> There are 293 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.207-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.207-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 9a707376d65f32dd46cc29db2659bd600c431b5f
* git describe: v4.19.206-294-g9a707376d65f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.206-294-g9a707376d65f

## No regressions (compared to v4.19.206)

## No fixes (compared to v4.19.206)

## Test result summary
total: 149708, pass: 120249, fail: 1145, skip: 24517, xfail: 3797

## Build Summary
* arm: 258 total, 258 passed, 0 failed
* arm64: 74 total, 74 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 82 total, 82 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sparc: 24 total, 24 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

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
