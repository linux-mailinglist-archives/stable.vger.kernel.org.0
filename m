Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC7558E737
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 08:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiHJGQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 02:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiHJGQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 02:16:43 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5D365576
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 23:16:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x21so17762383edd.3
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 23:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ifqcMNgVyZIcs1Y0FmGPTKuFLhWkVB6lCLmVgx28/qg=;
        b=wOnviD9udZL+xDTvmKmNEZnbwA8h032MGvWiviO4cpf7Wi5qwVKs0lVMY5Bdi3xyEA
         PvYUd4QL3WqKl/+izyqN/JX+hYlmAnNjbdfOBgmtUUlA+/y276RrEO96CscN//pe7wxi
         iINYpvvaa7EIPcxEUfpRMO3Pb10VOEo4qYtX/NP/sws0y6r63bJsj3Hx/wdghmEJM7Wm
         S1A8TKDzUwReIIPOwu+7Vt8KOLRkLgEdkGNDEDXRTDPdjmfzC3CsPzu3Fa2aLACP2mVE
         xOu6+HkghjJQtYLExFpIHRFojdqlPczOeDZWwlM2MkUzreRfeWTsFRMeIgSrFUJNcQIS
         3NsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ifqcMNgVyZIcs1Y0FmGPTKuFLhWkVB6lCLmVgx28/qg=;
        b=Wr3gSzFbQ+gjx0jnRwNpAGzfhBRLLQsnMHKRgzsogeowefle2b4aA8yPV0dctZHg5X
         iddsaOz8nKV9SRmmwqXTsMqOkdupCXdaEKhryd66wV2soRkvmPESu1YAXbzogjGuFMQu
         9729wQNQJXnfIVVZlLCIjofIrHozPgDzK4PShJu/2J/e54PQQ1lV3Ol3e7zS1wejmxGr
         o+IyJFK/j6IvouDi6GmlIkiNPAF02v5CvhcUQ7tR62jCneCt8f8YNH3kpKzJ834zK0u4
         2Obqj2Y1oVdI6dmExcgCcBCALwJW9Tf5tQEAwazK5QMRzBxBhvPXaeS0iK7XlVQyPEdy
         fITw==
X-Gm-Message-State: ACgBeo3I9qjHrBGNKwxI5DfcYuENh9LN8ZC+aHBhPugvVpuig/6/axug
        eA2eJpiFSnmsf46Z0xj2VzYGgomZaems0qAnwRliGg==
X-Google-Smtp-Source: AA6agR4z9L7CWMTfKtA+eGb27rhb/Ii1ePdFpwVieqBxwzEi/OoluNnriuk+Xx+yPCh7tNb0x64YhiRT5GFGGy5dqoY=
X-Received: by 2002:aa7:c70d:0:b0:440:432a:5f9e with SMTP id
 i13-20020aa7c70d000000b00440432a5f9emr18608206edq.110.1660112200803; Tue, 09
 Aug 2022 23:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220809175515.046484486@linuxfoundation.org>
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Aug 2022 11:46:29 +0530
Message-ID: <CA+G9fYs_yMc0vU0iNkNDJm0AesjKvwS+gTDQXRvYi2jMP19q3g@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/35] 5.18.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 9 Aug 2022 at 23:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.17 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.17-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 732bf05a92abae4d0d6c3aca109cbc5bb0ffdb25
* git describe: v5.18.16-36-g732bf05a92ab
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18.16-36-g732bf05a92ab

## No test regressions (compared to v5.18.16)

## No metric regressions (compared to v5.18.16)

## No test fixes (compared to v5.18.16)

## No metric fixes (compared to v5.18.16)

## Test result summary
total: 133738, pass: 119625, fail: 846, skip: 12384, xfail: 883

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 301 total, 301 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 53 passed, 2 failed

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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

-- 
Linaro LKFT
https://lkft.linaro.org
