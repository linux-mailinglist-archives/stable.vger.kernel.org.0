Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD71B300711
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 16:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbhAVPWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 10:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729097AbhAVPVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 10:21:40 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08CDC061793
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 07:20:56 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id dj23so6931092edb.13
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 07:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aOloNP8QP0eRjNYGwI2LuME4o0nuHEoMMVeWM2V/lRc=;
        b=sbzgT+ujzjH+zt+7L+xw6IGAcMB2kX9DI9x++kTzcsyjl+GM3mBuDar3l4WnCAT9Dh
         pgHkdgeP5bEntfbsBTm5TaIwq/wvsdYYHMAY34UNH5be4lg0Gciz0RV2sRZ/DQqoDmMC
         iQJREvUhqSkXVO6aN3Sl9HAZYe92Z10HZo8S+nniNKTK8RZaVYGf/6j1JlarKS5boZLo
         W+ggNQ+GVjazd/gpWGm3av8Ua36af3Ult+gnlfxjvnnUEa7qAzSqKbOxeXozmNeDZRH6
         vZWJtzWLgJ4Yh9kgvlID6jHYbPFZE9SFkZc+X9VBppAiuYmHEDuPHhVJvAoKBWmtwcWU
         3jKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aOloNP8QP0eRjNYGwI2LuME4o0nuHEoMMVeWM2V/lRc=;
        b=T8kJ1v/wriRkdsqfZ7BKsNQXsqzOQra3Cw8pzbe41xkbmphcvIe3jDoOtWANxcmnC1
         +biSHLsCrb6dbKouG/Ub84E3ywgM3WT3HDRw0hnfBV235/bWQrzlxRrVz/DpJlwmkWvf
         33M49YQNyRoOnySCF6B8dltZ1cjD9NJ8PvMUtP7IVjdij/etVykI6d9LtnrT5aXVFD02
         MBlVoDkHlacRgqxrrcm3ig5KwLvagpGJtU0pnvxltmhccwS/yv0eGbI4rpGIKSEebcGP
         DPB8mvuedPrOH0hNfZw4j7cUXgOL9BQb97xTPV+IQKsUCrdADjJp+sv9sCoCEQUsuOax
         c7fw==
X-Gm-Message-State: AOAM5322DClqwU6ZS/W8psTxkJoaYthK+Na1fP/z8TXsgQshiLKKd87j
        n76NGJaJAnGRB28LgTthWczs9URIlNSmsQNUrUil8g==
X-Google-Smtp-Source: ABdhPJwlRzpjVufr2v/TA6LbcxJQDXB6wj/lxcM/6k8GjjcGI86de739kHP+7V+WQ9LzcUy/SOnHNJoLFtW38dsCrrE=
X-Received: by 2002:a05:6402:5107:: with SMTP id m7mr27470edd.52.1611328855234;
 Fri, 22 Jan 2021 07:20:55 -0800 (PST)
MIME-Version: 1.0
References: <20210122135735.176469491@linuxfoundation.org>
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 22 Jan 2021 20:50:43 +0530
Message-ID: <CA+G9fYus+rnoxpZqhn35fMz4ZPQvYjkKFKSCsOhFtrHzbu1pZw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/50] 4.14.217-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-mips@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jan 2021 at 19:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.217 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.217-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

MIPS: cavium_octeon_defconfig and nlm_xlp_defconfig builds breaks
due to this patch on 4.14, 4.9 and 4.4

> Al Viro <viro@zeniv.linux.org.uk>
>     MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps

Build error:
arch/mips/kernel/binfmt_elfo32.c:116:
/arch/mips/kernel/../../../fs/binfmt_elf.c: In function 'fill_siginfo_note':
/arch/mips/kernel/../../../fs/binfmt_elf.c:1575:23: error: passing
argument 1 of 'copy_siginfo_to_user' from incompatible pointer type
[-Werror=incompatible-pointer-types]
  copy_siginfo_to_user((user_siginfo_t __user *) csigdata, siginfo);
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MIPS build failed
    * gcc-10-cavium_octeon_defconfig - FAILED
    * gcc-10-nlm_xlp_defconfig - FAILED
    * gcc-8-cavium_octeon_defconfig - FAILED
    * gcc-8-nlm_xlp_defconfig - FAILED
    * gcc-9-cavium_octeon_defconfig - FAILED
    * gcc-9-nlm_xlp_defconfig - FAILED

Build log link,
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/980489009#L162


-- 
Linaro LKFT
https://lkft.linaro.org
