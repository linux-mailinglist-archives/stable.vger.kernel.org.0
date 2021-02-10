Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7393166A2
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 13:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhBJM2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 07:28:33 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59092 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhBJM0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 07:26:04 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4A4F71C0B8A; Wed, 10 Feb 2021 13:25:18 +0100 (CET)
Date:   Wed, 10 Feb 2021 13:25:17 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lyude Paul <lyude@redhat.com>,
        Ville Syrjala <ville.syrjala@intel.com>,
        dri-devel@lists.freedesktop.org, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 5.10 078/120] drm/dp/mst: Export
 drm_dp_get_vc_payload_bw()
Message-ID: <20210210122517.GA27201@duo.ucw.cz>
References: <20210208145818.395353822@linuxfoundation.org>
 <20210208145821.517331268@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20210208145821.517331268@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 83404d581471775f37f85e5261ec0d09407d8bed upstream.
>=20
> This function will be needed by the next patch where the driver
> calculates the BW based on driver specific parameters, so export it.
>=20
> At the same time sanitize the function params, passing the more natural
> link rate instead of the encoding of the same rate.

> Cc: <stable@vger.kernel.org>

This adds exports, but there's no user of the export, neither in
5.10-stable nor in linux-next. What is the plan here?

Best regards,
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYCPQrQAKCRAw5/Bqldv6
8rqLAKCcXIbkWVbYEBX6KypH71nsV8KmYQCcDkLDxCN+NRflSbyE7HBMXW4HJ14=
=lDwN
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
