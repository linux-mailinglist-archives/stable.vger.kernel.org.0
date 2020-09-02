Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F88525A5D9
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 08:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIBGyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 02:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgIBGyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 02:54:22 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D3BC061245
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 23:54:20 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id x203so2001744vsc.11
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 23:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Vhp4TBShjCV1me8EDYCfySOAMSAS8lYcbunrcZn7Wuo=;
        b=ChUCzmCrmTWWil9nFTF+aELI2x9e/0P9Rz70oeBWoLzpvRjumW86qHw86q7i5cN+Z5
         m3I/p3xFWe9cF2sJmRdok1A0vdCdG5vmJ4UXEXv3zirNZRD/4Q3kfOVUWxzvjB8uqVxe
         RApz5STBZWF5IkLpiR41Ypu6PdRBq6DaBMJZvj3WYMA2fV4v2PkhmdyOPwdXaObHwCZ5
         LwFxnp27vo/xN8n0qlxjcnM1md/uJ7TodDfDiEJa8scsa2mrqBwyrIg+nmzHMeF7qNX+
         pDWp7wnSPEM5QlBbcE3UrAxzTukG3rk1xTmujm5KG8MNMTp9po9/wNnIVFndwoHwAOss
         15bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Vhp4TBShjCV1me8EDYCfySOAMSAS8lYcbunrcZn7Wuo=;
        b=SW1uMd4EfqhlSOlyijB8DB9bmGY8ZXM3y9NyfmYgT/4xDjcKymJh7CU/LHtCkSVgkz
         eOdKIdnnzCXsrd1Ufyk3dsfxFtvnBdH5LzpQ22ksAef7m5KvOhs8H7D6jPyhgvZHma9T
         uJLzGUxyHaXjR5/K2a/s/JDYpw+iO+jnItZg0Lnf9lwOCWB+MO/JZNukPSUId29R7xAS
         gvZtT6kOG85h0SGwRL22mwX6Y/9/rACojl9tB0gdz5LR9/N3T3EZ2FhJWfFcVS/p8FP2
         EdkbA+IbI4Y9Jxa2yAn4prNI7HFbUNWR+9wW582eaMX/cQcTAASQSxD4xIw63vWvEuAP
         GA8g==
X-Gm-Message-State: AOAM533blkH8/XyhTIA39dyKPTt8tibXD43krDS0IiE3un95qpgAbPzw
        HHoMi5eF0YI8WUF8svuf4e9iS8C7EvMWwDtI1AjIGg==
X-Google-Smtp-Source: ABdhPJx7/e1kvmkDZb4nH3IgfU+g17SjpnV49f01cfwMOBWmLZ2cKW7/U/2ALRtbhDXZOtZkojSTexn0j6y9f0N790w=
X-Received: by 2002:a67:7f4c:: with SMTP id a73mr4249398vsd.154.1599029659615;
 Tue, 01 Sep 2020 23:54:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200901150934.576210879@linuxfoundation.org>
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Sep 2020 12:24:08 +0530
Message-ID: <CA+G9fYsOqEBFcFpYPijST_-Do=9kr=Mnv_j4Dkb09RZM3QmTYA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/125] 4.19.143-rc1 review
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

On Tue, 1 Sep 2020 at 20:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.143 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.143-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.143-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: ae6e3cc29bb4eca8baf48409319aa290efcba5f5
git describe: v4.19.142-126-gae6e3cc29bb4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.142-126-gae6e3cc29bb4

No regressions (compared to build v4.19.142)

No fixes (compared to build v4.19.142)

Ran 35939 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* network-basic-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-open-posix-tests
* ltp-sched-tests
* igt-gpu-tools
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
