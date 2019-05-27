Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8012B7BC
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 16:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfE0Ojb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 10:39:31 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:44098 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfE0Oja (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 10:39:30 -0400
Received: by mail-io1-f47.google.com with SMTP id f22so13358077iol.11
        for <stable@vger.kernel.org>; Mon, 27 May 2019 07:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MLU35/uYR1nRgVrgDHc2qgXPOvCskzze0d2KFj4zXps=;
        b=c+BSZa2dmDN+uRW06TqwRy0VSL5yJC1MSmSGJE1963vI8tOugJ3+8Dkvf8KiRYDKHd
         dgCP7piZxptHkxhXQDm6nY5Mb0aGP6VcT8AOEOu/Kb5Fp7DjYrINF+aQwI9bFXbWWSYR
         yknLVAbVC7jy0bJZCsqSaEGwfcEm12dKzquQRioRcbkjQa+NAb9FM7OhszKG0vjWFFHT
         JHgU2yjQLDtYpecRacACpuYy4MR2i3YXxcRO9Lwk997ZdseT9aZ2hyz03XtucsX1M9QA
         cnO0QUEqQIkhpdnpeCakgRl45rQji/hAB65lPkGt2yBqqfxlH0XkQwIK6ADDWQI0fKFT
         Qn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MLU35/uYR1nRgVrgDHc2qgXPOvCskzze0d2KFj4zXps=;
        b=NRlBgtgBE4cT1CCrX4GXOe8eAtkGKDFapcprr6neGSUH1I5eY8CEVUxg2e7YKHY9+8
         1qlv/BomrrSBAKcj2kkmHmhLKLAoEjwhQx630/QxdyI+7Dvpdhp6krT8XExnkAmEie0P
         uzxc8rQANXw0tpjxQWgq4VlDMFSHAdkuOfqXsVe3Dhl4pvMpDvGb/+dB5obPLhnMeXn/
         iIkYL5WGmYzyQTvfFWL/n237490ZJ9oCr+lm0FPxbGwj1EXht9sljbo4mUYaaBKQMnxy
         hDmC/NPx2Phrk1vbI45uqGyY4OsLEB+GEOuGSdyyGYREHfSH92sXk7VHkLrgB6Mr2Djz
         BCFA==
X-Gm-Message-State: APjAAAU0QVfMYTfhcQDyGj9IkVJDpHULY1fYqyLx+T5JIyfePlUnlQ2y
        Z7B+w3VoUzh6vl7ybE+V3k39GWJc9rv9hKJQrmUlig==
X-Google-Smtp-Source: APXvYqwemw05bcQK1kMgE9bPYQbP9s3P2o/ztWMC7gY4oU0XJB6MRIVbuL0EpR+Agdh8qmQVo78SdGclPOg+d4TOwKg=
X-Received: by 2002:a6b:e711:: with SMTP id b17mr6150062ioh.3.1558967969074;
 Mon, 27 May 2019 07:39:29 -0700 (PDT)
MIME-Version: 1.0
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com>
 <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
 <ECADFF3FD767C149AD96A924E7EA6EAF9772760D@USCULXMSG01.am.sony.com> <1442701383.22077553.1558957933273.JavaMail.zimbra@redhat.com>
In-Reply-To: <1442701383.22077553.1558957933273.JavaMail.zimbra@redhat.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 27 May 2019 16:39:16 +0200
Message-ID: <CACT4Y+bDmqkCezoE7gJ9sP6q7wF1Ff2iRYzdODKa5g3uSfnQHg@mail.gmail.com>
Subject: Re: CKI hackfest @Plumbers invite
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Tim Bird <Tim.Bird@sony.com>, automated-testing@yoctoproject.org,
        info@kernelci.org, syzkaller <syzkaller@googlegroups.com>,
        lkp@lists.01.org, stable <stable@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Eliska Slobodova <eslobodo@redhat.com>, cki-project@redhat.com,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 27, 2019 at 1:52 PM Veronika Kabatova <vkabatov@redhat.com> wrote:
> ----- Original Message -----
> > From: "Tim Bird" <Tim.Bird@sony.com>
> > To: vkabatov@redhat.com, automated-testing@yoctoproject.org, info@kernelci.org, khilamn@baylibre.org,
> > syzkaller@googlegroups.com, lkp@lists.01.org, stable@vger.kernel.org, labbott@redhat.com
> > Cc: eslobodo@redhat.com, cki-project@redhat.com
> > Sent: Friday, May 24, 2019 10:17:04 PM
> > Subject: RE: CKI hackfest @Plumbers invite
> >
> >
> >
> > > -----Original Message-----
> > > From: Veronika Kabatova
> > >
> > > Hi,
> > >
> > > as some of you have heard, CKI Project is planning hackfest CI meetings
> > > after
> > > Plumbers conference this year (Sept. 12-13). We would like to invite
> > > everyone
> > > who has interest in CI for kernel to come and join us.
> > >
> > > The early agenda with summary is at the end of the email. If you think
> > > there's
> > > something important missing let us know! Also let us know in case you'd
> > > want to
> > > lead any of the sessions, we'd be happy to delegate out some work :)
> > >
> > >
> > > Please send us an email as soon as you decide to come and feel free to
> > > invite
> > > other people who should be present. We are not planning to cap the
> > > attendance
> > > right now but need to solve the logistics based on the interest. The event
> > > is
> > > free to attend, no additional registration except letting us know is
> > > needed.
> > >
> > > Feel free to contact us if you have any questions,
> >
> > I plan to come to the event.
> >
> > > -----------------------------------------------------------
> > > Here is an early agenda we put together:
> > > - Introductions
> > > - Common place for upstream results, result publishing in general
> > >   - The discussion on the mailing list is going strong so we might be able
> > >   to
> > >     substitute this session for a different one in case everything is
> > >     solved by
> > >     September.
> > > - Test result interpretation and bug detection
> > >   - How to autodetect infrastructure failures, regressions/new bugs and
> > >   test
> > >     bugs? How to handle continuous failures due to known bugs in both tests
> > > and
> > >     kernel? What's your solution? Can people always trust the results they
> > >     receive?
> > > - Getting results to developers/maintainers
> > >   - Aimed at kernel developers and maintainers, share your feedback and
> > >     expectations.
> > >   - How much data should be sent in the initial communication vs. a click
> > >   away
> > >     in a dashboard? Do you want incremental emails with new results as they
> > > come
> > >     in?
> > >   - What about adding checks to tested patches in Patchwork when patch
> > > series
> > >     are being tested?
> > >   - Providing enough data/script to reproduce the failure. What if special
> > >   HW
> > >     is needed?
> > > - Onboarding new kernel trees to test
> > >   - Aimed at kernel developers and maintainers.
> > >   - Which trees are most prone to bring in new problems? Which are the most
> > >     critical ones? Do you want them to be tested? Which tests do you feel
> > >     are
> > >     most beneficial for specific trees or in general?
> > > - Security when testing untrusted patches
> > >   - How do we merge, compile, and test patches that have untrusted code in
> > > them
> > >     and have not yet been reviewed? How do we avoid abuse of systems,
> > >     information theft, or other damage?
> > >   - Check out the original patch that sparked the discussion at
> > >     https://patchwork.ozlabs.org/patch/862123/
> > > - Avoiding effort duplication
> > >   - Food for thought by GregKH
> > >   - X different CI systems running ${TEST} on latest stable kernel on
> > >   x86_64
> > >     might look useless on the first look but is it? AMD/Intel CPUs,
> > >     different
> > >     network cards, different graphic drivers, compilers, kernel
> > >     configuration...
> > >     How do we distribute the workload to avoid doing the same thing all
> > >     over
> > >     again while still running in enough different environments to get the
> > >     most
> > >     coverage?


Hi Veronika,

All are great questions that we need to resolve!

I am also very much concerned about duplication in 2 other dimensions
with the current approach to kernel testing:

1. If X different CI systems running ${TEST}, developers receive X
reports about the same breakage from X different directions, in
different formats, of different quality, at slightly different times
and somebody needs to act on all of them in some way. The more CI
systems we have, the more run meaningful number of tests and do
automatic reporting, the more and more duplicates developers get.

2. Effort duplication between implementation of different CI systems.
Doing a proper and really good CI is very hard. This includes all
questions that you mentioned here, and fine tuning of all of that,
refining reporting, bisection, onboarding of different test suites,
onboarding of different dynamic/static analysis tools and much more.
Last but not least is duplication of processes related to these CIs.
Speaking of my experience with syzbot, this is extremely hard and
takes years. And we really can't expose a developer to 27 different
systems and slightly different processes (this would mean they follow
0 of these processes).
This is further complicated by the fact that kernel tests are
fragmented, so it's not possible to, say, simply run all kernel tests.
And kernel processes are fragmented, e.g. you mentioned patchwork, but
not all subsystems use patchwork, so it's not possible to simply
extend a CI to all subsystems. And some aspects of the current kernel
development process notoriously complicate automation of things that
really should be trivial. For example, if you have
github/gitlab/gerrit, you can hook into arrival of each new change and
pull exact code state. Done. For kernel some changes appear on
patchwork, some don't, some are duplicated on multiple patchworks,
some duplicated in a weird way on the same patchwork, some non-patches
appear on patchwork because it's confused, and last but not least you
can't really apply any of them because none of them include base
tree/commit info. Handling just this requires lots of effort, guessing
on coffee grounds and heuristics that need to be refined over time.
The total complexity of doing it just once, with all resources
combined and dev process re-shaped to cooperate is close to off-scale.

Do you see these points as a problem too? Or am I exaggerating matters?






> > > - Common hardware pools
> > >   - Is this something people are interested in? Would be helpful especially
> > >   for
> > >     HW that's hard to access, eg. ppc64le or s390x systems. Companies could
> > > also
> > >     sing up to share their HW for testing to ensure kernel works with their
> > >     products.
> >
> > I have strong opinions on some of these, but maybe only useful experience
> > in a few areas.  Fuego has 2 separate notions, which we call "skiplists"
> > and "pass criteria", which have to do with this bullet:
> >
> > - How to autodetect infrastructure failures, regressions/new bugs and test
> >      bugs? How to handle continuous failures due to known bugs in both
> >      tests and kernel? What's your solution? Can people always trust the
> >      results they
> >      receive?
> >
> > I'd be happy to discuss this, if it's desired.
> >
> > Otherwise, I've recently been working on standards for "test definition",
> > which defines the data and meta-data associated with a test.   I could talk
> > about where I'm at with that, if people are interested.
> >
>
> Sounds great! I added both your points to the agenda as I do think they have
> a place here. The list of items is growing so I hope we can still fit
> everything into the two days we planned :)
>
>
> See you there!
> Veronika
>
> > Let me know what you think.
> >  -- Tim
