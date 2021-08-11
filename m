Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D59C3E8A98
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 08:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhHKGyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 02:54:55 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:36366 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbhHKGyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 02:54:55 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 485ED1C0B76; Wed, 11 Aug 2021 08:54:31 +0200 (CEST)
Date:   Wed, 11 Aug 2021 08:54:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 003/135] bus: ti-sysc: Fix gpt12 system timer issue
 with reserved status
Message-ID: <20210811065430.GA1270@duo.ucw.cz>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810172955.789238213@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20210810172955.789238213@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Jarkko Nikula <jarkko.nikula@bitmer.com> reported that Beagleboard
> revision c2 stopped booting. Jarkko bisected the issue down to
> commit 6cfcd5563b4f ("clocksource/drivers/timer-ti-dm: Fix suspend
> and resume for am3 and am4").
>=20
> Let's fix the issue by tagging system timers as reserved rather than
> ignoring them. And let's not probe any interconnect target module child
> devices for reserved modules.
>=20
> This allows PM runtime to keep track of clocks and clockdomains for
> the interconnect target module, and prevent the system timer from idling
> as we already have SYSC_QUIRK_NO_IDLE and SYSC_QUIRK_NO_IDLE_ON_INIT
> flags set for system timers.

There was interaction between two patches, and result is that this one
does not do anything useful, see:

https://lore.kernel.org/linux-omap/20210811061053.32081-1-tony@atomide.com/=
T/#u

I believe it should be dropped for now.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRN0JgAKCRAw5/Bqldv6
8rq2AJ4xIqJhNRjne/PYgKDBJU5rnYaFcgCeOLpv0+81eA+pnvTqEEr6OfCymJ0=
=6rZQ
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
