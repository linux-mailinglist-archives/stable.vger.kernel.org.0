Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE76B25B1AB
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 18:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgIBQ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 12:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgIBQ26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 12:28:58 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B51C061245
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 09:28:58 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id g11so1774466ual.2
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 09:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IlfJS7zeotd/+1Rr3gwcEKhVi7P2PvhQ1n7v6H4jbZQ=;
        b=xtBWX7vshRH+6rOY6TNLdhDE2rxo1x0tv9VqNSxDWb0f0wJlEFTWf69+WAHt8hL3ih
         CgmklVbcPwleWq73o0Z6nXcdqbFS6MKX7+uzvVeJWcbZ7W0lxEKKRaggVfEZ0j2bUPvy
         RILeLrEOnxoa64QLGRR+tb2vqGN0/zfDZVJ5QqeOy7L5Qp0I2AxRkiwoNc0q4srYQI4a
         lzngMnyReO+7Yj/C7QpxWGqLlM2uHPABc8B+4B3x7hYb8bVqF6nAq4nMOD1SZpUe/c5w
         ZIJd2qnJZ43KEkAcWPgkb/ZX/hL0irBFbwB4y58S1MdMRsiuoO54DZUepNDBHePrwras
         KD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IlfJS7zeotd/+1Rr3gwcEKhVi7P2PvhQ1n7v6H4jbZQ=;
        b=fUlBdjmyYpuMwuGDmAKTCK0ZTugv9NE4M5fc+Oxn16lIS84O+yYTQ3Hq/XxXnu2egh
         F5f4qE5SGMbb+Ws0awchpi6pBEBBBMsfWRD6MK5YCUamg8ArudNd+n1TETfHLP+EvNmP
         Fv1gpJn+ozMmSNSGOKIp81i9kJPAr1VhtDWCAQkOCqqq5Mel3g4SY9jOClgH5h3/fSoq
         ll/HCJHnlWKl7ju3/r1mxaHZndz641xk4K6gvADDv2tyXZgPjnWqN+o35icpKltVT2iu
         JdbRvu/HyI4nlQnVh7Xo7K1b/Um147AJnsjtrpPwr4pq5siaCf51nIZXpnYyMcanwjYp
         zQQQ==
X-Gm-Message-State: AOAM532zm1I6yVlMelZa0MLwOVeubpEmBTo1XJ6JpROsKqQWoL4jicsE
        8dgxg3oAJUqpfQbzMtbtH2GwRlJEXwt1hFbIF2UhEQ==
X-Google-Smtp-Source: ABdhPJxoLnXYw6a1Sz1Fjo0jN8iWcYARzogsNzcZCmrOaug25U1FmQGYyjIJMh0pap9Hhy47bKUzb6msIrjwpnwy6xY=
X-Received: by 2002:ab0:679a:: with SMTP id v26mr5811948uar.27.1599064136956;
 Wed, 02 Sep 2020 09:28:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200902074837.329205434@linuxfoundation.org>
In-Reply-To: <20200902074837.329205434@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Sep 2020 21:58:45 +0530
Message-ID: <CA+G9fYv0oEqJQPJUhLAHX5wWrfZbhS6-cQOL8_Ex=d4tWAcHsQ@mail.gmail.com>
Subject: Re: [PATCH 5.8 000/253] 5.8.6-rc2 review
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

On Wed, 2 Sep 2020 at 13:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.6 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Sep 2020 07:47:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.6-rc2.gz
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

kernel: 5.8.6-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: 650d8f2a3b44d1fe3f6d569a5bf38e4501a4c90f
git describe: v5.8.5-254-g650d8f2a3b44
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/bui=
ld/v5.8.5-254-g650d8f2a3b44

No regressions (compared to build v5.8.5)

No fixes (compared to build v5.8.5)

Ran 39936 total tests in the following environments and test suites.

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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-controllers-tests
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
