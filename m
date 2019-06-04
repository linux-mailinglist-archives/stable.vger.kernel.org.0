Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409BC34231
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfFDIwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:52:19 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:36223 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfFDIwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:52:18 -0400
Received: by mail-yb1-f196.google.com with SMTP id y2so7677365ybo.3
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 01:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kYLgICQpICK8ri5V63VAT8UFbsdaqsjk1muc8EvHgYY=;
        b=ilKiskFrYKTgs32VHZamybokTiqHyXIzpL0njxCin9wE9vjhwZHazewSyDwnS+OQaV
         B+GMtDyPopG1bi+cZnBAKdUQbSI5/ZIFoJ0o6xXrIvGHoTPqWcUK6GGWD1SKtzW8ObCy
         8mOuuoQ+cSDbOo+uOz9YL0cF0VhwWPMN4T6uGBdq0hWg7xpQh/ja0byXUtfLAMkUa1xH
         +qWsRxvrttZu4SewAAsHwXAjlpbD2sfNDGoNj9ob+YhFTjCmbxy9SDhcB40swn8zoQOs
         0nTUsu0iAPaqn8ObmMgDOJKCTgOFD6j6t9I4tqPbBShyeLaWmmmhjBHA+zJ+PpucUONP
         LPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kYLgICQpICK8ri5V63VAT8UFbsdaqsjk1muc8EvHgYY=;
        b=Nguzzz5/sIzqlpVLNrnY1eMNkLB41i0m5znmhqgzMqwkHYlJvfkn4/O+qePj/GDbIO
         C6zWWU2JIOSShmgiYX7HB5TCsN7hX5vMs29yDr59ErKyC0eOA3eupdjFerbDT5+sgK3c
         wVw25qvEInjXQIguis59WQO24Ov1/mY085y2PjV8H6t0b/pwZ+LreDMjDfhTSSchNN/o
         EHVkBWP/ubZ8grm+pRoP6nhvlNyEfXD044l7lJ3aC/TVjW+9WKzReHScmSjXLd30725k
         1vIMTfZjQREAFhCSrgh9RhBOaPQ6kR+/mZGzHDPB+PgQXKRQCip8bmbLnd5L+qgkMwAd
         /pjg==
X-Gm-Message-State: APjAAAXoVQzEwrgv+EU/HNCUIZRAmC/dojaos2Sw/IkG26zdqSbm7zUv
        UVMnybckOhq7WVAranx9yqoqVX4focqTEDWK1ORg2w==
X-Google-Smtp-Source: APXvYqxbIoz39Y+v7XX1HPnKREcbPUK+AvROEN3sNtxkJ6lM1IlhHyWZpxBxo0lWBHFMYr/9Oi2TarS3PejKpR3MvpU=
X-Received: by 2002:a25:1854:: with SMTP id 81mr14521768yby.152.1559638337875;
 Tue, 04 Jun 2019 01:52:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190603223851.GA162395@google.com> <CAKv+Gu8VioGy1h8n0zKAqj+m_PBZdRU+BmJDH7=D7=iEiKRpgw@mail.gmail.com>
 <20190604074624.GA6840@kroah.com>
In-Reply-To: <20190604074624.GA6840@kroah.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Tue, 4 Jun 2019 01:52:06 -0700
Message-ID: <CABXOdTeLtgjzL_V5rgsLnwZLaiK+MnL1BfOr8XeGXW8+Ws9zQQ@mail.gmail.com>
Subject: Re: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap
 1:1 mapping code")
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Zubin Mithra <zsm@chromium.org>,
        stable <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 4, 2019 at 12:46 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 04, 2019 at 09:38:27AM +0200, Ard Biesheuvel wrote:
> > On Tue, 4 Jun 2019 at 00:38, Zubin Mithra <zsm@chromium.org> wrote:
> > >
> > > Hello,
> > >
> > > CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
> > > * 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")
> > >
> > > Could the patch be applied in order to v4.19.y?
> > >
> > > Tests run:
> > > * Chrome OS tryjob
> > >
> >
> > Unless I am missing something, it seems to me that there is some
> > inflation going on when it comes to CVE number assignments.
> >
> > The code in question only affects systems that are explicitly booted
> > with efi=old_map, and the memory allocation occurs so early during the
> > boot sequence that even if we fail and handle it gracefully, it is
> > highly unlikely that we can get to a point where the system is usable
> > at all.
> >
> > Does Chrome OS boot in EFI mode? Does it use efi=old_map? Is the
> > kernel built with 5 level paging enabled? Did you run it on 5 level
> > paging hardware?
> >
> > Or is this just a tick the box exercise?
> >
> > Also, I am annoyed (does it show? :-))  that nobody mentioned the CVE
> > at any point when the patch was under review (not even privately)
>
> CVEs are almost always asked for _after_ the patch is merged, as the
> average fix-to-CVE request timeframe is -100 days.
>
> Also, for the kernel, CVEs almost mean nothing, so if this really isn't
> an issue, I'll not backport this.
>
> And I really doubt that any chromeos device has 5 level page tables just
> yet :)
>

FWIW, Chrome OS kernels are not only used in Chromebooks nowadays.
They are also used in VM images in systems with hundreds of GB of
memory. At least some of those may well boot in EFI mode. Plus, as
also mentioned, we do not (and will not) double-guess CVEs. If anyone
has an issue with CVE creation, I would suggest to discuss with the
respective bodies, not with us.

Zubin, as mentioned before, please hold back on -stable backport
requests for CVE fixes. Please apply CVE fixes to our branches
directly instead, per the above guidance ("for the kernel, CVEs almost
mean nothing"). I'll revise our policy accordingly. Again, sorry for
the trouble.

Thanks,
Guenter

> thanks,
>
> greg k-h
