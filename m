Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77AE1735D6
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 12:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgB1LL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 06:11:56 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46192 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgB1LL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 06:11:56 -0500
Received: by mail-lj1-f194.google.com with SMTP id h18so2716950ljl.13
        for <stable@vger.kernel.org>; Fri, 28 Feb 2020 03:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HIdjgnxmDlkbYM0qyonP/o0ZxcL0OQPNoOF1hF19r2g=;
        b=Cv2KVZLYpcsGc5c3LjrzUc247WmBa1Rs8HX0GklW8ofQ/Axtex93zwkAld8EeG35ZL
         ZqTfGUdm/0/ChhFrzO9FNk1Dk00vUqOTlrajdnqF/1o3YGlsQpzTtn6sbIThs4qd72BE
         /Mq8pvSZuaWU7YykNZIqJt3V4vJFAnXJzr8wR75FdqzAlEiUV5EmsoGVszwI/ya87TcZ
         fdBcHUaEwjNdez154lkQZYuLwChYxxqofm4OUl5H1//AV/WXhRO9eujo7Cho8Su8WsUA
         RiwoknK8+hEIbDfkfvirbu8mHgFG+MN4bb+hlamU09mSinzIm3sWSJV+0Ed6CmKL0RCW
         2sgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HIdjgnxmDlkbYM0qyonP/o0ZxcL0OQPNoOF1hF19r2g=;
        b=eHRHg1QYHMitO6Z0j9kw2RFdoET3GSxtYN437fcjfGH5M2aPg+ft4PsrET3aDSvBBs
         TYGm5blcO9yPKfBKaIQYriBbubTYyKBbutxTf2BZnFLwmQwCfFT6wm958Wp3hazYGvRw
         4HKdEYv0Wobqdt3VjlELV+3wBNWMR8dImVidmT344Fykqtuax7wT33vrpbAv+asq+sI/
         fgVBrFlZLLpFwaTPbBGcvvlPGTapIGwZc3b6DcE/rSUb5/O66WBBgAIAYi1IQOqJMK64
         t9XdjUwLTW+Gdn+wT4ANk39y3WXDcmp3IDD510AiS6pkb55uuKeu8yHEmmLqq8ItYsUE
         1auw==
X-Gm-Message-State: ANhLgQ3x0ms9+Dwg6UUYI5vc7Y9mMSc0vsUkGIm7+jZgkn9GAnCEL3wG
        t3tkCLjHRBO6T/OqGHjXk+W+XEJhDQCDIZIeY3sPFazZIT0=
X-Google-Smtp-Source: ADFU+vs/dTljw1Ck+jEuV+WavyXXeUAuVuXxlLOvOCKwV0lAjDQLBYmy1RHT4SA2+aaMOjmKB0zQrPyXZ8Tfsev/F84=
X-Received: by 2002:a05:651c:414:: with SMTP id 20mr2447357lja.165.1582888313920;
 Fri, 28 Feb 2020 03:11:53 -0800 (PST)
MIME-Version: 1.0
References: <20200227132211.791484803@linuxfoundation.org>
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Feb 2020 16:41:41 +0530
Message-ID: <CA+G9fYsaAq8s1v1J0qL89QrH+w2mdWdUDwKLmQ-u7gb7+HX29A@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/113] 4.4.215-stable review
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

On Thu, 27 Feb 2020 at 19:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.215 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.215-rc1.gz
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

kernel: 4.4.215-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 68572b1fc85aad5f46827fabaefbc6aaaa1f92be
git describe: v4.4.214-114-g68572b1fc85a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.214-114-g68572b1fc85a

No regressions (compared to build v4.4.214)

No fixes (compared to build v4.4.214)

Ran 23132 total tests in the following environments and test suites.

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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* prep-tmp-disk
* spectre-meltdown-checker-test
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
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.215-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.215-rc1-hikey-20200227-658
git commit: 1a36ae5dee37518be5191e87733744dc02f99366
git describe: 4.4.215-rc1-hikey-20200227-658
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.215-rc1-hikey-20200227-658


No regressions (compared to build 4.4.215-rc1-hikey-20200227-657)


No fixes (compared to build 4.4.215-rc1-hikey-20200227-657)

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
