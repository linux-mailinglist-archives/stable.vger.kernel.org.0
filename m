Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931D524CE7B
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 09:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgHUHJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 03:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgHUHJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 03:09:20 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAAAC061385
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 00:09:18 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id z12so265804uam.12
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 00:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qsRUqzEHz2hvX10s1CFevWBJNZnWuTdz/MNYc/0zA9s=;
        b=KPQmdM6tkMN6Ep1FZeotANOOLSci5NOOGxEkF1HcuGUCH0aTX0g43BteJ055woCYUp
         lQuOBR77BnqN+Orh6DR7DcDg+ybOSpeMvHc+suyh0d/AttAJipgnR1FjjZ9CEJKHeBLP
         gJWKNkfye8KTdYMlYgPv03VBCim1VXDYtx0OkvHjMEuAWbhtA29AqbT/BZD1kXRroe05
         MfsYg/yS32ZISAC1psotBFbEpooPAhDJpOjRxMMkY07fUFU23xzs+hacDIfi0qCEuk6e
         6mG4gdkpbnqCETlJUzME9PzGa0sM9endCgHZs/eDL/AegTzzSlS3D32+N3wh/vcjGP0l
         4kSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qsRUqzEHz2hvX10s1CFevWBJNZnWuTdz/MNYc/0zA9s=;
        b=Ffse2UTmrbuM2KlGDXmm3i2QWnZ8wjqTK8UyCwfkpRlF5X1jMXVlyt1oU0R9mPGbmp
         rQeGJg6T0oGwDdMrNmqgyQ26kjvS0/1oucRxuNNEUPbDmL5oTC/X15yLBot2HsIN7NHx
         vnfKyb/iPY00TwEGUjhBIqumyb6mVqlXnqpXAfmhcHi9Q4Asw9dcvHY870gRDMyXdesk
         7X6cM4VxK31AbA7LBkr8qtSkKtIHnja8SRBQLxWEprUzaBXPSdhNgVozIsxMbUvPdgPk
         0rNhYGSGg7ltQS33y7oCuzCyw60qGQV1VTXPjAmkTOP6pmHqWvnOVDEJBeMiBBJJO7bf
         fWQQ==
X-Gm-Message-State: AOAM533zcOQpjQuByblWqUeBFlcYgQWqIgpmbruw/j8VgUmjF1XYU9OW
        5UH6lyr5YhpjU8vWDAkv93GK+oTugwjoivGC0SSnWQ==
X-Google-Smtp-Source: ABdhPJy7wu4Heg7705JtopAoAZHR1JI5IOZ9cyV+WUE9pxsUnoGhAkufrn8eY9LnpBDejLBXPLe8/Ac+q3xznWFvHs0=
X-Received: by 2002:ab0:462:: with SMTP id 89mr771846uav.34.1597993756959;
 Fri, 21 Aug 2020 00:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200820091537.490965042@linuxfoundation.org>
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 Aug 2020 12:39:05 +0530
Message-ID: <CA+G9fYt5xa1LT3NCoW7JW2Zz5mx_84Z_XTDzChiRL63apkquMg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/92] 4.19.141-rc1 review
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

On Thu, 20 Aug 2020 at 15:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.141 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.141-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.141-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 294e46de3a1d3cb90ac476ac92ffc835a7a1e716
git describe: v4.19.140-93-g294e46de3a1d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.140-93-g294e46de3a1d

No regressions (compared to build v4.19.140)

No fixes (compared to build v4.19.140)


Ran 34142 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
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
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kvm-unit-tests
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-tracing-tests
* perf
* libhugetlbfs
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
