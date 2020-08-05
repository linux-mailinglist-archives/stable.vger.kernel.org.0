Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A7023C58A
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 08:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgHEGDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 02:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgHEGDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 02:03:09 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFA1C061756
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 23:03:09 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t4so36344086iln.1
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 23:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WZ9AsbKXdiN9KsQoZuCEBbaE5QGvbp9chgZ8Va1ngsg=;
        b=D/4dCVHixTkkuuC6ayZkG537PmQQojDvvoMi5/IJb7OuAQapy59shQdpRXk9MTEhLq
         lTLAz0dNCqowJ9uj2+JEXozKsQuYNcbGPEBzIHlmyaw9smCSi4vnjdLinoQbkZG8+o5V
         ydy1Ok43gPmRpRiNMEsPa0soQjZ+O/w21pDLeD5Xm5xZTXWmpMF388IJ347WYqBS7Vs2
         EtBFg5dhMrQqoTh3Q+F+3+VT9PBo6aJnBrqEaicTWhWdAi8AMQ3c+rARbg2PJ3Gmj/eN
         J5Ywk7CoIHNQmWUK4WScVnKj9/6empHZOw3zTQ9P04jckN8fnZ/GU2ooOX4gSUe3KgOz
         xvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WZ9AsbKXdiN9KsQoZuCEBbaE5QGvbp9chgZ8Va1ngsg=;
        b=sXT4QBX05TU2wA4MRNNXyjBz33gm+SEgUvWeQW1Ko6C61mIre8zRg6Q0WG4fMBJMSE
         q+KvSlCDsxq2Ob1/2VfNisIUYo1CkabUbMI2y2qB5Z4+CBobjDSgUhicFgMokF7FPHJ8
         fBXI7s8BAjXWUd67yH5ifF4ZPrsoMGZA3ulqsP1GBIRDJV+YFgeb1uvqc2ywcMOn5uTP
         2uwHgq5KM1YmENivXALvfkKjBiHovmR8jC5MUjA5GT48BinK6C8Guq0H355VtttjZK9L
         r50y7wyvGvCU+SMMjehoyLbsdeDX812YN/+bkErzVXpyUyMnTk6fiLjQ2DrF4m7ALQ38
         H6DA==
X-Gm-Message-State: AOAM530PXZaPsBbe+MWJ7V2Jw42oa03EnZBnoasD/x14APUv16wxJTa5
        LXJdYZMtJvS5hxCHUlww6KnCJPVMxGVHi6IR4e76Yw==
X-Google-Smtp-Source: ABdhPJwMT9aHKhep6X1QHr3mX+Zkrm/RNvYcFsR/jjRWx8y0dn9Chjq0eSgHYPIBV8c3bWQykQA55l2rZ4L5/Z+lBag=
X-Received: by 2002:a92:96c7:: with SMTP id g190mr2295604ilh.252.1596607387895;
 Tue, 04 Aug 2020 23:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200804085233.484875373@linuxfoundation.org>
In-Reply-To: <20200804085233.484875373@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 5 Aug 2020 11:32:56 +0530
Message-ID: <CA+G9fYsPq80QDQYbkCQPwS5DLCZXk7cZR8BeY6VHU4gyWGckwA@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/116] 5.7.13-rc3 review
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

On Tue, 4 Aug 2020 at 14:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.13 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.13-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.7.13-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: d3223abaf6fdd20e0894b357a0f7f1da21a29226
git describe: v5.7.12-117-gd3223abaf6fd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.12-117-gd3223abaf6fd

No regressions (compared to build v5.7.12)

No fixes (compared to build v5.7.12)


Ran 34339 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
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
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-math-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* network-basic-tests
* igt-gpu-tools
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
