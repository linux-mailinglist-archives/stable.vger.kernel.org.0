Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C89B23CCB2
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 18:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgHEQ6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 12:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgHEQ4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:56:47 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807DBC06174A
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 09:51:32 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 140so24622754lfi.5
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 09:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yKgJ87tlQurrZfrQYEXodAO8OzBfJ9TRYjwrwCi61/U=;
        b=Olb3V+ArUyt0OGqFt/v2uUo/5e1lC5R9fiJfpnbkZ/1hkrUJuQ9U+awiv/FWz0zxRU
         QLt5Xjiyk5jNC0IE5H2855C1ZLlcXbu4to/gW3c03vbsYmHn9d8pcxIdlUAc4Km2VHWa
         fGVwwxbiecbT2soul1jwPZgwNIkYwmYIK46Mo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yKgJ87tlQurrZfrQYEXodAO8OzBfJ9TRYjwrwCi61/U=;
        b=nbYZYggKPGpF8lUBjaQDmxI2wr4puVDmUkjX9/hniT7QgqoRt97kRacno9GEKxMDRD
         OrdRfdcUdBrQ2XiNZ0piKSgPQhwNO2PpQTb5W35gV3xw5D1TjGSurdx5HKOQ4Fc6AYlT
         nVjgb7FdMDnLHXzDfOxWQtxl9TTSMasHvlWj6qMqJF+jKCTz6KsWeSe4xCyShu+4NvSy
         N/AQ4fm0K9X5xrc9tKK/f/QmnrhMjoZWJ5Tt5hHj/cI6eoUL+3oc5wxq+xrHqDOVXEc2
         4TbvKUjY9W/HLXb2ib7NC1QihUJ39TGga/F56OnM7jwg6eyUcNrmwWfNjVhjoOa5SMe0
         5VhQ==
X-Gm-Message-State: AOAM5331XDX0x7Lam9AoNFP8dUs4Br5yKOa/Zf6h16HVJ+2T6AvZEhz5
        TVN2fgp3NI++EQ2TugOD2BRaXFrEM9g=
X-Google-Smtp-Source: ABdhPJyVZa8jP9oJXJz1w1kgzwoLS2ZBMbGu9BB+czVf402Xz4rQzs9frXL9E6TWSDMhXcmRq2Ln3g==
X-Received: by 2002:a19:70c:: with SMTP id 12mr2005439lfh.207.1596646289244;
        Wed, 05 Aug 2020 09:51:29 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id d22sm1338027lfs.26.2020.08.05.09.51.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 09:51:27 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id g6so35839169ljn.11
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 09:51:27 -0700 (PDT)
X-Received: by 2002:a2e:9a11:: with SMTP id o17mr1821083lji.314.1596646286874;
 Wed, 05 Aug 2020 09:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200804072435.385370289@linuxfoundation.org> <CA+G9fYs35Eiq1QFM0MOj6Y7gC=YKaiknCPgcJpJ5NMW4Y7qnYQ@mail.gmail.com>
 <20200804082130.GA1768075@kroah.com> <CAHk-=whJ=shbf-guMGZkGvxh9fVmbrvUuiWO48+PDFG7J9A9qw@mail.gmail.com>
 <c32ad2216ca3dd83d6d3d740512db9de@kernel.org> <20200805095439.GB1634853@kroah.com>
 <813c64c8dbe037b9d84763f56c4dbb7d@kernel.org>
In-Reply-To: <813c64c8dbe037b9d84763f56c4dbb7d@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 5 Aug 2020 09:51:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiUEonP7tyAfYv=dja4i3b1oBtHL=KY=j8x55x3AFoZZw@mail.gmail.com>
Message-ID: <CAHk-=wiUEonP7tyAfYv=dja4i3b1oBtHL=KY=j8x55x3AFoZZw@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/121] 5.7.13-rc2 review
To:     Marc Zyngier <maz@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 5, 2020 at 4:20 AM Marc Zyngier <maz@kernel.org> wrote:
>
> I came up with yet another "quality" hack, which gets the job done,
> see below. It is obviously much simpler, but also terribly ugly.

This is effectively what the approach of commit c0842fbc1b18
("random32: move the pseudo-random 32-bit definitions to prandom.h")
was too. It has the prandom include in the middle of random.h - which
makes sense in the context of that patch (because it's where all the
prandom stuff used to live there), but the real secret is that as it
does that, it basically moves the percpu.h include down there too.

This mess has caused me to seriously look at making sparse generate a
"defined here, used here" list, and do a topo-sort on it all, and warn
about unused includes but also about stupidities like this.

But I won't have time to do that until after the merge window, and it
may turn out nastier than expected. But I did add all the include
chaining information to the sparse position logic recently in a fairly
easy to digest form, so my gut feel is that something that doesn't try
to actually optimize or solve the problem - just point out the obvious
errors - might be more reasonably doable than doing something that is
theoretically the RightThing(tm) to do.

IOW, a tool only to help find and figure these things out, rather than
a tool to do all the minimization for you automatically.

We'll see. No promises. And if somebody else beats me to it, I won't complain.

            Linus
