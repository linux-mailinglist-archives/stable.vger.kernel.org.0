Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56A0140C43
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 15:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgAQOSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 09:18:53 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37704 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgAQOSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 09:18:52 -0500
Received: by mail-lj1-f193.google.com with SMTP id o13so26615158ljg.4
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 06:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=izl8X8htH6wd+vn9Cs0AC1/6VQCcPbr4rYfSk8DimxE=;
        b=Gwc1ffaYv8M2rMuqLKx2lwC3Gq02E1wmNIQGuinDvivAFoNSsAr8lHwnOjrP32Rv16
         FPOCM1wFusAWhmhho6ScmKHmYKYNvNpTmdhUU/hwgXVSlgtddOxj40fIhVCc2fwioX68
         CD8Y4am055TFS6P2ZLIfZmfaYF5uyqAiaExMZA2XfPShNi2x7qU3zp2h64ZGkqlTVaMi
         MQfcJdbo5F8TmQfPr4Fl5yQD+cR1BzDiX0Gq31iYTkjHxFBvcoM71eTQlbhMrDxUUrL8
         m3csY+D1mJ+ZBP5ph8JALy4m3pLwmv/ZcxfzpOZlb/5ucmK3jiK3qEv/CfGbZHX/qObm
         GGog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=izl8X8htH6wd+vn9Cs0AC1/6VQCcPbr4rYfSk8DimxE=;
        b=pF4i+S7k8pT0XrnMRTIIgCBKEI2ciLAaGSZ/rjx43voChKd7C54zEdDI71mJ2YoocV
         xa+PyXdXKqnZKdywwepsAztL9KqlUyiQfsVhz1Y9XBpbeTCuMzagXkm3sNpq85Bv6O70
         yuJMYP/rAkETJ1EN+tkXn2BoOPAtpKRTFuOJGj9dbxwJzCKbUFc4RdYCe7dtZ9NcXMoD
         aSlJCgjEXN/pnsNWWYlyLiv1mWzGLYDW9EY2UkvITnFdeHjUm0sD1nCpAbMhyOjF573Q
         YLrbWpziriDTbFF95DSWrQBf5DSugPwLjxGVHjeV4QpxNTXCAQ/rObti3N0ZjfezrTjy
         JL7w==
X-Gm-Message-State: APjAAAWQIb8j54zVWiwnsAMjA15ZXKO3R7iuBxgBNzyG7ttuoVLJ5mQp
        tnttVgv3iZKsxKKCTE57j32y051jIYLZuqQ0lDvjk9lEZF8=
X-Google-Smtp-Source: APXvYqwTocEXxDm/G9a8m6fZ+15Qkx+FNufaRBY410Ij98pzm8omSXqu2TidOs0mqRF43++b0ftoC3PljDsqko3MRJc=
X-Received: by 2002:a2e:9692:: with SMTP id q18mr5654444lji.177.1579270730571;
 Fri, 17 Jan 2020 06:18:50 -0800 (PST)
MIME-Version: 1.0
References: <20200116231713.087649517@linuxfoundation.org>
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Jan 2020 19:48:36 +0530
Message-ID: <CA+G9fYtPTLCUo36ADbcpR+HaQem00TPiAQptCr6pZpYGwb81Aw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/84] 4.19.97-stable review
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

On Fri, 17 Jan 2020 at 04:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.97 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.97-rc1.gz
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

kernel: 4.19.97-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: e301315724e25ac136c78f10a08928c03bdf7466
git describe: v4.19.96-85-ge301315724e2
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.96-85-ge301315724e2

No regressions (compared to build v4.19.96)

No fixes (compared to build v4.19.96)

Ran 24423 total tests in the following environments and test suites.

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
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
