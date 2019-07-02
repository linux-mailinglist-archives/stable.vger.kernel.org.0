Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE95A5D4DD
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 18:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfGBQzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 12:55:04 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34542 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfGBQzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 12:55:03 -0400
Received: by mail-lj1-f195.google.com with SMTP id p17so17665947ljg.1
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 09:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1R/yB2CASjxkGZBlXSQDSeC5Ye1BYS35LIw0PQ6pX3E=;
        b=yzgwQUsHhYl5XIX5c8oPtWA9MyKmqC8f8PVabj7fpM5TG4SAy8t9PvusdIObTm73uO
         IvehrGlJIe/oxmWbJq23lYfCMhJHx+do7sghkN0qDWpy7wounHkaJzUKIJrnCyTlqoW0
         HVX9dxuSH7mi3RCkuyNTzaiuTVcdav09J49wiC9phqAODhY1rLSdv0AV3v1J8RmQnX5f
         EoMurmG/BBgvSAGnk6ThEAvFnSDIQPdK7kgIftWdMIUJuxHbJYnIah5VCG9dSAX8HUYk
         4r5ofqKKvdwk2sPLrDacIaD6Q5XTQG4evFacj337NEHpJ8pTzz+PWzdcwpCMLrU8hOMz
         AiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1R/yB2CASjxkGZBlXSQDSeC5Ye1BYS35LIw0PQ6pX3E=;
        b=fqwPZadej7vi/bLWXrbRY/tpjfUBE2GrAkB5ZL83R/kvnVBZHbQZX84q2KvOoHmIok
         xRyHpuCWy9kh3psqks1JPxwNyxdUAkR+1nN943rSbvzu5BdrWehpDg5ZL98+mo9/W7Qb
         UC5tqWzwYQ2xoa6aXQ65qvOKZWw8Y2SdlNfLg2TEpfgBZGU3DchacbHKeCdix57PfgGJ
         VFjWljvV97cZLsazKrbH+KtWGjO+anHPSRwrPob3KpLYThQDYXWbzf3tIADB17JR5MBb
         8BPXVMLQ0U7YxYiSvZgI8J7EJlQvnMEfmyPA/rWh57Hn4eS14lESgzS1st/Z7ae2DbzZ
         9txQ==
X-Gm-Message-State: APjAAAUNhClnmvLP5b6IwynrrsmmP+p8ahkx9mPgXI4qMk+jVw+G0rdg
        WrB2kzM1g3zuQQzkYbaFNrRHdkITgcah0LSCsZN9PmV7Z8k=
X-Google-Smtp-Source: APXvYqyeeGz0elhIilSgZsbT1jLZk2gJZGc13itdXip8q9yM0EbWiZEBEn9MAo0LKbgKbumYOOL11jVSha2KoGHKhs8=
X-Received: by 2002:a2e:b0f0:: with SMTP id h16mr18135855ljl.21.1562086501896;
 Tue, 02 Jul 2019 09:55:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190702080124.564652899@linuxfoundation.org>
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Jul 2019 22:24:50 +0530
Message-ID: <CA+G9fYvRas1wn_BYp5M2LEmNzC8fx7bEY3QT9+iUMJMhQYKU6g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/72] 4.19.57-stable review
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

On Tue, 2 Jul 2019 at 13:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.57 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.57-rc1.gz
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

kernel: 4.19.57-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 4d057dfd72c6b6b27f11e499fa7c9fc079fc62ef
git describe: v4.19.56-73-g4d057dfd72c6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.56-73-g4d057dfd72c6


No regressions (compared to build v4.19.56)

No fixes (compared to build v4.19.56)

Ran 25160 total tests in the following environments and test suites.

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
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
