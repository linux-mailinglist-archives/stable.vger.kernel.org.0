Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2B12C407E
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 13:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgKYMs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 07:48:27 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:44704 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKYMs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 07:48:27 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AFBE31C0B7D; Wed, 25 Nov 2020 13:48:24 +0100 (CET)
Date:   Wed, 25 Nov 2020 13:48:24 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        ultracoolguy@tutanota.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] leds: lm3697: Fix out-of-bound access"
 failed to apply to 5.9-stable tree
Message-ID: <20201125124824.GK29328@amd>
References: <160440470667193@kroah.com>
 <20201118225938.5nvkjdhc4st2zs57@debian>
 <X7eEUWOEl4dl2uvf@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2feizKym29CxAecD"
Content-Disposition: inline
In-Reply-To: <X7eEUWOEl4dl2uvf@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2feizKym29CxAecD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-11-20 09:54:41, Greg KH wrote:
> On Wed, Nov 18, 2020 at 10:59:38PM +0000, Sudip Mukherjee wrote:
> > Hi Greg,
> >=20
> > On Tue, Nov 03, 2020 at 12:58:26PM +0100, gregkh@linuxfoundation.org wr=
ote:
> > >=20
> > > The patch below does not apply to the 5.9-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git comm=
it
> > > id to <stable@vger.kernel.org>.
> >=20
> > Here is the backport. Please consider for 5.9-stable.
>=20
> Now applied, thanks.

Note that this is theoretical problem as device trees triggering it
are not circulating in the wild.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--2feizKym29CxAecD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl++UpgACgkQMOfwapXb+vLGmACffJCA+aAxXUlk55DuVai+5fIL
1kcAoK4Q8a5LVOQiliGoKkltr6rAZVyn
=aKSM
-----END PGP SIGNATURE-----

--2feizKym29CxAecD--
