Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF21F27ED7B
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 17:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgI3Pjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 11:39:31 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:42944 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgI3Pjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 11:39:31 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 725781C0B85; Wed, 30 Sep 2020 17:39:28 +0200 (CEST)
Date:   Wed, 30 Sep 2020 17:39:28 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 054/245] scsi: ufs: Make ufshcd_add_command_trace()
 easier to read
Message-ID: <20200930153928.GA23434@duo.ucw.cz>
References: <20200929105946.978650816@linuxfoundation.org>
 <20200929105949.626022505@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20200929105949.626022505@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Bart Van Assche <bvanassche@acm.org>
>=20
> [ Upstream commit e4d2add7fd5bc64ee3e388eabe6b9e081cb42e11 ]
>=20
> Since the lrbp->cmd expression occurs multiple times, introduce a new loc=
al
> variable to hold that pointer. This patch does not change any
> functionality.

This is just a cleanup, AFAICT, and there's no patch that depends on
it in 4.19-stable.

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX3SmsAAKCRAw5/Bqldv6
8qCrAKCgg6qcOq+U36dmG2qgzlxBoqX4MwCeJheWUZGQqca79qQCwrjao7XlgOA=
=frXz
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
