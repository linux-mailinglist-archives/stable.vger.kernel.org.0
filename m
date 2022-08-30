Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAC85A592D
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 04:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiH3COg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 22:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiH3COe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 22:14:34 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3939D8F5
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 19:14:33 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-11c4d7d4683so13626554fac.8
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 19:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=qR5uEo28JsXCsuGX4MoCWnnCxcpMhsEmJxldP6wV/gw=;
        b=qj0Ras3Gx9KtnXhGmB+i4qXQSYjKuhPrnVsawNHrdfg0Q1r+WBNRENX3p1viRq8cKt
         fzmPbe/7maUN1ju8+kIfgAvrSC69G7dD/CyqUK+6vpQq9uv+LxP7aeIM8wqf2vptMs24
         RSQQTVXYdylcckOoQakB10emxs4tg+8yhOr8qjz0WlUdbsvCsHZ56p7oKijREAwucHKx
         rwZVYNgvi6b8O3bqa36ygz6wUxZTss0sgvTO7VYGlT5ifqFds9uo5+z00+G5C2l4Gk/j
         HWpsbGEvogJjAZNm+p42MWU9BfA7zJA7UmFU8ZzCyuepbyZxxKzkFmFGcbAMs3Ejw0pG
         Uzhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=qR5uEo28JsXCsuGX4MoCWnnCxcpMhsEmJxldP6wV/gw=;
        b=Iv0fN+QPq2ca4i2nYZezhoUi+qG0aJ75uCTQvX8un9QsUGhoCj+p4jw4BkIkPsvfwZ
         638gWG45IAgsbcQFoY7jKArjXHOVUjf3rv10FIs5ZIl2xMiHDnnfu4/lJXh+woADHUwU
         CTIgC33e32rPfppF87wo8hP3LKRFTinqJj8GI4imuJ6TiXDbBNZHH6iSfv2E/u2n2h7M
         zyiDMKb8xvaLf00TsyCM4Q5ZFUqGYo9H+R+WsIu9gO7euEJyarOz2eq5nuQMvlwave6V
         LltyjislKgRGwRPGiTilewPRBuvGOaU0HufGQ0JTV+Ph2mqNZgmQR6acfhPHgrgUEvSb
         izNA==
X-Gm-Message-State: ACgBeo2Rv6Ey91VdP6Ns4yBbjBxMQfP3uNLP50SubC0/h2k1NWuBY5ZR
        mexM22DzyTp1t7izWC+qwGfGrLNj/SZEog==
X-Google-Smtp-Source: AA6agR4/IHMs50rxASXth2n5hwilJZ8KVIZdTCzxlTBTzhZpjEYL0woIWjYJUQoIkLVfAEKRg4HhyQ==
X-Received: by 2002:a05:6808:11ca:b0:2d9:a01a:488b with SMTP id p10-20020a05680811ca00b002d9a01a488bmr8301601oiv.214.1661825672316;
        Mon, 29 Aug 2022 19:14:32 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.72.147])
        by smtp.gmail.com with ESMTPSA id l2-20020a9d7a82000000b0063974238a5dsm5843301otn.63.2022.08.29.19.14.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 19:14:31 -0700 (PDT)
Message-ID: <1e67f6e1-49d0-60bb-9252-e872ca232ba4@linaro.org>
Date:   Mon, 29 Aug 2022 21:14:30 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220829105808.828227973@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 29/08/22 05:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.6 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.19.6-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: 5cfa6cf5bd86ffb0f956ff2ac4876ec6905dd3cf
* git describe: v5.19.4-161-g5cfa6cf5bd86
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.4-161-g5cfa6cf5bd86

## No test regressions (compared to v5.19.5)

## No metric regressions (compared to v5.19.5)

## No test fixes (compared to v5.19.5)

## No metric fixes (compared to v5.19.5)

## Test result summary
total: 112530, pass: 101420, fail: 894, skip: 9953, xfail: 263

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 306 total, 303 passed, 3 failed
* arm64: 68 total, 65 passed, 3 failed
* i386: 57 total, 51 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 26 passed, 6 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 61 total, 58 passed, 3 failed

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
* v4l2-compliance
* vdso


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
