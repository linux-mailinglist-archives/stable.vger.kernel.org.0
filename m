Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D960649B2F8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 12:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348721AbiAYLc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 06:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345925AbiAYLaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 06:30:23 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CEFC061744
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 03:28:25 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id p5so60582969ybd.13
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 03:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nKfpQISqriKOsG4ekJR5vF8uuiCgZwGiWhtxeLFlL4Y=;
        b=uRyJ8dFIbEA6wV3dKfUeKLZnoKW9Jfc+zmlHkz5aFm+W5IyLGdYNIZu6HvMRe/RfLI
         Z0wAN5OVA4XfC0zSbicOQjiKYcyrzhJ98QMKwpCHMZD/U+5F6TceNtDBtJBOUq78poSC
         JWEzm1iz3F08UJBcthUYi2fL/ixmeLTKTYQYUgwNG7KC4cgK0VAI9eVSSVIpYisdktvJ
         EpGxOmV0FfJpsZuhVQvfFWfnNVPuTdUCQ0QKhtDvK2SV9FpVYjUo7AW03E/d9Th79HuZ
         zMISbNr99FnW5pd4WTH7sLM3w21bTVf3QKMm0SPhT2NJmpABuj/uUHVu+nWjNU7zHs3i
         NQVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nKfpQISqriKOsG4ekJR5vF8uuiCgZwGiWhtxeLFlL4Y=;
        b=CAjzBOn74wLVBIWMdS+WU2WWZnnR8zC7QNMk91NgCTSdLIXmn9lMZ2DkNWWbGCbGIo
         0aJYzL1EZc/UdG3uYD2VvNIdmmSy//E5XDY5gQUjFuJVfJ0hcWcGMEbYaQs3RSm4A3rD
         MyK0Oqf0+Y85M+HdfEEnZDxgud9XeB4G8esClXxxcyOJIHv/dWCD0gK5YvI6/ZdkQXdP
         M6GsQgolTIyAdFSJrb/65wHdQDkojTSl5B+kfYsdlkHBfeaEXNGx7hhdIZczvQgJFFir
         gOvw6pn+Jzk8LBFRkupz15kO1+BxCDHEQO6atL3t33v4UXmCqoW34Bv/pC+UhhUFoGxA
         36xw==
X-Gm-Message-State: AOAM533S8zRQIM9Scx7/eosQ5lQ1Pbvd0ZCFZu1yfQKqrwjJll5AQNhr
        P0nswAqbDyonZ9lfk/y5z50UAFxzjUhjbH/6Zalhyw==
X-Google-Smtp-Source: ABdhPJw+2dPoVdljHBFLY7lLCAbrmWVow5rNy/aBKbCDl91AQV8Eqt1nhEeHMwcJKEUsQVgMh0MaEzXsQkK7WIoS5BI=
X-Received: by 2002:a25:838b:: with SMTP id t11mr27044230ybk.146.1643110104215;
 Tue, 25 Jan 2022 03:28:24 -0800 (PST)
MIME-Version: 1.0
References: <20220124183937.101330125@linuxfoundation.org>
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Jan 2022 16:58:13 +0530
Message-ID: <CA+G9fYshfJ-WCB141=ha8uf0-FhE9Pim6hd5BWAVxDpvHhTR0w@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/186] 4.14.263-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 at 00:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.263 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.263-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following patch caused build failures on arm imx_v6_v7_defconfig

> Lucas Stach <l.stach@pengutronix.de>
>     drm/etnaviv: limit submit sizes

 build/clang-nightly-imx_v6_v7_defconfig
 build/gcc-11-imx_v6_v7_defconfig
 build/gcc-10-imx_v6_v7_defconfig
 build/clang-11-imx_v6_v7_defconfig
 build/clang-12-imx_v6_v7_defconfig
 build/clang-13-imx_v6_v7_defconfig

Error:
-------
make --silent --keep-going --jobs=8 ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'

drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c: In function
'etnaviv_ioctl_gem_submit':
drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c:345:37: error: 'struct
drm_etnaviv_gem_submit' has no member named 'nr_pmrs'; did you mean
'nr_bos'?
      args->nr_bos > SZ_64K || args->nr_pmrs > 128) {
                                     ^~~~~~~
                                     nr_bos
make[5]: *** [scripts/Makefile.build:329:
drivers/gpu/drm/etnaviv/etnaviv_gem_submit.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

 --
Linaro LKFT
https://lkft.linaro.org
