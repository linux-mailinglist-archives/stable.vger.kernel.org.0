Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B298B57F0DD
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 20:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiGWSDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 14:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbiGWSDE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 14:03:04 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C340A1C109
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 11:03:03 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id c20-20020a9d4814000000b0061cecd22af4so1109013otf.12
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 11:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WRkur15cbv2HIRYMbArrqhaeelLjJmhq/Gio5OxAhMU=;
        b=vKqum8N5wk9gptsVz7o8RIiAdEXUKXMBQNvEvreDqVM/baoLBDBQJBI65vl3WuSb+I
         DJKkdkk0RQo6H1sjx/pwRFKPve8lcdtPSw3gxtgSEfhkJOivIwXBnv45rAj+8Qa1dbn/
         t0fcZMabvbysnT0cxCPMbFtwiO2qmQNVWUtG7ftvdTH4/nHWXrRM0lzuFch76fQ+yBE0
         JDwSYP831pH2xIpreBPqvRm3MpG7daYRQEeho/+09tNU+3P6vvjA9d6nsl8mV3/AILWV
         xxi7QV1RnxZle4/pAt6w731MAOSnQIgB5gDAwRFhRzYZgKqiMYnYOIdvqoKnWbXtA5sm
         aguA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WRkur15cbv2HIRYMbArrqhaeelLjJmhq/Gio5OxAhMU=;
        b=5EdPMFLaR5d1vpZlPnMoWUpKzSPAPfQ41G18SZxZ4c5UuXHwvGRIcpNsVbst/2uxkp
         iRiT7CC2sOi8/Jn7Vj+0sBiGb0o5KL4duO/UXih2DJMSiWZBncocYq4V01oWDkZaJJ7+
         vfIFWU/NXAmXuWwK2WuXV66WhuWO85T/trzLuXuGRQbeCDpcblOAMxoKF37qefEhpKvT
         uqwkMJVv6ZNEBHh1A+6FmZ1bl+pn6lOuShavFD2P6f5Sg2jtCBBUX/kVIVUXu6gPiFuP
         oaOf74nTkv7LEERYbaWATg7um39zWvj2JEWWsBw58a6hwhh8FhQ5+cXH5ZecW2xMXkwz
         9tkA==
X-Gm-Message-State: AJIora/8y1UPytFJ0Nzsn+Brxv2DM9dF5N7ih6nhTzpSkyz9BZ0F2tJv
        Pfv+yAsas1JlSg+GlK0VIs8BdQ==
X-Google-Smtp-Source: AGRyM1vQwRGJ757Q54Are2CStWkmm2lHzMgkZG0ii3Tau5E/b72lokV43KOPWQwORtJM4t/7uWu5Ug==
X-Received: by 2002:a05:6830:d13:b0:618:b519:5407 with SMTP id bu19-20020a0568300d1300b00618b5195407mr2097718otb.219.1658599383072;
        Sat, 23 Jul 2022 11:03:03 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.211])
        by smtp.gmail.com with ESMTPSA id n132-20020acaef8a000000b00335cad84fe9sm3062445oih.29.2022.07.23.11.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jul 2022 11:03:01 -0700 (PDT)
Message-ID: <26338676-278d-3cb3-2622-fa89ea79ada4@linaro.org>
Date:   Sat, 23 Jul 2022 13:03:00 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 000/148] 5.10.133-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220723095224.302504400@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
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

On 23/07/22 04:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.133 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 25 Jul 2022 09:50:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.133-rc1.gz
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
* kernel: 5.10.133-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 00d1152b116251d5f40936f24f9ef31f52eba544
* git describe: v5.10.132-149-g00d1152b1162
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.132-149-g00d1152b1162

## No test regressions (compared to v5.10.132)

## No metric regressions (compared to v5.10.132)

## No test fixes (compared to v5.10.132)

## No metric fixes (compared to v5.10.132)

## Test result summary
total: 138017, pass: 124391, fail: 610, skip: 12308, xfail: 708

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

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
