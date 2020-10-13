Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B848328C879
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 08:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388968AbgJMGGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 02:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388373AbgJMGGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 02:06:52 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086F9C0613D1
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 23:06:50 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id y16so15014205ila.7
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 23:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eFTOfIX04YskqDzw6C2yGbBW+Dg+sRy/DArqeoWHweg=;
        b=sq9jJ89V8yX+58zWqNjQ4erlOeCrJHDdaX0RZsimnOg0w8pzoA/bECEJsihLt7TS/F
         8SmYH+iOjWT1Vzu6ZM4J0IBhQUP2bAX39xj0p5WWBpKVbFuoSvqZ4iVSYereHwWEO2DN
         iDPRE/Z/SaMhBhMZoA1i1ncYA61L9oZfeB65WoGd+dXnD/8kcmI4Sy+NUpdO+/by+0PY
         h0nK7uy1hoqUgg4imW2H0BQwff061OoEU23pAuOWAa8Au+rs/G2QFi4xszSDEpRM/keH
         dvZwCCX6uGKZ8Zet+56+oa7dZ1u0Owpon7i7bAJbinZ5K/OuHsFNeynk6GZqwJYI9Xct
         MUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eFTOfIX04YskqDzw6C2yGbBW+Dg+sRy/DArqeoWHweg=;
        b=m9vTcP1kzSD2xWvNVD1/2Li/6ZydO4xqNH340NP6dKi4TNFXZ5PA83TOdwk5+mqxWD
         35GBodKySCfcRdkpw5Gg1rZSkNoEna5W0WyX8GdyrqjW1M1ZRgXKhaROOSh+4d8oXeAt
         3qzBZAM7feI6OMGUzZ+1XhJjg6Hx7ARk4wN6K/nZc0izVaDPuFbT4HbKLyaL1nDkNmdO
         PvYd2uM9esFR9koES+LDZ5zncwUgGdJtlUg578vtDrdkmLvOa29C9uGbjaBhHgKNsTj0
         zLhPg6Racbi+BMgHiIRvtxRF+y496CwkNcjeqYz2Z3Doq91cGvCw2M1KXIbn6Ry4Y+WW
         /sUA==
X-Gm-Message-State: AOAM532lR29w7CcJfdNnQhtYSqG/jBSUIMbm/ifxbZnGVZ+9ksesvK67
        +LcL/hszv0Akvn7Ohez0ur3K+ZGmeWYE++Zer+HU9A==
X-Google-Smtp-Source: ABdhPJwMybuGW/SMzwJdeSlAH2zehESMGS/lBUv0o7rc1hqgQtr1g4BEXGFLkbUIokkBR5rvstbitPFCYRbKcgPb+BI=
X-Received: by 2002:a92:9944:: with SMTP id p65mr1794376ili.127.1602569210160;
 Mon, 12 Oct 2020 23:06:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201012132629.469542486@linuxfoundation.org>
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Oct 2020 11:36:38 +0530
Message-ID: <CA+G9fYvnRXrSOohwHorMWQ4bG53NHy6zjuK1XVicM-4UwkBfjQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/49] 4.19.151-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Oct 2020 at 19:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.151 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.151-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.151-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 7457eed4b647560ae1b1800c295efc5f1db22e4b
git describe: v4.19.150-50-g7457eed4b647
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.150-50-g7457eed4b647

No regressions (compared to build v4.19.149-39-g204463e611dc)

No fixes (compared to build v4.19.149-39-g204463e611dc)

Ran 35109 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-io-tests
* ltp-math-tests
* network-basic-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
