Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FCC23CFE6
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgHET0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728384AbgHET0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 15:26:30 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C4AC06174A
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 12:26:29 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id j7so24252291oij.9
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 12:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r9p1250UjzzVY01/1Vj9Qr0UbfbQH5yUpRo8ZxWHA8Y=;
        b=QpAeZz4ZcD3ILEIVu1SjzSNPjeiCdcwiT3e+D1LCoTOp0piHaCyb0xtpHwZkV3Xu/L
         mRuUkva02Hndsc+r6kMiGL91YtTmqh5ePG1dy3SiUpUERbp8eHDXAm6pLqfcRtPXvL75
         3HAW9FY0D8QzTI4wbv4wK67+YcFE3wq8k2hEJ0onqfGCj3iinkKt+x7JAPg1rKIp8bFq
         pcGAiJ3vUf1X+eIjB98q5xYR+mP3ykzwngmbTLtx5Vxe5DEBvrJwTcOPLh3g975lXXla
         QoFlpAWwjdTY18smAdBgtZmcLtjn8YLcJ9iK3tDTDhoW2cG5jzp/L+AZh0cZ/MugDR7L
         znxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r9p1250UjzzVY01/1Vj9Qr0UbfbQH5yUpRo8ZxWHA8Y=;
        b=nHBMOinLS/Png7dGU5xppvZLEnOHR5u/T3JGOgfhkRMwSrs7hogvaDn0nTNvdRU3ju
         7c9uL5BM/U4ZwONGvmikiPxvb71rYMqkX9k79nnUsENFrDGasuLzr/3DFGMwvz25iZgo
         k0TAnr00uWDU7SzuTa6LtB2Jabk7/Xb3E39X3arjuuR0Q4Cse+ohcnmvvvxhiyOAQlI3
         oWfTu9+F/W46T2FLSJ0C7ls0+kUMQFvo44wWHdoLpmumxarRju6W5vIUtEijQoPdq0RB
         Hw3xbKV3lhV8Boc2dRzHaAHQGgBHnT975Um+zzowaob/bWlpq7k/ntRaQ+5115/YqWdd
         ifLA==
X-Gm-Message-State: AOAM533V0jGK9/T/oFc8RY5rJM0WR1F9YgZrP/xyvgCdwPwx8B+DF8xF
        N1VrzUGUJFrT0PyZ8r3ZYYyAvvg46b8tvEefAwIj7w==
X-Google-Smtp-Source: ABdhPJwQolivwzQqwYsBl8BkZIC8nT+MZuLOcgYHMkZ7hjp3wCdDDEAhpCkdYwFFvpke05AvqNAwhcvRkmltYtDXbRY=
X-Received: by 2002:aca:d595:: with SMTP id m143mr3883997oig.11.1596655589299;
 Wed, 05 Aug 2020 12:26:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200805153506.978105994@linuxfoundation.org> <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
 <71a132bf-5ddb-a97a-9b65-6767fd806ee9@roeck-us.net> <CAHk-=wi0WGMs6+Jz6rXbQO4mfzf8LGVc3TwmCdz0OwRtj7GgMQ@mail.gmail.com>
In-Reply-To: <CAHk-=wi0WGMs6+Jz6rXbQO4mfzf8LGVc3TwmCdz0OwRtj7GgMQ@mail.gmail.com>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Wed, 5 Aug 2020 14:26:17 -0500
Message-ID: <CAEUSe78hB1-FtRVagj_pVFAbrAgXdzHas5ub7Rf-Qf8O+_0NWA@mail.gmail.com>
Subject: Re: [PATCH 5.7 0/6] 5.7.14-rc1 review
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Wed, 5 Aug 2020 at 13:37, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Aug 5, 2020 at 11:24 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > Same with older versions of gcc. I don't see the problem with the
> > mainline kernel.
>
>   https://www.youtube.com/watch?v=3D-b5aW08ivHU
>
> > I think this is caused by more recursive includes.
> > arch/arm64/include/asm/archrandom.h includes include/linux/random.h
> > which includes arch/arm64/include/asm/archrandom.h to get the definitio=
n
> > of arch_get_random_seed_long_early (which it won't get because of
> > the recursion).
> >
> > What I don't really understand is how this works with new versions
> > of gcc.
>
> Is that the only place it triggers?

Yes

> Because the trivial fix would be something like the appended, which is
> the right thing to do anyway.
>
>               Linus
>
> diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
> index 07c4c8cc4a67..9ded4237e1c1 100644
> --- a/arch/arm64/kernel/kaslr.c
> +++ b/arch/arm64/kernel/kaslr.c
> @@ -11,8 +11,8 @@
>  #include <linux/sched.h>
>  #include <linux/types.h>
>  #include <linux/pgtable.h>
> +#include <linux/random.h>
>
> -#include <asm/archrandom.h>
>  #include <asm/cacheflush.h>
>  #include <asm/fixmap.h>
>  #include <asm/kernel-pgtable.h>

Tested-by: Daniel D=C3=ADaz <daniel.diaz@linaro.org>

This patch works fine. Built with gcc 7.3.0 and glibc 2.27.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
