Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFA04DF67
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 05:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfFUDxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 23:53:13 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37243 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfFUDxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 23:53:13 -0400
Received: by mail-lj1-f194.google.com with SMTP id 131so4677450ljf.4
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 20:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FrrvTHho78EP5KoZwnELQ+SwH7ZAGxfQLwF/qbl9Rvc=;
        b=zOwG4AOKjZuHQO1tV+XR6kkktAAUlYhiKzUk+P70lBPEePHK5/hS/6S5pgENPa0Xxq
         lKRE6zymJwCCmLjjOgjg91NO3uqY94zYl4NZ6+IzRkn77nLWJeQhYr34yw9QfQB2VAMU
         eAKCebLsfQR+BtEBWlbBUlnHbwDAdFZZYtCNh5ciC5yJg36lRPJkfDNmT5regus2biQs
         V5/B5AXgmwIOHhy7TiCetM+famhR8l2+ZF2z7JmxcgCGEUJHM5cneewKqG3YNXAiWr7T
         eMmnU3X2NAEX/HpPR+wu0IF+iGg19MQY7sT4EnfzaD2YDRep8E3wAAnAB0gRyx4vZ94j
         nedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FrrvTHho78EP5KoZwnELQ+SwH7ZAGxfQLwF/qbl9Rvc=;
        b=UrRnsNIcKp8kSxcL4+tjr5q9wNp0PRIxWfIU6L2sFpHP90s+5gcOmGX9ZXJQLxYEIN
         hQdPczBpAcR1Euva7cwyfjGIjv0M5wwbx3vtUIqnguxEYsWtDAM6zkI0IKhHSoyp3Xy6
         5loYwCf2tX4acALvJ80MnYaVMuCAfyFpwdE4L1TsDRE0HrDh3s7Mj46jWFRsMTteWcaW
         DJ/DC02hpZ5NqaR6OTQMvQR+8IEKMD1rHyKsCF8eaKBxEHut/dRnYF5kaAF9bUkK7qvX
         iW6hFZKk6+RgT2A0XJlKPmuabhncMOVMCyuHTDN8ifBGevKZNk17l5cAAWlYOVJljpkY
         eTSw==
X-Gm-Message-State: APjAAAUGkzhW3joGF1GKhGwB5v5VnfuMSkTK3Tt/IfgNf42Co3+7C1Up
        V0zpubLg4lJPrYf3ggVYszHRLYGOZ/l8zuqfD6P/dw==
X-Google-Smtp-Source: APXvYqygyRMTirpZrOw1xE7h5+5DAyC5gzJ/81Sz+cMwydhZF23uBzd0dG2gpwjzZQ12ARBpxnBkOMKPZoxKz//n+1c=
X-Received: by 2002:a2e:824d:: with SMTP id j13mr70390472ljh.137.1561089190895;
 Thu, 20 Jun 2019 20:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190620174336.357373754@linuxfoundation.org>
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 Jun 2019 09:22:59 +0530
Message-ID: <CA+G9fYstNR0bDrPiZHiXdX0bU6AnALU1inYm4JN0047zDKpoEQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/61] 4.19.54-stable review
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

On Thu, 20 Jun 2019 at 23:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.54 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.54-rc1.gz
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

kernel: 4.19.54-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 8661e38ef458269230688e503c5a1c50232e5fa2
git describe: v4.19.53-62-g8661e38ef458
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.53-62-g8661e38ef458


No regressions (compared to build v4.19.53)

No fixes (compared to build v4.19.53)

Ran 23617 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
