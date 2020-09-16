Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7013426BE14
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgIPHeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:34:31 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33628 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPHe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 03:34:29 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A79D81C0B80; Wed, 16 Sep 2020 09:34:27 +0200 (CEST)
Date:   Wed, 16 Sep 2020 09:34:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 28/78] nvme: have nvme_wait_freeze_timeout return if
 it timed out
Message-ID: <20200916073427.GB32537@duo.ucw.cz>
References: <20200915140633.552502750@linuxfoundation.org>
 <20200915140634.986905823@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <20200915140634.986905823@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 7cf0d7c0f3c3b0203aaf81c1bc884924d8fdb9bd ]
>=20
> Users can detect if the wait has completed or not and take appropriate
> actions based on this information (e.g. weather to continue
> initialization or rather fail and schedule another initialization
> attempt).

This does not fix any bug and is not needed in 4.19-stable. In the
5.8-stable there are other patches that depend on that (which is
probably why it was merged), but those are not present in 4.19.

Please drop.

Best regards,
								Pavel

> -void nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout);
> +int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout);

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2HAAwAKCRAw5/Bqldv6
8mHoAJ9kYbdv6h0mPccF2Jh3Z4JMmxUeLQCeI8r7m93bpV14khckbvVsO9BKOhw=
=19tg
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
