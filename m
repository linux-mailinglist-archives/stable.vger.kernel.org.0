Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB45190C0F
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 12:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgCXLMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 07:12:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:51865 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbgCXLMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 07:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585048332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RT6oA1D4SjFZEYnrzh+e9bPwrRWlrabhQI8hw3l+OI=;
        b=AYFZ0J1imsF702sXQrTrTDcM4yGkVDi9ohW5IO70COApZTbaqThhs3PGFL5j85R+k8orHa
        02r2Tn648TGp6SyLt8fjBRqNEOZEIV8GX09LyunAc3VqsbKyJoA/VUqLeRzslr0ZhUV0XZ
        /ZyHg0li7TvHyBqpKqXz69+gXMEFJbg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-OSoeDIPVNZmCwoPPgup0rw-1; Tue, 24 Mar 2020 07:12:08 -0400
X-MC-Unique: OSoeDIPVNZmCwoPPgup0rw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC05C800D53;
        Tue, 24 Mar 2020 11:12:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B146819C6A;
        Tue, 24 Mar 2020 11:12:07 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 41C9286380;
        Tue, 24 Mar 2020 11:12:07 +0000 (UTC)
Date:   Tue, 24 Mar 2020 07:12:07 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Greg KH <greg@kroah.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Message-ID: <970614328.15180583.1585048327050.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200324062213.GA1961100@kroah.com>
References: <cki.936A32626F.M0L95JS69X@redhat.com> <20200324062213.GA1961100@kroah.com>
Subject: =?utf-8?Q?Re:_=F0=9F=92=A5_PANICKED:_Test_report_for=09ke?=
 =?utf-8?Q?rnel_5.5.12-rc1-8b841eb.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.195.245, 10.4.195.24]
Thread-Topic: ? PANICKED: Test report for kernel 5.5.12-rc1-8b841eb.cki (stable)
Thread-Index: 2yNx6n+Jz/ULY5Rm46gEIcHfhdM/Kw==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Greg KH" <greg@kroah.com>
> To: "CKI Project" <cki-project@redhat.com>
> Cc: "Memory Management" <mm-qe@redhat.com>, "Ondrej Mosnacek" <omosnace@r=
edhat.com>, "Linux Stable maillist"
> <stable@vger.kernel.org>, "Jan Stancek" <jstancek@redhat.com>, "LTP Maili=
ng List" <ltp@lists.linux.it>
> Sent: Tuesday, March 24, 2020 7:22:13 AM
> Subject: Re: =F0=9F=92=A5 PANICKED: Test report for=09kernel 5.5.12-rc1-8=
b841eb.cki (stable)
>=20
> On Tue, Mar 24, 2020 at 05:42:38AM -0000, CKI Project wrote:
> >=20
> > Hello,
> >=20
> > We ran automated tests on a recent commit from this kernel tree:
> >=20
> >        Kernel repo:
> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git
> >             Commit: 8b841eb697e1 - Linux 5.5.12-rc1
> >=20
> > The results of these automated tests are provided below.
> >=20
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: PANICKED
> >=20
> > All kernel binaries, config files, and logs are available for download
> > here:
> >=20
> >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3D=
datawarehouse/2020/03/23/502039
> >=20
> > One or more kernel tests failed:
> >=20
> >     ppc64le:
> >      =F0=9F=92=A5 xfstests - ext4
> >=20
> >     aarch64:
> >      =E2=9D=8C LTP
> >=20
> >     x86_64:
> >      =F0=9F=92=A5 xfstests - ext4
>=20
> Ok, it's time I start just blacklisting this report again, it's not
> being helpful in any way :(
>=20
> Remember, if something starts breaking, I need some way to find out what
> caused it to break...
>=20

Hi Greg,

do you have any specific suggestions about what to include to help you out?
The linked console logs contain call traces for the panics [0]. Is there
anything else that would help you with debugging those? We're planning on
releasing core dumps, would those be helpful?



[0]: While these are new ones and not matching what we saw previously
     (that's why they weren't filtered out), the following commits from
     block tree should likely fix them:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commi=
t/?id=3Dfd1bb3ae54a9a2e0c42709de861c69aa146b8955
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commi=
t/?id=3Dc8997736650060594845e42c5d01d3118aec8d25
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commi=
t/?id=3D576682fa52cbd95deb3773449566274f206acc58
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commi=
t/?id=3D4d38a87fbb77fb9ff2ff4e914162a8ae6453eff5



Veronika

> greg k-h
>=20
>=20
>=20

