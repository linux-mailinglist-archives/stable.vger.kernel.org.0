Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF2610C74
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfEARvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 13:51:33 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:56342 "EHLO tmailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfEARvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 May 2019 13:51:33 -0400
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
        by mailer.gwdg.de with esmtp (Exim 4.90_1)
        (envelope-from <maan@tuebingen.mpg.de>)
        id 1hLtOE-0008UM-Hw; Wed, 01 May 2019 19:51:30 +0200
Received: from [10.37.80.2] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 22799062; Wed, 01 May 2019 19:52:56 +0200
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Wed, 01 May 2019 19:51:29 +0200
Date:   Wed, 1 May 2019 19:51:29 +0200
From:   Andre Noll <maan@tuebingen.mpg.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190501175129.GH2780@tuebingen.mpg.de>
References: <20190430121420.GW2780@tuebingen.mpg.de>
 <20190430151151.GF5207@magnolia>
 <20190430162506.GZ2780@tuebingen.mpg.de>
 <20190430174042.GH5207@magnolia>
 <20190430190525.GB2780@tuebingen.mpg.de>
 <20190430191825.GF5217@magnolia>
 <20190430210724.GD2780@tuebingen.mpg.de>
 <20190501153643.GL5207@magnolia>
 <20190501165933.GF2780@tuebingen.mpg.de>
 <20190501171529.GB28949@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xEruU51OOzV9VdJQ"
Content-Disposition: inline
In-Reply-To: <20190501171529.GB28949@kroah.com>
User-Agent: Mutt/1.11.4 (207b9306) (2019-03-13)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xEruU51OOzV9VdJQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 01, 19:15, Greg Kroah-Hartman wrote
> On Wed, May 01, 2019 at 06:59:33PM +0200, Andre Noll wrote:
> > On Wed, May 01, 08:36, Darrick J. Wong wrote
> > > > > You could send this patch to the stable list, but my guess is that
> > > > > they'd prefer a straight backport of all three commits...
> > > >=20
> > > > Hm, cherry-picking the first commit onto 4.9,171 already gives
> > > > four conflicting files. The conflicts are trivial to resolve (git
> > > > cherry-pick -xX theirs 21ec54168b36 does it), but that doesn't
> > > > compile because xfs_btree_query_all() is missing.  So e9a2599a249ed
> > > > (xfs: create a function to query all records in a btree) is needed =
as
> > > > well. But then, applying 86210fbebae (xfs: move various type verifi=
ers
> > > > to common file) on top of that gives non-trivial conflicts.
> > >=20
> > > Ah, I suspected that might happen.  Backports are hard. :(
> > >=20
> > > I suppose one saving grace of the patch you sent is that it'll likely
> > > break the build if anyone ever /does/ attempt a backport of those fir=
st
> > > two commits.  Perhaps that is the most practical way forward.
> > >=20
> > > > So, for automatic backporting we would need to cherry-pick even mor=
e,
> > > > and each backported commit should be tested of course. Given this, =
do
> > > > you still think Greg prefers a rather large set of straight backpor=
ts
> > > > over the simple commit that just pulls in the missing function?
> > >=20
> > > I think you'd have to ask him that, if you decide not to send
> > > yesterday's patch.
> >=20
> > Let's try. I've added a sentence to the commit message which explains
> > why a straight backport is not practical, and how to proceed if anyone
> > wants to backport the earlier commits.
> >=20
> > Greg: Under the given circumstances, would you be willing to accept
> > the patch below for 4.9?
>=20
> If the xfs maintainers say this is ok, it is fine with me.

Darrick said, he's in favor of the patch, so I guess I can add his
Acked-by. Would you also like to see the ack from Dave (the author
of the original commit)?

Anything else that needs to be changed?

Thanks
Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--xEruU51OOzV9VdJQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXMncngAKCRBa2jVAMQCT
D2wJAJ4qsAbTJewdQTxRwl8pthMQHOyfrQCgkjwSl14a7tFQS2iSG5yROXh0x3o=
=QPop
-----END PGP SIGNATURE-----

--xEruU51OOzV9VdJQ--
