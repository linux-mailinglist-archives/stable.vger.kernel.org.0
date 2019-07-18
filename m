Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A516CBAF
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 11:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfGRJSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 05:18:54 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34773 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfGRJSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 05:18:54 -0400
Received: by mail-lj1-f193.google.com with SMTP id p17so26597361ljg.1
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 02:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vqasNZMnTZGtpr5DmcPikq6VdO5am+Pn9KK3mDxK118=;
        b=rAspP7Wz5ZsH9DpT9YF07wnen0pRM2Q1HTo66WjblKJhNC/nmAMX08BbTvf7ZYbQ2Z
         c1wt8vKzHYIFgl1Ns3a9PkOcTzb+w8Jj+ihqPYb1XMMq4yJ+rH98hqeMugLTrp5m6n3S
         5la5RdjuVhkd0kI5///CvP/DRUDUgjN3TibSMtEbZoK/9SAA2y5+HUs4G/O6B7J5cnwl
         7PP6vXYNTVMqV6iPCRpnuNEqZCV9HT4ilTjPLS23XZnG4OY8ubEJ54oKT5c6gPgveQd+
         +rl8bentMMoTVQTtbnlSbJ2aQWzhGPTk16LV/C6q3G+PtonZpJA2UrlcvBcn5tF4h1cd
         as7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vqasNZMnTZGtpr5DmcPikq6VdO5am+Pn9KK3mDxK118=;
        b=eSenbDWz8DL3uxmAHVsLBU7wCnz7oQFxGjDpdeLQLpnT23/+GnuV/BUz61YHVBMINs
         A+TODK2bckYU4+1n3MDK1aBCjj8CklpvJMQ/4Eb0ecDxgx5alvOd4+DrTcvfmNngTOXL
         ll3wI2MOF2Z37rVbzN/o+VbZVPT78vU5NvWE+oGpqqxwNE4KEQPkpjqjwfVq7L/nthtf
         Rsjv9rD9L7dTmkb5LNtfNvghEWUDfZoQ8Fwaup9Oyd7Mj5BYJrwBKbOxeoRoyjQo2PNL
         VpTPXsdlQmZc1bqnjfz5zpadqjSsGI4ht4Zb/qZ8gHC4GMMg4+LBy3MZJdLmrKQwp5Ax
         h1Kw==
X-Gm-Message-State: APjAAAW+togigYOCkJmXtA3KVr09+wDcZIJFO+j3vDD66egyFBMrSdQU
        tMUyKnJFKOIDeEHbIfLmjiRLw8+t0nDTiC2RVWJ21Q==
X-Google-Smtp-Source: APXvYqzq0Ixyu3dtdEqEMP6URDu+/wK3X0Fr3I9AvmHPLqoYybHWYDGFONR9ERYVvyQ6rNuaQQXRGUIM7ya67SIVzy4=
X-Received: by 2002:a2e:9b4a:: with SMTP id o10mr24115421ljj.137.1563441532476;
 Thu, 18 Jul 2019 02:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190718030058.615992480@linuxfoundation.org>
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 18 Jul 2019 14:48:41 +0530
Message-ID: <CA+G9fYsAg=r=6JKZu88=+Yawjp8HKLjqY_tB=+NL5fe7Ow4qpg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/80] 4.14.134-stable review
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

On Thu, 18 Jul 2019 at 08:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.134 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.134-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.134-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 2c7e97d1f95df23feb292eb770c22e0b1472edd6
git describe: v4.14.133-81-g2c7e97d1f95d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.133-81-g2c7e97d1f95d


No regressions (compared to build v4.14.133)

No fixes (compared to build v4.14.133)

Ran 23808 total tests in the following environments and test suites.

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
* ltp-containers-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
