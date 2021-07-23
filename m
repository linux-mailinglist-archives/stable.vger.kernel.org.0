Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146C93D4149
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 22:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhGWT1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 15:27:00 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38700 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWT1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 15:27:00 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8C5B81C0B88; Fri, 23 Jul 2021 22:07:32 +0200 (CEST)
Date:   Fri, 23 Jul 2021 22:07:32 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 038/125] arm64: dts: qcom: msm8996: Make CPUCC
 actually probe (and work)
Message-ID: <20210723200732.GB22684@duo.ucw.cz>
References: <20210722155624.672583740@linuxfoundation.org>
 <20210722155625.957020845@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
In-Reply-To: <20210722155625.957020845@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
> Fix the compatible to make the driver probe and tell the
> driver where to look for the "xo" clock to make sure everything
> works.
>=20
> Then we get a happy (eh, happier) 8996:
>=20
> somainline-sdcard:/home/konrad# cat /sys/kernel/debug/clk/pwrcl_pll/clk_r=
ate
> 1152000000
>=20
> Don't backport without "arm64: dts: qcom: msm8996: Add CPU opps", as
> the system fails to boot without consumers for these clocks.

Changelog says this has dependency on
b502efda6480d7577f9f822fd450d6bc3a4ac2e6.

But that one is not in 5.10 AFAICT.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYPshhAAKCRAw5/Bqldv6
8t0PAKCT+PjYYZCu00w1hDwz9fqjs5d0vgCcCWTr5cv8IqC8QtuOLMHTZ0LBF7U=
=4Pqm
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
