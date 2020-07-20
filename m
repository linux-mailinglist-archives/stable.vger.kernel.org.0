Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD992268C9
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388686AbgGTQUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:20:25 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57534 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387635AbgGTQUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 12:20:23 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: nicolas)
        with ESMTPSA id DDDD6291119
Message-ID: <1eafe9f8c0668daf6523827db09c9b0d4cbe000a.camel@collabora.com>
Subject: Re: [PATCH 1/2] media: coda: Fix reported H264 profile
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Beckett <bob.beckett@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org
Date:   Mon, 20 Jul 2020 12:20:17 -0400
In-Reply-To: <0e0bb486f4a95686b1385f978333a584a34db9b0.camel@pengutronix.de>
References: <20200717034923.219524-1-ezequiel@collabora.com>
         <51175cb496644aaa5d5004630925ead4c6f0ddc7.camel@pengutronix.de>
         <17189cd91b7412fdd102c2710d9e6aa8778aac23.camel@collabora.com>
         <0e0bb486f4a95686b1385f978333a584a34db9b0.camel@pengutronix.de>
Organization: Collabora
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-tXlWoDBPFQDUyLGcRdzi"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-tXlWoDBPFQDUyLGcRdzi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 20 juillet 2020 =C3=A0 10:40 +0200, Philipp Zabel a =C3=A9crit :
> On Fri, 2020-07-17 at 11:56 -0400, Nicolas Dufresne wrote:
> > Le vendredi 17 juillet 2020 =C3=A0 10:14 +0200, Philipp Zabel a =C3=A9c=
rit :
> > > On Fri, 2020-07-17 at 00:49 -0300, Ezequiel Garcia wrote:
> > > > From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > > >=20
> > > > The CODA960 manual states that ASO/FMO features of baseline are not
> > > > supported, so for this reason this driver should only report
> > > > constrained baseline support.
> > >=20
> > > I know the encoder doesn't support this, but is this also true of the
> > > decoder? The i.MX6DQ Reference Manual explicitly lists H.264/AVC deco=
der
> > > support for both baseline profile and constrained base line profile.
> >=20
> > Hmm, double checking, you are right this is documented in the encoding =
tools
> > sections, not the decoding. But there is extra buffers that need to be =
passed
> > for ASO/FMO to work, I greatly doubt you have ever tested it.
>=20
> And you are correct, I don't think I use any test streams that have
> ASO/FMO enabled.
>=20
> > This is not supported by GStreamer parser, or FFMPEG parsers either.
> > Again, we need to make sure in V2 that encoding and decoding
> > capabilities are well seperated.
> >=20
> > As for advertising ASO/FMO, I can leave it there, but be aware I won't =
be
> > testing it. I can provide you links to streams if you care (they are pu=
blicly
> > accessible throught the ITU conformance streams published by the ITU).
>=20
> That would be welcome.

https://www.itu.int/net/ITU-T/sigdb/spevideo/VideoForm-s.aspx?val=3D1020026=
41

Notably, if you download the AVCv1 series, there is at
least FM2_SVA_C.zip that uses FMO (slice groups). I haven't looked them
up, I barely started harnessing it for GStreamer.

You can find the link to everything else here, including HEVC.

https://www.itu.int/net/ITU-T/sigdb/spevideo/Hseries-s.htm

>=20
> > But as for GStreamer and FFMPEG, this is not supported anyway.
>=20
> Ok, how about changing the commit message to say that this is
> unsupported for the encoder and untested for the decoder because there
> is no userspace support?

Agreed.

>=20
> regards
> Philipp

--=-tXlWoDBPFQDUyLGcRdzi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXxXEQQAKCRBxUwItrAao
HMlKAKDdLaaH0pFzX9sFTZfWpmu70QFI5gCeJvd+wksn4WXWpeCgySiwKBu9WEg=
=CtU8
-----END PGP SIGNATURE-----

--=-tXlWoDBPFQDUyLGcRdzi--

