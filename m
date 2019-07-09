Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F9462F3E
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 06:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfGIEQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 00:16:22 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41650 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfGIEQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 00:16:22 -0400
Received: by mail-lj1-f194.google.com with SMTP id d24so9008732ljg.8
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 21:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=01/N1A7OKejZO4iVGz3ACnbrz0rautscSukM3UR9o6k=;
        b=f+huVF6Rdi/Q3Wi+XLxWbLHwwwTbJvpfzzP1rw1zouPZDUKUT3Pg5ddY4TeDnatyGd
         6EXq7BLXXXdgmJsA+d6zDQ7f5k3jnJ0eXwhhGxiuHSeSulrpOiRXE2BMoT7+uOQ1f28u
         Yz7e9hwJe+vBLDNQF5xAhE6yhjl9DQGd1skSAhd2w4EEyWeW34jg7KBPsWgLbIGf3ksD
         RzDQelgvpIJZg8yvnYqCuq5F/parfZtyqHeA7lv7CtFXKt0ivrSnsX4zfIRCAAg3nDFS
         pH8FvrrlIoHGBw/GpLzFByqYnor1eVlB7MT9Fm8VjfhU94H5H0L19cQDisDBYiOrHpjr
         Kurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=01/N1A7OKejZO4iVGz3ACnbrz0rautscSukM3UR9o6k=;
        b=rklmMSyN8L5l82XPkx8Z+OopQIkPxwvr+5ExfErco+s5H5MFaGtyhJj69zGHM+4Ajk
         4ijC68FtR5QDDIAZhRGD5rAz2mN86Se4rRBTQJbVsvjWxOKvX5YUGpYX53zHUTKjbE2q
         mySsE2ipYtCBSfsI2+6Ryz8wL+G6Zb/7XZwSux6bcDTk5Mqwe+Z+INzBcXKRdOUL42wW
         mZsDpHpCES17IpsPwpD9aA5wkqH10O/8Vxvz6q1o9bK06gNA3y20AUHUxM/6SX5dav+5
         niUHT1uCRd1cldetliJ7FshBe6gT93pBKc9XavesK5ZBDcFRGmJxoBwKP4mY2Bo12xUC
         uirA==
X-Gm-Message-State: APjAAAVH1V0fUU5xKn9Pk8iQxJkhju2PhSSRs09Tl9iNvsFehBJugIhl
        TXFM42v4rwAAbvzeQZuFvWsASs7z4FLEBoiuKURExfHuQRU=
X-Google-Smtp-Source: APXvYqxQggoQC3JVKDxDmP/78fNp0reNB8aJzXQoiiKy33l1npEUt9p3zEDGNulvAEYBu0+jYPYXObWW7iHYKk/XZPU=
X-Received: by 2002:a2e:85d7:: with SMTP id h23mr12699643ljj.53.1562645780378;
 Mon, 08 Jul 2019 21:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190708150514.376317156@linuxfoundation.org>
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 9 Jul 2019 09:46:09 +0530
Message-ID: <CA+G9fYs5hWk_BqTy-jQdiTXXHoDpOdThF_RsqCjeyGEFCE4b0w@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/56] 4.14.133-stable review
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

On Mon, 8 Jul 2019 at 20:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.133 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.133-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.133-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 5c87156a66f25c493e12b023972fc2ccae813204
git describe: v4.14.132-57-g5c87156a66f2
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.132-57-g5c87156a66f2


No regressions (compared to build v4.14.132)


No fixes (compared to build v4.14.132)

Ran 23716 total tests in the following environments and test suites.

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
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* v4l2-compliance
* ltp-cve-tests
* ltp-fs-tests
* network-basic-tests
* spectre-meltdown-checker-test
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
