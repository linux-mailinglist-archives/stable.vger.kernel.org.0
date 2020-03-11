Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E481812B7
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 09:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgCKIP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 04:15:29 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39016 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgCKIP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 04:15:29 -0400
Received: by mail-lf1-f67.google.com with SMTP id j15so897104lfk.6
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 01:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jOjGU3wzPeEBTqciAiFkvPsk2Rvz1207yuRzp5ZI22A=;
        b=YMXe1meY0Ry5dt0/YTi6LD2sq1y8JA1K2tw35d9SXB0Xym/fasJSX8xopFbMTgljmj
         sbYAHPNr4yllnJJOaM5wjDKD1oc9jZokEZ3Gx7zfLcCSd3QLvWBbE6livByO6dwqAYW/
         psWCXu+76CX86sU2phB/p8OlYE4basp0ucgsKtZEpFRpEGIGJ27Rvo2YPfmVgrQOvMJZ
         HRdyaeQdcIpV+t/2OkpW+VXO+fVdeVVcwdW5ucWr1KwzUlSBYyztaOZ27gALMBu8CSDb
         O9X+q16RSbkyr92sDBV1JeQyQt0Nj8z5UzfEXdRcplhQgLuIIPjumry22fN/9S+4W82G
         YTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jOjGU3wzPeEBTqciAiFkvPsk2Rvz1207yuRzp5ZI22A=;
        b=cx8lgt1k7KRiCvI6N3n7KcpfFHmlwuS3+m4XZ6BIeVHUPVOSKd50Rs0oKuf+vXvcda
         4oKd0Seyax0Pe3DpNlqJChZa3wPLcHQEHZFjdKUykYexJLsFcT370qHkryy4zqxZlR68
         4GjDptoPQUPfraUOSkJSsbKsoHd6Y9YizksXDTjbEhE30qPGBZatPx6xofbPP1qqmn70
         dfqvxczZFCQp4UoC56sQknNeS/WgyD4jHR4EWlyrH2xxGiN3FqRbY01cLB6aU58t6meA
         aU//Lp3RxF3ZIkgxAd0I78X0KbhVNumiVy5hUuJhs7e/GroAcisfedjE/UwoCMhLTo+x
         h/dA==
X-Gm-Message-State: ANhLgQ3iuRAJHYG4MBJM3+M88PygGz4FoWWHwURE5qiI9OMDJJoU2WGx
        2+AlmMA/HQ8HC+JE0vawX6Hh2QHrqpFLWRpEY3fboA==
X-Google-Smtp-Source: ADFU+vtU+ZEVtgT1sRTyfkr5wdmsCjOAh2UsHK9kBDRX6mc/raNw9j4ccsDe9UmOZY6oJ2zA3l2Wkl7mbV+SJIFkYsk=
X-Received: by 2002:a19:4c08:: with SMTP id z8mr1374387lfa.95.1583914526981;
 Wed, 11 Mar 2020 01:15:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200310123639.608886314@linuxfoundation.org>
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Mar 2020 13:43:19 +0530
Message-ID: <CA+G9fYt0W2P4WaEg=KSziBtDA6riTATdp-eS6QM4Ft4LzAoUOA@mail.gmail.com>
Subject: Re: [PATCH 5.5 000/189] 5.5.9-stable review
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

On Tue, 10 Mar 2020 at 18:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.9 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.5.9-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: 11e07aec07807683209513e2ad4a41bd7ee8a250
git describe: v5.5.8-190-g11e07aec0780
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.8-190-g11e07aec0780

No regressions (compared to build v5.5.8)

No fixes (compared to build v5.5.8)

Ran 27520 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* ltp-dio-tests
* ltp-io-tests
* ltp-sched-tests
* ltp-syscalls-tests
* v4l2-compliance
* kvm-unit-tests
* ltp-cve-tests
* ltp-ipc-tests
* network-basic-tests
* spectre-meltdown-checker-test
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
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
