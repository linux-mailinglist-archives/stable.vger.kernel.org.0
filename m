Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4868038B12C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 16:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243795AbhETOL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 10:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243618AbhETOKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 10:10:44 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B024C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 07:09:12 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so15007190oto.0
        for <stable@vger.kernel.org>; Thu, 20 May 2021 07:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oHxuga1ErFF65E853qwFcrjYHY1gP/v6uMoWxWHzxU8=;
        b=vWMScIMAuBJSC33GVqps5NmQj50vpWdmMBY1L0iMYHDEqsTut6eiVNJUfOelmth+oX
         aBMDIVfW/CWyQLvJkXd7c6ykKnkNiwsvau3aBArOH9aDBUPyXLoEfNuRY6vti3iV4U1T
         L1RSmZ5l9CCu5tD3wggsEGfo9VU6JiwI2SwHHsy14bz43YsfYK+YBm+fd1oDZV81wBAU
         NSOZTtnPQxq4iWX7enfyLVT+PbGX1i+JmcDusj9EBO3z/uJ0jFEsWskOKj5PcFU1pYpF
         zCmXKCijqAb53tis5ZrTrtf6DBbJed4THgh8ZrzPyKFHVsxQPFeWM/04McykVXa7Uzs0
         fDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oHxuga1ErFF65E853qwFcrjYHY1gP/v6uMoWxWHzxU8=;
        b=G/ANTVVjLHbU+FaTfILa1AaqQ7zVLjHMbhAIXFd28yJvOlRy+HaR0zr0X8RowrjbQw
         x+GsXzAnJprfOkgPw9/QBlWASRWO9Hg/GLrXL2LobUlJq6g7Lf62YjPAd7iWXaM6u1kK
         j+Zp+LU7MyD4taL59JAifO+djMXlW4wwfG7S55B519HsTnD0KJJ5nsZXooXW8XsWWoiB
         uF2DHZkPYBOadzY8iWKLhR9uKaCNTKyLthQwS8tCISVkYav5ZYGFSCQVQ9Ir+EpuIX3L
         V78MG/gVpCOmGCvzIo/UrtiaAllk0cfZkg5AB/9vhoOJyWvGSBbJYD84alZOHvT2ESf+
         So5A==
X-Gm-Message-State: AOAM531V3WyR5sRG/eKg4muRGZpJO4E3vDPEeJvuvj8D3j+SbfsxxYlq
        4aCN44RVQKB3zvRK9ZqVwmEQmi+nDJwRJ9xaasijbQ==
X-Google-Smtp-Source: ABdhPJzN2xX0aRggvFLd3dE0g94qJKPAYD+X6kMd9VeHQ4jcRCc7+JXcF08RI5Aa7paJeeRt509mTwqMU2u1E5AuKCE=
X-Received: by 2002:a05:6830:4a6:: with SMTP id l6mr4077023otd.72.1621519751301;
 Thu, 20 May 2021 07:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210520092102.149300807@linuxfoundation.org> <cf63f39b-6323-4c11-8e53-d04532ed0b6a@roeck-us.net>
In-Reply-To: <cf63f39b-6323-4c11-8e53-d04532ed0b6a@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 May 2021 19:38:59 +0530
Message-ID: <CA+G9fYuVKoKnL5FHeHT_r-zwCrNLkgp2O8DJyso0mgOXXTXmAg@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/190] 4.4.269-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 at 17:12, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 5/20/21 2:21 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.269 release.
> > There are 190 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> > Anything received after that time might be too late.
> >
>
> All mips builds still fail.
>
> Building mips:defconfig ... failed
> --------------
> Error log:
> In file included from include/linux/kernel.h:136,
>                   from include/asm-generic/bug.h:13,
>                   from arch/mips/include/asm/bug.h:41,
>                   from include/linux/bug.h:4,
>                   from include/linux/page-flags.h:9,
>                   from kernel/bounds.c:9:
> arch/mips/include/asm/div64.h:59:30: error: expected identifier or '(' before '{' token
>     59 | #define __div64_32(n, base) ({      \
>        |                              ^
> include/asm-generic/div64.h:35:17: note: in expansion of macro '__div64_32'
>     35 | extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
>        |                 ^~~~~~~~~~
>
> It looks like the changes conflict with the code in include/asm-generic/div64.h.
> That code is completely different in later kernel versions.

LKFT build system also found these MIPS builds failed.

- Naresh
