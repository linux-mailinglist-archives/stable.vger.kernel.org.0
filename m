Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843392FA36A
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405148AbhAROox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405144AbhAROor (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 09:44:47 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA62BC0613CF
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 06:43:59 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id h16so17861262edt.7
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 06:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eDEr8EsYnN9j0p1ty6nt7x7JGOwdRnEpsAX+fmWuDF0=;
        b=aQgerXn24odrgBCC86uWNOviYMcYgNvr7tE7Xqw5uuPm8c1rxQNPC8/8BkbWMRjFzt
         pc0R6UFMJokRIPGgA56/aahSC3XWOcpmbTJ6PGnat42xz3olUkB4t7apb1kKWIwiy/5c
         V6ZpsXJNMa9al1E+PoiPpMmVncrM9W4mdKZCCykGe/r/1A6cNq+qWvmwLQBl1keHzo/z
         xRS+APY8QmFPPbLQOVijpSY97G051Z5umOPcIWdjJewVZb7wZtlVvl+6KSg/uhZggEYJ
         Ht1FSh60xUKakB2kAOKdrg6mN3rrgeQ5VbDKTKEDKqI3S21VRr2o4xJ/5VqvJtzeFVPg
         5lSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eDEr8EsYnN9j0p1ty6nt7x7JGOwdRnEpsAX+fmWuDF0=;
        b=J/1hw/e0r96GQPZZ6LeN0nIbW+nHMIElzOnthWuLBTn9n/Rs9t9hSQQbuwwKegSBxw
         U9PCGu5+TapqtpepYUuMa3nariBRCgtBrmnX4wMISuyKlyWV8PBU4nW+45QBSdW4ETgt
         A3ZA/LFhv27821nfADuPHiMb1990sVG1P+aqd7eTTId7mW/WQA1VOjN2dVH/vaqAFqY7
         R1FV+GOi2N+KSOWv0FiiRh5S7aTfAhIHZovKc6Yljw+sL3u2lwi2DCZIh0NXRH0A54m9
         jG/sEC12HkIZOpz2dLv6tgUwreZo0F17IBfa52tO5vEUxk7E+QrzkZgzq/6uckJ+N9xp
         0RPQ==
X-Gm-Message-State: AOAM533nJfEdlsYVS4z0I62kO4NF5QNUkm7w+9TvIEKl0Rb3vXjmQB+d
        QEiT7AcBlV5Tn6a1MQSTUZbI7ywezpt10dPapPcuHg==
X-Google-Smtp-Source: ABdhPJxQBu6TOGumUHE5+jC5O+0aDfrNuJjdy1ExMZJN5AVO/xtQoOyXHSNPQAkyWHGnJ8ss4eEX3jA/Nr3T+FpNy1g=
X-Received: by 2002:aa7:da8f:: with SMTP id q15mr19327452eds.239.1610981038464;
 Mon, 18 Jan 2021 06:43:58 -0800 (PST)
MIME-Version: 1.0
References: <20210118113340.984217512@linuxfoundation.org>
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 18 Jan 2021 20:13:47 +0530
Message-ID: <CA+G9fYvMxJgZERbpiHzz+kf4aNHAf5DYg3uQGfksL-wN8huUiw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/76] 5.4.91-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-mips@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jan 2021 at 17:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.91 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.91-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


MIPS: cavium_octeon_defconfig and nlm_xlp_defconfig builds breaks
due to this patch on stable-rc 4.19 and stable-rc 5.4 branches.

> Al Viro <viro@zeniv.linux.org.uk>
>     MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>


-- 
Linaro LKFT
https://lkft.linaro.org
