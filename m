Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3C11C208C
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 00:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgEAW0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 18:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgEAW0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 18:26:15 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE435C061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 15:26:14 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a21so3920708ljb.9
        for <stable@vger.kernel.org>; Fri, 01 May 2020 15:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OJjcJqpyMAKLr/KT3rvGMFcPeeM7SZEHY1XEJFFO0e0=;
        b=V9OzOtkFarZLDHJN0AZsF4CdX+1JpkVrNZdz4oT0AqVI1iQlafNeeJYvh9LC8wNtch
         yZNk9A2S0j0Qp/yIKIEepwuZr+6GnmdkEMlF4ePN22TuA7lEN9CdFpoBgTGg7uOv6pNn
         hXb+dR5ckf2TooYqn3Jxi7Ah7T1Vw629/9roHrDLndMEtkD6BqHH5Hh5T0RJkkzSgdl9
         SH4FYVktMKaM71fz7qNvJ+3wljg4jb+3LPK2tiDhQtfvHs0P5sU4qtNnRE9GeF5vjYzD
         ojOd+j1mvHswOobgInKkAeK9dhIC+G2M7Pd03YBKOmPMqX2z/lUUMJVaCsLKg6whbEt6
         Gydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OJjcJqpyMAKLr/KT3rvGMFcPeeM7SZEHY1XEJFFO0e0=;
        b=Q5OxlMzQxFFwGGOLmT3L2sMw74KLMri3an6eFR4ZBbPBAjZMy8FzDWdbW2hWGr/bnm
         VxImjDl/d87BkuX764n9yNmEht5a1TKn2DyP/d5gKN0AwG1pBvbN8V7ZJD99A7bEZ6dG
         vqquik6jCN/Jd2K0edJLm6aCO9+bCEmM85lbn8mL27KMD4RnZKs37HRHCdigcLoe9LHM
         3i1mAX3JmIdPwBumqjkpDRv/4+IngYV7RoCYlrEbOYGgTFhRwGaNfGAM8NXyDIh5kIi4
         LhnJaVDzV4wJ5ZbEsCh3gqncAZhdOyjKHe/Et4M1NRXAsCZVGUwSBc+Ejn0RNRKVytFp
         ZjLg==
X-Gm-Message-State: AGi0PuZ21sz5CK9qAhFH95eH4gncbkN+a2ZjFvEJXDhjQXHh4WXWaeBt
        +2tyRuUPtTOsLAwiSh6iHYKqR9lpVy1VPvRUgtx3Kw==
X-Google-Smtp-Source: APiQypIRa8fjlN7Fk9+hR9dbgIq6xhlxAMdY36Hs5BHzpRbvaeOSXCbe7TBD8mvHCuDy+7MWloN7XSEfCRlzJfgeWr8=
X-Received: by 2002:a2e:9455:: with SMTP id o21mr3616252ljh.245.1588371973114;
 Fri, 01 May 2020 15:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200501131544.291247695@linuxfoundation.org>
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 2 May 2020 03:56:01 +0530
Message-ID: <CA+G9fYs5Ep4Uq4n_LnbkeMUhpu0kLHFA_3f2wf43aaVnc8WObQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/117] 4.14.178-rc1 review
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

On Fri, 1 May 2020 at 19:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.178 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.178-rc1.gz
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

kernel: 4.14.178-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: b24d32661fe15b71ca1f5f6913749d2c8be9e0ae
git describe: v4.14.177-118-gb24d32661fe1
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.177-118-gb24d32661fe1

No regressions (compared to build v4.14.177)

No fixes (compared to build v4.14.177)


Ran 26220 total tests in the following environments and test suites.

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
* kselftest/net
* kselftest/networking
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-cve-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
