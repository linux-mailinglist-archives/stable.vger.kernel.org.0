Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0278227A01
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 09:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGUH7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 03:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgGUH7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 03:59:47 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45097C0619D7
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 00:59:47 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id 66so4313076vka.13
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 00:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SWIa6RDnAdfYh5r4VEn+L/pQA+Y1z8voMzmTSWR1ugI=;
        b=PYgoOUo5vcq8lHd0xl5pYA23FKFQFVYs9SQumPBaRaHg2mpGP/+TbaUVGMu+6gEcrY
         YI3ecDt4/mWrHL9aUzrR1NQYhFvnd/0MRswMHDuKLSgrD9lY/SqaYUV0oKkHEn0Zqbff
         uqR6v0eNWEpM8a3qCbbS3e6p0yYbJH9DnnZuLOiTRiLvPUyELymeh5Ve6vAIRih6IGkL
         NLi6BUBI7c7Si6BE7tzpjQ5EmFQ8Vv6fnBdh/vkSLAI+ztbU2W4NpvEJsQDthMTJQFiw
         I+1yaVi3Z+uTBRJDuK6f+sIBoHVCJpb+Ug6wBxcr/uC2yYHteJ+jd5k+/9MjcWKbf04s
         rCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SWIa6RDnAdfYh5r4VEn+L/pQA+Y1z8voMzmTSWR1ugI=;
        b=fIjcl7SDBrOarji91BtGZ/TMr2h2pcMjvSFgtEwnys7OPrioP3jZTVTJ+ESLAxpzCg
         BVp1m7N/mvYs+77GYhFZRGFIs2Ps8jo+dnll0XSE2pxO+OMBkFQzXNk1VB7jbpb58hJy
         uTplibIvvOXEXN8lh06cWqPgY++2qh5uKPPv0cohY4AhQzKtFlIkuWMhc63FceZlAoUQ
         NEcd2LQJPmU76zUkvlvpqzsPmJZlfq1R4kf9toVJIluLlST6M/+D4nBcfE9afa9B5Ihn
         tbWaPupiRuSxHBbhiYYVFYuxGzvD2agPw7Yx5kKaNdHbfm0LArm2EDXBDFBGyyUCLlEu
         WhyQ==
X-Gm-Message-State: AOAM531ADcieDPVPrgXfzFQAE3GqzjCLUh2EGBw8J1jXRFpzDH+o6cqx
        OdnyfL6NeMvb41bP4HqXYT+pkqx1qcxl8jXQieL1ejYiCwmzhQ==
X-Google-Smtp-Source: ABdhPJzgJlsoXLsNf+VCbfPllKh7qbBkFUkMfd8hnNCsMdnhBZHdvj1TZ7JJOTsMJWz2afCr2IjVbxRUBdcnD37MdlU=
X-Received: by 2002:a1f:16c3:: with SMTP id 186mr19778572vkw.16.1595318386008;
 Tue, 21 Jul 2020 00:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200720152803.732195882@linuxfoundation.org>
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jul 2020 13:29:34 +0530
Message-ID: <CA+G9fYvPG9o+3s2KwJHXcwdE4AUps29ePGSzRG7N8_RAr0_vug@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/133] 4.19.134-rc1 review
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

On Mon, 20 Jul 2020 at 21:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.134 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.134-rc1.gz
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

kernel: 4.19.134-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 9d319b54cc24b7800883e120b93d20d117181089
git describe: v4.19.133-134-g9d319b54cc24
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.133-134-g9d319b54cc24

No regressions (compared to build v4.19.133)

No fixes (compared to build v4.19.133)

Ran 34091 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
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
