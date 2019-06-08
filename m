Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDAA3A16B
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 21:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfFHTGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 15:06:37 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36066 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbfFHTGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 15:06:37 -0400
Received: by mail-lj1-f195.google.com with SMTP id i21so4531059ljj.3
        for <stable@vger.kernel.org>; Sat, 08 Jun 2019 12:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6i3nMyC0pxX9g9ZOmluPAmte2RCJfloAGvvix4oF/q0=;
        b=ECi1L8Ruwbfw1pB3XA1zxhqSZ1ueXjCteSPPzTn8v4cQYmmWwfSA8tz8CqbhzU9ll5
         CnMQgteRm1jbU7/RyHZAYXk7nE6ys44jCc4FL5cuVH31CvHzW/II/I8CU/ByEMgmTIcN
         I8irHaGR0GMAGF+y2LkHpObSTC3/V4rqSZigKRDk9qoCPsBEZ0LqIjurPXLI+kE+PfMw
         fyXd5FTAxy0gPwxCfAzEFEHnMk8Pl+GHB/nL66yeo8Jl78HipwttuyOOvfwh6SxoP+56
         /bn+7jjaUs5+mlrUakKNynUXfZJrtG7ExZMaN62NdH9wDES9udVYgz7/c69qvMI8rAvQ
         aKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6i3nMyC0pxX9g9ZOmluPAmte2RCJfloAGvvix4oF/q0=;
        b=ZnP9bfF9O3v9zedPPMT0U4gaGvFJWfsxd3i/RF8X/f6pfQUvPjNmdK1KJDk6SD4q20
         iUyRwmAWaNxWl9sJCtSyfPWnrfgQDo43RHtZ2Q/UZtB+kDe+aSEvAcmCoZ8gIdPHCnbl
         1H1oB5rK6CcMS3zta588GxCft9mrW8lxTINS2TsVqu8yLgdr1HJvPkVPa9UALNceE2Mc
         8gCXlY2ndKwU4Y7/UycepwOU90mmS6HpG7VPhCAuiZXspw+fntUKQvQ46h1OD+43SbbO
         /xaR0Sq2HhsCfZu8Zb0DqONvHRuKurVxTImsVu7R4Y130cdvoAUNzprDYhJ6/4E+zNzN
         JzlA==
X-Gm-Message-State: APjAAAUZxSrWhAbE2/e/69Z59fZp46+ASxOITd8oNFsvQDftYqrY7n4M
        zfPywzpZkQNfYBHH2gVuMyo4WSjJu9NTq5qbTwasDw==
X-Google-Smtp-Source: APXvYqwcT4Jhjjegl2n8+3gFm7MurE3TwNr2KoJch9exVtX4nMBXmEo7aWCQagA0gTh0bKy2VDLiL6abw2BcWLLSrjk=
X-Received: by 2002:a2e:2b11:: with SMTP id q17mr31572451lje.23.1560020794839;
 Sat, 08 Jun 2019 12:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190607153848.271562617@linuxfoundation.org> <20190608093256.GD19832@kroah.com>
In-Reply-To: <20190608093256.GD19832@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 9 Jun 2019 00:36:23 +0530
Message-ID: <CA+G9fYsB52VKE1+z8eJvz-x-Nyq2E7DtOoCw6vJPH_0F7UiXNg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
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

On Sat, 8 Jun 2019 at 15:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jun 07, 2019 at 05:38:41PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.124 release.
> > There are 69 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.124-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> > and the diffstat can be found below.
>
> -rc2 is out, to hopefully resolve the btrfs 32bit build failure:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.124-rc2.gz

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
selftest sources version updated to 5.1
Following test cases reported pass after upgrade
  kselftest:
    * bpf_test_libbpf.sh
    * net_ip_defrag.sh
Few kselftest test cases reported failure and we are investigating.

LTP version upgrade to 20190517

Summary
------------------------------------------------------------------------

kernel: 4.14.124-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 396e28a10fffc503c28b113c1e867b8e3684a98a
git describe: v4.14.123-70-g396e28a10fff
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.123-70-g396e28a10fff

No regressions (compared to build v4.14.123)

Fixes (compared to build v4.14.123)
------------------------------------------------------------------------
  kselftest:
    * bpf_test_libbpf.sh
    * net_ip_defrag.sh

Ran 22140 total tests in the following environments and test suites.

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
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
