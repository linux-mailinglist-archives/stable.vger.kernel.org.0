Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0F837111
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 12:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfFFKA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 06:00:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726972AbfFFKA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 06:00:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7AA33092641;
        Thu,  6 Jun 2019 10:00:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C8B72A313;
        Thu,  6 Jun 2019 10:00:17 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 598031806B15;
        Thu,  6 Jun 2019 10:00:16 +0000 (UTC)
Date:   Thu, 6 Jun 2019 06:00:15 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Shuah Khan <shuahkhan@gmail.com>, Dan Rue <dan.rue@linaro.org>
Cc:     automated-testing@yoctoproject.org, info@kernelci.org,
        Tim Bird <Tim.Bird@sony.com>, syzkaller@googlegroups.com,
        lkp@lists.01.org, stable <stable@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Eliska Slobodova <eslobodo@redhat.com>,
        CKI Project <cki-project@redhat.com>
Message-ID: <60016207.24115690.1559815215556.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAKocOONHHuL2xSBUQx0=pw5AHMG4im=9kv3GrJLrKaH6+wguDw@mail.gmail.com>
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com> <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com> <20190605204659.npyf7wnmsdlr2bff@xps.therub.org> <CAKocOONHHuL2xSBUQx0=pw5AHMG4im=9kv3GrJLrKaH6+wguDw@mail.gmail.com>
Subject: Re: CKI hackfest @Plumbers invite
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.205.124, 10.4.195.22]
Thread-Topic: CKI hackfest @Plumbers invite
Thread-Index: sXk4dxVD2bH3h6XwrT7jRkVqYxyISA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 06 Jun 2019 10:00:27 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Added you both to the list :)

----- Original Message -----
> From: "Shuah Khan" <shuahkhan@gmail.com>
> To: "Veronika Kabatova" <vkabatov@redhat.com>, automated-testing@yoctoproject.org, info@kernelci.org, "Tim Bird"
> <Tim.Bird@sony.com>, khilamn@baylibre.org, syzkaller@googlegroups.com, lkp@lists.01.org, "stable"
> <stable@vger.kernel.org>, "Laura Abbott" <labbott@redhat.com>, "Eliska Slobodova" <eslobodo@redhat.com>, "CKI
> Project" <cki-project@redhat.com>
> Sent: Thursday, June 6, 2019 12:00:13 AM
> Subject: Re: CKI hackfest @Plumbers invite
> 
> Hi Veronika,
> 
> On Wed, Jun 5, 2019 at 2:47 PM Dan Rue <dan.rue@linaro.org> wrote:
> >
> > On Tue, May 21, 2019 at 10:54:12AM -0400, Veronika Kabatova wrote:
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
> > > right now but need to solve the logistics based on the interest. The
> > > event is
> > > free to attend, no additional registration except letting us know is
> > > needed.
> > >
> 
> I am going be there and plan to attend.
> 
> > > Feel free to contact us if you have any questions,
> > > Veronika
> > > CKI Project
> >
> > Hi Veronika! Thanks for organizing this. I plan to attend, and I'm happy
> > to help out.
> >
> > With regard to the agenda, I've been following the '[Ksummit-discuss]
> > [MAINTAINERS SUMMIT] Squashing bugs!'[1] thread with interest, as it
> > relates especially to 'Getting results to developers/maintainers'. This,
> > along with result aggregation, are important areas to focus.
> >
> >
> > [1]
> > https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2019-May/006389.html
> >
> 
> Good to know there is an overlap and it makes sense for me to attend. :)
> 

I've been pointed to this thread just yesterday (thanks Laura!) and I agree
you bring up interesting topics in there. In fact, the "Getting results out"
topic Dan mentioned has the reproducibility of the failures as one of the
agenda items.

There definitely *is* an overlap in some of the topics and we'd be excited
to have you both there to talk more!

Veronika

> thanks,
> -- Shuah
> 
