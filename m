Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52DF58719E
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbiHATpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiHATpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:45:51 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DA82AC4A
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 12:45:48 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id c185so14213238oia.7
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 12:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=zTO5z1b2HBi2MHvoO0VDCQa4JcalTm7DQj8Wt/tBQgU=;
        b=gwOcIWDnx/oz5Jund5U+0j32WTTBpWogDpXxD0OMEDpt/pD7rfetrivW9TjnfW+0po
         iL9MShgxX938M0rQmfpYWhsLeAqmXvjkvbZ0f+QLrgAOW1KH4/SVQOQ5heSKbSQTqk19
         JuNDGFYOnIjZkAK9IwmX/Mhf0mc1Vzu5Hg/cvJNiRHPl6qTS54DHAjOkWvOu3b3hd3Ru
         Qsp3qRJLUDK+WYoC87BMrohHVl0uRJZC8ENtdYo6dqSbkAMFYmUxmUllUyYRuj14TaLV
         RbBJiZrxGyd/e/DPzjcYc6CBfbuaemupx2Bmk+cDxIut1iFWm/JWYMY+6tqZNRv5hscU
         ziRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=zTO5z1b2HBi2MHvoO0VDCQa4JcalTm7DQj8Wt/tBQgU=;
        b=GYTYKZBxvpJ6ZFL6Z+lSiGBz5Qah1CosUzb7g25iF5gFlUG/pQcRcrMW8DK1FEJi9p
         tCyCnVXnqRqMlVtDR0ByhgUtmRFsBLdsxnWvlrheLeyBn/D0kcrSOZ/vkCNKGUP1Orqz
         Vj9dZ5BShfWdE/ilq+5JPQrU4/q2RTbP+oakbdzAZBTBhJX5Gl9rHMdznZiKXxpE2/Kh
         p3NwW/kFPJzLtxBq437p+Crj+vefv5uTqhDJeAa2uEG+CVt8nOxG5Ic7R6MPrmH7I0M3
         /vx8eLbWiQ6qJoIzoakTL//nspAeFWku6DJxKAAQ1ii2q/6T//nB3xcCNnQiBONuOrb2
         d2Ug==
X-Gm-Message-State: AJIora8nZdLgcOV+Pft2CuMehBVygEG/eEcniHcxwrNvdTqqw/A8k3pE
        UvLvav1lpEoaomgv1xaHL1PejQ==
X-Google-Smtp-Source: AGRyM1vmfNmmRu2L6std5nKqLGzLUJ78DCnrLH8a8WRpHZdEaUrrpKMDmO6fEkjUPTAwEi1LkE1btQ==
X-Received: by 2002:a05:6808:2099:b0:33a:aa4f:25e6 with SMTP id s25-20020a056808209900b0033aaa4f25e6mr6993997oiw.129.1659383148107;
        Mon, 01 Aug 2022 12:45:48 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.211])
        by smtp.gmail.com with ESMTPSA id m14-20020a9d73ce000000b0061c34994238sm2994807otk.40.2022.08.01.12.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 12:45:46 -0700 (PDT)
Message-ID: <be23477d-7c17-1e65-d9cb-d2331b4ce8fe@linaro.org>
Date:   Mon, 1 Aug 2022 14:45:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.18 00/88] 5.18.16-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220801114138.041018499@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.18.16 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 5.18.16-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 7e8a7b1c98057a3014222a505c28c6bd43ed5666
* git describe: v5.18.14-248-g7e8a7b1c9805
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18.14-248-g7e8a7b1c9805

## No test regressions (compared to v5.18.14-159-g63d1be154edd)

## No metric regressions (compared to v5.18.14-159-g63d1be154edd)

## No test fixes (compared to v5.18.14-159-g63d1be154edd)

## No metric fixes (compared to v5.18.14-159-g63d1be154edd)

## Test result summary
total: 136635, pass: 122379, fail: 825, skip: 12686, xfail: 745

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 311 total, 308 passed, 3 failed
* arm64: 68 total, 66 passed, 2 failed
* i386: 57 total, 51 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 23 total, 20 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 61 total, 59 passed, 2 failed

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
