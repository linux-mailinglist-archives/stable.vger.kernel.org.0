Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C99132E599
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhCEKCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhCEKC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 05:02:27 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EF8C061756
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 02:02:27 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id r17so2235595ejy.13
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 02:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4+jzqKGagATPjg/VwwcWdsrDJERQg03vPdEG5QDDx6Y=;
        b=YNz/PEtm5Ver0vYi7v+xl8TmT0Bq3Heywo9loY0n8mJjOyld490V6BGc3tIo1mNSCr
         OQp7OA5IoZO1kr6yWzLtHJJv0vGvrtJoF1tJAQh7GkZl0eIEK/1r1+Y9HuX+sUGN031E
         FoQszYMuIp1vzcavHiTuI7XBrIdVD7FE8fg4Hk4hSHKP33jXeqn4ovK2aY97fyr68weJ
         bm5+uVh3RvlUXnJXKWxW8y5Nj89Yr8ZN8kwwgpCESzBkkKfRkrta3dbqHvuHUcoHwbsY
         C4rsGyhWe5NLP1pzAYcaFYhpf8jhtcKViaEctgOStLNT3GTqlXFHkuKtJYJ0XO77GMGL
         K+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4+jzqKGagATPjg/VwwcWdsrDJERQg03vPdEG5QDDx6Y=;
        b=gAMmAGdR/dl+Keawrz07b08SCHz32U9qUpIzpob1SbHsmcaEKCzwMlk+6u1UlT9UaW
         zC9b8j/1iZUmKd3UkkepV2Rihj4pJNrgrkYKgtUZwrQz3v1oN4xoL56LDxOsaxsoY1YH
         KkV1vCAXPVZOapIhIR+vBdrv3bkMJdELwoOE/YttszFOCqkRyXlyLsFXrcNsJDYJI3/O
         IeAMz+eoeiqHZlaI0B6TqYaLDHTnNE7W0AA1YLCZCfxd7jvIC2bxxPA/jRsM7pwFETBO
         IoZvkXYaJRW59l1FJhgNf5g10cgi695LEed04gKzKtuGP88/VZpXposHUZwDZfO4po9U
         a6NA==
X-Gm-Message-State: AOAM533wuBgBVNjyP88UeUVm/r/HAo1ISLEe3iRQERc4B9spY+ctEo5i
        5DK8SbbTnKTCLYbsU7MJFraCBF0QZCTr2jJkcDpnqw==
X-Google-Smtp-Source: ABdhPJxz89IE+aAgCF0gMQEoezCLzDvhGBdk15aI7RofQpNcrzsBXMp6cp2s/wF2+k/F3NscWxzuO0v03KoowOttML4=
X-Received: by 2002:a17:906:d8ca:: with SMTP id re10mr1587977ejb.18.1614938545934;
 Fri, 05 Mar 2021 02:02:25 -0800 (PST)
MIME-Version: 1.0
References: <20210302192700.399054668@linuxfoundation.org> <CA+G9fYsA7U7rzd=yGYQ=uWViY3_dXc4iY_pC-DM1K3R+gac19g@mail.gmail.com>
 <175fac9c-ac3f-bd82-9e5d-2c2970cfc519@roeck-us.net> <CA+G9fYtkrAs=ASaVVu6-Lnck8A6Pt_LGODxnpTYouvppbw_rbQ@mail.gmail.com>
 <CAHk-=wgxLTur2G5mvYKCXE4DkUo90T2Dy3X526sqJgOCm0gzNA@mail.gmail.com>
 <CA+G9fYsUJvLbaqOFkxYZJxZkgay92vxjjoD69C0+tS5kthZmoQ@mail.gmail.com> <YEHxNECRwr4Z4ka2@kroah.com>
In-Reply-To: <YEHxNECRwr4Z4ka2@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 5 Mar 2021 15:32:14 +0530
Message-ID: <CA+G9fYv5+T4Z1-7QqyyUht5U8vOQyaQr3O+wOq5TLxS4E9Uu_g@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 5 Mar 2021 at 14:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Mar 05, 2021 at 01:39:46PM +0530, Naresh Kamboju wrote:
> > On Fri, 5 Mar 2021 at 02:45, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > On Thu, Mar 4, 2021 at 9:56 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > >
> > > > On Thu, 4 Mar 2021 at 01:34, Guenter Roeck <linux@roeck-us.net> wrote:
> > > > >
> > > > > Upstream has:
> > > > >
> > > > > e71a8d5cf4b4 tty: fix up iterate_tty_read() EOVERFLOW handling
> > > > > ddc5fda74561 tty: fix up hung_up_tty_read() conversion
> > > >
> > > > I have applied these two patches and the reported problem did not solve.
> > >
> > > Hmm. Upstream has:
> > >
> > > *  3342ff2698e9 ("tty: protect tty_write from odd low-level tty disciplines")
> > > *  a9cbbb80e3e7 ("tty: avoid using vfs_iocb_iter_write() for
> > > redirected console writes")
> > > *  17749851eb9c ("tty: fix up hung_up_tty_write() conversion")
> > > G  e71a8d5cf4b4 ("tty: fix up iterate_tty_read() EOVERFLOW handling")
> > > G  ddc5fda74561 ("tty: fix up hung_up_tty_read() conversion")
> > >  * c7135bbe5af2 ("tty: fix up hung_up_tty_write() conversion")
> > >   d7fe75cbc23c ("tty: teach the n_tty ICANON case about the new
> > > "cookie continuations" too")
> > >   15ea8ae8e03f ("tty: teach n_tty line discipline about the new
> > > "cookie continuations"")
> > >   64a69892afad ("tty: clean up legacy leftovers from n_tty line discipline")
> > > *  9bb48c82aced ("tty: implement write_iter")
> > > *  dd78b0c483e3 ("tty: implement read_iter")
> > > *  3b830a9c34d5 ("tty: convert tty_ldisc_ops 'read()' function to take
> > > a kernel pointer")
> > >
> > > Where those ones marked with '*' seem to be in v5.10.y, and the one
> > > prefixed with 'G' are the ones Guenter mentioned.
> > >
> > > (We seem to have the "tty: fix up hung_up_tty_write() conversion"
> > > commit twice. I'm not sure how that happened, but whatever).
>
> I merged it through two different branches by applying it from email,
> one for 5.10-final and one for 5.11-rc1, sorry about that.
>
> > > But that still leaves three commits that don't seem to be in 5.10.y:
> > >
> > >   d7fe75cbc23c ("tty: teach the n_tty ICANON case about the new
> > > "cookie continuations" too")
> > >   15ea8ae8e03f ("tty: teach n_tty line discipline about the new
> > > "cookie continuations"")
> > >   64a69892afad ("tty: clean up legacy leftovers from n_tty line discipline")
> > >
> > > and they might fix what are otherwise short reads. Which is allowed by
> > > POSIX, afaik, but ..
> > >
> > > Do those three commits fix your test-case?
> >
> > Yes.
> > As per your suggestion I've added these three patches and tested
> > and the reported test case PASS now [1].
> >
> > This means I have five extra patches on top of the stable v5.10.20 tag.
> >
> > $ git log --oneline
> > 8c1c1de499af tty: teach the n_tty ICANON case about the new "cookie
> > continuations" too
> > 02aada164879 tty: teach n_tty line discipline about the new "cookie
> > continuations"
> > fb0df6b17897 tty: clean up legacy leftovers from n_tty line discipline
> > 429f7fc84d6a tty: fix up iterate_tty_read() EOVERFLOW handling
> > d0d54bca80a8 tty: fix up hung_up_tty_read() conversion
> > 83be32b6c9e5 (tag: v5.10.20, origin/linux-5.10.y) Linux 5.10.20
>
> That last commit, "tty: fix up hung_up_tty_read() conversion" is already
> in 5.10.20 as e018e57fd5c0 ("tty: fix up hung_up_tty_write()
> conversion"), it came in at 5.10.11, so how did you apply it again?

It is easy to confuse between read() and write().
tty: fix up hung_up_tty_read() conversion
tty: fix up hung_up_tty_write() conversion

Write() was there but read() is a commit that has been cherry-picked.

> Anyway, thanks for these, I've queued up the 4 other commits now to the
> 5.10.y and 5.11.y trees, let's see what happens...

Thank you !

- Naresh
