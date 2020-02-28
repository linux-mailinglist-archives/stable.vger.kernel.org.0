Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DBB172F62
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 04:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgB1DgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 22:36:04 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37907 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbgB1DgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 22:36:04 -0500
Received: by mail-lf1-f68.google.com with SMTP id w22so17544lfk.5
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 19:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FVT7qEYhm80HqJbc3aWKfNzrLg9U8y0nUBfDpf5KnMg=;
        b=pvTH561/K3ONvmMTS2sJ0tskdzovHpjj41uO2R9CLtDmRqcW0n3CZbTzicXccYr3K9
         lD2aLl+mm0rYiigoxjmaAqSGcCgA4v2xlli7pdQWC9229vSGdOaMXZsU3L2R+/9j8Qib
         qmMfsq36on+JjhbXc/FDkZBZ7tXWsqjkMynIk2O9l/G8DstFxqyocwuaaCveMI2BjUZc
         foXcMAMVYvE9dhDwIRONN5+9hUeBuA/zhR3vuoMNKJmqaErKB783bj8UFOIT5dKS0R9W
         NT21NGmI26AbxAxA26tOhqvsS6XFiejQ0BqopZNSmA2LdcJuk6Rz/ts2KqyQNUJE1XBI
         +IWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FVT7qEYhm80HqJbc3aWKfNzrLg9U8y0nUBfDpf5KnMg=;
        b=fZfN918ewzJNgXcWjAGTkkb5ZrlJd07LhLrM5lfYZMnc5pbtFMOJCR7c6OCl+RmyFE
         V2v9CnnRYXGjy3BVtiFa1yj3DS4PVOhgGH4ryV0LgJ8S5llV2wETeSomwrpJsf8lOAjR
         HO/tRGWm/PD1o6qXWeWghHcO8OvNsCtGvpv+GF/YD0JIVHqXspbdBl/FBmlkfDUKIvNt
         r7J61nxKJziII68FO5UvIfxrfLPsr765yFl952X4t52VZoILxwT8p/CTy8k3mwltJpot
         Mxkra5afoxRWhfXyyjXeCKRp2uCT8O8CrAA2emumMX6LFTMEZJ9tt8HKpPjKSNiPqXDh
         9BQA==
X-Gm-Message-State: ANhLgQ0U6MZbeRkvEU8gOI/ETEW28tI9Rvvad1s44SG4Z5Ng/5Mbpszp
        pqdtRA55mI30waEoaeaYV6iFvhvRM1/NzMaSAeL7U8k97GA=
X-Google-Smtp-Source: ADFU+vvlRW8ztAcPO+osmfqDpO30hIpVhisGrk2kWl2sseV5L3WzBosUr1QJcpxZIXzUEO2mlXWAaTfTi5wI9PLftJs=
X-Received: by 2002:a19:4f43:: with SMTP id a3mr1330526lfk.6.1582860962178;
 Thu, 27 Feb 2020 19:36:02 -0800 (PST)
MIME-Version: 1.0
References: <20200227132214.553656188@linuxfoundation.org>
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Feb 2020 09:05:50 +0530
Message-ID: <CA+G9fYuy_Td284_oTdxMb45vXsAZfCnTGYG8NfHA2XvemZ_hjQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/97] 4.19.107-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Feb 2020 at 19:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.107 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.107-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------
kernel: 4.19.107-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 6ed3dd5c1f76bc99760b8d2dee47709961c3596e
git describe: v4.19.106-98-g6ed3dd5c1f76
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.106-98-g6ed3dd5c1f76

No regressions (compared to build v4.19.106)

No fixes (compared to build v4.19.106)

Ran 28502 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
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
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ltp-cap_bounds-64k-page_size-tests
* ltp-cap_bounds-kasan-tests
* ltp-commands-64k-page_size-tests
* ltp-commands-kasan-tests
* ltp-containers-64k-page_size-tests
* ltp-containers-kasan-tests
* ltp-cpuhotplug-64k-page_size-tests
* ltp-cpuhotplug-kasan-tests
* ltp-crypto-64k-page_size-tests
* ltp-crypto-kasan-tests
* ltp-crypto-tests
* ltp-cve-64k-page_size-tests
* ltp-cve-kasan-tests
* ltp-dio-64k-page_size-tests
* ltp-dio-kasan-tests
* ltp-fcntl-locktests-64k-page_size-tests
* ltp-fcntl-locktests-kasan-tests
* ltp-filecaps-64k-page_size-tests
* ltp-filecaps-kasan-tests
* ltp-fs-kasan-tests
* ltp-fs_bind-64k-page_size-tests
* ltp-fs_bind-kasan-tests
* ltp-fs_perms_simple-64k-page_size-tests
* ltp-fs_perms_simple-kasan-tests
* ltp-fsx-64k-page_size-tests
* ltp-fsx-kasan-tests
* ltp-hugetlb-64k-page_size-tests
* ltp-hugetlb-kasan-tests
* ltp-io-64k-page_size-tests
* ltp-io-kasan-tests
* ltp-ipc-64k-page_size-tests
* ltp-ipc-kasan-tests
* ltp-math-64k-page_size-tests
* ltp-math-kasan-tests
* ltp-mm-64k-page_size-tests
* ltp-mm-kasan-tests
* ltp-nptl-64k-page_size-tests
* ltp-nptl-kasan-tests
* ltp-pty-64k-page_size-tests
* ltp-pty-kasan-tests
* ltp-sched-64k-page_size-tests
* ltp-sched-kasan-tests
* ltp-securebits-64k-page_size-tests
* ltp-securebits-kasan-tests
* ltp-syscalls-64k-page_size-tests
* ltp-syscalls-kasan-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
