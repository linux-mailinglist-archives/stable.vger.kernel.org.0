Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79EC133C6F
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 08:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgAHHsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 02:48:37 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39338 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgAHHsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 02:48:37 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 91DE41C25B8; Wed,  8 Jan 2020 08:48:35 +0100 (CET)
Date:   Wed, 8 Jan 2020 08:48:34 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 023/115] drm/nouveau: Move the declaration of struct
 nouveau_conn_atom up a bit
Message-ID: <20200108074834.GB619@amd>
References: <20200107205240.283674026@linuxfoundation.org>
 <20200107205255.976508438@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <20200107205255.976508438@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-01-07 21:53:53, Greg Kroah-Hartman wrote:
> From: Hans de Goede <hdegoede@redhat.com>
>=20
> [ Upstream commit 37a68eab4cd92b507c9e8afd760fdc18e4fecac6 ]
>=20
> Place the declaration of struct nouveau_conn_atom above that of
> struct nouveau_connector. This commit makes no changes to the moved
> block what so ever, it just moves it up a bit.
>=20
> This is a preparation patch to fix some issues with connector handling
> on pre nv50 displays (which do not use atomic modesetting).

As followup changes are not queued in v4.19-stable, should this be dropped?

   	    	    	    	      	     	    	    Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4ViVIACgkQMOfwapXb+vJI3QCgjU0CpkYT6r1fshAZMIkVHhZY
M3gAnj2/GcnHewOftSaC0ajt6tGLAIWS
=J427
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
