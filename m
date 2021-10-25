Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201F743A60C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 23:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhJYVnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 17:43:23 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52780 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhJYVnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 17:43:23 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 74DC41C0B76; Mon, 25 Oct 2021 23:40:59 +0200 (CEST)
Date:   Mon, 25 Oct 2021 23:40:59 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Brendan Higgins <brendanhiggins@google.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        David Gow <davidgow@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 70/95] gcc-plugins/structleak: add makefile var for
 disabling structleak
Message-ID: <20211025214059.GB2807@duo.ucw.cz>
References: <20211025190956.374447057@linuxfoundation.org>
 <20211025191007.069144838@linuxfoundation.org>
 <20211025205652.GA2807@duo.ucw.cz>
 <CAFd5g47z64vhphWC4Arne4AsxH9roNMuGdfT193wUtrDGAgOsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <CAFd5g47z64vhphWC4Arne4AsxH9roNMuGdfT193wUtrDGAgOsg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > [ Upstream commit 554afc3b9797511e3245864e32aebeb6abbab1e3 ]
> > >
> > > KUnit and structleak don't play nice, so add a makefile variable for
> > > enabling structleak when it complains.
> >
> > AFAICT, this patch does nothing useful in 5.10. Unlike mainline,
> > DISABLE_STRUCTLEAK_PLUGIN is not used elsewhere in the tree.
>=20
> The related patches that Greg picked up use this makefile variable.

I don't think so, not in 5.10. Can you double-check?

pavel@duo:~/cip/krc$ grep -ri DISABLE_STRUCTLEAK_PLUGIN .
=2E/scripts/Makefile.gcc-plugins:    DISABLE_STRUCTLEAK_PLUGIN +=3D -fplugi=
n-arg-structleak_plugin-disable
=2E/scripts/Makefile.gcc-plugins:export DISABLE_STRUCTLEAK_PLUGIN
pavel@duo:~/cip/krc$=20
commit b67ee9a213819f2c817e3d344c2fc186f299a4f5 (HEAD, origin/queue/5.10)
Author: Fabien Dessenne <fabien.dessenne@foss.st.com>
Date:   Fri Oct 8 14:25:17 2021 +0200

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYXckawAKCRAw5/Bqldv6
8um8AKCs1ibQ5SnbwnMPWO1Nk/B0LuOQTQCdFP4LBiCpI0qUIPAzC4Kg0axyzq4=
=wpZ/
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
