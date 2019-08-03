Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20DC80483
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 07:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfHCFrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 01:47:12 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35448 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfHCFrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Aug 2019 01:47:11 -0400
Received: by mail-lj1-f193.google.com with SMTP id x25so74834806ljh.2
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 22:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sp3xBWhCet2uHYhWCL+eN8Xzw3ehozirKeC8djMe/nE=;
        b=A2Ypxdf2urWjfIdmbkjOgfaBqOUxCTyYlWSQ1leZzJp9wD+4qnIAIl7RtrnYJYPFsM
         zJ/HqRqDqujQ+SgxUVqmoCoECZ+Kr87wryewMyeY5hUhal/+zEtU8VBa3kVeA0K2cbpG
         PjmgsxmJNhn4KFbFGTzk0cgzZfipi4JCjk8bEjmDlQN89CkYRlGhoFSGebYnEZxcNmc4
         0Mvwz6FJyq6tFfspO9Aie6hV/QU1DXP229u3/L3tb7RKxmBl1/SJ+m89EMKTQvVXL7e2
         8YHYhBEObNCz9n5pVCH+l2QlT2o42U4MztFm+u2+Y0pf2S5BDWnxAvGOtbRq2OhOtzIG
         cNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sp3xBWhCet2uHYhWCL+eN8Xzw3ehozirKeC8djMe/nE=;
        b=JwXj7L4b2l+AwYMswsirb1r9c7HVCDQb+lS30jGYUgg0nRkeZ+D6JmT8vWU3e9rF7B
         QPFz9LCrYsot9Nd0TDUHDCZNeUwpwkHJWi1ZEooUZDKLpDFn0Q6mJVhGMtz2PCDZte7t
         uQEoZlOXp92XdCG/Nq2KJr2GMU+9YoBo/XSfweTJp3d6OMIgBaYFf1uLyjkxasde1ek1
         86rVEGSq+zc89O3por79buaSEPio1drD1nhLOuJK4cwSfPfXJTeXs/Gy4pQUg+ABjEoe
         gc0tq4JgZkTcnykvXyMzxGSuSydG0JPnPiNqmMus95wDjdktAZT0wb6GykxB6KYy4xG1
         xE0w==
X-Gm-Message-State: APjAAAUvyRKlxNHfdWVJVJkuhgIfjdc4g81uADbcO9hYNQC+JNVrHNRF
        Y4xi+rqFiM1ljajrn8KL/zwBRMlKN1vD26A2gzwCWQ==
X-Google-Smtp-Source: APXvYqwfS/HOB8sCMzIaeFFYTNokqRqb8KhJKRXY3B793uno9qKlahv/5kOssC4Eysx/ihpZx23wRWjQ+Z9/RUOQePI=
X-Received: by 2002:a2e:9b4a:: with SMTP id o10mr16812178ljj.137.1564811229861;
 Fri, 02 Aug 2019 22:47:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190802092101.913646560@linuxfoundation.org>
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 3 Aug 2019 11:16:56 +0530
Message-ID: <CA+G9fYsgfxjGfPDfnS=Z4V0zv5Xh2bMEdqVu5oULA_ApFKsv6A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/32] 4.19.64-stable review
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

On Fri, 2 Aug 2019 at 15:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.64 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.64-rc1.gz
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

kernel: 4.19.64-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 63a8dab46af2b65ecdb5a83662d94a3a26be973e
git describe: v4.19.62-148-g63a8dab46af2
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.62-148-g63a8dab46af2


No regressions (compared to build v4.19.62)


No fixes (compared to build v4.19.62)

Ran 25243 total tests in the following environments and test suites.

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
