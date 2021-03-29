Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3B034CD0B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 11:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhC2JaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 05:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhC2JaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 05:30:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875E8C061756
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 02:30:05 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u5so18371512ejn.8
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 02:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vTRPui0u48D02lPV5oF4khibkSq4HKzG3OsqeO/4Iao=;
        b=Jh9KmSUIM15NXIFGmkO/7GT5MqmQpT+6QxkRJqBu9UGbukYU+lNkd//DpxNlHyAs8g
         V+x3ef3s830UCmKMyvqBoCCz8KJTkt1r1qmdmV9xFnO3UlDNMZGGo3194SvQeJdxhs6/
         w41xPtJvi78PaIVNL+GO38e/RRz5nsT4e30+8ZpOYK7oqTFEdufC9novbhl+qlL1crqY
         x8qvJunV6xKrDA4bhxrRbreRwNeHujWA/nqntrzx67Gv3zv7fEer2rKmaY6CHqUqEy6n
         M+XkTmsIMnzvp8GUwa72+CKfZUJ86JzU4WlXoMc4RyBdpHZ1whmzFpypvSgcMdh6ocND
         UwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vTRPui0u48D02lPV5oF4khibkSq4HKzG3OsqeO/4Iao=;
        b=D4YtauzuaVe1wVL8cSQ3ATPAH35Z2blrQ5CLA5t7KVoVhsJeBLWEzy6jgDGWqcq+TV
         bMZR9qixLS6RWbl2xZ6rwibXLHjTUDVquOoZDguUCHYdJ1myjd/IZRskdmLTOX27L0ds
         9lMhPdE7riuN4grdpooQCELbMpe3QSsoN78ILap29UIAfl+qyYrf0NK+d75nMS3zQrSq
         Lkd4ZjAZpHAQjJGMQfHEf8jPGLIXZcFUSo/aTzTV2hYEP21w05frRnngHvI9oA15niBS
         gggzh8nuFaUsjTs8J7eNxk+kCL2lv4vfxribsm7emtA24CiCU/8b+lhClqQGr9oZSWTh
         bQyA==
X-Gm-Message-State: AOAM532Sq2G+HEqSLLBisH60DwCnl6q4hWTv95qq7Z11Yi8z1gbv/Gul
        OTwqkqGHdaWjf8eso4aYy+DZjByCOr3jAaOiwxSt9Q==
X-Google-Smtp-Source: ABdhPJwS6hT52eCi3oZLx150FX+NOmzUj1j2vTPIegpVTj4GEfEZai+lF7oUKcz2bB5egXPfKLW8PcERvlwqEReyXiM=
X-Received: by 2002:a17:906:2a16:: with SMTP id j22mr27758109eje.247.1617010204130;
 Mon, 29 Mar 2021 02:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075633.135869143@linuxfoundation.org>
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 29 Mar 2021 14:59:53 +0530
Message-ID: <CA+G9fYs0-q+f4nT72PLn9ksHvKx=J6kJ6eyTuXa8OoocJwPmiQ@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/254] 5.11.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 at 14:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.11 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The stable rc 5.10 and 5.11 builds failed for arm64 architecture
due to below warnings / errors,

> Anshuman Khandual <anshuman.khandual@arm.com>
>     arm64/mm: define arch_get_mappable_range()


  arch/arm64/mm/mmu.c: In function 'arch_add_memory':
  arch/arm64/mm/mmu.c:1483:13: error: implicit declaration of function
'mhp_range_allowed'; did you mean 'cpu_map_prog_allowed'?
[-Werror=implicit-function-declaration]
    VM_BUG_ON(!mhp_range_allowed(start, size, true));
               ^
  include/linux/build_bug.h:30:63: note: in definition of macro
'BUILD_BUG_ON_INVALID'
   #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
                                                                 ^
  arch/arm64/mm/mmu.c:1483:2: note: in expansion of macro 'VM_BUG_ON'
    VM_BUG_ON(!mhp_range_allowed(start, size, true));
    ^~~~~~~~~

Build link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.11/DISTRO=lkft,MACHINE=juno,label=docker-buster-lkft/41/consoleText
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.10/DISTRO=lkft,MACHINE=dragonboard-410c,label=docker-buster-lkft/120/consoleFull

-- 
Linaro LKFT
https://lkft.linaro.org
