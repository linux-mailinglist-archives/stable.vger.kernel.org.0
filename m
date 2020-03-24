Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB90190DD8
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 13:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgCXMmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 08:42:42 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:29735 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727443AbgCXMmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 08:42:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585053760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IX+Nz+MNQtPX04L2tuoWum1Q05QumdhIxM/Q00/W7bk=;
        b=S1p8mKJn2yf2bCn7MWN/vVkzPl6b76QRB9wMHGsvot9oZ28UM8shzdoELQSBSs2O6Vb4si
        g2LyPt2J5YzN495CSAgqsbUbcutBzFmOscA8IjGryx14b9XgtmyHkaRbLFkDerQJQEblOv
        838O5lcp0e9piRB8U8h0NjCwp4QfmBE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-k41eMl4xOhaQCvJsG31YlQ-1; Tue, 24 Mar 2020 08:42:37 -0400
X-MC-Unique: k41eMl4xOhaQCvJsG31YlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07B7A800D54;
        Tue, 24 Mar 2020 12:42:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F358BBBBCE;
        Tue, 24 Mar 2020 12:42:35 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id E207286FF7;
        Tue, 24 Mar 2020 12:42:35 +0000 (UTC)
Date:   Tue, 24 Mar 2020 08:42:35 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Greg KH <greg@kroah.com>
Cc:     Memory Management <mm-qe@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Message-ID: <290791291.15199861.1585053755727.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200324114727.GA2333047@kroah.com>
References: <cki.936A32626F.M0L95JS69X@redhat.com> <20200324062213.GA1961100@kroah.com> <970614328.15180583.1585048327050.JavaMail.zimbra@redhat.com> <20200324111819.GA2234211@kroah.com> <1768018191.15186361.1585050272846.JavaMail.zimbra@redhat.com> <20200324114727.GA2333047@kroah.com>
Subject: =?utf-8?Q?Re:_=F0=9F=92=A5_PANICKED:_Test=09report=3Ffor=3Fke?=
 =?utf-8?Q?rnel_5.5.12-rc1-8b841eb.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.195.245, 10.4.195.29]
Thread-Topic: ? PANICKED: Test report?for?kernel 5.5.12-rc1-8b841eb.cki (stable)
Thread-Index: qdNWa0HLE9U5eSKYBaowC67tjwEF0w==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Greg KH" <greg@kroah.com>
> To: "Veronika Kabatova" <vkabatov@redhat.com>
> Cc: "Memory Management" <mm-qe@redhat.com>, "Ondrej Mosnacek" <omosnace@r=
edhat.com>, "Linux Stable maillist"
> <stable@vger.kernel.org>, "CKI Project" <cki-project@redhat.com>, "Jan St=
ancek" <jstancek@redhat.com>, "LTP Mailing
> List" <ltp@lists.linux.it>
> Sent: Tuesday, March 24, 2020 12:47:27 PM
> Subject: Re: =F0=9F=92=A5 PANICKED: Test=09report?for?kernel 5.5.12-rc1-8=
b841eb.cki (stable)
>=20
> On Tue, Mar 24, 2020 at 07:44:32AM -0400, Veronika Kabatova wrote:
> >=20
> >=20
> > ----- Original Message -----
> > > From: "Greg KH" <greg@kroah.com>
> > > To: "Veronika Kabatova" <vkabatov@redhat.com>
> > > Cc: "Memory Management" <mm-qe@redhat.com>, "Ondrej Mosnacek"
> > > <omosnace@redhat.com>, "Linux Stable maillist"
> > > <stable@vger.kernel.org>, "CKI Project" <cki-project@redhat.com>, "Ja=
n
> > > Stancek" <jstancek@redhat.com>, "LTP Mailing
> > > List" <ltp@lists.linux.it>
> > > Sent: Tuesday, March 24, 2020 12:18:19 PM
> > > Subject: Re: =F0=9F=92=A5 PANICKED: Test report=09for?kernel 5.5.12-r=
c1-8b841eb.cki
> > > (stable)
> > >=20
> > > On Tue, Mar 24, 2020 at 07:12:07AM -0400, Veronika Kabatova wrote:
> > > >=20
> > > >=20
> > > > ----- Original Message -----
> > > > > From: "Greg KH" <greg@kroah.com>
> > > > > To: "CKI Project" <cki-project@redhat.com>
> > > > > Cc: "Memory Management" <mm-qe@redhat.com>, "Ondrej Mosnacek"
> > > > > <omosnace@redhat.com>, "Linux Stable maillist"
> > > > > <stable@vger.kernel.org>, "Jan Stancek" <jstancek@redhat.com>, "L=
TP
> > > > > Mailing List" <ltp@lists.linux.it>
> > > > > Sent: Tuesday, March 24, 2020 7:22:13 AM
> > > > > Subject: Re: =F0=9F=92=A5 PANICKED: Test report for=09kernel
> > > > > 5.5.12-rc1-8b841eb.cki
> > > > > (stable)
> > > > >=20
> > > > > On Tue, Mar 24, 2020 at 05:42:38AM -0000, CKI Project wrote:
> > > > > >=20
> > > > > > Hello,
> > > > > >=20
> > > > > > We ran automated tests on a recent commit from this kernel tree=
:
> > > > > >=20
> > > > > >        Kernel repo:
> > > > > >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/l=
inux-stable-rc.git
> > > > > >             Commit: 8b841eb697e1 - Linux 5.5.12-rc1
> > > > > >=20
> > > > > > The results of these automated tests are provided below.
> > > > > >=20
> > > > > >     Overall result: FAILED (see details below)
> > > > > >              Merge: OK
> > > > > >            Compile: OK
> > > > > >              Tests: PANICKED
> > > > > >=20
> > > > > > All kernel binaries, config files, and logs are available for
> > > > > > download
> > > > > > here:
> > > > > >=20
> > > > > >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?p=
refix=3Ddatawarehouse/2020/03/23/502039
> > > > > >=20
> > > > > > One or more kernel tests failed:
> > > > > >=20
> > > > > >     ppc64le:
> > > > > >      =F0=9F=92=A5 xfstests - ext4
> > > > > >=20
> > > > > >     aarch64:
> > > > > >      =E2=9D=8C LTP
> > > > > >=20
> > > > > >     x86_64:
> > > > > >      =F0=9F=92=A5 xfstests - ext4
> > > > >=20
> > > > > Ok, it's time I start just blacklisting this report again, it's n=
ot
> > > > > being helpful in any way :(
> > > > >=20
> > > > > Remember, if something starts breaking, I need some way to find o=
ut
> > > > > what
> > > > > caused it to break...
> > > > >=20
> > > >=20
> > > > Hi Greg,
> > > >=20
> > > > do you have any specific suggestions about what to include to help =
you
> > > > out?
> > > > The linked console logs contain call traces for the panics [0]. Is
> > > > there
> > > > anything else that would help you with debugging those? We're plann=
ing
> > > > on
> > > > releasing core dumps, would those be helpful?
> > >=20
> > > Bisection to find the offending commit would be best.
> > >=20
> >=20
> > This is going to be really tricky for hard to reproduce bugs but we'll =
do
> > some research on it, thanks!
>=20
> I got about 8 "failed" emails today, it doesn't sound like it is hard to
> reproduce.

I meant in general, as we do catch a bunch of such problems. Those usually
require some input and testing from people who understand the subsystem to
create a reliable reproducer.

For this particular failure, do you want to try out the patches I linked
in the first email or should we waive them for now?

>=20
> And if you can't reproduce it, why would you expect me to know what is
> going on?  :)
>=20

Well you do know the kernel pretty well :) We also cc the test maintainers
to help out if it's needed since they understand the failed area, though
given the current situation around the world people's reactions might
understandably be slower.


Veronika

> thanks,
>=20
> greg k-h
>=20
>=20
>=20

