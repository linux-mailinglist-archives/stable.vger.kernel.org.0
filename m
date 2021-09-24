Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627EF4176BB
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 16:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346607AbhIXOXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 10:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345112AbhIXOXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 10:23:24 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5B4C061613
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 07:21:51 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id s24so12050350oij.8
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 07:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FawGbzp6bv4cmm3lQQtzr8t0+loRtFGJjRwGeuHOHrM=;
        b=Lpn/AcX7XUciwpOfKlca2t2peE9n2GT7EyahzDvvv2I36xmwF4kL3Uwkif1gQSm+Jl
         aKtm6h208f5y5IDaDtjkaHb9bhjS9SxHt8/JSoJ4/Y92mVcAMholXYFGrAVdaiYyqpZs
         H5bOaEoIsayZb5a+9dgfdUMAie0XJYq0NLR2OEiLfgOy1qibvOIry8x1XUteLmI7acTg
         q/qioUpAIuB4k77cKV8Q5y5nASWF4cUKNBEx3ClfptwDnattS/igVAfyPlON/EymF9F+
         JeQyBkzB584g6sAyaYPJmaKoBADKa4OXbflCpwj6r4GLcYu0CAYXmEsPZAgXH9q54tJc
         UiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FawGbzp6bv4cmm3lQQtzr8t0+loRtFGJjRwGeuHOHrM=;
        b=GtKwDKUZEGLKmg3Csop5pWIeFD6hg88QKK5/tWbwsFOzBemjMGnpTomt98FBqOEpic
         X7wOekxthlYO3077lFYyxY7vlQe6m8WYyFz0sq2AvQWhtrUsC9uwg4F0rM+YThApkCmC
         jy8L6ZfePMAHg7+q6zr2Tvj1Cm15FZBhIk5ozRXJMnmI1MRrUdyoip5FBXNa0LyI/tzI
         FiNqGsxaLXZxje6atD7OYKWKfxdz8mPtoozDMfDL46L+4FfYOvJK1PjBMC3pRfvEHVMF
         9Tj0SWFWasVSmOG0P0AHCR9135W50exUpmJKadR6ijS9s6NzmDiKFDkTMPsttSZKA9IH
         yMRA==
X-Gm-Message-State: AOAM533iE6gWYOqht3x3zTy5/wNoLKjlg4mVRchxo5UW4if1tyvko7GX
        cEFO6g2gNlBKbuMiiNflc+HYEFTdd98iEmOwd6g=
X-Google-Smtp-Source: ABdhPJwUdaDPeS1zMLhiN28aaKdxuMWYpR+zLBl1ZmWzu659+DN0vy5O8VwYVRizRlQM4g/UAgjwmQ==
X-Received: by 2002:aca:190c:: with SMTP id l12mr1659205oii.103.1632493311143;
        Fri, 24 Sep 2021 07:21:51 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id d10sm2253885ooj.24.2021.09.24.07.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 07:21:50 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/100] 5.14.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210924124341.214446495@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <6ebcc3a5-d57b-8aef-1964-17a210eb9334@linaro.org>
Date:   Fri, 24 Sep 2021 09:21:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/24/21 7:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.8 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions detected.

While building Perf for arm, arm64, i386 and x86, all with GCC 11, the following errors were encountered:

   util/parse-events-hybrid.c: In function 'add_hw_hybrid':
   util/parse-events-hybrid.c:84:17: error: implicit declaration of function 'copy_config_terms'; did you mean 'perf_pmu__config_terms'? [-Werror=implicit-function-declaration]
      84 |                 copy_config_terms(&terms, config_terms);
         |                 ^~~~~~~~~~~~~~~~~
         |                 perf_pmu__config_terms
   util/parse-events-hybrid.c:88:17: error: implicit declaration of function 'free_config_terms'; did you mean 'perf_pmu__config_terms'? [-Werror=implicit-function-declaration]
      88 |                 free_config_terms(&terms);
         |                 ^~~~~~~~~~~~~~~~~
         |                 perf_pmu__config_terms
   cc1: all warnings being treated as errors

To reproduce this build locally (for instance):
   tuxmake \
     --target-arch=x86_64 \
     --kconfig=defconfig \
     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft.config \
     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft-crypto.config \
     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/distro-overrides.config \
     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/systemd.config \
     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/virtio.config \
     --kconfig-add=CONFIG_IGB=y \
     --kconfig-add=CONFIG_UNWINDER_FRAME_POINTER=y \
     --kconfig-add=CONFIG_FTRACE_SYSCALLS=y \
     --toolchain=gcc-11 \
     --runtime=podman \
     perf

The nbd problems persist on some Arm configurations with Clang (footbridge_defconfig, mini2440_defconfig, s3c2410_defconfig):
   ERROR: modpost: "__mulodi4" [drivers/block/nbd.ko] undefined!

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
