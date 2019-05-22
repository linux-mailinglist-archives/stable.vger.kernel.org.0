Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCCA2603C
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 11:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfEVJPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 05:15:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42583 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfEVJPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 05:15:12 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 9DB6280327; Wed, 22 May 2019 11:15:00 +0200 (CEST)
Date:   Wed, 22 May 2019 11:15:07 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jeremy Soller <jeremy@system76.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 038/105] ALSA: hdea/realtek - Headset fixup for
 System76 Gazelle (gaze14)
Message-ID: <20190522091506.GC8174@amd>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520115249.657128023@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
In-Reply-To: <20190520115249.657128023@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2019-05-20 14:13:44, Greg Kroah-Hartman wrote:
> From: Jeremy Soller <jeremy@system76.com>
>=20
> commit 80a5052db75131423b67f38b21958555d7d970e4 upstream.
>=20
> On the System76 Gazelle (gaze14), there is a headset microphone input
> attached to 0x1a that does not have a jack detect. In order to get it
> working, the pin configuration needs to be set correctly, and the
> ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC fixup needs to be applied. This is
> identical to the patch already applied for the System76 Darter Pro
> (darp5).

Commit 89/ of the series fixes up this patch. Perhaps those two should
be merged together?
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzlExoACgkQMOfwapXb+vJoqgCgwH7VatwMJRBt6nNnFxtHEZsd
7FsAnA8xeloJQi/y3hmZV1qwZDAd1njM
=ZI6y
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
