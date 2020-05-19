Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58871D9120
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 09:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgESHdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 03:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgESHdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 03:33:39 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA17C05BD09
        for <stable@vger.kernel.org>; Tue, 19 May 2020 00:33:39 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id v5so10313736lfp.13
        for <stable@vger.kernel.org>; Tue, 19 May 2020 00:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cOpdM3JeaSt5vHf5niGi1B+YL5plewk0YJ9dKIK8tUs=;
        b=ZjqjSqO5GoNdgwpcUjf5PZPZaYDfB3kH9v6Q9gn4vQEll0+lgPLjA79x3rjJn6rH7w
         ujdOXxKcksCS0paFNJMj3CJfTyAOsrUyO1ocQ1O5eKl0eR2HYkS10dLqHxChjmSTPuv8
         w8hwKPoOREWlFfmnHfLmoNJyy/65a+zaNQnhB/jDhuO9UVxH0XZWQIWMgvYo2siopCdT
         nsESj5EtEeDpRD+ITSufOTOVqRY+sKV2QwJjXFpzxxM0zsA9BUG3vWFpD4+0rL5vRBDN
         /GaXj9RQw9wOUtr42E0f6oaAtjDxkDl412PKtD3VSTQ1aC4e3LmivQUOMPxVVXsErGWs
         PpkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cOpdM3JeaSt5vHf5niGi1B+YL5plewk0YJ9dKIK8tUs=;
        b=bG/l/LyqpGc5oP0HzXFMVGZPTwx9jSx0X7ljlZaNjWluGxI8ZN8FpDdltp8eF2cmQn
         gvUY+1iAXtalfaglLBg8ZHvEJSm7OOeyUy1JdQ/Dp7v6ki2pt6hchdM7pZPYKTYbc/hM
         K0q8YoM/ciKPaiGpdec3Ru54k4vTNLvCOkVGIxW4av1ya3WNd6BvWDdemLgdOhA7x1Vy
         ebZ3m5uIiUr9uHGRKLQ1DY9lvAtrF+HWT4iSS/8WNXQofkLJ1MauaqOFwFH9Z9ZjdPM9
         vkzoL35OYS5RbZFkKo+da3bWtsWE0oTnFT2yTK4E/dz1HrEYaJyRmJc3aR7cscjpmSSR
         0fAg==
X-Gm-Message-State: AOAM5301CNZBi7rvrbEEBvbmvaih2Ac09VfyWxJnbGT2YE0LksKW0LaZ
        dfYLFXaquLViS1iqu74GnFDhLVK39DUpAR2046wUKw==
X-Google-Smtp-Source: ABdhPJyKSecfu8pZn09gXh8Wqv4zWcrVnoTzUYx1a5mv2xSZGSjKaAYGtyxWkUITsT/ySi5dwJiNsFBTUMDiXD9xNLA=
X-Received: by 2002:a19:3817:: with SMTP id f23mr13934285lfa.6.1589873617745;
 Tue, 19 May 2020 00:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200518173450.097837707@linuxfoundation.org>
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 May 2020 13:03:26 +0530
Message-ID: <CA+G9fYtSpLLgJ-ANktVfsTt5EiryaTX8xfYZHZeaoG5bjCe8qA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/80] 4.19.124-rc1 review
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

On Mon, 18 May 2020 at 23:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.124 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.124-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.19.124-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: ff1170bc0ae95f29422b828165e36382a33b2dd3
git describe: v4.19.123-81-gff1170bc0ae9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.123-81-gff1170bc0ae9

No regressions (compared to build v4.19.123)

No fixes (compared to build v4.19.123)

Ran 31223 total tests in the following environments and test suites.

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
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
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
