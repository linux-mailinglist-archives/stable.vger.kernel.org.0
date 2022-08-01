Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CA95873CC
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 00:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiHAWOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 18:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiHAWOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 18:14:06 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACF643327
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 15:14:05 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id z12-20020a056830128c00b0061c8168d3faso9170910otp.7
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 15:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=VO1h1WtFFizo349bKXWFQiRecuOqllov6Z6FSAAqqIw=;
        b=jHo5LbtOOCc01OaoANW6nlyRvAMmVM8TmPWXASfWIMUGP5kGh2ChDIKiIuYEdDjap6
         lAQLCTLEP2wQcmU4wprW7ackRdpNzMERTu7cIL9BCcYux5Z7ZLEPuKsfMDHJ98CTYXbY
         KBpyKboVoKnl0/w/dJuHvPuNN/8BbBWOguo2GMDomS+vDP6JBoO/Cr79YQuXfljuq3Iv
         Ra1zOyt8KrY3Efc35jAcL7PGLDBdZtgSoFhbTdCAob4qoTFvaDjAbaQR+jzTuVyvzz3A
         UWGEtkdCQzW6otc1x6M5cGwFzBz+MRfkoDCA/ndfD4/c8TB7EXwZnX0QL9Z6AVfPfPy0
         oj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=VO1h1WtFFizo349bKXWFQiRecuOqllov6Z6FSAAqqIw=;
        b=UYMjCGv+IYHfxSyvI8AiZQ9oQRleO9SSj54fKhT8aJBmCkb8tYMpJxUEQ4kmrrCFff
         Or7EIFY5vMxZ35JRhLcN9aGTZXPpl7bfFx9eqNamb6yGpJ4orZsCudgxKdGpnJ6pLeFf
         53fuvzUIt/DxwnwhF7fU1SuzhntqV5i/LMhPEzBgVida9i6zk4f3aWy5YL7bO4kaUcyl
         O8PvyYStA5deYTJY6wrV8/4zY5jwOVJD9dDD9+LnyoI/YZQIPjg3GCyzOC5bV0ucaE/q
         glk2Tof5+xdWDSiSK5HcMTSysZnCVIWDJ5dLaQ6LB+aqb0YLkaJaRsQipipkQPqUqzSF
         fHZQ==
X-Gm-Message-State: AJIora94ggVhadmPAkLYqgtFgUGIPmogeqWxhLnhD63Xtah1v3M9X8l3
        iHsDUYzG1N46qvVW7jcaGqaR0Q==
X-Google-Smtp-Source: AGRyM1s/O+lyyuFgWPXj14rNm0vftcU0ZJ62CmmaK96wA9KWz5RL7LS6GAmA3+cMOymbUDnuJLcUEw==
X-Received: by 2002:a05:6830:6385:b0:61d:357:2077 with SMTP id ch5-20020a056830638500b0061d03572077mr6483436otb.359.1659392044909;
        Mon, 01 Aug 2022 15:14:04 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.211])
        by smtp.gmail.com with ESMTPSA id y17-20020a4ad651000000b0035eb4e5a6b6sm3000724oos.12.2022.08.01.15.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 15:14:04 -0700 (PDT)
Message-ID: <c5b9cc02-c754-6d0e-996b-bf996eca36e6@linaro.org>
Date:   Mon, 1 Aug 2022 17:14:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.10 00/65] 5.10.135-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220801114133.641770326@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 01/08/22 06:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.135 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.135-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.135-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 4f874431e68c8a1cf6c0d0c8353e404f9e2b6e02
* git describe: v5.10.133-168-g4f874431e68c
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.133-168-g4f874431e68c

## No test regressions (compared to v5.10.134)

## No metric regressions (compared to v5.10.134)

## No test fixes (compared to v5.10.134)

## No metric fixes (compared to v5.10.134)

## Test result summary
total: 122810, pass: 108952, fail: 547, skip: 12594, xfail: 717

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 306 total, 306 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
