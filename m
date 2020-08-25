Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4D5251195
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 07:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgHYFet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 01:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbgHYFes (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 01:34:48 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92595C061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 22:34:48 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id h19so1859396ual.10
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 22:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PaekePd+GUMlAPVeDLs32NXzFqhLDy3um0wCpNnWIqQ=;
        b=gLMvKV5VUClmPRVowS/5lsoz9LOpypjox+UFD9WhekvZBf1f0VOCcATYQdO4k6Jfty
         vJwYK98syVOt/EOi1qB4DHItS8lG5NZXg3z6GMNjanP487OOdFAn5W6YlZewySLirD77
         PpU9Gi2GjKWwJGE4s5Lm8//UpqHRoYeWQ79LAA8+suOKrzQW6CGHpulLzsMzgzR7byr3
         oQ34XmCXBb97I1LPVisYPRWb6f5l5rTryHNpNf9u3n6y9hJNBJQWHYOhMisUePnqrNBT
         eCHxpksSlIGenkyY1lHq9D1fEjuBnt3x0S7+RJxlqvuEp7lz/w1RtuD7075zwpzk4ztH
         joKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PaekePd+GUMlAPVeDLs32NXzFqhLDy3um0wCpNnWIqQ=;
        b=e/Cm8TMrCT/mruAuCvxBOarOQaNtRbDdgpX32NZqWo0vzZMZNVwS/eUeg10XlulqEx
         bFb90Fr3o13F8EnYsl13iOAykzz8RjpsrR+baHUnDkxOrKVmObjh84DWrjCcMl3jjta9
         6YBL0EqdHMqWJDUXWahxHY+g4Bl4oXRfq5VZIi5dm7hvXilFJcDx1tixovFCH4YntaGz
         v4r912W0sQBDJ2w/isu7UY9pLYRcC7Mg6HvaThSKdUXJBB/VjAt9WrDM8x32yDtBeyZP
         nJNdhBnNFmE6/j+G9Qax7HfaGmKXfOXX16lNFQ8Enj8Hm2hk0YSNBSZsfLGCl0+g2gwS
         5FOg==
X-Gm-Message-State: AOAM532t0LyMcmLZSqScu4MgKBLpEp5B71F+kg9EA4BIaVncCI4iMTGl
        uQ4QYKQfBpY7kecspThGtkGgVTt35EUx3DbbbZQO7g==
X-Google-Smtp-Source: ABdhPJzx9GhGTvLBPcfcsQiEXUwWu2GR2Cn1ZLdwtFitn7xbwXKBkM4XuFLoESC4Cp5edBA4JKh8Til1FTjjgl1a27o=
X-Received: by 2002:ab0:142e:: with SMTP id b43mr4640459uae.7.1598333687686;
 Mon, 24 Aug 2020 22:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200824164741.748994020@linuxfoundation.org>
In-Reply-To: <20200824164741.748994020@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Aug 2020 11:04:36 +0530
Message-ID: <CA+G9fYtCtXBXmUBBdy1kWa_fcs3jPVQm4UWwx=JTA8oVL1XdtQ@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/127] 5.7.18-rc2 review
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

On Mon, 24 Aug 2020 at 22:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.18 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.18-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.7.18-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: f16d132bb2de3adb5e9470242c50c83b6d5d9a54
git describe: v5.7.17-128-gf16d132bb2de
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.17-128-gf16d132bb2de

No regressions (compared to build v5.7.17)

No fixes (compared to build v5.7.17)

Ran 34887 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* v4l2-compliance
* kselftest
* kselftest/drivers
* kselftest/filesystems
* ltp-commands-tests
* ltp-controllers-tests
* ltp-math-tests
* perf
* kselftest/net
* libhugetlbfs
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* network-basic-tests
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
