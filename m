Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82F33921E8
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 23:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhEZVYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 17:24:21 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46912 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbhEZVYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 17:24:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B163C1C0B80; Wed, 26 May 2021 23:22:47 +0200 (CEST)
Date:   Wed, 26 May 2021 23:22:47 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfgang =?iso-8859-1?Q?M=FCller?= <wolf@oriole.systems>,
        Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 261/289] Revert "iommu/vt-d: Remove WO permissions
 on second-level paging entries"
Message-ID: <20210526212247.GA4463@duo.ucw.cz>
References: <20210517140305.140529752@linuxfoundation.org>
 <20210517140313.931565813@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20210517140313.931565813@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2021-05-17 16:03:06, Greg Kroah-Hartman wrote:
> This reverts commit c848416cc05afc1589edba04fe00b85c2f797ee3 which is
> eea53c5816889ee8b64544fa2e9311a81184ff9c upstream.

Please don't do this.

You are "creative" with marking upstream commits, which breaks
scripting, again. How=20

> Another iommu patch was backported incorrectly, causing problems, so
> drop this as well for the moment.
>=20
> Reported-by: Wolfgang M=FCller <wolf@oriole.systems>
> Cc: Ashok Raj <ashok.raj@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Simply put it into the sign-off area, where it belongs. People will
happily update the scripts as it will be the last breakage.

Thanks,

								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYK68JwAKCRAw5/Bqldv6
8jFFAJ4xfnEnON47C//aLVltIbKk3BXdDQCgrNaLyaJ8LPaD3vknvL7FQ5K2few=
=JJ5Q
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
