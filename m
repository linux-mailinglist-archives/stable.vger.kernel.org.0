Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A3C217ECC
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 07:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgGHFIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 01:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgGHFIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 01:08:37 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EFAC061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 22:08:36 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q4so16914822lji.2
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 22:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kawOTAEkEA/gvBN+weS6rWDGzfZVxP7i+vpKD4qaf6g=;
        b=XBu7iWTx4ugHeZ01LQSkB2ll96r4I8os+MSMuQ9V0cYMVUhfIGLQ8RNTa6Pras2ALn
         bzriGnn4qSUQSTATeaAcmwZFhXXfAmjDW5ScZqyxGn0q3UURd1I23o/Hs/RQDLXWtMc1
         7XWfUnZ+H6vP28dDsvvIy9TKdvT2u4aGH/8I26UNDqCHrVLjqjK9mYF/QZU+E8Uf70nL
         iESUG8xplPbamEuIpmExFkCROeonTwFcdCMogqSGzs1YqKX+FesAGj4jI7y/WdlvSGxT
         1uo7OufEwOgAK8jiRE9+rBbrJb1wK815f5yGf/BE7ULIpReEsPvVTtMgF9BGZxaKHla+
         ZhjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kawOTAEkEA/gvBN+weS6rWDGzfZVxP7i+vpKD4qaf6g=;
        b=OhTukmEkI29W6eYgPOWnYv8tnHCTReeWUgG4HnY890oHSVN9syWz25kv4/yYagVduf
         Dm9VswDsBXN/fR+pSvHC1DQCMhhB/Bpr7+0HAg/dpVN7Pa2nn4wXtLFq07OJPplv7mnE
         xM0LwBTJ6hMsBH1g3RDgJU+HT6us27/FMbQrLtzijS95wK90fmTc8++XXlKk1Y7R6b9U
         Jb+G/pxsyjN6Ox+58wwpZ7pXzUyN+oHuIslLGIObe7qBBmYi+AurbditqA3GyJrIvO2d
         LsSPVt976d4s1iiLua6Unuuv3+hYmlyQzG9LlLz8A6VzpbOzXSM5kH6CqF+4Q00bShQ8
         BruQ==
X-Gm-Message-State: AOAM531NguE2g4dTAV6YVyrMZwPPf2/xHV6c9X8B9xE3qr21S4fXYrEt
        y2V5mmZQdl5LHB7juReOMpZvp8v20qZnZwZk1tY5Ww==
X-Google-Smtp-Source: ABdhPJwcl1pdNCoyAKkp0kahX0botx9rqJ6vRucpdVhdTiZrM9JClehZShFtu7Pz2kwQMkrX3se8v8fACM6HorPR650=
X-Received: by 2002:a05:651c:1a6:: with SMTP id c6mr23740917ljn.358.1594184915095;
 Tue, 07 Jul 2020 22:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200707145800.925304888@linuxfoundation.org>
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Jul 2020 10:38:23 +0530
Message-ID: <CA+G9fYu9bu961J7A3=Pn3-YTwMochWM+rtEkZ74JfQXn52dT3g@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/112] 5.7.8-rc1 review
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

On Tue, 7 Jul 2020 at 20:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.8 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.8-rc1.gz
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

kernel: 5.7.8-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: b371afd12a4884e417026e432f135844c56afb05
git describe: v5.7.6-374-gb371afd12a48
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.6-374-gb371afd12a48

No regressions (compared to build v5.7.6)

No fixes (compared to build v5.7.6)

Ran 31484 total tests in the following environments and test suites.


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
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
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
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-math-tests
* network-basic-tests
* ltp-controllers-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-securebits-tests
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
