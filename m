Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E2F4A5C86
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 13:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbiBAMqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 07:46:01 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:36184 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238157AbiBAMqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 07:46:01 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D87651C0B81; Tue,  1 Feb 2022 13:45:59 +0100 (CET)
Date:   Tue, 1 Feb 2022 13:45:59 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.10 000/100] 5.10.96-rc1 review
Message-ID: <20220201124559.GB549@duo.ucw.cz>
References: <20220131105220.424085452@linuxfoundation.org>
 <20220201120557.GA549@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <20220201120557.GA549@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 5.10.96 release.
> > There are 100 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.=
96-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-5.10.y
> > and the diffstat can be found below.
>=20
> It seems we have boot problem on x86 qemu:
>=20
> https://lava.ciplatform.org/scheduler/job/616782
>=20
>=20
> [    0.183194] APIC: Switch to symmetric I/O mode setup
> [    0.187399] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=
=3D-1
> [    0.200659] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [    0.200984] ...trying to set up timer (IRQ0) through the 8259A ...
> [    0.201309] ..... (found apic 0 pin 2) ...
> [    0.214131] ....... failed.
> [    0.214303] ...trying to set up timer as Virtual Wire IRQ...
> [    0.227212] ..... failed.
> [    0.227390] ...trying to set up timer as ExtINT IRQ...
> [    1.287247] ..... failed :(.
> [    1.287584] Kernel panic - not syncing: IO-APIC + timer doesn't work! =
 Boot with apic=3Ddebug and send a report.  Then try booting with the 'noap=
ic' option.
> [    1.288043] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.96-rc1+ #1
> [    1.288231] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.12.0-1 04/01/2014
> [    1.288582] Call Trace:
>=20
> Other than that we have only the usual gmp.h failures.
>=20
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines=
/459895032
>=20
> I'll re-trigger the x86 qemu test, but it looks like real problem to me.

Huh. It suceeded this time.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/203900=
3632

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYfkrhwAKCRAw5/Bqldv6
8rI7AJ4txjW8RTdvDEsWc4GFAZgOHr7INACdHPp4OnuptDvnTqgBRWQvOapgtgk=
=bMFq
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
