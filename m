Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B78113B5A
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 06:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbfLEFe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 00:34:57 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43273 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfLEFe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 00:34:56 -0500
Received: by mail-lj1-f194.google.com with SMTP id a13so1993395ljm.10
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 21:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4d4KuCqg8CRegbSOX7zWEHceC3dDbXRSmaznQ3aXEw8=;
        b=B7nMAjCmAkgrUFa6g2ZFBlC01MXKVbTqNbTOJ58im7MfH6FdGiqfTnrKtABJkxCv/Z
         Fy74CehmSdP9gMQYQXLcPTrcWOvzhsAquiiM2N9eaVyR4zbmeTenlH6M41wGvAFuHjGO
         EYUuGISdr8bpvTBvleGIv9JMSTaTxvjNBpi7lcDqnew9yE4CFfRy9ZQ/3LWdYcXR+90+
         7FgiqJC0mMHS/VbbHpUQKXmNOTh46EdqiAWR27dnWY+aLKY5wocr4V/IjFiBhKc2lLwL
         2HNmCquxQu8tISO0guizZ7PzhSiX5/pIpiahcZZABF/MPL00Jdh38ACSfQiBok7wyekb
         Np0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4d4KuCqg8CRegbSOX7zWEHceC3dDbXRSmaznQ3aXEw8=;
        b=kLyl+DOGbMYnrZ0FRXZZFsIlnRd/mFtE8UeTLAeOM0OqKinQBK2WJPd7ldS7xAlHMa
         NX+S1qcKZc6KaHL/wvBO//RRppMWA0u/iNK94YnvnLN+73JNoiak6Ek24tCwQ4pw4/yX
         2RgA6sZA2F2t4Vfae7R0JYTLejqu0u7QaZrEv3GDgw1ji6mEI3bVebv7XEkmGZ3V1Qmt
         E28UZyzhKrjaoXvR2svPDqhLRizFxjLpo9Z/MyRSNmS0JDzq2qn3CHUt1jjkjUpQMgTx
         IgP6zzFUhXA9hgWgd3STs2n+vF+QNekCE4/bQ0227lriVjPyT3QBY9B/rjPBcCk5TGxZ
         QHYg==
X-Gm-Message-State: APjAAAWbqumSw5v3OCVTZP7bteOwvSrdKmv+ZqRCT8Ept8E9r2ZlfIj8
        WhhBYe3yNmNH7YIfRT83McG9SUa3EKjpJ39UfQqlLeWXU8c=
X-Google-Smtp-Source: APXvYqz7D/ENxvC0PRTWwmkFCRrDs6dhTZtl0nUIe996I1Ebb0FvCfPwB1Fr9oedBA2E7cObvUl+nCR0SMl9zJUSJlU=
X-Received: by 2002:a2e:854c:: with SMTP id u12mr4028797ljj.135.1575524094457;
 Wed, 04 Dec 2019 21:34:54 -0800 (PST)
MIME-Version: 1.0
References: <20191204175308.377746305@linuxfoundation.org>
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 Dec 2019 11:04:43 +0530
Message-ID: <CA+G9fYtQrOE0_dU259OpMtffd5dtC+-Z+hrDtZ=HQgUXi=_zcQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/125] 4.9.206-stable review
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

On Wed, 4 Dec 2019 at 23:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.206 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Dec 2019 17:50:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.206-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.206-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: eedf6ee6d6ccee71e628b172e33ef860e05e6bb2
git describe: v4.9.205-126-geedf6ee6d6cc
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.205-126-geedf6ee6d6cc


No regressions (compared to build v4.9.205)

No fixes (compared to build v4.9.205)

Ran 23412 total tests in the following environments and test suites.

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

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
