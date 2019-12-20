Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC260127559
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 06:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfLTFfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 00:35:12 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:47098 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfLTFfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 00:35:12 -0500
Received: by mail-lj1-f196.google.com with SMTP id m26so6261569ljc.13
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 21:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TvI9uduLULDLfJEVRURikWZJsrpJdtix4Tat0bsUYgY=;
        b=m+2m8o3um1gRj3SYDVIwsrELxvX/qVZFCWkRnS3QLmu+XFdQKJWF+wrCoS9eag2Eip
         5e75NBBkaxpoS3yibqzNbLzaiYPFR0oMBj/f7O5j+UFXQWKq4IF6MBYQRolPl1e+o1A6
         K7D/T5xId16Vm4lg8vIavkFxgUPjZ9X5qafn+d/Q0LY85x0Zv1rUwqFKP/XbQo5lEn7Q
         roPWtq4+ju4hxHENEakLh3eILIZw9CyMjUZZCb6rRZuvCwLEN0AXw0eNWuB9Yny+LInZ
         uRUGDsfkQfoHM2lJoh30Xlo0HLYwXgVlFOUCwgkRnArpMfCxJKkGsd0tXTQA5b3kGtWp
         x43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TvI9uduLULDLfJEVRURikWZJsrpJdtix4Tat0bsUYgY=;
        b=BC3zO7EuKJ9oIN/q07xQMwpNGACc1mfxAi8hvOk/CFRa1eVPSqEpLXxzvYtnjVCuEs
         ovHhb2GEBn0l0Ticd3g7Jt2EjUsI8bvO1Ku5xb7VOzvvFqjxZJgsqeZ26xo4qGUdyydb
         9hNybCcvGi2hvFNzz1/30m6EGGpTF0uiVAMeTj10kTwQO368jlPVQVYrMeg+rB8tykii
         oG+fN/jmEKNZWnPnmaBX1izKvXyXDo8rmFzNTv5l9RB1SCHmmJ+Xmh98mH7hnwLortrP
         pNKu/i6pm4Rhe5tJy90bhHgKuwoGpv80IE3AaUT5tof2cESakR2gFyUBp6BITTWNURoB
         R0ig==
X-Gm-Message-State: APjAAAVKsOwNqVKRB2+ByzEiXTnjpl6vjok0a4JfrGTqGOf3AXkjZUKI
        TadzdYCPAocFqmnr+tdFRfd4ORn7U+BoPoWgiz/lsA==
X-Google-Smtp-Source: APXvYqydHYeZnJ2j0VyykXZNfau7hIN3gH6EpNyoC8BrddIhiqzBsAX0U5PRmA68oTttxdLTCLlRIA7zfHLIz5tHUuM=
X-Received: by 2002:a2e:8316:: with SMTP id a22mr8900403ljh.141.1576820110424;
 Thu, 19 Dec 2019 21:35:10 -0800 (PST)
MIME-Version: 1.0
References: <20191219182848.708141124@linuxfoundation.org>
In-Reply-To: <20191219182848.708141124@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Dec 2019 11:04:59 +0530
Message-ID: <CA+G9fYuV+VLuSFPJzRmy9JOCWFb20aGrSVFSK2YC7N8_vVsTpA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/36] 4.14.160-stable review
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

On Fri, 20 Dec 2019 at 00:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.160 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.160-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.160-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 838b72b47f7ef92850331f8b87e1228d8301f392
git describe: v4.14.159-37-g838b72b47f7e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.159-37-g838b72b47f7e


No regressions (compared to build v4.14.159)

No Fixes (compared to build v4.14.159)


Ran 24211 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
