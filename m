Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 617A7F1DE0
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 19:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfKFS7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 13:59:35 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39282 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbfKFS7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 13:59:35 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 14F251C0997; Wed,  6 Nov 2019 19:59:33 +0100 (CET)
Date:   Wed, 6 Nov 2019 19:59:32 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/93] 4.19.81-stable review
Message-ID: <20191106185932.GA2183@amd>
References: <20191027203251.029297948@linuxfoundation.org>
 <20191029162419.cumhku6smn2x2bq4@ucw.cz>
 <20191029180233.GA587491@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20191029180233.GA587491@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-10-29 19:02:33, Greg Kroah-Hartman wrote:
> On Tue, Oct 29, 2019 at 05:24:19PM +0100, Pavel Machek wrote:
> > > This is the start of the stable review cycle for the 4.19.81 release.
> > > There are 93 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> > > Anything received after that time might be too late.
> >=20
> > > Date: Tue, 29 Oct 2019 10:19:29 +0100
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > To: linux-kernel@vger.kernel.org, Andrew Morton
> > > Subject: Linux 4.19.81
> >=20
> > > [-- The following data is signed --]
> >=20
> > >  I'm announcing the release of the 4.19.81 kernel.
> >=20
> > > All users of the 4.19 kernel series must upgrade.
> >=20
> > Am I confused or was the 4.19.81 released a bit early?
>=20
> I said:
> 	Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
>=20
> And I released at:
> 	Date: Tue, 29 Oct 2019 10:19:29 +0100
>=20
> So really, I was a few minutes late :)

I'm confused. You said "by Tue ... 08:27:02 PM UTC". That 8 PM is 20h,
but did the release on 10h GMT+1, or 9h UTC -- 9 AM.... so like 11
hours early, if I got the timezones right.

Does PM mean something else in the above context?

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3DGBQACgkQMOfwapXb+vIgvACfXy4dOoxStaX4TYXK6Hv1J6yh
YAcAnAnHKWkiTjwoB5Cg5Y58K+iR3jvj
=V8Qg
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
