Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE536E9509
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 03:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfJ3Ci5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 22:38:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42091 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726752AbfJ3Ci5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 22:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572403136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=blLxZBoRcaQB3QJFBCRv64abV67uCq/EYHTQ0UifKbI=;
        b=JuyZHqAz4KfufGk5/wA9UlRBfivzfcZriCryGp3WgGCdImsg0wFOJFETSiWZyh4h00Dzhj
        M6yAyCsTChcktDSKDU9d0WHFu2Fkdq2bdh7Z/ZjJBDTKVK9jhpycybaIauXzVNTsGBeCWh
        0c97Wqk8aL/0pax0FuoHn9dojZeYHzk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-FDp7zYf8O_ieyUetU-rnFQ-1; Tue, 29 Oct 2019 22:38:52 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8B095E8;
        Wed, 30 Oct 2019 02:38:50 +0000 (UTC)
Received: from localhost (dhcp-12-196.nay.redhat.com [10.66.12.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5A555D6D0;
        Wed, 30 Oct 2019 02:38:47 +0000 (UTC)
Date:   Wed, 30 Oct 2019 10:38:46 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     Deepa Dinamani <deepa.kernel@gmail.com>,
        Xiong Zhou <xzhou@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>, lkft-triage@lists.linaro.org,
        CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.3.8-rc2-96dab43.cki (stable)
Message-ID: <20191030023846.dbxdrtd4prl2dbco@xzhoux.usersys.redhat.com>
References: <20191029073318.c33ocl76zsgnx2y5@xzhoux.usersys.redhat.com>
 <20191029080855.GA512708@kroah.com>
 <20191029091126.ijvixns6fe3dzte3@xzhoux.usersys.redhat.com>
 <20191029092158.GA582092@kroah.com>
 <20191029124029.yygp2yetcjst4s6p@xzhoux.usersys.redhat.com>
 <CABeXuvpPQugDd9BOwtfKjmT+H+-mpeE83UOZKTLJTTZZ6DeHrQ@mail.gmail.com>
 <20191029181223.GB587491@kroah.com>
 <114dc6b2-846b-240d-db33-dd67aac51d30@redhat.com>
 <CABeXuvpEQoJ5F3vxjC4WUaUbKQJsdZJk-RERvwC1=YKG08_CyQ@mail.gmail.com>
 <13a8f979-7760-94e5-a32b-a3444caee6c2@redhat.com>
MIME-Version: 1.0
In-Reply-To: <13a8f979-7760-94e5-a32b-a3444caee6c2@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: FDp7zYf8O_ieyUetU-rnFQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 05:55:24PM -0400, Rachel Sibley wrote:
>=20
>=20
> On 10/29/19 5:21 PM, Deepa Dinamani wrote:
> > On Tue, Oct 29, 2019 at 1:08 PM Rachel Sibley <rasibley@redhat.com> wro=
te:
> > >=20
> > >=20
> > > On 10/29/19 2:12 PM, Greg KH wrote:
> > > > On Tue, Oct 29, 2019 at 07:57:05AM -0700, Deepa Dinamani wrote:
> > > > > The test is expected to fail on all kernels without the series.
> > > > >=20
> > > > > The series is a bugfix in the sense that vfs is no longer allowed=
 to
> > > > > set timestamps that filesystems have no way of supporting.
> > > > > There have been a couple of fixes after the series also.
> > > > >=20
> > > > > We can either disable the test or include the series for stable k=
ernels.
> > > > I don't see adding this series for the stable kernels, it does not =
make
> > > > sense.
> > I can disable the test from running within the xfs tests if needed.
> > But, how is it done for new tests that rely on features not present on
> > the stable kernels?
>=20
> Xiong's version of the test should be able to mask/skip the test based on=
 a
> kernel
> or distro version, but unsure how to mask if missing a specific feature, =
I'm
> hoping
> Xiong can help answer that.
> https://github.com/CKI-project/tests-beaker/tree/master/filesystems/xfs/x=
fstests

Filed https://github.com/CKI-project/tests-beaker/pull/417 to skip it
for now.

Xiong

> >=20
> > -Deepa
>=20

