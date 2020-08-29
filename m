Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF017256764
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 14:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgH2MLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 08:11:31 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55388 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgH2ML1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Aug 2020 08:11:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 56B501C0B82; Sat, 29 Aug 2020 14:11:24 +0200 (CEST)
Date:   Sat, 29 Aug 2020 14:11:23 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 34/38] btrfs: file: reserve qgroup space
 after the hole punch range is locked
Message-ID: <20200829121123.GB20944@duo.ucw.cz>
References: <20200821161807.348600-1-sashal@kernel.org>
 <20200821161807.348600-34-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <20200821161807.348600-34-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit a7f8b1c2ac21bf081b41264c9cfd6260dffa6246 ]
>=20
> The incoming qgroup reserved space timing will move the data reservation
> to ordered extent completely.
>=20
> However in btrfs_punch_hole_lock_range() will call
> btrfs_invalidate_page(), which will clear QGROUP_RESERVED bit for the
> range.
>=20
> In current stage it's OK, but if we're making ordered extents handle the
> reserved space, then btrfs_punch_hole_lock_range() can clear the
> QGROUP_RESERVED bit before we submit ordered extent, leading to qgroup
> reserved space leakage.
>=20
> So here change the timing to make reserve data space after
> btrfs_punch_hole_lock_range().
> The new timing is fine for either current code or the new code.

I'm not sure why this is queued for -stable. It is preparation for
future work, and that work is not queued for -stable.

Best regards,
							Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX0pF6wAKCRAw5/Bqldv6
8gWFAJwMY2fXbYqjDPGxslXicjB1hyFf/QCfTQMnBCPMjdI1Q5ow9sOchhLKP7g=
=IhAi
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
