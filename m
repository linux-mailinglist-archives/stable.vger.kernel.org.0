Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBB7595B45
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiHPMHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiHPMGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:06:52 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F354CB275F;
        Tue, 16 Aug 2022 04:56:23 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1CAC31C0006; Tue, 16 Aug 2022 13:56:21 +0200 (CEST)
Date:   Tue, 16 Aug 2022 13:56:14 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Big load on lkml created by -stable patchbombs was Re: [PATCH 5.19
 0000/1157] 5.19.2-rc1 review
Message-ID: <20220816115614.GB27428@duo.ucw.cz>
References: <20220815180439.416659447@linuxfoundation.org>
 <YvruPKI4dCyrXCp5@home.goodmis.org>
 <YvsocKly+n9S4CsB@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <YvsocKly+n9S4CsB@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 5.19.2 release.
> > > There are 1157 patches in this series, all will be posted as a respon=
se
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > Hi Greg,
> >=20
> > Perhaps its time that you just send a single email to LKML pointing whe=
re to
> > find the stable releases. These patch bombs are bringing vger down to i=
ts
> > knees, and causing delays in people's workflows. This doesn't just affe=
ct
> > LKML, but all other vger mailing lists. Probably because LKML has the b=
iggest
> > subscriber base that patch bombs to it can slow everything else down.
> >=20
> > I sent 3 patches to the linux-trace-devel list almost 4 hours ago, and =
they
> > still haven't shown up. I was going to point people to it tonight but i=
t's now
> > going to have to wait till tomorrow.
>=20
> Email is async, sometimes it takes longer than others to recieve
> messages.

Well, email is pretty fast most of the month.

> My "patch bombs" get sent out slow to the mail servers, there is work to
> fix up vger and move it over to the LF-managed infrastructure, perhaps
> work with the vger admins to help that effort out?

I'm pretty used to -stable patches going to l-k, so I got used to
current workflow. OTOH ... -stable _is_ quite significant fraction of
total lkml traffic, and I see how people may hate that.

Is not it ultimately for vger admins to decide what kind of load they
consider acceptable?

Would it make sense to somehow batch the messages, or perhaps to
modify patchbombing scripts to send patches "slowly" so that -stable
does not DoS other lkml users?

Actually, if the patch is same between multiple -stable releases
(which is rather common case) sending it just once tagged with "this
goes to 4.9, 4.14, 4.19 and 5.10" would both take less bandwidth and
make review easier. (But I see it may not be that easy).

Best regards,
								Pavel
							=09
PS: ...who is currently on EDGE connection. LF-managed infrastructure
is not going to help for people who use slow links to access lkml.
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYvuF3gAKCRAw5/Bqldv6
8rVhAJ4+dAqoazRNbBm8GEweuZaPUCb6QgCeLqbpLUmN9Z24i17Q79OQbtCFaVQ=
=4pqH
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
