Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965A81812CD
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 09:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgCKIVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 04:21:20 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42164 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgCKIVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 04:21:19 -0400
Received: by mail-lf1-f67.google.com with SMTP id t21so894975lfe.9
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 01:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/H44xo9YVbjQU2jF8VsFwG+fQELUXeP3PySlq2Oi+ZU=;
        b=sswH5hskdEuA+AVikpt0FFbATlmickLcGGKFoeCnwSLyfud9SEuMptPh7I0IqKqmrQ
         JY0DbfPNjMfpNtTfVv3UkbF8bU6LX4dX3Bs4WqIpMWcwyIcRDB/TuthViJojm0W1s92K
         SApwJ3xPBjPZ59CsDFnRA4MFGfGw3bD1U1M0Fhy0XQ6kWsZeWiEjqUOFiNBSyEViQQUM
         sNITfek9Z/pfJJGTKb14aqqi5HBBaaLQPJu2cq8+qGG11fW3DDcbpBX6bCl/0RgQZuPE
         R+b9aMxLWrAusGIn+dlmVxrAfXR14w3z58Du4DKj3AKPSKoMlEubaunBM7lJm8f1Bd+l
         D4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/H44xo9YVbjQU2jF8VsFwG+fQELUXeP3PySlq2Oi+ZU=;
        b=qW/EVQygyu7uxTcFthpU5nwP1j2476VZTOu6r0hhCZzvtRowbJVxDaNQbar78yl9br
         sKOlXlbp94zMj0xocjOQ5JxJazswpq3BnjG1giKViVxQMgP8M/zsCnTEu6pxexZbkxSR
         2KMtvRmPr+8SaK/e4VU7brEAFXaseCCNuKZkTfPrORurwae1tcbe7ds+NGe62HJWsmaY
         jUhoj0pkvFDagVc1Ow4AvSB0fpTZEbTHfN/b6rMKaF/xGhOSPF53VW4WCgPhzfK8w+TY
         U6Ry8Erf5k+DFLQFBibW0S+XyWwkwMNI5HaS50LOfKfq3lv2t/mer5eQsKilbz9tVgyI
         cFbA==
X-Gm-Message-State: ANhLgQ3mLRrtnEtwbQv83noF1tx+iI+bu/fyu45D3XcV2z9YWGyysTms
        edPPk0upEsgFuD9PZkWJwQci7bfyxhkvmnqi0tHJHg==
X-Google-Smtp-Source: ADFU+vuttkx3YOuB8M4MIP0FHI7sbtyY4OuMHmkIcMSsUUV+RcyFRZiPwXRwDoU0GdfmZKpUr4BX4GbNVF4HtmXO8fw=
X-Received: by 2002:a05:6512:1042:: with SMTP id c2mr1366390lfb.6.1583914875135;
 Wed, 11 Mar 2020 01:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200310123601.053680753@linuxfoundation.org>
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Mar 2020 13:50:48 +0530
Message-ID: <CA+G9fYsmBrJp2LRY_ixWMgKcNZXDC=TwNbGFN08iFwxybpSBUQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/72] 4.4.216-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Mar 2020 at 18:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.216 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.216-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.4.216-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 836f82655232ea02028bb5857f19bfd950b33c33
git describe: v4.4.215-73-g836f82655232
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.215-73-g836f82655232

No regressions (compared to build v4.4.215)

No fixes (compared to build v4.4.215)

Ran 21137 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* kselftest
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
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
* ltp-syscalls-compat-tests
* ltp-syscalls-kasan-tests
* install-android-platform-tools-r2600
* ltp-open-posix-tests
* kselftest-vsyscall-mode-none

Summary
------------------------------------------------------------------------

kernel: 4.4.216-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.216-rc1-hikey-20200310-664
git commit: ac3d5b19a0a5c40aaa3436bb63d6b0098eb7ce7b
git describe: 4.4.216-rc1-hikey-20200310-664
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.216-rc1-hikey-20200310-664


No regressions (compared to build 4.4.216-rc1-hikey-20200309-663)


No fixes (compared to build 4.4.216-rc1-hikey-20200309-663)

Ran 1682 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
