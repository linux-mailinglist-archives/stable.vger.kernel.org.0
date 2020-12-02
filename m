Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0942CC1CE
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 17:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgLBQLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 11:11:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726507AbgLBQLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 11:11:52 -0500
Date:   Wed, 2 Dec 2020 16:10:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606925471;
        bh=iiw4glKOQmWvuXrQGj5XNi+C/XY01JmyZqq9tpI3rso=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=HG9t8eIiCm6slvBOFMgReftNDzup7woiTT1XF3kneatybn/K9c1gzye6pIewH5X28
         hUCRR0ZoOZjBO0wLt0akfXoR2tpVRD2ojUOV/WpS68wU17bAsJClUSlz8v6po+a26A
         A5xY0A+RwlwctUdwJZUaolCr705HpDPICsnXgCAs=
From:   Mark Brown <broonie@kernel.org>
To:     dinghua ma <dinghua.ma.sz@gmail.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] regulatx DLDO2 voltage control register mask for
 AXP22x
Message-ID: <20201202161042.GI5560@sirena.org.uk>
References: <20201130234520.13255-1-dinghua.ma.sz@gmail.com>
 <CA+Jj2f8ADtb8JPPPzafvgVM0jssk8fz_BS-3LDUaYjZHcouTJQ@mail.gmail.com>
 <20201201150036.GH5239@sirena.org.uk>
 <CA+Jj2f9=oCxdnaHJTtPXwvwokRX9HRMDYUNrbDASmV+FoTefvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Op27XXJsWz80g3oF"
Content-Disposition: inline
In-Reply-To: <CA+Jj2f9=oCxdnaHJTtPXwvwokRX9HRMDYUNrbDASmV+FoTefvQ@mail.gmail.com>
X-Cookie: Sauron is alive in Argentina!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Op27XXJsWz80g3oF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 03, 2020 at 12:04:05AM +0800, dinghua ma wrote:
> I sent a new email. I don=E2=80=99t know if you received it. The subject =
is "[PATCH
> v3] regulator: axp20x: Fix DLDO2 voltage control register mask for AXP22x"

No, no sign.  You can check if things are at least hitting the list at:

    https://lore.kernel.org/lkml/

--Op27XXJsWz80g3oF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/HvIEACgkQJNaLcl1U
h9ALWAgAhpureonVY9iNgGFHwod6SmK1/fQvRYXAU6l1MRdfQCtYF9rQ6misHRxU
/euMiTGNOZ+wMUfwfZpvb1usjw+ZPtIJtlIPVQqY5YanB43Jmh3t3GwuQAaQuHV9
IaTG2kz/11qhKZjoQu+mWMTncCHAcV88+x9Xh6n0XSQZ1O8OaGz2eLwuIQOkYqZT
qzXTSoOennCJ/Apjr/HyCZzcTM7FvZxuIhn6zYBdboo5yEpqfDXdrV954eb2QxE1
vjjqbCWLUMdz427TtcJX6wo09Egasl+hbggeCWPE7WEAl4LpYY9jAkPCbtaAaD0O
m/p5+57BaGhOCafhTfRYGsPcAvYjtQ==
=uqdd
-----END PGP SIGNATURE-----

--Op27XXJsWz80g3oF--
