Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE12AB2985
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 05:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390946AbfIND6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 23:58:13 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35314 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390570AbfIND6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 23:58:13 -0400
Received: by mail-lj1-f195.google.com with SMTP id q22so24314047ljj.2
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 20:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kWbhn48lkv/mlCtWwWH2lMiArgSKgdoRN+xcWulW/aw=;
        b=R3GgpJNn/lDXU74b/LQb0y8pklcwr7Dj+nbmAkSDtpCl/BRpU3jqRQlrB3P7WnbYYc
         ZFYOD9M7mYovV/XLCjYRFMpjjx210/JGcYnkrlZ4l1teR+1xVn9OzNOGzxW55a1Lwghe
         W+yznmPGE4eF2h8J2fVs2KH4cWs5ELUczYcoe8viiDg1rogruA9RPPiiB/fhTZ6TqC6q
         llWJ768brxm3qUbEptLZqcDVrGIUjz98Kz6/4lFFWX7iSa7kA2WKoCTcoYoUg8KLd+0I
         KqV4NE/M5Foiyg/MW+u9ZRnfUSq8pOu+3gnZlSw4kiYf0SUIKLvjoYfHqM0Ds7B8k6YM
         nDyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kWbhn48lkv/mlCtWwWH2lMiArgSKgdoRN+xcWulW/aw=;
        b=BbeSdnydFBSuqYu/xx3kK3RarjWgVymjub2uPlU5gZIH7gsWtMbMh+zLqad/6ALs0Y
         gk38eWs1IiFpLzwa7OxyZJBgC89XVKZvElm00lKNppZFVb5nkEUGCF4U+rFLS06XB+5t
         Oy+22hbwtswFA2TmewHCx5VwR1ST1mo2Z8lbIzy2yrFMbKd4Oix2uivD/kzD8dOV5PPI
         IRoseTTef7iM+ogsWaq3+ixvmqCJSS/LDh804uEVyYxTqTVtRJ1q+iNv1x2y/iV0Zbr3
         GC6VLB7Lk+H3lcgSJrOd5xD+yozQU+b/vAi8I8p5oN4shvQz0Yme/OcGiEdyuI8t+RnQ
         9ccg==
X-Gm-Message-State: APjAAAW5Jc/tsvUErKbr5+E+sVxviu7N0YQq6Hm1Gkw+dTJLEOyDrXSg
        5t+i+6rgw+jee8cO+FOtcAxdKNn1cHXzIz/Gf24Srg==
X-Google-Smtp-Source: APXvYqz0xQ3coHPPrHgx1EQI1rszZi6pvb34OxpSFqg3o8VyyPO3Uo6vDV1h+7LRfR55r+xQ366XVhVlzevLVLdtj68=
X-Received: by 2002:a2e:94cd:: with SMTP id r13mr31857491ljh.24.1568433491552;
 Fri, 13 Sep 2019 20:58:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190913130440.264749443@linuxfoundation.org>
In-Reply-To: <20190913130440.264749443@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 13 Sep 2019 23:58:00 -0400
Message-ID: <CA+G9fYtrDEXEjfyniGN_x+4HDDt7sp3GQNJ3B70qAV=hKMR8Fg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/14] 4.9.193-stable review
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

On Fri, 13 Sep 2019 at 09:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.193 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.193-rc1.gz
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

kernel: 4.9.193-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 8e25fc1750f0dd9f378c153ecda509a578059b81
git describe: v4.9.192-15-g8e25fc1750f0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.192-15-g8e25fc1750f0


No regressions (compared to build v4.9.192)

No fixes (compared to build v4.9.192)


Ran 23550 total tests in the following environments and test suites.

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
* ltp-timers-tests
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
