Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDBD3D8B6F
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 12:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbhG1KKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 06:10:44 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54412 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhG1KKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 06:10:43 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2D6A51C0B80; Wed, 28 Jul 2021 12:10:41 +0200 (CEST)
Date:   Wed, 28 Jul 2021 12:10:40 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Carsten Schmid <carsten_schmid@mentor.com>
Subject: Re: [PATCH 5.10 167/167] xhci: add xhci_get_virt_ep() helper
Message-ID: <20210728101040.GA30574@amd>
References: <20210726153839.371771838@linuxfoundation.org>
 <20210726153845.014643770@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20210726153845.014643770@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Mathias Nyman <mathias.nyman@linux.intel.com>
>=20
> [commit b1adc42d440df3233255e313a45ab7e9b2b74096 upstream]

This is yet another variation in upstream commit making. So far I was
using these:

                ma =3D re.match(".*Upstream commit ([0-9a-f]*) .*", l)
                if ma:
                    m.upstream =3D ma.group(1)
                ma =3D re.match("[Cc]ommit ([0-9a-f]*) upstream[.]*", l)
		if ma:
                    m.upstream =3D ma.group(1)
                ma =3D re.match("[Cc]ommit: ([0-9a-f]*)", l)
                if ma:
                    m.upstream =3D ma.group(1)

I guess I could update second regexp to search anywhere in the
line.... but at that point it will also match stuff like "commit 1234
upstream is broken".

Do you have suggestion how to extract upstream sha1 automatically?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEBLSAACgkQMOfwapXb+vK5WACfTzpv0y+TCFXMmiTC9Ywa+gPV
QvAAoK2TNSoCeVKZmh5qMfPjTZ6ZXhM+
=IuzX
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
