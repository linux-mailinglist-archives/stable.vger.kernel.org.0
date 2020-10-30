Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAD229FFDE
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 09:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgJ3I06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 04:26:58 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51716 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3I06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 04:26:58 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6B78A1C0B82; Fri, 30 Oct 2020 09:26:54 +0100 (CET)
Date:   Fri, 30 Oct 2020 09:26:54 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.19.153
Message-ID: <20201030082653.GA29475@amd>
References: <160396822019115@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <160396822019115@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I'm announcing the release of the 4.19.153 kernel.
>=20
> All users of the 4.19 kernel series must upgrade.
>=20
> The updated 4.19.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git li=
nux-4.19.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=
=3Dsummary

Did something go seriously wrong here?

The original 4.19.153-rc1 series had 264 patches. "powerpc/tau: Remove
duplicated set_thresholds() call" is 146/264 of the series, but it is
last one in 4.19.153 as released. "178/264 ext4: limit entries
returned when counting...", for example, is not present in
4.19.153... as are others, for example "net: korina: cast KSEG0
address to pointer in kfree". Looks like 118 or so patches are
missing.

They are not in origin/queue/4.19, either.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+bzk0ACgkQMOfwapXb+vKxngCfWG0eOBqy6pZVRIubXq0ghR9n
D64AoLDH6iYLON9nsNftfOrUMXwAOCpP
=7NnE
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
