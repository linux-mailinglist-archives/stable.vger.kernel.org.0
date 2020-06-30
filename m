Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D5E20F051
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 10:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgF3ISO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 04:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731207AbgF3ISN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 04:18:13 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8865C03E979
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 01:18:12 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id d17so6716675ljl.3
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 01:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1r+fUBQ7kWB8Uv5rfkuJJaXftZ7SqcgrOU/0C4lpw48=;
        b=y8UWkbexM6m5wZUvoAG+hNiiQfSPtNgQKsjf/8PeqtajR9DrNkSBGC5L6y4dAkCLuS
         xuDemxYn6H3zRDft4hqAZw1cPRiene0Qet9vNBhuJKQBd50oOSZDLbXuZVRiIrU2Ib5M
         t1Xuivd0R6zXP7kAZPlZV5J33RfVvxCQG8t6x9ar0vQEILsOuoWrqP+hNji3l3gUvqxd
         l2GqsPjh2LvlGdx4lQjTIXNErr7igeArDanyT0M3EVldLDVfcpAnQctrOFPAvhgDZq3c
         NGyC6KqZjedBejVcfcV+wiO/pYYtGmQo8BbmD/8aLlmh0d6vcj8VRV8t+r+2mIMVwUG8
         2T6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1r+fUBQ7kWB8Uv5rfkuJJaXftZ7SqcgrOU/0C4lpw48=;
        b=PqbBHupxjwpnb01MKJ/swKgLF4YLeoVMl2zl7EzSx/GoCqGdYWRNg8uNTfS0YPwyLY
         Y68GQE3dcVI75MAPdl5XNi+SizXPQxX2lxrsnVtVubsFmA3fZtDcUyL2V9s1Crqnxkeg
         6bFwAX4f3RExixNDgcAkKMrh4vXFxxbfg8u00PhGfky+7b9ubdPEC056yhZlnLPhH3hK
         U/RayklGC6tasgJq+Fw+c8I3E5mNUxDjZN+9G4n+oYEbCmb1m3+pT7N2oMRmv769vQlP
         B9slmtBMQhrQpO1EZmQPMKWGN0QArGrxEpBpR44C6LAnQq2ZwpLCcAyAykn7g3uCzaYp
         41OQ==
X-Gm-Message-State: AOAM532HR2autZK+VK+HX5EeYPzZPezozV06n4EBcI8FQ1JsiWeACRj7
        fCdhJ2nEGvOUblo64j/z27S2Mfp3Rb5uakv6sT1Tgg==
X-Google-Smtp-Source: ABdhPJxVdxUi7BDIoQdNduhhR5pnn/GQRUmiMMo93SUXrMpBcQC4Gh1/dGRZWipN3WU4ovRG/yKp3KWJJL4kmvknDjo=
X-Received: by 2002:a2e:9089:: with SMTP id l9mr2669728ljg.431.1593505091028;
 Tue, 30 Jun 2020 01:18:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200629155309.2495516-1-sashal@kernel.org>
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Jun 2020 13:47:58 +0530
Message-ID: <CA+G9fYvjZyJfc3U5tUPLQiwiUa9mgqdAzumWsh8iheb6F2LSOQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/135] 4.4.229-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jun 2020 at 21:23, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 4.4.229 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 01 Jul 2020 03:53:07 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-4.4.y&id2=3Dv4.4.228
>
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> --
> Thanks,
> Sasha

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.229-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 136455f30e399451a9ddc66f1473d12ad4c23e3c
git describe: v4.4.228-135-g136455f30e39
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.228-135-g136455f30e39

No regressions (compared to build v4.4.228)

No fixes (compared to build v4.4.228)

Ran 18159 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* libhugetlbfs
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest/net

Summary
------------------------------------------------------------------------

kernel: 4.4.229-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.229-rc1-hikey-20200629-759
git commit: d32bb5b0e45faf6152d5b4771924d4680e4d3e0c
git describe: 4.4.229-rc1-hikey-20200629-759
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.229-rc1-hikey-20200629-759

No regressions (compared to build 4.4.229-rc1-hikey-20200623-756)

No fixes (compared to build 4.4.229-rc1-hikey-20200623-756)

Ran 1841 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
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

--=20
Linaro LKFT
https://lkft.linaro.org
