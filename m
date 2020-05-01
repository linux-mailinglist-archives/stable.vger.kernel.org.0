Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBBB1C20DE
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 00:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgEAWnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 18:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgEAWno (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 18:43:44 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1BBC061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 15:43:44 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u15so4001202ljd.3
        for <stable@vger.kernel.org>; Fri, 01 May 2020 15:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yU3H1bp1SbmN1KqneTIvVQrlShl+uWdR+0noJ69T6i8=;
        b=Ob9KouPdnZFfXldnMqlFDetSkkKVrfsNBy1qrNku0+iBfX5WjAdWNnJ1mIwC9E6kxZ
         ksg+mBl19E2ZXiBizd5vT78+TdQ1NerRwghD5Y4SSBVkhT+kJcZS3sAlcDKIf+RbsE2V
         yRW3bcmNL98VKoy6cEsTxVHNLhh474lAMLRcdrp9OWtrnIHaW3RQAXABpqbno2qTS4WX
         kQeuG4bvTSJoBS0r7k9oOkpd3WYCa2oa+mwtvoHmCziJvKS3eBJMUJHelFcstx0gIZvh
         90+QnmA6Z3JaKERxjsJGM+wTJ1W7s7w3TVvGbTns/xkzGPzWQCDufy4yda198xjAGEug
         yBtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yU3H1bp1SbmN1KqneTIvVQrlShl+uWdR+0noJ69T6i8=;
        b=MYkbj59EQqOTk4ef7DC81ilt0S7Wd77dgJJWgvy2pr4MWNLwyUVjkEh3SbKOtFJaly
         xmhwLVBSHJ+L4IaflkWCzUSmSYX3fMf5rEV5oKiUG3M14h30RswYxvrH4bqKVh45s5Os
         JoK7ocZavEjGX/WjbA2j/T7eIb6tH+S++VVlKrRv6S0Ti3COoPjTsydOTnA55eY14dB8
         h2ziYlWilWtH7lGrdiQTrMzuuFfi0sMtP8lFoXGeSZ9FysseCBEXZbSWDTGIbpgXACDF
         LkDzBE6rJgQrhWEanjbQvWKKNRS0AeeNt0rxE9WNFBQYan7/+J67ohX9wpFfyujoIPsu
         RW0g==
X-Gm-Message-State: AGi0PuYhE0w/mdexigSbyLS+mMaOsHlJcYduN+qdmYfJrMNcTccdVLf+
        xoZ1zMC1o/CGk+zdvZI8SlhnEW786OW8qoYLkZyhog==
X-Google-Smtp-Source: APiQypIGEp8Nl2qMTwLfi/AZJY8GBWeVVL6AImg/8pOkg0OydLzhnLagbiwsWhTJW6ECacUE1t0HlJFOtXOLb7OXNxw=
X-Received: by 2002:a2e:9018:: with SMTP id h24mr3585133ljg.217.1588373022354;
 Fri, 01 May 2020 15:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200501131513.810761598@linuxfoundation.org>
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 2 May 2020 04:13:30 +0530
Message-ID: <CA+G9fYvmgjmJeL=TR=FRhyavhZi_Gn_3EOjgPgRxfYTLsVE2Eg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/80] 4.9.221-rc1 review
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

On Fri, 1 May 2020 at 18:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.221 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.221-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.221-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: c0dc655ddaa63df35b8601af24a8b8b42bbd303a
git describe: v4.9.220-81-gc0dc655ddaa6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.220-81-gc0dc655ddaa6

No regressions (compared to build v4.9.220)

No fixes (compared to build v4.9.220)

Ran 24031 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
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
* perf
* v4l2-compliance
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest/net
* kselftest/networking
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems

--=20
Linaro LKFT
https://lkft.linaro.org
