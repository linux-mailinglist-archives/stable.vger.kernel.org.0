Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC6156816
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 13:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfFZL5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 07:57:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfFZL5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 07:57:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4A2A3C057F30;
        Wed, 26 Jun 2019 11:57:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 103EA60BF3;
        Wed, 26 Jun 2019 11:57:41 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB01E1806B0F;
        Wed, 26 Jun 2019 11:57:36 +0000 (UTC)
Date:   Wed, 26 Jun 2019 07:57:35 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Tim Bird <Tim.Bird@sony.com>
Cc:     guillaume tucker <guillaume.tucker@gmail.com>, kernelci@groups.io,
        automated-testing@yoctoproject.org, info@kernelci.org,
        syzkaller@googlegroups.com, lkp@lists.01.org,
        stable@vger.kernel.org, labbott@redhat.com, eslobodo@redhat.com,
        cki-project@redhat.com
Message-ID: <1255835260.27213560.1561550255907.JavaMail.zimbra@redhat.com>
In-Reply-To: <ECADFF3FD767C149AD96A924E7EA6EAF977399CD@USCULXMSG01.am.sony.com>
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com> <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com> <CAH1_8nAx-1+uqOwAOCfGbqdWzgWD1-oikAfoVBqw4qPcu8v4fw@mail.gmail.com> <1759213455.26229412.1561047112464.JavaMail.zimbra@redhat.com> <ECADFF3FD767C149AD96A924E7EA6EAF977399CD@USCULXMSG01.am.sony.com>
Subject: Re: CKI hackfest @Plumbers invite
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.205.201, 10.4.195.7]
Thread-Topic: CKI hackfest @Plumbers invite
Thread-Index: AQHVJ37SWv4qmkd5dESo8sS6Z+b53aak+c4AgAYyvSDWWRoavA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 26 Jun 2019 11:57:48 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Tim Bird" <Tim.Bird@sony.com>
> To: vkabatov@redhat.com, "guillaume tucker" <guillaume.tucker@gmail.com>
> Cc: kernelci@groups.io, automated-testing@yoctoproject.org, info@kernelci.org, syzkaller@googlegroups.com,
> lkp@lists.01.org, stable@vger.kernel.org, labbott@redhat.com, eslobodo@redhat.com, cki-project@redhat.com
> Sent: Monday, June 24, 2019 8:55:12 PM
> Subject: RE: CKI hackfest @Plumbers invite
> 
> > -----Original Message-----
> > From: Veronika Kabatova
> > 
> > ----- Original Message -----
> > > From: "Guillaume Tucker"
> > >
> > > Hi Veronika,
> > >
> > > On Tue, May 21, 2019 at 3:55 PM Veronika Kabatova
> > <vkabatov@redhat.com>
> > > wrote:
> > >
> > 
> > I agree that this topic is important (and I believe some other CKI people
> > made that clear as well) so I added it to the agenda topics. The list of
> > those is getting long so we'd definitely need to curate it properly soon
> > but I'll make sure this stays there.
> 
> I agree that Guillaume's topic would be good to discuss.
> 
> Is the draft agenda online anywhere?

I sent the draft with the original invite so you can check that out. Since
then, we added a few new topics to the list:

- Test definition standardization (from you)
- Onboarding new tests to run (versioning, unification of test locations
  etc.)
- Open testing philosophy (from Guillaume)

We'll try our best to cover all mentioned topics during the hackfest but
haven't started working on the schedule yet. We'll send it out before the
hackfest and likely will publish it on cki-project.org as well.


Veronika


>  -- Tim
> 
> 
