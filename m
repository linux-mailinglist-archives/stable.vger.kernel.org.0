Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC03B4DF61
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 05:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfFUDuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 23:50:12 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42314 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfFUDuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 23:50:12 -0400
Received: by mail-lj1-f193.google.com with SMTP id t28so4650615lje.9
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 20:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h17P65wYqaQ1YLx9/xtvrVHKv+agP862+Ce4hJtzuQU=;
        b=JQpDOqAKc0XWb3yDJHrQ0DnC/nK6fOYatWsinidQr7TYaGJoXXIgtga2p0SFn3r6Lt
         XUuR4kQwrnjBSvBhAImhpeSbHFqO9yOfb/wCE7cMRRNz9/CYU8jfECXkJqCwKZg58o7A
         9EcA82sM33Imh8nQ16CCKZ8+1M9wPvgi4O1k6GO3TS3vmUrgOlmim1K5iJ7Am+Dly81/
         iUMLXBao4M9RvcPiJgpmnVbH715NXCewTudYztdZlP76I/ZLX5PUnuxDV9ERWVBDHfDV
         zepsWR5vGPzLD9ZnP0BxgA3EK3mu7gbSyJoKBy/k2iSkE4MjYIQFKGJ6xDL+LhXoytF1
         hxzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h17P65wYqaQ1YLx9/xtvrVHKv+agP862+Ce4hJtzuQU=;
        b=kQx93uHRgRBFY2tFHy6xAVoiXP4x8Xde6n0reogRWZ45rtNmN+jSkT0IABedQUqUud
         2aCRxgo66lilnb5GrJfzgLccBPOYyOieQDpRBzQP9EsmFqBzoHA7Pmvyd7VM26stX6Iq
         bVRVpBfn5t7+bU+F5ETYm9c/VkPi0Z34l0X5lghCwydvxZMpn9pOP8SNjHz1VS8i7nuR
         mB20E/9g24kujeTnc5y6MRqmqbGUlCx4KYYA6r/V6RV89JmeFkSbTOAKPphXnqXM2IKp
         1Fjlsfd1+MNmM1EMDS5mMqL32n+akKBqlVDvunM6dk93jO73pBA6ARxnc/LvP+ElzKyy
         jUCg==
X-Gm-Message-State: APjAAAXtk5P0Ow1UezQD4c87AK/Bic0ms8uTy2lJKSVfKJtEF48wzIFX
        oFkZNNXEp0l8P2H6oWM3AK7iMICeaGvtKJqhjzpMOA==
X-Google-Smtp-Source: APXvYqzipemEf5jIf3vP9EBRV/mWVluJxH2EUb6MW1+67X5oexY8lxJlqe8aHwUZ3CHgMAE5mFd0HpRmM+4K7O3Z0FE=
X-Received: by 2002:a2e:8495:: with SMTP id b21mr7978898ljh.149.1561089010213;
 Thu, 20 Jun 2019 20:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190620174328.608036501@linuxfoundation.org>
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 Jun 2019 09:19:58 +0530
Message-ID: <CA+G9fYu0wezAm+8-YJxUyGo54b8Wv4Ky8sj+aTrGFhbTkBdf3A@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/45] 4.14.129-stable review
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

On Thu, 20 Jun 2019 at 23:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.129 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.129-rc1.gz
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

kernel: 4.14.129-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 7741fd984e5da7edc8b42719cac2db8d8f56b9a3
git describe: v4.14.128-46-g7741fd984e5d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.128-46-g7741fd984e5d


No regressions (compared to build v4.14.128)

No fixes (compared to build v4.14.128)


Ran 23866 total tests in the following environments and test suites.

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
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
