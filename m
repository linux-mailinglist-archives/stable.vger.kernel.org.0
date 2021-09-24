Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC28A417643
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhIXNyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbhIXNyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 09:54:19 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1931AC061613
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:52:46 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 97-20020a9d006a000000b00545420bff9eso13180227ota.8
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KTIuoQqH1Vy3dCBY6a9nnkey5cnkk5Mif6A0d0BSJyI=;
        b=mCgD1D5+GYMiCnwixla4vwbLU3t7TJwLB3FsaWHwALGK134+CpQZT8RgyRYmZUacTz
         N7mNW3H6E0vrmR7R+kl4abMdK14B4BvL4924n22FltgkL0feyEGMr0/IbTF2JaM6Ay8P
         a5n6S6HlEc7EYxO6lAIJP39/yuN8Y1Igl4F5Wp+WtdgR09CNGhQwzBjZhLG1H+Mz0Y6/
         87KfBoogWiE3ea7BmGRb+ewdgWMCni4L7JARBBsxtWNvU8B886Ii5GF3mAycqu+Zszd9
         JJlPiNYogrd2kdYlZoER5X9ERczFQwUcdBhtsgA6IoPsxDCcN2zWwPdA84asuaXcEDDs
         83rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KTIuoQqH1Vy3dCBY6a9nnkey5cnkk5Mif6A0d0BSJyI=;
        b=q/PArTZwniS8DYCZTjhI1MdJiVsstIebIYto8WVlWmqVrb/oQ0ZeWCcWvrj7qJqMhF
         yLZqir4Vhe4vZZWLgtyUOeQ4zLCx/R66+hdzGYnvTIoIz3yzez+kHWSPFGiXTWBy23VF
         p7bDCIXkn7sXZ4UHK4Z4XstbdG1V7chGf6NpE8o2eiHoM5Ju1YwJxMkTDuOsv9mWwHtY
         Uv554s/mhjHWX9EsKVoGVMn4Lf6aTFgD/6PGfriCUILY3GEpWcU89DZoJKYPVWS6TS8p
         T4eArsLSo3GCxiGTlT2/RibWEchScnfiBWyFQKmmC9hYc0/ihbEWsVg3CBofnFg4d9Lf
         iCfQ==
X-Gm-Message-State: AOAM531ZPpW5NNTIPIaHrz0L+YaLQwoJLDyQBdLD8owQXxjQavXMpEUo
        N7yA+QJdutAGOesPM4L50he7ydbdH/xy4sRqiXk=
X-Google-Smtp-Source: ABdhPJyAGoKMZ2Cs6f/OCkft9gHx0t0E+UZmTkjVr3S7OT9MrduPIk7vI8GlZ7NwWMqxKDnHgm8+8w==
X-Received: by 2002:a9d:24c3:: with SMTP id z61mr4287869ota.214.1632491565172;
        Fri, 24 Sep 2021 06:52:45 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id v16sm2110591oiv.23.2021.09.24.06.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 06:52:44 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/26] 4.9.284-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210924124328.336953942@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <6afcb65a-bf4f-7990-c7aa-21bc0cd66520@linaro.org>
Date:   Fri, 24 Sep 2021 08:52:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924124328.336953942@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/24/21 7:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.284 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.284-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions detected.

While building mxs_defconfig for arm with GCC 8, 9, 10 and 11, the following error was encountered:

   /builds/linux/arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate 'const' declaration specifier [-Wduplicate-decl-specifier]
     285 | static const struct gpio const tx28_gpios[] __initconst = {
         |                          ^~~~~
   /builds/linux/drivers/pwm/pwm-mxs.c: In function 'mxs_pwm_probe':
   /builds/linux/drivers/pwm/pwm-mxs.c:164:24: error: implicit declaration of function 'dev_err_probe'; did you mean 'device_reprobe'? [-Werror=implicit-function-declaration]
     164 |                 return dev_err_probe(&pdev->dev, ret, "failed to reset PWM\n");
         |                        ^~~~~~~~~~~~~
         |                        device_reprobe
   cc1: some warnings being treated as errors
   make[3]: *** [/builds/linux/scripts/Makefile.build:280: drivers/pwm/pwm-mxs.o] Error 1

This is also seen in other branches (from 4.4 to 5.4). To reproduce this build locally:

   tuxmake \
     --target-arch=arm \
     --kconfig=mxs_defconfig \
     --toolchain=gcc-11 \
     --runtime=podman \
     config default kernel xipkernel modules dtbs dtbs-legacy debugkernel headers

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
