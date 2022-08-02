Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C505874D7
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 02:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiHBAfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 20:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiHBAfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 20:35:52 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD68FD22
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 17:35:51 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-10ea7d8fbf7so10348627fac.7
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 17:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=IpG/dju9KLyWY+v7cb47gm6DxXSiSa+Zd/huh62dlOs=;
        b=LYUwomZu3H5zY5ikiCvxt25xm78Qmq2B/2LEt8FQIPgviW4e08HXwlHEWf+2CSfoOX
         zeqijkDLuj0EzqvZy7wzT+zuqVIsY3jqAeNeuTWqzBr50iVjeP0oTs6ENEbSwB0JkKLi
         sg+BeG2RBoFi3COtNjpgvQ1dNDZExn7Uv5Z8w8qbuu3gjGHAbOtLppMNntguqi/cUad4
         b2cct/jkcdrMnTVAQogvjjIgoTwAsuGLRjzwcEsDc8QKlMmPNT8/D6x7WqaC3ZJ6Rkt5
         qFym956VApjbyNuTD49nxJispTGaTloKqF08346HhFUi8JU8W/f87aLundwWV8WzxoMv
         9x8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=IpG/dju9KLyWY+v7cb47gm6DxXSiSa+Zd/huh62dlOs=;
        b=C8djqJ/jGfe1D6InheOmJberM54fDtDXOULXq9uQCwp3g1bonOwfDbz8Pg56g9W6hT
         FLqEv36hpBpChW49ClxW31ukTAc6kZ2WTTW969gqE2LX1mr1ayc5qkrYqIqv3iywlzHo
         Rqc9uQNANxLgoveWqz4DJO6UtJY0fOab1eATwCM7gs2cJj7tGMMEqEB35iaDhNod+zUu
         cpexXq1HyMn1liwj6ChgHZ0IaWxqvujIdgEH8FsiEB65S1uo3urwmQVasMCcZ4maBEKx
         8AsYfqzn6LeP0EWCJUz3LPp9cDQammnk4nKSUdtzk49edQMBXzv+GnHqA/ngMHQ6uAPx
         7Z8w==
X-Gm-Message-State: AJIora/zQRH49SypEFACtBOMSik2NNTVyMiJWIi4YUXfcELPP6X8ODvK
        Ct2Suddp0jMRxJy8psRW6Qu7uw==
X-Google-Smtp-Source: AGRyM1sYB0YTcs7CVvjVqFWF6n7FTYKIQn0sHsJDRfdIluSotVoZ8OdFjxKB993DPiqy9qHEkOBjjg==
X-Received: by 2002:a05:6870:2499:b0:101:7531:c7ec with SMTP id s25-20020a056870249900b001017531c7ecmr9075592oaq.42.1659400550909;
        Mon, 01 Aug 2022 17:35:50 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.211])
        by smtp.gmail.com with ESMTPSA id w9-20020a0568080d4900b003352223a14asm2788023oik.15.2022.08.01.17.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 17:35:50 -0700 (PDT)
Message-ID: <2b6bf767-d3f8-4e9b-358b-0826c701e00b@linaro.org>
Date:   Mon, 1 Aug 2022 19:35:48 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.4 00/34] 5.4.209-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220801114128.025615151@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 01/08/22 06:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.209 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.209-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.209-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: b48a8f43dce6a15f83f416453361b45905c1b88b
* git describe: v5.4.207-123-gb48a8f43dce6
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.207-123-gb48a8f43dce6

## No test regressions (compared to v5.4.208)

## No metric regressions (compared to v5.4.208)

## No test fixes (compared to v5.4.208)

## No metric fixes (compared to v5.4.208)

## Test result summary
total: 107690, pass: 94251, fail: 487, skip: 11696, xfail: 1256

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 307 total, 307 passed, 0 failed
* arm64: 61 total, 57 passed, 4 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 54 total, 52 passed, 2 failed

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
