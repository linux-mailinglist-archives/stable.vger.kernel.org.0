Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE87E2E858B
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbhAAUaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbhAAUaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:30:24 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8654FC061573
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 12:29:43 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id i24so20903266edj.8
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 12:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=erGuQwA96UNi+KloOUaqVfQUiHRql8hnOXPAAjHszhI=;
        b=iV/LPDNK4M/WjkR7M3eIkbW9w6lnRmyTXLjHfD6wQuZyh0rgbVE2p2GFvj9uEfj9IG
         ZSfTmKZfm3wlANcTrD9My8UlY0cBAYD2lclgiue0AYwyFSO38Nr2UWXpTITDTCF40qLU
         A2tffMfFu4NjlAGae9Ljj8HEu/JrrKZ/2rXLqP7XzWJa38xcIaLf43iASuggY6bxlhI7
         OsQObpC/fot0en2gPL50bo2w9+rAN9ErNU3KFDPBGy4D1J8D5UKqPKYI6BEKDzGk+LjF
         N4BmjowMbv/fzzGryv0fnObpKRgAz6fa8P68JPeAn7LHHr/YcSSDvcNIyFqCpyxlLZlM
         +IJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=erGuQwA96UNi+KloOUaqVfQUiHRql8hnOXPAAjHszhI=;
        b=M9sR+c8FSbQy46WRm0rGPhdCtreH/H197iyRFKlwoJ+dEpxOejCg8qRlKu+zjZJ1nE
         eBeemeADVc6f9zjzMS83R+Cykmtrt3Lz2R2bVaNo8OJOucAXwMCc5op2NscTnWmK1lfA
         apDz+9J7S1N2DAnNpezvALlJ1RQcokFYFsjO5webanVnotct/WzQx9i2sDSauGkTHIrj
         k6SLGE2LBR9s0M3nLdW+e1vq2bhsuGQeHg6N1mDkkGwEkq2xhvX4mQ4oINCZcDMvZNDk
         wuLXDPDz1VbonqosLgQnc523RAub4sNlQ65NIAMXOr0ekeaMjtXpjN00gNkOX3WdqUvM
         /BJA==
X-Gm-Message-State: AOAM5333qP2UiZgdvM4GeNSMdSoyW8VOksvj+UEcq62H6Dkjj758ZABB
        iRhyxqJh00qtsgJsxAGtCXHoEVxqFI0kPQ==
X-Google-Smtp-Source: ABdhPJxttdEDsNr5EcUksflYEJVry3XlBAdPFPUcU+zc6Rj84/uCYri/7Z8alWYC3uw3teLYFeqYtw==
X-Received: by 2002:aa7:db59:: with SMTP id n25mr58568463edt.203.1609532982283;
        Fri, 01 Jan 2021 12:29:42 -0800 (PST)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id u24sm6751028eje.71.2021.01.01.12.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 12:29:41 -0800 (PST)
Date:   Fri, 1 Jan 2021 21:29:39 +0100
From:   Petr Vorel <petr.vorel@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Rich Felker <dalias@libc.org>,
        Peter Korsgaard <peter@korsgaard.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Florian Weimer <fweimer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] uapi: move constants from <linux/kernel.h> to
 <linux/const.h>
Message-ID: <X++GM/DQGoDfGVuQ@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210101202758.28291-1-petr.vorel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210101202758.28291-1-petr.vorel@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> and include <linux/const.h> in UAPI headers instead of <linux/kernel.h>.

> commit a85cbe6159ffc973e5702f70a3bd5185f8f3c38d upstream.

> The reason is to avoid indirect <linux/sysinfo.h> include when using
> some network headers: <linux/netlink.h> or others -> <linux/kernel.h>
> -> <linux/sysinfo.h>.

> This indirect include causes on MUSL redefinition of struct sysinfo when
> included both <sys/sysinfo.h> and some of UAPI headers:

>     In file included from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/kernel.h:5,
>                      from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/netlink.h:5,
>                      from ../include/tst_netlink.h:14,
>                      from tst_crypto.c:13:
>     x86_64-buildroot-linux-musl/sysroot/usr/include/linux/sysinfo.h:8:8: error: redefinition of `struct sysinfo'
>      struct sysinfo {
>             ^~~~~~~
>     In file included from ../include/tst_safe_macros.h:15,
>                      from ../include/tst_test.h:93,
>                      from tst_crypto.c:11:
>     x86_64-buildroot-linux-musl/sysroot/usr/include/sys/sysinfo.h:10:8: note: originally defined here

> Link: https://lkml.kernel.org/r/20201015190013.8901-1-petr.vorel@gmail.com
> Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
> Suggested-by: Rich Felker <dalias@aerifal.cx>
> Acked-by: Rich Felker <dalias@libc.org>
> Cc: Peter Korsgaard <peter@korsgaard.com>
> Cc: Baruch Siach <baruch@tkos.co.il>
> Cc: Florian Weimer <fweimer@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> Hi,

> could this fix be backported to stable releases?
> Maybe safer to wait till v5.11 release.

> Adjusted for stable/linux-5.10.y.
FYI: Actually no modification was needed for stable/linux-5.10.y.

Kind regards,
Petr
