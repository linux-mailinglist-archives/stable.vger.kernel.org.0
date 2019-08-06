Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4A682B35
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 07:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731641AbfHFFpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 01:45:34 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34023 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfHFFpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 01:45:34 -0400
Received: by mail-lf1-f67.google.com with SMTP id b29so52736510lfq.1
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 22:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=P89CogMKW6Sgt++XgWFL5PZQbnz0kdGQjsZFbC0bIZE=;
        b=pWORd/fNaoUJf5GcizzIMXGj6i036nY9lYwtj8PyyH147iqP0GyvGfWuAZVszJTZze
         2IPmbVm4Fdgs9C3B+vLxHZ52p+XrpYVA4lnsw+SL9LJG9cULCyTvUlqszLHNpmPao2TX
         qOd71isHdHksQYX7BXkA7sHEJ4AJvL9sF0oqOdgyjDwylT9q8+d/+Ahjbe+0uuU3u8g7
         t9TBU3QNPB/QUmxTF10wWzJ1mbvK5pUDUVJVG41FZ7VE9MmBe3IEZc514SWekZ3f1Dsb
         2/JQgjqHVqGK6Tv1IPJS5DWb0tv3utT9x5ZwGFwJK0/Y60cYdTmsHQCbSgOdz8mUvzKv
         IvfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P89CogMKW6Sgt++XgWFL5PZQbnz0kdGQjsZFbC0bIZE=;
        b=pWUrh+mMo9qOYNY5geT8cXABh0kyRQNOGe5PcjAKuvatVlWBwi/6hIFGMwZvm9oyoq
         MyMuRB8KNfgcVjdfCQGB/6Xfl4Gig0Uku3UPQaENrXPoRYOlQfvw78cPOgcgI+4sUvIP
         V8yqe9j2DVMb8kEt71NZuhgWtcuFBQHTrMrymZdtUYJiC1J5jdxR3qVfijWrAx/gbII4
         TaNkTUJrdTeMPCxO0k2GFi0uelvqDTaP1Rk8xVamNOBxk1Iua1mnsc5dbsQkORo7UHJO
         DxXtxMNlTdifWQyBSbypxKrJSoKqUU67HU/FqQfAtVEvZCSqZ43/tiD3co1ciAWLdPEk
         vm3Q==
X-Gm-Message-State: APjAAAUT5p9U+ac4+piaz7x9R3J2KnoxwJhtpNQQBaGAc0cRiguZoNq4
        bMoXqWWHlXWn67VOtLRpCtE16srucBXUwE79gmwniw==
X-Google-Smtp-Source: APXvYqx19TOv8C6W7I1yY4YKf5TjwgDb1MgC6pdjkpOhRrq5Qy9ZNIC+gdhEXR7u63hnv436pxAen083jHJMV1kYIu8=
X-Received: by 2002:a19:6d02:: with SMTP id i2mr995829lfc.191.1565070332250;
 Mon, 05 Aug 2019 22:45:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190805124935.819068648@linuxfoundation.org>
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Aug 2019 11:15:20 +0530
Message-ID: <CA+G9fYt8JTW3q-VCyDzeU-p09d3fecr6-5D0qQoeWE7J2b4AWw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/74] 4.19.65-stable review
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

On Mon, 5 Aug 2019 at 18:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.65 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.65-rc1.gz
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

kernel: 4.19.65-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: e2fa6c5f11d562e4b6d9d0eaf3f9adea96e72032
git describe: v4.19.64-75-ge2fa6c5f11d5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.64-75-ge2fa6c5f11d5


No regressions (compared to build v4.19.64)

No fixes (compared to build v4.19.64)


Ran 25240 total tests in the following environments and test suites.

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
* kselftest
* libgpiod
* libhugetlbfs
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
