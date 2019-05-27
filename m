Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89282B886
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 17:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfE0Pmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 11:42:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfE0Pmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 11:42:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CAEEF307D855;
        Mon, 27 May 2019 15:42:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A6EA35D978;
        Mon, 27 May 2019 15:42:34 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 46C25206D1;
        Mon, 27 May 2019 15:42:34 +0000 (UTC)
Date:   Mon, 27 May 2019 11:42:33 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Tim Bird <Tim.Bird@sony.com>, automated-testing@yoctoproject.org,
        info@kernelci.org, syzkaller <syzkaller@googlegroups.com>,
        lkp@lists.01.org, stable <stable@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Eliska Slobodova <eslobodo@redhat.com>, cki-project@redhat.com,
        David Rientjes <rientjes@google.com>
Message-ID: <1462535054.22098520.1558971753594.JavaMail.zimbra@redhat.com>
In-Reply-To: <CACT4Y+bDmqkCezoE7gJ9sP6q7wF1Ff2iRYzdODKa5g3uSfnQHg@mail.gmail.com>
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com> <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com> <ECADFF3FD767C149AD96A924E7EA6EAF9772760D@USCULXMSG01.am.sony.com> <1442701383.22077553.1558957933273.JavaMail.zimbra@redhat.com> <CACT4Y+bDmqkCezoE7gJ9sP6q7wF1Ff2iRYzdODKa5g3uSfnQHg@mail.gmail.com>
Subject: Re: CKI hackfest @Plumbers invite
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.205.210, 10.4.195.25]
Thread-Topic: CKI hackfest @Plumbers invite
Thread-Index: tLPO6LmFvNusBo0tmpEVsrtCSshXiw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 27 May 2019 15:42:34 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Dmitry Vyukov" <dvyukov@google.com>
> To: "Veronika Kabatova" <vkabatov@redhat.com>
> Cc: "Tim Bird" <Tim.Bird@sony.com>, automated-testing@yoctoproject.org, info@kernelci.org, "syzkaller"
> <syzkaller@googlegroups.com>, lkp@lists.01.org, "stable" <stable@vger.kernel.org>, "Laura Abbott"
> <labbott@redhat.com>, "Eliska Slobodova" <eslobodo@redhat.com>, cki-project@redhat.com, "David Rientjes"
> <rientjes@google.com>
> Sent: Monday, May 27, 2019 4:39:16 PM
> Subject: Re: CKI hackfest @Plumbers invite
> 
> On Mon, May 27, 2019 at 1:52 PM Veronika Kabatova <vkabatov@redhat.com>
> wrote:
> > ----- Original Message -----
> > > From: "Tim Bird" <Tim.Bird@sony.com>
> > > To: vkabatov@redhat.com, automated-testing@yoctoproject.org,
> > > info@kernelci.org, khilamn@baylibre.org,
> > > syzkaller@googlegroups.com, lkp@lists.01.org, stable@vger.kernel.org,
> > > labbott@redhat.com
> > > Cc: eslobodo@redhat.com, cki-project@redhat.com
> > > Sent: Friday, May 24, 2019 10:17:04 PM
> > > Subject: RE: CKI hackfest @Plumbers invite
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Veronika Kabatova
> > > >
> > > > Hi,
> > > >
> > > > as some of you have heard, CKI Project is planning hackfest CI meetings
> > > > after
> > > > Plumbers conference this year (Sept. 12-13). We would like to invite
> > > > everyone
> > > > who has interest in CI for kernel to come and join us.
> > > >
> > > > The early agenda with summary is at the end of the email. If you think
> > > > there's
> > > > something important missing let us know! Also let us know in case you'd
> > > > want to
> > > > lead any of the sessions, we'd be happy to delegate out some work :)
> > > >
> > > >
> > > > Please send us an email as soon as you decide to come and feel free to
> > > > invite
> > > > other people who should be present. We are not planning to cap the
> > > > attendance
> > > > right now but need to solve the logistics based on the interest. The
> > > > event
> > > > is
> > > > free to attend, no additional registration except letting us know is
> > > > needed.
> > > >
> > > > Feel free to contact us if you have any questions,
> > >
> > > I plan to come to the event.
> > >
> > > > -----------------------------------------------------------
> > > > Here is an early agenda we put together:
> > > > - Introductions
> > > > - Common place for upstream results, result publishing in general
> > > >   - The discussion on the mailing list is going strong so we might be
> > > >   able
> > > >   to
> > > >     substitute this session for a different one in case everything is
> > > >     solved by
> > > >     September.
> > > > - Test result interpretation and bug detection
> > > >   - How to autodetect infrastructure failures, regressions/new bugs and
> > > >   test
> > > >     bugs? How to handle continuous failures due to known bugs in both
> > > >     tests
> > > > and
> > > >     kernel? What's your solution? Can people always trust the results
> > > >     they
> > > >     receive?
> > > > - Getting results to developers/maintainers
> > > >   - Aimed at kernel developers and maintainers, share your feedback and
> > > >     expectations.
> > > >   - How much data should be sent in the initial communication vs. a
> > > >   click
> > > >   away
> > > >     in a dashboard? Do you want incremental emails with new results as
> > > >     they
> > > > come
> > > >     in?
> > > >   - What about adding checks to tested patches in Patchwork when patch
> > > > series
> > > >     are being tested?
> > > >   - Providing enough data/script to reproduce the failure. What if
> > > >   special
> > > >   HW
> > > >     is needed?
> > > > - Onboarding new kernel trees to test
> > > >   - Aimed at kernel developers and maintainers.
> > > >   - Which trees are most prone to bring in new problems? Which are the
> > > >   most
> > > >     critical ones? Do you want them to be tested? Which tests do you
> > > >     feel
> > > >     are
> > > >     most beneficial for specific trees or in general?
> > > > - Security when testing untrusted patches
> > > >   - How do we merge, compile, and test patches that have untrusted code
> > > >   in
> > > > them
> > > >     and have not yet been reviewed? How do we avoid abuse of systems,
> > > >     information theft, or other damage?
> > > >   - Check out the original patch that sparked the discussion at
> > > >     https://patchwork.ozlabs.org/patch/862123/
> > > > - Avoiding effort duplication
> > > >   - Food for thought by GregKH
> > > >   - X different CI systems running ${TEST} on latest stable kernel on
> > > >   x86_64
> > > >     might look useless on the first look but is it? AMD/Intel CPUs,
> > > >     different
> > > >     network cards, different graphic drivers, compilers, kernel
> > > >     configuration...
> > > >     How do we distribute the workload to avoid doing the same thing all
> > > >     over
> > > >     again while still running in enough different environments to get
> > > >     the
> > > >     most
> > > >     coverage?
> 
> 
> Hi Veronika,
> 

Hi!

> All are great questions that we need to resolve!
> 
> I am also very much concerned about duplication in 2 other dimensions
> with the current approach to kernel testing:
> 
> 1. If X different CI systems running ${TEST}, developers receive X
> reports about the same breakage from X different directions, in
> different formats, of different quality, at slightly different times
> and somebody needs to act on all of them in some way. The more CI
> systems we have, the more run meaningful number of tests and do
> automatic reporting, the more and more duplicates developers get.
> 

This is a very good point that we had to deal with internally -- people aren't
happy getting multiple reports about a same issue.

And that's what part of my point of finding balance was about too. Maybe the
test only breaks on specific HW so getting X reports from runs on different HW
where X-1 pass and one fails helps to narrow the issue down. Same if it fails
everywhere -- it has to be some central code that caused the failures. If all
the reports are just different version of "tested on x86 VM and it failed"
then I totally agree it's not much help.

The formats and quality of the reports is definitely something worth talking
about too, and potentially unify as much as we can (Tim started some work on
this already).


> 2. Effort duplication between implementation of different CI systems.
> Doing a proper and really good CI is very hard. This includes all
> questions that you mentioned here, and fine tuning of all of that,
> refining reporting, bisection, onboarding of different test suites,
> onboarding of different dynamic/static analysis tools and much more.
> Last but not least is duplication of processes related to these CIs.
> Speaking of my experience with syzbot, this is extremely hard and
> takes years. And we really can't expose a developer to 27 different
> systems and slightly different processes (this would mean they follow
> 0 of these processes).
> This is further complicated by the fact that kernel tests are
> fragmented, so it's not possible to, say, simply run all kernel tests.
> And kernel processes are fragmented, e.g. you mentioned patchwork, but
> not all subsystems use patchwork, so it's not possible to simply
> extend a CI to all subsystems. And some aspects of the current kernel
> development process notoriously complicate automation of things that
> really should be trivial. For example, if you have
> github/gitlab/gerrit, you can hook into arrival of each new change and
> pull exact code state. Done. For kernel some changes appear on
> patchwork, some don't, some are duplicated on multiple patchworks,
> some duplicated in a weird way on the same patchwork, some non-patches
> appear on patchwork because it's confused, and last but not least you
> can't really apply any of them because none of them include base
> tree/commit info. Handling just this requires lots of effort, guessing
> on coffee grounds and heuristics that need to be refined over time.
> The total complexity of doing it just once, with all resources
> combined and dev process re-shaped to cooperate is close to off-scale.
> 

Totally agreed, we've have some fun with some of the points you
mentioned as well and I'm sure others too. What we do in CKI is to unify
as much as we can across different trees we're testing. For example the
trees living in GitHub/GitLab/Gerrit -- not all trees do this but all
trees use the git backend so we use polling and commit checking (ugly,
I admit) as it works everywhere and we don't need to maintain multiple
different APIs for the same thing.


I don't want to derail the invite discussion by replying to everything
here but what you brought up are great points that every CI system around
kernel has to deal with.

> Do you see these points as a problem too? Or am I exaggerating matters?
> 
> 

Oh absolutely! While it's what I call "the nasty implementation details"
they are all valid problems that should be talked about more. Whether it's
with developers (eg. the points about putting kernel tests into a single
place and unifying the development process, if possible) or with other CI
teams.

I'd be happy to talk with you about all of this at the hackfest or
privately/off-thread. The automated-testing list (in cc) is a great place
too as a diverse set of people involved with CI gathers there.


Let me know what works for you,
Veronika

> 
> 
> 
> 
> > > > - Common hardware pools
> > > >   - Is this something people are interested in? Would be helpful
> > > >   especially
> > > >   for
> > > >     HW that's hard to access, eg. ppc64le or s390x systems. Companies
> > > >     could
> > > > also
> > > >     sing up to share their HW for testing to ensure kernel works with
> > > >     their
> > > >     products.
> > >
> > > I have strong opinions on some of these, but maybe only useful experience
> > > in a few areas.  Fuego has 2 separate notions, which we call "skiplists"
> > > and "pass criteria", which have to do with this bullet:
> > >
> > > - How to autodetect infrastructure failures, regressions/new bugs and
> > > test
> > >      bugs? How to handle continuous failures due to known bugs in both
> > >      tests and kernel? What's your solution? Can people always trust the
> > >      results they
> > >      receive?
> > >
> > > I'd be happy to discuss this, if it's desired.
> > >
> > > Otherwise, I've recently been working on standards for "test definition",
> > > which defines the data and meta-data associated with a test.   I could
> > > talk
> > > about where I'm at with that, if people are interested.
> > >
> >
> > Sounds great! I added both your points to the agenda as I do think they
> > have
> > a place here. The list of items is growing so I hope we can still fit
> > everything into the two days we planned :)
> >
> >
> > See you there!
> > Veronika
> >
> > > Let me know what you think.
> > >  -- Tim
> 
