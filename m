Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D6123C5CA
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 08:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgHEG3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 02:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbgHEG3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 02:29:40 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9B8C061756
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 23:29:40 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q75so36633333iod.1
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 23:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m8dK0+V4abSKlsPa58jCyCNjedUT5VXE4QlX9AqSskE=;
        b=r5o0dmdEbdtbADvVVpFkO4xCXH7PjpMNvYyY+1Tb5RnD40Ia+Ufu9ubRv01CVDwpjv
         ZPAy+1OeY7z6to3fGLZ1YnzOQFC7XKpqrAUKU6YXOMNLvZGOdVVRH7C8Zml1+zt5lDKu
         qDUIrwMJwLizPls5CaTncOP/rOiay2Nsk0VYnzSZVgkxfYN75PKMoq7CNp6DZHWt4vTC
         HkLleYyvnmIRnWVy0N9BsNVcuzdzY5oeSDICoajulDXB+Iz7XMXIEk3OodnL0oK1ZYaS
         p7jUrXjhcf1nbPJy/t2bsdcqUgpSy65TORV0YBae/PHPZRHGgtvKzoVD3Mpq5fvprHcc
         9I5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m8dK0+V4abSKlsPa58jCyCNjedUT5VXE4QlX9AqSskE=;
        b=GWzns4RmQzLPfgLsT/LNh9jAMPm1C7NRnU7hNuT8ENXDVbDrLlzFujoNxgamtrTLU1
         s+BjOgsYIv2ZKrQQDQYuEbBL5tdXisc1Z1VF52cEI6OkmiokExiiKLWCE0j3uhlUicsK
         vcZIhFXgjWVxo3cgYOXqBpSq1uHHI2rJ1djmSzd1juluEUfNjoXIZLRHN/IQzzKo8ovb
         7EgYCZZO+yMcGlJbO2JeMt/cL/rA5MuLR9ixfCwhZKj2txEo5E/myZjdrxYxHEUI836h
         Qg6DsURyIsyP9WbyyLFxOw/ZZiCMuMKm82YyaHKAH1ilAcn7bsw+GfNCd5DQwwL05EO7
         A7Uw==
X-Gm-Message-State: AOAM5320Qz3lvx2xqsGT1ZVoaQsdLNrYi0ey9TJPbeQT3LQrqPbcinr4
        3KGBv/WaMqR7yIIkMT77Be7olhFPhTzVdrwlQdggFsD2bX9Snw==
X-Google-Smtp-Source: ABdhPJyLOpEtlnX4/38c5wfB2sk6MHF4YYfO2LNTVEJpA5blGiR+WUWL/Qsll2+a+ntDba+DrhP6QzQ8fmEl38Tm9e0=
X-Received: by 2002:a05:6602:2c08:: with SMTP id w8mr1882103iov.129.1596608979439;
 Tue, 04 Aug 2020 23:29:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200804085225.402560650@linuxfoundation.org>
In-Reply-To: <20200804085225.402560650@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 5 Aug 2020 11:59:28 +0530
Message-ID: <CA+G9fYvDsJv7A5VNeGChcpPUuYPs5vm6h6q6cfww+G9u74iSOA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/86] 5.4.56-rc3 review
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
> This is the start of the stable review cycle for the 5.4.56 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.56-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.56-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 47b594b8993f9c5a04eaed3d5a9f9ed77be876f5
git describe: v5.4.55-87-g47b594b8993f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.55-87-g47b594b8993f

No regressions (compared to build v5.4.55)

No fixes (compared to build v5.4.55)


Ran 35082 total tests in the following environments and test suites.

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
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* igt-gpu-tools
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
