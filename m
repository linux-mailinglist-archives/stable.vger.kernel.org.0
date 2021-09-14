Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7935640B794
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 21:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhINTMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 15:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhINTMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 15:12:01 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE73C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:10:43 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bq5so575799lfb.9
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YnOOs7cOY2aRKSHGTS9b6X5LZVhhuvMpnEJwtROL6Vg=;
        b=CmSn/OlpRAybXvo2UeErWrXzNG9m2iILp0YBMxECF85BY3IxHhiu4pzslIp+7b+0Be
         Bm0WWmlfJ3SG175Dw9XqJEm940Iu18WhmTkuSpTzzvLmiWoNnEFhA14ZFY2bg/B76lYT
         uCYW9+o/eDGt9dIpbA5ZdRCGMeDcfh3cYHSC2dUOO3JKIDP+7ZyFOx1lqsAnpjg64F0p
         Zprz17+VF3OyS6UZXd9xZrfXpJrPNC5BmvjrDLDdvtrJJDiwLv7nBtXHCRQuwgbOe2f7
         sC6Yw5XE0Fubwb4lWCCn00wg5b/97LengfgAP7dwKvftDU1W4FliR/y9/sb2q+ucM2En
         RWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YnOOs7cOY2aRKSHGTS9b6X5LZVhhuvMpnEJwtROL6Vg=;
        b=FgW/OUm5k1Q0GYlvMfeqK0s0CCNyk4YuBxfGuZIs9G4y1oKneK+AoWHKvSwUDuF3/g
         CFE2z8hsNjrwQMjG6Ssn21oVLWpp12YtbJJZ5aIzDThUv48iaAVYAYVdQ9PDc3XlgwJX
         vLrSiRzq9S03oTMtsJ9nuj3fYB0mXatrJkl/Q+AqsH4mpGuVpfKqUfyy38i1atyU3dLh
         X+u9PZt3Aqts8LKRfuVYzcMshO3nfg9t83XE85G0ytBVvG0gG5eTR4MMduE+zwErVb/y
         J4q3IqpIsIcJtpNm5X99gguhl8NWSYKMshzNmamGTDuSu1zxGCphFRaoy0pKmNIRdyNj
         mCvQ==
X-Gm-Message-State: AOAM532tWhV8IleeP+LLmTcdK5nbGE4QYJ5vEMfov9ZSUn4dgufLhn4u
        rIzfSWUuGm//PBhRfAuxWA2BRXBYOuJjScSLqY7j6w==
X-Google-Smtp-Source: ABdhPJw/+zEgpPOLgQMTdXmaDecwRkVFlAfV9dDhd+GqZB/UdQZhqL81/BhGLj2Cq9GXf8kWBJm7Pqb3KORMxQSljvw=
X-Received: by 2002:a05:6512:3b9e:: with SMTP id g30mr13975294lfv.651.1631646642092;
 Tue, 14 Sep 2021 12:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
 <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
 <CAKwvOdkOHxtsRGjZ2Y8x84sBaqWy8t-U3F9UbMiR7h=3_+mtqA@mail.gmail.com>
 <CAHk-=wjUR7FwE5LsZNaoQxrKu2TS7T-=1j8XqZK2miQuEmqf3Q@mail.gmail.com> <CAHk-=wgPupayk3GpwSMtkV5_onFzmmK2g3WmBV1EbSCj+D0eqw@mail.gmail.com>
In-Reply-To: <CAHk-=wgPupayk3GpwSMtkV5_onFzmmK2g3WmBV1EbSCj+D0eqw@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 14 Sep 2021 12:10:30 -0700
Message-ID: <CAKwvOdkab9O5q=DNn643+7HRgTDdD1i201Qi_cSuXYbJbXf1qw@mail.gmail.com>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 11:56 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Sep 14, 2021 at 11:48 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > There was never anything "loff_t" about bitmask at any point.
>
> Not 'bitmask'. It's 'blksize'. Hopefully that was obvious in context.

Isn't the parameter `blksize` of `nbd_set_size` declared as `loff_t`?
-- 
Thanks,
~Nick Desaulniers
