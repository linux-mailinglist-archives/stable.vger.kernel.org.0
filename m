Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DB0562B7C
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 08:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbiGAGXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 02:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiGAGXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 02:23:19 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C96A2CE02
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 23:23:16 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id h20so798056ilj.13
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 23:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p8Vs+3cdUTBOCxNd9F5KDhHmFCgbkvIsyeCqmS+0eGo=;
        b=ZurwC3lT5JkAPnL+B+vL3MIQJDyIKLw5HiOvrlmDWkiOJ1uXE49NHHZAUUDV4YwK3h
         Grhxr/kN/advhomP8sJwdItDuFxWWP5EMVFCurPDCWklO8TiYVoB6G5MyX84042S9ovC
         9v4fyBFwDIuP+F6xFVh2VXwypJRYXldyMi+bj6HnzcIco89UFHCL7fl8RKMNHZ+E3nLN
         +xtt1AEqPO4c9hrE4j3mD01UxOVpSo4NKETaoQJ758frEH+jbMGGTx8QB7T15GEy79zO
         ElzAL2PcDEAcJBCLfUaMzXmu4UlwvBnCBYPcnHSl0sfFA0wHhwfLBVSQdn1qzTqoMvU3
         IUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p8Vs+3cdUTBOCxNd9F5KDhHmFCgbkvIsyeCqmS+0eGo=;
        b=bqUH5dkT/BXCnaFRIK5wvlLgLteclCZjG2AGXXOOnsqRpV5q7TZEp51rxzWcAe6iTk
         b4iIMlTF/zCdmsU9Zp34NgPXi/c4cRc+NNO7QfNQKtDYIEpBTNbeKqYnuFL6H+mWR3dZ
         FwvJ/6LNmEh35+Je/44G5hQ99N0tF08r6R1jXkEM0miO2u07yKl+dVo+EG2XF6Av4oRp
         pAogZfikSvQ/yFv39x/1dWYn6o26tI2duPwpF+GEQkCeoPCDU3UTIMSMAnyBwTbGzKtv
         v8O8c+4BtEkLVu2Pvr/pUXPALHjjJTBIFXlkMlPdpUL3lBzsSW7/P7eidf1PeNbzccWh
         xAXg==
X-Gm-Message-State: AJIora9l1aj1fJCi9gbNqS0Xg3P17Igh0OluYOWeG6tW5wy89W/jovPg
        vCGLe+qz86NnQnHzNXNQxisMEW5f+5qBGIEHp0PJ5w==
X-Google-Smtp-Source: AGRyM1uF0WKc40I+dA1MyVhMF4HjFXMDlnrEYoX7rHgr0yR9k8wleGZZ4rTxqznzOtfo3/cXIzvVpLSCjY+NYuH5Wo0=
X-Received: by 2002:a92:d9cc:0:b0:2db:611:8cb9 with SMTP id
 n12-20020a92d9cc000000b002db06118cb9mr1105063ilq.55.1656656595745; Thu, 30
 Jun 2022 23:23:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220630133230.676254336@linuxfoundation.org>
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 1 Jul 2022 11:53:04 +0530
Message-ID: <CA+G9fYsC5DWYn_nApA10-P-QdgKNs53hJWUfg4WM0q1vf97-QA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/12] 5.10.128-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jun 2022 at 19:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.128 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.128-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.128-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 929b4759e471d567a6993b953bb85c5bb9f8fa7e
* git describe: v5.10.127-13-g929b4759e471
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.127-13-g929b4759e471

## Test Regressions (compared to v5.10.127)
No test regressions found.

## Metric Regressions (compared to v5.10.127)
No metric regressions found.

## Test Fixes (compared to v5.10.127)
No test fixes found.

## Metric Fixes (compared to v5.10.127)
No metric fixes found.

## Test result summary
total: 127248, pass: 114167, fail: 259, skip: 12135, xfail: 687

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 62 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 55 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
