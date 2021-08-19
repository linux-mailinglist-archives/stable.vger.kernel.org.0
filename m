Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07BA3F1516
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 10:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhHSIXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 04:23:20 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:60700 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236854AbhHSIXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 04:23:19 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C0CF41C0B77; Thu, 19 Aug 2021 10:22:42 +0200 (CEST)
Date:   Thu, 19 Aug 2021 10:22:42 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Theodore Ts'o <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jason@jlekstrand.net,
        Jonathan Gray <jsg@jsg.id.au>
Subject: Re: Determining corresponding mainline patch for stable patches Re:
 [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in eb_parse()
Message-ID: <20210819082242.GA13181@duo.ucw.cz>
References: <YROARN2fMPzhFMNg@kroah.com>
 <20210811122702.GA8045@duo.ucw.cz>
 <YRPLbV+Dq2xTnv2e@kroah.com>
 <20210813093104.GA20799@duo.ucw.cz>
 <20210813095429.GA21912@1wt.eu>
 <20210813102429.GA28610@duo.ucw.cz>
 <YRZRU4JIh5LQjDfE@kroah.com>
 <20210813111953.GB21912@1wt.eu>
 <YRaT3u4Qes8UY3x6@mit.edu>
 <YRdnANmNvp+Hkcg5@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <YRdnANmNvp+Hkcg5@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Plus this adds some cognitive load on those writing these patches, wh=
ich
> > > increases the global effort. It's already difficult enough to figure =
the
> > > appropriate Cc list when writing a fix, let's not add more burden in =
this
> > > chain.
> > >=20
> > > ...
> > >=20
> > > I'm also defending this on other projects. I find it important that
> > > efforts are reasonably shared. If tolerating 1% failures saves 20%
> > > effort on authors and adds 2% work on recipients, that's a net global
> > > win. You never completely eliminate mistakes anyway, regardless of the
> > > cost.
> >=20
> > The only way I can see to square the circle would be if there was some
> > kind of script that added enough value that people naturally use it
> > because it saves *them* time, and it automatically inserts the right
> > commit metadata in some kind of standardized way.
> >=20
> > I've been starting to use b4, and that's a great example of a workflow
> > that saves me time, and standardizes things as a very nice side
> > effect.  So perhaps the question is there some kind of automation that
> > saves 10-20% effort for authors *and* improves the quality of the
> > patch metadata for those that choose to use the script?
>=20
> A script/tool does generate the metadata in the "correct" way, as that
> is what Sasha and I use.  It is the issue for when people do it on their
> own for various reasons and do not just point us at an upstream commit
> that can cause issues.  In those cases, people wouldn't be using any
> script anyway, so there's nothing really to do here.

I agree that submitters would need to know about the tag; OTOH I
believe that if it looked like a tag, people would be more likely to
get it right. We moved from "mention what this fixes in body" to
"Fixes: " and I believe that was an improvement.

Anyway, three new entries in stable queues have format I have not seen
before:

|ec547f971 None .: 4.19| KVM: nSVM: always intercept VMLOAD/VMSAVE when nes=
ted (CVE-2021-3656)
|dbfcc0f75 None o: 4.19| KVM: nSVM: avoid picking up unsupported bits from =
L2 in int_ctl (CVE-2021-3653)
|b79b08940 None o: 4.4| KVM: nSVM: avoid picking up unsupported bits from L=
2 in int_ctl (CVE-2021-3653)

[ upstream commit 0f923e07124df069ba68d8bb12324398f4b6b709 ]

I guess I'll simply update the script.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYR4U0gAKCRAw5/Bqldv6
8pTNAKCDYzxB3+OILpEEEmtSt0D+14srYACdEdGQZV0MRvaMejh1wWSNC9JpWOs=
=Hkn1
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
