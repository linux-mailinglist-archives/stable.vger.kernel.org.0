Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C2320FE81
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 23:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgF3VJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 17:09:25 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50570 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgF3VJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 17:09:24 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 008FA1C0C0A; Tue, 30 Jun 2020 23:09:21 +0200 (CEST)
Date:   Tue, 30 Jun 2020 23:09:21 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 4.19 011/131] btrfs: make caching_thread use
 btrfs_find_next_key
Message-ID: <20200630210921.GA2728@duo.ucw.cz>
References: <20200629153502.2494656-1-sashal@kernel.org>
 <20200629153502.2494656-12-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20200629153502.2494656-12-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2020-06-29 11:33:02, Sasha Levin wrote:
> From: Josef Bacik <josef@toxicpanda.com>
>=20
> [ Upstream commit 6a9fb468f1152d6254f49fee6ac28c3cfa3367e5 ]
>=20
> extent-tree.c has a find_next_key that just walks up the path to find
> the next key, but it is used for both the caching stuff and the snapshot
> delete stuff.  The snapshot deletion stuff is special so it can't really
> use btrfs_find_next_key, but the caching thread stuff can.  We just need
> to fix btrfs_find_next_key to deal with ->skip_locking and then it works
> exactly the same as the private find_next_key helper.
>=20
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

According to changelog, this is not known to fix a bug. Why is it
needed in stable?

Best regards,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXvuqAQAKCRAw5/Bqldv6
8vAxAKDDeBPcwQCmEBCxgg7n9Vy/A5WwDACfR1MHhWupwkJTa9noYLO+HVUQo00=
=vZ97
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
