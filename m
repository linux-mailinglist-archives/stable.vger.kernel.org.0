Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6515C30935F
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 10:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhA3JXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 04:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhA3JWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 04:22:11 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A43C061794
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 23:13:30 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id d22so13138196edy.1
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 23:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1pLTWXoNtezrbyauA2L/M3lflfYp3KQIjDaYKHQ2k4Y=;
        b=y8bJwe5T9FuD1M7gf09Kj7XxK1wrd/813kU57UJnzD7j8NUV4e5/mGZTyD58MWAKhG
         hAuMDpiBAmbJouZK7U38GsRzQqqheOY89QtZ5aN5EtDztz6fhc0sSOBNp0EncZXUt0jf
         5MoGMj+rjEJVloDfBEzDFU0C2u3/2R+AEX/pdNheVY/jBBlK+zmdsjVkuogL+Kw7Z+U6
         T8wFquQKXjcVnVEbuq6UC+9PW3dkfFJxE3uGgynj1g42Y9SF6mLnH0Alac4pj18dNc5f
         MrKTcVNVzCFNjm1jzrzT3u7qWg75PWezfkOOnWxBSICpm54ouy9rNsEJRCio8u1irRZ/
         88zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1pLTWXoNtezrbyauA2L/M3lflfYp3KQIjDaYKHQ2k4Y=;
        b=jcvbadHWnyzhj162tMe51dgeaB1EkNsZCHRXWDJwjdij8rpWdzuoBAsEI0Y2q8MyCd
         iBh/88QTkf/bV1pisgVD6+jR7YY95qamf6asjBG3ojZgxJ2UerfoRqiE7uqaSpX9lIkO
         XDP5O00eoJoEUnHeH+t6cdh0WDbkjIUAu5RVHAiszC7JWXyV3ZrySFYzutPksvW8lSpq
         NGvLP1VvU6kBeqH0M+rsp2sTtm1KqXMC4KO/HFFYTJx2Ts6a5PBaWADB+/0CH52WzsR9
         mGCYdIJYzYaEMaCPpgnZCLmWj8W94YZGcr33CtDXcxczcfczNh2J7itmi05Xg3HAyHla
         VsAQ==
X-Gm-Message-State: AOAM533R/CZQ0Gv2Sc2DTmppOvh3sFEMns0uH1je/n6exRRjBiU1fcBZ
        Rr4dzkz1mVPrt49WdXD6cuUq9Yu2SdSNNiAKvgal8w==
X-Google-Smtp-Source: ABdhPJxNLs7StWw586XQu0YpUsIYwDIq2EX8qB5QaannXsyOx7gClFtRhlQdxAg+eBWbrevkieK5GnI1nDX7nIx9tuk=
X-Received: by 2002:aa7:c384:: with SMTP id k4mr8845680edq.23.1611990807777;
 Fri, 29 Jan 2021 23:13:27 -0800 (PST)
MIME-Version: 1.0
References: <20210129105909.630107942@linuxfoundation.org>
In-Reply-To: <20210129105909.630107942@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 30 Jan 2021 12:43:16 +0530
Message-ID: <CA+G9fYtT+ZpRtyXAe1DJHhFobDJDuNo8zg27xeHUN5RR8QuM9A@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/24] 4.4.254-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 29 Jan 2021 at 16:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.254 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.254-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.254-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: a1b3543d6297bec490fac84f5c93f620ba4234aa
git describe: v4.4.253-25-ga1b3543d6297
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.253-25-ga1b3543d6297


No regressions (compared to build v4.4.253-21-g39d0697414c5)

No fixes (compared to build v4.4.253-21-g39d0697414c5)

Ran 18438 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15 - arm
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* network-basic-tests
* v4l2-compliance
* kvm-unit-tests
* libhugetlbfs
* ltp-cap_bounds-tests
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
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* ltp-syscalls-tests
* ltp-controllers-tests
* install-android-platform-tools-r2600
* perf
* fwts

Summary
------------------------------------------------------------------------

kernel: 4.4.254-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git tag: 4.4.254-rc1-hikey-20210129-909
git commit: 1ed9a45adbcf3362d6299d7d9eb26d2fecc1f76f
git describe: 4.4.254-rc1-hikey-20210129-909
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.254-rc1-hikey-20210129-909

No regressions (compared to build 4.4.254-rc1-hikey-20210125-907)

No fixes (compared to build 4.4.254-rc1-hikey-20210125-907)

Ran 1721 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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
