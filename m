Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACA8267886
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 09:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgILH1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 03:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgILH1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 03:27:51 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C340C061757
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 00:27:51 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id n7so2933565vkq.5
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 00:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7NlcLAlNPtWofagY+Is55AZgVy6zFJSOgrS1UIM2OXQ=;
        b=XgMqgE835V9QHhzkTOvYVDVA8MZMAZIArnyAFUycUjR1g/V1pqoAVjdtI24gO5O0Bk
         0UR+uZnX+OTONAj4r2vUeaNiGa+QII3JIZTDwl9rgZBfnY5PLkVsm0ASJ4/owomZsYdT
         HcM51fIhEhyw8L04L8m83JWSKWHK6yrLekvIV0T7gRLMK9+lKx3PFsUs/kOUYg2YUhiH
         KyGzEsiWgWKcLfQmSud6ETJmJdDDuuR/dMmk8+veZFVFjiX5+GPXigxgbQ/RTMhMK2pe
         lapPrCritDzNGDOifvbS0+uc9xzDQ3iDNv2WvL9Qo9ma7Oukpk2IrXMvADz3GN9xVKp9
         1jgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7NlcLAlNPtWofagY+Is55AZgVy6zFJSOgrS1UIM2OXQ=;
        b=amf4tOoF0m6q2fjuDOYnZd49YRKFpUN4KMru9L/tdpP4q1KwVxgnjBGS3maRo/YcDB
         S4S6NjjzdQDXbwYCluzvO8851JF/2pYJVs3RMWmVk1S3Z7zk1iaU93OOiUDEqf7FVuK+
         KzqK9ggIAoDY6kvfK+j4fifiSyNH6KuFrSylfaUr4u3OzOCs40TioAxjtmng164coq3n
         6cz4nqbfrWps3iD2I1GuYtlOi8n6H7Jn59JadPQ6+a7Ca1HsSAxj4/1DLxB21nldgMXB
         /3Fy7/gPNIOj+YYYGXZQPeCcpB2gCYXjNJBnAWZQBtTqbIkurvuhfsCCSFQlYHQSwlc1
         WweA==
X-Gm-Message-State: AOAM533Amzcgkao9Bf3f+oy/uPcRdGkmjiJVF9qOvmWO8YPnA/N9cAwc
        0WXSGoPhBk/DZIdCwI8J/0UlL9RXG81GEY2xJ2cauQ==
X-Google-Smtp-Source: ABdhPJyLGSzyYoi6qjpNDXXb+e5Vam9IhtoOp2KTKvUe/cSIVGC7y74I8WaKXXT4voGH/Xt+Qi+qHLdyrj8BzkBn/RE=
X-Received: by 2002:a1f:198b:: with SMTP id 133mr2979974vkz.28.1599895669873;
 Sat, 12 Sep 2020 00:27:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200911122459.585735377@linuxfoundation.org>
In-Reply-To: <20200911122459.585735377@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 12 Sep 2020 12:57:38 +0530
Message-ID: <CA+G9fYsg+g_4B=6ritrWuZKFHJadnmAOjppjBt1nAGQGrdty2g@mail.gmail.com>
Subject: Re: [PATCH 5.8 00/16] 5.8.9-rc1 review
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

On Fri, 11 Sep 2020 at 18:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.9 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
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

kernel: 5.8.9-rc1
git repo: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
git branch: linux-5.8.y
git commit: dcdaabfe3cea0fafa25a9a2ce8d83fd4edad41d6
git describe: v5.8.8-17-gdcdaabfe3cea
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.8.=
y/build/v5.8.8-17-gdcdaabfe3cea


No regressions (compared to build v5.8.8)


No fixes (compared to build v5.8.8)

Ran 20836 total tests in the following environments and test suites.

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
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* linux-log-parser
* perf
* network-basic-tests
* libhugetlbfs
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
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
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
