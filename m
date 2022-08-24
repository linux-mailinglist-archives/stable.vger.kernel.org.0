Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C1E59F382
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 08:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiHXGOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 02:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiHXGOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 02:14:09 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E7C4055E
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 23:14:08 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u15so22850887ejt.6
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 23:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=u3g5QulTSLFvye8ufETPpL4OUU5TpmlskHMheK/Pwxs=;
        b=dZTKK6y8UcvHPgx6QCd0uYYQ1eazVYyovqg4Z15UeG0spQZWqYPlNxF0rn9z5bOuF5
         UaqUl71TSYUwWvWHY+ZBTjUas31Nxv6bwlzd2gfd1jU9ktSjtr0rfAvA91H5g3qgxRJO
         lKSkzV6r5zqRJhrNY2u5hmk9ARjXIt7X59ydViZk84qiH8eKYWVa8R+BbWivE5Qe4FtF
         FwL+dZH13IA+n7DUg9uTivNcENYkkRk+MJNoeUOb6p/B80wDZDzsS5947Iq9Tvbl/4E8
         4pXDaCuOWmbYTJj5yxaMMH6fzQsxtVSZcO3pGA9RXzEy3rrQOOGNxnrE53dMQdB+6wU+
         uDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=u3g5QulTSLFvye8ufETPpL4OUU5TpmlskHMheK/Pwxs=;
        b=JEefrqu6FYI0Gw88sdOqgTVPBEsTH9vIh4+Y3ehJUxiHJuOYdlX7RQ4FSbHwr7HSgV
         9MPiKRHjlZhDMNuyYDA6bkCY63uUELmWhFnkcYvCqEbl0KV+5Ol3wFN4gszkj72ZzJVY
         oWE7VqW3lBefuYNc8vMbR3CZLlu6wI+VEG6ctdy3z6o+bfT6P6FTxWtPZDUY7tL4CB+J
         cU32vkZfxcEA4J3YuLY9Lo9MJTJO9RriNSOSMvdwcj3vmizIHnmNqL65O8A45yx0U+EX
         LtLCzTJ36cgw+PHAw8dxOrkTfk/7eD6ZQBEz0XZT8mHc2K0B7yOw7KCdXRBVM9bFmB3E
         z3Dg==
X-Gm-Message-State: ACgBeo25t65/TN4GADNTfkSVFv1dUdf6mWh7Rp8pyICHVHDrZN6Is717
        VDSK+jWXQo1BBeanGAOAk1kzhFymZKGiWAg8nST++g==
X-Google-Smtp-Source: AA6agR6kM8lihKYko6eSpnQ4fn5oWMZhs8JfJ3bDwLRTzZK428FeSQZGicVrY39tiuUjeNbH/0fbg7DuMqf3SZl4hJg=
X-Received: by 2002:a17:907:7f9f:b0:73d:6e87:17ce with SMTP id
 qk31-20020a1709077f9f00b0073d6e8717cemr1874828ejc.366.1661321646573; Tue, 23
 Aug 2022 23:14:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220823080034.579196046@linuxfoundation.org>
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Aug 2022 11:43:55 +0530
Message-ID: <CA+G9fYvXcuoi6Z9XEZHUOOUA=zT4wjXD9f2yjqrw6a_=2pZA6w@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/101] 4.9.326-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Aug 2022 at 13:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.326 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.326-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
Regressions on arm and mips build failure.

Build failure logs are the same other reports.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.326-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 310ef13ccc72259d4df1c9fabbd5b5f8b7bf5563
* git describe: v4.9.325-102-g310ef13ccc72
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.325-102-g310ef13ccc72

## Test Regressions (compared to v4.9.325)
* arm, build
  - clang-11-at91_dt_defconfig
  - clang-11-axm55xx_defconfig
  - clang-11-exynos_defconfig
  - clang-11-integrator_defconfig
  - clang-11-keystone_defconfig
  - clang-11-multi_v5_defconfig
  - clang-11-nhk8815_defconfig
  - clang-11-omap1_defconfig
  - clang-11-orion5x_defconfig
  - clang-11-pxa910_defconfig
  - clang-11-shmobile_defconfig
  - clang-11-u8500_defconfig
  - clang-11-vexpress_defconfig
  - clang-12-at91_dt_defconfig
  - clang-12-axm55xx_defconfig
  - clang-12-exynos_defconfig
  - clang-12-integrator_defconfig
  - clang-12-keystone_defconfig
  - clang-12-multi_v5_defconfig
  - clang-12-nhk8815_defconfig
  - clang-12-omap1_defconfig
  - clang-12-orion5x_defconfig
  - clang-12-pxa910_defconfig
  - clang-12-shmobile_defconfig
  - clang-12-u8500_defconfig
  - clang-12-vexpress_defconfig
  - clang-13-at91_dt_defconfig
  - clang-13-axm55xx_defconfig
  - clang-13-exynos_defconfig
  - clang-13-integrator_defconfig
  - clang-13-keystone_defconfig
  - clang-13-multi_v5_defconfig
  - clang-13-nhk8815_defconfig
  - clang-13-omap1_defconfig
  - clang-13-orion5x_defconfig
  - clang-13-pxa910_defconfig
  - clang-13-shmobile_defconfig
  - clang-13-u8500_defconfig
  - clang-13-vexpress_defconfig
  - clang-14-multi_v5_defconfig-45747f0c
  - clang-nightly-at91_dt_defconfig
  - clang-nightly-axm55xx_defconfig
  - clang-nightly-exynos_defconfig
  - clang-nightly-integrator_defconfig
  - clang-nightly-keystone_defconfig
  - clang-nightly-multi_v5_defconfig
  - clang-nightly-multi_v5_defconfig-45747f0c
  - clang-nightly-nhk8815_defconfig
  - clang-nightly-omap1_defconfig
  - clang-nightly-orion5x_defconfig
  - clang-nightly-pxa910_defconfig
  - clang-nightly-shmobile_defconfig
  - clang-nightly-u8500_defconfig
  - clang-nightly-vexpress_defconfig
  - gcc-10-at91_dt_defconfig
  - gcc-10-axm55xx_defconfig
  - gcc-10-exynos_defconfig
  - gcc-10-footbridge_defconfig
  - gcc-10-imx_v6_v7_defconfig
  - gcc-10-integrator_defconfig
  - gcc-10-ixp4xx_defconfig
  - gcc-10-keystone_defconfig
  - gcc-10-multi_v5_defconfig
  - gcc-10-nhk8815_defconfig
  - gcc-10-omap1_defconfig
  - gcc-10-orion5x_defconfig
  - gcc-10-pxa910_defconfig
  - gcc-10-shmobile_defconfig
  - gcc-10-u8500_defconfig
  - gcc-10-vexpress_defconfig
  - gcc-11-at91_dt_defconfig
  - gcc-11-axm55xx_defconfig
  - gcc-11-exynos_defconfig
  - gcc-11-footbridge_defconfig
  - gcc-11-imx_v6_v7_defconfig
  - gcc-11-integrator_defconfig
  - gcc-11-ixp4xx_defconfig
  - gcc-11-keystone_defconfig
  - gcc-11-multi_v5_defconfig
  - gcc-11-multi_v5_defconfig-45747f0c
  - gcc-11-nhk8815_defconfig
  - gcc-11-omap1_defconfig
  - gcc-11-orion5x_defconfig
  - gcc-11-pxa910_defconfig
  - gcc-11-shmobile_defconfig
  - gcc-11-u8500_defconfig
  - gcc-11-vexpress_defconfig
  - gcc-9-at91_dt_defconfig
  - gcc-9-axm55xx_defconfig
  - gcc-9-exynos_defconfig
  - gcc-9-footbridge_defconfig
  - gcc-9-imx_v6_v7_defconfig
  - gcc-9-integrator_defconfig
  - gcc-9-ixp4xx_defconfig
  - gcc-9-keystone_defconfig
  - gcc-9-multi_v5_defconfig
  - gcc-9-nhk8815_defconfig
  - gcc-9-omap1_defconfig
  - gcc-9-orion5x_defconfig
  - gcc-9-pxa910_defconfig
  - gcc-9-shmobile_defconfig
  - gcc-9-u8500_defconfig
  - gcc-9-vexpress_defconfig

* mips, build
  - gcc-8-cavium_octeon_defconfig

--
Linaro LKFT
https://lkft.linaro.org
