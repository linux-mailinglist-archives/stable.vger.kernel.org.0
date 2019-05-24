Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D953F29374
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 10:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389549AbfEXIwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 04:52:18 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34818 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389676AbfEXIwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 04:52:17 -0400
Received: by mail-lj1-f195.google.com with SMTP id h11so7980252ljb.2
        for <stable@vger.kernel.org>; Fri, 24 May 2019 01:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O2vg4JJ6DQN4pfILUKPpTfkfWPxJjLQm+2vH3kc0sHQ=;
        b=J5FYUdsgzQPrZOCxmVPMsVuv9uaTdhwWmtv9DG/REc4UMztVrF2Kh9QDMLHoN1GFWS
         KdPFSf+owyVJDGLfjg4+BXjd4iRI4p0mpoH3Bnv8jhI0JcKSVluTBIyyIHbKK4Dfejap
         ICt22xHfszQXei9MfvLACCNxoWN5k1N4TxBqjx718Nk7Wg1ZRHKEOyvHmDsTQENDF9bO
         2GAD4WqxdAO4ZKR8vtaxXEKxmFWAX5rYVymVwnpQas870lETFxMtB9YIyCctppMdwcuJ
         EUJuSfFDDnZbLzmP0q+nfn9GYnQY2ZsP5yUfZ2lGAJhLsFv2wAB72IWMZQGUikRWMEpc
         BqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O2vg4JJ6DQN4pfILUKPpTfkfWPxJjLQm+2vH3kc0sHQ=;
        b=jeCFr5gAi0b3K0iWMOPLTZwwpMBYkdvbdsRAir8tSs87r5lQXgu6paZt5bGVpPf8V6
         z0oP6rnwJI/zeN4KP8n8qBNYHoMtruuvrJ4xtHwVDWlmX0pu0B2jBrmVsa3wx1hAfMbv
         5IBV/HrfyG/EywVl+kbFS8UVHoMght8jhxd5GUelUUE9SXh10/GykctVN7AvTKDrmx0m
         NM2BmSAn5DlVoL/jHcis/5eLxy3LmadaGwnCmdKHMD8c8u6rcMGLcCvqG5Tkft8UhUBG
         9Ya8nRvmAErFWM3RusQ/xHueWlkTH9TaocJdlm24FhB9I3atApLTjE45BErkx0Oi8BN/
         JJog==
X-Gm-Message-State: APjAAAXFx+e19BO3E6dk5mlXFw9Qbv0+tbrIB6ZyabYmPuhPAHIRLClg
        ZpReVy9qNbEHmvHrOPKXMSGIUVvgjye2fmJJnWKojA==
X-Google-Smtp-Source: APXvYqxAcY7C0Ox2MGq2f1WYUz/6CSPH493tnSQHpWl6GBGrfEjMPXwvo5jc0Ca/zhQDBXTN5UUqne8o2kDScTByc4A=
X-Received: by 2002:a2e:7411:: with SMTP id p17mr4442391ljc.24.1558687935675;
 Fri, 24 May 2019 01:52:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190523181720.120897565@linuxfoundation.org>
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 24 May 2019 14:22:03 +0530
Message-ID: <CA+G9fYvJGgo_SQj00Y7ounpwvjv4xCk+0x7Gtux7_-baKi+t7g@mail.gmail.com>
Subject: Re: [PATCH 5.0 000/139] 5.0.19-stable review
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

On Fri, 24 May 2019 at 00:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.0.19 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 25 May 2019 06:14:53 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.0.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.0.y
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

kernel: 5.0.19-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.0.y
git commit: c7802929531b3fd886283d78a4f91f1e522cbdf2
git describe: v5.0.18-140-gc7802929531b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/bui=
ld/v5.0.18-140-gc7802929531b


No regressions (compared to build v5.0.18)

No fixes (compared to build v5.0.18)

Ran 23203 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

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
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
