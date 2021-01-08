Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716232EEDED
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 08:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbhAHHgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 02:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHHgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 02:36:01 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F12BC0612F4
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 23:35:21 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id x16so13253931ejj.7
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 23:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ia90VSCRxJpyJeflDd0jLaMRS7LvQDio8SCYZlNgxQg=;
        b=Rr+YniyWmbt8+TSlVcDrsGE5g8lrTSagTpq0EuXMPmJLSezAA3ixUrYu7Re7EtjD/W
         yVMag7kCbRVrqilc1fRc9bheGehrql4gTKBRuz+DGRVoOr6bQn34GyX84a/V5OTBmhCt
         LoZwQ085ebMmk5ZnIR3/iYeNLpsNE8eromoSjo7x2hvcvsAHNgXqUx4XmAhR2pFhYewu
         FtUSVPO4CoUo2FFD71DnoxHXoadgZhexzjtchrI41PnMXlwR1Qh7A0U00p345NV8Z+nd
         YmlSN64lmoLbJrVeeuAov2yWgCTUJfZ/xdZcdIH585krMdB3FRp+P2xFYlJQCSqaXSIO
         P7bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ia90VSCRxJpyJeflDd0jLaMRS7LvQDio8SCYZlNgxQg=;
        b=THlIMdUk/Dl50F/QuXX4avM8aSOjs3w547EN/wbWzpZ0nMkPvQciwfX/O2Mtocl3+Y
         /WaW1BL79HhyV41pL8Wtj+q/DedWW2qRhgH8yqjfsTkCxty8H5sPgmRjPzVcrYYaw16K
         4yb/998DR5FpczP4DJUJSgfGi3NL7k8szTC4qgRfVf1bQVO0ianfbSLXyxvbLOjrVmQq
         pW1b+KzpbyhOKanK6B3QFAv64JmPa9YTz+m4hQcG3AmdhE9V70JRcStMYgBnCH1sHH7G
         vLxfN2Gu7tVH8Xp4P2dgvxGarMWBJBaaxnmxd+7Ayc8/u3vFLFmv2L9wfo0qSLzA1eZk
         1BUA==
X-Gm-Message-State: AOAM5329ip0y+pQBXm+SUbF7K/gN49j3x/JkpAuKiGs8+A84YhVCyvcf
        Q5D3dcz1VkqtHamKPQc4NRAEqaqQknj+7p+VDIEX5g==
X-Google-Smtp-Source: ABdhPJz8pIHIvbQysbONkrx2KDV/JpaibV3D6FxTOiehzqzSdBYXxEFioXBD+N1SeBNzwsqbRR2NjHouavuEsfaCx18=
X-Received: by 2002:a17:906:1498:: with SMTP id x24mr1781034ejc.170.1610091319750;
 Thu, 07 Jan 2021 23:35:19 -0800 (PST)
MIME-Version: 1.0
References: <20210107143052.973437064@linuxfoundation.org>
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 8 Jan 2021 13:05:08 +0530
Message-ID: <CA+G9fYtQprq0zUC7ZgG9t17MXgmGEKM7wzQTSxq-7wcd6nqm1Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/29] 4.14.214-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 7 Jan 2021 at 20:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.214 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.214-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.214-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 78e4e5e07ab0059bd4c96c117fb2a8e24bda7127
git describe: v4.14.213-30-g78e4e5e07ab0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.213-30-g78e4e5e07ab0

No regressions (compared to build v4.14.213)

No fixes (compared to build v4.14.213)

Ran 40940 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kvm-unit-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* fwts
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* v4l2-compliance
* ltp-containers-tests
* ltp-open-posix-tests
* rcutorture

--=20
Linaro LKFT
https://lkft.linaro.org
