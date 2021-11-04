Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242DD445775
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 17:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhKDQsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 12:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhKDQsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 12:48:06 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C382BC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 09:45:27 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso6389011otg.9
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 09:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UemmmgVz2UBV7uDF9H5IkPCiiiylmzZZHPJuR9mQc0k=;
        b=qXoi1JaTNA44hMHdT3GPNAV9NHdQNRDfaSVj+ujNOlcVGnQ4eF8yMclBXjPleyxj3y
         APEHznJqgqy0qxioIFGOeDdeyDClk+NWmIDpZgrYnFvQiBLKFVU0kwx8zKLbTGryf3nC
         RnudKbcgJQy3J6W09gjy+vxT1QiDrkCH4qFkncilOo1Iz3CVa+6lgV5RTtRwSnWYS+aD
         aEfbPimjyf/utjUDtnOsZGm7DNgoE6BqWfyvPiLNL4lLAh71gbWcgsqXc+9IIkp5HU1Q
         9vB6C0JOZlzzeNx4kyLTtpQ1FyR7s/5dQV9nFDpgU059E1fWlylj0XGgYlYa7co/k7so
         CT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UemmmgVz2UBV7uDF9H5IkPCiiiylmzZZHPJuR9mQc0k=;
        b=5xyd3Wd4FL3QSrFnkAbrHGr27Wg97y80b6qYUV1QxrfuZh3BS0EZFYthfPTi683GHF
         VT7UPHrs6fOsRE0wuoLncaTVPsanaf0hZEUwhTHpXEqR/DKZOa/3z9Q1X817xlPYA6SU
         9e+ValcsuitHYsyKGrCe30Z8lgXEsRnNVY4KpI+Qdje8vP+tRpn4F/0xv4nSejD1EhpX
         0g9lm0rXzVLkjXBjiUtEUDv0kkdNru5MM//iXMgaVPY7PryojuJvP414orTXlE85doUB
         Yyu63Lr8uiIr7MCn6m28DYBI7mWgD/cGS+TYSHvywnMMTAFgs+wOo/zNUI6nur9yaZmP
         Fdmw==
X-Gm-Message-State: AOAM532jifv1eg5OEH/AZAC7UPcmOsQ9ZYrliElF3MmoMXkTclPwhUAo
        rDMEXANNOJY91IHquX100Vt9Tw==
X-Google-Smtp-Source: ABdhPJyYyJOqMdiaBI6kqor7dn0taVCz0l+U3J2D+a7YxYm+kbHi0/nSVtbtloQ86HLSOPdfaa/2Xg==
X-Received: by 2002:a9d:73d4:: with SMTP id m20mr6448024otk.350.1636044326984;
        Thu, 04 Nov 2021 09:45:26 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.83])
        by smtp.gmail.com with ESMTPSA id j19sm340929oor.23.2021.11.04.09.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 09:45:26 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/16] 5.10.78-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20211104141159.561284732@linuxfoundation.org>
 <3971a9b4-ebb6-a789-2143-31cf257d0d38@linaro.org>
 <YYQIUhHkv3kUY+UC@kroah.com>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <49f4ccf9-02db-60c1-b32a-d814a8cd73db@linaro.org>
Date:   Thu, 4 Nov 2021 10:45:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYQIUhHkv3kUY+UC@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 11/4/21 10:20 AM, Greg Kroah-Hartman wrote:
> On Thu, Nov 04, 2021 at 09:53:57AM -0600, Daniel Díaz wrote:
>> Hello!
>>
>> On 11/4/21 8:12 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.78 release.
>>> There are 16 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Regressions detected.
>>
>> Build failures on all architectures and all toolchains (GCC 8, 9, 10, 11; Clang 10, 11, 12, 13, nightly):
>> - arc
>> - arm (32-bits)
>> - arm (64-bits)
>> - i386
>> - mips
>> - parisc
>> - ppc
>> - riscv
>> - s390
>> - sh
>> - sparc
>> - x86
>>
>> Failures look like this:
>>
>>    In file included from /builds/linux/include/linux/kernel.h:11,
>>                     from /builds/linux/include/linux/list.h:9,
>>                     from /builds/linux/include/linux/smp.h:12,
>>                     from /builds/linux/include/linux/kernel_stat.h:5,
>>                     from /builds/linux/mm/memory.c:42:
>>    /builds/linux/mm/memory.c: In function 'finish_fault':
>>    /builds/linux/mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHWPoisoned'; did you mean 'PageHWPoison'? [-Werror=implicit-function-declaration]
>>     3929 |  if (unlikely(PageHasHWPoisoned(page)))
>>          |               ^~~~~~~~~~~~~~~~~
>>    /builds/linux/include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
>>       78 | # define unlikely(x) __builtin_expect(!!(x), 0)
>>          |                                          ^
>>    cc1: some warnings being treated as errors
>>
>> and this:
>>
>>    /builds/linux/mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHWPoisoned' [-Werror,-Wimplicit-function-declaration]
>>            if (unlikely(PageHasHWPoisoned(page)))
>>                         ^
>>
>>    /builds/linux/mm/page_alloc.c:1237:4: error: implicit declaration of function 'ClearPageHasHWPoisoned' [-Werror,-Wimplicit-function-declaration]
>>                            ClearPageHasHWPoisoned(page);
>>                            ^
>>    /builds/linux/mm/page_alloc.c:1237:4: note: did you mean 'ClearPageHWPoison'?
>>
> 
> What configuration?  This builds for me on x86 here on allmodconfig.

Our main config also works, but defconfig, allnoconfig and tinyconfig all fail. That's across all architectures.

Here's a comprehensive list of failures:

* arc, build
   - gcc-8-allnoconfig
   - gcc-8-axs103_defconfig
   - gcc-8-defconfig
   - gcc-8-tinyconfig
   - gcc-8-vdk_hs38_smp_defconfig
   - gcc-9-allnoconfig
   - gcc-9-axs103_defconfig
   - gcc-9-defconfig
   - gcc-9-tinyconfig
   - gcc-9-vdk_hs38_smp_defconfig

* arm, build
   - clang-10-allnoconfig
   - clang-10-at91_dt_defconfig
   - clang-10-axm55xx_defconfig
   - clang-10-bcm2835_defconfig
   - clang-10-clps711x_defconfig
   - clang-10-davinci_all_defconfig
   - clang-10-defconfig
   - clang-10-exynos_defconfig
   - clang-10-footbridge_defconfig
   - clang-10-imx_v4_v5_defconfig
   - clang-10-imx_v6_v7_defconfig
   - clang-10-integrator_defconfig
   - clang-10-ixp4xx_defconfig
   - clang-10-keystone_defconfig
   - clang-10-lpc32xx_defconfig
   - clang-10-mini2440_defconfig
   - clang-10-multi_v5_defconfig
   - clang-10-mxs_defconfig
   - clang-10-nhk8815_defconfig
   - clang-10-omap1_defconfig
   - clang-10-omap2plus_defconfig
   - clang-10-orion5x_defconfig
   - clang-10-pxa910_defconfig
   - clang-10-s3c2410_defconfig
   - clang-10-s3c6400_defconfig
   - clang-10-s5pv210_defconfig
   - clang-10-sama5_defconfig
   - clang-10-shmobile_defconfig
   - clang-10-tinyconfig
   - clang-10-u8500_defconfig
   - clang-10-vexpress_defconfig
   - clang-11-allnoconfig
   - clang-11-at91_dt_defconfig
   - clang-11-axm55xx_defconfig
   - clang-11-bcm2835_defconfig
   - clang-11-clps711x_defconfig
   - clang-11-davinci_all_defconfig
   - clang-11-defconfig
   - clang-11-exynos_defconfig
   - clang-11-footbridge_defconfig
   - clang-11-imx_v4_v5_defconfig
   - clang-11-imx_v6_v7_defconfig
   - clang-11-integrator_defconfig
   - clang-11-ixp4xx_defconfig
   - clang-11-keystone_defconfig
   - clang-11-lpc32xx_defconfig
   - clang-11-mini2440_defconfig
   - clang-11-multi_v5_defconfig
   - clang-11-mxs_defconfig
   - clang-11-nhk8815_defconfig
   - clang-11-omap1_defconfig
   - clang-11-omap2plus_defconfig
   - clang-11-orion5x_defconfig
   - clang-11-pxa910_defconfig
   - clang-11-s3c2410_defconfig
   - clang-11-s3c6400_defconfig
   - clang-11-s5pv210_defconfig
   - clang-11-sama5_defconfig
   - clang-11-shmobile_defconfig
   - clang-11-tinyconfig
   - clang-11-u8500_defconfig
   - clang-11-vexpress_defconfig
   - clang-12-allnoconfig
   - clang-12-at91_dt_defconfig
   - clang-12-axm55xx_defconfig
   - clang-12-bcm2835_defconfig
   - clang-12-clps711x_defconfig
   - clang-12-davinci_all_defconfig
   - clang-12-defconfig
   - clang-12-defconfig-50bba0f5
   - clang-12-exynos_defconfig
   - clang-12-footbridge_defconfig
   - clang-12-imx_v4_v5_defconfig
   - clang-12-imx_v6_v7_defconfig
   - clang-12-integrator_defconfig
   - clang-12-ixp4xx_defconfig
   - clang-12-keystone_defconfig
   - clang-12-lpc32xx_defconfig
   - clang-12-mini2440_defconfig
   - clang-12-multi_v5_defconfig
   - clang-12-mxs_defconfig
   - clang-12-nhk8815_defconfig
   - clang-12-omap1_defconfig
   - clang-12-omap2plus_defconfig
   - clang-12-orion5x_defconfig
   - clang-12-pxa910_defconfig
   - clang-12-s3c2410_defconfig
   - clang-12-s3c6400_defconfig
   - clang-12-s5pv210_defconfig
   - clang-12-sama5_defconfig
   - clang-12-shmobile_defconfig
   - clang-12-tinyconfig
   - clang-12-u8500_defconfig
   - clang-12-vexpress_defconfig
   - clang-13-allnoconfig
   - clang-13-at91_dt_defconfig
   - clang-13-axm55xx_defconfig
   - clang-13-bcm2835_defconfig
   - clang-13-clps711x_defconfig
   - clang-13-davinci_all_defconfig
   - clang-13-defconfig
   - clang-13-defconfig-50bba0f5
   - clang-13-exynos_defconfig
   - clang-13-footbridge_defconfig
   - clang-13-imx_v4_v5_defconfig
   - clang-13-imx_v6_v7_defconfig
   - clang-13-integrator_defconfig
   - clang-13-ixp4xx_defconfig
   - clang-13-keystone_defconfig
   - clang-13-lpc32xx_defconfig
   - clang-13-mini2440_defconfig
   - clang-13-multi_v5_defconfig
   - clang-13-mxs_defconfig
   - clang-13-nhk8815_defconfig
   - clang-13-omap1_defconfig
   - clang-13-omap2plus_defconfig
   - clang-13-orion5x_defconfig
   - clang-13-pxa910_defconfig
   - clang-13-s3c2410_defconfig
   - clang-13-s3c6400_defconfig
   - clang-13-s5pv210_defconfig
   - clang-13-sama5_defconfig
   - clang-13-shmobile_defconfig
   - clang-13-tinyconfig
   - clang-13-u8500_defconfig
   - clang-13-vexpress_defconfig
   - clang-nightly-allnoconfig
   - clang-nightly-at91_dt_defconfig
   - clang-nightly-axm55xx_defconfig
   - clang-nightly-bcm2835_defconfig
   - clang-nightly-clps711x_defconfig
   - clang-nightly-davinci_all_defconfig
   - clang-nightly-defconfig
   - clang-nightly-defconfig-50bba0f5
   - clang-nightly-exynos_defconfig
   - clang-nightly-footbridge_defconfig
   - clang-nightly-imx_v4_v5_defconfig
   - clang-nightly-imx_v6_v7_defconfig
   - clang-nightly-integrator_defconfig
   - clang-nightly-ixp4xx_defconfig
   - clang-nightly-keystone_defconfig
   - clang-nightly-lpc32xx_defconfig
   - clang-nightly-mini2440_defconfig
   - clang-nightly-multi_v5_defconfig
   - clang-nightly-mxs_defconfig
   - clang-nightly-nhk8815_defconfig
   - clang-nightly-omap1_defconfig
   - clang-nightly-omap2plus_defconfig
   - clang-nightly-orion5x_defconfig
   - clang-nightly-pxa910_defconfig
   - clang-nightly-s3c2410_defconfig
   - clang-nightly-s3c6400_defconfig
   - clang-nightly-s5pv210_defconfig
   - clang-nightly-sama5_defconfig
   - clang-nightly-shmobile_defconfig
   - clang-nightly-tinyconfig
   - clang-nightly-u8500_defconfig
   - clang-nightly-vexpress_defconfig
   - gcc-10-allnoconfig
   - gcc-10-at91_dt_defconfig
   - gcc-10-axm55xx_defconfig
   - gcc-10-bcm2835_defconfig
   - gcc-10-clps711x_defconfig
   - gcc-10-davinci_all_defconfig
   - gcc-10-defconfig
   - gcc-10-defconfig-493f0879
   - gcc-10-defconfig-50bba0f5
   - gcc-10-defconfig-5a3a4204
   - gcc-10-defconfig-6830ede0
   - gcc-10-defconfig-883c3502
   - gcc-10-defconfig-a05dd807
   - gcc-10-defconfig-c58d92d2
   - gcc-10-defconfig-ced87bbf
   - gcc-10-exynos_defconfig
   - gcc-10-footbridge_defconfig
   - gcc-10-imx_v4_v5_defconfig
   - gcc-10-imx_v6_v7_defconfig
   - gcc-10-integrator_defconfig
   - gcc-10-ixp4xx_defconfig
   - gcc-10-keystone_defconfig
   - gcc-10-lpc32xx_defconfig
   - gcc-10-mini2440_defconfig
   - gcc-10-multi_v5_defconfig
   - gcc-10-mxs_defconfig
   - gcc-10-nhk8815_defconfig
   - gcc-10-omap1_defconfig
   - gcc-10-omap2plus_defconfig
   - gcc-10-orion5x_defconfig
   - gcc-10-pxa910_defconfig
   - gcc-10-s3c2410_defconfig
   - gcc-10-s3c6400_defconfig
   - gcc-10-s5pv210_defconfig
   - gcc-10-sama5_defconfig
   - gcc-10-shmobile_defconfig
   - gcc-10-tinyconfig
   - gcc-10-u8500_defconfig
   - gcc-10-vexpress_defconfig
   - gcc-11-allnoconfig
   - gcc-11-at91_dt_defconfig
   - gcc-11-axm55xx_defconfig
   - gcc-11-bcm2835_defconfig
   - gcc-11-clps711x_defconfig
   - gcc-11-davinci_all_defconfig
   - gcc-11-defconfig
   - gcc-11-exynos_defconfig
   - gcc-11-footbridge_defconfig
   - gcc-11-imx_v4_v5_defconfig
   - gcc-11-imx_v6_v7_defconfig
   - gcc-11-integrator_defconfig
   - gcc-11-ixp4xx_defconfig
   - gcc-11-keystone_defconfig
   - gcc-11-lpc32xx_defconfig
   - gcc-11-mini2440_defconfig
   - gcc-11-multi_v5_defconfig
   - gcc-11-mxs_defconfig
   - gcc-11-nhk8815_defconfig
   - gcc-11-omap1_defconfig
   - gcc-11-omap2plus_defconfig
   - gcc-11-orion5x_defconfig
   - gcc-11-pxa910_defconfig
   - gcc-11-s3c2410_defconfig
   - gcc-11-s3c6400_defconfig
   - gcc-11-s5pv210_defconfig
   - gcc-11-sama5_defconfig
   - gcc-11-shmobile_defconfig
   - gcc-11-tinyconfig
   - gcc-11-u8500_defconfig
   - gcc-11-vexpress_defconfig
   - gcc-8-allnoconfig
   - gcc-8-at91_dt_defconfig
   - gcc-8-axm55xx_defconfig
   - gcc-8-bcm2835_defconfig
   - gcc-8-clps711x_defconfig
   - gcc-8-davinci_all_defconfig
   - gcc-8-defconfig
   - gcc-8-exynos_defconfig
   - gcc-8-footbridge_defconfig
   - gcc-8-imx_v4_v5_defconfig
   - gcc-8-imx_v6_v7_defconfig
   - gcc-8-integrator_defconfig
   - gcc-8-ixp4xx_defconfig
   - gcc-8-keystone_defconfig
   - gcc-8-lpc32xx_defconfig
   - gcc-8-mini2440_defconfig
   - gcc-8-multi_v5_defconfig
   - gcc-8-mxs_defconfig
   - gcc-8-nhk8815_defconfig
   - gcc-8-omap1_defconfig
   - gcc-8-omap2plus_defconfig
   - gcc-8-orion5x_defconfig
   - gcc-8-pxa910_defconfig
   - gcc-8-s3c2410_defconfig
   - gcc-8-s3c6400_defconfig
   - gcc-8-s5pv210_defconfig
   - gcc-8-sama5_defconfig
   - gcc-8-shmobile_defconfig
   - gcc-8-tinyconfig
   - gcc-8-u8500_defconfig
   - gcc-8-vexpress_defconfig
   - gcc-9-allnoconfig
   - gcc-9-at91_dt_defconfig
   - gcc-9-axm55xx_defconfig
   - gcc-9-bcm2835_defconfig
   - gcc-9-clps711x_defconfig
   - gcc-9-davinci_all_defconfig
   - gcc-9-defconfig
   - gcc-9-exynos_defconfig
   - gcc-9-footbridge_defconfig
   - gcc-9-imx_v4_v5_defconfig
   - gcc-9-imx_v6_v7_defconfig
   - gcc-9-integrator_defconfig
   - gcc-9-ixp4xx_defconfig
   - gcc-9-keystone_defconfig
   - gcc-9-lpc32xx_defconfig
   - gcc-9-mini2440_defconfig
   - gcc-9-multi_v5_defconfig
   - gcc-9-mxs_defconfig
   - gcc-9-nhk8815_defconfig
   - gcc-9-omap1_defconfig
   - gcc-9-omap2plus_defconfig
   - gcc-9-orion5x_defconfig
   - gcc-9-pxa910_defconfig
   - gcc-9-s3c2410_defconfig
   - gcc-9-s3c6400_defconfig
   - gcc-9-s5pv210_defconfig
   - gcc-9-sama5_defconfig
   - gcc-9-shmobile_defconfig
   - gcc-9-tinyconfig
   - gcc-9-u8500_defconfig
   - gcc-9-vexpress_defconfig

* arm64, build
   - clang-10-allnoconfig
   - clang-10-tinyconfig
   - clang-11-allnoconfig
   - clang-11-tinyconfig
   - clang-12-allnoconfig
   - clang-12-tinyconfig
   - clang-13-allnoconfig
   - clang-13-tinyconfig
   - clang-nightly-allnoconfig
   - clang-nightly-tinyconfig
   - gcc-10-allnoconfig
   - gcc-10-tinyconfig
   - gcc-11-allnoconfig
   - gcc-11-tinyconfig
   - gcc-8-allnoconfig
   - gcc-8-tinyconfig
   - gcc-9-allnoconfig
   - gcc-9-tinyconfig

* i386, build
   - clang-10-allnoconfig
   - clang-10-defconfig
   - clang-10-tinyconfig
   - clang-11-allnoconfig
   - clang-11-defconfig
   - clang-11-tinyconfig
   - clang-12-allnoconfig
   - clang-12-defconfig
   - clang-12-tinyconfig
   - clang-13-allnoconfig
   - clang-13-defconfig
   - clang-13-tinyconfig
   - clang-nightly-allnoconfig
   - clang-nightly-defconfig
   - clang-nightly-tinyconfig
   - gcc-10-allnoconfig
   - gcc-10-defconfig
   - gcc-10-tinyconfig
   - gcc-11-allnoconfig
   - gcc-11-defconfig
   - gcc-11-tinyconfig
   - gcc-8-allnoconfig
   - gcc-8-i386_defconfig
   - gcc-8-tinyconfig
   - gcc-9-allnoconfig
   - gcc-9-i386_defconfig
   - gcc-9-tinyconfig

* mips, build
   - clang-10-allnoconfig
   - clang-10-defconfig
   - clang-10-tinyconfig
   - clang-11-allnoconfig
   - clang-11-defconfig
   - clang-11-tinyconfig
   - clang-12-allnoconfig
   - clang-12-defconfig
   - clang-12-tinyconfig
   - clang-13-allnoconfig
   - clang-13-defconfig
   - clang-13-tinyconfig
   - clang-nightly-allnoconfig
   - clang-nightly-defconfig
   - clang-nightly-tinyconfig
   - gcc-10-allnoconfig
   - gcc-10-ar7_defconfig
   - gcc-10-ath79_defconfig
   - gcc-10-bcm47xx_defconfig
   - gcc-10-bcm63xx_defconfig
   - gcc-10-defconfig
   - gcc-10-e55_defconfig
   - gcc-10-malta_defconfig
   - gcc-10-rt305x_defconfig
   - gcc-10-tinyconfig
   - gcc-8-allnoconfig
   - gcc-8-ar7_defconfig
   - gcc-8-ath79_defconfig
   - gcc-8-bcm47xx_defconfig
   - gcc-8-bcm63xx_defconfig
   - gcc-8-defconfig
   - gcc-8-e55_defconfig
   - gcc-8-malta_defconfig
   - gcc-8-rt305x_defconfig
   - gcc-8-tinyconfig

* parisc, build
   - gcc-10-allnoconfig
   - gcc-10-defconfig
   - gcc-10-tinyconfig
   - gcc-11-allnoconfig
   - gcc-11-defconfig
   - gcc-11-tinyconfig
   - gcc-8-allnoconfig
   - gcc-8-defconfig
   - gcc-8-tinyconfig
   - gcc-9-allnoconfig
   - gcc-9-defconfig
   - gcc-9-tinyconfig

* powerpc, build
   - gcc-10-allnoconfig
   - gcc-10-cell_defconfig
   - gcc-10-maple_defconfig
   - gcc-10-mpc83xx_defconfig
   - gcc-10-ppc64e_defconfig
   - gcc-10-ppc6xx_defconfig
   - gcc-10-tinyconfig
   - gcc-10-tqm8xx_defconfig
   - gcc-11-allnoconfig
   - gcc-11-cell_defconfig
   - gcc-11-maple_defconfig
   - gcc-11-mpc83xx_defconfig
   - gcc-11-ppc64e_defconfig
   - gcc-11-ppc6xx_defconfig
   - gcc-11-tinyconfig
   - gcc-11-tqm8xx_defconfig
   - gcc-8-allnoconfig
   - gcc-8-cell_defconfig
   - gcc-8-maple_defconfig
   - gcc-8-mpc83xx_defconfig
   - gcc-8-ppc64e_defconfig
   - gcc-8-ppc6xx_defconfig
   - gcc-8-tinyconfig
   - gcc-8-tqm8xx_defconfig
   - gcc-9-allnoconfig
   - gcc-9-cell_defconfig
   - gcc-9-maple_defconfig
   - gcc-9-mpc83xx_defconfig
   - gcc-9-ppc64e_defconfig
   - gcc-9-ppc6xx_defconfig
   - gcc-9-tinyconfig
   - gcc-9-tqm8xx_defconfig

* riscv, build
   - clang-11-allnoconfig
   - clang-11-defconfig
   - clang-11-tinyconfig
   - clang-12-allnoconfig
   - clang-12-defconfig
   - clang-12-tinyconfig
   - clang-13-allnoconfig
   - clang-13-defconfig
   - clang-13-tinyconfig
   - clang-nightly-allnoconfig
   - clang-nightly-defconfig
   - clang-nightly-tinyconfig
   - gcc-10-allnoconfig
   - gcc-10-defconfig
   - gcc-10-tinyconfig
   - gcc-11-allnoconfig
   - gcc-11-defconfig
   - gcc-11-tinyconfig
   - gcc-8-allnoconfig
   - gcc-8-defconfig
   - gcc-8-tinyconfig
   - gcc-9-allnoconfig
   - gcc-9-defconfig
   - gcc-9-tinyconfig

* s390, build
   - clang-13-allnoconfig
   - clang-13-tinyconfig
   - clang-nightly-allnoconfig
   - clang-nightly-tinyconfig
   - gcc-10-allnoconfig
   - gcc-10-tinyconfig
   - gcc-11-allnoconfig
   - gcc-11-tinyconfig
   - gcc-8-allnoconfig
   - gcc-8-tinyconfig
   - gcc-9-allnoconfig
   - gcc-9-tinyconfig

* sh, build
   - gcc-10-allnoconfig
   - gcc-10-defconfig
   - gcc-10-dreamcast_defconfig
   - gcc-10-microdev_defconfig
   - gcc-10-shx3_defconfig
   - gcc-10-tinyconfig
   - gcc-11-allnoconfig
   - gcc-11-defconfig
   - gcc-11-dreamcast_defconfig
   - gcc-11-microdev_defconfig
   - gcc-11-shx3_defconfig
   - gcc-11-tinyconfig
   - gcc-8-allnoconfig
   - gcc-8-defconfig
   - gcc-8-dreamcast_defconfig
   - gcc-8-microdev_defconfig
   - gcc-8-shx3_defconfig
   - gcc-8-tinyconfig
   - gcc-9-allnoconfig
   - gcc-9-defconfig
   - gcc-9-dreamcast_defconfig
   - gcc-9-microdev_defconfig
   - gcc-9-shx3_defconfig
   - gcc-9-tinyconfig

* sparc, build
   - gcc-10-allnoconfig
   - gcc-10-defconfig
   - gcc-10-tinyconfig
   - gcc-11-allnoconfig
   - gcc-11-defconfig
   - gcc-11-tinyconfig
   - gcc-8-allnoconfig
   - gcc-8-defconfig
   - gcc-8-tinyconfig
   - gcc-9-allnoconfig
   - gcc-9-defconfig
   - gcc-9-tinyconfig

* x86_64, build
   - clang-10-allnoconfig
   - clang-10-defconfig
   - clang-10-tinyconfig
   - clang-11-allnoconfig
   - clang-11-tinyconfig
   - clang-11-x86_64_defconfig
   - clang-12-allnoconfig
   - clang-12-tinyconfig
   - clang-12-x86_64_defconfig
   - clang-13-allnoconfig
   - clang-13-tinyconfig
   - clang-13-x86_64_defconfig
   - clang-nightly-allnoconfig
   - clang-nightly-tinyconfig
   - clang-nightly-x86_64_defconfig
   - gcc-10-allnoconfig
   - gcc-10-defconfig
   - gcc-10-tinyconfig
   - gcc-11-allnoconfig
   - gcc-11-defconfig
   - gcc-11-tinyconfig
   - gcc-8-allnoconfig
   - gcc-8-tinyconfig
   - gcc-8-x86_64_defconfig
   - gcc-9-allnoconfig
   - gcc-9-tinyconfig
   - gcc-9-x86_64_defconfig

(It would have been easier to list the ones that _passed_ instead! :)

Greetings!

daniel Díaz
daniel.diaz@linaro.org
