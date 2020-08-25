Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3F825131C
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 09:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgHYHZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 03:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbgHYHZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 03:25:29 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946A4C061755
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 00:25:28 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id x142so2597883vke.0
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 00:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LsQ6Z/LSlEgnBzqN/u/Za51QKnSSVHsOYfBbNiqX3qg=;
        b=fSG7xuI6hdvN9UXnyV88cpSYsVzi1RFc7p6vE4JsflwoBdDSiC51GbPTdj2ORvgrA3
         zg4m8Z0TJfeAP7x38kCewNBMCkKmwklZrJuyNgWwpyFRTRybln44fZmAWlJzrl5Qa73m
         CR4LkaBtWd/uJ0KE4lCfng3m9orLljEEhh0vWZruot7sI7wbV9aSisF3vSbJ8MVjTcxV
         QUf0mi4+LQAiLGvS8ZhveA2qZIOOcBCHii3lewL0Fx57k0ZXH85DhvyW/VrW89CF6Z+A
         UBipNu9ucoCeVtRCQ5xKdoOKUAiL+8u60LAOpTgwA4QA+mPLefXYyK4rvFebZ+wBdKwH
         rf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LsQ6Z/LSlEgnBzqN/u/Za51QKnSSVHsOYfBbNiqX3qg=;
        b=BI1qpZL6+TGC+4iHCcDtyC+9mJeBx8dAVVDIjRuDc2O9g0JcVfbFscGvGjAp9Jxwnk
         QsKa+0OJSvWvAbKI4ZU7QlzQ+bJov6ync1Kxnf9JAgW5skmehM9EqANBdyFKuc28IJ8F
         yNTT7qdYoKZhtXxETHnaWpsIDi0O4E68CHIjlykkdZjCLyciwb7+FF1DuuMhkGQzgJjk
         yEL3Xk96dE2VXIwZFJlP2OQbNSOBBFji8iNp8yzzvDCV5IxLNz+Ifme2XwpyeUQLbde0
         +6/wkZlxGeXYH2WjTpfGdEbtsW08ruadpFMFag/RLiYM1EK/MNd87C3CaYftYvlXxz3N
         4KuA==
X-Gm-Message-State: AOAM5313b/E1yjtXHbZL4eBdTBpk1RJRuq0LwakNtV/FKSvK5WLlOLSt
        R40LTiOJvQztch3mWmaNmmPuX2xJ2RwqLKOaZ/RKSg==
X-Google-Smtp-Source: ABdhPJxtywMh569OxMwZBZzpjAUTN1NycbW1Pwsi6XOVn+c1MAXVI47ivNPmnt2UBDB11mIEnwPeouEU7C2LveKfoEk=
X-Received: by 2002:a1f:2fc1:: with SMTP id v184mr4873982vkv.42.1598340326172;
 Tue, 25 Aug 2020 00:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200824164724.981131044@linuxfoundation.org>
In-Reply-To: <20200824164724.981131044@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Aug 2020 12:55:14 +0530
Message-ID: <CA+G9fYvRpqKnMUGQXMZ+QBSrwD6AjGx8cuvzxSYo7r7kdPoRTg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/51] 4.14.195-rc2 review
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

On Mon, 24 Aug 2020 at 22:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.195 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.195-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.195-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 376e60828efba537a502fdb54d35e2805852dbb4
git describe: v4.14.194-52-g376e60828efb
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.194-52-g376e60828efb

No regressions (compared to build v4.14.194)

No fixes (compared to build v4.14.194)


Ran 26317 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
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
* igt-gpu-tools
* install-android-platform-tools-r2600
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
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-fs-tests
* ltp-math-tests
* ltp-tracing-tests
* network-basic-tests
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
