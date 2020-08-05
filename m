Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0DE23C62D
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 08:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgHEGrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 02:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgHEGrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 02:47:13 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8BDC061756
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 23:47:12 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id a5so29562794ioa.13
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 23:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6Uii1PvvOokzwxUrKX2+mIaZmlJ0rs/4p13W4NSqVJw=;
        b=rzrCBLjoilz5/aWzylGWT4u2KP9EnVziOZzXAg0qonneY90Eg1UX94R0CW7OaS3dhF
         n+gABKV7K8ZLjx+V3SKqI13o110MUSM2HYyVY2WrZK/MhcmVI+1fGRF4rDUvkNoR+sph
         Y1breGAjUuHZLiWm6POkq6SyUIQzHyAN6rp4JXAotTqbjLC+hhtEck6S47DHKb7usPq5
         pqQRAMCVpILang4ltZq17bvNMvcNrOuRvv36AYPwBzsM1xynsawjaxANSDQDtCesHg+t
         jua94NH4xZe7pGl8jFT0jG8+zzKSyzpaTuM1J3+ZgPqU6cof5Wpz6RlWJBrh9W8vt4Bp
         bPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6Uii1PvvOokzwxUrKX2+mIaZmlJ0rs/4p13W4NSqVJw=;
        b=IhtDU0DUrNn0R8/nvqmyL+fjwx6/M+rhniNaPahBbnuVOtPtLllotEywQIAEBZ7Gmc
         J0vzaWNKP8wFuXSS+SphVabA0LP5W/oG8KqaCttDSkk2LWQSJjQdw5ktgc2S9z/YwOE7
         SKlm2YT7JGnK63Nb1chTNkOP+ec9kyhMa+SlMV/F1y0/1Bj6YrAwo2jIWjzRmT14E0Yf
         JH8CIw6ygrGvVwFJe/Iv/irqsB0hBobGpB5IPleU06QG6nFna1O1ODG7wxqC6hGw/f3B
         nVHTlmBGFV1aC0XZNtTpK1gc5csBhqJN4Cr9b4NcB8k7nstcYYyVUMB8SBxTHvlm9DZp
         APkA==
X-Gm-Message-State: AOAM530y0aMy0kPntpoIZQP3llMV/r2QBKgsd2YcW1K9RDsWf+1baghA
        2HD2pRocUZZz4coTfsRi01ClvXh5SvjMZronD6HgNw==
X-Google-Smtp-Source: ABdhPJw+CJUEOJcbznyLuamclWVmzVhr0VkKyMM7Rh8F6GwHUoTT21SUP82kf0I19KiyCfsGUsWKCd2zLln/Lh4DW28=
X-Received: by 2002:a6b:7c02:: with SMTP id m2mr1887950iok.49.1596610031871;
 Tue, 04 Aug 2020 23:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200804085216.109206737@linuxfoundation.org>
In-Reply-To: <20200804085216.109206737@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 5 Aug 2020 12:17:00 +0530
Message-ID: <CA+G9fYtevgKfArekiGifCjp0Q92t=1_g9h9h3mXf-gt9=W-C3g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/52] 4.19.137-rc3 review
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

On Tue, 4 Aug 2020 at 14:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.137 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.137-rc3.gz
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

kernel: 4.19.137-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: a820898d10fd3f0edc999c46d087d1a170fbd043
git describe: v4.19.136-53-ga820898d10fd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.136-53-ga820898d10fd

No regressions (compared to build v4.19.136)

No fixes (compared to build v4.19.136)


Ran 34729 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* network-basic-tests
* ltp-commands-tests
* ltp-math-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
