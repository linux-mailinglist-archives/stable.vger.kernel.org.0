Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926E029E14F
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 03:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgJ1V4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:56:03 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51272 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgJ1Vv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:51:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DE5EA1C0BA8; Wed, 28 Oct 2020 08:43:10 +0100 (CET)
Date:   Wed, 28 Oct 2020 08:43:10 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Rohit Kumar <rohitkr@codeaurora.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 072/264] ASoC: qcom: lpass-platform: fix memory leak
Message-ID: <20201028074310.GA9902@amd>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201027135434.080956764@linuxfoundation.org>
 <20201028070207.GB8084@amd>
 <917df715-be29-8b99-8058-6ef4e4254483@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <917df715-be29-8b99-8058-6ef4e4254483@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2020-10-28 13:04:02, Rohit Kumar wrote:
> Thanks Pavel for the review.
>=20
> On 10/28/2020 12:32 PM, Pavel Machek wrote:
> >Hi!
> >
> >>From: Rohit kumar <rohitkr@codeaurora.org>
> >>
> >>[ Upstream commit 5fd188215d4eb52703600d8986b22311099a5940 ]
> >>
> >>lpass_pcm_data is never freed. Free it in close
> >>ops to avoid memory leak.
> >AFAICT this introduces memory leaks in the error paths.
> Yes, I will post the fix soon. Thanks for review.

Well, the email had a fix attached :-). Feel free to review it and use
it...

Best regards,

								Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+ZIQ4ACgkQMOfwapXb+vKxrACfad7S6Olm4jEHF+1ya+cUStyc
mjcAnir4CMpopDrwvcmUt/Mhx/EDT1a8
=OWf9
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
