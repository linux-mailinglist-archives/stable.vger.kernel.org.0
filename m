Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76EF91FE8C
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 06:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfEPEkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 00:40:02 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33437 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbfEPEkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 00:40:02 -0400
Received: by mail-lj1-f194.google.com with SMTP id w1so1824598ljw.0
        for <stable@vger.kernel.org>; Wed, 15 May 2019 21:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t/yxYlsGZjMrGCDvf8/6m1cTXsqp5AKZTp8TY48QFvI=;
        b=pwgN1ApuOdceCJgr0/pvhFR+ueL15U+3s1cU7qQTSZBuPbEppTkWnCysvMAmGG44KO
         uLMDo/gpvEqmbnOAZUZCxF3kY+qV9dajgmlcmL2q8PFvlChPtEHPkavR58a8L4KOa5bx
         1HUwiM6BszI43YhgIilElluaEyNjmSHAYRJEk8t2j7U7mJhAGJnBGZh6Y16ccPBv3HKP
         6lqUnGA98XJB83uKYZirNxJUtOSYTTRpaXDYkTsur/B1nn7SyFERSZLPHe6W9cp7LUMl
         B5VUik/kS52QgECNWAVWiPJDkXDdQyaNAdB2/udah7mB9z1wnzVVDdM/dFpfr0NxRyY5
         RQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t/yxYlsGZjMrGCDvf8/6m1cTXsqp5AKZTp8TY48QFvI=;
        b=IoQ6HYU7L8lRx5R31I+JYnhdOek346J5cxpLerU8sQBSJzNT1N4owdPfKKntg/noWl
         XCEXjPqOfEVoVuiV18U5JbrnVJGDxo1cZ3RyRwnMi0be0+/BivonsJZHNwK+IzQan66K
         uekn+7RlevWbaGaLimDjXv7jdLTbqoTbKod6QH0Z8sev8IYzmFb4iNFdHWqSVNtfh1GV
         9wUnyPJbqBVjUAoKN4RSOKQI12Lzv3hyyyLAOybkGWYNNKawEWpqb+nDfXVScCZgy1k6
         P1SqLSXqs39m3Y9BJJG75Orsy+atWxi+ANLYKjan9mEfJBPPC9WpRPunhUXhp5VD8hDx
         TlGw==
X-Gm-Message-State: APjAAAVJqI1Soa9CNPtnGCone+9xdOJMhxfp0nDdFeZ+PCACFEc8mLfo
        FOGzEUpYMPVCZkTfFu4pauSEwaUQooB+BwJWIZLjlw==
X-Google-Smtp-Source: APXvYqxM0ieUhv9K5uL09LD6pyZgA8iT0SRupjeCQY1qrr1nZMbYmCWJ/F7L/UfY+zz2tbRrAEUuhKi9JsdY6PaTtLs=
X-Received: by 2002:a2e:8796:: with SMTP id n22mr10236816lji.75.1557981600193;
 Wed, 15 May 2019 21:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190515090722.696531131@linuxfoundation.org>
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 16 May 2019 10:09:48 +0530
Message-ID: <CA+G9fYuqG0VGyMQQRA1UT4rTH9fku7ZoZByB2D8rh-mppAVwkg@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/266] 4.4.180-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 May 2019 at 16:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.180 release.
> There are 266 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 17 May 2019 09:04:49 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.180-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
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

kernel: 4.4.180-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: be756dada5b771fe51be37a77ad0bdfba543fdae
git describe: v4.4.179-267-gbe756dada5b7
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.179-267-gbe756dada5b7


No regressions (compared to build v4.4.179)

No fixes (compared to build v4.4.179)

Ran 13304 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* kselftest
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* prep-tmp-disk
* spectre-meltdown-checker-test
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.180-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.180-rc1-hikey-20190515-440
git commit: 4acf8bfa73bb083efe32d6b2623a48f49e662657
git describe: 4.4.180-rc1-hikey-20190515-440
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.180-rc1-hikey-20190515-440


No regressions (compared to build 4.4.180-rc1-hikey-20190515-439)


No fixes (compared to build 4.4.180-rc1-hikey-20190515-439)

Ran 3043 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64
- qemu_arm64

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

--=20
Linaro LKFT
https://lkft.linaro.org
