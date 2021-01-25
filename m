Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAA4302964
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 18:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbhAYR4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 12:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731108AbhAYRz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 12:55:26 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDB4C061A29
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 09:45:41 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id 31so8082426plb.10
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 09:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dsuPhefQgichTP7XKQR2dbMq1C95W4+Nrc5ixBeFe88=;
        b=n371yiXKR4rpFvO3dlu3vZ6fj41f1XusH9YqyJsGTZ3ivKkrPp7K2YiP3M4y1HotOi
         Yvb2zCtjrt84f/npurbsGhraWCqbKcmWfJ9c5FSlAGy7fl7qzgOHESJDkuYHh5hWy1Xs
         fpDEj6cWYHPlJyijsv+zFQYl89saZoLcUP8ySH5DzRZXJGnHOIFk91IRbJXYa2hC2XI/
         VDcFibLi1BszsrRjjDjp1d3VswVCrX8wtfYIGQu1uXchIlVzWQbiRpUmqHAOIcO9ljpS
         SCyUg/988+fi7bu7lTusz8/d89mLl434jjT14M1RUtW9bMetZJJTFRkmibRp5VF+bn3m
         Nylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dsuPhefQgichTP7XKQR2dbMq1C95W4+Nrc5ixBeFe88=;
        b=aGSB6ws+fZGF3yuCWawb9q5lBTVoNWRvhI8NX61IikoIQSqjEz99tZWYNJvnIVlOxe
         DwMFjuxDoApkFVAXQetbuy1yVzSAXsMbIyNf4byCjEN2xRuycJD3CxwPGWMBIHE4slIW
         pRaBWL7VKTD5X1Dl6LBlw9iV/JSlZexSNPClGzFCW57id3MmZJUt7y0gn4Bkx6tDV9x+
         qWRi2IROVaZGIyTLUO/PowdFbWHPUX1d1CtWf+ZeFKtZtX02hb1dlInVZCIuZvxR11qn
         Y7Hxx35r8NMSufVnh49J4Kfehh5Jdf2L0RnxE6dYRvux45vISyK+icyYAJOvWnl9XRHK
         jB3A==
X-Gm-Message-State: AOAM530ONpKmvVATZ1KkpZOznXE5/B8XjMyy6OqRjb0bR9vz3WyuGV+l
        rJ6eQrKgcsZqZUXUZUC1ohkJTUoWEYkhP7oDPaA7IQ==
X-Google-Smtp-Source: ABdhPJwF0/eChIPL6NG4kkphRa701CHL8KDBNEVztnfayL6Xiabbojvgo5qaXEaSDXWydeq5bneoSsvfKr2owwxCQYo=
X-Received: by 2002:a17:902:ed94:b029:de:8844:a650 with SMTP id
 e20-20020a170902ed94b02900de8844a650mr1591452plj.56.1611596740552; Mon, 25
 Jan 2021 09:45:40 -0800 (PST)
MIME-Version: 1.0
References: <20210125132425.28245-1-will@kernel.org> <YA7WztCb4OGA6m4S@kroah.com>
In-Reply-To: <YA7WztCb4OGA6m4S@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 25 Jan 2021 09:45:30 -0800
Message-ID: <CAKwvOdkjWuH5MJz-H7T95B8rOAcoBWGXi1RsKT-YXYr1-K6A5g@mail.gmail.com>
Subject: Re: [STABLE BACKPORT v2 4.4.y, 4.9.y and 4.14.y] compiler.h: Raise
 minimum version of GCC to 5.1 for arm64
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Will Deacon <will@kernel.org>, "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Florian Weimer <fweimer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 6:34 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jan 25, 2021 at 01:24:25PM +0000, Will Deacon wrote:
> > commit dca5244d2f5b94f1809f0c02a549edf41ccd5493 upstream.
> >
> > GCC versions >= 4.9 and < 5.1 have been shown to emit memory references
> > beyond the stack pointer, resulting in memory corruption if an interrupt
> > is taken after the stack pointer has been adjusted but before the
> > reference has been executed. This leads to subtle, infrequent data
> > corruption such as the EXT4 problems reported by Russell King at the
> > link below.
> >
> > Life is too short for buggy compilers, so raise the minimum GCC version
> > required by arm64 to 5.1.
> >
> > Reported-by: Russell King <linux@armlinux.org.uk>
> > Suggested-by: Arnd Bergmann <arnd@kernel.org>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: <stable@vger.kernel.org> # 4.4.y, 4.9.y and 4.14.y only
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Cc: Florian Weimer <fweimer@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Nathan Chancellor <natechancellor@gmail.com>
> > Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Link: https://lore.kernel.org/r/20210105154726.GD1551@shell.armlinux.org.uk
> > Link: https://lore.kernel.org/r/20210112224832.10980-1-will@kernel.org
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > [will: backport to 4.4.y/4.9.y/4.14.y; add __clang__ check]

LGTM

> > Link: https://lore.kernel.org/r/CA+G9fYuzE9WMSB7uGjV4gTzK510SHEdJb_UXQCzsQ5MqA=h9SA@mail.gmail.com
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  include/linux/compiler-gcc.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
>
> Thanks, now queued up, let's try this again :)
>
> greg k-h



-- 
Thanks,
~Nick Desaulniers
