Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD48DB81C
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 22:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393263AbfJQUC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 16:02:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44345 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394622AbfJQUC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 16:02:29 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so3827647ljj.11
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 13:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uyfTpc4uoGGfUXhiiQ1ULESUjtJAjGktU/a6QTF0Zxk=;
        b=ODXUKTq6gV6Zgod339kE7rlWH0ZnqPl50KwGglJq5xCspeReCHnduUb4AEu3vi4e91
         HiDEvxN6Cea4dbNCmZa5h3CySEQAqwknzeog8qejMsL2mUcmJCtl7aGsCN0L4uwvZ6N5
         o/jhjerrNZxplOaJXZkIT0nHd21x4oqgULlstIPItodHfnnzb37w7EOPg+EOX3p/CKL+
         5VZiP32aIaSqJCHhREt/zwIZsiCwyUbM+7IRJcNWjWbu1oCsscAfFOR/MycSsagKUics
         XCQXUNZyU7MwHpjkrdFWnNu0wNqDO7BelKt9XD2SY8GJmXaahzmZgqxB6eZ2kppDdEHK
         B5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uyfTpc4uoGGfUXhiiQ1ULESUjtJAjGktU/a6QTF0Zxk=;
        b=jlS0H4tb3WvDeSiug2KLSVJwh2C/KyqQxjYR24edTcW/Tsk8mfVk5ZDzTeOqmz2YOd
         /Y38BrudBGhuMhtZ8ffNFSK5b4dwYDLNMuBQ+A9Ii0Ptv6YJNyt+vPC+Fqi7QF/c+0pb
         QvoWFNagz1YhoHKTJ8aP5hSCyNEdxNmmW7qXsNat564Pm9kY4B+IFYAc9dSLwaLQDsFO
         USCo104LHfSuf9mgE3V0F+7cNUjaHdykJlSUI8gY/4XwYYVY0om7IlvYUxuE7GI3qxo8
         4IowKCd6EipJ1RAz9ppcAvQB/rpMA2j9aqPMDQgNb29KUPE+bFlbyY34quQYdewDmKnN
         KYuQ==
X-Gm-Message-State: APjAAAVQhg3bRcKUQ3xys4EQUTwxJID3dSDqum9OWDVsnIeh5SEmnD7X
        c6CGDCdZXdhdv/XUfdOKg9v3rPX6rL+u9ivcraOgEg==
X-Google-Smtp-Source: APXvYqz7YfwiA1STU4iQjyXHFbERzSURVwH4loWX5wkYhcI2X5zdovKfhKrbF7BblnhYxlc1K6FFMYSctkyjJv+atac=
X-Received: by 2002:a2e:5354:: with SMTP id t20mr3675619ljd.227.1571342546083;
 Thu, 17 Oct 2019 13:02:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191016214729.758892904@linuxfoundation.org>
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 18 Oct 2019 01:32:14 +0530
Message-ID: <CA+G9fYvfDTFpba=XTMvOebUjJO1x3keK_cYiEq_x28OEHnatpw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/79] 4.4.197-stable review
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

On Thu, 17 Oct 2019 at 03:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.197 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.197-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.4.197-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: cb63cd392f388e3874d4bc23b0090c3e137bf22d
git describe: v4.4.196-80-gcb63cd392f38
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.196-80-gcb63cd392f38


No regressions (compared to build v4.4.196)


No fixes (compared to build v4.4.196)

Ran 12991 total tests in the following environments and test suites.

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
* ltp-timers-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* libhugetlbfs
* install-android-platform-tools-r2600

Summary
------------------------------------------------------------------------

kernel: 4.4.197-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.197-rc1-hikey-20191016-586
git commit: 8ef378ea28b5d306c5655fc0b219b8dc01fb1b3f
git describe: 4.4.197-rc1-hikey-20191016-586
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.197-rc1-hikey-20191016-586


No regressions (compared to build 4.4.197-rc1-hikey-20191016-585)


No fixes (compared to build 4.4.197-rc1-hikey-20191016-585)

Ran 1523 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
