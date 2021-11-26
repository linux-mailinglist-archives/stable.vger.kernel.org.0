Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC3045EF21
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 14:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349789AbhKZNc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 08:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbhKZNa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 08:30:58 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298B0C0617A0
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 04:42:18 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id x15so38392568edv.1
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 04:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1aJx2QnFUEeTZRRrLqYEK/nTxPoSb0FQB0KD407GCkQ=;
        b=oAi0AnTDtQ0QCnAOmZa6sHU6qklaBmvB2Dnib9FwD+qa+hLEN3XlbpnKVaoHsMQzGM
         DBUQupJ8OG9WcpkXB9+iUkMRteX7B9HPYOU/vDmpHN2JS+3NScgYx9ZJdxDhdJG5ujMt
         GMGof7JXfszUoCkTC5zwAx73NT+lIW4Fbwd9F+zOIzeEn4u5iTBz9qXMaqPn1N1VfzcA
         44mhZaFeisG1W4Oh1Fy5WOUhOnkSx+t+mFl8SCBivUl8GtxUStav/pjHvItBMBYjL6g6
         qNbGiyUyEkYckHhsSvWNqhhrzNvzjc4B4+Wr0Jb2UudF6+qPWSXkn80XB8ULVEU/20Bi
         S4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1aJx2QnFUEeTZRRrLqYEK/nTxPoSb0FQB0KD407GCkQ=;
        b=Gu2JLyI0zx6IO0ZTkKFDrP8smQNNfJKi31JNKMW81x4V8YvSSkgNZU3bXEOA1dPrJV
         bx3GM8jhXb1LkQC8PbUUdn6P07gG1lKAXtsrrOELLIuFH98pLd2B4oxIf7NRgwq+GJPj
         32tSeYN5TH6uMOugCNWozCbigeEJvqDmPDa7x9LJiCkC3yfqgQDt25dLnkOVDfKmpFVG
         l0boHGA08GskKzaik+rZQ0Eji5HV8fEkY3J7sVSBwe5sqf/ooVKyxs/YYoEU95StIdW8
         x06urQt0zecBY/4L7UNB+U/oKud1ucnRrNrqwVflH4RLSMgv1hr4l3KZZab+XN6N/9ai
         QhFg==
X-Gm-Message-State: AOAM532ddlkT1BBnwc7kzS6Dq5P8f9LRNR4cmQlwFtNWGx6PWVGFgw+Z
        ycXdHA/TvsqWigYNF0Imf8rz8PwsbAS6o8OgC7ATBg==
X-Google-Smtp-Source: ABdhPJyJChkNkHdxT8C0VAbm9mM9omTAukKIwQ1VyaZS1LQ6mPLuqeqGknC+fQColrPQwpFWy3zuNlOZM8WtlS06cK4=
X-Received: by 2002:a17:906:489b:: with SMTP id v27mr37847667ejq.567.1637930536266;
 Fri, 26 Nov 2021 04:42:16 -0800 (PST)
MIME-Version: 1.0
References: <20211125160503.347646915@linuxfoundation.org>
In-Reply-To: <20211125160503.347646915@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 26 Nov 2021 18:12:03 +0530
Message-ID: <CA+G9fYsRBz4AQ2wWNoSxyzBCNK2zCViX8JkoewodybQGrkn+QA@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/159] 4.4.293-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021 at 21:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.293 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Nov 2021 16:04:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.293-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.293-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.4.y
* git commit: 026850c9b4d089e2bb4e9cfb10a53278a5a6fc53
* git describe: v4.4.292-160-g026850c9b4d0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
92-160-g026850c9b4d0

## No regressions (compared to v4.4.292-162-g118b5f50cf5b)

## No fixes (compared to v4.4.292-162-g118b5f50cf5b)


## Test result summary
total: 44842, pass: 35892, fail: 206, skip: 7725, xfail: 1019

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 18 total, 18 passed, 0 failed

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

--
Linaro LKFT
https://lkft.linaro.org
