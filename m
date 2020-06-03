Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72811EC932
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 07:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgFCF54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 01:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgFCF5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 01:57:55 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A72C05BD43
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 22:57:54 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x27so521241lfg.9
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 22:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JpeVz17nK62n2I7lJsMjpjJeta8RNunq13H2fFv481U=;
        b=rxJ5wnqmdp0ElBh95sbYZD2C0ERDuJhqALLPdI3Uf6ID1QWL1A7TjOgB+zjd4HSTXM
         BqlNiWSveZ2HCUVCwcNH9x/sf3TvRJbb3TLdDI+4uVMNoxgJfpzNTOSRx6aQeMPWl47t
         1ul7+8Twj9LfQe0Wl3phhIWRw8MEkGexykWzlUu4M7QLPoxg1eHVhWBHsR3+NscOJdle
         8Y4OsDnKweo43BTM41ZdiZdr/bTFXaNJ43IZgMVUuv5dQTg927u5jvrJxIe/U3rCg9B6
         sG9df7Z69Jz54oyzAFq9h4q4CSs1szIdLSM9Y50ZrUsx4yV8PjEg3LOOcEn6ETLfwoBk
         2UMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JpeVz17nK62n2I7lJsMjpjJeta8RNunq13H2fFv481U=;
        b=fw9Zc9xzkOiCHkCZVUMZkRo5tEFe/ElUmvLywDuWC7KD42ZFK6MroK/Q653nSzGrnG
         tr3uGnzaaaGSjtkYTfqIXy3JOMn5kgIWunV13Tof6BRRhGmWHxQufhPo+MuOa1HEuifW
         M/XrNe96Nph++QjVEzfy8blRPeeQ511h4yshadjL7BccxxBI7ZNo43igOy5j2i3GYNmb
         6xeuhYhOaI1/lmG1m14l547GvSzio9YquFW9zCHP7Vtc7dumkGH3zYC9aoGqCjnPqLPf
         1kaaRnvC8dJguHAVDywhpz3bzU3LYyccejrrULYio/hcQ5nzXz8UU9FuuDcUVCR2OjaY
         ReHg==
X-Gm-Message-State: AOAM530WdihYHlZZXT5Db9veedhD+uTwON7yxLu3RBhdGKYZ7CcrbyRM
        W2WPKCh7WNsYsIvdJ/stKHtDT7TDozpt6wbhMl3Lbw==
X-Google-Smtp-Source: ABdhPJxyH9UCojipPIpjPD3fz4YC4gZFpOn5JiS7xpx0NKM4c9VqB1kxuxEJapZkWwubv5077IsNALkuU0PLpE6lVV4=
X-Received: by 2002:a19:8453:: with SMTP id g80mr1527341lfd.167.1591163872565;
 Tue, 02 Jun 2020 22:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200602101901.374486405@linuxfoundation.org>
In-Reply-To: <20200602101901.374486405@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Jun 2020 11:27:41 +0530
Message-ID: <CA+G9fYvGFL5-PtfxrSuOMVmM0Xni8mKZnNWt+=J+OT-wmK8YFQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/92] 4.19.126-rc2 review
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

On Tue, 2 Jun 2020 at 15:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.126 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.126-rc2.gz
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

kernel: 4.19.126-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 80718197a8a3f9c3b222375e5d1de8adf5422000
git describe: v4.19.125-93-g80718197a8a3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.125-93-g80718197a8a3

No regressions (compared to build v4.19.125)

No fixes (compared to build v4.19.125)

Ran 26389 total tests in the following environments and test suites.

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
* kselftest/networking
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
