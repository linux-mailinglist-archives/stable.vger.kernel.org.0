Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EE92BC4EA
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 11:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgKVKHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 05:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbgKVKHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 05:07:33 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FED5C0613D2
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 02:07:32 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id s25so19127020ejy.6
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 02:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mTrvJBNQw+XSygUPQOq1V8aAQG3hqMkSG3RgtFsMO3g=;
        b=ROFaBEM6CmhJcORUmzHPm2Qmt66R9DRSDIXeWoqvLRB6K1opxqQA2tKYKZ3ZB4KDjm
         SYA6KfoRr2e49F3RUhmZjWrBl5LQpTEywvLXhhaFdsTHnxSla0Nv8d0THFX9B36D4WCf
         c+FlGhj+AfmKUwIWg4I0I+2fhYPDRRa+s7lNSgMcxnmER7anpZAfLCCpz2Ua/PG8HLl2
         mXE2ZVU6z6iVUZaP2EVJikcCJGxRixcxla02P2fhTtRKZjh8zKMZV0haxmNrzin/hVIA
         CuEWXsRZ86VXOjzTJZgmQ0CxogTkG+yS8VbvgpZANLWeG12zSWjMckVIlssqmMRK2bdb
         TO+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mTrvJBNQw+XSygUPQOq1V8aAQG3hqMkSG3RgtFsMO3g=;
        b=q7wHR/PYVLh1TS0qJmbPsUHOWH+d3CovCPojCRcnsY5lNijphRVMpemKAN3cm8y2hW
         QMN0CpJLZNO9ExE+trxGQxpP/1Z9yEp9UBW3xJNcVqwEJT2AMRCtvS1yYRogfGsqu5uL
         VeuwS9z1sUiXjd0yZuzBcpqt+ghz+u22td/Moo7UKjO+Ye+XBfpB3T9N+ura6IWXSZKr
         fT/Qts/C3RCuQ28tLQBswk8vCiq7h8gzGnSylcyl5qEUH1S+4S60QGhDaoyTAz1F+XfC
         c4kA75mwYzB2ei9ihFR6uMx2C/YZgcCRRgNeiYvGmgtFpNSZMKOky0zaLoY1kOgsE6tG
         9CWg==
X-Gm-Message-State: AOAM530+XyY855/reBJuxX1tdFOjpZfKCS91vvBh1jzrdkgc/HGaDCQG
        QzxEkMKDauuFr4oIQcdCSVr8RoV9fbwGHJ3B0uYxtA==
X-Google-Smtp-Source: ABdhPJzwi0X2mmu0AK8D81hcVTX6644ryj3nliWnx6Yy0Y0zyBjnFo1ocg9rTxu9g296imI3hGg/SQ1ZM8xjlqqvjeE=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr1759042eju.375.1606039651047;
 Sun, 22 Nov 2020 02:07:31 -0800 (PST)
MIME-Version: 1.0
References: <20201120104539.534424264@linuxfoundation.org>
In-Reply-To: <20201120104539.534424264@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 22 Nov 2020 15:37:19 +0530
Message-ID: <CA+G9fYvmgMTrQJogsLaf2Ytf=dZiLZcB94c7KrtBGENr-SAiaw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/15] 4.4.245-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Nov 2020 at 16:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.245 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.245-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.4.245-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 11095ab90e22ac875983239a445f6b4ad64b6e08
git describe: v4.4.244-16-g11095ab90e22
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.244-16-g11095ab90e22

No regressions (compared to build v4.4.244)

No fixes (compared to build v4.4.244)


Ran 32775 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
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
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-tracing-tests
* install-android-platform-tools-r2600

Summary
------------------------------------------------------------------------

kernel: 4.4.245-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.245-rc1-hikey-20201120-861
git commit: a395e149575bc8d8ec23a677f979301bfefd8862
git describe: 4.4.245-rc1-hikey-20201120-861
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.245-rc1-hikey-20201120-861

No regressions (compared to build 4.4.244-rc1-hikey-20201117-859)

No fixes (compared to build 4.4.244-rc1-hikey-20201117-859)

Ran 1722 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
