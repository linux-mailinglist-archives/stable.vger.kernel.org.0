Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 201A6128B4
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 09:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfECH0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 03:26:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38768 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfECH0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 03:26:21 -0400
Received: by mail-lf1-f65.google.com with SMTP id v1so3719099lfg.5
        for <stable@vger.kernel.org>; Fri, 03 May 2019 00:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Dsx2nXK+/+DVPRawdRuGNY4tbTYcOzkd9mRb77NUkhc=;
        b=fLL9islumkeJwquqsV3AdztTa9UUhx1CJKwMbsNVK9OO+1EwAtB32SOYwN8vs95wj9
         IpS8pZoRPR8XTQ5oIQV2bu2sG25Y7vVHBx6wqJiH/FaFQrRqzi26+o3PVrcNeCOBzHh2
         88RmLANWQER0iphjz4xHyMxz2BGYwB2//UBRP0nMle+WvWSJV6T9AzmFsI90x42fBmk1
         rtOp5i++qLQyuwkTvmUlXRkhe5yZ9ptpPvDtLQOcHHW+AZA3Nuj00gR/aRifhw+OxTqC
         R8t9uXF0K4dO7rjZcaMP3JhoWmXUsJcMe8JtkWGA27lUcebVQUyP9i32/stOyLpkpCsA
         ZCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Dsx2nXK+/+DVPRawdRuGNY4tbTYcOzkd9mRb77NUkhc=;
        b=IDQcHRbQgHnuNIb44KnKoapD2SFIfcgFGm98ls8YTc4RCyFwit7UxuqK+gBwKy9mzE
         l7Pyf47AGz1oxKMwHwi13TOSM5NP1F1Q3uHe8YccviOVUfl67KFqnIubxcsLWvQwrUaw
         9IIcrjO5c7W7bME9QXxSemjO43BdFsiHP4ktDRwzHb4T6BdT/RAiJV6JFnqA2TiN7SKE
         TPUuRTPoO4rd2Jvm8jgke64ewZp6Qfczvx8W1WsZJ16AmjreqNoDxPYRDcY2GTvNXXdB
         OuEYmzyai3/i1BJmSIvvuWSdqihTBPSKLfaDwRi4OsY1haMjBFvgqEwjxr0k6zsBRrNQ
         Rhyg==
X-Gm-Message-State: APjAAAVMRA6ZfYliV2nIiduiYt8bUyI/yQGOpgDlX+k8n1FGptzSxKRV
        idN3GciMsWHVHQNlF5Ye4QxFIrmm8SeZjPtMOyr3jQ==
X-Google-Smtp-Source: APXvYqwWLW9DwsPqwigRfqef/inQX/vsQrqYzz9NOhx4A4hUCtjln4I6wv88+OD37fuI8tCCb228uIu1fOsGRh9Zd3c=
X-Received: by 2002:ac2:4246:: with SMTP id m6mr1659473lfl.0.1556868379684;
 Fri, 03 May 2019 00:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190502143333.437607839@linuxfoundation.org>
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 3 May 2019 12:56:08 +0530
Message-ID: <CA+G9fYtv_aPXHZ7JtA1HzfQ-j2nzRabnA1tWWG-_Xwkf8UK4_g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/72] 4.19.39-stable review
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

On Thu, 2 May 2019 at 20:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.39 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 04 May 2019 02:32:17 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.39-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.39-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: db2d00a74567be6e93472fcc4bfa8ada96cc6397
git describe: v4.19.38-73-gdb2d00a74567
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.38-73-gdb2d00a74567

No regressions (compared to build v4.19.38)

No fixes (compared to build v4.19.38)


Ran 21232 total tests in the following environments and test suites.

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
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
