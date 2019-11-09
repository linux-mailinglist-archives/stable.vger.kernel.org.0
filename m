Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01016F5E6B
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 11:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfKIKXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 05:23:16 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40009 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfKIKXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Nov 2019 05:23:15 -0500
Received: by mail-lj1-f194.google.com with SMTP id q2so8797144ljg.7
        for <stable@vger.kernel.org>; Sat, 09 Nov 2019 02:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4R4ZGpBPCGb8J92MIbZrAoKXjtk1foECrrPCFTHPlO4=;
        b=lEDTUsQCYBQuEfcd4vpYukLBQOzlKILg0WNnYw7d78E43u0NqbhHardq7JoAQSzogh
         XgvnNiBwo+R+FZZ4DgCbFTptzLDPOEnJ8T2nEiFf1jVWslC9ky7ovHzZ7CTfyYQXx0Wj
         XSI5RI0eaeSMbWQSql96Lk4aXjN1Wx4h7DvhGrFz3QicIsT/LZMRopa7F81cgjccsl/N
         +0ZyFDoA5gro6VtSs0bOrRSaXhkL5CmsN2tLMwtSFv9Y31Fv/xb6m5p0gdTEYV+b1HXQ
         IfkGPuyh4KyLQd07BjpdudZKok+Uc8UnrIri4DIMq67MgrbScDKGTKmoVCOqr2c9gbJS
         BGiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4R4ZGpBPCGb8J92MIbZrAoKXjtk1foECrrPCFTHPlO4=;
        b=bKl3+acfHU9q8nSdkUy9SS4HiVzNuKT/SpJxd9lLPFy29CLNiRNRCaWzobG/njwA7E
         6ug7fXkobLeD3NFTDv5UszuT3G/W6FAWxVeMvihBQZpSz2J4ZOMKj1VLquHLf9zIFeTF
         FcrYiqdbQ5l+muhn1RYv7E/x5JS/Sasg7sy+O0AGHOsf+vrRssbSqEbecU9auqsqS+zH
         UUYVYbtK2Z8Cnw1cjfEAokyzeSUxt8wN6baQVsvx9KEWGMd1lqMYASnPRgLAeAaKZUN2
         dEQturl2xdDYgVjfLdKp/V207TUTv880nAg6dyzxvXNqBTmPkv9738GAQoWRqP1/Jti/
         YhDw==
X-Gm-Message-State: APjAAAXYUkTLCl3InAAfbiWyOYmYf0y9jtGjULGYmKKxEgBByRibZtSp
        wbBezv9humbQHFA9CIOupPToyT617AWBQquEyDbzYQ==
X-Google-Smtp-Source: APXvYqxO5p2YcjlG+JlH7YtnrFeFY4CTmV7Wg1DY0XM48SPDuRvj7aR1kzvhbUBnHak28b+2VwIGHsmltM3h0LpLql8=
X-Received: by 2002:a2e:7202:: with SMTP id n2mr8826777ljc.194.1573294993793;
 Sat, 09 Nov 2019 02:23:13 -0800 (PST)
MIME-Version: 1.0
References: <20191108174900.189064908@linuxfoundation.org>
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 Nov 2019 15:53:02 +0530
Message-ID: <CA+G9fYs_+meFv_Jbdon_Q_MoPvSB6qhv1sWM0Nr56oxSdbT8oQ@mail.gmail.com>
Subject: Re: [PATCH 5.3 000/140] 5.3.10-stable review
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

On Sat, 9 Nov 2019 at 00:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.3.10 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.3.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.3.y
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

kernel: 5.3.10-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.3.y
git commit: 11077993d8919cb6ce838e60002b129d8321ac80
git describe: v5.3.9-141-g11077993d891
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/bui=
ld/v5.3.9-141-g11077993d891

No regressions (compared to build v5.3.9)

No fixes (compared to build v5.3.9)

Ran 26162 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
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
