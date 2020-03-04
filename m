Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183C4178B1A
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 08:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgCDHJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 02:09:20 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39261 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgCDHJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 02:09:20 -0500
Received: by mail-lf1-f67.google.com with SMTP id n30so586366lfh.6
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 23:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JsYeKfKs2XZrC+kCpOFx401M5U/67+Z8xk8Q9AKW6BA=;
        b=F8zSJUTxPQ20qrRF7Vhj+xvmNJvFU5lOrBVd2Q00tM1xvK/I2JEcdpGKqj56lk3ALO
         eZFrsRVQ9OnB8tOKKFnbCV609Wc3I4+YNREYWTMMDxzOn+DllRzgLIIZz+AkpgRaDFXb
         +I4DwOQz7Yjg/mZ41kwM4Xjfzk2O+pb1RdmObSTnTQ/PLlMugBiaFEM74pRh4oFDTHgO
         DLFvpZAeA4kT+vn0k6cRMFr1Bx0JAAgDr+7HysrodnV+/reNCbKCcDhCF+Q98rGq1bRK
         8xFSefhCfATJgLFd455fq296nol5jlVT8sdiNvjATizHhelVNatiFfaQzROVc357Oj71
         ecFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JsYeKfKs2XZrC+kCpOFx401M5U/67+Z8xk8Q9AKW6BA=;
        b=B7OyhRdOK0MaGsR3NIynuDx1MNDQ60z3U58cezcM15O8ypD49/26LFQ44tQlDoQ7nd
         Fad/6GiLf+ir0rLfdHeKtyikWCx7aWJROWlNjwzESQK8rahAdCBz75xttQ82NZUL+DbO
         c4A7Y3/UUJXovhHvA3f/FtyDvCTyrt3Ul8P12M2V5CSAcoaKcKnqa8hS8XixrA9ZJANC
         gFB9Pte1JK4zTSolgM3d8rdeLnXaKL0WgyWtTN1oYdVJHba3X9vA7OwRX+c4JLunp/04
         ljs4T/gfSKEQPqyvh55V3DtG3r9+I5rqft46BMJoEMMXt7QdUzET42iWhLoPiA7gjbGz
         K+hA==
X-Gm-Message-State: ANhLgQ0taLJOuLZd/fAIU/WelrN6mWhlWlHW9QMC6J8uH7qJVqJPZBy4
        XzrdTFiQ/gf+HoYD6Y3AwJ1EuM4ZLCLDv4EjOXk6RA==
X-Google-Smtp-Source: ADFU+vtDG8QjPFGc206RQ6tlGKIWhBr7Zg45xMq83dk+yDmKmsgSkjL9aKABI+LliL6qvf9ftwBESuQiE2sxTb0J/I8=
X-Received: by 2002:a05:6512:1042:: with SMTP id c2mr1107043lfb.6.1583305756675;
 Tue, 03 Mar 2020 23:09:16 -0800 (PST)
MIME-Version: 1.0
References: <20200303174349.075101355@linuxfoundation.org>
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 4 Mar 2020 12:39:05 +0530
Message-ID: <CA+G9fYs14zfwfApDMdhdGgrBZ00EDrZZGZbuRDoN20Q7aGZdFw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/87] 4.19.108-stable review
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

On Tue, 3 Mar 2020 at 23:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.108 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Mar 2020 17:43:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.108-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions detected on x86_64 and i386.

Test failure output:
CVE-2017-5715: VULN (IBRS+IBPB or retpoline+IBPB+RSB filling, is
needed to mitigate the vulnerability)

Test description:
CVE-2017-5715 branch target injection (Spectre Variant 2)

Impact: Kernel
Mitigation 1: new opcode via microcode update that should be used by
up to date compilers to protect the BTB (by flushing indirect branch
predictors)
Mitigation 2: introducing "retpoline" into compilers, and recompile
software/OS with it
Performance impact of the mitigation: high for mitigation 1, medium
for mitigation 2, depending on your CPU

ref:
https://github.com/speed47/spectre-meltdown-checker
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.107-=
88-g619f84afab6a/testrun/1265077/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/tests/spectre-me=
ltdown-checker-test/CVE-2017-5715

Summary
------------------------------------------------------------------------

kernel: 4.19.108-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 619f84afab6af6b99d65c2e2c76cf7b899fca40e
git describe: v4.19.107-88-g619f84afab6a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.107-88-g619f84afab6a

Regressions (compared to build v4.19.107)
------------------------------------------------------------------------

i386:
  spectre-meltdown-checker-test:
    * CVE-2017-5715

x86:
  spectre-meltdown-checker-test:
    * CVE-2017-5715

No fixes (compared to build v4.19.107)

Ran 21202 total tests in the following environments and test suites.

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
* linux-log-parser
* perf
* libhugetlbfs
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
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* ltp-crypto-tests
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
* ltp-cve-64k-page_size-tests
* ltp-cve-kasan-tests
* ltp-dio-64k-page_size-tests
* ltp-dio-kasan-tests
* ltp-fcntl-locktests-64k-page_size-tests
* ltp-fcntl-locktests-kasan-tests
* ltp-filecaps-64k-page_size-tests
* ltp-filecaps-kasan-tests
* ltp-fs-64k-page_size-tests
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
* ltp-nptl-64k-page_size-tests
* ltp-nptl-kasan-tests
* ltp-pty-64k-page_size-tests
* ltp-pty-kasan-tests
* ltp-sched-64k-page_size-tests
* ltp-sched-kasan-tests
* ltp-securebits-64k-page_size-tests
* ltp-securebits-kasan-tests
* ltp-syscalls-64k-page_size-tests
* ltp-syscalls-compat-tests
* ltp-syscalls-kasan-tests
* ltp-open-posix-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ltp-mm-kasan-tests

--=20
Linaro LKFT
https://lkft.linaro.org
