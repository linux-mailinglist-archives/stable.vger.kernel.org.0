Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5201057C
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 08:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbfEAGdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 02:33:08 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36824 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfEAGdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 02:33:05 -0400
Received: by mail-lj1-f194.google.com with SMTP id y8so8434385ljd.3
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 23:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wGXhZyqFBvdoHfbjGYl1bpeRe9mYvugSCMYlXRy7D5Q=;
        b=iaj1R25IbggIQNeMdCAlOB/g8xSDDwMPK7d1wjbSKntu2Tr4RtJ2Z5ygdr2ZsGBOXZ
         XQlMPqcDS+kwhWTMvK8RIY42cdPTpbAuh7Qbp2UZsnyLtF10Pv8n5Qxb4mC17K8vG2mz
         v3rRnNcTdfsUBjw43JSdypzB/532axOQgVpuWXvvuuT3uYzuoI4vHEr+3bgqKg2zyPS/
         hWgs50DsXTjRUzLmcWTmdosIhdrekB9ZvTEILVB644m9xecjm/PPckHCaytfgu6b1Wgf
         1GMjmu1BoJKDASQ+rdX7d9JlgTN6OgLmX4amvq5uo5RVycOQhXC6Wzbc0oBTLAhtxVXI
         Z6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wGXhZyqFBvdoHfbjGYl1bpeRe9mYvugSCMYlXRy7D5Q=;
        b=d3X4Lj7tRjotr9c9YoiR/qT+zyk6iuyhyYS0+mMhilsLDUfk6dGpllHeghHVlzz19b
         cYZHhPdi4Vcaot6D225eUm1M5qchd1/uTfkKNqkYjX3RluDqO0RiHfNaIZEuqSkl9qGp
         lLznuwdHAjMDwNk4VY2Pc7otcMrrhNnUEfAyr/m6POAmO7yzJwlDfeb9QDRiG+AqaWmq
         1rTTr4ok21qz6cU9TZqlDI/m4lr6brmdPoe/kw7oKDX4HGTbIPtXsvsthlbmXCQHWDbb
         mlZ3OR0QqhXpCHpm1EVjJVwTHaEfbkSzotErzdUs0+3omMcQjDqQfOvsiO6NC16Gj4PW
         1Wsg==
X-Gm-Message-State: APjAAAW2yp9tLMx9DI9x/94P0wQtjRGbpVX5W4wyEsQDZ3MYSMgkhpMy
        MmMvDq951YmPrAxU0Khwf9bEDwhKP8PhbobyGkN2PLD8P1Q=
X-Google-Smtp-Source: APXvYqy2o3GZ+Gj9fH7vvPJTbhjpP7nFr9Hb9moMaaeVPHcRKJ+et23eQC8UT+16SIKk4auJ1pOl68zqo+UsRVN6AMA=
X-Received: by 2002:a2e:309:: with SMTP id 9mr40273052ljd.114.1556692383315;
 Tue, 30 Apr 2019 23:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190430113549.400132183@linuxfoundation.org>
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 1 May 2019 12:02:52 +0530
Message-ID: <CA+G9fYt=uAFaBUEYM80_2n7QE34zytY4zdZ4gR9ErOiV0ktXfw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/53] 4.14.115-stable review
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

On Tue, 30 Apr 2019 at 17:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.115 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu 02 May 2019 11:34:49 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.115-rc1.gz
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

kernel: 4.14.115-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: db44a158d937ed88d91fa55f1df54c11490a5b57
git describe: v4.14.114-54-gdb44a158d937
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.114-54-gdb44a158d937

No regressions (compared to build v4.14.114)

No fixes (compared to build v4.14.114)

Ran 23587 total tests in the following environments and test suites.

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
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
