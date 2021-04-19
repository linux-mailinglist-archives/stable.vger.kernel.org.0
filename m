Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1173C364D18
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 23:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhDSVdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 17:33:19 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46742 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhDSVdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 17:33:19 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 50F6F1C0B7F; Mon, 19 Apr 2021 23:32:48 +0200 (CEST)
Date:   Mon, 19 Apr 2021 23:32:47 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 043/103] net: tipc: Fix spelling errors in net/tipc
 module
Message-ID: <20210419213247.GC6626@amd>
References: <20210419130527.791982064@linuxfoundation.org>
 <20210419130529.293126321@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Content-Disposition: inline
In-Reply-To: <20210419130529.293126321@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit a79ace4b312953c5835fafb12adc3cb6878b26bd ]
>=20
> These patches fix a series of spelling errors in net/tipc module.

This should not be in -stable, it just cleans up comments.

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmB99v8ACgkQMOfwapXb+vLhigCfehRb2TgimcBJhPUzVVdquu/a
Qr8AoK2HMMVh3FcxW01/3a5NbjnXbEAT
=bZSt
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
