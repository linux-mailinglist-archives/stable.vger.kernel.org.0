Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81ECC18111F
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 07:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgCKGuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 02:50:00 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40028 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgCKGt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 02:49:57 -0400
Received: by mail-lf1-f68.google.com with SMTP id j17so710929lfe.7
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 23:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ahpBQ/+MYLu31BrwJkeFZdQBFShmEUV3ptb6UOshc68=;
        b=uLs6JZmsH08Av3TuGF4owIV46RupFv89AFa5i4RUvTNxqYl1uvb7cVShZqcHNZooBk
         grPCjCLUBRtid1BPucJB4IjfN+EPBPk4jIaF+mQmkOzpFJb07JDGIJbyn5aMqvdL2WH0
         kkwIBnlnZScIn59YTZdarA6S8uPL7uiZ3ddxb4mO9orWWjk/aMR3OT5xxkx7NGtztpaq
         BZpCMMFTgP4hM8xrZROPhHIBmRKbrYMamSG7SThqI0IfbcOL9+zhTdZ4mX4DhMFzjFH4
         /8xwuNK0lFQyUP5Oxew+SpV/76dZZkPiJ+WAfuSdUelZLVB+qpaIP21RNUAgxf7KlvnK
         1R3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ahpBQ/+MYLu31BrwJkeFZdQBFShmEUV3ptb6UOshc68=;
        b=G5JgYFOT7ztVzJj7UDqnd+p2i/wtGLxgLIkypc8MIXpNsILtQTjfRQBINTQp2gye7w
         WzHvQRUR650cFUawX+GOoVZh5oAKpTB/Jg11rrZzau2TEuFEmHVTF6UnT6dErF5U3IkY
         MoiEun+u0JAjjic8sWr4pimxpc2VYyKcgQdR1zMyAc1Ooj9h6Vw3k5zMfmybIAbTLpbB
         jNPe7MrYmroSbedBO9HsiR7ZwiMiQmuwN6rj6iKbue2KeY26ao9vCPuDnvxZCs0NWMBv
         qhRIxr4JDHSoSggh9U2t4D4pirQgsp7iMz+PXZIGcgQrkOkZbLwybr9Z8jhiJ3NCjSsx
         eMdw==
X-Gm-Message-State: ANhLgQ2Nc8btTUJMmMhIFByMVuv+ZMUrL60yJ/nqyVBuuya3CmxNSmW3
        C2B+OMQT1eJpodtym2H9SPUdQqvP6l5+gPCIgVhEkA==
X-Google-Smtp-Source: ADFU+vtBZWcxqHu6mtHM5XKcb8m14/jjtqIf3EJevH0mPIgVcXbKV3luUkkJf7v0zozf7UxmG5WE9HW7++7FnxTqaew=
X-Received: by 2002:a05:6512:3188:: with SMTP id i8mr1206124lfe.26.1583909394840;
 Tue, 10 Mar 2020 23:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200310124203.704193207@linuxfoundation.org>
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Mar 2020 12:19:42 +0530
Message-ID: <CA+G9fYsGAPV9eNpP41PKUTjoOdAF47iWVRSiCm6t9k=67V7XSw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/126] 4.14.173-stable review
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

On Tue, 10 Mar 2020 at 18:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.173 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Mar 2020 12:41:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.173-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.173-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: d5b7f770c4ed8ec0f3efb2a110406d2199fab05e
git describe: v4.14.172-127-gd5b7f770c4ed
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.172-127-gd5b7f770c4ed

No regressions (compared to build v4.14.172)

No fixes (compared to build v4.14.172)

Ran 24996 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
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
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
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
* ltp-syscalls-kasan-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ltp-mm-kasan-tests

--=20
Linaro LKFT
https://lkft.linaro.org
