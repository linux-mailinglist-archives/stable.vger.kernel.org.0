Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7F229D951
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733189AbgJ1WuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbgJ1Wt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:49:56 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB74C0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:49:54 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id f6so585187ybr.0
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ozg/xNrcYSziE20bzi4lIPwNQnRu5LTAaFvjlaSgtGk=;
        b=C78HtLq7jT+jP9hMgZWD6rTRSns8CtEY5TtXp8yOpaV3uWHPRW4VEULBwtiV323cJy
         j/R+byIa7BpjbCW2A57u4bRQgUq+V1hcO4aU5qYXkE0cq+FVfGvqep0ghcfwPVYuNjOo
         QAQyawL14OtAx3STd3Uc4fmzuPxCB4R9t4yWtzg1RR+iy3YnHtWnCIvAmcijhuEpcoQB
         xtBIYP8RlrkA94M96acTYtcwH/KMr4PHfeKl8J/p68AFZllOsIXpdOQALmbXEiX1HcOC
         NwJcIKoSybjuKFy+QslQceolgIzzqFbvlXZezmVlkO+pr7X3A0sSPAtvIfXdXpfXPv+l
         oIhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ozg/xNrcYSziE20bzi4lIPwNQnRu5LTAaFvjlaSgtGk=;
        b=Pwu/DsiTUUahqXmI/+Y73goKA6AnsENZRt6PdRXFlT+WBYkrLpYAT5jqX/tKDXBee/
         RGPFdiKFajeqkN60zVGYHasOtIrnIYjIqh4tG1sgFJ8UYwEHUW9mX4m+UMrRPwQGNqQN
         3s4U6Z3bS6mEkG2k9ggit+g/V044DDaFteSsv17gv3chraSYYE5WvkTjtMKrqz1c2ANx
         tju3kUlE5oGAPW2XWq33Hm22GkserjaECTZMQN7Su0R2cuyUvHRCTD4SgKP4ikuPTa+8
         YqWX6PsuhRZ3KwGSq87djIP2tuwYKemrxuj0Zes+OcKM4bz25nwvpCOYi4cR+GZIr+0P
         pJ1g==
X-Gm-Message-State: AOAM533Df/GIMPSq/ozk7h/40mGAqkfesIbnQ+EKEgpsH0gaE+VpCBWL
        pQ8BOX3TAX4+Vh6ZOZR4M1Q7kVwTL5iUrY7I/iexnD7gEp22GojT
X-Google-Smtp-Source: ABdhPJy++gKqdUg1HOlS/X39Aj8EsBgkT5xmgJ6KMAsEGOHJ5HZWjKQF6HnvM/L5XgEnqFr7qDncUNJQZbqysimK7L0=
X-Received: by 2002:a9d:22e4:: with SMTP id y91mr5232950ota.72.1603893041819;
 Wed, 28 Oct 2020 06:50:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201027134900.532249571@linuxfoundation.org>
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Oct 2020 19:20:30 +0530
Message-ID: <CA+G9fYvH9o8SkuxJ3QZ5W2_oQpaTLdNs-=78FKSRG1+oPbvSeg@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/112] 4.4.241-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020 at 19:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.241 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.241-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.241-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: b3d9b0c29dc82606492af20d03760fb07876eb22
git describe: v4.4.240-113-gb3d9b0c29dc8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.240-113-gb3d9b0c29dc8

No regressions (compared to build v4.4.240)

No fixes (compared to build v4.4.240)

Ran 7633 total tests in the following environments and test suites.

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
- x86-kasan

Test Suites
-----------
* build
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
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
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* ltp-commands-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-math-tests
* install-android-platform-tools-r2600
* perf

Summary
------------------------------------------------------------------------

kernel: 4.4.241-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.241-rc1-hikey-20201027-837
git commit: 7aa5c99e548c0f8522c9c04b9f489957aee944b9
git describe: 4.4.241-rc1-hikey-20201027-837
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.241-rc1-hikey-20201027-837


No regressions (compared to build 4.4.241-rc1-hikey-20201024-836)

No fixes (compared to build 4.4.241-rc1-hikey-20201024-836)

Ran 1748 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
