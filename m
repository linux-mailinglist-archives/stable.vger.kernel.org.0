Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E07F2B385
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 13:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfE0LwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 07:52:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbfE0LwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 07:52:16 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 025483082211;
        Mon, 27 May 2019 11:52:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C2F95D707;
        Mon, 27 May 2019 11:52:14 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id ED068206D1;
        Mon, 27 May 2019 11:52:13 +0000 (UTC)
Date:   Mon, 27 May 2019 07:52:13 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Tim Bird <Tim.Bird@sony.com>
Cc:     automated-testing@yoctoproject.org, info@kernelci.org,
        syzkaller@googlegroups.com, lkp@lists.01.org,
        stable@vger.kernel.org, labbott@redhat.com, eslobodo@redhat.com,
        cki-project@redhat.com
Message-ID: <1442701383.22077553.1558957933273.JavaMail.zimbra@redhat.com>
In-Reply-To: <ECADFF3FD767C149AD96A924E7EA6EAF9772760D@USCULXMSG01.am.sony.com>
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com> <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com> <ECADFF3FD767C149AD96A924E7EA6EAF9772760D@USCULXMSG01.am.sony.com>
Subject: Re: CKI hackfest @Plumbers invite
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.205.210, 10.4.195.9]
Thread-Topic: CKI hackfest @Plumbers invite
Thread-Index: AdUSbaN1oGVEoc2FRCGELn9GsI4Q09FwgasV
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 27 May 2019 11:52:15 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Tim Bird" <Tim.Bird@sony.com>
> To: vkabatov@redhat.com, automated-testing@yoctoproject.org, info@kernelci.org, khilamn@baylibre.org,
> syzkaller@googlegroups.com, lkp@lists.01.org, stable@vger.kernel.org, labbott@redhat.com
> Cc: eslobodo@redhat.com, cki-project@redhat.com
> Sent: Friday, May 24, 2019 10:17:04 PM
> Subject: RE: CKI hackfest @Plumbers invite
> 
> 
> 
> > -----Original Message-----
> > From: Veronika Kabatova
> > 
> > Hi,
> > 
> > as some of you have heard, CKI Project is planning hackfest CI meetings
> > after
> > Plumbers conference this year (Sept. 12-13). We would like to invite
> > everyone
> > who has interest in CI for kernel to come and join us.
> > 
> > The early agenda with summary is at the end of the email. If you think
> > there's
> > something important missing let us know! Also let us know in case you'd
> > want to
> > lead any of the sessions, we'd be happy to delegate out some work :)
> > 
> > 
> > Please send us an email as soon as you decide to come and feel free to
> > invite
> > other people who should be present. We are not planning to cap the
> > attendance
> > right now but need to solve the logistics based on the interest. The event
> > is
> > free to attend, no additional registration except letting us know is
> > needed.
> > 
> > Feel free to contact us if you have any questions,
> 
> I plan to come to the event.
> 
> > -----------------------------------------------------------
> > Here is an early agenda we put together:
> > - Introductions
> > - Common place for upstream results, result publishing in general
> >   - The discussion on the mailing list is going strong so we might be able
> >   to
> >     substitute this session for a different one in case everything is
> >     solved by
> >     September.
> > - Test result interpretation and bug detection
> >   - How to autodetect infrastructure failures, regressions/new bugs and
> >   test
> >     bugs? How to handle continuous failures due to known bugs in both tests
> > and
> >     kernel? What's your solution? Can people always trust the results they
> >     receive?
> > - Getting results to developers/maintainers
> >   - Aimed at kernel developers and maintainers, share your feedback and
> >     expectations.
> >   - How much data should be sent in the initial communication vs. a click
> >   away
> >     in a dashboard? Do you want incremental emails with new results as they
> > come
> >     in?
> >   - What about adding checks to tested patches in Patchwork when patch
> > series
> >     are being tested?
> >   - Providing enough data/script to reproduce the failure. What if special
> >   HW
> >     is needed?
> > - Onboarding new kernel trees to test
> >   - Aimed at kernel developers and maintainers.
> >   - Which trees are most prone to bring in new problems? Which are the most
> >     critical ones? Do you want them to be tested? Which tests do you feel
> >     are
> >     most beneficial for specific trees or in general?
> > - Security when testing untrusted patches
> >   - How do we merge, compile, and test patches that have untrusted code in
> > them
> >     and have not yet been reviewed? How do we avoid abuse of systems,
> >     information theft, or other damage?
> >   - Check out the original patch that sparked the discussion at
> >     https://patchwork.ozlabs.org/patch/862123/
> > - Avoiding effort duplication
> >   - Food for thought by GregKH
> >   - X different CI systems running ${TEST} on latest stable kernel on
> >   x86_64
> >     might look useless on the first look but is it? AMD/Intel CPUs,
> >     different
> >     network cards, different graphic drivers, compilers, kernel
> >     configuration...
> >     How do we distribute the workload to avoid doing the same thing all
> >     over
> >     again while still running in enough different environments to get the
> >     most
> >     coverage?
> > - Common hardware pools
> >   - Is this something people are interested in? Would be helpful especially
> >   for
> >     HW that's hard to access, eg. ppc64le or s390x systems. Companies could
> > also
> >     sing up to share their HW for testing to ensure kernel works with their
> >     products.
> 
> I have strong opinions on some of these, but maybe only useful experience
> in a few areas.  Fuego has 2 separate notions, which we call "skiplists"
> and "pass criteria", which have to do with this bullet:
> 
> - How to autodetect infrastructure failures, regressions/new bugs and test
>      bugs? How to handle continuous failures due to known bugs in both
>      tests and kernel? What's your solution? Can people always trust the
>      results they
>      receive?
> 
> I'd be happy to discuss this, if it's desired.
> 
> Otherwise, I've recently been working on standards for "test definition",
> which defines the data and meta-data associated with a test.   I could talk
> about where I'm at with that, if people are interested.
> 

Sounds great! I added both your points to the agenda as I do think they have
a place here. The list of items is growing so I hope we can still fit
everything into the two days we planned :)


See you there!
Veronika

> Let me know what you think.
>  -- Tim
> 
> 
