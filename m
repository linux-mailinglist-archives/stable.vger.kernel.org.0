Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4682619BCFA
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 09:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgDBHqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 03:46:00 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46417 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgDBHqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 03:46:00 -0400
Received: by mail-lf1-f65.google.com with SMTP id q5so1846995lfb.13
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 00:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=POxEV3gj5cjnPO9rMI9IMD58/NUgIZeKUsyUnyCZ2LE=;
        b=W+yspeD4JWWsnqpgdHoGlADkiuEdPw59EKlpn0eViFz5wlHzKZFkn1Z7OyaHwxPlLj
         Y8gTLnmmrwKafg4eJmpFAnfM34L/NErzk5P0YdYUk4Rpx6KzxIqnJYeaZsvbFAEzDedJ
         gZKSN+cq5RKj4+jc9odCyX78ivhNB1AZbczFK575LPeEdhHIVAL+J/cN2LMeif/yj9Z1
         amKW27YaVIRJdlbzKLvVA91rFUImtGdXXGyztq7kit7Rs9s9wrnSx+KOt8sn1giAA2xZ
         WDpGbAeqKeojXLXL1rBBcwD0Nc8Hdqd4uTpKpYh8sPAtppfiHmgakSSkbLFdeDO73DPy
         lsTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=POxEV3gj5cjnPO9rMI9IMD58/NUgIZeKUsyUnyCZ2LE=;
        b=O/+FXNyk4ZHdWnoGSnqlmLgZINHLBNs9tMDcfz+b3eA4h0EpZpxxcOexFbgTO5qcx4
         RnDB9wUz0MY7aO55xp2rSh1Pp+4DHSCMHZl3u8d11tlWnTkhJNw78cBD4lG5XfJG966t
         zSde6PhJ6WXux9kS8ZlqI1s5SpVxnmXQNhAcDl95cY6U5xk8tr7ChGcTY1z83jvgMRKT
         e5oJUbA9BTm+0DiizFGbXbVqtWsUohk81J30JyRTE6hU3O0fD/i2/8kphJ0rn8WL10BL
         GW+pN+KSV3WSxihzW8Em9EpCeT7Of2jGfoRKwJOe8KyXkFC6NI72IHikPxyyL8t++Bjv
         BA/A==
X-Gm-Message-State: AGi0PuY3B2W0xHDbVCLlpXyyf53YH0w+vdd4ZvNdxBrQu+HR6a+zBmLU
        HgVxHjNlGC4U/2XRLUxLHt0wrgP5bmo9HXqZDynN+g==
X-Google-Smtp-Source: APiQypL6BCglL+mKXWvslatfZWl30Hc678f0SMa9dY0CVlHkkFRnHXupeBxR23E9415HjLdGtIqX1ujoq7hN32HdbkU=
X-Received: by 2002:a05:6512:21b:: with SMTP id a27mr1309779lfo.55.1585813557262;
 Thu, 02 Apr 2020 00:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200401161530.451355388@linuxfoundation.org>
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Apr 2020 13:15:45 +0530
Message-ID: <CA+G9fYswn5TeEeuoNLx6i95tsaEirahBjU1V7Rc7ZMj2Lc6K+g@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/102] 4.9.218-rc1 review
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

On Wed, 1 Apr 2020 at 22:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.218 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.218-rc1.gz
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

kernel: 4.9.218-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 61ccfbbfe9f63b4a44ef11f9ad40d362970cc8fc
git describe: v4.9.217-103-g61ccfbbfe9f6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.217-103-g61ccfbbfe9f6

No regressions (compared to build v4.9.217)

No fixes (compared to build v4.9.217)


Ran 28143 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-commands-tests
* ltp-cve-tests
* ltp-math-tests
* network-basic-tests
* ltp-ipc-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
