Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D407A10C974
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 14:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfK1N3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 08:29:31 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43080 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfK1N3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 08:29:30 -0500
Received: by mail-lf1-f66.google.com with SMTP id l14so20045947lfh.10
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 05:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iUl6g4ZG+wDV0G17ul1kD+ARP55ICE5OtOglq5iOgz0=;
        b=sGxqYLXpCyyHDIWmSaxWrLXiPHaoECIuxBeJiovZdl5emAyjvNwHf+eUHGsZIcYZOA
         HUhn/b9Q90F3VX5TsO4oQjOHCdgdVK4c64+uVzl+mKWxXdDEQFL3DZwIGCRXgqoJiWZ5
         Uxqh4KjbeGTPstR/dHplpjOr4ugpmY/w2frptEvTXWb3Xr/j8ElxrN4pVLwlkyRUkpBD
         mLMGb59u1Ygqpeb+V9jaZtfrZponJbvoSoejPylbU5tUDWccFCQ7YWzkKf4sTwlznQ/p
         hVIBAf+hXBZbpOHrWtWpGBPmTiMZXM9elt0sT6miF/Ltp3Q7kzp4fAqFGDHcU5OoHVTP
         Rktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iUl6g4ZG+wDV0G17ul1kD+ARP55ICE5OtOglq5iOgz0=;
        b=thQOacHJEW3EWFm+Y85Sz2ckTUVMiw0qL5unAZf++C7v92MOwjAVCHmV1oc7vQSq5p
         +1z2A9ofUKQ2rv/vAae00//qxM2UvcoUOhYK4nETFzz8yVhn71bKSmaA9tkWdl6o7ZEz
         u4DS6wJE5b+I0qpLemugmRlU6m483f8PiwWo19ya7dz2DENGJTzggwyU+iwLSZJgtGG7
         /dL7AhUh867Dv8IhkV2moT4oZua7RgsGbZtrWjYw4vjIvJ6vuwgt4sPCmjPS6I83xdPy
         k7A6PBTPhCemZH71j7PBJ5GXZVaLyW7dBvTYwMWgBg6Nwe5DU76r5tyKfzmF0kI+9SIq
         b5eQ==
X-Gm-Message-State: APjAAAVSIKLvONMxDoJ87D//e3MB4/WithPvxRFPzZgtjXP8sVCZRqA0
        cFcy3IDnR4oCApyBLfy8Ubi+nYwL/EZuFeZ55uISCsD/kO8=
X-Google-Smtp-Source: APXvYqy9ssoAEBTSBtcfzRRSsapfFUjRyzMCo+M15XsAK9DQibBgGVQW8yp8l47pJpL2aNqcohQDTZvV3gfeX8HKjqw=
X-Received: by 2002:ac2:5b0f:: with SMTP id v15mr20796774lfn.99.1574947768629;
 Thu, 28 Nov 2019 05:29:28 -0800 (PST)
MIME-Version: 1.0
References: <20191127202857.270233486@linuxfoundation.org>
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Nov 2019 18:59:17 +0530
Message-ID: <CA+G9fYs-ugvOrYBZbmieSK1rQrcRh6R9cL3Vz8xK59sB3aAqyg@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/132] 4.4.204-stable review
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

On Thu, 28 Nov 2019 at 02:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.204 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.204-rc1.gz
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

kernel: 4.4.204-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: d7e1aa334904482d6133568d82815d712c9705b1
git describe: v4.4.203-133-gd7e1aa334904
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.203-133-gd7e1aa334904


No regressions (compared to build v4.4.203)

No fixes (compared to build v4.4.203)


Ran 20052 total tests in the following environments and test suites.

Environments
--------------
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
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* ltp-containers-tests
* ltp-fs-tests
* network-basic-tests
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
