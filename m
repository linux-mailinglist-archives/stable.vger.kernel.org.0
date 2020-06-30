Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26B020ED40
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 07:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgF3FO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 01:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgF3FOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 01:14:25 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80451C061755
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 22:14:25 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y13so10568159lfe.9
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 22:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W69ph+i0GrUHBE6EcCTuT/obYcwfDKs0cbLyOStqOtc=;
        b=pTpqk02aElatHhMshdGJvvxKDo+gn5r+Y5C8oJa5VR6XW/ufOsRmN6rKqFSkDMFldr
         NIjKL9FJ/D/qmY/tSL/kaizmj6RY1k9g2F7scQZlqvf3bEM5FzTv3EFnmayHtWQsezTM
         UHweAyFsN2MNPY39HDzkYbPXvA5fq79JNmhdr/gD3TGQvE0jU0OSHewzV1mdaHzUvyw0
         hXbnegzNBrMvJI+6jdO2j9buU3bgxf63F/zC8y/YqBEfHqGLHu8/ba8Crk+DqI3G1fEj
         dSfBUWQvlKjgOLV3qRpyWL1OHCVI0K6qUkom5qULrF46JRKbGfsCZ5aSYcV2edvduRyr
         YZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W69ph+i0GrUHBE6EcCTuT/obYcwfDKs0cbLyOStqOtc=;
        b=hsYu3d53uQf3LgZxjkW+2eIbAzKzCJx7hNsMkInG5BnJwtFAL1qpXyz/FpdaalNB6m
         3Q4Iz0ekB3Xr6ijjspeEFcsf0lFxEpG+ntHzSxSYQmRM7YQw5OUnv/d7d2LJQQnrqS7d
         V4v9mj9G8LJ6iLdAA7abTHySrYzunL/mhr7aOaSa6yAKncN6oTFwxZxit36IA2KhMCxI
         8hcu9NabsXePpHvoegzlcZuDq0hCJVvJ1hEgJOUgTSvDJ7Bs3rIpkNSUA3BVetsBoY1a
         vXj8CISe3Ppbmbfmq9zGX95OEqQttLKxySv/wypb5PWkz6I3K7ipjn1FtBdF1THGp3wj
         l8Ug==
X-Gm-Message-State: AOAM530/oxcRtyaOxU+REjye0DY91/XOOes1Ez9vXPxOcBG7bZdI4zYV
        uMoknEq/83QuzdMV83zdRbbf4BcDFUKNUecby4fBXQ==
X-Google-Smtp-Source: ABdhPJyQyCEgfdcfcd4bxOyQ1pV8XyLXbUtS8COBDcfz+GkZVBiKtmMhGz4nw8J25sfNsNCGjyX9Ud3h+W31/CCxGN4=
X-Received: by 2002:a19:4285:: with SMTP id p127mr10507224lfa.74.1593494063781;
 Mon, 29 Jun 2020 22:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200629151818.2493727-1-sashal@kernel.org>
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Jun 2020 10:44:12 +0530
Message-ID: <CA+G9fYu0Vq2KbqonYwp-mm+STOg5yKDjqHvSeFQ_u-VbaLjgUA@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/265] 5.7.7-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jun 2020 at 20:48, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 5.7.7 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 01 Jul 2020 03:14:48 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-5.7.y&id2=3Dv5.7.6
>
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> --
> Thanks,
> Sasha

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.7.7-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: 97943c6d41ef2b05f4e064eb49a538ff4b405809
git describe: v5.7.6-265-g97943c6d41ef
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.6-265-g97943c6d41ef

No regressions (compared to build v5.7.6)

No fixes (compared to build v5.7.6)


Ran 36511 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
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
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-math-tests
* network-basic-tests
* ltp-controllers-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-securebits-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
