Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D983647C515
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 18:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhLURew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 12:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhLURew (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 12:34:52 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F08C061574
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:34:52 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso17510740ots.6
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 09:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u+4aD5Pe6rsO93aXXQVERPguDn8LEagFobvNQYR5AMY=;
        b=qlnub33qV4W7YlZJhHMjbzC+h6WX/94y1RwbNLLHvKmsu+ox4HVbc9CWMxtbPAGsIA
         tjqC3MO+uOXryktkOwyzbK56qQpn/+hiAFaJJP7bPqa/f6vj+7GNkSE/Fbgh/cunVNLs
         2n5XgBB+ZeSx5UTUoHfC9SqzJMZ/5S7/RzMxLMMtWgwMoAVgMzaD7YG3BJJE8j9dZv1h
         ycqHvKU/v6+mllXm+Fs0auAxTr6bhEWZMfwBw6H1X8cTwsE2jRj/uuKyRJl2nHCredx+
         zXQucCZCTAvwca8yJ/k646rw3EJeQ7ebxGb4MOcBQPc2rjVX4X/XdMdoHVdeBTFDz7Fb
         cCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u+4aD5Pe6rsO93aXXQVERPguDn8LEagFobvNQYR5AMY=;
        b=bqtFjGS9+ic6HJaIIWeZdIOfnuWS0iwcgRVMZAND9kcQyxwmTGEdJ7cOqlJTo0fvQa
         q3o0StjSfo6DbQWJ5i+lhyXTbA2dbbbtlJ1z2asWgdDwZwRQ83TuZi3xV014XSbldCEw
         nF2EEPwQVjPPv3FTN2OOp93JvilNzMEzBQs645gIk3uo6N9iYzZAmGQkY2IBCxORq8BX
         gpTnO3300Y669jrWVUyePbipKfHvz2LT6l4OggphSWJXUNsx4eWKZoTsPvevMPX76SrS
         1Pe0kc3mYvZ+Z4Y0vFLdqyb3WNJDT/wwPP/J0T2/+I72T5E8F1yiGARIFUo+AoSfXG2T
         LXgw==
X-Gm-Message-State: AOAM533UgBKf+bYjNjajvoCs/S3Uc6qq2x7pr1wgsCtsmK0P61DBRGKC
        XHbEVOhiPDJmuniiO1Wi+vHk/orYxGIk7f8BpLeWxw==
X-Google-Smtp-Source: ABdhPJwSPyuU2fRgegim+90H8AF9sLEywy3fam6vEwJ68FP5oAYF/cHGAfxmlg6p5PD69Tb+7ROuRpuZ/12Rv7/K8y4=
X-Received: by 2002:a9d:2ab:: with SMTP id 40mr3114788otl.208.1640108091530;
 Tue, 21 Dec 2021 09:34:51 -0800 (PST)
MIME-Version: 1.0
References: <20211220143017.842390782@linuxfoundation.org>
In-Reply-To: <20211220143017.842390782@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Dec 2021 23:04:40 +0530
Message-ID: <CA+G9fYvDRXZ5se1Y9TPWx5cfaDC9JTRSv=Js0w-Pu8qObZDnFw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/23] 4.4.296-rc1 review
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

On Mon, 20 Dec 2021 at 20:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.296 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.296-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.296-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.4.y
* git commit: f46f7fed481068d1389efbf0122c45cb9f36480d
* git describe: v4.4.295-24-gf46f7fed4810
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
95-24-gf46f7fed4810

## No Test Regressions (compared to v4.4.295-6-ge478503b16a3)

## No Test Fixes (compared to v4.4.295-6-ge478503b16a3)

## Test result summary
total: 46356, pass: 37461, fail: 177, skip: 7721, xfail: 997

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 30 total, 24 passed, 6 failed

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
