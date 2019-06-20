Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB894D2E7
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 18:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFTQL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 12:11:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbfFTQL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 12:11:57 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 264FE83F3C;
        Thu, 20 Jun 2019 16:11:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EF7761987;
        Thu, 20 Jun 2019 16:11:55 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3C7971806B0E;
        Thu, 20 Jun 2019 16:11:53 +0000 (UTC)
Date:   Thu, 20 Jun 2019 12:11:52 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Guillaume Tucker <guillaume.tucker@gmail.com>
Cc:     kernelci@groups.io, automated-testing@yoctoproject.org,
        info@kernelci.org, Tim Bird <Tim.Bird@sony.com>,
        syzkaller@googlegroups.com, lkp@lists.01.org,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Eliska Slobodova <eslobodo@redhat.com>,
        CKI Project <cki-project@redhat.com>
Message-ID: <1759213455.26229412.1561047112464.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAH1_8nAx-1+uqOwAOCfGbqdWzgWD1-oikAfoVBqw4qPcu8v4fw@mail.gmail.com>
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com> <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com> <CAH1_8nAx-1+uqOwAOCfGbqdWzgWD1-oikAfoVBqw4qPcu8v4fw@mail.gmail.com>
Subject: Re: CKI hackfest @Plumbers invite
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.204.239, 10.4.195.12]
Thread-Topic: CKI hackfest @Plumbers invite
Thread-Index: skr/QCNoOlzeCUrzcig8JpHiZicQTw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 20 Jun 2019 16:11:56 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Guillaume Tucker" <guillaume.tucker@gmail.com>
> To: kernelci@groups.io, vkabatov@redhat.com
> Cc: automated-testing@yoctoproject.org, info@kernelci.org, "Tim Bird" <Tim.Bird@sony.com>, khilamn@baylibre.org,
> syzkaller@googlegroups.com, lkp@lists.01.org, stable@vger.kernel.org, "Laura Abbott" <labbott@redhat.com>, "Eliska
> Slobodova" <eslobodo@redhat.com>, "CKI Project" <cki-project@redhat.com>
> Sent: Thursday, June 20, 2019 5:42:11 PM
> Subject: Re: CKI hackfest @Plumbers invite
> 
> Hi Veronika,
> 
> On Tue, May 21, 2019 at 3:55 PM Veronika Kabatova <vkabatov@redhat.com>
> wrote:
> 
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
> 
> Please do count me in as well!
> 

\o/

> One topic I would like to add to the agenda is:
> 
> - Open testing philosophy
>   - Connecting components from different origins: builders, test
>     labs, databases, dashboards...
>   - Interoperability: documented remote APIs to let components
>     talk to each other
>   - kernelci.org already does this with distributed builds and
>     test labs, it would be good to apply the same principles to
>     to other existing systems doing upstream kernel testing for
>     everyone's benefit
>   - Optimal utilisation of available resources
>   - Enable more high-level features by joining
>     forces (bisections, cross-referencing of results, bug
>     tracking...)
> 
> This does have some commonality with "Common hardware pools"
> and "Avoiding effort duplication" but I think it makes sense to
> keep it together as a general approach.
> 

I agree that this topic is important (and I believe some other CKI people
made that clear as well) so I added it to the agenda topics. The list of
those is getting long so we'd definitely need to curate it properly soon
but I'll make sure this stays there.


Thanks for the interest!
Veronika

> Thanks,
> Guillaume
> 
> Feel free to contact us if you have any questions,
> > Veronika
> > CKI Project
> >
> >
> > -----------------------------------------------------------
> > Here is an early agenda we put together:
> > - Introductions
> > - Common place for upstream results, result publishing in general
> >   - The discussion on the mailing list is going strong so we might be able
> > to
> >     substitute this session for a different one in case everything is
> > solved by
> >     September.
> > - Test result interpretation and bug detection
> >   - How to autodetect infrastructure failures, regressions/new bugs and
> > test
> >     bugs? How to handle continuous failures due to known bugs in both
> > tests and
> >     kernel? What's your solution? Can people always trust the results they
> >     receive?
> > - Getting results to developers/maintainers
> >   - Aimed at kernel developers and maintainers, share your feedback and
> >     expectations.
> >   - How much data should be sent in the initial communication vs. a click
> > away
> >     in a dashboard? Do you want incremental emails with new results as
> > they come
> >     in?
> >   - What about adding checks to tested patches in Patchwork when patch
> > series
> >     are being tested?
> >   - Providing enough data/script to reproduce the failure. What if special
> > HW
> >     is needed?
> > - Onboarding new kernel trees to test
> >   - Aimed at kernel developers and maintainers.
> >   - Which trees are most prone to bring in new problems? Which are the most
> >     critical ones? Do you want them to be tested? Which tests do you feel
> > are
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
> > x86_64
> >     might look useless on the first look but is it? AMD/Intel CPUs,
> > different
> >     network cards, different graphic drivers, compilers, kernel
> > configuration...
> >     How do we distribute the workload to avoid doing the same thing all
> > over
> >     again while still running in enough different environments to get the
> > most
> >     coverage?
> > - Common hardware pools
> >   - Is this something people are interested in? Would be helpful
> > especially for
> >     HW that's hard to access, eg. ppc64le or s390x systems. Companies
> > could also
> >     sing up to share their HW for testing to ensure kernel works with their
> >     products.
> >
> > -=-=-=-=-=-=-=-=-=-=-=-
> > Groups.io Links: You receive all messages sent to this group.
> >
> > View/Reply Online (#404): https://groups.io/g/kernelci/message/404
> > Mute This Topic: https://groups.io/mt/31697554/924702
> > Group Owner: kernelci+owner@groups.io
> > Unsubscribe: https://groups.io/g/kernelci/unsub  [
> > guillaume.tucker@gmail.com]
> > -=-=-=-=-=-=-=-=-=-=-=-
> >
> >
> 
